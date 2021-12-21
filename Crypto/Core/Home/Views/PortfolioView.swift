//
//  PortfolioView.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import SwiftUI


struct PortfolioView: View {
  
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject private var viewModel: HomeViewModel
  
  @State private var selectedCoin: Coin? = nil
  @State private var quantityText: String = ""
  @State private var showCheckmark: Bool = false
  
  
  var body: some View {
    
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 0) {
          
          SearchBarView(searchText: $viewModel.searchText)
          
          coinLogoList
          
          if selectedCoin != nil {
            portfolioInputSection
          }
        }
      }
      .navigationTitle("Edit Portfolio")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          XMarkButton {
            presentationMode.wrappedValue.dismiss()
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          trailingNavBarButtons
        }
      }
    }
  }
}



struct PortfolioView_Previews: PreviewProvider {
  static var previews: some View {
    PortfolioView()
      .environmentObject(dev.homeViewModel)
  }
}


extension PortfolioView {
  
  private var coinLogoList: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 10) {
        ForEach(viewModel.allCoins) { coin in
          CoinLogoView(coin: coin)
            .frame(width: 75)
            .padding(4)
            .onTapGesture {
              withAnimation(.easeIn(duration: 0.2)) {
                selectedCoin = coin
              }
            }
            .background(
              RoundedRectangle(cornerRadius: 10)
                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear, lineWidth: 1)
            )
        }
      }
      .frame(height: 120)
      .padding(.leading)
    }
  }
  
  private var portfolioInputSection: some View {
    VStack(spacing: 20) {
      HStack {
        Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
        Spacer()
        Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
      }
      
      Divider()
      
      HStack {
        Text("Amount holding:")
        Spacer()
        TextField("Ex: 1.4", text: $quantityText)
          .multilineTextAlignment(.trailing)
          .keyboardType(.decimalPad)
      }
      
      Divider()
      
      HStack {
        Text("Current value:")
        Spacer()
        Text(getCurrentValue().asCurrencyWith2Decimals())
      }
    }
    .animation(.none)
    .padding()
    .font(.headline)
  }
  
  
  private var trailingNavBarButtons: some View {
    HStack(spacing: 10) {
      Image(systemName: "checkmark")
        .opacity(showCheckmark ? 1.0 : 0.0)
      
      Button(action: {
        saveButtonPressed()
      }, label: {
        Text("Save".uppercased())
      })
        .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)
    }
    .font(.headline)
  }
  
  
  private func getCurrentValue() -> Double {
    if let quantity = Double(quantityText) {
      return quantity * (selectedCoin?.currentPrice ?? 0)
    }
    return 0
  }
  
  
  private func saveButtonPressed() {
    
    guard let coin = selectedCoin else { return }
    
    // save to portfolio
    
    // show teh checkmark
    withAnimation(.easeIn) {
      showCheckmark = true
      removeSelectedCoind()
    }
    
    // hide keyboard
    UIApplication.shared.endEditing()
    
    // hide checkmark
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      showCheckmark = false
    }
  }
  
  private func removeSelectedCoind() {
    
    selectedCoin = nil
    viewModel.searchText = ""
  }
}
