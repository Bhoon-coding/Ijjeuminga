//
//  Extension + Encodable.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/12.
//

import Foundation

extension Encodable {
    func encodeDict() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else {
            throw NSError()
        }
        
        return dictionary
    }
}
