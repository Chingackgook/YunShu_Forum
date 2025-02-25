<template>
  <div :class="{disabled: maindeskreadonly}">
    <div class="reset-password-container">
      <h1>忘记密码</h1>
      <el-form label-position="top">

        <el-form-item label="新密码" prop="pass">
          <el-input type="password" v-model="pass" placeholder="请输入新密码"
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
            <el-input v-model="code" placeholder="请输入验证码" style="flex: 1; margin-right: 10px;"></el-input>
            <el-button :disabled="isDisabled" @click="sendcode">获取验证码</el-button>
            <span v-if="isDisabled" style="margin-left: 10px;">{{ countdown }} 秒后可再次获取</span>
          </div>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="surebutclicked">确认</el-button>
          <el-button type="text" @click="login">返回</el-button>
        </el-form-item>
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
import { ref,getCurrentInstance } from 'vue';
import myDialog from './Mydialog.vue';
export default{
    name: 'Forget',
    components: {
      myDialog
    },
    setup(){
      const isDisabled = ref(false);
      const countdown = ref(60);
      const email = ref(null);
      const uid=ref(null);
      const pass=ref(null);
      const repass=ref(null);
      const info=ref(null);
      const code=ref(null);
      let app = getCurrentInstance();
      const path =app.proxy.$backpath;

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
          showdialog('失败','两次密码不一致',false,'确定','');
          return;
        }
        else if(!(pass.value&&repass.value&&email.value&&code.value)){
          showdialog('失败','请填写完整信息',false,'确定','');
          return;
        }
        else if(!/^\d{6}$/.test(code.value)){
          showdialog('失败','验证码格式不正确',false,'确定','');
          return;
        }
        let body = {
          password: pass.value,
          mail:email.value,
          code:code.value
        };
        const response = await fetch(`${path}/api/forget`, {
            method: 'POST',
            body: JSON.stringify(body)
        });
        info.value = await response.json();
        if(info.value.isok==true){
          uid.value=info.value.uid;
          sessionStorage.setItem('uid',uid.value);
          sessionStorage.setItem('uname',info.value.uname);
          sessionStorage.setItem('uimage',info.value.uimage);
          window.location.href='/perinfo';
        }
        else{
            showdialog('失败',info.value.failreason,false,'确定','');
        }
      }
      const  sendcode=async()=> {
        let body = {
          mail: email.value
        };
        const response = await fetch(`${path}/api/regist/mail?type=find`, {
            method: 'POST',
            body: JSON.stringify(body)
        });
        const data =  await response.json();
        if (data.isok) {
          isDisabled.value = true;
          startCountdown();
        }
        else{
          showdialog('发送失败',data.failreason,false,'确定','');
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
      document.title = '忘记密码-云枢论坛';
      return{
        uid,
        pass,
        repass,
        email,
        code,
        surebutclicked,
        login,
        isDisabled,
        countdown,
        sendcode,
        dialogtitle,
        dialogtext,
        dialogneedcancelbut,
        dialogsurebuttext,
        dialogcancelbuttext,
        dialogvisible,
        myDialogConfirm,
        myDialogCancel,
        maindeskreadonly
      }
    }
}
</script>

<style>
.disabled {
  pointer-events: none; /* 禁止点击 */
  opacity: 0.5; /* 不可用状态的视觉效果 */
}
.reset-password-container {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
  border: 1px solid #ccc;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}
.reset-password-container h1 {
  text-align: center;
  margin-bottom: 20px;
}
</style>