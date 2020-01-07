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

// this swift file is coded for retrieving screenshots and meta data for later displaying
// but currently, we abondanded the method of retrieving screenshots based on different day intervals, like 3 days or 5 days.
// we retrieve images by day, like Jan 5th.
// hence, we only used function to retrieve information for one specific day

class ReplayingOne: NSViewController{

    
    static let applicationDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    static let applocationDelegateTemp : AppDelegate = NSApplication.shared.delegate as! AppDelegate
    static var SessionNumber = [Int]()
    static var SessionNumberForOneHour = [Int]()
    static var SessionNumberForThreeHour = [Int]()
    static var SessionNumberForEightHour = [Int]()
    static var SessionNumberForFiveHour = [Int]()
    static var SessionNumberFor24Hour = [Int]()
    static var SessionNumberForToday = [Int]()
    static var SessionNumberForYesterday = [Int]()
    static var SessionNumberForSomeDay = [Int]()
    //static var SessionNumberForDays = [Int]()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do view setup here.
//    }

    
    @available(OSX 10.13, *)
    
    // get all images from today
    func FetchPhotoToday() -> Array<Any>{
        
        let Defaultpath = Settings.DefaultFolder
        
        // Documnet/Reflect
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        let Initialsession = 1
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
        // last = 4
        if last == 0{
            
        }
        else {
            for i in 1...last{
                // string format path
                let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(i)
                let URLfilepath = NSURL(string : Stringfilepath)
                //let DisplayImage = NSImage.self
                do {
                    //filelist contain all names of the file in this folder
                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                    let tempURL = NSURL(string: Stringfilepath)
                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                    let lalala = tempFileList.map { url in
                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                        }
                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                    let count = lalala.count
//                    for k in 0..<count{
//                        if lalala[k].0.contains(".jpg"){
//                            print(lalala[k])
//                            let temp = Stringfilepath + "/" + lalala[k].0
//                            tem.append(temp)
//                        }
//                    }

                    let number = filelist.count
                    for k in 0..<count{
                        if lalala[k].0.contains(".jpg"){
                            let temp = Stringfilepath + "/" + lalala[k].0
                            //means it is a photo, instead of a json file
                            PhotoNameArray.append(temp)
                        }
                    }
                    //PhotoNameArray contains file path + file name
                } catch {
                    print(error)
                }
            }
        }

        // the number of photo of today
        let PhotoNumber = PhotoNameArray.count
        
        return PhotoNameArray
    }
    

    // fetch images from last one hour, not being used currently
    func FetchOneHours() -> Array<Any>{
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        let fileManager = FileManager.default
        let yesterday = GetYesterdayDate(date : date, Day : 1)
        let pastdate = GetDateOfPastTime(date : date, Hour : 1)
        let pasttime = GetTimeOfPastTime(date: date, Hour: 1)
        print("here")
        print(pasttime)
        let currentTime = GetTimeOfCurrentTime(date : date)
        let Initialsession = 1

        // past date is the same as today
        if (pastdate == current){
            ReplayingOne.SessionNumberForOneHour = ReplayingOne.applicationDelegate.fileNameDictionary[pastdate] as! [Int]
            var last = ReplayingOne.SessionNumberForOneHour.count - 1
            if (last == 0){
                print("no recording last one hour")
            }else{
                //has at least one folder, the last one is "current-last"
                //several session folders, at least one folder
                //for i in (1...last).reversed(){
                while(last > 0){
                    //iterate from last to first
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(last)
                    let jsonFilePath = Stringfilepath + "/" + "test.json"
                    //josnfile path
                    do{
                        //into the folder
                        let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePath)
                        let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePath)
                        print(timeOfStart)
                        //read out the start time
                        //2019-2-25-16:05:57
                        //compare with past time
                        //
                        let hourOfStartTime = ReturnHour(str: timeOfStart)
                        let hourOfPastTime = ReturnHour(str: pasttime)
                        if (hourOfStartTime > hourOfPastTime){
                            //current time is 16, past time is 13, if start time is before past time, then check end of time
                            //start is 14
                            let hourOfEndTime = ReturnHour(str: timeOfEnd)
                            //end is 14
                            // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                            if (hourOfEndTime <= hourOfPastTime ){
                                //not recording
                                break
                            }
                            else {
                                //start time < past time < end time, the recording is in this period of time
                                //read screenshot
                                //need to code
                                do {
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                    let tempURL = NSURL(string: Stringfilepath)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    // number is not being used currently
                                    let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            if (DealWithScreenShotName(str : lalala[k].0) >= hourOfPastTime) {
                                                let temp = Stringfilepath + "/" + lalala[k].0
                                                tem.append(temp)
                                            }
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                
                            }
                            last -= 1
                        }else if (hourOfStartTime == hourOfPastTime){
                            //read all photo out in this json file
                            do {
                                let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                let tempURL = NSURL(string: Stringfilepath)
                                let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                let lalala = tempFileList.map { url in
                                    (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                    }
                                    .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                let count = lalala.count
                                //let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                let number = filelist.count
                                //let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                //let number = filelist.count
                                var tem = [String]()
                                for k in 0..<count{
                                    if lalala[k].0.contains(".jpg"){
                                        let temp = Stringfilepath + "/" + lalala[k].0
                                        //means it is a photo, instead of a json file
                                        tem.append(temp)
                                        //PhotoNameArray.append(temp)
                                    }
                                }
                                var reverse : [String] = Array(tem.reversed())
                                PhotoNameArray += reverse
                            } catch {
                                print(error)
                            }
                            break
                            
                        }else{
                            //hour of start time > past time
                            // go to previous file to read again
                            last -= 1
                        }
                        
                    }catch{
                        print(error)
                    }
                    //last -= 1
                    //end of the while loop
                }
            }
            
        }
            // past date is yesterday
            // go to yesterday
        else{
            ReplayingOne.SessionNumberForToday = ReplayingOne.applicationDelegate.fileNameDictionary[current] as! [Int]
            let lengthoftoday = ReplayingOne.SessionNumberForToday.count
            if (!fileManager.fileExists(atPath: Defaultpath().absoluteString + current + "-" + String(Initialsession))){
                print("today, you have not started recording")
            }
            //let first = 1
            
            let lastoftoday = lengthoftoday - 1
            // last = 4
            if (lastoftoday == 0){
                print("no recording last three hour")
            }else{
                for i in 1...lastoftoday{
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(i)
                    //let URLfilepath = NSURL(string : Stringfilepath)
                    do {
                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                        let tempURL = NSURL(string: Stringfilepath)
                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                        let lalala = tempFileList.map { url in
                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                            }
                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                        let count = lalala.count
                        //let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                        let number = filelist.count
                        //filelist contain all names of the file in this folder
                        var tem = [String]()
                        for k in 0..<count{
                            if lalala[k].0.contains(".jpg"){
                                let temp = Stringfilepath + "/" + lalala[k].0
                                tem.append(temp)
                                //means it is a photo, instead of a json file
                                //PhotoNameArray.append(temp)
                            }
                        }
                        var reverse : [String] = Array(tem.reversed())
                        PhotoNameArray += reverse
                        //PhotoNameArray contains file path + file name
                        //print(PhotoNameArray)
                    } catch {
                        print(error)
                    }
                }
            }
            // second yesterday
            // print(yesterday)
            if ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] == nil{
                return PhotoNameArray.reversed() as [String]
            }
            else{
                ReplayingOne.SessionNumberForYesterday = ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] as! [Int]
                
                let lengthofyesterday = ReplayingOne.SessionNumberForYesterday.count
                var lastofyesterday = lengthofyesterday - 1
                if (lastofyesterday == 0){
                    print("no recording yesterday in these eight hours")
                }else{
                    //has at least one folder, the last one is "current-last"
                    //several session folders, at least one folder
                    //for i in (1...last).reversed(){
                    while(lastofyesterday > 0){
                        //iterate from last to first
                        let Stringfilepathofyesterday = Defaultpath().absoluteString + yesterday + "-" + String(lastofyesterday)
                        let jsonFilePathofyesterday = Stringfilepathofyesterday + "/" + "test.json"
                        //josnfile path
                        //let URLfilepath = NSURL(string : Stringfilepath)
                        do{
                            //into the folder
                            let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePathofyesterday)
                            let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePathofyesterday)
                            //print(timeOfStart)
                            //read out the start time
                            //2019-2-25-16:05:57
                            //compare with past time
                            //
                            let hourOfStartTime = ReturnHour(str: timeOfStart)
                            let hourOfPastTime = ReturnHour(str: pasttime)
                            if (hourOfStartTime > hourOfPastTime){
                                //current time is 14, past time is 11, start time is before past time, then check end of time
                                let hourOfEndTime = ReturnHour(str: timeOfEnd)
                                // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                                if (hourOfEndTime <= hourOfPastTime ){
                                    //not recording
                                    break
                                }
                                else {
                                    //start time < past time < end time, the recording is in this period of time
                                    //read screenshot
                                    //need to code
                                    do {
                                        //let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                        let tempURL = NSURL(string: Stringfilepathofyesterday)
                                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                        let lalala = tempFileList.map { url in
                                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                            }
                                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                        let count = lalala.count
                                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                        let number = filelist.count
                                        var tem = [String]()
                                        for k in 0..<count{
                                            if lalala[k].0.contains(".jpg"){
                                                if (DealWithScreenShotName(str : lalala[k].0) >= hourOfPastTime) {
                                                    let temp = Stringfilepathofyesterday + "/" + lalala[k].0
                                                    //PhotoNameArray.append(temp)
                                                    tem.append(temp)
                                                }
                                            }
                                        }
                                        var reverse : [String] = Array(tem.reversed())
                                        PhotoNameArray += reverse
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                                lastofyesterday -= 1
                            }else if (hourOfStartTime == hourOfPastTime){
                                //read all photo out in this json file
                                do {
                                    let tempURL = NSURL(string: Stringfilepathofyesterday)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                    let number = filelist.count
                                    //let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                    //let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            let temp = Stringfilepathofyesterday + "/" + lalala[k].0
                                            //means it is a photo, instead of a json file
                                            //PhotoNameArray.append(temp)
                                            tem.append(temp)
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                break
                                
                            }else{
                                //hour of start time > past time
                                // go to previous file to read again
                                lastofyesterday -= 1
                            }
                            
                        }catch{
                            print(error)
                        }
                        //last -= 1
                        //end of the while loop
                    }
                }
            }
            

        }
        //if it doesnot exist, go to previous day
        
        return PhotoNameArray.reversed() as [String]
    }
    //
    //

    // fetch all images from last 3 hours.
    // last three hours may contains yesterday's recording
    func FetchThreeHours() -> Array<Any>{
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        let fileManager = FileManager.default
        let yesterday = GetYesterdayDate(date : date, Day : 1)
        let pastdate = GetDateOfPastTime(date : date, Hour : 3)
        let pasttime = GetTimeOfPastTime(date: date, Hour: 3)
        let currentTime = GetTimeOfCurrentTime(date : date)
        let Initialsession = 1
        // past date is the same as today
        if (pastdate == current){
            ReplayingOne.SessionNumberForThreeHour = ReplayingOne.applicationDelegate.fileNameDictionary[pastdate] as! [Int]
            var last = ReplayingOne.SessionNumberForThreeHour.count - 1
            if (last == 0){
                print("no recording last three hour")
            }else{
                //has at least one folder, the last one is "current-last"
                //several session folders, at least one folder
                //for i in (1...last).reversed(){
                while(last > 0){
                    //iterate from last to first
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(last)
                    let jsonFilePath = Stringfilepath + "/" + "test.json"
                    //josnfile path
                    do{
                        //into the folder
                        let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePath)
                        let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePath)
                        print(timeOfStart)
                        //read out the start time
                        //2019-2-25-16:05:57
                        //compare with past time
                        //
                        let hourOfStartTime = ReturnHour(str: timeOfStart)
                        let hourOfPastTime = ReturnHour(str: pasttime)
                        if (hourOfStartTime > hourOfPastTime){
                            //current time is 16, past time is 13, if start time is before past time, then check end of time
                            //start is 14
                            let hourOfEndTime = ReturnHour(str: timeOfEnd)
                            //end is 14
                            // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                            if (hourOfEndTime <= hourOfPastTime ){
                                //not recording
                                break
                            }
                            else {
                                //start time < past time < end time, the recording is in this period of time
                                //read screenshot
                                //need to code
                                do {
                                    let tempURL = NSURL(string: Stringfilepath)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                    let number = filelist.count
                                    //lalala[k].0.contains(".jpg")
                                    //let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                    //let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            if (DealWithScreenShotName(str : lalala[k].0) >= hourOfPastTime) {
                                                let temp = Stringfilepath + "/" + lalala[k].0
                                                tem.append(temp)
                                            }
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                
                            }
                            last -= 1
                        }else if (hourOfStartTime == hourOfPastTime){
                            //read all photo out in this json file
                            do {
                                let tempURL = NSURL(string: Stringfilepath)
                                let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                let lalala = tempFileList.map { url in
                                    (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                    }
                                    .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                let count = lalala.count
                                let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                let number = filelist.count
                                var tem = [String]()
                                for k in 0..<count{
                                    if lalala[k].0.contains(".jpg"){
                                        let temp = Stringfilepath + "/" + lalala[k].0
                                        //meaning it is a photo, instead of a json file
                                        tem.append(temp)
                                    }
                                }
                                var reverse : [String] = Array(tem.reversed())
                                PhotoNameArray += reverse
                            } catch {
                                print(error)
                            }
                            break
                            
                        }else{
                            //hour of start time > past time
                            // go to previous file to read again
                            last -= 1
                        }
                        
                    }catch{
                        print(error)
                    }
                    //last -= 1
                    //end of the while loop
                }
            }
            
        }
        // past date is yesterday
        // go to yesterday
        else{
            ReplayingOne.SessionNumberForToday = ReplayingOne.applicationDelegate.fileNameDictionary[current] as! [Int]
            let lengthoftoday = ReplayingOne.SessionNumberForToday.count
            //var PhotoNameArray = [String]()
            //let fileManager = FileManager.default
            //let temppath = Defaultpath().absoluteString + current + "-" + String(Initialsession)
            if (!fileManager.fileExists(atPath: Defaultpath().absoluteString + current + "-" + String(Initialsession))){
                print("today, you have not started recording")
            }
            //let first = 1
            
            let lastoftoday = lengthoftoday - 1
            // last = 4
            if (lastoftoday == 0){
                print("no recording last three hour")
            }else{
                for i in 1...lastoftoday{
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(i)
                    //let URLfilepath = NSURL(string : Stringfilepath)
                    do {
                        //filelist contain all names of the file in this folder
                        let tempURL = NSURL(string: Stringfilepath)
                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                        let lalala = tempFileList.map { url in
                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                            }
                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                        let count = lalala.count
                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                        let number = filelist.count
                        var tem = [String]()
                        for k in 0..<count{
                            if lalala[k].0.contains(".jpg"){
                                let temp = Stringfilepath + "/" + lalala[k].0
                                //means it is a photo, instead of a json file
                                tem.append(temp)
                                //PhotoNameArray.append(temp)
                            }
                        }
                        //PhotoNameArray contains file path + file name
                        var reverse : [String] = Array(tem.reversed())
                        PhotoNameArray += reverse
                    } catch {
                        print(error)
                    }
                }
            }
            
            //second part: yesterday
            if ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] == nil{
                
                return PhotoNameArray.reversed() as [String]
            }
            else{
                ReplayingOne.SessionNumberForYesterday = ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] as! [Int]
                let lengthofyesterday = ReplayingOne.SessionNumberForYesterday.count
                var lastofyesterday = lengthofyesterday - 1
                if (lastofyesterday == 0){
                    print("no recording yesterday in these eight hours")
                }else{
                    //has at least one folder, the last one is "current-last"
                    //several session folders, at least one folder
                    //for i in (1...last).reversed(){
                    while(lastofyesterday > 0){
                        //iterate from last to first
                        let Stringfilepathofyesterday = Defaultpath().absoluteString + yesterday + "-" + String(lastofyesterday)
                        let jsonFilePathofyesterday = Stringfilepathofyesterday + "/" + "test.json"
                        //josnfile path
                        //let URLfilepath = NSURL(string : Stringfilepath)
                        do{
                            //into the folder
                            let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePathofyesterday)
                            let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePathofyesterday)
                            //print(timeOfStart)
                            //read out the start time
                            //2019-2-25-16:05:57
                            //compare with past time
                            //
                            let hourOfStartTime = ReturnHour(str: timeOfStart)
                            let hourOfPastTime = ReturnHour(str: pasttime)
                            if (hourOfStartTime > hourOfPastTime){
                                //current time is 14, past time is 11, start time is before past time, then check end of time
                                let hourOfEndTime = ReturnHour(str: timeOfEnd)
                                // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                                if (hourOfEndTime <= hourOfPastTime ){
                                    //not recording
                                    break
                                }
                                else {
                                    //start time < past time < end time, the recording is in this period of time
                                    //read screenshot
                                    //need to code
                                    do {
                                        let tempURL = NSURL(string: Stringfilepathofyesterday)
                                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                        let lalala = tempFileList.map { url in
                                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                            }
                                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                        let count = lalala.count
                                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                        let number = filelist.count
                                        //lalala[k].0.contains(".jpg")
                                        //let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                        //let number = filelist.count
                                        var tem = [String]()
                                        for k in 0..<count{
                                            if lalala[k].0.contains(".jpg"){
                                                if (DealWithScreenShotName(str :  lalala[k].0) >= hourOfPastTime) {
                                                    let temp = Stringfilepathofyesterday + "/" +  lalala[k].0
                                                    //PhotoNameArray.append(temp)
                                                    tem.append(temp)
                                                }
                                            }
                                        }
                                        var reverse : [String] = Array(tem.reversed())
                                        PhotoNameArray += reverse
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                                lastofyesterday -= 1
                            }else if (hourOfStartTime == hourOfPastTime){
                                //read all photo out in this json file
                                do {
                                    let tempURL = NSURL(string: Stringfilepathofyesterday)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            let temp = Stringfilepathofyesterday + "/" + lalala[k].0
                                            //means it is a photo, instead of a json file
                                            //PhotoNameArray.append(temp)
                                            tem.append(temp)
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                break
                                
                            }else{
                                //hour of start time > past time
                                // go to previous file to read again
                                lastofyesterday -= 1
                            }
                            
                        }catch{
                            print(error)
                        }
                        //last -= 1
                        //end of the while loop
                    }
                }
                
            }

            
        }
        //if it doesnot exist, go to previous day
        
        return PhotoNameArray.reversed() as [String]
    }
    //
    func FetchFiveHours() -> Array<Any>{
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        let fileManager = FileManager.default
        let yesterday = GetYesterdayDate(date : date, Day : 1)
        let pastdate = GetDateOfPastTime(date : date, Hour : 5)
        let pasttime = GetTimeOfPastTime(date: date, Hour: 5)
        let currentTime = GetTimeOfCurrentTime(date : date)
        //print("in fetch 5 hour function")
        let Initialsession = 1
        //ReplayingOne.SessionNumber = ReplayingOne.applicationDelegate.fileNameDictionary[current] as! [Int]
        // past date is the same as today
        if (pastdate == current){
            ReplayingOne.SessionNumberForFiveHour = ReplayingOne.applicationDelegate.fileNameDictionary[pastdate] as! [Int]
            var last = ReplayingOne.SessionNumberForFiveHour.count - 1
            if (last == 0){
                print("no recording last three hour")
            }else{
                //has at least one folder, the last one is "current-last"
                //several session folders, at least one folder
                //for i in (1...last).reversed(){
                while(last > 0){
                    //iterate from last to first
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(last)
                    let jsonFilePath = Stringfilepath + "/" + "test.json"
                    //josnfile path
                    //let URLfilepath = NSURL(string : Stringfilepath)
                    do{
                        //into the folder
                        let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePath)
                        let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePath)
                        print(timeOfStart)
                        //read out the start time
                        //2019-2-25-16:05:57
                        //compare with past time
                        //
                        let hourOfStartTime = ReturnHour(str: timeOfStart)
                        let hourOfPastTime = ReturnHour(str: pasttime)
                        if (hourOfStartTime > hourOfPastTime){
                            //current time is 16, past time is 13, if start time is before past time, then check end of time
                            //start is 14
                            let hourOfEndTime = ReturnHour(str: timeOfEnd)
                            //end is 14
                            // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                            if (hourOfEndTime <= hourOfPastTime ){
                                //not recording
                                break
                            }
                            else {
                                //start time < past time < end time, the recording is in this period of time
                                //read screenshot
                                //need to code
                                do {
                                    let tempURL = NSURL(string: Stringfilepath)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            if (DealWithScreenShotName(str : lalala[k].0) >= hourOfPastTime) {
                                                let temp = Stringfilepath + "/" + lalala[k].0
                                                tem.append(temp)
                                            }
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                
                            }
                            last -= 1
                        }else if (hourOfStartTime == hourOfPastTime){
                            //read all photo out in this json file
                            do {
                                let tempURL = NSURL(string: Stringfilepath)
                                let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                let lalala = tempFileList.map { url in
                                    (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                    }
                                    .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                let count = lalala.count
                                let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                let number = filelist.count
                                var tem = [String]()
                                for k in 0..<count{
                                    if lalala[k].0.contains(".jpg"){
                                        let temp = Stringfilepath + "/" + lalala[k].0
                                        //means it is a photo, instead of a json file
                                        tem.append(temp)
                                    }
                                }
                                var reverse : [String] = Array(tem.reversed())
                                PhotoNameArray += reverse
                            } catch {
                                print(error)
                            }
                            break
                            
                        }else{
                            //hour of start time > past time
                            // go to previous file to read again
                            last -= 1
                        }
                        
                    }catch{
                        print(error)
                    }
                    //last -= 1
                    //end of the while loop
                }
            }
            
        }
            // past date is yesterday
            // go to yesterday
        else{
            ReplayingOne.SessionNumberForToday = ReplayingOne.applicationDelegate.fileNameDictionary[current] as! [Int]
            let lengthoftoday = ReplayingOne.SessionNumberForToday.count
            if (!fileManager.fileExists(atPath: Defaultpath().absoluteString + current + "-" + String(Initialsession))){
                print("today, you have not started recording")
            }
            //let first = 1
            
            let lastoftoday = lengthoftoday - 1
            // last = 4
            if (lastoftoday == 0){
                print("no recording last three hour")
            }else{
                for i in 1...lastoftoday{
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(i)
                    //let URLfilepath = NSURL(string : Stringfilepath)
                    do {
                        let tempURL = NSURL(string: Stringfilepath)
                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                        let lalala = tempFileList.map { url in
                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                            }
                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                        let count = lalala.count
                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                        let number = filelist.count
                        //filelist contain all names of the file in this folder
                        var tem = [String]()
                        for k in 0..<count{
                            if lalala[k].0.contains(".jpg"){
                                let temp = Stringfilepath + "/" + lalala[k].0
                                //means it is a photo, instead of a json file
                                tem.append(temp)
                            }
                        }
                        var reverse : [String] = Array(tem.reversed())
                        PhotoNameArray += reverse
                        //PhotoNameArray contains file path + file name
                    } catch {
                        print(error)
                    }
                }
            }
            
            //second psrt: yesterday
            print(yesterday)
            if ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] == nil{
                return PhotoNameArray.reversed() as [String]
            }
            else{
                ReplayingOne.SessionNumberForYesterday = ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] as! [Int]
                let lengthofyesterday = ReplayingOne.SessionNumberForYesterday.count
                var lastofyesterday = lengthofyesterday - 1
                if (lastofyesterday == 0){
                    print("no recording yesterday in these eight hours")
                }else{
                    //has at least one folder, the last one is "current-last"
                    //several session folders, at least one folder
                    //for i in (1...last).reversed(){
                    while(lastofyesterday > 0){
                        //iterate from last to first
                        let Stringfilepathofyesterday = Defaultpath().absoluteString + yesterday + "-" + String(lastofyesterday)
                        let jsonFilePathofyesterday = Stringfilepathofyesterday + "/" + "test.json"
                        //josnfile path
                        //let URLfilepath = NSURL(string : Stringfilepath)
                        do{
                            //into the folder
                            let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePathofyesterday)
                            let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePathofyesterday)
                            //print(timeOfStart)
                            //read out the start time
                            //2019-2-25-16:05:57
                            //compare with past time
                            //
                            let hourOfStartTime = ReturnHour(str: timeOfStart)
                            let hourOfPastTime = ReturnHour(str: pasttime)
                            if (hourOfStartTime > hourOfPastTime){
                                //current time is 14, past time is 11, start time is before past time, then check end of time
                                let hourOfEndTime = ReturnHour(str: timeOfEnd)
                                // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                                if (hourOfEndTime <= hourOfPastTime ){
                                    //not recording
                                    break
                                }
                                else {
                                    //start time < past time < end time, the recording is in this period of time
                                    //read screenshot
                                    //need to code
                                    do {
                                        let tempURL = NSURL(string: Stringfilepathofyesterday)
                                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                        let lalala = tempFileList.map { url in
                                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                            }
                                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                        let count = lalala.count
                                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                        let number = filelist.count
                                        var tem = [String]()
                                        for k in 0..<count{
                                            if lalala[k].0.contains(".jpg"){
                                                if (DealWithScreenShotName(str : lalala[k].0) >= hourOfPastTime) {
                                                    let temp = Stringfilepathofyesterday + "/" + lalala[k].0
                                                    tem.append(temp)
                                                }
                                            }
                                        }
                                        var reverse : [String] = Array(tem.reversed())
                                        PhotoNameArray += reverse
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                                lastofyesterday -= 1
                            }else if (hourOfStartTime == hourOfPastTime){
                                //read all photo out in this json file
                                do {
                                    let tempURL = NSURL(string: Stringfilepathofyesterday)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            let temp = Stringfilepathofyesterday + "/" + lalala[k].0
                                            //means it is a photo, instead of a json file
                                            tem.append(temp)
                                            //PhotoNameArray.append(temp)
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                break
                                
                            }else{
                                //hour of start time > past time
                                // go to previous file to read again
                                lastofyesterday -= 1
                            }
                            
                        }catch{
                            print(error)
                        }
                        //last -= 1
                        //end of the while loop
                    }
                }
            }
            
        }
        //if it doesnot exist, go to previous day
        
        return PhotoNameArray.reversed() as [String]
    }
    
    // fetch all screenshots from the last 8 hours
    func FetchEightHours() -> Array<Any>{
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        let fileManager = FileManager.default
        let yesterday = GetYesterdayDate(date : date, Day : 1)
        let pastdate = GetDateOfPastTime(date : date, Hour : 8)
        let pasttime = GetTimeOfPastTime(date: date, Hour: 8)
        print("here")
        print(pasttime)
        let currentTime = GetTimeOfCurrentTime(date : date)
        //print("in fetch 8 hour function")
        let Initialsession = 1
        // past date is the same as today
        if (pastdate == current){
            ReplayingOne.SessionNumberForEightHour = ReplayingOne.applicationDelegate.fileNameDictionary[pastdate] as! [Int]
            var last = ReplayingOne.SessionNumberForEightHour.count - 1
            if (last == 0){
                print("no recording last three hour")
            }else{
                //has at least one folder, the last one is "current-last"
                //several session folders, at least one folder
                //for i in (1...last).reversed(){
                while(last > 0){
                    //iterate from last to first
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(last)
                    let jsonFilePath = Stringfilepath + "/" + "test.json"
                    //josnfile path
                    do{
                        //into the folder
                        let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePath)
                        let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePath)
                        print(timeOfStart)
                        //read out the start time
                        //2019-2-25-16:05:57
                        //compare with past time
                        //
                        let hourOfStartTime = ReturnHour(str: timeOfStart)
                        let hourOfPastTime = ReturnHour(str: pasttime)
                        if (hourOfStartTime > hourOfPastTime){
                            //current time is 16, past time is 13, if start time is before past time, then check end of time
                            //start is 14
                            let hourOfEndTime = ReturnHour(str: timeOfEnd)
                            //end is 14
                            // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                            if (hourOfEndTime <= hourOfPastTime ){
                                //not recording
                                break
                            }
                            else {
                                //start time < past time < end time, the recording is in this period of time
                                //read screenshot
                                //need to code
                                do {
                                    let tempURL = NSURL(string: Stringfilepath)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            if (DealWithScreenShotName(str : lalala[k].0) >= hourOfPastTime) {
                                                let temp = Stringfilepath + "/" + lalala[k].0
                                                tem.append(temp)
                                            }
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                
                            }
                            last -= 1
                        }else if (hourOfStartTime == hourOfPastTime){
                            //read all photo out in this json file
                            do {
                                let tempURL = NSURL(string: Stringfilepath)
                                let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                let lalala = tempFileList.map { url in
                                    (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                    }
                                    .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                let count = lalala.count
                                let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                let number = filelist.count
                                var tem = [String]()
                                for k in 0..<count{
                                    if lalala[k].0.contains(".jpg"){
                                        let temp = Stringfilepath + "/" + lalala[k].0
                                        //means it is a photo, instead of a json file
                                        tem.append(temp)
                                    }
                                }
                                var reverse : [String] = Array(tem.reversed())
                                PhotoNameArray += reverse
                            } catch {
                                print(error)
                            }
                            break
                            
                        }else{
                            //hour of start time > past time
                            // go to previous file to read again
                            last -= 1
                        }
                        
                    }catch{
                        print(error)
                    }
                    //last -= 1
                    //end of the while loop
                }
            }
            
        }
            // past date is yesterday
            // go to yesterday
        else{
            ReplayingOne.SessionNumberForToday = ReplayingOne.applicationDelegate.fileNameDictionary[current] as! [Int]
            let lengthoftoday = ReplayingOne.SessionNumberForToday.count
            if (!fileManager.fileExists(atPath: Defaultpath().absoluteString + current + "-" + String(Initialsession))){
                print("today, you have not started recording")
            }
            //let first = 1
            
            let lastoftoday = lengthoftoday - 1
            // last = 4
            if (lastoftoday == 0){
                print("no recording last three hour")
            }else{
                for i in 1...lastoftoday{
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(i)
                    do {
                        let tempURL = NSURL(string: Stringfilepath)
                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                        let lalala = tempFileList.map { url in
                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                            }
                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                        let count = lalala.count
                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                        let number = filelist.count
                        //filelist contain all names of the file in this folder
                        var tem = [String]()
                        for k in 0..<count{
                            if lalala[k].0.contains(".jpg"){
                                let temp = Stringfilepath + "/" + lalala[k].0
                                //means it is a photo, instead of a json file
                                tem.append(temp)
                            }
                        }
                        var reverse : [String] = Array(tem.reversed())
                        PhotoNameArray += reverse
                        //PhotoNameArray contains file path + file name
                    } catch {
                        print(error)
                    }
                }
            }
            
            //second part: yesterday
            print(yesterday)
            if ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] == nil{
                return PhotoNameArray.reversed() as [String]
            }
            else{
                ReplayingOne.SessionNumberForYesterday = ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] as! [Int]
                let lengthofyesterday = ReplayingOne.SessionNumberForYesterday.count
                var lastofyesterday = lengthofyesterday - 1
                if (lastofyesterday == 0){
                    print("no recording yesterday in these eight hours")
                }else{
                    //has at least one folder, the last one is "current-last"
                    //several session folders, at least one folder
                    //for i in (1...last).reversed(){
                    while(lastofyesterday > 0){
                        //iterate from last to first
                        let Stringfilepathofyesterday = Defaultpath().absoluteString + yesterday + "-" + String(lastofyesterday)
                        let jsonFilePathofyesterday = Stringfilepathofyesterday + "/" + "test.json"
                        //josnfile path
                        //let URLfilepath = NSURL(string : Stringfilepath)
                        do{
                            //into the folder
                            let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePathofyesterday)
                            let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePathofyesterday)
                            //print(timeOfStart)
                            //read out the start time
                            //2019-2-25-16:05:57
                            //compare with past time
                            //
                            let hourOfStartTime = ReturnHour(str: timeOfStart)
                            let hourOfPastTime = ReturnHour(str: pasttime)
                            if (hourOfStartTime > hourOfPastTime){
                                //current time is 14, past time is 11, start time is before past time, then check end of time
                                let hourOfEndTime = ReturnHour(str: timeOfEnd)
                                // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                                if (hourOfEndTime <= hourOfPastTime ){
                                    //not recording
                                    break
                                }
                                else {
                                    //start time < past time < end time, the recording is in this period of time
                                    //read screenshot
                                    //need to code
                                    do {
                                        let tempURL = NSURL(string: Stringfilepathofyesterday)
                                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                        let lalala = tempFileList.map { url in
                                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                            }
                                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                        let count = lalala.count
                                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                        let number = filelist.count
                                        var tem = [String]()
                                        //filelist[j]
                                        for k in 0..<count{
                                            if lalala[k].0.contains(".jpg"){
                                                if (DealWithScreenShotName(str : lalala[k].0) >= hourOfPastTime) {
                                                    let temp = Stringfilepathofyesterday + "/" + lalala[k].0
                                                    tem.append(temp)
                                                }
                                            }
                                        }
                                        var reverse : [String] = Array(tem.reversed())
                                        PhotoNameArray += reverse
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                                lastofyesterday -= 1
                            }else if (hourOfStartTime == hourOfPastTime){
                                //read all photo out in this json file
                                do {
                                    let tempURL = NSURL(string: Stringfilepathofyesterday)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            let temp = Stringfilepathofyesterday + "/" + lalala[k].0
                                            //means it is a photo, instead of a json file
                                            tem.append(temp)
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                break
                                
                            }else{
                                //hour of start time > past time
                                // go to previous file to read again
                                lastofyesterday -= 1
                            }
                            
                        }catch{
                            print(error)
                        }
                        //last -= 1
                        //end of the while loop
                    }
                }
            }
            
        }
        //if it doesnot exist, go to previous day
        
        return PhotoNameArray.reversed() as [String]
    }
    //end of 8 hours
    
    // fetch last 24 hours for all recorded screenshots
    func Fetch24Hours() -> Array<Any>{
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        let fileManager = FileManager.default
        let yesterday = GetYesterdayDate(date : date, Day : 1)
        let pastdate = GetDateOfPastTime(date : date, Hour : 24)
        let pasttime = GetTimeOfPastTime(date: date, Hour: 24)
        let currentTime = GetTimeOfCurrentTime(date : date)
        //print("in fetch 24 hours function")
        let Initialsession = 1
        // past date is the same as today
        if (pastdate == current){
            ReplayingOne.SessionNumberFor24Hour = ReplayingOne.applicationDelegate.fileNameDictionary[pastdate] as! [Int]
            var last = ReplayingOne.SessionNumberFor24Hour.count - 1
            if (last == 0){
                print("no recording last three hour")
            }else{
                //has at least one folder, the last one is "current-last"
                //several session folders, at least one folder
                //for i in (1...last).reversed(){
                while(last > 0){
                    //iterate from last to first
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(last)
                    let jsonFilePath = Stringfilepath + "/" + "test.json"
                    //josnfile path
                    //let URLfilepath = NSURL(string : Stringfilepath)
                    do{
                        //into the folder
                        let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePath)
                        let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePath)
                        print(timeOfStart)
                        //read out the start time
                        //2019-2-25-16:05:57
                        //compare with past time
                        //
                        let hourOfStartTime = ReturnHour(str: timeOfStart)
                        let hourOfPastTime = ReturnHour(str: pasttime)
                        if (hourOfStartTime > hourOfPastTime){
                            //current time is 14, past time is 11, start time is before past time, then check end of time
                            let hourOfEndTime = ReturnHour(str: timeOfEnd)
                            // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                            if (hourOfEndTime <= hourOfPastTime ){
                                //not recording
                                break
                            }
                            else {
                                //start time < past time < end time, the recording is in this period of time
                                //read screenshot
                                //need to code
                                do {
                                    let tempURL = NSURL(string: Stringfilepath)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            if (DealWithScreenShotName(str : lalala[k].0) >= hourOfPastTime) {
                                                let temp = Stringfilepath + "/" + lalala[k].0
                                                tem.append(temp)
                                            }
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                
                            }
                            last -= 1
                        }else if (hourOfStartTime == hourOfPastTime){
                            //read all photo out in this json file
                            do {
                                let tempURL = NSURL(string: Stringfilepath)
                                let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                let lalala = tempFileList.map { url in
                                    (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                    }
                                    .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                let count = lalala.count
                                let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                let number = filelist.count
                                var tem = [String]()
                                for k in 0..<count{
                                    if lalala[k].0.contains(".jpg"){
                                        let temp = Stringfilepath + "/" + lalala[k].0
                                        //means it is a photo, instead of a json file
                                        tem.append(temp)
                                    }
                                }
                                var reverse : [String] = Array(tem.reversed())
                                PhotoNameArray += reverse
                            } catch {
                                print(error)
                            }
                            break
                            
                        }else{
                            //hour of start time > past time
                            // go to previous file to read again
                            last -= 1
                        }
                        
                    }catch{
                        print(error)
                    }
                    //last -= 1
                    //end of the while loop
                }
            }
            
        }
            // past date is yesterday
            // go to yesterday
        else{
            //code here
            //check yesterday and today
            //first part: today
            ReplayingOne.SessionNumberForToday = ReplayingOne.applicationDelegate.fileNameDictionary[current] as! [Int]
            let lengthoftoday = ReplayingOne.SessionNumberForToday.count
            if (!fileManager.fileExists(atPath: Defaultpath().absoluteString + current + "-" + String(Initialsession))){
                print("today, you have not started recording")
            }
            //let first = 1
            
            let lastoftoday = lengthoftoday - 1
            // last = 4
            if (lastoftoday == 0){
                print("no recording last three hour")
            }else{
                for i in 1...lastoftoday{
                    let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(i)
                    //let URLfilepath = NSURL(string : Stringfilepath)
                    do {
                        let tempURL = NSURL(string: Stringfilepath)
                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                        let lalala = tempFileList.map { url in
                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                            }
                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                        let count = lalala.count
                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                        let number = filelist.count
                        //filelist contain all names of the file in this folder
                        var tem = [String]()
                        for k in 0..<count{
                            if lalala[k].0.contains(".jpg"){
                                let temp = Stringfilepath + "/" + lalala[k].0
                                //means it is a photo, instead of a json file
                                tem.append(temp)
                            }
                        }
                        var reverse : [String] = Array(tem.reversed())
                        PhotoNameArray += reverse
                        //PhotoNameArray contains file path + file name
                    } catch {
                        print(error)
                    }
                }
            }
            //second part: yesterday
            print(yesterday)
            if ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] == nil {
                return PhotoNameArray.reversed() as [String]
            }
            else{
                ReplayingOne.SessionNumberForYesterday = ReplayingOne.applicationDelegate.fileNameDictionary[yesterday] as! [Int]
                let lengthofyesterday = ReplayingOne.SessionNumberForYesterday.count
                var lastofyesterday = lengthofyesterday - 1
                if (lastofyesterday == 0){
                    print("no recording yesterday in these eight hours")
                }else{
                    //has at least one folder, the last one is "current-last"
                    //several session folders, at least one folder
                    //for i in (1...last).reversed(){
                    while(lastofyesterday > 0){
                        //iterate from last to first
                        let Stringfilepathofyesterday = Defaultpath().absoluteString + yesterday + "-" + String(lastofyesterday)
                        let jsonFilePathofyesterday = Stringfilepathofyesterday + "/" + "test.json"
                        //josnfile path
                        //let URLfilepath = NSURL(string : Stringfilepath)
                        do{
                            //into the folder
                            let timeOfStart = BasedonJsonFilePathReadStartTime(jsonpath : jsonFilePathofyesterday)
                            let timeOfEnd = BasedonJsonFilePathReadEndTime(jsonpath : jsonFilePathofyesterday)
                            //print(timeOfStart)
                            //read out the start time
                            //2019-2-25-16:05:57
                            //compare with past time
                            //
                            let hourOfStartTime = ReturnHour(str: timeOfStart)
                            let hourOfPastTime = ReturnHour(str: pasttime)
                            if (hourOfStartTime > hourOfPastTime){
                                //current time is 14, past time is 11, start time is before past time, then check end of time
                                let hourOfEndTime = ReturnHour(str: timeOfEnd)
                                // this if statement is impossible, because psttime< starttime, starttime< end time, so end time must > pasttime
                                if (hourOfEndTime <= hourOfPastTime ){
                                    //not recording
                                    break
                                }
                                else {
                                    //start time < past time < end time, the recording is in this period of time
                                    //read screenshot
                                    //need to code
                                    do {
                                        let tempURL = NSURL(string: Stringfilepathofyesterday)
                                        let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                        let lalala = tempFileList.map { url in
                                            (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                            }
                                            .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                        let count = lalala.count
                                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                        let number = filelist.count
                                        var tem = [String]()
                                        for k in 0..<count{
                                            if lalala[k].0.contains(".jpg"){
                                                if (DealWithScreenShotName(str : lalala[k].0) >= hourOfPastTime) {
                                                    let temp = Stringfilepathofyesterday + "/" + lalala[k].0
                                                    tem.append(temp)
                                                    //PhotoNameArray.append(temp)
                                                }
                                            }
                                        }
                                        var reverse : [String] = Array(tem.reversed())
                                        PhotoNameArray += reverse
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                                lastofyesterday -= 1
                            }else if (hourOfStartTime == hourOfPastTime){
                                //read all photo out in this json file
                                do {
                                    let tempURL = NSURL(string: Stringfilepathofyesterday)
                                    let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                                    let lalala = tempFileList.map { url in
                                        (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                        }
                                        .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                                    let count = lalala.count
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for k in 0..<count{
                                        if lalala[k].0.contains(".jpg"){
                                            let temp = Stringfilepathofyesterday + "/" + lalala[k].0
                                            //means it is a photo, instead of a json file
                                            tem.append(temp)
                                        }
                                    }
                                    var reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                break
                                
                            }else{
                                //hour of start time > past time
                                // go to previous file to read again
                                lastofyesterday -= 1
                            }
                            
                        }catch{
                            print(error)
                        }
                        //last -= 1
                        //end of the while loop
                    }
                }
            }
            
            
        }
        //if it doesnot exist, go to previous day
        
        return PhotoNameArray.reversed() as [String]
    }
    
    // get all recordings from last three days
    func FetchThreeday() -> Array<Any> {
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        let fileManager = FileManager.default
        let pastdate = GetDateOfPastTime(date : date, Hour : 8)
        let pasttime = GetTimeOfPastTime(date: date, Hour: 8)
        let currentTime = GetTimeOfCurrentTime(date : date)
        //print("in fetch 3 days recordings function")
        
        let Initialsession = 1
        for i in 0..<3{
            let theDate = GetYesterdayDate(date: date, Day: i)
            var SessionNumberForDays = [Int]()
            var cur = [String]()
            //0,1,2 today, yesterday, and the day before yesterday
            if ReplayingOne.applicationDelegate.fileNameDictionary[theDate] == nil{
                continue
            }
            else{
                SessionNumberForDays = ReplayingOne.applicationDelegate.fileNameDictionary[theDate] as! [Int]
                let length = SessionNumberForDays.count
                if (length == 0){
                    let string = "the day of " + theDate + "is empty"
                    print(string)
                }
                else{
                    for j in 1..<length{
                        var tem = [String]()
                        let Stringfilepath = Defaultpath().absoluteString + theDate + "-" + String(j)
                        do {
                            let tempURL = NSURL(string: Stringfilepath)
                            let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                            let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                            let lalala = tempFileList.map { url in
                                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                }
                                .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                            let count = lalala.count
                            
                            for k in 0..<count{
                                if lalala[k].0.contains(".jpg"){
                                    print(lalala[k])
                                    let temp = Stringfilepath + "/" + lalala[k].0
                                    tem.append(temp)
                                }
                            }
                        } catch {
                            print(error)
                        }
                        cur += tem
                    }
                }
            }
            PhotoNameArray += cur.reversed()
            
        }
        
        return PhotoNameArray.reversed() as [String]
    }
    
    // function to fetch last 5 days' recordings and screenshots
    func FetchFiveday() -> Array<Any> {
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        //let current = String(year) + "-" + String(month) + "-" + String(day)
        let fileManager = FileManager.default

        let currentTime = GetTimeOfCurrentTime(date : date)
        //print("in fetch 5 days function")
        
        let Initialsession = 1
        for i in 0..<5{
            let theDate = GetYesterdayDate(date: date, Day: i)
            var SessionNumberForDays = [Int]()
            var cur = [String]()
            //0,1,2 today, yesterday, and the day before yesterday
            if ReplayingOne.applicationDelegate.fileNameDictionary[theDate] == nil{
                continue
            }
            else{
                SessionNumberForDays = ReplayingOne.applicationDelegate.fileNameDictionary[theDate] as! [Int]
                let length = SessionNumberForDays.count
                if (length == 0){
                    let string = "the day of " + theDate + "is empty"
                    print(string)
                }
                else{
                    for j in 1..<length{
                        var tem = [String]()
                        let Stringfilepath = Defaultpath().absoluteString + theDate + "-" + String(j)
                        do {
                            let tempURL = NSURL(string: Stringfilepath)
                            let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                            let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                            
                            let lalala = tempFileList.map { url in
                                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                }
                                .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                            let count = lalala.count
                            print(count)
                            
                            for k in 0..<count{
                                if lalala[k].0.contains(".jpg"){
                                    print(lalala[k])
                                    let temp = Stringfilepath + "/" + lalala[k].0
                                    tem.append(temp)
                                }
                            }
                        } catch {
                            print(error)
                        }
                        cur += tem
                    }
                }
                PhotoNameArray += cur.reversed()
            }
          
        }
        
        return PhotoNameArray.reversed() as[String]
    }
    
    // get last 7 days' recordings and screenshots
    func FetchSevenday() -> Array<Any>{
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let fileManager = FileManager.default
        let currentTime = GetTimeOfCurrentTime(date : date)
        //print("in fetch 7 days function")
        
        let Initialsession = 1
        for i in 0..<7{
            let theDate = GetYesterdayDate(date: date, Day: i)
            var SessionNumberForDays = [Int]()
            var cur = [String]()
            //0,1,2 today, yesterday, and the day before yesterday
            if ReplayingOne.applicationDelegate.fileNameDictionary[theDate] == nil{
                continue
            }
            else{
                SessionNumberForDays = ReplayingOne.applicationDelegate.fileNameDictionary[theDate] as! [Int]
                let length = SessionNumberForDays.count
                
                if (length == 0){
                    let string = "the day of " + theDate + "is empty"
                    print(string)
                }
                else{
                    
                    for j in 1..<length{
                        var tem = [String]()
                        let Stringfilepath = Defaultpath().absoluteString + theDate + "-" + String(j)
                        do {
                            
                            let tempURL = NSURL(string: Stringfilepath)
                            let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                            let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                            let lalala = tempFileList.map { url in
                                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                }
                                .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                            let count = lalala.count
                            for k in 0..<count{
                                if lalala[k].0.contains(".jpg"){
                                    print(lalala[k])
                                    let temp = Stringfilepath + "/" + lalala[k].0
                                    tem.append(temp)
                                }
                            }

                        } catch {
                            print(error)
                        }
                        cur += tem

                    }
                }
            }
            PhotoNameArray += cur.reversed()
        }//end of for loop
        
        return PhotoNameArray.reversed() as [String]
    }
    
    // get the current time
    //useless, change to following two functions
    func PastTimeFewHoursAgo( valueOfHour : Int) -> String {
        _ = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempHourValue = (-1) * valueOfHour
        let tempdate = Calendar.current.date(byAdding: .hour, value: tempHourValue, to: Date())
        let dateString = dateFormatter.string(from: tempdate!)
        //5:06:52 PM
        dateFormatter.dateFormat = "h:mm:ss a"
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "MM.dd, HH:mm:ss"
        //hour, minute, and second
        //dateFormatter.dateFormat = "HH"
        let date24 = dateFormatter.string(from: final!)
        return date24
    }
    
    //
    func GetDateSeveralDaysAgo(day : Int) -> Array<String>{
        var arrayOfDay = [String]()
        for i in 0..<day{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.medium
            let temp = (-1) * i
            let tempdate = Calendar.current.date(byAdding: .day, value: temp, to: Date())
            var dateString = dateFormatter.string(from: tempdate!)
            //dateFormatter.dateFormat = "h:mm:ss a"
            let final = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "yyyy-M-d"
            let date24 = dateFormatter.string(from: final!)
            arrayOfDay.append(date24)
        }
        return arrayOfDay
    }
    
    func GetYesterdayDate(date : Date, Day : Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempDayValue = (-1) * Day
        let tempdate = Calendar.current.date(byAdding: .day, value: tempDayValue, to: Date())
        var dateString = dateFormatter.string(from: tempdate!)
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d"
        let date24 = dateFormatter.string(from: final!)
        return date24
    }
    
    // get the time of severl hours ago
    func GetDateOfPastTime( date : Date, Hour : Int) -> String {

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempHourValue = (-1) * Hour
        let tempdate = Calendar.current.date(byAdding: .hour, value: tempHourValue, to: Date())
        var dateString = dateFormatter.string(from: tempdate!)
        //dateFormatter.dateFormat = "h:mm:ss a"
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d"
        let date24 = dateFormatter.string(from: final!)
        //print(date24)
        return date24
    }
    
    
    //get the time of past, several hours ago
    func GetTimeOfPastTime( date : Date, Hour : Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempHourValue = (-1) * Hour
        let tempdate = Calendar.current.date(byAdding: .hour, value: tempHourValue, to: Date())
        let dateString = dateFormatter.string(from: tempdate!)
        //dateFormatter.dateFormat = "h:mm:ss a"
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d-HH:mm:ss"
        let date24 = dateFormatter.string(from: final!)
        return date24
    }
    
    // get the time of the current time
    func GetTimeOfCurrentTime( date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempdate = Calendar.current.date(byAdding: .hour, value: 0, to: Date())
        let dateString = dateFormatter.string(from: tempdate!)
        //dateFormatter.dateFormat = "h:mm:ss a"
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d-HH:mm:ss"
        let date24 = dateFormatter.string(from: final!)
        return date24
    }
    
    //based on json file path to get start time as string
    func BasedonJsonFilePathReadStartTime(jsonpath : String) -> String{
        let rawData : NSData = try! NSData(contentsOf: URL(fileURLWithPath: jsonpath))
        var startTime = ""
        do{
            let jsonDataDictionary = try JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
            startTime = dictionaryOfReturnedJsonData["StartTime"] as! String

        }catch{print(error)}
        return startTime
    }
    
    // based on json file path to read the end time
    func BasedonJsonFilePathReadEndTime(jsonpath : String) -> String{
        let rawData : NSData = try! NSData(contentsOf: URL(fileURLWithPath: jsonpath))
        var endTime = ""
        do{
            let jsonDataDictionary = try JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
            
            endTime = dictionaryOfReturnedJsonData["EndTime"] as! String
            
            
        }catch{print(error)}
        return endTime
    }
    
    // return the hour
    func ReturnHour(str : String) -> Int{
        //print(str)
        let start = str.index(str.startIndex, offsetBy: 10)
        let end = str.index(str.endIndex, offsetBy: -6)
        let range = start..<end
        let mySubstring = str[range]
        print(mySubstring)
        return Int(mySubstring)!
    }
    
    
    // return the minute
    func ReturnMinute(str : String) -> Int{
        print(str)
        let start = str.index(str.startIndex, offsetBy: 13)
        let end = str.index(str.endIndex, offsetBy: -3)
        let range = start..<end
        let mySubstring = str[range]
        print(mySubstring)
        return Int(mySubstring)!
    }
    
    // handle screenshot name
    // hardcoded, because now we have a formatted name of screenshot
    func DealWithScreenShotName(str : String) -> Int{
        print(str)
        let start = str.index(str.startIndex, offsetBy: 17)
        let end = str.index(str.endIndex, offsetBy: -10)
        let range = start..<end
        let mySubstring = str[range]
        print(mySubstring)
        return Int(mySubstring)!
    }
    
    // sort files by date
    func fileSortByDate(filepath : URL) -> [String]?{
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if let urlArray = try? FileManager.default.contentsOfDirectory(at: filepath,
                                                                       includingPropertiesForKeys: [.contentModificationDateKey],
                                                                       options:.skipsHiddenFiles)
        {
            
            return urlArray.map { url in
                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? Date.distantPast)
                }
                .sorted(by: { $0.1 > $1.1 }) // sort descending modification dates
                .map { $0.0 } // extract file names
            
        }
        else{
            return nil
        }
    }
    
    
    // get the screeenshots recorded on some day
    // now, we are using this method as the main function by selecting the data
    func FetchSomeday(SomeDay : String) -> Array<Any>{
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        let currentTime = GetTimeOfCurrentTime(date : date)
        let Initialsession = 1
        for i in 0..<1{
            //let theDate = GetYesterdayDate(date: date, Day: i)
            var SessionNumberForDays = [Int]()
            var cur = [String]()
            //0,1,2 today, yesterday, and the day before yesterday
            if ReplayingOne.applicationDelegate.fileNameDictionary[SomeDay] == nil{
                continue
            }
            else{
                SessionNumberForDays = ReplayingOne.applicationDelegate.fileNameDictionary[SomeDay] as! [Int]
                let length = SessionNumberForDays.count
                
                if (length == 0){
                    let string = "the day of " + SomeDay + "is empty"
                    print(string)
                }
                else{
                    
                    for j in 1..<length{
                        var tem = [String]()
                        let Stringfilepath = Defaultpath().absoluteString + SomeDay + "-" + String(j)
                        do {
                            
                            let tempURL = NSURL(string: Stringfilepath)
                            let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                            let tempFileList = try FileManager.default.contentsOfDirectory(at: tempURL! as URL, includingPropertiesForKeys: [.creationDateKey], options: .skipsHiddenFiles)
                            let lalala = tempFileList.map { url in
                                (url.lastPathComponent, (try? url.resourceValues(forKeys: [.creationDateKey]))?.creationDate ?? Date.distantPast)
                                }
                                .sorted(by: { $1.1 > $0.1 }) // sort descending modification dates
                            let count = lalala.count
                            for k in 0..<count{
                                if lalala[k].0.contains(".jpg"){
                                    print(lalala[k])
                                    let temp = Stringfilepath + "/" + lalala[k].0
                                    tem.append(temp)
                                }
                            }
                        } catch {
                            print(error)
                        }
                        cur += tem

                    }
                }
            }
            PhotoNameArray += cur.reversed()
        }//end of for loop
        
        return PhotoNameArray.reversed() as [String]
    }
    
    
    
    //end of the class
}
