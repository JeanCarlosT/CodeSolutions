//
//  ApiClient.swift
//  financialapp
//
//  Created by Sioma on 27/03/22.
//

import Foundation



class ApiClient {
    
    static var host: String =  "192.168.1.26"
    
    static func createMultipartBody(data: [String:String], boundary : String) -> Data {
        let body = NSMutableData()
        var fieldString = "--\(boundary)\r\n"
      
        
        data.forEach { (key: String, value: String) in
            fieldString += "Content-Disposition: form-data;name=\"\(key)\"\r\n"
            fieldString += "Content-Type: text/plain; charset=ISO-8859-1\r\n"
            fieldString += "Content-Transfer-Encoding: 8bit\r\n"
            fieldString += "\r\n"
            fieldString += "\(value)\r\n"
            fieldString += "--\(boundary)\r\n"
        }
        body.appendString(fieldString)
        print(String(data:body as Data,encoding: .utf8)!)
        return body as Data
    }
        
    //Request with response (Do care about data return)
    static func requestWithRespond<T : Decodable>( by urlRequest : URLRequest, decodableObject : T.Type ) async -> T? {
        do {
            let sessionSettings = URLSessionConfiguration.default
            sessionSettings.timeoutIntervalForRequest = 30.0
            sessionSettings.timeoutIntervalForResource = 50.0
            let session = URLSession(configuration: sessionSettings)
            
            let (data,response) = try await session.data(for: urlRequest)
            
            
            //Validamos el statusCode de la respuesta es diferente a 200
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                return  nil
            }
            
            //Validamos si hay datos
            if  data.isEmpty == false {
                print("Tamaño del json \(data)")
                
                do{
                    //Validamo si dentro del data hay algún error
                    let decodeData = try JSONDecoder().decode(decodableObject.self, from: data)
                    return decodeData
                    
                }catch{
                    
                   return nil
                }
                
            }else{
                return nil
            }
            
            
        } catch{
            //Cuando hay algùn error
            return nil
        }
    }
    
    //Request with Boolean as response (Do NOT care about data return)
    static func requestWithRespond_<T : Decodable>( by urlRequest : URLRequest,decodableObject : T.Type , completionHandler : @escaping (T?)->Void){
        do {
            let sessionSettings = URLSessionConfiguration.default
            sessionSettings.timeoutIntervalForRequest = 30.0
            sessionSettings.timeoutIntervalForResource = 50.0
            let session = URLSession(configuration: sessionSettings)
            
            let task =  session.dataTask(with: urlRequest){ data, response, error in
                
                // validamos que haya respuesta
                guard let response  = response  else {
                    return completionHandler(nil)
                }
                
                //Validamos el statusCode de la respuesta es diferente a 200
                if (response as? HTTPURLResponse)?.statusCode != 200 {
                    return completionHandler(nil)
                }
                
                //Validamos si hay data
                guard let data = data else {
                    return completionHandler(nil)
                }
                
                
                //Validamos si hay datos
                if  data.isEmpty == false {
                    print("Tamaño del json \(data)")
                    
                    do{
                        //Validamo si dentro del data hay algún error
                        let decodeData = try JSONDecoder().decode(decodableObject.self, from: data)
                        return completionHandler(decodeData)
                        
                    }catch{
                        
                       return completionHandler(nil)
                    }
                    
                } else {
                     return completionHandler(nil)
                }
                
                
            }
            
            task.resume()
        }
    }
    
    //Request with Boolean as response (Do NOT care about data return)
    static func requestWitNoResponse( by urlRequest : URLRequest ) async -> Bool {
        do {
            let sessionSettings = URLSessionConfiguration.default
            sessionSettings.timeoutIntervalForRequest = 30.0
            sessionSettings.timeoutIntervalForResource = 50.0
            let session = URLSession(configuration: sessionSettings)
            
            let (data,response) = try await session.data(for: urlRequest)
            
            
            //Validamos el statusCode de la respuesta es diferente a 200
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                return  false
            }
            
            //Validamos si hay datos de ERROR
            if  data.isEmpty == false {
                print("Tamaño del json \(data)")
                
                return true
                
            }else{
                return false
            }
            
            
        } catch{
            //Cuando hay algùn error
            return false
        }
    }
}


extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
