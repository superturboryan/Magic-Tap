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
    
    @State var selectedAction: Action = .none
    
    let performActionPublisher = NotificationCenter.default.publisher(
        for: MessageKeys.perform.notification
    )
    
    let selectActionPublisher = NotificationCenter.default.publisher(
        for: MessageKeys.select.notification
    )
    
    var body: some View {
        NavigationStack {
            VStack {
                selectedActionView
            }
            .imageScale(.large)
            .padding()
            .toolbar {
                watchImage
            }
        }
        .onReceive(performActionPublisher) { handleNotifcation($0) }
        .onReceive(selectActionPublisher) { handleNotifcation($0) }
    }
    
    var selectedActionView: some View {
        VStack {
            Text("Selected Action")
            Text("\(selectedAction.display)")
        }
        .font(.title)
        .animation(.default, value: selectedAction)
    }
    
    var watchImage: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
               // No action
            } label: {
                if wcManager.isReachable {
                    Image(systemName: "iphone")
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "iphone.slash")
                        .foregroundStyle(.red)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    func handleNotifcation(_ notification: Notification) {
        if let actionToSelect = notification.userInfo?[MessageKeys.select] as? Action {
            selectedAction = actionToSelect
        }
        
        if let actionToPerform = notification.userInfo?[MessageKeys.perform] as? Action {
            selectedAction = actionToPerform
            perform(actionToPerform)
        }
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
