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
    
    var body: some View {
        VStack {
            if wcManager.isReachable {
                Image(systemName: "iphone")
                    .foregroundStyle(.green)
            } else {
                Image(systemName: "iphone.slash")
                    .foregroundStyle(.red)
            }
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    WatchView()
}
