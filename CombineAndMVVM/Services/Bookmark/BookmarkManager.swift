//
//  BookmarkManager.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/12/2.
//

import CoreData
import Foundation

class BookmarkManager: BookmarkService {
  // MARK: - Singleton

 var coreDataRepository: CoreDataContextService

  // MARK: - Initializer

  // 用建構子（init）注入 context
  init(coreDataRepository: CoreDataContextService = CoreDataRepository()) {
    self.coreDataRepository = coreDataRepository
  }
}

// MARK: - Bookmark Operations

extension BookmarkManager {
  /// 檢查 Core Data Entities(Bookmark) 資料是否重複
  /// - Parameter title: 書籤的標題
  /// - Returns: 是否重複
  func isBookmarkDuplicate(_ title: String) -> Bool {
    let context = coreDataRepository.context
    let request: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
    request.predicate = NSPredicate(format: "title == %@", title)
    do {
      let results = try context.fetch(request)
      return !results.isEmpty
    } catch {
      print("Failed to fecth Bookmark: \(error)")
      return false
    }
  }

  /// 儲存書籤到 Core Data
  /// - Parameters:
  ///   - title: 書籤的標題
  ///   - data: 書籤的相關數據
  func saveBookmark(title: String, data: Data) {
    let bookmark = Bookmark(context: coreDataRepository.context)
    bookmark.title = title
    bookmark.data = data
    coreDataRepository.saveContext()
    print("Bookmark saved")
    
  }

  /// 獲取所有 Entities(Bookmark) 書籤
  /// - Returns: 書籤的陣列
  func fetchBookmarks() -> [Bookmark] {
    let context = coreDataRepository.context
    let request: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
    do {
      return try context.fetch(request)
    } catch {
      print("Failed to fetch bookmarks: \(error)")
      return []
    }
  }

  /// 刪除指定書籤
  /// - Parameter title: 書籤的標題
  func delete(title: String) {
    let context = coreDataRepository.context
    let request: NSFetchRequest<Bookmark> = Bookmark.fetchRequest()
    request.predicate = NSPredicate(format: "title == %@", title)
    do {
      let results = try context.fetch(request)
      if let bookmark = results.first {
        context.delete(bookmark)
        coreDataRepository.saveContext()
        print("Bookmark deleted")
      }
    } catch {
      print("Failed to fecth Bookmark: \(error)")
    }
  }
}
