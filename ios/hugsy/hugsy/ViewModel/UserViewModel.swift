//
//  UserViewModel.swift
//  Hugsy
//
//  Created by Eric Terrisson on 27/03/2024.
//

import Foundation

class UserViewModel: ObservableObject {
    
    @Published var userName: String = "" {
        didSet {
            // Appeler checkUserName lorsque la propriété userName change et a 6 caractères ou +
            if userName.count >= 6 {
                userNameIsValid = false
                checkUserName()
            } else {
                userNameInfo = "6 caractères minimum"
            }
        }
    }
    @Published var userNameInfo: String = "6 caractères minimum"
    var userNameIsValid: Bool = false
    
    @Published var phoneNumber: String = "" {
        didSet {
            // Appeler checkPhoneNumber lorsque la propriété phoneNumber change et a 10 caractères
            if phoneNumber.count == 10 {
                phoneNumberIsValid = false
                checkPhoneNumber()
            } else {
            phoneNumberInfo = "C'est pour sécuriser ton compte"
            }
        }
    }
    @Published var phoneNumberInfo: String = "C'est pour sécuriser ton compte"
    var phoneNumberIsValid: Bool = false
    
    @Published var TcIsChecked: Bool = false
    
    @Published var successSignin: Bool = false
    
    /// Instance du service API.
    private var api = Api()
    
    private func checkUserName(){
        print("username : \(self.userName)")
        api.checkUserNameRequest(userName: self.userName) { result in
            switch result {
                
            case .success(let isUserNameAvailable):
                // Utilisation de DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    // Met à jour le jeton dans l'instance utilisateur
                    if isUserNameAvailable {
                        self.userNameInfo = "Pseudo disponible"
                        self.userNameIsValid = true
                    } else {
                        self.userNameInfo = "Pseudo déjà utilisé"
                    }
                }
                
            case .failure(let error):
                print("La vérification du pseudo a échoué avec l'erreur : \(error)")
                DispatchQueue.main.async {
                    self.userNameInfo = "Erreur de vérification"
                }
            }
        }
    }
    
    private func checkPhoneNumber(){
        api.checkPhoneNumberRequest(phoneNumber: phoneNumber) { result in
            switch result {
                
            case .success(let isPhoneNumberAvailable):
                // Utilisation de DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                DispatchQueue.main.async {
                    // Met à jour le jeton dans l'instance utilisateur
                    if isPhoneNumberAvailable {
                        self.phoneNumberInfo = "Numéro disponible"
                        self.phoneNumberIsValid = true
                    } else {
                        self.phoneNumberInfo = "Numéro déjà utilisé"
                    }
                }
                
            case .failure(let error):
                print("La vérification du numéro de téléphone a échoué avec l'erreur : \(error)")
                DispatchQueue.main.async {
                    self.phoneNumberInfo = "Erreur de vérification"
                }
            }
        }
    }
    
    func registerNewUser(){
        if (userNameIsValid && phoneNumberIsValid && TcIsChecked) {
            
            let randomPassword = randomPassword(length: 16)
            let newUser = UserData(userName: userName, phoneNumber: phoneNumber, password: randomPassword)
            
            api.createNewUserRequest(user: newUser) { result in
                switch result {
                    
                case .success(let isUserCreated):
                    // Utilisation de DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                    DispatchQueue.main.async {
                        // Met à jour le jeton dans l'instance utilisateur
                        if isUserCreated {
                            print("Utilisateur créé avec succès")
                            self.successSignin = true
                        } else {
                            print("Utilisateur non créé")
                        }
                    }
                    
                case .failure(let error):
                    print("La création de l'utilisateur a échoué avec l'erreur : \(error)")
                }
            }
            
        } else {
            print("Données non valide")
        }
    }
    
    private func randomPassword(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789*!?"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
