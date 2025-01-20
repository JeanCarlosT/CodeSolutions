//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 3/11/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject{
    
    init(){
        addSubcribers()
    }
    
    enum SortOption{
        case rank, rankReversed, holdings,holdingsReversed, price, pricReverse
    }
    
    @Published var allCoins: [CoinModel] = []
    
    @Published var portFolio: [CoinModel] = []
    
    @Published var isDownloadingData: Bool = false
    
    @Published var searchBarTextFilter: String = ""
    
    @Published var isLoading: Bool = false
    
    @Published var sortOption: SortOption = .holdings
    
    private var cancellables = Set<AnyCancellable>()
    
    private let coinDataService = CoinDataService()
    
    private let porfolioDataService = PortfolioDataService()
    
    private let marketDataService = MarketDataService()
    
    @Published var statisticModels:[StatisticModel] = [ ]
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    func addSubcribers(){
        coinDataService.$isDownloadingData
            .assign(to: \.isDownloadingData, on: self)
            .store(in: &cancellables)
        
        $searchBarTextFilter
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoin)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        
        marketDataService.$marketDataModel
            .combineLatest($portFolio)
            .map(mapMarket)
            .sink { [weak self] statistics in
                self?.statisticModels = statistics
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        porfolioDataService.$savedEntity
            .combineLatest($allCoins)
            .map { (portfolioEntities,coins) -> [CoinModel] in
                coins
                    .compactMap { coin -> CoinModel? in
                        guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id }) else { return nil }
                        
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] returnedCoins in
                guard let self = self else { return }
                self.portFolio = self.sortPortfolioCoinsIFNeed(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
    }
    
    func updatePortFolio(coin: CoinModel, amount: Double){
        porfolioDataService.updatePortFolio(coin: coin, amount: amount)
    }
    
    func filterAndSortCoin(text:String,coins:[CoinModel],sort: SortOption)->[CoinModel]{
        var updatedCoins = filterMapCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    
    func filterMapCoins(text:String,coins:[CoinModel])->[CoinModel]{
        /// Validamos si hay un text filtrado
        guard !text.isEmpty else{ return coins }
        
        let lowerCasedText = text.lowercased()
        
        return coins.filter { coinModel in
            return coinModel.name.lowercased().contains(lowerCasedText) ||
            coinModel.symbol.lowercased().contains(lowerCasedText) ||
            coinModel.id.lowercased().contains(lowerCasedText)
        }
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel]){
        switch sort{
        case .rank,.holdings,.holdingsReversed:
            coins.sort(by: {$0.rank < $1.rank })
        case .rankReversed:
            coins.sort(by: {$0.rank > $1.rank })
        case .price:
            coins.sort(by: {$0.currentPrice < $1.currentPrice })
        case .pricReverse:
            coins.sort(by: {$0.currentPrice > $1.currentPrice })
        }
    }
    
    private func sortPortfolioCoinsIFNeed(coins: [CoinModel])->[CoinModel]{
        switch sortOption{
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
            
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default:
            return coins
        }
    }
    
    func mapMarket(marketModel: MarketDataModel?,portfolioCoins:[CoinModel])->[StatisticModel]{
        
        var stats = [StatisticModel]()
        
        guard let data = marketModel else{
            return stats
        }
        
        let marketCap = StatisticModel(
            title: "Market Cap",
            value: data.marketCap,
            percentageChange: data.marketCapChangePercentage24HUsd
        )
        
        let volume = StatisticModel(
            title: "24h Volume",
            value: data.volume
        )
        
        let btcDominance = StatisticModel(
            title: "BTC Dominance",
            value: data.btcDominance
        )
        
        let portfolioValue = portfolioCoins.map { $0.currentHoldingsValue }.reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentageChange = coin.priceChangePercentage24H ?? 0 / 100
                let previousvalue = currentValue / (1 + percentageChange)
                return previousvalue
            }
            .reduce(0,+)
        
        let percentageChanges = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChanges
        )
        stats.append(contentsOf: [marketCap,volume,btcDominance,portfolio])
        return stats
    }
    
}
