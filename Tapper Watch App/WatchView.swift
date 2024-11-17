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
        VStack(spacing: 20) {
            phoneImage
            tapMeButton
        }
        .padding()
    }
    
    var phoneImage: some View {
        if wcManager.isReachable {
            Image(systemName: "iphone")
                .foregroundStyle(.green)
        } else {
            Image(systemName: "iphone.slash")
                .foregroundStyle(.red)
        }
    }
    
    var tapMeButton: some View {
        Button {
            wcManager.sendAction(selectedAction)
        } label: {
            Text("Tap me 🙂‍↕️")
        }
        .handGestureShortcut(.primaryAction)
    }
}

#Preview {
    WatchView()
}
