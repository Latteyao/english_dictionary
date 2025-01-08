//
//  WordsModel.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/7/3.
//

import Foundation


// MARK: - 主要模型
/// 表示一個單字的主要資料模型
struct WordData: Codable, Equatable {

  var word: String?
    let frequency: Double?
    let syllables: Syllables?
    let pronunciation: Pronunciation?
    let results: [WordResult]?
  // 返回一個空的 WordData 實例，通常用於初始化或測試
  static var empty: WordData {
    return WordData(word: nil, frequency: 0, syllables: Syllables(count: 0, list: [""]), pronunciation: Pronunciation(all: ""), results: [WordResult(definition: nil, derivation: nil, examples: nil, hasTypes: nil, partOfSpeech: nil, synonyms: nil, typeOf: nil)])
      }
  
}

// MARK: - 音節模型
/// 表示一個單字的音節數量和音節列表
struct Syllables: Codable {
    let count: Int
    let list: [String]
}

// MARK: - 發音模型

/// 表示一個單字的發音
struct Pronunciation: Codable {
    let all: String
}

// MARK: - 結果模型

/// 表示一個單字的詳細結果（定義、詞源、例句等）
struct WordResult: Codable {
    let definition: String?
    let derivation: [String]?
    let examples: [String]?
    let hasTypes: [String]?
    let partOfSpeech: String?
    let synonyms: [String]?
    let typeOf: [String]?
}

extension WordData{
  
  static func == (lhs: WordData, rhs: WordData) -> Bool {
    return lhs.word == rhs.word
  }
  
}
