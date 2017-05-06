//
//  MapViewDelegate.swift
//  Restaurants Transit
//
//  Created by Jeremy Broutin on 5/6/17.
//  Copyright © 2017 Jeremy Broutin. All rights reserved.
//

import MapKit

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let restaurantAnnotation = annotation as? RestaurantAnnotation {
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin") as? MKPinAnnotationView {
                dequeuedView.annotation = restaurantAnnotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: restaurantAnnotation, reuseIdentifier: "Pin")
                view.canShowCallout = true
                view.animatesDrop = true
                view.detailCalloutAccessoryView = UIImageView(image: restaurantAnnotation.image)
                
                // Left Accessory
                let leftAccessory = UILabel(frame: CGRect(x: 0,y: 0,width: 50,height: 30))
                leftAccessory.text = restaurantAnnotation.eta
                leftAccessory.font = UIFont(name: "Verdana", size: 10)
                view.leftCalloutAccessoryView = leftAccessory
                
                // Right accessory view
                let image = UIImage(named: "bus.png")
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(image, for: UIControlState())
                view.rightCalloutAccessoryView = button
            }
            return view
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeTransit]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
}
