//
//  Data+.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/5.
//

import Foundation


extension Data {
    // 將任意符合 Codable 的物件編碼為 Data
    static func encode<T: Codable>(_ value: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(value)
        } catch {
            print("Failed to encode object: \(error)")
            return nil
        }
    }

    // 從 Data 解碼為指定類型的物件
    func decode<T: Codable>(_ type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(type, from: self)
        } catch {
            print("Failed to decode data: \(error)")
            return nil
        }
    }
}
