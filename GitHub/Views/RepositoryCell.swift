//
//  RepositoryT]Cell.swift
//  GitHub
//
//  Created by Sanith on 5/6/20.
//  Copyright © 2020 Sanith. All rights reserved.
//

import UIKit

class RepositoryCell: UITableViewCell {

    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var forks: UILabel!
    @IBOutlet weak var stars: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
