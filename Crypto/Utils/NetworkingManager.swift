//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import Foundation
import Combine


class NetworkingManager {
  
  enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
      switch self {
      case .badURLResponse(url: let url):
        return "Bad response from URL: \(url)"
      case .unknown:
        return "Unexpected error ocurred"
      }
    }
  }
  
  static func download(url: URL) -> AnyPublisher<Data, Error> {
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .subscribe(on: DispatchQueue.global(qos: .default)) // make sure to be on the background thread
      .tryMap({ try handleURLResponse(output: $0, url: url)})
      .receive(on: DispatchQueue.main) // receive on the main thread
      .eraseToAnyPublisher() // takes the publishers and converts into an AnyPublisher<Data, Error>
  }
  
  
  static func handleCompletion(_ completion: Subscribers.Completion<Error>) {
    switch completion {
    case .finished:
      break
    case .failure(let error):
      print(error.localizedDescription)
    }
  }
  
  
  static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
    guard let response = output.response as? HTTPURLResponse,
          response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
          }
    
    return output.data
  }
}
