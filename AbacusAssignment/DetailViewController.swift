//
//  DetailViewController.swift
//  AbacusAssignment
//
//  Created by Mahesh Etreddy on 07/05/16.
//  Copyright © 2016 Mahesh Etreddy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblDetailView: UILabel!
    @IBOutlet weak var detailImageView: UIImageView!
    
    var strImgURL : String = String()
    var strLabelText : String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.loadImageFromURL(strImgURL)
        lblDetailView.text = strLabelText
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
