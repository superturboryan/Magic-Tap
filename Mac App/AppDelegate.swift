//
//  AppDelegate.swift
//  Magic Tap
//
//  Created by Ryan on 2024-11-21.
//

import Cocoa
import Keypress
import SwiftUI
import XinChao

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let xinchao = XinChaoAdvertiser()
    
    var statusItem: NSStatusItem!
    var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupstatusItem()
        
        xinchao.stopAdvertising()
        xinchao.startAdvertising()
        setupKeypress()
        
        openSettings()
    }
    
    private func setupstatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.behavior = .terminationOnRemoval
        statusItem.button!.title = "👌"
        
        let quitButton = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q")
        let settingsButton = NSMenuItem(title: "Settings 🎛️", action: #selector(openSettings), keyEquivalent: "o")
        
        let menu = NSMenu()
        menu.items = [
            settingsButton,
            quitButton
        ]
        statusItem.menu = menu
    }

    @objc func quitApp() {
        NSApp.terminate(nil)
    }
    
    @objc func openSettings() {
        guard settingsWindow == nil else {
            settingsWindow!.makeKeyAndOrderFront(nil)
            return
        }
        
        settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        settingsWindow!.center()
        settingsWindow!.styleMask = [.titled, .fullSizeContentView]
        settingsWindow!.titleVisibility = .hidden
        settingsWindow!.titlebarAppearsTransparent = true
        
        settingsWindow!.title = "👌✨ Settings"
        settingsWindow!.isReleasedWhenClosed = false
        settingsWindow!.level = .floating

        let hostingController = SettingsView(xinchao: xinchao).hostingController
        settingsWindow!.contentView = hostingController.view
        settingsWindow!.makeKeyAndOrderFront(nil)
    }
    
    func setupKeypress() {
        let defaults = UserDefaults.standard
        xinchao.onReceiveMessage { _ in
            if
                let secondModifier = defaults.string(forKey: "secondModifier"),
                !secondModifier.isEmpty,
                let firstModifier = defaults.string(forKey: "firstModifier"),
                !firstModifier.isEmpty,
                let key = defaults.string(forKey: "key")
            {
                keypress.press(key, with: firstModifier, and: secondModifier)
            } else if
                let firstModifier = defaults.string(forKey: "firstModifier"),
                !firstModifier.isEmpty,
                let key = defaults.string(forKey: "key")
            {
                keypress.press(key, with: firstModifier)
            } else if
                let key = defaults.string(forKey: "key"),
                !key.isEmpty
            {
                keypress.press(key)
            }
        }
    }
}

private extension View {

    var hostingController: NSHostingController<Self> {
        .init(rootView: self)
    }
}
