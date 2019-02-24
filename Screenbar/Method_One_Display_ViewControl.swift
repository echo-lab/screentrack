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

    @IBOutlet weak var ImageDisplayArea: NSImageView!
    
    @IBOutlet weak var InformationDisplayArea: NSTextField!
    
    @IBOutlet weak var PlayButton: NSButton!
    @IBOutlet weak var DisplayFilePath: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        DefaultImageDisplay()
        DefaultInformationDisplay()
    }
    
    func DefaultImageDisplay(){
        let defaultImage = NSImage(named : "DefaultDisplayImage")
        ImageDisplayArea.image = defaultImage
        
    }
    func DefaultInformationDisplay(){
        let message = "Good Morning"
        //InformationDisplayArea.textStorage?.append(NSAttributedString(string: message))
        InformationDisplayArea.stringValue = message
        DisplayFilePath.stringValue = ""
        
    }


    @IBAction func TodayPhotoButton(_ sender: Any) {
        let ReplayingOneHandler = ReplayingOne()
        PhotoNameList = ReplayingOneHandler.FetchPhotoToday() as! [String]
        //let RelatedInformationHandler = RelatedInformation()
        
        photonumber = PhotoNameList.count - 1
        SliderValueSet()
        //print(Slider.maxValue)
        Slider.doubleValue = Slider.minValue
        let photoname = PhotoNameList[Int(Slider.minValue)]
        let nsImage = NSImage(contentsOfFile: photoname)
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
        let photoname = PhotoNameList[index]
        //print(photoname)
        //photo name is the silder's current position corresponding photo
        //photo name is paht now
        let nsImage = NSImage(contentsOfFile: photoname)
        //print(photoname)
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
        InformationDisplayArea.stringValue = DicMessage.description
        if DicMessage["file-path"] != nil{
            DisplayFilePath.stringValue = DicMessage["file-path"] as! String
        }
        else if DicMessage["frontmost-page-url"] != nil{
            DisplayFilePath.stringValue = DicMessage["frontmost-page-url"] as! String
        }
        else{
            DisplayFilePath.stringValue = "null"
        }
        
        
    }
    
    
    @IBAction func PreviousButton(_ sender: Any) {
        let temp = Int(Slider.doubleValue)
        //print(temp)
        if temp > 0 {
            let photoname = PhotoNameList[temp - 1]
            let nsImage = NSImage(contentsOfFile: photoname)
            ImageDisplayArea.image = nsImage
            Slider.doubleValue -= 1
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            InformationDisplayArea.stringValue = DicMessage.description
            if DicMessage["file-path"] != nil{
                DisplayFilePath.stringValue = DicMessage["file-path"] as! String
            }
            else if DicMessage["frontmost-page-url"] != nil{
                DisplayFilePath.stringValue = DicMessage["frontmost-page-url"] as! String
            }
            else{
                DisplayFilePath.stringValue = "null"
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
            ImageDisplayArea.image = nsImage
            Slider.doubleValue += 1
            let RelatedInformationHandler = RelatedInformation()
            let JsonFilePath = RelatedInformationHandler.BasedOnImagePathToFindJsonFile(photoname: photoname)
            let ImageName = RelatedInformationHandler.BasedOnImagePathToFindtheImageName(photoname: photoname)
            let DicMessage = RelatedInformationHandler.BasedOnJsonPath(jsonpath : JsonFilePath, screenshot : ImageName)
            InformationDisplayArea.stringValue = DicMessage.description
            if DicMessage["file-path"] != nil{
                DisplayFilePath.stringValue = DicMessage["file-path"] as! String
            }
            else if DicMessage["frontmost-page-url"] != nil{
                DisplayFilePath.stringValue = DicMessage["frontmost-page-url"] as! String
            }
            else{
                DisplayFilePath.stringValue = "null"
            }
        }
        

    }
    
    @IBAction func OpenRelatedFile(_ sender: Any) {
        print(DisplayFilePath.stringValue.description)
        
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
            ImageDisplayArea.image = nsImage
            Slider.doubleValue += 1
        }
        else if(Int(Slider.doubleValue) == Int(Slider.maxValue)){
            let index = Int(Slider.doubleValue)
            let photoname = PhotoNameList[index]
            let nsImage = NSImage(contentsOfFile: photoname)
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
    //end of the class
}
