//
//  MenuView.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import SwiftUI
import ARKit
struct MenuView: View{
    @ObservedObject var arViewModel : ARViewModel
    @AppStorage(StorageKeys.endingHighestScore.rawValue) var endingHighestScore: Int?
    var body: some View {
        ZStack{
            VStack{
                Text("FaceMatch")
                    .foregroundColor(.black)
                    .font(.system(size: 50, design: .rounded).bold())
                Image("Beaming face with smiling eyes")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 150)
                Text("ベストスコア : \(String(endingHighestScore ?? 0))")
                    .foregroundColor(.black)
                    .font(.system(size: 20, design: .rounded).bold())
                ForEach(GameStage.allCases, id: \.self) { gameStage in
                    switch gameStage {
                    case .game: gameButton(gameStage: gameStage, text: gameStage.string, color: gameStage.color, icon: gameStage.icon)
                            .padding(5)
                    default: EmptyView()
                    }
                }
            }
            }
    }
    func gameButton(gameStage: GameStage, text: String, color: Color, icon: String) -> some View {
        Button {
            arViewModel.changeGameStage(newGameStage: gameStage)
        } label: {
            GameButtonView(text: text, color: color)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(arViewModel: ARViewModel.init())
    }
}

