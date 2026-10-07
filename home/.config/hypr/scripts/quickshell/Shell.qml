//@ pragma UseQApplication
import QtQuick
import Quickshell

ShellRoot {
    id: root
    property var mainWidget: null
    property bool isDesktop: false
    property bool isWifiOn: false
    property string ethStatus: "Disconnected"
    property bool showEthernet: false

    Connections {
        target: Quickshell
        function onReloadCompleted() { Quickshell.inhibitReloadPopup() }
        function onReloadFailed(errorString) { Quickshell.inhibitReloadPopup() }
    }

    Main {}
    TopBar {}
    Floating {}
}

