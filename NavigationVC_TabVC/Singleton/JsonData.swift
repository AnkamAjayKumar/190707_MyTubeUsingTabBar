//
//  JsonData.swift
//  NavigationVC_TabVC
//
//  Created by Ankam Ajay Kumar on 12/12/19.
//  Copyright © 2019 Ankam Ajay Kumar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class JsonData: NSObject {
    
    //instance creation
    var URLReqObj:URLRequest!
    var dataTaskObj:URLSessionDataTask!

    //singleton variables
    static var shared:JsonData = JsonData()
    var posterData:Data!
    var buttonTapped:Int!
    var stories = [String]()
    var title = [String]()
    var actorName = [[String]]()
    var directorName = [String]()
    var posters = [UIImage]()
    var trailer = [AVPlayer]()
    var songs = [[AVPlayer]]()
    var songNames = [[String]]()
    var movieList = [String:String]()

    private override init() {
        
    }

    //method creation for json data
    func movieDataFromJson() -> [[String:Any]]
    {
        var convertedData:[[String:Any]]!
        
        
        //Service URL creating into 'URLRequest'
        URLReqObj = URLRequest(url: URL(string: "https://www.brninfotech.com/tws/MovieDetails2.php?mediaType=movies")!)
        
        //HTTP request method
        URLReqObj.httpMethod = "GET"
        
        //URL Session data task
        dataTaskObj = URLSession.shared.dataTask(with: URLReqObj, completionHandler: { (data, connDetails, err) in
            
            //Block using to handle errors
            do
            {
                convertedData = try (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String:Any]])
                //print(convertedData!)
            }
            catch
            {
                print("Unable to pass Json data")
            }
            
        })
        dataTaskObj.resume()
        
        while (convertedData == nil) {
            
        }
        
        return convertedData
    }


}

