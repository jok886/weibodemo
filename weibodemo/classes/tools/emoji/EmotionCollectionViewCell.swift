//
//  EmotionCollectionViewCell.swift
//  nettool
//
//  Created by macliu on 2021/1/21.
//

import UIKit

class EmotionCollectionViewCell: UICollectionViewCell {
    // MARK: - 属性
    var emotion : Emotion? {
        didSet {
            guard let emotion = emotion else {
                return
            }
            //
            emotionBtn.setBackgroundImage(UIImage(contentsOfFile: emotion.pngPath ?? ""), for: .normal)
            emotionBtn.setTitle(emotion.emojiCode, for: .normal)
            
            //删除按钮
            if emotion.isRemove {
                emotionBtn.setBackgroundImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }else{
                
            }
        }
    }
    private lazy var emotionBtn : UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}
// MARK: - UI
extension EmotionCollectionViewCell {
    private func setupUI() {
        //1 添加子控件
        contentView.addSubview(emotionBtn)
        //2
        emotionBtn.frame = contentView.frame
        //3. 设置属性
        emotionBtn.isUserInteractionEnabled = false
        emotionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        
        
    }
}
