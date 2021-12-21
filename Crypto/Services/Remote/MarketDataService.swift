//
//  MarketDataService.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import Foundation
import Combine


/// Repository
class MarketDataService {
  
  // we will subscribe to this publisher from the view models
  @Published var marketData: MarketData? = nil
  
  // required because subscriptions can be cancelled at any time
  // that's why we need to store them - we can use the following to cancel it
  var marketDataSubscription: AnyCancellable?
  
  
  init() {
    getData()
  }
  
  
  func getData() {
    
    guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else {
      return
    }
    
    // this can be sending data over time but the requrest is a simple GET request
    // because we will cancel it at the end to save on memory since it is not a WEB Socket connection
    marketDataSubscription = NetworkingManager.download(url: url) // our custom download method runs on the back thread and receives on the main thread
      .decode(type: GlobalData.self, decoder: JSONDecoder())
      .sink { completion in
        // handles the error state
        NetworkingManager.handleCompletion(completion)
      } receiveValue: { [weak self] returnedGlobalData in
        self?.marketData = returnedGlobalData.data
        self?.marketDataSubscription?.cancel() // cancel the subscription after returning the data
      }

  }
}
