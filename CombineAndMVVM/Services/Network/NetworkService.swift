//
//  NetworkService.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/12.
//

import Foundation
import Combine

protocol NetworkService {
  func fetchData<T: Codable>(_ endpoint: Endpoint.RequestPath) -> AnyPublisher<T, NetworkError>
}



protocol NetworkErrorHandler: NetworkService {
  func handleNetworkError(_ error: Error) -> NetworkError
}

extension NetworkErrorHandler{
  func handleNetworkError(_ error: Error) -> NetworkError {
    if let decodingError = error as? DecodingError {
      print("Error decoding JSON: \(decodingError.localizedDescription)")
      return .invalidResponse
    }
    if let urlError = error as? URLError {
      print("Error fetching data: \(urlError.localizedDescription)")
      return .networkFailure
    }
    return .unknown
  }
}

protocol NetworkResponseHandler: NetworkService {
  func handleResponse(_ output: URLSession.DataTaskPublisher.Output) throws -> Data
}

extension NetworkResponseHandler{
  func handleResponse(_ output: URLSession.DataTaskPublisher.Output) throws -> Data {
    guard let urlResponse = output.response as? HTTPURLResponse, 200...299 ~= urlResponse.statusCode else {
      print("Invalid Response")
      throw DatafetchError.invalidResponse
    }
    return output.data
  }
}
