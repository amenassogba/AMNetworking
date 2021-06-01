//
//  RestClient.swift
//
//  Created by Amen ASSOGBA on 07/05/2021.
//  Copyright © 2021  Amen IO. All rights reserved.
//

import Foundation


public protocol Client {
  
  init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol)
  @discardableResult func execute(request: Request, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask?

}

public class RestClient: Client {
  
  private let environment: EnvironmentProtocol
  private let networkSession: NetworkSessionProtocol
  
  public required init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol) {
    self.environment = environment
    self.networkSession = networkSession
  }
  
  @discardableResult
  public func execute(request: Request, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask? {
    guard let urlRequest = request.urlRequest(with: environment) else {
      completion(.failure(NetworkError.invalidRequest))
      return nil
    }
      
    let task = networkSession.dataTask(with: urlRequest, completionHandler: { [weak self] (data, urlResponse, error) in
      
      guard let urlResponse = urlResponse as? HTTPURLResponse else {
        completion(.failure(NetworkError.invalidResponse))
        return
      }
      
      let result = self?.handleErrors(data: data, urlResponse: urlResponse, error: error)
      switch result {
        case .success(let data):
          DispatchQueue.main.async {
            completion(.success(data))
          }
        case .failure(let error):
          DispatchQueue.main.async {
            completion(.failure(error))
          }
        case .none:
          completion(.failure(NetworkError.noData))
      }
      
    })
    
    task?.resume()
    return task
    
    
  }
  

  private func handleErrors(data: Data?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Data, Error> {
    switch urlResponse.statusCode {
      case 200...299:
        if let data = data {
          return .success(data)
        } else {
          return .failure(NetworkError.noData)
        }
      case 400...499:
        return .failure(NetworkError.invalidRequest)
      case 500...599:
        return .failure(NetworkError.serverError)
      default:
        return .failure(NetworkError.serverError)
    }
  }

  
  
}
