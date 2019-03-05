import UIKit
import RxSwift

class DishesViewController: UIViewController {

    @IBOutlet weak var dishesTableView: UITableView!

    var viewModel: DishesViewModel!
    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dishesTableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                                 forCellReuseIdentifier: "DishTableViewCell")

        NetworkService.shared.getAllDishes()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { chefs in
                self.viewModel.dishesList = chefs
                self.dishesTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

}

extension DishesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dishesList.count
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
            let dish = viewModel.dishesList[indexPath.row]
            dishCell.configureWith(dish)
            dishCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushDishViewController(dish: dish)
                })
                .disposed(by: dishCell.disposeBag)
        default:
            break
        }
    }

}
