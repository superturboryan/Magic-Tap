//
//  WatchApp.swift
//  Tapper Watch App
//
//  Created by Ryan on 2024-11-16.
//

import Common
import SwiftUI

@main
struct Tapper_Watch_AppApp: App {
    
    @StateObject var wcManager = WCManager()
    
    var body: some Scene {
        WindowGroup {
            WatchView()
        }
        .environmentObject(wcManager)
    }
}
