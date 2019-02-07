//
//  jsonfile.swift
//  Screenbar
//
//  Created by Donghan Hu on 1/13/19.
//  Copyright © 2019 Christian Engvall. All rights reserved.
//

import Foundation
class json: NSObject{
    //create a json file
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
            } else {
                print("Couldn't create json file for some reason")
            }
        } else {
            print("File already exists")
        }
        return jsonFilePath
    }
    
    
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
        
        // Write that JSON to the file created earlier
        //let jsonFilePath = NSURL(FilePath)
        do {
            let file = try FileHandle(forWritingTo: FilePath)
            file.write(jsonData as Data)
            print("JSON data was written to teh file successfully!")
        } catch let error as NSError {
            print("Couldn't write to file: \(error.localizedDescription)")
        }
    }
    
}
