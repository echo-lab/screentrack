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
        let tempName = (NSWorkspace.shared.frontmostApplication?.localizedName)!
        // URL never used currently
        let URL = NSWorkspace.shared.frontmostApplication?.executableURL
        let characterSet = CharacterSet(charactersIn: "com.")
        // AfterTrimResult never used currenly
        let AfterTrimResult = tempName.trimmingCharacters(in: characterSet)
        CurrentFrontMostApp = tempName
        // print("initial current app name is:", CurrentFrontMostApp)
    }
    
    
    @available(OSX 10.13, *)
    @objc func DetectFrontMostApp() -> String{
        let ScreenshotHandler = ScreenShot()
        
        let DetectFrontMostAppName = NSWorkspace.shared.frontmostApplication?.localizedName
        let characterSet = CharacterSet(charactersIn: "com.")
        let AfterTrimResult = DetectFrontMostAppName?.trimmingCharacters(in: characterSet)
        // print(AfterTrimResult ?? "nil result")
        if CurrentFrontMostApp != DetectFrontMostAppName {
            let temp = NSWorkspace.shared.frontmostApplication?.localizedName
            if DetectFrontMostAppName == temp {
                ScreenshotHandler.take()
                print(CurrentFrontMostApp)
                print(DetectFrontMostAppName ?? "none")
                print("frontmost app changed and caputre")
                CurrentFrontMostApp = DetectFrontMostAppName!
            }
            else{
                ScreenshotHandler.take()
                CurrentFrontMostApp = temp!
                print(DetectFrontMostAppName ?? "none")
                print("frontmost app changed and caputre")
            }
        }
        return CurrentFrontMostApp

    }
    func LocalNameOfFrontMostSoftware(){
        let DetectFrontMost = NSWorkspace.shared.frontmostApplication?.localizedName
        // print(DetectFrontMost)
    }

        
}

    







