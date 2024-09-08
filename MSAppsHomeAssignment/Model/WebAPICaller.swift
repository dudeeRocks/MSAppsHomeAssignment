// Abstract: single object for centralized api calls.

import Foundation

class WebAPICaller {
    static let shared = WebAPICaller()
    
    /// Returns an array of `User` objects decoded from JSON.
    func fetchUsers() async throws -> [User] {
        let endpoint = "https://api.mockaroo.com/api/729a5c80?count=120&key=947b40d0"
        
        let data = try await getData(from: endpoint)
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
            let fetchedUsers = try decoder.decode([User].self, from: data)
            
            print("Successfully fetch users.")
            
            return fetchedUsers
        } catch {
            throw WebAPICallerError.invalidData
        }
    }
    
    func fetchImage(for user: UserEntity) async throws -> Data {
        guard let endpoint = user.avatarURL else {
            throw WebAPICallerError.invalidURL
        }
        
        do {
            return try await getData(from: endpoint)
        } catch {
            throw WebAPICallerError.invalidData
        }
    }
    
    private func getData(from endpoint: String) async throws -> Data {
        guard let url = URL(string: endpoint) else {
            throw WebAPICallerError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            throw WebAPICallerError.invalidResponse
        }
        
        return data
    }
    
    private init() { }
}

enum WebAPICallerError: Error {
    case invalidURL, invalidResponse, invalidData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid server response."
        case .invalidData:
            return "Failed to decode the data."
        }
    }
}
