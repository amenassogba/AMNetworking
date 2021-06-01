//
//  DataHandler.swift
//
//  Created by Amen ASSOGBA on 07/05/2021.
//  Copyright © 2021  Amen IO. All rights reserved.
//

import Foundation

extension Decodable {
 public static func decode(from data: Data) -> Result<Self, Error> {
    do {
      let decodable = try JSONDecoder().decode(Self.self, from: data)
      return .success(decodable)
    }
    catch let error{
      return .failure(NetworkError.parseError(error.localizedDescription))
    }
    
  }
}

extension Encodable {
  func toJSONDictionary() -> [String: Any] {
    guard let data = try? JSONEncoder().encode(self),
          let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [:] }
    return dictionary
  }
}

extension Data {
  func toJSON() -> Any? {
    do {
      return try JSONSerialization.jsonObject(with: self, options: .mutableContainers)
    } catch {
      return nil
    }
  }

}


//    catch DecodingError.dataCorrupted(let context) {
//      return .failure(DecodingError.self as! Error)
//    } catch DecodingError.keyNotFound(let key, let context) {
//      print("codingPath: \(context.codingPath)")
//      return .failure(.custom(message: context.debugDescription))
//    } catch DecodingError.valueNotFound(let value, let context) {
//      print("Value '\(value)' not found: \(context.debugDescription)")
//      print("codingPath: \(context.codingPath)" )
//      return .failure(.custom(message: context.debugDescription))
//    } catch DecodingError.typeMismatch(let type, let context) {
//      print("Type '\(type)' mismatch: \(context.debugDescription)")
//      print("codingPath: \(context.codingPath)")
//      return .failure(.custom(message: context.debugDescription))
