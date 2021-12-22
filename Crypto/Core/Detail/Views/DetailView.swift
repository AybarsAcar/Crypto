//
//  DetailView.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import SwiftUI


struct DetailView: View {
  
  @StateObject var viewModel: DetailViewModel
  
  private let colums: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]
  
  private let spacing: CGFloat = 30
  
  init(coin: Coin) {
    _viewModel = StateObject(wrappedValue: DetailViewModel(coin: coin))
  }
  
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Text("")
          .frame(height: 150)
        
        overviewTitle
        Divider()
        overviewGrid
        
        additionalTitle
        Divider()
        additionalGrid
        
      }
      .padding()
    }
    .navigationTitle(viewModel.coin.name)
  }
}



struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      DetailView(coin: dev.coin)
    }
  }
}


extension DetailView {
  
  private var overviewTitle: some View {
    Text("Overview")
      .font(.title)
      .bold()
      .foregroundColor(.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var additionalTitle: some View {
    Text("Additional Details")
      .font(.title)
      .bold()
      .foregroundColor(.theme.accent)
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private var overviewGrid: some View {
    LazyVGrid(
      columns: colums,
      alignment: .leading,
      spacing: spacing,
      pinnedViews: []
    ) {
      ForEach(viewModel.overviewStatistics) { stat in
        StatisticView(stat: stat)
      }
    }
  }
  
  private var additionalGrid: some View {
    LazyVGrid(
      columns: colums,
      alignment: .leading,
      spacing: spacing,
      pinnedViews: []
    ) {
      ForEach(viewModel.additionalStatistics) { stat in
        StatisticView(stat: stat)
      }
    }
  }
}
