//
//  GPSViewController.swift
//  iOSDataDemo
//
//  Created by Du Shuchen on 2016/06/15.
//  Copyright © 2016年 Du Shuchen. All rights reserved.
//

import UIKit
import CoreLocation

import BTNavigationDropdownMenu

struct VisitedPlace {
    
    var location: CLLocationCoordinate2D
    var arrival: NSDate
    var departure: NSDate
    var area: CLLocationAccuracy
    
    init(location: CLLocationCoordinate2D, area: CLLocationAccuracy, arrival: NSDate, departure: NSDate) {
        
        self.location = location
        self.area = area
        self.arrival = arrival
        self.departure = departure
    }
}

class GPSViewController: UIViewController {

    @IBOutlet weak var coordinate: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var visitTable: UITableView!
    
    var locationManager: CLLocationManager!
    var longitude: CLLocationDegrees!
    var latitude: CLLocationDegrees!
    
    let items = ["1m", "10m", "100m", "1km", "3km"]
    var currentAccuracy = kCLLocationAccuracyBest
    
    var visitedPlaces = [VisitedPlace]()
    
    var menuView: BTNavigationDropdownMenu!
    
    override func viewDidDisappear(animated: Bool) {
        
        locationManager.stopUpdatingLocation()
    }
    
    func loadCurrentAccuracy(accuracy: String) {
        
        switch accuracy {
        case "1m":
            currentAccuracy = kCLLocationAccuracyBest
        case "10m":
            currentAccuracy = kCLLocationAccuracyNearestTenMeters
        case "100m":
            currentAccuracy = kCLLocationAccuracyHundredMeters
        case "1km":
            currentAccuracy = kCLLocationAccuracyKilometer
        case "3km":
            currentAccuracy = kCLLocationAccuracyThreeKilometers
        default:
            return
        }
    }
    
    func loadMenu() {
        
        menuView = BTNavigationDropdownMenu(navigationController: super.navigationController, title: "精度", items: items)
        
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {[unowned self] (indexPath: Int) in
            
            self.loadCurrentAccuracy(self.items[indexPath])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        
        longitude = CLLocationDegrees()
        latitude = CLLocationDegrees()
        
        visitTable.delegate = self
        visitTable.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = currentAccuracy
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.NotDetermined {
            
            locationManager.requestAlwaysAuthorization()
        }
        
        loadMenu()
        locationManager.startUpdatingLocation()
        locationManager.stopMonitoringVisits()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GPSViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return visitedPlaces.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VISIT-ITEM", forIndexPath: indexPath) as! VisitTableViewCell
        
        let place = visitedPlaces[indexPath.row]
        
        let lo = place.location.longitude
        let la = place.location.latitude
        
        cell.coordinate.text = "\(lo), \(la)"
        cell.arrival.text = place.arrival.description
        cell.departure.text = place.departure.description
        cell.area.text = place.area.description
        
        return cell
    }
}

extension GPSViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didVisit visit: CLVisit) {
        
        let coor = visit.coordinate
        let arrival = visit.arrivalDate
        let departure = visit.departureDate
        let area = visit.horizontalAccuracy
        
        let visitedPlace = VisitedPlace(location: coor, area: area, arrival: arrival, departure: departure)
        
        visitedPlaces.append(visitedPlace)
        
        visitTable.reloadData()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        latitude = newLocation.coordinate.latitude
        longitude = newLocation.coordinate.longitude
        
        coordinate.text = "\(longitude), \(latitude)"
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { places, error in
        
            guard error == nil else {
                
                print("reverse geocoder fails: \(error?.description)")
                return
            }
            
            guard let _places = places where _places.count > 0 else {
                
                print("problems with data from geocoder")
                return
            }
            
            let pm = _places[0] as CLPlacemark
            self.displayLocation(pm)
        })
    }
    
    func displayLocation(placemark: CLPlacemark) {
        
        var address = ""
        
        address = placemark.locality != nil ? placemark.locality! : ""
        address += ", "
        address += placemark.postalCode != nil ? placemark.postalCode! : ""
        address += ", "
        address += placemark.administrativeArea != nil ? placemark.administrativeArea! : ""
        address += ", "
        address += placemark.country != nil ? placemark.country! : ""
        location.text = address
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("error updating location: " + error.localizedDescription)
    }
}