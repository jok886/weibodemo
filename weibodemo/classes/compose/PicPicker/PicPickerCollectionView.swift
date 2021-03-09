//
//  PicPickerCollectionView.swift
//  weibodemo
//
//  Created by macliu on 2021/1/21.
//

import UIKit


private let pickCell = "pickCell"
private let edgeMargin : CGFloat = 15

class PicPickerCollectionView: UICollectionView {

    // MARK: -属性
    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - 系统
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //布局
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = ( UIScreen.main.bounds.width - 4 * edgeMargin ) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = edgeMargin
        layout.minimumInteritemSpacing = edgeMargin
        
        //属性
        register(UINib(nibName: "PicPickerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: pickCell)
        dataSource = self
       // delegate   = self
        //
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }

}
// MARK: - 代理
extension PicPickerCollectionView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pickCell, for: indexPath) as! PicPickerCollectionViewCell
        
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
            
     //   cell.backgroundColor = UIColor.red
        
        return cell
    }
   
}
