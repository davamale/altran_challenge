//
//  NetworkStub.swift
//  altran_challenge
//
//  Created by Dava on 8/4/17.
//
//

import Foundation

final class NetworkStub: Networking {
  
  var shouldReturnSuccess: Bool = true
  
  func get(url: URL, withCompletion completion: @escaping Response) {
    
    if shouldReturnSuccess {
      let jsonResponse: JSONArray = [ObjectHelper.gnomeJsonMock()]
      return completion(jsonResponse, nil)
    }
    
    completion(nil, NetworkError.responseError("Generic error"))
  }
}
