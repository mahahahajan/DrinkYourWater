//
//  WaterViewController.swift
//  DrinkWater
//
//  Created by Pulkit Mahajan on 12/28/20.
//

import Cocoa
import Foundation

class WaterViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBOutlet var countLabel: NSTextField!
    
    
    @objc func sendNotif(){
        let notification = NSUserNotification()
        notification.identifier = String(Int.random(in: 1...100))
        notification.title = "Reminder: Water"
    //        notification.subtitle = "This is a reminder"
        notification.informativeText = "Drink your water!"
        
        notification.soundName = NSUserNotificationDefaultSoundName
        notification.deliveryRepeatInterval?.hour = 60
        notification.contentImage = NSImage(byReferencingFile: "water-glass.png")
        // Manually display the notification
        let notificationCenter = NSUserNotificationCenter.default
    //        notificationCenter.obser
        notificationCenter.deliver(notification)
    }
}



extension WaterViewController{
    
    @IBAction func sub(sender: NSButton){
        print("Sub")
        if(countLabel.intValue > 0){
            countLabel.intValue = (countLabel.intValue - 1)
        }
    }
    @IBAction func add(sender: NSButton){
        print("Add")
        countLabel.intValue = (countLabel.intValue + 1)
    }
    @IBAction func prefs(sender: NSButton){
        print("Prefs")
    }
    @IBAction func about(sender: NSButton){
        print("About")
        sendNotif()
    }
    @IBAction func quit(sender: NSButton){
        print("Quit")
        NSApplication.shared.terminate(self)
    }
}

extension WaterViewController {
  // MARK: Storyboard instantiation
  static func freshController() -> WaterViewController {
    //1.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    //2.
    let identifier = NSStoryboard.SceneIdentifier("WaterViewController")
    //3.
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? WaterViewController
    else {
      fatalError("Why cant i find WaterViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}
