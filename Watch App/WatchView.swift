//
//  WatchView.swift
//  Tapper Watch App
//
//  Created by Ryan on 2024-11-16.
//

import Common
import SwiftUI

struct WatchView: View {
    
    @EnvironmentObject var wcManager: WCManager
    
    @AppStorage("selectedAction")
    var selectedAction: Action = .incrementVolume
    
    @State var showInfo = false
    
    @AppStorage("isFirstLaunch")
    var isFirstLaunch = true
    
    var body: some View {
        NavigationStack {
            VStack {
                selectActionPicker
            }
            .background {
                hiddenDoubleTapButton
            }
            .fontDesign(.rounded)
            .toolbar {
                phoneImage
                showInfoButton
            }
        }
        .onAppear {
            #if DEBUG
//            isFirstLaunch = true // FOR DEBUGGING ONBOARDING
            #endif
            if isFirstLaunch {
                showInfo = true
            }
        }
        .sheet(isPresented: $showInfo) {
            info
            .onDisappear {
                isFirstLaunch = false
            }
        }
        .onChange(of: selectedAction) { old, new in
            wcManager.updateSelectedAction(new)
        }
    }
    
    var selectActionPicker: some View {
        Picker(selection: $selectedAction) {
            ForEach(Action.allCases) {
                Text($0.display)
                    .font(.title)
                    .tag($0)
            }
        } label: {
            Text("Selected Action")
                .font(.title3)
                .fontWeight(.semibold)
        }
        .defaultWheelPickerItemHeight(55)
    }
    
    var phoneImage: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if wcManager.isReachable {
                Image(systemName: "iphone")
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "iphone.slash")
                    .foregroundStyle(.red)
            }
        }
    }
    
    var showInfoButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showInfo = true
            } label: {
                Image(systemName: "questionmark")
            }
            .foregroundStyle(.green)
        }
    }
        
    var hiddenDoubleTapButton: some View {
        Button {
            wcManager.sendAction(selectedAction)
        } label: {
            EmptyView()
        }
        .handGestureShortcut(.primaryAction)
        .buttonStyle(.plain)
    }
    
    var info: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                VStack {
                    if isFirstLaunch {
                        onboarding
                    }
                    VStack(spacing: 6) {
                        Text("Follow these steps to get started:")
                            .fontWeight(.semibold)
                            .id("Steps")
                        Text("- Make sure Double Tap is turned on by going to")
                        Text("Settings > Gestures > Double Tap")
                            .fontWeight(.semibold)
                        Text("- Select an action using the crown on your watch")
                        Text("- Double tap your fingers to send the action to your phone")
                        Spacer(minLength: 10)
                        Button("Continue") {
                            showInfo = false
                        }
                    }
                }
                .background(.black)
                .padding(.horizontal, 4)
                .fontDesign(.rounded)
            }
            .onAppear {
                if isFirstLaunch {
                    Task {
                        try? await Task.sleep(for: .seconds(3.5))
                        withAnimation(.spring) {
                            scrollView.scrollTo("Steps", anchor: .top)
                        }
                    }
                }
            }
        }
    }
    
    var onboarding: some View {
        VStack {
            Text("Welcome to Magic Tap")
                .fontWeight(.semibold)
                .font(.title2)
            Spacer(minLength: 6)
            Text("🥳 ✨")
                .font(.title2)
            Spacer(minLength: 5)
            Text("Control your phone in a pinch 🤏")
                .font(.title3)
            Spacer(minLength: 30)
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    WatchView()
}
