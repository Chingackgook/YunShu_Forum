<!-- LogList.vue -->
<template>
  <div :class="{disabled: maindeskreadonly}" class="main" style="margin-left: 12%;margin-right: 12%;">

    <el-container>
      <!-- 头部 -->

      <el-header class="homeHeader" height=180px margin-top=50px>
        <span class="homeTitle" >
          {{ "云枢" }}
        </span>  
      </el-header>

      <el-header class="homeHeader2" height=180px margin-top=50px>
        <span class="homeTitle2" style="display: inline-block; margin-top: -20px;" >
          {{ "论坛" }}
        </span>  
      </el-header>

      <el-header class="homeHeader3" height=180px margin-top=50px>
        <span class="homeTitle" >
          
        </span>  
      </el-header>

      <div>
        <span class="slogan">
          {{ "言有尽而意无穷" }}
        </span>
        <br>
        <span class="slogan">
          {{ "知无涯而思有道" }}
        </span>
      </div>

      <div>
        <img src="../assets/element.png" alt="描述图片" class="image-element">
      </div>

      

    </el-container>

    <h2 v-if="isattion" class="customTitle" >
      我的关注
    </h2>
    <h2 v-else-if="issearchmodel" class="customTitle">搜索</h2>
    <h2 v-else class="customTitle">
      实时热点,点击追踪
    </h2>

    <div style="display: flex; justify-content: space-between; align-items: center;gap: 10px; margin-bottom: 10px;">
      <div style="align-items: center; justify-content: center;">
        <el-input 
          v-model="searchname" 
          placeholder="请输入" 
          clearable
          @clear="handleclear" 
          style="width: 350px; height: 35px;border-radius: 15px;" 
        />
        <el-button @click="onSearch" style="margin-left: 10px;font-weight: 400;">搜索</el-button>
        <!-- <el-button @click="clearSearch" type="danger">清空搜索</el-button> -->
      </div>
      <div>
        <span style="color: #ccc;font-size: 20px; text-shadow : 0.5px 0.5px 0.5px rgba(0, 0, 0, 1);">排序方式：</span>
        <el-select v-model="orderstr" placeholder="排序方式" style="width: 90px;"
          @change="fetchLogs"
        >
          <el-option
            v-for="item in orderoption"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </div>
    </div>
    <div>
      <div v-if="issearchmodel&&(logs==null||logs.length==0)" style="text-align: center; margin-top: 20px;">
        <span style="color: #ccc;font-size: 20px; text-shadow : 0.5px 0.5px 0.5px red;">没有找到相关内容</span>
      </div>
      <div v-else-if="isattion&&(logs==null||logs.length==0)" style="text-align: center; margin-top: 20px;">
        <span style="color: #ccc;font-size: 20px; text-shadow : 0.5px 0.5px 0.5px red;">去关注一些人吧</span>
      </div>
      <el-card class="log-card" v-for="log in logs" :key="log.id">
        <div style="display: flex; align-items: center; height: auto;">
          <div @click="touid(log.uid)" @mouseover="isuserHovered = log.id" @mouseleave="isuserHovered = -1"
          style="display: flex; align-items: center; width: 15%;"class="clickUname">
            <img v-if="log.uimage" :src="log.uimage" alt="用户头像" class="avatar" style="width: 55px; height: 55px; border-radius: 50%; margin-right: 10px;" />
            <img v-else src="../assets/loading.png" alt="用户头像" class="avatar" style="width: 55px; height: 55px; border-radius: 50%; margin-right: 10px;" />
            <!-- 用户名和用户 ID 信息 -->

            <div style="max-width: 100%;">
              <div style="font-weight: bold;font-size: 15pt;word-break: break-all;">{{ log.uname }}</div>
              <div style="color: #999; font-size: 10pt;">{{ log.uid }}</div>
            </div>

          </div>
          <el-divider direction="vertical" style="height: 75%;"></el-divider>
          <!-- 居中的标题 -->
          <div @click="tolog(log.id)"
            @mouseover="istitleHovered = log.id" @mouseleave="istitleHovered = -1"
            style="flex-grow: 2; text-align: left; font-weight: bold; cursor: pointer;
            width: 70%; margin-right: 10px;
            ">

            <div :style="{ textDecoration: (istitleHovered==log.id) ? 'underline' : 'none' }">
              <div style="font-size: 14pt; margin-bottom: 8px;">{{ log.title }}：</div>
              <div style="color: #999;font-size: 10pt; font-weight: 400;">{{ log.somecontent }}</div>
            </div>

            <div v-if="!(log.subjects==null || log.subjects[0]=='')">
              <el-tag v-for="subject in log.subjects" :key="subject"
              style="margin-right: 10px;margin-top: 20px;" size="medium"
              >{{ subject }}</el-tag>
            </div>

            <div style="margin-left: auto; color: #999; font-size: 9pt;
            display: flex; align-items: center; margin-top: 10px;">
              <el-icon>
                <Timer></Timer>
              </el-icon>
              <span>&nbsp;</span>
              <span>{{ log.time }}</span>
            </div>
          </div>
           <div style="width: 15%;display: flex; flex-direction: column; align-items: flex-end;">
            <span class="log-actions">
              <span @click="likelog(log)" class="action-item">
                <img src="../assets/redheart.png" v-if="log.islike" class="heart-icon" />
                <img src="../assets/blackheart.png" v-else class="heart-icon" />
                <span>{{ log.likenum }}</span>
              </span>
              <span>&nbsp;</span>
              <span @click="collectlog(log)" class="action-item">
                <img src="../assets/collect.png" v-if="log.iscollect" class="collect-icon" />
                <img src="../assets/uncollect.png" v-else class="collect-icon" />
                <span>{{ log.collectnum }}</span>
              </span>
            </span>
            </div>
        </div>
      </el-card>
    </div>
    <el-pagination
      background
      :current-page="currentPage"
      :page-count="totalPages"
      layout="prev, pager, next , jumper"
      @current-change="goToPage"
      style="margin-top: 10px;"
    />

    <div style="height: 60px;"></div>

  </div>

  <!-- 弹出框 -->
  <myDialog
    v-if="dialogvisible"
    :dialogtitle="dialogtitle"
    :dialogtext="dialogtext"
    :dialogneedcancelbut="dialogneedcancelbut"
    :dialogsurebuttext="dialogsurebuttext"
    :dialogcancelbuttext="dialogcancelbuttext"
    @confirm="myDialogConfirm"
    @cancel="myDialogCancel"
  ></myDialog>
  <!-- 弹出框结束 -->



</template>

<script>
import { ref, onMounted ,getCurrentInstance , computed } from 'vue';
import { useRoute } from 'vue-router';
import myDialog from './Mydialog.vue';
import router from '@/router';
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
export default {
  name: 'Home',
  components: {
    Timer:ElementPlusIconsVue.Calendar,
    myDialog,
  },
  setup() {
      //对话框
      const dialogtitle = ref('');
      const dialogtext = ref('');
      const dialogneedcancelbut = ref(false);
      const dialogsurebuttext = ref('');
      const dialogcancelbuttext = ref('');
      const dialogvisible = ref(false);
      const maindeskreadonly = ref(false);
      const istitleHovered = ref(-1);
      const isuserHovered = ref(-1);
      let dconfirmfunc=()=>null;
      let dcancelfunc=()=>null;
      const showdialog = (title, text, needcancelbut, surebuttext, cancelbuttext
        , diaconfirmfuc = () => null, diacancelfuc = () => null
      ) => {
        dialogtitle.value = title;
        dialogtext.value = text;
        dialogneedcancelbut.value = needcancelbut;
        dialogsurebuttext.value = surebuttext;
        dialogcancelbuttext.value = cancelbuttext;
        dialogvisible.value = true;
        maindeskreadonly.value = true;
        dconfirmfunc=diaconfirmfuc;
        dcancelfunc=diacancelfuc;
      };
      const myDialogConfirm = () => {
        dialogvisible.value = false;
        dconfirmfunc();
        maindeskreadonly.value = false;
      };
      const myDialogCancel = () => {
        dialogvisible.value = false;
        dcancelfunc();
        maindeskreadonly.value = false;
      };
      //对话框结束
    const route=useRoute();
    const headers = new Headers();
    headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));
    let isattion = ref(false);
    if(route.query.attion){
      isattion.value=true;
    }
    let issearchmodel = ref(false)
    let searchname=ref('')
    if(route.query.sname){
      let thesname=route.query.sname;
      if (thesname.includes('subject--')) {
        thesname = thesname.replace('subject--', ''); // 移除 'subject-' 字段
        thesname = '#'+thesname;
      }
      issearchmodel.value=true;
      searchname.value=thesname
    }
    const logs = ref([]);
    const currentPage = ref(1);
    const pagesToShow = ref(5); // 控制显示的页码数量，比如显示5个页码
    const totalPages = ref(1);
    const app = getCurrentInstance();
    const path = app.proxy.$backpath;
    const myuid = sessionStorage.getItem('uid');
    const orderstr = ref('time');
    const orderoption = [
      { value: 'time', label: '时间' },
      { value: 'like', label: '点赞数' },
      { value: 'collect', label: '收藏数' },
    ]
    const fetchLogs = async () => {
      let response = null;
      if(issearchmodel.value!=true){
        let fetchstr=path+'/api/logs?page='+currentPage.value;
        if(myuid){
          fetchstr+='&uid='+myuid;
        }
        if(isattion.value){
          fetchstr+='&isattion=true';
        }
        fetchstr+='&ordertype='+orderstr.value;
        console.log(fetchstr);
        response=await fetch(fetchstr, {
          method: 'GET',
          headers: headers
        });
      }
      else{
        let fetchstr=path+'/api/searchlogs?page='+currentPage.value;
        if(myuid){
          fetchstr+='&uid='+myuid;
        }
        if(isattion.value){
          fetchstr+='&isattion=true';
        }
        fetchstr+='&ordertype='+orderstr.value;
        let body = {
          name: searchname.value
        };
        response=await fetch(fetchstr, {
          method: 'POST',
          body: JSON.stringify(body),
          headers: headers
        });
      }
      const data =  await response.json();
      logs.value = data.logs;
      totalPages.value = data.totalPages;
    };

    const pages = computed(() => {
      const half = Math.floor(pagesToShow.value / 2);
      let start = Math.max(1, currentPage.value - half);
      let end = Math.min(totalPages.value, start + pagesToShow.value - 1);

      if (end - start < pagesToShow.value) {
        start = Math.max(1, end - pagesToShow.value + 1);
      }

      return Array.from({ length: end - start + 1 }, (_, i) => start + i);
    });

    const goToPage = (page) => {
      console.log(page);
      currentPage.value = page;
      fetchLogs();
    };
    
    const onSearch = ()=>{
      if(searchname.value==''){
        showdialog('提示','请输入搜索内容',false,'确定','取消');
        return;
      }
      let herfstr='/home?sname='+searchname.value;
      if(isattion.value){
        herfstr+='&attion=true';
      }
      router.push(herfstr);
      issearchmodel.value=true;
      currentPage.value=1;
      fetchLogs();
    };

    const handleclear = ()=>{
      searchname.value='';
      issearchmodel.value=false;
      currentPage.value=1;
      fetchLogs();
    };


    const tolog = (id) => {
      router.push('/log/' + id);
    };
    const touid = (uid) => {
      router.push('/perinfo/' + uid);
    };
    const tologin = () => {
      window.location.href = "/login?from=/home";
    };
    const likelog = async (log) => {
      if (!myuid) {
        showdialog('提示', '登录后可点赞', true, '登录', '取消', tologin, () => null);
        return;
      }
      const likestr = log.islike ? '0' : '1';//0表示取消点赞，1表示点赞
      const logId = log.id;
      const response = await fetch(path + '/api/likelog?uid=' + myuid + '&logid=' + logId + '&type=' + likestr, {
        method: 'POST',
        headers: headers
      });
      const data = await response.json();
      if (data.isok) {
        log.islike = !log.islike;
        log.likenum += log.islike ? 1 : -1;
      }
      else {
        showdialog('点赞失败', data.failreason, false, '确定', '确定');
      }
    }
    const collectlog = async (log) => {
      if (!myuid) {
        showdialog('提示', '登录后可收藏', true, '登录', '取消', tologin, () => null);
        return;
      }
      const collectstr = log.iscollect ? '0' : '1';//0表示取消收藏，1表示收藏
      const logId = log.id;
      const response = await fetch(path + '/api/collectlog?uid=' + myuid + '&logid=' + logId + '&type=' + collectstr, {
        method: 'POST',
        headers: headers
      });
      const data =  await response.json();
      if (data.isok) {
        log.iscollect = !log.iscollect;
        log.collectnum += log.iscollect ? 1 : -1;
      }
      else {
        showdialog('收藏失败', data.failreason, false, '确定', '确定');
      }
    }

    onMounted(fetchLogs);
    if(isattion.value){
      document.title = '关注-云枢论坛';
    }
    else{
      document.title = '首页-云枢论坛';
    }
    return {
      isattion,
      issearchmodel,
      logs,
      currentPage,
      totalPages,
      pagesToShow,
      onSearch,
      searchname,
      pages,
      goToPage,
      fetchLogs,
      myDialogConfirm,
      myDialogCancel,
      dialogtitle,
      dialogtext,
      dialogneedcancelbut,
      dialogsurebuttext,
      dialogcancelbuttext,
      dialogvisible,
      maindeskreadonly,
      showdialog,
      tolog,
      handleclear,
      touid,
      likelog,
      collectlog,
      istitleHovered,
      isuserHovered,
      orderstr,
      orderoption,
    };
  },
};
</script>


<style>
.disabled {
  pointer-events: none;
  opacity: 0.6;
}
.log-actions {
  display: flex;
  align-items: center;
  /* 让子元素垂直居中对齐 */
  flex-direction: row;
}

.action-item {
  display: flex;
  align-items: center;
  width: 50px;
  /* 让文本和图片在同一行垂直居中 */
  cursor: pointer;
  /* 提示用户这是可点击的 */
}

@font-face {
  font-family: 'MyCustomFont';
  src: url('../assets/Font.ttf') format('truetype');
}

@font-face {
  font-family: '207Font';
  src: url('../assets/Font2.ttf') format('truetype');
}

@font-face {
  font-family: 'sloganFont';
  src: url('../assets/Font3.ttf') format('truetype');
}

@font-face {
  font-family: 'Font4';
  src: url('../assets/Font4.ttf') format('truetype');
}
/* @font-face {
  font-family: 'Font-slogan';
  src: url('../assets/Font-slogan.ttf') format('truetype');
} */

.customTitle{
  color: rgb(230, 230, 230);
  font-Family: 'MyCustomFont';
  font-Size: 30px ;
  margin-Bottom: 12px;
  letter-Spacing: 5px;
  margin-top:-38px;
  margin-left: 35px;
  font-weight: 200;
}

.homeHeader{
  /*圆角边框*/
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  background-color: #e9f4fbcc;
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  /*宽度为60%*/
  width: 60%;
  /*居中*/
  margin: 0 auto;
  background-image: url('../assets/homeHeaderBg.png');
  background-size: cover; /* 确保背景图片覆盖整个容器 */
  background-repeat: no-repeat; /* 防止背景图片重复 */
  background-position: center; /* 背景图片居中 */
  text-align: right;
  padding-top: 10px; /* 调整父容器的上内边距 */
  position: relative; /* 设置为相对定位 */
  z-index: 1; /* 设置较高的层级 */
  
}


.homeHeader2{
    /*圆角边框*/
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  background-color: #e9f4fbcc;
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  width: 18%;
  margin: 0 auto;
  background-image: url('../assets/homeHeaderBg-right.png');
  background-size: cover; 
  background-position: center; 
  text-align:center;
  transform: scale(0.8); /* 缩放元素 */
  transform-origin: center; /* 缩放中心 */
  margin-right: 80px; /* 向右移动 */
  margin-top: -65px;
  position: relative; /* 设置为相对定位 */
  z-index: 1; 
}

.homeHeader3{
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  background-color: #e9f4fbcc;
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  width: 22%;
  margin: 0 auto;
  background-image: url('../assets/homeHeaderBg-left.png');
  background-size: cover; 
  background-position: center; 
  text-align: right;
  transform: scale(0.8); /* 缩放元素 */
  transform-origin: center; /* 缩放中心 */
  margin-right: 800px; /* 向右移动 */
  margin-top: -200px;

  position: relative; /* 设置为相对定位 */
  z-index: 0; /* 设置较低的层级 */
}


.homeTitle{
  color: rgb(0, 74, 173);
  font-Family: 'MyCustomFont';
  font-Size: 110px;
  margin-Bottom: 5px;
  letter-Spacing: 5px;
  text-align: left;
  margin-left: -200px;
  white-space: nowrap;
  /* text-shadow: 
    -1px -1px 0 #fff,  
    1px -1px 0 #fff,
    -1px 1px 0 #fff,
    1px 1px 0 #fff; 添加白色描边 */
}
.homeTitle2{
  color: rgb(0, 74, 173);
  font-Family: 'MyCustomFont';
  font-Size: 135px;
  margin-Bottom: 5px;
  letter-Spacing: 5px;
  text-align: left;
  margin-left: -200px;
  white-space: nowrap;
  text-shadow: 
    -1px -1px 0 #fff,  
    1px -1px 0 #fff,
    -1px 1px 0 #fff,
    1px 1px 0 #fff; /* 添加白色描边 */
}

.slogan{
  color: rgb(255, 255, 255);
  font-Family: 'Font4';
  font-Size: 20px;
  margin-Bottom: 5px;
  letter-Spacing: 5px;
  text-align: right;
  margin-left: 200px;
  position: relative; /* 设置为相对定位 */
  top: -250px; /* 整体上移 */
  position: relative; /* 设置为相对定位 */
  z-index: 1; 
}

.image-element{
  width: 100px; /* 设置图片宽度 */
  height: auto; /* 保持图片比例 */
  display: block; /* 将图片显示为块级元素 */
  margin-right: 200px; /* 居中对齐 */
  margin-top:-50px;
  transform: scale(5); /* 缩放图片 */
  opacity: 0.7; 
}

.log-card{
  margin-top: 10px;
  background-image: url('../assets/userBg.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
}


.clickUname{
  cursor: pointer;
}
.clickUname:hover {
  font-weight: bold; /* 鼠标移到标签上时字体变粗 */
  color: #2794c3; /* 鼠标移到标签上时字体颜色变化 */
}


</style>