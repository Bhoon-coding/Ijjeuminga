//
//  DestinationTableViewCell.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/08.
//

import UIKit

final class DestinationTableViewCell: BaseTableViewCell<UITableViewCell> {
    
    private weak var busStopLabel: UILabel!

    override func initView() {
        super.initView()
        
        let busStopLabel = UILabel()
        busStopLabel.translatesAutoresizingMaskIntoConstraints = false
        busStopLabel.text = "강남역"
        busStopLabel.textColor = .black
        contentView.addSubview(busStopLabel)
        self.busStopLabel = busStopLabel
        
        
    }
    
    override func initConstraint() {
        super.initConstraint()
        
        NSLayoutConstraint.activate([
            busStopLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            busStopLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 86),
            busStopLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }
    
    internal func setupCell() {
        
        
    }
}

#Preview {
    DestinationTableViewCell()
}
