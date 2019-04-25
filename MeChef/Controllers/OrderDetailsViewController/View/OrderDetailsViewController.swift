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
            [NSAttributedString.Key.foregroundColor: UIColor.mainOrangeColor]
        navigationController?.isNavigationBarHidden = false
        title = "Order Details"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(dismissOrder))
    }

    @objc func dismissOrder() {
        NavigationService.popNavigationTopController()
    }

}
