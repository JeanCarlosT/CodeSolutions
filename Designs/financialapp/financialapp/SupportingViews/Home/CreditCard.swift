//
//  CreditCard.swift
//  financialapp
//
//  Created by Sioma on 8/03/22.
//

import SwiftUI

var foreGroundColor : Color = .white

struct CreditCard: View{
    var index : Int
    @Binding var swipedCardCounter : Int
    var card : Card
    var user : User
    var showNumber : Bool = false
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
            CardBackground(
                index: index,
                swipedCardCounter: $swipedCardCounter,
                color: Color(card.background_color),
                card: card
            )
            VStack(alignment:.leading){
                //MARK: logoTipo y validación
                HStack{
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(foreGroundColor)
                        Text(convertDoubleToCurrency(Double(card.monto) ?? 0.0))
                            .font(.system(size: 18,weight: .semibold))
                            .foregroundColor(foreGroundColor)
                    }
                    Spacer()
                    Image("cardIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                }
                
                Spacer()
                
                //MARK: card number
                Text(cardNumber())
                    .font(.system(size: 25,weight: .semibold))
                    .foregroundColor(foreGroundColor)
                
                Spacer()
                
                //MARK: owner, expirationDate
                HStack{
                    KeyValueView(key:user.nombre , value: card.tipo_tarjeta)
                    Spacer()
                    HStack{
                        KeyValueView(key: card.fecha_vencimiento , value: "expiration")
                        KeyValueView(key: card.codigo_seguridad, value: "CVS")
                    }
                }
            }
            .padding()
        }
    }

    func convertDoubleToCurrency(_ amount : Double)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount)) ?? "0.0"
    }
    
    
   func cardNumber()->String{
       var  string : String = ""
       let length = card.numero.count
       if showNumber {
           for x in 0..<length{
               if x % 4 == 0 {string = string + " "}
               let input = card.numero
               let char = input[input.index(input.startIndex, offsetBy: x)]
               string = string + String(char)
           }
       }else{
           for x in 0..<length{
               if string.count < 15{
                   if x % 4 == 0 {string = string + " "}
                   string = string + "*"
               }else{
                   if x % 4 == 0 {string = string + " "}
                   let input = card.numero
                   let char = input[input.index(input.startIndex, offsetBy: x)]
                   string = string + String(char)
               }
           }
       }
       return string
   }
    
    static func cardOffsetY(index : Int)->CGFloat{
        return index <= 3 ? CGFloat(index) * 20 : 20
    }
    
    static func cardOffsetX(index : Int)->CGFloat{
        return index <= 3 ? CGFloat(index) * 25 : 20
    }
    
    @ViewBuilder func text()->some View{
        Text("hola")
    }
}

struct KeyValueView : View{
    var key : String
    var value : String
    var body: some View{
        VStack(alignment:.leading) {
            Text(key)
                .font(.system(size: 18,weight: .semibold))
                .foregroundColor(foreGroundColor)
            Text(value)
                .font(.caption)
                .foregroundColor(foreGroundColor)
        }
    }
}

struct CardBackground :View {
    var index : Int
    
    @Binding var swipedCardCounter : Int
    
    var color  : Color
    
    var card : Card
    
    var body: some View{
        HStack{
//            ForEach(card.colors,id:\.color_id) { circle in
//                Circle()
//                    .fill(Color(circle.color))
//                    .frame(width: circle.size, height: circle.size)
//                    .offset(x: circle.offset , y: circle.offset)
//            }
        }
        .frame(maxWidth: CGFloat.getScreenWidth - 60, maxHeight: .infinity)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 15,style: .continuous))
        // mark: just show what is inside the frme bounds
        .clipped(antialiased: true)
    }
    
    
    
    
    func getWidth(index: Int)->CGFloat{
        let boxWidth = CGFloat.getScreenWidth - 60
        let cardWidth = (index - swipedCardCounter) <= 3 ? CGFloat(index) * 30 : 60
        return boxWidth - cardWidth
    }
    
    func getHeight(index: Int)->CGFloat {
        let boxHeight = CGFloat(200)
        let cardHeight = (index - swipedCardCounter) <= 2 ? CGFloat(index) * 20 : 40
        return boxHeight - cardHeight
    }
    
    func string_CGFloat(_ str : String)->CGFloat{
        if let n = NumberFormatter().number(from: str) {
            let f = CGFloat(truncating: n)
            return f
        }else{
            return CGFloat.random(in: 0.0..<40.0)
        }
    }
    
}

//struct CreditCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//        //        CreditCard(
//        //            index: 2, swipedCardCounter: .constant(1),
//        //            card: Card(id: 0, cardColor: Color("Morado"), owner: "Jean Carlos 1")
//        //        )
//    }
//}
