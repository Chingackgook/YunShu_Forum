<!-- LoginDialog.vue -->
<template>
  <div class="dialog">
    <h2>{{ props.dialogtitle }}</h2>
    <p>{{ props.dialogtext }}</p>
    <el-button size="large" @click="confirm">{{ props.dialogsurebuttext }}</el-button>
    <el-button  size="large" v-if="props.dialogneedcancelbut" @click="cancel">{{ props.dialogcancelbuttext }}</el-button>
  </div>
</template>
  
  <script setup>
  
  // 接收父组件传入的props
  const props = defineProps({
    dialogtitle: String,// 标题
    dialogtext: String,// 提示文案
    dialogneedcancelbut: Boolean,// 是否显示取消按钮
    dialogsurebuttext: String,// 确定按钮文案
    dialogcancelbuttext: String// 取消按钮文案
  })
  
  // 向父组件发送事件
  const emit = defineEmits(['confirm', 'cancel'])
  
  const confirm = () => {
    emit('confirm')
  }
  
  const cancel = () => {
    emit('cancel')
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
    /* background-image: url('../assets/dialogBg.png');
    background-repeat: repeat;
    background-position:center; */


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
  