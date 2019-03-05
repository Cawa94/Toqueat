import UIKit
import RxSwift
import RxGesture

class ChefsViewController: BaseTableViewController<[Chef], Chef> {

    var chefsViewModel: ChefsViewModel! {
        didSet {
            tableViewModel = chefsViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ChefTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ChefTableViewCell")

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let chefCell as ChefTableViewCell:
            let chef = chefsViewModel.elementAt(indexPath.row)
            chefCell.configureWith(chef)
            chefCell.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    NavigationService.pushChefViewController(chefId: chef.id)
                })
                .disposed(by: chefCell.disposeBag)
        default:
            break
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        chefsViewModel.elements = chefsViewModel.result ?? []
        super.onResultsState()
    }

}
