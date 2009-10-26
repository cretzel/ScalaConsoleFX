/*
 * TextAreaFXGroup.fx
 *
 * Created on 14.09.2009, 18:34:37
 */
package com.github.scalaconsolefx;

import javafx.scene.CustomNode;
import javafx.scene.Group;
import org.jfxtras.scene.border.SoftBevelBorder;

import javafx.scene.paint.Color;

public class TextAreaFXGroup extends CustomNode {

    public var text: String;
    public var width: Number;
    public var height: Number;

    override function create() {
        def border: SoftBevelBorder = SoftBevelBorder {
            borderColor: Color.GRAY
            node: Group {
                content: [
                        TextAreaFX {
                                text: bind text with inverse;
                                width: bind width - 6
                                height: bind height - 6
                            }
                        ]

                        
            }
        }
    }
}
