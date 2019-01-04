//
//  StatusMenuController.swift
//  vpn
//
//  Created by Anton Turko on 03/01/2019.
//  Copyright © 2019 Anton Turko. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var isRunning = false
    var runTask:Process!
    var outputPipe:Pipe!
    @IBOutlet weak var connectButton: NSMenuItem!
    
    override func awakeFromNib() {
        let icon = NSImage(named: "statusIcon")
        icon?.isTemplate = true // best for dark mode
        statusItem.button?.image = icon
        statusItem.menu = statusMenu
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectOnExit), name: NSApplication.willTerminateNotification, object:nil)
    }
    
    @IBAction func preferencesAction(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        if let windowController = storyboard.instantiateController(withIdentifier: "window") as? NSWindowController {
            windowController.showWindow(self)
        }
    }
    
    @IBAction func connectAction(_ sender: Any) {
        if (!isRunning) {
            connect()
        } else {
            disconnect()
        }
        connectButton.title = isRunning ? "Disconnect" : "Connect"
    }

    private func disconnect(waitExecute:Bool=false) {
        self.runTask.terminate()
        runScript(scriptToExecute:"killall pppd", waitExecute: waitExecute)
        isRunning = false
    }

    @objc private func disconnectOnExit() {
        disconnect(waitExecute: true)
    }

    private func connect() {
        guard let path = Bundle.main.path(forResource: "RunScript", ofType:"command") else {
            print("Unable to locate RunScript.command")
            return
        }
        let configPath = Bundle.main.path(forResource: "vpn", ofType:"config")
        runScript(scriptToExecute: path + " " + configPath!)
        isRunning = true
    }

    private func runScript(scriptToExecute:String, waitExecute:Bool=false) {
        let taskQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        taskQueue.async {
            var arguments:[String] = []
            arguments.append("-c")
            arguments.append("osascript -e \"do shell script \\\"" + scriptToExecute + "\\\" with administrator privileges\"")
            self.outputPipe = Pipe()
            self.runTask = Process()
            self.runTask.standardOutput = self.outputPipe
            self.runTask.launchPath = "/bin/sh"
            self.runTask.arguments = arguments
            self.runTask.terminationHandler = {
                task in
                DispatchQueue.main.async(execute: {
                    print("Task Ended")
                })
            }
//            self.captureStandardOutputAndRouteToTextView(self.runTask)
            self.runTask.launch()
            if (waitExecute) {
                self.runTask.waitUntilExit()
            }
            print("Task Runing")
        }
    }

    private func captureStandardOutputAndRouteToTextView(_ task:Process) {
        
        //1.
        outputPipe = Pipe()
        task.standardOutput = outputPipe

        //2.
        outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
        //3.
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading , queue: nil) {
            notification in
        
            //4.
            let output = self.outputPipe.fileHandleForReading.availableData
            let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
        
            //5.
            DispatchQueue.main.async(execute: {
//                let previousOutput = self.outputText.string ?? ""
//                let nextOutput = previousOutput + "\n" + outputString
//                self.outputText.string = nextOutput

//                let range = NSRange(location:nextOutput.characters.count,length:0)
//                self.outputText.scrollRangeToVisible(range)
                
                print(outputString)
        
            })
        
            //6.
            self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        
            
        }
    }
}
