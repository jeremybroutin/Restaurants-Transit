//
//  ViewController.swift
//  Restaurants Transit
//
//  Created by Jeremy Broutin on 5/6/17.
//  Copyright © 2017 Jeremy Broutin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    // MARK:- IBOutlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK:- Properties
    
    var names:[String]!
    var images:[UIImage]!
    var descriptions:[String]!
    var coordinates:[Any]!
    var currentRestaurantIndex: Int = 0
    lazy var locationManager: CLLocationManager = { [unowned self] in
        var manager = CLLocationManager()
        return manager
    }()

    // MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDefaultData()
        showUserLocation()
    }

    // MARK:- IBActions
    
    @IBAction func showNext(_ sender: Any) {
        if currentRestaurantIndex > names.count - 1{
            currentRestaurantIndex = 0
        }
        var point = createRestaurantAnnotation()
        let directionRequest = createDirectionRequest(destinationCoordinates: point.coordinate)
        mapView.setCenter(point.coordinate, animated: true)
        let directions = MKDirections(request: directionRequest)
        directions.calculateETA { (etaResponse, error) -> Void in
            if let error = error {
                print("Error while requesting ETA: \(error.localizedDescription)")
                point.eta = error.localizedDescription
            } else {
                point.eta = "\(Int((etaResponse?.expectedTravelTime)!/60)) min"
            }
            var doesExist = false
            for annotation in self.mapView.annotations{
                if annotation.coordinate == point.coordinate {
                    doesExist = true
                    point = annotation as! RestaurantAnnotation
                }
            }
            if !doesExist{
                self.mapView.addAnnotation(point)
            }
            self.mapView.selectAnnotation(point, animated: true)
            self.currentRestaurantIndex += 1
        }
    }

    // MARK:- Helper functions
    
    private func loadDefaultData() {
        // Some restaurants in London
        names = ["Pied a Terre", "Big Ben", "Hawksmoor Seven Dials", "Enoteca Turi", "Wiltons", "Scott's", "The Laughing Gravy", "Restaurant Gordon Ramsay"]
        
        // Restaurants' images to show in the pin callout
        images = [UIImage(named: "restaurant-1.jpeg")!, UIImage(named: "restaurant-2.jpeg")!, UIImage(named: "restaurant-3.jpeg.jpg")!, UIImage(named: "restaurant-4.jpeg")!, UIImage(named: "restaurant-5.jpeg")!, UIImage(named: "restaurant-6.jpeg")!, UIImage(named: "restaurant-7.jpeg")!, UIImage(named: "restaurant-8.jpeg")!]
        
        // Latitudes, Longitudes
        coordinates = [
            [51.519066, -0.135200],
            [51.513446, -0.125787],
            [51.465314, -0.214795],
            [51.507747, -0.139134],
            [51.509878, -0.150952],
            [51.501041, -0.104098],
            [51.485411, -0.162042],
            [51.513117, -0.142319]
        ]
        
        // Start with the first Restaurant in the array
        currentRestaurantIndex = 0
    }
    
    private func showUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    private func createRestaurantAnnotation() -> RestaurantAnnotation {
        let coordinate = coordinates[currentRestaurantIndex] as! [Double]
        let latitude: Double   = coordinate[0]
        let longitude: Double  = coordinate[1]
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let point = RestaurantAnnotation(coordinate: locationCoordinates)
        point.title = names[currentRestaurantIndex]
        point.image = images[currentRestaurantIndex]
        
        return point
    }
    
    private func createDirectionRequest(destinationCoordinates: CLLocationCoordinate2D) -> MKDirectionsRequest {
        let request = MKDirectionsRequest()
        let source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.source = source
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
        request.destination = destination
        request.requestsAlternateRoutes = false
        request.transportType = .transit
        return request
    }
}

