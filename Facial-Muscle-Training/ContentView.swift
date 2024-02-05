//
//  ContentView.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @ObservedObject var arViewModel : ARViewModel = ARViewModel()
    var body: some View {
        VStack {
            switch arViewModel.gameStage {
            case .menu: MenuView(arViewModel: arViewModel)
            case .game:
                GameView(arViewModel: arViewModel)
            case .ending:
                EndingView(arViewModel: arViewModel)
            }
        }
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

