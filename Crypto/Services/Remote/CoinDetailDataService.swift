//
//  CoinDetailDataService.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import Foundation
import Combine


class CoinDetailDataService {
  
  // we will subscribe to this publisher from the view models
  @Published var coinDetail: CoinDetail? = nil
  
  // required because subscriptions can be cancelled at any time
  // that's why we need to store them - we can use the following to cancel it
  var coinDetailSubscription: AnyCancellable?
  
  let _coin: Coin
  
  
  init(coin: Coin) {
    _coin = coin
    getCoinDetails()
  }
  
  
  func getCoinDetails() {
    
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(_coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
      return
    }
    
    // this can be sending data over time but the requrest is a simple GET request
    // because we will cancel it at the end to save on memory since it is not a WEB Socket connection
    coinDetailSubscription = NetworkingManager.download(url: url) // our custom download method runs on the back thread and receives on the main thread
      .decode(type: CoinDetail.self, decoder: JSONDecoder())
      .sink { completion in
        // handles the error state
        NetworkingManager.handleCompletion(completion)
      } receiveValue: { [weak self] coinDetail in
        self?.coinDetail = coinDetail
        self?.coinDetailSubscription?.cancel() // cancel the subscription after returning the data
      }

  }
}
