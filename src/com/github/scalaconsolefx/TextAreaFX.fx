/*
 * TextAreaFX.fx
 *
 * Created on 14.09.2009, 07:55:35
 */
package com.github.scalaconsolefx;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.Font;
import javafx.ext.swing.SwingComponent;
import javax.swing.JComponent;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;

public class TextAreaFX extends SwingComponent{

     var jTextArea: JTextArea;
     var jScrollPane: JScrollPane;

     public var length: Integer;
     public var readText:String;
     public var text: String on replace{
         jTextArea.setText(text);
     }

     public var toolTipText: String on replace{
         jTextArea.setToolTipText(toolTipText);
     }

     public override function createJComponent():JComponent{
         translateX = 15;
         translateY = 5;
         var f:Font = new Font("courier",Font.PLAIN, 13);

         jTextArea = new JTextArea(4, 33);
         jTextArea.setOpaque(false);
         jTextArea.setFont(f);
         jTextArea.setWrapStyleWord(true);
         jTextArea.setLineWrap(true);
         jTextArea.addKeyListener( KeyListener{
             public override function
             keyPressed(keyEvent:KeyEvent) {
                 if (keyEvent.VK_PASTE == keyEvent.getKeyCode())
                 {
                     jTextArea.paste();
                 }
             }

             public override function
             keyReleased( keyEvent:KeyEvent) {
                 var pos = jTextArea.getCaretPosition();
                 text = jTextArea.getText();
                 //jTextArea.setCaretPosition(pos);
             }

             public override function
             keyTyped(keyEvent:KeyEvent) {
                 length = jTextArea.getDocument().getLength();
             }
         }
         );

         jScrollPane = new JScrollPane(jTextArea);
         
         return jScrollPane;
     }

}