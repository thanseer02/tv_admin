import { ApiService } from './api.js';

// Application State
let urlsData = [];
let pendingDeleteId = null;

// DOM Elements
const authView = document.getElementById('authView');
const dashboardView = document.getElementById('dashboardView');
const loginForm = document.getElementById('loginForm');
const loginUsername = document.getElementById('loginUsername');
const loginPassword = document.getElementById('loginPassword');
const loginBtn = document.getElementById('loginBtn');
const logoutBtn = document.getElementById('logoutBtn');

const userDisplayName = document.getElementById('userDisplayName');
const userRole = document.getElementById('userRole');
const userAvatar = document.getElementById('userAvatar');

const statTotalUrls = document.getElementById('statTotalUrls');
const statActiveUrls = document.getElementById('statActiveUrls');
const statInactiveUrls = document.getElementById('statInactiveUrls');

const searchInput = document.getElementById('searchInput');
const categoryFilter = document.getElementById('categoryFilter');
const statusFilter = document.getElementById('statusFilter');

const urlTableBody = document.getElementById('urlTableBody');
const emptyState = document.getElementById('emptyState');
const openAddModalBtn = document.getElementById('openAddModalBtn');
const emptyStateAddBtn = document.getElementById('emptyStateAddBtn');

// Modals
const urlModal = document.getElementById('urlModal');
const urlForm = document.getElementById('urlForm');
const modalTitle = document.getElementById('modalTitle');
const closeModalBtn = document.getElementById('closeModalBtn');
const cancelModalBtn = document.getElementById('cancelModalBtn');
const editUrlId = document.getElementById('editUrlId');
const urlTitle = document.getElementById('urlTitle');
const urlAddress = document.getElementById('urlAddress');
const urlCategory = document.getElementById('urlCategory');
const urlStatus = document.getElementById('urlStatus');
const urlRefresh = document.getElementById('urlRefresh');
const urlNotes = document.getElementById('urlNotes');

const deleteModal = document.getElementById('deleteModal');
const closeDeleteModalBtn = document.getElementById('closeDeleteModalBtn');
const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
const deleteItemTitle = document.getElementById('deleteItemTitle');

const toastContainer = document.getElementById('toastContainer');

// Utility: Toast notification
function showToast(message, type = 'info') {
  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.innerHTML = `
    <span>${message}</span>
  `;
  toastContainer.appendChild(toast);
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(10px)';
    setTimeout(() => toast.remove(), 250);
  }, 3200);
}

// Utility: Date formatter
function formatDate(isoString) {
  if (!isoString) return '-';
  const d = new Date(isoString);
  return d.toLocaleDateString(undefined, {
    month: 'short',
    day: 'numeric',
    year: 'numeric'
  }) + ' ' + d.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

// Authentication Check & View Switcher
function checkAuth() {
  if (ApiService.isAuthenticated()) {
    const user = ApiService.getCurrentUser() || { name: 'Admin', username: 'admin', role: 'Administrator' };
    userDisplayName.textContent = user.name || user.username;
    userRole.textContent = user.role || 'Administrator';
    userAvatar.textContent = (user.name || user.username || 'A').charAt(0).toUpperCase();

    authView.classList.add('hidden');
    dashboardView.classList.remove('hidden');
    loadUrls();
  } else {
    authView.classList.remove('hidden');
    dashboardView.classList.add('hidden');
  }
}

// Load URLs
async function loadUrls() {
  try {
    urlsData = await ApiService.fetchUrls();
    renderTable();
    updateStats();
  } catch (err) {
    showToast(err.message || 'Error loading URLs', 'error');
  }
}

// Update KPI Stats
function updateStats() {
  statTotalUrls.textContent = urlsData.length;
  statActiveUrls.textContent = urlsData.filter(u => u.status === 'active').length;
  statInactiveUrls.textContent = urlsData.filter(u => u.status === 'inactive').length;
}

// Filter and Render Table
function renderTable() {
  const searchVal = searchInput.value.toLowerCase().trim();
  const catVal = categoryFilter.value;
  const statusVal = statusFilter.value;

  const filtered = urlsData.filter(item => {
    const matchSearch =
      (item.title && item.title.toLowerCase().includes(searchVal)) ||
      (item.url && item.url.toLowerCase().includes(searchVal)) ||
      (item.notes && item.notes.toLowerCase().includes(searchVal));

    const matchCategory = catVal === 'ALL' || item.category === catVal;
    const matchStatus = statusVal === 'ALL' || item.status === statusVal;

    return matchSearch && matchCategory && matchStatus;
  });

  urlTableBody.innerHTML = '';

  if (filtered.length === 0) {
    emptyState.classList.remove('hidden');
  } else {
    emptyState.classList.add('hidden');
    filtered.forEach(item => {
      const tr = document.createElement('tr');
      tr.innerHTML = `
        <td>
          <div class="cell-title">
            <span>${escapeHtml(item.title)}</span>
            <span class="cell-category">${escapeHtml(item.category || 'General')} ${item.refreshInterval > 0 ? `• ⟳ ${item.refreshInterval}s` : ''}</span>
          </div>
        </td>
        <td>
          <div class="cell-url" title="${escapeHtml(item.url)}">${escapeHtml(item.url)}</div>
        </td>
        <td>
          <span class="badge ${item.status === 'active' ? 'badge-active' : 'badge-inactive'}">
            <span class="badge-dot"></span>
            ${item.status === 'active' ? 'Active' : 'Inactive'}
          </span>
        </td>
        <td style="color: #94a3b8; font-size: 13px;">
          ${formatDate(item.updatedAt || item.createdAt)}
        </td>
        <td>
          <div class="actions-cell">
            <button class="icon-btn test-btn" title="Open Stream URL in new tab" data-url="${escapeHtml(item.url)}">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                <polyline points="15 3 21 3 21 9"></polyline>
                <line x1="10" y1="14" x2="21" y2="3"></line>
              </svg>
            </button>
            <button class="icon-btn edit-btn" title="Edit URL" data-id="${item.id}">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"></path>
              </svg>
            </button>
            <button class="icon-btn delete-btn" title="Delete URL" data-id="${item.id}" data-title="${escapeHtml(item.title)}">
              <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="3 6 5 6 21 6"></polyline>
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
              </svg>
            </button>
          </div>
        </td>
      `;
      urlTableBody.appendChild(tr);
    });
  }
}

function escapeHtml(text) {
  if (!text) return '';
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}

// Modal open/close handlers
function openAddModal() {
  modalTitle.textContent = 'Add New Stream URL';
  editUrlId.value = '';
  urlForm.reset();
  urlStatus.value = 'active';
  urlRefresh.value = 0;
  urlModal.classList.remove('hidden');
  urlTitle.focus();
}

function openEditModal(id) {
  const item = urlsData.find(u => u.id === id);
  if (!item) return;

  modalTitle.textContent = 'Update Stream URL';
  editUrlId.value = item.id;
  urlTitle.value = item.title || '';
  urlAddress.value = item.url || '';
  urlCategory.value = item.category || 'General';
  urlStatus.value = item.status || 'active';
  urlRefresh.value = item.refreshInterval || 0;
  urlNotes.value = item.notes || '';

  urlModal.classList.remove('hidden');
  urlTitle.focus();
}

function closeModal() {
  urlModal.classList.add('hidden');
}

function openDeleteModal(id, title) {
  pendingDeleteId = id;
  deleteItemTitle.textContent = title;
  deleteModal.classList.remove('hidden');
}

function closeDeleteModal() {
  pendingDeleteId = null;
  deleteModal.classList.add('hidden');
}

// Event Listeners: Authentication
loginForm.addEventListener('submit', async (e) => {
  e.preventDefault();
  const username = loginUsername.value.trim();
  const password = loginPassword.value;

  loginBtn.disabled = true;
  loginBtn.innerHTML = 'Signing in...';

  try {
    await ApiService.login(username, password);
    showToast(`Welcome back, ${username}!`, 'success');
    loginForm.reset();
    checkAuth();
  } catch (err) {
    showToast(err.message || 'Authentication error', 'error');
  } finally {
    loginBtn.disabled = false;
    loginBtn.innerHTML = `
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"></path>
        <polyline points="10 17 15 12 10 7"></polyline>
        <line x1="15" y1="12" x2="3" y2="12"></line>
      </svg>
      Sign In
    `;
  }
});

logoutBtn.addEventListener('click', async () => {
  await ApiService.logout();
  showToast('Logged out successfully', 'info');
  checkAuth();
});

// Event Listeners: Add / Edit Modal
openAddModalBtn.addEventListener('click', openAddModal);
emptyStateAddBtn.addEventListener('click', openAddModal);
closeModalBtn.addEventListener('click', closeModal);
cancelModalBtn.addEventListener('click', closeModal);

urlModal.addEventListener('click', (e) => {
  if (e.target === urlModal) closeModal();
});

// Form Submission (Add or Update)
urlForm.addEventListener('submit', async (e) => {
  e.preventDefault();

  const id = editUrlId.value;
  const payload = {
    title: urlTitle.value.trim(),
    url: urlAddress.value.trim(),
    category: urlCategory.value,
    status: urlStatus.value,
    refreshInterval: Number(urlRefresh.value) || 0,
    notes: urlNotes.value.trim(),
  };

  const saveBtn = document.getElementById('saveUrlBtn');
  saveBtn.disabled = true;
  saveBtn.textContent = 'Saving...';

  try {
    if (id) {
      // Update
      await ApiService.updateUrl(id, payload);
      showToast('URL updated successfully', 'success');
    } else {
      // Create / Add
      await ApiService.addUrl(payload);
      showToast('New URL added successfully', 'success');
    }
    closeModal();
    await loadUrls();
  } catch (err) {
    showToast(err.message || 'Failed to save URL', 'error');
  } finally {
    saveBtn.disabled = false;
    saveBtn.textContent = 'Save URL';
  }
});

// Event Listeners: Delete Modal
closeDeleteModalBtn.addEventListener('click', closeDeleteModal);
cancelDeleteBtn.addEventListener('click', closeDeleteModal);
deleteModal.addEventListener('click', (e) => {
  if (e.target === deleteModal) closeDeleteModal();
});

confirmDeleteBtn.addEventListener('click', async () => {
  if (!pendingDeleteId) return;

  confirmDeleteBtn.disabled = true;
  confirmDeleteBtn.textContent = 'Deleting...';

  try {
    await ApiService.deleteUrl(pendingDeleteId);
    showToast('URL removed successfully', 'success');
    closeDeleteModal();
    await loadUrls();
  } catch (err) {
    showToast(err.message || 'Failed to delete URL', 'error');
  } finally {
    confirmDeleteBtn.disabled = false;
    confirmDeleteBtn.textContent = 'Confirm Delete';
  }
});

// Table action buttons (Edit, Delete, Open Test)
urlTableBody.addEventListener('click', (e) => {
  const editBtn = e.target.closest('.edit-btn');
  if (editBtn) {
    const id = editBtn.dataset.id;
    openEditModal(id);
    return;
  }

  const delBtn = e.target.closest('.delete-btn');
  if (delBtn) {
    const id = delBtn.dataset.id;
    const title = delBtn.dataset.title;
    openDeleteModal(id, title);
    return;
  }

  const testBtn = e.target.closest('.test-btn');
  if (testBtn) {
    const url = testBtn.dataset.url;
    window.open(url, '_blank', 'noopener,noreferrer');
    return;
  }
});

// Search & Filter Listeners
searchInput.addEventListener('input', renderTable);
categoryFilter.addEventListener('change', renderTable);
statusFilter.addEventListener('change', renderTable);

// Keyboard Esc to close modals
window.addEventListener('keydown', (e) => {
  if (e.key === 'Escape') {
    closeModal();
    closeDeleteModal();
  }
});

// Initial boot
checkAuth();

