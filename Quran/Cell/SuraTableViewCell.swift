//
//  SuraTableViewCell.swift
//  Quran
//
//  Created by Admin on 10/9/19.
//

import UIKit

class SuraTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ayaNumberLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.accessoryType = .disclosureIndicator
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
