//
//  OpenSoftware.swift
//  Screenbar
//
//  Created by Donghan Hu on 3/6/19.
//

import Foundation
import AppKit



class OpenSoftware : NSObject{
    let errorHandler = ErrorFileHandler()
    
    var dictionary : [String : String] = [ "Google Chrome"           : "Browser",
                                           "Safari"                  : "Browser",
                                           "Preview"                 : "Preview",
                                           "Acrobat Reader"          : "Adobe Acrobat Reader DC",
                                           "Pages"                   : "Productivity",
                                           "Numbers"                 : "Productivity",
                                           "Keynots"                 : "Productivity",
                                           "Xcode"                   : "Productivity",
                                           "Microsoft Word"          : "Productivity",
                                           "Microsoft Excel"         : "Productivity",
                                           "Microsoft PowerPoint"    : "Productivity",
                                           "TextEdit"                : "TextEdit"
        
    ]
    
    func openSoftwareBasedInfor(name : String, urlAndPath : String){
        let category = dictionary[name]
        if category == "Browser"{
            if urlAndPath != nil {
                let first = "tell application \""
                let second = "\" \n open location \""
                let third = "\" \n end tell"
                let final = first + name + second + urlAndPath + third
                AppleScript(script: final)
                makeFrontmost(name : name)
            }
            else {
                let first = "tell application \""
                let second = "\" \n activate \n end tell"
                let final = first + name + second
                AppleScript(script: final)
                makeFrontmost(name : name)
            }
        }
        else if category == "Productivity"{
            if urlAndPath != nil {
                //urlAndPath is String
                //let filePath = url?.path
                let temp = String(urlAndPath.dropFirst(7))
                let newString = temp.replacingOccurrences(of: "%20", with: " ")
                //let temp = "/Users/donghanhu/Desktop/Presentation1.pptx"
                if (FileManager.default.fileExists(atPath: newString)){
                    let first = "tell application \""
                    let second = "\" \n open \""
                    let third = "\" \n end tell"
                    let final = first + name + second + urlAndPath + third
                    AppleScript(script: final)
                    makeFrontmost(name : name)
                }
                else{
                    let alert = NSAlert.init()
                    alert.messageText = "Hello"
                    alert.informativeText = "no file found"
                    alert.addButton(withTitle: "OK")
                    //alert.addButton(withTitle: "Cancel")
                    alert.runModal()
                }
                
            }
            else {
                let first = "tell application \""
                let second = "\" \n activate \n end tell"
                let final = first + name + second
                AppleScript(script: final)
                makeFrontmost(name : name)
            }
           
        }
        else if category == "Preview"{
            if urlAndPath.count > 7{
                //code here
                let start = urlAndPath.index(urlAndPath.startIndex, offsetBy: 7)
                let end = urlAndPath.index(urlAndPath.endIndex, offsetBy: 0)
                let range = start..<end
                let tempUrl = urlAndPath[range]
                if(FileManager.default.fileExists(atPath: String(tempUrl))){
                    let first = "tell application \""
                    let second = "\" \n open \""
                    let third = "\" \n end tell"
                    let final = first + name + second + tempUrl + third
                    AppleScript(script: final)
                    makeFrontmost(name : name)
                    
                }
                else{
                    let alert = NSAlert.init()
                    alert.messageText = "Hello"
                    alert.informativeText = "no file found"
                    alert.addButton(withTitle: "OK")
                    //alert.addButton(withTitle: "Cancel")
                    alert.runModal()
                }
               
            }
            else {
                let first = "tell application \""
                let second = "\" \n activate \n end tell"
                let final = first + name + second
                AppleScript(script: final)
                makeFrontmost(name : name)
            }
           
        }
        else if category == "TextEdit"{
            if urlAndPath.count > 7{
                //code here
                let start = urlAndPath.index(urlAndPath.startIndex, offsetBy: 7)
                let end = urlAndPath.index(urlAndPath.endIndex, offsetBy: 0)
                let range = start..<end
                let tempUrl = urlAndPath[range]
                if(FileManager.default.fileExists(atPath: String(tempUrl))){
                    let first = "tell application \""
                    let second = "\" \n open \""
                    let third = "\" \n end tell"
                    let final = first + name + second + tempUrl + third
                    AppleScript(script: final)
                    makeFrontmost(name : name)
                    
                }
                else{
                    let alert = NSAlert.init()
                    alert.messageText = "Hello"
                    alert.informativeText = "no file found"
                    alert.addButton(withTitle: "OK")
                    //alert.addButton(withTitle: "Cancel")
                    alert.runModal()
                }
                
            }
            else {
                let first = "tell application \""
                let second = "\" \n activate \n end tell"
                let final = first + name + second
                AppleScript(script: final)
                makeFrontmost(name : name)
            }
        }
        else if category == "Adobe Acrobat Reader DC"{
            if urlAndPath.count > 7{
                let start = urlAndPath.index(urlAndPath.startIndex, offsetBy: 7)
                let end = urlAndPath.index(urlAndPath.endIndex, offsetBy: 0)
                let range = start..<end
                let tempUrl = urlAndPath[range]
                if (FileManager.default.fileExists(atPath: String(tempUrl))){
                    let first = "tell application \"Adobe Acrobat Reader DC\" \n activate \n open \""
                    let second = "\" \n end tell"
                    let final = first + tempUrl + second
                    AppleScript(script: final)
                    makeFrontmost(name: "Acrobat Reader")
                }
                else{
                    let alert = NSAlert.init()
                    alert.messageText = "Hello"
                    alert.informativeText = "no file found"
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
               
            }
            else{
                let first = "tell application \"Adobe Acrobat Reader DC\" \n activate \n end tell"
                AppleScript(script: first)
                makeFrontmost(name: "Acrobat Reader")
            }
          
        }
        else{
            //"Xcode"
            let url = NSWorkspace.shared.fullPath(forApplication: name)
            let one = "tell application" + url! + "to activate"
            let first = "tell application \""
            let second = "\" \n activate \n end tell"
            let final = first + name + second
            //AppleScript(script: final)
            AppleScript(script: one)
            makeFrontmost(name: name)
        }
       
        
    }
    //
    
    func stringSub(url : String) -> String{
        let start = url.index(url.startIndex, offsetBy: 7)
        let end = url.index(url.endIndex, offsetBy: 0)
        let range = start..<end
        let mySubstring = url[range]
        return String(mySubstring)
    }
    //
    
    func makeFrontmost(name : String){
        let first = "tell application \"System Events\" \n perform action \"AXRaise\" of window 1 of process \""
        let second = "\" \n end tell"
        let final = first + name + second
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            //let errorHandler = errorFile()
            errorHandler.writeError(error : error!)
            print("error: \(String(describing: error))")
        }
    }
    
    func AppleScript(script : String){
        var error: NSDictionary?
        //let scriptObject = NSAppleScript(source: MyAppleScript)
        let scriptObject = NSAppleScript(source: script)
        scriptObject!.executeAndReturnError(&error)
        //let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            errorHandler.writeError(error : error!)
            print("error: \(String(describing: error))")
        }
    }
    
    
}
