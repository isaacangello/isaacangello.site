import "./src/fa6/pro/css/all.css"
import "./src/fa6/pro/js/all"
import './style.css';
import 'animate.css'
import Alpine from 'alpinejs';

window.Alpine = Alpine;
Alpine.data('app', () => ({
  loadPage(page){
    fetch('./src/html/'+page)
    .then(resp=>resp.text())
    .then(resp=>{
      this.$refs.appContent.innerHTML = resp
    })
  },
  init(){
    this.loadPage('home.html')
  }
})
)
Alpine.start();
