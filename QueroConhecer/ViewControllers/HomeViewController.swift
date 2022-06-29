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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Quero Conhecer"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(handleAddLocation))
        configureTableView()
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
    
    func configureUI(){
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 700)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reusableIdentifier, for: indexPath) as! LocationsTableCell
        return cell
    }
}
