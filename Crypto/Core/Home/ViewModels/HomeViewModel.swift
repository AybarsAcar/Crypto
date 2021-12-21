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
  
  @Published var isloading: Bool = false
  
  @Published var sortOption: SortOption = .holdings
  
  
  private let _coinDataService: CoinDataService = CoinDataService()
  private let _marketDataService: MarketDataService = MarketDataService()
  private let _portfolioDataService: PortfolioDataService = PortfolioDataService()
  private var _cancellables = Set<AnyCancellable>()
  
  
  enum SortOption {
    case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
  }
  
  
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
    
    
    // subscribe to the portfolio data service publisher which updates local portfolioCoins
    // we will combine it with the allCoins to get the coin models - updated info on the coins
    // subscribe to the filtered all coins so our portfolio filters as well
    $allCoins
      .combineLatest(_portfolioDataService.$savedEntities)
      .map { (coins, portfolioItems) -> [Coin] in
        return self.mapAllCoinsToPortfolioCoins(coins: coins, portfolioItems: portfolioItems)
      }
      .sink { [weak self] returnedCoins in
        self?.portfolioCoins = returnedCoins
      }
      .store(in: &_cancellables)
    
    
    // subscribe to the market data service
    _marketDataService.$marketData
      .combineLatest($portfolioCoins)
      .map { (marketData, porfolioCoinItems) -> [Statistic] in
        return self.mapMarketDataToStatisticArray(marketData: marketData, coinsInPortfolio: porfolioCoinItems)
      }
      .sink { [weak self] returnedStats in
        self?.stats = returnedStats
        self?.isloading = false // set isLoading to false after refetching data
      }
      .store(in: &_cancellables)
    
  }
  
  
  func updatePortfolio(coin: Coin, amount: Double) {
    _portfolioDataService.updatePortfolio(coin: coin, amount: amount)
  }
  
  
  /// function to reload all the data coming from the API
  func reloadData() {
    isloading = true
    
    _coinDataService.getCoins()
    _marketDataService.getData()
    
    HapticManager.notification(type: .success) // give haptic feedback
  }
  
  
  private func mapAllCoinsToPortfolioCoins(coins: [Coin], portfolioItems: [PortfolioItem]) -> [Coin] {
    coins.compactMap { coin -> Coin? in
      guard let entity = portfolioItems.first(where: { $0.coinID == coin.id })  else {
        return nil
      }
      
      return coin.updateHoldings(amount: entity.amount) // return as a Coin Model
    }
  }
  
  
  private func mapMarketDataToStatisticArray(marketData: MarketData?, coinsInPortfolio: [Coin]) -> [Statistic] {
    var stats: [Statistic] = []
    
    guard let data = marketData else {
      return stats
    }
    
    let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
    let volume = Statistic(title: "24h Volume", value: data.volume)
    let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
    
    let portfolioValue = coinsInPortfolio
      .map { $0.totalCurrentHoldingsValue }
      .reduce(0, +)
    
    let portfolioValue24HAgo = coinsInPortfolio.map { coin -> Double in
      let currentValue = coin.totalCurrentHoldingsValue
      
      // 25% -> returns as 25 -> make it 0.25
      let percentChange = coin.priceChangePercentage24H! / 100
      
      let previousValue = currentValue / (1 + percentChange)
      
      return previousValue
    }
      .reduce(0, +)
    
    let percentChange24H = ((portfolioValue - portfolioValue24HAgo) / portfolioValue24HAgo) * 100
    
    
    let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentChange24H)
    
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
