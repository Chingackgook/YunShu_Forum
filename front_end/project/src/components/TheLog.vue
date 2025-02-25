<!-- LogDetail.vue -->
<template>
  <div v-if="ready" :class="{ disabled: maindeskreadonly }" 
  style="margin-left: 10%; margin-right: 10%;">
    <div class="header">

      <el-card class="ucard">
        <div style="display: flex; 
        flex-direction: column;
        align-items: center; 
        justify-content: space-between;">
          <div style="display: flex; align-items: center; cursor: pointer;" @click="toperinfo(log.uid)">

              <el-avatar :src="uimage ? uimage.src : '../assets/loading.png'" style="margin-right: 80px" :size="90" />
            <span style="font-size: 20px;line-height: 1.5;">
              <div>
                <span style="margin-left: -50px;">{{ log.uname }}</span>
              </div>
              <div>
                <span style="font-size: 14px; color: #999;margin-left: -50px;">(uid:{{ log.uid }})</span>
              </div>
            </span>
          </div>
        </div>
      </el-card>

      <el-card class="titlecard">
        <div style="display: flex; align-items: center; justify-content: space-between;">
          <div style="display: flex; align-items: center;">
            <span style="font-size: 28px;line-height: 1.2;">
              <div>
                <span>{{ log.title }}</span>
              </div>
              <div>
                <el-tag v-for="subject in log.subjects"
                    class="clickable-tag" style="  
                    margin-right: 10px;
                    font-size: 16px;"
                    @click="tosearch(subject)"
                >
                {{ subject }}
                </el-tag>
              </div>
              <div>
                <span class="viewtext">浏览量：{{ log.viewnum }}</span>
              </div>
            </span>
          </div>
          <span style="font-size: 20px; color: #999;">
            <div style="display: flex; flex-direction: column; align-items: flex-end;">
              
              <span v-if="log.uid == myuid||isadmin" style="font-size: 14px; color: #999;">
                
                <el-button type="danger" @click="goingdelete('log', logId)" plain
                  >删帖
                </el-button>
              
              </span>
              
              <div v-else style="display: flex; flex-direction: column;align-items: flex-end;">
                
                <el-button v-if="!log.isattion" @click="attionusr()" type="primary" style="width: 100%;"
                  >关注
                </el-button>
                
                <el-button v-else @click="attionusr()" type="primary" style="width: 100%;"
                plain 
                  >取消关注
                </el-button>

                <!--举报按钮-->
                <el-button @click="report(logId)" style="margin-top: 10px; width: 100%;"
                type="danger" plain >举报</el-button>
              </div>
            </div>
          </span>
        </div>
      </el-card>
    </div>


    <div v-if="log">
      <el-card class="maincard">
        <p class="maintext">{{ log.content }}</p>
        <el-divider></el-divider>
        <div class="maincard" v-if="images.length > 0">
          <img v-for="image in images" :src="image.src" class="logimage"
          @click="showimage(images.indexOf(image))"
          />
          <p v-if="images.length < log.imagenum">加载中...</p>
        </div>
        <div style="display: flex; justify-content: space-between; align-items: center;
        margin-top: 10px;
        ">
          <span class="smalltext" style="margin-top: 10px;">发布时间:{{ log.time }}</span>
          <span class="log-actions">
            <span @click="likelog" class="action-item">
              <img src="../assets/redheart.png" v-if="log.islike" class="heart-icon" />
              <img src="../assets/blackheart.png" v-else class="heart-icon" />
              <span>{{ log.likenum }}</span>
            </span>
            <span>&nbsp;</span>
            <span @click="collectlog" class="action-item">
              <img src="../assets/collect.png" v-if="log.iscollect" class="collect-icon" />
              <img src="../assets/uncollect.png" v-else class="collect-icon" />
              <span>{{ log.collectnum }}</span>
            </span>
          </span>
        </div>
      </el-card>
    </div>


    <el-card class="maincard">
      <h1 style="font-size: 24px;">评论 共{{ commentsnum }}条</h1>
      <div style="align-items: center; justify-content: center; gap: 10px; margin-bottom: 10px;">
        <el-input v-model="inputComment" placeholder="我来说说" 
        style="width: 50%;" type="textarea" :autosize="{ minRows: 1, maxRows: 6 }"/>
        <el-button v-if="myuid" @click="sendcomment" style="margin-left: 10px;">发送</el-button>
        <el-button v-if="myuid" @click="inputComment=''" style="margin-left: 10px;">清空</el-button>
        <el-button v-else @click="window.location.href = '/login?from=/log/' + logId;"
        style="margin-left: 10px;">登录后评论</el-button>
      </div>
      <el-card class="maincard" v-for="comment in comments" :key="comment.id">
        
        <div style="display: flex; align-items: center;">
          <div @click="toperinfo(comment.uid)" style="cursor: pointer;">
            <img v-if="comment.uimage" :src="comment.uimage" alt="用户头像" style="width: 35px; height: 35px; border-radius: 50%; margin-right: 10px;" />
            <img v-else src="../assets/loading.png" alt="用户头像" style="width: 35px; height: 35px; border-radius: 50%; margin-right: 10px;" />
          </div>
            <!-- 用户名和用户 ID 信息 -->
          <div style="flex-grow: 1; display: flex; align-items: center;">
            <span class="smalltext" @click="toperinfo(log.uid)" style="cursor: pointer;">{{ comment.uname }}</span>
            <span>
              <el-tag v-if="comment.uid == log.uid" type="success" class="uinfotag">楼主</el-tag>
              <el-tag v-if="comment.uid == myuid" type="success" class="uinfotag">我</el-tag>
            </span>
          </div>
        </div>

        <p class="commenttext">{{ comment.content }}</p>

        <div style="
          display: flex;
          justify-content: space-between;
          align-items: center;
        ">
          <div v-if="replyTarget && replyTarget.type == 'comment' && replyTarget.id == comment.id"
          style="width: 100%;">
            <el-input v-model="inputReply" placeholder="回复评论..." 
            style="width: 30%;" size="small" type="textarea" :autosize="{ minRows: 1, maxRows: 6 }"
            />
            <el-button @click="sendReply" size="small" style="margin-left: 10pt;">发送</el-button>
            <el-button @click="cancelReply" size="small">取消</el-button>
          </div>
          <div v-else>
            <el-button @click="setReplyTarget(comment, null)" type="primary" plain size="small">点击回复</el-button>
          </div>

          <div style="display: flex; align-items: center;">
            <!-- 点赞按钮 -->
            <span @click="likecomment(comment)" style="display: flex; align-items: center; cursor: pointer; margin-right: 10px;">
              <img src="../assets/redheart.png" v-if="comment.islike" class="heart-icon" />
              <img src="../assets/blackheart.png" v-else class="heart-icon" />
              <span class="smalltext">{{ comment.likenum }}</span>
            </span>
          </div>
        </div>

        <div style="margin-top: 10pt;align-items: center; display: flex;">
          <span class="smalltext">{{ comment.time }}</span>
          <!--举报按钮---->
          <el-icon class="icon" :size="20">
            <Warning @click="report(logId,comment.id)"/>
          </el-icon>
          <!--删除按钮-->
          <el-icon v-if="comment.uid==myuid||log.uid==myuid||isadmin" class="icon" :size="20">
            <Delete @click="goingdelete('comment',logId,comment.id,null,comment.uid)" />
          </el-icon>
        </div>

        <div name="更多回复" style="margin-top:  10pt; margin-left: 15pt;">
          <div v-if="Array.isArray(comment.replies) && comment.replies.length === 0">
            <el-button v-if="comment.replynum != 0" @click="morereply(comment)"
            text type="primary" size="small">
            展开{{ comment.replynum }}条回复</el-button>
          </div>
          <div v-else>
            <div v-for="reply in comment.replies" :key="reply.id">
              <el-divider></el-divider>
              <div>
                <div style="display: flex; align-items: center;">
                  <img :src="reply.uimage?reply.uimage:'../assets/loading.png'" alt="用户头像" 
                  @click="toperinfo(reply.uid)"
                  style="width: 25px; height: 25px; border-radius: 50%; margin-right: 10px;cursor: pointer;" />
                  <div style="flex-grow: 1; display: flex; align-items: center;">
                    <div class="smallertext">
                      <span @click="toperinfo(reply.uid)" style="cursor: pointer;">{{ reply.uname }}</span>
                      <span>
                        <el-tag v-if="reply.uid == log.uid" type="success" class="uinfotag">楼主</el-tag>
                        <el-tag v-if="reply.uid == myuid" type="success" class="uinfotag">我</el-tag>
                      </span>
                      <span v-if="reply.touid">-></span>
                      <span v-if="reply.touid" @click="toperinfo(reply.touid)" style="cursor: pointer;">{{ reply.touname }}</span>
                      <span>
                        <el-tag v-if="reply.touid == log.uid" type="success" class="uinfotag">楼主</el-tag>
                        <el-tag v-if="reply.touid == myuid" type="success" class="uinfotag">我</el-tag>
                      </span>
                    </div>
                  </div>
                </div>
              </div>

              <p class="replytext">{{ reply.content }}</p>

              <div style="
                display: flex;
                justify-content: space-between;
                align-items: center;
              ">
                <div v-if="replyTarget && replyTarget.type == 'reply' && replyTarget.id == reply.id"
                style="width: 100%;">
                  <el-input v-model="inputReply" placeholder="回复评论..." style="width: 30%;" 
                  size="small" type="textarea" :autosize="{ minRows: 1, maxRows: 6 }"/>
                  <el-button @click="sendReply" size="small" style="margin-left: 10pt;">发送</el-button>
                  <el-button @click="cancelReply" size="small">取消</el-button>
                </div>
                <div v-else>
                  <el-button @click="setReplyTarget(comment, reply)" type="primary" plain size="small">点击回复</el-button>
                </div>

                <div style="display: flex; align-items: center;">
                  <!-- 点赞按钮 -->
                  <span @click="likereply(reply,comment.id)" style="display: flex; align-items: center; cursor: pointer; margin-right: 10px;">
                    <img src="../assets/redheart.png" v-if="reply.islike" class="heart-iconsmall" />
                    <img src="../assets/blackheart.png" v-else class="heart-iconsmall" />
                    <span class="smallertext">{{ reply.likenum }}</span>
                  </span>
                </div>
              </div>
              <div style="margin-top: 10pt; display: flex; align-items: center;">
                <span class="smallertext">{{ reply.time }}</span>
                <!--举报按钮---->
                <el-icon class="icon" :size="20">
                  <Warning @click="report(logId,comment.id,reply.id)"/>
                </el-icon>
                <!--删除按钮-->
                <el-icon v-if="reply.uid==myuid||log.uid==myuid||isadmin" class="icon" :size="20">
                  <Delete @click="goingdelete('reply',logId,comment.id,reply.id,reply.uid)" />
                </el-icon>
              </div>
            </div>
            <el-divider></el-divider>
            <el-button v-if="comment.replies.length >= comment.replynum" @click="morereply(comment)"
            text type="primary" disabled size="small">
            没有更多回复</el-button>
            <el-button v-else @click="morereply(comment)"
            text type="primary" size="small">
            展开{{ comment.replynum-comment.replies.length }}条回复</el-button>
            <el-button @click="lessreply(comment)"
            text type="primary" size="small">
            收起回复</el-button>
          </div>
        </div>
      </el-card>
      <div style="margin-top: 10px;">
        <el-button v-if="comments.length < commentsnum" @click="getmorecom" type="primary" text>
          展开{{ commentsnum - comments.length }}条评论
        </el-button>
        <el-button v-else type="primary" disabled text>没有更多评论</el-button>
      </div>

    </el-card>
  </div>

  <myDialog v-if="dialogvisible" :dialogtitle="diatitle" :dialogtext="dialogtext"
    :dialogneedcancelbut="needcancelbut" :dialogsurebuttext="surebutstr" :dialogcancelbuttext="cancelbutstr"
    @confirm="DialogConfirm()" @cancel="DialogCancel()">
  </myDialog>

  <ReportDialog v-if="reportvisible" :logid="goingreportdata[0]" :commentid="goingreportdata[1]"
    :replyid="goingreportdata[2]" :myuid="goingreportdata[3]" :explain="goingreportdata[4]"
    @ok="reportdialogok" @fail="reportdialogfail">
  </ReportDialog>

  <el-image-viewer
    v-if="isshowimages"
    :url-list="tempimages.map(item => item.src)"
    @close="showimage"
    :hide-on-click-modal="true"
  />
</template>


<script>
import { ref, onMounted, getCurrentInstance } from 'vue';
import * as ElementPlusIconsVue from '@element-plus/icons-vue'
import myDialog from './Mydialog.vue';
import ReportDialog from './ReportDialog.vue';
import router from '@/router';
export default {
  name: 'LogDetail',
  components: {
    Delete: ElementPlusIconsVue.Delete,
    Warning: ElementPlusIconsVue.Warning,
    myDialog,
    ReportDialog,
  },
  setup() {
    const timetool = (date) => {
      return date.getFullYear() + '-' +
           String(date.getMonth() + 1).padStart(2, '0') + '-' +
           String(date.getDate()).padStart(2, '0') + ' ' +
           String(date.getHours()).padStart(2, '0') + ':' +
           String(date.getMinutes()).padStart(2, '0') + ':' +
           String(date.getSeconds()).padStart(2, '0');
    }

    const app = getCurrentInstance();
    const path = app.proxy.$backpath;
    const log = ref(null);
    const uid = ref(null);
    const uimage = ref(null);
    const myuid = sessionStorage.getItem('uid');
    const uname = ref(null);
    const logId = window.location.pathname.split('/').pop();
    const comments = ref([]);
    const commentsnum = ref(0);
    const inputReply = ref('');
    const inputComment = ref('');
    const replyTarget = ref(null);
    const images = ref([]);
    const ready = ref(false);
    const goingdeletedata = ref([]);
    const goingdeletedatauid = ref(null);
    const isadmin = sessionStorage.getItem('isadmin');
    const headers = new Headers();
    headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));
    //对话框的属性
    const diatitle = ref('提示');
    const needcancelbut = ref(true);
    const cancelbutstr = ref('取消');
    const surebutstr = ref('登录');
    const dialogtext = ref('');
    const maindeskreadonly = ref(false);
    const dialogvisible = ref(false);
    let dialogsurefunc = () => null;
    let dialogcancelfunc = () => null;
    //举报对话框
    const reportvisible = ref(false);
    const goingreportdata = ref([]);
    //显示图片详情
    const isshowimages = ref(false);
    const tempimages = ref([]);
    const showimage=(index=-1)=>{
      tempimages.value = [];
      isshowimages.value = !isshowimages.value;
      if(index!=-1){
        for (let i=index; i<images.value.length; i++) {
          tempimages.value.push(images.value[i]);
        }
        for (let i=0; i<index; i++) {
          tempimages.value.push(images.value[i]);
        }
      }
    }

    const fetchLogDetail = async () => {
      let fetchstr = null;
      if (myuid) {
        fetchstr = `${path}/api/logs/alog?id=${logId}&uid=${myuid}`;
      }
      else {
        fetchstr = `${path}/api/logs/alog?id=${logId}`;
      }
      const response = await fetch(fetchstr);
      //如果是404，说明没有这个帖子
      if(response.status==404){
        showdialog('提示','帖子不存在',false,'返回主页','确定',()=>{window.location.href = '/';});
        return;
      }
      log.value =  await response.json();
      if(!log.value.subjects||log.value.subjects[0]==''){
        log.value.subjects = null;
      }
      console.log(log.value);
      uid.value = log.value.uid;
      uname.value = log.value.uname;
      comments.value = log.value.comments;
      if (!comments.value) {
        comments.value = [];
      }
      commentsnum.value = log.value.comnum;
      console.log(commentsnum.value);
      document.title = log.value ? log.value.title : ''+'-云枢论坛';
      for (let i = 0; i < comments.value.length; i++) {
        comments.value[i].replies = [];
      }
      uimage.value = new Image();
      uimage.value.src = log.value.uimage;
      for (let i = 0; i < log.value.imagenum; i++) {
        const response = await fetch(`${path}/api/logs/image?logid=${logId}&imageid=${i}`);
        const data = await response.json();
        let image = new Image();
        image.src = data.url;
        images.value.push(image);
      }
      ready.value = true;
    };
    const sendcomment = async () => {
      if( inputComment.value.trim() === '') {
        showdialog('提示', '评论内容不能为空', false, '确定', '确定');
        return;
      }
      let body = {
        content: inputComment.value,
      };
      const response = await fetch(path + '/api/newcomment?uid=' + myuid + '&logid=' + logId, {
        method: 'POST',
        body: JSON.stringify(body),
        headers: headers,
      });
      const data =  await response.json();
      if (data.isok) {
        showdialog('提示', '评论成功', false, '确定', '确定');
        let newcom = {
          id: data.id,
          uid: myuid,
          uname: sessionStorage.getItem('uname'),
          content: inputComment.value,
          time: timetool(new Date()),
          islike: false,
          likenum: 0,
          replynum: 0,
          replies: [],
          uimage: sessionStorage.getItem('uimage'),
        };
        comments.value.unshift(newcom);
        inputComment.value = '';
        commentsnum.value++;
        showdialog('提示', '评论成功', false, '确定', '确定');
      }
      else {
        showdialog('提示', data.failreason, false, '确定', '确定');
      }
    }

    const setReplyTarget = (comment, reply) => {
      if (!myuid) {
        showdialog('提示', '登录后可回复', true, '登录', '取消', tologin, () => null);
        return;
      }
      if (reply) {
        replyTarget.value = { type: 'reply', id: reply.id, commentId: comment.id, touid: reply.uid, touname: reply.uname };
      } else {
        replyTarget.value = { type: 'comment', id: comment.id, touid: comment.uid, touname: comment.uname };
      }
    };

    const sendReply = async () => {
      if (inputReply.value.trim() === '') {
        showdialog('提示', '回复内容不能为空', false, '确定', '确定');
        return;
      }
      let body = {
        content: inputReply.value,
      };

      let apiUrl = '';
      if (replyTarget.value.type == 'comment') {
        apiUrl = path + `/api/newreply?uid=${myuid}&comid=${replyTarget.value.id}&logid=${logId}`;
      } else if (replyTarget.value.type == 'reply') {
        apiUrl = path + `/api/newreply?uid=${myuid}&replyid=${replyTarget.value.id}&comid=${replyTarget.value.commentId}&logid=${logId}`;
      }

      const response = await fetch(apiUrl, {
        method: 'POST',
        body: JSON.stringify(body),
        headers: headers,
      });

      const data =  await response.json();
      if (data.isok) {
        let newReply = {
          id: data.id,
          uid: myuid,
          uname: sessionStorage.getItem('uname'),
          touid: replyTarget.value.touid,
          touname: replyTarget.value.touname,
          content: inputReply.value,
          time: timetool(new Date()),
          islike: false,
          uimage: sessionStorage.getItem('uimage'),
          likenum: 0,
        };

        if (replyTarget.value.type == 'comment') {
          newReply.touid=null;
          const comment = comments.value.find(c => c.id == replyTarget.value.id);
          comment.replies.unshift(newReply);
          comment.replynum++;
        } else if (replyTarget.value.type == 'reply') {
          const comment = comments.value.find(c => c.id == replyTarget.value.commentId);
          const replyIndex = comment.replies.findIndex(r => r.id == replyTarget.value.id);
          if (replyIndex !== -1) {
            // 插入到被回复的回复的后面
            comment.replies.splice(replyIndex + 1, 0, newReply); 
          } else {
            comment.replies.unshift(newReply); // 如果找不到，放在最后
          }
          comment.replynum++;
        }

        inputReply.value = '';
        replyTarget.value = null;
        showdialog('提示', '回复成功', false, '确定', '确定');
      } else {
        showdialog('提示', '回复失败', false, '确定', '确定');
      }
    };
    const cancelReply = () => {
      inputReply.value = '';
      replyTarget.value = null;
    };
    const likelog = async () => {
      if (!myuid) {
        showdialog('提示', '登录后可点赞', true, '登录', '取消', tologin, () => null);
        return;
      }
      const likestr = log.value.islike ? '0' : '1';//0表示取消点赞，1表示点赞
      const response = await fetch(path + '/api/likelog?uid=' + myuid + '&logid=' + logId + '&type=' + likestr, {
        method: 'POST',
        headers: headers,
      });
      const data = await response.json();
      if (data.isok) {
        log.value.islike = !log.value.islike;
        log.value.likenum += log.value.islike ? 1 : -1;
      }
      else {
        showdialog('点赞失败', data.failreason, false, '确定', '确定');
      }
    }
    const collectlog = async () => {
      if (!myuid) {
        showdialog('提示', '登录后可收藏', true, '登录', '取消', tologin, () => null);
        return;
      }
      const collectstr = log.value.iscollect ? '0' : '1';//0表示取消收藏，1表示收藏
      const response = await fetch(path + '/api/collectlog?uid=' + myuid + '&logid=' + logId + '&type=' + collectstr, {
        method: 'POST',
        headers: headers,
      });
      const data =  await response.json();
      if (data.isok) {
        log.value.iscollect = !log.value.iscollect;
        log.value.collectnum += log.value.iscollect ? 1 : -1;
      }
      else {
        showdialog('收藏失败', data.failreason, false, '确定', '确定');
      }
    }
    const likecomment = async (comdata) => {
      if (!myuid) {
        showdialog('提示', '登录后可点赞', true, '登录', '取消');
        return;
      }
      const likestr = comdata.islike ? '0' : '1';//0表示取消点赞，1表示点赞
      const comid = comdata.id;
      const response = await fetch(path + '/api/likecomment?uid='
        + myuid + '&comid=' + comid + '&type=' + likestr + '&logid=' + logId,
        {
          method: 'POST',
          headers: headers,
        });
      const data =  await response.json();
      if (data.isok) {
        comdata.islike = !comdata.islike;
        comdata.likenum += comdata.islike ? 1 : -1;
      }
      else {
        console.log(data.failreason);
      }
    }
    const likereply = async (reply, comid) => {
      if (!myuid) {
        showdialog('提示', '登录后可点赞', true, '登录', '取消', tologin, () => null);
        return;
      }
      const likestr = reply.islike ? '0' : '1';//0表示取消点赞，1表示点赞
      const replyid = reply.id;
      const response = await fetch(path + '/api/likereply?uid='
        + myuid + '&replyid=' + replyid + '&type=' + likestr + '&comid=' + comid + '&logid=' + logId,
        {
          method: 'POST',
          headers: headers,
        });
      const data =  await response.json();
      if (data.isok) {
        reply.islike = !reply.islike;
        reply.likenum += reply.islike ? 1 : -1;
      }
      else {
        console.log(data.failreason);
      }
    }
    const attionusr = async () => {
      if (!myuid) {
        showdialog('提示', '登录后可关注', true, '登录', '取消', tologin, () => null);
        return;
      }
      const attionstr = log.value.isattion ? '0' : '1';//0表示取消关注，1表示关注
      const response = await fetch(path + '/api/attionusr?uid=' + myuid +
        '&attionuid=' + uid.value + '&type=' + attionstr, {
        method: 'POST',
        headers: headers,
      });
      const data =  await response.json();
      if (data.isok) {
        log.value.isattion = !log.value.isattion;
        if (attionstr == '1') {
          showdialog('关注成功', null, false, '确定', '确定');
        }
        else {
          showdialog('取关成功', null, false, '确定', '确定');
        }
      }
      else {
        if (attionstr == '1') {
          showdialog('关注失败', data.failreason, false, '确定', '确定');
        }
        else {
          showdialog('取关失败', data.failreason, false, '确定', '确定');
        }
      }
    }
    const getmorecom = async () => {
      const nowcomnumstr = comments.value.length;
      const response = await fetch(path + '/api/morecom?logid=' + logId +
        '&nowcomnum=' + nowcomnumstr + '&uid=' + myuid);
      const data =  await response.json();
      if(data.comments==null){
        showdialog('提示','没有更多评论',false,'确定','确定');
        return;
      }
      for (let i = 0; i < data.comments.length; i++) {
        data.comments[i].replies = [];
      }
      comments.value = comments.value.concat(data.comments);
    }
    const morereply = async (comment) => {
      const nowreplynumstr = comment.replies.length;
      const response = await fetch(path + '/api/morereply?' + 'logid=' + logId +
        '&comid=' + comment.id + '&nowrepnum=' + nowreplynumstr + '&uid=' + myuid);
      const data =  await response.json();
      comment.replies = comment.replies.concat(data.replies);
    }
    const lessreply = (comment) => {
      comment.replies = [];
    }
    const deletedata = async () => {
      maindeskreadonly.value = true;
      let [type, logid, comid, replyid] = goingdeletedata.value;
      let targetuid = goingdeletedatauid.value;
      let apiUrl = '';
      if (type == 'log') {
        apiUrl = path + `/api/deletelog?uid=${myuid}&logid=${logid}`;
        if(isadmin&&targetuid!=myuid){
          apiUrl = path + `/api/adm/admdellog?logid=${logid}`+`&uid=${uid.value}`;
        }
      }
      else if (type == 'comment') {
        apiUrl = path + `/api/deletecomment?uid=${myuid}&logid=${logid}&comid=${comid}`;
        if(isadmin&&targetuid!=myuid){
          apiUrl = path + `/api/adm/admdelcomment?comid=${comid}`+`&logid=${logid}`+`&uid=${targetuid}`;
        }
      }
      else if (type == 'reply') {
        apiUrl = path + `/api/deletereply?uid=${myuid}&logid=${logid}&comid=${comid}&replyid=${replyid}`;
        if(isadmin&&targetuid!=myuid){
          apiUrl = path + `/api/adm/admdelreply?replyid=${replyid}`+`&uid=${targetuid}`;
        }
      }
      const response = await fetch(apiUrl, {
        method: 'POST',
        headers: headers,
      });
      const data =  await response.json();
      if (data.isok) {
        if (type == 'log') {
          showdialog('删除成功', null, false, '返回主页', '确定', tohome, () => null);
        }
        else if (type == 'comment') {
          showdialog('删除成功', null, false, '确定', '确定');
          for (let i = 0; i < comments.value.length; i++) {
            if (comments.value[i].id == comid) {
              comments.value.splice(i, 1);
              commentsnum.value--;
              break;
            }
          }
        }
        else if (type == 'reply') {
          showdialog('删除成功', null, false, '确定', '确定');
          for (let i = 0; i < comments.value.length; i++) {
            if (comments.value[i].id == comid) {
              for (let j = 0; j < comments.value[i].replies.length; j++) {
                if (comments.value[i].replies[j].id == replyid) {
                  comments.value[i].replies.splice(j, 1);
                  comments.value[i].replynum--;
                  break;
                }
              }
            }
          }
        }
      }
      else {
        showdialog('删除失败', data.failreason, false, '确定', '确定');
      }
    }

    const report= async(logid,commentid,replyid) =>{
      if (!myuid) {
        showdialog('提示', '登录后可举报', true, '登录', '取消', tologin, () => null);
        return;
      }
      let explain = "举报";
      if(replyid!=null){
        explain += "评论：“";
        let thecomment = comments.value.find(c=>c.id==commentid);
        let thereply = thecomment.replies.find(r=>r.id==replyid);
        explain += thereply.content;
        explain += "”";
      }
      else if(commentid!=null){
        replyid ="";
        explain += "评论：“";
        let thecomment = comments.value.find(c=>c.id==commentid);
        explain += thecomment.content;
        explain += "”";
      }
      else{
        commentid ="";
        replyid="";
        explain += "帖子：“";
        explain += log.value.title;
        explain += "”";
      }
      if(explain.length>45){
        explain = explain.slice(0,45);
        explain += "...”";
      }
      goingreportdata.value = [String(logid),String(commentid),String(replyid),String(myuid),explain];
      reportvisible.value = true;
      maindeskreadonly.value = true;
    }

    const reportdialogok = () => {
      reportvisible.value = false;
      showdialog('举报成功', null, false, '确定', '确定');
    }

    const reportdialogfail = (reason) => {
      reportvisible.value = false;
      if(reason!="cancel"){
        showdialog('举报失败', reason, false, '确定', '确定');
        return;
      }
      else{
        maindeskreadonly.value = false;
      }
    }

    const goingdelete = (type,logid,comid,replyid,uid=log.value.uid) => {
      goingdeletedata.value = [type,logid,comid,replyid];
      goingdeletedatauid.value = uid;
      console.log(goingdeletedatauid.value);
      let text = '';
      let content = '';
      if(type == 'log'){
        text = '确定删除该帖子';
      }
      else if(type == 'comment'){
        text = '确定删除评论';
        for (let i = 0; i < comments.value.length; i++) {
          if (comments.value[i].id == comid) {
            content = comments.value[i].content;
            if(content.length>30){
              content = content.slice(0,30);
              content += '...';
            }
            break;
          }
        }
        text += '：“' + content + '”';
      }
      else if(type == 'reply'){
        text = '确定删除回复';
        for (let i = 0; i < comments.value.length; i++) {
          if (comments.value[i].id == comid) {
            for (let j = 0; j < comments.value[i].replies.length; j++) {
              if (comments.value[i].replies[j].id == replyid) {
                content = comments.value[i].replies[j].content;
                if(content.length>30){
                  content = content.slice(0,30);
                  content += '...';
                }
                break;
              }
            }
          }
        }
        text += '：“' + content + '”';
      }
      text += '？';
      showdialog('提示', text, true, '确定', '取消',deletedata,()=>null);
    };

    const toperinfo = (uid) => {
      router.push(`/perinfo/${uid}`);
    };

    const tosearch = (sname) => {
      sname=sname.replace("#","");
      sname="subject--"+sname;
      router.push(`/home?sname=${sname}`);
    };

    const showdialog = (title, text, needcancel, surebuttext, cancelbuttext,
      surefunc=()=>null, cancelfunc=()=>null
    ) => {
      dialogvisible.value = true;
      dialogtext.value = text;
      diatitle.value = title;
      needcancelbut.value = needcancel;
      surebutstr.value = surebuttext;
      cancelbutstr.value = cancelbuttext;
      maindeskreadonly.value = true;
      dialogsurefunc = surefunc;
      dialogcancelfunc = cancelfunc;
    };

    const DialogConfirm=()=>{
      dialogvisible.value = false;
      dialogsurefunc();
      maindeskreadonly.value = false;
    }
    const DialogCancel=()=>{
      dialogvisible.value = false;
      dialogcancelfunc();
      maindeskreadonly.value = false;
    }

    const tologin = () => {
      window.location.href = '/login?from=/log/' + logId;
    };

    const tohome = () => {
      window.location.href = '/';
    };

    onMounted(fetchLogDetail);
    return {
      log,
      logId,
      comments,
      myuid,
      inputReply,
      sendcomment,
      likelog,
      likecomment,
      getmorecom,
      collectlog,
      attionusr,
      morereply,
      lessreply,
      commentsnum,
      likereply,
      replyTarget,
      setReplyTarget,
      sendReply,
      images,
      uimage,
      cancelReply,
      deletedata,
      report,
      needcancelbut,
      cancelbutstr,
      surebutstr,
      dialogtext,
      diatitle,
      window,
      maindeskreadonly,
      ready,
      toperinfo,
      tosearch,
      goingdelete,
      inputComment,
      DialogConfirm,
      DialogCancel,
      dialogvisible,
      reportvisible,
      goingreportdata,
      showdialog,
      reportdialogok,
      reportdialogfail,
      isshowimages,
      showimage,
      tempimages,
      isadmin,
    };
  },
};
</script>


<style>
.ucard {
  background-color: #e9f4fbcc !important;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  width: 25%;
  display: flex; /* 启用 Flexbox 布局 */
  flex-direction: column;
  align-items: center; /* 水平方向居中 */
  justify-content: center; /* 垂直方向居中 */

  background-image: url('../assets/uBackground.png');
  background-size: cover; /* 确保背景图片覆盖整个容器 */
  background-repeat: no-repeat; /* 防止背景图片重复 */
  background-position: center; /* 背景图片居中 */
}


.titlecard {
  /*圆角边框*/
  background-color: #e9f4fbcc !important;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  width: 75%;
  background-image: url('../assets/userBackground.jpg');
  background-size: cover; /* 确保背景图片覆盖整个容器 */
  background-repeat: no-repeat; /* 防止背景图片重复 */
  background-position: center; /* 背景图片居中 */
  /*居中*/
}

.maincard {
  /*圆角边框*/
  background-color: #e9f4fbcc !important;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 10px;
  border-radius: 5px;
  margin-top: 20px;
}

.header {
  height: auto;
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.maintext{
  text-indent: 2em;
  font-size: 20px;
}

.commenttext{
  font-size: 20px;
}

.replytext{
  font-size: 18px;
}

.smalltext {
  font-size: 15px;
  color: #999;
}

.viewtext{
  font-size: 15px;
  color: #1a1a1a;
}

.smallertext {
  font-size: 13px;
  color: #999;
}

.log-actions {
  display: flex;
  align-items: center;
  /* 让子元素垂直居中对齐 */
  flex-direction: row;
}

.action-item {
  display: flex;
  align-items: center;
  width: 50px;
  /* 让文本和图片在同一行垂直居中 */
  cursor: pointer;
  /* 提示用户这是可点击的 */
}

.heart-icon {
  height: 25px;
  width: 25px;
}

.heart-iconsmall {
  height: 20px;
  width: 20px;
}

.collect-icon {
  margin-left: 10px;
  /* 给图标添加一些间距 */
  height: 20px;
  /* 根据需要调整图标高度 */
}

.logimage {
  width: 30%;    /* 设置每张图片的宽度 */
  margin: 5px;
  height: auto;    /* 高度自动调整，保持比例 */
  object-fit: cover;
  cursor: pointer;
}
.icon{
  cursor: pointer !important;
  margin-left: 10px;
}

.uinfotag{
  margin-left: 5px;
}

.clickable-tag {
  cursor: pointer;
}
.clickable-tag:hover {
  font-weight: bold; /* 鼠标移到标签上时字体变粗 */
  background-color: #f0f0f0; /* 鼠标移到标签上时背景颜色变化 */
  color: #333; /* 鼠标移到标签上时字体颜色变化 */
}

</style>