//
//  CurrentApplication.swift
//  Screenbar
//
//  Created by Donghan Hu on 10/30/18.
//  Copyright © 2018 Christian Engvall. All rights reserved.
//

import Foundation
import AppKit

class CurrentApplicationData : NSObject{
    
    public let InitialSet = NSMutableSet()
    
    
    override init(){
        for runningapp in NSWorkspace.shared.runningApplications{
            if let bundleIdentifier = runningapp.localizedName{
                let characterSet = CharacterSet(charactersIn: ".com")
                let AfterTrimResult = bundleIdentifier.trimmingCharacters(in: characterSet)
                if InitialSet.contains(AfterTrimResult){}
                else{
                    InitialSet.add(AfterTrimResult)
                }
            }
        }
    }
    
    @available(OSX 10.15, *)
    @objc func CurrentApplicationInfo(){
        let screenshot = ScreenShot()
        for runningApp in NSWorkspace.shared.runningApplications {
            if runningApp.isActive{
                print(runningApp.localizedName)
                print(String(describing: runningApp.executableURL))
            }
            if let bundleIdentifier = runningApp.localizedName {
                let characterSet = CharacterSet(charactersIn: ".com")
                let AfterTrimResult = bundleIdentifier.trimmingCharacters(in: characterSet)
                if InitialSet.contains(AfterTrimResult){
                }
                else {
                    InitialSet.add(AfterTrimResult)
                    screenshot.takeScreenshot()
                }
            }
            
        }
    }
    
    @objc func showinfor(){
        print("timer works")
    }
    
}

