//
//  WaterViewController.swift
//  DrinkWater
//
//  Created by Pulkit Mahajan on 12/28/20.
//

import Cocoa
import Foundation

let testTime = 15.0;
let minute = 60.0;
let hour = minute * 60;
var windowHeight: CGFloat = 100;


class WaterViewController: NSViewController, NSWindowDelegate {


    var prefs: Preferences!
    //Set this up later
    var cupCount = 0
    
    @IBOutlet var countLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        countLabel.intValue = Int32(Preferences.cupCount);
    }
    
    override func viewDidAppear() {
        countLabel.intValue = Int32(Preferences.cupCount)
    }
    
    func setPrefs(myPrefs: Preferences){
//        print("set my prefs first")
        prefs = myPrefs
    }

}


extension WaterViewController{
    
    @IBAction func sub(sender: NSButton){
        print("Sub")
        if(Preferences.cupCount > 0){
            Preferences.cupCount -= 1
            countLabel.intValue = Int32(Preferences.cupCount)
        }
    }
    @IBAction func add(sender: NSButton){
        print("Add")
        Preferences.cupCount += 1
        countLabel.intValue = Int32(Preferences.cupCount)
    }
    @IBAction func prefButton(sender: NSButton){
        print("Prefs")
    }
    @IBAction func about(sender: NSButton){
        print("About (Test for now)")
//        var waterReminderTimer = Timer.scheduledTimer(timeInterval: testTime, target: self, selector: #selector(WaterViewController.sendNotif), userInfo: nil, repeats: true)
//        sendNotif()
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
