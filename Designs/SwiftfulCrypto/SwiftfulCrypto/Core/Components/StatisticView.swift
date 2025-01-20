//
//  StatisticView.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 4/11/22.
//

import SwiftUI

struct StatisticView: View {
    
    let statisticModel: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading,spacing:4) {
            Text(statisticModel.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            Text(statisticModel.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            
            HStack(spacing:4){
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(angle())
                
                Text(statisticModel.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(foregroundColor())
            .opacity(statisticModel.percentageChange == nil ? 0.0 : 1.0)
        }
    }
    
    func angle()->Angle{
        guard let percentage = statisticModel.percentageChange else {
            return Angle(degrees: 0)
        }
        if percentage >= 0{
            return Angle(degrees: 0)
        }else{
            return Angle(degrees: 180)
        }
    }
    
    func foregroundColor()->Color{
        guard let percentage = statisticModel.percentageChange else {
            return Color.theme.red
        }
        if percentage >= 0{
            return Color.theme.green
        }else{
            return Color.theme.red
        }
    }
}

struct StatisticView_Previews: PreviewProvider{
    static var previews: some View {
        StatisticView(statisticModel: dev.stat1)
    }
}
