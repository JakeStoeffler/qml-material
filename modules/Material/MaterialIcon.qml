/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014-2015 Michael Spencer
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

/*!
   \qmltype AwesomeIcon
   \inqmlmodule Material

   \brief Displays an icon from the FontAwesome icon collection.

   Most of the time, this is used indirectly by the \l Icon component, which
   is used by action bars, list items, and many other common Material components.
 */
Item {
    id: widget

    property string name

    property alias color: text.color
    property int size: Units.dp(24)

    width: text.width
    height: text.height

    property alias weight: text.font.weight

    Text {
        id: text
        anchors.centerIn: parent

        font.family: "Material Icons"
        text: widget.name
        color: Theme.light.iconColor
        font.pixelSize: widget.size
    }
}
