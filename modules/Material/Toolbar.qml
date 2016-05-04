/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014-2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.4
import QtQuick.Controls 1.3 as Controls
import QtQuick.Layouts 1.1
import Material 0.2


/*!
   \qmltype Toolbar
   \inqmlmodule Material

   \brief Provides the container used to hold the action bar of pages.
*/
View {
    id: toolbar

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
    }

    property int actionBarHeight: {
        if (!page || page.actionBar.hidden)
            return 0

        var height = implicitHeight + page.actionBar.extendedHeight

        if (page.rightSidebar && page.rightSidebar.showing) {
            var sidebarHeight = implicitHeight + page.rightSidebar.actionBar.extendedHeight

            height = Math.max(height, sidebarHeight)
        }

        return height
    }
    property int targetHeight: actionBarHeight
    property int maxActionCount: Device.type === Device.desktop
                                 ? 5 : Device.type === Device.tablet ? 4 : 3
    property bool clientSideDecorations: false
    property string color: "white"
    property var page
    property bool showBackButton

    property color decorationColor: page && page.actionBar
            ? page.actionBar.decorationColor
            : Theme.primaryDarkColor

    opacity: page && page.actionBar.hidden ? 0 : 1

    backgroundColor: page ? page.actionBar.backgroundColor.a === 0
                            ? page.backgroundColor : page.actionBar.backgroundColor
                          : Theme.primaryColor

    implicitHeight: Units.gu(1)
    height: targetHeight
    elevation: backgroundColor === page.color ? 0 : page.actionBar.elevation
    fullWidth: true
    clipContent: true

    function pop(page) {
        stack.pop(page.actionBar)

        if (page.rightSidebar && page.rightSidebar.actionBar)
            rightSidebarStack.pop(page.rightSidebar.actionBar)
        else
            rightSidebarStack.pop(emptyRightSidebar)

        toolbar.page = page
    }

    function push(page) {
        stack.push(page.actionBar)

        page.actionBar.toolbar = toolbar
        toolbar.page = page

        if (page.rightSidebar && page.rightSidebar.actionBar)
            rightSidebarStack.push(page.rightSidebar.actionBar)
        else
            rightSidebarStack.push(emptyRightSidebar)
    }

    function replace(page) {
        page.actionBar.maxActionCount = Qt.binding(function() { return toolbar.maxActionCount })
        toolbar.page = page

        stack.replace(page.actionBar)

        if (page.rightSidebar && page.rightSidebar.actionBar)
            rightSidebarStack.replace(page.rightSidebar.actionBar)
        else
            rightSidebarStack.replace(emptyRightSidebar)
    }

    Rectangle {
        anchors.fill: rightSidebarStack

        color: page.rightSidebar && page.rightSidebar.actionBar.backgroundColor
               ? Qt.darker(page.rightSidebar.actionBar.backgroundColor,1).a === 0
                 ? page.rightSidebar.color
                 : page.rightSidebar.actionBar.backgroundColor
               : Theme.primaryColor
    }

    Controls.StackView {
        id: stack
        height: actionBarHeight

        anchors {
            left: parent.left
            right: page && page.rightSidebar
                   ? rightSidebarStack.left
                   : clientSideDecorations ? windowControls.left : parent.right
            rightMargin: 0
        }

        delegate: toolbarDelegate
    }

    Controls.StackView {
        id: rightSidebarStack
        height: actionBarHeight
        width: page && page.rightSidebar
               ? page.rightSidebar.width
               : 0

        anchors {
            right: clientSideDecorations ? windowControls.left : parent.right
            rightMargin: page.rightSidebar ? page.rightSidebar.anchors.rightMargin : 0
        }

        delegate: toolbarDelegate
    }

    Controls.StackViewDelegate {
        id: toolbarDelegate
    }

    Row {
        id: windowControls

        visible: clientSideDecorations

        anchors {
            verticalCenter: stack.verticalCenter
            right: parent.right
            rightMargin: Units.dp(16)
        }

        spacing: Units.dp(24)

        IconButton {
            iconName: "navigation/close"
            color: Theme.lightDark(toolbar.backgroundColor, Theme.light.textColor,
                Theme.dark.textColor)
            onClicked: Qt.quit()
        }
    }

    Component {
        id: emptyRightSidebar

        Item {}
    }
}
