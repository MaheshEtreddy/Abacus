//
//  Config.swift
//  AbacusAssignment
//
//  Created by Mahesh Etreddy on 07/05/16.
//  Copyright © 2016 Mahesh Etreddy. All rights reserved.
//

import UIKit

struct Config {
    static let WSBaseUrl = "https://api.instagram.com/v1/tags/YIPTV/media/recent?access_token=180966824.1677ed0.72f401c1c3d64e6fac76cdecfbddd0a3"
    
}

extension UIImageView
{
    func loadImageFromURL(url : NSString ){
        
        let request : NSURLRequest = NSURLRequest(URL: NSURL(string: url as String)!)
        
        let sessionConfig : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.requestCachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        let urlSession : NSURLSession = NSURLSession(configuration: sessionConfig)
        
        let downloadTask : NSURLSessionTask =  urlSession.dataTaskWithRequest(request) { (imageData, response, error) -> Void in
            if error == nil {
                //print("Image Download")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.image = UIImage(data: imageData!)
                    
                })
                
            }
            else{
                print("Image failed")
                print(error)
                
            }
        }
        downloadTask.resume()
        
    }
    
    
}
