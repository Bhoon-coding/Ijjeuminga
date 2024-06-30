//
//  Parameter.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/12.
//

import Foundation

import Alamofire

struct Code {
    let key: CodeKey
    let value: Codable?
}

enum CodeKey: String {
    case token
    
    case busRouteId
    
    case startOrd
    
    case endOrd
    
    case serviceKey
    
    // MARK: - Header
    case authorization
    
    case contentType
    
    var mappedKey: String {
        switch self {
        case .authorization:
            return "Authorization"
        case .contentType:
            return "Content-Type"
        default:
            return rawValue
        }
    }
    
    var mappedValue: String {
        switch self {
        case .authorization:
            return "Bearer "
        case .contentType:
            return "application/json"
        default:
            return rawValue
        }
    }
    
}

public class Parameters {
    private var params: [String: Codable?] = [:]

    func append(_ code: Code) {
        params[code.key.rawValue] = code.value
    }

    func toDictionary() -> Alamofire.Parameters {
        var parameters = Alamofire.Parameters()
        params.forEach { key, value in

            if let dictionaryValue = try? value?.encodeDict() {
                parameters[key] = dictionaryValue
            } else {
                parameters[key] = value
            }
        }

        return parameters
    }

    func toString() -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return nil
        }

        return jsonString
    }
    // TODO: [] 네트워크 레이어 마저 하기
    func get<T>(_: T.Type, _ code: CodeKey) -> T? {
        let value = params[code.rawValue] as? T
        return value
    }
}
