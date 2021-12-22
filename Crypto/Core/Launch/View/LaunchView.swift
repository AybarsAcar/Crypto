//
//  LaunchView.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import SwiftUI


struct LaunchView: View {
  
  @State private var loadingText: [String] = "Loading you portfolio...".map { String($0) }
  @State private var showLoadingText: Bool = false
  @State private var counter: Int = 0
  @State private var loops: Int = 0
  
  @Binding var showLaunchView: Bool
  
  private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  
  var body: some View {
    
    ZStack {
      // background layer
      Color.launchTheme.background
        .ignoresSafeArea()
      
      Image("logo-transparent")
        .resizable()
        .frame(width: 100, height: 100, alignment: .center)
      
      ZStack {
        if showLoadingText {
          HStack(spacing: 0) {
            ForEach(loadingText.indices) { i in
              Text(loadingText[i])
                .font(.headline)
                .foregroundColor(.launchTheme.accent)
                .fontWeight(.heavy)
                .offset(y: counter == i  ? -5 : 0)
            }
          }
          .transition(.scale.animation(.easeIn))
        }
      }
      .offset(y: 70)
    }
    .onAppear {
      showLoadingText.toggle()
    }
    .onReceive(timer) { _ in
      withAnimation(.spring()) {
        
        if counter == loadingText.count {
          loops += 1
          counter = 0
          
          if loops >= 2 {
            showLaunchView = false
          }
          
        } else {
          counter += 1
        }
      }
    }
  }
}



struct LaunchView_Previews: PreviewProvider {
  static var previews: some View {
    LaunchView(showLaunchView: .constant(true))
  }
}
