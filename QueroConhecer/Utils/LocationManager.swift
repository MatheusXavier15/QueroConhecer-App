//
//  LocationManager.swift
//  QueroConhecer
//
//  Created by Matheus Xavier on 01/07/22.
//

import CoreLocation

/*
 @LocationManager, Instância de localização.
 Utiliza o CoreLocation para determinar a localização do usuário.
 */
class LocationHandler: NSObject, CLLocationManagerDelegate {
    static let shared = LocationHandler()
    var locationManager: CLLocationManager!
    var location: CLLocation?
    private var requestLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    
    private var address = ""
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    /*
     @requestLocationAuthorization, pede autorização do usuário para uso da localização.
     Emite a execução de uma função que contém um boolean com o resultado da interação com o usuário.
     A request de autoriação do uso de localização só pode ser feita uma vez.
     */
    public func requestLocationAuthorization(completion: @escaping(Bool) -> Void){
        self.locationManager.delegate = self
        
        if #available(iOS 13.4, *) {
    
            self.requestLocationAuthorizationCallback = { status in
                switch status {
                case .notDetermined:
                    self.locationManager.requestWhenInUseAuthorization()
                case .restricted, .denied:
                    completion(false)
                    break
                case .authorizedWhenInUse:
                    self.locationManager.startUpdatingLocation()
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    completion(true)
                case .authorizedAlways:
                    break
                @unknown default:
                    break
                }
            }
        } else {
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    // MARK: -> Delegate
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.requestLocationAuthorizationCallback?(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.location = location
        }
    }
}
