# Toqueat

Toqueat is an iOS client for a food delivery marketplace that connects users with local chefs.  
Users can browse chefs and dishes, build a cart, schedule a delivery slot, and pay securely via Stripe.

The app is built with a production-style architecture (UIKit + MVVM + RxSwift) and integrates multiple third-party SDKs for networking, reactive bindings, image loading, payments, and more.

---

## 👨‍💻 My Role

I was responsible for the full iOS client development and a large part of the platform architecture:

- Designed the overall navigation and UX for the mobile app  
- Implemented the iOS application from scratch using UIKit
- Defined the networking layer and API models (generated from JSON → Swift)
- Integrated Stripe for payments and Stuart for delivery tracking
- Implemented reactive bindings with RxSwift / RxCocoa
- Set up the project structure, CocoaPods dependencies, and build configuration
- Designed and implemented the backend database and API in Ruby for this platform (can be found [here](https://github.com/Cawa94/Toqueat-database))

---

## 🧰 Tech Stack

### Mobile (iOS)

- **Language:** Swift  
- **UI Framework:** UIKit  
- **Minimum iOS version:** iOS 11.0
- **Dependency management:** CocoaPods
- **Architecture:**
  - MVVM with reactive bindings (RxSwift / RxCocoa)
  - Service layer for networking and business logic
  - Separate models layer for API entities (ObjectMapper-based)

---

## 🧱 Architecture

The client is structured as a modular UIKit app with clear separation of concerns:

- **Presentation layer (UIKit + MVVM):**
  - View controllers responsible for UI, navigation, and rendering
  - ViewModels handle state, business rules, and expose reactive streams (RxSwift) to the UI
- **Networking & data layer:**
  - API client built on top of Alamofire / RxAlamofire
  - JSON models defined in Swift and mapped with ObjectMapper
  - Generated model layer from JSON definitions using a JAR-based API generator
- **Domain layer:**
  - Entities for chefs, dishes, orders, delivery slots, addresses, etc.
  - Stripe payment integration (payment intents) and Stuart delivery integration for courier tracking (driver location, ETA, delivery state)

---

## ✨ Features (Client-Side)

> Some features depend on backend configuration and keys, so the app may not fully run out-of-the-box without environment setup.

- **Chef & dishes browsing**
  - List of available chefs with profile information
  - Dishes with pricing, images, categories, and availability

- **Cart & ordering**
  - Add/remove dishes to a local cart
  - Choose delivery date and time slot
  - Send orders to the backend with all necessary parameters (dishes, quantities, address, delivery slot, payment method)

- **Address management**
  - Create and update user addresses
  - City selection, street, apartment/floor, and other fields mapped to backend models

- **Delivery slots**
  - Fetch available delivery slots for a given date/chef
  - Take into account busy or blocked slots returned by the backend

- **Payments**
  - Stripe integration for payment methods and payment intents
  - Proper mapping of Stripe-related fields inside order creation flows

- **Delivery tracking**
  - Stuart integration for delivery jobs, driver information, ETA, and tracking URL
  - Mapping of Stuart objects (addresses, locations, jobs, deliveries, cancellations, etc.)

- **Error handling**
  - Typed error models for server and third-party services (e.g. `ServerError`, `StuartError`)
  - Separation of success and error responses for cleaner handling in the UI

---

## 🧩 Backend & Database

Alongside the iOS client, I also:

- Designed the **database schema** for the platform (chefs, dishes, orders, delivery slots, users, etc.)
- Implemented the backend in **Ruby** (REST API consumed by this iOS app)
- Kept the API contracts in sync with the iOS models using JSON → Swift generation

You can find the Ruby backend repository [here](https://github.com/Cawa94/Toqueat-database)

---

## 🧠 Notable Technical Aspects

Even if the project is old and may not compile without some configuration, it showcases:

- A **reactive MVVM architecture** built on top of **UIKit** and **RxSwift**
- A rich **networking layer** with:
  - **Alamofire** + **RxAlamofire**
  - **ObjectMapper** models
  - Generated Swift models from JSON definitions aligned with a **Ruby backend**
- Integration with **real-world services**:
  - **Stripe** for payments
  - **Stuart** for delivery & courier tracking
- Use of **modularization via Git submodules** for shared code
- A non-trivial **domain** (chefs, dishes, orders, delivery slots, deliveries, addresses, users, etc.) modeled end-to-end across client and server

---

## 🔗 Contact

Yuri Cavallin — Senior iOS Developer

Email: [yuricavallin.developer@gmail.com]

LinkedIn: [https://www.linkedin.com/in/yuri-cavallin/]
