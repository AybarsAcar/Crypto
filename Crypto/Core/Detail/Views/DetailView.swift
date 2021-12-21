//
//  DetailView.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import SwiftUI


struct DetailView: View {
  
  let coin: Coin
  
  init(coin: Coin) {
    self.coin = coin
  }
  
  var body: some View {
    Text(coin.name)
  }
}



struct DetailView_Previews: PreviewProvider {
  static var previews: some View {
    DetailView(coin: dev.coin)
  }
}
