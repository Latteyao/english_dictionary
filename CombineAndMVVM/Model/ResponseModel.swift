//
//  ResponseModel.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/10.
//

import Foundation

// 定義主模型
struct ResponseModel: Codable {
    let query: Query
    var results: Results
}

// 定義 Query 部分的模型
struct Query: Codable {
    let letterPattern: String?
    let limit: String
    let page: Int
}

// 定義 Results 部分的模型
struct Results: Codable {
    let total: Int
    var data: [String]?
}

