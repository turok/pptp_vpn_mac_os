//
//  PreferencesViewController.swift
//  vpn
//
//  Created by Anton Turko on 03/01/2019.
//  Copyright © 2019 Anton Turko. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    @IBOutlet weak var serverAddress: NSTextField!
    @IBOutlet weak var login: NSTextField!
    @IBOutlet weak var password: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSApp.activate(ignoringOtherApps: true)
        let preferences = Preferences()
        serverAddress.stringValue = preferences.server()
        login.stringValue = preferences.login()
        password.stringValue = preferences.password()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func saveAction(_ sender: Any) {
        let preferences = Preferences()
        preferences.save(server: serverAddress.stringValue, login: login.stringValue, password: password.stringValue)
        self.view.window?.close()
    }
    
}

