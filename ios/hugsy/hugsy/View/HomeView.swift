//
//  HomeView.swift
//  Hugsy
//
//  Created by Eric Terrisson on 27/03/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            TopNavBar()
            Spacer()
            Text("Content")
            Spacer()
            BottomNavBar()
        }
    }
}

struct TopNavBar: View {
    var body: some View {
        HStack { 
            Spacer()
            Text("HUGSY")
                .foregroundColor(Color("petrole"))
                .font(.custom("LilitaOne-Regular", size: 28))
        }
        .padding()
        .background(Color("turquoise"))
        .shadow(color: Color("lightblack").opacity(0.2), radius: 4, x: 0, y: 8)
    }
}

struct BottomNavBar: View {
    var body: some View {
        HStack {
            VStack(spacing: 10) {
                Image(systemName: "message.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text("Chat")
                    .foregroundColor(Color("petrole"))
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                Image(systemName: "person.fill.badge.plus")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text("New friend")
                    .foregroundColor(Color("petrole"))
            }
            
            Spacer()
            
            VStack(spacing: 10) {
                Image(systemName: "person.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                Text("Profile")
                    .foregroundColor(Color("petrole"))
            }
        }
        .padding()
        .background(Color("turquoise"))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
