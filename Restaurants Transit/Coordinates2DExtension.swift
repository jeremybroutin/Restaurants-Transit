//
//  Coordinates2DExtension.swift
//  Restaurants Transit
//
//  Created by Jeremy Broutin on 5/6/17.
//  Copyright © 2017 Jeremy Broutin. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
