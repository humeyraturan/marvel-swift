//
//  DetailViewController.swift
//  marvelTest
//
//  Created by Hümeyra Turan on 18.12.2023.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lbl_Comics: UILabel!
    @IBOutlet weak var lbl_Series: UILabel!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var img_View: UIImageView!
    @IBOutlet weak var lbl_Stories: UILabel!
    @IBOutlet weak var lbl_Events: UILabel!
    var img = UIImage()
    var user_name = ""
    var series = ""
    var stories = ""
    var events = ""
    var comics = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_Name.text = user_name
        lbl_Series.text = series
        img_View.image = img
        lbl_Stories.text = stories
        lbl_Events.text = events
        lbl_Comics.text = comics

    }
    


}
