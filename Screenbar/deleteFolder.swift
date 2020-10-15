//
//  deleteFolder.swift
//  Screenbar
//
//  Created by Donghan Hu on 11/12/19.
//

import Foundation
import AppKit

//path: /Users/donghanhu/Documents/Reflect/


@available(OSX 10.13, *)
class deleteFolders{
    
    var path = "/Users/donghanhu/Documents/Reflect/"
    
    func getFolderPath(dayLength: String) -> Date{
        let dayLengthInt = Int(dayLength)! * (-1)
        // the day length to save all screenshot is:
        //  print("dayLength:", dayLength)
        let toDate = Date()
        let fromDate = Calendar.current.date(byAdding:  .day, value: dayLengthInt, to: toDate)
        
        // the date format is:
        // print("fromDate", fromDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        var dateString = dateFormatter.string(from: fromDate!)
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d"
        let date24 = dateFormatter.string(from: final!)
        print("date24", date24)
        return fromDate!
        
    }
    
    func listFiles(rootpath: URL, dayLength: String){
        let fileManager = FileManager.default
        let lastDate = self.getFolderPath(dayLength: dayLength)
        do {
            
            let filesURLs = try fileManager.contentsOfDirectory(at: rootpath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            //print("fileurls", filesURLs.count)
//            for i in 0..<filesURLs.count{
//                filesURLs[i].resourceValues(forKeys: .contentModificationDateKey)
//                print(filesURLs[i])
//            }
            for i in filesURLs {
                let attributes = try! i.resourceValues(forKeys: [.creationDateKey, .nameKey])
                //print("attributes", attributes)
                let filename = attributes.name!
                let modificationDate = attributes.creationDate
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.none
                dateFormatter.timeStyle = DateFormatter.Style.medium
                dateFormatter.dateFormat = "yyyy-M-d"
                let temp = dateFormatter.string(from: modificationDate!)
                if modificationDate! < lastDate{
                    //print(i)
                    //url : i
                    try! fileManager.removeItem(at: i)
                    
                }

                //print(modificationDate)
            }
            
                
        }
        catch {
            print("Error while enumberting files")
        }
    }
    
    
    
}
