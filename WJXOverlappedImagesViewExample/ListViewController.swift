//
//  ListViewController.swift
//  WJXOverlappedImagesViewExample
//
//  Created by Jiuxing Wang on 2019/3/17.
//  Copyright © 2019年 Jiuxing Wang. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ListCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 66
        
        navigationItem.title = "测试 FPS"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ListCell
        cell.update()
        return cell
    }
}

class ListCell: UITableViewCell {
    var imagesView: WJXOverlappedImagesView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imagesView = WJXOverlappedImagesView(frame: CGRect(x: 0, y: 0, width: contentView.bounds.size.width, height: contentView.bounds.size.height))
        imagesView.imageFetcher = { imagesView, imageView, url, index in
            imageView.kf.setImage(with: URL(string: url))
        }
        contentView.addSubview(imagesView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        imagesView.updateInTransaction { imagesView in
            imagesView.imageBorderColor = UIColor.white
            imagesView.imageBorderWidth = 4
            imagesView.imageHeight = self.bounds.size.height
            
            imagesView.overlapDistance = 16
            imagesView.shouldShowMoreIndicatorImageViewWhenImageCountExceedsMaxLimit = true
            imagesView.maxLimit = 4
            
            imagesView.imageUrls = [
                "https://avatars1.githubusercontent.com/u/4176744?v=40&s=132",
                "https://avatars1.githubusercontent.com/u/565251?v=3&s=132",
                "https://avatars2.githubusercontent.com/u/587874?v=3&s=132",
                "https://avatars2.githubusercontent.com/u/1019875?v=4&s=132",
                "https://avatars2.githubusercontent.com/u/839283?v=4&s=132",
                "https://avatars0.githubusercontent.com/u/724423?v=3&s=132",
                "https://avatars3.githubusercontent.com/u/602569?v=4&s=132",
                "https://avatars1.githubusercontent.com/u/8086633?v=3&s=132",
            ]
        }
        
        var frame = imagesView.frame
        frame.size = imagesView.intrinsicContentSize
        imagesView.frame = frame
    }
}
