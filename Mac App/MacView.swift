//
//  MacView.swift
//  Magic Tap Mac App
//
//  Created by Ryan on 2024-11-20.
//

import Common
import SwiftUI

struct MacView: View {
    
    @ObservedObject var bonjourAdvertiser = BonjourServiceAdvertiser()
    
    init() {
        bonjourAdvertiser.stopAdvertising()
        bonjourAdvertiser.startAdvertising()
    }
    
    var body: some View {
        VStack {
            Text("Magic Tap 👌✨")
                .font(.title)
            
            if bonjourAdvertiser.isAdvertising {
                HStack {
                    Text("Looking for device")
                    ProgressView()
                }
            } else if bonjourAdvertiser.isConnected {
                Button("Stop Bonjour ❌") {
                    bonjourAdvertiser.stopAdvertising()
                    bonjourAdvertiser.messages = []
                }
            } else {
                Button("Start Bonjour 🛜") {
                    bonjourAdvertiser.startAdvertising()
                }
            }
            
            List(bonjourAdvertiser.messages, id: \.self) {
                Text($0)
            }
        }
        .padding()
    }
}

#Preview {
    MacView()
}
