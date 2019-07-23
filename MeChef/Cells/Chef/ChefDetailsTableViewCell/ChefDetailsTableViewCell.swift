import UIKit
import RxSwift

struct ChefDetailsTableViewModel {

    let chef: Chef
    let descriptionExpanded: Bool

}

final class ChefDetailsTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var presentationTextView: UITextView!
    @IBOutlet private weak var readMore: UIButton!
    @IBOutlet private weak var availabilityButton: UIButton!
    @IBOutlet private weak var instagramButton: UIButton!

    var viewModel: ChefDetailsTableViewModel?
    var disposeBag = DisposeBag()

    public var instaButton: UIButton {
        return instagramButton
    }

    public var availabButton: UIButton {
        return availabilityButton
    }

    public var readMoreButton: UIButton {
        return readMore
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}

extension ChefDetailsTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = ChefDetailsTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: ChefDetailsTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: ChefDetailsTableViewModel) {
        self.viewModel = contentViewModel

        instagramButton.isHidden = contentViewModel.chef.instagramUsername?.isEmpty ?? true
        instagramButton.text = " @\(contentViewModel.chef.instagramUsername ?? "")"
        nameLabel.text = "\(contentViewModel.chef.name) \(contentViewModel.chef.lastname)"
        cityLabel.text = contentViewModel.chef.address.city.name
        presentationTextView.text = contentViewModel.chef.description
        if contentViewModel.descriptionExpanded {
            presentationTextView.translatesAutoresizingMaskIntoConstraints = true
            presentationTextView.sizeToFit()
        }
        readMore.isHidden = contentViewModel.descriptionExpanded
            || presentationTextView.frame.height >
            presentationTextView.sizeThatFits(presentationTextView.bounds.size).height
    }

}
