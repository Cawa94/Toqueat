import UIKit
import RxSwift

class ChefViewController: UIViewController {

    @IBOutlet weak var chefNameLabel: UILabel!
    @IBOutlet weak var chefDishesTableView: UITableView!

    var viewModel: ChefViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        self.chefNameLabel.text = viewModel.chef.name

        chefDishesTableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                                     forCellReuseIdentifier: "DishTableViewCell")
    }

}

extension ChefViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chefDishes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            let dish = viewModel.chefDishes[indexPath.row]
            dishCell.configureWith(dish)
        default:
            break
        }
    }

}
