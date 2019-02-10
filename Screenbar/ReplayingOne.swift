//
//  ReplayingOne.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/4/19.
//  Copyright © 2019 Christian Engvall. All rights reserved.
//

import Cocoa
import Foundation
import CoreImage

@available(OSX 10.13, *)


class ReplayingOne: NSViewController {

    
    static let applicationDelegate: AppDelegate = NSApplication.shared().delegate as! AppDelegate
    static var SessionNumber = [Int]()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do view setup here.
//    }

    
    @available(OSX 10.13, *)
    func FetchPhotoToday() -> Array<Any>{
        
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
            //let DisplayImage = NSImage.self
            do {
                //filelist contain all names of the file in this folder
                let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                let number = filelist.count
                for j in 0..<number{
                    if filelist[j].contains(".jpg"){
                        let temp = Stringfilepath + "/" + filelist[j]
                        //means it is a photo, instead of a json file
                        PhotoNameArray.append(temp)
                    }
                }
                //PhotoNameArray contains file path + file name
                //print(PhotoNameArray)
            } catch {
                print(error)
            }
        }
        // the number of photo of today
        let PhotoNumber = PhotoNameArray.count
        
        return PhotoNameArray
    }
    
    //@IBAction func replayone(_ sender: Any) {
    //}

    
    
    
    
    
}
