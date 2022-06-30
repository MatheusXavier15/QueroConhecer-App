//
//  TableCellView.swift
//  QueroConhecer
//
//  Created by Matheus Xavier on 29/06/22.
//

import Foundation
import UIKit

class LocationsTableCell: UITableViewCell {
    
    var place: Place! {
        didSet{
            label.text = place.name
        }
    }
    
    private let image: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "cellIcon")?.withRenderingMode(.alwaysOriginal))
        imageView.setDimensions(height: 25, width: 25)
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "teste"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        self.backgroundColor = .white
        addSubview(image)
        image.anchor(left: leftAnchor, paddingLeft: 15)
        image.centerY(inView: self)
        
        addSubview(label)
        label.anchor(left: image.rightAnchor, paddingLeft: 15)
        label.centerY(inView: self)
    }
}
