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
  
  func get(url: URL, withCompletion completion: @escaping (Response) -> Void) {
    
    if shouldReturnSuccess {
      let jsonResponse: JSONArray = [ObjectHelper.gnomeJsonMock()]
      return completion(Response.success(jsonResponse))
    }
    
    completion(Response.error(NetworkError.responseError("Generic error")))
  }
}
