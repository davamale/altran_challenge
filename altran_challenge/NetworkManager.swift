//
//  NetworkManager.swift
//  altran_challenge
//
//  Created by Dava on 7/7/17.
//
//

import UIKit

/// alias NSDictionary to JSON
public typealias JSON = NSDictionary

public typealias JSONArray = [NSDictionary]

/// Response
public typealias Response = (JSONArray?, NetworkError?) -> ()


/// Network Errors
public enum NetworkError: Error {
    case responseError(String)
    case connectionError(String)
}

class NetworkManager: NSObject {
    
    /// Performs an HTTP GET
    ///
    /// - Parameters:
    ///   - url: url to send GET request
    ///   - completion: Response object
    static func get(url: URL, withCompletion completion: @escaping Response) {
        
        let request = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            
            if let error = error {
                return completion(nil, NetworkError.connectionError(error.localizedDescription))
            }
            
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? JSON else {
                return completion(nil, NetworkError.responseError("Response Error"))
            }
            
            DispatchQueue.main.async {
                completion(json?["Brastlewark"] as? JSONArray, nil)
            }
        });

        task.resume()
    }
}









