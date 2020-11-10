//
//  ScreenshotIntervalCell.swift
//  Screenbar
//
//  Created by Li on 10/14/20.
//

import AppKit

@available(OSX 10.15, *)
class ScreenshotIntervalViewController: NSViewController {
    
    static let identifer = "ScreenshotIntervalCell"
    
    @IBOutlet var screenshotIntervalSilder: NSSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenshotIntervalSilder.minValue = Double(MainWindowViewController.SLIDER_MIN_VALUE)
        screenshotIntervalSilder.maxValue = Double(MainWindowViewController.SLIDER_MAX_VALUE)
        screenshotIntervalSilder.intValue = Int32(MainWindowViewController.SLIDER_INIT_VALUE)
    }
    
    @IBAction func screenshotIntervalOnSlide(_ sender: NSSlider) {
        print(sender.intValue)
    }
}
