
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
}

let string = MyVariables.yourVariable
var jpath = MyVariables.jsonpath


@available(OSX 10.13, *)
class MainWindowViewController: NSViewController {
    static let applicationDelegate: AppDelegate = NSApplication.shared().delegate as! AppDelegate
    
    @IBOutlet weak var secondsTextBox: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    //@IBOutlet weak var path: NSPathControl!
    var path = URL(string: NSHomeDirectory() + "/Documents" + "/Reflect/")
    @IBOutlet weak var playSound: NSButton!
    
    //following are the height and width set of the scale of the image
    @IBOutlet weak var TimeInterval: NSTextField!
    @IBOutlet weak var TimeIntervalTwo: NSTextFieldCell!
    
    
    
    // A timer that fires after a certain time interval has elapsed, sending a specified message to a target object
    @IBOutlet weak var CompressRateLabel: NSTextFieldCell!
    
    var timerScreenshot: Timer = Timer()
    var timerFrontmost: Timer = Timer()
    var timerCurrentAppList: Timer = Timer()
    
    //var observerFrontmost:
    
    // new a object for class ScreenShot
    //let screenshotHandler = ScreenShot()
    let currentappHandler = CurrentApplicationData()
    let frontmostappHandler = FrontmostApp()
    let mouselocatinoHandler = DetectMousePosition()
    let openfileinforHandler = openfile()
    let jsonfileHandler = json()
    let appdelegateHandler = AppDelegate()
    
    
    lazy var window: NSWindow = self.view.window!
    
    
    var mouseLocation: NSPoint {
        return NSEvent.mouseLocation()
    }
    var location: NSPoint {
        return window.mouseLocationOutsideOfEventStream
    }
    
    var observers = [NSKeyValueObservation]()
    
    @IBOutlet weak var CaptureScreenshot: NSButton!
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.setSeconds()
        self.setImageHeight()
        self.setImageWidth()
        self.hideError()
        //self.setPath()
        //appdelegateHandler.SessionCounter(counter: 0)
        
        self.setPlaySound()
//        self.setImageSize()
//        print(frontmostappHandler.CurrentFrontMostApp)
//        print(currentappHandler.InitialSet)
        
        
        // show the mouse current position function
        //mouselocatinoHandler.CurrentMouseLocation()
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
//            print("mouseLocation:", String(format: "%.1f, %.1f", self.mouseLocation.x, self.mouseLocation.y))
//            print("windowLocation:", String(format: "%.1f, %.1f", self.location.x, self.location.y))
//            return $0
//        }
//        NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
//            self.mouseLocation == NSEvent.mouseLocation()
//            print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
//        }
        
        let height = Settings.TimeIntervalSecondTwoGet()
        let width = Settings.TimeIntervalSecondTwoGet()
        
        //upperrightpoint coordinate
        let UpperRightCoordinateX = Int(self.mouseLocation.x) - Int(height!)/2 < 0 ? 0 : Int(self.mouseLocation.x) - Int(height!)/2
        let UpperRightCoordinateY = Int(self.mouseLocation.y) + Int(width!)/2 > 900 ? 900 : Int(self.mouseLocation.y) + Int(width!)/2
        //lowerleftpoint coordinate
        let LowerLeftCoordinateX = Int(self.mouseLocation.x) + Int(height!)/2 > 1440 ? 1440 : Int(self.mouseLocation.x) + Int(height!)/2
        let LowerLeftCoordinateY = Int(self.mouseLocation.y) - Int(width!)/2 < 0 ? 0 : Int(self.mouseLocation.y) - Int(width!)/2
        
        
    }
    //slider from 480 to 1440
    @IBAction func CompressSilder(_ sender: NSSliderCell) {
        CompressRateLabel.stringValue = String(Int(sender.doubleValue))
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
    
    func setImageHeight(){
        let intervalseconds: Double? = Settings.TimeIntervalSecondGet()
        self.TimeInterval.stringValue = String(intervalseconds!)
    }
    func setImageWidth(){
        let intervalsecondstwo: Double? = Settings.TimeIntervalSecondTwoGet()
        self.TimeIntervalTwo.stringValue = String(intervalsecondstwo!)
    }
    

    // get the information of whether have sound or not
    func setPlaySound() {
        self.playSound.state = Settings.getPlaySound()
    }
    
    // show error
    // what error?
    func showError() {
        self.errorMessage.isHidden = false
    }
    
    // hide the error
    // what error?
    func hideError() {
        self.errorMessage.isHidden = true
    }
    
    
    //pass these three parameters into corresponding functions
    func saveSettings(_ seconds: Double?, path: URL?, playSound: Int, height: Int) {
        Settings.setSecondsIntervall(seconds)
        //print("in savesetting")
        //print(path)
        Settings.setPath(path)
        Settings.setPlaySound(playSound)
        Settings.setImageCompressHeight(height)
        
    }

    
//    func setPath() {
//        self.path.url = Settings.DefaultFolder() as URL
//        print("self.setpath: ")
//        print(self.path.url)
//        self.path.allowedTypes = ["public.folder"]
//    }
    
    
    func close() {
        let appDelegate : AppDelegate = NSApplication.shared().delegate as! AppDelegate
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
        }
    }
    
    // save current input, setting
    // only check second input is right or not
    func saveSettings() -> Bool {
        var success = true;
        let seconds: Double? = Double(self.secondsTextBox.stringValue)
        let path: URL? = self.path
        let playSound = self.playSound.state
        let height = self.CompressRateLabel.stringValue
        
        if(seconds == nil) {
            self.showError()
            success = false;
        }
        else {
            self.hideError()
            self.saveSettings(seconds, path: path, playSound: playSound, height: Int(height)!)
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
            print("json file path")
            //print(Settings.getPath())
            let date = Date()
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let year = calendar.component(.year, from: date)
            let current = String(year) + "-" + String(month) + "-" + String(day)
            //var SessionNumber = MainWindowViewController.applicationDelegate.fileNameDictionary[current] as! [Int]
            //print("this is the session number that is already sotred before create path")
            //print(SessionNumber.count)
            Settings.PathCreate()
            jpath = jsonfileHandler.createjson(filepath: URL(string: MyVariables.yourVariable)!)
            appdelegateHandler.changeicon()
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
        screenshotHandler.take()
        //useless
        NotificationCenter.default.addObserver(self, selector: #selector(abd(notification:)), name:NSNotification.Name.NSApplicationDidBecomeActive, object: (Any).self)
        
        self.timerScreenshot = Timer.scheduledTimer(timeInterval: seconds!, target: screenshotHandler, selector: #selector(ScreenShot.take), userInfo: nil, repeats: true)
        
        // useful
        self.timerFrontmost = Timer.scheduledTimer(timeInterval: 3.0, target: frontmostappHandler, selector: #selector(FrontmostApp.DetectFrontMostApp), userInfo: nil, repeats: true)
        //print("running apps")
        
        //self.timerCurrentAppList = Timer.scheduledTimer(timeInterval: 3.0, target: currentappHandler, selector: #selector(CurrentApplicationData.CurrentApplicationInfo), userInfo: nil, repeats: true)
        //openfileinforHandler.OpenFileInfor()
        
        self.ChangeTitleOfButton("Recording! Click to stopping automatic screenshot")
    }
    //useless
    @objc func abd(notification: Notification){
        print("yoyoy")
    }

    func stopAutomaticScreenShot() {
        self.timerScreenshot.invalidate()
        self.timerCurrentAppList.invalidate()
        self.timerFrontmost.invalidate()
        self.ChangeTitleOfButton("Capture automatic screenshot")
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
    
    // Go to the folder that save the screenshots
    @IBAction func GoToTheFolder(_ sender: Any) {

        NSWorkspace.shared().openFile(MyVariables.yourVariable)
    }
    
    
    // Click the more visualziation button
    // The window supposed to be open is in folder Views, Storyboard
    // This funciton aims to open a new window for future options
    
    //lazy var windowOne : NSWindow

    
    //click button for the display method one
    

    
    @IBAction func Visual_One(_ sender: Any) {
        
        let Method_One_Display_ViewControl_Handler : NSViewController = Method_One_Display_ViewControl()
        self.presentViewControllerAsModalWindow(Method_One_Display_ViewControl_Handler)
    }
    
    // Quit this program
    @IBAction func ClickQuitButton(_ sender: Any) {
        NSApplication.shared().terminate(self)
    }
    
    
}
