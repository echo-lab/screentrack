//
//  UserData.swift
//  Screenbar
//
//  Created by Li on 10/14/20.
//

import Combine
import Foundation
import AppKit

// global variable of file path
struct UserData {
    
    //File path to the image storage directory:~/Documents/Reflect/[date]
    static var screenshotStoragePath = String()
    
    //File path to the jsonfile:~/Documents/Reflect/[date]/test.json
    static var jsonPath: URL = URL(string: "google.com")!
    
    //File path to error.txt:~/Documents/Reflect/[date]/errorFile.txt
    static var errorPath: URL = URL(string: "google.com")!
    
    //The width of the user's screen
    static var maxWidth: Int {
        var screen: NSScreen
        
        if let _screen = NSScreen.main {
            screen = _screen
            
            let scale = screen.backingScaleFactor
            let width = screen.frame.size.width
            let scaledWidth = width * scale
            
            return Int(scaledWidth)
        }
        return 0
    }
    
    static var maxHeight: Int {
        var screen: NSScreen
        
        if let _screen = NSScreen.main {
            screen = _screen
            
            let scale = screen.backingScaleFactor
            let height = screen.frame.size.height
            let scaledHeight = height * scale
            
            return Int(scaledHeight)
        }
        return 0
    }
    
    //File path to the Reflect directory:~/Documents/Reflect
    static var rootFolderPath: URL {
        return URL(string: NSHomeDirectory() + "/Documents" + "/Reflect/")!
    }
    
    //Timelapse Window Controller
    static var TimelapseWindowController : NSWindowController? = nil
    
    //Boolean value representing whether the TimelapseWindow is open
    static var timelapseWindowIsOpen = false
    
    //TODO: fix today's date
}
