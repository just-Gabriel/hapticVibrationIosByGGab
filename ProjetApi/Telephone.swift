//
//  Telephone.swift
//  ProjetApi
//
//  Created by Ortega Gabriel on 13/06/2024.
//

import Foundation

struct Telephone: Codable {
    let id: Int
    let marque: String
    let modele: String
    let versionLogiciel: Int
    let numeroModele: String

    enum CodingKeys: String, CodingKey {
        case id
        case marque
        case modele
        case versionLogiciel = "version_logiciel"
        case numeroModele = "numero_modele"
    }
}


