//
//  PhoneView.swift
//  Tapper
//
//  Created by Ryan on 2024-11-16.
//

import Common
import SwiftUI

struct PhoneView: View {
    
    @EnvironmentObject var wcManager: WCManager
    
    let actionPublisher = NotificationCenter.default.publisher(
        for: Action.key.notification
    )
    
    var body: some View {
        VStack {
            if wcManager.isReachable {
                Image(systemName: "checkmark.applewatch")
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "exclamationmark.applewatch")
                    .foregroundStyle(.red)
            }
            Text("Hello, world!")
        }
        .imageScale(.large)
        .padding()
        .onReceive(actionPublisher) { handleNotifcation($0) }
    }
    
    func handleNotifcation(_ notification: Notification) {
        guard let action = notification.userInfo?[Action.key] as? Action else {
            print("Action not found in notification.userInfo")
            return
        }
        perform(action)
    }
    
    func perform(_ action: Action) {
        print("Performing \(action)")
        switch action {

        case .incrementVolume:
            print("Not implemented")
        case .decrementVolume:
            print("Not implemented")
        case .toggleMute:
            print("Not implemented")
        case .togglePlayPause:
            print("Not implemented")
        case .nextTrack:
            print("Not implemented")
        case .previousTrack:
            print("Not implemented")
        case .vibrate:
            print("Not implemented")
        case .none:
            print("Not implemented")
        }
    }
}

#Preview {
    PhoneView()
}
