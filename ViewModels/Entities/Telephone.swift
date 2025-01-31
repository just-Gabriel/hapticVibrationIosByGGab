import Foundation

struct Telephone: Codable, Equatable {
    let id: Int?
    let marque: String
    let modele: String
    let versionLogiciel: String
    let numeroModele: String

    enum CodingKeys: String, CodingKey {
        case id
        case marque
        case modele
        case versionLogiciel = "version_logiciel"
        case numeroModele = "numero_modele"

    }

    static func == (lhs: Telephone, rhs: Telephone) -> Bool {
        return lhs.id == rhs.id
    }
}
