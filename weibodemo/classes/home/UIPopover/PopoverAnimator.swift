//
//  PopoverAnimator.swift
//  weibodemo
//
//  Created by macliu on 2021/1/18.
//

import UIKit

class PopoverAnimator: NSObject {
    //对外提供属性
    
    //
    var isPresented : Bool = false
    var presentedFrame : CGRect = .zero
    
    var callback : ((_ presented : Bool) -> ())?
    
    override init() {
        
    }
    // MARK- zidingyi
    //自定义了构造函数，但是没有重写init()，自定义构造会覆盖init()构造函数
    init(callback : @escaping (_ presented : Bool) -> ()) {
        self.callback = callback
    }
}



// MARK: -转场代理
extension PopoverAnimator : UIViewControllerTransitioningDelegate {
    //弹出尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentation = WMUPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentedFrame // 
        return presentation
    }
    //弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callback!(isPresented)
        return self
    }
    //消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callback!(isPresented)
        return self
    }
}
//弹出和消失动画代理
extension PopoverAnimator : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
   
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
      
        isPresented ? animateTransitionPresentes(transitionContext: transitionContext) : animateTransitionDismiss(transitionContext: transitionContext)
   
    }
    
    //自定义弹出动画
    private func animateTransitionPresentes (transitionContext: UIViewControllerContextTransitioning) {
        //1.
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        //2
        transitionContext.containerView.addSubview(presentedView)
        //执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),animations: {
            presentedView.transform = .identity
            transitionContext.completeTransition(true)
        })
    }
    
    //自定义消失
    private func animateTransitionDismiss (transitionContext: UIViewControllerContextTransitioning) {
        //1.
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        //2
        UIView.animate(withDuration: transitionDuration(using: transitionContext),animations: {
            dismissView.transform = CGAffineTransform(scaleX: 1.0,y: 0.0001)
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        })

    }

}
