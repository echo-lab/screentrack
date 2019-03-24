//
//  Method_One_Display_ViewControl.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/8/19.
//

import Cocoa
@available(OSX 10.13, *)


class Method_One_Display_ViewControl: NSViewController, NSTextViewDelegate {
    @IBOutlet weak var Slider: NSSlider!
    var photonumber = 0
    var PhotoNameList = [String]()
    
    var TimerPlayButton = Timer()

    @IBOutlet weak var MultiLineOfPastTime: NSTextField!
    @IBOutlet weak var MultiLineLabelOfCurrentTime: NSTextField!
    
    @IBOutlet weak var ImageDisplayArea: NSImageView!
    
    @IBOutlet weak var CurrentTimeTextField: NSTextField!
    
    @IBOutlet weak var InformationDisplayArea: NSTextField!
    
    @IBOutlet weak var ComboBoxOfMenu: NSComboBoxCell!
    @IBOutlet weak var PlayButton: NSButton!
    
    @IBOutlet weak var InforTwo: NSTextField!
    @IBOutlet weak var InforOne: NSTextField!
    @IBOutlet weak var InforFive: NSTextField!
    @IBOutlet weak var InforFour: NSTextField!
    @IBOutlet weak var InforThree: NSTextField!
    
    
    let GetListOfFilesHandler = FindScreenShot()
    
    var timerCurrentTime = Timer()

//    override func viewDidAppear() {
//        super.viewDidAppear()
////        DefaultInformationDisplay()
////        DefaultDisplayToday()
////        MultiLineOfPastTime.stringValue = ""
////        DefaultComboMenu()
////        timerCurrentTime.invalidate()
//        self.timerCurrentTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.CurrentTime), userInfo: nil, repeats: true)
//    }
//
//    override func viewWillAppear() {
//        //timerCurrentTime.fire()
//        self.timerCurrentTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.CurrentTime), userInfo: nil, repeats: true)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //DefaultImageDisplay()
        DefaultInformationDisplay()
        DefaultDisplayToday()
        MultiLineOfPastTime.stringValue = ""
        MultiLineLabelOfCurrentTime.stringValue = ""
        DefaultComboMenu()
        print("view did load")
//        timerCurrentTime.invalidate()
//        self.timerCurrentTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.CurrentTime), userInfo: nil, repeats: true)
//        for i in 99..<101{
//            sleep(1)
//            print(i)
//        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = DateFormatter.Style.none
//        dateFormatter.timeStyle = DateFormatter.Style.medium
//        dateFormatter.dateFormat = "M-d, HH:mm:ss"
//        let temp = dateFormatter.string(from: NSDate() as Date)
//        MultiLineLabelOfCurrentTime.stringValue = temp
//        self.timerCurrentTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.CurrentTime), userInfo: nil, repeats: true)
    }
    override func viewDidAppear() {
        print("test")
//        super.viewDidAppear()
//        self.timerCurrentTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.CurrentTime), userInfo: nil, repeats: true)
        
//        for i in 0..<2{
//            print(i)
//            sleep(1)
//        }
//
    }
    

//    override func viewDidAppear() {
//         self.timerCurrentTime = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.CurrentTime), userInfo: nil, repeats: true)
//    }
    
    //
    func InitialInforLabels(){
        
    }
    //show current time
    @objc func CurrentTime(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "M-d, HH:mm:ss"
        let temp = dateFormatter.string(from: NSDate() as Date)
        print(temp)
        MultiLineLabelOfCurrentTime.stringValue = temp
    }
    //end of the function of show current time
    func DefaultDisplayToday(){
        let ReplayingOneHandler = ReplayingOne()
        PhotoNameList = ReplayingOneHandler.FetchPhotoToday() as! [String]
        if PhotoNameList.count == 0{
            print("today has no photo recorded")
            DefaultImageDisplay()
            InformationDisplayArea.stringValue = "Today has no photo recorded, This is your last screenshot"
            
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
                InforTwo.stringValue = DicMessage["PhotoName"] as! String
            }
            if DicMessage["category"] != nil{
                InforThree.stringValue = DicMessage["category"] as! String
            }
            if DicMessage["FilePath"] != nil{
                InforFour.stringValue = DicMessage["FilePath"] as! String
            }
            else if DicMessage["FrontmostPageUrl"] != nil{
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
            }
            else{
                InforFour.stringValue = "null"
            }
            if DicMessage["FrontmostPageTitle"] != nil{
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            }
            else if DicMessage["FileName"] != nil{
                InforFive.stringValue = DicMessage["FileName"] as! String
            }
            else{
                InforFive.stringValue = "nil"
            }
            
        }
        
    }
    //
    func DefaultComboMenu(){
        let singularNouns = ["today", "recent 1 hour", "recent 3 hours", "recent 5 hours", "recent 8 hours", "recent 24 hours", "recent 3 days", "recent 5 days", "recent 7 days"]
        ComboBoxOfMenu.removeAllItems()
        ComboBoxOfMenu.addItems(withObjectValues: singularNouns)
        //let number = singularNouns.count
        ComboBoxOfMenu.selectItem(at: 0)
    }
    
    func DefaultImageDisplay(){
        if DisplayLatestPic() == ""{
            let defaultImage = NSImage(named : "DefaultDisplayImage")
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
            //InformationDisplayArea.stringValue = DicMessage.description
            if DicMessage["SoftwareName"] != nil{
                print(DicMessage["SoftwareName"])
                InforOne.stringValue = DicMessage["SoftwareName"] as! String
            }
            if DicMessage["PhotoName"] != nil{
                InforTwo.stringValue = DicMessage["PhotoName"] as! String
            }
            if DicMessage["category"] != nil{
                InforThree.stringValue = DicMessage["category"] as! String
            }
            if DicMessage["FilePath"] != nil{
                InforFour.stringValue = DicMessage["FilePath"] as! String
            }
            else if DicMessage["FrontmostPageUrl"] != nil{
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
            }
            else{
                InforFour.stringValue = "null"
            }
            if DicMessage["FrontmostPageTitle"] != nil{
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            }
            else if DicMessage["FileName"] != nil{
                InforFive.stringValue = DicMessage["FileName"] as! String
            }
            else{
                InforFive.stringValue = "nil"
            }
        }
        
        
    }
    
    func DefaultInformationDisplay(){
        let message = "Good Morning"
        InformationDisplayArea.stringValue = message
        //DisplayFilePath.stringValue = ""
        
    }


    @IBAction func TodayPhotoButton(_ sender: Any) {
        let ReplayingOneHandler = ReplayingOne()
        PhotoNameList = ReplayingOneHandler.FetchPhotoToday() as! [String]
        //let RelatedInformationHandler = RelatedInformation()
        //ReplayingOneHandler.FetchThreeHours()
        photonumber = PhotoNameList.count - 1
        SliderValueSet()
        //print(Slider.maxValue)
        Slider.doubleValue = Slider.minValue
        let photoname = PhotoNameList[Int(Slider.minValue)]
        let nsImage = NSImage(contentsOfFile: photoname)
        ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
        ImageDisplayArea.image = nsImage
        //print(PhotoNameList)
    }
    
    func SliderValueSet(){
        let maxvalue = photonumber
//        print("macvalue")
//        print(maxvalue)
//        print(PhotoNameList[0])
        Slider.minValue = 0
        Slider.maxValue = Double(maxvalue)
    }
    
    
    @IBAction func SliderAction(_ sender: Any) {
        let index = Int((sender as AnyObject).doubleValue)
        // code here
        let photoname = PhotoNameList[index]
        //print(photoname)
        //photo name is the silder's current position corresponding photo
        //photo name is paht now
        let nsImage = NSImage(contentsOfFile: photoname)
        //print(photoname)
        ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
        ImageDisplayArea.image = nsImage
        //ImageDisplayArea.image = nsImage as? NSImage
        
        //photoname is the name of screenshot, full path
        let RelatedInformationHandler = RelatedInformation()
        //json path
        let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
        //Correspoing screenshots file name, "Screenshot-11.26.35 PM.jpg"
        let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
        //print(JsonFilePath)
        //print(ImageName)
        let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
        //print(DicMessage)
        //DicMessage.description
        //InformationDisplayArea.textStorage?.append(NSAttributedString(string: DicMessage.description))
        //InformationDisplayArea.stringValue = DicMessage.description
        if DicMessage["SoftwareName"] != nil{
            print(DicMessage["SoftwareName"])
            InforOne.stringValue = DicMessage["SoftwareName"] as! String
        }
        if DicMessage["PhotoName"] != nil{
            InforTwo.stringValue = DicMessage["PhotoName"] as! String
        }
        if DicMessage["category"] != nil{
            InforThree.stringValue = DicMessage["category"] as! String
        }
        if DicMessage["FilePath"] != nil{
            InforFour.stringValue = DicMessage["FilePath"] as! String
        }
        else if DicMessage["FrontmostPageUrl"] != nil{
            InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
        }
        else{
            InforFour.stringValue = "null"
        }
        if DicMessage["FrontmostPageTitle"] != nil{
            InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
        }
        else if DicMessage["FileName"] != nil{
            InforFive.stringValue = DicMessage["FileName"] as! String
        }
        else{
            InforFive.stringValue = "nil"
        }
        
        
    }
    
    
    @IBAction func PreviousButton(_ sender: Any) {
        let temp = Int(Slider.doubleValue)
        //print(temp)
        if temp > 0 {
            let photoname = PhotoNameList[temp - 1]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
            Slider.doubleValue -= 1
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            //InformationDisplayArea.stringValue = DicMessage.description
            if DicMessage["SoftwareName"] != nil{
                print(DicMessage["SoftwareName"])
                InforOne.stringValue = DicMessage["SoftwareName"] as! String
            }
            if DicMessage["PhotoName"] != nil{
                InforTwo.stringValue = DicMessage["PhotoName"] as! String
            }
            if DicMessage["category"] != nil{
                InforThree.stringValue = DicMessage["category"] as! String
            }
            if DicMessage["FilePath"] != nil{
                InforFour.stringValue = DicMessage["FilePath"] as! String
            }
            else if DicMessage["FrontmostPageUrl"] != nil{
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
            }
            else{
                InforFour.stringValue = "null"
            }
            if DicMessage["FrontmostPageTitle"] != nil{
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            }
            else if DicMessage["FileName"] != nil{
                InforFive.stringValue = DicMessage["FileName"] as! String
            }
            else{
                InforFive.stringValue = "nil"
            }
        }
    }
    
    @IBAction func NextButton(_ sender: Any) {
        let temp = Int(Slider.doubleValue)
        //print(temp)
        if temp < Int(Slider.maxValue) {
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
                print(DicMessage["SoftwareName"])
                InforOne.stringValue = DicMessage["SoftwareName"] as! String
            }
            if DicMessage["PhotoName"] != nil{
                InforTwo.stringValue = DicMessage["PhotoName"] as! String
            }
            if DicMessage["category"] != nil{
                InforThree.stringValue = DicMessage["category"] as! String
            }
            if DicMessage["FilePath"] != nil{
                InforFour.stringValue = DicMessage["FilePath"] as! String
            }
            else if DicMessage["FrontmostPageUrl"] != nil{
                InforFour.stringValue = DicMessage["FrontmostPageUrl"] as! String
            }
            else{
                InforFour.stringValue = "null"
            }
            if DicMessage["FrontmostPageTitle"] != nil{
                InforFive.stringValue = DicMessage["FrontmostPageTitle"] as! String
            }
            else if DicMessage["FileName"] != nil{
                InforFive.stringValue = DicMessage["FileName"] as! String
            }
            else{
                InforFive.stringValue = "nil"
            }
        }
        

    }
    
    
    @IBAction func PlayButtonClick(_ sender: Any) {

        if (Int(Slider.doubleValue) < Int(Slider.maxValue)){
            self.AutomaticPlayFunc()
        }
    }
    
    func AutomaticPlayFunc(){
        if(self.TimerPlayButton.isValid){
            self.stopPlaying()
        }
        else{
            self.startPlaying()
        }
    }
    
    func startPlaying(){
        self.TimerPlayButton = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.printtext), userInfo: nil, repeats: true)
        

    }
    
    func printtext(){
        print("print text")
    }
    
    @objc func PlayNextImage(){
        print("in the playnextiamge func")
        if(Int(Slider.doubleValue) < Int(Slider.maxValue)){
            let index = Int(Slider.doubleValue)
            let photoname = PhotoNameList[index]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
            Slider.doubleValue += 1
        }
        else if(Int(Slider.doubleValue) == Int(Slider.maxValue)){
            let index = Int(Slider.doubleValue)
            let photoname = PhotoNameList[index]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
            ImageDisplayArea.image = nsImage
            self.stopPlaying()
            
        }
        else{
            PlayButton.title = "Stop"
        }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func stopPlaying(){
        self.TimerPlayButton.invalidate()
        PlayButton.title = "play"
    }
    //
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
        //let dateString = dateFormatter.string(from: tempdate!)
        //5:06:52 PM
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
//        let tempHourValue = (-1) * day
        let tempdate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        //let dateString = dateFormatter.string(from: tempdate!)
        //5:06:52 PM
        dateFormatter.dateFormat = "MM.dd, "
        let date24 = dateFormatter.string(from: tempdate!)
        return date24
    }
    //
    func dialogOKCancel(question: String, text: String) {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "OK")
        //alert.addButton(withTitle: "Cancel")
        //return alert.runModal() == NSAlertFirstButtonReturn
    }
    //
    @IBAction func TimeIntervalCheckButton(_ sender: Any) {
        let timeinterval = ComboBoxOfMenu.stringValue
        timerCurrentTime.invalidate()
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
                MultiLineLabelOfCurrentTime.stringValue = endTime
                MultiLineOfPastTime.stringValue = startTime
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
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
                MultiLineLabelOfCurrentTime.stringValue = endTime
                MultiLineOfPastTime.stringValue = startTime
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
            }
        }
        else if (timeinterval == "recent 3 hours"){
            let ReplayingOneHandler = ReplayingOne()
            PhotoNameList = ReplayingOneHandler.FetchThreeHours() as! [String]
            print(PhotoNameList)
            let last = PhotoNameList.count - 1
            //ReplayingOneHandler.FetchThreeHours()
            //code here
            
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
                MultiLineLabelOfCurrentTime.stringValue = endTime
                MultiLineOfPastTime.stringValue = startTime
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
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
                MultiLineLabelOfCurrentTime.stringValue = endTime
                MultiLineOfPastTime.stringValue = startTime
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
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
                MultiLineLabelOfCurrentTime.stringValue = startTime
                MultiLineOfPastTime.stringValue = endTime
                photonumber = PhotoNameList.count - 1
                print(photonumber)
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
            }
            
        }
        else if (timeinterval == "today"){
            let ReplayingOneHandler = ReplayingOne()
            PhotoNameList = ReplayingOneHandler.FetchPhotoToday() as! [String]
            let string = PastTimeToday() + "00:00:00"
            let last = PhotoNameList.count - 1
            print(PhotoNameList[0])
           
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
                MultiLineLabelOfCurrentTime.stringValue = endTime
                MultiLineOfPastTime.stringValue = startTime
                photonumber = PhotoNameList.count - 1
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
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
            }else{
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineLabelOfCurrentTime.stringValue = endTime
                MultiLineOfPastTime.stringValue = startTime
                photonumber = PhotoNameList.count - 1
                print(photonumber)
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
            }
        }
        else if (timeinterval == "recent 5 days"){
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
            }else{
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineLabelOfCurrentTime.stringValue = endTime
                MultiLineOfPastTime.stringValue = startTime
                photonumber = PhotoNameList.count - 1
                print(photonumber)
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
            }
        }
        else if (timeinterval == "recent 7 days"){
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
            }else{
                let startTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[0])
                let endTime = TimeSubstringFromPhotoName( ScreenshotName : PhotoNameList[last])
                MultiLineLabelOfCurrentTime.stringValue = endTime
                MultiLineOfPastTime.stringValue = startTime
                photonumber = PhotoNameList.count - 1
                print(photonumber)
                SliderValueSet()
                Slider.doubleValue = Slider.maxValue
                let photoname = PhotoNameList[Int(Slider.maxValue)]
                let nsImage = NSImage(contentsOfFile: photoname)
                ImageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
                ImageDisplayArea.image = nsImage
            }
        }
        

        print(timeinterval)
    }
    
    
    func DisplayLatestPic() -> String{
        var finalpath = ""
        let stringArray = GetListOfFilesHandler.GetListOfFiles()
        if (stringArray == nil){
            print("reflect folder is nil")
        }
        else{
            //print(stringArray![0])
            let Defaultpath = Settings.DefaultFolder
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
    

    @IBAction func TestButton(_ sender: Any) {
        
        let OpenSoftwarehandler = OpenSoftware()
        OpenSoftwarehandler.openSoftwareBasedInfor(name: InforOne.stringValue, urlAndPath: InforFour.stringValue)
        //self.dismissViewController(self)
        //self.preferredMinimumSize
        
        self.view.isHidden = true
        //super.viewDidDisappear()
    }
    //
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
        let start = name.characters.index(of: "-")
        let end = name.characters.index(of: "j")
        let subStr = name[start..<end]
        let newStart = subStr.index(subStr.startIndex, offsetBy: 1)
        let newEnd = subStr.index(subStr.endIndex, offsetBy : -1)
        let range = newStart..<newEnd
        let temp = subStr[range]
        //print(temp)
        
        
        return temp
        
    }
    
    
    
    //end of the class
}
