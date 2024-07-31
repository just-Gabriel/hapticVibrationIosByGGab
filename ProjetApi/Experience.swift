//
//  Experience.swift
//  ProjetApi
//
//  Created by Ortega Gabriel on 13/06/2024.
//

import Foundation

struct Experience: Codable {
    let id: Int
    let agreabilite: Int
    let intensite: Int
    let impression: String

    enum CodingKeys: String, CodingKey {
        case id
        case agreabilite
        case intensite
        case impression
    }
}


