//
//  TransactionModel.swift
//  financialapp
//
//  Created by Sioma on 28/03/22.
//

import Foundation

class TransactionModel : Codable {
    var transaccion_id : String
    var monto : String
    var tipo_transaccion : String
    var origen : String
    var destino : String
    var created_at : String
}
