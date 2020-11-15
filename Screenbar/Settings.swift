import Foundation
import CoreData
import AppKit

@available(OSX 10.15, *)
class Settings : NSObject {
    
    static let applicationDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    static let screenshotIntervalKey = "seconds"
    static let storageDaysKey = "storageDays"
    static var detectSwitchKey = "detectSwitch"
    static var sessionNumberArray = [Int]()
    
    static var imageCompressionRateKey = "compressionRate"
    static var imageCompressionRateHeightKey = "compressedHeight"
    static var imageCompressionRateWidthKey = "compressedWidth"
    
    
    //MARK: Screenshot Interval
    static func setScreenshotInterval(to newScreenshotInterval: Int) {
        UserDefaults.standard.set(newScreenshotInterval, forKey: screenshotIntervalKey)
    }
    
    static func getScreenshotInterval() -> Double? {
        return UserDefaults.standard.double(forKey: screenshotIntervalKey)
    }
    
    //MARK: Image Compression Rate
    static func setImageCompressionRate(to newCompressionRate: Int) {
        UserDefaults.standard.set(newCompressionRate, forKey: imageCompressionRateKey)
        
        if getImageCompressionRate() != nil && getImageCompressionHeight() != nil && getImageCompressionWidth() != nil {
            let compressionRate = Double(getImageCompressionRate()!)
            let compressionPercentage = compressionRate / 100.0
            
            if let screen = NSScreen.main {
                let rect = screen.frame
                let height = rect.size.height
                let width = rect.size.width
                
                let compressedHeight = Float(height) * Float(compressionPercentage)
                let compressedWidth = Float(width) * Float(compressionPercentage)
                
                setImageCompressionHeight(to: Int(compressedHeight))
                setImageCompressionWidth(to: Int(compressedWidth))
            }
        }
    }
    
    static func getImageCompressionRate() -> Int? {
        return UserDefaults.standard.integer(forKey: imageCompressionRateKey)
    }
    
    //MARK: Image Compression Height
    static func setImageCompressionHeight(to height: Int) {
        UserDefaults.standard.set(height, forKey: imageCompressionRateHeightKey)
    }
    
    static func getImageCompressionHeight() -> Int? {
        return UserDefaults.standard.integer(forKey: imageCompressionRateHeightKey)
    }

    
    //MARK: Image Compression Width
    static func setImageCompressionWidth(to width: Int) {
        UserDefaults.standard.set(width, forKey: imageCompressionRateWidthKey)
    }
    
    static func getImageCompressionWidth() -> Int? {
        return UserDefaults.standard.integer(forKey: imageCompressionRateWidthKey)
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
