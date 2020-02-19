//
//  StationTableViewCell.swift
//  Fav8
//
//  Created by Administrator on 2018-05-09.
//  Copyright © 2018 Woqomoqo. All rights reserved.
//

import UIKit


class StationTableViewCell: UITableViewCell {
    
    
    //MARK: Properties
    
    
    @IBOutlet var cellView: UIView!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet var urlLabel: UILabel!
    
    
    @IBOutlet var photoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
