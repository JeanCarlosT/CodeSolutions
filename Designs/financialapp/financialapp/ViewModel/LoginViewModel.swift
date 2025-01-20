//
//  LoginViewModel.swift
//  financialapp
//
//  Created by Sioma on 27/03/22.
//

import Foundation

class LoginViewModel : ObservableObject {
    
    @Published var userLogged : User = User(
        identificacion: "",
        nombre: "",
        apellido: ""
    )
    
    @Published var isLoading : Bool = false
    
    @Published var navigate  : Bool = false
    
    @Published var showAlert : Bool = false
    
    func login(user_id : String) async {
        /*
         MARK: url, el host = a la direción ip del computador del servidor
         http://{{host}}/backend/src/model/login.php?id=1000748072
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
        let url2 = URL(string: "http://\(ApiClient.host)/backend/src/model/login.php?id=\(user_id)")!
        
        ///REQUEST
        var urlRequest = URLRequest(url: url2)
        
        /// MÉTODO
        urlRequest.httpMethod = "GET"
    
        let requestResult = await ApiClient.requestWithRespond(by: urlRequest, decodableObject: User.self)
        
        if let requestResult = requestResult {
            DispatchQueue.main.async {
                self.userLogged = requestResult
                self.isLoading = false
                self.showAlert = false
                self.navigate = true
            }
           
        }else{
            DispatchQueue.main.async {
                self.isLoading = false
                self.showAlert = true
            }
            
        }
        
    }
    
}
