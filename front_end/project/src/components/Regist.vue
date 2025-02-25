<template>
  <div :class="{disabled: maindeskreadonly}">
    <div class="register-container">
      <h1>用户注册</h1>
      <el-form label-position="top">
        
        <el-form-item label="用户名" prop="uname">
          <el-input v-model="uname" placeholder="请输入用户名"></el-input>
        </el-form-item>

        <el-form-item label="密码" prop="pass">
          <el-input type="password" v-model="pass" placeholder="请输入密码"
          :show-password="true"></el-input>
        </el-form-item>

        <el-form-item label="确认密码" prop="repass">
          <el-input type="password" v-model="repass" placeholder="请确认密码"
          :show-password="true"></el-input>
        </el-form-item>

        <el-form-item label="邮箱" prop="email">
          <el-input v-model="email" placeholder="请输入邮箱"></el-input>
        </el-form-item>

        <el-form-item label="验证码" prop="code">
          <div style="display: flex; align-items: center;">
            <el-input v-model="code" placeholder="请输入6位验证码" style="flex: 1; margin-right: 10px;"></el-input>
            <el-button :disabled="isDisabled" @click="sendcode">
              获取验证码
            </el-button>
            <span v-if="isDisabled" style="margin-left: 10px;">{{ countdown }} 秒后可再次获取</span>
          </div>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="surebutclicked">注册</el-button>
          <el-button type="text" @click="login">已有账号：登录</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>

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
import { ref,getCurrentInstance } from 'vue';
import myDialog from './Mydialog.vue';
export default{
    name: 'Regist',
    components: {
      myDialog
    },
    setup(){
      const isDisabled = ref(false);
      const countdown = ref(60);
      const email = ref(null);
      const uid=ref(null);
      const uname =ref(null);
      const pass=ref(null);
      const repass=ref(null);
      const info=ref(null);
      const code=ref(null);
      let app = getCurrentInstance();
      const path =app.proxy.$backpath;
      const headers = new Headers();
      headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));

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

      const login=()=>{
        router.push('/login');
      }
      const surebutclicked=async()=>{
        if(!(pass.value==repass.value)){
          showdialog('注册失败','两次密码不一致',false,'确定',null);
          return;
        }
        else if(!(pass.value&&repass.value&&uname.value&&email.value&&code.value)){
          showdialog('注册失败','请填写完整信息',false,'确定',null);
          return;
        }
        //判断验证码是否为6位数字
        else if(!/^\d{6}$/.test(code.value)){
          showdialog('注册失败','验证码格式不正确',false,'确定',null);
          return;
        }
        let body = {
          password: pass.value,
          uname:uname.value,
          mail:email.value,
          code:code.value
        };
        const response = await fetch(`${path}/api/regist`, {
            method: 'POST',
            body: JSON.stringify(body),
            headers: headers,
        });
        info.value = await response.json();
        if(info.value.isok==true){
          uid.value=info.value.uid;
          sessionStorage.setItem('uid',uid.value);
          sessionStorage.setItem('uname',uname.value);
          sessionStorage.setItem('uimage',info.value.uimage);
          sessionStorage.setItem('token',info.value.token);
          window.location.href='/perinfo';
        }
        else{
            showdialog('注册失败',info.value.failreason,false,'确定',null);
        }
      }
      const  sendcode=async()=> {
        let body = {
          mail: email.value
        };
        const response = await fetch(`${path}/api/regist/mail?type=regist`, {
            method: 'POST',
            body: JSON.stringify(body),
            headers: headers,
        });
        const data =  await response.json();
        console.log(data);
        if (data.isok) {
          isDisabled.value = true;
          startCountdown();
        }
        else{
          showdialog('验证码发送失败',data.failreason,false,'确定',null);
        }
      }
      const startCountdown=()=> {
        const interval = setInterval(() => {
          countdown.value--;
          if (countdown.value === 0) {
            clearInterval(interval);
            isDisabled.value = false;
            countdown.value = 60;
          }
        }, 1000);
      }
      document.title = '注册-云枢论坛';
      return{
        uid,
        uname,
        pass,
        repass,
        email,
        code,
        surebutclicked,
        login,
        isDisabled,
        countdown,
        sendcode,
        startCountdown,
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
      }
    }
}
</script>

<style>
.disabled{
  pointer-events: none;
  opacity: 0.5;
}
.register-container {
  max-width: 400px;
  margin: 0 auto;
  background-color: #e6f7ffb1;;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}
.register-container h1 {
  text-align: center;
}
</style>