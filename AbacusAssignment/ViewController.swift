//
//  ViewController.swift
//  AbacusAssignment
//
//  Created by Mahesh Etreddy on 07/05/16.
//  Copyright © 2016 Mahesh Etreddy. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var ImageData = [NSManagedObject]()

    @IBOutlet weak var objCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.deleteAllData("Image")
        self.getDataFromServer()


        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageData.count
    }
    //Mark :- Collection view delegate methods
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! CollectionViewCell
        let imgData = ImageData[indexPath.row]

        cell.imageView.loadImageFromURL(imgData.valueForKey("imageURL") as! String)
        cell.lblName.text = imgData.valueForKey("name") as? String
        return cell

    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let viewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as? DetailViewController
        let imgData = ImageData[indexPath.row]
        viewControllerObj?.strImgURL = imgData.valueForKey("imageURL") as! String
        viewControllerObj?.strLabelText = imgData.valueForKey("name") as! String
        self.navigationController?.pushViewController(viewControllerObj!, animated: true)

        
    }
    
    
    func getDataFromServer(){
        
        Helper.requestToServer(.GET, URL: Config.WSBaseUrl, headers: [:], params:[:]) { (response) in
            if let responseJSON = response as? NSDictionary  {
                Helper.showProgressHUD("Loading....")
                let arrImageData = responseJSON["data"] as! NSArray
                for images in arrImageData{
                    print(images["user"])
                    let dicImage = images["images"] as! NSDictionary
                    let dicStandardRes = dicImage.objectForKey("standard_resolution") as! NSDictionary
                    print(dicStandardRes["url"] as! String)
                    
                    let dicUserName = images["user"] as! NSDictionary
                    print(dicUserName["full_name"] as! NSString)
                    let objModel = ModelClass()
                    objModel.saveData(dicUserName["full_name"] as! String, url: dicStandardRes["url"] as! String)
                    self.fetchResutls()
                    self.objCollectionView.reloadData()
                    Helper.hideProgressHUD()
                }
                
            }else{
                print("Invalid tag information received from service")
                print("Error while fetching tags: \(response)")
                return
            }
            
        }
    }
    
    
    func fetchResutls(){
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName: "Image")
        
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            ImageData = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
}

