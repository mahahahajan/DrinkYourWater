//
//  OverLayViewController.swift
//  DrinkWater
//
//  Created by Pulkit Mahajan on 9/13/21.
//

import Cocoa

class OverLayViewController:  NSViewController, NSWindowDelegate {

    
    override func loadView() {
        super.loadView()
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.window?.level = .floating
    }
    
    override func viewDidAppear() {
        self.view.window?.level = .floating
        self.view.window?.makeKey()
        self.view.window?.makeKeyAndOrderFront(nil)
    }
    
}
