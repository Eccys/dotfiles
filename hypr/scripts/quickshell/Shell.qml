//@ pragma UseQApplication
import QtQuick
import Quickshell

ShellRoot {
    id: root
    property var mainWidget: null

    Connections {
        target: Quickshell
        function onReloadCompleted() { Quickshell.inhibitReloadPopup() }
        function onReloadFailed(errorString) { Quickshell.inhibitReloadPopup() }
    }

    Main {}
    TopBar {}
    Floating {}
}

