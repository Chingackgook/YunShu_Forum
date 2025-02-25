<template>


  <div :class="{disabled: maindeskreadonly}" 
  style="margin-left: 10%; margin-right: 10%; ">

    <div >
      <img src="../assets/newLogElement.png" alt="新建帖子元素" 
          style="width: 200px; height: 100px;
          position: relative; bottom: 0px; right: 50px;"
      />
    </div>

    <h1 class="customTitle">&nbsp;新建帖子</h1>
    <el-card class="maincard">
      <h4 style="font-size: 14pt;" >帖子标题</h4>
      <div style="margin-bottom: 20px;">
        <el-input v-model="inputTitle" placeholder="请输入帖子标题"
                type="textarea"
                style="width: 80%;font-size: larger;color: black;font-size: 11pt;">
        </el-input>
      </div>
      <h4 style="font-size: 14pt;">主题</h4>
      <div>
        <el-tag 
          v-for="subject in subjects" 
          :key="subject" 
          @click="removeSubject(subject)"
          @mouseover="taghovered = subject"
          @mouseleave="taghovered = null"
          :class="{ 'hovered-tag': taghovered === subject }"
          style="font-size: 10pt; cursor: pointer; margin-right: 5pt;">
          #{{ subject }}
        </el-tag>

        <!-- <el-button 
          @click="addingsubject" 
          type="primary" 
          size="medium" 
          style="
            margin-top: 10px; 
            width: 100pt; 
            height: 40pt; 
            "
        >
         添加主题
        </el-button> -->

        <div style="margin-top: 10px;">
          <el-input v-model="newsubject" placeholder="请输入主题" 
          style="width:20%; margin-top:1px;"/>
          <el-button @click="addsubject" size="small" style="margin-left: 20px;">添加</el-button>
        </div>
      </div>
      <h4 style="font-size: 14pt;">帖子内容</h4>
      <div style="margin-top: 20px;">
        <el-input v-model="inputValue" placeholder="请输入帖子内容"
                type="textarea"
                :autosize="{minRows: 10}"
                style="width: 80%; height: 38%;font-size: 11pt;">
        </el-input>
      </div>
      <div>
        <el-checkbox v-model="needFriend">仅好友可见</el-checkbox>
      </div>
    </el-card>

    <el-card class="maincard">
      <h4 style="font-size: 14pt;">上传图片</h4>
      <div class="image-upload-container">
        <!-- 图片上传和显示 -->
        <div v-for="(img, index) in imgBase64" :key="index" class="image-box">
          <img :src="img" alt="Uploaded Image" />
          <button class="delete-button" @click="removeImg(index)">×</button> <!-- 删除按钮 -->
        </div>
        <!-- 上传图片的正方形按钮 -->
        <div class="image-box upload-button" @click="triggerUpload">
          <span>+</span>
        </div>
        <!-- 隐藏的上传输入框 -->
        <input type="file" @change="uploadImg" ref="fileInput" 
        accept="image/*"
        multiple style="display: none;">
      </div>
    </el-card>

    <div class="button-container">
      <el-button 
        type="primary" 
        @click="sendData" 
        style="
          margin-top: 10px; 
          width: 200pt; 
          height: 80pt; 
          text-align: center; 
          color: rgb(230, 230, 230);
          font-Family: 'MyCustomFont';
          font-Size: 45px ;" 
      >
        发布
      </el-button>
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
    @confirm="sureButPush"
    @cancel="cancelButPush"
  ></myDialog>

  <div style="height: 60px;"></div>
</template>


<script>
import { ref, getCurrentInstance } from 'vue';
import myDialog from './Mydialog.vue';
import router from '@/router';

export default {
  name: 'NewLog',
  components: {
    myDialog,
  },
  setup() {
    const inputValue = ref('');
    const inputTitle = ref(''); // 新增帖子标题
    const needFriend = ref(false);
    const imgBase64 = ref([]); // 存储多张图片的Base64字符串
    const uid = sessionStorage.getItem('uid');
    const app = getCurrentInstance();
    const path = app.proxy.$backpath;
    const subjects = ref([]);
    const isadding = ref(false);
    const newsubject = ref('');
    const fileInput = ref(null); // 用于引用隐藏的文件输入框
    const logid = ref(null);
    const taghovered = ref(null);
    const headers = new Headers();
    headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));

      //对话框
      let dialogsurefunc =() => null;
      let dialogcancelfunc = () => null;
      const dialogtitle = ref('');
      const dialogtext = ref('');
      const dialogneedcancelbut = ref(false);
      const dialogsurebuttext = ref('');
      const dialogcancelbuttext = ref('');
      const dialogvisible = ref(false);
      const maindeskreadonly = ref(false);
      const sureButPush = () => {
        dialogvisible.value = false;
        maindeskreadonly.value = false;
        dialogsurefunc();
      };
      const cancelButPush = () => {
        dialogvisible.value = false;
        maindeskreadonly.value = false;
        dialogcancelfunc();
      };
      const showdialog = (title, text, 
        needcancelbut, surebuttext, cancelbuttext,
        surefuc=()=>null, cancelfuc=()=>null
      ) => {
        dialogtitle.value = title;
        dialogtext.value = text;
        dialogneedcancelbut.value = needcancelbut;
        dialogsurebuttext.value = surebuttext;
        dialogcancelbuttext.value = cancelbuttext;
        dialogvisible.value = true;
        maindeskreadonly.value = true;
        dialogsurefunc = surefuc;
        dialogcancelfunc = cancelfuc;
      };
      const tohome = () => {
        window.location.href = '/home';
      };
      const tolog = () => {
        router.push('/log/' + logid.value);
      };
      //对话框结束

    const sendData = async () => {
      for(let i =0;i<subjects.value.length;i++){
        if(subjects.value[i].length>0 &&subjects.value[i][0] != '#')
        subjects.value[i] = "#" + subjects.value[i];
      }
      let body = {
        title: inputTitle.value,
        content: inputValue.value,
        needfriend: needFriend.value,
        subject: subjects.value,
        images: imgBase64.value // 将Base64数组添加到请求体中
      };
      if (inputTitle.value === '') {
        showdialog('发帖失败', '标题不能为空', false, '确定', '');
        return;
      }
      else if(inputValue.value === '') {
        showdialog('发帖失败', '内容不能为空', false, '确定', '');
        return;
      }
      maindeskreadonly.value = true;
      try{
        const response = await fetch(path + '/api/newlog?uid=' + uid, {
          method: 'POST',
          body: JSON.stringify(body),
          headers: headers,
        });
        const data =  await response.json();
        if (data.isok) {
          logid.value = data.logid;
          showdialog('发帖成功', null,true, '返回主页', '查看帖子', tohome, tolog);
        }
        else{
          showdialog('发帖失败', data.failreason, false, '确定', '');
        }
      }catch(e){
        showdialog('发帖失败', '网络错误', false, '确定', '');
      }
    };

    const uploadImg = (event) => {
      const files = Array.from(event.target.files); // 获取上传的所有文件
      files.forEach(file => {
        if(file.type.indexOf('image') === -1) {
          showdialog('上传失败', '请上传图片文件', false, '确定', '');
          return;
        }
        const reader = new FileReader();
        reader.onloadend = () => {
          imgBase64.value.push(reader.result); // 将Base64字符串添加到数组中
        };
        reader.readAsDataURL(file); // 读取文件为Data URL（Base64格式）
      });
    };

    const removeImg = (index) => {
      imgBase64.value.splice(index, 1); // 移除指定索引的图片
    };

    const addingsubject = () => {
      isadding.value = true;
    };

    const addsubject = () => {
      if(newsubject.value === ''){
        return;
      }
      else if(newsubject.value.length>15){
        showdialog('添加失败', '主题长度不能超过15个字符', false, '确定', '');
        return;
      }
      for (let i = 0; i < subjects.value.length; i++) {
        if (subjects.value[i] === newsubject.value) {
          showdialog('添加失败', '该主题已存在', false, '确定', '');
          return;
        }
      }
      subjects.value.push(newsubject.value);
      isadding.value = false;
      newsubject.value = '';
    };

    const removeSubject = (subject) => {
      const index = subjects.value.indexOf(subject);
      if (index > -1) {
        subjects.value.splice(index, 1); // 移除指定主题
      }
    };

    const triggerUpload = () => {
      // 触发隐藏的文件输入框
      fileInput.value.click();
    };

    document.title = '发布帖子-云枢论坛';
    return {
      inputValue,
      inputTitle,
      sendData,
      needFriend,
      uploadImg,
      imgBase64,
      triggerUpload,
      removeSubject,
      removeImg,
      fileInput,
      subjects,
      isadding,
      addingsubject,
      newsubject,
      addsubject,
      dialogtitle,
      dialogtext,
      dialogneedcancelbut,
      dialogsurebuttext,
      dialogcancelbuttext,
      dialogvisible,
      maindeskreadonly,
      sureButPush,
      cancelButPush,
      taghovered,
      
    }
  }
}
</script>


<style scoped>
/* 可以在这里添加样式 */

.main {
  background: linear-gradient(to bottom right, #e6f7ff, #ffffff);
  /* background-image: url('./assets/background.jpg'); */
  background-image: url('../assets/background8.png');
  background-size: cover;
  background-repeat: repeat;
  background-position: center;
  min-height: 100vh;
  overflow: hidden;
}

@font-face {
  font-family: 'MyCustomFont';
  src: url('../assets/Font.ttf') format('truetype');
}

.customTitle{
  color: rgb(230, 230, 230);
  font-Family: 'MyCustomFont';
  font-Size: 50px ;
  margin-Bottom: 45px;
  letter-Spacing: 5px;
  margin-top:-85px;
  margin-left:5%;
  /* margin-left: 35px; */
  font-weight: 200;
  text-align: left;
}

</style>

<style scoped>
.image-upload-container {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.image-box {
  position: relative;
  width: 100px;
  height: 100px;
  border: 1px solid #ccc;
  display: flex;
  justify-content: center;
  align-items: center;
  cursor: pointer;
  background-color: #f0f0f0;
}

.image-box img {
  max-width: 100%;
  max-height: 100%;
}

.upload-button {
  background-color: white;
  border: 1px dashed #ccc;
}

.upload-button span {
  font-size: 24px;
  color: #ccc;
}

.delete-button {
  position: absolute;
  top: 5px;
  left: 5px;
  background-color: red;
  color: white;
  border: none;
  border-radius: 50%;
  width: 20px;
  height: 20px;
  display: none;
  justify-content: center;
  align-items: center;
  cursor: pointer;
}

.hovered-tag {
  background-color: rgb(244, 132, 132) !important;
  color: white; /* 可选，让字体颜色对比明显 */
}


.image-box:hover .delete-button {
  display: flex;
}


.disabled {
  pointer-events: none;
  opacity: 0.5;
}

.maincard {
  margin-top: 10px;
  background-image: url('../assets/uBackground.png');
  background-size: cover; 
  background-repeat: repeat; 
  background-position: center; 
}

.button-container {
  display: flex;
  justify-content: flex-end; /* 水平居中 */
  align-items: center; /* 垂直居中 */
}

</style>
