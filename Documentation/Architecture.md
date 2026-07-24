# Vienna RSS Project Documentation Draft

## 📄 README.md - High-Level Project Overview (Draft)

**Title: Vienna RSS Feed Aggregator**

Vienna is a robust, native macOS application designed for advanced content consumption and aggregation. Its main role is to provide users with a highly customizable reading environment for multiple incoming RSS, Atom, and JSON feeds. It acts as a full-featured content management system rather than just a simple feed reader due to its powerful features like Smart Folders and advanced article parsing/viewing modes.

### Key Concepts:
*   **Federation:** Supports connecting directly to external sites or using private APIs (like Open Reader).
*   **Readability Focus:** The application prioritizes user experience by providing distinct viewing modes—a list view for quick scanning, and a professional reader mode that cleans up raw web content.
*   **Extensible Data Layer:** Core functionality is built around structured data models (`Folder`, `Article`) persisted in SQLite. It uses plugins and background notification centers to ensure UI components react immediately to data changes without requiring polling.

### Usage Profile:
Vienna is designed for the **power user**: developers, researchers, content curators, or highly engaged readers who manage many disparate sources of information and require organizational tools beyond basic feed viewing.

---

## ⚙️ ARCHITECTURE.md - Technical Blueprint (Draft)

**1. Overall Architecture Pattern:** The application employs an event-driven pattern rooted in Objective-C's `NSNotificationCenter` for reactive UI updates, despite having modern Swift extensions. Core state changes flow through the central data model and trigger notifications (`VNADatabaseWillDeleteFolderNotification`, etc.), ensuring loose coupling between data and presentation layers.

**2. Data Persistence & Model:**
*   **Database:** Utilizes SQLite (via FMDB) as a single source of truth for all metadata: Folder structure, Article GUIDs, and Core Article content. Transactions are mandatory for atomic write operations (e.g., fetching batches).
*   **Data Entity:** The `Article` is the central entity, which must be uniquely identified using platform-specific techniques like combining the Source GUID with a source identifier record to prevent duplicate ingestion across streams.

**3. Data Flow Lifecycle: The Core Sync Loop**
1.  **Trigger:** A subscription update (time-based/manual) triggers a call into **`Sources/Fetching/RefreshManager.m`**.
2.  **Acquisition:** Plugins specific to the feed type execute network calls, parsing raw data using specialized parsers in `Article list/Article content/`.
3.  **Persistence:** Successful articles are batched and written atomically to the SQLite database. This critically includes updating aggregated folder counts (`unread_count`).
4.  **Notification:** Crucially, upon completion of a transaction (e.g., successful batch write, or a directory deletion), an explicit `NSNotification` is posted. **This notification mechanism decouples persistence from presentation.**

**4. UI/UX Layer Interaction (The View Layer):**
*   The UI components (`ArticleList`, `FolderView`) are not data sources; they are *subscribers*. They register observers against the same notifications listed above. When a notification fires, the view controllers receive it and execute the necessary methods to refresh their visible state/data display without accessing the database directly—they trust that an observer handles the retrieval efficiently.

**5. Key Code Areas for Documentation:**
*   `ViennaApp.m/.h`: Application entry point and overall lifecycle management.
*   `Database.m/.h`: Contains all transaction logic and read/write wrappers.
*   `RefreshManager.m`: Manages the sequence of fetching, parsing, and updating notifications.

---