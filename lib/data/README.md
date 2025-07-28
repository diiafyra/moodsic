
### 2. `data/` – Model + Repository
- **Mục đích**: Định nghĩa cấu trúc data (model) và cách lấy/lưu (repository).
- **Ví dụ sản phẩm**:
    - `data/models/user.dart` ⇒ **Model**: class `User { String id; String name; }`.
    - `data/models/playlist.dart` ⇒ **Model**: `Playlist { String id; String title; String imageUrl; }`.
    - `data/repositories/user_repository.dart` ⇒ **Logic**: `Future<User> fetchCurrentUser()`.
    - `data/repositories/playlist_repository.dart` ⇒ **Logic**: `Future<List<Playlist>> getPlaylistsByMood(String mood)`.
