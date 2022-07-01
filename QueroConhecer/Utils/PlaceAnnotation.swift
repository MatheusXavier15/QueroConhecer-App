//
//  PlaceAnnotation.swift
//  QueroConhecer
//
//  Created by Matheus Xavier on 01/07/22.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation {
    enum AnnotationType {
        case place
        case poi
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: AnnotationType
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, type: AnnotationType){
        self.coordinate = coordinate
        self.type = type
    }
}
