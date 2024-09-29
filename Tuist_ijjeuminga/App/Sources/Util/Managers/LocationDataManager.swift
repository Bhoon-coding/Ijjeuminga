//
//  LocationDataManager.swift
//  Ijjeuminga
//
//  Created by BH on 2024/07/01.
//

import CoreLocation

import RxSwift

class LocationDataManager: NSObject {
    
    static let shared = LocationDataManager()
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    let showAlert = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    func requestLocationAuth() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func checkLoactionAuth() {
        let status = locationManager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways || status == .notDetermined else {
            self.showAlert.onNext(())
            return
        }
    }
    
    private func handleUpdatingLocation(_ manager: CLLocationManager) {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
}

extension LocationDataManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("authStatus: \(manager.authorizationStatus)")
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            handleUpdatingLocation(manager)
        case .authorizedAlways:
            handleUpdatingLocation(manager)
        case .notDetermined:
//            manager.requestAlwaysAuthorization()
            break
        case .restricted:
            // TODO: [] location을 지원하지 않는 기기인 경우 분기처리
            break
        case .denied:
            self.showAlert.onNext(())
            print("권한팝업 필요")
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        self.lastLocation = lastLocation
    }
    
    func compareLocation(to stations: [Rest.BusRouteInfo.ItemList]) -> Observable<(Int, Int)> {
        // TODO: [] 현재 거리와 500m ~ 1km 차이나는 정류장을 현재정류장으로 보여지게 해야함
        guard let currentLocation = self.lastLocation else { return .empty() }
        var distances: [CLLocationDistance] = []
        for station in stations {
            guard let gpsX = station.gpsX, let gpsY = station.gpsY else {
                print("stations 데이터가 없음")
                return .empty()
            }
            let stationLocation = CLLocation(latitude: Double(gpsY)!, longitude: Double(gpsX)!)
            let distance = currentLocation.distance(from: stationLocation)
            distances.append(distance)
        }
        
        if let minDistance = distances.min() {
            let filtered = distances.filter { $0 != minDistance }
            if let secondMinDistance = filtered.min(),
               let nearestIndex = distances.firstIndex(of: minDistance),
               let secondNearIndex = distances.firstIndex(of: secondMinDistance) {
                
                locationManager.stopUpdatingLocation()
                return .just((nearestIndex, secondNearIndex))
            }
        }
        return .empty()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("did Failed With Error: \(error.localizedDescription)")
    }
    
}
