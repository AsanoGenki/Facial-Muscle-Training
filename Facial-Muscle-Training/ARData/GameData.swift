//
//  GameData.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import Foundation

enum mouthScale: CaseIterable {
    case neutral, smile, frown, openMouthSmile, openMouthNeutral, tongueOut, kissFace
    
    var string: String {
        switch self {
        case .neutral: return "Neutral"
        case .smile:
            return "Smile"
        case .frown:
            return "Frown"
        case .openMouthSmile:
            return "Open Mouth Smile"
        case .openMouthNeutral:
            return "Open Mouth Neutral"
        case .tongueOut:
            return "Tongue Out"
        case .kissFace:
            return "Kiss Face"
        }
    }
}
enum eyeScale: CaseIterable {
    case neutral, closed, wideOpen, rollingEyesUp, squinting, wink
    
    var string: String {
        switch self {
        case .neutral:
            return "Neutral"
        case .closed:
            return "Closed"
        case .wideOpen:
            return "Wide Open"
        case .rollingEyesUp:
            return "Rolling Eyes Up"
        case .squinting:
            return "Squinting"
        case .wink:
            return "Winking"
        }
    }
}
