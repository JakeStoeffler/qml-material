/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2014-2015 Michael Spencer <sonrisesoftware@gmail.com>
 *               2015 Bogdan Cuza
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
import QtQuick.Window 2.2
import Material 0.2
import QtGraphicalEffects 1.0

/*!
   \qmltype Icon
   \inqmlmodule Material

   \brief Displays an icon from the Material Design and FontAwesome icon collections.
*/
Item {
    id: icon

    property color color: Theme.light.iconColor
    property real size: Units.dp(24)

    /*!
       The name of the icon to display.
       
       \sa source
    */
    property string name

    /*!
       A URL pointing to an image to display as the icon. By default, this is
       a special URL representing the icon named by \l name from the Material Design
       icon collection or FontAwesome. The icon will be colorized using the specificed \l color,
       unless you put ".color." in the filename, for example, "app-icon.color.svg".

       \sa name
      */
    property string source: "icon://" + name

    property bool valid: source.indexOf("icon://awesome/") == 0 
            ? awesomeIcon.valid : image.status == Image.Ready

    property url iconDirectory: Qt.resolvedUrl("icons")

    width: size
    height: size

    property bool colorize: icon.source.indexOf("icon://") === 0 || icon.source.indexOf(".color.") === -1

    Rectangle {
        id: colorRect
        width: 100
        height: 100
        color: icon.color
        visible: false
        layer.enabled: true
        layer.smooth: true
    }

    Image {
        id: image

        anchors.fill: parent
        visible: source != ""

        source: {
            if (icon.source.indexOf("icon://") == 0) {
                var name = icon.source.substring(7)
                var list = name.split("/");

                if (name == "" || list[0] === "awesome")
                    return "";
                return Qt.resolvedUrl("icons/%1/%2.svg".arg(list[0]).arg(list[1]));
            } else {
                return icon.source
            }
        }

        sourceSize {
            width: size * Screen.devicePixelRatio
            height: size * Screen.devicePixelRatio
        }

        layer.enabled: colorize
        layer.samplerName: "maskSource"
        layer.effect: ShaderEffect {
            property var colorSource: colorRect
            fragmentShader: "
                uniform lowp sampler2D colorSource;
                uniform lowp sampler2D maskSource;
                uniform lowp float qt_Opacity;
                varying highp vec2 qt_TexCoord0;
                void main() {
                    lowp vec4 vclr = texture2D(colorSource, qt_TexCoord0);
                    lowp float a = texture2D(maskSource, qt_TexCoord0).a;
                    gl_FragColor = vec4(a*vclr.r, a*vclr.g, a*vclr.b, a*vclr.a);
                }
            "
        }
    }

    AwesomeIcon {
        id: awesomeIcon

        anchors.centerIn: parent
        size: icon.size * 0.9
        visible: name != ""
        color: icon.color

        name: {
            if (icon.source.indexOf("icon://") == 0) {
                var name = icon.source.substring(7)
                var list = name.split("/")

                if (list[0] === "awesome") {
                    return list[1]
                }
            }

            return ""
        }
    }
}
