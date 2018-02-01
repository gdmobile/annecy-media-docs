//
//  NetworkService.swift
//  Sample
//
//  Created by Tobias Schultka on 01.02.18.
//  Copyright © 2018 GD Mobile GmbH. All rights reserved.
//

import Foundation

class NetworkService {
    private static let API_VERSION = "1.0"
    private static let TOKEN = "6ce0bbf0-2dc8-4d7c-a497-e93105188ba1"
    
    /// Initialize Annecy network service.
    init() {}
    
    /// Start HTTP request.
    ///
    /// - Parameter url: REST request URL.
    /// - Parameter method: HTTP request method e.g. "GET" or "POST".
    /// - Parameter query: GET or POST request parameters.
    /// - Parameter success: Success completion handler.
    /// - Parameter failure: Error completion handler.
    func request(
        url: String,
        method: String,
        query: [String: String]?,
        success: @escaping ([String: Any]) -> Void,
        failure: @escaping (Error?) -> Void) {
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(NetworkService.TOKEN)",
            "Content-Type": "application/json",
            "API-VERSION": NetworkService.API_VERSION
        ]
        
        let session = URLSession(configuration: config)
        let urlComponents = NSURLComponents(string: url)!
        var items: [URLQueryItem] = []
        
        if (query != nil) {
            for (key, value) in query! {
                items.append(URLQueryItem(name: key, value: value))
            }
        }
        
        items = items.filter{!$0.name.isEmpty}
        
        if !items.isEmpty {
            urlComponents.queryItems = items
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.httpMethod = method
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if let error = error {
                print("ANNECY MEDIA: \(error.localizedDescription)")
                failure(error)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        if let jsonData = json["data"] as? [String: Any] {
                            success(jsonData)
                        } else if let message = json["message"] as? String {
                            print("ANNECY MEDIA: \(message)")
                            failure(nil)
                        } else {
                            print("ANNECY MEDIA: data in response is missing")
                            failure(nil)
                        }
                    }
                } catch {
                    print("ANNECY MEDIA: error in JSONSerialization")
                    failure(nil)
                }
            }
        })
        
        task.resume()
    }
}
