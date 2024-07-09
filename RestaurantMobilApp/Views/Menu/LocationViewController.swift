//
//  LocationViewController.swift
//  RestaurantMobilApp
//
//  Created by Ö.Ş on 10.06.2024.
//

import UIKit
import SnapKit
import GoogleMaps

class LocationViewController: UIViewController {
    
    var zoom:Float = 15
    let lat = -23.562573
    let long = -46.654952
    weak var coordinator: MainCoordinatorProtocol?
    var mapView: GMSMapView!
    
    
    lazy private var btnZoomIn: UIButton = {
       let button = UIButton()
        button.setImage(.zoomIn, for: .normal)
        return button
    }()
    
    lazy private var btnZoomOut: UIButton = {
       let button = UIButton()
        button.setImage(.zoomOut, for: .normal)
        return button
    }()
    
    lazy private var btnMyLocation: UIButton = {
       let button = UIButton()
        button.setImage(.getLocation, for: .normal)
        return button
    }()
    
    lazy private var bottom_bg: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = .clear
        view.layer.masksToBounds = true
        view.image = .bottomBg
        return view
    }()
    
}


extension LocationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .themePrimary
        self.navigationItem.title = "Location"
        mapView = GMSMapView()
        self.mapView.mapStyle(withFilename: "darkMap", andType: "json")
        view.addSubview(mapView)
        view.addSubview(bottom_bg)
        view.addSubview(btnZoomIn)
        view.addSubview(btnZoomOut)
        view.addSubview(btnMyLocation)
        setupConstraints()
        addMarker()
        createMapView()
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        bottom_bg.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        btnZoomOut.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        btnZoomIn.snp.makeConstraints{
            $0.bottom.equalTo(btnZoomOut.snp.top).offset(-11)
            $0.trailing.equalToSuperview().offset(-16)
        }
        btnMyLocation.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    
    private func createMapView(){
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: zoom)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
    }
    
    private func addMarker(){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.title = "Something"
        marker.snippet = "description"
        marker.map = mapView
        marker.icon = UIImage(named: "burger")
    }
    
    @objc private func didButtonTapped(_ button: UIButton) {
        
        if button == btnZoomIn {
            zoom = zoom + 1
            self.mapView.animate(toZoom: zoom)
        }
        
        if button == btnZoomOut {
            zoom = zoom - 1
            self.mapView.animate(toZoom: zoom)
        }
        
        if button == btnMyLocation {
            guard let lat = self.mapView.myLocation?.coordinate.latitude, let lng = self.mapView.myLocation?.coordinate.longitude else {
                return
            }
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: zoom)
            self.mapView.animate(to: camera)
            
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            let userLocation = GMSMarker(position: position)
            userLocation.map = mapView
        }
        
        
    }
    
}


extension GMSMapView {
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            }else {
                NSLog("Unable to find darkMap")
            }
        }
        catch {
            NSLog("failded to load. \(error)")
        }
    }
}

