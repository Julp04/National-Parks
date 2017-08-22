//
//  TableViewCell.swift
//  NationalParks
//
//  Created by Julian Panucci on 10/2/16.
//  Copyright © 2016 Julian Panucci. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var parkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
