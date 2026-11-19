(function () {
  const root = document.documentElement;
  const key = 'biologytools-docs-theme';
  let theme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';

  try {
    const savedTheme = localStorage.getItem(key);
    if (savedTheme === 'light' || savedTheme === 'dark') theme = savedTheme;
  } catch {
    // The toggle also works when browser storage is unavailable.
  }

  root.dataset.theme = theme;

  document.addEventListener('DOMContentLoaded', function () {
    const button = document.getElementById('themeToggle');
    if (!button) return;

    function updateButton() {
      const dark = theme === 'dark';
      button.setAttribute('aria-pressed', String(dark));
      button.textContent = dark ? 'Switch to day mode' : 'Switch to night mode';
    }

    updateButton();
    button.hidden = false;
    button.addEventListener('click', function () {
      theme = theme === 'dark' ? 'light' : 'dark';
      root.dataset.theme = theme;
      updateButton();

      try {
        localStorage.setItem(key, theme);
      } catch {
        // The current page still uses the selected theme.
      }
    });
  });
})();
