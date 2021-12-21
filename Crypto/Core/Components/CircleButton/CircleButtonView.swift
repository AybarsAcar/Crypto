//
//  CircleButtonView.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import SwiftUI


struct CircleButtonView: View {
  
  let iconName: String
  
  var body: some View {
    
    Image(systemName: iconName)
      .font(.headline)
      .foregroundColor(.theme.accent)
      .frame(width: 50, height: 50, alignment: .center)
      .background(
        Circle()
          .foregroundColor(.theme.background)
      )
      .shadow(color: .theme.accent.opacity(0.25), radius: 10, x: 0, y: 0)
      .padding()
  }
}



struct CircleButtonView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CircleButtonView(iconName: "heart.fill")
        .previewLayout(.sizeThatFits)
      
      CircleButtonView(iconName: "heart.fill")
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
  }
}
