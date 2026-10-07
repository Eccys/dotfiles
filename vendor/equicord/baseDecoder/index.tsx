/*
 * Vencord, a modification for Discord's desktop app
 * Copyright (c) 2022 Vendicated and contributors
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

import "./style.css";

import { ChatBarButton } from "@api/ChatButtons";
import { findGroupChildrenByChildId, NavContextMenuPatchCallback } from "@api/ContextMenu";
import { CodeBlock } from "@components/CodeBlock";
import { EquicordDevs } from "@utils/constants";
import { copyWithToast, insertTextIntoChatInputBox } from "@utils/discord";
import { classes } from "@utils/misc";
import definePlugin, { IconProps } from "@utils/types";
import { Message, RenderModalProps } from "@vencord/discord-types";
import { ChannelStore, Menu, Modal, openModal, showToast, useEffect, useRef, useState } from "@webpack/common";

import { clearDecoded, DecodedAccessory, revealDecoded } from "./accessory";
import { clearDecodeCache, decodeText, encodeText, Format, formats, looksLikeEe } from "./codecs";
import { settings } from "./settings";

const DISCORD_MESSAGE_LIMIT = 2000;

function DecodeIcon({ className, height = 20, width }: IconProps) {
    return (
        <span className={`ee-decode-label${className ? ` ${className}` : ""}`} style={{ height, width: width ?? "auto" }}>
            Decode
        </span>
    );
}
function EncodeIcon({ className }: IconProps = {}) {
    return <span className={className} style={{ fontSize: 14, fontWeight: 700 }}>Ee!?</span>;
}

async function decodeMessage(message: Message) {
    try {
        const text = await decodeText(message.content, "auto");
        revealDecoded(message.id, { text });
    } catch (e) {
        showToast(e instanceof Error ? e.message : "Could not decode this message.", "failure");
    }
}

function openEncodeModal() {
    openModal(props => <CodecModal {...props} />);
}

function toggleAutoEncode() {
    settings.store.autoEncode = !settings.store.autoEncode;
    showToast(
        settings.store.autoEncode ? "Auto-encode on — Enter will encode before send." : "Auto-encode off.",
        "success"
    );
}

const messageCtxPatch: NavContextMenuPatchCallback = (children, { message }: { message: Message; }) => {
    if (!message?.content?.trim()) return;
    const group = findGroupChildrenByChildId("copy-text", children) ?? findGroupChildrenByChildId("reply", children);
    if (!group) return;
    const after = Math.max(
        group.findIndex(c => c?.props?.id === "copy-text"),
        group.findIndex(c => c?.props?.id === "reply")
    );
    group.splice(after + 1, 0, (
        <Menu.MenuItem
            id="ee-decode"
            label="Decode"
            action={() => void decodeMessage(message)}
        />
    ));
};

function CodecModal({ initial = "", decode = false, ...props }: RenderModalProps & { initial?: string; decode?: boolean; }) {
    const [input, setInput] = useState(initial);
    const [format, setFormat] = useState<Format>(decode ? "auto" : settings.store.defaultFormat as Format);
    const [output, setOutput] = useState("");
    const [error, setError] = useState("");
    const [busy, setBusy] = useState(false);
    const sequence = useRef(0);
    const run = async (encoding: boolean, value = input, selected = format) => {
        const id = ++sequence.current;
        setBusy(true);
        setError("");
        setOutput("");
        try {
            const result = await (encoding ? encodeText(value, selected) : decodeText(value, selected));
            if (id === sequence.current) setOutput(result);
        } catch (e) {
            if (id === sequence.current) setError(e instanceof Error ? e.message : "Could not convert this text.");
        } finally {
            if (id === sequence.current) setBusy(false);
        }
    };
    useEffect(() => {
        if (decode && initial) void run(false, initial, "auto");
        return () => { sequence.current++; };
    }, []);
    const invalidate = () => {
        sequence.current++;
        setOutput("");
        setError("");
        setBusy(false);
    };
    return (
        <Modal {...props} size="lg" title={decode ? "Decode message" : "Text encoder / decoder"}>
            <div className="ee-codec">
                <label>Format
                    <select value={format} onChange={e => { invalidate(); setFormat(e.target.value as Format); }}>
                        {formats.map(f => <option key={f.value} value={f.value}>{f.label}</option>)}
                    </select>
                </label>
                <label>Input
                    <textarea value={input} spellCheck={false} onChange={e => { invalidate(); setInput(e.target.value); }} />
                </label>
                <div className="ee-codec-actions">
                    <button disabled={busy || !input} onClick={() => void run(true)}>Encode</button>
                    <button disabled={busy || !input} onClick={() => void run(false)}>Decode</button>
                    {busy && <span role="status">Working…</span>}
                </div>
                {error && <p role="alert">{error}</p>}
                {output !== "" && <>
                    <CodeBlock content={output} lang="" />
                    <div className="ee-codec-actions">
                        <button onClick={() => copyWithToast(output)}>Copy result</button>
                        <button onClick={() => { insertTextIntoChatInputBox(output); props.onClose(); }}>Insert into message</button>
                    </div>
                </>}
                <small>Runs locally. Insert puts the result in your draft. Ee!? uses the public key from deadlyblock.com/e/. Click the chat-bar Ee!? button to auto-encode on Enter.</small>
            </div>
        </Modal>
    );
}

export default definePlugin({
    name: "DecodeBase64",
    description: "Fast local encoder/decoder: Ee!?, Base64, Hex and URL encoding. Auto-encode on send, auto-decode under messages.",
    dependencies: ["MessagePopoverAPI", "ChatInputButtonAPI", "MessageAccessoriesAPI", "MessageEventsAPI"],
    tags: ["Chat", "Utility"],
    authors: [EquicordDevs.ThePirateStoner],
    settings,
    stop() {
        clearDecodeCache();
        clearDecoded();
    },
    encodeText,
    decodeText,
    contextMenus: {
        message: messageCtxPatch
    },
    renderMessageAccessory: props => <DecodedAccessory message={props.message} />,
    messagePopoverButton: {
        icon: DecodeIcon,
        render(message) {
            if (!message.content?.trim()) return null;
            return {
                label: "Decode",
                icon: DecodeIcon,
                message,
                channel: ChannelStore.getChannel(message.channel_id),
                onClick: () => void decodeMessage(message)
            };
        }
    },
    chatBarButton: {
        icon: EncodeIcon,
        render({ isAnyChat }) {
            const { autoEncode } = settings.use(["autoEncode"]);
            if (!isAnyChat) return null;
            return (
                <ChatBarButton
                    tooltip={autoEncode
                        ? "Auto-encode on — Enter encodes before send (right-click for encoder)"
                        : "Auto-encode off — click to encode on Enter (right-click for encoder)"}
                    onClick={e => {
                        if (e.shiftKey) {
                            e.preventDefault();
                            openEncodeModal();
                            return;
                        }
                        toggleAutoEncode();
                    }}
                    onContextMenu={e => {
                        e.preventDefault();
                        openEncodeModal();
                    }}
                >
                    <EncodeIcon className={classes(autoEncode && "ee-auto-on")} />
                </ChatBarButton>
            );
        }
    },
    async onBeforeMessageSend(_, message) {
        if (!settings.store.autoEncode) return;
        const content = message.content?.trim();
        if (!content) return;
        if (content.startsWith("/")) return;
        if (looksLikeEe(content)) return;

        try {
            const encoded = await encodeText(content, settings.store.defaultFormat as Format);
            if (encoded.length > DISCORD_MESSAGE_LIMIT) {
                showToast(`Encoded message is ${encoded.length} characters; Discord's limit is ${DISCORD_MESSAGE_LIMIT}.`, "failure");
                return { cancel: true };
            }
            message.content = encoded;
        } catch (e) {
            showToast(e instanceof Error ? e.message : "Could not encode this message.", "failure");
            return { cancel: true };
        }
    }
});
