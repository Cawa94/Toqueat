import UIKit
import Nuke
import LeadKit

final class DriverDeliveringView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var driverImageView: UIImageView!
    @IBOutlet private weak var extimatedTimeLabel: UILabel!
    @IBOutlet private weak var callButton: UIButton!

    private var viewModel: DriverDeliveringViewModel?

    public var callDriverButton: UIButton {
        return callButton
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("DriverDeliveringView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        driverImageView.roundCorners(radii: 10,
                                     borderWidth: 1, borderColor: .lightGrayColor)
    }

}

extension DriverDeliveringView: ConfigurableView {

    public func configure(with viewModel: DriverDeliveringViewModel) {
        self.viewModel = viewModel
    }

    func updateEtaText() {
        extimatedTimeLabel.attributedText = viewModel?.attributedExtimatedTime()
    }

}
