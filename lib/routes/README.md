### 6. `routes/` – Định nghĩa Navigation
- **Mục đích**: Nếu bạn cần tách file router ra ngoài `core/`, đặt ở đây.
- **Ví dụ sản phẩm**:
- `routes/app_routes.dart` ⇒ **Logic**: danh sách `GoRoute(path: '/mood', builder: …)`.
- `routes/route_names.dart` ⇒ **Data**: constant `static const mood = '/mood';`.
