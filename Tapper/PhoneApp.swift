//
//  Phone.swift
//  Tapper
//
//  Created by Ryan on 2024-11-16.
//

import Common
import SwiftUI

@main
struct TapperApp: App {
    
    @StateObject var wcManager = WCManager()
    
    var body: some Scene {
        WindowGroup {
            PhoneView()
        }
        .environmentObject(wcManager)
    }
}
