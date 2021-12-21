//
//  HapticManager.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import Foundation
import SwiftUI


class HapticManager {
  
  private init() { }
  
  static let generator = UINotificationFeedbackGenerator()
  
  static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    generator.notificationOccurred(type)
  }
  
}
