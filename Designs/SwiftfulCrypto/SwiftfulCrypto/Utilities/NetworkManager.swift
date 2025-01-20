//
//  NetworkManager.swift
//  SwiftfulCrypto
//
//  Created by Sioma on 3/11/22.
//

import Foundation
import Combine
class NetworkManager{
    
    enum NetworkingError: LocalizedError{
        case badUrlResponse(url: URL)
        case unknown
        
        var errorDescription: String?{
            switch self{
            case .badUrlResponse(let url): return "Bad response from url: \(url)"
            case .unknown: return "unknown error occur!"
            }
        }
    }
    
    static func download(url: URL)-> AnyPublisher<Data, Error>{
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on:DispatchQueue.global(qos:.background))
            .tryMap({ try handleUrlResponse(output: $0,url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output,url: URL) throws -> Data{
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else{
            throw NetworkingError.badUrlResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print("Error getting the coins \(error.localizedDescription)")
        }
    }
    
}
