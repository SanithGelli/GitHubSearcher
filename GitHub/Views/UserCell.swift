//
//  UserCell.swift
//  GitHub
//
//  Created by Sanith on 5/7/20.
//  Copyright © 2020 Sanith. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var repos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
