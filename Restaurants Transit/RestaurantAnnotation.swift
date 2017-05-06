//
//  RestaurantAnnotation.swift
//  Restaurants Transit
//
//  Created by Jeremy Broutin on 5/6/17.
//  Copyright © 2017 Jeremy Broutin. All rights reserved.
//

import UIKit
import MapKit

class RestaurantAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    var eta: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
