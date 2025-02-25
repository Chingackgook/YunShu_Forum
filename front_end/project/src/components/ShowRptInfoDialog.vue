<!-- LoginDialog.vue -->
<template>
    <div class="dialog" v-if="ready">
        <h2>举报类型：{{ typestr }}</h2>
        <div style="display: flex; flex-direction: row; justify-content: space-between;">
        <div class="maincard" :style="{width: props.type=='log'?'100%':'50%'}">
            <h4 style = "text-align: left;">帖子内容：</h4>
            <h3>{{ logdata.title }}</h3>
            <p>{{ logdata.content }}</p>
            <div class="image-container">
                <div v-for="image in logdata.images" :key="image" class="image-wrapper">
                <img :src="image" alt="图片" @click="showuimage()" class="image" />
                </div>
            </div>
        </div>

        <div class="maincard" v-if="props.type!='log'" style="width: 50%;">

            <h4 style = "text-align: left;">评论内容：</h4>

            <div>
                {{ commentdata.uname }}:
                {{ commentdata.content }}
            </div>



            <div v-if="props.type=='reply'">

          
                <h4 style = "text-align: left;"> 
                {{  '----------------------------------------------------回复内容：'}}
                </h4>
                {{ replydata.uname }}:
                {{ replydata.content }}
            </div>
        </div>
        <el-image-viewer
            v-if="isshowuimage"
            :url-list="logdata.images"
            @close="showuimage"
            :hide-on-click-modal="true"
            :infinite="false"
        />
    </div>
    <el-button @click="emit('ok')" style="margin-top: 5px;">确定</el-button>
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
    })

    const isshowuimage = ref(false);

    const app = getCurrentInstance();
    const path = app.proxy.$backpath;
    const myuid = sessionStorage.getItem('uid');
    const ready = ref(false);
    const typestr = ref(props.type=='log'?'帖子':(props.type=='comment'?'评论':'回复'));
    const headers = new Headers();
    headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));

    // 向父组件发送事件
    const emit = defineEmits(['ok']);
    const logdata= ref(null);
    const commentdata= ref(null);
    const replydata= ref(null);

    const fetchinfo = async () => {
        try{
            let querystr = '?logid=' + props.logid + '&commentid=' + props.commentid + '&replyid=' + props.replyid
            + '&uid=' + myuid + '&type=' + props.type;
            const res = await fetch(path + '/api/adm/getreportinfo' + querystr, {
                method: 'GET',
                headers: headers,
            });
            const data =await res.json();
            logdata.value = data.loginfo;
            commentdata.value = data.commentinfo;
            replydata.value = data.replyinfo;
            ready.value = true;
        }
        catch(err){
            emit('ok');
        }
        if(logdata.value==null){
            emit('ok');
        }
    };

    onMounted(() => {
        fetchinfo();
    });

    const showuimage = () => {
      isshowuimage.value = !isshowuimage.value;
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
    max-width: 600px;
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

.maincard {
    margin-top: 20px;
    padding: 10px;
    border: 1px solid #d9d9d9;
    border-radius: 5px;
    background-color: #f9f9f9;
}

.image-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
}

.image-wrapper {
  margin-right: 5px;
}

.image {
  cursor: pointer;
  width: 60pt;
  height: 60pt;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translate(-50%, -45%); }
    to { opacity: 1; transform: translate(-50%, -50%); }
}
</style>
    