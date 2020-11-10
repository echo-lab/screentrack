import Foundation
import AppKit

struct mouseLocationInformation {
    static var mouseX = -1
    static var mouseY = -1
}

@available(OSX 10.15, *)
class ScreenShot : NSObject {
    let imageCompressionHandler = ImageCompress()
    
    @objc @available(OSX 10.15, *)
    func takeScreenshot() {
        let xLocation = Int(NSEvent.mouseLocation.x)
        let yLocation = Int(NSEvent.mouseLocation.y)
        if xLocation != mouseLocationInformation.mouseX || yLocation != mouseLocationInformation.mouseY {
            
            let dateString = getCurrentDateFormatted()
            
            let task = Process()
            task.launchPath = "/usr/sbin/screencapture"
            var arguments = [String]()
            arguments.append(UserData.screenshotStoragePath + "/Screenshot-" + dateString + ".jpg")
            task.arguments = arguments
            
            let originalImageName = UserData.screenshotStoragePath + "/Screenshot-" + dateString + ".jpg"
            let originalImageNameFullPath = UserData.screenshotStoragePath + "/Screenshot-" + dateString + ".jpg"
            
            task.launch()
            task.waitUntilExit()
            
            mouseActivities.keyboardDirty = false
            mouseActivities.scrollDirty = false
            
            let photoname = "/Screenshot-" + dateString + ".jpg"
            let currentFrontMostApplication = FrontmostApp().CurrentFrontMostApp
            let bound = getBoundOfFrontMostApplication(application : currentFrontMostApplication)
            Classify().SoftwareBasedOnCategory(softwareName : currentFrontMostApplication, screenshotName : photoname, bound : bound)

            let image = NSImage(contentsOf: URL(fileURLWithPath: originalImageName))

            let urlStr : NSString = originalImageNameFullPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! as NSString

            let url = URL(string: urlStr as String)
            imageCompressionHandler.resize(image: image!,
                                           imagenameaddress:url!,
                                           fullpath: originalImageNameFullPath,
                                           hei: Settings.getImageCompressWidth()!/2,
                                           wi: Settings.getImageCompressHeight()!/2
            )
            mouseLocationInformation.mouseX = xLocation
            mouseLocationInformation.mouseY = yLocation
        }
    }
    
    // getDate function, return a string value
    private func getCurrentDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        let currentDate = Date()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "MM.dd,HH:mm:ss"
        return dateFormatter.string(from: currentDate)
    }
    
    // get the bound of the front most software
    // now hard code into the json file
    func getBoundOfFrontMostApplication(application : String) -> Array<String>{
        let first = "tell application \""
        let second = "\" to get the bounds of the front window"
        let final = first + application + second
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        let _: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            print("error for GetBoundOfFrontMostSoftware: \(String(describing: error))")
//            let positionTemp = [230, 108]
//            print("positionTemp", positionTemp)
            //MARK: TODO - hard coded?
            //MARK: TODO - some applications do not have bounds - optional bounds value implementation
            let sizeTemp = ["230", "108", "1210", "748"]
//            print("sizeTemp", sizeTemp)
            return sizeTemp
        }
        else{
            var arr = [String]()
            arr = ["230", "108", "1210", "748"]
            return arr
        }
    }
    
    // get the size of the software
    func sizeOfSoftware(AppName : String, position : Array<Int>) -> Array<String>{
        var result = [String]()
        var arr = [Int]()
        let first = "tell application \"System Events\" to tell application process \""
        let second = "\" \n get size of window 1 \n end tell"
        let final = first + AppName + second
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            print("error for sizeOfSoftware: \(String(describing: error))")
            let empty = [String]()
            return empty
        } else {
            for i in 1..<3{
                let temp = String(describing: output.atIndex(i)?.int32Value)
                let start = temp.characters.index(of: "(")!
                let end = temp.characters.index(of: ")")!
                let subStr = temp[start..<end]
                let newStart = subStr.index(subStr.startIndex, offsetBy: 1)
                let newEnd = subStr.index(subStr.endIndex, offsetBy : 0)
                let range = newStart..<newEnd
                arr.append(Int(subStr[range])!)
            }
        }
        let screen = NSScreen.main
        let rect = screen?.frame
        let height = Int((rect?.size.height)!)
        let width = Int((rect?.size.width)!)
        var tempThreeFactor = arr[0] + position[0]
        var tempFourFactor = arr[1] + position[1]
        if tempThreeFactor > width{
            tempThreeFactor = width
        }
        if tempFourFactor > height{
            tempFourFactor = height
        }
        if position[0] < 0{
            result.append(String(0))
        }
        else{
           result.append(String(position[0]))
        }
        if position[1] < 0{
            result.append(String(0))
        }
        else{
            result.append(String(position[1]))
        }
        result.append(String(tempThreeFactor))
        result.append(String(tempFourFactor))
        return result
   
    }
    
    //  get the position of the current software
    func positionOfSoftware(AppName : String) -> Array<Int>{
        let first = "tell application \"System Events\" to tell application process \""
        let second = "\" \n get position of window 1 \n end tell"
        let final = first + AppName + second
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            print("error for positionOfSoftware: \(String(describing: error))")
            let empty = [Int]()
            return empty
        } else {
            var arr = [Int]()
            for i in 1..<3{
                let temp = String(describing: output.atIndex(i)?.int32Value)
                let start = temp.characters.index(of: "(")!
                let end = temp.characters.index(of: ")")!
                let subStr = temp[start..<end]
                let newStart = subStr.index(subStr.startIndex, offsetBy: 1)
                let newEnd = subStr.index(subStr.endIndex, offsetBy : 0)
                let range = newStart..<newEnd
                arr.append(Int(subStr[range])!)
            }
            return arr
        }
    }
}

