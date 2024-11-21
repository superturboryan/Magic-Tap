//
//  SelectKeypressView.swift
//  Magic Tap
//
//  Created by Ryan on 2024-11-21.
//

import SwiftUI
import XinChao

struct SettingsView: View {
    
    @ObservedObject var xinchao: XinChaoAdvertiser
    
    @AppStorage("firstModifier")
    var firstModifier: String = ""
    
    @AppStorage("secondModifier")
    var secondModifier: String = ""
    
    @AppStorage("key")
    var key: String = ""
    
    var body: some View {
        VStack {
            selectKeysView
            closeButton
                .padding()
            Text("Messages:")
            List(xinchao.messages, id: \.self) {
                Text($0)
            }
        }
        .frame(width: 300, height: 400)
    }
    
    var closeButton: some View {
        Button("Close") {
            NSApp.keyWindow?.close()
        }
    }
    
    var selectKeysView: some View {
        VStack {
            TextField("First modifier", text: $firstModifier)
            TextField("Second modifier", text: $secondModifier)
            TextField("Key", text: $key)
        }
        .padding(.horizontal)
    }
}
