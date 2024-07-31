import Foundation

struct User: Codable, Equatable {
    let id: Int?
    let age: Int
    let sexe: String
    let mainDominante: String
    let password: String?
    let paysResidence: String
    let profession: String
    let vibrationTelActive: Bool
    let vibrationClavierActive: Bool
    let coqueTel: Bool
    let niveauInformatique: Int

    enum CodingKeys: String, CodingKey {
        case id
        case age
        case sexe
        case mainDominante
        case password
        case paysResidence = "PaysResidence"
        case profession = "Profession"
        case vibrationTelActive = "VibrationTelActive"
        case vibrationClavierActive = "VibrationClavierActive"
        case coqueTel = "CoqueTel"
        case niveauInformatique = "NiveauInformatique"
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
