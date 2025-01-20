
import Foundation

class ViewModel : ObservableObject {
    @Published var  gamesInfo = [Game]()
    
    init() {
        //prepara el string de la Url para convertirlo en URL
        let url = URL(string: "https://gamestream-api.herokuapp.com/api/games")
         
        //Se crea un URL REQUEST
        var request  = URLRequest(url: url!)
        
        //Ponemos el tipo de method (GET,POST,PUT)
        request.httpMethod = "GET"
        
        //Lanzazmos la peticion
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            do {
                //Validamos que la data no sea nil
                if let json = data {
                    print("Tamaño del json de view model \(json)")
                    
                    //Decodificamos el JSON
                    let decodeData = try JSONDecoder().decode([Game].self, from: json)
                    
                    
                    //Llamamos otro hilo para que no afecte el proceso actual
                    DispatchQueue.main.async {
                        self.gamesInfo.append(contentsOf: decodeData)
                    }
                    
                }
                
            } catch {
                
                print("Error: \(error)")
                
            }
        }.resume() //Es importante el resume para mandar la peticiones
        
        
        
    }
    
    
}
