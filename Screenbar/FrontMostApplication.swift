//
//  FrontMostApplication.swift
//  Screenbar
//
//  Created by Donghan Hu on 10/30/18.
//  Copyright © 2018 Christian Engvall. All rights reserved.
//

import Foundation
import AppKit
import Cocoa

@available(OSX 10.13, *)
class FrontmostApp : NSObject{
    
    public var CurrentFrontMostApp: String
    
    override init() {
        let tempName = (NSWorkspace.shared().frontmostApplication?.bundleIdentifier)!
        //let frontmostinfo = NSWorkspace.shared().frontmostApplication?.
        //print(frontmostinfo ?? "none")
        let characterSet = CharacterSet(charactersIn: "com.")
        let AfterTrimResult = tempName.trimmingCharacters(in: characterSet)
        CurrentFrontMostApp = AfterTrimResult
        print("initial current app name is:")
        print(CurrentFrontMostApp)
    }
    
    
    @available(OSX 10.13, *)
    func DetectFrontMostApp() -> String{
        let ScreenshotHandler = ScreenShot()
        
        let DetectFrontMostAppName = NSWorkspace.shared().frontmostApplication?.bundleIdentifier
        let characterSet = CharacterSet(charactersIn: "com.")
        let AfterTrimResult = DetectFrontMostAppName?.trimmingCharacters(in: characterSet)
        //print(AfterTrimResult ?? "nil result")
        if CurrentFrontMostApp != AfterTrimResult{
            print(CurrentFrontMostApp)
            print(AfterTrimResult ?? "none")
            print("frontmost app changed and caputre")
            
            ScreenshotHandler.take()
            CurrentFrontMostApp = AfterTrimResult!
        }
        return CurrentFrontMostApp

    }
    func LocalNameOfFrontMostSoftware(){
        let DetectFrontMost = NSWorkspace.shared().frontmostApplication?.localizedName
        print(DetectFrontMost)
    }

        
}
    
    







