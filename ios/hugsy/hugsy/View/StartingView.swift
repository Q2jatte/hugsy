//
//  StartingView.swift
//  Hugsy
//
//  Created by Eric Terrisson on 26/03/2024.
//

import SwiftUI

struct StartingView: View {
    
    var body: some View {
        VStack {
            Logo()
            Illustration()
            SignInButton()
        }
    }
}

// MARK: - Logo
struct Logo: View {
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(["H", "U", "G", "S", "Y"], id: \.self) { letter in
                Image(letter)
                    .offset(y: self.animate ? 0 : -300)
                    .animation(.interpolatingSpring(stiffness: 100, damping: 10)
                                .delay(1 + Double(0.2 * Double(self.index(for: letter)))),
                               value: animate)
            }
        }
        .onAppear {
            self.animate.toggle()
        }
    }
    
    func index(for letter: String) -> Int {
        let letters = ["H", "U", "G", "S", "Y"]
        return letters.firstIndex(of: letter) ?? 0
    }
}

// MARK: - Illustration
struct Illustration: View {
    
    @State private var scaleFactor: CGFloat = 0
    
    var body: some View {
        Image("smartphone-together")
            .resizable()
            .scaledToFit()
            .scaleEffect(scaleFactor)
            .animation(.easeInOut(duration: 1.0), value: scaleFactor)
            .onAppear {
                withAnimation {
                    scaleFactor = 1.0 // Scale factor to animate to
                }
            }
    }
}

// MARK: - SignIn button
struct SignInButton: View {
    
    @State private var buttonOffsetY: CGFloat = 1000 // Initial offset (below the screen)
    @State private var animate = false
    
    var body: some View {
        Button {
            print("signin")
        } label: {
            NavigationLink(destination: SigninView()) {
                Text("S'inscrire")
                    .padding()
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .font(.title)
                    .background(Color("turquoise"))
                    .cornerRadius(20)
                    .shadow(color: Color("lightblack").opacity(0.1), radius: 8, x: 0, y: 8)
                    .shadow(color: Color("lightblack").opacity(0.2), radius: 4, x: 0, y: 8)
                    .offset(y: buttonOffsetY)
            }            
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    buttonOffsetY = 0 // Move button to final position
                    animate = true // Start animation
                }
            }
        }
        .animation(.easeInOut(duration: 1.0), value: animate)
        

    }
}

struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        StartingView()
    }
}
