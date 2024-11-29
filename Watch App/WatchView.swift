//
//  WatchView.swift
//  Tapper Watch App
//
//  Created by Ryan on 2024-11-16.
//

import Common
import DoublePinch
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
        .onChange(of: selectedAction) { _, selectedAction in
            wcManager.updateSelectedAction(selectedAction)
        }
        .onChange(of: wcManager.isReachable) { _, isReachable in
            if isReachable {
                wcManager.updateSelectedAction(selectedAction)
            }
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
        .doublePinch()
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    var info: some View {
        ScrollViewReader { proxy in
            
            let scrollToSetupAfterDelay = {
                Task {
                    try? await Task.sleep(for: .seconds(3.5))
                    withAnimation(.spring) {
                        proxy.scrollTo("Steps", anchor: .top)
                    }
                }
            }
            
            ScrollView {
                VStack {
                    if isFirstLaunch {
                        onboarding
                    }
                    setup
                }
                .background(.black)
                .padding(.horizontal, 4)
                .fontDesign(.rounded)
            }
            .onAppear {
                if isFirstLaunch {
                    _ = scrollToSetupAfterDelay()
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
    
    var setup: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Follow these steps to get started:")
                .fontWeight(.semibold)
                .id("Steps")
            if isNewDoubleTapGestureSupported {
                doubleTapGestureSetup
            } else {
                accessibilityQuickActionSetup
            }
            Text("- Select an action using the crown on your watch")
            Text("- Double tap your fingers to send the action to your phone")
            Spacer(minLength: 10)
            Button("Continue") {
                showInfo = false
            }
        }
    }
    
    var doubleTapGestureSetup: some View {
        Group {
            Text("- Make sure Double Tap is turned on by going to")
            Text("Settings > Gestures > Double Tap")
                .fontWeight(.semibold)
        }
    }
    
    var accessibilityQuickActionSetup: some View {
        Group {
            Text("- Turn on Quick Actions by going to")
            Text("Settings > Accessibility > Quick Actions")
                .fontWeight(.semibold)
        }
    }
    
    var isNewDoubleTapGestureSupported: Bool {
        // Check if watch is Series 9 / Ultra or newer
        // https://gist.github.com/adamawolf/3048717#file-apple_mobile_device_types-txt
        var sysinfo = utsname()
        uname(&sysinfo)
        let machineMirror = Mirror(reflecting: sysinfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        guard
            let firstModelChar = model.first(where: \.isNumber),
            let firstModelInt = Int(String(firstModelChar))
        else {
            return false
        }
        return firstModelInt >= 7
    }
}

#Preview {
    WatchView()
}
