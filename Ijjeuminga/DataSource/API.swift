//
//  API.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/11.
//

import Foundation

struct APICommon {
    static let host: String = Bundle.main.object(forInfoDictionaryKey: "SERVER_HOST") as! String
}

protocol APIErrorDefinable: Error {
    var httpStatusCode: Int { get }
    var errorMsg: String? { get }
}

struct CommonAPIError: APIErrorDefinable {
    var httpStatusCode: Int
    var errorMsg: String?
}
