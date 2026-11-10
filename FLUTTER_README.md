# LinkDesk — Flutter Web Admin Portal

A professional, modern, responsive Flutter Web Admin Portal engineered for URL management and live stream routing.

---

## Architecture Overview
Built strictly following Flutter and Clean Architecture best practices:

```
tv_admin/
├── lib/
│   ├── main.dart                          # App Entrypoint, ThemeMode & Auth Router
│   ├── core/
│   │   └── theme/
│   │       └── app_theme.dart             # Modern Light & Dark Material 3 Themes
│   ├── models/
│   │   ├── url_item.dart                  # UrlItem, UrlEnvironment, UrlStatus models
│   │   └── user_model.dart                # User Session & JWT Token model
│   ├── services/
│   │   └── auth_service.dart              # Token management & session persistence
│   ├── repositories/
│   │   ├── auth_repository.dart           # Auth interface + MockAuthRepository
│   │   └── url_repository.dart            # Url CRUD interface + MockUrlRepository
│   ├── screens/
│   │   ├── login_screen.dart              # Login form UI with validation & forgot pw
│   │   └── dashboard_screen.dart          # Primary Dashboard, metrics, filters & state
│   └── widgets/
│       ├── top_nav_bar.dart               # Responsive navigation bar & profile
│       ├── stat_card.dart                 # KPI Metric cards
│       ├── filter_search_bar.dart         # Search & filter bar
│       ├── url_data_table.dart            # Desktop DataTable
│       ├── url_mobile_list.dart           # Responsive card list for mobile viewports
│       ├── url_badge.dart                 # Environment & Status badges
│       ├── url_form_dialog.dart           # Add / Edit URL modal dialog
│       ├── url_details_dialog.dart        # Full URL details view dialog
│       ├── delete_confirmation_dialog.dart# Safe deletion confirmation modal
│       ├── forgot_password_dialog.dart    # Forgot Password reset modal
│       └── state_widgets.dart             # Empty & Error states with action retry
├── web/
│   ├── index.html                         # Flutter Web runner
│   └── manifest.json
├── pubspec.yaml                           # Flutter dependencies & metadata
└── analysis_options.yaml                  # Flutter lints configuration
```

---

## Features Implemented
1. **Authentication:**
   - Email & password validation.
   - Show / Hide password toggle.
   - "Remember me" checkbox.
   - "Forgot password" modal dialog.
   - Token & session management in `AuthService`.
2. **Dashboard & Metrics:**
   - Total URLs count.
   - Active Streams count.
   - Inactive / Paused count.
3. **URL CRUD & Operations:**
   - **Add URL:** modal with name, address, description, environment, and status.
   - **Edit URL:** pre-populated update dialog.
   - **Delete URL:** confirmation modal with item name highlight.
   - **Details Modal:** complete read-only inspect view with quick copy.
   - **Search:** live filter by name, address, or description.
   - **Filters:** environment (Production, Staging, Testing, Other) & status (Active, Inactive).
   - **One-click Copy URL** with toast confirmation.
   - **Quick Activate / Deactivate** toggle.
4. **Responsive SaaS UI:**
   - Auto-switches between desktop `DataTable` and mobile `UrlMobileList`.
   - Dark mode & Light mode switcher in the top bar.
   - Full empty states & error states with retry buttons.

---

## Running with Flutter
```bash
flutter pub get
flutter run -d chrome
```

## Existing HTML/JS Portal
The existing standalone web version (`index.html`, `app.js`, `styles.css`) is completely preserved and still accessible via `python3 -m http.server 3000`.

