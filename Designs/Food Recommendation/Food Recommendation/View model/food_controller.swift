//
//  contentView_controller.swift
//  Food Recommendation
//
//  Created by Sioma on 18/02/22.
//

import Foundation
import UIKit

class FoodModelData : ObservableObject{
    
    @Published var recommendation_list :  [Food] = [
        Food(id:0,name: "Burger", image_name: "burger", description: "1 Flame grilled"),
        Food(id:1,name: "Chicken Box", image_name: "chicken", description: "24 chicken legs"),
        Food(id:2,name: "Donuts", image_name: "donuts", description: "Snack time!"),
        Food(id:3,name: "Hot Dog", image_name: "hotdog", description: "Bread,sausage and magic"),
        Food(id:4,name: "Ice Cream", image_name: "ice_cream", description: "Choose your fav"),
        Food(id:5,name: "Strawberry Milk Shake", image_name: "milk_shake", description: "Strawberry milk shake"),
        Food(id:6,name: "Pizza", image_name: "pizza", description: "Cheese and tomatoes"),
        Food(id:7,name: "Sandwich", image_name: "sandwich", description: "vegetarian sandwich")
    ]
    
    
    static func GetScreenSize()-> CGFloat {
        return UIScreen.main.bounds.size.width
    }
        
    
}
