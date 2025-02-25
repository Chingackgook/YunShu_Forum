<template>
  <div :class="{disabled: maindeskreadonly}" >
      <div class="login-container" @keydown.enter="surebutclicked">
        <h1 @click="titleclicked" v-if="!isadmin">用户登录</h1>
        <h1 v-else>管理员登录</h1>
        <el-form label-position="top">
          <el-form-item label="id/邮箱" prop="username">
            <el-input v-model="uid"></el-input>
          </el-form-item>
          <el-form-item label="密码" prop="password">
            <el-input type="password" v-model="pass"
            :show-password="true"
            ></el-input>
          </el-form-item>
            <el-button type="primary" @click="surebutclicked">登录</el-button>
            <el-button type="primary" @click="forget">忘记密码</el-button>
            <el-button type="text" @click="regist">没有账号：注册</el-button>
        </el-form>
      </div>
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
</template>

<script>
import router from '@/router';
import { useRoute } from 'vue-router';
import { ref,getCurrentInstance } from 'vue';
import myDialog from './Mydialog.vue';
export default{
    name: 'Login',
    components: {
      myDialog,
    },
    setup(){

      //对话框
      const dialogtitle = ref('');
      const dialogtext = ref('');
      const dialogneedcancelbut = ref(false);
      const dialogsurebuttext = ref('');
      const dialogcancelbuttext = ref('');
      const dialogvisible = ref(false);
      const maindeskreadonly = ref(false);

      const showdialog = (title, text, needcancelbut, surebuttext, cancelbuttext) => {
        dialogtitle.value = title;
        dialogtext.value = text;
        dialogneedcancelbut.value = needcancelbut;
        dialogsurebuttext.value = surebuttext;
        dialogcancelbuttext.value = cancelbuttext;
        dialogvisible.value = true;
        maindeskreadonly.value = true;
      };
      const myDialogConfirm = () => {
        dialogvisible.value = false;
        maindeskreadonly.value = false;
      };
      const myDialogCancel = () => {
        dialogvisible.value = false;
        maindeskreadonly.value = false;
      };
      //对话框结束

      const route=useRoute();
      const from=route.query.from;
      const uid=ref(null);
      const pass=ref(null);
      const info=ref(null);

      const isadmin=ref(false);
      let tcnum=0;
      const titleclicked =()=>{
        if(tcnum>5){
          isadmin.value=true;
          return;
        }
        tcnum+=1;
      }

      let app = getCurrentInstance();
      const path =app.proxy.$backpath;
      const regist=()=>{
        router.push('/regist');
      }
      const forget=()=>{
        router.push('/forget');
      }
      const surebutclicked=async()=>{
        if(uid.value==null||uid.value==''){
          showdialog('登录失败', 'id/邮箱不能为空', false, '确定', '');
          return;
        }
        if(pass.value==null||pass.value==''){
          showdialog('登录失败', '密码不能为空', false, '确定', '');
          return;
        }
        let body = {
          uid: uid.value,
          password: pass.value
        };
        let fetchstr=path+'/api/';
        if(isadmin.value){
          fetchstr+='admlogin';
        }
        else{
          fetchstr+='login';
        }
        const response = await fetch(fetchstr, {
            method: 'POST',
            body: JSON.stringify(body)
        });
        info.value = await response.json();
        if(info.value.isok==true){
          sessionStorage.setItem('uname',info.value.uname);
          sessionStorage.setItem('uid',info.value.uid);
          sessionStorage.setItem('uimage',info.value.uimage);
          sessionStorage.setItem('token',info.value.token);
          if(isadmin.value){
            sessionStorage.setItem('isadmin',true);
            window.location.href='/admindesk';
          }
          if(from){
            window.location.href=from;
          }
          else{
            window.location.href='/perinfo/'+info.value.uid;
          }
        }
        else{
            showdialog('登录失败', info.value.failreason, false, '确定', '');
            return;
        }
      }
      document.title = '登录-云枢论坛';
      return{
        surebutclicked,
        pass,
        uid,
        regist,
        forget,
        dialogtitle,
        dialogtext,
        dialogneedcancelbut,
        dialogsurebuttext,
        dialogcancelbuttext,
        dialogvisible,
        maindeskreadonly,
        showdialog,
        myDialogConfirm,
        myDialogCancel,
        isadmin,
        titleclicked,
      }
    }
}
</script>

<style>
.disabled{
  pointer-events: none;
  opacity: 0.5;
}
.login-container {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  background-color: #e6f7ffb1;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}
.login-container h1 {
  text-align: center;
}
</style>