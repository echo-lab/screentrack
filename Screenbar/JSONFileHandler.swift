//
//  jsonfile.swift
//  Screenbar
//
//  Created by Donghan Hu on 1/13/19.
//  Copyright © 2019 Christian Engvall. All rights reserved.
//

import Foundation
class JSONFileHandler: NSObject{
    
    func createJSONFile(at path: URL?) -> URL {
        
        var jsonFilePath = URL(string: NSHomeDirectory())!
        if let _jsonFilePath = path?.appendingPathComponent("test.json") {
            jsonFilePath = _jsonFilePath
        }
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        if !fileManager.fileExists(atPath: (jsonFilePath.absoluteString), isDirectory: &isDirectory) {
            
            let created = fileManager.createFile(atPath: (jsonFilePath.absoluteString), contents: nil, attributes: nil)
            
            if created {
                initJSONFileWithData(atPath: (jsonFilePath.absoluteString))
            } else {
                print("Error while creating a JSON file at path: \(String(describing: path))")
            }
        }
        
        return jsonFilePath
    }
    
    private func initJSONFileWithData(atPath path : String){
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day) + "-" + String(hour)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempdate = Calendar.current.date(byAdding: .hour, value: 0, to: Date())
        var dateString = dateFormatter.string(from: tempdate!)
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d-HH:mm:ss"
        let date24 = dateFormatter.string(from: final!)
        var ArrayOfDictionary = [Dictionary<String, Any>]()
        let dictionary : [String : Any] = 
            [
                "Introduction" : "Hello, world"
        ]
        let NameofSession = path.replacingOccurrences(of: "/test.json", with: "")
        
//        let SessionNameOfDictionary : [String : Any] = [
//            "name of session" : NameofSession
//        ]
            
        ArrayOfDictionary.append(dictionary)
        
        // name of the session: the number of session created today
        // start time: the time starting to recording
        // end time: the time that ending to recording for this specific session
        // informaiton: meta data for each screenshot
        
        var temp : [String : Any] =
            [
                "name of session"   : NameofSession,
                "StartTime"         : date24,
                "Information"       : ArrayOfDictionary,
                "EndTime"           : date24
        ]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: temp, options: JSONSerialization.WritingOptions.prettyPrinted)
        if FileManager.default.fileExists(atPath: path){
            var err:NSError?
            if let fileHandle = FileHandle(forWritingAtPath: path){
                fileHandle.write(jsonData)
                fileHandle.closeFile()
            }
            else {
                print("Can't open fileHandle \(String(describing: err))")
            }
        }
        
        
    }
    
    // write meta data into json file
    
    func writejsonfile(FilePath: URL, SoftwareName: String, OpenFilePath: String, WebsiteAddress: String){
        var jsonData: NSData!
        let information = SoftwareName + OpenFilePath + WebsiteAddress
        do {
            jsonData = try JSONSerialization.data(withJSONObject: information, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = String(data: jsonData as Data, encoding: String.Encoding.utf8)
            print(jsonString!)
        } catch let error as NSError {
            print("Array to JSON conversion failed: \(error.localizedDescription)")
        }

        do {
            let file = try FileHandle(forWritingTo: FilePath)
            file.write(jsonData as Data)
            print("JSON data was written to teh file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
    }
    
}
