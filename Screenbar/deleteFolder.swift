//
//  deleteFolder.swift
//  Screenbar
//
//  Created by Donghan Hu on 11/12/19.
//

import Foundation
import AppKit

//path: /Users/donghanhu/Documents/Reflect/


@available(OSX 10.15, *)
class deleteFolders{
    
    var path = "/Users/donghanhu/Documents/Reflect/"
    
    func getFolderPath(dayLength: String) -> Date{
        let dayLengthInt = Int(dayLength)! * (-1)
        let toDate = Date()
        let fromDate = Calendar.current.date(byAdding:  .day, value: dayLengthInt, to: toDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let dateString = dateFormatter.string(from: fromDate!)
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d"
        return fromDate!
        
    }
    
    func listFiles(rootpath: URL, dayLength: String){
        let fileManager = FileManager.default
        let lastDate = self.getFolderPath(dayLength: dayLength)
        do {
            let filesURLs = try fileManager.contentsOfDirectory(at: rootpath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for i in filesURLs {
                let attributes = try! i.resourceValues(forKeys: [.creationDateKey, .nameKey])
                let modificationDate = attributes.creationDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.none
                dateFormatter.timeStyle = DateFormatter.Style.medium
                dateFormatter.dateFormat = "yyyy-M-d"
                if modificationDate! < lastDate{
                    try! fileManager.removeItem(at: i)
                }
            }
        } catch {
            print("Error while enumberting files")
        }
    }
}
