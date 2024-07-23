//
//  BusListTableViewCell.swift
//  Ijjeuminga
//
//  Created by 조성빈 on 6/16/24.
//

import Foundation
import UIKit

class BusListTableViewCell: BaseTableViewCell<BusInfo> {
    
    static let identifier = "BusListTableViewCell"
    
    private weak var numberLabel: UILabel!
    private weak var typeLabel: UILabel!
    
    override func initView() {
        let numberLabel = UILabel()
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.font = UIFont(name: Font.sandollGothicBold, size: 16)
        self.contentView.addSubview(numberLabel)
        self.numberLabel = numberLabel
        
        let typeLabel = UILabel()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = UIFont(name: Font.sandollGothicLight, size: 14)
        typeLabel.textColor = UIColor(named: Color.grayCACACA)
        self.contentView.addSubview(typeLabel)
        self.typeLabel = typeLabel
    }
    
    override func initConstraint() {
        self.numberLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
        self.numberLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24).isActive = true
        
        self.typeLabel.topAnchor.constraint(equalTo: self.numberLabel.bottomAnchor, constant: 4).isActive = true
        self.typeLabel.leadingAnchor.constraint(equalTo: self.numberLabel.leadingAnchor).isActive = true
        self.typeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16).isActive = true
    }
    
    override func configureCell(data: BusInfo?) {
        self.numberLabel.text = data?.busNumber
        switch data?.type {
        case 1:
            self.typeLabel.text = "서울 간선버스"
            self.numberLabel.textColor = UIColor(named: Color.blue)
        case 2:
            self.typeLabel.text = "지선버스"
            self.numberLabel.textColor = UIColor(named: Color.green)
        case 3:
            self.typeLabel.text = "서울 순환버스"
            self.numberLabel.textColor = UIColor(named: Color.yello)
        case 4:
            self.typeLabel.text = "서울 광역버스"
            self.numberLabel.textColor = UIColor(named: Color.red)
        case 5:
            self.typeLabel.text = "마을버스"
            self.numberLabel.textColor = UIColor(named: Color.green)
        case 6:
            self.typeLabel.text = "공항버스"
            self.numberLabel.textColor = UIColor(named: Color.brown)
        default:
            break
        }
    }
}
