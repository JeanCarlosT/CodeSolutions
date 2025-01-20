//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 3/11/22.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    @State private var showLaunchView: Bool = true
    
    init(){
        UINavigationBar.appearance()
            .largeTitleTextAttributes = [
                .foregroundColor: UIColor(Color.theme.accent)
            ]
        
        UINavigationBar.appearance()
            .titleTextAttributes = [
                .foregroundColor: UIColor(Color.theme.accent)
            ]
        
        UITableView.appearance().backgroundColor = UIColor.clear
            
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                if #available(iOS 16.0, *) {
                    NavigationStack{
                        HomeView()
                            .toolbar(.hidden, for: .navigationBar)
                    }
                    .environmentObject(vm)
                } else {
                    NavigationView{
                        HomeView()
                            .navigationBarHidden(true)
                    }
                    .environmentObject(vm)
                }
                
                ZStack{
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
