import UIKit
import StatefulViewController
import RxSwift
import RxCocoa

class BaseStatefulController<ResultType>: UIViewController, StatefulViewController,
    UIGestureRecognizerDelegate, UIScrollViewDelegate {

    private let disposeBag = DisposeBag()
    typealias ViewModelType = BaseStatefulViewModel<ResultType>
    var viewModel: ViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        setupInitialViewState()
        configureNavigationBar()

        viewModel.loadingStateDriver
            .drive(stateChanged)
            .disposed(by: disposeBag)
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .mainOrangeColor
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.darkGrayColor]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ",
                                                           style: .plain, target: nil, action: nil)
    }

    var stateChanged: Binder<ViewModelType.LoadingState> {
        return Binder(self) { base, value in
            switch value {
            case .loading:
                base.onLoadingState()
            case .result:
                base.onResultsState()
            case .empty:
                base.onEmptyState()
            case .error(let error):
                base.onErrorState(error: error)
            case .initial:
                break
            }
        }
    }

    // MARK: - StatefulViewController related methods

    func onLoadingState() {}

    func onResultsState() {}

    func onEmptyState() {}

    func onErrorState(error: Error) {}

    func retry() {
        startLoading()
        viewModel.retry()
    }

    func reload() {
        startLoading()
        viewModel.reload()
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {}

}
