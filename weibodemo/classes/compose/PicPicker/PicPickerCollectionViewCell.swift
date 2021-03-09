//
//  PicPickerCollectionViewCell.swift
//  weibodemo
//
//  Created by macliu on 2021/1/21.
//

import UIKit

class PicPickerCollectionViewCell: UICollectionViewCell {

    var image : UIImage? {
        didSet {
            if (image != nil)  {
               // addBtn.setBackgroundImage(image, for: .normal)
                addBtn.isUserInteractionEnabled = false
                imageView.image = image
                delBtn.isHidden = false
            }else {
                imageView.image = nil
                addBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), for: .normal)
                addBtn.isUserInteractionEnabled = true
                delBtn.isHidden = true
            }
        }
    }
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var delBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - 事件
    @IBAction func AddClick(_ sender: Any) {
        //通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: showPhotoBrowserNotification), object: nil)
        
    }
    @IBAction func delClick(_ sender: Any) {
        //
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: removePhotoBrowserNotification), object: imageView.image)
    }
    
}
