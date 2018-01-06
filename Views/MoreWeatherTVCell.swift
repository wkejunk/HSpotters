//
//  MoreWeatherTVCell.swift
//  Spotters
//
//  Created by Walter Edgar on 12/27/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit

class MoreWeatherTVCell: UITableViewCell {
    @IBOutlet weak var compassImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var gustLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var moonPhaseLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.arrowImage.transform = CGAffineTransform.identity
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
