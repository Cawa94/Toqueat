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

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ChefTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ChefTableViewCell")

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChefTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath, isLoading: chefsViewModel.isLoading)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath, isLoading: Bool) {
        if isLoading {
            configureWithPlaceholders(cell, at: indexPath)
        } else {
            configureWithContent(cell, at: indexPath)
        }
    }

    private func configureWithPlaceholders(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let chefCell as ChefTableViewCell:
            chefCell.configureWithLoading(true)
        default:
            break
        }
    }

    private func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let chefCell as ChefTableViewCell:
            let chef = chefsViewModel.elementAt(indexPath.row)
            let viewModel = ChefTableViewModel(chef: chef)
            chefCell.configureWithLoading(contentViewModel: viewModel)
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
        chefsViewModel.elements = chefsViewModel.result
        super.onResultsState()
    }

}
