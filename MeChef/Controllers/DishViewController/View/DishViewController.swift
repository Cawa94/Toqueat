import UIKit
import RxSwift

class DishViewController: UIViewController {

    var viewModel: DishViewModel!
    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

}
