# TV Stream Admin Portal (UI)

A modern, responsive Admin Portal designed to manage streaming URLs and endpoints for TV displays.

## Features Built
- **Authentication View:** Clean login UI with state persistence (session tokens) and demo credentials.
- **Add URL:** Modal dialog to add stream/display URLs with category, title, reload interval, and notes.
- **Update URL:** Edit modal populated with existing entry data.
- **Delete URL:** Confirmation modal to prevent accidental removal.
- **Preview / Test Link:** Quick launch stream URL in a new tab.
- **Search & Filter:** Real-time filter by title, URL text, category, and status (active/inactive).
- **KPI Metrics:** Live counts for total, active, and inactive stream endpoints.
- **API Ready Architecture:** Built with an isolated [`api.js`](file:///Users/tanseer/Documents/oopsss/tv_app/tv_admin/api.js) service layer.

---

## Quick Start (Run Locally)

You can serve this portal with any static file server:

### Option 1: Python
```bash
python3 -m http.server 3000
```
Then open `http://localhost:3000` in your browser.

### Option 2: VS Code / IDE Live Server
Right-click `index.html` and choose **Open with Live Server**.

---

## Demo Login Credentials
- **Username:** `admin`
- **Password:** `admin` (or any password >= 4 characters)

---

## Connecting Your Backend API Later

Open [`api.js`](file:///Users/tanseer/Documents/oopsss/tv_app/tv_admin/api.js) and update the configuration object:

```javascript
export const API_CONFIG = {
  USE_MOCK_API: false, // <-- Switch this to false
  BASE_URL: 'https://api.yourdomain.com/api/v1', // <-- Enter your backend URL
  ENDPOINTS: {
    LOGIN: '/auth/login',
    LOGOUT: '/auth/logout',
    GET_URLS: '/urls',
    ADD_URL: '/urls',
    UPDATE_URL: (id) => `/urls/${id}`,
    DELETE_URL: (id) => `/urls/${id}`,
  }
};
```

All methods (`fetchUrls`, `addUrl`, `updateUrl`, `deleteUrl`, `login`, `logout`) are already implemented with standard `fetch()` calls and `Bearer` authorization headers.

# tv_admin
# tv_admin
