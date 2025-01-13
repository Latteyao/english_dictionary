//
//  MockDataService.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/12.
//

import Foundation
import Combine


protocol MockDataService {
  func fetchMockData<T: Codable>(_ endpoint: Endpoint.RequestPath) -> AnyPublisher<T, NetworkError>
}


protocol MockDataDecodable:MockDataService {
  func mockDataDecoder<T: Codable>(_ data: Data) -> AnyPublisher<T, NetworkError>
}

extension MockDataDecodable{
   func mockDataDecoder<T: Codable>(_ data: Data) -> AnyPublisher<T, NetworkError> {
    do {
      // 假設 mockData 是 Data 類型，可以用來解碼成 ResponseModel
      let decodedData = try JSONDecoder().decode(T.self, from: data)

      // 返回解碼後的資料
      return Just(decodedData) // 返回解碼的 ResponseModel
        .setFailureType(to: NetworkError.self) // 設置錯誤類型為 NetworkError
        .eraseToAnyPublisher() // 返回 AnyPublisher
    } catch {
      // 如果解碼過程出錯，返回失敗的 Publisher
      return Fail(error: NetworkError.invalidData)
        .eraseToAnyPublisher()
    }
  }
}


//protocol MockingData:MockDataService {
//  var stub: Data { get }
//}
//
//protocol GeneralMockingData: MockingData {}
//protocol RandomMockingData: MockingData {}
//protocol SearchMockingData: MockingData {}
