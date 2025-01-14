//
//  BookmarkService.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2025/1/14.
//

import Foundation

protocol BookmarkService: BookmarkDuplicating, BookmarkSaving, BookmarkFetching, BookmarkDeleting {}

/// 判斷書籤是否重複
protocol BookmarkDuplicating {
  func isBookmarkDuplicate(_ title: String) -> Bool
}

/// 儲存書籤
protocol BookmarkSaving {
  func saveBookmark(title: String, data: Data)
}

/// 抓取書籤
protocol BookmarkFetching {
  func fetchBookmarks() -> [Bookmark]
}

/// 刪除書籤
protocol BookmarkDeleting {
  func delete(title: String)
}
