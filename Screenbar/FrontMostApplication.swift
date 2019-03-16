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
        let tempName = (NSWorkspace.shared().frontmostApplication?.localizedName)!
        //let frontmostinfo = NSWorkspace.shared().frontmostApplication?.
        //print(frontmostinfo ?? "none")
        //print(tempName)
        let characterSet = CharacterSet(charactersIn: "com.")
        let AfterTrimResult = tempName.trimmingCharacters(in: characterSet)
        CurrentFrontMostApp = tempName
        print("initial current app name is:")
        print(CurrentFrontMostApp)
    }
    
    
    @available(OSX 10.13, *)
    func DetectFrontMostApp() -> String{
        let ScreenshotHandler = ScreenShot()
        
        let DetectFrontMostAppName = NSWorkspace.shared().frontmostApplication?.localizedName
        let characterSet = CharacterSet(charactersIn: "com.")
        let AfterTrimResult = DetectFrontMostAppName?.trimmingCharacters(in: characterSet)
        //print(AfterTrimResult ?? "nil result")
        
        if CurrentFrontMostApp != AfterTrimResult{
            //sleep(1.5)
            let temp = NSWorkspace.shared().frontmostApplication?.localizedName
            if AfterTrimResult == temp {
                ScreenshotHandler.take()
                print(CurrentFrontMostApp)
                print(AfterTrimResult ?? "none")
                print("frontmost app changed and caputre")
                CurrentFrontMostApp = AfterTrimResult!
            }
            else{
                //AfterTrimResult != temp, means 1.5s later, switch a new software
                //
                ScreenshotHandler.take()
                CurrentFrontMostApp = temp!
                print(AfterTrimResult ?? "none")
                print("frontmost app changed and caputre")
            }
//            print(CurrentFrontMostApp)
//            print(AfterTrimResult ?? "none")
//            print("frontmost app changed and caputre")
//
//            ScreenshotHandler.take()
//            CurrentFrontMostApp = AfterTrimResult!
        }
        return CurrentFrontMostApp

    }
    func LocalNameOfFrontMostSoftware(){
        let DetectFrontMost = NSWorkspace.shared().frontmostApplication?.localizedName
        print(DetectFrontMost)
    }

        
}

    







