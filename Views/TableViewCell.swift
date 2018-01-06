//
//  TableViewCell.swift
//  Airport
//
//  Created by Walter Edgar on 12/24/17.
//  Copyright © 2017 Walter Edgar. All rights reserved.
//

import UIKit

class AirportTableViewCell: UITableViewCell {

    @IBOutlet weak var airlineImage: UIImageView!
    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var tailLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var fromToLabel: UILabel!
    @IBOutlet weak var airportNameLabel: UILabel!
    @IBOutlet weak var estTimeLabel: UILabel!
//    @IBOutlet weak var actTimeLabel: UILabel!
    @IBOutlet weak var airportCodeLabel: UILabel!
    
    @IBOutlet weak var gateLabel: UILabel!
    @IBOutlet weak var codeShareLabel: UILabel!
    @IBOutlet weak var cellView: AirportTableViewCell!
    @IBOutlet weak var airplaneImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var specialLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.airlineImage.layer.cornerRadius = self.airlineImage.layer.frame.height / 2
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
