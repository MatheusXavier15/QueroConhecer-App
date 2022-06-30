//
//  HomeController.swift
//  QueroConhecer
//
//  Created by Matheus Xavier on 29/06/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    let reusableIdentifier = "LocationsTableCell"
    let tableView = UITableView()
    var places : [Place] = []
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Quero Conhecer"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(handleAddLocation))
        loadPlaces()
        configureTableView()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("refreshTable"), object: nil, queue: .main) { _ in
            self.loadPlaces()
        }
    }
    
    @objc func handleAddLocation(){
        let nav = PlaceFinderViewController()
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true)
    }
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LocationsTableCell.self, forCellReuseIdentifier: self.reusableIdentifier)
        tableView.rowHeight = 60
        tableView.backgroundColor = .white
        configureUI()
    }
    
    func loadPlaces(){
        if let placesData = userDefaults.data(forKey: "places") {
            do {
                places = try JSONDecoder().decode([Place].self, from: placesData)
                tableView.reloadData()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func configureUI(){
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 700)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableIdentifier, for: indexPath) as! LocationsTableCell
        cell.place = places[indexPath.row]
        return cell
    }
}
