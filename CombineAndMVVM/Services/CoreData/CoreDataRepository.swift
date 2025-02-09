//
//  CoreDataRepository.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/4.
//

import CoreData
import Foundation

class CoreDataRepository: CoreDataContextService{
  
  var onError: ((String) -> Void)?
  
  init(onError: ((String) -> Void)? = nil) {
    self.onError = onError
  }

  // MARK: - Core Data Stack

  /// NSPersistentContainer 負責管理 Core Data 堆疊
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CombineAndMVVM")
    container.loadPersistentStores { _, error in
      if let error = error {
        print("❌ Core Data stack initialization error: \(error.localizedDescription)")
        self.onError?("Core Data 初始化失敗：\(error.localizedDescription)")
      }
    }
    return container
  }()

  /// 提供當前的 NSManagedObjectContext，方便執行資料操作
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
}


