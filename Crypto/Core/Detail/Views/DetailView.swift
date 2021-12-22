//
//  DetailView.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import SwiftUI


struct DetailView: View {
  
  @StateObject private var viewModel: DetailViewModel
  
  @State private var showFullDesctiption: Bool = false
  
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
      
      VStack {
        ChartView(coin: viewModel.coin)
          .padding(.vertical)
        
        VStack(spacing: 20) {
          
          overviewTitle
          Divider()
          
          descriptionSection
          
          overviewGrid
          
          additionalTitle
          Divider()
          additionalGrid
          
          externalLinksSection
          
        }
        .padding()
        
      }
    }
    .navigationTitle(viewModel.coin.name)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        navigationBarTrailingItems
      }
    }
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
  
  private var navigationBarTrailingItems: some View {
    HStack {
      Text(viewModel.coin.symbol.uppercased())
        .font(.headline)
        .foregroundColor(.theme.secondaryText)
      
      CoinImageView(coin: viewModel.coin)
        .frame(width: 25, height: 25, alignment: .center)
    }
  }
  
  private var descriptionSection: some View {
    ZStack {
      if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
        VStack(alignment: .leading) {
          Text(coinDescription)
            .lineLimit(showFullDesctiption ? nil : 3)
            .font(.callout)
            .foregroundColor(.theme.secondaryText)
          
          Button(action: {
            withAnimation(.easeInOut) {
              showFullDesctiption.toggle()
            }
          }, label: {
            Text(showFullDesctiption ? "Less" : "Read more...")
              .font(.caption)
              .bold()
              .padding(.vertical, 4)
          })
            .accentColor(.blue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
  }
  
  private var externalLinksSection: some View {
    VStack(alignment: .trailing, spacing: 10) {
      if let websiteString = viewModel.websiteURL,
         let url = URL(string: websiteString) {
        HStack {
          Link("Website", destination: url)
            .accentColor(.blue)
          Image(systemName: "arrow.up.right.square")
            .foregroundColor(.blue)
        }
      }
      
      if let redditString = viewModel.redditURL,
         let url = URL(string: redditString) {
        HStack {
          Link("Reddit", destination: url)
            .accentColor(.blue)
          
          Image(systemName: "arrow.up.right.square")
            .foregroundColor(.blue)
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .trailing)
    .font(.footnote)
  }
}
