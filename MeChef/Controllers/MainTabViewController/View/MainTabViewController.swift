import UIKit
import RxSwift

class MainTabViewController: UITabBarController {

    private let disposeBag = DisposeBag()
    var viewModel: MainTabViewModel!

    var basketViewFrame: CGRect {
        let xCoord = (tabBar.frame.width / 3) * 2
        return CGRect(x: xCoord, y: self.view.frame.height - 75,
                      width: tabBar.frame.width / 3, height: 50)
    }

    init() {
        self.viewModel = MainTabViewModel()

        super.init(nibName: MainTabViewController.xibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.getCustomerEphemeralKey()
        viewModel.customizeStripeUI()
        configureTabBar()

    }

    func configureTabBar() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.darkGrayColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:
            UIColor.mainOrangeColor], for: .selected)
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().backgroundColor = .white

        if !SessionService.isChef {
            let chefsController = NavigationService.chefsTab()
            let dishesController = NavigationService.dishesTab()
            let cartController = NavigationService.cartTab()

            viewControllers = [ chefsController, dishesController, cartController ]

            CartService.localCartDriver.drive(onNext: { localCart in
                let cartController = self.viewControllers?[2]
                let totalInCart = localCart?.total ?? 0.00
                cartController?.tabBarItem.title = totalInCart.stringWithCurrency
                self.setBadgeValue(localCart?.dishes?.count ?? 0)
            }).disposed(by: disposeBag)

        } else if let chefId = SessionService.session?.chef?.id {
            let chefWeekplanController = NavigationService.chefWeekplanTab(chefId: chefId)
            let chefDishesController = NavigationService.chefDishesTab(chefId: chefId)

            viewControllers = [ chefWeekplanController, chefDishesController ]
        }
    }

    func setBadgeValue(_ value: Int = 0) {
        for view in self.tabBar.subviews {
            if let badgeView = view as? PGTabBadge {
                badgeView.removeFromSuperview()
            }
        }
        addBadge(value: value)
    }

    func addBadge(value: Int) {
        let itemPosition = CGFloat(3)
        let itemWidth: CGFloat = tabBar.frame.width / 3
        let xOffset: CGFloat = 20
        let yOffset: CGFloat = 0
        let badgeView = PGTabBadge()
        badgeView.frame.size = CGSize(width: 17, height: 17)
        badgeView.center = CGPoint(x: (itemWidth * itemPosition) - (itemWidth/2) + xOffset,
                                   y: 20 + yOffset)
        badgeView.layer.cornerRadius = badgeView.bounds.width/2
        badgeView.clipsToBounds = true
        badgeView.textColor = .white
        badgeView.textAlignment = .center
        badgeView.font = .boldFontOf(size: 11)
        badgeView.text = "\(value)"
        badgeView.backgroundColor = .mainOrangeColor
        badgeView.tag = 3
        tabBar.addSubview(badgeView)
        tabBar.bringSubviewToFront(badgeView)
    }

}

class PGTabBadge: UILabel {}
