<template>
    <div class="dialog">
        <h2>处理举报</h2>
        <p>处理用户：{{ props.uid }}</p>
        <el-divider></el-divider>
        <div name="handleuser" class="handleuser">
            <div>
                <el-checkbox v-model="isBan" :disabled="isignore||isRestricked||isSendWarning" >封禁用户，并删除举报内容</el-checkbox>
            </div>
            <div>
                <el-select v-if="isBan" v-model="Bandays" placeholder="请选择封禁天数"
                style="width: 400%;">
                    <el-option label="1天" value="1"></el-option>
                    <el-option label="3天" value="3"></el-option>
                    <el-option label="7天" value="7"></el-option>
                    <el-option label="30天" value="30"></el-option>
                    <el-option label="永久" value="-1"></el-option>
                </el-select>
            </div>

            <div>
                <el-checkbox v-model="isRestricked" :disabled="isignore||isBan||isSendWarning">禁言用户，并删除举报内容</el-checkbox>
            </div>

            <div>
                <el-select v-if="isRestricked" v-model="Restrickeddays" placeholder="请选择禁言天数"
                style="width: 400%;"
                >
                    <el-option label="1天" value="1"></el-option>
                    <el-option label="3天" value="3"></el-option>
                    <el-option label="7天" value="7"></el-option>
                    <el-option label="30天" value="30"></el-option>
                    <el-option label="永久" value="-1"></el-option>
                </el-select>
            </div>

            <div>
                <el-checkbox v-model="isSendWarning" :disabled="isignore||isBan||isRestricked">发送警告，并删除举报内容</el-checkbox>
            </div>

            <div>
                <el-input v-if="isSendWarning" v-model="sendWarningcontent" placeholder="请输入警告内容"
                :autosize="{ minRows: 1, maxRows: 8 }" type="textarea"
                style="width: 100%; margin-left: 5%;"
                ></el-input>
            </div>

            <div>
                <el-checkbox v-model="isignore" @change="ignoreselect"
            >无违规，不做处理</el-checkbox>
            </div>

        </div>

        <el-divider></el-divider>
        <el-button @click="okbutclicked" type="primary" size="large" plain
            style="margin-top: 20px;">确定</el-button>
        <el-button @click="emit('fail', 'cancle')" type="danger" size="large" plain
            style="margin-top: 20px;">取消</el-button>
    </div>
  </template>
    
<script setup>
import { onMounted, ref } from 'vue'
import { getCurrentInstance } from 'vue';

// 接收父组件传入的props
const props = defineProps({
    type: String,
    logid: String,
    commentid: String,
    replyid: String,
    uid: String,
    somecontent: String,
    rid: String,
    ruid: String,
})


const app = getCurrentInstance();
const path = app.proxy.$backpath;
const headers = new Headers();
headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));

const isBan = ref(false);
const Restrickeddays = ref(null);
const isRestricked = ref(false);
const Bandays = ref(null);
const isSendWarning = ref(false);
const sendWarningcontent = ref(null);

const isdeletecontent = ref(false);

const isignore = ref(false);

const ignoreselect = () => {
    if (isignore.value) {
        isBan.value = false;
        isRestricked.value = false;
        isSendWarning.value = false;
        isdeletecontent.value = false;
    }
}


// 向父组件发送事件
const emit = defineEmits(['ok', 'fail']);

const okbutclicked = async() => {
    let type = props.type;
    console.log(type);
    let data ;
    if(isignore.value||(!isBan.value&&!isRestricked.value&&!isSendWarning.value&&!isdeletecontent.value)){
        //无违规，不做处理
        if(!isignore.value){
            emit('fail', '未选择任何处理方式');
        }
        const body ={
            rid: props.rid,
            type: props.type == 'log' ? 'log' : 'comment',
        }
        let typestr = props.type == 'log' ? 'log' : 'comment';
        const fetchstr = path + '/api/adm/reportok'+ "?rid=" + props.rid + "&type=" + typestr;
        const response = await fetch(fetchstr, {
            method: 'POST',
            body: JSON.stringify(body),
            headers: headers,
        });
        data = await response.json();
        if(data.isok){
            console.log('ok');
            emit('ok');
            return;
        }
        else{
            console.log('fail');
            emit('fail', data.failreason);
            return;
        }
    }
    else {
        if(isBan.value && Bandays.value==null){
            alert('请选择封禁天数');
            return;
        }
        if(isRestricked.value && Restrickeddays.value==null){
            alert('请选择禁言天数');
            return;
        }
        if(isSendWarning.value && sendWarningcontent.value==null){
            alert('请输入警告内容');
            return;
        }
        if(isBan.value){
            //封禁用户并删除内容
            const body={
                uid: props.uid,
                day: Bandays.value,
                type: 'ban',
                rtype: props.type,//违规类型
                id: props.type=='log'?props.logid:(props.type=='comment'?props.commentid:props.replyid),
                rid: props.rid,
                ruid: props.ruid,
            }
            let idstr = props.type=='log'?props.logid:(props.type=='comment'?props.commentid:props.replyid);
            console.log(body);
            let fetchstr = path + 
            '/api/adm/gagandenclose'+"?uid="
            +props.uid+"&day="
            +Bandays.value
            +"&type=ban&rtype="
            +props.type
            +"&id="+idstr
            +"&rid="
            +props.rid
            +"&ruid="
            +props.ruid;
            const response = await fetch(fetchstr, {
                method: 'POST',
                body: JSON.stringify(body),
                headers: headers,
            });
            data = await response.json();
            if(data.isok){
                console.log('ok');
                emit('ok');
                return;
            }
            else{
                console.log('fail');
                emit('fail', data.failreason);
                return;
            }
        }
        if(isRestricked.value){
            //禁言用户并删除内容
            const body={
                uid: props.uid,
                day: Restrickeddays.value,
                type: 'restrick',
                rtype: props.type,//违规类型
                id: props.type=='log'?props.logid:(props.type=='comment'?props.commentid:props.replyid),
                rid: props.rid,
                ruid: props.ruid,
            }
            let idstr = props.type=='log'?props.logid:(props.type=='comment'?props.commentid:props.replyid);
            const fetchstr = path 
                + '/api/adm/gagandenclose'
                +"?uid="+props.uid
                +"&day="+Restrickeddays.value
                +"&type=restrick&rtype="
                +props.type
                +"&id="
                +idstr
                +"&rid="
                +props.rid
                +"&ruid="
                +props.ruid;

            // const fetchstr = path + '/api/adm/gagandenclose';
            const response = await fetch(fetchstr, {
                method: 'POST',
                body: JSON.stringify(body),
                headers: headers,
            });
            const data = await response.json();
            if(data.isok){
                console.log('ok');
                emit('ok');
                return;
            }
            else{
                console.log('fail');
                emit('fail', data.failreason);
                return;
            }
        }
        if(isSendWarning.value){
            //发送警告并删除内容
            const body={
                content: sendWarningcontent.value,
            }
            let typestr = props.type == 'log' ? 'log' : 'comment';
            const fetchstr = path 
                + '/api/adm/sendinfo' 
                + "?uid=" + props.uid 
                // + "&content=" 
                // + sendWarningcontent.value 
                + "&ruid=" + props.ruid 
                + "&type=" + typestr
                + "&rid=" + props.rid

            const response = await fetch(fetchstr, {
                method: 'POST',
                body: JSON.stringify(body),
                headers: headers,
            });
            data = await response.json();
            if(data.isok){
                console.log('ok');
                emit('ok');
                return;
            }
            else{
                console.log('fail');
                emit('fail', data.failreason);
                return;
            }
        }
    }
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

    .handleuser{
        display: flex; 
        flex-direction: column; 
        align-items: flex-start;
    }
    
    .handleuser div{
        margin-left: 20%;
        width: auto;
    }
    
    @keyframes fadeIn {
      from { opacity: 0; transform: translate(-50%, -45%); }
      to { opacity: 1; transform: translate(-50%, -50%); }
    }
    </style>
    