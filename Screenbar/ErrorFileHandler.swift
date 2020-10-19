//
//  CreateErrorFile.swift
//  Screenbar
//
//  Created by Donghan Hu on 3/14/19.
//

import Foundation

class ErrorFileHandler : NSObject{
    
    func createErrorFile(at path: URL?) -> URL{
        var errorFilePath = URL(string: NSHomeDirectory())!
        if let _errorFilePath = path?.appendingPathComponent("errorFile.txt") {
            errorFilePath = _errorFilePath
        }
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        if !fileManager.fileExists(atPath: (errorFilePath.absoluteString), isDirectory: &isDirectory) {
            fileManager.createFile(atPath: (errorFilePath.absoluteString), contents: nil, attributes: nil)
        }
        
        return errorFilePath
    }
    
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
}
