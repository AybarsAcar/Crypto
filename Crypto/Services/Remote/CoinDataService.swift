//
//  CoinDataService.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import Foundation
import Combine


/// Repository
class CoinDataService {
  
  // we will subscribe to this publisher from the view models
  @Published var allCoins: [Coin] = []
  
  // required because subscriptions can be cancelled at any time
  // that's why we need to store them - we can use the following to cancel it
  var coinSubscription: AnyCancellable?
  
  
  init() {
    getCoins()
  }
  
  
  func getCoins() {
    
    guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
      return
    }
    
    // this can be sending data over time but the requrest is a simple GET request
    // because we will cancel it at the end to save on memory since it is not a WEB Socket connection
    coinSubscription = NetworkingManager.download(url: url) // our custom download method runs on the back thread and receives on the main thread
      .decode(type: [Coin].self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main) // receive on the main thread, UI updates done on the main thread
      .sink { completion in
        // handles the error state
        NetworkingManager.handleCompletion(completion)
      } receiveValue: { [weak self] (coins) in
        self?.allCoins = coins
        self?.coinSubscription?.cancel() // cancel the subscription after returning the data
      }

  }
}
