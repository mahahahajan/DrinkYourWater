//
//  PrefsViewController.swift
//  DrinkWater
//
//  Created by Pulkit Mahajan on 12/29/20.
//
import Cocoa

class PrefsViewController: NSViewController, NSWindowDelegate {
    
    var overlayWindow: NSWindow!
    var screen: NSScreen!
    var prefs : Preferences!
    var reminderTimeValueHolder : Double!
    var resetTimer: Timer!
    var reminderTimer: Timer!
    var notifRadioButtons: [NSButton]!
    var notifTypeNumberHolder: Int!
    var notificationPeriodChanged = 0
    
    //TODO: Notification wont show up if preferences is open
    
    @IBOutlet var reminderStepperValue: NSStepperCell!
    @IBOutlet var reminderTimeField: NSTextField!
    @IBOutlet var unitsControl: NSPopUpButton!
    
    @IBOutlet var MainTextField: NSTextField!
    @IBOutlet var SubTextField: NSTextField!
    
    @IBOutlet var resetTimeText: NSTextField!
    
    @IBOutlet var nonIntrusiveSwitch: NSButton!
    @IBOutlet var intrusiveSwitch: NSButton!
    @IBOutlet var bothSwitch: NSButton!
    
    
    @IBOutlet var notifTextField: NSTextField!
    @IBOutlet var subtextField: NSTextField!
    
    
    @IBOutlet var showIconCheckbox: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tempScreen = NSScreen.main {
            windowHeight = tempScreen.visibleFrame.height/2
            screen = tempScreen
        }
        // Do view setup here.
//        print("Level is: " , self.view.window?.level)
//        self.view.window?.level = .normal
//        self.overlayWindow?.level = .floating
        notificationPeriodChanged = 0
        notifRadioButtons = [nonIntrusiveSwitch, intrusiveSwitch, bothSwitch]
        loadPrefs()
    }
    
    override func viewDidAppear() {
        for window in NSApplication.shared.windows {
            if(window.title == "Preferences"){
                notificationPeriodChanged = 0
                window.level = .normal
                window.update()
//                window.close()
            }
            if(window.title == ""){
                window.makeFirstResponder(window.firstResponder)
                window.makeKeyAndOrderFront(nil)
                window.makeKey()
            }
        }
    }
    
    func loadPrefs() {
        reminderTimeValueHolder = Preferences.reminderTime / 3600 //For right now, the first view is already in hours
        
        reminderStepperValue.doubleValue = reminderTimeValueHolder
        reminderTimeField.stringValue = reminderStepperValue.stringValue
        reminderTimeField.isHighlighted = false
        reminderTimeField.refusesFirstResponder = true
        
        print(Preferences.resetTime)
        resetTimeText.stringValue = Preferences.resetTime
        resetTimeText.isHighlighted = false
        resetTimeText.refusesFirstResponder = true
        resetTimeText.alignment = .right
        
        //TODO: set radio buttons
        notifTypeNumberHolder = Preferences.notifTypeNum
        notificationTypeSwitcher(notifRadioButtons[notifTypeNumberHolder-1])
        
        notifTextField.stringValue = Preferences.notifText
        notifTextField.isHighlighted = false
        notifTextField.refusesFirstResponder = true
        
        subtextField.stringValue = Preferences.subText
        subtextField.isHighlighted = false
        subtextField.refusesFirstResponder = true
        
        let showAppIconHolder: Int
        switch(Preferences.showDockIcon){
        case true:
            showAppIconHolder = 1
        case false:
            showAppIconHolder = 0
        }
        
        showIconCheckbox.integerValue = showAppIconHolder
        showIconCheckbox.isHighlighted = false
        showIconCheckbox.refusesFirstResponder = true
       
    }
    
    @objc func userHitChugButton(_ sender: NSButton){
        closeOverlay(myWindow: overlayWindow)
//        Preferences.cupCount += 1
    }
    
    @objc func userDrankButton() {
        print("HELLO WORLD")
        print("User Drank Water button")
        //TODO:Close Overlay
        //TODO: Update count
        //Update other information?
        //TODO: Play Sound
//        let senderButton = sender as! NSButton
        closeOverlay(myWindow: overlayWindow)
        Preferences.cupCount += 1
    }
    
    
    
    @objc func updateResetTimer() {
        
        let resetTimeHolder = Preferences.resetTime
        print(resetTimeHolder)
        let resetTimePieces = resetTimeHolder.split(separator: ":")
        print("hours: " , resetTimePieces[0], " and min: " , resetTimePieces[1])
        
        let now = Date()
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, hour: Int(resetTimePieces[0]), minute: Int(resetTimePieces[1]))
        let nextResetTime = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
        
        
        //TODO: Set this back to 24 hours
    //        let resetTimer = Timer.scheduledTimer(timeInterval: 4, target: waterViewController!, selector: #selector(waterViewController.clearCups), userInfo: nil, repeats: true)
        if(resetTimer != nil){
            resetTimer.invalidate()
        }
        resetTimer = Timer.init(fireAt: nextResetTime, interval: 24 * 60 * 60, target: self, selector: #selector(clearCups), userInfo: nil, repeats: true)
        
        //TODO: Check for existing resetTimer
        RunLoop.main.add(resetTimer, forMode: .common)
    }
    
    @objc func clearCups() {
        print("Clear cups")
        Preferences.cupCount = 0
    }
    
    func setTimer(time: TimeInterval) {
//        let date = Date().addingTimeInterval(time)
//        Timer.init(fireAt: date, interval: time, target: self, selector: #selector(WaterViewController.sendNotif), userInfo: nil, repeats: true)
        if(reminderTimer != nil){
            reminderTimer.invalidate()
        }
        reminderTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(PrefsViewController.sendNotif), userInfo: nil, repeats: true)
        RunLoop.main.add(reminderTimer, forMode: .common)
        print("setTimer for ",  Preferences.reminderTime)
    }
    
    @objc func sendNotif(){
        print("Notif type is (Send Notif): ", Preferences.notifTypeNum)
//        print("Sender is: " , sender)
        switch(Preferences.notifTypeNum){
        case 1:
            createSmallNotif()
        case 2:
            createOverlay()
        case 3:
            createSmallNotif()
            createOverlay()
        default:
            break;
        }
    }
    
    @objc func createSmallNotif(){
        let notification = NSUserNotification()
        notification.title = Preferences.notifText
    //        notification.subtitle = "This is a reminder"
        notification.informativeText = Preferences.subText
        notification.hasReplyButton = false
        notification.hasActionButton = true
        notification.otherButtonTitle = "Close"
        notification.actionButtonTitle = "Chug"
        
        var actions = [NSUserNotificationAction]()
        let action1 = NSUserNotificationAction(identifier: "action1", title: "Action 1")
        actions.append(action1)
        
        notification.additionalActions = actions
        
        notification.soundName = NSUserNotificationDefaultSoundName
//        notification.deliveryRepeatInterval?.hour = 60
        notification.contentImage = NSImage(byReferencingFile: "water-glass.png")
        // Manually display the notification
        let notificationCenter = NSUserNotificationCenter.default
    //        notificationCenter.obser
        notificationCenter.deliver(notification)
    }
    
    
    
    @objc func closeOverlay(myWindow: NSWindow){
        myWindow.close()
    }
    
    func createOverlay(){
        
        let window = NSPanel(contentRect: NSRect(x: 0, y: 0, width: 0, height: 0), styleMask: [.borderless, .titled, .closable], backing: .buffered, defer: false)
        if(overlayWindow != nil){
            closeOverlay(myWindow: overlayWindow)
        }
        overlayWindow = window
        
        self.view.wantsLayer = true;
        window.contentView?.wantsLayer = true;
        //window.backgroundColor = .init(red: 0, green: 173/255, blue: 1, alpha: 1)
        window.backgroundColor = .init(red: 30/255, green: 180/255, blue: 233/255, alpha: 1)
        
//        window.backgroundColor = .init(patternImage: NSImage(named: NSImage.Name.init("reminder"))!)
        window.styleMask.remove(NSWindow.StyleMask.miniaturizable)
        window.standardWindowButton(NSWindow.ButtonType.fullScreenButton)?.isHidden = true
        window.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(NSWindow.ButtonType.zoomButton)?.isHidden = true
        window.delegate = self
        //THIS LINE STOPS THE CRASH ON CLOSE
        window.isReleasedWhenClosed = false
        window.setFrame(NSRect(x:0, y: 0, width: screen.visibleFrame.width, height: screen.visibleFrame.height ), display: true, animate: true)
        
        let imageView = NSImageView(frame: window.frame)
        imageView.frame = CGRect(x: Int(window.frame.width * 17/48), y: Int(window.frame.height * 3/12), width: 450, height: 450)
//             Set image property and replace name with your image file's name
        imageView.image = NSImage(named: "water-glass")
        if ( 0 <= Preferences.cupCount && Preferences.cupCount < 3){
            imageView.image = NSImage(named: "smallWater")
//            window.contentView?.layer?.contents = NSImage(named: "smallWater")
        }
        else if ( 3 <= Preferences.cupCount && Preferences.cupCount < 7){
            imageView.image = NSImage(named: "medWater")
//            window.contentView?.layer?.contents = NSImage(named: "smallWater")
        }
        else {
            imageView.image = NSImage(named: "bigWater")
//            window.contentView?.layer?.contents = NSImage(named: "smallWater")
        }
        
//        window.contentView?.layer?.contents = NSImage(named: "reminder")
        let acceptButton = NSButton(frame: window.frame)
        acceptButton.target = self
//        acceptButton.sendAction(on: .leftMouseUp)
        acceptButton.action = #selector(PrefsViewController.userDrankButton)
        acceptButton.isEnabled = true
        
        acceptButton.isBordered = true
        acceptButton.bezelStyle = .shadowlessSquare
        acceptButton.wantsLayer = true
//        acceptButton.image =  NSImage(named: "buttonBg")
//        12, 206, 107
//        44, 246, 179
        acceptButton.layer?.backgroundColor = .init(red: 4/255, green: 255/255, blue: 52/255, alpha: 1)
        
//        acceptButton.highlight(true)
        acceptButton.frame = CGRect(x: Int(window.frame.width * 18/48), y: Int(windowHeight/4), width: Int(window.frame.width/4), height: Int(window.frame.height/10))
        let acceptFont = NSFont(name: "Futura", size: 75)
        acceptButton.font = acceptFont
        acceptButton.title = "Chug"
        acceptButton.updateLayer()
        
        
//            textView.frame = CGRect(x: 0, y: screen.frame.midY, width: screen.visibleFrame.width, height: 400)
        let textView = NSTextView(frame: window.frame)
//        textView.setFrameOrigin(window.frame.origin)
        textView.frame = CGRect(x: 0, y: window.frame.height - (windowHeight * 0.7), width: window.frame.width, height: windowHeight * 2/3)
        textView.usesRuler = false
        textView.string = Preferences.notifText
        textView.lowerBaseline(nil)
//        textView.textStorage?.append(NSAttributedString(string: "Test"))
        textView.isEditable = false
        textView.backgroundColor = .init(red: 0,   green: 0, blue: 0, alpha: 0)
        textView.isSelectable = false
        textView.alignment = .center
        textView.isRichText = true
        let textFont = NSFont(name: "Futura", size: 200)
        textView.font = textFont
        
        window.contentView?.addSubview(textView )
        window.contentView?.addSubview(acceptButton)
        window.contentView?.addSubview(imageView)
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden
        
//        window.contentView.
//        window.contentViewController = OverLayViewController(nibName: nil, bundle: nil)
//        window.makeMain()
        
//        window.acceptsFirstResponder = true
//        window.makeFirstResponder(window.firstResponder)
//        window.acceptsFirstResponder = window.becomeFirstResponder()
        
        window.level = .floating
        window.makeKeyAndOrderFront(nil)
        window.orderFrontRegardless()
//        window.makeKey()
//        window.order(.above, relativeTo: 3 )
//        window.trackEvents(matching: .any, timeout: 1000, mode: .common, handler: #selector(PrefsViewController.userDrankButton))
        
        print("Is this window a floating panel: " , window.isFloatingPanel)
//        window.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
//        window.level = .floating
        window.isOpaque = true
        window.animationBehavior = .default

//        print("Floating: " , window.isFloatingPanel)
    }
    
  
    
    @IBAction func increment(sender: NSStepper){
        reminderTimeField.stringValue = reminderStepperValue.stringValue
        reminderTimeValueHolder = reminderStepperValue.doubleValue
        notificationPeriodChanged = 1
        setReminderTime()
        
    }
    @IBAction func setReminderTimeFromTextfield(_ sender: Any) {
        reminderStepperValue.doubleValue = Double(reminderTimeField.stringValue)!
        reminderTimeValueHolder = reminderStepperValue.doubleValue
        notificationPeriodChanged = 1
        setReminderTime()
    }
    
    @IBAction func setResetTimeFromField(_ sender: Any) {
        Preferences.resetTime = resetTimeText.stringValue
        //TODO: updateResetTime
        self.updateResetTimer()
    }
    @IBAction func updateReminderTimeField(_ sender: Any) {
        print(unitsControl.selectedItem!.title)
        
        let currUnit = unitsControl.selectedItem!.title
        
        switch currUnit {
        case "hours":
            reminderTimeField.doubleValue = Preferences.reminderTime / 3600
        case "min":
            reminderTimeField.doubleValue = Preferences.reminderTime / 60
        default:
            reminderTimeField.doubleValue = Preferences.reminderTime
        }
        
    }
    //For some reason, setReminderTime needs to be called
    
    
    @IBAction func notificationTypeSwitcher(_ sender: NSButton) {
        print("Hit this")
        notifRadioButtons.forEach { $0.state = .off } // uncheck everything
        sender.state = .on // check the button that is clicked on
        Preferences.notifTypeNum = notifRadioButtons.firstIndex(of: sender)! + 1
        print("Pref notif number is " , Preferences.notifTypeNum)
    }
    
    @IBAction func sendTestNotif(_ sender: Any) {
        
        for window in NSApplication.shared.windows {
            if(window.title == "Preferences"){
                window.resignFirstResponder()
                window.resignKey()
                window.resignMain()
//                window.orderOut(sender)
                window.orderBack(sender)
//                window.order(.below, relativeTo: 0)
                //                window.close()
            }
        }
        sendNotif()
    }
    
    @IBAction func toggleDockIcon(_ sender: Any) {
        let checkBox = sender as! NSButton
        print(checkBox.stringValue)
//        NSApp.dockTile.badgeLabel = "12"
        if(checkBox.stringValue == "1" ){
            NSApp.setActivationPolicy(.regular)
            Preferences.showDockIcon = true
        } else{
            NSApp.setActivationPolicy(.accessory)
//            NSApp.menu
            NSApplication.shared.activate(ignoringOtherApps: true)
            Preferences.showDockIcon = false
        }
    }
    
    @IBAction func restoreDefaultsAction(_ sender: Any) {
        Preferences.resetToDefault()
        loadPrefs()
        print("Prefs should be reloaded")
    }
    
    @objc func setReminderTime() {
        
        print(unitsControl.selectedItem!.title)
        
        let currUnit = unitsControl.selectedItem!.title
        
        switch currUnit {
        case "hours":
            Preferences.reminderTime = reminderTimeValueHolder * 3600
        case "min":
            Preferences.reminderTime = reminderTimeValueHolder * 60
        default:
            Preferences.reminderTime = reminderTimeValueHolder
        }
        //TODO: Change timer
        setTimer(time: Preferences.reminderTime)
        
    }
    
//    override func viewWillDisappear() {
//        setReminderTime()
//    }
}




extension PrefsViewController {
  // MARK: Storyboard instantiation
    static func freshController() -> PrefsViewController {
    //1.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    //2.
    let identifier = NSStoryboard.SceneIdentifier("PrefsViewController")
    //3.
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PrefsViewController
    else {
      fatalError("Why cant i find PrefsViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
