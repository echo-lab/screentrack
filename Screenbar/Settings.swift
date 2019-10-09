import Foundation
import CoreData
import AppKit

// this class is a total setting of these three things
// time interval of screenshot, storage path and whether have sound or not

@available(OSX 10.13, *)

class Settings : NSObject {
    static let applicationDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    //static let appdelegateHandler = AppDelegate()
    
    //
    static var secondsKey = "seconds"
    static var pathKey = "savePath"
    static var playSoundKey = "playSound"
    //height
    static var TimeIntervalSecond = "intervalseconds"
    //width
    static var TimeIntervalSecondTwo = "intervalsecondstwo"
    //
    static var detectSwitchKey = "detectSwitch"
    
    static var ImageHeight = "height"
    static var ImageWidth = "width"
    static var SessionKey = "session"
    
    static var SessionNumber = [Int]()
    
    // default value of timeinervalsecond
    static func TimeIntervalSecondTwoSet(_ intervalsecondstwo: Double?){
        //
        let defaults = UserDefaults.standard
        defaults.set(intervalsecondstwo!, forKey: secondsKey)
    }
    // get the value of TimerIntercalSecond
    static func TimeIntervalSecondTwoGet() -> Double?{
        let defaults = UserDefaults.standard
        var inervalsecondstwo: Double? = defaults.double(forKey: secondsKey)
        if(inervalsecondstwo == nil){
            inervalsecondstwo = 300.0
        }
        return inervalsecondstwo
    }
    
    
    // default value of timeinervalsecond
    static func TimeIntervalSecondSet(_ intervalseconds: Double?){
        //
        let defaults = UserDefaults.standard
        defaults.set(intervalseconds!, forKey: secondsKey)
    }
    // get the value of TimerIntercalSecond
    static func TimeIntervalSecondGet() -> Double?{
        let defaults = UserDefaults.standard
        var inervalseconds: Double? = defaults.double(forKey: secondsKey)
        if(inervalseconds == nil){
            inervalseconds = 500.0
        }
        return inervalseconds
    }
    
    // get the parameter of hight and width from silder
    static func setImageCompressHeight(_ height: Int?){
        let defaults = UserDefaults.standard
        defaults.set(height!, forKey: ImageHeight)
    }
    static func getImageCompressHeight() -> Int?{
        let deaults = UserDefaults.standard
        let height: Int? = deaults.integer(forKey: ImageHeight)
        return height
    }

    static func getImageCompressWidth() -> Int?{
        let width = (getImageCompressHeight()! * 900) / 1440
        //print("hight now : " + String(width))
        return width
    }

    
    static func setSecondsIntervall(_ seconds: Double?) {
        // set the defalut as standard
        let defaults = UserDefaults.standard
        defaults.set(seconds!, forKey: secondsKey)
    }
    
    //return a double value as second
    static func getSecondsInterval() -> Double? {
        // set the defalut as standard
        let defaults = UserDefaults.standard
        //
        let seconds: Double? = defaults.double(forKey: secondsKey)
        // if the input is null, then set to 1.0 second as defalult
//        if(seconds == nil) {
//            seconds = 60.0
//        }
        //return the setted second result
        return seconds
    }
    
    // set the storage path
    static func setPath(_ path: URL?) {
        let defaults = UserDefaults.standard
        defaults.set(path, forKey: pathKey)
    }
    static func DefaultFolder() -> URL{
        let defaultpath = URL(string: NSHomeDirectory() + "/Documents" + "/Reflect/")
        //print("default file path")
        //print(defaultpath!)
        return defaultpath!
    }
    
    // return a URL value as storage path
    @available(OSX 10.13, *)
    //create the foler path
    static func PathCreate(){
        let path = DefaultFolder()
        let url = path.absoluteString
        print(url)
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        // after the second click(or more clicks), here has one bug
        SessionNumber = applicationDelegate.fileNameDictionary[current] as! [Int]
        //print("this is the session number that is already sotred")
        //print(SessionNumber)
        let length = SessionNumber.count
        if SessionNumber[length - 1] == 0 {
            //if the first and only number is 0
            //save a new number "1" into plist
            SessionNumber.append(Int(1))
            
            applicationDelegate.fileNameDictionary.setValue(SessionNumber, forKey: current)
            //create a new folder and return this folder path
            let temp = url + current + "-" + String(1)
            print("temp in creatpath func")
            print(temp)
            let finalpath = NSURL(string: temp)
            do
            {
                try FileManager.default.createDirectory(atPath: finalpath!.path!, withIntermediateDirectories: true, attributes: nil)
                print("create folder successed")
            }
            catch let error as NSError
            {
                print("Unable to create directory \(error.debugDescription)")
            }
            MyVariables.yourVariable = temp
            //return finalpath! as URL
        }
        else{
            //the last number is not 0
            //save a new number "+1" into plist
            let new = SessionNumber[length - 1] + 1
            SessionNumber.append(new)
            applicationDelegate.fileNameDictionary.setValue(SessionNumber, forKey: current)
            //create a new floder and return this folder path
            let temp = url + current + "-" + String(new)
            print("temp in creatpath func")
            print(temp)
            let finalpath = NSURL(string: temp)
            do
            {
                try FileManager.default.createDirectory(atPath: finalpath!.path!, withIntermediateDirectories: true, attributes: nil)
                print("create folder successed")
            }
            catch let error as NSError
            {
                print("Unable to create directory \(error.debugDescription)")
            }
            MyVariables.yourVariable = temp
            //return finalpath! as URL
        }
    }
    
    static func GettingPathFromStringToURL(str: String) -> URL{
        let finalurl = NSURL(string: str)
        return finalurl! as URL
    }
    
    
    static func setPlaySound(_ state: Int?) {
        let defaults = UserDefaults.standard
        defaults.set(state, forKey: playSoundKey)
    }
    
    // return a int value to show whether have sound or not
    static func getPlaySound() -> Int {
        let defaults = UserDefaults.standard
        var state : Int? = defaults.integer(forKey: playSoundKey)
        // default is no sound
        if(state == nil) {
            state = 0;
        }
        return state!;
    }
    //end of set play sound or not
    static func setDetectSwitch(_ state: Int?){
        let defaults = UserDefaults.standard
        defaults.set(state, forKey: detectSwitchKey)
    }
    static func getDetectSwitch() -> Int{
        let defaults = UserDefaults.standard
        var state : Int? = defaults.integer(forKey: detectSwitchKey)
        // default is no sound
        if(state == nil) {
            state = 1;
        }
        return state!;
    }
    //end of set play sound or not
    
    static func setSession(){
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: SessionKey)
    }
    static func getSession() -> Int{
        let defaults = UserDefaults.standard
        let counter : Int? = defaults.integer(forKey: SessionKey)
        return counter!;
    }
    
    @available(OSX 10.13, *)
    //save foldername from string: name
    static func SessionCounter(name: String){
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newSession = NSEntityDescription.insertNewObject(forEntityName: "Session", into: context)
        newSession.setValue(name, forKey: "foldername")
        do{
            try context.save()
            print("Core data foldername saved")
        }
        catch{
            print("Core data foldername failed")
        }
    }
    //using plist
    
    
}
