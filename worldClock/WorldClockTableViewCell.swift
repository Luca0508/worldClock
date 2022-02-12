//
//  WorldClockTableViewCell.swift
//  worldClock
//
//  Created by 蕭鈺蒖 on 2022/2/10.
//

import UIKit

class WorldClockTableViewCell: UITableViewCell {

    @IBOutlet weak var relativeDateLabel: UILabel!
    @IBOutlet weak var relativeHourLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
