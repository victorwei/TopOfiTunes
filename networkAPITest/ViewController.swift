//
//  ViewController.swift
//  networkAPITest
//
//  Created by Victor Wei on 8/18/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit



class Album {
    var title: String?
    var imageUrl: String?
    var favorite: Bool = false
    
}

var cache =  NSCache<NSString, UIImage>()

class ViewController: UIViewController {

    var tableView: UITableView!
    
    var networkController = ITunesDataController()
    var savedData = FavoriteController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "AlbumCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "albumCell")
        
        
        savedData.getFavoritedAlbums { (success) in
            if success {
                
                
            }
        }
        
        networkController.getNetworkData { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networkController.albumData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let album = networkController.albumData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumCell
        
        cell.setInfo(album: album)
        
        let isFavorited = savedData.favoriteAlbums.contains(where: { (favoritedAlbum) -> Bool in
            return favoritedAlbum.title == album.title
        })
        
        if isFavorited {
            cell.addToFavorite()
        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // change the liked status
        let selectedAlbum = networkController.albumData[indexPath.row]
        selectedAlbum.favorite = !selectedAlbum.favorite
        
        if let cell = tableView.cellForRow(at: indexPath) as? AlbumCell {
            if selectedAlbum.favorite {
                if savedData.saveToFavorites(album: selectedAlbum) {
                    print("saved data")
                }
                cell.addToFavorite()
            } else {
                cell.removeFromFavorite()
                if savedData.deleteFromFavorite(album: selectedAlbum) {
                    print("successfully deleted")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
