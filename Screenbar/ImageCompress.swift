//
//  ImageCompress.swift
//  Screenbar
//
//  Created by Donghan Hu on 11/10/18.
//  Copyright © 2018 Christian Engvall. All rights reserved.
//

import Foundation
import Cocoa
import AppKit


class ImageCompress : NSObject{
    
    func resize(image: NSImage,imagenameaddress :URL, fullpath: String, hei: Int, wi: Int){
        
        // set the destination image size
        //print("work")
        //print(image.size.width, image.size.height)
        let w = wi
        let h = hei
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))

        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
      //  print( "print 0 " + String(describing: image.size.width) + "/+" + String(describing: image.size.height))
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        //print( "print 1" + String(describing: newImage.size.width) + "/+" + String(describing: newImage.size.height))
        //print("print 3:" + fullpath)
        let characterSet = CharacterSet(charactersIn: " ")
        _ = fullpath.trimmingCharacters(in: characterSet)
        if newImage.pngWrite(to: URL(fileURLWithPath: fullpath), options: .atomic) {
            print("File saved")
        }
        else {
            print("File saved failed")
        }
    }
    
    
    //end of Imagge compression class
}




extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .PNG, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func resize_two(image: NSImage,imagenameaddress :URL, fullpath: String, hei: Int, wi: Int){
        
    }
}


