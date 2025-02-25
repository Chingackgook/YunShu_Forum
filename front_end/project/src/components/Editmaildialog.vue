<!-- LoginDialog.vue -->
<template>
    <div class="dialog">
      <h2>修改邮箱</h2>
      <el-input v-model="newemail" placeholder="输入新邮箱" @input="becomereditem = ''"
      :style="{ borderColor: (becomereditem =='newemail') ? 'red' : '' }"
      ></el-input>
      <div style="display: flex; align-items: center; margin-top: 10px">
        <el-input v-model="code" placeholder="请输入6位验证码" style="flex: 1; margin-right: 10px;"
        :style="{ borderColor: (becomereditem =='code') ? 'red' : '' }" @input="becomereditem = ''"
        ></el-input>
        <el-button :disabled="isDisabled" @click="sendcode">
            获取验证码
        </el-button>
        <span v-if="isDisabled" style="margin-left: 10px;">{{ countdown }} 秒后可再次获取</span>
      </div>
      <div class="warning" v-if="ishowwarning">
        {{ warningtext }}
      </div>
      <div style="margin-top: 10px;">
        <el-button  @click="confirm" plain type="primary">确认</el-button>
        <el-button  @click="cancel" plain type="primary">取消</el-button>
      </div>
    </div>
  </template>
    
<script setup>
import { ref } from 'vue'
import { getCurrentInstance } from 'vue';

// 接收父组件传入的props
const props = defineProps({
    uid: String
})

const app = getCurrentInstance();
const path = app.proxy.$backpath;
const newemail = ref("");
const code = ref("");
const isDisabled = ref(false);
const countdown = ref(60);
const becomereditem = ref("");
const ishowwarning = ref(false);
const warningtext = ref("");
const headers = new Headers();
headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));

// 向父组件发送事件
const emit = defineEmits(['ok', 'cancel'])

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

const sendcode = async() => {
    if (newemail.value === "") {
        becomereditem.value = "newemail";
        ishowwarning.value = true;
        warningtext.value = "请输入新邮箱";
        return;
    }
    let body = {
        mail: newemail.value
    };
    const response = await fetch(`${path}/api/regist/mail?type=regist`, {
        method: 'POST',
        body: JSON.stringify(body),
        headers: headers,
    });
    const data =  await response.json();
    if (data.isok) {
        isDisabled.value = true;
        ishowwarning.value = false;
        startCountdown();
    }
    else{
        ishowwarning.value = true;
        warningtext.value = "验证码发送失败：" + data.failreason;
    }
}

const confirm = async()=>{
    if (newemail.value === "") {
        becomereditem.value = "newemail";
        ishowwarning.value = true;
        warningtext.value = "请输入新邮箱";
        return;
    }
    else if (code.value === "") {
        becomereditem.value = "code";
        ishowwarning.value = true;
        warningtext.value = "请输入验证码";
        return;
    }
    let body = {
        uid: props.uid,
        newemail: newemail.value,
        code: code.value
    };
    const response = await fetch(`${path}/api/changemail`, {
        method: 'POST',
        body: JSON.stringify(body),
        headers: headers,
    });
    
    const data =  await response.json();
    if (data.isok) {
        emit('ok', newemail.value);
    }
    else{
        ishowwarning.value = true;
        warningtext.value = "修改邮箱失败：" + data.failreason;
    }
}

const cancel = ()=>{
    emit('cancel');
}




</script>
    
    <style scoped>
    .dialog {
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      /* background-color: #e6f7ff; */
      background-color: rgb(255, 255, 255);
      border-radius: 12px;
      padding: 24px;
      max-width: 400px;
      width: 90%;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      animation: fadeIn 0.3s ease-out;
      font-family: Arial, sans-serif;
      text-align: center;
    }
    
    .dialog h2 {
      font-size: 1.5rem;
      margin-bottom: 12px;
      color: #333333;
    }

    .warning {
      color: rgb(239, 90, 90);
      margin-top: 10px;
    }
    
    @keyframes fadeIn {
      from { opacity: 0; transform: translate(-50%, -45%); }
      to { opacity: 1; transform: translate(-50%, -50%); }
    }
</style>
    