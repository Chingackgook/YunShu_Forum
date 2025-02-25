<template>
    <div class="dialog">
        <h2>封禁\禁言\警告用户</h2>
        <div name="handleuser" class="handle">

            <div style="text-align: middle;">处理用户：{{ props.uid }}</div>
            <el-divider></el-divider>
            <div v-if="props.type === 'Ban'" shadow="hover" style="width: 100%;margin-top: 10px;">
                <div>
                    <el-checkbox v-model="isBan" >封禁用户</el-checkbox>
                </div>
                <div>
                    <el-select v-if="isBan" v-model="Bandays" placeholder="请选择封禁天数"
                        style="width: 50%;margin-left: 10px;">
                        <el-option label="1天" value="1"></el-option>
                        <el-option label="3天" value="3"></el-option>
                        <el-option label="7天" value="7"></el-option>
                        <el-option label="30天" value="30"></el-option>
                        <el-option label="永久" value="-1"></el-option>
                    </el-select>
                </div>
            </div>

            <div v-else-if="props.type === 'Rsd'" shadow="hover" style="width: 100%;margin-top: 10px;">
                <div>
                    <el-checkbox v-model="isRestricked" >禁言用户</el-checkbox>
                </div>
                <div>
                    <el-select v-if="isRestricked" v-model="Restrickeddays" placeholder="请选择禁言天数"
                        style="width: 50%;margin-left: 10px;">
                        <el-option label="1天" value="1"></el-option>
                        <el-option label="3天" value="3"></el-option>
                        <el-option label="7天" value="7"></el-option>
                        <el-option label="30天" value="30"></el-option>
                        <el-option label="永久" value="-1"></el-option>
                    </el-select>
                </div>
            </div>

            <div v-else>
                <div>
                    <el-checkbox v-model="isSendWarning" >发送警告</el-checkbox>
                </div>
                <div>
                    <el-input v-if="isSendWarning" v-model="sendWarningcontent" 
                        type="textarea"
                        placeholder="请输入警告内容"
                        :autosize="{ minRows: 1, maxRows: 8 }"
                        style="width: 70%;"></el-input>
                </div>
            </div>

        </div>
        <el-divider></el-divider>
        <el-button @click="okbutclicked" type="primary" size="large" plain
            style="margin-top: 20px;">确定</el-button>
        <el-button @click="emit('fail', 'cancel')" type="danger" size="large" plain
            style="margin-top: 20px;">取消</el-button>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import { getCurrentInstance } from 'vue'

// 接收父组件传入的props
const props = defineProps({
    uid: String,
    type: String,
})

const app = getCurrentInstance()
const path = app.proxy.$backpath

const isBan = ref(false)
const Restrickeddays = ref(null)
const isRestricked = ref(false)
const Bandays = ref(null)
const isSendWarning = ref(false)
const sendWarningcontent = ref(null)
const newstatus = ref('')
const headers = new Headers();
headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));


// 向父组件发送事件
const emit = defineEmits(['ok', 'fail'])

const okbutclicked = async () => {
    let type = props.type
    console.log(type)
    let data

    if (isBan.value && Bandays.value == null) {
        alert('请选择封禁天数')
        return
    }
    if (isBan.value) {
        //封禁用户
        const body = {
            uid: props.uid,
            day: Bandays.value,
            type: 'baned',
        }
        const fetchstr = path + '/api/adm/dBan' + "?uid=" + props.uid + "&day=" + Bandays.value + "&type=baned"
        const response = await fetch(fetchstr, {
            method: 'POST',
            body: JSON.stringify(body),
            headers: headers,
        })
        data = await response.json()
        if (data.isok) {
            newstatus.value = 'baned'
            console.log('ok')
            emit('ok', newstatus.value, Bandays.value)
            return
        } else {
            console.log('fail')
            emit('fail', data.failreason)
            return
        }
    }

    if (isRestricked.value && Restrickeddays.value == null) {
        alert('请选择禁言天数')
        return
    }
    if (isRestricked.value) {
        //禁言用户
        const body = {
            uid: props.uid,
            day: Restrickeddays.value,
            type: 'restrickted',
        }
        const fetchstr = path + '/api/adm/dBan' + "?uid=" + props.uid + "&day=" + Restrickeddays.value + "&type=restrickted"
        const response = await fetch(fetchstr, {
            method: 'POST',
            body: JSON.stringify(body),
            headers: headers,
        })
        const data = await response.json()
        if (data.isok) {
            newstatus.value = 'restrickted'
            console.log('ok')
            emit('ok', newstatus.value, Restrickeddays.value)
            return
        } else {
            console.log('fail')
            emit('fail', data.failreason)
            return
        }
    }

    if (isSendWarning.value && sendWarningcontent.value == null) {
        alert('请输入警告内容')
        return
    }
    if (isSendWarning.value) {
        //发送警告
        const body = {
            content: sendWarningcontent.value,
        }
        const fetchstr = path + '/api/adm/dWarn'+ "?uid=" + props.uid 
        const response = await fetch(fetchstr, {
            method: 'POST',
            body: JSON.stringify(body),
            headers: headers,
        })
        data = await response.json()
        if (data.isok) {
            console.log('ok')
            emit('ok','',0)
            return
        } else {
            console.log('fail')
            emit('fail', data.failreason)
            return
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

.handle {
    margin-top: 20px;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translate(-50%, -45%);
    }
    to {
        opacity: 1;
        transform: translate(-50%, -50%);
    }
}
</style>