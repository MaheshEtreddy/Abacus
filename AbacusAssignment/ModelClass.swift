//
//  ModelClass.swift
//  AbacusAssignment
//
//  Created by Mahesh Etreddy on 07/05/16.
//  Copyright © 2016 Mahesh Etreddy. All rights reserved.
//

import UIKit
import CoreData
class ModelClass: NSObject {
    var images = [NSManagedObject]()

    func getDataFromServer(){
        
        Helper.requestToServer(.GET, URL: Config.WSBaseUrl, headers: [:], params:[:]) { (response) in
            if let responseJSON = response as? NSDictionary  {
                let arrImageData = responseJSON["data"] as! NSArray
                for images in arrImageData{
                print(images["user"])
                    let dicImage = images["images"] as! NSDictionary
                    let dicStandardRes = dicImage.objectForKey("standard_resolution") as! NSDictionary
                    print(dicStandardRes["url"] as! String)

                    let dicUserName = images["user"] as! NSDictionary
                    print(dicUserName["full_name"] as! NSString)
                    self.saveData(dicUserName["full_name"] as! String, url: dicStandardRes["url"] as! String)

                }
                
            }else{
                print("Invalid tag information received from service")
                print("Error while fetching tags: \(response)")
                return
            }

        }
    }
    
    func saveData(name: String, url : String) {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Image",
                                                        inManagedObjectContext:managedContext)
        
        let imageData = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        //3
        imageData.setValue(url, forKey: "imageURL")
        imageData.setValue(name, forKey: "name")
        
        //4
        do {
            try managedContext.save()
            //5
            images.append(imageData)

        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    

}
