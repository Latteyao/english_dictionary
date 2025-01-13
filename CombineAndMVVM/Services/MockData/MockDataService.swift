//
//  MockDataService.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/12.
//

import Foundation
import Combine


protocol MockDataService {
  func fetchMockData<T: Codable>(_ endpoint: Endpoint.APIPath) -> AnyPublisher<T, DatafetchError>
}


protocol MockDataDecodable:MockDataService {
  func mockDataDecoder<T: Codable>(_ data: Data) -> AnyPublisher<T, DatafetchError>
}

extension MockDataDecodable{
   func mockDataDecoder<T: Codable>(_ data: Data) -> AnyPublisher<T, DatafetchError> {
    do {
      // 假設 mockData 是 Data 類型，可以用來解碼成 ResponseModel
      let decodedData = try JSONDecoder().decode(T.self, from: data)

      // 返回解碼後的資料
      return Just(decodedData) // 返回解碼的 ResponseModel
        .setFailureType(to: DatafetchError.self) // 設置錯誤類型為 DatafetchError
        .eraseToAnyPublisher() // 返回 AnyPublisher
    } catch {
      // 如果解碼過程出錯，返回失敗的 Publisher
      return Fail(error: DatafetchError.invalidData)
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
