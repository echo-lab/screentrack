//
//  Method_One_Display_ViewControl.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/8/19.
//

import Cocoa
@available(OSX 10.13, *)


class Method_One_Display_ViewControl: NSViewController {
    @IBOutlet weak var Slider: NSSlider!
    var photonumber = 0
    var PhotoNameList = [String]()
    
    @IBOutlet weak var ImageDisplayArea: NSImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        DefaultImageDisplay()
    }
    
    func DefaultImageDisplay(){
        let defaultImage = NSImage(named : "DefaultDisplayImage")
        ImageDisplayArea.image = defaultImage
        
    }

    @IBAction func TodayPhotoButton(_ sender: Any) {
        let ReplayingOneHandler = ReplayingOne()
        PhotoNameList = ReplayingOneHandler.FetchPhotoToday() as! [String]
        photonumber = PhotoNameList.count - 1
        SliderValueSet()
        print(Slider.maxValue)
        //print(PhotoNameList)
    }
    
    func SliderValueSet(){
        let maxvalue = photonumber
        Slider.minValue = 0
        Slider.maxValue = Double(maxvalue)
    }
    
    
    @IBAction func SliderAction(_ sender: Any) {
        let index = Int((sender as AnyObject).doubleValue)
        let photoname = PhotoNameList[index]
        print(photoname)
        //photo name is the silder's current position corresponding photo
        //photo name is paht now
        
        let nsImage = NSImage(contentsOfFile: photoname)
//
        ImageDisplayArea.image = nsImage as! NSImage
        
        //photoname is the name of screenshot
    }
    
    func ReadImageFromPath(){
        let filemanager = FileManager.default
        //let path = DefaultFolder() + ""
        
    }
    
    
    
}
