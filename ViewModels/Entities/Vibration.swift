import Foundation

struct Vibration: Codable, Identifiable {
    let id: Int?
    let nom_vibration: String?
    let nombre_de_fois: Int?
    let mobile = 1
    

    enum CodingKeys: String, CodingKey {
        case id
        case nom_vibration = "nom_vibration"
        case nombre_de_fois = "nombre_de_fois"
        
    }
}

    
