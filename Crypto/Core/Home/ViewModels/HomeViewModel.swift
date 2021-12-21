//
//  HomeViewModel.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
  
  @Published var stats: [Statistic] = []
  
  @Published var allCoins: [Coin] = []
  @Published var portfolioCoins: [Coin] = []
  
  @Published var searchText: String = ""
  
  private let _coinDataService: CoinDataService = CoinDataService()
  private let _marketDataService: MarketDataService = MarketDataService()
  private var _cancellables = Set<AnyCancellable>()
  
  
  init() {
    addSubscribers()
  }
  
  
  func addSubscribers() {
    
    // subscribe to the search text publisher - which returns filtered coins
    // this will update the local allCoins variable
    // if no search text is applied then returns all hte coins
    $searchText
      .combineLatest(_coinDataService.$allCoins) // when either changes it will be published
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // wait 0.5 seconds before running this code
      .map { (text, startingCoins) -> [Coin] in
        return self.filterCoins(searchText: text, coins: startingCoins)
      }
      .sink { [weak self] returnedCoins in
        self?.allCoins = returnedCoins
      }
      .store(in: &_cancellables)
    
    
    // subscribe to the market data service
    _marketDataService.$marketData
      .map { marketData -> [Statistic] in
        return self.mapMarketDataToStatisticArray(marketData: marketData)
      }
      .sink { [weak self] returnedStats in
        self?.stats = returnedStats
      }
      .store(in: &_cancellables)
  }
  
  
  private func mapMarketDataToStatisticArray(marketData: MarketData?) -> [Statistic] {
    var stats: [Statistic] = []
    
    guard let data = marketData else {
      return stats
    }
    
    let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
    let volume = Statistic(title: "24h Volume", value: data.volume)
    let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
    let portfolio = Statistic(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
    
    stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
    
    return stats
  }
  
  
  /// filters coins based on the seearchText passed in
  /// search filter applied based on coin's name, symbol, or id
  private func filterCoins(searchText: String, coins: [Coin]) -> [Coin] {
    guard !searchText.isEmpty else {
      // return all the coins if the search text is empty
      return coins
    }
    
    let lowercasedText = searchText.lowercased()
    
    return coins.filter { coin -> Bool in
      return coin.name.lowercased().contains(lowercasedText) ||
      coin.symbol.lowercased().contains(lowercasedText) ||
      coin.id.lowercased().contains(lowercasedText)
    }
  }
  
}
