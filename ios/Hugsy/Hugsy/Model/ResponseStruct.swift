//
//  ResponseStruct.swift
//  Hugsy
//
//  Created by Eric Terrisson on 27/03/2024.
//

import Foundation

struct UserNameAvailabilityResponse: Codable {
    let isUserNameAvailable: Bool
}

struct PhoneNumberAvailabilityResponse: Codable {
    let isPhoneNumberAvailable: Bool
}

struct UserCreatedResponse: Codable {
    let isUserCreated: Bool
}
