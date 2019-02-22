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
    
    var TimerPlayButton : Timer = Timer()

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

//        TimerPlayButton = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.SliderValuePlusOne),
        
 //      self.SliderValuePlusOne()

//        if(Int(Slider.doubleValue) < Int(Slider.maxValue))&&(PlayButton.title == "play"){
//            PlayButton.title = "stop"
//            while(Int(Slider.doubleValue) < Int(Slider.maxValue)){
//                print("in the while loop")
//        while(Slider.doubleValue < Slider.maxValue){
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//                    // Put your code which should be executed with a delay here
//                    self.SliderValuePlusOne()
//                })
//        }
//                usleep(1000000)
//                let photoname = PhotoNameList[Int(Slider.doubleValue)]
//                let nsImage = NSImage(contentsOfFile: photoname)
//                print(photoname)
//                ImageDisplayArea.image = nsImage
//                Slider.doubleValue += 1
//                sleep(1)
//                self.SliderValuePlusOne()
//            }
//        }
//        else if (Int(Slider.doubleValue) == Int(Slider.maxValue)){
//            self.PlayButton.title = "paly"
//        }
//        else{
//            self.PlayButton.title = "paly"
//        }
        
//
        if (Int(Slider.doubleValue) <= Int(Slider.maxValue))&&(PlayButton.title == "play"){
            PlayButton.title = "stop"
//            TimerPlayButton = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.SliderValuePlusOne), userInfo: (Any).self, repeats: true)
//            while (Int(Slider.doubleValue) < Int(Slider.maxValue)){
//            delay(1.0){
//
//                let temp = Int(self.Slider.doubleValue)
//                let photoname = self.PhotoNameList[temp]
//                let nsImage = NSImage(contentsOfFile: photoname)
//                print(photoname)
//                self.ImageDisplayArea.image = nsImage
//                print("yoyo")
//                self.Slider.doubleValue += 1
//            }
//
//            }
            
        }
        else if(Int(Slider.doubleValue) < Int(Slider.maxValue)) && (PlayButton.title == "stop"){
            PlayButton.title = "play"
        }
        else if (Int(Slider.doubleValue) == Int(Slider.maxValue)){
            PlayButton.title = "End"
        }
        
    }
    
    
    func SliderValuePlusOne(){
        let temp = Int(Slider.doubleValue)
            let photoname = PhotoNameList[temp]
            let nsImage = NSImage(contentsOfFile: photoname)
            print(photoname)
            ImageDisplayArea.image = nsImage
        print("yoyo")
            Slider.doubleValue += 1
        
            //sleep(1)
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func stopPlaying(){
        self.TimerPlayButton.invalidate()
    }
    //end of the class
}
