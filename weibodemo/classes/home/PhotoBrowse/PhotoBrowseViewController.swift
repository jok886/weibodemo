//
//  PhotoBrowseViewController.swift
//  weibodemo
//
//  Created by macliu on 2021/1/23.
//

import UIKit
import SnapKit
import SVProgressHUD

private let PhotoCell = "PhotoCell"
class PhotoBrowseViewController: UIViewController {
    // MARK: - 属性
    var indexPath : IndexPath?
    var picURLs : [NSURL]?
    // MARK: - 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoBrowseCollectionViewLayout())
    private lazy var closeBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "关闭")
    private lazy var saveBtn : UIButton = UIButton(bgColor: UIColor.darkGray, fontSize: 14, title: "保存")
    
    
    // MARK: - 构造
    init(indexPath : IndexPath,picURLs : [NSURL]) {
        
        self.indexPath = indexPath
        self.picURLs = picURLs
        
        
        
        super.init(nibName: nil, bundle: nil)
       
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    // MARK: - 系统
    override func loadView() {
        view.frame.size.width += 20  //图片之间的间距
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupUI()
        //滚动到指定位置
        collectionView.scrollToItem(at: indexPath!, at: .left, animated: true)
        
    }
    

 

}
// MARK: - UI
extension PhotoBrowseViewController {
    private func setupUI() {
        //1.
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        //2.
        collectionView.frame = view.bounds
   
        
        closeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp_makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn.snp_bottom)
            make.size.equalTo(closeBtn.snp_size)
        }
        
        //3.collectionview属性
        collectionView.register(PhotoBrowseViewCell.self, forCellWithReuseIdentifier: PhotoCell)
        collectionView.dataSource = self
 
       
        //
        closeBtn.addTarget(self, action: "closeClick", for: .touchUpInside)
        saveBtn.addTarget(self, action: "saveClick", for: .touchUpInside)
    }
}
// MARK: - 事件
extension PhotoBrowseViewController  {
    
    @objc private func closeClick() {
        dismiss(animated: true, completion: nil)
    }
    //保存图片
    @objc private func saveClick() {
        //1.获取显示的image
       let cell = collectionView.visibleCells.first as! PhotoBrowseViewCell
        guard let image = cell.imageView.image else {
            return
        }
        //2.保存到相册
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        //3.
        
    }
   // - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;

    @objc private func image(image : UIImage,didFinishSavingWithError error: Error,contextInfo : AnyObject) {
        //
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        }else {
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}
// MARK: - 代理
extension PhotoBrowseViewController : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell, for: indexPath) as! PhotoBrowseViewCell
        
        //2.
        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.green
        cell.picURL = picURLs?[indexPath.item]
        cell.delegate = self
        //3.
        return cell
    }

}
// MARK: - cell代理
extension PhotoBrowseViewController : PhotoBrowseViewCellDelgate {
    func imageViewClick(){
        closeClick()
    }
}
//
// MARK: - AnimatorDismissDelegate代理
extension PhotoBrowseViewController : AnimatorDismissDelegate {
    func indexPathforDismissView() -> NSIndexPath {
        //1.
        let cell = collectionView.visibleCells.first!
        return collectionView.indexPath(for: cell)! as NSIndexPath
    }
    
    func imageViewforDismissView() -> UIImageView {
        //1.
        let imageView = UIImageView()
        
        //
        let cell = collectionView.visibleCells.first as! PhotoBrowseViewCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        //
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
        
    }
    
    
}


class PhotoBrowseCollectionViewLayout: UICollectionViewFlowLayout{
   
    override func prepare() {
        super.prepare()
        //1.
        itemSize = collectionView!.frame.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .horizontal
        
        //
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
    }
}
