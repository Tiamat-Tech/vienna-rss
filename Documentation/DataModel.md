# Data Model & Persistence

Vienna relies on a persistent database layer centered around **SQLite** (accessed through **FMDB**) as its Single Source of Truth (SSoT). This store is responsible for maintaining all historical, permanent data regarding feeds, articles, and folder structures.

## Core Entities

### 📂 Folders (`Folder`)
Folders are the primary organizational units within Vienna. The system supports several distinct types:

*   **RSS (Subscription) Folders:** Standard containers holding external feed URLs (RSS, Atom, JSON Feed). Articles in these folders are populated via periodic background refresh cycles managed by `RefreshManager`.
*   **OpenReader Sync Folders:** Containers used for content synchronized with cloud services like OpenReader API. These facilitate cross-device data synchronization.
*   **Smart Folder Filters:** Dynamic grouping containers. Instead of needing direct feed URLs, articles appear here based on logical criteria defined by the user (see the [Smart Folders guide](./SmartFolders.md)). They are powerful for abstract organization.
*   **Group Folders:** Purely organizational wrappers. These folders group other folder types together in the display tree but contain no unique content sources themselves.

**System-Managed Folders:** The application automatically maintains system directories including `Root` (the top-level container), `Trash`, and temporary result sets for filtering operations.

### 📰 Articles (`Article`)
Articles represent individual pieces of consumed content stored within a folder context. Each article instance maintains the following key data points:

*   **Metadata:** Title, Source URL, Publication Date, Last Updated Timestamp, Author, etc.
*   **Parsed Content:** The cleaned, rendered HTML or formatted text used for display in Article View.
*   **Status Flags:** Critical flags such as `unread_status`, `flagged` status (favorite / to be re-read), `revised` or `deleted` statuses.

### 🧩 Criteria & Predicates
This layer defines the logic that dictates folder membership. A criteria set allows users to define complex groupings using standard boolean operators (`AND`, `OR`, `NOT`). This structured approach enables powerful, generalized filtering for Smart Folders, ensuring consistency across all dynamic views.

## Entity Relationships Summary

- **Portfolio / Folder** (Parent) contains many → **Articles** (Children).
- **Smart Folder** acts as a "Virtual Parent," where the articles are derived from the entire database but filtered by **Criteria**.
- **Feeds** serve as the data source for **RSS Folders**, providing the continuous input that populates the article pool.
---
*End of Data Model and Persistence Documentation*