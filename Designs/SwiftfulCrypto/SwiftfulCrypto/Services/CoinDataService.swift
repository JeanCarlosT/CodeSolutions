//
//  CoinDataService.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 3/11/22.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    
    @Published var isDownloadingData: Bool = true
    
    //    var cancellables = Set<AnyCancellable>()
    
    var coinSubscription : AnyCancellable?
    
    init(){
        getCoins()
    }
    
    func getCoins(){
        guard
            let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")else{
            isDownloadingData = false
            return
        }
        
        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedCoinsModel in
                self?.isDownloadingData = false
                self?.allCoins = returnedCoinsModel
                self?.coinSubscription?.cancel() // Se puede cancelar cuando es una sola petición
            })
    }
}
