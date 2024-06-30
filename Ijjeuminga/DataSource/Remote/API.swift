//
//  API.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/11.
//

import Foundation

import Alamofire
import RxSwift

struct APICommon {
    // swiftlint:disable:next force_cast
    static let host: String = Bundle.main.object(forInfoDictionaryKey: "SERVER_HOST") as! String
}

struct Rest {
    struct Buspos {
        
    }
}

public protocol APIDefinition {
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
}

public extension APIDefinition {
    // swiftlint:disable:next identifier_name
    static var rx: Reactive<Self>.Type {
        return Reactive<Self>.self
    }
    // swiftlint:disable:next identifier_name
    var rx: Reactive<Self> {
        return Reactive(self)
    }
}

protocol APIErrorDefinable: Error {
    var httpStatusCode: Int { get }
    var errorMsg: String? { get }
}

struct CommonAPIError: APIErrorDefinable {
    var httpStatusCode: Int
    var errorMsg: String?
}
