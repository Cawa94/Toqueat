import UIKit

extension NavigationService {

    static func chefProfileViewController(chefId: Int64) -> ChefProfileViewController {
        let controller = ChefProfileViewController(nibName: ChefProfileViewController.xibName,
                                                   bundle: nil)
        let viewModel = ChefProfileViewModel(chefId: chefId)

        controller.chefProfileViewModel = viewModel
        return controller
    }

}
