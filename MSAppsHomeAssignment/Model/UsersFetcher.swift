// Abstract: single object for centralized users fetching.

import Foundation

class UsersFetcher {
    static let shared = UsersFetcher()
    
    func fetchUsers() async throws -> [User] {
        let endpoint = "https://api.mockaroo.com/api/729a5c80?count=120&key=947b40d0"
        
        guard let url = URL(string: endpoint) else {
            throw FetchError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
            (200...299).contains(httpResponse.statusCode) else {
            throw FetchError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
            let fetchedUsers = try decoder.decode([User].self, from: data)
            
            return fetchedUsers
        } catch {
            throw FetchError.invalidData
        }
    }
    
    private init() { }
}

enum FetchError: Error {
    case invalidURL, invalidResponse, invalidData
}
