//
//  Phone.swift
//  Tapper
//
//  Created by Ryan on 2024-11-16.
//

import Common
import Controllers
import SwiftUI

@main
struct TapperApp: App {
    
    @StateObject var systemController = SystemController()
    @StateObject var wcManager = WCManager()
    
    var body: some Scene {
        WindowGroup {
            PhoneView()
                .environmentObject(systemController)
                .environmentObject(wcManager)
        }
    }
}
