import UIKit
import StatefulViewController
import RxSwift
import RxCocoa

class BaseStatefulController<ResultType>: UIViewController, StatefulViewController,
    UIGestureRecognizerDelegate, UIScrollViewDelegate {

    private let disposeBag = DisposeBag()
    typealias ViewModelType = BaseStatefulViewModel<ResultType>
    var viewModel: ViewModelType!

    lazy var loadingStateView = {
        LoadingView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        loadingView = loadingStateView

        setupInitialViewState()
        configureNavigationBar()

        viewModel.loadingStateDriver
            .drive(stateChanged)
            .disposed(by: disposeBag)
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

    func onLoadingState() {
        startLoading(with: loadingStateView)
    }

    func onResultsState() {
        endLoading(with: loadingStateView)
    }

    func onEmptyState() {
        endLoading(with: loadingStateView)
    }

    func onErrorState(error: Error) {
        endLoading(with: loadingStateView)
    }

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

    // MARK: - LoadingActivityIndicator related methods

    func showActivityIndicatorView() {
        backingView.addSubview(loadingStateView)
        loadingStateView.setToCenter()
    }

    func hideActivityIndicatorView() {
        loadingStateView.removeFromSuperview()
    }

}

extension StatefulViewController {

    func startLoading(with loadingView: LoadingView) {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        backingView.addSubview(loadingView)
        loadingView.setToCenter()
        //transitionViewStates(loading: true, animated: true, completion: nil)
    }

    func endLoading(with loadingView: LoadingView, error: Error? = nil) {
        loadingView.removeFromSuperview()
        //transitionViewStates(loading: false, error: error, animated: false, completion: nil)
    }

}
