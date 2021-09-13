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
    
    
//    @objc func printQuote(_ sender: Any?) {
//      let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
//      let quoteAuthor = "Mark Twain"
//
//      print("\(quoteText) — \(quoteAuthor)")
//    }
//    func constructMenu() {
//      let menu = NSMenu()
//
//      menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
//      menu.addItem(NSMenuItem.separator())
//      menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
//
//      statusItem.menu = menu
//    }
    
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
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        popover.contentViewController?.view.window?.makeKey()
        NSApplication.shared.activate(ignoringOtherApps: true)
        popover.behavior = .transient
      }
    }

    func closePopover(sender: Any?) {
      popover.close()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
          button.action = #selector(togglePopover(_:))
        }
                
        popover.contentViewController = WaterViewController.freshController()
        popover.behavior = .transient
//        constructMenu()
        NSUserNotificationCenter.default.delegate = self
        
        //Application is launched, start the timer that will send the notifications
        var waterReminderTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(WaterViewController.sendNotif), userInfo: nil, repeats: true)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
            return true
    }

}

