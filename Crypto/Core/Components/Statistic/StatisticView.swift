//
//  StatisticView.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import SwiftUI


struct StatisticView: View {
  
  let stat: Statistic
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      
      Text(stat.title)
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
      
      Text(stat.value)
        .font(.headline)
        .foregroundColor(.theme.accent)
      
      HStack(spacing: 4) {
        Image(systemName: "triangle.fill")
          .font(.caption2)
          .rotationEffect(
            Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180)
          )
        
        Text(stat.percentageChange?.asPercentStringWith2Decimals() ??  "")
          .font(.caption)
        .bold()
      }
      .foregroundColor((stat.percentageChange ?? 0) >= 0 ? .theme.green : .theme.red)
      // changing the opacity we can align the items instead of conditionally rendering it
      .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
    }
  }
}



struct StatisticView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      StatisticView(stat: dev.stat1)
        .previewLayout(.sizeThatFits)
        .padding()
      
      StatisticView(stat: dev.stat2)
        .previewLayout(.sizeThatFits)
        .padding()
      
      StatisticView(stat: dev.stat3)
        .previewLayout(.sizeThatFits)
        .padding()
      
      StatisticView(stat: dev.stat1)
        .previewLayout(.sizeThatFits)
        .padding()
        .preferredColorScheme(.dark)
    }
  }
}
