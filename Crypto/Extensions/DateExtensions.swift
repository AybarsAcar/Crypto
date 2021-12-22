//
//  DateExtensions.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import Foundation


extension Date {
  
  /// Custom initialiser to parse the date coming from our API
  /// ```
  /// "2021-03-13T20:49:26.606Z"
  /// ```
  init(apiString: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss.SSSZ"
    
    let date = formatter.date(from: apiString) ?? Date()
    
    self.init(timeInterval: 0, since: date)
  }
  
  
  private var shortFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    
    return formatter
  }
  
  
  /// returns the Date as a short date string
  func asShortDateString() -> String {
    return shortFormatter.string(from: self)
  }
}
