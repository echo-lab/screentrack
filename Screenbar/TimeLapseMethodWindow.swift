//
//  TimeLapseMethodWindow.swift
//  Screenbar
//
//  Created by Donghan Hu on 3/11/19.
//

import Cocoa
@available(OSX 10.15, *)

class TimeLapseMethodWindow: NSViewController, NSWindowDelegate {

    @IBOutlet weak var ImageDisplayArea: NSImageView!
    @IBOutlet weak var openEnclosingFolderButton: NSButtonCell!
    
    @IBOutlet weak var InforOne: NSTextField!
    @IBOutlet weak var InforTwo: NSTextField!
    // @IBOutlet weak var InforThree: NSTextField!
    @IBOutlet weak var InforFour: NSTextField!
    @IBOutlet weak var InforFive: NSTextField!
    
    @IBOutlet var showCroppedImage: NSImageView!
    
    @IBOutlet weak var croppedButton: NSButtonCell!
    
    @IBOutlet weak var FilePathOrURL: NSTextField!
    @IBOutlet weak var PageTitalOrFileName: NSTextField!
    
    @IBOutlet weak var MultiLineOfPastTime: NSTextField!
    @IBOutlet weak var MultiLineOfCurrentTime: NSTextField!
    
    @IBOutlet weak var ComboBoxOfMenu: NSComboBox!
    
    @IBOutlet weak var Slider: NSSliderCell!
    
    @IBOutlet weak var SliderOfSpeed: NSSlider!
    
    @IBOutlet weak var InformationDisplayArea: NSTextField!
    
    @IBOutlet weak var NextVideoImageButton: NSButton!
    
    @IBOutlet weak var PreviousVideoImageButton: NSButton!
    
    @IBOutlet weak var datePick: NSDatePicker!
    @IBOutlet weak var confirmButtonForDatePick: NSButton!
    
    @IBOutlet weak var CloseWindowButton: NSButton!
    @IBOutlet weak var imageButtonPlay: NSButton!
    @IBOutlet weak var imageButtonNext: NSButton!
    @IBOutlet weak var imageButtonPrevious: NSButton!
    @IBOutlet weak var ButtonOfPlay: NSButton!
    @IBOutlet weak var cropButton: NSButton!
    
    
    @IBOutlet weak var staticCategoryText: NSTextField!
    
    
    var photonumber = 0
    var PhotoNameList = [String]()
    
    let GetListOfFilesHandler = FindScreenShot()
    
    var playImageTimer = Timer()
    var closeWindowTimer = Timer()
    
    
    let croppedImagePopover = NSPopover()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.delegate = self
         self.view.window?.title = "ScreenTrack"
        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
       
        cropButton.isHidden = true
        staticCategoryText.isHidden = true
        DefaultInformationDisplay()
        DefaultDisplayToday()
        MultiLineOfPastTime.stringValue = ""
        MultiLineOfCurrentTime.stringValue = ""
        DefaultComboMenu()
        imageButtonSet()
        
        datePick.dateValue = Date()
    }
    
    func windowWillClose(_ aNotification: Notification) {
        print("windowWillClose")
        UserData.timelapseWindowIsOpen = false
        UserData.TimelapseWindowController = nil
    }
    
    @objc func CurrentTime(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "M-d, HH:mm:ss"
        let temp = dateFormatter.string(from: NSDate() as Date)
        print(temp)
    }
    // end of Current Time
    
    //
    func imageButtonSet(){
        imageButtonPrevious.image = NSImage(named: NSImage.Name(rawValue: "Previous"))
        imageButtonNext.image   = NSImage(named: NSImage.Name(rawValue: "Next"))
        imageButtonPlay.image = NSImage(named: NSImage.Name(rawValue: "PlayIcon"))
        NextVideoImageButton.image = NSImage(named: NSImage.Name(rawValue: "nextvideo"))
        PreviousVideoImageButton.image = NSImage(named: NSImage.Name(rawValue: "previousvideo"))
        
    }
    //
    func DefaultDisplayToday(){
        openEnclosingFolderButton.isEnabled = true
        let ReplayingOneHandler = ReplayingOne()
        PhotoNameList = ReplayingOneHandler.FetchPhotoToday() as! [String]
        if PhotoNameList.count == 0{
            print("today has no photo recorded")
            //code here
            //DefaultImageDisplay()
            DefaultNoPhotoRecordedDisplay()
            
            InformationDisplayArea.stringValue = ""
            Slider.doubleValue = Slider.maxValue
            
        }else{
            photonumber = PhotoNameList.count - 1
            SliderValueSet()
            Slider.doubleValue = Slider.maxValue
            let photoname = PhotoNameList[Int(Slider.maxValue)]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            //InformationDisplayArea.stringValue = DicMessage.description
            if DicMessage["SoftwareName"] != nil{
                //print(DicMessage["SoftwareName"])
                InforOne.stringValue = DicMessage["SoftwareName"] as! String
            }
            if DicMessage["PhotoName"] != nil{
                let photoNameString = DicMessage["PhotoName"] as! String
                let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                InforTwo.stringValue = printTimeString
            }
            if DicMessage["FilePath"] != nil{
                FilePathOrURL.stringValue = "File Path"
                InforFour.stringValue = DicMessage["FilePath"] as! String
            }
            else if DicMessage["FrontmostPageUrl"] != nil{
                FilePathOrURL.stringValue = "Page URL"
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                openEnclosingFolderButton.isEnabled = false
            }
            else{
                FilePathOrURL.stringValue = "File Path or Page URL"
                InforFour.stringValue = "null"
            }
            if DicMessage["FrontmostPageTitle"] != nil{
                PageTitalOrFileName.stringValue = "Page Title"
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            }
            else if DicMessage["FileName"] != nil{
                
                PageTitalOrFileName.stringValue = "File Name"
                InforFive.stringValue = DicMessage["FileName"] as! String
            }
            else{
                PageTitalOrFileName.stringValue = "Page Tital or File Name"
                InforFive.stringValue = "nil"
            }
            
        }
        
    }
    //end of DefaultDisplayToday()
    func DefaultNoPhotoRecordedDisplay(){
        let defaultImage = NSImage(named : NSImage.Name(rawValue: "No_Image_Available"))
        ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
        ImageDisplayArea.image = defaultImage
    }
    //
    func DefaultComboMenu(){
        let singularNouns = ["today", "recent 1 hour", "recent 3 hours", "recent 5 hours", "recent 8 hours", "recent 24 hours", "recent 3 days", "recent 5 days", "recent 7 days"]
        ComboBoxOfMenu.removeAllItems()
        ComboBoxOfMenu.addItems(withObjectValues: singularNouns)
        //let number = singularNouns.count
        ComboBoxOfMenu.selectItem(at: 0)
    }
    //end of DefaultComboMenu()
    
    //
    func DefaultImageDisplay(){
        openEnclosingFolderButton.isEnabled = true
        if DisplayLatestPic() == ""{
            let defaultImage = NSImage(named : NSImage.Name(rawValue: "DefaultDisplayImage"))
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = defaultImage
        }
        else{
            let nsImage = NSImage(contentsOfFile: DisplayLatestPic())
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: DisplayLatestPic())
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: DisplayLatestPic())
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            defaultSliderValue()
            if DicMessage["SoftwareName"] != nil{
                InforOne.stringValue = DicMessage["SoftwareName"] as! String
            }
            if DicMessage["PhotoName"] != nil{
                let photoNameString = DicMessage["PhotoName"] as! String
                let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                InforTwo.stringValue = printTimeString
            }
            if DicMessage["FilePath"] != nil{
                FilePathOrURL.stringValue = "File Path"
                InforFour.stringValue = DicMessage["FilePath"] as! String
            }
            else if DicMessage["FrontmostPageUrl"] != nil{
                FilePathOrURL.stringValue = "Page URL"
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                openEnclosingFolderButton.isEnabled = false
            }
            else{
                FilePathOrURL.stringValue = "File Path or Page URL"
                InforFour.stringValue = "null"
            }
            
            if DicMessage["FrontmostPageTitle"] != nil{
                PageTitalOrFileName.stringValue = "Page Title"
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            }
            else if DicMessage["FileName"] != nil{
                PageTitalOrFileName.stringValue = "File Name"
                InforFive.stringValue = DicMessage["FileName"] as! String
            }
            else{
                PageTitalOrFileName.stringValue = "Page Tital or File Name"
                InforFive.stringValue = "nil"
            }
        }
    }
    
    
    func DefaultInformationDisplay(){
        let message = "Good Morning"
        InformationDisplayArea.stringValue = ""
    }
    
    func defaultSliderValue(){
        Slider.minValue = 0.0
        Slider.maxValue = 0.0
    }
    
    func SliderValueSet(){
        let maxvalue = photonumber
        Slider.minValue = 0
        Slider.maxValue = Double(maxvalue)
    }
    
    @IBAction func SliderAction(_ sender: Any) {
        openEnclosingFolderButton.isEnabled = true
        let index = Int((sender as AnyObject).doubleValue)
        if PhotoNameList != []{
            let photoname = PhotoNameList[index]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            if DicMessage["SoftwareName"] != nil{
                InforOne.stringValue = DicMessage["SoftwareName"] as! String
            }
            if DicMessage["PhotoName"] != nil{
                let photoNameString = DicMessage["PhotoName"] as! String
                let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                InforTwo.stringValue = printTimeString
            }
            if DicMessage["FilePath"] != nil{
                FilePathOrURL.stringValue = "File Path"
                InforFour.stringValue = DicMessage["FilePath"] as! String
            }
            else if DicMessage["FrontmostPageUrl"] != nil{
                FilePathOrURL.stringValue = "Page URL"
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                openEnclosingFolderButton.isEnabled = false
            }
            else{
                FilePathOrURL.stringValue = "File Path or Page URL"
                InforFour.stringValue = "null"
            }
            if DicMessage["FrontmostPageTitle"] != nil{
                PageTitalOrFileName.stringValue = "Page Title"
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            }
            else if DicMessage["FileName"] != nil{
                PageTitalOrFileName.stringValue = "File Name"
                InforFive.stringValue = DicMessage["FileName"] as! String
            }
            else{
                PageTitalOrFileName.stringValue = "Page Tital or File Name"
                InforFive.stringValue = "nil"
            }
        }
        else{
            
        }
    }
    
    @IBAction func imageButtonPreviousClick(_ sender: Any) {
        openEnclosingFolderButton.isEnabled = true
        let temp = Int(Slider.doubleValue)
        //print(temp)
        if temp > 0 {
            if PhotoNameList != []{
                let photoname = PhotoNameList[temp - 1]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                Slider.doubleValue -= 1
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page Url"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                }
                else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                }
                else{
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
        }
    }
    
    
    @IBAction func imageButtonNextClick(_ sender: Any) {
        openEnclosingFolderButton.isEnabled = true
        let temp = Int(Slider.doubleValue)
        //print(temp)
        if temp < Int(Slider.maxValue) {
            if PhotoNameList != []{
                let photoname = PhotoNameList[temp + 1]
                //photoname is the path of screenshots
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                Slider.doubleValue += 1
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                //InformationDisplayArea.stringValue = DicMessage.description
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    //InforTwo.stringValue = DicMessage["PhotoName"] as! String
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
//                if DicMessage["category"] != nil{
//                    InforThree.stringValue = DicMessage["category"] as! String
//                }
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                } else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                } else {
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
        }
    }
    
    func PastTimeHours(hour : Int) -> Array<String>{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "M-d, HH:mm:ss"
        let temp = dateFormatter.string(from: NSDate() as Date)
        let tempHourValue = (-1) * hour
        let tempdate = Calendar.current.date(byAdding: .hour, value: tempHourValue, to: Date())
        //let dateString = dateFormatter.string(from: tempdate!)
        //5:06:52 PM
        dateFormatter.dateFormat = "MM.dd, HH:mm:ss"
        let date24 = dateFormatter.string(from: tempdate!)
        var arr = [String]()
        arr.append(date24)
        arr.append(temp)
        return arr
    }
    
    func PastTimeDays(day : Int) -> Array<String>{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "M-d, HH:mm:ss"
        let temp = dateFormatter.string(from: NSDate() as Date)
        let tempHourValue = (-1) * day
        let tempdate = Calendar.current.date(byAdding: .day, value: tempHourValue, to: Date())
        dateFormatter.dateFormat = "MM.dd, "
        let date24 = dateFormatter.string(from: tempdate!)
        var arr = [String]()
        arr.append(date24)
        arr.append(temp)
        return arr
    }
    
    func PastTimeToday() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempdate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        dateFormatter.dateFormat = "MM.dd, "
        let date24 = dateFormatter.string(from: tempdate!)
        return date24
    }
    
    func dialogOKCancel(question: String, text: String) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
    }
    
    @IBAction func TimeIntervalCheckButton(_ sender: Any) {
        if (InforFour.stringValue != "null") && (FilePathOrURL.stringValue == "File Path"){
            let errorHandler = SoftwareClassifier()
            let first = "set thePath to POSIX file \""
            let second = "\" \n tell application \"Finder\" to reveal thePath"
            let final = first + InforFour.stringValue + second
            var error: NSDictionary?
            let scriptObject = NSAppleScript(source: final)
            let output: NSAppleEventDescriptor = scriptObject!.executeAndReturnError(&error)
            if (error != nil) {
                print("error: \(String(describing: error))")
            }
        }
        else if (FilePathOrURL.stringValue == "PageUrl"){
            let alert = NSAlert.init()
            alert.messageText = "Hello"
            alert.informativeText = "this is url not file path"
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
        else {
            let alert = NSAlert.init()
            alert.messageText = "Hello"
            alert.informativeText = "no file to find"
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    func DisplayLatestPic() -> String{
        var finalpath = ""
        let stringArray = GetListOfFilesHandler.GetListOfFiles()
        if (stringArray == nil){
            print("reflect folder is nil")
        }
        else{
            //print(stringArray![0])
            let Defaultpath = Settings.getUserDefaultFolderPath
            let displayImageFolder = Defaultpath().absoluteString + stringArray![0]
            print(displayImageFolder)
            let picPath = GetListOfFilesHandler.GetLatestImage(path: URL(string : displayImageFolder)!)
            if picPath == nil{
                print("latest pic is nil")
            }
            else{
                print(picPath![0])
                let finalPicPath = displayImageFolder + "/" + picPath![0]
                print(finalPicPath)
                finalpath = finalPicPath
            }
        }
        return finalpath
    }
    
    func TimeSubstringFromPhotoName(ScreenshotName : String) -> String{
        //Screenshot-3.6,17:59:00.jpg
        //  /Users/donghanhu/Documents/Reflect/2019-3-6-1/Screenshot-15:38:45.jpg
        let photoname =  ScreenshotName
        let RelatedInformationHandler = RelatedInformation()
        //json path
        let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
        //Correspoing screenshots file name, "Screenshot-11.26.35 PM.jpg"
        let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
        print(JsonFilePath)
        print(ImageName)
        var name = ""
        let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
        if DicMessage["PhotoName"] != nil{
            name = DicMessage["PhotoName"] as! String
        }
        guard let start = name.characters.index(of: "-") else { return "error" }
        guard let end = name.characters.index(of: "j") else { return "error" }
        
        let subStr = name[start..<end]
        let newStart = subStr.index(subStr.startIndex, offsetBy: 1)
        let newEnd = subStr.index(subStr.endIndex, offsetBy : -1)
        let range = newStart..<newEnd
        let temp = subStr[range]
        return String(temp)
    }
    
    @IBAction func TestButton(_ sender: Any) {
        let OpenSoftwarehandler = OpenSoftware()
        OpenSoftwarehandler.openSoftwareBasedInfor(name: InforOne.stringValue, urlAndPath: InforFour.stringValue)
    }
    
    func AutomaticPlayFunc(){
        if(self.playImageTimer.isValid){
            self.stopPlaying()
        }
        else{
            //ButtonOfPlay.title = "Pause"
            imageButtonPlay.image = NSImage(named : NSImage.Name(rawValue: "PauseIcon"))
            self.startPlaying()
        }
    }
    
    var repeatBool : Bool = true
    var speedOfSlider : Float = 0.0
    
    
    func startPlaying(){
        let speed = SliderOfSpeed.floatValue
        speedOfSlider = speed
        self.playImageTimer = Timer.scheduledTimer(timeInterval: TimeInterval(speed), target: self, selector: #selector(self.imagePlay), userInfo: nil, repeats: repeatBool)
    }
    
    @objc func imagePlay(){
        openEnclosingFolderButton.isEnabled = true
        let temp = Int(Slider.doubleValue)
        
        if SliderOfSpeed.floatValue != speedOfSlider{
            //startPlaying()
            self.playImageTimer.invalidate()
            self.startPlaying()
        }
        if temp < Int(Slider.maxValue) {
            if PhotoNameList != []{
                let photoname = PhotoNameList[temp + 1]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                Slider.doubleValue += 1
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    InforTwo.stringValue = DicMessage["PhotoName"] as! String
                }
                
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                }
                else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                }
                else{
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
        } else {
            self.playImageTimer.invalidate()
            imageButtonPlay.image = NSImage(named : NSImage.Name(rawValue: "PlayIcon"))
        }
    }
    
    func stopPlaying(){
        self.playImageTimer.invalidate()
        imageButtonPlay.image = NSImage(named : NSImage.Name(rawValue: "PlayIcon"))
        //ButtonOfPlay.title = "play"
    }
    
    
    @IBAction func imageButtonPlay(_ sender: Any) {
        if (Int(Slider.doubleValue) < Int(Slider.maxValue)){
            self.AutomaticPlayFunc()
        }
    }
    
    
    @IBAction func MenuBoxOptionAction(_ sender: Any) {
        openEnclosingFolderButton.isEnabled = true
        let timeinterval = ComboBoxOfMenu.stringValue
        if (timeinterval == "recent 1 hour"){
            let ReplayingOneHandler = ReplayingOne()
            PhotoNameList = ReplayingOneHandler.FetchOneHours() as! [String]
            let last = PhotoNameList.count - 1
            
            if PhotoNameList.count == 0{
                print("no photo recorded")
                let alert = NSAlert.init()
                alert.messageText = "Hello"
                alert.informativeText = "No photo recorded from last 1 hour, this image is the last screenshot"
                alert.addButton(withTitle: "OK")
                //alert.addButton(withTitle: "Cancel")
                alert.runModal()
                
            }else{
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
                MultiLineOfPastTime.stringValue = monthChange(str : startTime)
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
//                if DicMessage["category"] != nil{
//                    InforThree.stringValue = DicMessage["category"] as! String
//                }
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                }
                else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                }
                else{
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
                
            }
        }
        else if (timeinterval == "recent 5 hours"){
            let ReplayingOneHandler = ReplayingOne()
            
            PhotoNameList = ReplayingOneHandler.FetchFiveHours() as! [String]
            let last = PhotoNameList.count - 1
            //ReplayingOneHandler.FetchThreeHours()
            
            if PhotoNameList.count == 0{
                print("no photo recorded")
                let alert = NSAlert.init()
                alert.messageText = "Hello"
                alert.informativeText = "No photo recorded from last 5 hour, this image is the last screenshot"
                alert.addButton(withTitle: "OK")
                //alert.addButton(withTitle: "Cancel")
                alert.runModal()
            }else{
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
                MultiLineOfPastTime.stringValue = monthChange(str : startTime)
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
//                if DicMessage["category"] != nil{
//                    InforThree.stringValue = DicMessage["category"] as! String
//                }
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                }
                else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                }
                else{
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
        }
        else if (timeinterval == "recent 3 hours"){
            let ReplayingOneHandler = ReplayingOne()
            PhotoNameList = ReplayingOneHandler.FetchThreeHours() as! [String]
            //print(PhotoNameList)
            let last = PhotoNameList.count - 1
            if PhotoNameList.count == 0{
                print("no photo recorded")
                let alert = NSAlert.init()
                alert.messageText = "Hello"
                alert.informativeText = "No photo recorded from last 3 hour, this image is the last screenshot"
                alert.addButton(withTitle: "OK")
                //alert.addButton(withTitle: "Cancel")
                alert.runModal()
            }else{
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
                MultiLineOfPastTime.stringValue = monthChange(str : startTime)
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
//                if DicMessage["category"] != nil{
//                    InforThree.stringValue = DicMessage["category"] as! String
//                }
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                }
                else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                }
                else{
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
        }
        else if (timeinterval == "recent 8 hours"){
            let ReplayingOneHandler = ReplayingOne()
            PhotoNameList = ReplayingOneHandler.FetchEightHours() as! [String]
            let last = PhotoNameList.count - 1
            print(PhotoNameList)
            
            if PhotoNameList.count == 0{
                print("no photo recorded")
                let alert = NSAlert.init()
                alert.messageText = "Hello"
                alert.informativeText = "No photo recorded from last 8 hour, this image is the last screenshot"
                alert.addButton(withTitle: "OK")
                //alert.addButton(withTitle: "Cancel")
                alert.runModal()
            }else{
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
                MultiLineOfPastTime.stringValue = monthChange(str : startTime)
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
//                if DicMessage["category"] != nil{
//                    InforThree.stringValue = DicMessage["category"] as! String
//                }
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                }
                else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                }
                else{
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
            
        }
        else if (timeinterval == "recent 24 hours"){
            //Fetch24Hours()
            let ReplayingOneHandler = ReplayingOne()
            
            PhotoNameList = ReplayingOneHandler.Fetch24Hours() as! [String]
            let last = PhotoNameList.count - 1
            
            //MultiLineOfPastTime.stringValue = startTime
            if PhotoNameList.count == 0{
                print("no photo recorded")
                let alert = NSAlert.init()
                alert.messageText = "Hello"
                alert.informativeText = "No photo recorded from last 24 hour, this image is the last screenshot"
                alert.addButton(withTitle: "OK")
                //alert.addButton(withTitle: "Cancel")
                alert.runModal()
            }else{
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
                MultiLineOfPastTime.stringValue = monthChange(str : startTime)
                photonumber = PhotoNameList.count - 1
                print(photonumber)
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
//                if DicMessage["category"] != nil{
//                    InforThree.stringValue = DicMessage["category"] as! String
//                }
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                }
                else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                }
                else{
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
            
        }
        else if (timeinterval == "today"){
            let ReplayingOneHandler = ReplayingOne()
            PhotoNameList = ReplayingOneHandler.FetchPhotoToday() as! [String]
            let string = PastTimeToday() + "00:00:00"
            let last = PhotoNameList.count - 1
            //print(PhotoNameList[0])
            
            if PhotoNameList.count == 0{
                print("no photo recorded")
                let alert = NSAlert.init()
                alert.messageText = "Hello"
                alert.informativeText = "No photo recorded today, this image is the last screenshot"
                alert.addButton(withTitle: "OK")
                //alert.addButton(withTitle: "Cancel")
                alert.runModal()
            }else{
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                
                MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
                MultiLineOfPastTime.stringValue = monthChange(str : startTime)
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
//                if DicMessage["category"] != nil{
//                    InforThree.stringValue = DicMessage["category"] as! String
//                }
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                }
                else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                }
                else{
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
            //let RelatedInformationHandler = RelatedInformation()
            //            photonumber = PhotoNameList.count - 1
            //            SliderValueSet()
            //            Slider.doubleValue = Slider.minValue
            //            let photoname = PhotoNameList[Int(Slider.minValue)]
            //            let nsImage = NSImage(contentsOfFile: photoname)
            //            ImageDisplayArea.image = nsImage
        }
        else if (timeinterval == "recent 3 days"){
            let ReplayingOneHandler = ReplayingOne()
            PhotoNameList = ReplayingOneHandler.FetchThreeday() as! [String]
            let last = PhotoNameList.count - 1
            
            if PhotoNameList.count == 0{
                print("no photo recorded")
                let alert = NSAlert.init()
                alert.messageText = "Hello"
                alert.informativeText = "No photo recorded from last 3 days, this image is the last screenshot"
                alert.addButton(withTitle: "OK")
                //alert.addButton(withTitle: "Cancel")
                alert.runModal()
            } else {
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
                MultiLineOfPastTime.stringValue = monthChange(str : startTime)
                photonumber = PhotoNameList.count - 1
                print(photonumber)
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
//                if DicMessage["category"] != nil{
//                    InforThree.stringValue = DicMessage["category"] as! String
//                }
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                }
                else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                }
                else{
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                }
                else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                }
                else{
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
        } else if (timeinterval == "recent 5 days"){
            let ReplayingOneHandler = ReplayingOne()
            PhotoNameList = ReplayingOneHandler.FetchFiveday() as! [String]
            let last = PhotoNameList.count - 1
            
            if PhotoNameList.count == 0{
                print("no photo recorded")
                let alert = NSAlert.init()
                alert.messageText = "Hello"
                alert.informativeText = "No photo recorded from last 5 days, this image is the last screenshot"
                alert.addButton(withTitle: "OK")
                //alert.addButton(withTitle: "Cancel")
                alert.runModal()
            } else {
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
                MultiLineOfPastTime.stringValue = monthChange(str : startTime)
                photonumber = PhotoNameList.count - 1
                print(photonumber)
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                
                if DicMessage["SoftwareName"] != nil {
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                
                if DicMessage["PhotoName"] != nil {
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
                
                if DicMessage["FilePath"] != nil {
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                } else if DicMessage["FrontmostPageUrl"] != nil {
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                } else {
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                
                if DicMessage["FrontmostPageTitle"] != nil {
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                } else if DicMessage["FileName"] != nil {
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                } else {
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
        } else if (timeinterval == "recent 7 days"){
            let ReplayingOneHandler = ReplayingOne()
            PhotoNameList = ReplayingOneHandler.FetchSevenday() as! [String]
            let last = PhotoNameList.count - 1
            
            if PhotoNameList.count == 0{
                print("no photo recorded")
                let alert = NSAlert.init()
                alert.messageText = "Hello"
                alert.informativeText = "No photo recorded from last 7 days, this image is the last screenshot"
                alert.addButton(withTitle: "OK")
                //alert.addButton(withTitle: "Cancel")
                alert.runModal()
            } else {
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
                MultiLineOfPastTime.stringValue = monthChange(str : startTime)
                photonumber = PhotoNameList.count - 1
                print(photonumber)
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
                let RelatedInformationHandler = RelatedInformation()
                let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
                let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
                let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
                if DicMessage["SoftwareName"] != nil{
                    //print(DicMessage["SoftwareName"])
                    InforOne.stringValue = DicMessage["SoftwareName"] as! String
                }
                if DicMessage["PhotoName"] != nil{
                    let photoNameString = DicMessage["PhotoName"] as! String
                    let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                    InforTwo.stringValue = printTimeString
                }
                
                if DicMessage["FilePath"] != nil{
                    FilePathOrURL.stringValue = "File Path"
                    InforFour.stringValue = DicMessage["FilePath"] as! String
                } else if DicMessage["FrontmostPageUrl"] != nil{
                    FilePathOrURL.stringValue = "Page URL"
                    InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                    openEnclosingFolderButton.isEnabled = false
                } else {
                    FilePathOrURL.stringValue = "File Path or Page URL"
                    InforFour.stringValue = "null"
                }
                
                if DicMessage["FrontmostPageTitle"] != nil{
                    PageTitalOrFileName.stringValue = "Page Title"
                    InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
                } else if DicMessage["FileName"] != nil{
                    PageTitalOrFileName.stringValue = "File Name"
                    InforFive.stringValue = DicMessage["FileName"] as! String
                } else {
                    PageTitalOrFileName.stringValue = "Page Tital or File Name"
                    InforFive.stringValue = "nil"
                }
            }
        }
    }
    
    
    @IBAction func CloseWindow(_ sender: Any) {
        self.view.window?.windowController?.close()
        UserData.timelapseWindowIsOpen = false
        UserData.TimelapseWindowController = nil
    }

    
    func monthChange(str : String) -> String{
        let monthIndex = str.index(str.startIndex, offsetBy : 2)
        let monthDigit = String(str[..<monthIndex])
        let dictionary = [
            "01"    : "Jan",
            "02"    : "Feb",
            "03"    : "Mar",
            "04"    : "Apr",
            "05"    : "May",
            "06"    : "June",
            "07"    : "Jul",
            "08"    : "Aug",
            "09"    : "Sept",
            "10"    : "Oct",
            "11"    : "Nove",
            "12"    : "Dec"
        ]
        let monthName = dictionary[monthDigit]
        let dayIndexStart = str.index(str.startIndex, offsetBy : 3)
        let datIndexEnd = str.index(str.endIndex, offsetBy : -9)
        let dayDigit = String(str[dayIndexStart..<datIndexEnd])
        let dictionaryForDay = [
            "01"    : "1st",
            "02"    : "2nd",
            "03"    : "3rd",
            "04"    : "4th",
            "05"    : "5th",
            "06"    : "6th",
            "07"    : "7th",
            "08"    : "8th",
            "09"    : "9th",
            "10"    : "10th",
            "11"    : "11st",
            "12"    : "12nd",
            "13"    : "13rd",
            "14"    : "14th",
            "15"    : "15th",
            "16"    : "16th",
            "17"    : "17th",
            "18"    : "18th",
            "19"    : "19th",
            "20"    : "20th",
            "21"    : "21st",
            "22"    : "22nd",
            "23"    : "23rd",
            "24"    : "24th",
            "25"    : "25th",
            "26"    : "26th",
            "27"    : "27th",
            "28"    : "28th",
            "29"    : "29th",
            "30"    : "30th",
            "31"    : "31st"
        ]
        let dayName = dictionaryForDay[dayDigit]
        
        let timeIndex = str.index(str.endIndex, offsetBy : -8)
        let timeDigit = String(str[timeIndex...])
        let final = monthName! + " " + dayName! + ", " + timeDigit
        return final
    }
    
    
    func PhotonameChangeToTime(photoNameString : String) -> String{
        //   /Screenshot-03.18,16:03:21.jpg
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let start = photoNameString.index(photoNameString.startIndex, offsetBy: 15)
        let end = photoNameString.index(photoNameString.endIndex, offsetBy: -13)
        let range = start..<end
        let photoDay = photoNameString[range]
        let intDay = Int(photoDay)
        let startOfTime = photoNameString.index(photoNameString.startIndex, offsetBy: 18)
        let endOfTime = photoNameString.index(photoNameString.endIndex, offsetBy: -4)
        let rangeOfTime = startOfTime..<endOfTime
        let time = photoNameString[rangeOfTime]
        let yesterday = GetYesterdayDate(date: date, Day: 1)
        let intYesterday = Int(yesterday)
        let startOfTimeWithDay = photoNameString.index(photoNameString.startIndex, offsetBy: 12)
        let endOfTimeWithDay = photoNameString.index(photoNameString.endIndex, offsetBy: -4)
        //let timeWithDay = photoNameString[rangeOfTimeWithDay]
        if day == intDay{
            let result = "(Today)" + time
            return result
        }
        else if (intDay == intYesterday){
            let result = "(Yesterday)" + time
            return result
        }
        else{
            let result = monthChangeForTime(str : photoNameString) + " " + time
            return result
        }
    }
    
    
    func GetYesterdayDate(date : Date, Day : Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        let tempDayValue = (-1) * Day
        let tempdate = Calendar.current.date(byAdding: .day, value: tempDayValue, to: Date())
        let dateString = dateFormatter.string(from: tempdate!)
        let final = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "dd"
        let date24 = dateFormatter.string(from: final!)
        return date24
    }
    
    //  /Screenshot-03.18,16:03:21.jpg
    func monthChangeForTime(str : String) -> String{
        let monthStartIndex = str.index(str.startIndex, offsetBy : 12)
        let monthEndIndex = str.index(str.endIndex, offsetBy: -16)
        let rangeForMonth = monthStartIndex..<monthEndIndex
        let monthDigit = String(str[rangeForMonth])
        let dictionary = [
            "01"    : "Jan",
            "02"    : "Feb",
            "03"    : "Mar",
            "04"    : "Apr",
            "05"    : "May",
            "06"    : "June",
            "07"    : "Jul",
            "08"    : "Aug",
            "09"    : "2019, September",
            "10"    : "Oct",
            "11"    : "Nove",
            "12"    : "Dec"
        ]
        let monthName = dictionary[monthDigit]
        
        let dayIndexStart = str.index(str.startIndex, offsetBy : 15)
        let datIndexEnd = str.index(str.endIndex, offsetBy : -13)
        let dayDigit = String(str[dayIndexStart..<datIndexEnd])
        let dictionaryForDay = [
            "01"    : "1st",
            "02"    : "2nd",
            "03"    : "3rd",
            "04"    : "4th",
            "05"    : "5th",
            "06"    : "6th",
            "07"    : "7th",
            "08"    : "8th",
            "09"    : "9th",
            "10"    : "10th",
            "11"    : "11st",
            "12"    : "12nd",
            "13"    : "13rd",
            "14"    : "14th",
            "15"    : "15th",
            "16"    : "16th",
            "17"    : "17th",
            "18"    : "18th",
            "19"    : "19th",
            "20"    : "20th",
            "21"    : "21st",
            "22"    : "22nd",
            "23"    : "23rd",
            "24"    : "24th",
            "25"    : "25th",
            "26"    : "26th",
            "27"    : "27th",
            "28"    : "28th",
            "29"    : "29th",
            "30"    : "30th",
            "31"    : "31st"
        ]
        let dayName = dictionaryForDay[dayDigit]
        let final = monthName! + " " + dayName!
        return final
    }
    
    func makeFrontmost(){
        let first = "tell application \"System Events\" \n perform action \"AXRaise\" of window 1 of process \"Finder\" \n end tell"
        var error: NSDictionary?
        let scriptObject = NSAppleScript(source: first)
        scriptObject!.executeAndReturnError(&error)
        if (error != nil) {
            let errorHandler = SoftwareClassifier()
            errorHandler.writeError(error : error!)
            print("error: \(String(describing: error))")
        }
    }
    
    @IBAction func PreviousVideoClickButton(_ sender: Any) {
        openEnclosingFolderButton.isEnabled = true
        Slider.doubleValue = Slider.minValue
        let temp = Int(Slider.doubleValue)
        if PhotoNameList != []{
            let photoname = PhotoNameList[temp]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
            Slider.doubleValue -= 1
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            if DicMessage["SoftwareName"] != nil{
                InforOne.stringValue = DicMessage["SoftwareName"] as! String
            }
            if DicMessage["PhotoName"] != nil{
                let photoNameString = DicMessage["PhotoName"] as! String
                let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                InforTwo.stringValue = printTimeString
            }
            
            if DicMessage["FilePath"] != nil{
                FilePathOrURL.stringValue = "File Path"
                InforFour.stringValue = DicMessage["FilePath"] as! String
            }
            else if DicMessage["FrontmostPageUrl"] != nil{
                FilePathOrURL.stringValue = "Page Url"
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                openEnclosingFolderButton.isEnabled = false
            }
            else{
                FilePathOrURL.stringValue = "File Path or Page URL"
                InforFour.stringValue = "null"
            }
            if DicMessage["FrontmostPageTitle"] != nil{
                PageTitalOrFileName.stringValue = "Page Title"
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            }
            else if DicMessage["FileName"] != nil{
                PageTitalOrFileName.stringValue = "File Name"
                InforFive.stringValue = DicMessage["FileName"] as! String
            }
            else{
                PageTitalOrFileName.stringValue = "Page Tital or File Name"
                InforFive.stringValue = "nil"
            }
        }
        
    }
    // end of PreviousVideoClickButton
    @IBAction func NextVideoClickButton(_ sender: Any) {
        openEnclosingFolderButton.isEnabled = true
        Slider.doubleValue = Slider.maxValue
        let temp = Int(Slider.doubleValue)
        if PhotoNameList != []{
            let photoname = PhotoNameList[temp]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
            Slider.doubleValue += 1
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            
            if DicMessage["SoftwareName"] != nil{
                InforOne.stringValue = DicMessage["SoftwareName"] as! String
            }
            
            if DicMessage["PhotoName"] != nil{
                let photoNameString = DicMessage["PhotoName"] as! String
                let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                InforTwo.stringValue = printTimeString
            }
            
            if DicMessage["FilePath"] != nil{
                FilePathOrURL.stringValue = "File Path"
                InforFour.stringValue = DicMessage["FilePath"] as! String
            } else if DicMessage["FrontmostPageUrl"] != nil{
                FilePathOrURL.stringValue = "Page URL"
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                openEnclosingFolderButton.isEnabled = false
            } else {
                FilePathOrURL.stringValue = "File Path or Page URL"
                InforFour.stringValue = "null"
            }
            
            if DicMessage["FrontmostPageTitle"] != nil{
                PageTitalOrFileName.stringValue = "Page Title"
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            } else if DicMessage["FileName"] != nil{
                PageTitalOrFileName.stringValue = "File Name"
                InforFive.stringValue = DicMessage["FileName"] as! String
            } else {
                PageTitalOrFileName.stringValue = "Page Tital or File Name"
                InforFive.stringValue = "nil"
            }

        }
    }
    
    open var windowController: NSWindowController?
    var sub1WindowController: NSWindowController?
    
    var boolValue = false
    
    @IBAction func CropImageClick(_ sender: Any) {
        let temp = Int(Slider.doubleValue)
        if PhotoNameList != [] && boolValue == false{
            let photoname = PhotoNameList[temp]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            let screen = NSScreen.main
            let rect = screen?.frame
            let width = Int((rect?.size.width)!)
            let ratio = width / Int(nsImage!.size.width)
            var first = 0
            var second = 0
            var third = 0
            var forth = 0
            let arrayOfBound = DicMessage["bound"]
            if arrayOfBound != nil{
                let boundInfor = arrayOfBound as! [String]
                print(boundInfor)
                if boundInfor != [] {
                    first = Int(boundInfor[0])! / ratio
                    second = Int(boundInfor[1])! / ratio
                    third = Int(boundInfor[2])! / ratio
                    forth = Int(boundInfor[3])! / ratio
                    let heightOfSoftware = forth - second
                    let widthOfSoftware = third - first
                    let cropimage = NSImage(contentsOfFile: photoname)
                    let xPosition = first
                    let yPosition = second
                    
                    let newImage = cropimage?.cgImage(forProposedRect: nil, context: nil, hints: nil)
                    
                    let cropZone = CGRect(x: CGFloat(xPosition * 2), y: CGFloat(yPosition * 2), width: CGFloat(widthOfSoftware * 2), height: CGFloat(heightOfSoftware * 2))
                    
                    let cutImageRef : CGImage = newImage!.cropping(to:cropZone)!
                    let newNSImage = NSImage(cgImage: cutImageRef, size: NSSize(width: cutImageRef.width, height: cutImageRef.height))
                    ImageDisplayArea.image = newNSImage
                    boolValue = true
                    croppedButton.title = "Undo"
                } else {
                    let alert = NSAlert.init()
                    alert.messageText = "Hello"
                    alert.informativeText = "Can't crop this image with invalid information"
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
            }
        } else if PhotoNameList != [] && boolValue == true{
            boolValue = false
            croppedButton.title = "Crop"
            let photoname = PhotoNameList[temp]
            //photoname is the path of screenshots
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
        }
    }

    @IBAction func datePickFunction(_ sender: Any) {
        openEnclosingFolderButton.isEnabled = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        //sleep(UInt32(1))
        print(datePick.dateValue)
        let result = dateFormatter.string(from: datePick.dateValue)
        print(result)
        let ReplayingOneHandler = ReplayingOne()
        
        PhotoNameList = ReplayingOneHandler.FetchSomeday(SomeDay: result) as! [String]
        let last = PhotoNameList.count - 1
        if PhotoNameList.count == 0{
            print("no photo recorded")
            let alert = NSAlert.init()
            alert.messageText = "Hello"
            alert.informativeText = "No photo recorded from this day, this image is the last screenshot"
            alert.addButton(withTitle: "OK")
            //alert.addButton(withTitle: "Cancel")
            alert.runModal()
        } else {
            let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
            let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
            MultiLineOfCurrentTime.stringValue = monthChange(str: endTime)
            MultiLineOfPastTime.stringValue = monthChange(str : startTime)
            photonumber = PhotoNameList.count - 1
            SliderValueSet()
            Slider.doubleValue = Slider.maxValue
            let photoname = PhotoNameList[Int(Slider.maxValue)]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            if DicMessage["SoftwareName"] != nil{
                //print(DicMessage["SoftwareName"])
                InforOne.stringValue = DicMessage["SoftwareName"] as! String
            }
            if DicMessage["PhotoName"] != nil{
                let photoNameString = DicMessage["PhotoName"] as! String
                let printTimeString = PhotonameChangeToTime(photoNameString: photoNameString)
                InforTwo.stringValue = printTimeString
            }
            if DicMessage["FilePath"] != nil{
                FilePathOrURL.stringValue = "File Path"
                InforFour.stringValue = DicMessage["FilePath"] as! String
            }
            else if DicMessage["FrontmostPageUrl"] != nil{
                FilePathOrURL.stringValue = "Page URL"
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
                openEnclosingFolderButton.isEnabled = false
            }
            else{
                FilePathOrURL.stringValue = "File Path or Page URL"
                InforFour.stringValue = "null"
            }
            if DicMessage["FrontmostPageTitle"] != nil{
                PageTitalOrFileName.stringValue = "Page Title"
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            }
            else if DicMessage["FileName"] != nil{
                PageTitalOrFileName.stringValue = "File Name"
                InforFive.stringValue = DicMessage["FileName"] as! String
            }
            else{
                PageTitalOrFileName.stringValue = "Page Tital or File Name"
                InforFive.stringValue = "nil"
            }
        }
    }
    
    
    @IBAction func datePickConfirmButton(_ sender: Any) {
        self.view.window?.windowController?.close()
        UserData.timelapseWindowIsOpen = false
        UserData.TimelapseWindowController = nil
    }
}
