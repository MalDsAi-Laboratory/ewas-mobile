# CLAUDE.md — ewas-mobile (ScrapIt)

> Deep-code audit: environment variables, dependent services, production readiness, code quality, testability.

---

## Project Overview

**ScrapIt** — Flutter e-waste marketplace. Three user roles: `seller` (submit items, track orders), `recycler` (set prices, accept bids), `admin`/`deliveryuser` (manage all orders, assign agents).

**Stack**: GetX state management · Dio HTTP (per-service singleton) · `flutter_dotenv` · `flutter_secure_storage` · `flutter_map` (OpenStreetMap tiles) · `cached_network_image` · `flutter_screenutil` (design size 390×844)

**Package name**: `com.ewaste.ewas` | **pubspec name**: `simple_ui` ← placeholder, never updated | **App title**: `ScrapIt` | **Android label**: `E-WAS`

---

## 1. Environment Variables

Loaded in [`app_start_services.dart`](lib/app_start_services.dart):

```dart
await dotenv.load(fileName: kReleaseMode ? ".env.prod" : ".env.dev");
```

Both files are listed as Flutter **assets** in `pubspec.yaml` — they ship unencrypted inside the APK binary:

```yaml
assets:
  - .env.dev
  - .env.prod
```

| Variable | Dev | Prod |
|---|---|---|
| `PRODUCT_CATALOGUE_BASE_URL` | `13.204.227.253:4082/api` | `ewas.maldsai.com:4082/api` |
| `ORDER_BASE_URL` | `13.204.227.253:8083/orders` | `ewas.maldsai.com:8083/api/v1/order` ← **different path prefix** |
| `INVENTORY_BASE_URL` | `13.204.227.253:4081/api/inventory` | `ewas.maldsai.com:4081/api/inventory` |
| `USER_BASE_URL` | `13.204.227.253:4080/api/v1/users` | `ewas.maldsai.com:4080/api/v1/users` |
| `BIDDING_BASE_URL` | `13.204.227.253:6060/api/v1/bidding` | `ewas.maldsai.com:6060/api/v1/bidding` |
| `PRODUCT_DETAILS_BASE_URL` | `13.204.227.253:5080/api/v1/product-details` | `ewas.maldsai.com:5080/api/v1/product-details` |
| `LOCATION_BASE_URL` | `13.204.227.253:8086/api/locations` | `ewas.maldsai.com:5080/api/sellers` ← **different port/path** |
| `RADIUS` | `10000` | `10000` |
| `SCHEDULING_BASE_URL` | `13.204.227.253:8085/api/seller-locations` | ❌ missing | Not read in `load_env.dart` — dead |

**Critical issues:**
- **Env files are APK-readable.** `apktool d` exposes all server IPs. Never bundle secrets as assets.
- **Two hardcoded URLs outside env**: `http://93.229.113.153:8080` in [`inventory_model.dart:44`](lib/models/inventory_model.dart) (image server, different IP from all env values); `http://ewas.maldsai.com:8080/myapp` in [`app_images.dart:7`](lib/ui_utils/app_images.dart).
- All 8 variables are `String?` in `load_env.dart` and used with `!` at Dio singleton creation. A missing env entry produces a null-assertion crash at first API call rather than a clear configuration error. There is no startup validation.
- `SCHEDULING_BASE_URL` is defined in `.env.dev` but has no matching variable in `load_env.dart` and is never consumed by any Dio singleton — dead configuration.

---

## 2. Dependent Services

All services run on **raw HTTP, no TLS**. Auth base URL is derived at runtime by string-replacing `/users` → `/auth` in `USER_BASE_URL` — fragile. Each service has its own Dio singleton class initialised lazily on first access; the base URL is baked in at creation time so changing env after init has no effect. All singletons share the same interceptor shape (request logging, response logging, 403 accumulator).

| Service | Port | Purpose | API file |
|---|---|---|---|
| User + Auth | 4080 | Register, login, profile CRUD | [`user_apis.dart`](lib/services/apis/user/user_apis.dart) |
| Product Catalogue | 4082 | Categories, products per category | [`product_catalogue_api.dart`](lib/services/apis/product_catalogue/product_catalogue_api.dart) |
| Inventory | 4081 | Inventory records + multipart image upload | [`inventory_apis.dart`](lib/services/apis/inventory/inventory_apis.dart) |
| Order | 8083 | Create / read / update orders | [`order_apis.dart`](lib/services/apis/order/order_apis.dart) |
| Bidding | 6060 | Bid CRUD per order | [`bidding_apis.dart`](lib/services/apis/bidding/bidding_apis.dart) |
| Product Details | 5080 | Recycler pricing, nearby recycler map data | [`product_details_api.dart`](lib/services/apis/product_details/product_details_api.dart) |
| Location / Scheduling | Dev 8086 / Prod 5080 | Seller GPS coordinates, login location lookup | [`location_apis.dart`](lib/services/apis/location/location_apis.dart) |
| Image server | 8080 (hardcoded IP) | Product image serving — URL baked into `InventoryModel.fromJson` | N/A |
| OSM Nominatim (ext.) | — | Reverse geocoding in map screens | direct `http` call |

### Order Lifecycle

Orders progress through a fixed sequence defined in [`order_helper.dart`](lib/modules/orders/order_helper.dart):

```
Order placed → Bidding Started → Bidding In Progress → Bidding Completed
                                                      → Bidding Rejected
                                                      → Awaiting for pick → Order Collected
                                                                          → Delivered to warehouse
                                                                          → Delivered for Recycle
                                                                          → Completed
```

Status is stored as a raw string constant (no enum). The cart flow stores draft orders locally in `getApplicationDocumentsDirectory()` before they go to auction; `CartController` reads them back from the filesystem. When a cart order is submitted, it gets converted to a bidding order and the local files are deleted.

### Service Dependency at Login / Registration

**Login chain** (seller/recycler):
```
loginUserApi (User Service)
  └─> getUserByUserIdApi2 (Location Service)
       └─> SecureStorageServices.setUserLocation()
```
If Location Service is down, login still succeeds with cached/skipped coordinates — intentional degradation ([`auth_controller.dart:189`](lib/modules/auth/auth_controller.dart)).

**Registration chain**:
```
createUserApi (Auth endpoint)
  └─> createUser2Api (Location Service)  ← non-blocking, fire-and-forget
```
If the location call fails silently, the seller has no location entry. Item listing will break later when the location service can't find them.

---

## 3. Production Readiness

### P0 — Blockers

| # | Issue | Location |
|---|---|---|
| 3.1 | **No auth tokens on any API call.** The interceptor block exists in all 7 service files but the token attachment code is 100% commented out — `requiresToken: true` is checked but the Firebase/JWT code below is dead. All backend endpoints are callable anonymously. | all `*_api_services.dart` |
| 3.2 | **Plaintext HTTP everywhere.** Credentials, bid prices, and location data travel unencrypted. | `.env.dev`, `.env.prod` |
| 3.3 | **Env files ship inside the APK** (listed as Flutter assets). | `pubspec.yaml` |
| 3.4 | **Password stored in SecureStorage.** `UserModel.toJson()` includes `password`; the full object is persisted on registration and re-loaded at splash. | [`user_model.dart:35`](lib/models/user_model.dart) |
| 3.5 | **Release build uses debug signing.** Play Store will reject it. | [`build.gradle:33`](android/app/build.gradle) |
| 3.6 | **No logout.** `SecureStorageServices.logOut()` exists but is never called from any screen. `removeLoginDataToStorage()` is a commented-out stub everywhere. | all `*_api_services.dart` |
| 3.7 | **Memory leak.** On every 403 response, the Dio exception and its handler object are appended to module-global `failedApis` / `handlers` lists (`var failedApis = []; var handlers = [];`) that are never read and never cleared — unbounded growth for the lifetime of the process. | all `*_api_services.dart` |

### P1 — Significant Issues

**Bulk order fetch with N+1 inventory calls.** [`all_order_controller.dart:82`](lib/modules/orders/controller/all_order_controller.dart) requests `pageSize: 10000` in a single call, then `_fetchInventory()` fires one HTTP request per order in parallel (`Future.wait` over all `orders`). With `pageSize: 10000` this means up to 10,001 simultaneous requests on load. Pagination params (`pageNumber`, `pageSize`) already exist in the API signature — real server-side pagination just needs to be wired up and the bypass removed.

**`device_preview_plus` in `dependencies`**, not `dev_dependencies`. It's commented out in `main.dart` but still ships in the production binary, inflating APK size unnecessarily.

**App identity mismatch across three files:**
- `pubspec.yaml` → `name: simple_ui`, `description: A simple Flutter UI` (boilerplate, never updated)
- `main.dart` → `title: 'ScrapIt'`
- `AndroidManifest.xml` → `android:label="E-WAS"`

**Dart SDK constraint** `">=2.19.0 <3.0.0"` in `pubspec.yaml` blocks Dart 3 language features and will prevent future tooling upgrades.

**`INTERNET` permission** not declared in `AndroidManifest.xml`. Flutter injects it automatically in debug builds; explicit declaration is required for production.

**`MainScreenController.getRoleBasedScreen`** returns a `List<Widget>` for known roles but falls through to `return CartPage()` (a single `Widget`) in the `default` case — type mismatch that Dart's type inference currently masks but will break at runtime for any unexpected role value.

---

## 4. Code Quality

**Massive duplication in the API service layer.** All 7 `*_api_services.dart` files copy-paste ~80 identical lines: `ErrorModel`, `failedApis`/`handlers` globals, `checkSocketException`, `requestEntityTooLarge`, full Dio interceptor setup, `removeLoginDataToStorage` stub — ~560 lines that belong in one `BaseDioSingleton`. Only `UserDioSingleton` and `LocationDioSingleton` have `reset()`; the other 5 initialise eagerly before `dotenv.load()` completes if imported early.

**Unsafe model parsing** — will crash at runtime:

| File | Crash |
|---|---|
| [`user_model.dart:32`](lib/models/user_model.dart) | `json['roles'].cast<String>()` — `NoSuchMethodError` if `roles` is null |
| [`order_controller.dart:52`](lib/modules/orders/controller/order_controller.dart) | `name.split(' ')[1]` — `RangeError` on single-word names |
| [`profile_controller.dart:138`](lib/modules/profile/profile_controller.dart) | `model.firstName!`, `model.lastName!`, etc. — all force-unwrapped; null from API crashes `onInit` |
| [`auth_controller.dart:216`](lib/modules/auth/auth_controller.dart) | `double.parse(location!.split(',')[0])` — crashes if location is null or not in `"lat,lng"` format |

**Unguarded `print()` in production.** None of the following are wrapped in `kDebugMode`:

| File | What gets logged |
|---|---|
| [`location_apis.dart:25`](lib/services/apis/location/location_apis.dart) | Full serialised user payload including address and GPS — every registration call |
| [`map_screen.dart`](lib/modules/auth/components/map_screen.dart) | Raw HTTP response body from Nominatim geocoding |
| [`submit_item_controller.dart`](lib/modules/submit_item/submit_item_controller.dart) | Progress markers and error strings on every order submit |
| [`cart_controller.dart`](lib/modules/cart/cart_controller.dart) | `"createInventory failed"` |
| [`locate_recylers.dart`](lib/modules/locate_recyclers/locate_recylers.dart) | Radius value from env |

**Inconsistent error field extraction.** Different API files use different keys to pull the error message: `response.data?['detail']` (catalogue, order, location), `response.data?['message']` (inventory, bidding, user), or a hardcoded fallback string. Users see different error formats depending on which backend service responds. No shared error contract exists.

**Navigation anti-pattern** — [`submit_item_controller.dart`](lib/modules/submit_item/submit_item_controller.dart) calls `Get.back()` four times consecutively to unwind the stack. One extra push anywhere in the flow leaves the user on the wrong screen.

**`Timer.periodic` without disposal guard** — [`cart_controller.dart:29`](lib/modules/cart/cart_controller.dart) starts a 2-second poll timer. If the polled controller is not registered at tick time, `Get.find()` throws and the timer never cancels, continuing to run after the widget is disposed. (Currently commented out in `onInit` but wired to re-enable.)

**`CartController.onInit` loads nothing.** The `pollOrderStatusAndUpdateCart()` call is commented out and never replaced. On app start the cart tab is empty until the user navigates away and back, because `getCartProducts()` is never triggered automatically.

**Dead / misnamed files**: `cached_cart_list.dart` (100% commented out), `main_module/services.dart` (empty), `locate_recylers.dart` (filename typo), `rejectBidding_btn.dart` (mixed case). `path_provider` is used in two controllers but missing from `pubspec.yaml` — implicit transitive dependency that will break on dependency updates.

**All models use Dart 2 patterns**: `new Map<String, dynamic>()`, `data['x'] = this.x`, explicit `this.` references in constructors — across all 8 model files. These generate active lint warnings under `flutter_lints`.

---

## 5. Testability

**One test file exists; it tests the wrong app.** [`test/widget_test.dart`](test/widget_test.dart) looks for `"Enter text"` / `"Submit"` from a Flutter starter template — `flutter test` fails immediately. There are no unit tests, integration tests, or mock infrastructure.

**Controllers are untestable in isolation.** Every controller calls `Get.find<AnotherController>()` directly inside business logic. Testing `AllOrderController` requires also registering `MainScreenController`, `OrderController`, and more.

**API layer is not mockable.** All API calls are module-level top-level functions (`createOrderApi`, `getAllOrdersApi` …) that reference Dio singletons initialised at import time. There is no interface or injection point — swapping HTTP for a fake requires modifying source code.

**Global singleton state leaks between tests.** `Dio dio = OrderDioSingleton.instance` executes at file import time. One test's interceptor state and base URL bleed into the next. Only 2 of 7 singletons have a `reset()` method — the other 5 cannot be torn down between tests.

**Untyped response contract.** All API functions return `Map<String, dynamic>` with informal keys `status`, `statusCode`, `data`. No `Result<T, E>` type exists. Error-path assertions require reading source to know which key carries the message; the key differs per service (`detail` vs `message`).

**No repository abstraction.** Controllers import API functions directly from `*_apis.dart` files. Adding a repository interface layer (e.g., `abstract class OrderRepository { Future<List<OrderModel>> getOrders(); }`) would decouple controllers from HTTP and make every controller trivially unit-testable with a fake.

**`ProfileController.onInit` is `async` but declared `void`.** The `async` modifier on a `void` return type makes the future fire-and-forget — exceptions are silently swallowed and the profile screen can render with empty/stale data before the awaited location fetch completes.

**Order status is a stringly-typed constant class** (`OrderStatus.orderPlaced = "Order placed"`). Typos or mismatches between what the backend sends and what the frontend checks (`orderStatus == "Order placed"`) fail silently — no enum exhaustiveness check is possible. [`order_helper.dart`](lib/modules/orders/order_helper.dart).

---

## Key Files

| File | Role |
|---|---|
| [`lib/app_start_services.dart`](lib/app_start_services.dart) | App bootstrap: env load + Dio reset |
| [`lib/services/load_env.dart`](lib/services/load_env.dart) | All env variable declarations (all `String?`) |
| [`lib/modules/splash/splash_screen.dart`](lib/modules/splash/splash_screen.dart) | Auto-login from secure storage |
| [`lib/modules/auth/auth_controller.dart`](lib/modules/auth/auth_controller.dart) | Login, register, location flow |
| [`lib/modules/main_module/app_screen.dart`](lib/modules/main_module/app_screen.dart) | Root screen; registers global GetX controllers |
| [`lib/modules/main_module/main_screen_controller.dart`](lib/modules/main_module/main_screen_controller.dart) | Role-based page + nav bar setup |
| [`lib/modules/orders/controller/all_order_controller.dart`](lib/modules/orders/controller/all_order_controller.dart) | Central order + inventory state (10k fetch) |
| [`lib/modules/submit_item/submit_item_controller.dart`](lib/modules/submit_item/submit_item_controller.dart) | Order creation + image upload flow |
| [`lib/modules/cart/cart_controller.dart`](lib/modules/cart/cart_controller.dart) | Draft orders stored locally before auction |
| [`lib/models/inventory_model.dart`](lib/models/inventory_model.dart) | **Hardcoded image server IP on lines 44–56** |
| [`lib/ui_utils/app_images.dart`](lib/ui_utils/app_images.dart) | **Hardcoded prod media server URL** |
| [`android/app/build.gradle`](android/app/build.gradle) | **Release build uses debug signing — Play Store will reject** |

---

## Prioritized Action List

### P0 — Security
1. Move all backend URLs to HTTPS
2. Wire Bearer token into Dio interceptors (uncomment + implement Firebase Auth or JWT)
3. Replace `.env` assets with `--dart-define` compile-time flags
4. Remove `password` from `UserModel.toJson()` and from secure storage
5. Add a proper release signing config in `build.gradle`

### P1 — Stability
6. Null-guard `json['roles']` in `UserModel.fromJson`
7. Fix name split in `OrderController` (`split(' ', 2)` minimum)
8. Add `reset()` to all 5 remaining Dio singletons; call them all in `app_start_services.dart`
9. Move image server base URL into env; remove hardcoded IP from `InventoryModel.fromJson`
10. Implement logout; wire it to a settings action

### P2 — Code Quality
11. Extract `BaseDioSingleton` + `DioUtils` to eliminate 560-line duplication; add `reset()` to all 5 singletons that lack it
12. Wrap API functions in repository classes with abstract interfaces (enables DI and mocking without modifying controllers)
13. Add typed `ApiResult<T, E>` wrapper; standardise error field to a single key across all 7 services
14. Move `device_preview_plus` to `dev_dependencies`; guard all remaining `print()` with `if (kDebugMode)`
15. Update `pubspec.yaml`: set `name` to `scrapit`, update `description`, bump SDK to `^3.0.0`; add `INTERNET` permission to `AndroidManifest.xml`
16. Replace `OrderStatus` string constants with a Dart `enum` to get exhaustiveness checking and eliminate stringly-typed comparisons throughout the order flow

### P3 — Testing
16. Delete `widget_test.dart`; write real unit tests for `Validations`, `OrderStatus`, and all model `fromJson`/`toJson`
17. Refactor controllers to accept repository interfaces via constructor (no `Get.find()` in business logic)
18. Add integration tests for the two core flows: register → login → submit item; and login → view orders → update status
19. Add widget tests for role-based navigation (verify correct pages shown per role)

### P4 — Cleanup
20. Remove `cached_cart_list.dart` (dead), empty `main_module/services.dart`, and the `SCHEDULING_BASE_URL` entry from `.env.dev`
21. Rename `locate_recylers.dart` → `locate_recyclers.dart` and `rejectBidding_btn.dart` → `reject_bidding_btn.dart`
22. Add `path_provider` explicitly to `pubspec.yaml` (currently implicit via transitive dep)
23. Update all 8 models from `new Map<>()` / `this.field` patterns to modern Dart collection literals
24. Wire `CartController` `onInit` to call `getCartProducts()` directly (remove the now-unnecessary `pollOrderStatusAndUpdateCart` workaround)
25. Add an `IMAGE_BASE_URL` env variable and read it in `InventoryModel.fromJson` and `AppImages` instead of hardcoded IPs/domains
