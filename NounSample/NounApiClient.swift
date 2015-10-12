//
//  NounApiClient.swift
//  NounSample
//
//  Created by ERNESTO GARCIA CARRIL on 9/10/15.
//  Copyright © 2015 ernesto. All rights reserved.
//

import AppKit


class NounApiClient
{
    
    struct API {
        static let BaseURL  = "http://api.thenounproject.com"
        static let Icons = "icons"
    }
    
    let session:NSURLSession
    let oauthClient:OAuthSwiftClient
    
    
    init(key:String, secret:String) {
        
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        oauthClient = OAuthSwiftClient(consumerKey:key, consumerSecret: secret)
        oauthClient.credential.oauth_header_type = "oauth1"
    }
    // API calls should be cancellable and  throttled (enqueued). for this sample, just fire and forget..
    func iconsForSearchTerm( term:String, completion: ( icons:[Icon]?, error:NSError?) ->() ) {
        // this should also cancel previous requests in a real app
        guard let urlString = urlSearchIconForTerm(term) else
        {
            completion(icons:nil, error:nil)
            return
        }
        
        oauthClient.get(urlString, parameters: [:], success:
            { (data, response) -> Void in
                print("Response : \(response)")
                
                let icons = Icon.iconListFromJsonData( data )
                completion(icons:icons , error: nil )
                
            }) { (error) -> Void in
                print("Error requesting: \(error)")
                completion(icons: [], error: error )
        }
        
    }
    
    func iconImageForURL( imageURL:NSURL, completion:(image:NSImage?, error:NSError?) ->() ) {
        
        let request = NSURLRequest(URL: imageURL)
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            // this should be cached to disk in a real app
            guard let data = data else  {
                completion(image: nil, error: error)
                return;
            }
            completion( image: NSImage(data: data), error: nil)
            
        }
        dataTask.resume()
        
    }
    
    func urlSearchIconForTerm(term:String) -> String?
    {
        let url = NSURL(string: API.BaseURL)?.URLByAppendingPathComponent(API.Icons).URLByAppendingPathComponent(term)
        return url?.absoluteString
    }
    
}