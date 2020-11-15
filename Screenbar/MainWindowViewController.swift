
//TimeInterval and TimerInterval2 are for the size of image caputre

import Cocoa
import AppKit
import SwiftUI

struct mouseActivities {
    static var scrollDirty = false
    static var keyboardDirty = false
}

//MARK: TODO - remove sliders
//MARK: TODO - look into switching software detection screenshot bug

@available(OSX 10.15, *)
class MainWindowViewController: NSViewController, NSTextFieldDelegate {
    
    //MARK: - Refactored Variables
    @IBOutlet var screenshotIntervalTextField: NSTextField!
    @IBOutlet var storageDaysTextField: NSTextField!
    @IBOutlet var recordButton: NSButton!
    @IBOutlet var estimatedDiskSpaceTextField: NSTextField!
    @IBOutlet var compressionRateSlider: NSSlider!
    @IBOutlet var compressionRateTextField: NSTextField!
    
    var screenshotInterval: Int?
    var compressionRate: Int?
    var screenshotCounter: Timer = Timer()
//    var screenshotStoragePath = URL(string: NSHomeDirectory() + "/Documents" + "/Reflect/")
    
    static let SLIDER_MIN_VALUE = 40
    static let SLIDER_MAX_VALUE = 100
    static let SLIDER_INIT_VALUE = 70
    
    //MARK: Handlers
    let frontmostAppHandler = FrontmostApp()
    let jsonFileHandler = JSONFileHandler()
    let errorFileHandler = ErrorFileHandler()
    let deleteFoldersHandler = deleteFolders()
    
    //MARK: - End of refactored variables
    
    
    //MARK: - TODO
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var playSound: NSButton!
    @IBOutlet weak var DetectSwitchCheckButton: NSButton!
    
    var timerFrontmost: Timer = Timer()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        initialize()
        screenshotInterval = Int(Settings.getScreenshotInterval() ?? 0.0)
    }
    
    override func controlTextDidChange(_ notification: Notification) {
        if let textField = notification.object as? NSTextField {
            print(textField.stringValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    @IBAction func storageDaysOnSlide(_ sender: NSSlider) {
//    }
    
//    @IBAction func screenshotIntervalOnSlide(_ sender: NSSlider) {
//        updateScreenshotIntervalLabel(to: Int(sender.intValue))
//        updateEstimatedDiskSpaceTextField()
//    }
    
    @IBAction func compressionRateOnSlide(_ sender: NSSliderCell) {
        updateEstimatedDiskSpaceTextField()
        compressionRate = Int(sender.intValue)
        compressionRateTextField.intValue = sender.intValue
        compressionRateTextField.stringValue += "%"
    }
    
    //pass these three parameters into corresponding functions
    func saveSettings(seconds: Double?, height: Int, DetectSwitchCheckButton: Int) {
        //MARK: TODO wrap optionals
//        Settings.setScreenshotInterval(to: seconds)
        Settings.setImageCompressionRate(to: height)
        Settings.setDetectSwitch(DetectSwitchCheckButton)
        
    }
    
    func close() {
        let appDelegate : AppDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.hideMainWindow(self)
    }
    
    @IBAction func recordOnClick(_ sender: Any) {
        saveSettings()
        deleteFoldersHandler.listFiles(rootpath: UserData.rootFolderPath, dayLength: storageDaysTextField.stringValue)
        automaticScreenshot()
    }
    
    func saveSettings() {
        let screenshotInterval = Int(screenshotIntervalTextField.intValue)
        let compressionRate = Int(compressionRateSlider.intValue)
        
        Settings.setScreenshotInterval(to: screenshotInterval)
        Settings.setImageCompressionRate(to: compressionRate)
    }
    
    func automaticScreenshot() {
        if screenshotCounter.isValid {  //Currently recording
            self.stopAutomaticScreenShot()
        } else {    //Start recording
            self.close()
            if Settings.createUserStorageDirectory() {
                UserData.jsonPath = jsonFileHandler.createJSONFile(at: URL(string: UserData.screenshotStoragePath))
                UserData.errorPath = errorFileHandler.createErrorFile(at: URL(string: UserData.screenshotStoragePath))
            }
            self.startAutomaticScreenshot()
        }
    }
    
    func updateRecordButtonLabel(to title:String) {
        recordButton.title = title
    }
    
    private func initScreenshotCounter() {
        screenshotCounter = Timer.scheduledTimer(
            timeInterval: Settings.getScreenshotInterval()!,
            target: ScreenShot(),
            selector: #selector(ScreenShot().takeScreenshot),
            userInfo: nil,
            repeats: true)
    }
    
    func startAutomaticScreenshot() {
        initScreenshotCounter()
        
        if (Settings.getDetectSwitch() == 1){
            timerFrontmost = Timer.scheduledTimer(
                timeInterval: 3.0,
                target: frontmostAppHandler,
                selector: #selector(FrontmostApp.DetectFrontMostApp),
                userInfo: nil,
                repeats: true)
        }
        updateRecordButtonLabel(to: "Stop Recording")
    }

    func stopAutomaticScreenShot() {
        timerFrontmost.invalidate()
        screenshotCounter.invalidate()
        updateRecordButtonLabel(to: "Record")
        let AddingDataAfterStopingHandler = JsondataAfterTracking()
        AddingDataAfterStopingHandler.DataAfterRecording(filepath: URL(string: UserData.screenshotStoragePath)!)
    }
    
    open var windowController: NSWindowController?
    var sub1WindowController: NSWindowController?
    
    @IBAction func TimeLapseWindow(_ sender: Any) {
        if (UserData.timelapseWindowIsOpen == false){
            let windowHandler = TimeLapseMethodWindow()
            let sub1Window = NSWindow(contentViewController: windowHandler)
            UserData.TimelapseWindowController = NSWindowController(window: sub1Window)
            UserData.TimelapseWindowController?.showWindow(nil)
            UserData.timelapseWindowIsOpen = true
        }
        else{
            UserData.TimelapseWindowController?.showWindow(nil)
        }
  
        self.view.window?.close()
    }
    
    @IBAction func MethodTwoVisualWindow(_ sender: Any) {
        let Window_Handler : NSViewController = Method_One_Display_Window()
        //let sub1ViewController = NSViewController(nibName: "TimeLapseMethodWindow", bundle: Bundle.main)
        let sub1Window = NSWindow(contentViewController:  Window_Handler)
        UserData.TimelapseWindowController = NSWindowController(window: sub1Window)
        UserData.TimelapseWindowController?.showWindow(nil)
        self.view.window?.close()
    }
    
    @IBAction func quitButtonOnClick(_ sender: Any) {
        exit(0)
    }
    
    // function for the day length text field
    @IBAction func dayLengthTextField(_ sender: Any) {
        updateEstimatedDiskSpaceTextField()
    }
    
    //function for the time interval text field
    @IBAction func timeIntervalTextField(_ sender: Any) {
        updateEstimatedDiskSpaceTextField()
    }
    
    //function for the time interval action second
    @IBAction func timeIntervalActionSecond(_ sender: NSTextField) {
        updateEstimatedDiskSpaceTextField()
    }
    
    var screenshotIntervalPopover: NSPopover?
    //MARK: COMPLETED
    
    //MARK: - initialize()
    private func initialize() {
        initScreenshotIntervalTextField()
        initCompressionRateValues()
        initEstimatedDiskSpaceTextField()
        errorMessage.isHidden = true
    }
    
    //MARK: - initCompressionRateValues
    private func initCompressionRateValues() {
        compressionRateSlider.minValue = 40
        compressionRateSlider.maxValue = 100
        compressionRateSlider.intValue = 70
        compressionRateTextField.stringValue = String(MainWindowViewController.SLIDER_INIT_VALUE) + "%"
    }
    
    //MARK: - initScreenshotIntervalTextField
    private func initScreenshotIntervalTextField() {
        if let screenshotInterval = Settings.getScreenshotInterval() {
            screenshotIntervalTextField.stringValue = String(screenshotInterval)
        }
    }
    
    
    //MARK: - initEstimatedDiskSpaceTextField
    private func initEstimatedDiskSpaceTextField() {
        let screenshotInterval = screenshotIntervalTextField.doubleValue
        let storageDays = storageDaysTextField.doubleValue
        
        //TODO: compression rate definition
        let compressedImageRatio = compressionRateSlider.doubleValue / compressionRateSlider.maxValue
        let estimatedJPGSize = 150.0
        
        let totalNumberOfScreenshotsPerDay = 60 / screenshotInterval * 480
        let totalStoreMB = totalNumberOfScreenshotsPerDay * compressedImageRatio * estimatedJPGSize / 1024
        let totalStoreGB = totalStoreMB * storageDays / 1024
        
        estimatedDiskSpaceTextField.stringValue = String(format: "%.1f", totalStoreGB) + "GB"
    }
    
    
    //MARK: - updateEstimatedDiskSpaceTextField
    private func updateEstimatedDiskSpaceTextField() {
        let screenshotInterval = screenshotIntervalTextField.doubleValue
        let storageDays = storageDaysTextField.doubleValue

        let compressedImageRatio = compressionRateSlider.doubleValue / compressionRateSlider.maxValue

        let estimatedJPGSize = 150.0

        let totalNumberOfScreenshotsPerDay = 60 / screenshotInterval * 480
        let totalMB = totalNumberOfScreenshotsPerDay * compressedImageRatio * estimatedJPGSize / 1024
        let totalGB = totalMB * storageDays / 1024

        estimatedDiskSpaceTextField.stringValue = String(format: "%.1f", totalGB) + "GB"
    }
}
