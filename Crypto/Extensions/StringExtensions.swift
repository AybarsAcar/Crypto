//
//  StringExtensions.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import Foundation


extension String {
  
  var withoutHTMLTags: String {
    return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
  }
  
}
