//
//  SearchGame.swift
//  GameStream
//
//  Created by MacBook Casa on 31/01/22.
//

import Foundation

class SearchGame : ObservableObject {
    
    @Published var searchInfo = [Game]()
    
    func searchGame(by gameName : String ){
        //Limpiamos el arreglo de juegos
        searchInfo.removeAll()
        
        //Encodificamos el nombre que se va a enviar como parametro con el fin de que se puedan enviar con espacio y sin problemas
        let gameNameSpaces = gameName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let url = URL(string: "https://gamestream-api.herokuapp.com/api/games/search?contains=\(gameNameSpaces ?? "cuphead")")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        var dataDecode =  URLSession.shared.dataTask(with: request) { data, response, error in
            do{
              
                if let jsonData = data {
                    print("tamaño del json encodificado  \(jsonData)")
                    let decodeData = try JSONDecoder().decode(ResultsGames.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        self.searchInfo.append(contentsOf: decodeData.results)
                    }
                    
                }
                
            }catch{
                print("Error: \(error)")
            }
            
        }.resume()
        
        
        print()
        
    }
    
    
}
