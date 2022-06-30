//
//  Place.swift
//  QueroConhecer
//
//  Created by Matheus Xavier on 29/06/22.
//

import Foundation
import CoreLocation

struct Place: Codable, Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
    let longitude: CLLocationDegrees
    let latitude: CLLocationDegrees
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func getFormattedAddress(with placemark: CLPlacemark) -> String {
        var address = ""
        if let street = placemark.thoroughfare {
            address += street
        }
        if let number = placemark.subThoroughfare {
            address += ", \(number)"
        }
        if let sublocality = placemark.subLocality {
            address += ", \(sublocality)"
        }
        if let locality = placemark.locality {
            address += "\n \(locality)"
        }
        if let state = placemark.administrativeArea {
            address += " - \(state)"
        }
        if let country = placemark.country {
            address += ", \(country)"
        }
        
        return address
    }
}
