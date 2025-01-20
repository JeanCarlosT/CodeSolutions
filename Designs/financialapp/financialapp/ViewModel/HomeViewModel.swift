//
//  HomeViewModel.swift
//  financialapp
//
//  Created by Sioma on 8/03/22.
//

import Foundation
import SwiftUI

enum ServicesAllows : String,CaseIterable {
    case transferMoney = "Transferencia de dinero"
    case payments = "Pagos de nomina ó facturas"
    case takeOutMoney = "Retiro de dinero"
}

enum FocusableField : Hashable{
    case monto
    case destination
}

class HomeViewModel : ObservableObject{
    @Published var creditCards : [Card] = []
    
    @Published var transactions : [TransactionModel] = []
    
    @Published var swipedCardCounter = 0
    
    @Published var showCardDetail : Bool  = false
    
    @Published var service : ServicesAllows = .payments
    
    @Published  var isLoading : Bool = false
    
    @Published var showAlert : Bool = false
    
    var colors : [Color] = [
        Color("circle_gray"),
        Color("loginColor"),
        Color("loginColor2"),
        Color("signInColor")
    ]
    
    init(){
        
    }
    
    func initialize(user_id : String){
        withAnimation {
            creditCards.removeAll()
            Task{ await getUser_Cards(user_id: user_id) }
        }
    }
    
    func random_offset()->CGFloat{
        return CGFloat.random(in: 0.0..<40.0)
    }
    
    func random_size()->CGFloat{
        return CGFloat.random(in: 20.0..<60.0)
    }
    
    func string_CGFloat(_ str : String)->CGFloat{
        if let n = NumberFormatter().number(from: str) {
            let f = CGFloat(truncating: n)
            return f
        }else{
            return CGFloat.random(in: 0.0..<40.0)
        }
    }
    
    func cardNumber(_ data : String)->String{
        var  string : String = ""
        let length = data.count
        for x in 0..<length{
            if x % 4 == 0 {string = string + " "}
            let input = data
            let char = input[input.index(input.startIndex, offsetBy: x)]
            string = string + String(char)
        }
        return string
    }
    
    func getUser_Cards(user_id : String) async {
        /*
         MARK: url, el host = a la direción ip del computador del servidor
         http://{{host}}/backend/src/model/tarjetas.php?user_id=1000748072
         */
        
        if user_id.isEmpty {
            self.isLoading = false
            self.showAlert = true
            return
        }
        
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        

        ///URL:
        let url2 = URL(string: "http://\(ApiClient.host)/backend/src/model/tarjetas.php?user_id=\(user_id)")!
        
        ///REQUEST
        var urlRequest = URLRequest(url: url2)
        
        /// MÉTODO
        urlRequest.httpMethod = "GET"
    
        let requestResult = await ApiClient.requestWithRespond(by: urlRequest, decodableObject: [CodableCard].self)
        
        if let requestResult = requestResult {
            DispatchQueue.main.async {
                for card in requestResult{
                    
                    var colors : [circleColors] = []
                    
                    for color in card.colors{
                        colors.append(
                            circleColors(
                                color_id: color.color_id,
                                color: color.color,
                                size: self.string_CGFloat(color.size),
                                offset: self.string_CGFloat(color.offset),
                                tarjeta_id: color.tarjeta_id
                            )
                        )
                    }
                    
                    self.creditCards.append (Card(
                        tarjeta_id: card.tarjeta_id,
                        background_color: card.background_color,
                        numero: card.numero,
                        monto: card.monto,
                        fecha_vencimiento: card.fecha_vencimiento,
                        codigo_seguridad: card.codigo_seguridad,
                        tipo_tarjeta: card.tipo_tarjeta,
                        persona_id: card.persona_id,
                        offset: self.string_CGFloat(card.offset),
                        colors: colors
                    )
                    )
                }
                
                self.isLoading = false
                self.showAlert = false
            }
            
        }else{
            DispatchQueue.main.async {
                self.isLoading = false
                self.showAlert = true
            }
            
        }
        
    }
    
    func getCard_transaction(tarjeta_id : String){
        /*
         MARK: url, el host = a la direción ip del computador del servidor
         http://{{host}}/backend/src/model/tarjetas.php?user_id=1000748072
         */
        
        if tarjeta_id.isEmpty {
            self.showAlert = true
            return
        }
        

        ///URL:
        let url2 = URL(string: "http://\(ApiClient.host)/backend/src/model/transanction.php?card_id=\(tarjeta_id)")!
        
        ///REQUEST
        var urlRequest = URLRequest(url: url2)
        
        /// MÉTODO
        urlRequest.httpMethod = "GET"
    
        ApiClient.requestWithRespond_(by: urlRequest, decodableObject: [TransactionModel].self){ requestResult in
            if let requestResult = requestResult {
                DispatchQueue.main.async {
                    self.transactions = requestResult
                    self.showAlert = false
                }
                
            }else{
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showAlert = true
                }
            }
        }
    }
    
}
