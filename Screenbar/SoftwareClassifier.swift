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

class SoftwareClassifier: NSObject {
    
    let categoryDictionary: [String: Int] = [
        "Preview"                 : 1,
        "Pages"                   : 2,
        "Numbers"                 : 2,
        "Keynote"                 : 2,
        "Xcode"                   : 3,
        "Google Chrome"           : 4,
        "Safari"                  : 5,
        "Microsoft Word"          : 6,
        "Microsoft Excel"         : 6,
        "Microsoft PowerPoint"    : 6,
        "Acrobat Reader"          : 6,
        "Eclipse"                 : 6,
        "TextEdit"                : 7
    ]
    
    @available(OSX 10.15, *)
    func writeSoftwareBasedOnCategory(softwareName: String, screenshotName: String, bound: [String]) {
        let categoryNumber = categoryDictionary[softwareName]
        
        let metaDataDictionary = createMetaDataDictionary(byCategory: categoryNumber ?? 0, softwareName: softwareName, screenshotName: screenshotName, bound: bound)
        
        writeToJSONFile(withMetaDataDictionary: metaDataDictionary)
    }
    
    //MARK: getTextEditFilePath
    func getTextEditFilePath() -> String{
        let MyAppleScript = "tell application \"System Events\" \n tell process \"TextEdit\" \n set thefile to value of attribute \"AXDocument\" of window 1 \n end tell \n end tell"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else {
            return (output.stringValue?.description)!
        }
    }
    
    //MARK: getTextEditFileName
    func getTextEditFileName() -> String{
//        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set fileName to name of window 1 \n end tell \n end tell"
        let first = "tell application \"System Events\" \n tell process"
        let second = "\"TextEdit\" \n "
        let third = "set fileName to name of window 1 \n end tell \n end tell"
        let final = first + second + third
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        //let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        
        if output.stringValue == nil{
            return "none"
        } else {
            return (output.stringValue?.description)!
        }
    }
    
    //MARK: getPreviewFilePath
    func getPreviewFilePath() -> String{
        
        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set thefile to value of attribute \"AXDocument\" of window 1 \n end tell \n end tell"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else {
            return (output.stringValue?.description)!
            
        }
    }
    
    //MARK: getPreviewFileName
    func getPreviewFileName() -> String{
        
//        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set fileName to name of window 1 \n end tell \n end tell"
        
        let first = "tell application \"System Events\" \n tell process"
        let second = "\"Preview\" \n "
        let third = "set fileName to name of window 1 \n end tell \n end tell"
        let final = first + second + third
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }
    
    //MARK: getProductivityFilePath
    func getProductivityFilePath(softwarename : String) -> String{
        
//        let MyAppleScript = "tell application \"Pages\" \n activate \n tell front document to set fpath to its file as alias \n set ctime to creation date of (info for fpath) \n set thisfile to POSIX path of fpath \n return thisfile \n end tell \n tell application \"Pages\" to return"
        
        let first = "tell application \""
        let second = "\" \n activate \n tell front document to set fpath to its file as alias \n set ctime to creation date of (info for fpath) \n set thisfile to POSIX path of fpath \n return thisfile \n end tell \n tell application \""
        let third = "\" to return "
        let final = first + softwarename + second + softwarename + third
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
        
    }
    
    //MARK: getXcodeFilename
    func getXcodeFilename(softwarename : String) -> (String){
        let first = "tell application \"Xcode\" \n set fileName to name of window 1 \n end tell"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: first)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }
    
    //MARK: getProductivityFilename
    func getProductivityFilename(softwarename : String) -> String{
//        let MyAppleScript = "tell application \"System Events\" \n tell process \"Pages\" \n set fileName to name of window 1 \n end tell \n end tell"
        let first = "tell application \"System Events\" \n tell process \""
        let third = "\" \n set fileName to name of window 1 \n end tell \n end tell"
        let final = first + softwarename + third
        print("final for Xcode", final)
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }
    
    //MARK: getGoogleChromeFirstPageURL
    func getGoogleChromeFirstPageURL() -> String{
        let MyAppleScript = "tell application \"Google Chrome\" to return URL of active tab of first window"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }
    
    //MARK: getGoogleChromeFirstPageTitle
    func getGoogleChromeFirstPageTitle() -> String{
        let MyAppleScript = "tell application \"Google Chrome\" to return title of active tab of first window"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }
    
    //MARK: getSafariFirstPageTitle
    func getSafariFirstPageTitle() -> String{
        let MyAppleScript = "tell application \"Safari\" to return name of front document "
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }
    
    //MARK: getSafariBrowserFirstPageURL
    func getSafariBrowserFirstPageURL() -> String{
        let MyAppleScript = "tell application \"Safari\" to return URL of front document "
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }

    //MARK: getMicrosoftSoftwareFilePath
    func getMicrosoftSoftwareFilePath(name : String) -> String{
//        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set thefile to value of attribute \"AXDocument\" of window 1 \n end tell \n end tell"
        let first = "tell application \"System Events\" \n tell process \""
        let second = "\" \n set thefile to value of attribute \"AXDocument\" of window 1 \n end tell \n end tell"
        let final = first + name + second
        var error: NSDictionary?
        print("applescript",final)
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            writeError(error : error!)
            print(" file path error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }
    
    // return the write error
    func writeError(error : NSDictionary){
        let path = "file://" + UserData.errorPath.absoluteString
        let URLpath = NSURL(string : path)
        let currentTime = Date().description(with: .current)
        let errorDescription = error.description
        let result = currentTime + "\n" + errorDescription
        
        do {
            try result.write(to: URLpath! as URL, atomically: false, encoding: .utf8)
        } catch {
            
        }
    }
    
    //MARK: createDictionary
    private func createMetaDataDictionary(byCategory categoryNumber: Int, softwareName: String, screenshotName: String, bound: [String]) -> [String: Any] {
        var dictionary: [String: Any] = [
            "softwareName": softwareName,
            "photoName": screenshotName,
            "bound": bound
        ]
        
        switch categoryNumber {
        case 1:
            dictionary["filePath"] = getPreviewFilePath()
            dictionary["fileName"] = getPreviewFileName()
            dictionary["category"] = "Productivity"
        case 2:
            let formattedSoftwareName = softwareName.replacingOccurrences(of: "apple.iWork.", with: "")
            dictionary["filePath"] = getProductivityFilePath(softwarename: formattedSoftwareName)
            dictionary["fileName"] = getProductivityFilename(softwarename: formattedSoftwareName)
            dictionary["category"] = "Productivity"
        case 3:
            let formattedSoftwareName = softwareName.replacingOccurrences(of: "apple.dt.", with: "")
            dictionary["filePath"] = getProductivityFilename(softwarename: formattedSoftwareName)
            dictionary["fileName"] = getXcodeFilename(softwarename: formattedSoftwareName)
            dictionary["category"] = "Coding"
        case 4:
            dictionary["frontMostPageURL"] = getGoogleChromeFirstPageURL()
            dictionary["frontMostPageTitle"] = getGoogleChromeFirstPageTitle()
            dictionary["category"] = "Browser"
        case 5:
            dictionary["frontMostPageURL"] = getSafariBrowserFirstPageURL()
            dictionary["frontMostPageTitle"] = getSafariFirstPageTitle()
            dictionary["category"] = "Browser"
        case 6:
            let formattedSoftwareName = softwareName.replacingOccurrences(of: "icrosoft.", with: "")
            dictionary["filePath"] = getMicrosoftSoftwareFilePath(name: softwareName)
            dictionary["fileName"] = getProductivityFilename(softwarename: formattedSoftwareName)
            dictionary["category"] = "Productivity"
        case 7:
            dictionary["filePath"] = getTextEditFilePath()
            dictionary["fileName"] = getTextEditFileName()
            dictionary["category"] = "Productivity"
        default:
            dictionary["category"] = "None"
        }
        
        return dictionary
    }
    
    //MARK: writeToJSONFile
    private func writeToJSONFile(withMetaDataDictionary metaDataDictionary: [String: Any]) {
        
        do {
            var jsonPathURL: URL = URL(string: NSHomeDirectory())!
            
            if let _jsonPathURL = URL(string: "file://" + UserData.jsonPath.absoluteString) {
                jsonPathURL = _jsonPathURL
            }
            
            try updateJSONFile(at: jsonPathURL, with: metaDataDictionary)
        } catch {
            print("Error writing metadata to JSON file: \(metaDataDictionary)")
        }
    }   //End of writeToJSONFile()
    
    private func updateJSONFile(at path: URL, with data: [String: Any]) throws {
        let rawData: NSData = try NSData(contentsOf: path)
        if let jsonDataArray = try JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [[String: Any]] {
            
            //EMTPY JSON FILE
            if jsonDataArray.count == 0 {
                let startTime = DateFormatter.localizedString(
                    from: Date(),
                    dateStyle: .short,
                    timeStyle: .short
                )
                
                let newSessionData: [String: Any] = [
                    "startTime": startTime,
                    "images": [data]
                ]
                
                let newJSONData = try JSONSerialization.data(withJSONObject: newSessionData, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                if let file = FileHandle(forWritingAtPath: UserData.jsonPath.absoluteString) {
                    file.write(newJSONData)
                    file.closeFile()
                }
            } else {
                print("NON-EMPTY JSON FILE")
            }
        }
    }
    
    private func readJSONFileAndUpdate(at jsonPathURL: URL, withNewData metaDataDictionary: [String: Any]) throws {
//        print("readJSONFileAndUpdate:")
//        print("at: \(jsonPathURL)")
//        print("with: \(metaDataDictionary)")
        let rawData: NSData = try NSData(contentsOf: jsonPathURL)
        let jsonDataDictionary = try JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as?  NSDictionary
        
        print("rawData: \(rawData)")
//        print("jsonDataDictionary: \(jsonDataDictionary)")
        
        if let dictionaryOfReturnedJsonData = jsonDataDictionary as? [String: Any] {
            print("HERE")
            var jsonArray: [[String: Any]] = [[String: Any]()]
            
            if let _jsonArray = dictionaryOfReturnedJsonData["Information"] as? [[String: Any]] {
                jsonArray = _jsonArray
            }
            
            jsonArray.append(metaDataDictionary)
            jsonDataDictionary?.setValue(jsonArray, forKey: "Information")
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDataDictionary as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let file = FileHandle(forWritingAtPath: UserData.jsonPath.absoluteString) {
                file.write(jsonData)
                file.closeFile()
            }
        }
    }   //End of readJSONFileAndUpdate()
}   //End of Classify


