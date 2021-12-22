//
//  SettingsView.swift
//  Crypto
//
//  Created by Aybars Acar on 22/12/2021.
//

import SwiftUI


struct SettingsView: View {
  
  @Environment(\.presentationMode) var presentationMode
  
  let defaultURL = URL(string: "https://www.google.com")!
  let youtubeURL = URL(string: "https://www.youtube.com")!
  let github = URL(string: "https://www.github.com/aybarsacar")!
  let coingeckoURL = URL(string: "https://www.coingecko.com")!
  let website = URL(string: "https://www.aybarsacar.dev")!
  
  var body: some View {
    NavigationView {
      List {
        linksSection
        coingeckoSection
        developerSection
        applicationSection
      }
      .listStyle(.grouped)
      .navigationTitle("Settings")
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          XMarkButton {
            presentationMode.wrappedValue.dismiss()
          }
        }
      }
    }
  }
}



struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}


struct SettingsViewLink: View {
  
  let message: String
  let destination: URL
  
  var body: some View {
    HStack {
      Link(message, destination: destination)
        .accentColor(.blue)
      Spacer()
      Image(systemName: "arrow.up.right.square")
        .foregroundColor(.blue)
    }
    .font(.headline)
  }
}


extension SettingsView {
  
  private var linksSection: some View {
    Section(header: Text("Social Media")) {
      VStack(alignment: .leading) {
        Image("logo")
          .resizable()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        
        Text("This app uses MVVM architecture, Combine to fetch data, and CoreData!")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.theme.accent)
      }
      .padding(.vertical)
      
      SettingsViewLink(message: "Find us on Google", destination: defaultURL)
      SettingsViewLink(message: "Watch us on Youtube", destination: youtubeURL)
      
    }
  }
  
  private var coingeckoSection: some View {
    Section(header: Text("Coin Gecko")) {
      VStack(alignment: .leading) {
        Image("coingecko")
          .resizable()
          .scaledToFit()
          .frame(height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        
        Text("The Crypocurrency data that is used in this app comes from a free API from CoinGecko! Price updates may be slightly delayed.")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.theme.accent)
      }
      .padding(.vertical)
      
      SettingsViewLink(message: "Visit CoinGecko", destination: coingeckoURL)
    }
  }
  
  private var developerSection: some View {
    Section(header: Text("Developer")) {
      VStack(alignment: .leading) {
        Image("logo")
          .resizable()
          .frame(width: 100, height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 20))
        
        Text("This app is developed by Aybars Acar. It uses SwiftUI as the view framework")
          .font(.callout)
          .fontWeight(.medium)
          .foregroundColor(.theme.accent)
      }
      .padding(.vertical)
      
      SettingsViewLink(message: "Website", destination: website)
      SettingsViewLink(message: "Github", destination: github)
    }
  }
  
  private var applicationSection: some View {
    Section(header: Text("Application")) {
      SettingsViewLink(message: "Terms of Service", destination: defaultURL)
      SettingsViewLink(message: "Privacy Policy", destination: defaultURL)
      SettingsViewLink(message: "Company Website", destination: defaultURL)
      SettingsViewLink(message: "Learn More", destination: defaultURL)
    }
  }
  
}
