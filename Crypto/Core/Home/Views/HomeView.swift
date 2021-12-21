//
//  HomeView.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import SwiftUI


struct HomeView: View {
  
  @EnvironmentObject private var viewModel: HomeViewModel
  
  @State private var showPortfolio: Bool = false
  
  @State private var isPortfolioViewDisplayed: Bool = false
  
  var body: some View {
    
    ZStack {
      // background
      Color.theme.background.ignoresSafeArea()
        .sheet(isPresented: $isPortfolioViewDisplayed, onDismiss: {
          isPortfolioViewDisplayed = false
        }, content: {
          PortfolioView()
            .environmentObject(viewModel)
        })
      
      // content layer
      VStack {
        
        homeHeader
        
        HomeStatsView(showPortfolio: $showPortfolio)
        
        SearchBarView(searchText: $viewModel.searchText)
        
        columnTitles
        
        if !showPortfolio {
          allCoinsList
            .transition(.move(edge: .leading))
        }
        
        if showPortfolio {
          portfolioCoinsList
            .transition(.move(edge: .trailing))
        }
        
        Spacer()
      }
    }
  }
}



struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      HomeView()
        .navigationBarHidden(true)
    }
    .environmentObject(dev.homeViewModel)
  }
}


extension HomeView {
  
  private var homeHeader: some View {
    HStack {
      CircleButtonView(iconName: showPortfolio ? "plus" : "info")
        .animation(.none, value: showPortfolio)
        .onTapGesture {
          if showPortfolio {
            isPortfolioViewDisplayed = true
          }
        }
        .background(
          CircleButtonAnimationView(animate: $showPortfolio)
        )
      
      Spacer()
      
      Text(showPortfolio ? "Portfolio" : "Live Prices")
        .fontWeight(.heavy)
        .font(.headline)
        .foregroundColor(.theme.accent)
        .animation(.none, value: showPortfolio)
      
      Spacer()
      
      CircleButtonView(iconName: "chevron.right")
        .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
        .onTapGesture {
          withAnimation(.spring()) {
            showPortfolio.toggle()
          }
        }
    }
    .padding(.horizontal)
  }
  
  
  private var allCoinsList: some View {
    List {
      ForEach(viewModel.allCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: false)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
      }
    }
    .listStyle(.plain)
  }
  
  private var portfolioCoinsList: some View {
    List {
      ForEach(viewModel.portfolioCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: true)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
      }
    }
    .listStyle(.plain)
  }
 
  
  private var columnTitles: some View {
    HStack {
      Text("Coin")
      Spacer()
      
      if showPortfolio{
        Text("Holdings")
      }
      
      Text("Price")
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing) // make it 1/3.5 th of the screen
    }
    .font(.caption)
    .foregroundColor(.theme.secondaryText)
    .padding(.horizontal)
  }
}
