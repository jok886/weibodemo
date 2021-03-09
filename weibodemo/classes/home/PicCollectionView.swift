//
//  PicCollectionView.swift
//  weibodemo
//
//  Created by macliu on 2021/1/20.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {

    // MARK:-属性
    var picURLs : [NSURL] = [NSURL]() {
        didSet {
            self.reloadData()
        }
    }
    
    
    // MARK:-系统
    
    // MARK: - 系统
    override  func awakeFromNib() {
        super.awakeFromNib()
        
        dataSource = self
        delegate   = self
    }

}
// MARK:-
extension PicCollectionView : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        
        //cell.backgroundColor = UIColor.red
        cell.picURL = picURLs[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //点击图片
      //  indexPath.item
        // 1. 获取点击的图片 url, index
        let userInfo = [showPhotoBrowserNotificationIndexPath: indexPath , showPhotoBrowserNotificationURLs : picURLs] as [String : Any]
        
        //
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: showPhotoBrowserNotificationhome), object: self, userInfo: userInfo)
        
        
        
    }
    
}
extension PicCollectionView : AnimatorPresentedDelegate {
    func startRect(indexpath: NSIndexPath) -> CGRect {
        //1.获取cell
        let cell = self.cellForItem(at: indexpath as IndexPath)!
        //2.
        let startframe = self.convert(cell.frame, to: UIApplication.shared.keyWindow!)
         return startframe
    }
    
    func endRect(indexpath: NSIndexPath) -> CGRect {
        //获取
        let picURL = picURLs[indexpath.item]
      //  let group = DispatchGroup.init()
        
        
        
        let x = 0
        var width = UIScreen.main.bounds.width
        var y = 0
        var height = 0
        
        
        let semaclound = DispatchSemaphore(value: 0)
        

        SDWebImageManager.shared.loadImage(with: picURL as? URL , options: SDWebImageOptions.highPriority, progress:nil, completed: { ( image:UIImage?,data:Data?, error:Error? ,cacheType:SDImageCacheType, finished:Bool,url:URL?) -> Void in
          // print("下载了一张图片")
            //
            height = Int(width / (image?.size.width)! * ((image?.size.height)!) ?? 0)
            if height >= Int(UIScreen.main.bounds.height) {
                y = 0
            }else {
                y = Int ((UIScreen.main.bounds.height - CGFloat(height)) * 0.5 )
            }
            
            semaclound.signal();
       })
        semaclound.wait(timeout: DispatchTime.distantFuture)
        return CGRect(x: 0, y: y, width: Int(width), height: height)
  
        
        
    }
    
    func imageView(indexpath: NSIndexPath) -> UIImageView {
        //
        let imageView = UIImageView()
        
        let picURL = picURLs[indexpath.item]
        
        //2.
        let semaclound = DispatchSemaphore(value: 0)
        

        SDWebImageManager.shared.loadImage(with: picURL as? URL , options: SDWebImageOptions.highPriority, progress:nil, completed: { ( image:UIImage?,data:Data?, error:Error? ,cacheType:SDImageCacheType, finished:Bool,url:URL?) -> Void in
          // print("下载了一张图片")
            //
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            semaclound.signal();
       })
        semaclound.wait(timeout: DispatchTime.distantFuture)
        
        return imageView
    }
    
    
}
class PicCollectionViewCell : UICollectionViewCell{
    
    // MARK:-自定义属性
    var picURL : NSURL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            iconView.sd_setImage(with: picURL as URL?, placeholderImage: UIImage(named: "empty_picture"))
        }
    }
    
    @IBOutlet weak var iconView: UIImageView!
    
}
