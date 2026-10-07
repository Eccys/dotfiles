// Cache interface restored from ilyamiro/imperative-dots for eccys widgets.
import QtQuick
import Quickshell

QtObject {
    readonly property string home: Quickshell.env("HOME")
    readonly property string xdgRuntimeDir: Quickshell.env("XDG_RUNTIME_DIR")
    readonly property string cacheDir: home + "/.cache/quickshell"
    readonly property string stateDir: home + "/.local/state/quickshell"
    readonly property string runDir: (xdgRuntimeDir || "/tmp") + "/quickshell"
    readonly property string logDir: runDir + "/logs"

    function directory(kind, base, widgetName) {
        const path = Quickshell.env("QS_" + kind + "_" + widgetName.toUpperCase())
            || (base + "/" + widgetName);
        Quickshell.execDetached(["mkdir", "-p", path]);
        return path;
    }
    function getCacheDir(widgetName) { return directory("CACHE", cacheDir, widgetName); }
    function getStateDir(widgetName) { return directory("STATE", stateDir, widgetName); }
    function getRunDir(widgetName) { return directory("RUN", runDir, widgetName); }
    function getLogDir(widgetName) { return directory("LOG", logDir, widgetName); }
}
