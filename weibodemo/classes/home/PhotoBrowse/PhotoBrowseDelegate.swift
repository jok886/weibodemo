//
//  PhotoBrowseDelegate.swift
//  weibodemo
//
//  Created by macliu on 2021/1/23.
//

import UIKit


//面向协议开发
protocol AnimatorPresentedDelegate : NSObjectProtocol {
    func startRect(indexpath : NSIndexPath) -> CGRect
    func endRect(indexpath : NSIndexPath) -> CGRect
    func imageView(indexpath : NSIndexPath) -> UIImageView
    
}
protocol AnimatorDismissDelegate : NSObjectProtocol {
    func indexPathforDismissView() -> NSIndexPath
    func imageViewforDismissView() -> UIImageView
}

class PhotoBrowseDelegate: NSObject {
    var isPresented : Bool = false
    
    var presentedDelgate : AnimatorPresentedDelegate?
    var indexpath : NSIndexPath?
    
    var dismissDelgate : AnimatorDismissDelegate?
    
}



extension PhotoBrowseDelegate : UIViewControllerTransitioningDelegate {
 
    
 
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        isPresented = true
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}
extension PhotoBrowseDelegate : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
       
        isPresented ? animateForPresentedView(transitionContext: transitionContext) : animateForDismissView(transitionContext: transitionContext)
        
    }

    func animateForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let presentedDelgate = presentedDelgate ,let indexpath = indexpath else {
            return
        }
        //1.取出弹出的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //2.添加到containerView
        transitionContext.containerView.addSubview(presentedView )
        //3.执行动画
        let startRect = presentedDelgate.startRect(indexpath: indexpath)
        let imageView = presentedDelgate.imageView(indexpath: indexpath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        
        
        presentedView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            imageView.frame = presentedDelgate.endRect(indexpath: indexpath)
        } completion: { (_) in
            imageView.removeFromSuperview()
            presentedView.alpha = 1.0
            
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    func animateForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let dismissDelgate = dismissDelgate,let presentedDelgate = presentedDelgate  else {
            return
        }
        
        //1.
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        dismissView.removeFromSuperview()
        
        let imageView = dismissDelgate.imageViewforDismissView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelgate.indexPathforDismissView()
        //2.
        //3.执行动画
        //dismissView.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
           // dismissView.alpha = 0.0
            imageView.frame = presentedDelgate.startRect(indexpath: indexPath)
        } completion: { (_) in
          //  dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
