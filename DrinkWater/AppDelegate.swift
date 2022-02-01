//
//  AppDelegate.swift
//  DrinkWater
//
//  Created by Pulkit Mahajan on 12/28/20.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    var waterViewController: WaterViewController!
    var prefsViewController: PrefsViewController!
    
//    var resetTimer: Timer!
    
    
    @objc func togglePopover(_ sender: Any?) {
//        popover.behavior = .transient
      if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }

    func showPopover(sender: Any?) {
      if let button = statusItem.button {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
        popover.contentViewController?.view.window?.makeKey()
        NSApplication.shared.activate(ignoringOtherApps: true)
//        popover.contentSize = NSSize(width: 300, height: 150)
        popover.behavior = .transient
      }
    }

    func closePopover(sender: Any?) {
      popover.close()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        Preferences.reminderTime = 25
        
        print(Preferences.reminderTime)
        
        prefsViewController = PrefsViewController.freshController()
        waterViewController = WaterViewController.freshController()
        prefsViewController.setTimer(time: Preferences.reminderTime)
        
        Preferences.cupCount = 0
        //TODO: Do I actually need this?
//        waterViewController.setPrefs(myPrefs: Preferences)
//        print("setting  preferences pane preferences" )
//        PrefsViewController().setPrefs(myPrefs: Preferences)
        
        let showDockIcon = Preferences.showDockIcon
        
        if(showDockIcon ){
            NSApp.setActivationPolicy(.regular)
        } else{
            NSApp.setActivationPolicy(.accessory)
//            NSApp.menu
            NSApplication.shared.activate(ignoringOtherApps: true)

        }
        
        //INFO: Sets the popover look here
        popover.contentViewController = waterViewController
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
          button.action = #selector(togglePopover(_:))
        }
        
        // TODO: consider making it a menu?
        NSUserNotificationCenter.default.delegate = self
        
        prefsViewController.updateResetTimer()
        
    }
    
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
            return true
    }
    

}

