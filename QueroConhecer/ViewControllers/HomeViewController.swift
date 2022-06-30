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
    
    private let noPlacesLb: UILabel =  {
       let lb = UILabel()
        lb.text = "Nenhum lugar salvo.\n Para salvar algum local, clique no + acima..."
        lb.font = .systemFont(ofSize: 16, weight: .bold)
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }()
    
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
    
    @objc func handleShowAll(){
        navigationController?.pushViewController(ShowPlaceViewController(places: places, nibName: nil, bundle: nil), animated: true)
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
        if places.count == 0 {
            tableView.backgroundView = noPlacesLb
            navigationItem.leftBarButtonItem = nil
        } else {
            let btnShowAll = UIBarButtonItem(title: "Mostrar todos no mapa", style: .plain, target: self, action: #selector(handleShowAll))
            navigationItem.leftBarButtonItem = btnShowAll
            tableView.backgroundView = nil
        }
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableIdentifier, for: indexPath) as! LocationsTableCell
        cell.place = places[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        navigationController?.pushViewController(ShowPlaceViewController(places: [place], nibName: nil, bundle: nil), animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Excluir") { _, _, completionHandler in
            self.places.remove(at: indexPath.row)
            do {
                let json = try JSONEncoder().encode(self.places)
                self.userDefaults.set(json, forKey: "places")
            } catch let error {
                print(error.localizedDescription)
            }
            self.loadPlaces()
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
