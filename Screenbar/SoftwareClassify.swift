//
//  SoftwareClassify.swift
//  Screenbar
//
//  Created by Donghan Hu on 1/9/19.
//  Copyright © 2019 Christian Engvall. All rights reserved.
//

// this swift file and class is used to classify various applicaitons into different classes
// due to different catefories, we would like to obtain different meta data
// currently, we have 7 different categoires
// works for about at least 12 kinds of software or applications



import Foundation
import Cocoa
import CoreData


class classify : NSObject{

    var ClassDictionary : [String : String] = ["Preview"                 : "1",
                                               "Pages"                   : "2",
                                               "Numbers"                 : "2",
                                               "Keynote"                 : "2",
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
    @available(OSX 10.15, *)
    func SoftwareBasedOnCategory(SoftwareName : String, ScreenshotName : String, BoundInfor : [String]){
        let number = ClassDictionary[SoftwareName]
        
        // this category is for "preview" software
        if number == "1" {
            print("nothing")
            let dictionary : [String : Any] = ["SoftwareName"  : SoftwareName,
                                               "PhotoName"     : ScreenshotName,
                                               "FilePath"      : PreviewFilePath(),
                                               "FileName"      : PreviewFileName(),
                                               "category"      : "Productivity",
                                               "bound"         : BoundInfor
                
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                // here "decoded" is of type `Any`, decoded from JSON data
                // you can now cast it with the right type
                let current_path = "file://" + UserData.jsonPath.absoluteString
                //url is the json file
                let url = URL(string: current_path as String)
                var fileSize : UInt64
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: UserData.jsonPath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : UserData.jsonPath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}

                    }
                } catch {
                    print("preview Error: \(error)")
                }
            }
            catch{
                print(Error.self)
            }
        }
        
        // this category is fro the unmbers， pages, and keynote
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
                let current_path = "file://" + UserData.jsonPath.absoluteString
                let url = URL(string: current_path as String)

                var fileSize : UInt64
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: UserData.jsonPath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : UserData.jsonPath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                        }catch {print(error)}
                    }
                } catch {
                    print("pages, numbers, and keynotes Error: \(error)")
                }
            }
            catch{
                print(Error.self)
            }
        }
            
        // this category is for the Xcode
        else if number == "3"{
            let newname = SoftwareName.replacingOccurrences(of: "apple.dt.", with: "")
            let dictionary : [String : Any] = ["SoftwareName"          : SoftwareName,
                                               "PhotoName"             : ScreenshotName,
                                               "FilePath"              : ProductivityFilePath(softwarename : newname),
                                               "FileName"              : XcodeFileName(softwarename: newname),
                                               "category"              : "Coding",
                                               "bound"                 : BoundInfor
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                let current_path = "file://" + UserData.jsonPath.absoluteString
                let url = URL(string: current_path as String)
                
                var fileSize : UInt64
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: UserData.jsonPath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : UserData.jsonPath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                        }catch {print(error)}
                    }
                } catch {
                    print("xcode Error: \(error)")
                }
            }
            catch{
                print(Error.self)
            }
        }
            
        // this category is for the chrome
        else if number == "4" {
            let dictionary : [String : Any] = ["SoftwareName"          : SoftwareName,
                                               "PhotoName"             : ScreenshotName,
                                               "FrontmostPageUrl"     : BrowserFirstPageURL(),
                                               "FrontmostPageTitle"   : BrowserFirstPageTitle(),
                                               "category"               : "Browser",
                                               "bound"                  : BoundInfor
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                let current_path = "file://" + UserData.jsonPath.absoluteString
                let url = URL(string: current_path as String)
                
                var fileSize : UInt64
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: UserData.jsonPath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : UserData.jsonPath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                    }
                } catch {
                    print("chrome Error: \(error)")
                }
                
            }
            catch{
                print(Error.self)
            }
            
        }
            
            
        // this category is for the Safari
        // different from the chrome
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
                let current_path = "file://" + UserData.jsonPath.absoluteString
                let url = URL(string: current_path as String)
                
                var fileSize : UInt64
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: UserData.jsonPath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : UserData.jsonPath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                    }
                } catch {
                    print("safari Error: \(error)")
                }
                
            }
            catch{
                print(Error.self)
            }
        }
            
        // this category is for microsoft productivty software
        else if number == "6"{
            let newname = SoftwareName.replacingOccurrences(of: "icrosoft.", with: "")
            let fullname = "Microsoft " + newname
            let dictionary : [String : Any] = ["SoftwareName"  : SoftwareName,
                                               "PhotoName"     : ScreenshotName,
                                               "FilePath"      : MicrosoftSoftwareFilePath(name: SoftwareName),
                                               "FileName"      : ProductivityFileName(softwarename: newname),
                                               "category"      : "Productivity",
                                               "bound"         : BoundInfor
                
            ]
            do {
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                let current_path = "file://" + UserData.jsonPath.absoluteString
                let url = URL(string: current_path as String)
                
                var fileSize : UInt64
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: UserData.jsonPath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        //read insdie data out
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : UserData.jsonPath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                        }catch {print(error)}
                    }
                } catch {
                    print("microsoft software Error: \(error)")
                }
                
            }
            catch{
                print(Error.self)
            }
        }
            
        // this category is for textedit
        else if number == "7"{
            let dictionary : [String : Any] = ["SoftwareName"  : SoftwareName,
                                               "PhotoName"     : ScreenshotName,
                                               "FilePath"      : TextEditFilePath(),
                                               "FileName"      : TextEditFileName(),
                                               "category"      : "Productivity",
                                               "bound"         : BoundInfor

            ]
            do {
                //var error : NSError?
                let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                // here "decoded" is of type `Any`, decoded from JSON data
                // you can now cast it with the right type
                let current_path = "file://" + UserData.jsonPath.absoluteString
                //url is the json file
                let url = URL(string: current_path as String)
                var fileSize : UInt64
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: UserData.jsonPath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : UserData.jsonPath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                    }
                } catch {
                    print("textedit Error: \(error)")
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
                let current_path = "file://" + UserData.jsonPath.absoluteString
                //url is the json file
                let url = URL(string: current_path as String)
                var fileSize : UInt64
                do {
                    let attr = try FileManager.default.attributesOfItem(atPath: UserData.jsonPath.absoluteString)
                    fileSize = attr[FileAttributeKey.size] as! UInt64
                    if fileSize == 0{
                        print("json file is empty")
                        try jsonData.write(to: url!, options : .atomic)
                    }
                    else{
                        let rawData : NSData = try! NSData(contentsOf: url!)
                        do{
                            let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                            var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                            jsonarray.append(dictionary)
                            jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                            let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                            if let file = FileHandle(forWritingAtPath : UserData.jsonPath.absoluteString) {
                                file.write(jsonData)
                                file.closeFile()
                            }
                            
                        }catch {print(error)}
                    }
                } catch {
                    print("other uncategorized software Error: \(error)")
                }
            }
            catch{
                print(Error.self)
            }
        }
        
        // end of this function
    }
    
    // get the file path of text edit
    func TextEditFilePath() -> String{
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
    
    // get the text edit file name
    func TextEditFileName() -> String{
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
            let empty = "empty"
            return empty
        }
        else { return (output.stringValue?.description)!}
    }

    
    //preview opened file path
    func PreviewFilePath() -> String{
        
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
    
    // get the file name of the preview
    func PreviewFileName() -> String{
        
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
    
    //pages, Numbers, Keynots, Xcode file path
    func ProductivityFilePath(softwarename : String) -> String{
        
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
    
    //Xcode opened file name 
    func XcodeFileName(softwarename : String) -> (String){
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
    
    
    //return the file name of these productivity applications
    func ProductivityFileName(softwarename : String) -> String{
        let MyAppleScript = "tell application \"System Events\" \n tell process \"Pages\" \n set fileName to name of window 1 \n end tell \n end tell"
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
    
    //return the browser first active page's url
    func BrowserFirstPageURL() -> String{
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
    
    //return the browser first active page's title
    func BrowserFirstPageTitle() -> String{
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
    
    //return the browser first active page title of the Safari
    func SafariBrowserFirstPageTitle() -> String{
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
    
    //return the browser first active page url of Safari
    func SafariBrowserFirstPageURL() -> String{
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

    //return the  microsoft software file path
    func MicrosoftSoftwareFilePath(name : String) -> String{
        
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
            try result.write(to: URLpath as! URL, atomically: false, encoding: .utf8)
        }
        catch {
        }
    }
    
    //end of the class
}


