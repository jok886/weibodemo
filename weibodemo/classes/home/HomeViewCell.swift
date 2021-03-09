//
//  HomeViewCell.swift
//  weibodemo
//
//  Created by macliu on 2021/1/20.
//

import UIKit
import SDWebImage
import HYLabel


private let edgeMargin : CGFloat = 15
private let itemMargin : CGFloat = 10

class HomeViewCell: UITableViewCell {
    // MARK:- 属性
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: HYLabel!
    @IBOutlet weak var retweetLabel: HYLabel!
    
    @IBOutlet weak var retweetBGView: UIView!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var BottomView: UIView!
    // MARK:- 内容宽度约束
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var collectViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweenTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    
    // MARK:-定义属性
    var viewModel : StatusViewMode? {
        didSet {
            //1. nil效验
            guard let viewModel = viewModel else{
                return
            }
            //2.设置头像
          
            iconView.sd_setImage(with: viewModel.profileURL as URL?, placeholderImage: UIImage(named: "avatar_default_small"))
            
            //3.认证图像
            verifiedView.image = viewModel.verifiedImage
            //4.昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            //5.会员图标
            vipView.image = viewModel.vipImage
            //6。时间
            timeLabel.text = viewModel.createatText
            
            //7.微博正文
            contentLabel.attributedText = FindEmotion.shareInstance.findAttrString(statusText: viewModel.status?.text, font: contentLabel.font)
            
            if let sourceText = viewModel.sourceText  {
                sourceLabel.text = "来自" + sourceText
            }else {
                sourceLabel.text = nil
            }
            
            
            //8.设置昵称颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            
            //9.计算picView高度宽度
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewWCons.constant = picViewSize.width
            picViewHCons.constant = picViewSize.height
            
            //10数据传递
            picView.picURLs = viewModel.picURLs
            
            //11转发微博
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,
                   let retweenText = viewModel.status?.retweeted_status?.text {
                    
                    let retweetedText = "@" + "\(screenName): " + retweenText
                    retweetLabel.attributedText =  FindEmotion.shareInstance.findAttrString(statusText: retweetedText, font: retweetLabel.font)
                    //设置转发正文顶部的约束
                    retweenTopCons.constant = 15
                }
                retweetBGView.isHidden = false
                
            }else{
                retweetLabel.text = nil
                retweetBGView.isHidden = true
                
                //设置转发正文顶部的约束
                retweenTopCons.constant = 0
            }
            
            //12 计算cell高度
            
            if viewModel.cellHeight == 0 {
                //强制布局
                layoutIfNeeded()
                
                //12.2获取底部工具的最大Y值
                viewModel.cellHeight  =  BottomView.frame.maxY
            }
      
            
            
            
            
        }
    }
    
    // MARK:- 系统函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //设置正文宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        //设置HYLabel 内容 颜色
        contentLabel.matchTextColor = UIColor.purple
        retweetLabel.matchTextColor = UIColor.purple
        //监听点击 事件
        contentLabel.userTapHandler = { (label,user,range) in
            
        }
        contentLabel.linkTapHandler = { (label,link,range) in
            
        }
        contentLabel.topicTapHandler = { (label,topic,range) in
            
        }
    }



}
extension HomeViewCell {
    private func calculatePicViewSize(count : Int) -> CGSize {
        //1.没有图
        if count == 0 {
            collectViewBottomCons.constant = 0
            return .zero
        }
        
        collectViewBottomCons.constant = 10
        //取出布局
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
       // let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
      
        
        //单张配图
        if count == 1 {
            //请求图片的高度宽度
            //取出图片
            let urlString = viewModel?.picURLs.last?.absoluteString
            
            var w : CGFloat = 0.0
            var h : CGFloat = 0.0
           // let image = SDWebImageManager.shared.imageCache.imagefrom
          
       
            
            let semaclound = DispatchSemaphore(value: 0)
            
            
           SDWebImageManager.shared.imageCache.queryImage(forKey: urlString, options: SDWebImageOptions.highPriority, context: nil, cacheType: .disk) { (image:UIImage?, data:Data?, cacheType:SDImageCacheType) in
      
            if image != nil {
                w = CGFloat(image!.size.width  * 2)
                h = CGFloat(image!.size.height  * 2)
                
               
            }
  
            semaclound.signal();
            
           }
            
            semaclound.wait(timeout: DispatchTime.distantFuture)
            
            layout.itemSize = CGSize(width: w, height: h)
            
            return CGSize(width: w, height: h)
      
        }

        
        //2. 计算,
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        //布局
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        
        
        //3.4张
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1  //修复bug +1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        //计算行
        let rows = CGFloat( (count - 1 ) / 3 + 1)
        //4.2 计算高度
        let picViewH = rows * imageViewWH + (rows - 1 ) * itemMargin
        //
        let picViewW = UIScreen.main.bounds.width - 2 * itemMargin
        
        return CGSize(width: picViewW, height: picViewH)
        
    }
}
