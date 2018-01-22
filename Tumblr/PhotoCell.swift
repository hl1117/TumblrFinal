//
//  PhotoCell.swift
//  Tumblr
//
//  Created by Harika Lingareddy on 1/10/18.
//  Copyright © 2017 Harika Lingareddy. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    override func awakeFromNib() {
     //    super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
