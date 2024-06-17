//
//  NetworkManager.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/11.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift

class NetworkManager {
    static let instance: NetworkManager = .init()

    let session: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 4
        // host 당 최대 연결 수 제한 ( 4 )
        configuration.httpMaximumConnectionsPerHost = 4

        session = Session(configuration: configuration, interceptor: NetworkIntercepter())
    }

    // 주의 : 기 정의된 에러코드 먼저 확인 후 최후로 활용할 것
    static func createHttpError(_ response: HTTPURLResponse, error: AFError?) -> CustomError.NetworkError? {
        if response.statusCode >= 200, response.statusCode < 300 {
            return nil
        }

        // TODO: rechability
        if let nsError = error as NSError? {
            // when no status code available, check timeout of networkAvailability
            if nsError.code == CFNetworkErrors.cfurlErrorTimedOut.rawValue {
                return CustomError.NetworkError.networkTimeout
            } else if nsError.code == CFNetworkErrors.cfurlErrorNotConnectedToInternet.rawValue
                || nsError.code == CFNetworkErrors.cfurlErrorCannotFindHost.rawValue
                || nsError.code == CFNetworkErrors.cfurlErrorCannotConnectToHost.rawValue
                || nsError.code == CFNetworkErrors.cfurlErrorNetworkConnectionLost.rawValue
                || nsError.code == CFNetworkErrors.cfurlErrorDNSLookupFailed.rawValue
            {
                return CustomError.NetworkError.networkUnavailable
            }

            return nil
        }

        return nil
    }

    static func request<R: Codable>(host: String = APICommon.host,
                                    parameters: Parameters? = nil,
                                    path: String,
                                    method: HTTPMethod = .get,
                                    header: HTTPHeaders? = nil,
                                    encoding: ParameterEncoding = URLEncoding(destination: .methodDependent, arrayEncoding: .brackets, boolEncoding: .literal))
        -> Single<R>
    {
        Single<R>.create { observer in

            guard let url = URL(string: host + path) else {
                observer(.failure(CustomError.NetworkError.invalidURL))
                return Disposables.create()
            }

            let request = NetworkManager.instance.session
                .request(url,
                         method: method,
                         parameters: parameters?.toDictionary(),
                         encoding: encoding,
                         headers: header)
                .responseDecodable(of: R.self) { res in

                    var responseBodyString = ""

                    if let responseBody = res.data,
                       let stringData = String(data: responseBody, encoding: .utf8)
                    {
                        responseBodyString = stringData
                    }

                    switch res.result {
                    case .failure(let afError):
                        
                        Log.network(afError)
                        Log.network("========= Error 😢 ===========")
                        Log.network("||")
                        Log.network("|| host : \(res.request?.url?.host ?? "")")
                        Log.network("|| request path : \(res.request?.url?.path ?? "")")
                        Log.network("|| request url : \(res.request?.url?.absoluteString ?? "")")
                        Log.network("|| request headers : \(res.request?.headers ?? [:])")
                        Log.network("|| response body : \(responseBodyString)")
                        Log.network("|| http Code : \(res.response?.statusCode ?? -1)")
                        Log.network("||")
                        Log.network("==============================")
                        
                        // 기 정의된 에러 코드 체크
                        if let response = res.response {
                            observer(.failure(CustomError.NetworkError.apiError(definition: CommonAPIError(httpStatusCode: response.statusCode, errorMsg: afError.failureReason))))
                            return
                        }
                

                        // 네트워크 연결 유실 체크
                        guard let httpResponse = res.response,
                              let httpError = NetworkManager.createHttpError(httpResponse, error: afError)
                        else {
                            // 기 정의된 네트워크 연결 유실 에러 아닐 경우 Alfamofire 자체 에러 전달
                            observer(.failure(afError))
                            return
                        }
                        
                        // parsing fail 체크
                        do {
                            if let rawData = res.data {
                                _ = try JSONDecoder().decode(R.self, from: rawData)
                            } else {
                                observer(.failure(CustomError.NetworkError.parsingFail))
                                Log.error(" \(#function): \(CustomError.NetworkError.parsingFail) -> \(res)")
                                return
                            }
                        } catch {
                            Log.network(afError)
                            observer(.failure(CustomError.NetworkError.parsingFail))
                            Log.error("Catch \(#function): \(CustomError.NetworkError.parsingFail) -> \(res.data)")
                            return
                        }

                        // 기 정의된 네트워크 연결 관련 에러 처리
                        observer(.failure(httpError))
                    case let .success(response):
                        Log.network("========= Response 🎁 =========")
                        Log.network("||")
                        Log.network("|| host : \(res.request?.url?.host ?? "")")
                        Log.network("|| request path : \(res.request?.url?.path ?? "")")
                        Log.network("|| request url : \(res.request?.url?.absoluteString ?? "")")
                        Log.network("|| response body : \(responseBodyString)")
                        Log.network("|| http Code : \(res.response?.statusCode ?? -1)")
                        Log.network("||")
                        Log.network("==============================")
                        observer(.success(response))
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

private final class NetworkIntercepter: RequestInterceptor {
    /// 최대 retry count 지정. 3번.
    static let maximumRetryCount: Int = 3

    /// 로그 등록
    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var jsonHttpBodyString = ""
        if let httpBodyData = urlRequest.httpBody,
           let stringData = String(data: httpBodyData, encoding: .utf8)
        {
            jsonHttpBodyString = stringData
        }
        Log.network("========= Request 🚀 =========")
        Log.network("||")
        Log.network("|| host : \(urlRequest.url?.host ?? "")")
        Log.network("|| path : \(urlRequest.url?.path ?? "")")
        Log.network("|| method : \(urlRequest.httpMethod ?? "")")
        Log.network("|| header : \(urlRequest.headers)")
        if !jsonHttpBodyString.isEmpty {
            Log.network("|| requestbody : \(jsonHttpBodyString)")
        }
        Log.network("||")
        Log.network("==============================")
        completion(.success(urlRequest))
    }

    /// 네트워크 연결 유실 시 Retry 설정
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // 최대 retry count 도달 시 session cancel, retry 종료
        guard request.retryCount < NetworkIntercepter.maximumRetryCount else {
            Log.network("NetworkRetryHandler retry finished..")
            session.cancelAllRequests()
            completion(.doNotRetry)
            return
        }
        // Device Network 연결 유실, timeout 발생 시 1.5초 간격 retry 시도
        if let nsError = ((error.asAFError)?.underlyingError as? NSError),
           nsError.code == CFNetworkErrors.cfurlErrorTimedOut.rawValue
        {
            var requestBodyString = ""

            if let requestBody = request.request?.httpBody,
               let stringData = String(data: requestBody, encoding: .utf8)
            {
                requestBodyString = stringData
            }

            Log.network("========= Retry Request 🤔 =========")
            Log.network("||")
            Log.network("|| host : \(request.request?.url?.host ?? "")")
            Log.network("|| path : \(request.request?.url?.path ?? "")")
            Log.network("|| method : \(request.request?.httpMethod ?? "")")
            Log.network("|| header : \(request.request?.headers)")
            if !requestBodyString.isEmpty {
                Log.network("|| body : \(requestBodyString)")
            }
            Log.network("||")
            Log.network("==============================")
            
            completion(.retry)
        } else {
            Log.network("NetworkRetryHandler not handling.. : \(String(describing: error.asAFError))")
            completion(.doNotRetry)
        }
    }
}

