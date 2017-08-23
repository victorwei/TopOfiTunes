//
//  ITunesDataController.swift
//  networkAPITest
//
//  Created by Victor Wei on 8/22/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class ITunesDataController: NSObject {
    
    let url = URL(string: "https://itunes.apple.com/us/rss/topalbums/limit=20/json")!
    var albumData = [Album]()
    
    
    func getNetworkData(completion: @escaping (_ success: Bool)-> ()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("Error: \(error!.localizedDescription)")
                completion(false)
                return
            }
            
            if let jsonData = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                
                self.parseDictionary(data: jsonData)
                completion(true)
                
            }
        }
        dataTask.resume()
    }
    
    
    func parseDictionary(data: NSDictionary) {
        
        guard let feed = data["feed"] as? NSDictionary,
            let entries = feed["entry"] as? [NSDictionary] else {
                return
        }
        
        for entry in entries {
            
            let album = Album()
            
            if let nameDict = entry["title"] as? NSDictionary,
                let name = nameDict["label"] as? String {
                album.title = name
                
            }
            
            if let imageDict = entry["im:image"] as? [NSDictionary],
                let imageUrl = imageDict[0]["label"] as? String {
                album.imageUrl = imageUrl
            }
            
            albumData.append(album)
        }
        
        
    }

}
