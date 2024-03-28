//
//  ProfileViewModel.swift
//  Hugsy
//
//  Created by Eric Terrisson on 28/03/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var isProfileLoaded: Bool = false
    @Published var profile: Profile = Profile(userId: nil, imageUrl: nil, shortDescription: nil)
    
    /// Instance du service API.
    private var api = Api()
    
    func loadingProfile(){
        
        if let retrievedToken = getTokenFromKeychain(forKey: "AccessToken") {
            api.getProfileRequest(token: retrievedToken) { result in
                switch result {
                    
                case .success(let profile):
                    // Utilisation de DispatchQueue pour garantir que les modifications sont effectuées sur le thread principal
                    DispatchQueue.main.async {
                        self.profile = profile
                    }
                    
                case .failure(let error):
                    print("Erreur de récupération du profil : \(error)")
                }
            }
        } else {
            print("Aucun token trouvé dans le Keychain.")
        }
    }
}
