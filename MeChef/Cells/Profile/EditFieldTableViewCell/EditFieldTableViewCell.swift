import UIKit

final class EditFieldTableViewCell: UITableViewCell {

    @IBOutlet private weak var contentContainerViewOutlet: UIView!
    @IBOutlet private weak var placeholderContainerViewOutlet: UIView!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var bottomSpacerView: UIView!

    private var viewModel: EditFieldTableViewModel?
    private let pickerView = UIPickerView()

    public var cellTextField: UITextField {
        return textField
    }

}

extension EditFieldTableViewCell: PlaceholderConfigurable {

    typealias ContentViewModelType = EditFieldTableViewModel
    typealias PlaceholderViewModelType = Void

    var contentContainerView: UIView {
        return contentContainerViewOutlet
    }

    var placeholderContainerView: UIView {
        return placeholderContainerViewOutlet
    }

    func configureWith(loading: Bool = false, contentViewModel: EditFieldTableViewModel? = nil) {
        if loading {
            configureContentLoading(with: .placeholder)
        } else if let contentViewModel = contentViewModel {
            configureContentLoading(with: .content(contentViewModel: contentViewModel))
        }
    }

    func configure(contentViewModel: EditFieldTableViewModel) {
        self.viewModel = contentViewModel

        textField.text = contentViewModel.fieldValue
        textField.placeholder = contentViewModel.placeholder
        textField.autocapitalizationType = contentViewModel.fieldCapitalized ? .words : .none
        bottomSpacerView.isHidden = contentViewModel.hideBottomLine

        textField.inputView = contentViewModel.pickerValues.isNotEmpty ? pickerView : nil
        pickerView.delegate = self
    }

}

extension EditFieldTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.pickerValues.count ?? 0
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.pickerValues[row] ?? ""
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = viewModel?.pickerValues[row]
    }

}
