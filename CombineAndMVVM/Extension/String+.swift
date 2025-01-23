//
//  String.swift
//  CombineAndMVVM
//
//  Created by MacBook Pro on 2024/11/15.
//

import Foundation
import UIKit

extension String {
  
  func asIndentedAttributedString() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 14 // 首行縮排
        paragraphStyle.headIndent = 14 // 其他行的縮排
        paragraphStyle.lineSpacing = 4 // 行距
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 16) // 字體大小
        ]
        
    return NSAttributedString(string: self, attributes: attributes)
    }
  
  func emptyOrNil() -> String {
    self.isEmpty || self == "" || self == " " ? "❎" : self
    
  }
}
