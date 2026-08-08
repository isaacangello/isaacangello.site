import './src/css/style.css';
import 'animate.css'
import Alpine from 'alpinejs';
import { createRouter } from 'router-maverik';
import { installAlpine } from 'router-maverik/alpine';

window.Alpine = Alpine;

const SITE_URL = 'https://isaacangello.free.nf';

const PAGE_TITLES = {
  home: 'Isaac Castro Dev',
  curriculo: 'Currículo - Isaac Castro',
  projetos: 'Projetos - Isaac Castro',
  contato: 'Contato - Isaac Castro',
  blog: 'Blog - Isaac Castro',
};

const PAGE_FILES = {
  home: 'home.html',
  curriculo: 'curriculo.html',
  projetos: 'projetos.html',
  contato: 'contato.html',
  blog: 'blog.html',
};

Alpine.store('blog', {
  posts: [],
  loaded: false,

  async load() {
    if (this.loaded) return;
    try {
      const resp = await fetch('/src/posts/index.json');
      this.posts = await resp.json();
      this.loaded = true;
      Alpine.store('router').applyMeta();
    } catch (e) {
      console.error('Falha ao carregar posts:', e);
      this.posts = [];
    }
  },

  getBySlug(slug) {
    return this.posts.find((p) => p.slug === slug) || null;
  },
});

async function loadPage(page, slug) {
  const file = slug ? 'post.html' : PAGE_FILES[page];
  if (!file) return;
  const resp = await fetch('/src/html/' + file);
  const html = await resp.text();
  document.getElementById('app').innerHTML = html;
}

const router = createRouter({
  routes: [
    { path: '/', name: 'home', title: PAGE_TITLES.home },
    { path: '/blog', name: 'blog', title: PAGE_TITLES.blog },
    { path: '/blog/:slug', name: 'post', title: PAGE_TITLES.blog },
    { path: '/curriculo', name: 'curriculo', title: PAGE_TITLES.curriculo },
    { path: '/projetos', name: 'projetos', title: PAGE_TITLES.projetos },
    { path: '/contato', name: 'contato', title: PAGE_TITLES.contato },
  ],
  fallback: 'home',

  onNavigate({ route, params }) {
    if (!route) return;
    if (route.name === 'post') {
      loadPage('blog', params.slug);
      Alpine.store('blog').load();
    } else {
      loadPage(route.name);
      if (route.name === 'blog') Alpine.store('blog').load();
    }
  },

  meta({ route, params }) {
    const name = route ? route.name : 'home';
    let title = PAGE_TITLES[name] || PAGE_TITLES.home;
    let path = route ? route.path : '/';
    if (route && route.name === 'post') {
      const post = Alpine.store('blog').getBySlug(params.slug);
      if (post) title = post.title + ' - Isaac Castro';
      path = '/blog/' + params.slug;
    }
    return {
      title,
      description: 'Site pessoal e blog de Isaac Castro — desenvolvedor web fullstack.',
      canonical: SITE_URL + path,
    };
  },
});

installAlpine(Alpine, 'router', router);

Alpine.data('blogList', function () {
  return {
    get posts() {
      return Alpine.store('blog').posts;
    }
  }
});

Alpine.data('blogPost', function () {
  return {
    get post() {
      return Alpine.store('blog').getBySlug(Alpine.store('router').params.slug);
    }
  }
});

Alpine.start();
