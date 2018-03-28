//
//  DiveTableViewCell.swift
//  Scuba
//
//  Created by Hubert Ka on 2018-01-07.
//  Copyright © 2018 Hubert Ka. All rights reserved.
//

import UIKit

class DiveTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var diveNumberLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
