//
//  UserData.swift
//  Hugsy
//
//  Created by Eric Terrisson on 27/03/2024.
//

import Foundation

struct UserData: Identifiable, Codable {
    let id = UUID()
    let userName: String?
    let phoneNumber: String?    
}
