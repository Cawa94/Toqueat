import UIKit

class AnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private let duration = 0.3
    var originFrame: CGRect = .zero
    var originCornerRadius: CGFloat = 0.0
    var presenting = true
    var dismissCompletion: (() -> Void)?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let finalView = presenting ? toView : transitionContext.view(forKey: .from)!

        let initialFrame = presenting
            ? originFrame : CGRect(x: 0, y: 0, width: containerView.frame.width, height: 250)
        let finalFrame = presenting
            ? CGRect(x: 0, y: 0, width: containerView.frame.width, height: 250) : originFrame

        let xScaleFactor = presenting ?
            initialFrame.width / finalFrame.width :
            finalFrame.width / initialFrame.width

        let yScaleFactor = presenting ?
            initialFrame.height / finalFrame.height :
            finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                               y: yScaleFactor)

        if presenting {
            finalView.transform = scaleTransform
            finalView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            finalView.clipsToBounds = true
            finalView.roundCorners(radii: originCornerRadius)
        }

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(finalView)

        UIView.animate(withDuration: duration, animations: {
            if self.presenting {
                finalView.transform = CGAffineTransform.identity
                finalView.roundCorners(radii: 0)
            } else {
                finalView.transform = scaleTransform
                finalView.roundCorners(radii: self.originCornerRadius)
            }
            finalView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { _ in
            self.dismissCompletion?()
            transitionContext.completeTransition(true)
        })
    }

}
