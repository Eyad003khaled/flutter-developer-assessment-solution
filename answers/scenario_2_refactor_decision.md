#  Scenario 2: Refactor Under Pressure

---

## 1. **Decision**

I will **NOT refactor now**.  
I will postpone the refactor **until after the launch**.

---

## 2. **Justification**

### Why NOT refactor now?

- The launch deadline is **only 3 weeks away**
- `FetchUserDataBloc` is deeply integrated into multiple features
- Refactoring it now introduces:
  - High risk of **breaking critical flows**
  - Unexpected regressions in:
    - Chat
    - Real-time updates (Pusher)
    - User data
  - Increased debugging time

 This directly threatens **missing the launch deadline**, which is the top priority.

---

### Risks of Each Option

####  Refactor Now
- High probability of **regressions**
- Delays due to:
  - Dependency restructuring
  - Integration issues
- Hard to stabilize before release

####  Refactor After Launch Without Preparation
- Technical debt remains unmanaged
- Harder to refactor without test coverage

####  Refactor After Launch (Chosen)
- Safer environment
- Time to:
  - Add proper test coverage
  - Refactor in a controlled way
- No risk to launch delivery

---

## 3. **Pre-Launch Strategy (Make Launch Safer)**

Since refactoring is postponed, I will focus on **stabilizing the current system**:

### Actions:

-  Add **targeted testing** for all features depending on `FetchUserDataBloc`:
  - User profile loading
  - Chat subscriptions
  - Banner events
  - Wallet updates

-  Avoid adding **new responsibilities** to this BLoC
-  Isolate new feature logic (live-streaming) in **separate BLoCs/services**
-  Add logging for critical flows (especially WebSocket events)

---

## 4. **Post-Launch Refactor Plan**

Immediately after launch:

### Step 1: Add Test Coverage
- Cover current behavior before refactoring
- Ensure safe refactor without breaking features

### Step 2: Split the BLoC

Proposed decomposition:

- `UserBloc` → profile & user data
- `SocketBloc` → Pusher connection & events
- `ChatBloc` → messaging & subscriptions
- `BannerBloc` → gift/game banners
- `WalletBloc` → wallet balance
- `AppConfigBloc` → app configuration
- `NotificationBloc` → FCM token & notifications

---

### Dependency Diagram (Conceptual)

```
FetchUserDataBloc (Current)
        ↓
----------------------------------
| UserBloc        | WalletBloc    |
| ChatBloc        | BannerBloc    |
| SocketBloc      | ConfigBloc    |
| NotificationBloc              |
----------------------------------
```

---

## 5. **Team Coordination**

To avoid merge conflicts with 2 developers working in the same area:

- Use **feature branches**
- Keep PRs:
  - Small
  - Focused
- Perform **strict PR reviews** before merging
- Rebase frequently to stay updated
- Communicate clearly on:
  - Ownership of files
  - Active changes

---

## 6. **Testing Strategy**

### Before Refactoring

- Add **baseline tests** for current behavior:
  - Critical flows only (not full coverage)
  - Focus on:
    - Chat
    - User data
    - Real-time updates

---

### During Refactoring

- Refactor incrementally (not all at once)
- Ensure tests pass after each step

---

### After Refactoring

- Expand test coverage:
  - Unit tests for each new BLoC
  - Integration tests for flows between BLoCs

---

### Key Principle

> Write tests **before and after refactoring**, then compare results to ensure behavior consistency.

---

##  Final Summary

- Prioritize **meeting the launch deadline**
- Avoid risky refactoring under time pressure
- Stabilize current system with **targeted testing**
- Perform **structured refactor post-launch**
- Ensure quality with **incremental refactor + test validation**
