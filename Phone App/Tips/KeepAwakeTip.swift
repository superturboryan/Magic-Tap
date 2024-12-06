//
//  KeepAwakeTip.swift
//  Magic Tap
//
//  Created by Ryan on 2024-11-30.
//

import TipKit

struct KeepAwakeTip: Tip {
    
    @Parameter static var isDisplayed: Bool = false
    
    var title: Text {
        Text(String(localized: "This prevents your phone from going to sleep", comment: "Tip title"))
            .font(.footnote)
            .fontWeight(.medium)
    }
    
    var message: Text? {
        Text(String(
            localized: "The phone needs to remain open for some features to work. \n\nDecrease the screen brightness to save battery ⚡️",
            comment: "Tip message"
        ))
    }
    
    var actions: [Action] {[
        .init(title: "Decrease Brightness")
    ]}
    
    var rules: [Rule] {[
        #Rule(Self.$isDisplayed) { $0 == true }
    ]}
}
