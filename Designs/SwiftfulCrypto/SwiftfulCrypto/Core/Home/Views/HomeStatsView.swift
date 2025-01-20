//
//  HomeStatsView.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 4/11/22.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject var homeVm: HomeViewModel
    
    @Binding var showPortFolio: Bool
    
    var body: some View {
        HStack{
            ForEach(homeVm.statisticModels) { model in
                StatisticView(statisticModel: model)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        } .frame(
            width: UIScreen.main.bounds.width,
            alignment: showPortFolio ? .trailing : .leading
        )
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortFolio: .constant(true))
            .environmentObject(dev.homeVM)
    }
}
