//
//  Endpoint.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/13.
//

import Foundation

struct Endpoint {
  
  enum APIPath {
    case general(for: String)
    case random
    case search(for: String)
  }
  // MARK: - 屬性
     private let baseURL: String = "https://wordsapiv1.p.rapidapi.com"
     private let path: APIPath
  
  // 初始化
      init(path: APIPath) {
          self.path = path
      }
  
  var url: URL {
          switch path {
          case .general(for: let word):
              return URL(string: "\(baseURL)/words/\(word)")!
          case .random:
              return URL(string: "\(baseURL)/words/?random=true")!
          case .search(for: let word):
              return URL(string: "\(baseURL)/words/?limit=100&letterPattern=\(word)")!
          }
      }
//    var request: URLRequest {
//      switch self {
//      case .general(for: let word):
//        return URLRequest(url: URL(string: "https://wordsapiv1.p.rapidapi.com/words/\(word)")!)
//      case .random:
//        return URLRequest(url: URL(string: "https://wordsapiv1.p.rapidapi.com/words/?random=true")!)
//      case .search(for: let word):
//        return URLRequest(url: URL(string: "https://wordsapiv1.p.rapidapi.com/words/?limit=100&letterPattern=\(word)")!)
//      }
//    }
  
  // URLRequest 組建
//      var request: URLRequest? {
////          guard let url = url else { return nil }
//          var request = URLRequest(url: url)
//          request.addValue(MySecret.APIKey, forHTTPHeaderField: "X-RapidAPI-Key")
//          request.addValue("wordsapiv1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
//          return request
//      }
  }

