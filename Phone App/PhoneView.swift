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
import TipKit

struct PhoneView: View {
    
    @EnvironmentObject var systemController: SystemController
    @EnvironmentObject var wcManager: WCManager
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var keepAwake = false
    @State var selectedAction: Action = .none
    @State var showAbout = false
    
    @AppStorage("tapCount")
    var tapCount = 0
    
    let performActionPublisher = NotificationCenter.default.publisher(
        for: MessageKeys.perform.notification
    )
    
    let selectActionPublisher = NotificationCenter.default.publisher(
        for: MessageKeys.select.notification
    )
    
    init() {
        UIApplication.shared.isIdleTimerDisabled = keepAwake
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                gradientBackground
                content
            }
            .ignoresSafeArea()
            .toolbar {
                watchImage
                aboutButton
            }
        }
        .sheet(isPresented: $showAbout) {
            AboutView()
        }
        .onReceive(performActionPublisher) { handleNotifcation($0) }
        .onReceive(selectActionPublisher) { handleNotifcation($0) }
        .onChange(of: keepAwake) { _, keepAwake in
            UIApplication.shared.isIdleTimerDisabled = keepAwake
        }
    }
    
    var gradientBackground: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    .background,
                    .background,
                    .cyan,
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .overlay(colorScheme == .dark ? .background.opacity(0.3) : Color.clear)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    .blue.opacity(0.5),
                    .clear
                ]),
                center: .bottomLeading,
                startRadius: 5,
                endRadius: 400
            )
            .blendMode(.overlay)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    .indigo.opacity(0.5),
                    .clear
                ]),
                center: .top,
                startRadius: 5,
                endRadius: 400
            )
            
        }
    }
    
    var content: some View {
        VStack(spacing: 20) {
            Spacer()
            
            watchStatusView
            
            Spacer()
            
            if wcManager.isWatchAppInstalled {
                keepAwakeToggle
            }
        }
    }
    
    var watchStatusView: some View {
        VStack {
            if !wcManager.isWatchAppInstalled {
                installWatchAppView
            } else if wcManager.isReachable {
                selectedActionView
                    .transition(.scale)
            } else {
                openWatchAppView
                    .transition(.scale)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 4)
        .animation(.spring, value: wcManager.isReachable)
    }
    
    var selectedActionView: some View {
        VStack(spacing: 20) {
            Text("Selected Action")
                .fontWeight(.semibold)
            Text("\(selectedAction.display)")
                .contentTransition(.numericText())
        }
        .font(.title)
        .animation(.default, value: selectedAction)
    }
    
    @ViewBuilder
    var keepAwakeToggle: some View {
        let tip = KeepAwakeTip()
        
        Toggle(isOn: $keepAwake) {
            Text("☕️ Keep screen ON")
                .fontWeight(.semibold)
        }
        .tint(.yellow)
        .padding([.bottom, .horizontal], 40)
        .popoverTip(tip, arrowEdge: .bottom) { _ in
            keepAwake = true
            tip.invalidate(reason: .actionPerformed)
        }
    }
    
    var openWatchAppView: some View {
        VStack(spacing: 20) {
            Text("Open watch app to continue")
                .font(.title3)
                .fontWeight(.semibold)
            
            Image(.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .mask(Circle())
        }
    }

    var watchImage: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
               // No action
            } label: {
                Image(systemName: wcManager.isReachable ? "checkmark.applewatch" : "applewatch.slash")
                    .foregroundStyle(wcManager.isReachable ? .blue : .red)
                    .fontWeight(.heavy)
                    .contentTransition(.symbolEffect(.replace))
                    .animation(.default, value: wcManager.isReachable)
            }
        }
    }
    
    var aboutButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showAbout = true
            } label: {
                Text("About")
                    .fontWeight(.semibold)
                    .popoverTip(OpenAboutViewTip(), arrowEdge: .top) { _ in
                        showAbout = true
                    }
            }
        }
    }
    
    var installWatchAppView: some View {
        Text("Install Magic Tapper \non your Apple Watch to begin")
            .font(.title2)
            .multilineTextAlignment(.center)
    }
    
    func handleNotifcation(_ notification: Notification) {
        if let actionToSelect = notification.userInfo?[MessageKeys.select] as? Action {
            selectedAction = actionToSelect
        }
        
        if let actionToPerform = notification.userInfo?[MessageKeys.perform] as? Action {
            selectedAction = actionToPerform
            perform(actionToPerform)
            tapCount += 1
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

extension Color {
    
    static var background: Color {
        .init(uiColor: UIColor.systemBackground)
    }
}
