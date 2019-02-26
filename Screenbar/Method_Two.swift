//
//  Method_Two.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/15/19.
//
import Foundation
import Cocoa


@available(OSX 10.13, *)
class ReplayingTwo{
    
    static let applicationDelegate: AppDelegate = NSApplication.shared().delegate as! AppDelegate
    static var SessionNumber = [Int]()
    
    
    func FetchTodayInformation() -> Dictionary<String, Int>{
        let Defaultpath = Settings.DefaultFolder
        // Documnet/Refolecor
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        let Initialsession = 1
        //let CurrentURLpath = NSURL(string : Defaultpath().absoluteString + current)
        ReplayingOne.SessionNumber = ReplayingOne.applicationDelegate.fileNameDictionary[current] as! [Int]
        //SessionNumber is now an Int array containing, for example: 0, 1, 2, 3, 4
        //length is the number of session, now is 5
        let length = ReplayingOne.SessionNumber.count
        var PhotoNameArray = [String]()
        var HashmapOfJsonResult = [String : Int]()
        let fileManager = FileManager.default
        let temppath = Defaultpath().absoluteString + current + "-" + String(Initialsession)
        if (!fileManager.fileExists(atPath: Defaultpath().absoluteString + current + "-" + String(Initialsession))){
            print("today, you have not started recording")
        }
        //let first = 1
        let last = length - 1
        //print(last)
        // last = 4
        for i in 1...last{
            // string format path
            let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(i)
            let URLfilepath = NSURL(string : Stringfilepath)
            //into the session folder
            //let DisplayImage = NSImage.self
            //filelist contain all names of the file in this folder
            let jsonfilepathString  = Stringfilepath + "test.json"
            let jsonfilepathUrl     = NSURL(string : jsonfilepathString)
            let rawData : NSData = try! NSData(contentsOf: URL(fileURLWithPath: jsonfilepathString))
            do{
                let jsonDataDictionary = try JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
                let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
                var jsonarray = dictionaryOfReturnedJsonData["Information"] as! [[String: Any]]
                //jsonarray is the whole data contains in this json file
                let length = jsonarray.count
                for j in 1 ..< length{
                    let tempname = String(describing: jsonarray[j]["SoftwareName"])
                    var tempvalue = HashmapOfJsonResult[tempname]
                    if tempvalue == nil{
                        HashmapOfJsonResult[tempname] = 1
                    }else{
                        let tempcount = tempvalue! + 1
                        HashmapOfJsonResult[tempname] = tempcount
                    }
                }
                
            }
            catch{
                print(error)
            }
        }
        // the number of photo of today
        //let PhotoNumber = PhotoNameArray.count
        
        return HashmapOfJsonResult
    }
    
    
    
}
