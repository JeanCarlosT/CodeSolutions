//
//  ContentView.swift
//  Food Recommendation
//
//  Created by Sioma on 17/02/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var controller : FoodModelData = FoodModelData()
    
    private var filterRating : [Food] {
        return controller.recommendation_list.sorted { firstFood, secondFood in
            return firstFood.numberOfLikes > secondFood.numberOfLikes
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators:false){
                ForEach(filterRating,id:\.id) { food in
                    FoodCardView(
                        foodItem: food,
                        isUserFavorite: $controller.recommendation_list[food.id].isUserFavorite
                    )
                }
            }
            .navigationTitle("Fast Food!")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


