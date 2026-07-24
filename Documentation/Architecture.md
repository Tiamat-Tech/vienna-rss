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

## ⚙️ ARCHITECTURE.md - Technical Blueprint (Refined)

**1. Overall Architecture Pattern:**
The application follows a hybrid **Model-View-Controller / Observer** pattern. Core logic is implemented in Objective-C, while the UI layer primarily uses Swift. The bridge between these worlds is `NSNotificationCenter`, which enables an event-driven flow where database updates automatically trigger view refreshes.

**2. Persistence & Data Model (The Single Source of Truth):**
*   **Database Management:** Managed via a singleton `Database` class using FMDB/SQLite. This handles queries for Folders, Articles, and Fields.
*   **Folder Types:** 
    *   *RSS Folders:* Standard feeds with subscription URLs.
    *   *Open Reader Folders:* Remote-based folders requiring additional state management.
    *   *Smart Folders:* Predicate-based filters that dynamically group articles based on queries (`CriteriaTree`).
*   **Data Integrity:** Mandatory transactions ensure atomic write operations (e.g., batch updates to folder counts).

**3. Data Flow Lifecycle: The Core Feed Loop:**
1.  **Trigger:** A time-based, manual, or recursive update triggers the **`RefreshManager`**.
2.  **Acquisition & Concurrency:** `RefreshManager` manages an `NSOperationQueue`. It parses raw data using specialized parsers in `Article list/Article content/`, handling network complexity (301 redirects, auth credentials) independently of the UI.
3.  **Persistence Integration:** Successful articles are batched and written atomically to SQLite. This includes updating aggregated metadata like `unread_count`.
4.  **Notification (Decoupling):** Upon completion of a transaction, an explicit `NSNotification` is posted. **This mechanism allows the Data Layer to speak to the View Layer without knowing its structure.**

**4. UI/UX Layer Interaction (The Presentation Flow):**
*   **Active Subscribers:** The UI components (`ArticleList`, `FolderView`) are observers. They listen for notifications like `MA_Notify_FoldersUpdated` or `VNADatabaseWillDeleteFolderNotification`.
*   **Component Breakdown:**
    *   **Folder List Pane:** A recursive tree structure (`FoldersTree`) allowing for nested organization.
    *   **Article List Pane:** Supports multiple layout modes: *Split Layout*, *Unified Layout*. 
    *   **Browser Module:** A dedicated `WKWebView` based explorer for deep dives into individual articles.

**5. Key Code Modules for Quick Reference:**
*   `Application/ViennaApp`: Application lifecycle and top-level setup.
*   `Database.h/.m`: The query engine, transaction logic, and folder tree management.
*   `Fetching/RefreshManager.m`: The network orchestration engine (HTTP requests, concurrency, activity logging).
*   `Main window/...`: Swift-based UI components for Navigation, Toolbars, and specialized viewing layouts.

---
