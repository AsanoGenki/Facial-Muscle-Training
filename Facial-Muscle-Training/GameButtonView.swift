//
//  GameButtonView.swift
//  Facial-Muscle-Training
//
//  Created by Genki on 2/5/24.
//

import SwiftUI

struct GameButtonView: View{
    var text: String
    var color: Color
    var body: some View {
        Text(text)
            .frame(minWidth: 150)
            .foregroundColor(.white)
            .font(.system(.title2, design: .rounded).bold())
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).fill(color.opacity(0.8)))
        
    }
}

struct GameButtonView_Previews: PreviewProvider {
    static var previews: some View {
        GameButtonView(text: "text", color: .red)
    }
    
}

