//
//  AlbumCell.swift
//  networkAPITest
//
//  Created by Victor Wei on 8/18/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelTrailingContraint: NSLayoutConstraint!
    @IBOutlet weak var favoritedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        favoritedImageView.isHidden = true
        labelTrailingContraint.constant = 10
        albumImageView.image = nil
    }
    
    
    
    
    func addToFavorite() {
        favoritedImageView.isHidden = false
        labelTrailingContraint.constant = 50
    }
    
    
    func removeFromFavorite() {
        favoritedImageView.isHidden = true
        labelTrailingContraint.constant = 10
    }
    
    
    
    func setInfo(album: Album) {
        
        
        if let title = album.title {
            label.text = title
        }
        
        if let imageurl = album.imageUrl,
            let theurl = URL(string: imageurl) {
            
            if let image = cache.object(forKey: NSString(string: imageurl)) {
                albumImageView.image = image
                
            } else {
                let dataTask = URLSession.shared.dataTask(with: theurl, completionHandler: { (data, response, error) in
                    
                    
                    guard let data = data, error == nil else {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.albumImageView.image = image
                        }
                        cache.setObject(image, forKey: NSString(string: imageurl))
                    }
                })
                dataTask.resume()
            }
        }
        
        
        
        
    }
}
