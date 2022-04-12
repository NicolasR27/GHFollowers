//
//  NetWorkManager.swift
//  GHFollowers
//
//  Created by Nicolas Rios on 4/11/22.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"
    
    public init() {}
    
    func getFollowers(for username: String,page: Int,completed: @escaping([Follower]?,String?) -> Void) {
        let endpoint = baseURL+"/users/\(username)/followers?per_page=100&page\(page)"
        
        guard let url = URL(string: endpoint )  else {
            completed(nil,"this username created invalid request")
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: url) { data,response,error in
            
            if let _ = error {
                completed(nil,"unable to complete your request")
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server. Please try again.")
                return
            }
            
            guard let data = data else{
                completed(nil," the data from sever is invalid . please try again")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self,from:data)
                completed(followers,nil)
            } catch {
                completed(nil, "the data response from server.please try again")
            }
        }
        task.resume()
    }
}
