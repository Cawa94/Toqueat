import UIKit
import LeadKit
import RxSwift
import RxCocoa

final class GoToPaymentView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var whiteBackgroundView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var goToPaymentButton: RoundedButton!

    private var viewModel: GoToPaymentViewModel?
    private let disposeBag = DisposeBag()

    public var openCheckoutButton: RoundedButton {
        return goToPaymentButton
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("GoToPaymentView",
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

        whiteBackgroundView.layer.cornerRadius = 15.0
        whiteBackgroundView.clipsToBounds = true
        whiteBackgroundView.drawShadow(cornerRadii: 15.0,
                                       size: CGSize(width: 0, height: 5),
                                       opacity: 0.2)
        let buttonModel = RoundedButtonViewModel(title: "Proceed to checkout",
                                                 type: .defaultOrange)
        goToPaymentButton.configure(with: buttonModel)
    }

}

extension GoToPaymentView: ConfigurableView {

    public func configure(with viewModel: GoToPaymentViewModel) {
        self.viewModel = viewModel

        messageLabel.attributedText = viewModel.selectedSlot.attributedDeliveryMessage
    }

}
