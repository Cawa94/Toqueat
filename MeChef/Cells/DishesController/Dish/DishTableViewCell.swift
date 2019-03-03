import UIKit

class DishTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func configureWith(_ dish: Dish) {
        nameLabel.text = dish.name
        descriptionLabel.text = dish.description
    }

}
