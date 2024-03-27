//
//  API.swift
//  Hugsy
//
//  Created by Eric Terrisson on 27/03/2024.
//

import Foundation

enum ApiError: Error {
    case invalidURL
    case serializationError
    case missingToken
    case authenticationFailure
    case serverConnectionError
    case cannotConnectToHost
    case invalidData
    case domain
    case unhandledResponse(Int)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "URL invalide"
        case .serializationError:
            return "Erreur de sérialisation"
        case .missingToken:
            return "Token manquant"
        case .authenticationFailure:
            return "Échec de l'authentification."
        case .serverConnectionError:
            return "Impossible de se connecter au serveur."
        case .cannotConnectToHost:
            return "Impossible de se connecter au serveur."
        case .invalidData:
            return "Données invalides."
        case .domain:
            return "Impossible de joindre le serveur."
        case .unhandledResponse(let statusCode):
            return "Réponse non gérée. Code de réponse : \(statusCode)"
        }
    }
    
    // Additional initializer to map from generic Error
    init(_ error: Error) {
        if let apiError = error as? ApiError {
            self = apiError
        } else {
            self = .unhandledResponse((error as NSError).code)
        }
    }
}

class Api {
    
    static let baseURL = URL(string: Bundle.main.object(forInfoDictionaryKey: "API_ROOT_URL") as! String)!
    static let checkUserNameURL = baseURL.appendingPathComponent("/api/check-username")
    static let checkPhoneNumberURL = baseURL.appendingPathComponent("/api/check-phonenumber")
    static let createUserURL = baseURL.appendingPathComponent("/api/users/create")
    
    // Session will used for Mocker tests
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - POST
    /**
     USERNAME CHECK -Vérifie la disponibilité d'un username.
     
     - Parameters:
        - userName: Les caractères du pseudo à vérifierutilisés
        - completion: Une closure appelée une fois que la requête est terminée.
     - Returns: Bool
     - Throws: Lève les erreurs suivantes :
        - déserialisation
        - authentification
        - erreur serveur
    */
    func checkUserNameRequest(userName: String, completion: @escaping (Result<Bool, Error>) -> Void) {        
        
        let url = Api.checkUserNameURL
        
        // Création de la requête
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Encodage du nom d'utilisateur en JSON et l'ajouter dans le corps de la requête
        do {
            let jsonData = try JSONEncoder().encode(["userName": userName])
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de l'encodage JSON : \(error)")
            completion(.failure(error))
            return
        }
        
        // Création de la tâche URLSession pour envoyer la requête
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Code http de réponse : \(httpResponse.statusCode)")
                
                // Gérer les différentes réponses HTTP
                switch httpResponse.statusCode {
                case 200:
                    if let responseData = data {
                        do {
                            // Désérialisation du JSONen [Patient]
                            let jsonDecoder = JSONDecoder()
                            let isUserNameAvailable = try jsonDecoder.decode(Bool.self, from: responseData)
                            completion(.success(isUserNameAvailable))
                            
                        } catch {
                            print("Erreur lors de la désérialisation JSON : \(error)")
                            completion(.failure(error))
                        }
                    }
                    
                case 401:
                    completion(.failure(ApiError.authenticationFailure))
                    
                default:
                    completion(.failure(ApiError.unhandledResponse(httpResponse.statusCode)))
                }
            }
        }
        task.resume()
    }
    
    /**
     PHONENUMBER CHECK -Vérifie que le numéro de téléphone n'est pas déjà enregistré..
     
     - Parameters:
        - phoneNumber: Le numéro à vérifier
        - completion: Une closure appelée une fois que la requête est terminée.
     - Returns: Bool
     - Throws: Lève les erreurs suivantes :
        - déserialisation
        - authentification
        - erreur serveur
    */
    func checkPhoneNumberRequest(phoneNumber: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let url = Api.checkPhoneNumberURL
        
        // Création de la requête
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Encodage du numéro de téléphone en JSON et l'ajouter dans le corps de la requête
        do {
            let jsonData = try JSONEncoder().encode(["phoneNumber": phoneNumber])
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de l'encodage JSON : \(error)")
            completion(.failure(error))
            return
        }
        
        // Création de la tâche URLSession pour envoyer la requête
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Code http de réponse : \(httpResponse.statusCode)")
                
                // Gérer les différentes réponses HTTP
                switch httpResponse.statusCode {
                case 200:
                    if let responseData = data {
                        do {
                            // Désérialisation du JSONen [Patient]
                            let jsonDecoder = JSONDecoder()
                            let isPhoneNumberAvailable = try jsonDecoder.decode(Bool.self, from: responseData)
                            completion(.success(isPhoneNumberAvailable))
                            
                        } catch {
                            print("Erreur lors de la désérialisation JSON : \(error)")
                            completion(.failure(error))
                        }
                    }
                    
                case 401:
                    completion(.failure(ApiError.authenticationFailure))
                    
                default:
                    completion(.failure(ApiError.unhandledResponse(httpResponse.statusCode)))
                }
            }
        }
        task.resume()
    }
    
    /**
     CREATE NEW USER -Création d'un nouvel utilisateur.
     
     - Parameters:
        - phoneNumber: Le numéro à vérifier
        - completion: Une closure appelée une fois que la requête est terminée.
     - Returns: Bool
     - Throws: Lève les erreurs suivantes :
        - déserialisation
        - authentification
        - erreur serveur
    */
    func createNewUserRequest(user: UserData, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let url = Api.createUserURL
        
        // Création de la requête
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Encodage du user en JSON et l'ajouter dans le corps de la requête
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            print("Erreur lors de l'encodage JSON : \(error)")
            completion(.failure(error))
            return
        }
        
        // Création de la tâche URLSession pour envoyer la requête
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Code http de réponse : \(httpResponse.statusCode)")
                
                // Gérer les différentes réponses HTTP
                switch httpResponse.statusCode {
                case 200:
                    if let responseData = data {
                        do {
                            // Désérialisation du JSONen [Patient]
                            let jsonDecoder = JSONDecoder()
                            let isUserCreated = try jsonDecoder.decode(Bool.self, from: responseData)
                            completion(.success(isUserCreated))
                            
                        } catch {
                            print("Erreur lors de la désérialisation JSON : \(error)")
                            completion(.failure(error))
                        }
                    }
                    
                case 401:
                    completion(.failure(ApiError.authenticationFailure))
                    
                default:
                    completion(.failure(ApiError.unhandledResponse(httpResponse.statusCode)))
                }
            }
        }
        task.resume()
    }
    
}
