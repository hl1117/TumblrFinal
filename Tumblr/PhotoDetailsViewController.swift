//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Harika Lingareddy on 1/10/18.
//  Copyright © 2017 Harika Lingareddy. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var picView: UIImageView!
    var use: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let image = use else{
            return
        }
        
        picView.image = image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
