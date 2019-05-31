import Foundation
import LeadKit

// swiftlint:disable superfluous_disable_command
// swiftlint:disable line_length
// swiftlint:disable file_length
// swiftlint:disable identifier_name

extension String {
	/// City
	static func addressCity() -> String { return "address_city".localized() }

	/// Door
	static func addressDoor() -> String { return "address_door".localized() }

	/// Floor
	static func addressFloor() -> String { return "address_floor".localized() }

	/// Number
	static func addressNumber() -> String { return "address_number".localized() }

	/// Street
	static func addressStreet() -> String { return "address_street".localized() }

	/// Zipcode
	static func addressZipcode() -> String { return "address_zipcode".localized() }

	/// Already registered
	static func authAlreadyRegistered() -> String { return "auth_already_registered".localized() }

	/// Are you a chef?
	static func authAreChef() -> String { return "auth_are_chef".localized() }

	/// If you would like to be a chef, please write an email at toqueat@gmail.com
	static func authHowBecomeChef() -> String { return "auth_how_become_chef".localized() }

	/// Log in
	static func authLogin() -> String { return "auth_login".localized() }

	/// Log in as chef
	static func authLoginAsChef() -> String { return "auth_login_as_chef".localized() }

	/// I am not a chef
	static func authNotChef() -> String { return "auth_not_chef".localized() }

	/// Register
	static func authRegister() -> String { return "auth_register".localized() }

	/// is gonna cook this dishes for you!
	static func cartChefWillCook() -> String { return "cart_chef_will_cook".localized() }

	/// Choose delivery time
	static func cartChooseDeliveryTime() -> String { return "cart_choose_delivery_time".localized() }

	/// Your cart is empty. Just choose the perfect dishes you would like to taste
	static func cartEmptyText() -> String { return "cart_empty_text".localized() }

	/// Complete order
	static func checkoutCompleteOrder() -> String { return "checkout_complete_order".localized() }

	/// Pay with
	static func checkoutPayWith() -> String { return "checkout_pay_with".localized() }

	/// Checkout
	static func checkoutTitle() -> String { return "checkout_title".localized() }

	/// Order placed! You'll receive a notification when driver will be coming at you
	static func checkoutCompleted() -> String { return "checkout_completed".localized() }

	/// Add dish
	static func chefAddDish() -> String { return "chef_add_dish".localized() }

	/// Chef availability
	static func chefAvailability() -> String { return "chef_availability".localized() }

	/// Here you can let people know when you're available to deliver. Tap a slot to enable/disable it
	static func chefAvailabilityEditExplanation() -> String { return "chef_availability_edit_explanation".localized() }

	/// The chef will be available to deliver dishes only during this hours
	static func chefAvailabilityExplanation() -> String { return "chef_availability_explanation".localized() }

	/// Slots updated
	static func chefAvailabilitySlotsUpdated() -> String { return "chef_availability_slots_updated".localized() }

	/// Available
	static func chefAvailable() -> String { return "chef_available".localized() }

	/// Busy
	static func chefBusy() -> String { return "chef_busy".localized() }

	/// Check availability
	static func chefCheckAvailability() -> String { return "chef_check_availability".localized() }

	/// Activate your account
	static func chefActivateAccount() -> String { return "chef_activate_account".localized() }

	/// Disable your account
	static func chefDisableAccount() -> String { return "chef_disable_account".localized() }

	/// Instagram username
	static func chefInstagramUsername() -> String { return "chef_instagram_username".localized() }

	/// You're available now
	static func chefAccountActivated() -> String { return "chef_account_activated".localized() }

	/// You're no longer available
	static func chefAccountDisabled() -> String { return "chef_account_disabled".localized() }

	/// My dishes
	static func chefMyDishes() -> String { return "chef_my_dishes".localized() }

	/// Unavailable
	static func chefUnavailable() -> String { return "chef_unavailable".localized() }

	/// My Weekplan
	static func chefWeekplan() -> String { return "chef_weekplan".localized() }

	/// Between
	static func commonBetween() -> String { return "common_between".localized() }

	/// Cart
	static func commonCart() -> String { return "common_cart".localized() }

	/// Chef
	static func commonChef() -> String { return "common_chef".localized() }

	/// Chefs
	static func commonChefs() -> String { return "common_chefs".localized() }

	/// Delivery
	static func commonDelivery() -> String { return "common_delivery".localized() }

	/// Delivery date
	static func commonDeliveryDate() -> String { return "common_delivery_date".localized() }

	/// Dish
	static func commonDish() -> String { return "common_dish".localized() }

	/// Dishes
	static func commonDishes() -> String { return "common_dishes".localized() }

	/// Done
	static func commonDone() -> String { return "common_done".localized() }

	/// Edit
	static func commonEdit() -> String { return "common_edit".localized() }

	/// Optional
	static func commonOptional() -> String { return "common_optional".localized() }

	/// Profile
	static func commonProfile() -> String { return "common_profile".localized() }

	/// Save
	static func commonSave() -> String { return "common_save".localized() }

	/// Total
	static func commonTotal() -> String { return "common_total".localized() }

	/// Warning
	static func commonWarning() -> String { return "common_warning".localized() }

	/// Cancel
	static func commonCancel() -> String { return "common_cancel".localized() }

	/// Confirm
	static func commonConfirm() -> String { return "common_confirm".localized() }

	/// Ok
	static func commonOk() -> String { return "common_ok".localized() }

	/// Proceed to checkout
	static func deliveryDateProceedCheckout() -> String { return "delivery_date_proceed_checkout".localized() }

	/// You will receive your order
	static func deliveryDateWillReceive() -> String { return "delivery_date_will_receive".localized() }

	/// Add to basket
	static func dishAddToBasket() -> String { return "dish_add_to_basket".localized() }

	/// Ingredients
	static func dishIngredients() -> String { return "dish_ingredients".localized() }

	/// Prepared by
	static func dishPreparedBy() -> String { return "dish_prepared_by".localized() }

	/// servings
	static func dishServings() -> String { return "dish_servings".localized() }

	/// Description
	static func dishDescription() -> String { return "dish_description".localized() }

	/// Describe your dish...
	static func dishDescriptionPlaceholder() -> String { return "dish_description_placeholder".localized() }

	/// Max quantity for order
	static func dishMaxQuantity() -> String { return "dish_max_quantity".localized() }

	/// Price
	static func dishPrice() -> String { return "dish_price".localized() }

	/// Type
	static func dishType() -> String { return "dish_type".localized() }

	/// Desserts
	static func dishTypeDesserts() -> String { return "dish_type_desserts".localized() }

	/// Main courses
	static func dishTypeMainCourses() -> String { return "dish_type_main_courses".localized() }

	/// Salads
	static func dishTypeSalads() -> String { return "dish_type_salads".localized() }

	/// Second courses
	static func dishTypeSecondCourses() -> String { return "dish_type_second_courses".localized() }

	/// Single courses
	static func dishTypeSingleCourses() -> String { return "dish_type_single_courses".localized() }

	/// Snacks
	static func dishTypeSnacks() -> String { return "dish_type_snacks".localized() }

	/// Disable dish
	static func editDishDisable() -> String { return "edit_dish_disable".localized() }

	/// Dish disabled
	static func editDishDisabled() -> String { return "edit_dish_disabled".localized() }

	/// Enable dish
	static func editDishEnable() -> String { return "edit_dish_enable".localized() }

	/// Dish enabled
	static func editDishEnabled() -> String { return "edit_dish_enabled".localized() }

	/// New dish
	static func editDishNewTitle() -> String { return "edit_dish_new_title".localized() }

	/// Edit dish
	static func editDishTitle() -> String { return "edit_dish_title".localized() }

	/// Dish created
	static func editDishCreated() -> String { return "edit_dish_created".localized() }

	/// Dish updated
	static func editDishUpdated() -> String { return "edit_dish_updated".localized() }

	/// Something went wrong
	static func errorSomethingWentWrong() -> String { return "error_something_went_wrong".localized() }

	/// You're gonna lose all your products
	static func errorChangeCartChef() -> String { return "error_change_cart_chef".localized() }

	/// Search chef
	static func mainSearchChef() -> String { return "main_search_chef".localized() }

	/// Search dishes
	static func mainSearchDish() -> String { return "main_search_dish".localized() }

	/// Delivery to
	static func orderDetailsDeliveryTo() -> String { return "order_details_delivery_to".localized() }

	/// Order number
	static func orderDetailsOrderNumber() -> String { return "order_details_order_number".localized() }

	/// Order details
	static func orderDetailsTitle() -> String { return "order_details_title".localized() }

	/// Your dishes
	static func orderDetailsYourDishes() -> String { return "order_details_your_dishes".localized() }

	/// Costs
	static func orderDetailsCosts() -> String { return "order_details_costs".localized() }

	/// will be at your house
	static func orderDetailsDriverEta() -> String { return "order_details_driver_eta".localized() }

	/// will be at your house in a few minutes
	static func orderDetailsDriverEtaUndefined() -> String { return "order_details_driver_eta_undefined".localized() }

	/// Canceled
	static func ordersCanceled() -> String { return "orders_canceled".localized() }

	/// Delivered
	static func ordersDelivered() -> String { return "orders_delivered".localized() }

	/// En route
	static func ordersEnRoute() -> String { return "orders_en_route".localized() }

	/// Scheduled
	static func ordersScheduled() -> String { return "orders_scheduled".localized() }

	/// My orders
	static func ordersTitle() -> String { return "orders_title".localized() }

	/// Waiting for confirmation
	static func ordersWaitingForConfirmation() -> String { return "orders_waiting_for_confirmation".localized() }

	/// My address
	static func profileMyAddress() -> String { return "profile_my_address".localized() }

	/// Log out
	static func profileLogout() -> String { return "profile_logout".localized() }

	/// My availability
	static func profileMyAvilability() -> String { return "profile_my_avilability".localized() }

	/// My orders
	static func profileMyOrders() -> String { return "profile_my_orders".localized() }

	/// Personal details
	static func profilePersonalDetails() -> String { return "profile_personal_details".localized() }

	/// Stripe account associated
	static func profileStripeAssociated() -> String { return "profile_stripe_associated".localized() }

	/// Connect your Stripe account
	static func profileStripeMissing() -> String { return "profile_stripe_missing".localized() }

	/// Address updated
	static func profileAddressUpdated() -> String { return "profile_address_updated".localized() }

	/// Personal details updated
	static func profileUpdated() -> String { return "profile_updated".localized() }

	/// Write something about you...
	static func profileDescriptionPlaceholder() -> String { return "profile_description_placeholder".localized() }

	/// Stripe account connected
	static func profileStripeConnected() -> String { return "profile_stripe_connected".localized() }

	/// Confirm password
	static func userConfirmPassword() -> String { return "user_confirm_password".localized() }

	/// Email
	static func userEmail() -> String { return "user_email".localized() }

	/// Lastname
	static func userLastname() -> String { return "user_lastname".localized() }

	/// Password
	static func userPassword() -> String { return "user_password".localized() }

	/// Phone
	static func userPhone() -> String { return "user_phone".localized() }

	/// Name
	static func userName() -> String { return "user_name".localized() }

}
