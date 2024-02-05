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
                    Label(String("0"), systemImage: "clock")
                        .padding()
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
                print ("error")
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