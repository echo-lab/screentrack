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
        return NSEvent.mouseLocation()
    }
    
    
    func CurrentMouseLocation(){
        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
            self.mouseLocation == NSEvent.mouseLocation()
            print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
        }
        
    }
}
