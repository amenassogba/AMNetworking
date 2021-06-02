//
//  TestRequest.swift
//
//  Created by Amen ASSOGBA on 09/05/2021.
//  Copyright © 2021  Amen IO. All rights reserved.
//

import Foundation


public struct TestRequest: Request  {
  
  public init() {}
  
  public var path: String { return "/character"}
  public var method: RequestMethod { return .get}
  public var headers: ReaquestHeaders?
  public var parameters: RequestParameters?
  public var progressHandler: ProgressHandler?
  
}
