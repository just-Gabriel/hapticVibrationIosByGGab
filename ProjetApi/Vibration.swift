//
//  Vibration.swift
//  ProjetApi
//
//  Created by Ortega Gabriel on 13/06/2024.
//

import Foundation

struct Vibration: Codable {
    let id: Int
    let nom_vibration: String

    enum CodingKeys: String, CodingKey {
        case id
        case nom_vibration
    }
}


