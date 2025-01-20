//
//  SettingsView.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 21/11/22.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string:"https://www.google.com")!
    let youtubeURL = URL(string:"https://www.youtube.com/c/swiftfulthinking")!
    let coffeEURL = URL(string:"https://www.buymeacoffe.com/nicksarno")!
    let coinGeckoURL = URL(string:"https://www.coingecko.com")!
    let personalURL = URL(string:"https://www.nicksarno.com")!
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            
            ZStack{
                
                Color.theme.background
                    .ignoresSafeArea()
                
                List {
                    swiftfukThingkinSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    coinGeckoLogoSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                    developerSection
                        .listRowBackground(Color.theme.background.opacity(0.5))
                }
                .font(.headline)
                .tint(.blue)
                .listStyle(.grouped)
                .navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        XmarkButton { self.dismiss() }
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

extension SettingsView{
    
    private var swiftfukThingkinSection: some View{
        Section{
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a @SwiftfulThinking course on Youtube. It uses MVVM architecture, Combine,  and CoreData!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Subscribe on Youtube 🥳", destination: youtubeURL)
            Link("Support his coffee addiction ☕️", destination: coffeEURL)
            
        } header: {
            Text("Swiftful Thinking")
        }
    }
    
    private var coinGeckoLogoSection: some View{
        Section{
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Visit Coingecko", destination: coinGeckoURL)
            
        } header: {
            Text("CoinGecko")
        }
    }
    
    private var developerSection: some View{
        Section{
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Jean Carlos. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading. Publishers/suscribers, and Data Persistence.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Cool", destination: defaultURL)
            
        } header: {
            Text("Developer")
        }
    }
    
}
