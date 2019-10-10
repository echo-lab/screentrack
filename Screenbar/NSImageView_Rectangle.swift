//
//  NSImageView_Rectangle.swift
//  Screenbar
//
//  Created by Donghan Hu on 2/14/19.
//

import Cocoa
import AppKit
import Foundation

@available(OSX 10.13, *)

class NSImageView_Rectangle: NSImageView {
    var SumOfDictionary : Int = 0
    var SortedDictionary = [String: Int]()
    var arrayofname = [String]()
    var arrayofvalue = [Int]()
    
    var tempArrayDouble = [Double]()
    //change int array to double array
    
    func intArrayToDouble (arrayOfint : [Int]){
        tempArrayDouble = arrayOfint.map { Double($0) }
    }
    // end of function intArrayToDouble
    override func draw(_ dirtyRect: NSRect)
    {
//        Draw a rectangle
//        let bPath:NSBezierPath = NSBezierPath(rect: dirtyRect)
//        let fillColor = NSColor(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
//        fillColor.set()
//        bPath.fill()

//      draw a circle
//        let context = NSGraphicsContext.current()?.cgContext
//        context?.saveGState()
//        context?.setFillColor(NSColor.red.cgColor)
//        context?.fillEllipse(in: dirtyRect)
//        context?.restoreGState()
        
//        let borderColor = NSColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
//        borderColor.set()
//        bPath.lineWidth = 12.0
//        bPath.stroke()
        
        
        
        
          //draw a rectangle from the bottom of right
//          let rectangleColor = NSColor(red: 0.0, green: 0.0, blue: 2.0, alpha: 1.0)
//          let rect = NSMakeRect(0, 0, 30.0, 30.0)
//          let cPath: NSBezierPath = NSBezierPath(rect: rect)
//          rectangleColor.set()
//          cPath.fill()
        
        
        
        let values = [ 445, 20, 110, 70, 233].sorted()
        let tempValues = values.map { Double($0) }
        
        // These two lines are actual YMTreeMap usage!
        let treeMap = TreeMap(withValues: tempValues)
        let treeMapRects = treeMap.tessellate(inRect: self.bounds)
//        
        let context = NSGraphicsContext.current?.cgContext
        let randomColorHandler = Colors()
        treeMapRects.forEach { (treeMapRect) in
            randomColorHandler.randomColor.setFill()
            context?.fill(treeMapRect)
        }
    }
    
    
    //
    func CollageImageDraw(dic : Dictionary<String, Int>){
        let length = dic.count
        let dictValDec = dic.sorted(by: { $0.value > $1.value })
        //let dict = ["A": 123, "B": 789, "C": 567, "D": 432, "E": 76, "F": 332, "G": 12]
        //[(key: "B", value: 789), (key: "C", value: 567), (key: "D", value: 432), (key: "A", value: 123)]
        //count 0 has the biggest number
        let Val = Array(dic.values)
        var sum = 0
        //let sortedArray = Val.sorted(by : >)
        for i in 0 ..< length{
            sum = sum + Val[i]
        }
    }

    //set SumOfDcitionary is the total sum of the inital dictionary = 0
    func CalculateSumOfDictionary(dic : Dictionary<String, Int>){
        var sum = 0
        let length = dic.count
        let temparray = Array(dic.values)
        for i in 0 ..< length{
            sum += temparray[i]
        }
        SumOfDictionary = sum
    }
    
    
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
    //end of the class
}
