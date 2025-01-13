//
//  Endpoint.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/13.
//

import Foundation

struct Endpoint {
  
  enum RequestPath {
    case general(for: String)
    case random
    case search(for: String)
    
    var url: URL {
      let baseURL: String = "https://wordsapiv1.p.rapidapi.com"
      switch self {
      case .general(for: let word):
        return URL(string: "\(baseURL)/words/\(word)")!
      case .random:
        return URL(string: "\(baseURL)/words/?random=true")!
      case .search(for: let word):
        return URL(string: "\(baseURL)/words/?limit=100&letterPattern=\(word)")!
      }
    }
  }
}

