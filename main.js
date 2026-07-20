import './src/css/style.css';
import 'animate.css'
import Alpine from 'alpinejs';

window.Alpine = Alpine;

Alpine.store('router', {
  current: 'home',

  routes: {
    home:      { file: 'home.html',      title: 'Isaac Castro Dev' },
    curriculo: { file: 'curriculo.html',  title: 'Currículo - Isaac Castro' },
    projetos:  { file: 'projetos.html',   title: 'Projetos - Isaac Castro' },
    contato:   { file: 'contato.html',    title: 'Contato - Isaac Castro' },
  },

  navigate(page) {
    if (this.routes[page]) {
      window.location.hash = '/' + page;
    }
  },

  navigateFromHash() {
    const page = window.location.hash.replace('#/', '') || 'home';
    if (this.routes[page]) {
      this.current = page;
      this.loadPage(page);
    }
  },

  async loadPage(page) {
    const route = this.routes[page];
    if (!route) return;
    try {
      const resp = await fetch('./src/html/' + route.file);
      const html = await resp.text();
      document.getElementById('app').innerHTML = html;
      document.title = route.title;
    } catch (e) {
      console.error('Failed to load page:', page, e);
    }
  }
});

Alpine.start();

const router = Alpine.store('router');
router.navigateFromHash();
window.addEventListener('hashchange', () => router.navigateFromHash());
