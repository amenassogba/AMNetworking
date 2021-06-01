//
//  NetworkError.swift
//
//  Created by Amen ASSOGBA on 06/05/2021.
//  Copyright © 2021  Amen IO. All rights reserved.
//

import Foundation
public enum NetworkError: Error {
  
  case noData
  case invalidResponse
  case invalidRequest
  case invalidTokenError
  case serverError
  case parseError(String?)
  case custom(Int?) //400 with specitif code
}
