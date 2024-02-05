//
//  ManualView.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import SwiftUI
import ARKit

struct ManualView : View {
    @ObservedObject var arViewModel : ARViewModel
    @State var frameSize: CGFloat = 60
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 30){
                Text("遊び方")
                    .font(.title)
                HStack{
                    Image("Grinning squinting face")
                        .resizable()
                        .frame(width: frameSize, height: frameSize)
                        .padding(7)
                        .background(RoundedRectangle(cornerRadius: 25).fill(.regularMaterial))
                    Text(": 上に表示される絵文字を制限時間内になるべく多く真似する単純なゲームです")
                    
                }
                HStack{
                    Label(String("5"), systemImage: "gamecontroller")
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(.regularMaterial))
                    Text(": スコア")
                }
                HStack{
                    Label(String("13"), systemImage: "trophy")
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(.regularMaterial))
                        .foregroundColor(.yellow)
                    Text(": ベストスコア")
                }
                HStack{
                    Label(String("15"), systemImage: "clock")
                        .padding()
                        .foregroundColor(arViewModel.gameTime > 5 ? Color(uiColor: .label) : .red)
                        .background(RoundedRectangle(cornerRadius: 15).fill(.regularMaterial))
                    Text(": 残り時間")
                }
                Spacer()
            }.padding(.horizontal)
                .padding(.top, 50)
            VStack{
                Spacer()
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
    }
}

struct ManualView_Previews: PreviewProvider {
    static var previews: some View {
        ManualView(arViewModel: ARViewModel.init())
    }
}

