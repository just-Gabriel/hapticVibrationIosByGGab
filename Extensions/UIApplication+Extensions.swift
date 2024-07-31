//
//  UIApplication+Extensions.swift
//  ProjetApi
//
//  Created by Ortega Gabriel on 20/06/2024.
//

import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        guard let windowScene = connectedScenes.first as? UIWindowScene else {
            return
        }
        windowScene.windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}

