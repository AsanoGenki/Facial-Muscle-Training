//
//  ARModel.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import Foundation
import RealityKit
import ARKit

struct ARModel {
    private(set) var arView : ARView
    var smileRight: Float = 0
    var smileLeft: Float = 0
    var mouthStatus: mouthScale = .neutral
    
    init() {
        arView = ARView(frame: .zero)
        arView.session.run(ARFaceTrackingConfiguration())
    }
    
    mutating func update(faceAnchor: ARFaceAnchor){
        smileRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthSmileRight})?.value ?? 0)
        smileLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthSmileLeft})?.value ?? 0)
        // LIPS
        let smileRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthSmileRight})?.value ?? 0)
        let smileLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthSmileLeft})?.value ?? 0)
        let frownRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthFrownRight})?.value ?? 0)
        let frownLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthFrownLeft})?.value ?? 0)
        let mouthFunnel = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthFunnel})?.value ?? 0)
        let mouthPucker = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthPucker})?.value ?? 0)
        let tongueOut = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .tongueOut})?.value ?? 0)
        mouthStatus = mouthCheck(tongueOut: tongueOut, frownLeft: frownLeft, frownRight: frownRight, smileLeft: smileLeft, smileRight: smileRight, mouthPucker: mouthPucker, mouthFunnel: mouthFunnel)
    }
    mutating func mouthCheck(tongueOut: Float, frownLeft: Float, frownRight: Float, smileLeft: Float, smileRight: Float, mouthPucker: Float, mouthFunnel: Float) -> mouthScale {
        
        var result = mouthScale.neutral
        
        if tongueOut > 0.2 {
            result = .tongueOut
        } else if mouthPucker > 0.7 {
            result = .kissFace
        } else if frownLeft > 0.35 && frownRight > 0.35 {
            result = .frown
        } else if smileLeft > 0.4 && smileRight > 0.4 {
            if mouthFunnel > 0.04 {
                result = .openMouthSmile
            } else {
                result = .smile
            }
        } else if mouthFunnel > 0.1 {
            result = .openMouthNeutral
        }
        return result
    }
}
