//
//  OpeningDocumentInfor.swift
//  Screenbar
//
//  Created by Donghan Hu on 12/11/18.
//  Copyright © 2018 Christian Engvall. All rights reserved.
//

import Foundation
import Cocoa

// this class is not being used currently, for chrome
class openfile: NSObject{
    func chrome(){
        let myAppleScript = "tell application \"Google Chrome\" \n return URL of active tab of first window \n end tell"
       
        var error: NSDictionary?
        
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(
                &error) {
                print(output.stringValue)
            } else if (error != nil) {
                print("error: \(error)")
            }
        }
    }


}
