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
