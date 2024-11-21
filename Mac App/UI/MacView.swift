//
//  MacView.swift
//  Magic Tap Mac App
//
//  Created by Ryan on 2024-11-20.
//

import Common
import Keypress
import SwiftUI
import XinChao

struct MacView: View {
    
    @ObservedObject var bonjourAdvertiser = XinChaoAdvertiser()
    
    init() {
        bonjourAdvertiser.stopAdvertising()
        bonjourAdvertiser.startAdvertising()
        
        bonjourAdvertiser.onReceiveMessage { message in
            
//            keypress.press("Control", "Command", "Q")
        }
    }
    
    var body: some View {
        VStack {
            header
            
            List(bonjourAdvertiser.messages, id: \.self) {
                Text($0)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    var header: some View {
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
        }
    }
}

#Preview {
    MacView()
}
