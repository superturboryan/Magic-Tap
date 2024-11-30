//
//  OpenAboutViewTip.swift
//  Magic Tap
//
//  Created by Ryan on 2024-11-30.
//

import TipKit

struct OpenAboutViewTip: Tip {
    
    var title: Text {
        Text(String(localized: "Need help?", comment: "Tip title"))
            .font(.footnote)
            .fontWeight(.medium)
    }
    
    var message: Text? {
        Text(String(
            localized: "Check out the About page to learn more about how this app works",
            comment: "Tip message"
        ))
    }
    
    var actions: [Action] {[
        .init(title: "Go to About page")
    ]}
    
    var rules: [Rule] {[
        // Show for all users
    ]}
}
