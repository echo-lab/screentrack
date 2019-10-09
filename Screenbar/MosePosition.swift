//
//  MosePosition.swift
//  Screenbar
//
//  Created by Donghan Hu on 11/2/18.
//  Copyright © 2018 Christian Engvall. All rights reserved.
//

import Foundation
import AppKit

class DetectMousePosition : NSEvent{
    
    
    var mouseLocation: NSPoint {
        return NSEvent.mouseLocation
    }
    
//    var location: NSPoint {
//        return window.mouseLocationOutsideOfEventStream
//    }
    func CurrentMouseLocation(){
//        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
//            self.mouseLocation == NSEvent.mouseLocation()
//            print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
//        }
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
            print("mouseLocation:", String(format: "%.1f, %.1f", self.mouseLocation.x, self.mouseLocation.y))
            //print("windowLocation:", String(format: "%.1f, %.1f", self.location.x, self.location.y))
            return $0
        }
    }
    
    
}
