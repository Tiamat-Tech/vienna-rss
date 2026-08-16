# Data Flow Management in Vienna RSS

This document outlines the canonical flow of operational data in Vienna, detailing how external RSS/Atom/JSON feeds are fetched and transformed into articles within the application's central store, and afterwards consumed by views.

## 🔄 Core Data Pipeline: Fetching a Feed Item
The general flow for loading content involves four main stages: Discovery, Fetching, Parsing, and Caching.

1.  **Discovery (Input):** Data is expected to come from user-provided initial feed URL(s) or sourced via a managed server connection (Open Reader API). An update request — which can be time-based, manual, or recursive — triggers the `RefreshManager`. The system identifies all configured RSS/Atom/JSON sources for the requested scope.
2.  **Fetching:** Dedicated networking components are responsible for performing HTTP requests to the source URLs. Vienna handles concurrency (via `NSOperationQueue`) and manages rate-limiting behaviors of external services, as well as network complexities like 301 redirects and authentication sessions. This stage output is raw, unstructured XML or JSON payload objects specific to each feed format.
3.  **Parsing & Transformation:** The raw results (XML/JSON) are passed through a set of structured parsers (e.g., RSSFeed parser, AtomFeed parser). This stage transforms raw web data into the single, canonical internal data model (`Article`), and attempts to normalize fields (e.g. alway resolving `date published` regardless of feed). Error handling here must be robust to prevent application crashes or information loss from malformed remote feeds.
4.  **Caching and Client Consumption:** Validated articles are batched and written atomically to the SQLite database. This includes updating aggregated metadata like `unread_count`. Upon completion of a transaction, an explicit `NSNotification` is posted. ⭐ **This mechanism allows the Data Layer to communicate changes to the View Layer without knowing its internal structure.** View controllers/view models are in charge of observing the notification center events they are interested in.

## 💾 Caching Strategy: Optimizing Performance
Due to the nature of external network calls and disk I/O, caching is critical for performance and reliability. Vienna employs a multi-layered cache structure:

### 1. Network Cache (Short-Term / Source)
*   **Goal:** Prevent excessive requests to source servers for the same feed URL.
*   **Mechanism:** The system tracks last update timestamps and utilizes HTTP status code 304 responses. When syncing OpenReader data, the system tracks high-water marks (e.g., last modified timestamps for entire feeds or individual articles) to efficiently determine *what has changed* since the last successful sync without re-downloading everything. Only content that exceeds this timestamp is flagged for download and merging into the local persistent cache.

### 2. Local Persistence Cache (Long-Term / Client)
*   **Goal:** Store the primary read model of feed articles so they can be viewed offline, even when connectivity is poor or restricted.
*   **Mechanism:** Uses persistent local storage around SQLite to store all primary content. This establishes SQLite as the **Single Source of Truth (SSoT)** for data persistence and history. It stores a comprehensive `Article` record for every article seen, along with metadata like last-read status and update history.

### 3. Volatile Memory Cache (Medium-Term / Client)
*   **Goal:** Ensure UI components react instantly without incurring excessive disk I/O overhead on every view change.
*   **Mechanism:** The application maintains in-memory summaries of folders, as well as local caches intended to reflect the 'working set' of articles. When possible, only article metadata is retained in memory. This high-speed layer allows for fast UI interactions and gracefully falls back to reading from disk when content is needed after being purged from memory (cf. `Folder.m`).

⚠️ **Architectural Warning: Cache/SSoT Contract**
The SQLite database remains the Single Source of Truth (SSoT). The volatile working cache acts as a high-speed presentation layer, holding temporary read/write status indicators until the next full `RefreshManager` cycle flushes its contents to the SSoT. Any future changes to the `RefreshManager` must reconcile data flow between the permanent SQLite SSoT commit point and the transient, in-memory state used for UI observation.

Accesses to the **SQLite** database must always pass through the functions of a singleton `Database` object which itself uses **FMDB**.

---
*End of Data Flow Documentation*