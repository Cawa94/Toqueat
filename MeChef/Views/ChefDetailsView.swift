import UIKit

final class ChefDetailsView: UIView {

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var presentationLabel: UILabel!
    @IBOutlet private weak var availabilityButton: UIButton!
    @IBOutlet private weak var instagramButton: UIButton!

    var viewModel: Chef?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("ChefDetailsView",
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

}

extension ChefDetailsView: PlaceholderConfigurable {

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

        nameLabel.text = "\(contentViewModel.name) \(contentViewModel.lastname)"
        cityLabel.text = contentViewModel.city.name
        presentationLabel.text = "Sono una chef esperta che sa fare tutti i piatti "
            + "del mondo e sono sempre buonissimi"
    }

}
