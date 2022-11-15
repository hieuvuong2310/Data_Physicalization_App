//
//  APIRequest.swift
//  Visualize_Data
//
//  Created by Hieu Vuong on 2022-11-12.
//

import Foundation


enum APIError: Error{
    case responseProblem
    case decodingProblem
    case encodingProblem
}

struct APIRequest {
    let resourceURL: URL
    
    init(endpoint: String) {
        let resourceString = "http://127.0.0.1:5001/data-visualization-proje-d998b/us-central1/app/api/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        
        self.resourceURL = resourceURL
    }
    
    //Save for project registration
    //POST call for this endpoint: /api/leader/leaderID:/projectInfo
    func save (_ item: ProjectRegis, completion: @escaping(Result<ProjectRegis, APIError>) -> Void){
        do {
            var urlRequest = URLRequest(url: resourceURL)
            
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(item)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {
                data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let
                    jsonData = data else{
                        completion(.failure(.responseProblem))
                        return
                }
                
                do{
                    let messageData = try JSONDecoder().decode(ProjectRegis.self, from: jsonData)
                    completion(.success(messageData))
                }catch{
                    completion(.failure(.decodingProblem))
                }
            }
            dataTask.resume()
        }catch{
            completion(.failure(.encodingProblem))
        }
    }
}
