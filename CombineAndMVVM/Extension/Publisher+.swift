//
//  Publisher.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/8.
//

import Foundation
import Combine

extension Publisher where Output == WordData,Failure == DataManager.DatafetchError{
  
  func mapAndValidateWordData(errorState: @escaping (DataManager.WordDetailStateError) -> Void) -> AnyPublisher<WordData, Never>{
  }
  
}
