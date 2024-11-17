//
//  PhoneView.swift
//  Tapper
//
//  Created by Ryan on 2024-11-16.
//

import Common
import Controllers
import SwiftUI

struct PhoneView: View {
    
    @EnvironmentObject var systemController: SystemController
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
            systemController.volume.increaseVolume()
        case .decrementVolume:
            systemController.volume.decreaseVolume()
        case .toggleMute:
            systemController.volume.toggleMute()
        case .togglePlayPause:
            systemController.togglePlayPause()
        case .nextTrack:
            systemController.skipToNextTrack()
        case .previousTrack:
            systemController.skipToPreviousTrack()
        case .vibrate:
            systemController.vibrate()
        
        case .none:
            print("Not implemented")
        }
    }
}

#Preview {
    PhoneView()
}
