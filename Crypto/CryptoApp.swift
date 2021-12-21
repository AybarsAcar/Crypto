//
//  CryptoApp.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import SwiftUI

@main
struct CryptoApp: App {
  
  @StateObject private var viewModel = HomeViewModel()
  
  init() {
    // override the navigation bar titles
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationView {
        HomeView()
          .navigationBarHidden(true) // to prevent the default navigation bar
      }
      .environmentObject(viewModel) // all the children will have access to this viewModel
    }
  }
}
