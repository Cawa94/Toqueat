import UIKit
import RxSwift
import Nuke

class OrderTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!

    @IBOutlet private weak var chefImageView: UIImageView!
    @IBOutlet private weak var chefLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var deliveryLabel: UILabel!
    @IBOutlet private weak var dateLeadingConstraint: NSLayoutConstraint!

    var disposeBag = DisposeBag()
    private var viewModel: OrderTableViewModel?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        chefImageView.roundCorners(radii: self.chefImageView.frame.width/2,
                                   borderWidth: 1.0, borderColor: .mainOrangeColor)
    }

}

extension OrderTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = OrderTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: OrderTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: OrderTableViewModel) {
        self.viewModel = contentViewModel

        chefLabel.text = contentViewModel.order.chef.name
        totalLabel.text = contentViewModel.order.totalPrice.stringWithCurrency
        deliveryLabel.attributedText = contentViewModel.order.deliveryDate.attributedShortMessage
        dateLeadingConstraint.constant = SessionService.isChef ? -50 : 10
        chefLabel.isHidden = SessionService.isChef
        chefImageView.isHidden = SessionService.isChef
        if let url = contentViewModel.order.chef.avatarLink {
            Nuke.loadImage(with: url, into: chefImageView)
        } else {
            chefImageView.image = UIImage(named: "chef_placeholder")
        }
    }

}
