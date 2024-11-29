//
//  Action.swift
//  Common
//
//  Created by Ryan on 2024-11-17.
//

import Foundation

public enum Action: String, CaseIterable, Codable, Sendable {
    
    case incrementVolume
    case decrementVolume
    case toggleMute
    
    case togglePlayPause
    case nextTrack
    case previousTrack
    
    case vibrate
    
    case toggleFlashlight
    
    case `none`
}

extension Action: Identifiable {
    
    public var id: String { "\(self)" }
    public static let key = "\(Self.self)"
    
    public var display: String {
        switch self {
        case .incrementVolume: "🔊👍"
        case .decrementVolume: "🔊👎"
        case .toggleMute: "🔊🚫"
        case .togglePlayPause: "⏯️"
        case .nextTrack: "⏭️"
        case .previousTrack: "⏮️"
        case .toggleFlashlight: "🔦"
        case .vibrate: "🫨"
        case .none: "None"
        }
    }
}
