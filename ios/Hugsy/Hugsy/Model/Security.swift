//
//  Security.swift
//  Hugsy
//
//  Created by Eric Terrisson on 28/03/2024.
//

import Foundation
import Security

func saveTokenToKeychain(token: String, forKey key: String) -> Bool {
    // Convertir la chaîne en un objet de données
    guard let tokenData = token.data(using: .utf8) else {
        return false
    }
    
    // Créer une recherche pour trouver le Keychain item à mettre à jour ou ajouter
    var query = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecValueData as String: tokenData
    ] as [String: Any]
    
    // Supprimer l'ancien item s'il existe
    SecItemDelete(query as CFDictionary)
    
    // Ajouter le nouvel item au Keychain
    let status = SecItemAdd(query as CFDictionary, nil)
    return status == errSecSuccess
}

func getTokenFromKeychain(forKey key: String) -> String? {
    // Créer une recherche pour récupérer l'item du Keychain
    let query = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: kCFBooleanTrue!,
        kSecMatchLimit as String: kSecMatchLimitOne
    ] as [String: Any]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    
    guard status == errSecSuccess, let tokenData = item as? Data else {
        return nil
    }
    
    // Convertir les données en chaîne
    return String(data: tokenData, encoding: .utf8)
}
