(function () {
  "use strict";

  let coffres = [];
  let manuels = [];
  let activeTab = "coffres";

  const el = (sel) => document.querySelector(sel);
  const gridCoffres = el("#grid-coffres");
  const gridManuels = el("#grid-manuels");
  const searchInput = el("#search");
  const chapterFilter = el("#chapter-filter");
  const lightbox = el("#lightbox");
  const lightboxImg = el("#lightbox-img");

  function escapeHtml(str) {
    if (!str) return "";
    return str
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
  }

  function galleryHtml(images) {
    if (!images || !images.length) return "";
    return (
      '<div class="gallery">' +
      images
        .map(
          (src) =>
            `<img src="${src}" alt="" loading="lazy" referrerpolicy="no-referrer" data-full="${src}" />`
        )
        .join("") +
      "</div>"
    );
  }

  function coffreCard(c) {
    const extra = c.contenu
      ? `<div class="card-extra">🎁 Contenu : ${escapeHtml(c.contenu)}</div>`
      : "";
    return `
      <article class="card" data-chapter="${escapeHtml(c.chapitre)}" data-search="${escapeHtml(
      (c.chapitre + " " + c.sousChapitre + " " + c.combinaison + " " + c.description).toLowerCase()
    )}">
        <div class="card-header">
          <div class="card-chapter">${escapeHtml(c.chapitre)}</div>
          <h3 class="card-title">${escapeHtml(c.sousChapitre)}</h3>
        </div>
        <div class="card-body">
          <p class="card-desc">${escapeHtml(c.description)}</p>
          <div class="combo-badge">${escapeHtml(c.combinaison)}</div>
          ${extra}
        </div>
        ${galleryHtml(c.images)}
        <a class="card-link" href="${c.sourceUrl}" target="_blank" rel="noopener">Voir la source ↗</a>
      </article>
    `;
  }

  function manuelCard(m) {
    const extra = m.coffreLie
      ? `<div class="card-extra">🔒 Se trouve dans un coffre (voir onglet Coffres)</div>`
      : "";
    return `
      <article class="card" data-chapter="${escapeHtml(m.chapitre)}" data-search="${escapeHtml(
      (m.titre + " " + m.chapitre + " " + m.branche + " " + m.personnage + " " + m.description).toLowerCase()
    )}">
        <div class="card-header">
          <div class="card-chapter">${escapeHtml(m.chapitre)}</div>
          <h3 class="card-title">${escapeHtml(m.titre)}</h3>
        </div>
        <div class="card-body">
          <div class="badge-row">
            <span class="badge">👤 ${escapeHtml(m.personnage)}</span>
            <span class="badge">🌿 ${escapeHtml(m.branche)}</span>
          </div>
          <p class="card-desc">${escapeHtml(m.description)}</p>
          ${extra}
        </div>
        ${galleryHtml(m.images)}
      </article>
    `;
  }

  function renderGrid(container, items, cardFn) {
    if (!items.length) {
      container.innerHTML = '<div class="empty-state">Aucun résultat.</div>';
      return;
    }
    container.innerHTML = items.map(cardFn).join("");
  }

  function currentFilters() {
    return {
      q: searchInput.value.trim().toLowerCase(),
      chapter: chapterFilter.value,
    };
  }

  function applyFilters() {
    const { q, chapter } = currentFilters();
    const filterFn = (item, chapField) => {
      const matchesChapter = !chapter || item[chapField] === chapter;
      const matchesQuery =
        !q ||
        (item.chapitre + " " + (item.sousChapitre || item.titre) + " " + (item.combinaison || "") + " " + item.description)
          .toLowerCase()
          .includes(q);
      return matchesChapter && matchesQuery;
    };

    if (activeTab === "coffres") {
      renderGrid(gridCoffres, coffres.filter((c) => filterFn(c, "chapitre")), coffreCard);
    } else {
      renderGrid(gridManuels, manuels.filter((m) => filterFn(m, "chapitre")), manuelCard);
    }
  }

  function populateChapterFilter() {
    const source = activeTab === "coffres" ? coffres : manuels;
    const chapters = [...new Set(source.map((i) => i.chapitre))];
    chapterFilter.innerHTML =
      '<option value="">Tous les chapitres</option>' +
      chapters.map((c) => `<option value="${escapeHtml(c)}">${escapeHtml(c)}</option>`).join("");
  }

  function switchTab(tab) {
    activeTab = tab;
    document.querySelectorAll(".tab-btn").forEach((b) => b.classList.toggle("active", b.dataset.tab === tab));
    document.querySelectorAll(".panel").forEach((p) => p.classList.toggle("active", p.id === "panel-" + tab));
    populateChapterFilter();
    applyFilters();
  }

  document.querySelectorAll(".tab-btn").forEach((btn) => {
    btn.addEventListener("click", () => switchTab(btn.dataset.tab));
  });

  searchInput.addEventListener("input", applyFilters);
  chapterFilter.addEventListener("change", applyFilters);

  document.addEventListener("click", (e) => {
    const img = e.target.closest(".gallery img");
    if (img) {
      lightboxImg.src = img.dataset.full;
      lightbox.classList.remove("hidden");
    }
  });
  el("#lightbox-close").addEventListener("click", () => lightbox.classList.add("hidden"));
  lightbox.addEventListener("click", (e) => {
    if (e.target === lightbox) lightbox.classList.add("hidden");
  });

  Promise.all([
    fetch("data/coffres.json").then((r) => r.json()),
    fetch("data/manuels.json").then((r) => r.json()),
  ])
    .then(([coffresData, manuelsData]) => {
      coffres = coffresData;
      manuels = manuelsData;
      el("#count-coffres").textContent = coffres.length;
      el("#count-manuels").textContent = manuels.length;
      switchTab("coffres");
    })
    .catch((err) => {
      gridCoffres.innerHTML =
        '<div class="empty-state">Erreur de chargement des données : ' + escapeHtml(err.message) + "</div>";
    });
})();
