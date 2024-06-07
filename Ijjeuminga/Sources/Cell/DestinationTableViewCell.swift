//
//  DestinationTableViewCell.swift
//  Ijjeuminga
//
//  Created by BH on 2024/06/08.
//

import UIKit

final class DestinationTableViewCell: BaseTableViewCell<UITableViewCell> {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
    }
}
