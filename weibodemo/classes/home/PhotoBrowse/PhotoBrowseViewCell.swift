//
//  PhotoBrowseViewCell.swift
//  weibodemo
//
//  Created by macliu on 2021/1/23.
//

import UIKit
import SDWebImage

protocol PhotoBrowseViewCellDelgate : NSObjectProtocol {
    func imageViewClick()
}
class PhotoBrowseViewCell: UICollectionViewCell {
    // MARK: - 属性
    var picURL : NSURL? {
        didSet {
            setupContent(picURL: picURL)
        }
    }
    
    var delegate : PhotoBrowseViewCellDelgate?
    // MARK: - 懒加载属性
    private lazy var scrollView : UIScrollView = UIScrollView()
     lazy var imageView : UIImageView = UIImageView()
    private lazy var progressView : ProgressView = ProgressView()
    
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
extension PhotoBrowseViewCell {
    private func setupUI() {
        //
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        //
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20  //图片之间的间距
        //
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5 , y: UIScreen.main.bounds.width * 0.5)
        //
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        //监听imageview 手势
        imageView.isUserInteractionEnabled = true
        let tapGes = UITapGestureRecognizer(target: self, action: "imageViewClick")
        imageView.addGestureRecognizer(tapGes)
        
    }
}
// MARK: - 事件
extension PhotoBrowseViewCell {
    
    private func imageViewClick() {
        delegate?.imageViewClick()
    }
    
}
extension PhotoBrowseViewCell {
    private func setupContent(picURL : NSURL?) {
        guard let picURL = picURL else {
            return
        }
        //
        
        
        
        //2.取出image对象

        let x = 0
        var width = UIScreen.main.bounds.width
        var y = 0
        var height = 0
        
        let group = DispatchGroup.init()
        
        group.enter()
        SDWebImageManager.shared.loadImage(with: picURL as? URL , options: SDWebImageOptions.highPriority, progress:{(receivedSize:Int,expectedSize:Int,targetURL:URL?)->Void in
            //  let pro = Float(receivedSize)/Float(expectedSize)*100
            //  print("进度..\(pro)%")
            
        }, completed: { ( image:UIImage?,data:Data?, error:Error? ,cacheType:SDImageCacheType, finished:Bool,url:URL?) -> Void in
          // print("下载了一张图片")
           //3.计算大小
            height = Int(width / (image?.size.width)! * ((image?.size.height)!) ?? 0)
            if height >= Int(UIScreen.main.bounds.height) {
                y = 0
            }else {
                y = Int ((UIScreen.main.bounds.height - CGFloat(height)) * 0.5 )
            }
            self.imageView.frame = CGRect(x: x, y: y, width: Int(width), height: height)
            self.scrollView.contentSize = CGSize(width: 0, height: height)
            
            //4.
           // self.imageView.image = image
            self.progressView.isHidden = false
            
            self.imageView.sd_setImage(with: self.getBigURL(smallURL: picURL) as URL, placeholderImage: image, options: [], progress: { ( receivedSize,  expectedSize, _) in
                self.progressView.progress = CGFloat(Double(receivedSize / expectedSize) * 1.0)
            }, completed: { (image:UIImage?, error, _, _) in
                self.progressView.isHidden = true
            })
                
                
                
              //  .sd_setImage(with: getBigURL(smallURL: picURL) as URL, placeholderImage: image)
            
            
            group.leave()
       })
        group.notify(queue: DispatchQueue.main) {
            
        }
    }
    private func getBigURL(smallURL : NSURL ) -> NSURL {
        //1.
        let smallString = smallURL.absoluteString
        smallString?.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return NSURL(string: smallString!)!
        
    }
}
