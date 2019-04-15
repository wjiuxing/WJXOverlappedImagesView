//
//  ViewController.swift
//  WJXOverlappedImagesViewExample
//
//  Created by Jiuxing Wang on 2019/3/16.
//  Copyright © 2019年 Jiuxing Wang. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var overlappedImagesView: WJXOverlappedImagesView!
    
    private lazy var imageUrls =  [
        "https://avatars1.githubusercontent.com/u/4176744?v=40&s=132",
        "https://avatars1.githubusercontent.com/u/565251?v=3&s=132",
        "https://avatars2.githubusercontent.com/u/587874?v=3&s=132",
        "https://avatars2.githubusercontent.com/u/1019875?v=4&s=132",
        "https://avatars2.githubusercontent.com/u/839283?v=4&s=132",
        "https://avatars0.githubusercontent.com/u/724423?v=3&s=132",
        "https://avatars3.githubusercontent.com/u/602569?v=4&s=132",
        "https://avatars1.githubusercontent.com/u/8086633?v=3&s=132",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "WJXOverlappedImagesView Demo"
        
        overlappedImagesView.imageFetcher = { imagesView, imageView, url, index in
            // fetch image via YYWebImage
//            imageView.yy_setImage(with: URL(string: url)!, placeholder: UIImage(named: "demo-avatar"))
            
            // fetch image via Kingfisher
//            imageView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "demo-avatar"))
            
            // fetch image via SDWebImage
            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "demo-avatar"))
        }
        
        overlappedImagesView.imageFetchCanceler = { imagesView, imageView, index in
//            imageView.yy_cancelCurrentImageRequest()
//            imageView.kf.cancelDownloadTask()
            imageView.sd_cancelCurrentImageLoad()
        }
        
        overlappedImagesView.updateInTransaction { imagesView in
            imagesView.imageBorderWidth = 4
            imagesView.imageBorderColor = UIColor.white
            imagesView.imageHeight = 66
            imagesView.overlapDistance = 16
            imagesView.shouldShowMoreIndicatorImageViewWhenImageCountExceedsMaxLimit = true
            imagesView.maxLimit = 4
            imagesView.imageUrls = self.imageUrls
        }
    }
    
    @IBOutlet weak var maxLimitLabel: UILabel!
    
    @IBAction func listAction() {
        let vc = ListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func imageCountDidChange(_ sender: UIStepper) {
        let max = Int(sender.value)
        overlappedImagesView.updateInTransaction { imagesView in
            imagesView.maxLimit = max
        }
        
        maxLimitLabel.text = "\(max)"
    }
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBAction func distanceSliderChanged(_ sender: UISlider) {
        let distance = sender.value
        overlappedImagesView.updateInTransaction { imagesView in
            imagesView.overlapDistance = CGFloat(distance)
        }
        
        distanceLabel.text = "\(distance)"
    }
    
    @IBAction func forceToShowMoreIndicatorChanged(_ sender: UISwitch) {
        overlappedImagesView.updateInTransaction { imagesView in
            imagesView.forceToShowMoreIndicatorImageView = sender.isOn
        }
    }
    
    @IBOutlet weak var imageUrlsCountLabel: UILabel!
    @IBAction func imageUrlsCountDidChange(_ sender: UIStepper) {
        let count = Int(sender.value)
        overlappedImagesView.updateInTransaction { imagesView in
            imagesView.imageUrls = Array(self.imageUrls[0..<count])
            self.imageUrlsCountLabel.text = "\(count)"
        }
    }
}
