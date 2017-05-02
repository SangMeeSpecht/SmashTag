//
//  ImageViewController.swift
//  SmashTag
//
//  Created by SangMee Specht on 4/28/17.
//  Copyright © 2017 SangMee Specht. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }

    private var mentionImage = UIImageView()
    
    @IBOutlet weak var imageScrollView: UIScrollView! {
        didSet {
            imageScrollView.contentSize = mentionImage.frame.size
            imageScrollView.delegate = self
            imageScrollView.minimumZoomScale = 0.03
            imageScrollView.maximumZoomScale = 5.0
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
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mentionImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.addSubview(mentionImage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.imageURL {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
