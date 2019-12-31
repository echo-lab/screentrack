
//TimeInterval and TimerInterval2 are for the size of image caputre

import Cocoa
import AppKit

protocol buttonchange {
    associatedtype Buttonclick: NSObject = Self
}

// global variable of file path
struct MyVariables {
    static var yourVariable = "someString"
    static var jsonpath : URL = URL(string: "https://www.apple.com")!
    static var errorPath : URL = URL(string: "https://www.apple.com")!
    static var maxWidth = 0
    static var initSecond = -1
    static var rootFolderPath = URL(string: "")
    static var sub1WindowController : NSWindowController? = nil
    static var openedBool = false
}

struct mouseActivities {
    static var scrollDirty = false
    static var keyboardDirty = false
}

struct imageSize {
    static var maxSize = 0
}


let string = MyVariables.yourVariable
var jpath = MyVariables.jsonpath
var erpath = MyVariables.errorPath



@available(OSX 10.13, *)
class MainWindowViewController: NSViewController, NSTextFieldDelegate {
    static let applicationDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var secondsTextBox: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var playSound: NSButton!
    @IBOutlet weak var TimeIntervalTwo: NSTextFieldCell!
    @IBOutlet weak var CompressionSlider: NSSlider!
    @IBOutlet weak var compressionLabel: NSTextField!
    @IBOutlet weak var estimatedInfor: NSTextField!
    @IBOutlet weak var CompressRateLabel: NSTextFieldCell!
    @IBOutlet weak var dayLength: NSTextField!
    @IBOutlet weak var DetectSwitchCheckButton: NSButton!
    
    var timerScreenshot: Timer = Timer()
    var timerFrontmost: Timer = Timer()
    var timerCurrentAppList: Timer = Timer()
    var timerScroll: Timer = Timer()
    var path = URL(string: NSHomeDirectory() + "/Documents" + "/Reflect/")
    
    let currentappHandler = CurrentApplicationData()
    let frontmostappHandler = FrontmostApp()
    let mouselocatinoHandler = DetectMousePosition()
    let openfileinforHandler = openfile()
    let jsonfileHandler = json()
    let errorfileHandler = errorFile()
    let appdelegateHandler = AppDelegate()
    let activitiesHandler = activitiesDetection()
    let deleteFoldersHandler = deleteFolders()

    lazy var window: NSWindow = self.view.window!
    
    
    var mouseLocation: NSPoint {
        return NSEvent.mouseLocation
    }
    
    var location: NSPoint {
        return window.mouseLocationOutsideOfEventStream
    }
    
    var observers = [NSKeyValueObservation]()
    
    @IBOutlet weak var CaptureScreenshot: NSButton!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setSeconds()
        self.hideError()
        self.compressionSliderValueSet()
        compressionLabel.stringValue = "40.0%"
        CompressionSlider.stringValue = String(CompressionSlider.minValue)


        let temp = Double(imageSize.maxSize)
        let imageSize = CompressionSlider.doubleValue * temp / CompressionSlider.maxValue

        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480

        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024

        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"

        self.setPlaySound()
        
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
    }
    

    
    //slider from NSSliderCell
    @IBAction func CompressSilder(_ sender: NSSliderCell) {
        let ratio = sender.doubleValue / Double(MyVariables.maxWidth)
        let temp = String(format: "%.1f", ratio * 100)
        let result = temp + "%"
        CompressRateLabel.stringValue = String(Int(sender.doubleValue))
        compressionLabel.stringValue = result
        let maxSize = Double(imageSize.maxSize)
        let imageSize = sender.doubleValue * maxSize / CompressionSlider.maxValue
        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480
        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024
        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"
        
    }
    
    
    // get the second interval input
    func setSeconds() {
        let seconds: Double? = Settings.getSecondsInterval()
        self.secondsTextBox.stringValue = String(seconds!)
        
        
    }
    
    // get the information of whether have sound or not
    func setPlaySound() {
        self.playSound.state = NSControl.StateValue(rawValue: Settings.getPlaySound())
    }
    
    func setDetectSwitch(){
        self.DetectSwitchCheckButton.state = NSControl.StateValue(rawValue: Settings.getDetectSwitch())
    }
    //
    
    func showError() {
        self.errorMessage.isHidden = false
    }
    

    func hideError() {
        self.errorMessage.isHidden = true
    }
    
    
    //pass these three parameters into corresponding functions
    func saveSettings(_ seconds: Double?, path: URL?, playSound: Int, height: Int, DetectSwitchCheckButton: Int) {
        Settings.setSecondsIntervall(seconds)
        Settings.setPath(path)
        MyVariables.rootFolderPath = path
        //print("path:", path)
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
        //deleteFoldersHandler.listFiles(rootpath: MyVariables.rootFolderPath!, dayLength: dayLength.stringValue)
        if(self.saveSettings()) {
            deleteFoldersHandler.listFiles(rootpath: MyVariables.rootFolderPath!, dayLength: dayLength.stringValue)
            self.automaticScreenshot()
        }
    }
    
    // save current input, setting
    // only check second input is right or not
    func saveSettings() -> Bool {
        var success = true;
        let seconds : Double? = Double(self.secondsTextBox.stringValue)
        let path: URL? = self.path
        let playSound = self.playSound.state
        let DetectSwitchCheckButton = self.DetectSwitchCheckButton.state
        let height = self.CompressRateLabel.stringValue
        
        if(seconds == nil) || (seconds == 0) {
            self.showError()
            success = false;
        }
        else {
            self.hideError()
            self.saveSettings(seconds, path: path, playSound: playSound.rawValue, height: Int(height)!, DetectSwitchCheckButton: DetectSwitchCheckButton.rawValue)
        }
        return success;
    }
    
    func automaticScreenshot() {
        
        // start change to stop
        if(self.timerScreenshot.isValid) {
            self.stopAutomaticScreenShot()
        }
        else {
            // start caputring
            //Settings.getPath().path is the name of json file
            //close the main window
            self.close()
            let date = Date()
            let calendar = Calendar.current
            Settings.PathCreate()
            jpath = jsonfileHandler.createjson(filepath: URL(string: MyVariables.yourVariable)!)
            erpath = errorfileHandler.createError(filepath: URL(string: MyVariables.yourVariable)!)
            self.startAutomaticScreenshot()

        }
    }
    
    func ChangeTitleOfButton(_ title:String) {
        self.CaptureScreenshot.title = title
        
    }
    
    func startAutomaticScreenshot() {
        let seconds = Settings.getSecondsInterval()
        _ = Settings.TimeIntervalSecondGet()
        // take a photo instantly
        let screenshotHandler = ScreenShot()
        //not take a screenshot at the start of the application
        //screenshotHandler.take()
        self.timerScreenshot = Timer.scheduledTimer(timeInterval: seconds!, target: screenshotHandler, selector: #selector(ScreenShot.take), userInfo: nil, repeats: true)
        if (Settings.getDetectSwitch() == 1){
            self.timerFrontmost = Timer.scheduledTimer(timeInterval: 3.0, target: frontmostappHandler, selector: #selector(FrontmostApp.DetectFrontMostApp), userInfo: nil, repeats: true)
        }
        self.ChangeTitleOfButton("Recording! Stop")
    }

    func stopAutomaticScreenShot() {
        self.timerScreenshot.invalidate()
        self.timerCurrentAppList.invalidate()
        self.timerFrontmost.invalidate()
        self.ChangeTitleOfButton("Click to start")
        let AddingDataAfterStopingHandler = JsondataAfterTracking()
        AddingDataAfterStopingHandler.DataAfterRecording(filepath: URL(string: MyVariables.yourVariable)!)
    }
    
    // Go to the folder that save the screenshots
    @IBAction func GoToTheFolder(_ sender: Any) {

        NSWorkspace.shared.openFile(MyVariables.yourVariable)
        self.view.window?.close()
    }
    
    
    // Click the more visualziation button
    // The window supposed to be open is in folder Views, Storyboard
    // This funciton aims to open a new window for future options
    
    //lazy var windowOne : NSWindow

    
    //click button for the display method one
    
    //
    func compressionSliderValueSet(){
        let screen = NSScreen.main
        let scale = Int((screen?.backingScaleFactor)!)
        
        let rect = screen?.frame
        let width = Int((rect?.size.width)!)
        let height = Int((rect?.size.height)!)
        print(width)
        print(height)
        let firstValue = width * scale
        let secondValue = height * scale
        print(firstValue)
        print(secondValue)
        let temp = 950 * firstValue * secondValue
        imageSize.maxSize = temp / (2880 * 1800)
        print("max image size:" + String(imageSize.maxSize))
        CompressionSlider.minValue = Double(firstValue * 4 / 10)
        CompressionSlider.maxValue = Double(firstValue)
        MyVariables.maxWidth = firstValue
        
    }

    //
    
    open var windowController: NSWindowController?
    var sub1WindowController: NSWindowController?
    
    @IBAction func TimeLapseWindow(_ sender: Any) {
        if (MyVariables.openedBool == false){
            let windowHandler = TimeLapseMethodWindow()
            let sub1Window = NSWindow(contentViewController: windowHandler)
            MyVariables.sub1WindowController = NSWindowController(window: sub1Window)
            MyVariables.sub1WindowController?.showWindow(nil)
            MyVariables.openedBool = true
        }
        else{
            MyVariables.sub1WindowController?.showWindow(nil)
        }
  
        self.view.window?.close()
    }
    
    @IBAction func MethodTwoVisualWindow(_ sender: Any) {
        let Window_Handler : NSViewController = Method_One_Display_Window()
        //let sub1ViewController = NSViewController(nibName: "TimeLapseMethodWindow", bundle: Bundle.main)
        let sub1Window = NSWindow(contentViewController:  Window_Handler)
        MyVariables.sub1WindowController = NSWindowController(window: sub1Window)
        MyVariables.sub1WindowController?.showWindow(nil)
        self.view.window?.close()
    }
    
    

    // Quit this software
    @IBAction func ClickQuitButton(_ sender: Any) {
        
        exit(0)
    }
    
    // function for the day length text field
    @IBAction func dayLengthTextField(_ sender: Any) {
        let temp = Double(imageSize.maxSize)
        let imageSize = CompressionSlider.doubleValue * temp / CompressionSlider.maxValue
        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480
        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024
        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"
    }
    
    //function for the time interval text field
    @IBAction func timeIntervalTextField(_ sender: Any) {
        let temp = Double(imageSize.maxSize)
        let imageSize = CompressionSlider.doubleValue * temp / CompressionSlider.maxValue
        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480
        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024
        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"
    }
    
    //function for the time interval action second
    @IBAction func timeIntervalActionSecond(_ sender: NSTextField) {
        let temp = Double(imageSize.maxSize)
        let imageSize = CompressionSlider.doubleValue * temp / CompressionSlider.maxValue
        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480
        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024
        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"
    }
    
}
