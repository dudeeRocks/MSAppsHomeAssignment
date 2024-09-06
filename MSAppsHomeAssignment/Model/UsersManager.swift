// Abstract: Object for fetching and caching users

import Foundation

class UsersManager {
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let endpoint = "https://api.mockaroo.com/api/729a5c80?count=120&key=947b40d0"
        
        guard let url = URL(string: endpoint) else {
            completion(.failure(UsersManagerError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
        
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(UsersManagerError.invalidResponse))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let fetchedUsers = try decoder.decode([User].self, from: data)
                    
                    // TODO: Save users to persistent storage
                    
                    DispatchQueue.main.async {
                        
                    }
                } catch {
                    completion(.failure(UsersManagerError.invalidData))
                    return
                }
            }
        }
        task.resume()
    }
}

enum UsersManagerError: Error {
    case invalidURL, invalidResponse, invalidData
}
