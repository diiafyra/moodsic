### 3. `domain/` – Business logic (Use Cases & Entities)
- **Mục đích**: Tách biệt hoàn toàn “việc app phải làm” (use case) khỏi các chi tiết fetch data.
- **Ví dụ sản phẩm**:
    - `domain/entities/mood.dart` ⇒ **Entity**: `Mood { String code; String label; }`.
    - `domain/usecases/fetch_playlists_by_mood.dart` ⇒ **Logic**: class `FetchPlaylistsByMood { execute(String mood) => List<Playlist> }`.
    - `domain/usecases/save_user_survey.dart` ⇒ **Logic**: nhận input form khảo sát, gọi repository lưu vào Firestore.
