import RxSwift

class CheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deliverySlotLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!

    var checkoutViewModel: CheckoutViewModel!
    private let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel.text = SessionService.session?.user?.address.fullAddress

        tableView.register(UINib(nibName: "DishTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "DishTableViewCell")
    }

    @IBAction func selectDeliverySlotAction(_ sender: Any) {
        guard let chefId = checkoutViewModel.chefId
            else { return }
        let deliverySlotsController = NavigationService.deliverySlotsViewController(chefId: chefId)
        deliverySlotsController.deliverySlotDriver
            .drive(self.deliverySlotLabel.rx.text)
            .disposed(by: disposeBag)
        NavigationService.presentDeliverySlots(controller: deliverySlotsController)
    }

    @IBAction func selectAddressAction(_ sender: Any) {
        guard let city = SessionService.session?.user?.city.name
            else { return }
        let addressController = NavigationService.addressViewController(city: city)
        addressController.selectedAddressDriver
            .map { $0.fullAddress }
            .drive(addressLabel.rx.text)
            .disposed(by: disposeBag)
        NavigationService.presentAddress(controller: addressController)
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkoutViewModel.elements.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishTableViewCell",
                                                 for: indexPath)
        configure(cell, at: indexPath)
        return cell
    }

    private func configure(_ cell: UITableViewCell, at indexPath: IndexPath) {
        configureWithContent(cell, at: indexPath)
    }

    private func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let dishCell as DishTableViewCell:
            let dish = checkoutViewModel.elementAt(indexPath.row)
            let viewModel = DishTableViewModel(dish: dish.asDish,
                                               chefName: nil)
            dishCell.configureWithLoading( contentViewModel: viewModel)
        default:
            break
        }
    }

}

private extension String {

    var fullAddress: String {
        guard let city = SessionService.session?.user?.city.name,
            let zipcode = SessionService.session?.user?.zipcode
            else { return self }
        return "\(self), \(zipcode) \(city)"
    }

}
