//
//  CoinImageViewModel.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 3/11/22.
//

import Foundation
import SwiftUI
import Combine


class CoinImageViewModel: ObservableObject{
    
    @Published var image: UIImage? = nil
    
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let coin: CoinModel
    
    private let imageService: CoinImageService
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageService = CoinImageService(coin: coin)
        self.getImage()
        self.addSubscribers()
    }
    
    func addSubscribers(){
        
        imageService.$downloadingImage
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        imageService.$image
            .sink{ [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] uiImage in
                self?.image = uiImage
            }
            .store(in: &cancellables)
    }
    
    private func getImage(){
        
    }
    
}

