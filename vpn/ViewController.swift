//
//  ViewController.swift
//  vpn
//
//  Created by Anton Turko on 03/01/2019.
//  Copyright © 2019 Anton Turko. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var serverAddress: NSTextField!
    @IBOutlet weak var login: NSTextField!
    @IBOutlet weak var password: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSApp.activate(ignoringOtherApps: true)
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func connectAction(_ sender: Any) {
        
    }
    
}

