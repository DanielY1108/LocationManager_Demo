//
//  LocationManager.swift
//  LocationManager_Demo
//
//  Created by JINSEOK on 2023/05/11.
//

import UIKit
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    typealias FetchLocationCompletion = (CLLocationCoordinate2D?, Error?) -> Void

    private let locationManager = CLLocationManager()
    // 동작을 담아주기 위해 클로저를 만들어 줌
    private var didFetchLocation: FetchLocationCompletion?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        // 위치관련 정보를 받기위해선 무조건 호출되어야 합니다. (또는 requestAlwaysAuthorization, plist에 따라서 설정하기)
        locationManager.requestWhenInUseAuthorization()
        // 위치 정확도 (여기선 배터리 상황에 따른 최적의 정확도로 설정)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdatingLocation() {
        // 여러번 호출되도 새 이벤트가 생성되지 않아서 stopUpdatingLocation을 사용해줘야 합니다.
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // 현재 인증 상태 확인
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            print("Location Auth: Allow")
        case .notDetermined , .denied , .restricted:
            print("Location Auth: denied")
        default: break
        }
    }
    
    // 현재 위치를 받아올 수 있는 메서드
    func fetchLocation(completion: @escaping FetchLocationCompletion) {
        // 위치를 받기위해 시작시켜준다.
        startUpdatingLocation()
        
        // completion 동작을 didFetchLocation 동작에 담는다.
        self.didFetchLocation = completion
        
        // 위치 값을 받은 후 새로운 이벤트를 받기위해 정지를 시켜줍니다.
        self.stopUpdatingLocation()
        
    }
}

extension LocationManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 사용자의 최신 위치 정보를 가져옵니다.
        guard let location = locations.last else { return }
        
        let coordinate = location.coordinate
        
        // coordinate 값을 갖고 저장된 동작을 실행
        self.didFetchLocation?(coordinate, nil)
    }
    
    // 잠재적인 오류에 응답하기 위해서 생성
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to Fetch Location (\(error))")
        
        self.didFetchLocation?(nil, error)
    }
}
