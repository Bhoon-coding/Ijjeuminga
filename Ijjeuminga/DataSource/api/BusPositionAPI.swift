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

protocol BusPositionAPIServiceable {
    func getBusPosition(
        with busRouteId: String
    ) -> Single<Rest.Buspos.BusPosition.BusPositionResponse>
}

struct BusPositionAPIService: BusPositionAPIServiceable {
    func getBusPosition(
        with busRouteId: String
    ) -> Single<Rest.Buspos.BusPosition.BusPositionResponse> {
        Rest.Buspos.BusPosition(parameters: Rest.Buspos.BusPosition.BusPositionParameters(
            busRouteId: busRouteId
        ))
        .rx
        .request()
    }
}
            
extension Reactive where Base == Rest.Buspos.BusPosition {
    func request() -> Single<Rest.Buspos.BusPosition.BusPositionResponse> {
        NetworkManager.request(
            parameters: base.parameters,
            path: base.path,
            method: base.method,
            header: base.headers,
            encoding: URLEncoding.queryString
        )
    }
}

extension Rest.Buspos {
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
            let sectionOrd: String // 구간순번
            let sectionId: String // 구간ID
            let stopFlag: String // 정류소 도착여부
            let dataTm: String // 제공시간
            let busNum: String // 차량번호
            let congetion: String // 차량내부 혼잡도
            
            enum CodingKeys: String, CodingKey {
                case sectionOrd = "sectOrd"
                case busNum = "plainNo"
                case sectionId, stopFlag, dataTm, congetion
            }
        }
        
        init(parameters: BusPositionParameters) {
            let params = Parameters()
            
            params.append(.init(key: .busRouteId, value: parameters.busRouteId))
//            params.append(.init(key: .startOrd, value: parameters.startOrd))
//            params.append(.init(key: .endOrd, value: parameters.endOrd))
//            params.append(.init(key: .serviceKey, value: parameters.serviceKey))
            
            self.parameters = params
        }
        
    }
}


