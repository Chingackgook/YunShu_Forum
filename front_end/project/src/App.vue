<template>
  <div class="main">
    <el-container>
      <el-header>
        
        <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal" @select="handleSelect">
          
          <img 
            @click="clickLogo"
            src="./assets/logo3.png" 
            alt="logo" 
            style="
              margin-right: 2%; 
              height: 50px;
              margin-top: 1%;
              cursor: pointer;
              " 
          />

          <span style="margin-top:1.8%;margin-left: -1.5%; font-size: 30px;font-family:fantasy;
          cursor: pointer;" @click="clickLogo">
            {{ "CHF" }}
          </span>

          <el-menu-item class="mitem" index="1" style="margin-left: 10%">
            <el-icon>
              <house-icon></house-icon>
            </el-icon>
            <span>首页</span>
          </el-menu-item>

          <el-menu-item class="mitem" index="2">
            <el-icon>
              <select-icon></select-icon>
            </el-icon>
            <span>关注</span>
          </el-menu-item>

          <el-menu-item class="mitem" index="3">
            <el-icon>
              <edit-icon></edit-icon>
            </el-icon>
            <span>新建帖子</span>
          </el-menu-item>

          <el-menu-item class="mitem" index="4">
            <el-icon>
              <user-icon></user-icon>
            </el-icon>
            <span>个人中心</span>
          </el-menu-item>

          <el-menu-item class="mitem" index="5" v-if="isadmin">
            <el-icon>
              <lock-icon></lock-icon>
            </el-icon>
            <span>管理员面板</span>
          </el-menu-item>

        </el-menu>
      </el-header>

      <el-main class="content">
        <router-view></router-view>
      </el-main>

    </el-container>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
export default {
  name: 'App',
  components: {
    HouseIcon: ElementPlusIconsVue.House,
    EditIcon: ElementPlusIconsVue.Edit,
    SelectIcon: ElementPlusIconsVue.Select,
    UserIcon: ElementPlusIconsVue.User,
    LockIcon: ElementPlusIconsVue.Lock,
  },
  setup() {
    document.title = 'CHF';
    const router = useRouter();
    let activenum = 1;
    let path = window.location.pathname;
    let query = window.location.search;

    if (query.indexOf('attion=true') != -1) {
      activenum = 2;
      console.log('attion');
    } else if (path.indexOf('/newlog') != -1) {
      activenum = 3;
    } else if (path.indexOf('/perinfo/') != -1) {
      activenum = 4;
    } else if (path.indexOf('/admindesk') != -1){
      activenum = 5;
    }else {
      activenum = 1;
    }

    const activeIndex = ref(String(activenum));
    const isadmin = ref(sessionStorage.getItem('isadmin'));

    const handleSelect = (index) => {
      console.log(index);
      activeIndex.value = index;
      if (index == 1) {
        router.push('/start');
      } else if (index == 2) {
        router.push('/attion');
      } else if (index == 3) {
        router.push('/newlog');
      } else if (index == 4) {
        router.push('/perinfo');
      } else if (index == 5) {
        router.push('/admindesk');
      }
    };

    const clickLogo = (index) => {
      if(index !==1){
        index = 1;
        activeIndex.value = index;
        router.push('/home');
      }
    };

    return {
      activeIndex,
      handleSelect,
      isadmin,
      router,
      clickLogo 
    };
  }
}
</script>

<style scoped>

.el-menu-demo {
  /*无色纯透明背景*/
  background-color: rgba(0, 0, 0, 0);
  height: 80px;
  margin-left: 10%;
  margin-right: 10%;
}
.main {
  background: #c0e7ff;
  background-image: url('./assets/background8.png');
  background-size: cover;
  background-repeat: repeat;
  background-position: center;
  background-attachment: fixed;/*保持背景不变 */
  min-height: 100vh;
}
.el-header {
  background-color: #e9f4fb;
  height: auto;
}
/* .content {
  background-color: #e9f4fb96; 
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  margin: 20px;
  overflow-y: auto;
} */


</style>
