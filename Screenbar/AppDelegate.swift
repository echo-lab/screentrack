import Cocoa
import Foundation
import AppKit
import CoreData



@available(OSX 10.13, *)
@NSApplicationMain
//subtitied nsobject with nsviewcontroller
class AppDelegate: NSViewController, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: -2)
    let mainWindowPopover = NSPopover()
    var eventMonitor : EventMonitor?
    
    static let applicationDelegate: AppDelegate = NSApplication.shared.delegate as! AppDelegate
    static var SessionNumber = [Int]()
    
    var timerScroll: Timer = Timer()
    //var eventHandler  = activitiesDetection()
    
    var fileNameDictionary: NSMutableDictionary = NSMutableDictionary()

    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.addImage()
        self.initMainWindowPopover()
        self.initEventMonitor()
        self.UserDefaultsReset()
        //self.SessionCounter(counter: 0)
        print("launch")
//        self.FoldernamePlist()
        // Override point for customization after application launch.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let current = String(year) + "-" + String(month) + "-" + String(day)
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/filename.plist"
        let fileManager = FileManager.default
        let time = AppDelegate.FoldernameTime()
        if (!fileManager.fileExists(atPath: plistFilePathInDocumentDirectory)) {
            /*
             here is where we are going to create the plist file
             */
           
            //print(length)
            let dicContent:[String: [Int]] = [time: [0]]
            let plistContent = NSDictionary(dictionary: dicContent)

            let success:Bool = plistContent.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
            if success {
                print("file has been created!")
            }else{
                print("unable to create the file")
            }
        }else{
            //file exist, but if it is a new day, it dont contain today,


            var nsDictionary: NSDictionary?
            nsDictionary = NSDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
            
            if nsDictionary?.value(forKey: time) == nil{
                let dicContent:[String: [Int]] = [time: [0]]
                let plistContent = NSDictionary(dictionary: dicContent)
                
                //
                do{
                    let temp = "file://" + plistFilePathInDocumentDirectory
                    let urlofplist = URL(string : temp)
                    let data = try Data(contentsOf: urlofplist!)
                    print("data")
                    var plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String : [Int]]
                    plist?.updateValue([0], forKey: time)
                    let plistData = try PropertyListSerialization.data(fromPropertyList: plist!, format: .xml, options: 0)
                    try plistData.write(to: urlofplist!)
                    
                }catch{
                    print(error.localizedDescription)
                }
                

                
                
                
                //
                //let success:Bool = plistContent.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
                
                
                
//                var propertyListForamt =  PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
//                var plistData: [String: AnyObject] = [:] //Our data
//                let plistPath = plistFilePathInDocumentDirectory //the path of the data
//                let plistXML = FileManager.default.contents(atPath: plistPath)!
//                do {//convert the data to a dictionary and handle errors.
//                    plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListForamt) as! [String:AnyObject]
//                    plistData.
//
//                } catch {
//                    print("Error reading plist: \(error), format: \(propertyListForamt)")
//                }
                
            }
//            if AppDelegate.applicationDelegate.fileNameDictionary.value(forKey: time) == nil{
//                let dicContent:[String: [Int]] = [time: [0]]
//                let plistContent = NSDictionary(dictionary: dicContent)
//                let success:Bool = plistContent.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
//            }
            
            print("filename plist file already exist")
        }
        /*
         Instantiate an NSMutableArray object and initialize it with the contents of the
         RecipesILike.plist file from the Document directory on the user's iOS device.
         */
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        /*
         IF the optional variable arrayFromFile has a value, THEN
         RecipesILike.plist exists in the Document directory and the array is successfully created
         ELSE
         read RecipesILike.plist from the application's main bundle.
         */
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            
            // CountryCities.plist exists in the Document directory
            fileNameDictionary = dictionaryFromFileInDocumentDirectory
            
        } else {
            /******************************************************************************************
             RecipesILike.plist does not exist in the Document directory; Read it from the main bundle.
             
             This will be the case only when the app is launched for the very first time. Thereafter,
             RecipesILike.plist will be written to and read from the iOS device's Document directory.
             
             For readability purposes, the plist file contains " | " to separate the data values.
             Since URLs cannot have spaces and names should not begin or end with a space,
             we clean the RecipesILike.plist data by replacing all occurrences of " | " with "|"
             *****************************************************************************************/
            
            // Obtain the file path to the plist file in the main bundle (project folder)
            let plistFilePathInMainBundle: String? = Bundle.main.path(forResource: "filename", ofType: "plist")
            
            // Instantiate an NSMutableDictionary object and initialize it with the contents of the CountryCities.plist file.
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            
            // Store the object reference into the instance variable
            fileNameDictionary = dictionaryFromFileInMainBundle!
            
        }
        
        //let defaults = UserDefaults.standard
        let handler = MainWindowViewController()
        
        NSEvent.addGlobalMonitorForEvents(matching: .scrollWheel, handler: keyDown)

        //defaults.setValue("60.0", forKey: handler.secondsTextBox.stringValue)
        
    }
    func keyDown(event: NSEvent!){
        print("scroll whell")
        //return event
    }
    

    func applicationWillResignActive(_ notification: Notification) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/filename.plist"
        
        // Write the NSMutableDictionary to the CountryCities.plist file in the Document directory
        fileNameDictionary.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        //print("write into plist")
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        // Add the plist filename to the document directory path to obtain an absolute path to the plist filename
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/filename.plist"
        
        // Write the NSMutableDictionary to the CountryCities.plist file in the Document directory
        fileNameDictionary.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        //print("write into plist")
    }
    
    //Using plist to store filename
    static func FoldernameTime() -> String{
        let date = Date()
        let calendar = Calendar.current
        //let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        //let path = documentDirectory.appending("／Reflect/filename.plist")
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let Time = String(year) + "-" + String(month) + "-" + String(day)
        return Time
    }
    // set the image or icon on menubar
    func addImage() {
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "ScreenbarIcon"))
            statusItem.alternateImage = button.image
            statusItem.highlightMode = true
            button.action = #selector(self.showMainWindow)
        }
    }
    
    func changeicon(){
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(rawValue: "recording"))
            statusItem.alternateImage = button.image
            statusItem.highlightMode = true
            button.action = #selector(self.showMainWindow)
        }
    }
//    func UserDefaultValueSet(){
//        let handler = MainWindowViewController()
//
//        let defaults = UserDefaults.standard
//        defaults.setValue("60.0", forKey: handler.secondsTextBox.stringValue)
//    }
    
    //user default reset
    func UserDefaultsReset(){
        let domain = Bundle.main.bundleIdentifier!
        
        //UserDefaults.standard.removePersistentDomain(forName: domain)
        //UserDefaults.standard.removePersistentDomain(forName: "pathKey")
    }
    
    func initMainWindowPopover() {
        self.mainWindowPopover.contentViewController = MainWindowViewController(nibName: NSNib.Name(rawValue: "MainWindowView"), bundle: nil)
    }
    
    func initEventMonitor() {
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [unowned self] event in
            if self.mainWindowPopover.isShown {
                self.hideMainWindow(event)
            }
        }
        eventMonitor?.start()
    }
    
    //counter for sessions, initial is 0 as defalut
    func SessionCounter(counter: Int) -> Int{
        let counter = counter + 1
        return counter
    }
    
    //var sub1WindowController: NSWindowController?
    
    @objc func showMainWindow() {

        if let button = statusItem.button {
            // main window opened, so close it
            if(self.mainWindowPopover.isShown) {
                self.hideMainWindow(self)
            }
            //even minimazie, MyVariables.sub1WindowController?.showWindow(nil) still not nil
            else if (MyVariables.sub1WindowController?.showWindow(nil) == nil && MyVariables.openedBool == true && self.mainWindowPopover.isShown == false){
                print("==nil")
                MyVariables.sub1WindowController?.showWindow(nil)
            }
                
            // first open main window
            else if (MyVariables.sub1WindowController?.showWindow(nil) == nil && MyVariables.openedBool == false && self.mainWindowPopover.isShown == false){
                self.mainWindowPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                eventMonitor?.start()
            }
                
            else if(MyVariables.sub1WindowController?.showWindow(nil) != nil && MyVariables.openedBool == true && self.mainWindowPopover.isShown == false){
                print(MyVariables.sub1WindowController?.showWindow(nil) ?? "warning")
                print(self.mainWindowPopover.isShown)
                
                self.mainWindowPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                eventMonitor?.start()
                print("yyy")
                

            }
                
            else {
                print("Beg")
                print(MyVariables.sub1WindowController?.showWindow(nil))

                print(self.mainWindowPopover.isShown)
//                self.mainWindowPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
//                eventMonitor?.start()
                print("44444")
                MyVariables.sub1WindowController?.showWindow(nil)
            }
        }
    }
    
//    func doubleClickSimulator(){
//        if let button = statusItem.button {
//            if(self.mainWindowPopover.isShown) {
//                self.hideMainWindow(self)
//            }
//        }
//    }
    
    
    func hideMainWindow(_ sender: AnyObject?) {
        self.mainWindowPopover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func terminate() {
        exit(0)
    }
    
    // MARK: - Core Data stack
    //core data copy
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Screenbar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }
    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            
            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            //let answer = alert.runModal()
            // some trouble: Expression type 'Bool' is ambiguous without more context
//            if (answer == .alertSecondButtonReturn) {
//                return .terminateCancel
//            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }
    
    
}

