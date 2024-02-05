//
//  ARViewModel.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import Foundation
import RealityKit
import ARKit

class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
    @Published var model : ARModel = ARModel()
    
    var arView : ARView {
        model.arView
    }
    var gameStage: GameStage {
        model.gameStageVar
    }
    var score: Int {
        model.currentScore
    }
    var gameTime: Int {
        model.gametime
    }
    var countdownTime: Int {
        model.countdownTime
    }
    func countdownTimeUpdate() {
        model.countdownTimeUpdate()
    }
    func updateGameTime() {
        model.updateGameTime()
    }
    func shuffle() {
        model.facesArray.shuffle()
    }
    func simpleSuccess() {
        model.simpleSuccess()
    }
    func startSessionDelegate() {
        model.arView.session.delegate = self
    }
    //顔を識別し、update関数を実行する
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        if let faceAnchor = anchors.first  as? ARFaceAnchor {
            model.update(faceAnchor: faceAnchor)
        }
    }
    func changeGameStage(newGameStage: GameStage) {
        model.updateGameStage(gameStage: newGameStage)
    }
}
