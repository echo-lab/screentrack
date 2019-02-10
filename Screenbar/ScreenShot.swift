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
        softwareclassifyHandler.SoftwareDetect(SoftwareName: FrontmostApphandler.CurrentFrontMostApp, ScreenshotName : photoname)
        
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
    //useless kind of 
    @available(OSX 10.13, *)
    func take_second(){
        // dataString is the vaule store current data
        let dateString = self.getDate()
        // new task euqal to Process()
        let task = Process()
        // set launchpath "screencapture"
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
        
        arguments.append(MyVariables.yourVariable + "/Screenshot-" + dateString + ".jpg")
        //set the task's arguments
        task.arguments = arguments
        //print(arguments)
        //let OriginialimageName = Settings.getPath().path + "/Screenshot-" + dateString + ".jpg"
        //print("file name is :" + OriginialimageName)
        //launch the task
        task.launch()
        
//      print(URL(fileURLWithPath: OriginialimageName))
//      let Newimage = NSImage(byReferencing: URL(fileURLWithPath: OriginialimageName))
//      print(Newimage.size.width, Newimage.size.height)
//      ImageCompressHandler.resize(image: Newimage, imagenameaddress: URL(fileURLWithPath: OriginialimageName))
    
    }
    
    // isn't this is so complex?
    // getDate function, return a string value
    private func getDate() -> String {
        let date = Date()
        self.dateFormatter.dateStyle = DateFormatter.Style.none
        self.dateFormatter.timeStyle = DateFormatter.Style.medium
        var dateString = self.dateFormatter.string(from: date)
        dateString = dateString.replacingOccurrences(of: ":", with: ".", options: NSString.CompareOptions.literal, range: nil)
        return dateString;
    }
}

