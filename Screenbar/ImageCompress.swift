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

@available(OSX 10.13, *)

// this class is for compressing the screenshot

class ImageCompress : NSObject{
    
    func resize(image: NSImage,imagenameaddress :URL, fullpath: String, hei: Int, wi: Int){
        
        // set the final image size
        let w = wi
        let h = hei
        // w = wide, h = height
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        
        // characterSet is not being used currently
        let characterSet = CharacterSet(charactersIn: " ")
        
        if newImage.pngWrite(to: URL(fileURLWithPath: fullpath), options: .atomic) {
            print("File saved successfully after resizing and compression")
        }
        else {
            print("File failed to save successfully after resizing and compression")
        }
    }

    //end of Imagge compression class
}




extension NSImage {
    
    // resize and compress to .png format.
    //less stoage space needed
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            
            print("png data failed to write, the error is: ", error)
            return false
        }
    }
    
    func resize_two(image: NSImage,imagenameaddress :URL, fullpath: String, hei: Int, wi: Int){
    }
    
    
}


