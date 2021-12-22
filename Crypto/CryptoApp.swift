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
  
  @State private var showLaunchView: Bool = true
  
  init() {
    // override the navigation bar titles
    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    UINavigationBar.appearance().tintColor = UIColor(.theme.accent)
    
    // make the table views background clear by default - i.e. List Component
    UITableView.appearance().backgroundColor = UIColor.clear
  }
  
  var body: some Scene {
    WindowGroup {
      
      ZStack {
        NavigationView {
          HomeView()
            .navigationBarHidden(true) // to prevent the default navigation bar
        }
        .navigationViewStyle(.stack)
        .environmentObject(viewModel) // all the children will have access to this viewModel
        
        ZStack {
          // Launch View should appear on the home view
          if showLaunchView {
            LaunchView(showLaunchView: $showLaunchView)
              .transition(.move(edge: .leading))
          }
        }
        .zIndex(2.0)
        
      }
    }
  }
}
