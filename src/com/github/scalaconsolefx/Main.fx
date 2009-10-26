package com.github.scalaconsolefx;

import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.Group;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.scene.paint.Color;
import javafx.scene.paint.LinearGradient;
import javafx.scene.paint.Stop;
import javafx.scene.shape.Rectangle;
import javafx.geometry.VPos;
import org.jfxtras.stage.JFXStage;
import org.jfxtras.menu.NativeMenu;

import org.jfxtras.menu.NativeMenuItem;

import com.github.scalaconsolefx.interpreter.SFXInterpreter;

var scene: Scene;
var stageWidth = 600;
var stageHeight = 500;
var inputGroup: TextAreaFXGroup;
var outputGroup: TextAreaFXGroup;
var controls: Group;
var menu: NativeMenu;

def interpreter = new SFXInterpreter();

menu = NativeMenu {
    items: [
            NativeMenu {
                text: "File"
                action: function() {
                  FX.println("Yeah!")
                }
                items: [
                        NativeMenuItem {
                            text:"Dude"
                        }

                        ]

            }
    ]
}

inputGroup = TextAreaFXGroup {
    width: bind scene.width
    height: bind scene.height/2 - controls.boundsInLocal.height/2;
    text: 'println("Hello World!")'
}

outputGroup = TextAreaFXGroup {
    width: bind scene.width
    height: bind scene.height/2 - controls.boundsInLocal.height/2;
}

var executeButton = Button {
    action: function() {execute();}
    text: "Execute"
}
var clearInputButton = Button {
    action: function() {inputGroup.text = "";}
    text: "Clear"
}

controls = Group {
    var rect0: Rectangle;
    var rect1: Rectangle;
    var hbox: HBox;
    content: [
        rect0 = Rectangle {
            width: bind scene.width
            height: 31
            fill: Color.BLACK
        }
        rect1 = Rectangle {
            arcHeight:10 arcWidth:10
            width: bind scene.width - 3
            height: bind rect0.height - 2
            stroke: Color.BLACK
            translateX: 1 translateY: 1
            fill: LinearGradient {
                startX:0 endX:1 proportional:true
                stops: [Stop {offset:0 color:Color.GRAY}, Stop {offset:1 color:Color.GRAY}]
            }
        }
        hbox = HBox {
            width: bind scene.width
            translateX: 10
            translateY: 4
            spacing: 10
            vpos: VPos.CENTER
            nodeVPos: VPos.CENTER
            content: [executeButton, clearInputButton]
        }

    ]

}

function execute() {
    outputGroup.text = interpreter.interpret(inputGroup.text);
}

var stage: Stage = JFXStage {

    title: "ScalaConsole FX"
    width: stageWidth
    height: stageHeight
    scene: scene = Scene {
        content: [
            VBox {
                content: [
                    inputGroup,
                    controls,
                    outputGroup
                ]

            }
        ]
    }
}