import './src/css/style.css';
import 'animate.css'
import Alpine from 'alpinejs';

window.Alpine = Alpine;

Alpine.store('router', {
  current: 'home',
  currentPost: null,
  posts: [],

  routes: {
    home:      { file: 'home.html',      title: 'Isaac Castro Dev' },
    curriculo: { file: 'curriculo.html',  title: 'Currículo - Isaac Castro' },
    projetos:  { file: 'projetos.html',   title: 'Projetos - Isaac Castro' },
    contato:   { file: 'contato.html',    title: 'Contato - Isaac Castro' },
    blog:      { file: 'blog.html',       title: 'Blog - Isaac Castro' },
  },

  navigate(page) {
    const blogMatch = page.match(/^blog\//);
    if (this.routes[page] || blogMatch) {
      window.location.hash = '/' + page;
    }
  },

  navigateFromHash() {
    const hash = window.location.hash.replace('#/', '') || 'home';
    const blogMatch = hash.match(/^blog\/(.+)$/);
    if (blogMatch) {
      this.current = 'blog';
      this.currentPost = blogMatch[1];
      this.loadPage('blog');
    } else if (this.routes[hash]) {
      this.current = hash;
      this.currentPost = null;
      this.loadPage(hash);
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
      if (page === 'blog') {
        await this.loadPosts();
      }
    } catch (e) {
      console.error('Failed to load page:', page, e);
    }
  },

  async loadPosts() {
    try {
      const resp = await fetch('./src/posts/index.json');
      this.posts = await resp.json();
    } catch (e) {
      console.error('Failed to load posts:', e);
      this.posts = [];
    }
  }
});

Alpine.data('blogList', function () {
  return {
    get posts() {
      return Alpine.store('router').posts;
    }
  }
});

Alpine.data('blogPost', function () {
  return {
    get post() {
      const slug = Alpine.store('router').currentPost;
      return Alpine.store('router').posts.find(p => p.slug === slug) || null;
    }
  }
});

Alpine.start();

const router = Alpine.store('router');
router.navigateFromHash();
window.addEventListener('hashchange', () => router.navigateFromHash());
