import UIKit

class ChefTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipesNumberLabel: UILabel!

    func configureWith(_ chef: Chef) {
        nameLabel.text = chef.name
        recipesNumberLabel.text = "Ricette \(chef.dishes?.count ?? 0)"
    }

}
