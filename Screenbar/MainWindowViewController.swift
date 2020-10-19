
//TimeInterval and TimerInterval2 are for the size of image caputre

import Cocoa
import AppKit

struct mouseActivities {
    static var scrollDirty = false
    static var keyboardDirty = false
}


@available(OSX 10.13, *)
class MainWindowViewController: NSViewController, NSTextFieldDelegate {
    
    //MARK: - Refactored Variables
    
    @IBOutlet var screenshotIntervalTextField: NSTextField!
    @IBOutlet var storageDaysTextField: NSTextField!
    @IBOutlet var recordButton: NSButton!
    @IBOutlet var estimatedDiskSpaceTextField: NSTextField!
    @IBOutlet var compressionRateSlider: NSSlider!
    @IBOutlet var compressionRateTextField: NSTextField!
    
    var compressionRate: Int?
    var screenshotCounter: Timer = Timer()
    var screenshotStoragePath = URL(string: NSHomeDirectory() + "/Documents" + "/Reflect/")
    var imageMaxSize: Double = 0
    
    static let SLIDER_MIN_VALUE = 40
    static let SLIDER_MAX_VALUE = 100
    static let SLIDER_INIT_VALUE = 70
    
    //MARK: - End of refactored variables
    
    
    //MARK: - TODO: find out what do these do
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var playSound: NSButton!
    @IBOutlet weak var DetectSwitchCheckButton: NSButton!
    
    var timerFrontmost: Timer = Timer()
    
    let frontmostAppHandler = FrontmostApp()
    let jsonFileHandler = JSONFileHandler()
    let errorFileHandler = ErrorFileHandler()
    let deleteFoldersHandler = deleteFolders()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        initialize()
    }
    
    override func controlTextDidChange(_ notification: Notification) {
        if let textField = notification.object as? NSTextField {
            print(textField.stringValue)
            //do what you need here
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //code here for view did load
        initScreenshotIntervalPopover()
    }
    
    
    //slider from NSSliderCell
    @IBAction func compressionRateOnSlide(_ sender: NSSliderCell) {
        updateEstimatedDiskSpaceTextField()
        compressionRate = Int(sender.intValue)
        compressionRateTextField.intValue = sender.intValue
        compressionRateTextField.stringValue += "%"
    }
    
    // get the information of whether have sound or not
    func setPlaySound() {
        self.playSound.state = NSControl.StateValue(rawValue: Settings.getPlaySound())
    }
    
    func setDetectSwitch(){
        self.DetectSwitchCheckButton.state = NSControl.StateValue(rawValue: Settings.getDetectSwitch())
    }
    
    //pass these three parameters into corresponding functions
    func saveSettings(_ seconds: Double?, path: URL?, playSound: Int, height: Int, DetectSwitchCheckButton: Int) {
        Settings.setSecondsIntervall(seconds)
        Settings.setPath(path)
        Settings.setPlaySound(playSound)
        Settings.setImageCompressHeight(height)
        Settings.setDetectSwitch(DetectSwitchCheckButton)
        
    }
    
    func close() {
        let appDelegate : AppDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.hideMainWindow(self)
    }
    
    //click start capture button
    @IBAction func CaptureScreenshots(_ sender: Any) {
        if self.saveSettings() {
            deleteFoldersHandler.listFiles(rootpath: UserData.rootFolderPath, dayLength: storageDaysTextField.stringValue)
            automaticScreenshot()
        }
    }
    
    // save current input, setting
    // only check second input is right or not
    func saveSettings() -> Bool {
        var success = true;
        let seconds : Double? = Double(self.screenshotIntervalTextField.stringValue)
        let playSound = self.playSound.state
        let DetectSwitchCheckButton = self.DetectSwitchCheckButton.state
        
        if(seconds == nil) || (seconds == 0) {
            errorMessage.isHidden = false
            success = false;
        } else {
            errorMessage.isHidden = true
            self.saveSettings(seconds, path: screenshotStoragePath, playSound: playSound.rawValue, height: compressionRate ?? 50, DetectSwitchCheckButton: DetectSwitchCheckButton.rawValue)
        }
        return success;
    }
    
    func automaticScreenshot() {
        if screenshotCounter.isValid {
            self.stopAutomaticScreenShot()
        } else {
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
            timeInterval: Settings.getSecondsInterval()!,
            target: ScreenShot(),
            selector: #selector(ScreenShot().take),
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
        self.timerFrontmost.invalidate()
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
    
    @IBAction func quitButtonClicked(_ sender: Any) {
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
    
    //MARK: IBAction
    @IBAction func screenshotIntervalClicked(_ sender: NSButton) {
        print("SCREENSHOT INTERVAL CLICKED")
        
    }
    
    
    private func initScreenshotIntervalPopover() {
        print("INIT SCREENSHOT INTERVAL POPOVER")
        screenshotIntervalPopover?.contentViewController = ScreenshotIntervalViewController(nibName: NSNib.Name(rawValue: "ScreenshotIntervalCell"), bundle: nil)
        print(screenshotIntervalPopover == nil)
    }
    
    //MARK: COMPLETED
    
    //MARK: - initialize()
    private func initialize() {
        initScreenshotIntervalTextField()
        initCompressionRateValues()
        initEstimatedDiskSpaceTextField()
        setPlaySound()
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
        if let screenshotInterval = Settings.getSecondsInterval() {
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
        let totalStoreMB = totalNumberOfScreenshotsPerDay * compressedImageRatio * estimatedJPGSize / 1024
        let totalStoreGB = totalStoreMB * storageDays / 1024
        
        estimatedDiskSpaceTextField.stringValue = String(format: "%.1f", totalStoreGB) + "GB"
    }
}
