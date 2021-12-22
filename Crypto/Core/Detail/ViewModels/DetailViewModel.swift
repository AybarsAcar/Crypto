//
//  DetailViewModel.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import Foundation
import Combine


class DetailViewModel: ObservableObject {
  
  @Published var overviewStatistics: [Statistic] = []
  @Published var additionalStatistics: [Statistic] = []
  @Published var coin: Coin
  @Published var coinDescription: String? = nil
  @Published var websiteURL: String? = nil
  @Published var redditURL: String? = nil

  
  private let _coinDetailDataService: CoinDetailDataService
  private var _cancellables = Set<AnyCancellable>()
  
  
  init(coin: Coin) {
    self.coin = coin
    _coinDetailDataService = CoinDetailDataService(coin: coin)
    
    self.addSubscribers()
  }
  
  
  private func addSubscribers() {
    
    _coinDetailDataService.$coinDetail
      .combineLatest($coin)
      .map(mapDataToStatistics)
      .sink { [weak self] returnedArrays in
        self?.overviewStatistics = returnedArrays.overview
        self?.additionalStatistics = returnedArrays.additional
      }
      .store(in: &_cancellables)
    
    
    _coinDetailDataService.$coinDetail
      .sink { [weak self] returnedCoinDetails in
        self?.coinDescription = returnedCoinDetails?.readableDescription
        self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
        self?.redditURL = returnedCoinDetails?.links?.subredditURL
      }
      .store(in: &_cancellables)
  }
  
  
  private func mapDataToStatistics(coinDetailModel: CoinDetail?, coinModel: Coin) -> (overview: [Statistic], additional: [Statistic]) {
    
    return (createOverviewArray(coinModel: coinModel), createAdditionalArray(coinModel: coinModel, coinDetailModel: coinDetailModel))
  }
  
  
  func createOverviewArray(coinModel: Coin) -> [Statistic] {
    let price = coinModel.currentPrice.asCurrencyWith6Decimals()
    let pricePercentChange = coinModel.priceChangePercentage24H
    let priceStat = Statistic(title: "Current Price", value: price, percentageChange: pricePercentChange)
    
    let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "0.00")
    let marketCapPercentChange = coinModel.marketCapChangePercentage24H
    let marketCapStat = Statistic(title: "Market Capitalisation", value: marketCap, percentageChange: marketCapPercentChange)
    
    let rank = "\(coinModel.rank)"
    let rankStat = Statistic(title: "Rank", value: rank)
    
    let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "0.00")
    let volumeStat = Statistic(title: "Volume", value: volume)
    
    return [priceStat, marketCapStat, rankStat, volumeStat]
  }
  
  
  func createAdditionalArray(coinModel: Coin, coinDetailModel: CoinDetail?) -> [Statistic] {
    let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
    let highStat = Statistic(title: "24h High", value: high)
    
    let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
    let lowStat = Statistic(title: "24h Low", value: low)
    
    let priceChange = coinModel.priceChangePercentage24H?.asCurrencyWith6Decimals() ?? "n/a"
    let pricePercentChange2 = coinModel.priceChangePercentage24H
    let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
    
    let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
    let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
    let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
    
    let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
    let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
    let blockStat = Statistic(title: "Block Time", value: blockTimeString)
    
    let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
    let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
    
    return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
  }
}
