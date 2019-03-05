import UIKit
import RxSwift

class DishViewController: BaseStatefulController<Dish> {

    var dishViewModel: DishViewModel! {
        didSet {
            viewModel = dishViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
