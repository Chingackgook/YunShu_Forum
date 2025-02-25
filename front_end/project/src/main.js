import { createApp,ref,provide } from 'vue'
import App from './App.vue'
import router from './router.js'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
export const app = createApp(App);
// app.config.globalProperties.$backpath = 'http://127.0.0.1:4523/m1/5204288-4870430-default';
// app.config.globalProperties.$backpath = 'http://172.27.51.106:8080';
app.config.globalProperties.$backpath = 'http://127.0.0.1:8080';
// app.config.globalProperties.$backpath = 'http://172.27.65.64:8080';
//app.config.globalProperties.$backpath = 'http://172.27.51.106:8080';
// app.config.globalProperties.$backpath = 'http://172.27.65.64:8080';
//this is the path to the backend server
app.use(router);
app.use(ElementPlus);
app.mount('#app');