import UIKit
import RxSwift

class DishTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    func configureWith(_ dish: Dish) {
        nameLabel.text = dish.name
        descriptionLabel.text = dish.description
    }

}
