//
//  Phone.swift
//  Tapper
//
//  Created by Ryan on 2024-11-16.
//

import Common
import Controllers
import SwiftUI
import TipKit

@main
struct TapperApp: App {
    
    @StateObject var systemController = SystemController()
    @StateObject var wcManager = WCManager()
    
    init() {
        configureTips()
    }
    
    var body: some Scene {
        WindowGroup {
            PhoneView()
                .environmentObject(systemController)
                .environmentObject(wcManager)
        }
    }
    
    func configureTips() {
        #if DEBUG
        try? Tips.resetDatastore() // Always display tips
        #endif
        try? Tips.configure([
            .displayFrequency(.immediate)
        ])
    }
}
