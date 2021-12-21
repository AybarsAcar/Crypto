//
//  CoinImageViewModel.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import Foundation
import SwiftUI
import Combine


class CoinImageViewModel: ObservableObject {
  
  @Published var image: UIImage? = nil
  @Published var isLoading: Bool = false
  
  private let _coin: Coin
  private let _dataService: CoinImageService
  
  private var _cancellables = Set<AnyCancellable>()
  
  
  init(coin: Coin) {
    _coin = coin
    _dataService = CoinImageService(coin: coin)
    
    addSubscribers()
    self.isLoading = true
  }
  

  private func addSubscribers() {
    // subscribe to the published image from the CoinImageService
    _dataService.$image
      .sink { [weak self] _ in
        self?.isLoading = false
      } receiveValue: { [weak self] returnedImage in
        self?.image = returnedImage
      }
      .store(in: &_cancellables)
  }
}
