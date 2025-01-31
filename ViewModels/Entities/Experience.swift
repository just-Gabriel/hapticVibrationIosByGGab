import Foundation


struct Experience: Codable {
    let id: Int?
    let agreabilite: Float
    let intensite: Float
    let impression: String?
    let user: String
    let telephone: String
    let vibration: String
    let nombre_de_fois: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case agreabilite
        case intensite
        case impression
        case user
        case telephone
        case vibration
        case nombre_de_fois
        

        
    }
}
