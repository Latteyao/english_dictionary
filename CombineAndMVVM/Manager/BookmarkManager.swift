//
//  BookmarkManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/2.
//

import CoreData
import Foundation

class BookmarkManager {
  // MARK: - Singleton
  
  static let shared = BookmarkManager()

  private init() {}
}

// MARK: - Bookmark Operations

extension BookmarkManager {
  /// 檢查 Core Data Entities(Bookmark) 資料是否重複
  /// - Parameter title: 書籤的標題
  /// - Returns: 是否重複
  func isBookmarkDuplicate(_ title: String) -> Bool {
    let request: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
    request.predicate = NSPredicate(format: "title == %@", title)
    do {
      let results = try CoreDataManager.shared.context.fetch(request)
      return results.count == 0
    } catch {
      print("Faild to fecth Bookmark: \(error)")
      return false
    }
  }
  
  /// 儲存書籤到 Core Data
  /// - Parameters:
  ///   - title: 書籤的標題
  ///   - data: 書籤的相關數據
  func save(title: String, data: Data) {
    let bookmark = Bookmark(context: CoreDataManager.shared.context)
    bookmark.title = title
    bookmark.data = data
    CoreDataManager.shared.saveContext()
    print("Bookmark saved")
  }
  
  /// 獲取所有 Entities(Bookmark) 書籤
  /// - Returns: 書籤的陣列
  func fetchBookmarks() -> [Bookmark] {
    let request: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
    do {
      return try CoreDataManager.shared.context.fetch(request)
    } catch {
      print("Failed to fetch bookmarks: \(error)")
      return []
    }
  }
  
  /// 刪除指定書籤
  /// - Parameter title: 書籤的標題
  func delete(title: String) {
    let request: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
    request.predicate = NSPredicate(format: "title == %@", title)
    do {
      let results = try CoreDataManager.shared.context.fetch(request)
      CoreDataManager.shared.context.delete(results.first!)
      CoreDataManager.shared.saveContext()
      print("Bookmark deleted")
    } catch {
      print("Faild to fecth Bookmark: \(error)")
    }
  }
}
