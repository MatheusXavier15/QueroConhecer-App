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
        title = "Title"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.backBarButtonItem?.title = " "
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(toggleSearchBar))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    @objc func handleRoute(){
        //
    }
    
    @objc func toggleSearchBar(){
        //
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
        contentView.anchor(height: 160)
        configureContent()
        view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [searchBar, map, contentView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 6
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
    }
}

extension ShowPlaceViewController: UISearchBarDelegate {
    
}
