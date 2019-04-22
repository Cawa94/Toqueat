import UIKit
import RxSwift

class AddDishTableViewCell: UITableViewCell {

    @IBOutlet private weak var addDishButton: RoundedButton!

    public var addDish: RoundedButton {
        return addDishButton
    }

    var disposeBag = DisposeBag()
    private var viewModel: ChefOrderTableViewModel?

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    override func awakeFromNib() {
        let buttonModel = RoundedButtonViewModel(title: "Add dish", type: .squeezedOrange)
        addDishButton.configure(with: buttonModel)
    }

}
