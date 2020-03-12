//
//  EarthquakesViewController.swift
//  Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class EarthquakesViewController: UIViewController {
	
    private var quakeFetcher = QuakeFetcher()
    
	// NOTE: You need to import MapKit to link to MKMapView
	@IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quakeFetcher.fetchQuakes { (quakes, error) in
            if let error = error {
                print("Error fetching quakes: \(error)")
                return
            }
            
            guard let quakes = quakes else { return }
            print("Quakes: \(quakes.count)")
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(quakes)
                
                // zoom to the first earthquake (sorted largest mag)
                guard let quake = quakes.first else { return } // TODO: Zoom to current pos
                
                let coordinateSpan = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                let region = MKCoordinateRegion(center: quake.coordinate, span: coordinateSpan)
                
                self.mapView.setRegion(region, animated: true)
            }
            
        }
    }
}
