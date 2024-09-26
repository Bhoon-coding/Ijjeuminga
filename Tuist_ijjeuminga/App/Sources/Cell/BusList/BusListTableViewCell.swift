//
//  BusListTableViewCell.swift
//  Ijjeuminga
//
//  Created by 조성빈 on 6/16/24.
//

import Common
import Foundation
import UIKit

protocol BusListTableViewCellDelegate: AnyObject {
    func deleteButtonTapped(index: Int)
}

class BusListTableViewCell: BaseTableViewCell<BusInfo> {
    
    static let identifier = "BusListTableViewCell"
    
    private weak var numberLabel: UILabel!
    private weak var typeLabel: UILabel!
    private weak var deleteButton: UIButton!
    
    weak var delegate: BusListTableViewCellDelegate?
    var index: Int = 0
    var isSearchCell: Bool = false
    
    override func initView() {
        let numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.font = .bold(16)
        self.contentView.addSubview(numberLabel)
        self.numberLabel = numberLabel
        
        let typeLabel = UILabel()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = .regular(14)
        typeLabel.textColor = .searchText
        self.contentView.addSubview(typeLabel)
        self.typeLabel = typeLabel
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(nil, for: .normal)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .searchText
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        self.contentView.addSubview(button)
        self.deleteButton = button
    }
    
    override func initConstraint() {
        self.numberLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        self.numberLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24).isActive = true
        
        self.typeLabel.topAnchor.constraint(equalTo: self.numberLabel.bottomAnchor, constant: 4).isActive = true
        self.typeLabel.leadingAnchor.constraint(equalTo: self.numberLabel.leadingAnchor).isActive = true
        self.typeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16).isActive = true
        
        self.deleteButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24).isActive = true
        self.deleteButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
    override func configureCell(data: BusInfo?) {
        self.numberLabel.text = data?.busNumber
        switch data?.type {
        case 1:
            self.typeLabel.text = "서울 간선버스"
            self.numberLabel.textColor = .blue
        case 2:
            self.typeLabel.text = "지선버스"
            self.numberLabel.textColor = .green
        case 3:
            self.typeLabel.text = "서울 순환버스"
            self.numberLabel.textColor = .yellowBus
        case 4:
            self.typeLabel.text = "서울 광역버스"
            self.numberLabel.textColor = .redBus
        case 5:
            self.typeLabel.text = "마을버스"
            self.numberLabel.textColor = .greenBus
        case 6:
            self.typeLabel.text = "공항버스"
            self.numberLabel.textColor = .brown
        default:
            break
        }
        
        self.deleteButton.isHidden = self.isSearchCell == true ? true : false
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.deleteButtonTapped(index: self.index)
    }
}
