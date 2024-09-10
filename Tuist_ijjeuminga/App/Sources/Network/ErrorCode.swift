//
//  ErrorCode.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/11.
//

import Foundation

import Alamofire

enum CustomError: Error {
    enum NetworkError: Error {
        /// network timeout
        case networkTimeout
        /// device network lost
        case networkUnavailable
        /// 잘못된 URL
        case invalidURL
        /// API Error
        case apiError(definition: APIErrorDefinable)
        /// 정의되지 않은 Error
        case unknown(afError: AFError)
        /// 응답 결과 Data nil
        case emptyData
        /// 파싱 실패
        case parsingFail
        
        var messageDescription: String {
            switch self {
            case .networkTimeout:
                return "네트워크가 불안정합니다.\n잠시 후 다시 시도해주세요."
            case .networkUnavailable:
                return "네트워크가 불안정합니다.\n네트워크가 불안정해요. 연결을 확인해주세요."
            case .invalidURL:
                return "유효하지 않은 URL 입니다"
            case .apiError(definition: let definition):
                return "API 에러: \(definition.localizedDescription)"
            case .unknown(afError: let afError):
                return "알 수 없는 에러: \(afError.localizedDescription)"
            case .emptyData:
                return "데이터가 없습니다."
            case .parsingFail:
                return "데이터를 파싱하는데 실패했습니다."
            }
        }
    }
}

