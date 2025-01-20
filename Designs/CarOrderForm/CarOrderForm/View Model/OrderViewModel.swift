//
//  OrderViewModel.swift
//  CarOrderForm
//
//  Created by Sioma on 3/03/22.
//

import Foundation

class OrderViewModel : ObservableObject{
    @Published var rentalPeriod = 0
    @Published var numberOfCars = 0
    @Published var pickUpTime = 0
    @Published var pickUpLocation = 0
    @Published var returnLocation = 0
    
    let rentalPeriods = Array(0..<10)
    let numberOfCardOptions  = Array(1..<4)
    let pickUpTimes = Array(stride(from: 30, through: 180, by: 30))
    let locations = ["Chigorodó","Apartadó","Carepa","Casa verde","Turbo","Rio sucio"]
    var specialDriver : Bool = false
    
    
}
