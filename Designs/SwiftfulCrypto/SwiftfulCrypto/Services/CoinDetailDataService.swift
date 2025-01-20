//
//  CoinDetailDataService.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 21/11/22.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    
    @Published var isDownloadingData: Bool = true
    
    //    var cancellables = Set<AnyCancellable>()
    
    var coinDetailSubscription : AnyCancellable?
    
    let coin: CoinModel
    
    init(coin: CoinModel){
        self.coin = coin
        getCoiDetails()
    }
    
    func getCoiDetails(){
        guard
            let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")else{
            isDownloadingData = false
            return
        }
        
        coinDetailSubscription = NetworkManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedCoinDetailModel in
                self?.isDownloadingData = false
                self?.coinDetails = returnedCoinDetailModel
                self?.coinDetailSubscription?.cancel() // Se puede cancelar cuando es una sola petición
            })
    }
}
