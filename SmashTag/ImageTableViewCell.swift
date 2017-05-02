//
//  ImageTableViewCell.swift
//  SmashTag
//
//  Created by SangMee Specht on 5/2/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    var tweetURL: URL? {
        didSet { fetchImage() }
    }
    
    @IBOutlet weak var tweetImage: UIImageView!
    
    func fetchImage() {
        tweetImage?.image = nil
        
        if let url = tweetURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.tweetURL {
                    DispatchQueue.main.async {
                        self?.tweetImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
