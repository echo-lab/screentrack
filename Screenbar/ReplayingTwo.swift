//
//  ReplayingTwo.swift
//  Screenbar
//
//  Created by Donghan Hu on 3/18/19.
//

import Foundation
import Cocoa
import CoreImage


@available(OSX 10.13, *)

class ReplayingMethodTwo: NSViewController{
    
    
    static let applicationDelegate: AppDelegate = NSApplication.shared().delegate as! AppDelegate
    static let applocationDelegateTemp : AppDelegate = NSApplication.shared().delegate as! AppDelegate
    static var SessionNumber = [Int]()
    static var SessionNumberForOneHour = [Int]()
    static var SessionNumberForThreeHour = [Int]()
    static var SessionNumberForEightHour = [Int]()
    static var SessionNumberForFiveHour = [Int]()
    static var SessionNumberFor24Hour = [Int]()
    static var SessionNumberForToday = [Int]()
    static var SessionNumberForYesterday = [Int]()
    
    
    //
    func FetchPhotoToday() -> Dictionary<String, Int>{
        var dictionaryTemp = [String: Int]()
        let Defaultpath = Settings.DefaultFolder
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        let Initialsession = 1
        ReplayingMethodTwo.SessionNumber = ReplayingMethodTwo.applicationDelegate.fileNameDictionary[current] as! [Int]
        let length = ReplayingMethodTwo.SessionNumber.count
        var PhotoNameArray = [String]()
        let fileManager = FileManager.default
        let temppath = Defaultpath().absoluteString + current + "-" + String(Initialsession)
        if (!fileManager.fileExists(atPath: Defaultpath().absoluteString + current + "-" + String(Initialsession))){
            print("today, you have not started recording")
        }
        let last = length - 1
        if last == 0{
            print("no recording today")
        }
        else {
            for i in 1...last{
                let Stringfilepath = Defaultpath().absoluteString + current + "-" + String(i)
                let jsonFilePath = Stringfilepath + "/" + "test.json"
                let URLfilepath = NSURL(string : Stringfilepath)
                do {
                    let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePath)
                    let arrayLength = tempArray.count
                    for number in 0..<arrayLength{
                        let tempName = tempArray[number]["SoftwareName"]//anyobject
                        if tempName != nil{
                            let currentName = tempName as! String
                            if dictionaryTemp[currentName] != nil{
                                let tempValue = dictionaryTemp[currentName]
                                dictionaryTemp[currentName] = tempValue! + 1
                            }
                            else{
                                dictionaryTemp[currentName] = 1
                            }
                        }
                    }
                    
                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                    let number = filelist.count
                    for j in 0..<number{
                        if filelist[j].contains(".jpg"){
                            let temp = Stringfilepath + "/" + filelist[j]
                            PhotoNameArray.append(temp)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        let PhotoNumber = PhotoNameArray.count
        
        return dictionaryTemp
    }
    
    //
    func FetchOneHours() -> Dictionary<String, Int>{
        var dictionaryTemp = [String: Int]()
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        //var softwareNameArray = [String]()
        //var softwareNameCountArray = [Int]()
        //var dictionaryOfSoftware = [String : Int]()
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
        //let currentTime = GetTimeOfCurrentTime(date : date)
        //print(currentTime)
        //print("in fetch 3 hour function")
        let Initialsession = 1
        if (pastdate == current){
            ReplayingMethodTwo.SessionNumberForOneHour = ReplayingMethodTwo.applicationDelegate.fileNameDictionary[pastdate] as! [Int]
            var last = ReplayingMethodTwo.SessionNumberForOneHour.count - 1
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
                        //print(timeOfStart)
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
                                    let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePath)
                                    let arrayLength = tempArray.count
                                    for number in 0..<arrayLength{
                                        let tempName = tempArray[number]["SoftwareName"]//anyobject
                                        if tempName != nil{
                                            let currentName = tempName as! String
                                            if dictionaryTemp[currentName] != nil{
                                                //contian this software name already
                                                //dictionaryTemp[currentName] += 1
                                                let tempValue = dictionaryTemp[currentName]
                                                dictionaryTemp[currentName] = tempValue! + 1
                                            }
                                            else{
                                                dictionaryTemp[currentName] = 1
                                            }
                                        }
                                        //let currentName = tempArray[number]["SoftwareName"] as! String
                                    }
                                    
                                    
                                    
                                    
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for j in 0..<number{
                                        if filelist[j].contains(".jpg"){
                                            if (DealWithScreenShotName(str : filelist[j]) >= hourOfPastTime) {
                                                let temp = Stringfilepath + "/" + filelist[j]
                                                tem.append(temp)
                                                
                                                //PhotoNameArray.append(temp)
                                            }
                                        }
                                    }
                                    let reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                
                            }
                            last -= 1
                        }else if (hourOfStartTime == hourOfPastTime){
                            //read all photo out in this json file
                            do {
                                let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePath)
                                let arrayLength = tempArray.count
                                for number in 0..<arrayLength{
                                    let tempName = tempArray[number]["SoftwareName"]//anyobject
                                    if tempName != nil{
                                        let currentName = tempName as! String
                                        if dictionaryTemp[currentName] != nil{
                                            //contian this software name already
                                            //dictionaryTemp[currentName] += 1
                                            let tempValue = dictionaryTemp[currentName]
                                            dictionaryTemp[currentName] = tempValue! + 1
                                        }
                                        else{
                                            dictionaryTemp[currentName] = 1
                                        }
                                    }
                                    //let currentName = tempArray[number]["SoftwareName"] as! String
                                }
                                
                                
                                
                                
                                
                                
                                let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                let number = filelist.count
                                var tem = [String]()
                                for j in 0..<number{
                                    if filelist[j].contains(".jpg"){
                                        let temp = Stringfilepath + "/" + filelist[j]
                                        //means it is a photo, instead of a json file
                                        //PhotoNameArray.append(temp)
                                        tem.append(temp)
                                    }
                                }
                                let reverse : [String] = Array(tem.reversed())
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
            ReplayingMethodTwo.SessionNumberForToday = ReplayingMethodTwo.applicationDelegate.fileNameDictionary[current] as! [Int]
            let lengthoftoday = ReplayingMethodTwo.SessionNumberForToday.count
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
                    let jsonFilePath = Stringfilepath + "/" + "test.json"
                    //let URLfilepath = NSURL(string : Stringfilepath)
                    do {
                        let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePath)
                        let arrayLength = tempArray.count
                        for number in 0..<arrayLength{
                            let tempName = tempArray[number]["SoftwareName"]//anyobject
                            if tempName != nil{
                                let currentName = tempName as! String
                                if dictionaryTemp[currentName] != nil{
                                    //contian this software name already
                                    //dictionaryTemp[currentName] += 1
                                    let tempValue = dictionaryTemp[currentName]
                                    dictionaryTemp[currentName] = tempValue! + 1
                                }
                                else{
                                    dictionaryTemp[currentName] = 1
                                }
                            }
                            //let currentName = tempArray[number]["SoftwareName"] as! String
                        }
                        
                        
                        
                        
                        
                        
                        //filelist contain all names of the file in this folder
                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                        let number = filelist.count
                        var tem = [String]()
                        for j in 0..<number{
                            if filelist[j].contains(".jpg"){
                                let temp = Stringfilepath + "/" + filelist[j]
                                //means it is a photo, instead of a json file
                                tem.append(temp)
                                //PhotoNameArray.append(temp)
                            }
                        }
                        //PhotoNameArray contains file path + file name
                        //print(PhotoNameArray)
                        let reverse : [String] = Array(tem.reversed())
                        PhotoNameArray += reverse
                    } catch {
                        print(error)
                    }
                }
            }
            //second yesterday
            //print(yesterday)
            if ReplayingMethodTwo.applicationDelegate.fileNameDictionary[yesterday] == nil{
                
                //return PhotoNameArray.reversed() as [String]
                return dictionaryTemp
            }
            else{
                ReplayingMethodTwo.SessionNumberForYesterday = ReplayingMethodTwo.applicationDelegate.fileNameDictionary[yesterday] as! [Int]
                let lengthofyesterday = ReplayingMethodTwo.SessionNumberForYesterday.count
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
                                        let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePathofyesterday)
                                        let arrayLength = tempArray.count
                                        for number in 0..<arrayLength{
                                            let tempName = tempArray[number]["SoftwareName"]//anyobject
                                            if tempName != nil{
                                                let currentName = tempName as! String
                                                if dictionaryTemp[currentName] != nil{
                                                    //contian this software name already
                                                    //dictionaryTemp[currentName] += 1
                                                    let tempValue = dictionaryTemp[currentName]
                                                    dictionaryTemp[currentName] = tempValue! + 1
                                                }
                                                else{
                                                    dictionaryTemp[currentName] = 1
                                                }
                                            }
                                            //let currentName = tempArray[number]["SoftwareName"] as! String
                                        }
                                        
                                        
                                        
                                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                        let number = filelist.count
                                        var tem = [String]()
                                        for j in 0..<number{
                                            if filelist[j].contains(".jpg"){
                                                if (DealWithScreenShotName(str : filelist[j]) >= hourOfPastTime) {
                                                    let temp = Stringfilepathofyesterday + "/" + filelist[j]
                                                    //PhotoNameArray.append(temp)
                                                    tem.append(temp)
                                                }
                                            }
                                        }
                                        let reverse : [String] = Array(tem.reversed())
                                        PhotoNameArray += reverse
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                                lastofyesterday -= 1
                            }else if (hourOfStartTime == hourOfPastTime){
                                //read all photo out in this json file
                                do {
                                    let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePathofyesterday)
                                    let arrayLength = tempArray.count
                                    for number in 0..<arrayLength{
                                        let tempName = tempArray[number]["SoftwareName"]//anyobject
                                        if tempName != nil{
                                            let currentName = tempName as! String
                                            if dictionaryTemp[currentName] != nil{
                                                //contian this software name already
                                                //dictionaryTemp[currentName] += 1
                                                let tempValue = dictionaryTemp[currentName]
                                                dictionaryTemp[currentName] = tempValue! + 1
                                            }
                                            else{
                                                dictionaryTemp[currentName] = 1
                                            }
                                        }
                                        //let currentName = tempArray[number]["SoftwareName"] as! String
                                    }
                                    
                                    
                                    
                                    
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for j in 0..<number{
                                        if filelist[j].contains(".jpg"){
                                            let temp = Stringfilepathofyesterday + "/" + filelist[j]
                                            //means it is a photo, instead of a json file
                                            //PhotoNameArray.append(temp)
                                            tem.append(temp)
                                        }
                                    }
                                    let reverse : [String] = Array(tem.reversed())
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
        
        //return PhotoNameArray.reversed() as [String]
        return dictionaryTemp
    }
    // end of function fetchPhotoOneHours()
    //
    func FetchThreeHours() -> Dictionary<String, Int>{
        var dictionaryTemp = [String: Int]()
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        //var softwareNameArray = [String]()
        //var softwareNameCountArray = [Int]()
        _ = [String : Int]()
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
        //let currentTime = GetTimeOfCurrentTime(date : date)
        //print(currentTime)
        //print("in fetch 3 hour function")
        let Initialsession = 1
        if (pastdate == current){
            ReplayingMethodTwo.SessionNumberForThreeHour = ReplayingMethodTwo.applicationDelegate.fileNameDictionary[pastdate] as! [Int]
            var last = ReplayingMethodTwo.SessionNumberForThreeHour.count - 1
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
                        //print(timeOfStart)
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
                                    let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePath)
                                    let arrayLength = tempArray.count
                                    for number in 0..<arrayLength{
                                        let tempName = tempArray[number]["SoftwareName"]//anyobject
                                        if tempName != nil{
                                            let currentName = tempName as! String
                                            if dictionaryTemp[currentName] != nil{
                                                //contian this software name already
                                                //dictionaryTemp[currentName] += 1
                                                let tempValue = dictionaryTemp[currentName]
                                                dictionaryTemp[currentName] = tempValue! + 1
                                            }
                                            else{
                                                dictionaryTemp[currentName] = 1
                                            }
                                        }
                                        //let currentName = tempArray[number]["SoftwareName"] as! String
                                    }
                                    
                                    
                                    
                                    
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for j in 0..<number{
                                        if filelist[j].contains(".jpg"){
                                            if (DealWithScreenShotName(str : filelist[j]) >= hourOfPastTime) {
                                                let temp = Stringfilepath + "/" + filelist[j]
                                                tem.append(temp)
                                                
                                                //PhotoNameArray.append(temp)
                                            }
                                        }
                                    }
                                    let reverse : [String] = Array(tem.reversed())
                                    PhotoNameArray += reverse
                                } catch {
                                    print(error)
                                }
                                
                            }
                            last -= 1
                        }else if (hourOfStartTime == hourOfPastTime){
                            //read all photo out in this json file
                            do {
                                let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePath)
                                let arrayLength = tempArray.count
                                for number in 0..<arrayLength{
                                    let currentName = tempArray[number]["SoftwareName"] as! String
                                    if dictionaryTemp[currentName] != nil{
                                        //contian this software name already
                                        //dictionaryTemp[currentName] += 1
                                        let tempValue = dictionaryTemp[currentName]
                                        dictionaryTemp[currentName] = tempValue! + 1
                                    }
                                    else{
                                        dictionaryTemp[currentName] = 1
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                                
                                let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                                let number = filelist.count
                                var tem = [String]()
                                for j in 0..<number{
                                    if filelist[j].contains(".jpg"){
                                        let temp = Stringfilepath + "/" + filelist[j]
                                        //means it is a photo, instead of a json file
                                        //PhotoNameArray.append(temp)
                                        tem.append(temp)
                                    }
                                }
                                let reverse : [String] = Array(tem.reversed())
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
            ReplayingMethodTwo.SessionNumberForToday = ReplayingMethodTwo.applicationDelegate.fileNameDictionary[current] as! [Int]
            let lengthoftoday = ReplayingMethodTwo.SessionNumberForToday.count
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
                    let jsonFilePath = Stringfilepath + "/" + "test.json"
                    //let URLfilepath = NSURL(string : Stringfilepath)
                    do {
                        let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePath)
                        let arrayLength = tempArray.count
                        for number in 0..<arrayLength{
                            let currentName = tempArray[number]["SoftwareName"] as! String
                            if dictionaryTemp[currentName] != nil{
                                //contian this software name already
                                //dictionaryTemp[currentName] += 1
                                let tempValue = dictionaryTemp[currentName]
                                dictionaryTemp[currentName] = tempValue! + 1
                            }
                            else{
                                dictionaryTemp[currentName] = 1
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                        //filelist contain all names of the file in this folder
                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                        let number = filelist.count
                        var tem = [String]()
                        for j in 0..<number{
                            if filelist[j].contains(".jpg"){
                                let temp = Stringfilepath + "/" + filelist[j]
                                //means it is a photo, instead of a json file
                                tem.append(temp)
                                //PhotoNameArray.append(temp)
                            }
                        }
                        //PhotoNameArray contains file path + file name
                        //print(PhotoNameArray)
                        let reverse : [String] = Array(tem.reversed())
                        PhotoNameArray += reverse
                    } catch {
                        print(error)
                    }
                }
            }
            //second yesterday
            //print(yesterday)
            if ReplayingMethodTwo.applicationDelegate.fileNameDictionary[yesterday] == nil{
                
                //return PhotoNameArray.reversed() as [String]
                return dictionaryTemp
            }
            else{
                ReplayingMethodTwo.SessionNumberForYesterday = ReplayingMethodTwo.applicationDelegate.fileNameDictionary[yesterday] as! [Int]
                let lengthofyesterday = ReplayingMethodTwo.SessionNumberForYesterday.count
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
                                        let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePathofyesterday)
                                        let arrayLength = tempArray.count
                                        for number in 0..<arrayLength{
                                            let currentName = tempArray[number]["SoftwareName"] as! String
                                            if dictionaryTemp[currentName] != nil{
                                                //contian this software name already
                                                //dictionaryTemp[currentName] += 1
                                                let tempValue = dictionaryTemp[currentName]
                                                dictionaryTemp[currentName] = tempValue! + 1
                                            }
                                            else{
                                                dictionaryTemp[currentName] = 1
                                            }
                                            
                                        }
                                        
                                        
                                        
                                        let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                        let number = filelist.count
                                        var tem = [String]()
                                        for j in 0..<number{
                                            if filelist[j].contains(".jpg"){
                                                if (DealWithScreenShotName(str : filelist[j]) >= hourOfPastTime) {
                                                    let temp = Stringfilepathofyesterday + "/" + filelist[j]
                                                    //PhotoNameArray.append(temp)
                                                    tem.append(temp)
                                                }
                                            }
                                        }
                                        let reverse : [String] = Array(tem.reversed())
                                        PhotoNameArray += reverse
                                    } catch {
                                        print(error)
                                    }
                                    
                                }
                                lastofyesterday -= 1
                            }else if (hourOfStartTime == hourOfPastTime){
                                //read all photo out in this json file
                                do {
                                    let tempArray = basedOnJsonFilePathReadArray(jsonpath: jsonFilePathofyesterday)
                                    let arrayLength = tempArray.count
                                    for number in 0..<arrayLength{
                                        let currentName = tempArray[number]["SoftwareName"] as! String
                                        if dictionaryTemp[currentName] != nil{
                                            //contian this software name already
                                            //dictionaryTemp[currentName] += 1
                                            let tempValue = dictionaryTemp[currentName]
                                            dictionaryTemp[currentName] = tempValue! + 1
                                        }
                                        else{
                                            dictionaryTemp[currentName] = 1
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    
                                    let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepathofyesterday)
                                    let number = filelist.count
                                    var tem = [String]()
                                    for j in 0..<number{
                                        if filelist[j].contains(".jpg"){
                                            let temp = Stringfilepathofyesterday + "/" + filelist[j]
                                            //means it is a photo, instead of a json file
                                            //PhotoNameArray.append(temp)
                                            tem.append(temp)
                                        }
                                    }
                                    let reverse : [String] = Array(tem.reversed())
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
        
        //return PhotoNameArray.reversed() as [String]
        return dictionaryTemp
    }
    // end of function fetchPhotoThreeHours()
    //
    func FetchSevenday() -> Dictionary<String, Int>{
        var dictionaryTemp = [String: Int]()
        let Defaultpath = Settings.DefaultFolder
        var PhotoNameArray = [String]()
        let date = Date()
        let calendar = Calendar.current
        _ = calendar.component(.day, from: date)
        _ = calendar.component(.month, from: date)
        _ = calendar.component(.year, from: date)
        //let current = String(year) + "-" + String(month) + "-" + String(day)
        _ = FileManager.default
        //let yesterday = GetYesterdayDate(date : date, Day : 1)
        //let pastdate = GetDateOfPastTime(date : date, Hour : 8)
        //let pasttime = GetTimeOfPastTime(date: date, Hour: 8)
        _ = GetTimeOfCurrentTime(date : date)
        //print(currentTime)
        //print("in fetch 3 hour function")
        
        let Initialsession = 1
        for i in 0..<7{
            let theDate = GetYesterdayDate(date: date, Day: i)
            var SessionNumberForDays = [Int]()
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
                        let Stringfilepath = Defaultpath().absoluteString + theDate + "-" + String(j)
                        do {
                            let currentJsonFilePath = Stringfilepath + "/" + "test.json"
                            let tempArray = basedOnJsonFilePathReadArray(jsonpath: currentJsonFilePath)
                            let arrayLength = tempArray.count
                            for number in 0..<arrayLength{
                                let tempName = tempArray[number]["SoftwareName"]//anyobject
                                if tempName != nil{
                                    let currentName = tempName as! String
                                    if dictionaryTemp[currentName] != nil{
                                        //contian this software name already
                                        //dictionaryTemp[currentName] += 1
                                        let tempValue = dictionaryTemp[currentName]
                                        dictionaryTemp[currentName] = tempValue! + 1
                                    }
                                    else{
                                        dictionaryTemp[currentName] = 1
                                    }
                                }
                                //let currentName = tempArray[number]["SoftwareName"] as! String
                            }
                            
                            
                            //filelist contain all names of the file in this folder
                            let filelist = try FileManager.default.contentsOfDirectory(atPath: Stringfilepath)
                            let number = filelist.count
                            var tem = [String]()
                            for j in 0..<number{
                                if filelist[j].contains(".jpg"){
                                    let temp = Stringfilepath + "/" + filelist[j]
                                    //means it is a photo, instead of a json file
                                    tem.append(temp)
                                }
                            }
                            //PhotoNameArray contains file path + file name
                            //print(PhotoNameArray)
                            let reverse : [String] = Array(tem.reversed())
                            PhotoNameArray += reverse
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            
        }
        return dictionaryTemp
        //return PhotoNameArray.reversed() as [String]
    }
    //end of function fetchSevenDays()
    
    
    
    //
    func PastTimeFewHoursAgo( valueOfHour : Int) -> String {
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
            let dateString = dateFormatter.string(from: tempdate!)
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
        let dateString = dateFormatter.string(from: tempdate!)
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
        let dateString = dateFormatter.string(from: tempdate!)
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d"
        let date24 = dateFormatter.string(from: final!)
        return date24
    }
    //the time
    func GetTimeOfPastTime( date : Date, Hour : Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempHourValue = (-1) * Hour
        let tempdate = Calendar.current.date(byAdding: .hour, value: tempHourValue, to: Date())
        let dateString = dateFormatter.string(from: tempdate!)
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "yyyy-M-d-HH:mm:ss"
        let date24 = dateFormatter.string(from: final!)
        return date24
    }
    //
    func GetTimeOfCurrentTime( date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempdate = Calendar.current.date(byAdding: .hour, value: 0, to: Date())
        let dateString = dateFormatter.string(from: tempdate!)
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
    //
    func basedOnJsonFilePathReadArray(jsonpath : String) -> Array<Dictionary<String, AnyObject>>{
        //let RelatedInformationHandler = RelatedInformation()
        //var softwareName = "other"
        var array = [Dictionary<String, AnyObject>]()
        let rawData : NSData = try! NSData(contentsOf: URL(fileURLWithPath: jsonpath))
        do{
            let jsonDataDictionary = try JSONSerialization.jsonObject(with: rawData as Data, options: JSONSerialization.ReadingOptions.mutableContainers)as? NSDictionary
            let dictionaryOfReturnedJsonData = jsonDataDictionary as! Dictionary<String, AnyObject>
            array = dictionaryOfReturnedJsonData["Information"] as!  [Dictionary<String, AnyObject>]
        }catch{print(error)}
        return array
    }
    //
    func ReturnHour(str : String) -> Int{
        print(str)
        let start = str.index(str.startIndex, offsetBy: 10)
        let end = str.index(str.endIndex, offsetBy: -6)
        let range = start..<end
        let mySubstring = str[range]
        print(mySubstring)
        return Int(mySubstring)!
    }
    //
    func ReturnMinute(str : String) -> Int{
        print(str)
        let start = str.index(str.startIndex, offsetBy: 13)
        let end = str.index(str.endIndex, offsetBy: -3)
        let range = start..<end
        let mySubstring = str[range]
        print(mySubstring)
        return Int(mySubstring)!
    }
    func DealWithScreenShotName(str : String) -> Int{
        //print("in 3 hours")
        print(str)
        let start = str.index(str.startIndex, offsetBy: 17)
        let end = str.index(str.endIndex, offsetBy: -10)
        let range = start..<end
        let mySubstring = str[range]
        print(mySubstring)
        return Int(mySubstring)!
    }
    //
    
    
    
    
    //end of class ReplayingMethodTwo
}
