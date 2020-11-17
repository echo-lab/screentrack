import Cocoa
import Foundation
import AppKit
import CoreData



@available(OSX 10.15, *)
@NSApplicationMain
//subtitied nsobject with nsviewcontroller
class AppDelegate: NSViewController, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: -2)
    let mainWindowPopover = NSPopover()
    var eventMonitor : EventMonitor?
    
    var fileNameDictionary: NSMutableDictionary = NSMutableDictionary()
    
    //MARK: Did Finish Launching
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.addImage()
        self.initMainWindowPopover()
        self.initEventMonitor()
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/filename.plist"
        let fileManager = FileManager.default
        let time = AppDelegate.FoldernameTime()
        if (!fileManager.fileExists(atPath: plistFilePathInDocumentDirectory)) {
            let dicContent:[String: [Int]] = [time: [0]]
            let plistContent = NSDictionary(dictionary: dicContent)

            let success:Bool = plistContent.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
            if success {
                print("file has been created!")
            } else {
                print("unable to create the file")
            }
        } else {
            var nsDictionary: NSDictionary?
            nsDictionary = NSDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
            
            if nsDictionary?.value(forKey: time) == nil{
                do {
                    let temp = "file://" + plistFilePathInDocumentDirectory
                    let urlofplist = URL(string : temp)
                    let data = try Data(contentsOf: urlofplist!)
                    print("data")
                    var plist = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String : [Int]]
                    plist?.updateValue([0], forKey: time)
                    let plistData = try PropertyListSerialization.data(fromPropertyList: plist!, format: .xml, options: 0)
                    try plistData.write(to: urlofplist!)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
//            print("filename plist file already exist")
        }
        
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            fileNameDictionary = dictionaryFromFileInDocumentDirectory
        } else {
            let plistFilePathInMainBundle: String? = Bundle.main.path(forResource: "filename", ofType: "plist")
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            fileNameDictionary = dictionaryFromFileInMainBundle!
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: .scrollWheel, handler: keyDown)
    }
    
    
    func applicationWillResignActive(_ notification: Notification) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/filename.plist"
        fileNameDictionary.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/filename.plist"
        fileNameDictionary.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
    }
    
    
    static func FoldernameTime() -> String{
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let Time = String(year) + "-" + String(month) + "-" + String(day)
        return Time
    }
    
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
    
    @objc func showMainWindow() {
        if let button = statusItem.button {
            if mainWindowPopover.isShown {
                self.hideMainWindow(self)
            } else if (UserData.TimelapseWindowController?.showWindow(nil) == nil && UserData.timelapseWindowIsOpen == true && self.mainWindowPopover.isShown == false){
                print("==nil")
                UserData.TimelapseWindowController?.showWindow(nil)
            } else if (UserData.TimelapseWindowController?.showWindow(nil) == nil && UserData.timelapseWindowIsOpen == false && self.mainWindowPopover.isShown == false){
                self.mainWindowPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                eventMonitor?.start()
            } else if (UserData.TimelapseWindowController?.showWindow(nil) != nil && UserData.timelapseWindowIsOpen == true && self.mainWindowPopover.isShown == false){
                self.mainWindowPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                eventMonitor?.start()
            } else {
                UserData.TimelapseWindowController?.showWindow(nil)
            }
        }
    }
    
    func hideMainWindow(_ sender: AnyObject?) {
        self.mainWindowPopover.performClose(sender)
        eventMonitor?.stop()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Screenbar")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    @IBAction func saveAction(_ sender: AnyObject?) {
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
        }
        return .terminateNow
    }
}

