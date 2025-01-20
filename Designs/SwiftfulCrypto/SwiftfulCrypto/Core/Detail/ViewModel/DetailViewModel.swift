//
//  DetailViewModel.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 21/11/22.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject{
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteUrl: String? = nil
    @Published var redditURL: String? = nil
    
    @Published var isLoading: Bool = false
    
    @Published var coin: CoinModel
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel){
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSuscribers()
    }
    
    private func addSuscribers(){
        
        coinDetailService.$isDownloadingData
            .sink { value in
                self.isLoading = value
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnArrays in
                self?.overviewStatistics = returnArrays.overview
                self?.additionalStatistics = returnArrays.additional
            }
            .store(in: &cancellables)
        
//        coinDetailService.$coinDetails
//            .sink { [weak self] returnedCoinDeatil in
//                self?.coinDescription = returnedCoinDeatil?.readableDescription
//                self?.websiteUrl = returnedCoinDeatil?.links?.homepage?.first
//                self?.redditURL = returnedCoinDeatil?.links?.subredditURL
//            }
//            .store(in: &cancellables)
        
    }
    
    private func mapDataToStatistics(coinDetailModel: CoinDetailModel?,coinModel: CoinModel)-> (overview: [StatisticModel],additional: [StatisticModel]){
        
        //Website
        self.coinDescription = coinDetailModel?.readableDescription
        self.websiteUrl = coinDetailModel?.links?.homepage?.first
        self.redditURL = coinDetailModel?.links?.subredditURL
        
        // OverView
        let overviewStatistics = createOverViewArray(coinModel: coinModel)
        // Additional
        let additionalStatistics = createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel)
        
        return (overviewStatistics,additionalStatistics)
    }
    
    
    private func createOverViewArray(coinModel: CoinModel)->[StatisticModel]{
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price,percentageChange: pricePercentageChange)
        
        let marketCap = "$"+(coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap,percentageChange: marketCapPercentageChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$"+(coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overviewStatistics: [StatisticModel] = [
            priceStat,marketCapStat,rankStat,volumeStat
        ]
        
        return overviewStatistics
    }
    
    private func createAdditionalArray(coinDetailModel: CoinDetailModel?,coinModel: CoinModel)->[StatisticModel]{
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChangePercentage24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange2 = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange,percentageChange: pricePercentChange2)
        
        let marketCapChange = "$"+(coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentageChange2 = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange,percentageChange: marketCapPercentageChange2)
        
        let blocktime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blocktimeString = blocktime == 0 ? "n/a" : "\(blocktime)"
        let blockStat = StatisticModel(title: "Block Time", value: blocktimeString)
        
        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStats = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additionalStatistics: [StatisticModel]  = [
            highStat,lowStat,priceChangeStat,marketCapChangeStat,blockStat,hashingStats
        ]
        return additionalStatistics
    }
    
}
