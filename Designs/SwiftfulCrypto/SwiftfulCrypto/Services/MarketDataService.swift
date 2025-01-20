//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 4/11/22.
//

import Foundation
import Combine

class MarketDataService{
    
    @Published var marketDataModel: MarketDataModel? = nil
    
    @Published var isDownloadingData: Bool = true
    
    //    var cancellables = Set<AnyCancellable>()
    
    var marketDataSubscription : AnyCancellable?
    
    init(){
        getData()
    }
    
    func getData(){
        guard
            let url = URL(string: "https://api.coingecko.com/api/v3/global")else{
            isDownloadingData = false
            return
        }
        
        marketDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                self?.isDownloadingData = false
                self?.marketDataModel = returnedGlobalData.data
                self?.marketDataSubscription?.cancel() // Se puede cancelar cuando es una sola petición
            })
    }
    
}
