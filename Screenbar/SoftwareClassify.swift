//
//  SoftwareClassify.swift
//  Screenbar
//
//  Created by Donghan Hu on 1/9/19.
//  Copyright © 2019 Christian Engvall. All rights reserved.
//

import Foundation
import Cocoa
import CoreData


class classify : NSObject{

    static var Category_one = ["apple.Preview"]
    static var Category_two = ["Pages", "Numbers", "Keynotes", "Xcode"]
    static var Category_three = ["Google Chrome"]
    
    @available(OSX 10.13, *)
    func SoftwareDetect(SoftwareName : String){
        //(filepath: URL(string: MyVariables.yourVariable)!)
        if (SoftwareName == "apple.Preview"){
            print("apple Preview")
            //using dictionary to store
            print(PreviewFilePath())
            print(PreviewFileName())
            print(jpath.absoluteURL)
            print(".")
            let dictionary : [String : Any] = ["software-name":"Preview",
                                              "file-path": PreviewFilePath(),
                                              "file-name": PreviewFileName()
                                              //"open-frontmost-website":
            ]
            do {
                //var error : NSError?
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                // here "decoded" is of type `Any`, decoded from JSON data
                // you can now cast it with the right type
                let current_path = "file://" + jpath.absoluteString
                let url = URL(string: current_path as String)
                //let file = FileManager.default
                try jsonData.write(to: url!, options: .atomic)
                print(jsonString)
            } catch {
                print(error.localizedDescription)
            }
        }//end of preview input
    }
    
    //preview opened file path
    func PreviewFilePath() -> String{
        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set thefile to value of attribute \"AXDocument\" of window 1 \n end tell \n end tell"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
        if (error != nil) {
            print("error: \(String(describing: error))")
        }
            return output.stringValue!
    }
    //preview open file name
    func PreviewFileName() -> String{
        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set fileName to name of window 1 \n end tell \n end tell"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
        if (error != nil) {
            print("error: \(String(describing: error))")
        }
        return output.stringValue!
    }
    
    
}


