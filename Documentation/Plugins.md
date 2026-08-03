# 🔌 The Plugin System

In Vienna, plugins serve as **behavioral adapters**—they allow the application to be flexible and user-friendly by extending functionality without requiring modifications to the core engine code. ✨

The system is organized into four categories, each addressing a specific functional need:

### 1. Feed Source Plugins
These modules are responsible for normalizing data inputs. They transform raw or concise identifiers (like a website ID) into fully functional URLs required by the feed reader. This abstracts away complex URL generation logic from the user.

*   **Example:** Automatically translating a `wordpress.com` site identifier into its dedicated RSS/Atom endpoint.

### 2. Sync Server Plugins
This category streamlines connectivity to remote data sources. These plugins standardize the presentation and authentication process when connecting to external synchronization services (specifically OpenReader servers), reducing configuration complexity for the end-user.

### 3. Sharing Plugins
Sharing plugins define structured methods for exporting content from Vienna. They dictate how an article or selected segment of a webpage can be transferred to another application (e.g. blogging software) or posted to a specific web service, ensuring clean and predictable output formatting.
*   **Purpose:** Define the output format and target destination for exported data.
*   **Example:** Formatting an article as a clean text block for Facebook, or as rich URL with metadata for Mastodon.

### 4. Search Plugins
These modules improve discoverability by adding general web search capabilities to content consumption. A configured search plugin allows users to trigger a tab browser search, enabling quick context-switching between an article and a broader exploration.

---
*End of Plugin System Documentation*
