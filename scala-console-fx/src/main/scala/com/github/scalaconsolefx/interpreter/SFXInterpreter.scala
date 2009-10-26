package com.github.scalaconsolefx.interpreter

import scala.tools.nsc.Interpreter
import scala.tools.nsc.InterpreterResults
import scala.tools.nsc.InterpreterResults._
import scala.tools.nsc.Settings
import scala.tools.nsc.Properties
import java.io._
import SFXInterpreter._

object SFXInterpreter {
  
  val newLine = "\n"
  
}

class SFXInterpreter {

  private val writer = new StringWriter
  private val sysout = new ByteArrayOutputStream
  private val interpreter = createInterpreter
    
  private def createInterpreter(): Interpreter = {
    val settings = createSettings
    val interpreter = new Interpreter(settings, new PrintWriter(writer))
    
    interpreter.beQuietDuring {
      interpreter.bind("settings", "scala.tools.nsc.Settings", settings)
      interpreter.bind("scalaVersion", "java.lang.String", Properties.versionString);
    }
    
    interpreter
  }
  
  private def createSettings(): Settings = {
    val s = new Settings(null)
    s.classpath.value =
      addClasspathExtras(s.classpath.value)
    s
  }
 
  def interpret(codeString: String): String = {
    
    // redirect System.out
    val prevSystemOut = System.out
    System.setOut(new PrintStream(sysout))
    
    var output = interpretLines("", codeString.lines.toList.filter(_ != ""), Success)

    // reset System.out
    System.setOut(prevSystemOut)
    
    output
  }
  
  private def interpretLines(start: String, remaining: List[String], prevResult: Result): String = {

    prevResult match {
      
      case InterpreterResults.Incomplete => {
        remaining match {
	      case x :: xs => {
	        val (ires, iout) = interpretUntil(start, x, prevResult)
	        iout + interpretLines(start + newLine + x, xs, ires)
	      }
	      case Nil => "Incomplete"
	    }
      }
      
      case InterpreterResults.Success => {
        remaining match {
	      case x :: xs => {
	        val (ires, iout) = interpretUntil("", x, prevResult)
	        iout + interpretLines(x, xs, ires)
	      }
	      case Nil => ""
	    }
      }
      
      case InterpreterResults.Error => "Error"
      
    }
  }
  
  private def interpretUntil(start: String, nextLine: String, lastResult: InterpreterResults.Result) = {
    val iresult = interpreter interpret start + newLine + nextLine
    
    var output = 
      if (lastResult == InterpreterResults.Success) "\nscala> " + nextLine + newLine
      else "       " + nextLine + newLine
    
    output += flushAndClearWriter
    output += flushAndClearSysout

    (iresult, output)
  }
    
  private def flushAndClearWriter = {
    val content = writer.toString
    val buf = writer.getBuffer
    buf.delete(0, buf.length)
    content
  }
  
  private def flushAndClearSysout = {
    val content = sysout.toString()
	sysout.reset  
	content
  }

  /** Copied from MainGenericRunner. */
  private def addClasspathExtras(classpath: String): String = {
    val scalaHome = System getenv "SCALA_HOME"
    val extraClassPath =
      if (scalaHome eq null)
        ""
      else {
        def listDir(name:String):Array[File] = {
          val libdir = new File(new File(scalaHome), name)
          if (!libdir.exists || libdir.isFile)
            Array()
          else       
            libdir.listFiles
        }
        {
          val filesInLib = listDir("lib")
          val jarsInLib = 
            filesInLib.filter(f => 
              f.isFile && f.getName.endsWith(".jar"))
          jarsInLib.toList
        } ::: {
          val filesInClasses = listDir("classes")
          val dirsInClasses = 
            filesInClasses.filter(f => f.isDirectory)
          dirsInClasses.toList
        }
      }.mkString("", File.pathSeparator, "")

    if (classpath == "")
      extraClassPath + File.pathSeparator + "."
    else
      classpath + File.pathSeparator + extraClassPath
  }

}
