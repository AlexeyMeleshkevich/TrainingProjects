//
//  ViewController.swift
//  FindBeacon
//
//  Created by Alexey Meleshkevich on 30.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceLabel: UILabel!
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = UIColor.gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        
        let beaconIdentity = CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456)
        let beaconRegion = CLBeaconRegion(beaconIdentityConstraint: beaconIdentity, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconIdentity)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) { [weak self] in
            switch distance {
            case .far:
                self?.view.backgroundColor = UIColor.blue
                self?.distanceLabel.text = "FAR"
                
            case .immediate:
                self?.view.backgroundColor = UIColor.red
                self?.distanceLabel.text = "RIGHT HERE"
            
            case .near:
                self?.view.backgroundColor = UIColor.orange
                self?.distanceLabel.text = "NEAR"
                
            default:
                self?.view.backgroundColor = UIColor.gray
                self?.distanceLabel.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            showAlert(with: beacon.proximity)
        } else {
            update(distance: .unknown)
            showAlert(with: .unknown)
        }
    }
    
    func showAlert(with distance: CLProximity) {
        let message = "\(distance)"
        
        let alert = UIAlertController(title: "Scanning finished", message: "Beacon location is \(message)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}

