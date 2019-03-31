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

//    static var Category_one = ["apple.Preview"]
//    static var Category_two = ["Pages", "Numbers", "Keynotes", "Xcode"]
//    static var Category_three = ["Google Chrome"]
    var ClassDictionary : [String : String] = ["Preview"                 : "1",
                                               "Pages"                   : "2",
                                               "Numbers"                 : "2",
                                               "Keynots"                 : "2",
                                               "Xcode"                   : "3",
                                               "Google Chrome"           : "4",
                                               "Safari"                  : "5",
                                               "Microsoft Word"          : "6",
                                               "Microsoft Excel"         : "6",
                                               "Microsoft PowerPoint"    : "6",
                                               "Acrobat Reader"          : "6",
                                               "Eclipse"                 : "6",
                                               "TextEdit"                : "7"
    ]
    @available(OSX 10.13, *)
    func SoftwareBasedOnCategory(SoftwareName : String, ScreenshotName : String, BoundInfor : [String]){
        let number = ClassDictionary[SoftwareName]
        if number == "1" {
            //print("apple Preview")
            //            print(PreviewFilePath())
            //            print(PreviewFileName())
            //            print(jpath.absoluteURL)
            let dictionary : [String : Any] = ["SoftwareName"  : SoftwareName,
                                               "PhotoName"     : ScreenshotName,
                                               "FilePath"      : PreviewFilePath(),
                                               "FileName"      : PreviewFileName(),
                                               "category"      : "Productivity",
                                               "bound"         : BoundInfor
                
                //"open-frontmost-website":
            ]
            do {
                //var error : NSError?
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                // here "decoded" is of type `Any`, decoded from JSON data
                // you can now cast it with the right type
                let current_path = "file://" + jpath.absoluteString
                //url is the json file
                let url = URL(string: current_path as String)
                var fileSize : UInt64
                do {
                    //return [FileAttributeKey : Any]
                    let attr = try FileManager.default.attributesOfItem(atPath: jpath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //print("json file has other data inside")
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            //print(jsonarray)
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : jpath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                        
                        //try jsonData.write(to: url!, options : .atomic)
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            catch{
                print(Error.self)
            }
        }
        
        else if number == "2"{
            //substring the software name here
            let newname = SoftwareName.replacingOccurrences(of: "apple.iWork.", with: "")
            
            let dictionary : [String : Any] = ["SoftwareName"  : SoftwareName,
                                               "PhotoName"     : ScreenshotName,
                                               "FilePath"      : ProductivityFilePath(softwarename : newname),
                                               "FileName"      : ProductivityFileName(softwarename: newname),
                                               "category"      : "Productivity",
                                               "bound"         : BoundInfor
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                let current_path = "file://" + jpath.absoluteString
                let url = URL(string: current_path as String)

                var fileSize : UInt64
                do {
                    //return [FileAttributeKey : Any]
                    let attr = try FileManager.default.attributesOfItem(atPath: jpath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //print("json file has other data inside")
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            //print(jsonarray)
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : jpath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                        //try jsonData.write(to: url!, options : .atomic)
                    }
                } catch {
                    print("Error: \(error)")
                }
                
            }
            catch{
                print(Error.self)
            }
        }
        else if number == "3"{
            let newname = SoftwareName.replacingOccurrences(of: "apple.dt.", with: "")
            let dictionary : [String : Any] = ["SoftwareName"          : SoftwareName,
                                               "PhotoName"             : ScreenshotName,
                                               "FilePath"              : ProductivityFilePath(softwarename : newname),
                                               "FileName"              : ProductivityFileName(softwarename: newname),
                                               "category"              : "Coding",
                                               "bound"                 : BoundInfor
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                let current_path = "file://" + jpath.absoluteString
                let url = URL(string: current_path as String)
                
                var fileSize : UInt64
                do {
                    //return [FileAttributeKey : Any]
                    let attr = try FileManager.default.attributesOfItem(atPath: jpath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //print("json file has other data inside")
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            //print(jsonarray)
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : jpath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                        //try jsonData.write(to: url!, options : .atomic)
                    }
                } catch {
                    print("Error: \(error)")
                }
                
            }
            catch{
                print(Error.self)
            }
        }
        //for google chrome, now
        else if number == "4" {
            //let newname = SoftwareName.replacingOccurrences(of: "apple.dt.", with: "")
            
            let dictionary : [String : Any] = ["SoftwareName"          : SoftwareName,
                                               "PhotoName"             : ScreenshotName,
                                               //"file-path": ProductivityFilePath(softwarename : newname),
                                               //"file-name": ProductivityFileName(softwarename: newname)
                                               "FrontmostPageUrl"     : BrowserFirstPageURL(),
                                               "FrontmostPageTitle"   : BrowserFirstPageTitle(),
                                               "category"               : "Browser",
                                               "bound"                  : BoundInfor
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                let current_path = "file://" + jpath.absoluteString
                let url = URL(string: current_path as String)
                
                var fileSize : UInt64
                do {
                    //return [FileAttributeKey : Any]
                    let attr = try FileManager.default.attributesOfItem(atPath: jpath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //print("json file has other data inside")
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            //print(jsonarray)
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : jpath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                        //try jsonData.write(to: url!, options : .atomic)
                    }
                } catch {
                    print("Error: \(error)")
                }
                
            }
            catch{
                print(Error.self)
            }
            
        }
        //apple.Safari
        else if number == "5"{
            let newname = SoftwareName.replacingOccurrences(of: "apple.", with: "")
            let dictionary : [String : Any] = ["SoftwareName"          : SoftwareName,
                                               "PhotoName"             : ScreenshotName,
                                               "FrontmostPageUrl"     : SafariBrowserFirstPageURL(),
                                               "FrontmostPageTitle"   : SafariBrowserFirstPageTitle(),
                                               "category"               : "Browser",
                                               "bound"                  : BoundInfor
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                let current_path = "file://" + jpath.absoluteString
                let url = URL(string: current_path as String)
                
                var fileSize : UInt64
                do {
                    //return [FileAttributeKey : Any]
                    let attr = try FileManager.default.attributesOfItem(atPath: jpath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //print("json file has other data inside")
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            //print(jsonarray)
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : jpath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                        //try jsonData.write(to: url!, options : .atomic)
                    }
                } catch {
                    print("Error: \(error)")
                }
                
            }
            catch{
                print(Error.self)
            }
        }
        // for microsoft productivty software
        else if number == "6"{
            let newname = SoftwareName.replacingOccurrences(of: "icrosoft.", with: "")
            let fullname = "Microsoft " + newname
            let dictionary : [String : Any] = ["SoftwareName"  : SoftwareName,
                                               "PhotoName"     : ScreenshotName,
                                               "FilePath"      : MicrosoftSoftwareFilePath(name: SoftwareName),
                                               "FileName"      : ProductivityFileName(softwarename: newname),
                                               "category"       : "Productivity",
                                               "bound"         : BoundInfor
                
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                let current_path = "file://" + jpath.absoluteString
                let url = URL(string: current_path as String)
                
                var fileSize : UInt64
                do {
                    //return [FileAttributeKey : Any]
                    let attr = try FileManager.default.attributesOfItem(atPath: jpath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //print("json file has other data inside")
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            //print(jsonarray)
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : jpath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                        //try jsonData.write(to: url!, options : .atomic)
                    }
                } catch {
                    print("Error: \(error)")
                }
                
            }
            catch{
                print(Error.self)
            }
        }
        else if number == "7"{
            let dictionary : [String : Any] = ["SoftwareName"  : SoftwareName,
                                               "PhotoName"     : ScreenshotName,
                                               "FilePath"      : TextEditFilePath(),
                                               "FileName"      : TextEditFileName(),
                                               "category"      : "Productivity",
                                               "bound"         : BoundInfor
                
                //"open-frontmost-website":
            ]
            do {
                //var error : NSError?
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                // here "decoded" is of type `Any`, decoded from JSON data
                // you can now cast it with the right type
                let current_path = "file://" + jpath.absoluteString
                //url is the json file
                let url = URL(string: current_path as String)
                var fileSize : UInt64
                do {
                    //return [FileAttributeKey : Any]
                    let attr = try FileManager.default.attributesOfItem(atPath: jpath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //print("json file has other data inside")
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            //print(jsonarray)
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : jpath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                        
                        //try jsonData.write(to: url!, options : .atomic)
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            catch{
                print(Error.self)
            }
        }
        //could not identify this software name into any catogoriy
        else{
            let dictionary : [String : Any] = ["SoftwareName"  : SoftwareName,
                                               "PhotoName"     : ScreenshotName,
                                               "category"      : "Dont know",
                                               "bound"         : BoundInfor
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                let current_path = "file://" + jpath.absoluteString
                //url is the json file
                let url = URL(string: current_path as String)
                var fileSize : UInt64
                do {
                    //return [FileAttributeKey : Any]
                    let attr = try FileManager.default.attributesOfItem(atPath: jpath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //print("json file has other data inside")
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : jpath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
            catch{
                print(Error.self)
            }
        }
        
        // end of this function
    }
    //
    func TextEditFilePath() -> String{
        let MyAppleScript = "tell application \"System Events\" \n tell process \"TextEdit\" \n set thefile to value of attribute \"AXDocument\" of window 1 \n end tell \n end tell"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else {
            //let tem = output.stringValue?.
            return (output.stringValue?.description)!
            
        }

    }
    //
    func TextEditFileName() -> String{
        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set fileName to name of window 1 \n end tell \n end tell"
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
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }
    //
    //preview opened file path
    func PreviewFilePath() -> String{
        
        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set thefile to value of attribute \"AXDocument\" of window 1 \n end tell \n end tell"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else {
            //let tem = output.stringValue?.
            return (output.stringValue?.description)!
            
        }
        //return (output.stringValue?.description)!
    }
    //preview open file name
    func PreviewFileName() -> String{
        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set fileName to name of window 1 \n end tell \n end tell"
        let first = "tell application \"System Events\" \n tell process"
        let second = "\"Preview\" \n "
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
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
        //return (output.stringValue?.description)!
    }
    
    //pages, Numbers, Keynots, Xcode
    func ProductivityFilePath(softwarename : String) -> String{
        //example is Pages
        let MyAppleScript = "tell application \"Pages\" \n activate \n tell front document to set fpath to its file as alias \n set ctime to creation date of (info for fpath) \n set thisfile to POSIX path of fpath \n return thisfile \n end tell \n tell application \"Pages\" to return"
        let first = "tell application \""
        let second = "\" \n activate \n tell front document to set fpath to its file as alias \n set ctime to creation date of (info for fpath) \n set thisfile to POSIX path of fpath \n return thisfile \n end tell \n tell application \""
        let third = "\" to return "
        let final = first + softwarename + second + softwarename + third
        var error: NSDictionary?
        //let scriptObject = NSAppleScript(source: MyAppleScript)
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        //print(output.stringValue)
        //print(output.stringValue?.description)
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
        //return (output.stringValue?.description)!
        
    }
    //return the file name of these productivity
    func ProductivityFileName(softwarename : String) -> String{
        let MyAppleScript = "tell application \"System Events\" \n tell process \"Pages\" \n set fileName to name of window 1 \n end tell \n end tell"
        let first = " tell application \"System Events\" \n tell process \""
        let third = "\" \n set fileName to name of window 1 \n end tell \n end tell"
        let final = first + softwarename + third
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
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
        //return (output.stringValue?.description)!
    }
    
    //return the browser first active page url
    func BrowserFirstPageURL() -> String{
        let MyAppleScript = "tell application \"Google Chrome\" to return URL of active tab of first window"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
        //return output.stringValue!
    }
    //return the browser first active page title
    func BrowserFirstPageTitle() -> String{
        let MyAppleScript = "tell application \"Google Chrome\" to return title of active tab of first window"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
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
    //return the browser first active page title of Safari
    func SafariBrowserFirstPageTitle() -> String{
        let MyAppleScript = "tell application \"Safari\" to return name of front document "
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
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
    //return the browser first active page url of Safari
    func SafariBrowserFirstPageURL() -> String{
        let MyAppleScript = "tell application \"Safari\" to return URL of front document "
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: MyAppleScript)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
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
    //microsoft software file path
    func MicrosoftSoftwareFilePath(name : String) -> String{
        
        let MyAppleScript = "tell application \"System Events\" \n tell process \"Preview\" \n set thefile to value of attribute \"AXDocument\" of window 1 \n end tell \n end tell"
        let first = "tell application \"System Events\" \n tell process \""
        let second = "\" \n set thefile to value of attribute \"AXDocument\" of window 1 \n end tell \n end tell"
        let final = first + name + second
        var error: NSDictionary?
        //let scriptObject = NSAppleScript(source: MyAppleScript)
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        //print(output.stringValue)
        if (error != nil) {
            writeError(error : error!)
            print("error: \(String(describing: error))")
        }
        if output.stringValue == nil{
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
        //return (output.stringValue?.description)!
    }
    
    //
    func writeError(error : NSDictionary){
        let path = "file://" + erpath.absoluteString
        let URLpath = NSURL(string : path)
        let currentTime = Date().description(with: .current)
        let errorDescription = error.description
        let result = currentTime + "\n" + errorDescription
        do {
            try result.write(to: URLpath as! URL, atomically: false, encoding: .utf8)
        }
        catch {
        }
    }
    
    
    //end of the class
}


