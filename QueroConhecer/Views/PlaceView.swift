//
//  PlaceView.swift
//  QueroConhecer
//
//  Created by Matheus Xavier on 29/06/22.
//

import Foundation
import UIKit
import MapKit
protocol PlaceViewDelegate: AnyObject {
    func didPresentAlert(alert: UIAlertController)
    func addPlace(place: Place)
}

class PlaceView: UIView {
    
    weak var delegate: PlaceViewDelegate?
    
    enum FindPlaceMessageType {
        case error(String)
        case confirmation(String)
    }
    
    var place: Place!
    
    let titleLb: UILabel = {
       let lb = UILabel()
        lb.text = "Digite o nome do local que deseja conhecer..."
        lb.textColor = .darkGray
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 16)
        return lb
    }()
    
    let localLb: UILabel = {
       let lb = UILabel()
        lb.text = "...ou escolha tocando no mapa por dois segundos"
        lb.textColor = .darkGray
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 16)
        return lb
    }()
    
    let localTf: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 14)
        tf.layer.borderColor = #colorLiteral(red: 0.003921568627, green: 0.7176470588, blue: 0.8901960784, alpha: 1)
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    private lazy var searchBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Escolher", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.7176470588, blue: 0.8901960784, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.tintColor = .white
        btn.anchor(width: 80)
        btn.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return btn
    }()
    
    private let mapView = MKMapView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSearch(){
        localTf.resignFirstResponder()
        let address = localTf.text
        
        mapView.toggleLoading()
        
        let geocoder = CLGeocoder()
        guard let address = address else {
            return
        }
        geocoder.geocodeAddressString(address) { placemarks, error in
            self.mapView.toggleLoading()
            guard error == nil else {
                self.showAlert(type: .error("Erro Desconhecido"))
                return
            }
            if !self.savePlace(with: placemarks?.first) {
                self.showAlert(type: .error("Erro Desconhecido"))
            }
        }
    }
    
    @objc func handleLongPressMapView(_ gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            mapView.toggleLoading()
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(coordinate: coordinate, altitude: 10, horizontalAccuracy: 10, verticalAccuracy: 10, timestamp: Date.now)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                self.mapView.toggleLoading()
                guard error == nil else {
                    self.showAlert(type: .error("Erro Desconhecido"))
                    return
                }
                if !self.savePlace(with: placemarks?.first) {
                    self.showAlert(type: .error("Erro Desconhecido"))
                }
            }
        }
    }
    
    func savePlace(with placemark: CLPlacemark?) -> Bool {
        guard let placemark = placemark, let coordinate = placemark.location?.coordinate else {
            return false
        }
        let address = Place.getFormattedAddress(with: placemark)
        place = Place(name: placemark.name ?? placemark.country ?? "Desconhecido", longitude: coordinate.longitude, latitude: coordinate.latitude,  address: address)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 3500, longitudinalMeters: 3500)
        mapView.setRegion(region, animated: true)
        self.showAlert(type: .confirmation(place.name))
        return true
    }
    
    func showAlert(type: FindPlaceMessageType){
        let title: String
        let message: String
        var hasConfirmation: Bool = false
        
        switch type {
        case .error(let errorMessage):
            title = "Erro"
            message = "\(errorMessage)"
        case .confirmation(let confirmMessage):
            title = "Local encontrado"
            message = "Deseja adicionar \(confirmMessage)"
            hasConfirmation = true
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if hasConfirmation {
            let confirmAction = UIAlertAction(title: "Ok", style: .default) { action in
                self.delegate?.addPlace(place: self.place)
            }
            alert.addAction(confirmAction)
        }
        delegate?.didPresentAlert(alert: alert)
    }
    
    func configureUI(){
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressMapView(_:)))
        gesture.minimumPressDuration = 2.0
        
        mapView.addGestureRecognizer(gesture)
        self.backgroundColor = .white
        self.addSubview(titleLb)
        titleLb.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 40)
        let stack = UIStackView(arrangedSubviews: [localTf, searchBtn])
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 15
        self.addSubview(stack)
        stack.anchor(top: titleLb.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 20, paddingRight: 20, height: 30)
        
        self.addSubview(localLb)
        localLb.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 40)
        
        self.addSubview(mapView)
        mapView.anchor(top: localLb.bottomAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20)
    }
}

extension PlaceView: MKMapViewDelegate {
    
}
