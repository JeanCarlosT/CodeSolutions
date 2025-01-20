//
//  SaveData.swift
//  GameStream
//
//  Created by Jean Carlos Casa on 31/01/22.
//

import Foundation

class SaveData {
    var email : String = ""
    var password : String = ""
    var name : String = ""
    
    
    func storageData(correo:String,contrasena:String,nombre:String) ->Bool {
        
        //Los UserDefaults es para almacenar datos pequeños pero importantes para la app
        UserDefaults.standard.set([correo,contrasena,nombre], forKey: "userData")
        return true
    }
    
    func getDataStoraged()->[String] {
        if let userData: [String] = UserDefaults.standard.stringArray(forKey: "userData") {
            return userData
        }else{
            return []
        }
    }
    
    
    func validateUserData(correo:String,contrasena:String) -> Bool {
        
        var emailSaved = ""
        var passwordSaved = ""
        
        if UserDefaults.standard.object(forKey: "userData") != nil {
            emailSaved = UserDefaults.standard.stringArray(forKey: "userData")![0]
            passwordSaved = UserDefaults.standard.stringArray(forKey: "userData")![1]
            
            if emailSaved == correo && contrasena == passwordSaved {
                return true
            }else{
                return false
            }
            
        }else{
            return false
        }
        
        
        
    }
    
    
}
