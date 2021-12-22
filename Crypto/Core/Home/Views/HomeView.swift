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
  
  @State private var isPortfolioViewDisplayed: Bool = false // new sheet
  
  @State private var isSettingsViewDisplayed: Bool = false // new sheet
  
  
  // navigation variables
  @State private var selectedCoin: Coin? = nil
  @State private var isDetailViewDisplayed: Bool = false
  
  
  var body: some View {
    
    ZStack {
      // background
      Color.theme.background.ignoresSafeArea()
        .sheet(isPresented: $isPortfolioViewDisplayed, onDismiss: {
          isPortfolioViewDisplayed = false
        }, content: {
          EditPortfolioView()
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
            .refreshable {
              viewModel.reloadData()
            }
            .transition(.move(edge: .leading))
        }
        
        if showPortfolio {
          ZStack(alignment: .top) {
            
            if viewModel.portfolioCoins.isEmpty && viewModel.searchText.isEmpty {
              emptyPortfolio
            } else {
              portfolioCoinsList
                .refreshable {
                  viewModel.reloadData()
                }
            }
          }
          .transition(.move(edge: .trailing))
        }
        
        Spacer()
      }
      .sheet(isPresented: $isSettingsViewDisplayed, onDismiss: {
        isSettingsViewDisplayed = false
      }, content: {
        SettingsView()
      })
    }
    .background(
      NavigationLink(destination: DetailLoadingView(coin: $selectedCoin), isActive: $isDetailViewDisplayed, label: { EmptyView() })
    )
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
          } else {
            isSettingsViewDisplayed = true
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
          .onTapGesture {
            lazyNavigate(coin: coin)
          }
      }
    }
    .listStyle(.plain)
  }
  
  private var portfolioCoinsList: some View {
    List {
      ForEach(viewModel.portfolioCoins) { coin in
        CoinRowView(coin: coin, showHoldingsColumn: true)
          .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
          .onTapGesture {
            lazyNavigate(coin: coin)
          }
      }
    }
    .listStyle(.plain)
  }
  
  
  private var columnTitles: some View {
    HStack {
      HStack(spacing: 4) {
        Text("Coin")
        
        Image(systemName: "chevron.down")
          .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0)
          .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))
      }
      .onTapGesture {
        withAnimation(.default) {
          viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
        }
      }
      
      
      Spacer()
      
      if showPortfolio{
        HStack(spacing: 4) {
          Text("Holdings")
          Image(systemName: "chevron.down")
            .opacity((viewModel.sortOption == .holdings || viewModel.sortOption == .holdings) ? 1.0 : 0.0)
            .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
        }
        .onTapGesture {
          withAnimation(.linear(duration: 0.1)) {
            viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
          }
        }
        
      }
      
      HStack(spacing: 4) {
        Text("Price")
        
        Image(systemName: "chevron.down")
          .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1.0 : 0.0)
          .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
      }
      .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing) // make it 1/3.5 th of the screen
      .onTapGesture {
        withAnimation(.default) {
          viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
        }
      }
    }
    .font(.caption)
    .foregroundColor(.theme.secondaryText)
    .padding(.horizontal)
  }
  
  
  private func lazyNavigate(coin: Coin) {
    selectedCoin = coin
    isDetailViewDisplayed.toggle()
  }
  
  
  private var emptyPortfolio: some View {
    Text("You haven't added any coins to your portfolio yet... Click the + button to get started!")
      .font(.callout)
      .foregroundColor(.theme.accent)
      .fontWeight(.medium)
      .multilineTextAlignment(.center)
      .padding(50)
  }
}
