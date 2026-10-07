import { Message } from "@vencord/discord-types";
import { Parser, useEffect, useState } from "@webpack/common";

import { decodeText, looksLikeEe } from "./codecs";
import { settings } from "./settings";

export interface DecodedValue {
    text: string;
}

const setters = new Map<string, (v: DecodedValue | undefined) => void>();
const revealed = new Map<string, DecodedValue>();
const dismissed = new Set<string>();

export function revealDecoded(messageId: string, data: DecodedValue) {
    dismissed.delete(messageId);
    revealed.set(messageId, data);
    setters.get(messageId)?.(data);
}

export function clearDecoded() {
    revealed.clear();
    dismissed.clear();
    setters.clear();
}

export function DecodedAccessory({ message }: { message: Message; }) {
    const { autoDecode } = settings.use(["autoDecode"]);
    const [decoded, setDecoded] = useState<DecodedValue | undefined>(() =>
        dismissed.has(message.id) ? undefined : revealed.get(message.id)
    );

    useEffect(() => {
        if ((message as any).vencordEmbeddedBy) return;

        setters.set(message.id, setDecoded);

        if (dismissed.has(message.id)) {
            setDecoded(undefined);
            return () => void setters.delete(message.id);
        }

        const existing = revealed.get(message.id);
        if (existing) {
            setDecoded(existing);
            return () => void setters.delete(message.id);
        }

        if (!autoDecode || !message.content || !looksLikeEe(message.content)) {
            setDecoded(undefined);
            return () => void setters.delete(message.id);
        }

        let cancelled = false;
        void decodeText(message.content, "ee")
            .then(text => {
                if (cancelled || dismissed.has(message.id)) return;
                revealDecoded(message.id, { text });
            })
            .catch(() => { /* Not a valid Ee!? payload; leave the message as-is. */ });

        return () => {
            cancelled = true;
            setters.delete(message.id);
        };
    }, [message.id, message.content, autoDecode]);

    if (!decoded) return null;

    return (
        <div className="ee-decoded" role="note">
            <div className="ee-decoded-meta">Decoded</div>
            <div className="ee-decoded-text">{Parser.parse(decoded.text)}</div>
            <button
                type="button"
                className="ee-decoded-dismiss"
                onClick={() => {
                    dismissed.add(message.id);
                    revealed.delete(message.id);
                    setDecoded(undefined);
                }}
            >
                Dismiss
            </button>
        </div>
    );
}
