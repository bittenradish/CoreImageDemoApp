//
//  FilterCellCollectionViewCell.swift
//  CoreImageDemoApp
//
//  Created by Rashid on 19.11.23.
//

import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var filterNameText: UILabel!
    
    func commonInit() {
        backgroundColor = .white
        // Set rounded corners for the contentView
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        layer.cornerRadius = 20
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
}
