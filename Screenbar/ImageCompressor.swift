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

@available(OSX 10.15, *)
class ImageCompressor : NSObject{
    
    func resize(image: NSImage, imageNameAddress: URL, imageFullPath: String, to size: [Int]) {
        
        let finalWidth = size[1]
        let finalHeight = size[0]
        let destSize = NSMakeSize(CGFloat(finalWidth), CGFloat(finalHeight))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        
        if newImage.pngWrite(to: URL(fileURLWithPath: imageFullPath), options: .atomic) {
            print("File saved successfully after resizing and compression")
        } else {
            print("File failed to save successfully after resizing and compression")
        }
    }
}

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print("PNG data failed to write with error: ", error)
            return false
        }
    }
}


