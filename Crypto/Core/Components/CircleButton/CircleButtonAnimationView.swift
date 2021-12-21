//
//  CircleButtonAnimationView.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import SwiftUI

struct CircleButtonAnimationView: View {
  
  @Binding var animate: Bool
  
  var body: some View {
    
    Circle()
      .stroke(lineWidth: 5.0)
      .scale(animate ? 1.0 : 0.0)
      .opacity(animate ? 0.0 : 1.0)
      .animation(animate ? .easeOut(duration: 0.5) : .none) // animate in 1 direction
  }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
  static var previews: some View {
    CircleButtonAnimationView(animate: .constant(false))
  }
}
