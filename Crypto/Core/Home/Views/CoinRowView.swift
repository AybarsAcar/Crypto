//
//  CoinRowView.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import SwiftUI


struct CoinRowView: View {
  
  let coin: Coin
  let showHoldingsColumn: Bool
  
  var body: some View {
    HStack(spacing: 0) {
      
      leftColumn
      
      Spacer()
      
      if showHoldingsColumn {
        centerColumn
      }
      
      rightColumn
      
    }
    .font(.subheadline) // anything not formatted will be a .subheadline
  }
}



struct CoinRowView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CoinRowView(coin: dev.coin, showHoldingsColumn: true)
        .previewLayout(.sizeThatFits)
        .padding()
      
      CoinRowView(coin: dev.coin, showHoldingsColumn: true)
        .previewLayout(.sizeThatFits)
        .padding()
        .preferredColorScheme(.dark)
    }
  }
}


extension CoinRowView {
  
  private var leftColumn: some View {
    HStack(spacing: 0) {
      
      Text("\(coin.rank)")
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .frame(minWidth: 30)
      
      CoinImageView(coin: coin)
        .frame(width: 30, height: 30, alignment: .center)
      
      Text(coin.symbol.uppercased())
        .font(.headline)
        .padding(.leading, 6)
        .foregroundColor(.theme.accent)
    }
  }
  
  
  private var centerColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.totalCurrentHoldingsValue.asCurrencyWith2Decimals())
        .bold()
        .foregroundColor(.theme.accent)
      
      Text((coin.currentHoldings ?? 0).asNumberStringWith2Decimals())
        .foregroundColor(.theme.accent)
    }
  }
  
  
  private var rightColumn: some View {
    VStack(alignment: .trailing) {
      Text(coin.currentPrice.asCurrencyWith6Decimals())
        .bold()
        .foregroundColor(.theme.accent)
      
      Text(coin.priceChangePercentage24H?.asPercentStringWith2Decimals() ?? "")
        .foregroundColor(
          (coin.priceChangePercentage24H ?? 0) >= 0 ? .theme.green : .theme.red
        )
    }
    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing) // make it 1/3.5 th of the screen
  }
}
