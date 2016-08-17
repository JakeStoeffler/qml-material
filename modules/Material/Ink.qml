/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014-2015 Michael Spencer <sonrisesoftware@gmail.com>
 *               2014 Marcin Baszczewski
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
import Material 0.2
import Material.Extras 0.1

/*!
   \qmltype Ink
   \inqmlmodule Material

   \brief Represents a ripple ink animation used in buttons and many other components.
 */
MouseArea {
    id: view

    clip: true
    hoverEnabled: false
    z: 2

    onPressed: {
        pressedBgTimer.stop()
        pressedBackground.opacity = 1
    }
    onCanceled: pressedBgTimer.start()
    onReleased: pressedBgTimer.start()

    property int startRadius
    property int endRadius
    property Item lastCircle
    property color color
    property bool circular: false
    property bool centered: false
    property int focusWidth: 0
    property bool focused
    property color focusColor: "transparent"
    property bool showFocus: true

    Rectangle {
        id: pressedBackground

        anchors.fill: parent
        color: Qt.rgba(0,0,0,0.15)
        opacity: 0
        radius: circular ? parent.width/2 : 0
    }

    Timer {
        id: pressedBgTimer
        interval: 125
        onTriggered: pressedBackground.opacity = 0
    }
}
