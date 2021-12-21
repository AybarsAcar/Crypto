//
//  UIApplicationExtensions.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import Foundation
import SwiftUI


extension UIApplication {
  
  /// extension function to dismiss the keyboard
  /// ```
  /// UIApplication.shared.endEditing()
  /// ```
  func endEditing() {
    
    // send an obj-c function to dissmiss the keyboard
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
}
