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
    var gameStageVar: GameStage = .menu
    var mouthStatus: mouthScale = .neutral
    var eyeStatus: eyeScale = .neutral
    var eyebrowStatus: eyebrowScale = .neutral
    var facesArray: Array<faces> = []
    var collectedFaces: Array<faces> = []
    var currentScore: Int = 0
    var gametime: Int = 0
    var countdownTime: Int = 3
    
    init() {
        arView = ARView(frame: .zero)
        arView.session.run(ARFaceTrackingConfiguration())
        gametime = 15
        facesArray = []
        collectedFaces = []
        for face in faces.allCases {
            facesArray.append(face)
        }
        facesArray.shuffle()
    }
    mutating func updateGameStage(gameStage: GameStage) {
        gameStageVar = gameStage
    }
    mutating func updateGameTime() {
        switch gameStageVar {
        case .game: gametime -= 1
        default: break
        }
    }
    mutating func countdownTimeUpdate() {
        countdownTime -= 1
    }
    mutating func update(faceAnchor: ARFaceAnchor){
        // LIPS
        let smileRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthSmileRight})?.value ?? 0)
        let smileLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthSmileLeft})?.value ?? 0)
        let frownRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthFrownRight})?.value ?? 0)
        let frownLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthFrownLeft})?.value ?? 0)
        let mouthFunnel = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthFunnel})?.value ?? 0)
        let mouthPucker = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .mouthPucker})?.value ?? 0)
        let tongueOut = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .tongueOut})?.value ?? 0)
        mouthStatus = mouthCheck(tongueOut: tongueOut, frownLeft: frownLeft, frownRight: frownRight, smileLeft: smileLeft, smileRight: smileRight, mouthPucker: mouthPucker, mouthFunnel: mouthFunnel)
        
        // EYES
        let eyeWideLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeWideLeft})?.value ?? 0)
        let eyeWideRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeWideRight})?.value ?? 0)
        let eyeSquintLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeSquintLeft})?.value ?? 0)
        let eyeSquintRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeSquintRight})?.value ?? 0)
        let eyeBlinkLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeBlinkLeft})?.value ?? 0)
        let eyeBlinkRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeBlinkRight})?.value ?? 0)
        let eyeLookUpLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeLookUpLeft})?.value ?? 0)
        let eyeLookUpRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .eyeLookUpRight})?.value ?? 0)
        eyeStatus = eyeCheck(eyeBlinkLeft: eyeBlinkLeft, eyeBlinkRight: eyeBlinkRight, eyeWideLeft: eyeWideLeft, eyeWideRight: eyeWideRight, eyeLookUpLeft: eyeLookUpLeft, eyeLookUpRight: eyeLookUpRight, eyeSquintLeft: eyeSquintLeft, eyeSquintRight: eyeSquintRight)
        
        // EYEBROWS
        let eyebrowInnerUp = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .browInnerUp})?.value ?? 0)
        let eyebrowDownLeft = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .browDownLeft})?.value ?? 0)
        let eyebrowDownRight = Float(truncating: faceAnchor.blendShapes.first(where: {$0.key == .browDownRight})?.value ?? 0)
        eyebrowStatus = eyebrowCheck(eyebrowInnerUp: eyebrowInnerUp, eyebrowDownLeft: eyebrowDownLeft, eyebrowDownRight: eyebrowDownRight)
        
        if facesArray.count > 0 {
            faceCheck(face: facesArray.first!, eyes: eyeStatus, eyebrows: eyebrowStatus, mouth: mouthStatus)
        }
    }
    mutating func faceCheck(face: faces, eyes: eyeScale, eyebrows: eyebrowScale, mouth: mouthScale ) {
        if (face.eyeScale.contains(where: {$0 == eyes})) && (face.eyebrowScale.contains(where: {$0 == eyebrows})) && (face.mouthScale.contains(where: {$0 == mouth})) {
            currentScore += 1
            if currentScore < 10 {
                gametime += 2
            } else {
                gametime += 1
            }
            simpleSuccess()
            collectedFaces.append(facesArray[0])
            facesArray.remove(at: 0)

        }
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
    mutating func eyeCheck(eyeBlinkLeft: Float, eyeBlinkRight: Float, eyeWideLeft: Float, eyeWideRight: Float, eyeLookUpLeft: Float, eyeLookUpRight: Float, eyeSquintLeft: Float, eyeSquintRight: Float) -> eyeScale {
        
        var result = eyeScale.neutral
        
        if eyeLookUpLeft > 0.7 && eyeLookUpRight > 0.7 {
            result = .rollingEyesUp
        } else if eyeBlinkLeft > 0.8 && eyeBlinkRight > 0.8 {
            result = .closed
        } else if eyeWideLeft > 0.5 && eyeWideRight > 0.5 {
            result = .wideOpen
        }  else if (eyeBlinkLeft > 0.8 && eyeBlinkRight < 0.2) || (eyeBlinkRight > 0.8 && eyeBlinkLeft < 0.2) {
            result = .wink
        } else if eyeSquintLeft > 0.3 && eyeSquintRight > 0.3 {
            result = .squinting
        }
        
        return result
    }
    mutating func eyebrowCheck(eyebrowInnerUp: Float, eyebrowDownLeft: Float, eyebrowDownRight: Float) -> eyebrowScale {
        
        var result = eyebrowScale.neutral
        
        if eyebrowInnerUp > 0.6 && eyebrowDownLeft == 0 && eyebrowDownRight == 0 {
            result = .surprised
        } else if eyebrowInnerUp > 0.1 && ( (eyebrowDownLeft < 0.3 && eyebrowDownLeft > 0 ) || ( eyebrowDownRight < 0.3 && eyebrowDownRight > 0 )) {
            result = .splitSkeptical
        } else if eyebrowDownRight > 0.7 && eyebrowDownLeft > 0.7 {
            result = .furrowed
        }
        
        return result
    }
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
