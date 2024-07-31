import Foundation

struct Telephone: Codable, Equatable {
    let id: Int?
    let marque: String
    let modele: String
    let versionLogiciel: Double
    let numeroModele: String

    static func == (lhs: Telephone, rhs: Telephone) -> Bool {
        return lhs.id == rhs.id
    }
}
