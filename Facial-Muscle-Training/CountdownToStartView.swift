//
//  CountdownToStartView.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import SwiftUI
import ARKit
struct CountdownToStartView : View {
    @ObservedObject var arViewModel : ARViewModel
    var body: some View {
        ZStack{
                ARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)
                Rectangle().fill(.thinMaterial).edgesIgnoringSafeArea(.all)
            Text(String(arViewModel.countdownTime))
                .font(.system(size: 100))
        }
        .task {
            while arViewModel.countdownTime > 0  && arViewModel.gameStage == .game{
                do {
                    try await Task.sleep(nanoseconds: UInt64(1_000_000_000))
                    if arViewModel.countdownTime > 0  && arViewModel.gameStage == .game{
                        arViewModel.countdownTimeUpdate()
                    }
                } catch {
                }
            }
        }
    }
}

struct CountdownToStartView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownToStartView(arViewModel: ARViewModel.init())
    }
}
