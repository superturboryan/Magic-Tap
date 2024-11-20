//
//  PhoneView.swift
//  Tapper
//
//  Created by Ryan on 2024-11-16.
//

import Common
import Control
import Controllers
import SwiftUI

struct PhoneView: View {
    
    @EnvironmentObject var systemController: SystemController
    @EnvironmentObject var wcManager: WCManager
    
    @State var selectedAction: Action = .none
    @State var showAbout = false
    
    let bonjourBroswer = BonjourServiceBrowser()
    
    let performActionPublisher = NotificationCenter.default.publisher(
        for: MessageKeys.perform.notification
    )
    
    let selectActionPublisher = NotificationCenter.default.publisher(
        for: MessageKeys.select.notification
    )
    
    init() {
        bonjourBroswer.startBrowsing()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                selectedActionView
            }
            .font(.title)
            .imageScale(.large)
            .padding()
            .toolbar {
                watchImage
                showAboutButton
            }
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .onReceive(performActionPublisher) { handleNotifcation($0) }
        .onReceive(selectActionPublisher) { handleNotifcation($0) }
    }
    
    var selectedActionView: some View {
        VStack(spacing: 20) {
            Text("Selected Action")
                .fontWeight(.semibold)
            Text("\(selectedAction.display)")
        }
        .animation(.default, value: selectedAction)
    }
    
    var watchImage: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
               // No action
            } label: {
                if wcManager.isReachable {
                    Image(systemName: "checkmark.applewatch")
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "applewatch.slash")
                        .foregroundStyle(.red)
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    var showAboutButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAbout = true
            } label: {
                Image(systemName: "info.circle")
                    .fontWeight(.bold)
            }
        }
    }
    
    func handleNotifcation(_ notification: Notification) {
        if let actionToSelect = notification.userInfo?[MessageKeys.select] as? Action {
            selectedAction = actionToSelect
        }
        
        if let actionToPerform = notification.userInfo?[MessageKeys.perform] as? Action {
            selectedAction = actionToPerform
            perform(actionToPerform)
            bonjourBroswer.sendMessage("From watchOS with love 💌")
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
        case .toggleFlashlight:
            Control.Flashlight.toggle()
        
        case .none:
            print("Not implemented")
        }
    }
}

#Preview {
    PhoneView()
}
