// Abstract: simple model to manage user login and registration.

import Foundation

class AuthManager {
    
    static var isLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        }
    }
    
    // MARK: - Methods
    
    func login(userName: String, password: String) throws {
        guard let storedUserName = UserDefaults.standard.string(forKey: UserDefaultsKeys.userName.rawValue) else {
            throw AuthError.userNotFound
        }
        
        guard userName == storedUserName else {
            throw AuthError.invalidUserName
        }
        
        guard let storedPassword = UserDefaults.standard.string(forKey: UserDefaultsKeys.password.rawValue), password == storedPassword else {
            throw AuthError.invalidPassword
        }
        
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    func register(userName: String, password: String) throws {
        guard userName.count > 0 else {
            throw AuthError.userNameTooShort
        }
        
        guard password.count > 0 else {
            throw AuthError.passwordTooShort
        }
        
        if let existingUserName = UserDefaults.standard.string(forKey: UserDefaultsKeys.userName.rawValue) {
            guard userName != existingUserName else {
                throw AuthError.userNameAlreadyTaken
            }
        }
        
        UserDefaults.standard.set(userName, forKey: UserDefaultsKeys.userName.rawValue)
        UserDefaults.standard.set(password, forKey: UserDefaultsKeys.password.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
}

enum AuthError: Error {
    case invalidUserName
    case invalidPassword
    case userNotFound
    case userNameTooShort
    case passwordTooShort
    case userNameAlreadyTaken
    
    var title: String {
        switch self {
        case .invalidUserName:
            return "Invalid user name."
        case .invalidPassword:
            return "Invalid password."
        case .userNotFound:
            return "User name not found."
        case .userNameTooShort:
            return "User name too short."
        case .passwordTooShort:
            return "Password too short."
        case .userNameAlreadyTaken:
            return "User name taken."
        }
    }
    
    var message: String {
        switch self {
        case .invalidUserName:
            return "Check your user name and try again."
        case .invalidPassword:
            return "Check your password and try again."
        case .userNotFound:
            return "User with this name does not exist. Try again."
        case .userNameTooShort:
            return "User name must contain at least one character."
        case .passwordTooShort:
            return "Password must contain at least one character."
        case .userNameAlreadyTaken:
            return "The user name you entered is already taken. Try again."
        }
    }
}

