import { createRouter, createWebHistory } from 'vue-router';
import LogDetail from './components/TheLog.vue';
import Home from './components/Home.vue';
import PerInfo from './components/PerInfo.vue';
import Login from './components/Login.vue';
import Regist from './components/Regist.vue';
import NewLog from './components/NewLog.vue';
import Editinfo from './components/Editinfo.vue';
import Forget from './components/Forget.vue';
import Admindesk from './components/Admindesk.vue';
const routes = [
  { path: '/', redirect: '/home'},
  { path: '/start', component: Home}, 
  { path: '/home', component: Home},
  { path: '/attion', component: Home},
  { path: '/log/:id', component: LogDetail },
  { path: '/perinfo', component: PerInfo},
  { path: '/perinfo/:uid', component: PerInfo},
  { path: '/editinfo/:uid', component: Editinfo},
  { path: '/login',component: Login},
  { path: '/regist',component: Regist},
  { path: '/newlog',component: NewLog},
  { path: '/about',redirect: '/home'},
  { path: '/forget',component: Forget},
  { path: '/admindesk',component: Admindesk}
];

const router = createRouter({
  history: createWebHistory(),
  routes: routes,
  base: __dirname
});


router.beforeEach((to, from, next) => {
  // 检查用户是否已登录
  const uid = sessionStorage.getItem('uid');
  if (to.path === '/perinfo') {
    // 如果未登录且试图访问仪表盘，则重定向到登录页
    if (!uid) {
      next('/login');
    }
    else{
      window.location.href = '/perinfo/'+uid;//这样会刷新页面，使用next()不会刷新页面
    }
  } 
  else if (to.path === '/start'){
    window.location.href = '/home';
  }
  else if (to.path === '/attion'){
    if (!uid) {
      router.push({path: '/login', query: {from: '/attion'}});
    }
    else{
      window.location.href = '/home?attion=true';
    }
  }
  else if(to.path === '/newlog'){
    if (!uid) {
      //将router from参数传递给登录页，使用params传递参数
      router.push({path: '/login', query: {from: '/newlog'}});
    }
    else{
      next();
    }
  }
  else if(to.path === '/admindesk'){
    const isvalid = sessionStorage.getItem('isadmin');
    if(!isvalid){
      router.push({path: '/home'});
    }
    else{
      next();
    }
  }
  else{
    next();
  }
});

export default router;
