    
import Foundation

//Para poder codificar y decodificar se utiliza el protocolo Codable en la clase o estrtuctura a utillizar

struct Games : Codable  {
    
    var games : [Game]
    
}

struct ResultsGames : Codable  {
    
    var results : [Game]
    
}


struct Game: Codable , Hashable {
    var title           : String
    var studio          : String
    var contentRaiting  : String
    var publicationYear : String
    var description     : String
    var platforms       : [String]
    var tags            : [String]
    var videosUrls      : VideoUrl
    var galleryImages   : [String]
    
}

struct VideoUrl : Codable, Hashable {
    var mobile : String
    var tablet : String
}
