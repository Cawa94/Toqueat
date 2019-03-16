import UIKit
import MapKit
import RxSwift
import RxCocoa

class AddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    MKLocalSearchCompleterDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarContainerView: UIView!

    private var request = MKLocalSearchCompleter()
    private var matchingItems: [String] = []
    private let disposeBag = DisposeBag()
    private let selectedAddressVariable = Variable<String?>(nil)
    private var initialLocation: CLLocation!

    public var selectedAddressDriver: Driver<String> {
        return selectedAddressVariable.asDriver().filterNil()
    }

    var mapView: MKMapView {
        let map = MKMapView()
        let regionRadius: CLLocationDistance = 10000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
        return map
    }

    private lazy var searchBar = {
        UISearchBar()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarContainerView.addSubview(searchBar)
        searchBar.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        searchBar.sizeToFit()
        searchBar.rx
            .text
            .orEmpty
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { text in
                if self.request.isSearching {
                    self.request.cancel()
                }
                self.request.queryFragment = text
                self.request.region = self.mapView.region
                self.request.delegate = self
            })
            .disposed(by: disposeBag)

        tableView.register(UINib(nibName: "AddressTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "AddressTableViewCell")
    }

    func setLocationFor(city: String) {
        switch city {
        case "Barcelona":
            initialLocation = CLLocation(latitude: 41.3868214, longitude: 2.1695953)
        case "Madrid":
            initialLocation = CLLocation(latitude: 40.4165902, longitude: -3.7132205)
        default:
            initialLocation = CLLocation(latitude: 41.3868214, longitude: 2.1695953)
        }
    }

    // MARK: - UITableViewDelegate - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell",
                                                 for: indexPath)
        let selectedItem = matchingItems[indexPath.row]
        cell.textLabel?.text = selectedItem
        cell.detailTextLabel?.text = ""
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAddressVariable.value = matchingItems[indexPath.row]
        NavigationService.dismissAddressController()
    }

    // MARK: - MKLocalSearchCompleterDelegate

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let addresses = completer.results.map { result in
            result.title
        }

        matchingItems = addresses.uniqueElements
        self.tableView.reloadData()
    }

}
