//
//  Method_One_Display_Window.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/8/19.
//

import Cocoa

@available(OSX 10.15, *)
class Method_One_Display_Window: NSViewController{

    @IBOutlet weak var menuBoxOutlet: NSComboBox!
    @IBOutlet weak var imageDisplayArea: NSImageCell!
    
    //lazy var window: NSWindow = self.view.window!
    
    
    @IBOutlet weak var testImageView: NSImageView!
    let replayingMethodTwoHandler = ReplayingMethodTwo()
    
    var dictionaryTemp = [String: Int]()

    override func viewDidLoad() {
        
    }
    //view appear after load
    override func viewWillAppear() {
        super.viewWillAppear()
        DefaultComboMenu()
    }
    //
    func defaultDisplay(){
        let ReplayingOneHandler = ReplayingMethodTwo()
        var totalAmount = 0
        dictionaryTemp = ReplayingOneHandler.FetchPhotoToday() as! [String: Int]
        if dictionaryTemp.count == 0{
            print("no photo recording today")
            DefaultNoPhotoRecordedDisplay()
        }
        else{
            let arrayOfName = sortDictionaryGetSoftwareName(dic :  dictionaryTemp)
            let arrayOfValue = sortDictionaryGetSoftwareCount(dic:  dictionaryTemp)
            for i in 0..<arrayOfValue.count{
                totalAmount += arrayOfValue[i]
            }
            print(totalAmount)
            print(arrayOfName)
            print(arrayOfValue)
            let drawRectanglehandler = NSImageView_Rectangle()
            drawRectanglehandler.intArrayToDouble(arrayOfint : arrayOfValue)
            
            
        }
        
        
        
        //FetchPhotoToday()
    }
    //end of defaultDisplay()
    //
    func DefaultNoPhotoRecordedDisplay(){
        let defaultImage = NSImage(named : NSImage.Name(rawValue: "No_Image_Available"))
        imageDisplayArea.imageScaling = .scaleProportionallyUpOrDown
        imageDisplayArea.image = defaultImage
    }
    //end of DefaultNoPhotoRecordedDisplay()
    //
    func DefaultComboMenu(){
        //let singularNouns = ["today", "recent 1 hour", "recent 3 hours", "recent 5 hours", "recent 8 hours", "recent 24 hours", "recent 3 days", "recent 5 days", "recent 7 days"]
        let singularNouns = ["today", "recent 1 hour", "recent 3 hours", "recent 5 hours", "recent 8 hours", "recent 24 hours", "recent 3 days", "recent 5 days", "recent 7 days"]
        menuBoxOutlet.removeAllItems()
        menuBoxOutlet.addItems(withObjectValues: singularNouns)
        //let number = singularNouns.count
        menuBoxOutlet.selectItem(at: 0)
    }
    //end of DefaultComboMenu()


    @IBAction func menuBoxActionWithoutClicking(_ sender: Any) {
        let timeinterval = menuBoxOutlet.stringValue
        if(timeinterval == "today"){
            let replayingTwoHandler = ReplayingMethodTwo()
            //let array = replayingTwoHandler.FetchThreeHours()
            
        }else if (timeinterval == "recent 1 hour"){
            let replayingTwoHandler = ReplayingMethodTwo()
            let array = replayingTwoHandler.FetchOneHours()
            print(array)
        }else if (timeinterval == "recent 3 hours"){
            let replayingTwoHandler = ReplayingMethodTwo()
            var totalAmount = 0
            let array = replayingTwoHandler.FetchThreeHours()
            let arrayOfName = sortDictionaryGetSoftwareName(dic : array)
            let arrayOfValue = sortDictionaryGetSoftwareCount(dic: array)
            for i in 0..<arrayOfValue.count{
                totalAmount += arrayOfValue[i]
            }
            //print(totalAmount)
            //print(arrayOfName)
            //print(arrayOfValue)
            //["Xcode", "Google Chrome"]
            //[2, 1]
            
                
        }else if (timeinterval == "recent 5 hours"){
            let replayingTwoHandler = ReplayingMethodTwo()
            //let array = replayingTwoHandler.FetchThreeHours()
            
        }else if (timeinterval == "recent 8 hours"){
            let replayingTwoHandler = ReplayingMethodTwo()
            //let array = replayingTwoHandler.FetchThreeHours()
            
        }else if (timeinterval == "recent 24 hours"){
            let replayingTwoHandler = ReplayingMethodTwo()
            //let array = replayingTwoHandler.FetchThreeHours()
            
        }else if (timeinterval == "recent 3 days"){
            let replayingTwoHandler = ReplayingMethodTwo()
            //let array = replayingTwoHandler.FetchThreeHours()
            
        }else if (timeinterval == "recent 5 days"){
            let replayingTwoHandler = ReplayingMethodTwo()
            //let array = replayingTwoHandler.FetchThreeHours()
            
        }else if (timeinterval == "recent 7 days"){
            let replayingTwoHandler = ReplayingMethodTwo()
            //let array = replayingTwoHandler.FetchThreeHours()
            var totalAmount = 0
            let array = replayingTwoHandler.FetchSevenday()
            let arrayOfName = sortDictionaryGetSoftwareName(dic : array)
            let arrayOfValue = sortDictionaryGetSoftwareCount(dic: array)
            for i in 0..<arrayOfValue.count{
                totalAmount += arrayOfValue[i]
            }
            print(totalAmount)
            print(arrayOfName)
            print(arrayOfValue)
            let tempValues = arrayOfValue.map { Double($0) }
            //testImageView
            let treeMap = TreeMap(withValues: tempValues)
            let treeMapRects = treeMap.tessellate(inRect: testImageView.bounds)
            let size = testImageView.bounds
            //let context = NSGraphicsContext.current()?.cgContext
            let context = NSGraphicsContext.current?.cgContext
            let randomColorHandler = Colors()
            let fillColor = NSColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
            let number = treeMapRects.count
            for i in 0..<number{
                //draw(treeMapRects[i])
                //NSBezierPath(rect: treeMapRects[i]).fill()
                let rectangleColor = NSColor(red: 0.0, green: 0.0, blue: 2.0, alpha: 1.0)
                print(treeMapRects[i])
                let cPath: NSBezierPath = NSBezierPath(rect: treeMapRects[i])
                //rectangleColor.set()
                //cPath.fill()
                randomColorHandler.randomColor.setFill()
                //treeMapRects[i]
                cPath.fill()
                //context?.fill(treeMapRects[i])
                
            }
//            treeMapRects.forEach { (treeMapRect) in
//                randomColorHandler.randomColor.setFill()
//                context?.fill(treeMapRect)
//            }
        }
            
        else{}
    }
    //end of the menuBoxActionWithoutClicking()
    //
    func sortDictionaryGetSoftwareName(dic : Dictionary<String, Int>) -> [String]{
        let dictValDec = dic.sorted(by: { $1.1 < $0.1 })
        var arrayOfName = [String]()
        for i in 0..<dictValDec.count{
            arrayOfName.append(dictValDec[i].key)
        }
        return arrayOfName
    }
    //end of sortDictionaryGetSoftwareName
    //
    func sortDictionaryGetSoftwareCount(dic : Dictionary<String, Int>) -> [Int]{
        let dictValDec = dic.sorted(by: { $1.1 < $0.1 })
        var arrayOfValue = [Int]()
        for i in 0..<dictValDec.count{
            arrayOfValue.append(dictValDec[i].value)
        }
        return arrayOfValue
    }
    
    
    
    //------------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------------
    

    @IBAction func testButtonToChangeRectangles(_ sender: Any) {
        let handler = NSImageView_Rectangle()
        let rect = NSRect(x:0, y: 0, width:50 , height:50)
        //handler.draw(testImageView)
        let fillColor = NSColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
        handler.draw(rect)
        print("1")
    }
    
    
    
    // end of class
}
