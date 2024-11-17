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
    }
}

#Preview {
    PhoneView()
}
