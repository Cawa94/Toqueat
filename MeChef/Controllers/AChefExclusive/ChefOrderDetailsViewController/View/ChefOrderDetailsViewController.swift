import UIKit
import RxSwift
import RxCocoa

class ChefOrderDetailsViewController: UIViewController {

    var viewModel: ChefOrderDetailsViewModel!

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

    @IBAction func confirmOrderAction(_ sender: Any) {
        guard let chefLocation = SessionService.session?.chef?.stuartLocation
            else { return }
        let createStuartSingle = viewModel.createStuartJobWith(orderId: viewModel.order.id,
                                                               chefLocation: chefLocation)
        self.hudOperationWithRetry(operationSingle: createStuartSingle,
                                   onSuccessClosure: { _ in
                                    self.presentAlertWith(title: "YEAH",
                                                          message: "Order scheduled")
                                    NavigationService.reloadChefOrders = true
        },
                                   disposeBag: self.disposeBag)
    }

    @IBAction func cancelOrderAction(_ sender: Any) {
        viewModel.changeOrderStatusWith(orderId: viewModel.order.id,
                                                       state: .canceled)
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                self.presentAlertWith(title: "YEAH",
                                      message: "Order canceled")
                NavigationService.reloadChefOrders = true
            })
            .disposed(by: self.disposeBag)
    }

}
