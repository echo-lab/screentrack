//
//  Method_One_Display_Window.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/8/19.
//

import Cocoa

class Method_One_Display_Window: NSViewController {

    
    //lazy var window: NSWindow = self.view.window!
    var timerCurrentTime : Timer = Timer()
    
//    var mouseLocation: NSPoint {
//        return NSEvent.mouseLocation()
//    }
//    var location: NSPoint {
//        return window.mouseLocationOutsideOfEventStream
//    }
    override func viewDidAppear() {
         print("test window showed appera")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("test window showed load")

        print("this is window")


    }
    
    @objc func CurrentTime(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "M-d, HH:mm:ss"
        let temp = dateFormatter.string(from: NSDate() as Date)
        print("temp")
        //MultiLineLabelOfCurrentTime.stringValue = temp
    }

    
    
}
