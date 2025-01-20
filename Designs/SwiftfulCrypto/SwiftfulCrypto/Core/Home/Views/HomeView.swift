//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 3/11/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    
    @State private var showPortfolio: Bool = false
    
    @State private var showPortfolioView: Bool = false
    
    @State private var showSettingsView: Bool = false
    
    @State private var selectedCoin: CoinModel? = nil
    
    @State private var showDetailCoin: Bool = false
    
    var body: some View {
        ZStack{
            Color.theme.background // Backgrounud layer
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            VStack{
                homeHeader
                
                HomeStatsView(showPortFolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchBarTextFilter)
                
                columnsTitle
                
                if !showPortfolio{
                    allCoinsList
                }else{
                    portFolioCoinsList
                }
                
                
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailCoin,
                label: { EmptyView() }
            )
        )
    }
    
    
    private func switchPortFolio(){
        withAnimation(.spring()){
            showPortfolio.toggle()
        }
    }
    
    private func getChevronAngle()->Angle{
        Angle(degrees: showPortfolio ? 180 : 0)
    }
    
}

// Supporting Views
extension HomeView{
    private var homeHeader: some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none,value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }else{
                        showSettingsView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            
            Spacer()
            if vm.isDownloadingData{
                LoadingView()
            }else{
                Text(showPortfolio ? "Portfolio" : "Live Prices")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.theme.accent)
                    .animation(.none,value: showPortfolio)
            }
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(getChevronAngle())
                .onTapGesture(perform: switchPortFolio)
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View{
        List{
            ForEach(vm.allCoins) { coin in
                CoinRowView(
                    coin: coin,
                    showHoldingColumns: false
                )
                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                .onTapGesture {
                    selectedCoin = coin
                    showDetailCoin.toggle()
                }
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
        .transition(.move(edge: .leading))
    }
    
    private var portFolioCoinsList: some View{
        List{
            ForEach(vm.portFolio) { coin in
                CoinRowView(
                    coin: coin,
                    showHoldingColumns: true
                )
                .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
        .transition(.move(edge: .trailing))
    }
    
    private var columnsTitle: some View{
        HStack{
            HStack(spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1.0 : 0.0)
                    .rotationEffect(
                        Angle(degrees: vm.sortOption == .rank ? 0 : 180)
                    )
                
            }
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio{
                HStack(spacing: 4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1.0 : 0.0)
                        .rotationEffect(
                            Angle(degrees: vm.sortOption == .holdings ? 0 : 180)
                        )
                }
                .onTapGesture {
                    withAnimation(.default){
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .price || vm.sortOption == .pricReverse ? 1.0 : 0.0)
                    .rotationEffect(
                        Angle(degrees: vm.sortOption == .price ? 0 : 180)
                    )
            }
            .frame(width: UIScreen.main.bounds.width / 3.5,alignment: .trailing)
            .onTapGesture {
                withAnimation(.default){
                    vm.sortOption = vm.sortOption == .price ? .pricReverse : .price
                }  
            }
            
            
            Button {
                withAnimation(.linear(duration: 2.0)){
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
                    .rotationEffect(
                        Angle(degrees: vm.isLoading ? 360 : 0),
                        anchor: .center
                    )
            }
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}
