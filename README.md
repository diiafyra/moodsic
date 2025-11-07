# Moodsic

## Design
Figma: [Moodsic](https://www.figma.com/design/DU2wVctCCRMZnTNLuEpZ3G/moodsic?node-id=0-1&p=f)

## Cấu trúc dự án
(fill code theo cấu trúc này)
### 1. `core/` – “Xương sống” của dự án
- **Mục đích**: Chứa cấu hình chung, service để gọi API, helper, và widget cực kỳ generic.
- **Ví dụ sản phẩm**:
    - `core/config/env.dart` ⇒ **Logic**: nạp biến môi trường (API_URL, API_KEY).
    - `core/config/routes.dart` ⇒ **Logic**: định nghĩa GoRouter cho toàn app.
    - `core/config/themes/light_theme.dart` ⇒ **Data**: `ThemeData` cho light mode.
    - `core/services/api_service.dart` ⇒ **Logic**: class `ApiService.post()`/`get()` gọi Firebase Function hoặc N8N.
    - `core/utils/validators.dart` ⇒ **Logic**: hàm `isValidEmail()`, `isStrongPassword()`.
    - `core/widgets/primary_button.dart` ⇒ **Component**: `PrimaryButton` dùng chung khắp app các component nhỏ như các nút...

### 2. `data/` – Model + Repository
- **Mục đích**: Định nghĩa cấu trúc data (model) và cách lấy/lưu (repository).
- **Ví dụ sản phẩm**:
    - `data/models/user.dart` ⇒ **Model**: class `User { String id; String name; }`.
    - `data/models/playlist.dart` ⇒ **Model**: `Playlist { String id; String title; String imageUrl; }`.
    - `data/repositories/user_repository.dart` ⇒ **Logic**: `Future<User> fetchCurrentUser()`.
    - `data/repositories/playlist_repository.dart` ⇒ **Logic**: `Future<List<Playlist>> getPlaylistsByMood(String mood)`.
    -
### 3. `domain/` – Business logic (Use Cases & Entities)
- **Mục đích**: Tách biệt hoàn toàn “việc app phải làm” (use case) khỏi các chi tiết fetch data.
- **Ví dụ sản phẩm**:
    - `domain/entities/mood.dart` ⇒ **Entity**: `Mood { String code; String label; }`.
    - `domain/usecases/fetch_playlists_by_mood.dart` ⇒ **Logic**: class `FetchPlaylistsByMood { execute(String mood) => List<Playlist> }`.
    - `domain/usecases/save_user_survey.dart` ⇒ **Logic**: nhận input form khảo sát, gọi repository lưu vào Firestore.

### 4. `features/` – Feature Modules
- **Mục đích**: Mỗi tính năng lớn (module) có đầy đủ màn hình, viewmodel, và widget nội bộ.
- **Cấu trúc chung mỗi feature**:  
  features/<feature_name>/
  ├── view/ # Các screen (pages)
  ├── viewmodel/ # State + logic tương tác UI
  └── widgets/ # Component chỉ dùng trong feature đó
  **Ví dụ sản phẩm**:
- **`features/auth/`**
    - `view/login_page.dart` ⇒ **Screen**: form đăng nhập (email/password).
    - `viewmodel/login_viewmodel.dart` ⇒ **Logic**: validate input, gọi AuthService.
    - `widgets/google_signin_button.dart` ⇒ **Component**: nút “Sign in with Google”.
- **`features/mood_input/`**
    - `view/mood_input_page.dart` ⇒ **Screen**: slider chọn mood, button “Next”.
    - `viewmodel/mood_input_viewmodel.dart` ⇒ **Logic**: lưu mood chọn, điều hướng.
    - `widgets/mood_slider.dart` ⇒ **Component**: custom slider với icon mood.
- **`features/playlist_suggestion/`**
    - `view/playlist_page.dart` ⇒ **Screen**: danh sách playlist.
    - `viewmodel/playlist_viewmodel.dart` ⇒ **Logic**: gọi use case `FetchPlaylistsByMood`.
    - `widgets/playlist_card.dart` ⇒ **Component**: hiển thị ảnh + tên playlist.

### 5. `shared/` – Shared Widgets & State
- **Mục đích**: Chứa widget “cỡ vừa” hoặc provider/global state dùng chung nhiều feature.
- **Ví dụ sản phẩm**:
- `shared/widgets/app_scaffold.dart` ⇒ **Component**: scaffold chuẩn, custom AppBar + Drawer.
- `shared/widgets/loading_overlay.dart` ⇒ **Component**: overlay loading dùng khắp app.
- `shared/state/theme_provider.dart` ⇒ **Logic**: lưu và đổi theme (light/dark).

### 6. `routes/` – Định nghĩa Navigation
- **Mục đích**: Nếu bạn cần tách file router ra ngoài `core/`, đặt ở đây.
- **Ví dụ sản phẩm**:
- `routes/app_routes.dart` ⇒ **Logic**: danh sách `GoRoute(path: '/mood', builder: …)`.
- `routes/route_names.dart` ⇒ **Data**: constant `static const mood = '/mood';`.
