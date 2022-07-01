//
//  ShowPlaceViewController.swift
//  QueroConhecer
//
//  Created by Matheus Xavier on 29/06/22.
//

import Foundation
import UIKit
import MapKit

class ShowPlaceViewController: UIViewController {
    
    private let map = MKMapView()
    private let places: [Place]!
    private var poi: [MKAnnotation] = []
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "O que você deseja buscar?"
        return sb
    }()
    
    private let nameLb: UILabel =  {
        let lb = UILabel()
        lb.text = "Name"
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.numberOfLines = 0
        lb.textAlignment = .left
        return lb
    }()
    
    private let addresLb: UILabel =  {
        let lb = UILabel()
        lb.text = "Addres"
        lb.font = .systemFont(ofSize: 14)
        lb.numberOfLines = 0
        lb.adjustsFontSizeToFitWidth = true
        lb.textAlignment = .left
        return lb
    }()
    
    private lazy var routeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Trace Route", for: .normal)
        btn.addTarget(self, action: #selector(handleRoute), for: .touchUpInside)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = #colorLiteral(red: 0.003921568627, green: 0.7176470588, blue: 0.8901960784, alpha: 1)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
        contentView.isHidden = true
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(toggleSearchBar))
    }
    
    init(places: [Place], nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.places = places
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        map.delegate = self
        if places.count == 1 {
            title = places.first?.name
        } else {
            title = "Meus Lugares"
        }
        places.forEach { place in
            addToMap(place)
        }
        showPlaces()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    @objc func handleRoute(){
        //
    }
    
    @objc func toggleSearchBar(){
        searchBar.resignFirstResponder()
        searchBar.isHidden = !searchBar.isHidden
        self.view.layoutIfNeeded()
    }
    
    func addToMap(_ place: Place){
        let annotation = PlaceAnnotation(coordinate: place.coordinate, type: .place)
        annotation.title = place.name
        annotation.address = place.address
        map.addAnnotation(annotation)
    }
    
    func showPlaces(){
        map.showAnnotations(map.annotations, animated: true)
    }
    
    func configureContent(){
        contentView.addSubview(nameLb)
        contentView.addSubview(addresLb)
        contentView.addSubview(routeBtn)
        nameLb.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingRight: 15)
        addresLb.anchor(top: nameLb.bottomAnchor, left: contentView.leftAnchor, right: contentView.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingRight: 15)
        routeBtn.anchor( left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingLeft: 40, paddingBottom: 15, paddingRight: 40)
    }
    
    func configureUI() {
        searchBar.delegate = self
        contentView.anchor(height: 160)
        configureContent()
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [searchBar, map, contentView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 6
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
}

extension ShowPlaceViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        map.toggleLoading()
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBar.text
        request.region = map.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if error == nil {
                guard let response = response else {
                    return
                }
                
                self.map.removeAnnotations(self.poi)
                self.poi.removeAll()
                
                for item in response.mapItems {
                    let annotation = PlaceAnnotation(coordinate: item.placemark.coordinate, type: .poi)
                    annotation.title = item.placemark.name
//                    annotation.address = item.placemark
                    self.poi.append(annotation)
                }
                self.map.addAnnotations(self.poi)
                self.map.showAnnotations(self.poi, animated: true)
            }
            self.map.toggleLoading()
        }
    }
}

extension ShowPlaceViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is PlaceAnnotation){
            return nil
        }
        let type = (annotation as! PlaceAnnotation).type
        let identifier = "\(type)"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        annotationView?.markerTintColor = type == .place ? #colorLiteral(red: 0.00400000019, green: 0.7179999948, blue: 0.8899999857, alpha: 1) : #colorLiteral(red: 1, green: 0.768627451, blue: 0.2470588235, alpha: 1)
        annotationView?.glyphImage = type == .place ? #imageLiteral(resourceName: "placeGlyph.png") : #imageLiteral(resourceName: "poiGlyph")
        annotationView?.displayPriority = type == .place ? .required : .defaultHigh
        return annotationView
    }
}
