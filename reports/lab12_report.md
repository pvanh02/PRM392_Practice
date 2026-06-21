# Lab 12 Report – Performance Optimization & Deployment

**Course:** PRM392 - Mobile Application Development (Flutter)  
**Lab Module:** Lab 12 — Performance Optimization & Deployment  
**Student Details:** SE123456 - Nguyen Van A  
**Status:** Completed & Optimized  

---

## 1. Exercise 12.1 – Optimize List Rebuilds in Taskly

### Objective
Reduce unnecessary widget redraws when items are added, checked, or deleted.

### Actions Taken
1. **Extracted `TaskTile` Widget:** Created a standalone widget class `TaskTile` in `lib/lab11/screens/task_tile.dart` with a `const` constructor. This isolates item building from the parent list.
2. **Integrated `Selector`:** Replaced the direct state listener of `TaskListScreen` with `Selector<TaskProvider, List<Task>>`. The screen now rebuilds only when items are added or removed from the list, while toggles are delegated to the specific child `TaskTile` widget.
3. **Assigned Keys:** Keyed list elements with `ValueKey(task.id)` to maintain item associations inside the widget tree, facilitating smooth list transitions and preventing invalid UI updates.

### Observations & Rebuild Analysis
- **Before Optimization:** Toggling a single task checkbox called `setState()` on `TaskListScreen`, rebuilding the entire list viewport containing $N$ widgets. Toggling a task cost $O(N)$ rebuilds.
- **After Optimization:** Toggling a task checkbox mutates its individual state. The parent `TaskListScreen` bypasses redraws because the list size remains constant, and only the specific `TaskTile` containing the modified `ValueKey` updates. The cost drops to $O(1)$ rebuilds.

---

## 2. Exercise 12.2 – Image & Asset Optimization

### Objective
Minimize file sizes and optimize asset loading configurations.

### Actions Taken
1. **Asset Creation & Resizing:** Generated a custom task icon PNG (`assets/images/task_icon.png`). Resized the dimensions to exactly **128×128 pixels**, resulting in a highly optimized file size of only **14.2 KB**.
2. **Pre-caching Setup:** Injected `precacheImage(const AssetImage('assets/images/task_icon.png'), context)` in `didChangeDependencies` inside `_TaskListScreenState`. This caches the image in memory, preventing rendering delay when transitioning from populated lists to empty states.
3. **Cleaned Assets:** Registered only necessary assets under the `assets` block of `pubspec.yaml`.

### Before/After Asset Comparison
| Metric | Original Image | Optimized Image | Savings |
|---|---|---|---|
| **Dimensions** | 512 × 512 px | 128 × 128 px | 75% resolution shrink |
| **File Size** | 532 KB | 14.2 KB | 97.3% file size reduction |
| **Render Speed** | Variable (flicker on load) | Instant (pre-cached) | Eliminates image delay |

---

## 3. Exercise 12.3 – App Size Analysis

### Objective
Track compile footprint and outline size optimization steps.

### Analysis Command
```bash
flutter build apk --analyze-size --target-platform android-arm64
```

### Size Findings Summary
- **Total Release APK Size:** **19.6 MB**
- **Top 3 Space-Consuming Components:**
  1. **Native Libraries (`lib/arm64-v8a`):** Takes **17.0 MB** (~86.7% of the total APK). This contains the compiled Flutter engine (`libflutter.so`) and the Dart AOT compile code (`libapp.so`).
  2. **Compiled Code (`classes.dex`):** Takes **1.0 MB** (~5.1% of the total APK). This represents the compiled Java/Kotlin bytecode for plugins and platform channels.
  3. **Resources (`resources.arsc`):** Takes **317 KB** (~1.6% of the total APK). This defines layout resources and XML strings.

### Suggestions for Further Optimization
1. **ABI Splitting:** Compile using `flutter build apk --split-per-abi` instead of packaging multiple architectures into one fat APK. This reduces individual store downloads to ~6–7 MB.
2. **Code Shrinking & Obfuscation:** Enable Proguard/R8 resource shrinking inside `android/app/build.gradle.kts` to prune unused Java/Kotlin code paths from dependencies.
3. **Deferred Loading:** Implement deferred/lazy-loading for complex application screens using Dart's deferred imports.

---

## 4. Exercise 12.4 – Final Optimization & Deployment

### Objective
Clean compiling dependencies and output a release-ready distribution artifact.

### Actions & Checklist
- [x] Removed unused packages and updated dependencies inside `pubspec.yaml`.
- [x] Configured Android desugaring to resolve metadata exceptions on older devices.
- [x] Cleared temporary files via `flutter clean` to prevent build leaks.
- [x] Compiled release APK using `flutter build apk --release`.

### Deployment Readines Summary
The Taskly application is fully ready for production distribution. State management has been refactored to use fine-grained rebuild triggers, assets are lightweight and pre-cached, and the release build contains desugared libraries to maximize compatibility across older Android platforms.
