//
//  LocationDataManager.swift
//  Ijjeuminga
//
//  Created by BH on 2024/07/01.
//

import CoreLocation

final class LocationDataManager: NSObject {
    private let locationManager = CLLocationManager()
    var stations: [Rest.BusRouteInfo.ItemList] = []
    var nearestStationIndex: Int = -1
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    deinit { }
    
    func requestLocationAuth() {
        guard locationManager.authorizationStatus == .notDetermined else { return }
        locationManager.requestAlwaysAuthorization()
    }
    
    private func handleUpdatingLocation(_ manager: CLLocationManager) {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    private func compareLocation(with currentLocation: CLLocation) {
        // TODO: [] 현재 거리와 500m ~ 1km 차이나는 정류장을 현재정류장으로 보여지게 해야함
        var distances: [CLLocationDistance] = []
        for station in stations {
            guard let gpsX = station.gpsX,
                  let gpsY = station.gpsY
            else {
                return
            }
            let stationLocation = CLLocation(latitude: Double(gpsY)!, longitude: Double(gpsX)!)
            let distance = currentLocation.distance(from: stationLocation)
            distances.append(distance)
        }
        
        if let minDistance = distances.min() {
            if let nearestIndex = distances.firstIndex(of: minDistance) {
                print("가장 가까운 정류장: \(stations[nearestIndex])")
                self.nearestStationIndex = nearestIndex
                locationManager.stopUpdatingLocation()
            }
        } else {
            print("No distances calculated.")
        }
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
            manager.requestAlwaysAuthorization()
        case .restricted:
            // TODO: [] location을 지원하지 않는 기기인 경우 분기처리
            break
        case .denied:
            // TODO: [] 권한 동의 요청 팝업 (시스템 설정 이동)
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        compareLocation(with: lastLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("did Failed With Error: \(error.localizedDescription)")
    }
    
}
