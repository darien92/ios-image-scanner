//
//  SavedTextCell.swift
//  TextReaderiOS
//
//  Created by Darién on 5/11/20.
//  Copyright © 2020 Darien. All rights reserved.
//

import UIKit

class SavedTextCell: UITableViewCell {
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var lblTimestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupData(text:String, timestamp:String){
        lblText.text = text
        lblTimestamp.text = timestamp
    }
}
