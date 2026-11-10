// API Service Configuration
// Once your backend APIs are ready, set `USE_MOCK_API = false` and update `API_BASE_URL`.

export const API_CONFIG = {
  USE_MOCK_API: true,
  BASE_URL: 'https://api.yourdomain.com/api/v1',
  ENDPOINTS: {
    LOGIN: '/auth/login',
    LOGOUT: '/auth/logout',
    GET_URLS: '/urls',
    ADD_URL: '/urls',
    UPDATE_URL: (id) => `/urls/${id}`,
    DELETE_URL: (id) => `/urls/${id}`,
  }
};

const STORAGE_KEYS = {
  AUTH_TOKEN: 'tv_admin_auth_token',
  AUTH_USER: 'tv_admin_auth_user',
  URL_ITEMS: 'tv_admin_urls_data',
};

// Initial mock data if empty
const DEFAULT_URLS = [
  {
    id: 'url_101',
    title: 'Live Sports Feed 1 (HD)',
    url: 'https://stream.example.com/live/sports-hd.m3u8',
    category: 'Sports',
    status: 'active',
    refreshInterval: 30,
    notes: 'Main stadium feed for lobby screens',
    createdAt: new Date(Date.now() - 86400000 * 3).toISOString(),
    updatedAt: new Date(Date.now() - 86400000 * 1).toISOString(),
  },
  {
    id: 'url_102',
    title: 'Company Dashboard & Metrics',
    url: 'https://metrics.internal.company.com/tv-display',
    category: 'Dashboard',
    status: 'active',
    refreshInterval: 60,
    notes: 'Displays real-time KPIs and system alerts',
    createdAt: new Date(Date.now() - 86400000 * 5).toISOString(),
    updatedAt: new Date(Date.now() - 86400000 * 2).toISOString(),
  },
  {
    id: 'url_103',
    title: 'Promotional Video Reel',
    url: 'https://cdn.example.com/assets/promo_loop_2026.mp4',
    category: 'Media',
    status: 'inactive',
    refreshInterval: 0,
    notes: 'Looping promotional video for customer waiting lounge',
    createdAt: new Date(Date.now() - 86400000 * 7).toISOString(),
    updatedAt: new Date(Date.now() - 86400000 * 4).toISOString(),
  },
  {
    id: 'url_104',
    title: 'World News Stream',
    url: 'https://news.example.com/global-channel/stream.m3u8',
    category: 'News',
    status: 'active',
    refreshInterval: 120,
    notes: 'Secondary channel for cafeteria display',
    createdAt: new Date(Date.now() - 86400000 * 10).toISOString(),
    updatedAt: new Date(Date.now() - 86400000 * 6).toISOString(),
  }
];

// Helper to simulate network latency
const delay = (ms = 400) => new Promise(resolve => setTimeout(resolve, ms));

export class ApiService {
  static getStoredUrls() {
    const raw = localStorage.getItem(STORAGE_KEYS.URL_ITEMS);
    if (!raw) {
      localStorage.setItem(STORAGE_KEYS.URL_ITEMS, JSON.stringify(DEFAULT_URLS));
      return [...DEFAULT_URLS];
    }
    try {
      return JSON.parse(raw);
    } catch {
      return [...DEFAULT_URLS];
    }
  }

  static saveStoredUrls(urls) {
    localStorage.setItem(STORAGE_KEYS.URL_ITEMS, JSON.stringify(urls));
  }

  static getAuthToken() {
    return localStorage.getItem(STORAGE_KEYS.AUTH_TOKEN);
  }

  static getCurrentUser() {
    const raw = localStorage.getItem(STORAGE_KEYS.AUTH_USER);
    return raw ? JSON.parse(raw) : null;
  }

  static isAuthenticated() {
    return !!this.getAuthToken();
  }

  // Authentication APIs
  static async login(username, password) {
    if (API_CONFIG.USE_MOCK_API) {
      await delay(500);
      // Demo credentials check (accepts admin/admin or any valid non-empty)
      if ((username === 'admin' && password === 'admin') || (username && password.length >= 4)) {
        const user = { username, role: 'Administrator', name: 'Super Admin', email: `${username}@tvadmin.io` };
        const token = 'mock_jwt_token_' + Math.random().toString(36).substring(2);
        localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, token);
        localStorage.setItem(STORAGE_KEYS.AUTH_USER, JSON.stringify(user));
        return { success: true, user, token };
      } else {
        throw new Error('Invalid credentials. (Hint: Try username: admin, password: admin)');
      }
    } else {
      // Real API integration
      const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.LOGIN}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password }),
      });
      if (!response.ok) {
        const error = await response.json().catch(() => ({ message: 'Login failed' }));
        throw new Error(error.message || 'Login failed');
      }
      const data = await response.json();
      localStorage.setItem(STORAGE_KEYS.AUTH_TOKEN, data.token);
      localStorage.setItem(STORAGE_KEYS.AUTH_USER, JSON.stringify(data.user));
      return data;
    }
  }

  static async logout() {
    if (!API_CONFIG.USE_MOCK_API) {
      try {
        await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.LOGOUT}`, {
          method: 'POST',
          headers: { 'Authorization': `Bearer ${this.getAuthToken()}` }
        });
      } catch (e) {
        console.warn('Logout API call failed:', e);
      }
    }
    localStorage.removeItem(STORAGE_KEYS.AUTH_TOKEN);
    localStorage.removeItem(STORAGE_KEYS.AUTH_USER);
    return { success: true };
  }

  // URL Management APIs
  static async fetchUrls() {
    if (API_CONFIG.USE_MOCK_API) {
      await delay(300);
      return this.getStoredUrls();
    } else {
      const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.GET_URLS}`, {
        headers: { 'Authorization': `Bearer ${this.getAuthToken()}` }
      });
      if (!response.ok) throw new Error('Failed to fetch URLs');
      return await response.json();
    }
  }

  static async addUrl(payload) {
    if (API_CONFIG.USE_MOCK_API) {
      await delay(400);
      const urls = this.getStoredUrls();
      const newEntry = {
        id: 'url_' + Date.now().toString(36),
        title: payload.title.trim(),
        url: payload.url.trim(),
        category: payload.category || 'General',
        status: payload.status || 'active',
        refreshInterval: Number(payload.refreshInterval) || 0,
        notes: payload.notes || '',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };
      urls.unshift(newEntry);
      this.saveStoredUrls(urls);
      return newEntry;
    } else {
      const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.ADD_URL}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.getAuthToken()}`
        },
        body: JSON.stringify(payload),
      });
      if (!response.ok) throw new Error('Failed to create URL entry');
      return await response.json();
    }
  }

  static async updateUrl(id, payload) {
    if (API_CONFIG.USE_MOCK_API) {
      await delay(400);
      const urls = this.getStoredUrls();
      const index = urls.findIndex(u => u.id === id);
      if (index === -1) throw new Error('URL entry not found');

      urls[index] = {
        ...urls[index],
        ...payload,
        updatedAt: new Date().toISOString()
      };
      this.saveStoredUrls(urls);
      return urls[index];
    } else {
      const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.UPDATE_URL(id)}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${this.getAuthToken()}`
        },
        body: JSON.stringify(payload),
      });
      if (!response.ok) throw new Error('Failed to update URL entry');
      return await response.json();
    }
  }

  static async deleteUrl(id) {
    if (API_CONFIG.USE_MOCK_API) {
      await delay(300);
      let urls = this.getStoredUrls();
      urls = urls.filter(u => u.id !== id);
      this.saveStoredUrls(urls);
      return { success: true, id };
    } else {
      const response = await fetch(`${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.DELETE_URL(id)}`, {
        method: 'DELETE',
        headers: { 'Authorization': `Bearer ${this.getAuthToken()}` }
      });
      if (!response.ok) throw new Error('Failed to delete URL entry');
      return await response.json();
    }
  }
}

