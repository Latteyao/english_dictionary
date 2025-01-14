//
//  WordDataService.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/14.
//

import Combine
import Foundation

protocol WordDataService {
  var popularWords: [String] { get }
}

protocol WordDataFetcher: WordDataService {
  func fetchWord(endpoint: Endpoint.RequestPath) -> AnyPublisher<WordData, NetworkError>
  func fetchPopularWords(at array: [String]) -> AnyPublisher<[PopularWordResult], Never>
}
