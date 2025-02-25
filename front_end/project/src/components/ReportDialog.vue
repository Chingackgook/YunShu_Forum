<!-- LoginDialog.vue -->
<template>
    <div class="dialog">
      <h2>举报</h2>
      <p>{{ props.explain }}</p>
      <el-radio-group v-model="reporttype" 
      style="display: flex;justify-content: left;margin-left: 10%; margin-bottom: 10px;
      ">
        <el-radio :value="1">色情暴力</el-radio>
        <el-radio :value="2">政治敏感</el-radio>
        <el-radio :value="3">引人不适</el-radio>
        <el-radio :value="4">违法犯罪</el-radio>
        <el-radio :value="5">侵犯隐私</el-radio>
        <el-radio :value="6">垃圾广告</el-radio>
        <el-radio :value="7">不实信息</el-radio>
        <el-radio :value="8">我不喜欢</el-radio>
        <el-radio :value="0">其他类型</el-radio>
      </el-radio-group>
      <el-input v-model="reasontext" type="textarea" :autosize="{ minRows: 2, maxRows: 4 }"
      style=" width: 80%;"
      placeholder="请填写举报理由"></el-input>
      <div style="margin-top: 10px;">
        <el-button  @click="confirm" plain type="danger">举报</el-button>
        <el-button  @click="cancel" plain type="primary">取消</el-button>
      </div>
    </div>
  </template>
    
<script setup>
import { ref } from 'vue'
import { getCurrentInstance } from 'vue';

// 接收父组件传入的props
const props = defineProps({
    logid:String,
    commentid:String,
    replyid:String,
    myuid:String,
    explain:String
})


const reporttype = ref(0);
const reasontext = ref("");
const app = getCurrentInstance();
const path = app.proxy.$backpath;
const headers = new Headers();
headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));

// 向父组件发送事件
const emit = defineEmits(['ok', 'fail'])

const confirm = async() => {
    let logid = props.logid;
    let commentid = props.commentid;
    let replyid = props.replyid;
    let reportname= '';
    let myuid = props.myuid;
    if(replyid!=""){
        reportname= 'reply';
    }
    else if(commentid!=""){
        reportname= 'comment';
    }
    else{
        reportname= 'log';
    }
    let reporttypestr="";
    switch(reporttype.value){
        case 1:
            reporttypestr="色情低俗";
            break;
        case 2:
            reporttypestr="政治反动";
            break;
        case 3:
            reporttypestr="引人不适";
            break;
        case 4:
            reporttypestr="违法犯罪";
            break;
        case 5:
            reporttypestr="侵犯隐私";
            break;
        case 6:
            reporttypestr="垃圾广告";
            break;
        case 7:
            reporttypestr="不实信息";
            break;
        case 8:
            reporttypestr="我不喜欢";
            break;
        default:
            reporttypestr="其他";
            break;
    }
    let body = {
        reporttarget: reportname,
        uid: myuid,
        logid: logid,
        commentid: commentid,
        replyid: replyid,
        type: reporttypestr,
        reason: reasontext.value
    };
    const response = await fetch(path + '/api/report', {
        method: 'POST',
        body: JSON.stringify(body),
        headers: headers,
    });
    const data =  await response.json();
    if (data.isok){
        emit('ok')
    }
    else{
        emit('fail',data.failreason)
    }
}

const cancel = () => {
    emit('fail','cancel')
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

.dialog p {
    font-size: 1rem;
    color: #666666;
    margin-bottom: 20px;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translate(-50%, -45%); }
    to { opacity: 1; transform: translate(-50%, -50%); }
}
</style>
    