//
//  CoreDataManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/4.
//

import CoreData
import Foundation

class CoreDataRepository: CoreDataContextService {
  // MARK: - Singleton
  
  static let shared = CoreDataRepository()
  
  // MARK: - Core Data Stack
  
  /// NSPersistentContainer 負責管理 Core Data 堆疊
  lazy var persistentContainer: NSPersistentContainer = {
    let  container = NSPersistentContainer(name: "CombineAndMVVM")
    container.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Core Data stack initialization error: \(error)")
      }
    }
    return container
  }()
  
  /// 提供當前的 NSManagedObjectContext，方便執行資料操作
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
}

// MARK: - Core Data Operations

extension CoreDataRepository {
  /// 儲存變更到 Core Data
  func saveContext() {
    // 確認是否有變更需要儲存
    if context.hasChanges {
      do {
        // 嘗試儲存變更
        try context.save()
      } catch {
        // 錯誤處理：列印失敗訊息，避免應用程式崩潰
        print("Failed to save context: \(error)")
      }
    }
  }

  /// 清除指定 entity 的所有資料
  /// - Parameter entityName: 實體名稱
  func clearEntityData(named entityName: String){
    // 建立 Fetch Request 以取得指定實體的資料
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    // 建立批次刪除請求
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try CoreDataRepository.shared.context.execute(deleteRequest)
      CoreDataRepository.shared.saveContext()
      print("All \(entityName) data deleted")
    } catch {
      print("Failed to delete \(entityName) data: \(error)")
    }
  }
}
