//
//  NotlarTableViewCell.swift
//  ToDoListApp
//
//  Created by Kaan Cantimur on 17.04.2023.
//

import UIKit

class NotlarTableViewCell: UITableViewCell {

    @IBOutlet weak var notLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
