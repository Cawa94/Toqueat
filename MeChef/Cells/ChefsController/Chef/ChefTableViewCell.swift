import UIKit
import RxSwift

class ChefTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipesNumberLabel: UILabel!

    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
    }

    func configureWith(_ chef: Chef) {
        nameLabel.text = chef.name
        recipesNumberLabel.text = "Ricette \(chef.dishes?.count ?? 0)"
    }

}
