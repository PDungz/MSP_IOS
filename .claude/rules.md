# MSP iOS Development Rules

## 🎯 TOKEN OPTIMIZATION - PRIORITY #1

### TOOL USAGE RULES

**FORBIDDEN ❌:**
- TodoWrite for simple tasks (< 3 steps)
- Multiple sequential tool calls that can be parallel
- Explaining before doing
- Asking confirmation when request is clear
- Using Bash for file operations (use Read/Glob/Grep/Edit/Write)
- Updating todo after each small step

**REQUIRED ✅:**
- Read file before Edit (mandatory)
- Parallel tool calls when independent
- Action first, explain after (if needed)
- TodoWrite ONLY for complex features (> 5 steps)
- Short responses

### WORKFLOW

**Simple task (fix, small change):**
```
Read → Edit/Write → Done
```

**Complex task (new feature):**
```
Read files (parallel) → Write all files (parallel) → Done
```

### RESPONSE STYLE

**Bad ❌:**
```
"Để tôi giúp bạn tách logic..."
"Tôi sẽ tạo todo list..."
"Bây giờ tôi sẽ đọc file..."
```

**Good ✅:**
```
"Đã tạo ViewModel + Models"
"Đã refactor View"
```

## 🏗️ ARCHITECTURE

```
Feature/
├── Model/              # Struct, Identifiable, Equatable
├── ViewModel/          # @MainActor, ObservableObject, all logic
└── Presentation/
    └── Views/          # UI only, no logic
        └── Components/ # Reusable
```

**Rules:**
- View: UI only, @StateObject/@ObservedObject
- ViewModel: All logic, @Published
- Model: Data only
- No logic in Views

## 📝 CODE STYLE

```swift
// View
struct XView: View {
    @StateObject private var vm = XViewModel()
    var body: some View { ... }
}

// ViewModel
@MainActor
class XViewModel: ObservableObject {
    @Published var state: State
    func action() async { ... }
}
```

## 📊 TOOL CALL BUDGET

| Task | Max Calls | Todo? |
|------|-----------|-------|
| Bug fix | 3 | No |
| Add function | 4 | No |
| New component | 5 | No |
| New feature | 10 | Yes |
| Major refactor | 15 | Yes |

## ✅ CHECKLIST

Before responding:
- [ ] Can combine tool calls?
- [ ] Really need todo?
- [ ] Can skip explanation?
- [ ] Using correct tools?

---

**REMEMBER: Less tools, less text, more code, parallel calls.**
