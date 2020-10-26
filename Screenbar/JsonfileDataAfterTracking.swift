//
//  JsonfileDataAfterTracking.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/23/19.
//

import Foundation

class JsondataAfterTracking : NSObject{
    
    func DataAfterRecording (filepath : URL){
        //write image number
        //write stop time
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        //let current = String(year) + "-" + String(month) + "-" + String(day) + "-" + String(hour)
        let documentsDirectoryPath = filepath
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        //new temp date, (Date())
        let tempdate = Calendar.current.date(byAdding: .hour, value: 0, to: Date())
        let dateString = dateFormatter.string(from: tempdate!)
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d-HH:mm:ss"
        let date24 = dateFormatter.string(from: final!)
        //let jsonFilePath = documentsDirectoryPath.appendingPathComponent("test.json")
        
        let dictionary : [String : Any] =
            [
                "EndTime"       : date24,
                "number of imaeges" : NumberOfImages(SessionFolderPath: filepath.absoluteString)
        ]
        //write this dictionary into json file
        do{
            let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
            let current_path = "file://" + UserData.jsonPath.absoluteString
            //url is the json file
            let url = URL(string: current_path as String)
            //var fileSize : UInt64
            let rawData : NSData = try! NSData(contentsOf: url!)
            do{
                let jsonDataDictionary = try JSONSerialization.jsonObject(with : rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                //read json file data as a dictionary
                var dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                //read dictionary as Dictionary <String, Any>
                //dont need the array now
                //just add one one more new dictionary into it
                dictionaryOfReturnedJsonData.updateValue(NumberOfImages(SessionFolderPath: filepath.absoluteString) as AnyObject, forKey: "number of images")
                dictionaryOfReturnedJsonData.updateValue(date24 as AnyObject, forKey: "EndTime")
                //var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String : Any]]
                
                //print(jsonarray)
                //jsonarray.append(dictionary)
                //jsonDataDictionary?.setValue(jsonarray, forKey: "Information")
                
//                let jsonData = try! JSONSerialization.data(withJSONObject : jsonDataDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                let jsonData = try! JSONSerialization.data(withJSONObject : dictionaryOfReturnedJsonData, options: JSONSerialization.WritingOptions.prettyPrinted)
                if let file = FileHandle(forWritingAtPath : UserData.jsonPath.absoluteString) {
                    file.write(jsonData)
                    file.closeFile()
                }
            
        }
        catch{
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

