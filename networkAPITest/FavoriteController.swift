//
//  FavoriteController.swift
//  networkAPITest
//
//  Created by Victor Wei on 8/22/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit
import CoreData

class FavoriteController: NSObject {
    
    var albums: [NSManagedObject] = []
    var favoriteAlbums: [Album] = []
    
    
    func getFavoritedAlbums(completion: (_ success: Bool) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(false)
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
        
        do {
            albums = try managedContext.fetch(fetchRequest)
            convertToAlbums()
            completion(true)
        } catch let error as NSError {
             print("Could not fetch. \(error), \(error.userInfo)")
            completion(false)
        }
        
    }
    
    
    func convertToAlbums() {
        
        for album in albums {
            
            if let name = album.value(forKey: "title") as? String,
                let imageurl = album.value(forKey: "imageurl") as? String {
                
                let newAlbum = Album()
                newAlbum.title = name
                newAlbum.imageUrl = imageurl
                newAlbum.favorite = true
                
                favoriteAlbums.append(newAlbum)
            }
        }
        
    }
    
    
    func saveToFavorites(album: Album) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: managedContext)!
        let newalbum = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if let name = album.title,
            let imageurl = album.imageUrl {
            
            newalbum.setValue(name, forKey: "title")
            newalbum.setValue(imageurl, forKey: "imageurl")
            
        } else {
            return false
        }
        
        do {
            try managedContext.save()
            albums.append(newalbum)
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteFromFavorite(album: Album) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        var matchingObject: NSManagedObject = NSManagedObject()
        
        
        for (index, object) in albums.enumerated() {
            if let title = album.title,
                let otherTitle = object.value(forKey: "title") as? String,
                title == otherTitle {
                matchingObject = object
                albums.remove(at: index)
                break
            }
        }
        managedContext.delete(matchingObject)
        
        
        
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("failed delete")
            return false
        }
        
    }
    

}
