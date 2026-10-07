import { definePluginSettings } from "@api/Settings";
import { OptionType } from "@utils/types";

import { formats } from "./codecs";

export const settings = definePluginSettings({
    defaultFormat: {
        description: "Default encoder format",
        type: OptionType.SELECT,
        options: formats.filter(f => f.value !== "auto").map(f => ({ ...f, default: f.value === "ee" }))
    },
    autoEncode: {
        description: "Encode your message when you press Enter. Click the Ee!? chat bar button to toggle.",
        type: OptionType.BOOLEAN,
        default: true
    },
    autoDecode: {
        description: "Show the decoded text under incoming Ee!? messages",
        type: OptionType.BOOLEAN,
        default: true
    }
});
