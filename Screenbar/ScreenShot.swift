import Foundation
import AppKit


@available(OSX 10.13, *)
class ScreenShot : NSObject {
    
    lazy var dateFormatter = DateFormatter();
    let ImageCompressHandler = ImageCompress()
    
    
    @available(OSX 10.13, *)
    func take() {
        // dataString is the vaule store current data
        let dateString = self.getDate()
        // new task euqal to Process()
        let task = Process()
        //set launchpath "screencapture"
        //this is used for screencapture
        task.launchPath = "/usr/sbin/screencapture"
        
        // this is a chaging string with different setting
        var arguments = [String]();
        
        // whether have sound or not
        if(Settings.getPlaySound() == 0) {
            arguments.append("-x")
        }
        // set the screenshot name
        // using the getpath funcion in Setting.swift
        //MyVariables.yourVariable
        //arguments.append(Settings.getPath().path + "/Screenshot-" + dateString + ".jpg")
        arguments.append(MyVariables.yourVariable + "/Screenshot-" + dateString + ".jpg")
        //set the task's arguments
        task.arguments = arguments
        //print(arguments)
        let OriginialimageName = MyVariables.yourVariable + "/Screenshot-" + dateString + ".jpg"
        _ = " \"" +  MyVariables.yourVariable + "/Screenshot-" + dateString + ".jpg" + " \""
        let OriginialimageNameFullPath = MyVariables.yourVariable + "/Screenshot-" + dateString + ".jpg"
//        let OriginialimageName = Settings.getPath().path + "/Screenshot-" + dateString + ".jpg"
//        _ = " \"" +  Settings.getPath().path + "/Screenshot-" + dateString + ".jpg" + " \""
//        let OriginialimageNameFullPath =   Settings.getPath().path + "/Screenshot-" + dateString + ".jpg"

        print("file name is :" + OriginialimageName)
        //launch the task
         
        //classify different software
        task.launch() // asynchronous call.
        task.waitUntilExit()
        print("after screenshot")
        let FrontmostApphandler = FrontmostApp()
        print(FrontmostApphandler.CurrentFrontMostApp)
        
        let softwareclassifyHandler = classify()
        //classify different software running
        let photoname = "/Screenshot-" + dateString + ".jpg"
//        softwareclassifyHandler.SoftwareDetect(SoftwareName: FrontmostApphandler.CurrentFrontMostApp, ScreenshotName : photoname)
        
        //print(GetBoundOfFrontMostSoftware())
        let CurrentFrontName = FrontmostApphandler.CurrentFrontMostApp
        let bound = GetBoundOfFrontMostSoftware(AppName : CurrentFrontName)
        softwareclassifyHandler.SoftwareBasedOnCategory(SoftwareName : CurrentFrontName, ScreenshotName : photoname, BoundInfor : bound)
        //let temphandelr = FrontmostApp()
        //temphandelr.windowlocation()
        //print(URL(fileURLWithPath: OriginialimageName))
        let Newimage = NSImage(contentsOf: URL(fileURLWithPath: OriginialimageName))
        //print(Newimage?.size.height)
        //let Newimage = NSImage(byReferencing: URL(fileURLWithPath: OriginialimageName))
        let urlStr : NSString = OriginialimageNameFullPath.addingPercentEscapes(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))! as NSString
        
        let url = URL(string: urlStr as String)
        ImageCompressHandler.resize(image: Newimage!
            , imagenameaddress:url!
            , fullpath: OriginialimageNameFullPath
            , hei: Settings.getImageCompressWidth()!/2
            , wi: Settings.getImageCompressHeight()!/2
        )
        
        
    }
    
    // getDate function, return a string value
    private func getDate() -> String {
        let date = Date()
        
        self.dateFormatter.dateStyle = DateFormatter.Style.none
        self.dateFormatter.timeStyle = DateFormatter.Style.medium
        //self.dateFormatter.dateFormat = "MM.dd,HH:mm:ss"
        self.dateFormatter.dateFormat = "MM.dd,HH:mm:ss"
        var dateString = self.dateFormatter.string(from: date)
        //print(dateString)
        //5:06:52 PM
        //let calendar = Calendar.current
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm:ss a"
//        let final = dateFormatter.date(from: dateString)
//        dateFormatter.dateFormat = "M.d,HH:mm:ss"
//        let date24 = dateFormatter.string(from: final!)
        //print(date24)
        //print(date24)
        
        //dateString = dateString.replacingOccurrences(of: ":", with: ".", options: NSString.CompareOptions.literal, range: nil)
        //return dateString;
        return dateString
    }
    //
    
    func GetBoundOfFrontMostSoftware(AppName : String) -> Array<String>{
        //let MyAppleScript = tell application "Preview" to get the bounds of the front window
        let first = "tell application \""
        let second = "\" to get the bounds of the front window"
        let final = first + AppName + second
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        print(String(output.description))
        if (error != nil) {
            print("error: \(String(describing: error))")
            let positionTemp = positionOfSoftware(AppName : AppName)
            let sizeTemp = sizeOfSoftware(AppName : AppName, position : positionTemp)
            //let empty = [String]()
            print("sizeTemp")
            print(sizeTemp)
            return sizeTemp
        }
        else{
            var arr = [String]()
            for i in 1..<5{
                let temp = String(describing: output.atIndex(i)?.int32Value)
                //arr = arr +
                let start = temp.characters.index(of: "(")!
                let end = temp.characters.index(of: ")")!
                let subStr = temp[start..<end]
                let newStart = subStr.index(subStr.startIndex, offsetBy: 1)
                let newEnd = subStr.index(subStr.endIndex, offsetBy : 0)
                let range = newStart..<newEnd
                arr.append(subStr[range])
            }
            return arr
        }
        //let stringvalue = String(arr)
        //<NSAppleEventDescriptor: [ 0, 23, 1439, 828 ]>
        //print(output.stringValue)
    }
    //
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
            print("error: \(String(describing: error))")
            let empty = [String]()
            return empty
        }
        else{
            for i in 1..<3{
                let temp = String(describing: output.atIndex(i)?.int32Value)
                //arr = arr +
                let start = temp.characters.index(of: "(")!
                let end = temp.characters.index(of: ")")!
                let subStr = temp[start..<end]
                let newStart = subStr.index(subStr.startIndex, offsetBy: 1)
                let newEnd = subStr.index(subStr.endIndex, offsetBy : 0)
                let range = newStart..<newEnd
                arr.append(Int(subStr[range])!)
                
            }
            //return arr
        }
        let screen = NSScreen.main
        let rect = screen()?.frame
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
        result.append(String(position[0]))
        result.append(String(position[1]))
        result.append(String(tempThreeFactor))
        result.append(String(tempFourFactor))
        return result
   
    }
    
    func positionOfSoftware(AppName : String) -> Array<Int>{
        let first = "tell application \"System Events\" to tell application process \""
        let second = "\" \n get position of window 1 \n end tell"
        let final = first + AppName + second
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: final)
        let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            print("error: \(String(describing: error))")
            let empty = [Int]()
            return empty
        }
        else{
            var arr = [Int]()
            for i in 1..<3{
                let temp = String(describing: output.atIndex(i)?.int32Value)
                //arr = arr +
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

