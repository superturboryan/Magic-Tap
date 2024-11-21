//
//  MacApp.swift
//  Magic Tap
//
//  Created by Ryan on 2024-11-20.
//

import Common
import SwiftUI

@main
struct Magic_Tap_Mac_AppApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
//            MacView()
        }
    }
}
