//
//  PortfolioDataService.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 8/11/22.
//

import Foundation
import CoreData

class PortfolioDataService{
    
    private let container: NSPersistentContainer
    
    private let containerName:String = "PortfolioContainer"
    
    private let entityName: String =  "PortfolioEntity"
    
    @Published var savedEntity: [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Eror loading core data! \(error)")
            }
            self.getPortfolio()
        }
    }
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do{
            savedEntity = try container.viewContext.fetch(request)
        }catch{
            print("Eror fetching portfolio Entities! \(error)")
        }
    }
    
    // MARK: PUBLIC
    func updatePortFolio(coin: CoinModel,amount: Double){
        if let entity = savedEntity.first(where: { $0.coinID == coin.id }){
            if amount > 0 {
                update(entity: entity, amount: amount)
            }else{
                delete(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE
    private func add(coin: CoinModel,amount: Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save(){
        do{
            try container.viewContext.save()
           
        }catch{
            print("Eror trying to save portfolio Entities! \(error)")
        }
    }
    
    private func applyChanges(){
        save()
        getPortfolio()
    }
    
}
