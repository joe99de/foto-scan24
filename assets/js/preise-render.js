/**
 * Rendert die Preisgruppen aus assets/js/preise.config.js
 * in jedes Element mit [data-preise-grid].
 */
(function () {
  function escapeNewlines(text) {
    return text.split("\n").map(function (line) {
      return document.createTextNode(line);
    });
  }

  function renderGruppe(gruppe) {
    var karte = document.createElement("div");
    karte.className = "preis-karte";

    var h3 = document.createElement("h3");
    h3.innerHTML = gruppe.titel;
    karte.appendChild(h3);

    var ul = document.createElement("ul");
    gruppe.produkte.forEach(function (produkt) {
      var li = document.createElement("li");
      var name = document.createElement("span");
      name.textContent = produkt.name;
      var preis = document.createElement("span");
      preis.className = "preis";
      preis.textContent = produkt.preis;
      li.appendChild(name);
      li.appendChild(preis);
      ul.appendChild(li);
    });
    karte.appendChild(ul);

    if (gruppe.hinweis) {
      var hinweis = document.createElement("p");
      hinweis.style.fontSize = ".8rem";
      hinweis.style.color = "#888";
      hinweis.style.marginTop = "10px";
      hinweis.textContent = gruppe.hinweis;
      karte.appendChild(hinweis);
    }

    return karte;
  }

  function render() {
    var config = window.PREISE_CONFIG;
    if (!config) return;

    document.querySelectorAll("[data-preise-grid]").forEach(function (grid) {
      grid.innerHTML = "";
      config.gruppen.forEach(function (gruppe) {
        grid.appendChild(renderGruppe(gruppe));
      });
    });

    document.querySelectorAll("[data-preise-intro]").forEach(function (el) {
      if (config.intro) el.textContent = config.intro;
    });

    document.querySelectorAll("[data-preise-hinweis]").forEach(function (el) {
      el.innerHTML = "";
      if (config.abschlusshinweis) {
        config.abschlusshinweis.split("\n").forEach(function (line, i) {
          if (i > 0) el.appendChild(document.createElement("br"));
          el.appendChild(document.createTextNode(line));
        });
      }
    });

    document.querySelectorAll("[data-preisbremse]").forEach(function (el) {
      el.innerHTML = "";
      if (config.preisbremse) {
        var titel = document.createElement("strong");
        titel.textContent = config.preisbremse.titel;
        var text = document.createElement("p");
        text.textContent = config.preisbremse.text;
        el.appendChild(titel);
        el.appendChild(text);
      }
    });

    document.querySelectorAll("[data-preise-teaser]").forEach(function (el) {
      var teaser = config.gruppen
        .filter(function (g) { return g.teaserName && g.teaserPreis; })
        .map(function (g) { return g.teaserName + " " + g.teaserPreis; })
        .join(" · ");
      el.textContent = teaser;
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", render);
  } else {
    render();
  }
})();
