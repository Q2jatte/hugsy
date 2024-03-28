//
//  SuccessSigninView.swift
//  Hugsy
//
//  Created by Eric Terrisson on 27/03/2024.
//

import SwiftUI

struct SuccessSigninView: View {
    
    @State private var scaleFactor: CGFloat = 0.9
    
    var body: some View {
        VStack {
            
            Text("Bienvenue chez")
                .font(.title)
            
            Image("hugsy")
                .resizable()
                .scaledToFit()
            
            Image("smartphone-happy")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            Button {
                print("Go")
            } label: {
                HStack {
                    Text("Commencer")
                    Image(systemName: "chevron.right")
                }
                .padding()
                .foregroundColor(.white)
                .textCase(.uppercase)
                .font(.title)
                .background(Color("petrole"))
                .cornerRadius(20)
                .shadow(color: Color("lightblack").opacity(0.1), radius: 8, x: 0, y: 8)
                .shadow(color: Color("lightblack").opacity(0.2), radius: 4, x: 0, y: 8)
            }
            .scaleEffect(scaleFactor)
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: scaleFactor)
            .onAppear {
                withAnimation {
                    scaleFactor = 1.1
                }
            }
        }
        .padding()
    }
}

struct SuccessSigninView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessSigninView()
    }
}
