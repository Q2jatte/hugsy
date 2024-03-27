//
//  SigninView.swift
//  Hugsy
//
//  Created by Eric Terrisson on 27/03/2024.
//

import SwiftUI

struct SigninView: View {
    
    @StateObject private var viewModel = UserViewModel()    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Choisis ton pseudo")
                    .font(.title)
                    .foregroundColor(Color("marine"))
                TextField("Albator84", text: $viewModel.userName)
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    
                Text(viewModel.userNameInfo)
                    .foregroundColor(.gray)
                
                Text("Ajoute un n° de téléphone")
                    .font(.title)
                    .foregroundColor(Color("marine"))
                TextField("0612345678", text: $viewModel.phoneNumber)
                    .keyboardType(.phonePad) // numeric keyboard
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    
                Text(viewModel.phoneNumberInfo)
                    .foregroundColor(.gray)
                
                Toggle(isOn: $viewModel.TcIsChecked) {
                            Text("J'accèpte les conditions générales d'utilisation")
                                .font(.title)
                                .foregroundColor(Color("marine"))
                        }
                        .padding()
                
                Image("smartphone-shield")
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                
                
                Button(action: {
                    // Submit form
                    submitForm()
                }) {
                    Text("Valider")
                        .padding()
                        .textCase(.uppercase)
                        .font(.title)
                        .foregroundColor(.white)
                        .background(Color("petrole"))
                        .cornerRadius(20)
                }
            }
            .padding()
            .background(Color("anis"))
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
    func submitForm() {
        // Traitement du formulaire dans le viewmodel
        viewModel.registerNewUser()        
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
