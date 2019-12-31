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
    
    func CurrentMouseLocation(){
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
            print("mouseLocation:", String(format: "%.1f, %.1f", self.mouseLocation.x, self.mouseLocation.y))
            return $0
        }
    }
    
    
}
