import UIKit
import RxSwift
import RxGesture

class ChefsViewController: UIViewController {

    @IBOutlet weak var chefsTableView: UITableView!

    var viewModel: ChefsViewModel!
    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        chefsTableView.register(UINib(nibName: "ChefTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "ChefTableViewCell")

        NetworkService.shared.getAllChefs()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { chefs in
                self.viewModel.chefsList = chefs
                self.chefsTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

}

extension ChefsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chefsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let chefCell as ChefTableViewCell:
            let chef = viewModel.chefsList[indexPath.row]
            chefCell.configureWith(chef)
            chefCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushChefViewController(chef: chef)
                })
                .disposed(by: chefCell.disposeBag)
        default:
            break
        }
    }

}
