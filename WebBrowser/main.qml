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

    menuBar: ToolBar {
            id: toolBar
            anchors.fill: parent.header
            spacing: 0
            ToolButton {
                id: backButton
                onClicked: layout.children[layout.currentIndex].goBack()
                text: qsTr("<")
                anchors.left: parent.left
            }
            ToolButton {
                id: forwardButton
                onClicked: layout.children[layout.currentIndex].goForward()
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
                //text: layout.children[layout.currentIndex].url
                text: layout.children[layout.currentIndex].url
                onAccepted: layout.children[layout.currentIndex].url = this.text
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
//    header: Item {
//        id: test

//        id: rowLayout

//        Button {
//            id: newTab

//            height: tabBar.height
//            width: 10
//            text: "+"
//            anchors{
//                right: parent.right
//                left: tabBar.right
//            }
//            onClicked: {
//                var newView = tabBar.addNewTab()
//                newView.url = "https://www.rutilea.com"
//                //browserWindow.title = Qt.binding(function(){return layout.children[layout.currnetIndex].title})
//                browserWindow.title = Qt.binding(function(){return newView.title})
//            }
//        }
        TabBar {
            id: tabBar
            anchors {
                left: parent.left
//                right: newTab.left
                right: parent.right
            }

//            TabButton {
//                text: webView.title
//            }
//            TabButton {
//                text: "+"
//                anchors.right: parent.right
//                //TabBar.index: parent.count - 1
//                onClicked: {
//                    var newView = tabBar.addNewTab()
//                    newView.url = "https://www.rutilea.com"
//                    //parent.currentIndex += 1
//                    parent.currentIndex = parent.count
//                }
//            }


            function addNewTab() {
                //var newViewComponent = Qt.createComponent(browserComponent)
                //if(newViewComponent.status === Component.Ready)
                var newView = browserComponent.createObject(layout)
                //newView.url =
                //newView.webView.url = url
                var tabButton = tabButtonComponent.createObject(this)
                tabButton.text = Qt.binding(function(){return newView.title})
                return newView
            }

            Component.onCompleted: {
                var newView = addNewTab()
                newView.url = "https://www.rutilea.com"
                //browserWindow.title = Qt.binding(function(){return layout.children[layout.currnetIndex].title})
                browserWindow.title = Qt.binding(function(){return newView.title})
                //tabBar.incrementCurrentIndex()
            }
        }
//    }


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
                //anchors.fill: parent
                url: "https://www.rutilea.com"
                onNewViewRequested: function(request){
                    if(request.destination === WebEngineView.NewViewInTab) {
                        var webView = tabBar.addNewTab()
                        request.openIn(webView)
                        //tabBar.currentIndex += 1
                        tabBar.incrementCurrentIndex()
                    }
                }
            }
        }
        Component {
            id: tabButtonComponent
            TabButton{
                id:tabButton
                //text: Qt.binding(function(){return layout.visibleChildren[0].title})
                contentItem:Item {
                    Text {
                        id: tabButtonText
                        elide: Text.ElideRight
                        anchors{
                            left: parent.left
                            right: closeButton.left
                        }
                        text:  tabButton.text
                    }
                    Button {
                        id:closeButton
                        implicitHeight: parent.height
                        implicitWidth: this.height
                        anchors.right: parent.right
                        text: "x"
                        onClicked: tabBar.removeItem(tabButton)
                    }
                }


            }
        }
    }



}
