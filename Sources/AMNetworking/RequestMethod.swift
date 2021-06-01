//
//  Method.swift
//  Meetmate
//
//  Created by Amen ASSOGBA on 06/05/2021.
//  Copyright © 2021  Amen IO. All rights reserved.
//

import Foundation

public enum RequestMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

public typealias ReaquestHeaders = [String: String]
public typealias RequestParameters = [String : Any?]
public typealias ProgressHandler = (Float) -> Void
