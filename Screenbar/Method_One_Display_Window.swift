//
//  Method_One_Display_Window.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/8/19.
//

import Cocoa

@available(OSX 10.13, *)

class Method_One_Display_Window: NSViewController {

    @IBOutlet weak var menuBoxOutlet: NSComboBox!
    
    //lazy var window: NSWindow = self.view.window!
    
    
    let replayingMethodTwoHandler = ReplayingMethodTwo()
    
//    var mouseLocation: NSPoint {
//        return NSEvent.mouseLocation()
//    }
//    var location: NSPoint {
//        return window.mouseLocationOutsideOfEventStream
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DefaultComboMenu()
        print("this is window")
        
    }
    
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
    
    
    
    
    // end of class
}
