//
//  jsonfile.swift
//  Screenbar
//
//  Created by Donghan Hu on 1/13/19.
//  Copyright © 2019 Christian Engvall. All rights reserved.
//

import Foundation
class json: NSObject{
    
    //create a json file to save all meta data inside
    func createjson(filepath: URL) -> URL{
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = filepath
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("test.json")
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: (jsonFilePath.absoluteString), isDirectory: &isDirectory) {
            let created = fileManager.createFile(atPath: (jsonFilePath.absoluteString), contents: nil, attributes: nil)
            if created {
                print("Json file created ")
                WriteInitialData(Filepath: (jsonFilePath.absoluteString))
                
            } else {
                print("Couldn't create json file for some reason")
            }
        } else {
            print("File already exists")
        }
        return jsonFilePath
    }
    
    
    // write some start information into json file
    // currently, I need to write something into it while creating a new json file
    
    
    func WriteInitialData(Filepath : String){
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
        let NameofSession = Filepath.replacingOccurrences(of: "/test.json", with: "")
        
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
        if FileManager.default.fileExists(atPath: Filepath){
            var err:NSError?
            if let fileHandle = FileHandle(forWritingAtPath: Filepath){
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
