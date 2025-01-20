//
//  PortfolioView.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 4/11/22.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var vm : HomeViewModel
    
    @State private var selectedCoin: CoinModel? = nil
    
    @State private var text: String = ""
    
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment:.leading,spacing: 0){
                    SearchBarView(searchText: $vm.searchBarTextFilter)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                    
                }
            }
            .background(
                Color.theme.background
                    .ignoresSafeArea()
            )
            .navigationTitle("Edit porfolio")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    XmarkButton(action: { dismiss() })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButton
                }
            }
            .onChange(of: vm.searchBarTextFilter) { newValue in
                if newValue == ""{
                    removeSelectedCoin()
                }
            }
        }
    }
}

extension PortfolioView{
    private var coinLogoList: some View{
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack(spacing: 10){
                ForEach(vm.searchBarTextFilter.isEmpty ? vm.portFolio : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding()
                        .onTapGesture(perform: {selectCoin(coin)})
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ?
                                    Color.theme.green :
                                        Color.clear,
                                    lineWidth: 1
                                )
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    private var portfolioInputSection: some View{
        VStack(spacing: 20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()
            HStack{
                Text("Amount holdings:")
                Spacer()
                TextField("Ex: 1.4", text: $text)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none,value: UUID())
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButton: some View{
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button {
                saveButtonPressed()
            } label: {
                Text("save".uppercased())
            }
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(text)) ?
                1.0 : 0.0
            )
            
        }
        .font(.headline)
    }
    
}

extension PortfolioView{
    func selectCoin(_ coin: CoinModel){
        withAnimation {
            selectedCoin = coin
            updateSelectedIcon(coin: coin)
        }
    }
    
    func updateSelectedIcon(coin: CoinModel){
        if let portfolioCoin = vm.portFolio.first(where: {$0.id == coin.id}),
           let amount = portfolioCoin.currentHoldings{
            text = "\(amount)"
        }else{
            text = ""
        }
    }
    
    func getCurrentValue()->Double{
        if let quantity = Double(text){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    func saveButtonPressed(){
        guard
            let coin =  selectedCoin,
            let amount = Double(text) else {
            return
        }
        
        // Save to portfolio
        vm.updatePortFolio(coin: coin, amount:amount )
        
        // show checkmark
        withAnimation {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        // Hide Keyboard
        UIApplication.shared.endEditing()
        
        // Hide checkMArk
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            withAnimation(.easeOut){
                self.showCheckMark = false
            }
        }
        
    }
    
    func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchBarTextFilter = ""
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}
