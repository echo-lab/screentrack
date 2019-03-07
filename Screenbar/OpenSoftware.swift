//
//  OpenSoftware.swift
//  Screenbar
//
//  Created by Donghan Hu on 3/6/19.
//

import Foundation



class OpenSoftware : NSObject{
    
    var dictionary : [String : String] = [ "Google Chrome"           : "Browser",
                                           "Safari"                  : "Browser",
                                           //"Preview"                 : "Productivity",
                                           "Pages"                   : "Productivity",
                                           "Numbers"                 : "Productivity",
                                           "Keynots"                 : "Productivity",
                                           "Xcode"                   : "Productivity",
                                           "Microsoft Word"          : "Productivity",
                                           "Microsoft Excel"         : "Productivity",
                                           "Microsoft PowerPoint"    : "Productivity"
        
    ]
    
    func openSoftwareBasedInfor(name : String, urlAndPath : String){
        let category = dictionary[name]
        if category == "Browser"{
            let first = "tell application \""
            let second = "\" \n open location \""
            let third = "\" \n end tell"
            let final = first + name + second + urlAndPath + third
            AppleScript(script: final)
            makeFrontmost(name : name)
            
        }
        else if category == "Productivity"{
            let first = "tell application \""
            let second = "\" \n open \""
            let third = "\" \n end tell"
            let final = first + name + second + urlAndPath + third
            AppleScript(script: final)
            makeFrontmost(name : name)
        }
        else{
            
        }
       
        
    }
    func makeFrontmost(name : String){
        let first = "tell application \"System Events\" \n perform action \"AXRaise\" of window 1 of process \""
        let second = "\" \n end tell"
        let final = first + name + second
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
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
            print("error: \(String(describing: error))")
        }
    }
    
    
}
