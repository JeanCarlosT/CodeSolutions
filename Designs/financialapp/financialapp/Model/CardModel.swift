//
//  CardModel.swift
//  financialapp
//
//  Created by Sioma on 9/03/22.
//

import Foundation
import SwiftUI


enum CreditCardType:String,CaseIterable {
    case Joven
    case Maestro
    case admin
}

struct CodableCard : Codable{
    var tarjeta_id : String
    var background_color : String
    var numero : String
    var monto : String
    var fecha_vencimiento : String
    var codigo_seguridad : String
    var tipo_tarjeta : String
    var persona_id : String
    var offset : String
    var colors : [BackgroundCircles]
}

struct Card{
   init(tarjeta_id: String, background_color: String, numero: String, monto: String, fecha_vencimiento: String, codigo_seguridad: String, tipo_tarjeta: String, persona_id: String, offset: CGFloat, colors: [circleColors]) {
        self.tarjeta_id = tarjeta_id
        self.background_color = background_color
        self.numero = numero
        self.monto = monto
        self.fecha_vencimiento = fecha_vencimiento
        self.codigo_seguridad = codigo_seguridad
        self.tipo_tarjeta = tipo_tarjeta
        self.persona_id = persona_id
        self.offset = offset
        self.colors = colors
    }
    
    var tarjeta_id : String
    var background_color : String
    var numero : String
    var monto : String
    var fecha_vencimiento : String
    var codigo_seguridad : String
    var tipo_tarjeta : String
    var persona_id : String
    var offset : CGFloat
    var colors : [circleColors]
}

class BackgroundCircles : Codable {
    init(color_id: String, color: String, size: String, offset: String, tarjeta_id: String) {
        self.color_id = color_id
        self.color = color
        self.size = size
        self.offset = offset
        self.tarjeta_id = tarjeta_id
    }
    
    var color_id : String
    var color : String
    var size : String
    var offset : String
    var tarjeta_id : String
}

class circleColors : Codable {
    init(color_id: String, color: String, size: CGFloat, offset: CGFloat, tarjeta_id: String) {
        self.color_id = color_id
        self.color = color
        self.size = size
        self.offset = offset
        self.tarjeta_id = tarjeta_id
    }
    
    var color_id : String
    var color : String
    var size : CGFloat
    var offset : CGFloat
    var tarjeta_id : String
}
