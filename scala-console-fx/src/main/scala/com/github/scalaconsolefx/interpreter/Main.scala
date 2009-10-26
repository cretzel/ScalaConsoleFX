package com.github.scalaconsolefx.interpreter

import scala.tools.nsc.Settings
import java.io._


object Main {
  def main(args : Array[String]) : Unit = {
    
    var names: Array[String] = Array("1");
    println(names.elements)
    
    val interpreter = new SFXInterpreter()
    //var result = interpreter.interpret("println(\"Hello World\")\nval x= 10\nprintln(x)");
    //println("*\n" + result)

    var script = "trait Fruit{\ndef eat():Unit = {\nprintln(\"X\")\n}\n}\n";
    println(script)
    var result = interpreter.interpret(script);
    println("->\n" + result)

    
    script = "settings";
    println(script)
    result = interpreter.interpret(script);
    println("->\n" + result)

    script = "scalaVersion";
    println(script)
    result = interpreter.interpret(script);
    println("->\n" + result)
    
    
    println(1.->(2))
    

    
    
  }
  


}
