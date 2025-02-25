<!-- LoginDialog.vue -->
<template>
    <div class="dialog">
      <h2 v-if="props.type==='increase'">增加用户{{sts}}天数</h2>
      <h2 v-else>减少用户{{sts}}天数</h2>
      <p>用户ID:{{ props.uid }}</p>
    <el-divider></el-divider>
        <span>
        <p v-if="props.type==='increase'">增加天数 (最大值: {{ props.type==='increase' ? 365-props.days+1 : props.days - 1 }})</p>
        <p v-else>减少天数 (最大值: {{ props.type==='increase' ? 365-props.days+1 : props.days - 1 }})</p>
        </span>
        <span>
        <el-input-number 
            v-if="props.days >= 1"
            v-model="changedays" 
            :min="1" 
            :max="props.type==='increase'?365-props.days+1:props.days-1" 
            style="margin-top: 10px;">
        </el-input-number>
        </span>
        <el-divider></el-divider>
      <div style="margin-top: 10px;">
        <el-button  @click="confirm" plain type="danger" :disabled="!days">确定</el-button>
        <el-button  @click="cancel" plain type="primary">取消</el-button>
      </div>
    </div>
</template>
    
<script setup>
import { ref } from 'vue'
import { getCurrentInstance } from 'vue';

// 接收父组件传入的props
const props = defineProps({
    uid:String,
    days:Number,
    type:String,
    status:String
})

let sts = props.status == 'baned' ? '封禁' : '禁言'; 
const changedays = ref(1);

const app = getCurrentInstance();
const path = app.proxy.$backpath;
const headers = new Headers();
headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));

// 向父组件发送事件
const emit = defineEmits(['ok','fail'])

const confirm = async() => {
    let uid =  props.uid;
    let body = {
        uid:uid,
        days:props.type ==='increase'?changedays.value:-changedays.value,
    };

    const response = await fetch(path + '/api/adm/modLiftDays',{
        method: 'POST',
        body: JSON.stringify(body),
        headers: headers
    });

    const data =  await response.json();
    if (data.isok){
        emit('ok',props.type ==='increase'?changedays.value:-changedays.value)
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
    