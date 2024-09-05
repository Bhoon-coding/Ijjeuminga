//
//  BustRouteInfoAPI.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/23.
//

import Foundation

import Alamofire
import RxSwift
import RxCocoa

extension Rest {
    struct BusRouteInfo: APIDefinition {
        var path: String = "/api/rest/busRouteInfo/getStaionByRoute"
        
        var headers: HTTPHeaders?
        
        var parameters: Parameters?
        
        var method: HTTPMethod = .get
        
        struct BusRouteInfoParameters: Codable {
            let busRouteId: String
            var serviceKey: String = Constant.serviceKey
            var resultType: String = "json"
        }
        
        struct BusRouteInfoResponse: Codable {
            let comMsgHeader: COMMsgHeader
            let msgHeader: MsgHeader
            let msgBody: MsgBody
        }

        struct COMMsgHeader: Codable {
            let responseTime, requestMsgID, responseMsgID, returnCode: String?
            let errMsg, successYN: String?
        }

        // MARK: - MsgBody
        struct MsgBody: Codable {
            let itemList: [ItemList]?
        }

        // MARK: - ItemList
        struct ItemList: Codable {
            let busRouteID, busRouteNm, busRouteAbrv, seq: String?
            let section, station, arsID, stationNm: String?
            let gpsX, gpsY, posX, posY: String?
            let fullSectDist: String?
            let direction: String?
            let stationNo, routeType, beginTm, lastTm: String?
            let trnstnid, sectSpd: String?
            let transYn: String?
        }

        // MARK: - MsgHeader
        struct MsgHeader: Codable {
            let headerMsg, headerCD: String?
            let itemCount: Int
        }
        
        init(parameters: BusRouteInfoParameters) {
            let params = Parameters()
            params.append(.init(key: .serviceKey, value: parameters.serviceKey))
            params.append(.init(key: .busRouteId, value: parameters.busRouteId))
            params.append(.init(key: .resultType, value: parameters.resultType))
            self.parameters = params
        }
    }
}

protocol BusRouteInfoAPIServiceable {
    func getStaionByRoute(with busRouteId: String) -> Single<Rest.BusRouteInfo.BusRouteInfoResponse>
}

struct BusRouteInfoAPIService: BusRouteInfoAPIServiceable {
    func getStaionByRoute(with busRouteId: String) -> RxSwift.Single<Rest.BusRouteInfo.BusRouteInfoResponse> {
        Rest.BusRouteInfo(parameters: .init(busRouteId: busRouteId))
            .rx
            .request()
    }
    
}

extension Reactive where Base == Rest.BusRouteInfo {
    func request() -> Single<Rest.BusRouteInfo.BusRouteInfoResponse> {
        return NetworkManager.request(
            parameters: base.parameters,
            path: base.path,
            encoding: URLEncoding.queryString
        )
    }
}
