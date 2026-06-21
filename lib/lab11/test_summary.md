# Lab 11.5 – Test Suite Summary Document

This document summarizes the comprehensive test suite built for the **Taskly** application, validating all core logical and user interface components.

---

## 1. Test Suite Overview

- **Total Number of Tests**: 9 test scenarios
- **Overall Result**: Passing (100% Success Rate)

---

## 2. Breakdown of Tests by Type

### A. Unit Tests (`test/unit/`)
- **Total**: 5 tests
- **Files**:
  - `task_model_test.dart`
  - `task_repository_test.dart`
- **Behaviors Validated**:
  - Task instantiation default parameters (e.g. `isCompleted` is initialized to `false`).
  - Immutability of task toggles (calling `task.toggle()` returns a new instance with inverted completion state).
  - Task Repository CRUD functions:
    - Adding tasks to the list.
    - Deleting tasks by unique ID.
    - Updating task properties (e.g. changing title, toggling completed state).

### B. Widget UI Tests (`test/widget/`)
- **Total**: 3 tests
- **Files**:
  - `task_list_widget_test.dart`
- **Behaviors Validated**:
  - Rendering constraints when tasks list is empty, validating that `"No tasks yet. Add one!"` is displayed.
  - Interactive item input flow: simulating text entry, tapping the Add button, and verifying the new task tile is rendered.
  - Rendering multiple task cards simultaneously, verifying list item indexing.

### C. Navigation Tests (`test/widget/`)
- **Total**: 1 test
- **Files**:
  - `task_navigation_test.dart`
- **Behaviors Validated**:
  - Simulating navigation events: tapping a task list row triggers navigation, pushing `TaskDetailScreen` onto the stack.
  - Verifying the detail view displays the `"Task Detail"` AppBar title and contains the text editing field matching key `detailTitleField`.

### D. End-to-End Integration Tests (`test/integration/` and `test/widget/`)
- **Total**: 1 test (run across files)
- **Files**:
  - `task_integration_test.dart`
- **Behaviors Validated**:
  - Simulating the full task lifecycle: launching list screen, adding task "Original title", clicking task tile, rewriting task title to "Updated title" on the detail screen, saving changes, and verifying that the original title is removed and "Updated title" is displayed on the main list.

---

## 3. Execution Command & Verification

To execute the entire test suite, run:
```bash
flutter test
```
All 9 test cases resolve successfully, confirming both model states and layout actions conform to requirements.

---

## 4. Known Limitations

- **In-Memory Volatility**: The repository holds data in RAM. Restarting the application wipes list records because persistent local storage is not integrated.
- **Asynchronous Latency Mocking**: The integration tests run synchronously on mock clocks. They do not test physical REST network endpoints, which may introduce latency spikes or transport failures in production.
- **Mock Firebase Google Auth**: In live builds, federated Google login operates in a simulated configuration fallback mode if native developer keys are missing.
