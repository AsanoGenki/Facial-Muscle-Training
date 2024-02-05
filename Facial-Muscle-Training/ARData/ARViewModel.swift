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
    var isSmiling: Bool {
        var temp = false
        if model.smileLeft > 0.8 || model.smileRight > 0.8 {
            temp = true
        }
        return temp
    }
    func shuffle() {
        model.facesArray.shuffle()
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
    
}
