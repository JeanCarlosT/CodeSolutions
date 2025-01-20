//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 18/11/22.
//

import SwiftUI

struct DetailLoadingView: View{
    
    @Binding var coin: CoinModel?
    
    init(coin: Binding<CoinModel?>) {
        self._coin = coin
    }
    
    var body: some View{
        ZStack{
            if let coin = coin{
                DetailView(coin: coin)
            }
        }
    }
    
    
}

struct DetailView: View {
    
    @StateObject var vm: DetailViewModel
    
    @State private var showFullDescription: Bool = false
    
    init(coin: CoinModel) {
        self._vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("Initializing Detail View For \(coin.name)")
    }
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let spacing: CGFloat = 30
    
    var body: some View {
        ScrollView{
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20){
                    overViewTitle
                    Divider()
                    descriptionSection
                    overViewLazygrid
                    additionalViewTitle
                    Divider()
                    additionalLazygrid
                    websiteSection
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .navigationBarTitleDisplayMode(.automatic)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                coinLogo
            }
            
            ToolbarItem(placement: .principal) {
                if vm.isLoading{
                    LoadingView()
                }
            }
            
        }
    }
    
}


extension DetailView{
    
    private var websiteSection: some View{
        VStack(alignment: .leading, spacing: 20){
            if let website = vm.websiteUrl,
               let url = URL(string: website){
                Link("Website", destination: url)
            }
            
            if let redditString = vm.redditURL,
               let url = URL(string: redditString){
                Link("Reddit", destination: url)
            }
            
        }
        .tint(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection: some View{
        ZStack{
            if let coinDescription = vm.coinDescription,
               !coinDescription.isEmpty{
            
                VStack(alignment:.leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical,4)
                    }
                    .tint(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var coinLogo:some View{
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overViewTitle: some View{
        Text("OverView")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var overViewLazygrid: some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []
        ) {
            ForEach(vm.overviewStatistics) { stat in
                StatisticView(statisticModel: stat)
            }
        }
    }
    
    private var additionalViewTitle: some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var additionalLazygrid: some View{
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []
        ) {
            ForEach(vm.additionalStatistics) { stat in
                StatisticView(statisticModel:stat)
            }
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}
