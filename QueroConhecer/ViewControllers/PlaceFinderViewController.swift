//
//  LocalsViewController.swift
//  QueroConhecer
//
//  Created by Matheus Xavier on 29/06/22.
//

import Foundation
import UIKit

class PlaceFinderViewController: UIViewController {
    let placeView = PlaceView(frame: .infinite)
    let userDefaults = UserDefaults.standard
    private lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "cancel"), for: .normal)
        btn.setDimensions(height: 30, width: 30)
        btn.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.2)
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func closeScreen(){
        self.dismiss(animated: true)
    }
    
    func configureUI(){
        placeView.delegate = self
        view.addSubview(placeView)
        placeView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 40, paddingRight: 20)
        view.addSubview(closeBtn)
        closeBtn.anchor(top: placeView.topAnchor, right: placeView.rightAnchor, paddingTop: -15, paddingRight: -15)
    }
}

extension PlaceFinderViewController: PlaceViewDelegate {
    func addPlace(place: Place) {
        var places: [Place]
        if let placesData = userDefaults.data(forKey: "places") {
            do {
                places = try JSONDecoder().decode([Place].self, from: placesData)
                if !places.contains(place) {
                    places.append(place)
                    let json = try JSONEncoder().encode(places)
                    userDefaults.set(json, forKey: "places")
                    NotificationCenter.default.post(name: NSNotification.Name("refreshTable"), object: nil)
                }
                dismiss(animated: true)
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            do {
                let json = try JSONEncoder().encode([place])
                userDefaults.set(json, forKey: "places")
                dismiss(animated: true)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func didPresentAlert(alert: UIAlertController) {
        present(alert, animated: true)
    }
}
