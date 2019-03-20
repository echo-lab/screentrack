//
//  RandomColors.swift
//  Screenbar
//
//  Created by Donghan Hu on 3/19/19.
//

import Foundation
import AppKit


@available(OSX 10.13, *)
class Colors{
    
    var randomColor : NSColor{
        return NSColor(red: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       green: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       blue: CGFloat(arc4random_uniform(255) % 255) / 255.0,
                       alpha: 1)
    }
    //end of return random color
    
    
}

