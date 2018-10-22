//
//  MapViewController.swift
//  FMAD
//
//  Created by Pranav Karnani on 18/10/18.
//  Copyright © 2018 NotACoder. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var type = ""
    var locValue: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var containerTransform = CGAffineTransform()
    var x = 0, flag = 0
    var current = DeskLocations(lat: 0,long:0,price:0,id:"", name: "",address: "", desks: 0)
    var min = 100000000.0
    var closest : DeskLocations = DeskLocations(lat: 0,long:0,price:0,id:"", name: "",address: "", desks: 0)
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var priceCard: UIView!
    @IBOutlet weak var priceCardBttn: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fromInput: UITextField!
    @IBOutlet weak var toInput: UITextField!
    @IBOutlet weak var confirmBooking: UIButton!
    
    @IBAction func to(_ sender: UITextField) {
        type = "to"
        print(type)
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    
    @IBAction func from(_ sender: UITextField) {
        type = "from"
        print(type)
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        if type == "to" {
            fromInput.text = timeFormatter.string(from: sender.date)
        }
        else if type == "from" {
            toInput.text = timeFormatter.string(from: sender.date)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func confirmBookingTapped(_ sender: Any) {

    }
    
    override func viewDidLoad() {
        setup(field: fromInput)
        setup(field: toInput)
        
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        mapView.showsPointsOfInterest = true
        mapView.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        containerTransform = cardView.transform
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(MapViewController.swiped))
        swipeDown.direction = .down
        cardView.addGestureRecognizer(swipeDown)
        view.bringSubviewToFront(headerView)
        view.bringSubviewToFront(cardView)
    }
    
    func setup(field: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .dateAndTime
        field.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getLocations()
    }
    
    @objc func swiped() {
        priceCard.alpha = 1
        UIView.animate(withDuration: 0.4, animations: {
            self.cardView.transform = self.containerTransform
        }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        cardView.makeCard(myView: cardView)
        cardView.makeCard(myView: headerView)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locValue = (manager.location?.coordinate ?? nil) ?? CLLocationCoordinate2D(latitude: 12.9718, longitude: 79.1589)
        
        if(x == 0) {
            let region = MKCoordinateRegion(center: locValue, span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
            mapView.setRegion(region, animated: true)
            x = 1
        }
    }
    
    func getLocations() {
        Services.shared.getLocations { (status) in
            if(status == 1) {
                for item in locationList.data {
                    let dist = self.calc_dist(lon1: item.long, lat1: item.lat)
                    if dist < self.min {
                        self.closest = item
                        self.min = dist
                    }
                    let latDiff = abs(self.locValue.latitude - item.lat)
                    let longDiff = abs(self.locValue.longitude - item.long)
                    if(latDiff <= 0.2 && longDiff<=0.2) {
                        self.current = item
                        let coord = CLLocationCoordinate2D(latitude: item.lat, longitude: item.long);
                        let anno = MKPointAnnotation()
                        anno.coordinate = coord
                        anno.title = item.name
                        anno.subtitle = String(item.price)
                        DispatchQueue.main.async {
                            self.mapView.addAnnotation(anno)
                            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                        }
                    }
                }
            }
            else {
                print("Location errr");
            }
            self.refreshView(data: self.closest)
        }
        
    }
    
    func calc_dist(lon1: Double, lat1: Double) -> Double {
        let lon2 = locValue.longitude
        let lat2 = locValue.latitude
        let dlon = (lon2 - lon1).degreesToRadians
        let dlat = (lat2 - lat1).degreesToRadians
        let a = pow(sin(dlat/2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon/2), 2)
        let c = 2 * asin(sqrt(a))
        return 6367000 * c
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        flag = 1
        let select = view.annotation
        for item in locationList.data {
            if (item.name == select?.title) {
                self.current = item
                self.refreshView(data: item)
            }
        }
    }
    
    func refreshView(data: DeskLocations) {
        DispatchQueue.main.async {
            self.name.text = data.name
            self.price.text = String(data.price)
            self.distance.text = String(Int(self.calc_dist(lon1: data.long, lat1: data.lat))) + " METRES"
            self.animate()
        }
    }
    
    func animate() {
        if(flag == 1) {
            confirmBooking.setTitle("Proceed for \(current.price)", for: .normal)
            priceCard.alpha = 0
            UIView.animate(withDuration: 0.4, animations: {
                self.cardView.transform = CGAffineTransform(translationX: 0, y: -280)
            }, completion: nil)
        }
    }
    
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { return CGFloat(Int(self)) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
