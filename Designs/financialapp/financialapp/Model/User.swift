//
//  User.swift
//  financialapp
//
//  Created by Sioma on 27/03/22.
//

import Foundation

class User : Codable {
    
    init(identificacion: String, nombre: String, apellido: String) {
        self.identificacion = identificacion
        self.nombre = nombre
        self.apellido = apellido
    }
    
    var identificacion : String
    var nombre : String
    var apellido : String
    
}
