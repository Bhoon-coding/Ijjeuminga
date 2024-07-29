//
//  BusPositionAPI.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/14.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

extension Rest {
    struct BusPosition: APIDefinition {
        
        var path: String = "/api/rest/buspos/getBusPosByRouteSt"
        
        var headers: HTTPHeaders?
        
        var parameters: Parameters?
        
        var method: HTTPMethod = .get
        
        struct BusPositionParameters: Codable {
            let busRouteId: String
            var startOrd: String = "1"
            var endOrd: String = "10"
            var serviceKey: String = Constant.serviceKey
        }
        
        struct BusPositionResponse: Codable {
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
            let stopFlag: String? // 정류소 도착여부
            let lastStnId: String? // 마지막으로 지나온 정류장 ID
            let busNum: String? // 차량번호
            let vehId: String? // 버스 ID
            let posX: String? // 버스 위치 X 좌표
            let posY: String? // 버스 위치 Y 좌표
            
            enum CodingKeys: String, CodingKey {
                case busNum = "plainNo"
                case stopFlag = "stopFlag"
                case lastStnId = "lastStnId"
                case vehId = "vehId"
                case posX = "posX"
                case posY = "posY"
            }
        }

        init(parameters: BusPositionParameters) {
            let params = Parameters()
            
            params.append(.init(key: .busRouteId, value: parameters.busRouteId))
            params.append(.init(key: .startOrd, value: parameters.startOrd))
            params.append(.init(key: .endOrd, value: parameters.endOrd))
            params.append(.init(key: .serviceKey, value: parameters.serviceKey))
            
            self.parameters = params
        }
        
    }
}

protocol BusPositionAPIServiceable {
    func getBusPosition(
        with busRouteId: String
    ) -> Single<Rest.BusPosition.BusPositionResponse>
}

struct BusPositionAPIService: BusPositionAPIServiceable {
    func getBusPosition(
        with busRouteId: String
    ) -> Single<Rest.BusPosition.BusPositionResponse> {
        Rest.BusPosition(parameters: Rest.BusPosition.BusPositionParameters(
            busRouteId: busRouteId
        ))
        .rx
        .request()
    }
}
            
extension Reactive where Base == Rest.BusPosition {
    func request() -> Single<Rest.BusPosition.BusPositionResponse> {
        NetworkManager.request(
            parameters: base.parameters,
            path: base.path,
            method: base.method,
            header: base.headers,
            encoding: URLEncoding.queryString
        )
    }
}
