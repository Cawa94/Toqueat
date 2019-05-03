import UIKit
import RxSwift
import Nuke

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
    var newImageData: Data?
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()

        avatarImageView.roundCorners(radii: 15.0)
        avatarImageView.isHidden = !viewModel.isChef
        avatarImageView.rx.tapGesture().when(.recognized).asDriver()
            .drive(onNext: { _ in
                self.pickImageAction()
            }).disposed(by: disposeBag)
        tableViewTopConstraint.constant = viewModel.isChef ? 300 : 10
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
        /*let newDeliverySlots = chefDeliverySlotsViewModel.activeSlots.map { $0.id }
        let updateSingle = NetworkService.shared.updateDeliverySlotsFor(chefId: chefDeliverySlotsViewModel.chefId,
                                                                        slots: newDeliverySlots)
        
        self.hudOperationWithSingle(operationSingle: updateSingle,
                                    onSuccessClosure: { _ in
                                        self.chefDeliverySlotsViewModel.reload()
                                        NavigationService.reloadChefOrders = true
                                        self.presentAlertWith(title: "YEAH",
                                                              message: "Slots updated")
        },
                                    disposeBag: self.disposeBag)*/
    }

    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
        let avatarHeight: CGFloat = viewModel.isChef ? 300 : 20
        contentViewHeightConstraint.constant = tableViewHeightConstraint.constant
            + avatarHeight // Content without table
    }

    func pickImageAction() {
        ImagePickerManager().pickImage(self) { image in
            self.didPick(image: image)
        }
    }

    func didPick(image: UIImage?) {
        guard let image = image, let fixedImage = rotateImage(image: image)
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
            case 1:
                cellViewModel = EditFieldTableViewModel(fieldValue: viewModel.lastname,
                                                        placeholder: "Lastname")
            case 2:
                cellViewModel = EditFieldTableViewModel(fieldValue: viewModel.phone,
                                                        placeholder: "Phone number")
            case 3:
                cellViewModel = viewModel.isChef
                    ? EditFieldTableViewModel(fieldValue: viewModel.chef?.instagramUrl,
                                              placeholder: "Instagram Url")
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
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = UITableViewCell()
        headerCell.backgroundColor = .lightGrayBackgroundColor
        return headerCell
    }

}
