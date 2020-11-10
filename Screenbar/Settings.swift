import Foundation
import CoreData
import AppKit

@available(OSX 10.15, *)
class Settings : NSObject {
    
    static let applicationDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    static let screenshotIntervalKey = "seconds"
    static let storageDaysKey = "storageDays"
    static var detectSwitchKey = "detectSwitch"
    static var imageCompressionRateKey = "height"
    static var imageWidth = "width"
    static var sessionNumberArray = [Int]()
    
    static func setScreenshotInterval(to newScreenshotInterval: Int) {
//        if let newScreenshotInterval = _newScreenshotInterval {
            UserDefaults.standard.set(newScreenshotInterval, forKey: screenshotIntervalKey)
//        }
    }
    
    static func getScreenshotInterval() -> Double? {
        return UserDefaults.standard.double(forKey: screenshotIntervalKey)
    }
    
    static func setImageCompressionRate(to _newCompressionRate: Int?) {
        if let newCompressionRate = _newCompressionRate {
            UserDefaults.standard.set(newCompressionRate, forKey: imageCompressionRateKey)
        }
    }
    
    static func getImageCompressHeight() -> Int?{
        let deaults = UserDefaults.standard
        let height: Int? = deaults.integer(forKey: imageCompressionRateKey)
        return height
    }

    static func getImageCompressWidth() -> Int?{
        let width = (getImageCompressHeight()! * 900) / 1440
        return width
    }
    
    //MARK: getUserDefaultFolderPath
    static func getUserDefaultFolderPath() -> URL {
        var defaultPath = URL(string: NSHomeDirectory())!
        
        if let _defaultPath = URL(string: NSHomeDirectory() + "/Documents" + "/Reflect/") {
            defaultPath = _defaultPath
        }
        
        return defaultPath
    }
    
    //MARK: Create User Storage Directory
    @available(OSX 10.15, *)
    static func createUserStorageDirectory() -> Bool {
        let path = getUserDefaultFolderPath()
        let url = path.absoluteString
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        
        if let _sessionNumberArray = applicationDelegate.fileNameDictionary[current] as? [Int] {
            sessionNumberArray = _sessionNumberArray
        }
        
        let length = sessionNumberArray.count
        
        let newSessionNumber = sessionNumberArray[length - 1] == 0 ? 1 : sessionNumberArray[length - 1] + 1
        let screenshotStoragePath = url + current + "-" + String(newSessionNumber)
        
        applicationDelegate.fileNameDictionary.setValue(sessionNumberArray, forKey: current)
        
        let finalPath = NSURL(string: screenshotStoragePath)
        
        do {
            try FileManager.default.createDirectory(atPath: finalPath!.path!, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Unable to create directory \(error.debugDescription)")
            return false
        }
        
        UserData.screenshotStoragePath = screenshotStoragePath
        return true
    }

    static func setDetectSwitch(_ state: Int?){
        let defaults = UserDefaults.standard
        defaults.set(state, forKey: detectSwitchKey)
    }
    
    static func getDetectSwitch() -> Int{
        let defaults = UserDefaults.standard
        var state : Int? = defaults.integer(forKey: detectSwitchKey)
        
        if state == nil {
            state = 1;
        }
        
        return state!;
    }
}
