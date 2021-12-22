//
//  ChartView.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import SwiftUI


struct ChartView: View {
  
  // we will animate the line
  @State private var percentage: CGFloat = 0
  
  private let data: [Double]
  private let maxY: Double
  private let minY: Double
  private let lineColor: Color
  private let startingDate: Date
  private let endingDate: Date
  
  init(coin: Coin) {
    data = coin.sparklineIn7D?.price ?? []
    
    // setup the Y axis
    maxY = data.max() ?? 0.0
    minY = data.min() ?? 0.0
    
    let priceChange = (data.last ?? 0) - (data.first ?? 0)
    lineColor = priceChange > 0 ? .theme.green : .theme.red
    
    endingDate = Date(apiString: coin.lastUpdated ?? "")
    startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60) // go back 7 days
  }
  
  var body: some View {
    
    VStack {
      lineChart
        .frame(height: 200)
        .background(chartBg)
        .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
      
      chartDateLabels
        .padding(.horizontal, 4)
    }
    .font(.caption)
    .foregroundColor(.theme.secondaryText)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        withAnimation(.linear(duration: 2.0)) {
          percentage = 1.0
        }
      }
    }
    
  }
}



struct ChartView_Previews: PreviewProvider {
  static var previews: some View {
    ChartView(coin: dev.coin)
  }
}


extension ChartView {
  
  private var lineChart: some View {
    GeometryReader { geometry in
      Path { path in
        for i in data.indices {
          
          let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(i + 1)
          
          // get the length of the y axis
          let yAxis = maxY - minY
          
          // inverse CGFloat because (0,0) position is at the top
          // y increases as we go down so we need to inverse it
          let yPosition = (1 - CGFloat((data[i] - minY) / yAxis)) * geometry.size.height
          
          if i == 0 {
            path.move(to: CGPoint(x: xPosition, y: yPosition))
          }
          
          path.addLine(to: CGPoint(x: xPosition, y: yPosition))
        }
      }
      .trim(from: 0, to: percentage)
      .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
      .shadow(color: lineColor.opacity(0.4), radius: 6, x: 0, y: 10)
      .shadow(color: lineColor.opacity(0.1), radius: 2, x: 0, y: 20)
    }
  }
  
  
  private var chartBg: some View {
    VStack {
      Divider()
      Spacer()
      Divider()
      Spacer()
      Divider()
    }
  }
  
  private var chartYAxis: some View {
    VStack {
      Text(maxY.formattedWithAbbreviations())
      Spacer()
      Text(((maxY + minY) / 2).formattedWithAbbreviations())
      Spacer()
      Text(minY.formattedWithAbbreviations())
    }
  }
  
  private var chartDateLabels: some View {
    HStack {
      Text(startingDate.asShortDateString())
      Spacer()
      Text(endingDate.asShortDateString())
    }
  }
}
