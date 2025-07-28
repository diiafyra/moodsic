### 1. `core/` – “Xương sống” của dự án
- **Mục đích**: Chứa cấu hình chung, service để gọi API, helper, và widget cực kỳ generic.
- **Ví dụ sản phẩm**:
    - `core/config/env.dart` ⇒ **Logic**: nạp biến môi trường (API_URL, API_KEY).
    - `core/config/routes.dart` ⇒ **Logic**: định nghĩa GoRouter cho toàn app.
    - `core/config/themes/light_theme.dart` ⇒ **Data**: `ThemeData` cho light mode.
    - `core/services/api_service.dart` ⇒ **Logic**: class `ApiService.post()`/`get()` gọi Firebase Function hoặc N8N.
    - `core/utils/validators.dart` ⇒ **Logic**: hàm `isValidEmail()`, `isStrongPassword()`.
    - `core/widgets/primary_button.dart` ⇒ **Component**: `PrimaryButton` dùng chung khắp app các component nhỏ như các nút...