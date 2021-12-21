//
//  CoinImageService.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import Foundation
import SwiftUI
import Combine


class CoinImageService {
  
  @Published var image: UIImage? = nil
  
  private var imageSubscription: AnyCancellable?

  private let _coin: Coin
  private let _fileManager = LocalFileManager.shared
  private let _folderName = "coin_images"
  private let _imageName: String
  
  init (coin: Coin) {
    _coin = coin
    _imageName = coin.id
    
    getCoinImage()
  }
  
  
  private func getCoinImage() {
    if let savedImage = _fileManager.getImage(imageName: _imageName, folderName: _folderName) {
      // if successful - retrieved image from the file manager
      image = savedImage
    } else {
      // image is not available in the File system of our device
      // so download from the API
      downloadCoinImage()
    }
  }
  
  
  private func downloadCoinImage() {
    
    guard let url = URL(string: _coin.image) else {
      return
    }
    
    // this can be sending data over time but the requrest is a simple GET request
    // because we will cancel it at the end to save on memory since it is not a WEB Socket connection
    imageSubscription = NetworkingManager.download(url: url) // our custom download method runs on the back thread and receives on the main thread
      .tryMap({ (data) -> UIImage? in
        return UIImage(data: data)
      })
      .sink { completion in
        // handles the error state
        NetworkingManager.handleCompletion(completion)
      } receiveValue: { [weak self] (returnedImage) in
        
        guard let self = self, let downloadedImage = returnedImage else { return }
        
        self.image = downloadedImage
        self.imageSubscription?.cancel() // cancel the subscription after returning the data
        self._fileManager.saveImage(image: downloadedImage, imageName: self._imageName, folderName: self._folderName)
      }
    
  }
}
