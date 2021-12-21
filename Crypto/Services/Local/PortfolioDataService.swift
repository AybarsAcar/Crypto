//
//  PortfolioDataService.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import Foundation
import CoreData


class PortfolioDataService {
  
  @Published var savedEntities: [PortfolioItem] = []
  
  private let _container: NSPersistentContainer
  private let _containerName: String = "PortfolioContainer"
  private let _entityName: String = "PortfolioItem"
  
  init() {
    _container = NSPersistentContainer(name: _containerName)
    _container.loadPersistentStores { _, error in
      if let error = error {
        print("Error loading Core Data:\n\(error)")
      }
      
      // fetch all the portfolios
      self.getPortfolio()
    }
  }
  
  
  func updatePortfolio(coin: Coin, amount: Double) {
    
    // check if the coin already exists in the db
    if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
      
      if amount > 0 {
        update(entity: entity, amount: amount)
      } else {
        delete(entity: entity)
      }
    } else {
      // new entity
      add(coin: coin, amount: amount)
    }
  }
  
  
  private func getPortfolio() {
    let request = NSFetchRequest<PortfolioItem>(entityName: _entityName)
    
    do {
      savedEntities = try _container.viewContext.fetch(request)
      
    } catch {
      print("Error fetching portfolio items:\n\(error)")
    }
  }
  
  
  private func add(coin: Coin, amount: Double) {
    
    // convert coin model to our portfolio item entity
    let entity = PortfolioItem(context: _container.viewContext)
    entity.coinID = coin.id
    entity.amount = amount
    
    // save the context to update the core data
    // we refetch the coins agains - alternatively we can mutate the cached published variable from here
    applyChanges()
  }
  
  
  private func update(entity: PortfolioItem, amount: Double) {
    entity.amount = amount
    applyChanges()
  }
  
  
  private func delete(entity: PortfolioItem) {
    _container.viewContext.delete(entity)
    applyChanges()
  }
  
  
  private func save() {
    
    do {
      try _container.viewContext.save()
    } catch {
      print("Error saving changes to Core Data:\n\(error)")
    }
  }
  
  
  private func applyChanges() {
    save()
    getPortfolio()
  }
}
