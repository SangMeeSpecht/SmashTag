//
//  ImageViewController.swift
//  SmashTag
//
//  Created by SangMee Specht on 4/28/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    var imageURL: URL? {
        didSet {
            image = nil
            fetchImage()
        }
    }

    private var mentionImage = UIImageView()
    
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.contentSize = mentionImage.frame.size
        }
    }
    
    private var image: UIImage? {
        get {
            return mentionImage.image
        }
        set {
            mentionImage.image = newValue
            mentionImage.sizeToFit()
            imageScrollView?.contentSize = mentionImage.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageURL = URL(string: "http://www.findcatnames.com/wp-content/uploads/2017/01/tabby-cat-names.jpg")
        imageScrollView.addSubview(mentionImage)
    }
    
    private func fetchImage() {
        if let url = imageURL {
            if let imageData = try? Data(contentsOf: url) {
                image = UIImage(data: imageData)
            }
        }
    }
}
