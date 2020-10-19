//
//  FindTheLatestScreenShot.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/28/19.
//

import Foundation

@available(OSX 10.13, *)
class FindScreenShot : NSObject{
    
    //the first is the latest folder
    //.contentModificationDateKey
    func GetListOfFiles() -> [String]?{
        let fileManager = FileManager.default
        let Defaultpath = Settings.getUserDefaultFolderPath
        //Defaultpaht is a URL
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if let urlArray = try? FileManager.default.contentsOfDirectory(at: Defaultpath(),
                                                                       includingPropertiesForKeys: [.creationDateKey],
                                                                       options:.skipsHiddenFiles) {
            
            return urlArray.map { url in
                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                }
                .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                .map { $0.0 } // extract file names
            
        } else {
            return nil
        }
    }
    
    func GetLatestImage(path : URL) -> [String]?{
        let fileManager = FileManager.default
        let Defaultpath = Settings.getUserDefaultFolderPath
        //Defaultpaht is a URL
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        if let urlArray = try? FileManager.default.contentsOfDirectory(at: path,
                                                                       includingPropertiesForKeys: [.creationDateKey],
                                                                       options:.skipsHiddenFiles) {
            
            return urlArray.map { url in
                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                }
                .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                .map { $0.0 } // extract file names
            
        } else {
            return nil
        }
    }
    
    
    
    //end of the class
}
