import UIKit
import StatefulViewController
import RxSwift
import RxCocoa

class BaseStatefulController<ResultType>: UIViewController, StatefulViewController {

    private let disposeBag = DisposeBag()
    typealias ViewModelType = BaseStatefulViewModel<ResultType>
    var viewModel: ViewModelType!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialViewState()

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

}
