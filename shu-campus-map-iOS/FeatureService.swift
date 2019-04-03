//
//  FeatureService.swift
//  shu-campus-map-iOS
//
//  Created by Coltin Kifer on 4/1/19.
//  Copyright © 2019 Coltin Kifer. All rights reserved.
//

import Foundation

class FeatureService {
    
    var baseUrl = URL(string: "")
    var urlString = "https://api.mapbox.com/datasets/v1/ck108860/cjsnn5cb53iet32o196hatdnm/features"
    var accessToken = "?access_token="
    
    init(dataSetUrl: String) {
        if(!dataSetUrl.isEmpty){
            self.baseUrl = URL(string: dataSetUrl)
        }
        var plist: NSDictionary?
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            plist = NSDictionary(contentsOfFile: path)
            self.accessToken += plist?.object(forKey: "MGLMapboxAccessToken") as! String
        }
        urlString += accessToken
        baseUrl = URL(string: self.urlString)
    }
    
    func GetFeatures() {
        let request = URLRequest(url: baseUrl!)
        
        // make the request
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            // parse the result as JSON, since that's what the API provides
            do {
                guard let feature = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("error trying to convert data to JSON")
                        return
                }
                // now we have the todo
                // let's just print it to prove we can access it
                print("The feature is: " + feature.description)
                
                // the todo object is a dictionary
                // so we just access the title using the "title" key
                // so check for a title and print it if we have one
                guard let type = feature["type"] as? String else {
                    print("Could not get type from JSON")
                    return
                }
                print("The type is: " + type)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
}
