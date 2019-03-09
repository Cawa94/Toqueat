import UIKit
import RxSwift

class DishViewController: BaseStatefulController<Dish> {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var chefNameLabel: UILabel!

    var dishViewModel: DishViewModel! {
        didSet {
            viewModel = dishViewModel
        }
    }

    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func addToCartAction(_ sender: Any) {
        CartService.addToCart(product: BaseResultWithIdAndName(id: dishViewModel.result.id,
                                                               name: dishViewModel.result.name))
        debugPrint("CART PRODUCTS: \(CartService.localCart?.products.map { $0.name } ?? ["Unknown"])")
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        nameLabel.text = dishViewModel.result.name
        descriptionLabel.text = dishViewModel.result.description
        chefNameLabel.text = "Chef: \(dishViewModel.result.chef.name)"
    }

    override func onLoadingState() {
        nameLabel.text = "LOADING"
        descriptionLabel.text = "LOADING"
        chefNameLabel.text = "LOADING"
    }

}
