//
//  GameView.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import SwiftUI
import RealityKit

struct GameView : View {
    @ObservedObject var arViewModel : ARViewModel = ARViewModel()
    @State var frameSize: CGFloat = 100
    var body: some View {
        if arViewModel.countdownTime > 0 {
            CountdownToStartView(arViewModel: arViewModel)
        } else {
            ZStack {
                ARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack{
                        VStack{
                            Label(String(arViewModel.score), systemImage: "gamecontroller")
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).fill(.regularMaterial))
                            Label(String("0"), systemImage: "trophy")
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 15).fill(.regularMaterial))
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                        Label(String(arViewModel.gameTime), systemImage: "clock")
                            .padding()
                            .foregroundColor(arViewModel.gameTime > 5 ? Color(uiColor: .label) : .red)
                            .background(RoundedRectangle(cornerRadius: 15).fill(.regularMaterial))
                    }
                    Spacer()
                }.padding(.horizontal)
                VStack{
                    currentEmoji
                    Spacer()
                    HStack{
                        Spacer()
                        
                        Button {
                            arViewModel.changeGameStage(newGameStage: .menu)
                        }
                    label:{
                        Label(String("メニュー"), systemImage: "arrowshape.turn.up.backward")
                            .padding()
                            .foregroundColor(.primary)
                            .background(RoundedRectangle(cornerRadius: 15).fill(.regularMaterial))
                    }.padding(20)
                    }
                }
            }
            .task {
                while arViewModel.gameTime > 0 {
                    do {
                        try await Task.sleep(nanoseconds: UInt64(1_000_000_000))
                        arViewModel.updateGameTime()
                        
                        if arViewModel.gameTime == 0 {
                            arViewModel.changeGameStage(newGameStage: .ending)
                        }
                    } catch {
                    }
                }
            }
        }
    }
    var currentEmoji: some View {
        VStack {
            if arViewModel.model.facesArray.count > 0 {
                arViewModel.model.facesArray.first?.image
                    .resizable()
                    .frame(width: frameSize, height: frameSize)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 25).fill(.regularMaterial))
                    .onTapGesture {
                        changeEmoji()
                    }
            }
        }
    }
    func changeEmoji() {
        arViewModel.shuffle()
        arViewModel.simpleSuccess()
        withAnimation(.spring(dampingFraction: 0.5)) {
            frameSize = 130
        }
        Task {
            do {
                try await Task.sleep(nanoseconds: UInt64(0_200_000_000))
                withAnimation(.spring(dampingFraction: 0.5)) {
                    frameSize = 100
                }
            } catch {
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        arViewModel.startSessionDelegate()
        return arViewModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    GameView()
}
