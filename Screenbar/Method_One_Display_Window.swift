//
//  Method_One_Display_Window.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/8/19.
//

import Cocoa

class Method_One_Display_Window: NSViewController {

    
    lazy var window: NSWindow = self.view.window!
    
    var mouseLocation: NSPoint {
        return NSEvent.mouseLocation()
    }
    var location: NSPoint {
        return window.mouseLocationOutsideOfEventStream
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("window two showed")
//        let myFrame = NSRect(x: 0.0, y: 0.0, width: 2000.0, height: 2000.0)
//        let myRect = NSView(frame: myFrame)
//        self.view.addSubview(myRect)
        // Do view setup here.
        
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
            print("mouseLocation:", String(format: "%.1f, %.1f", self.mouseLocation.x, self.mouseLocation.y))
            print("windowLocation:", String(format: "%.1f, %.1f", self.location.x, self.location.y))
            return $0
        }
    }

    
    
}
