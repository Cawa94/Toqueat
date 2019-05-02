import UIKit
import RxSwift
import RxCocoa

class OrderDetailsViewController: UIViewController {

    var viewModel: OrderDetailsViewModel!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .mainOrangeColor
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.darkGrayColor]
        navigationController?.isNavigationBarHidden = false
        title = "Order Details"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ",
                                                           style: .plain, target: nil, action: nil)
    }

}
