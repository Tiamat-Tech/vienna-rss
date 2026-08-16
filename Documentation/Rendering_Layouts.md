# Rendering & Layouts

Vienna implements two primary, distinct content consumption experiences — the **Split Layout** and the **Unified Layout** — to cater to different user reading styles and use cases. 📐

## Display Modes

| Feature | Split Layout (Scanning Mode) | Unified Layout (Focused Mode) |
| :--- | :--- | :--- |
| **Primary Goal** | Rapid browsing efficiency | Deep reading immersion |
| **Structure** | Dual-pane view (Concurrent scan/view) | Maximum screen real estate for content |
| **Context** | Persistent navigation visibility | Minimal navigational chrome; focused on body |
| **Best For** | Skimming articles while moving quickly | Studying a single article in detail |

### 1. Split Layout
The Split Layout is optimized for rapid browsing efficiency. It presents a dual-pane view structure where users can concurrently scan list item summaries on one side while viewing detailed previews or source content in the other. This mode maintains persistent context as the user moves through records without losing visibility of navigation elements. The two panes can be stacked horizontally or vertically.

### 2. Unified Layout
The Unified Layout is engineered for deep reading immersion. It maximizes screen real estate dedicated solely to the article's body, aiming for a distraction-free experience by minimizing navigational chrome and maximizing readability cues. Transitions are designed to feel seamless as the user moves from one complete document view to the next.

## WebKit Integration & Content Conversion
Both layout modes depend heavily on the underlying **WebKit Engine** but manage content presentation through different logic pipelines:

1.  **Article Converter:** This is an abstraction layer. It uses data sourced from the feed structure, *not* raw HTML, to generate a clean reading stream. The converter's goal is to use these tagged elements free of Web's noise (headers, sidebars, advertisements) to intelligently reconstruct a core narrative flow, through a custom HTML template and associated CSS styling. The content and tags of these elements are defined by `Article+Tag`.
2.  **Browser Original Mode:** An alternative behavior for users who want total fidelity. This embeds the `WKWebView` directly, allowing users to navigate and view content exactly as it appears on the original source website (including its complex CSS/JS rendering).
3.  **Visual Feedback:** Standardized indicators are used across all views to provide explicit visual feedback during asynchronous processes like content fetching or title changes, ensuring predictable user interaction patterns.

---
*End of Rendering & Layouts Documentation*