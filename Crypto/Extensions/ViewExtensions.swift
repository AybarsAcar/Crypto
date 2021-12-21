//
//  ViewExtensions.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import Foundation
import SwiftUI


extension View {
  
  /// extention to navigate in a lazy way
  /// because default NavigationLink renders all the visible Links prior to navigaion which may end up with wasted CPU usage
  /// ```
  /// SomeView()
  ///   .navigate(using: $selectedCoin, destination: CoinDetailView)
  /// ```
  @ViewBuilder
  func navigate<Value, Destination: View>(
    using binding: Binding<Value?>,
    @ViewBuilder destination: (Value) -> Destination
  ) -> some View {
    background(NavigationLink(binding, destination: destination))
  }
}


extension NavigationLink where Label == EmptyView {
  init?<Value>(
    _ binding: Binding<Value?>,
    @ViewBuilder destination: (Value) -> Destination
  ) {
    guard let value = binding.wrappedValue else {
      return nil
    }
    
    let isActive = Binding(
      get: { true },
      set: { newValue in if !newValue { binding.wrappedValue = nil } }
    )
    
    self.init(destination: destination(value), isActive: isActive, label: EmptyView.init)
  }
}
