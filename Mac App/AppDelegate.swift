//
//  AppDelegate.swift
//  Magic Tap
//
//  Created by Ryan on 2024-11-21.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupstatusItem()
    }
    
    private func setupstatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.button!.title = "👌"
        
        let quitButton = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        let menu = NSMenu()
        menu.addItem(quitButton)
        
        statusItem.menu = menu
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
