//
//  CoreDataContextService.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/14.
//

import CoreData
import Foundation

protocol CoreDataContextService: CoreDataSavable, CoreDataEntityDeletable, CoreDataErrorNotifiable{
  var context: NSManagedObjectContext { get }
}
/// 負責存檔功能的協議
protocol CoreDataSavable {
  /// CoreDataSavable 的型別需要提供一個可存取的 NSManagedObjectContext
  func saveContext()
}

extension CoreDataSavable where Self: CoreDataContextService {
  /// 儲存變更到 Core Data
  func saveContext() {
    // 確認是否有變更需要儲存
    if context.hasChanges {
      do {
        // 嘗試儲存變更
        try context.save()
      } catch {
        // 錯誤處理：列印失敗訊息，避免應用程式崩潰
        print("Core Data Save Error: \(error.localizedDescription)")
        print("Error full: \(error)") 
      }
    }
  }
}

/// 負責刪除實體資料的協議
protocol CoreDataEntityDeletable {
  /// CoreDataEntityDeletable 的型別需要提供一個可存取的 NSManagedObjectContext

  /// 清除指定實體的所有資料
  /// - Parameter entityName: 實體名稱
  func clearEntityData(named entityName: String)
}

extension CoreDataEntityDeletable where Self: CoreDataContextService {
  /// 清除指定 entity 的所有資料
  /// - Parameter entityName: 實體名稱
  func clearEntityData(named entityName: String) {
    // 建立 Fetch Request 以取得指定實體的資料
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    // 建立批次刪除請求
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

    do {
      try context.execute(deleteRequest)
      saveContext()
      print("All \(entityName) data deleted")
    } catch {
      print("Failed to delete \(entityName) data: \(error)")
    }
  }
}
/// CoreData 錯誤通知
protocol CoreDataErrorNotifiable {
  var onError: ((String) -> Void)? { get set }
}
