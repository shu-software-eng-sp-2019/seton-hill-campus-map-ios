//
//  LegendTableViewCell.swift
//  shu-campus-map-iOS
//
//  Created by Coltin Kifer on 4/8/19.
//  Copyright © 2019 Coltin Kifer. All rights reserved.
//

import UIKit

class LegendTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(building: Building) {
        self.title.text = building.name
        self.subtitle.text = building.description
    }

}
