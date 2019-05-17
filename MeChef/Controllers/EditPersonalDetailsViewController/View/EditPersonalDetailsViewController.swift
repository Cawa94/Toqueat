import UIKit
import RxSwift
import Nuke
import SwiftValidator
import CropViewController

private extension CGFloat {
    static let maxAvatarDimension: CGFloat = 1_080
}

class EditPersonalDetailsViewController: UIViewController {

    @IBOutlet private weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var avatarImageView: UIImageView!

    var viewModel: EditPersonalDetailsViewModel!
    private var newImageData: Data?
    private let validator = Validator()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        avatarImageView.roundCorners(radii: avatarImageView.bounds.width/2)
        avatarImageView.isHidden = !viewModel.isChef
        avatarImageView.rx.tapGesture().when(.recognized).asDriver()
            .drive(onNext: { _ in
                self.pickImageAction()
            }).disposed(by: disposeBag)
        tableViewTopConstraint.constant = viewModel.isChef ? 200 : 10
        if let avatarUrl = viewModel.chef?.avatarLink {
            Nuke.loadImage(with: avatarUrl, into: avatarImageView)
            avatarImageView.contentMode = .scaleAspectFill
        }

        tableView.register(UINib(nibName: "EditFieldTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "EditFieldTableViewCell")
        tableView.register(UINib(nibName: "EditDescriptionTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "EditDescriptionTableViewCell")
    }

    func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .mainOrangeColor
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.darkGrayColor]
        navigationController?.isNavigationBarHidden = false
        title = "Personal Details"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ",
                                                           style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(updateDetails))
    }

    @objc func updateDetails() {
        validator.validate(self)
    }

    func updateChefDetails() {
        guard let chefId = viewModel.chef?.id,
            let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditFieldTableViewCell,
            let name = nameCell.cellTextField.text,
            let lastnameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditFieldTableViewCell,
            let lastname = lastnameCell.cellTextField.text,
            let phoneCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditFieldTableViewCell,
            let phone = phoneCell.cellTextField.text,
            let instagramCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? EditFieldTableViewCell,
            let descriptionCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0))
                as? EditDescriptionTableViewCell
            else { return }
        let instagramUsername = instagramCell.cellTextField.text
        let description = descriptionCell.hasContent ? descriptionCell.cellTextView.text : nil

        let chefParameters = ChefUpdateParameters(name: name, lastname: lastname,
                                                  phone: phone, instagramUsername: instagramUsername,
                                                  description: description)

        var operationSingle: Single<Void>
        let updateChefSingle = NetworkService.shared.updateChefWith(parameters: chefParameters,
                                                                    chefId: chefId)
            .map { _ in
                if let newImage = self.newImageData {
                    NetworkService.shared.uploadChefAvatar(for: chefId,
                                                           imageData: newImage,
                                                           completion: { _ in })
                }
        }
        operationSingle = updateChefSingle
        hudOperationWithSingle(operationSingle: operationSingle,
                               onSuccessClosure: { _ in
                                self.presentAlertWith(
                                    title: "YEAH", message: "Chef updated",
                                    actions: [ UIAlertAction(title: "Ok", style: .default,
                                                             handler: { _ in
                                                                NavigationService.reloadChefProfile = true
                                    })])
        }, disposeBag: disposeBag)
    }

    func updateUserDetails() {
        guard let userId = viewModel.user?.id,
            let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditFieldTableViewCell,
            let name = nameCell.cellTextField.text,
            let lastnameCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EditFieldTableViewCell,
            let lastname = lastnameCell.cellTextField.text,
            let phoneCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? EditFieldTableViewCell,
            let phone = phoneCell.cellTextField.text
            else { return }

        let userParameters = UserUpdateParameters(name: name, lastname: lastname, phone: phone)
        let updateUserSingle = NetworkService.shared.updateUserWith(parameters: userParameters,
                                                                    userId: userId)
        hudOperationWithSingle(operationSingle: updateUserSingle,
                               onSuccessClosure: { _ in
                                self.presentAlertWith(
                                    title: "YEAH", message: "User updated",
                                    actions: [ UIAlertAction(title: "Ok", style: .default,
                                                             handler: { _ in
                                                                NavigationService.reloadUserProfile = true
                                    })])
        }, disposeBag: disposeBag)
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        let avatarHeight: CGFloat = viewModel.isChef ? 270 : 20
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + avatarHeight // Content without table
    }

    func pickImageAction() {
        ImagePickerManager().pickImage(self) { image in
            self.didPick(image: image)
        }
    }

    func didPick(image: UIImage?) {
        guard let image = image
            else { return }

        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }

}

extension EditPersonalDetailsViewController: CropViewControllerDelegate {

    func cropViewController(_ cropViewController: CropViewController,
                            didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        guard let fixedImage = rotateImage(image: image)
            else { return }

        let imageSize = fixedImage.size
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        let maxSize = max(imageWidth, imageHeight)
        let ratio = maxSize / min(maxSize, .maxAvatarDimension)
        let newSize = CGSize(width: imageWidth / ratio, height: imageHeight / ratio)

        guard let newSizeImage = fixedImage.support.resize(newSize: newSize)?.base,
            let imageData = UIImage.jpegData(newSizeImage)(compressionQuality: 0.8)
            else { return }

        avatarImageView.image = newSizeImage
        newImageData = imageData

        NavigationService.dismissTopController()
    }

    func rotateImage(image: UIImage) -> UIImage? {
        if image.imageOrientation == UIImage.Orientation.up {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        guard let copy = UIGraphicsGetImageFromCurrentImageContext()
            else { return nil }
        UIGraphicsEndImageContext()
        return copy
    }

}

extension EditPersonalDetailsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isChef ? 5 : 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if viewModel.isChef {
            switch indexPath.row {
            case 4:
                cell = tableView.dequeueReusableCell(withIdentifier: "EditDescriptionTableViewCell",
                                                     for: indexPath)
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "EditFieldTableViewCell",
                                                     for: indexPath)
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "EditFieldTableViewCell",
                                                 for: indexPath)
        }
        configureWithContent(cell, at: indexPath)
        return cell
    }

    func configureWithContent(_ cell: UITableViewCell, at indexPath: IndexPath) {
        switch cell {
        case let editFieldCell as EditFieldTableViewCell:
            let cellViewModel: EditFieldTableViewModel
            switch indexPath.row {
            case 0:
                cellViewModel = EditFieldTableViewModel(fieldValue: viewModel.name,
                                                        placeholder: "Name")
                validator.registerField(editFieldCell.cellTextField, rules: [RequiredRule()])
            case 1:
                cellViewModel = EditFieldTableViewModel(fieldValue: viewModel.lastname,
                                                        placeholder: "Lastname")
                validator.registerField(editFieldCell.cellTextField, rules: [RequiredRule()])
            case 2:
                cellViewModel = EditFieldTableViewModel(fieldValue: viewModel.phone,
                                                        placeholder: "Phone number",
                                                        hideBottomLine: viewModel.isChef)
                validator.registerField(editFieldCell.cellTextField, rules: [RequiredRule()])
            case 3:
                cellViewModel = viewModel.isChef
                    ? EditFieldTableViewModel(fieldValue: viewModel.chef?.instagramUsername,
                                              placeholder: "Instagram username",
                                              fieldCapitalized: false)
                    : EditFieldTableViewModel(fieldValue: nil, placeholder: "")
            default:
                cellViewModel = EditFieldTableViewModel(fieldValue: nil, placeholder: "")
            }
            editFieldCell.configureWith(contentViewModel: cellViewModel)
        case let editDescriptionCell as EditDescriptionTableViewCell:
            let cellViewModel = EditDescriptionTableViewModel(fieldValue: viewModel.chef?.description,
                                                              placeholder: "Write something about you")
            editDescriptionCell.configure(contentViewModel: cellViewModel)
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isChef && indexPath.row == 4 ? UITableView.automaticDimension : 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.isChef ? 0 : 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = UITableViewCell()
        headerCell.backgroundColor = .lightGrayBackgroundColor
        return headerCell
    }

}

extension EditPersonalDetailsViewController: ValidationDelegate {

    func validationSuccessful() {
        if viewModel.isChef {
            updateChefDetails()
        } else {
            updateUserDetails()
        }
    }

    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        // turn the fields to red
        for (field, _) in errors {
            if let field = field as? UITextField {
                field.attributedPlaceholder = NSAttributedString(
                    string: field.placeholder ?? "",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            }
        }
    }

}
