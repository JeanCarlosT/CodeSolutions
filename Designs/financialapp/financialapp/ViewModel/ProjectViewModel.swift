//
//  ProjectViewModel.swift
//  financialapp
//
//  Created by Sioma on 26/03/22.
//

import Foundation
import SwiftUI

class ProjectViewModel : ObservableObject {
    
    @Published var card = Card(
        tarjeta_id: "",
        background_color: "Morado",
        numero: "",
        monto: "0.0",
        fecha_vencimiento: "2050-01-23",
        codigo_seguridad: "",
        tipo_tarjeta: "",
        persona_id: "",
        offset: 0.0,
        colors: []
    )
    
    @Published var isLoading : Bool = false
    
    @Published var showAlert : Bool = false
    
    var colors : [String] = [
        "Morado",
        "Rosado",
        "Azul claro",
        "circle_gray",
        "loginColor",
        "loginColor2",
        "signInColor",
        "#ffca2b",
        "#3f5836",
        "#ef8c66",
        "#8eff66",
        "#f4699c",
        "#693330"
    ]
    
    init(){
        self.card.numero = random_cardNumber()
        self.card.codigo_seguridad = "\(Int.random(in: 100...999))"
        self.card.tipo_tarjeta = "Joven"
        self.change_money(cardType: .Joven)
    }
    
 func create_card(user_id : String) async -> Bool {
        /*
         MARK: url, el host = a la direción ip del computador del servidor
         http://{{host}}/backend/src/model/tarjetas.php
         */

        DispatchQueue.main.async {
            self.isLoading = true
        }
        

        ///URL:
        let url2 = URL(string: "http://\(ApiClient.host)/backend/src/model/tarjetas.php")!

        ///REQUEST
        var urlRequest = URLRequest(url: url2)

        /// MÉTODO
        urlRequest.httpMethod = "POST"

        
        /// Boundry
        let boundary = "Boundary-\(UUID().uuidString)"
        
        ///HEADERS
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        /// DATA
        let parameteres : [String : String] = [
            "background_color": card.background_color,
            "numero": card.numero,
            "monto": card.monto,
            "fecha_vencimiento": card.fecha_vencimiento,
            "codigo_seguridad": card.codigo_seguridad,
            "tipo_tarjeta": card.tipo_tarjeta,
            "persona_id": user_id,
            "offset": card.offset.description,
        ]
       
                        
        /// CREATE OUR BODY
        urlRequest.httpBody = ApiClient.createMultipartBody(data: parameteres, boundary: boundary)

        let requestResult = await ApiClient.requestWitNoResponse(by: urlRequest)
        
        if requestResult{
            DispatchQueue.main.async {
                self.isLoading = false
                self.showAlert = false
            }
            return true
        }else{
            DispatchQueue.main.async {
                self.isLoading = false
                self.showAlert = true
            }
            return false
        }

    }
    
    func string_CGFloat(_ str : String)->CGFloat{
        if let n = NumberFormatter().number(from: str) {
            let f = CGFloat(truncating: n)
            return f
        }else{
            return CGFloat.random(in: 0.0..<40.0)
        }
    }
    
    func random_offset()->CGFloat{
        return CGFloat.random(in: 0.0..<40.0)
    }
    
    func random_size()->CGFloat{
        return CGFloat.random(in: 20.0..<60.0)
    }
    
    func random_cardNumber()->String{
        var string : String = "5"
        for _ in 0..<15{
            string = string + String(Int.random(in: 0...9))
        }
        return string
    }
    
    func addCircles(_ number : Int){
        for _ in 0..<number{
            self.card.colors.append(
                circleColors(
                    color_id: "",
                    color: colors.randomElement() ?? "Rosado",
                    size: random_size(),
                    offset: random_offset(),
                    tarjeta_id: ""
                )
            )
        }
    }
    
    func removeCircle(){
        card.colors.removeAll()
    }
    
    func change_money(cardType : CreditCardType){
        switch cardType {
        case .Joven:
            card.monto = "1000000"
        case .Maestro:
            card.monto = "2000000"
        case .admin:
            card.monto = "10000000"
        }
    }
    
}
