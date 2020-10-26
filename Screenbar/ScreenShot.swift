import Foundation
import AppKit

struct  mouseLocationInformation {
    static var mouseX = -1
    static var mouseY = -1
}

@available(OSX 10.13, *)
class ScreenShot : NSObject {
    
    lazy var dateFormatter = DateFormatter();
    let ImageCompressHandler = ImageCompress()
    let activitiesHandler = activitiesDetection()
    
    @objc @available(OSX 10.13, *)
    

    
    func take() {
        
        let xLocation = Int(NSEvent.mouseLocation.x)
        let yLocation = Int(NSEvent.mouseLocation.y)
        if (xLocation == mouseLocationInformation.mouseX && yLocation == mouseLocationInformation.mouseY){
            print("mouse did not move since last screenshot taken, no new image save this time")
        }
        else{
            // dataString is the vaule store current data
            let dateString = self.getDate()
            let task = Process()
            //set launchpath "screencapture"
            task.launchPath = "/usr/sbin/screencapture"
            var arguments = [String]();
            
            // ==0, dont play sound
            
            if(Settings.getPlaySound() == 0) {
                arguments.append("-x")
            }

            arguments.append(UserData.screenshotStoragePath + "/Screenshot-" + dateString + ".jpg")

            task.arguments = arguments
            //arguments save all arguments for the screenshot
            
            let OriginialimageName = UserData.screenshotStoragePath + "/Screenshot-" + dateString + ".jpg"
            _ = " \"" +  UserData.screenshotStoragePath + "/Screenshot-" + dateString + ".jpg" + " \""
            let OriginialimageNameFullPath = UserData.screenshotStoragePath + "/Screenshot-" + dateString + ".jpg"
            
            task.launch() // asynchronous call.
            task.waitUntilExit()
            mouseActivities.keyboardDirty = false
            mouseActivities.scrollDirty = false
            //print("after screenshot")
            let FrontmostApphandler = FrontmostApp()
            print(FrontmostApphandler.CurrentFrontMostApp)
            
            let softwareclassifyHandler = classify()
            //classify different software running
            let photoname = "/Screenshot-" + dateString + ".jpg"

            let CurrentFrontName = FrontmostApphandler.CurrentFrontMostApp
            let bound = GetBoundOfFrontMostSoftware(AppName : CurrentFrontName)
            softwareclassifyHandler.SoftwareBasedOnCategory(SoftwareName : CurrentFrontName, ScreenshotName : photoname, BoundInfor : bound)

            let Newimage = NSImage(contentsOf: URL(fileURLWithPath: OriginialimageName))

            let urlStr : NSString = OriginialimageNameFullPath.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! as NSString

            let url = URL(string: urlStr as String)
            ImageCompressHandler.resize(image: Newimage!
                , imagenameaddress:url!
                , fullpath: OriginialimageNameFullPath
                , hei: Settings.getImageCompressWidth()!/2
                , wi: Settings.getImageCompressHeight()!/2
            )

            mouseLocationInformation.mouseX = xLocation
            mouseLocationInformation.mouseY = yLocation
        }

        
    }
    
    // getDate function, return a string value
    private func getDate() -> String {
        let date = Date()
        self.dateFormatter.dateStyle = DateFormatter.Style.none
        self.dateFormatter.timeStyle = DateFormatter.Style.medium
        self.dateFormatter.dateFormat = "MM.dd,HH:mm:ss"
        let dateString = self.dateFormatter.string(from: date)
        return dateString
    }
    
    // get the bound of the front most software
    // now hard code into the json file
    func GetBoundOfFrontMostSoftware(AppName : String) -> Array<String>{
        let first = "tell application \""
        let second = "\" to get the bounds of the front window"
        let final = first + AppName + second
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            print("error for GetBoundOfFrontMostSoftware: \(String(describing: error))")
            let positionTemp = [230, 108]
            print("positionTemp", positionTemp)
            let sizeTemp = ["230", "108", "1210", "748"]
            print("sizeTemp", sizeTemp)
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
        }
        else{
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
        }
        else{
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
    // end of positionOfSoftware()
    
    
    
    //end of the class
}

