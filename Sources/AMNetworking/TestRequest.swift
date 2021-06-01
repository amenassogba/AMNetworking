//
//  TestRequest.swift
//  Meetmate
//
//  Created by Amen ASSOGBA on 09/05/2021.
//  Copyright © 2021  Amen IO. All rights reserved.
//

import Foundation


struct TestRequest: Request  {
  var path: String { return "/character"}
  var method: RequestMethod { return .get}
  var headers: ReaquestHeaders?
  var parameters: RequestParameters?
  var progressHandler: ProgressHandler?
  
}
