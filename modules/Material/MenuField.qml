/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2015 Michael Spencer <sonrisesoftware@gmail.com>
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
import QtQuick.Layouts 1.1

import Material 0.2
import Material.ListItems 0.1

/*!
   \qmltype MenuField
   \inqmlmodule Material

   \brief A input field similar to a text field but that opens a dropdown menu.
 */
Item {
    id: field

    implicitHeight: hasHelperText ? helperTextLabel.y + helperTextLabel.height + Units.dp(4)
                                  : underline.y + Units.dp(8)
    implicitWidth: spinBoxContents.implicitWidth

    activeFocusOnTab: true

    property color accentColor: Theme.accentColor
    property color errorColor: "#F44336"
    property color textColor: Theme.light.textColor
    property color tintColor: Qt.rgba(0,0,0,0.05)

    property alias model: listView.model

    property string textRole

    readonly property string selectedText: (listView.currentItem) ? listView.currentItem.text : ""

    property alias selectedIndex: listView.currentIndex
    property int maxVisibleItems: 4
    property int dropdownWidth: -1

    property alias placeholderText: fieldPlaceholder.text
    property alias helperText: helperTextLabel.text
    property string labelText: "" // if not empty, this will be used for the label text

    property bool floatingLabel: false
    property bool hasError: false
    property bool hasHelperText: helperText.length > 0
    property bool alignDropdownWithSelected: true
    property bool tintSelected: false

	property bool forceYOffset: false
	property int forceYOffsetPx: 0

    readonly property rect inputRect: Qt.rect(spinBox.x, spinBox.y, spinBox.width, spinBox.height)

    signal itemSelected(int index)

    function open() {                                                           
        var yOffset = 0;                                                        
        if (field.forceYOffset) {                                               
            listView.positionViewAtBeginning();                                 
            yOffset = field.forceYOffsetPx;                                     
        } else if (alignDropdownWithSelected) {                                 
            listView.positionViewAtIndex(listView.currentIndex, ListView.Center)
            yOffset = -listView.currentItem.itemLabel.mapToItem(menu, 0, 0).y   
        } else {                                                                
            listView.positionViewAtBeginning()                                  
        }                                                                       
        menu.open(label, 0, yOffset)                                            
    }                                                                           
                                                                                
    Ink {                                                                       
        anchors.fill: parent                                                    
        onClicked: field.open()                                                 
    } 

    Item {
        id: spinBox

        height: Units.dp(18)
        width: parent.width

        y: {
            if(!floatingLabel)
                return Units.dp(0)
            if(floatingLabel && !hasHelperText)
                return Units.dp(40)
            return Units.dp(28)
        }

        RowLayout {
            id: spinBoxContents

            height: parent.height
            width: parent.width + Units.dp(5)
            spacing: 0

            Label {
                id: label

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                text: (labelText !== "") ? labelText : ((listView.currentItem) ? listView.currentItem.text : "")
                color: textColor
                style: "subheading"
                elide: Text.ElideRight
            }

            Icon {
                id: dropDownIcon

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                Layout.preferredWidth: Units.dp(24)
                Layout.preferredHeight: Units.dp(24)

                name: "navigation/arrow_drop_down"
                size: Units.dp(24)
            }
        }

        Dropdown {
            id: menu

            anchor: Item.TopLeft

            width: dropdownWidth > 0 ? dropdownWidth : spinBox.width

            //If there are more than max items, show an extra half item so
            // it's clear the user can scroll
            height: Math.min(maxVisibleItems*Units.dp(48) + Units.dp(24), listView.contentHeight)

            ListView {
                id: listView

                width: menu.width
                height: count > 0 ? menu.height : 0

                interactive: true

                delegate: Standard {
                    id: delegateItem

                    text: textRole ? model[textRole] : modelData
                    textColor: (listView.currentIndex == index) ? accentColor : Theme.light.textColor
                    tintColor: (field.tintSelected && listView.currentIndex == index) ? field.tintColor : Qt.rgba(0,0,0,0)
                    onClicked: {
                        itemSelected(index)
                        //listView.currentIndex = index
                        menu.close()
                    }
                }
            }

            Scrollbar {
                flickableItem: listView
            }
        }
    }

    Label {
        id: fieldPlaceholder

        text: field.placeholderText
        visible: floatingLabel

        font.pixelSize: Units.dp(12)

        anchors.bottom: spinBox.top
        anchors.bottomMargin: Units.dp(8)

        color: Theme.light.hintColor
    }

    Rectangle {
        id: underline

        color: field.hasError ? field.errorColor : field.activeFocus ? field.accentColor : Theme.light.hintColor

        height: field.activeFocus ? Units.dp(2) : Units.dp(1)

        anchors {
            left: parent.left
            right: parent.right
            top: spinBox.bottom
            topMargin: Units.dp(8)
        }

        Behavior on height {
            NumberAnimation { duration: 200 }
        }

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    Label {
        id: helperTextLabel

        anchors {
            left: parent.left
            right: parent.right
            top: underline.top
            topMargin: Units.dp(4)
        }

        visible: hasHelperText
        font.pixelSize: Units.dp(12)
        color: field.hasError ? field.errorColor : Qt.darker(Theme.light.hintColor)

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}
