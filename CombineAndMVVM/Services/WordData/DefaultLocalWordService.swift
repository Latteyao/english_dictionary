//
//  DefaultLocalWordService.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/14.
//

import Foundation

protocol LocalWordService {
  func loadPopularWords(from fileName: String) -> [String]
}

class DefaultLocalWordService: LocalWordService {
    func loadPopularWords(from fileName: String) -> [String] {
            guard let path = Bundle.main.path(forResource: fileName, ofType: "json"),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                  let words = try? JSONDecoder().decode([String: Int].self, from: data) else {
                return []
            }
            return Array(words.shuffled().prefix(3).map { $0.key })
  }
}
