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
//            var serviceKey: String = Constant.serviceKey
            var serviceKey: String = "24%2FpJnYDR4XV94MesDsNCLczRWS6TzkgXkazU4usR4gOt1mDnMi9i2hwfhMIQOa9rKP791WsLYupJwYxM%2FjXhQ%3D%3D"
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
            let busRouteId: String? // 노선ID
            let busRouteNm: String? // 노선명(DB관리용)
            let busRouteAbrv: String? // 노선명(안내용 - 마을버스 제외
            let seq: String? // 순번
            let section: String? // 구간ID
            let station: String? // 정류소 고유ID
            let stationNm: String? // 정류소 이름
            let gpsX: String? // X좌표(WGS 84)
            let gpsY: String? // Y좌표(WGS 84)
            let direction: String? // 진행방향
            let fullSectDist: String? // 정류소간 거리
            let stationNo: String? // 정류소 번호
            // 노선 유형 (1:공항, 2:마을, 3:간선, 4:지선, 5:순환, 6:광역, 7:인천, 8:경기, 9:폐지, 0:공용)
            let routeType: String?
            let beginTm: String? // 첫차 시간
            let lastTm: String? // 막차 시간
            let trnstnid: String? // 회차지 정류소ID
            let posX: String? // X좌표(GRS80)
            let posY: String? // Y좌표(GRS80)
            let sectSpd: String? // 구간속도
            let arsID: String? // 정류소 고유번호
            let transYn: String? // 회차지 여부 (Y: 회차, N:회차지아님)
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
