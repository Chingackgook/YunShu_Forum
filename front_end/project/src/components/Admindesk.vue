<template>
    <!-- <div>
        <p>管理员面板</p>
        <p>至少需要以下功能：</p>
        <p>1.查看所有用户（带搜索功能）</p>
        <p>2.查看所有帖子（带搜索功能）</p>
        <p>3.处理所有的举报（需要将已处理的举报向后端标记为已处理，需要实现跳转到对应的帖子，以及对应的评论位置，</p>
        <p>需新建接口向后端请求指定commentid的评论，最好新建一个vue组件（弹窗形式），用于显示被举报的帖子，以及对应的评论、回复）</p>
        <p>4.置顶帖子</p>
        <p>（弹窗方法可参考Thelog.vue的ReportDialog的实现）</p>
    </div> -->

    <div :class="{ disabled: maindeskreadonly }" >
      <el-container style="display: flex;">
        <el-aside width="200px">
            <div>
                &nbsp;<!--空占位 -->
            </div>
            <div class="menu">
              <el-menu default-active="1" class="mymenu">

                <el-menu-item index="1" @click="changemod('userinfo')">
                    <el-icon>
                      <userIcon/>
                    </el-icon>
                    <span>查看所有用户</span>
                </el-menu-item>

                <el-menu-item index="2" @click="changemod('postinfo')">
                    <el-icon>
                      <postIcon/>
                    </el-icon>
                    <span>查看所有帖子</span>
                </el-menu-item>

                <el-menu-item index="3"  @click="changemod('reporthandle')">
                    <el-icon>
                      <reportIcon/>   
                    </el-icon>
                    <span>举报处理</span>
                </el-menu-item>

                <el-menu-item index="4" @click="changemod('banlist')">
                    <el-icon>
                      <banlistIcon/>   
                    </el-icon>
                    <span>封禁列表</span>
                </el-menu-item>
                
              </el-menu>
            </div>
        </el-aside>

        <el-main>
          <div v-if="modname === 'userinfo'">
              <div class="maindesk">
                
                <span 
                  style="font-size: 35px; 
                  font-Family: 'MyCustomFont';
                  color:rgba(38, 38, 38);
                  margin-bottom: 15px; /* 增加底部距离 */
                  display: block; /* 确保 span 是块级元素 */"
                >
                  用户列表
                </span>

                <div class="search-container">
                  <el-input
                      v-model="searchuser"
                      placeholder="默认用用户名搜索， # 号开头搜索用户id"
                      @clear = "handleclear"
                      clearable
                      style="width: 300px;"
                  />
                  <el-button @click="onSearchuser" style="margin-left: 10px;"
                  >搜索</el-button>
                </div>

                <el-card v-for="user in userlist" :key="user.uid" class="user-card">
                  <div style="display: flex; align-items: center;justify-content: space-between;">
                    <div @click="touid(user.uid)" @mouseover="isuserHovered = user.uid" @mouseleave="isuserHovered = -1"
                    style="display: flex; align-items: center; " class=" clickUname">
                      <img v-if="user.uimage" :src="user.uimage" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                      <img v-else src="../assets/loading.png" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                      <!-- 用户名和用户 ID 信息 -->
                      <div>
                      <!-- <div :style="{textDecoration: (isuserHovered==user.uid) ? 'underline' : 'none'}"> -->
                        <div style="font-weight: bold;font-size: 15pt;">{{ user.uname }}</div>
                        <div style="color: #999; font-size: 10pt;">{{ user.uid }}</div>
                      </div>
                    </div>
                  </div>
                </el-card>

              </div>

                <el-pagination
                  background
                  :current-page="userlistpage"
                  :page-count="userlisttotalpages"
                  layout="prev, pager, next , jumper"
                  @current-change="goToPageuser"
                  style="margin-top: 10px;"
                />
              </div>
      

          <div v-else-if="modname === 'postinfo'">
            <div class="maindesk">

              <span
                style="font-size: 30px; 
                margin-bottom: 30px;
                font-Family: 'MyCustomFont';
                color:rgba(38, 38, 38);
                font-Size:35px;
                margin-bottom: 15px; /* 增加底部距离 */
                display: block; /* 确保 span 是块级元素 */"
              >
                帖子列表
              </span>

              <div class="search-container">
                  <el-input
                      v-model="searchpost"
                      placeholder="默认用帖子标题搜索，# 号开头搜索帖子id"
                      clearable
                      @clear = "handleclear"
                      style="width: 300px;"
                  />
                  <el-button @click="onSearchpost" style="margin-left: 10px;"
                  >搜索</el-button>
              </div>

              <el-card v-for="log in loglist" :key="log.id" class="post-item" style="margin-top: 10px;" >

                <div style="display: flex; align-items: center;height: 120px;">
                  
                  <div @click="touid(log.uid)" @mouseover="isuserHovered = log.id" @mouseleave="isuserHovered = -1"
                  style="display: flex; align-items: center;width: 15%;"class="clickUname">
                    <img v-if="log.uimage" :src="log.uimage" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 10px;" />
                    <img v-else src="../assets/loading.png" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 10px;" />

                    <div>
                      <div style="font-weight: bold;font-size: 15pt;">{{ log.uname }}</div>
                      <div style="color: #999; font-size: 10pt;">{{ log.uid }}</div>
                    </div>

                  </div>

                  <el-divider direction="vertical"></el-divider>
                  <div  @click="tolog(log.id)" @mouseover="istitleHovered = log.id" @mouseleave="istitleHovered = -1"
                  style="flex-grow: 2; text-align: left; font-weight: bold; cursor: pointer;
                  width: 70%; margin-right: 10px;">
                    <div :style="{ textDecoration: (istitleHovered==log.id) ? 'underline' : 'none' }">
                      <div style="font-size: 14pt; margin-bottom: 8px;">{{ log.title }}：</div>
                      <div style="color: #999;font-size: 10pt; font-weight: 400;">{{ log.somecontent }}</div>
                    </div>
                    <el-tag v-for="subject in log.subjects" :key="subject"
                    style="margin-right: 10px;margin-top: 30px;" size="medium"
                    >{{ subject }}</el-tag>
                    <div style="margin-left: auto; color: #999; font-size: 8pt;
                    display: flex;align-items: center;margin-top: 5px;">
                      <el-icon name="time">
                        <calendar/>
                      </el-icon>
                      <span>{{ log.time }}</span>
                    </div>
                  </div>
                  <div style="width: 15%;display: flex; flex-direction: column; align-items: flex-end;">
                  </div>
                  </div>
              </el-card>
            </div>
            <el-pagination
                background
                :current-page="loglistpage"
                :page-count="loglisttotalpages"
                layout="prev, pager, next , jumper"
                @current-change="goToPagepost"
                style="margin-top: 10px;"
              />  
          </div>
          
          <div v-else-if="modname === 'reporthandle'" >
            
              <div class="maindeskrpt"> 
                
                <span 
                  style="font-size: 30px; 
                  margin-bottom: 30px;
                  font-Family: 'MyCustomFont';
                  color:rgba(38, 38, 38);
                  font-Size:35px;
                  margin-bottom: 15px; /* 增加底部距离 */
                  display: block; /* 确保 span 是块级元素 */"
                >
                  举报处理
                </span>

                <p v-if="reportTargets==null||reportTargets.length==0">{{"暂无举报"}}</p>
                <el-card v-for="target in reportTargets"
                style="margin-top: 10px;" class="rptItemBg">


                    <p>举报编号：
                      <span style="font-weight: bold;">{{ target.rid }}</span>
                    </p>

                    <p>举报类型：
                      <span v-if="target.type=='log'" style="font-weight: bold;">帖子</span>
                      <span v-else-if="target.type=='comment'" style="font-weight: bold;">评论</span>
                      <span v-else-if="target.type=='reply'" style="font-weight: bold;">回复</span>
                    </p>

                    <p>举报时间：
                      <span style="font-weight: bold;">{{target.time}}</span>
                    </p>

                    <p>违规类型：
                        <span style="font-weight: bold;">{{target.rtype}}</span>
                    </p>

                    <div>用户反馈内容：
                      <p style="border: 1px solid #ccc; padding: 20px; margin-top: 5px; max-width: 500px;">
                          <span style="font-weight: bold;">{{target.reason}}</span>
                      </p>
                    </div>

                    <el-button @click="showRpInfoDia(target)" type="primary" plain>举报详情</el-button>
                    <el-button @click="showHandleReportDia(target)" type="primary" plain>处理举报</el-button>
                </el-card>

                <el-pagination
                  background
                  :current-page="reportpage"
                  :page-count="reporttotalpages"
                  layout="prev, pager, next , jumper"
                  @current-change="goToPagereport"
                  style="margin-top: 10px;"
                />
              </div>
              
          </div>

<!-- 封禁列表 -->
          <div v-else-if="modname === 'banlist'">
            <div class="maindesks">
              
              <span 
                  style="font-size: 35px; 
                  margin-bottom: 30px;
                  font-family: 'MyCustomFont';
                  color: rgba(38, 38, 38);
                  margin-bottom: 15px; /* 增加底部距离 */
                  display: block; /* 确保 span 是块级元素 */"
              >
                封禁列表
              </span>


              <p v-if="banlist==null||banlist.length==0" style="margin-left: 40% ;font-size: 24pt;">暂无封禁</p>
              <el-card v-for="user in banlist" :key="user.uid" class="user-card" >
                      <div style="display: flex; align-items: center;justify-content: space-between;">
                        <div @click="touid(user.uid)" @mouseover="isuserHovered = user.uid" @mouseleave="isuserHovered = -1"
                        style="display: flex; align-items: center; cursor: pointer;">
                          <img v-if="user.uimage" :src="user.uimage" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                          <img v-else src="../assets/loading.png" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                          <!-- 用户名和用户 ID 信息 -->
                          <div :style="{textDecoration: (isuserHovered==user.uid) ? 'underline' : 'none'}">
                            <div style="font-weight: bold;font-size: 15pt;">{{ user.uname }}</div>
                            <div style="color: #999; font-size: 10pt;">{{ user.uid }}</div>
                          </div>
                        </div>
                        <div style="display: flex; align-items: center; justify-content: space-between;
                        width: 38%;">
                          <div style="display: flex; flex-direction: column; align-items: center;">
                            <el-tag type="danger" plain style="margin-bottom: 5px; font-size: 15px;">封禁时间：{{ user.fromtime }}</el-tag>
                            <el-tag style="margin-bottom: 5px; font-size: 15px;">解封时间：{{ user.totime }}</el-tag>
                          </div>
                          <span>
                              <el-button type="danger" plain @click="liftBan(user.uid)">解封</el-button>
                          </span>
                        </div>
                      </div>
              </el-card>
              <el-pagination
                background
                :current-page="banlistpage"
                :page-count="banlisttotalpages"
                layout="prev, pager, next , jumper"
                @current-change="goToPagebanlist"
                style="margin-top: 10px;"
              />
            </div>
<!-- 禁言列表 -->
            <div class="maindesks">
              
              <span 
                style="font-size: 35px; 
                margin-bottom: 30px;
                font-family: 'MyCustomFont';
                color: rgba(38, 38, 38);
                margin-bottom: 15px; /* 增加底部距离 */
                display: block; /* 确保 span 是块级元素 */"
              >
                禁言列表
              </span>

              <p v-if="restricklist==null||restricklist.length==0" style="margin-left: 40% ;font-size: 24pt;">暂无禁言</p>
              <el-card v-for="user in restricklist" :key="user.uid" class="user-card" >

                      <div style="display: flex; align-items: center;justify-content: space-between;">
                        <div @click="touid(user.uid)" @mouseover="isuserHovered = user.uid" @mouseleave="isuserHovered = -1"
                        style="display: flex; align-items: center; cursor: pointer;">
                          <img v-if="user.uimage" :src="user.uimage" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                          <img v-else src="../assets/loading.png" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                          <!-- 用户名和用户 ID 信息 -->
                          <div :style="{textDecoration: (isuserHovered==user.uid) ? 'underline' : 'none'}">
                            <div style="font-weight: bold;font-size: 15pt;">{{ user.uname }}</div>
                            <div style="color: #999; font-size: 10pt;">{{ user.uid }}</div>
                          </div>
                        </div>

                        <div style="display: flex;
                             align-items: center; 
                             justify-content: space-between;
                             width: 38%;"
                        >
                          <div style="display: flex; flex-direction: column; align-items: left;margin-right: -200px;">
                            <el-tag type="danger" plain style="margin-bottom: 5px;  font-size: 15px;">禁言时间：{{ user.fromtime }}</el-tag>
                            <el-tag style="margin-bottom: 5px; font-size: 15px;">解禁时间：{{ user.totime }}</el-tag>
                          </div>

                          <span>
                              <el-button type="danger" plain @click="liftBan(user.uid)">解禁</el-button>
                          </span>

                        </div>

                      </div>
              </el-card>
              <el-pagination
                background
                :current-page="restricklistpage"
                :page-count="restricklisttotalpages"
                layout="prev, pager, next , jumper"
                @current-change="goToPagerestricklist"
                style="margin-top: 10px;"
              />
            </div>
          </div>

<!-- 封禁列表 -->          
          
        </el-main>

      </el-container>
    </div>

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

    <RpInfoDia
    v-if="isreportinfovisible"
    :type = "reportTarget.type"
    :logid = "reportTarget.logid"
    :commentid = "reportTarget.commentid"
    :replyid = "reportTarget.replyid"
    @ok="()=>{isreportinfovisible=false;maindeskreadonly=false;}"
    ></RpInfoDia>

    <RpHandleDia
    v-if="isreporthandlevisible"
    :type="reportTarget.type"
    :logid="reportTarget.logid"
    :commentid="reportTarget.commentid"
    :replyid="reportTarget.replyid"
    :uid="reportTarget.uid"
    :somecontent="reportTarget.somecontent"
    :rid="reportTarget.rid"
    :ruid="reportTarget.ruid"
    @ok="handleReportdiaok(reportTarget)"
    @fail="handleReportdiafail"
    ></RpHandleDia>
    
</template>

<script setup>
  import { ref, onMounted, getCurrentInstance, computed, watch } from 'vue';
  import myDialog from './Mydialog.vue';
  import RpInfoDia from './ShowRptInfoDialog.vue';
  import RpHandleDia from './HandelRptDialog.vue';
  import router from '@/router';
  import * as ElementPlusIconsVue from '@element-plus/icons-vue'

  const postIcon = ElementPlusIconsVue.Edit;
  const userIcon = ElementPlusIconsVue.User;
  const reportIcon = ElementPlusIconsVue.Bell;
  const calendar = ElementPlusIconsVue.Calendar;
  const banlistIcon = ElementPlusIconsVue.Lock;
  document.title = '管理员面板-云枢论坛';

    const dialogtitle = ref('');
    const dialogtext = ref('');
    const dialogneedcancelbut = ref(false);
    const dialogsurebuttext = ref('');
    const dialogcancelbuttext = ref('');
    const dialogvisible = ref(false);
    const maindeskreadonly = ref(false);
    let dialogconfirmfuc=()=>null;
    let dialogcancelfuc=()=>null;

    //举报详情窗口变量
    const reportTarget = ref({});
    const isreportinfovisible = ref(false);

    //举报处理窗口变量
    const isreporthandlevisible = ref(false);

    const showHandleReportDia = (target) => {
      reportTarget.value = target;
      isreporthandlevisible.value = true;
      maindeskreadonly.value = true;
    }

    const handleReportdiaok = (target) => {
      isreporthandlevisible.value = false;
      maindeskreadonly.value = false;
      //删除掉已处理的举报
      reportTargets.value = reportTargets.value.filter((item) => item.rid != target.rid);
      fetchReportTarget();
      showdialog('处理成功','',false,'确定','');
    }

    const handleReportdiafail = (reason) => {
      isreporthandlevisible.value = false;
      if(reason=='cancle'){
        maindeskreadonly.value = false;
        return;
      }
      showdialog('处理失败',reason,false,'确定','');
    }

    const modname = ref('userinfo');
    const myuid = sessionStorage.getItem('uid');
    
    const isuserHovered = ref(-1);
    const istitleHovered = ref(-1);
    const headers = new Headers();
    headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));

    const userlist = ref([]);
    const userlisttotalpages = ref(1);
    const userlistpage = ref(1);

    const loglist = ref([]);
    const loglisttotalpages = ref(1);
    const loglistpage = ref(1);

    const banlist = ref([]);
    const banlisttotalpages = ref(1);
    const banlistpage = ref(1);

    const restricklist = ref([]);
    const restricklisttotalpages = ref(1);
    const restricklistpage = ref(1);

    const reportedlogpage = ref(1);


    const app = getCurrentInstance();
    const path = app.proxy.$backpath;

    const searchmod = ref('false'); 

    const currentPage=ref(1);
    const totalPages=ref(1);
    const pagesToShow=ref(5);

    const searchuser = ref('');
    const searchpost = ref('');

    const reportTargets = ref([]);
    const reportpage = ref(1);
    const reporttotalpages = ref(1);

    const pages = computed(() => {
      const half = Math.floor(pagesToShow.value / 2);
      let start = Math.max(1, currentPage.value - half);
      let end = Math.min(totalPages.value, start + pagesToShow.value - 1);
      if (end - start < pagesToShow.value) {
        start = Math.max(1, end - pagesToShow.value + 1);
      }
      return Array.from({ length: end - start + 1 }, (_, i) => start + i);
    });

    const fetchUser = async () => {
      // 获取用户
      let response;
      if (searchmod.value === 'true') {
        let fetchstr = path + '/api/adm/searchUser';
        if (searchuser.value.includes('#')) {
          let aname = searchuser.value.replace('#', '');
          response = await fetch(fetchstr + `?aimuid=${aname}&page=${userlistpage.value}`, {
            headers: headers,
          }
          );
        } else {
          response = await fetch(fetchstr + `?aimuname=${searchuser.value}&page=${userlistpage.value}`,
            {
              headers: headers,
            }
          );
        }
      }else{
        let fetchstr = path + '/api/adm/alluser';
        response = await fetch(fetchstr + `?page=${userlistpage.value}`,
          {
            headers: headers,
          }
        );
      } 
      let data = await response.json();
      userlist.value = data.datas;
      userlisttotalpages.value = data.totalPages;
      if(userlist.value==null||userlist.value.length==0){
        userlisttotalpages.value = null;
      }
    };
    
    const fetchPost = async()=>{
      //获取帖子
      let response;
      if(searchmod.value=='true'){
        let fetchstr = path + '/api/adm/searchLog';
        if(searchpost.value.includes('#')){
          let title = searchpost.value.replace('#','');
          response = await fetch(fetchstr + `?aimlogid=${title}&page=${userlistpage.value}`,
            {
              headers: headers,
            }
          );
        }else{
          response = await fetch(fetchstr + `?aimtitle=${searchpost.value}&page=${userlistpage.value}`,
            {
              headers: headers,
            }
          );
        }
      }else{
        let fetchstr = path + '/api/adm/allpost';
        response = await fetch(fetchstr+`?page=${loglistpage.value}`,
          {
            headers: headers,
          }
        );
      }
      let data = await response.json();
      loglist.value = data.logs;
      loglisttotalpages.value = data.totalPages;
      if(loglist.value==null||loglist.value.length==0){
        loglisttotalpages.value = null;
      }
    };

    const fetchBanlist = async()=>{
      let fetchstr = path + '/api/adm/banrestricklist';
      fetchstr = fetchstr + `?page=${banlistpage.value}`;
      fetchstr = fetchstr + `&type=ban`;
      let response = await fetch(fetchstr, {
        headers: headers,
      });
      let data = await response.json();
      console.log(data);
      banlist.value = data.datas;
      banlisttotalpages.value = data.totalpages;
      if(banlist.value==null||banlist.value.length==0){
        banlisttotalpages.value = null;
      }
    }

    const fetchRestricklist = async()=>{
      let fetchstr = path + '/api/adm/banrestricklist';
      fetchstr = fetchstr + `?page=${restricklistpage.value}`;
      fetchstr = fetchstr + `&type=restrick`;
      let response = await fetch(fetchstr,
        {
          headers: headers,
        }
      );
      let data = await response.json();
      restricklist.value = data.datas;
      restricklisttotalpages.value = data.totalpages;
      if(restricklist.value==null||restricklist.value.length==0){
        restricklisttotalpages.value = null;
      }
    }

    const fetchReportTarget=async()=>{
      let fetchstr = path + '/api/adm/getreports';
      fetchstr = fetchstr + `?page=${reportedlogpage.value}`;
      let response = await fetch(fetchstr,
        {
          headers: headers,
        }
      );
      let data = await response.json();
      reportTargets.value = data.rptarget;
      reporttotalpages.value = data.totalpages;
      if(reportTargets.value==null||reportTargets.value.length==0){
        reporttotalpages.value = null;
      }
    }

    const showRpInfoDia = (target) => {
      reportTarget.value = target;
      maindeskreadonly.value = true;
      isreportinfovisible.value = true;
    }


    const changemod = async(mod) => {
      searchmod.value = 'false';
      if(mod=='reporthandle'){
        fetchReportTarget();
      }else if(mod=='userinfo'){
        fetchUser();
      }else if(mod=='postinfo'){
        fetchPost();
      }else if(mod=='banlist'){
        fetchRestricklist();
        fetchBanlist();
      }
      modname.value = mod;
    }

    const liftBan = async(uid) => {
      let body = {
        uid: String(uid),
      };
      let fetchstr = path + '/api/adm/liftBan'+'?uid='+uid;
      let response = await fetch(fetchstr, {
        method: 'POST',
        headers: headers,
        body: JSON.stringify(body),
      });
      let data = await response.json();
      if (data.isok) {
        showdialog('解封成功', '', false, '确定', '');
        fetchBanlist();
        fetchRestricklist();
      } else {
        showdialog('解封失败', data.failreason, false, '确定', '');
      }
    }

    const touid = (uid) => {
      window.location.href='/perinfo/'+uid;
    }

    const tolog = (logid) => {
      router.push('/log/' + logid);
    }

    const goToPageuser = (page) => {
      userlistpage.value=page;
      fetchUser();
    }

    const goToPagepost = (page) => {
      loglistpage.value=page;
      fetchPost();
    }

    const goToPagereport = (page) => {
      reportpage.value=page;
      fetchReportTarget();
    }

    const goToPagebanlist = (page) => {
      banlistpage.value=page;
      fetchBanlist();
    }

    const goToPagerestricklist = (page) => {
      restricklistpage.value=page;
      fetchRestricklist();
    }

    const onSearchuser = async()=>{
      if(searchuser.value==''){
        showdialog('提示','请输入搜索内容',false,'确定','');
        return;
      }
      searchmod.value = 'true';
      fetchUser();
    }

    const onSearchpost = async()=>{
      if(searchpost.value==''){
        showdialog('提示','请输入搜索内容',false,'确定','');
        return;
      }
      searchmod.value = 'true';
      fetchPost();
    }

    const showdialog = (title, text, needcancelbut, surebuttext, cancelbuttext
      ,diaconfirmfunc=()=>null, diacancelfunc=()=>null
    ) => {
      dialogtitle.value = title;
      dialogtext.value = text;
      dialogneedcancelbut.value = needcancelbut;
      dialogsurebuttext.value = surebuttext;
      dialogcancelbuttext.value = cancelbuttext;
      dialogconfirmfuc=diaconfirmfunc;
      dialogcancelfuc=diacancelfunc;
      dialogvisible.value = true;
      maindeskreadonly.value =true;
    };

    const myDialogConfirm = async() => {
      dialogvisible.value = false;
      dialogconfirmfuc();
      maindeskreadonly.value = false;
    };

    const myDialogCancel = () => {
      dialogvisible.value = false;
      dialogcancelfuc();
      maindeskreadonly.value = false;
    };

    const handleclear = () => {
      if(modname.value=='userinfo'){
        fetchUser();
      }
      else if(modname.value=='postinfo'){
        fetchPost();
      }

    }

    onMounted(fetchUser);
    onMounted(fetchPost);
    // onMounted(fetchReportedlog);

</script>

<style scoped>


.maindesk {
  /*突出显示，阴影效果*/
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  /* background-image: url('../assets/userBg.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center;  */
}
.maindesku {
  /*突出显示，阴影效果*/
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  /* background-image: url('../assets/userBg.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center;  */
}
.maindeskrpt{
  /*突出显示，阴影效果*/
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  background-image: url('../assets/maindesks.png');
  background-size: auto; /* 确保背景图片覆盖整个容器 */
  background-repeat: repeat; /* 防止背景图片重复 */
  margin-bottom: 10px;
}
.maindesks {
  /*突出显示，阴影效果*/
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  background-image: url('../assets/maindesks.png');
  background-size: auto; /* 确保背景图片覆盖整个容器 */
  background-repeat: repeat; /* 防止背景图片重复 */
  margin-bottom: 10px;
  
}

.user-card {
  margin-top: 10px;
  background-image: url('../assets/userBg.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
}

.post-item{
  margin-top: 10px;
  background-image: url('../assets/userBg.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center;  
}

/* 修改 */



.main {
  background: none; /* 确保父组件背景不显示 */
}

.rptItemBg{

  margin-top: 10px;
  background-image: url('../assets/messageBackground.jpg');
  background-size: cover; 
  background-repeat: no-repeat; /* 防止背景图片重复 */
  background-position: center; /* 背景图片居中 */

}

.clickUname{
  cursor: pointer;
}
.clickUname:hover {
  font-weight: bold; /* 鼠标移到标签上时字体变粗 */
  color: #2794c3; /* 鼠标移到标签上时字体颜色变化 */
}



</style>