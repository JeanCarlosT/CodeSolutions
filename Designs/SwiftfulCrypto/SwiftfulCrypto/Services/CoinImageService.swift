//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 3/11/22.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService{
    
    @Published var image: UIImage? = nil
    
    @Published var downloadingImage: Bool = true
    
    var imageSubscription: AnyCancellable?
    
    private let folderName = "coin_images"
    private let imgeName : String
    
    let fileManager = LocalFileManager.instance
    
    let coin: CoinModel
    
    init(coin:CoinModel){
        self.coin = coin
        self.imgeName = coin.id
        getCoinImage()
    }
    
    func getCoinImage(){
        if let imageFM = fileManager.getImage(imageName: imgeName, folderName: folderName){
            self.image = imageFM
//            print("Image from FM")
        }else{
            downloadCoinImage()
//            print("Image from Internet")  
        }
    }
    
    func downloadCoinImage(){
        guard let url = URL(string:coin.image)else {
            downloadingImage = false
            return
        }
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                
                guard
                    let self = self,
                    let imageValid = returnedImage else{
                    return
                }
                
                self.fileManager.saveImage(image: imageValid, imageName:self.imgeName, folderName: self.folderName)
                self.downloadingImage = false
                self.image = returnedImage
                self.imageSubscription?.cancel() // Se puede cancelar cuando es una sola petición
            })
    }
    
}
