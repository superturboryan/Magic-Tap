//
//  KeepAwakeTip.swift
//  Magic Tap
//
//  Created by Ryan on 2024-11-30.
//

import TipKit

struct KeepAwakeTip: Tip {
    
    var title: Text {
        Text(String(localized: "Prevent your phone screen from turning off", comment: "Tip title"))
            .font(.footnote)
            .fontWeight(.medium)
    }
    
    var message: Text? {
        Text(String(
            localized: "The app needs to remain open with the phone screen on for some features to work",
            comment: "Tip message"
        ))
    }
    
    var actions: [Action] {[
        .init(title: "Keep screen on")
    ]}
    
    var rules: [Rule] {[
        // Show for all users
    ]}
}
