//
//  Environment.swift
//  Meetmate
//
//  Created by Amen ASSOGBA on 07/05/2021.
//  Copyright © 2021  Amen IO. All rights reserved.
//


public protocol EnvironmentProtocol {
  var baseURL: String { get }
}

public enum Environment: EnvironmentProtocol {
  
  case development
  case production
  
  public var baseURL: String {
    switch self {
      case .development:
        return "https://rickandmortyapi.com/api"
      case .production:
        return "https://rickandmortyapi.com/api"
    }
  }
}


//#if ENV_DEV
//#elseif ENV_PROD
//#endif
