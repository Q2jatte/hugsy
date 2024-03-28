//
//  ContentView.swift
//  studi
//
//  Created by Eric Terrisson on 27/03/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State var status: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .foregroundColor(status ? .red : .blue)
            
            Spacer()
            
            Button {
                status.toggle()
            } label: {
                Text("Change color")
            }

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
