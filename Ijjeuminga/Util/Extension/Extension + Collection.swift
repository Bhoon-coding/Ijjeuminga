//
//  Extension + Collection.swift
//  Ijjeuminga
//
//  Created by BH on 2024/07/11.
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        return self.indices.contains(index) ? self[index] : nil
    }
}
