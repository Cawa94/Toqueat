import RxSwift
import RxCocoa
import LeadKit

private extension RxTimeInterval {

    static let delayErrorShowing: RxTimeInterval = 0.5

}

public protocol BaseViewModel: class {
    // Nothing
}

class BaseStatefulViewModel<ResultType>: BaseViewModel {

    typealias LoadingState = GeneralDataLoadingState<Single<ResultType>>
    private let loadingViewModel: GeneralDataLoadingViewModel<ResultType>
    private let loadingStateVariable = Variable<LoadingState>(.initial)
    private let disposeBag = DisposeBag()

    init(dataSource: Single<ResultType>) {
        loadingViewModel = GeneralDataLoadingViewModel(dataSource: dataSource)

        loadingViewModel.loadingStateDriver
            .drive(loadingStateVariable)
            .disposed(by: disposeBag)

        loadingViewModel.reload()
    }

    var loadingStateDriver: Driver<LoadingState> {
        return loadingStateVariable.asDriver()
            .flatMap { state -> Driver<LoadingState> in
                switch state {
                case .error:
                    return Driver.just(state).delay(.delayErrorShowing)
                default:
                    return Driver.just(state)
                }
        }
    }

    final var currentLoadingState: LoadingState {
        return loadingStateVariable.value
    }

    var result: ResultType? {
        if case .result(let result, _) = currentLoadingState {
            return result
        } else {
            return nil
        }
    }

    var hasContent: Bool {
        return currentLoadingState.hasContent
    }

    var isLoading: Bool {
        return currentLoadingState.isLoading
    }

    func retry() {
        //loadingViewModel.retry()
    }

    func reload() {
        loadingViewModel.reload()
    }

}

extension GeneralDataLoadingState {

    var hasContent: Bool {
        if case .result = self {
            return true
        } else {
            return false
        }
    }

    var isLoading: Bool {
        if case .loading = self {
            return true
        } else {
            return false
        }
    }

}
