//
//  WJXOverlappedImagesView.swift
//  WJXOverlappedImagesView
//
//  Created by Jiuxing Wang on 2019/3/16.
//  Copyright © 2019年 Jiuxing Wang. All rights reserved.
//

import UIKit

fileprivate extension UIImageView {
    private struct AssociatedKeys {
        static var maskLayerKey = "UIImageView.maskLayer"
        static var borderLayerKey = "UIImageView.borderLayer"
        static var borderWidthKey = "UIImageView.borderWidth"
        static var borderColorKey = "UIImageView.borderColor"
        static var iconHeightKey = "UIImageView.iconHeight"
    }
    
    var maskLayer: CAShapeLayer {
        get {
            if let layer = objc_getAssociatedObject(self, &AssociatedKeys.maskLayerKey) as? CAShapeLayer {
                return layer
            }
            
            let mask = CAShapeLayer()
            mask.contentsScale = UIScreen.main.scale
            mask.isOpaque = true
            mask.frame = bounds
            mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width * 0.5).cgPath
            self.maskLayer = mask
            
            return mask
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.maskLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.layer.mask = newValue
        }
    }
    
    var borderLayer: CAShapeLayer {
        get {
            if let layer = objc_getAssociatedObject(self, &AssociatedKeys.borderLayerKey) as? CAShapeLayer {
                return layer
            }
            
            let border = CAShapeLayer()
            border.contentsScale = UIScreen.main.scale
            border.frame = bounds
            border.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width * 0.5).cgPath
            border.fillColor = UIColor.clear.cgColor
            border.strokeColor = UIColor.white.cgColor
            border.lineWidth = (borderWidth ?? 0) * UIScreen.main.scale
            border.lineJoin = CAShapeLayerLineJoin.round
            border.lineCap = CAShapeLayerLineCap.round
            self.borderLayer = border
            
            return border
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.borderLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            layer.addSublayer(newValue)
        }
    }
    
    var borderColor: UIColor? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.borderColorKey) as? UIColor }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.borderColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            borderLayer.strokeColor = newValue?.cgColor
        }
    }
    
    var iconHeight: CGFloat? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.iconHeightKey) as? CGFloat }
        set {
            guard newValue != iconHeight else { return }
            
            objc_setAssociatedObject(self, &AssociatedKeys.iconHeightKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            
            if let width = newValue {
                var frame = self.frame
                frame.size.width = width
                frame.size.height = width
                self.frame = frame
                
                let bounds: CGRect = CGRect(x: 0, y: 0, width: width, height: width)
                maskLayer.frame = bounds
                
                borderLayer.frame = bounds
                borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: width * 0.5).cgPath
            }
        }
    }
    
    var borderWidth: CGFloat? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.borderWidthKey) as? CGFloat }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.borderWidthKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            borderLayer.lineWidth = (newValue ?? 0) * UIScreen.main.scale
        }
    }
    
    convenience init(iconHeight: CGFloat, borderWidth: CGFloat) {
        self.init(frame: CGRect(x: 0, y: 0, width: iconHeight, height: iconHeight))
        
        self.borderWidth = borderWidth
        self.maskLayer.isHidden = false
        self.borderLayer.isHidden = false
    }
}

public class WJXOverlappedImagesView: UIView {
    public var imageUrls: [String]!
    public var imageHeight: CGFloat = 44
    public var overlapDistance: CGFloat = 16
    public var maxLimit: Int = 3
    public var shouldShowMoreIndicatorImageViewWhenImageCountExceedsMaxLimit: Bool = true
    public var imageBorderWidth: CGFloat = 2.0
    public var imageBorderColor: UIColor = UIColor.white
    
    public lazy var moreIndicatorImage: UIImage = {
        let bundlePath: String = Bundle.main.path(forResource: "WJXOverlappedImagesViewResource", ofType: "bundle")!
        let imagePath: String = bundlePath.appending("/more.png")
        let image: UIImage = UIImage(contentsOfFile: imagePath)!
        return image
    }()
    
    public typealias WJXOverlappedImagesViewImageFetcher = (WJXOverlappedImagesView, UIImageView, String, Int) -> Void
    public var imageFetcher: WJXOverlappedImagesViewImageFetcher!
    
    public typealias WJXOverlappedImagesViewImageFetchCanceler = (WJXOverlappedImagesView, UIImageView, Int) -> Void
    public var imageFetchCanceler: WJXOverlappedImagesViewImageFetchCanceler?
    
    fileprivate var imageViews: [UIImageView] = []
    fileprivate lazy var moreIndicatorImageView: UIImageView = {
        let imageView = UIImageView(iconHeight: imageHeight, borderWidth: imageBorderWidth)
        imageView.borderColor = imageBorderColor
        imageView.borderWidth = imageBorderWidth
        imageView.image = moreIndicatorImage
        imageView.backgroundColor = UIColor.white
        imageView.layer.zPosition = 100 // bring it to the most front of the screen.
        addSubview(imageView)
        
        return imageView
    }()
    
    override public var intrinsicContentSize: CGSize {
        let exceed: Bool = imageUrls.count > maxLimit
        
        var count: Int = exceed ? maxLimit : imageUrls.count
        if shouldShowMoreIndicatorImageViewWhenImageCountExceedsMaxLimit && exceed {
            count += 1 // 把“...”的图也算进去。
        }
        
        let gapCount: Int = max(count - 1, 0)
        let width: CGFloat = imageHeight * CGFloat(count) - overlapDistance * CGFloat(gapCount)
        
        return CGSize(width: width, height: imageHeight)
    }
    
    public func updateInTransaction(transaction: (WJXOverlappedImagesView) -> Void) {
        transaction(self)
        update()
    }
    
    public func update() {
        let exceed: Bool = self.imageUrls.count > maxLimit
        let imageUrls: [String] = exceed ? Array((self.imageUrls?[0..<maxLimit])!) : self.imageUrls
        
        if let canceler = imageFetchCanceler {
            while imageUrls.count < imageViews.count {
                let index = imageViews.endIndex - 1
                let imageView = imageViews.removeLast()
                canceler(self, imageView, index)
                imageView.removeFromSuperview()
            }
        } else {
            while imageUrls.count < imageViews.count {
                imageViews.removeLast().removeFromSuperview()
            }
        }
        
        while imageUrls.count > imageViews.count {
            let imageView = UIImageView(iconHeight: imageHeight, borderWidth: imageBorderWidth)
            imageViews.append(imageView)
            addSubview(imageView)
        }
        
        for (index, imageUrl) in imageUrls.enumerated() {
            let imageView = imageViews[index]
            imageView.frame = CGRect(x: (imageHeight - overlapDistance) * CGFloat(index), y: 0, width: imageHeight, height: imageHeight)
            imageView.iconHeight = imageHeight
            imageView.borderColor = imageBorderColor
            imageView.borderWidth = imageBorderWidth
            imageFetcher(self, imageView, imageUrl, index)
        }
        
        if shouldShowMoreIndicatorImageViewWhenImageCountExceedsMaxLimit && exceed {
            moreIndicatorImageView.frame = CGRect(x: (imageHeight - overlapDistance) * CGFloat(imageUrls.count), y: 0, width: imageHeight, height: imageHeight)
            moreIndicatorImageView.borderColor = imageBorderColor
            moreIndicatorImageView.borderWidth = imageBorderWidth
            moreIndicatorImageView.image = moreIndicatorImage
            moreIndicatorImageView.isHidden = false
        } else {
            moreIndicatorImageView.isHidden = true
        }
    }
}
