//
//  RealTimeBusAPI.swift
//  Ijjeuminga
//
//  Created by hayeon on 6/30/24.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

protocol RealTimeBusAPIServiceable {
    func getRealTimeBus(
        with busRouteId: String
    ) -> Single<Rest.RealTimeBus.RealTimeBusResponse>
}

struct RealTimeBusAPIService: RealTimeBusAPIServiceable {
    func getRealTimeBus(
        with vehId: String
    ) -> Single<Rest.RealTimeBus.RealTimeBusResponse> {
        Rest.RealTimeBus(parameters: Rest.RealTimeBus.RealTimeBusParameters(
            vehId: vehId
        ))
        .rx
        .request()
    }
}
            
extension Reactive where Base == Rest.RealTimeBus {
    func request() -> Single<Rest.RealTimeBus.RealTimeBusResponse> {
        NetworkManager.request(
            parameters: base.parameters,
            path: base.path,
            method: base.method,
            header: base.headers,
            encoding: URLEncoding.queryString
        )
    }
}

extension Rest {
    struct RealTimeBus: APIDefinition {
        
        var path: String = "/api/rest/buspos/getBusPosByVehId"
        
        var headers: HTTPHeaders?
        
        var parameters: Parameters?
        
        var method: HTTPMethod = .get
        
        struct RealTimeBusParameters: Codable {
            let vehId: String
//            var serviceKey: String = Constant.serviceKey
            var serviceKey: String = "24%2FpJnYDR4XV94MesDsNCLczRWS6TzkgXkazU4usR4gOt1mDnMi9i2hwfhMIQOa9rKP791WsLYupJwYxM%2FjXhQ%3D%3D"
        }
        
        struct RealTimeBusResponse: Codable {
            let comMsgHeader: COMMsgHeader
            let msgHeader: MsgHeader
            let msgBody: MsgBody
        }
        
        struct COMMsgHeader: Codable {
            let responseTime, requestMsgID, responseMsgID, returnCode: String?
            let errMsg, successYN: String?
        }
        
        struct MsgHeader: Codable {
            let headerMsg, headerCD: String?
            let itemCount: Int
        }

        struct MsgBody: Codable {
            let itemList: [ItemList]?
        }

        // MARK: - ItemList
        struct ItemList: Codable {
            let dataTm: String? // 제공시간
            let busNum: String? // 차량번호
            let lastStnId: String? // 마지막으로 지나간 정류장 ID
            /// (3 : 여유, 4 : 보통, 5 : 혼잡, 6 : 매우혼잡)
            let congetion: String? // 차량내부 혼잡도
            let stopFlag: String? //정류소 도착 여부(0:운행중, 1:도착)
            let stId: String? //정류소 고유 ID
            
            enum CodingKeys: String, CodingKey {
                case busNum = "plainNo"
                case dataTm, congetion, lastStnId, stopFlag, stId
            }
        }
        
        init(parameters: RealTimeBusParameters) {
            let params = Parameters()
            
            params.append(.init(key: .vehId, value: parameters.vehId))
            params.append(.init(key: .serviceKey, value: parameters.serviceKey))
            
            self.parameters = params
        }
        
    }
}
