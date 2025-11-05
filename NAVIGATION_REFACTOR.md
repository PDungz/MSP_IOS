# 🧭 Navigation Refactor - Simplified Navigation System

## 📅 Ngày: 05/11/2025

---

## ✨ Tổng Quan

Đã tạo **centralized navigation system** giống Flutter go_router, đơn giản hóa navigation trong SwiftUI.

### So Sánh Before/After:

#### ❌ BEFORE - Quá phức tạp:
```swift
// Phải tạo nhiều objects
let router = Router()
let appState = AppState()
let coordinator = HomeCoordinator(router: router, appState: appState)

// Phải truyền coordinator vào mọi view
HomeView(coordinator: coordinator, appState: appState)

// Navigate phức tạp
coordinator.navigateToDetail(id: "123")
```

#### ✅ AFTER - Đơn giản như Flutter:
```swift
// Navigate anywhere chỉ với 1 dòng
AppNavigation.push(.home)
AppNavigation.push(.userDetail(userId: "123"))

// Pop back
AppNavigation.pop()
AppNavigation.popToRoot()

// Replace
AppNavigation.replace(with: .login)
```

---

## 📁 Cấu Trúc Files

```
Core/Navigation/
├── AppRoute.swift              // Enum define tất cả routes
├── AppRouter.swift             // Singleton quản lý NavigationPath
├── AppNavigation.swift         // Static helper methods
└── RootNavigationView.swift    // Root navigation container
```

### Giải thích từng file:

#### 1. **AppRoute.swift** - Route Definitions
```swift
enum AppRoute: Hashable {
    case login
    case home
    case userDetail(userId: String)
    case foodDetail(foodId: String)
    // ... all routes
}
```
- Tương tự: `DpAppRouter` trong Flutter
- Define tất cả routes trong app
- Support associated values (parameters)
- Hashable để dùng với NavigationPath

#### 2. **AppRouter.swift** - Navigation Manager
```swift
class AppRouter: ObservableObject {
    static let shared = AppRouter()
    @Published var path = NavigationPath()

    func push(_ route: AppRoute)
    func pop()
    func popToRoot()
    func replace(with route: AppRoute)
}
```
- Singleton quản lý navigation state
- ObservableObject để SwiftUI auto-update
- Quản lý NavigationPath

#### 3. **AppNavigation.swift** - Convenience Helper
```swift
struct AppNavigation {
    static func push(_ route: AppRoute)
    static func pop()
    static func popToRoot()

    // Convenience methods
    static func navigateToLogin()
    static func navigateToHome()
    static func navigateToUserDetail(userId: String)
    // ...
}
```
- Tương tự: `DpAppNavigation` trong Flutter
- Static methods để dễ gọi
- Không cần context hay dependency injection

#### 4. **RootNavigationView.swift** - Navigation Container
```swift
struct RootNavigationView: View {
    @StateObject private var router = AppRouter.shared

    var body: some View {
        NavigationStack(path: $router.path) {
            // Destination resolver
            destinationView(for: initialRoute)
                .navigationDestination(for: AppRoute.self) { route in
                    destinationView(for: route)
                }
        }
    }
}
```
- Setup NavigationStack với AppRouter
- Resolve routes thành Views
- Tương tự: MaterialApp với GoRouter trong Flutter

---

## 🚀 Usage Examples

### Basic Navigation

```swift
// Push new screen
AppNavigation.push(.home)

// Push với parameters
AppNavigation.push(.userDetail(userId: "123"))
AppNavigation.push(.foodDetail(foodId: "456"))

// Pop back
AppNavigation.pop()

// Pop to root
AppNavigation.popToRoot()

// Replace current screen
AppNavigation.replace(with: .login)
```

### Common Flows

```swift
// Login success → Home
AppNavigation.navigateToHome()  // Clear stack + navigate

// Logout
AppNavigation.navigateToLogin()  // Clear stack + navigate

// View detail
AppNavigation.navigateToUserDetail(userId: "123")

// Go to settings
AppNavigation.navigateToSettings()
```

### In Buttons

```swift
Button("Go to Home") {
    AppNavigation.push(.home)
}

Button("View Detail") {
    AppNavigation.navigateToUserDetail(userId: viewModel.userId)
}

Button("Back") {
    AppNavigation.pop()
}

Button("Logout") {
    // Clear tokens
    authService.logout()

    // Navigate to login
    AppNavigation.navigateToLogin()
}
```

### In ViewModels

```swift
class HomeViewModel: ObservableObject {
    func onUserTapped(userId: String) {
        // Fetch data...

        // Navigate
        AppNavigation.navigateToUserDetail(userId: userId)
    }

    func onLogout() {
        // Clear auth
        NetworkManager.shared.clearTokens()

        // Navigate
        AppNavigation.navigateToLogin()
    }
}
```

---

## 🔧 Setup trong App

### App Entry Point

```swift
import SwiftUI

@main
struct MSP_IOSApp: App {
    var body: some Scene {
        WindowGroup {
            // ✅ Sử dụng RootNavigationView
            RootNavigationView(initialRoute: .login)
        }
    }
}
```

### Replace Existing Views

```swift
// ❌ BEFORE - Phức tạp
struct ContentView: View {
    let router = Router()
    let appState = AppState()
    let coordinator = HomeCoordinator(router: router, appState: appState)

    var body: some View {
        HomeView(coordinator: coordinator, appState: appState)
    }
}

// ✅ AFTER - Đơn giản
struct ContentView: View {
    var body: some View {
        RootNavigationView(initialRoute: .home)
    }
}
```

---

## 📝 Thêm Route Mới

### 1. Thêm case vào AppRoute enum:

```swift
// AppRoute.swift
enum AppRoute: Hashable {
    // ... existing routes

    // NEW: Payment routes
    case paymentMethod
    case paymentConfirm(amount: Double)
    case paymentSuccess
}
```

### 2. Update destination resolver:

```swift
// RootNavigationView.swift
@ViewBuilder
private func destinationView(for route: AppRoute) -> some View {
    switch route {
    // ... existing cases

    // NEW: Payment routes
    case .paymentMethod:
        PaymentMethodView()

    case .paymentConfirm(let amount):
        PaymentConfirmView(amount: amount)

    case .paymentSuccess:
        PaymentSuccessView()
    }
}
```

### 3. (Optional) Thêm convenience method:

```swift
// AppNavigation.swift
extension AppNavigation {
    static func navigateToPaymentMethod() {
        push(.paymentMethod)
    }

    static func navigateToPaymentConfirm(amount: Double) {
        push(.paymentConfirm(amount: amount))
    }

    static func navigateToPaymentSuccess() {
        push(.paymentSuccess)
    }
}
```

### 4. Sử dụng:

```swift
Button("Pay Now") {
    AppNavigation.navigateToPaymentConfirm(amount: 100.50)
}
```

---

## 🎯 Advantages

### 1. **Simple & Clean**
```swift
// ✅ Flutter-style navigation
AppNavigation.push(.home)
AppNavigation.pop()

// ❌ Không cần coordinator pattern phức tạp
// ❌ Không cần dependency injection
// ❌ Không cần truyền router vào mọi view
```

### 2. **Type-Safe**
```swift
// ✅ Compile-time checking
AppNavigation.push(.userDetail(userId: "123"))  // OK
AppNavigation.push(.userDetail())  // ❌ Compile error

// ❌ Không còn string-based routes dễ typo
```

### 3. **Centralized**
```swift
// ✅ Tất cả routes ở một nơi (AppRoute enum)
// ✅ Easy to see all available screens
// ✅ Easy to refactor
```

### 4. **Parameter Passing**
```swift
// ✅ Type-safe parameters
AppNavigation.push(.userDetail(userId: "123"))
AppNavigation.push(.foodDetail(foodId: "456"))
AppNavigation.push(.paymentConfirm(amount: 100.50))

// Parameters được pass thông qua associated values
```

### 5. **No Context Required**
```swift
// ✅ Navigate từ anywhere
// - ViewModel
// - Service layer
// - Button action
// - Async callback

// ❌ Không cần NavigationLink
// ❌ Không cần @EnvironmentObject
```

### 6. **Observable**
```swift
// ✅ AppRouter là ObservableObject
// ✅ UI tự động update khi navigation thay đổi
// ✅ SwiftUI reactivity
```

---

## 🆚 So Sánh với Flutter go_router

| Feature | Flutter (go_router) | SwiftUI (Our Implementation) |
|---------|---------------------|------------------------------|
| **Route Definition** | String paths | Enum cases |
| **Navigation** | `context.push()` | `AppNavigation.push()` |
| **Pop** | `context.pop()` | `AppNavigation.pop()` |
| **Parameters** | `extra` argument | Associated values |
| **Type Safety** | ❌ Runtime | ✅ Compile-time |
| **Context Required** | ✅ Yes | ❌ No |
| **Setup Complexity** | Medium | Low |

---

## 🔄 Migration Guide

### Step 1: Remove Old Navigation Files
```bash
# Xóa các files coordinator cũ (nếu có)
rm -rf Core/Navigation/Coordinator/
rm -rf Core/Navigation/Router/
```

### Step 2: Update App Entry
```swift
// Trong App.swift hoặc SceneDelegate
@main
struct MSP_IOSApp: App {
    var body: some Scene {
        WindowGroup {
            RootNavigationView(initialRoute: .login)  // ← Update this
        }
    }
}
```

### Step 3: Update Existing Views
```swift
// ❌ Remove old navigation code
// - coordinator parameters
// - router parameters
// - NavigationLink with destinations

// ✅ Replace with AppNavigation
Button("Go to Detail") {
    AppNavigation.push(.userDetail(userId: id))
}
```

### Step 4: Map Existing Screens to Routes
```swift
// 1. Add cases to AppRoute enum
// 2. Implement destination in RootNavigationView
// 3. Add convenience methods in AppNavigation (optional)
```

---

## 🎨 Best Practices

### 1. Use Enum for Routes
```swift
// ✅ GOOD - Type-safe
AppNavigation.push(.userDetail(userId: "123"))

// ❌ BAD - String-based (error-prone)
navigator.navigate(to: "/user/detail/123")
```

### 2. Use Convenience Methods
```swift
// ✅ GOOD - Descriptive
AppNavigation.navigateToUserDetail(userId: "123")

// ⚠️ OK - But less readable
AppNavigation.push(.userDetail(userId: "123"))
```

### 3. Clear Stack When Needed
```swift
// ✅ GOOD - Clear stack on logout
AppNavigation.navigateToLogin()  // Internal: reset() + replace()

// ❌ BAD - Stack không được clear
AppNavigation.push(.login)  // User có thể back về screens cũ
```

### 4. Group Related Routes
```swift
enum AppRoute: Hashable {
    // MARK: - Auth
    case login
    case register

    // MARK: - User Management
    case userList
    case userDetail(userId: String)

    // MARK: - Orders
    case orderList
    case orderDetail(orderId: String)
}
```

---

## 🐛 Troubleshooting

### Problem 1: Navigation không hoạt động
**Solution:** Ensure RootNavigationView được sử dụng ở root level
```swift
@main
struct MSP_IOSApp: App {
    var body: some Scene {
        WindowGroup {
            RootNavigationView(initialRoute: .login)  // ← Must be root
        }
    }
}
```

### Problem 2: View không update sau navigate
**Solution:** Ensure AppRouter là ObservableObject và được inject vào environment
```swift
NavigationStack(path: $router.path) {  // ← Binding to router.path
    // ...
}
.environmentObject(router)  // ← Inject to environment
```

### Problem 3: Parameters không được pass
**Solution:** Check associated values trong enum
```swift
// ✅ CORRECT
case userDetail(userId: String)

// ❌ WRONG
case userDetail  // No parameters
```

---

## 📚 References

- [SwiftUI NavigationStack Documentation](https://developer.apple.com/documentation/swiftui/navigationstack)
- [NavigationPath Documentation](https://developer.apple.com/documentation/swiftui/navigationpath)
- [Flutter go_router Package](https://pub.dev/packages/go_router)

---

## ✅ Summary

### Changes:
1. ✅ Created AppRoute enum - All routes in one place
2. ✅ Created AppRouter singleton - Navigation state management
3. ✅ Created AppNavigation helper - Flutter-style static methods
4. ✅ Created RootNavigationView - Navigation container setup

### Benefits:
- 🚀 **Simple** - One-line navigation
- 🎯 **Type-safe** - Compile-time checking
- 🧹 **Clean** - No boilerplate code
- 📱 **Flutter-like** - Familiar API
- 🔧 **Maintainable** - Easy to extend

### Usage:
```swift
// Navigate
AppNavigation.push(.home)
AppNavigation.push(.userDetail(userId: "123"))

// Pop
AppNavigation.pop()

// Clear & Navigate
AppNavigation.navigateToLogin()
```

**Giờ đây navigation trong SwiftUI đơn giản như Flutter! 🎉**
