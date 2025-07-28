### 5. `shared/` – Shared Widgets & State
- **Mục đích**: Chứa widget “cỡ vừa” hoặc provider/global state dùng chung nhiều feature.
- **Ví dụ sản phẩm**:
- `shared/widgets/app_scaffold.dart` ⇒ **Component**: scaffold chuẩn, custom AppBar + Drawer.
- `shared/widgets/loading_overlay.dart` ⇒ **Component**: overlay loading dùng khắp app.
- `shared/state/theme_provider.dart` ⇒ **Logic**: lưu và đổi theme (light/dark).