# Smart Folders & Criteria

Smart Folders are a core organizational feature in Vienna, allowing users to group articles dynamically based on predefined logic rather than being limited by static feed sources.

## Architecture and Functionality
The system utilizes a nested **CriteriaTree** structure. Unlike simple linear filters, this design permits highly complex logical groupings using standard boolean operators (`AND`, `OR`, `NOT`). This allows for the creation of "recipes" that define exactly which articles belong in a folder at any given moment.

### How it Works
When a Smart Folder is accessed or updated:
1.  **Trigger:** A navigation request or a write/update event triggers an evaluation check against all registered criteria for that specific folder.
2.  **Evaluation Source:** The logic queries the database, comparing metadata (e.g., `read_status`, `publication_date`) and content properties (e.g., substring matching, tag presence) against the rules.
3.  **Dynamic Update:** Content is reflected in real-time as soon as an article meets all requirements—ensuring that the folder acts as a "live view" of your data.

### Examples of Logical Nesting
To illustrate how criteria work together:

*   **Basic (OR):** `Published < 7 days ago` OR `Flagged = True`
*   **Complex (AND/NOT):** (`Published < 30 days ago` AND `Content contains "Space"`) AND NOT (`Source = "Mars Rover Feed"`)

### Key Use Cases
Smart Folders move beyond simple source linking to enable high-level organizational filtering:

*   **Metadata Filtering:** Creating dynamic views like *"All unread articles from this morning"* or *"Articles specifically flagged as Favorites."*
*   **Content Logic:** Deep-diving into themes (e.g., *“Every article mentioning 'AI' that does NOT contain the word 'Robotics'”*).

---
*End of Smart Folder Documentation*