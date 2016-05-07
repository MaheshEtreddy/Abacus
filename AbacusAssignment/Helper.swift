//
//  Helper.swift
//  AbacusAssignment
//
//  Created by Mahesh Etreddy on 07/05/16.
//  Copyright © 2016 Mahesh Etreddy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CoreData

import SystemConfiguration

class Helper: NSObject {
    //Mark :- Reachability Checking
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    
    
    //MARK :- Alamofire request to server
   class func requestToServer( Method: Alamofire.Method ,URL: String,headers: [String : String], params : [String:AnyObject],completion: (response: AnyObject) -> Void) {
        if(Helper.isConnectedToNetwork()){
            let request = Alamofire.request(Method, URL, parameters: params, headers: headers)
            request.responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    return
                }
                guard let responseJSON = response.result.value as? NSDictionary else {
                    print("Invalid tag information received from service")
                    return
                }
                print(responseJSON)
                completion(response: responseJSON)
            }
        }else{
        }
    }
    //MARK:- Show PROGRESS HUD
    class func showProgressHUD(message:String)->Void {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents();
        if(message == "" || message.isEmpty)
        {
            SVProgressHUD.show()
        }
        else
        {
            SVProgressHUD.showSuccessWithStatus(message)
        }
        
    }
    
    //MARK:- HIDE PROGRESS HUD
    class func hideProgressHUD()->Void {
        UIApplication.sharedApplication().endIgnoringInteractionEvents();
        SVProgressHUD.dismiss()
    }
    
    class func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.deleteObject(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}
