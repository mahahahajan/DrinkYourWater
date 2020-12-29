//
//  WaterViewController.swift
//  DrinkWater
//
//  Created by Pulkit Mahajan on 12/28/20.
//

import Cocoa

class WaterViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
