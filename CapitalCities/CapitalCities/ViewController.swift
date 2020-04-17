//
//  ViewController.swift
//  CapitalCities
//
//  Created by Alexey Meleshkevich on 17.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(setMapState))
        
        mapView.delegate = self
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "It was founded a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
        
        mapView.addAnnotations([london, oslo, paris, washington])
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        let id = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = UIColor.purple
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        let alert = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Wiki", style: .default, handler: { [weak self] (action) in
            let wikiVC = WikipediaController()
            wikiVC.endPoint = placeName ?? "Minsk"
            self?.navigationController?.pushViewController(wikiVC, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func setMapState() {
        let alert = UIAlertController(title: "Choose a map type", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .hybrid
        }))
        alert.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .hybrid
        }))
        alert.addAction(UIAlertAction(title: "hybridFlyover", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .hybridFlyover
        }))
        alert.addAction(UIAlertAction(title: "mutedStandard", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .mutedStandard
        }))
        alert.addAction(UIAlertAction(title: "satellite", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .satellite
        }))
        alert.addAction(UIAlertAction(title: "satelliteFlyover", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .satelliteFlyover
        }))
        alert.addAction(UIAlertAction(title: "standard", style: .default, handler: { [weak self] (action) in
            self?.mapView.mapType = .standard
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

