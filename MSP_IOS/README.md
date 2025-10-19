//
//  README.md
//  MSP_IOS
//
//  Created by Phùng Văn Dũng on 17/10/25.
//

## ✅ Cấu trúc đề xuất mới:

```
MSP_IOS/
│
├── 📱 App/
│   ├── MSP_IOSApp.swift                 # Entry point (@main)
│   ├── AppState.swift                   # Global state
│   └── RootView.swift                   # Root view với routing
│
├── 🧩 Core/
│   │
│   ├── Components/                      # ✨ THÊM MỚI
│   │   ├── Base/
│   │   │   └── BaseView.swift
│   │   ├── Buttons/
│   │   │   ├── PrimaryButton.swift
│   │   │   └── SecondaryButton.swift
│   │   ├── TextFields/
│   │   │   ├── CustomTextField.swift
│   │   │   └── SecureTextField.swift
│   │   ├── Loading/
│   │   │   └── LoadingView.swift
│   │   ├── Error/
│   │   │   └── ErrorView.swift
│   │   └── Cards/
│   │       └── CardView.swift
│   │
│   ├── Navigation/                      # ✨ THÊM MỚI
│   │   ├── Router.swift
│   │   ├── Route.swift
│   │   ├── Coordinator.swift
│   │   ├── BaseCoordinator.swift
│   │   └── NavigationFactory.swift
│   │
│   ├── Extensions/                      # ✨ THÊM MỚI
│   │   ├── View+Extensions.swift
│   │   ├── Color+Extensions.swift
│   │   ├── Font+Extensions.swift
│   │   └── String+Extensions.swift
│   │
│   ├── Utilities/                       # ✨ THÊM MỚI
│   │   ├── Constants.swift
│   │   ├── Logger.swift
│   │   ├── Validator.swift
│   │   └── KeychainManager.swift
│   │
│   ├── Styles/                          # ✨ THÊM MỚI
│   │   ├── Theme.swift
│   │   ├── Colors.swift
│   │   └── Fonts.swift
│   │
│   └── Modifiers/                       # ✨ THÊM MỚI
│       ├── LoadingModifier.swift
│       └── ErrorModifier.swift
│
├── 🎨 Feature/
│   │
│   ├── Auth/
│   │   ├── Models/                      # ✨ THÊM MỚI
│   │   │   ├── User.swift
│   │   │   ├── AuthRequest.swift
│   │   │   └── AuthResponse.swift
│   │   │
│   │   ├── Services/                    # ✨ THÊM MỚI
│   │   │   ├── AuthService.swift
│   │   │   ├── AuthRepository.swift
│   │   │   └── AuthAPI.swift
│   │   │
│   │   └── Presentation/
│   │       ├── AuthRoute.swift          # ✨ THÊM MỚI
│   │       ├── AuthCoordinator.swift    # ✨ THÊM MỚI
│   │       │
│   │       ├── ViewModels/
│   │       │   ├── LoginViewModel.swift
│   │       │   ├── RegisterViewModel.swift
│   │       │   └── ForgotPasswordViewModel.swift
│   │       │
│   │       └── Views/
│   │           ├── LoginView.swift
│   │           ├── RegisterView.swift
│   │           └── ForgotPasswordView.swift
│   │
│   ├── Home/
│   │   ├── Models/                      # ✨ THÊM MỚI
│   │   │   ├── HomeItem.swift
│   │   │   ├── Category.swift
│   │   │   └── Banner.swift
│   │   │
│   │   ├── Services/                    # ✨ THÊM MỚI
│   │   │   ├── HomeService.swift
│   │   │   ├── HomeRepository.swift
│   │   │   └── HomeAPI.swift
│   │   │
│   │   └── Presentation/
│   │       ├── HomeRoute.swift          # ✨ THÊM MỚI
│   │       ├── HomeCoordinator.swift    # ✨ THÊM MỚI
│   │       │
│   │       ├── ViewModels/
│   │       │   ├── HomeViewModel.swift
│   │       │   └── DetailViewModel.swift
│   │       │
│   │       └── Views/
│   │           ├── HomeView.swift
│   │           ├── DetailView.swift
│   │           └── Components/
│   │               ├── HomeHeaderView.swift
│   │               └── ItemCardView.swift
│   │
│   └── Cart/
│       ├── Models/                      # ✨ THÊM MỚI
│       │   ├── CartItem.swift
│       │   └── Cart.swift
│       │
│       ├── Services/                    # ✨ THÊM MỚI
│       │   ├── CartService.swift
│       │   └── CartRepository.swift
│       │
│       └── Presentation/
│           ├── CartRoute.swift          # ✨ THÊM MỚI
│           ├── CartCoordinator.swift    # ✨ THÊM MỚI
│           │
│           ├── ViewModels/
│           │   └── CartViewModel.swift
│           │
│           └── Views/
│               └── CartView.swift
│
├── 🌐 Network/                          # ✨ THÊM MỚI
│   ├── Base/
│   │   ├── APIClient.swift
│   │   ├── APIEndpoint.swift
│   │   ├── HTTPMethod.swift
│   │   └── NetworkError.swift
│   │
│   └── Interceptors/
│       ├── AuthInterceptor.swift
│       └── LoggingInterceptor.swift
│
├── 💾 Storage/                          # ✨ THÊM MỚI
│   ├── UserDefaults/
│   │   ├── UserDefaultsKeys.swift
│   │   └── UserDefaultsManager.swift
│   │
│   └── Keychain/
│       ├── KeychainKeys.swift
│       └── KeychainManager.swift
│
├── 📦 Resources/
│   ├── Assets.xcassets                  # ✅ GIỮ NGUYÊN
│   │   ├── AppIcon.appiconset
│   │   ├── Colors/
│   │   └── Images/
│   │
│   ├── Fonts/                           # ✨ THÊM MỚI
│   │   └── (Custom fonts)
│   │
│   └── Localizations/                   # ✨ THÊM MỚI
│       └── Localizable.strings
│
├── 🧪 MSP_IOSTests/                     # ✅ GIỮ NGUYÊN
│   ├── Features/
│   │   ├── Auth/
│   │   │   ├── LoginViewModelTests.swift
│   │   │   └── AuthServiceTests.swift
│   │   ├── Home/
│   │   │   └── HomeViewModelTests.swift
│   │   └── Cart/
│   │       └── CartViewModelTests.swift
│   │
│   ├── Core/
│   │   └── Navigation/
│   │       └── RouterTests.swift
│   │
│   └── Mocks/
│       ├── MockAuthService.swift
│       └── MockAPIClient.swift
│
├── 🧪 MSP_IOSUITests/                   # ✅ GIỮ NGUYÊN
│   ├── AuthFlowTests.swift
│   ├── HomeFlowTests.swift
│   └── CartFlowTests.swift
│
└── 📄 Supporting Files/
    ├── Info.plist
    └── MSP_IOS.entitlements
```
