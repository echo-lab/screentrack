
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
    
//    static var windowHandler : NSViewController? = nil
//    static var sub1Window : NSWindow? = nil
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
    //@IBOutlet weak var path: NSPathControl!
    var path = URL(string: NSHomeDirectory() + "/Documents" + "/Reflect/")
    @IBOutlet weak var playSound: NSButton!
    
    //following are the height and width set of the scale of the image
    //@IBOutlet weak var TimeInterval: NSTextField!
    @IBOutlet weak var TimeIntervalTwo: NSTextFieldCell!
    
    @IBOutlet weak var CompressionSlider: NSSlider!
    @IBOutlet weak var compressionLabel: NSTextField!
    
    @IBOutlet weak var estimatedInfor: NSTextField!
    
    // A timer that fires after a certain time interval has elapsed, sending a specified message to a target object
    @IBOutlet weak var CompressRateLabel: NSTextFieldCell!
    
    @IBOutlet weak var dayLength: NSTextField!
    var timerScreenshot: Timer = Timer()
    @IBOutlet weak var DetectSwitchCheckButton: NSButton!
    var timerFrontmost: Timer = Timer()
    var timerCurrentAppList: Timer = Timer()
    var timerScroll: Timer = Timer()
    
    
    //var observerFrontmost:
    
    // new a object for class ScreenShot
    //let screenshotHandler = ScreenShot()
    let currentappHandler = CurrentApplicationData()
    let frontmostappHandler = FrontmostApp()
    let mouselocatinoHandler = DetectMousePosition()
    let openfileinforHandler = openfile()
    let jsonfileHandler = json()
    let errorfileHandler = errorFile()
    let appdelegateHandler = AppDelegate()
    let activitiesHandler = activitiesDetection()
    

    lazy var window: NSWindow = self.view.window!
    
    
    var mouseLocation: NSPoint {
        return NSEvent.mouseLocation
    }
    var location: NSPoint {
        return window.mouseLocationOutsideOfEventStream
    }
    
    var observers = [NSKeyValueObservation]()
    
    @IBOutlet weak var CaptureScreenshot: NSButton!
    //detect scrolling action, but now, only works in small area
    override func scrollWheel(with event: NSEvent) {
        if event.scrollingDeltaY > 0{
            print(event.scrollingDeltaY)
        }
        else {
            print("scrollinDeltaY is 0")
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setSeconds()
        //self.setImageHeight()
        //self.setImageWidth()
        self.hideError()
        //secondsTextBox.stringValue = "10.0"
        self.compressionSliderValueSet()
        //self.setPath()
        compressionLabel.stringValue = "40.0%"
        CompressionSlider.stringValue = String(CompressionSlider.minValue)

        //let defaults = UserDefaults.standard
        let temp = Double(imageSize.maxSize)
        let imageSize = CompressionSlider.doubleValue * temp / CompressionSlider.maxValue
        //print(imageSize)
        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480
        //print(timeSum)
        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024
        //print(totalStore)
        //let timeInterval = 60 / Double(secondsTextBox.stringValue) * 60 * 8 * imageSize / 1024 / 1024
        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"

        self.setPlaySound()
//        self.setImageSize()
//        print(frontmostappHandler.CurrentFrontMostApp)
//        print(currentappHandler.InitialSet)
        
        
        // show the mouse current position function
        //mouselocatinoHandler.CurrentMouseLocation()
        
        
        
    }
    override func controlTextDidChange(_ notification: Notification) {
        if let textField = notification.object as? NSTextField {
            print(textField.stringValue)
            //do what you need here
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    //slider from NSSliderCell
    @IBAction func CompressSilder(_ sender: NSSliderCell) {
        let ratio = sender.doubleValue / Double(MyVariables.maxWidth)
        let temp = String(format: "%.1f", ratio * 100)
        let result = temp + "%"
        //let result = String(ratio * 100) + "%"
        
        //let temp = Int(sender.doubleValue)
        //print(temp)
        CompressRateLabel.stringValue = String(Int(sender.doubleValue))
        //print(CompressRateLabel.stringValue)
        compressionLabel.stringValue = result
        let temp1 = Double(imageSize.maxSize)
        let imageSize = sender.doubleValue * temp1 / CompressionSlider.maxValue
        //print(imageSize)
        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480
        //print(timeSum)
        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024
        //print(totalStore)
        //let timeInterval = 60 / Double(secondsTextBox.stringValue) * 60 * 8 * imageSize / 1024 / 1024
        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"
        
        
    }
    
    //
//    func setImageSize(){
//        let sizeheight : Int? = Settings.getImageCompressHeight()
//        self.CompressRateLabel.stringValue = String(sizeheight!)
//    }
    
    
    // get the second interval input
    func setSeconds() {
        let seconds: Double? = Settings.getSecondsInterval()
        self.secondsTextBox.stringValue = String(seconds!)
        
        
    }
    
//    func setImageHeight(){
//        let intervalseconds: Double? = Settings.TimeIntervalSecondGet()
//        self.TimeInterval.stringValue = String(intervalseconds!)
//    }
//    func setImageWidth(){
//        let intervalsecondstwo: Double? = Settings.TimeIntervalSecondTwoGet()
//        self.TimeIntervalTwo.stringValue = String(intervalsecondstwo!)
//    }
    

    // get the information of whether have sound or not
    func setPlaySound() {
        self.playSound.state = NSControl.StateValue(rawValue: Settings.getPlaySound())
    }
    
    // show error
    // what error?
    func setDetectSwitch(){
        self.DetectSwitchCheckButton.state = NSControl.StateValue(rawValue: Settings.getDetectSwitch())
    }
    //
    
    func showError() {
        self.errorMessage.isHidden = false
    }
    
    // hide the error
    // what error?
    func hideError() {
        self.errorMessage.isHidden = true
    }
    
    
    //pass these three parameters into corresponding functions
    func saveSettings(_ seconds: Double?, path: URL?, playSound: Int, height: Int, DetectSwitchCheckButton: Int) {
        Settings.setSecondsIntervall(seconds)
        //print("in savesetting")
        //print(path)
        Settings.setPath(path)
        Settings.setPlaySound(playSound)
        Settings.setImageCompressHeight(height)
        Settings.setDetectSwitch(DetectSwitchCheckButton)
        
    }

    
//    func setPath() {
//        self.path.url = Settings.DefaultFolder() as URL
//        print("self.setpath: ")
//        print(self.path.url)
//        self.path.allowedTypes = ["public.folder"]
//    }
    
    
    func close() {
        let appDelegate : AppDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.hideMainWindow(self)
    }
    
    //click start capture button
    @IBAction func CaptureScreenshots(_ sender: Any) {
        if(self.saveSettings()) {
//            Settings.getPath().path is the name of json file
//            print("json file path")
//            print(Settings.getPath())
//            Settings.PathCreate()
//            jsonfileHandler.createjson(filepath: URL(string: MyVariables.yourVariable)!)
            self.automaticScreenshot()
            //self.close()
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
            //print("json file path")
            //print(Settings.getPath())
            let date = Date()
            let calendar = Calendar.current
//            let day = calendar.component(.day, from: date)
//            let month = calendar.component(.month, from: date)
//            let year = calendar.component(.year, from: date)
            //let current = String(year) + "-" + String(month) + "-" + String(day)
            //var SessionNumber = MainWindowViewController.applicationDelegate.fileNameDictionary[current] as! [Int]
            //print("this is the session number that is already sotred before create path")
            //print(SessionNumber.count)
            Settings.PathCreate()
            jpath = jsonfileHandler.createjson(filepath: URL(string: MyVariables.yourVariable)!)
            erpath = errorfileHandler.createError(filepath: URL(string: MyVariables.yourVariable)!)
            //print(MyVariables.yourVariable)
            ///Users/donghanhu/Documents/Reflect/2019-2-23-1
            //appdelegateHandler.changeicon()
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
        //useless
        //NotificationCenter.default.addObserver(self, selector: #selector(abd(notification:)), name:NSNotification.Name.NSApplicationDidHide.didBecomeActiveNotification, object: (Any).self)
        //
        self.timerScreenshot = Timer.scheduledTimer(timeInterval: seconds!, target: screenshotHandler, selector: #selector(ScreenShot.take), userInfo: nil, repeats: true)
        
        // useful
        
        if (Settings.getDetectSwitch() == 1){
            self.timerFrontmost = Timer.scheduledTimer(timeInterval: 3.0, target: frontmostappHandler, selector: #selector(FrontmostApp.DetectFrontMostApp), userInfo: nil, repeats: true)
        }
        
        //self.timerScroll = Timer.scheduledTimer(timeInterval: 1.0, target: activitiesHandler, selector: #selector(activitiesDetection.detectScrolling), userInfo: nil, repeats: true)
        
        //print("running apps")
        
        //self.timerCurrentAppList = Timer.scheduledTimer(timeInterval: 3.0, target: currentappHandler, selector: #selector(CurrentApplicationData.CurrentApplicationInfo), userInfo: nil, repeats: true)
        //openfileinforHandler.OpenFileInfor()
        
        self.ChangeTitleOfButton("Recording! Stop")
    }
    //useless
    @objc func abd(notification: Notification){
        print("yoyoy")
    }

    func stopAutomaticScreenShot() {
        self.timerScreenshot.invalidate()
        self.timerCurrentAppList.invalidate()
        self.timerFrontmost.invalidate()
        self.ChangeTitleOfButton("Click to start")
        let AddingDataAfterStopingHandler = JsondataAfterTracking()
        AddingDataAfterStopingHandler.DataAfterRecording(filepath: URL(string: MyVariables.yourVariable)!)
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
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
        //let temp = screen?.backingScaleFactor
        let scale = Int((screen?.backingScaleFactor)!)
//        print("scale")
//        print(scale)
        //print(temp)
        
        let rect = screen?.frame

        //let height = Int((rect?.size.height)!)
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
        //print(CompressionSlider.minValue)
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
//
//
//        let Window_Handler : NSViewController = TimeLapseMethodWindow()
//        let sub1Window = NSWindow(contentViewController:  Window_Handler)
//        sub2WindowController = NSWindowController(window: sub1Window)
//        MyVariables.openedBool = true
//        sub2WindowController?.showWindow(nil)
        
        
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
    
    

    // Quit this program
    @IBAction func ClickQuitButton(_ sender: Any) {
        //NSApplication.shared().terminate(self)
        
        exit(0)
    }
    
    
    @IBAction func dayLengthTextField(_ sender: Any) {
        //print(sender.self)
        let temp = Double(imageSize.maxSize)
        let imageSize = CompressionSlider.doubleValue * temp / CompressionSlider.maxValue
        //print(imageSize)
        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480
        //print(timeSum)
        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024
        //print(totalStore)
        //let timeInterval = 60 / Double(secondsTextBox.stringValue) * 60 * 8 * imageSize / 1024 / 1024
        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"
    }
    
    @IBAction func timeIntervalTextField(_ sender: Any) {
        let temp = Double(imageSize.maxSize)
        let imageSize = CompressionSlider.doubleValue * temp / CompressionSlider.maxValue
        //print(imageSize)
        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480
        //print(timeSum)
        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024
        //print(totalStore)
        //let timeInterval = 60 / Double(secondsTextBox.stringValue) * 60 * 8 * imageSize / 1024 / 1024
        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"
    }
    @IBAction func timeIntervalActionSecond(_ sender: NSTextField) {
        let temp = Double(imageSize.maxSize)
        let imageSize = CompressionSlider.doubleValue * temp / CompressionSlider.maxValue
        //print(imageSize)
        let timeInterval = Double(secondsTextBox.stringValue)!
        let timeSum = 60 / timeInterval * 480
        //print(timeSum)
        let day = Double(dayLength.stringValue)!
        let totalStoreMB = timeSum * imageSize / 1024
        let totalStoreGB = totalStoreMB * day / 1024
        //print(totalStore)
        //let timeInterval = 60 / Double(secondsTextBox.stringValue) * 60 * 8 * imageSize / 1024 / 1024
        estimatedInfor.stringValue = "Estimated disk space: " + String(format: "%.1f",totalStoreGB) + "GB"
    }
    
}
