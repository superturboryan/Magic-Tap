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
    
    @State var selectedAction: Action = .nextTrack
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                selectActionPicker
                tapMeButton
            }
            .padding()
            .fontDesign(.rounded)
            .toolbar {
                phoneImage
            }
        }
        .onChange(of: selectedAction) { old, new in
            wcManager.updateSelectedAction(new)
        }
    }
    
    var selectActionPicker: some View {
        Picker(selection: $selectedAction) {
            ForEach(Action.allCases) {
                Text($0.display).tag($0)
            }
        } label: {
            Text("Selected 👌 Action")
                .font(.callout)
        }
    }
    
    var phoneImage: some ToolbarContent {
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
    
    var tapMeButton: some View {
        Button {
            wcManager.sendAction(selectedAction)
        } label: {
            Text("Double Tap 🙂‍↕️")
        }
        .handGestureShortcut(.primaryAction)
    }
}

#Preview {
    WatchView()
}
