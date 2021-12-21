//
//  DetailLoadingView.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import SwiftUI


struct DetailLoadingView: View {
  
  @Binding var coin: Coin?
  
  var body: some View {
    
    ZStack {
      if let coin = coin {
        DetailView(coin: coin)
      }
    }
  }
}



struct DetailLoadingView_Previews: PreviewProvider {
  static var previews: some View {
    DetailLoadingView(coin: .constant(nil))
  }
}
