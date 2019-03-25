import RxSwift
import RxCocoa

extension ObservableConvertibleType {

    func asDriver(onErrorDriver: Driver<E> = .empty()) -> Driver<E> {
        return asDriver(onErrorDriveWith: onErrorDriver)
    }

}
