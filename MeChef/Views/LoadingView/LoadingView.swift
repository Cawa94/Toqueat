import UIKit
import LeadKit
import NVActivityIndicatorView

final class LoadingView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var indicatorContentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("LoadingView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        indicatorContentView.roundCorners(radii: 10.0)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func configure() {
        let indicator = NVActivityIndicatorView(frame: indicatorContentView.bounds,
                                                type: .ballSpinFadeLoader,
                                                color: .highlightedOrangeColor)
        indicator.startAnimating()
        indicatorContentView.addSubview(indicator)
    }

}
