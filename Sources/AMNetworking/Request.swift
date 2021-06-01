//
//  Request.swift
//  Meetmate
//
//  Created by Amen ASSOGBA on 06/05/2021.
//  Copyright © 2021  Amen IO. All rights reserved.
//

import Foundation

public protocol Request {
  
  var path: String { get }
  var method: RequestMethod { get }
  var headers: ReaquestHeaders? { get }
  var parameters: RequestParameters? { get }
  
  var progressHandler: ProgressHandler? { get set }
}


extension Request {
  
  public func urlRequest(with environment: EnvironmentProtocol) -> URLRequest? {
    guard let url = url(with: environment.baseURL) else {
      return nil
    }
    
    var request = URLRequest(url: url)

    request.httpMethod = method.rawValue
    request.allHTTPHeaderFields = headers
    request.httpBody = body
    
    return request
  }
  

  private func url(with baseURL: String) -> URL? {
    guard var urlComponents = URLComponents(string: baseURL) else {
      return nil
    }

    urlComponents.path = urlComponents.path + path
    urlComponents.queryItems = queryItems
    
    return urlComponents.url
  }
  
  private var queryItems: [URLQueryItem]? {
    // Chek if it is a GET method.
    guard method == .get, let parameters = parameters else {
      return nil
    }
    // Convert parameters to query items.
    return parameters.map { (key: String, value: Any?) -> URLQueryItem in
      let valueString = String(describing: value)
      return URLQueryItem(name: key, value: valueString)
    }
  }
  
  private var body: Data? {
    guard [.post, .put, .patch].contains(method), let parameters = parameters else { return nil }
    var jsonBody: Data?
    
    do {
      jsonBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch {
      print(error)
    }
    return jsonBody
  }
}
