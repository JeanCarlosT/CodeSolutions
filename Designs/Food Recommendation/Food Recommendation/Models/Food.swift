//
//  Food.swift
//  Food Recommendation
//
//  Created by Sioma on 18/02/22.
//

import Foundation
import SwiftUI

class Food : ObservableObject {
    
    init(id: Int,name: String, image_name: String, description: String) {
        self.id = id
        self.name = name
        self.image_name = image_name
        self.description = description
        self.numberOfLikes = Int.random(in: 1000...1010)
        self.isUserFavorite = false
    }
    
    var id : Int
    
    var name : String
    
    var image_name : String
    
    var description : String
    
    lazy var image : Image =  {
        return Image(image_name)
    }()
    
    var cardColor : Color {
        return Color(image_name)
    }
    
    var numberOfLikes : Int
    
    var isUserFavorite : Bool {
        willSet {
            if newValue {
                numberOfLikes = numberOfLikes + 1
            } else {
                numberOfLikes = numberOfLikes - 1
            }
        }
    }
    
}
