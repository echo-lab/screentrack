//
//  JsonfileDataAfterTracking.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/23/19.
//

import Foundation

class JsondataAfterTracking : NSObject{
    
    func DataAfterRecording (filepath : URL){
        do {
            let current_path = "file://" + UserData.jsonPath.absoluteString
            let url = URL(string: current_path as String)
            let rawData : NSData = try! NSData(contentsOf: url!)
            do {
                let jsonDataArray = try JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                var sessionArray = [[String: Any]]()
                
                if let _sessionArray = jsonDataArray as? [[String: Any]] {
                    sessionArray = _sessionArray
                }
 
                sessionArray[sessionArray.count - 1]["endTime"] = Date().description
                
                let newJSONData = try JSONSerialization.data(withJSONObject: sessionArray, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                if let file = FileHandle(forWritingAtPath: UserData.jsonPath.absoluteString) {
                    file.write(newJSONData)
                    file.closeFile()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func NumberOfImages(SessionFolderPath : String) -> Int{
        //print("number of images function run but not work")
        //print(SessionFolderPath)
        //   /Users/donghanhu/Documents/Reflect/2019-2-23-8
        //let fileManager = FileManager.default
        
        let number = 0
        do {
            let filelist = try FileManager.default.contentsOfDirectory(atPath: SessionFolderPath)
            //print(filelist)
            let number = filelist.count - 2
            //print(number)
            return number
            //print(number)
        } catch {
            print(error)
            return number
        }

    }
    
    
    
    //end of the class
}

