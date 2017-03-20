//
//  TableViewCell.swift
//  IntroductionToHeatlhKit
//
//  Created by Charles Lee on 19/3/17.
//  Copyright © 2017 NextAcademy. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var pictureIV: UIImageView!{
        didSet {
            pictureIV.layer.cornerRadius = pictureIV.frame.size.width / 2
            pictureIV.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
