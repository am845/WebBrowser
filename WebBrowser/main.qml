import QtQuick 2.12
import QtWebEngine 1.8
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id:browserWindow
    //title: webView.title
    visible: true
    width: 1200
    height: 800

    header: ToolBar {
            anchors.fill: parent.header
            spacing: 0
            ToolButton {
                id: backButton
                onClicked: webView.goBack()
                text: qsTr("<")
                anchors.left: parent.left
            }
            ToolButton {
                id: forwardButton
                onClicked: webView.goForward()
                text: qsTr(">")
                anchors.left: backButton.right
            }
            ToolButton {
                id: reloadButton
                onClicked: webView.reload()
                text: qsTr("Reload")
                //icon.source: "icons/reload.png"
                //icon.height: backButton.layer.textureSize
                anchors.left: forwardButton.right
            }
            TextField {
                text: layout.visibleChildren[0].url
                onAccepted: layout.children[0].url = this.text
                //background: parent.background
                horizontalAlignment: TextInput.AlignHCenter
                maximumLength: 80
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                    left: reloadButton.right
                }

            }
    }
    TabBar {
        id: tabBar
        anchors.top: parent.top
        //TabButton {
        //    text: webView.title
        //}
        TabButton {
            text: "+"
            anchors.right: parent.right
        }


        function addNewTab() {
            //var newViewComponent = Qt.createComponent(browserComponent)
            //if(newViewComponent.status === Component.Ready)
            var newView = browserComponent.createObject(layout)
            //newView.url =
            //newView.webView.url = url
            var tabButton = tabButtonComponent.createObject(tabBar)
            return newView
        }

        Component.onCompleted: {
            var newView = addNewTab()
            newView.url = "https://www.rutilea.com"
            browserWindow.title = Qt.binding(function(){return layout.visibleChildren[0].title})
            currentIndex = count - 2
        }
    }
    StackLayout {
        id: layout
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: tabBar.bottom
        }
        currentIndex: tabBar.currentIndex
        Component {
            id: browserComponent
            WebEngineView {
                id: webView
                anchors.fill: parent
                url: "https://www.rutilea.com"
                onNewViewRequested: function(request){
                    if(request.destination === WebEngineView.NewViewInTab) {
                        var webView = tabBar.addNewTab()
                        request.openIn(webView)
                        tabBar.currentIndex += 1
                    }
                }
            }
        }
        Component {
            id: tabButtonComponent
            TabButton{
                text: Qt.binding(function(){return layout.visibleChildren[0].title})
            }
        }
    }



}
