//
//  EndingView.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import SwiftUI
struct EndingView: View {
    @ObservedObject var arViewModel : ARViewModel
    @AppStorage(StorageKeys.endingHighestScore.rawValue) var endingHighestScore: Int?
    @State var previousHighScore = 0
    var body: some View {
        ZStack{
            ARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)
            Rectangle().fill(.thinMaterial).edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 5, alignment: .center)]) {
                    ForEach(arViewModel.model.collectedFaces, id: \.self) { face in
                        face.image
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                }
            }
            .padding()
            VStack{
                Spacer()
                if arViewModel.gameStage == .ending {
                    Label("スコア: \(arViewModel.score)", systemImage: "gamecontroller")
                        .font(.system(.largeTitle, design: .rounded).bold())
                    if arViewModel.score <= previousHighScore {
                        Label("ベストスコア: \(endingHighestScore ?? 0)", systemImage: "trophy")
                            .font(.system(.title3, design: .rounded).bold())
                    }
                    
                    if arViewModel.score > previousHighScore {
                        Label("ベストスコア更新!", systemImage: "trophy")
                            .font(.system(.title2, design: .rounded).bold())
                            .foregroundColor(.yellow)
                        Text("前回のベストスコア: \(previousHighScore)")
                            .font(.system(.title2, design: .rounded).bold())
                    }
                }
                Button {
                    arViewModel.changeGameStage(newGameStage: .menu)
                }
            label:{
                Label(String("メニューに戻る"), systemImage: "arrowshape.turn.up.backward")
                    .padding()
                    .foregroundColor(.primary)
                    .background(RoundedRectangle(cornerRadius: 15).fill(.regularMaterial))
            }.padding(20)
            }
        }
        .onAppear{
            if arViewModel.gameStage == .ending {
                previousHighScore = endingHighestScore ?? 0
                if arViewModel.score > previousHighScore {
                    endingHighestScore = arViewModel.score
                }
            }
        }
    }
}

struct EndingView_Previews: PreviewProvider {
    static var previews: some View {
        EndingView(arViewModel: ARViewModel.init())
    }
}
