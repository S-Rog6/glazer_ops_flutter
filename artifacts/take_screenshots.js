/**
 * GlazerOps UI Screenshot Script
 *
 * Renders accurate HTML mockups of each screen using the app's design tokens,
 * then captures screenshots at mobile viewport (412×915) with Playwright.
 *
 * Screens captured:
 *   home.png        – Dashboard (Today's Jobs + Pinned)
 *   jobs.png        – Jobs list with all mock jobs
 *   job_details.png – Tampa Highrise job details (Overview tab)
 *   settings.png    – Settings / Preferences
 */

const { chromium } = require('playwright');
const path = require('path');
const fs = require('fs');

// ── Design tokens (from lib/core/constants/app_colors.dart + app_theme.dart) ──
const DARK = {
  bg: '#0A0A0E',
  surface: '#111318',
  surfaceRaised: '#191C25',
  border: '#262B36',
  primary: '#E82530',
  primaryContainer: '#480008',
  secondary: '#5C626F',
  onSurface: '#E8EBF2',
  onSurfaceVariant: '#B0B6C2',
  appBarBg: '#191C25',
  cardBg: '#191C25',
  navBg: '#191C25',
  navSelectedColor: '#E82530',
  navUnselectedColor: '#B0B6C2',
};

const VIEWPORT = { width: 412, height: 915 };
const OUT_DIR = path.join(__dirname, 'screenshots');

// ── Shared CSS ─────────────────────────────────────────────────────────────────
function baseCSS() {
  return `
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Roboto', 'Segoe UI', Arial, sans-serif;
      background: ${DARK.bg};
      color: ${DARK.onSurface};
      width: ${VIEWPORT.width}px;
      min-height: ${VIEWPORT.height}px;
      overflow-x: hidden;
    }
    /* AppBar */
    .app-bar {
      background: ${DARK.appBarBg};
      height: 56px;
      display: flex;
      align-items: center;
      padding: 0 16px;
      border-bottom: 1px solid ${DARK.border};
    }
    .app-bar-title {
      font-size: 20px;
      font-weight: 700;
      letter-spacing: 0.2px;
      color: ${DARK.onSurface};
    }
    .app-bar-back {
      color: ${DARK.onSurface};
      font-size: 22px;
      margin-right: 12px;
      cursor: pointer;
    }
    /* Bottom Navigation */
    .bottom-nav {
      position: fixed;
      bottom: 0; left: 0; right: 0;
      background: ${DARK.navBg};
      border-top: 1px solid ${DARK.border};
    }
    .nav-strip {
      background: linear-gradient(to right, #1E2229, #2b0e11);
      padding: 4px 0;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .nav-logo {
      font-size: 11px;
      font-weight: 800;
      color: #fff;
      letter-spacing: 1.5px;
      text-transform: uppercase;
    }
    .nav-items {
      display: flex;
      justify-content: space-around;
      padding: 4px 0 2px;
    }
    .nav-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 2px;
      flex: 1;
      padding: 4px 0;
      color: ${DARK.navUnselectedColor};
      font-size: 10px;
      font-weight: 600;
    }
    .nav-item.active { color: ${DARK.primary}; }
    .nav-item .nav-icon { font-size: 20px; line-height: 1; }
    /* Content area */
    .content {
      padding: 8px 8px 80px;
      background: linear-gradient(135deg, #120508, ${DARK.bg} 60%, #0d0f14);
      min-height: calc(${VIEWPORT.height}px - 56px);
    }
    /* Panel card */
    .panel {
      background: ${DARK.surface};
      border: 1px solid ${DARK.border};
      border-radius: 16px;
      padding: 16px;
      margin-bottom: 16px;
      box-shadow: 0 8px 16px rgba(0,0,0,0.16);
    }
    .panel-title {
      font-size: 20px;
      font-weight: 800;
      letter-spacing: -0.2px;
      color: ${DARK.onSurface};
      margin-bottom: 12px;
    }
    /* Filter row */
    .filter-row {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-bottom: 12px;
    }
    .search-field {
      background: ${DARK.surfaceRaised};
      border: 1px solid ${DARK.border};
      border-radius: 8px;
      padding: 10px 12px 10px 36px;
      color: ${DARK.onSurface};
      font-size: 13px;
      width: 220px;
      position: relative;
    }
    .search-wrap { position: relative; }
    .search-wrap::before {
      content: '🔍';
      position: absolute; left: 10px; top: 50%; transform: translateY(-50%);
      font-size: 13px;
    }
    .status-field {
      background: ${DARK.surfaceRaised};
      border: 1px solid ${DARK.border};
      border-radius: 8px;
      padding: 10px 12px;
      color: ${DARK.onSurface};
      font-size: 13px;
      width: 140px;
    }
    .filter-count {
      font-size: 12px;
      font-weight: 600;
      color: ${DARK.onSurface};
      display: flex;
      align-items: center;
    }
    /* Job card */
    .job-card {
      background: ${DARK.cardBg};
      border: 1px solid ${DARK.border};
      border-radius: 16px;
      margin-bottom: 12px;
      overflow: hidden;
      position: relative;
    }
    .job-card-bar {
      position: absolute;
      left: 0; top: 0; bottom: 0;
      width: 7px;
      border-radius: 16px 0 0 16px;
    }
    .job-card-body { padding: 16px 16px 14px 22px; }
    .job-name {
      font-size: 20px;
      font-weight: 800;
      color: ${DARK.onSurface};
      line-height: 1.05;
      margin-bottom: 10px;
    }
    .pill-row { display: flex; flex-wrap: wrap; gap: 8px; margin-bottom: 10px; }
    .pill {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      border-radius: 999px;
      padding: 5px 14px;
      font-size: 12px;
      font-weight: 600;
      border: 1px solid;
    }
    .pill-meta {
      background: rgba(92,98,111,0.14);
      border-color: ${DARK.border};
      color: ${DARK.onSurface};
    }
    .pill-open {
      background: rgba(232,37,48,0.18);
      border-color: rgba(232,37,48,0.42);
      color: ${DARK.primary};
    }
    .pill-scheduled {
      background: rgba(92,98,111,0.18);
      border-color: rgba(92,98,111,0.42);
      color: #8C929F;
    }
    .pill-completed {
      background: rgba(107,122,138,0.18);
      border-color: rgba(107,122,138,0.42);
      color: #6B7A8A;
    }
    .pill-progress {
      background: rgba(112,144,168,0.18);
      border-color: rgba(112,144,168,0.42);
      color: #7090A8;
    }
    .card-actions { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 12px; }
    .btn-filled {
      background: ${DARK.primary};
      color: #fff;
      border: none;
      border-radius: 12px;
      padding: 10px 16px;
      font-size: 12px;
      font-weight: 700;
      display: flex;
      align-items: center;
      gap: 5px;
    }
    .btn-outlined {
      background: transparent;
      color: ${DARK.primary};
      border: 1px solid ${DARK.border};
      border-radius: 12px;
      padding: 10px 14px;
      font-size: 12px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 5px;
    }
    .panel-actions {
      display: flex;
      gap: 8px;
      margin-bottom: 12px;
      flex-wrap: wrap;
    }
    /* Address panel */
    .address-panel {
      background: rgba(232,37,48,0.12);
      border: 1px solid ${DARK.border};
      border-radius: 12px;
      padding: 12px;
      text-align: right;
      margin-top: 8px;
    }
    .address-label { font-size: 11px; color: ${DARK.onSurfaceVariant}; font-weight: 600; }
    .address-value { font-size: 15px; font-weight: 700; color: ${DARK.onSurface}; }
    /* Divider */
    .divider { border: none; border-top: 1px solid ${DARK.border}; margin: 0; }
  `;
}

// ── Helper: job card HTML ──────────────────────────────────────────────────────
function jobCardHTML(job) {
  const barColors = {
    'Open': `background: linear-gradient(to bottom, ${DARK.primary}, ${DARK.secondary})`,
    'Scheduled': `background: linear-gradient(to bottom, ${DARK.secondary}, #8C929F)`,
    'Completed': `background: linear-gradient(to bottom, #6B7A8A, ${DARK.secondary})`,
    'In Progress': `background: linear-gradient(to bottom, #7090A8, ${DARK.secondary})`,
  };
  const pillClasses = {
    'Open': 'pill-open',
    'Scheduled': 'pill-scheduled',
    'Completed': 'pill-completed',
    'In Progress': 'pill-progress',
  };

  const barStyle = barColors[job.status] || barColors['Open'];
  const pillClass = pillClasses[job.status] || 'pill-open';

  return `
    <div class="job-card">
      <div class="job-card-bar" style="${barStyle}"></div>
      <div class="job-card-body">
        <div class="job-name">${job.jobName}</div>
        <div class="pill-row">
          <span class="pill pill-meta">🏷 PO ${job.poNumber.replace('PO-', '')}</span>
          <span class="pill ${pillClass}">${job.status}</span>
        </div>
        <div class="address-panel">
          <div class="address-label">📍 Address</div>
          <div class="address-value">${job.siteId}</div>
        </div>
        <div class="card-actions">
          <button class="btn-filled">↗ Open Job</button>
          <button class="btn-outlined">📌 Pin</button>
          <button class="btn-outlined">📝 Add Note</button>
        </div>
      </div>
    </div>
  `;
}

// ── Screen: Dashboard ──────────────────────────────────────────────────────────
function dashboardHTML() {
  const todayJob = {
    jobName: 'Civic Center Lobby',
    poNumber: 'PO-33445',
    siteId: 'Civic Center',
    status: 'In Progress',
  };
  const pinnedJobs = [
    { jobName: 'Tampa Highrise', poNumber: 'PO-12345', siteId: 'Downtown Tower', status: 'Open' },
    { jobName: 'Airport Retrofit', poNumber: 'PO-24680', siteId: 'Terminal B', status: 'Open' },
  ];

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>GlazerOps – Dashboard</title>
  <style>${baseCSS()}</style>
</head>
<body>
  <div class="app-bar">
    <span class="app-bar-title">Dashboard</span>
  </div>
  <div class="content">
    <div class="panel">
      <div class="panel-title">Today's jobs</div>
      ${jobCardHTML(todayJob)}
    </div>
    <hr class="divider" style="margin-bottom:16px;">
    <div class="panel">
      <div class="panel-title">Pinned</div>
      ${pinnedJobs.map(jobCardHTML).join('')}
    </div>
  </div>
  <div class="bottom-nav">
    <div class="nav-strip">
      <span class="nav-logo">GlazerOps</span>
    </div>
    <div class="nav-items">
      <div class="nav-item active">
        <span class="nav-icon">⬛</span>
        <span>Dashboard</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">💼</span>
        <span>Jobs</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">📅</span>
        <span>Schedule</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">👥</span>
        <span>Contacts</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">📝</span>
        <span>Notes</span>
      </div>
    </div>
  </div>
</body>
</html>`;
}

// ── Screen: Jobs List ──────────────────────────────────────────────────────────
function jobsHTML() {
  const jobs = [
    { jobName: 'Tampa Highrise', poNumber: 'PO-12345', siteId: 'Downtown Tower', status: 'Open' },
    { jobName: 'Hospital Install', poNumber: 'PO-67890', siteId: 'General Hospital', status: 'Scheduled' },
    { jobName: 'Airport Retrofit', poNumber: 'PO-24680', siteId: 'Terminal B', status: 'Open' },
    { jobName: 'University Annex', poNumber: 'PO-11223', siteId: 'North Campus', status: 'Completed' },
    { jobName: 'Civic Center Lobby', poNumber: 'PO-33445', siteId: 'Civic Center', status: 'In Progress' },
  ];

  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>GlazerOps – Jobs</title>
  <style>${baseCSS()}</style>
</head>
<body>
  <div class="app-bar">
    <span class="app-bar-title">Jobs</span>
  </div>
  <div class="content">
    <div class="panel">
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
        <div class="panel-title" style="margin-bottom:0;">Job Display Area</div>
      </div>
      <div class="panel-actions">
        <button class="btn-filled">≡ Filters</button>
        <button class="btn-filled">+ New Job</button>
      </div>
      <div class="filter-row">
        <div class="search-wrap">
          <input class="search-field" type="text" placeholder="Search by job name, PO, or site">
        </div>
        <div class="status-field" style="display:flex;align-items:center;justify-content:space-between;">
          <span style="font-size:12px;color:${DARK.onSurfaceVariant};">Status</span>
          <span style="font-size:13px;">All ▾</span>
        </div>
      </div>
      <div class="filter-count" style="margin-bottom:12px;">5 of 5 jobs</div>
      ${jobs.map(jobCardHTML).join('')}
    </div>
  </div>
  <div class="bottom-nav">
    <div class="nav-strip">
      <span class="nav-logo">GlazerOps</span>
    </div>
    <div class="nav-items">
      <div class="nav-item">
        <span class="nav-icon">⬛</span>
        <span>Dashboard</span>
      </div>
      <div class="nav-item active">
        <span class="nav-icon">💼</span>
        <span>Jobs</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">📅</span>
        <span>Schedule</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">👥</span>
        <span>Contacts</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">📝</span>
        <span>Notes</span>
      </div>
    </div>
  </div>
</body>
</html>`;
}

// ── Screen: Job Details ────────────────────────────────────────────────────────
function jobDetailsHTML() {
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>GlazerOps – Tampa Highrise</title>
  <style>
    ${baseCSS()}
    .tab-bar {
      display: flex;
      overflow-x: auto;
      background: ${DARK.appBarBg};
      border-bottom: 1px solid ${DARK.border};
      gap: 0;
      scrollbar-width: none;
    }
    .tab-bar::-webkit-scrollbar { display: none; }
    .tab {
      padding: 12px 16px;
      font-size: 13px;
      font-weight: 600;
      color: ${DARK.onSurfaceVariant};
      white-space: nowrap;
      border-bottom: 2px solid transparent;
      cursor: pointer;
    }
    .tab.active {
      color: ${DARK.primary};
      border-bottom-color: ${DARK.primary};
    }
    .section-title {
      font-size: 13px;
      font-weight: 700;
      color: ${DARK.onSurfaceVariant};
      text-transform: uppercase;
      letter-spacing: 0.8px;
      margin-bottom: 8px;
      margin-top: 16px;
    }
    .info-row {
      display: flex;
      justify-content: space-between;
      padding: 10px 0;
      border-bottom: 1px solid ${DARK.border};
      font-size: 14px;
    }
    .info-label { color: ${DARK.onSurfaceVariant}; font-weight: 600; }
    .info-value { color: ${DARK.onSurface}; font-weight: 500; text-align: right; }
    .desc-text {
      font-size: 14px;
      color: ${DARK.onSurface};
      line-height: 1.5;
      padding: 12px 0;
    }
    .status-badge {
      display: inline-block;
      background: rgba(112,144,168,0.18);
      border: 1px solid rgba(112,144,168,0.42);
      color: #7090A8;
      border-radius: 999px;
      padding: 4px 14px;
      font-size: 12px;
      font-weight: 700;
    }
    .header-card {
      background: ${DARK.surface};
      border: 1px solid ${DARK.border};
      border-radius: 16px;
      padding: 16px;
      margin-bottom: 14px;
    }
    .header-job-name {
      font-size: 22px;
      font-weight: 800;
      color: ${DARK.onSurface};
      margin-bottom: 10px;
    }
    .site-note {
      background: rgba(232,37,48,0.06);
      border-left: 3px solid ${DARK.primary};
      border-radius: 4px;
      padding: 10px 12px;
      font-size: 13px;
      color: ${DARK.onSurface};
      line-height: 1.4;
      margin-top: 8px;
    }
  </style>
</head>
<body>
  <div class="app-bar">
    <span class="app-bar-back">←</span>
    <span class="app-bar-title">Tampa Highrise</span>
  </div>
  <div class="tab-bar">
    <div class="tab active">Overview</div>
    <div class="tab">Contacts</div>
    <div class="tab">Crew</div>
    <div class="tab">Notes</div>
    <div class="tab">Attachments</div>
  </div>
  <div class="content" style="padding-bottom:20px;">
    <!-- Header card -->
    <div class="header-card">
      <div class="header-job-name">Tampa Highrise</div>
      <div class="pill-row">
        <span class="pill pill-meta">🏷 PO 12345</span>
        <span class="status-badge">In Progress</span>
      </div>
      <div style="margin-top:10px;font-size:13px;color:${DARK.onSurfaceVariant};">
        📍 Downtown Office Tower · 123 N Michigan Ave, Chicago IL 60601
      </div>
    </div>

    <!-- Overview tab -->
    <div class="panel">
      <div class="section-title">Job Info</div>
      <div class="info-row">
        <span class="info-label">Start Date</span>
        <span class="info-value">Mar 17, 2026</span>
      </div>
      <div class="info-row">
        <span class="info-label">End Date</span>
        <span class="info-value">Mar 28, 2026</span>
      </div>
      <div class="info-row">
        <span class="info-label">PO Number</span>
        <span class="info-value">PO-12345</span>
      </div>
      <div class="info-row">
        <span class="info-label">Status</span>
        <span class="info-value">In Progress</span>
      </div>

      <div class="section-title">Description</div>
      <p class="desc-text">
        Install new tempered storefront glass panels on floors 1–3,
        including framing adjustments and sealant work.
      </p>

      <div class="section-title">Site Notes</div>
      <div class="site-note">
        High-rise access requires security check-in 30 minutes before arrival.
        Badge needed for upper floors.
      </div>

      <div class="section-title">Site Address</div>
      <div class="info-row">
        <span class="info-label">Address</span>
        <span class="info-value">123 N Michigan Ave</span>
      </div>
      <div class="info-row">
        <span class="info-label">Suite</span>
        <span class="info-value">Suite 100</span>
      </div>
      <div class="info-row">
        <span class="info-label">City / State</span>
        <span class="info-value">Chicago, IL 60601</span>
      </div>
    </div>
  </div>
</body>
</html>`;
}

// ── Screen: Settings ───────────────────────────────────────────────────────────
function settingsHTML() {
  return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>GlazerOps – Settings</title>
  <style>
    ${baseCSS()}
    .settings-card {
      background: ${DARK.surface};
      border: 1px solid ${DARK.border};
      border-radius: 16px;
      overflow: hidden;
      margin-bottom: 12px;
    }
    .settings-tile {
      padding: 14px 16px;
      border-bottom: 1px solid ${DARK.border};
    }
    .settings-tile:last-child { border-bottom: none; }
    .settings-tile-title { font-size: 15px; font-weight: 600; color: ${DARK.onSurface}; }
    .settings-tile-subtitle { font-size: 13px; color: ${DARK.onSurfaceVariant}; margin-top: 2px; }
    .switch-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 14px 16px;
    }
    .switch-label { font-size: 15px; color: ${DARK.onSurface}; font-weight: 500; }
    .toggle {
      width: 44px;
      height: 24px;
      background: ${DARK.primary};
      border-radius: 12px;
      position: relative;
    }
    .toggle-knob {
      width: 20px;
      height: 20px;
      background: #fff;
      border-radius: 50%;
      position: absolute;
      right: 2px;
      top: 2px;
    }
    .section-list-tile {
      padding: 16px;
      border-bottom: 1px solid ${DARK.border};
      font-size: 15px;
      color: ${DARK.onSurface};
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .section-list-tile:last-child { border-bottom: none; }
    .tile-icon { font-size: 18px; }
  </style>
</head>
<body>
  <div class="app-bar">
    <span class="app-bar-title">Settings</span>
  </div>
  <div class="content">
    <!-- Theme card -->
    <div class="settings-card">
      <div class="settings-tile">
        <div class="settings-tile-title">Theme</div>
        <div class="settings-tile-subtitle">Dark mode</div>
      </div>
      <div class="switch-row">
        <span class="switch-label">Use dark theme</span>
        <div class="toggle"><div class="toggle-knob"></div></div>
      </div>
    </div>

    <!-- Other settings -->
    <div class="settings-card" style="margin-top:12px;">
      <div class="section-list-tile">
        <span class="tile-icon">🔔</span>
        <span>Notifications</span>
      </div>
      <div class="section-list-tile">
        <span class="tile-icon">ℹ️</span>
        <span>About</span>
      </div>
    </div>
  </div>

  <div class="bottom-nav">
    <div class="nav-strip">
      <span class="nav-logo">GlazerOps</span>
    </div>
    <div class="nav-items">
      <div class="nav-item">
        <span class="nav-icon">⬛</span>
        <span>Dashboard</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">💼</span>
        <span>Jobs</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">📅</span>
        <span>Schedule</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">👥</span>
        <span>Contacts</span>
      </div>
      <div class="nav-item">
        <span class="nav-icon">📝</span>
        <span>Notes</span>
      </div>
    </div>
  </div>
</body>
</html>`;
}

// ── Main ───────────────────────────────────────────────────────────────────────
(async () => {
  fs.mkdirSync(OUT_DIR, { recursive: true });

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({
    viewport: VIEWPORT,
    deviceScaleFactor: 2,   // retina-quality output
  });

  const screens = [
    { name: 'home',        html: dashboardHTML() },
    { name: 'jobs',        html: jobsHTML() },
    { name: 'job_details', html: jobDetailsHTML() },
    { name: 'settings',    html: settingsHTML() },
  ];

  for (const { name, html } of screens) {
    const page = await context.newPage();
    await page.setContent(html, { waitUntil: 'networkidle' });
    await page.waitForTimeout(300);
    const outPath = path.join(OUT_DIR, `${name}.png`);
    await page.screenshot({ path: outPath, fullPage: false });
    await page.close();
    console.log(`✓ ${name}.png`);
  }

  await browser.close();
  console.log(`\nScreenshots saved to: ${OUT_DIR}`);
})();
