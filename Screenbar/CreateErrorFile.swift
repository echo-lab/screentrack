//
//  CreateErrorFile.swift
//  Screenbar
//
//  Created by Donghan Hu on 3/14/19.
//

import Foundation

class errorFile : NSObject{
    func createError(filepath: URL) -> URL{
        let documentsDirectoryPathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let documentsDirectoryPath = filepath
        let jsonFilePath = documentsDirectoryPath.appendingPathComponent("errorFile.txt")
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        // creating a .json file in the Documents folder
        if !fileManager.fileExists(atPath: (jsonFilePath.absoluteString), isDirectory: &isDirectory) {
            let created = fileManager.createFile(atPath: (jsonFilePath.absoluteString), contents: nil, attributes: nil)
            if created {
                print("error file created ")
                
            } else {
                print("Couldn't create error file for some reason")
            }
        } else {
            print("Error File already exists")
        }
        return jsonFilePath
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
    
    
    
    //end of errorFile class
}
