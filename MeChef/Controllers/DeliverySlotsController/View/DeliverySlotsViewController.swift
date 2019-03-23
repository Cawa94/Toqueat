import RxSwift
import RxCocoa
import RxOptional

class DeliverySlotsViewController: BaseStatefulController<[DeliverySlot]>,
    UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var weekdayPicker: UIPickerView!
    @IBOutlet weak var hourPicker: UIPickerView!

    var deliverySlotsViewModel: DeliverySlotsViewModel! {
        didSet {
            viewModel = deliverySlotsViewModel
        }
    }

    private let disposeBag = DisposeBag()
    private let deliverySlotVariable = Variable<String?>(nil)

    public var deliverySlotDriver: Driver<String> {
        return deliverySlotVariable.asDriver().filterNil()
    }

    var weekdaySelectedIndex = 0
    var hourSelectedIndex = 0
    var hoursIds: [Int64] = []

    // MARK: - UIPickerViewDelegate - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == weekdayPicker {
            return deliverySlotsViewModel.listOfWeekdaysIds.count
        } else if pickerView == hourPicker {
            return hoursIds.count
        } else {
            return 0
        }
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == weekdayPicker {
            return deliverySlotsViewModel.weekdayNameWith(weekdayId: deliverySlotsViewModel.listOfWeekdaysIds[row])
        } else if pickerView == hourPicker {
            return deliverySlotsViewModel.hoursRangeWith(
                hourId: hoursIds[row],
                weekdayId: deliverySlotsViewModel.listOfWeekdaysIds[weekdaySelectedIndex])
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == weekdayPicker {
            weekdaySelectedIndex = row
            hourSelectedIndex = 0
            hoursIds = deliverySlotsViewModel.listOfHoursIdsFor(selectedIndex: weekdaySelectedIndex)
            hourPicker.reloadAllComponents()
        } else if pickerView == hourPicker {
            hourSelectedIndex = row
            let weekdayId = deliverySlotsViewModel.listOfWeekdaysIds[weekdaySelectedIndex]
            let hourId = hoursIds[hourSelectedIndex]
            guard let deliveryDate = deliverySlotsViewModel.deliveryDate(weekdayId: weekdayId, hourId: hourId)
                else { return }
            CartService.localCart = CartService.localCart?.copyWith(deliveryDate: deliveryDate)
            deliverySlotVariable.value = "\(deliverySlotsViewModel.weekdayNameWith(weekdayId: weekdayId))"
                + " at \(deliverySlotsViewModel.hoursRangeWith(hourId: hourId, weekdayId: weekdayId))"
        }
    }

    // MARK: - StatefulViewController related methods

    override func onResultsState() {
        deliverySlotsViewModel.deliverySlots = deliverySlotsViewModel.result
        weekdayPicker.reloadAllComponents()
        hoursIds = deliverySlotsViewModel.listOfHoursIdsFor(selectedIndex: weekdaySelectedIndex)
        hourPicker.reloadAllComponents()
    }

    // MARK: - Actions

    @IBAction func dismissAction(_ sender: Any) {
        guard deliverySlotVariable.value != nil
            else {
                presentAlertWith(title: "WARNING", message: "Please pick a delivery slot")
                return
            }
        NavigationService.dismissDeliverySlotsController()
    }

}
