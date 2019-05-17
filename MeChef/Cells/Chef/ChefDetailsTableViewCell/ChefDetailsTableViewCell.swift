import UIKit
import RxSwift

final class ChefDetailsTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var presentationLabel: UILabel!
    @IBOutlet private weak var availabilityButton: UIButton!
    @IBOutlet private weak var instagramButton: UIButton!

    var viewModel: Chef?
    var disposeBag = DisposeBag()

    public var instaButton: UIButton {
        return instagramButton
    }

    public var availabButton: UIButton {
        return availabilityButton
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}

extension ChefDetailsTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = Chef
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: Chef? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: Chef) {
        self.viewModel = contentViewModel

        instagramButton.isHidden = contentViewModel.instagramUsername == nil
        instagramButton.text = " @\(contentViewModel.instagramUsername ?? "")"
        nameLabel.text = "\(contentViewModel.name) \(contentViewModel.lastname)"
        cityLabel.text = contentViewModel.city.name
        presentationLabel.text = contentViewModel.description
    }

}
