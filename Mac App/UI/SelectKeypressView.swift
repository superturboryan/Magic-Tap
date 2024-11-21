//
//  SelectKeypressView.swift
//  Magic Tap
//
//  Created by Ryan on 2024-11-21.
//

import SwiftUI

struct SelectKeypressView: View {
    var body: some View {
        VStack {
            Text("Hello from the new window!")
                .font(.title)
                .padding()
            Button("Close") {
                NSApp.keyWindow?.close()
            }
            .padding()
        }
        .frame(width: 300, height: 200)
    }
}
