<template>
  <div v-if="infoready&&logready" :class="{disabled: maindeskreadonly}">
    <!-- 主体布局 -->
    <el-container>
      <!-- 头部 -->
      <el-header class="myHeader" height="auto">
        <div style="display: flex; align-items: center; justify-content: space-between;
        margin: 20px;
        ">
          <div style="display: flex; align-items: center;">
            <el-avatar :src="userimage ? userimage.src : '../assets/loading.png'"
            @click="showuimage()" style="margin-right: 30px; cursor: pointer; width: 60pt;height: 60pt;"
            />
            <span style="font-size: 20px;line-height: 1.5;">

              <div>
                <span style="font-size: 30px; 
                      margin-bottom: 30px;
                      font-Family: 'MyCustomFont';
                      color:rgba(38, 38, 38);
                      font-Size:50px"
                >
                  {{ perinfo.uname }}
                </span>
                <span>&nbsp;</span>
                <span class = "littleTitle">(uid:{{ uid }})</span>
              </div>

              <div class ="littleTitle" style=" margin-top:15px ;">
                个性签名：
                <el-tag 
                  style="margin-right: 10px;
                  font-size:16px" 
                  aria-placeholder="这个家伙很懒~还没有个性签名"
                >
                  {{ perinfo.persign==""||perinfo.persign==null? "这个家伙很懒~还没有个性签名":perinfo.persign}}
                </el-tag>
              </div>

              <div class ="littleTitle"style=" margin-top:5px ;">
                兴趣标签：
                <span v-for="interest in perinfo.interests">

                  <el-tag class="clickable-tag" style="  
                    margin-right: 10px;
                    font-size: 16px;"
                    @click="tosearch(interest)"
                  >
                    {{ interest }}
                  </el-tag>
                  
                </span>
                <span v-if="perinfo.interests ==''">
                  <el-tag style="margin-right: 10px;font-size:16px">{{"这个家伙很神秘~还没有设置兴趣标签"  }}</el-tag>
                </span>

              </div>

              <div style="border-top: 1px solid #ccc; margin: 5px 0;"></div>

              <div class="littleTitle">
                关注：{{ perinfo.attionnum }} | 粉丝：{{ perinfo.fansnum }} | 获赞数：{{ perinfo.likenum }}
              </div>
            </span>
          </div>
          <span v-if="isself" style="font-size: 14px; color: #999;">
            <el-button @click="editinfo()" type="primary" plain>编辑信息</el-button>
            <el-button @click="asklogout()" type="danger" plain>注销</el-button>
          </span>
          <span v-else style="font-size: 14px; color: #999;">
            <el-button v-if="!perinfo.isattion" @click="attionusr()" type="primary">关注</el-button>
            <el-button v-else @click="attionusr()" type="primary" plain>取消关注</el-button>
          </span>
        </div>
      </el-header>
      <el-container style="display: flex;">
        <!-- 左侧菜单 -->
        <el-aside width="150px">
          <div>
            &nbsp;<!--空占位 -->
          </div>
          <div class="menu">
            <el-menu default-active="1" class="mymenu">

              <el-menu-item index="1" @click="changemod('info')">
                <el-icon>
                  <infoIcon/>
                </el-icon>
                <span>详细信息</span>
              </el-menu-item>

              <el-menu-item index="2" @click="changemod('self')">
                <el-icon>
                  <sendIcon/>
                </el-icon>
                <span>发布的帖子</span>
              </el-menu-item>

              <el-menu-item index="3" @click="changemod('like')">
                <el-icon>
                  <img
                  :src="modname=='like' ? require('../assets/blueheart.png') : require('../assets/blackheart.png')"
                  alt="点赞"
                  style="width: 20px; height: 20px;"
                  />
                </el-icon>
                <span>点赞的帖子</span>
              </el-menu-item>

              <el-menu-item index="4" @click="changemod('collect')">
                <el-icon>
                  <collectIcon/>
                </el-icon>
                <span>收藏的帖子</span>
              </el-menu-item>

              <el-menu-item index="5" v-if="isself" @click="changemod('attion')">
                <el-icon>
                  <attionIcon/>
                </el-icon>
                <span>我的关注</span>
              </el-menu-item>

              <el-menu-item index="6" v-if="isself" @click="changemod('setting')">
                <el-icon>
                  <settingIcon/>
                </el-icon>
                <span>设置</span>
              </el-menu-item>

              <el-menu-item index="7" v-if="isself" @click="changemod('sysmessage')">
                <el-icon>
                  <sysmessageIcon/>
                </el-icon>
                <span>系统消息</span>
              </el-menu-item>

              <el-menu-item index="8" v-if="isadmin && uid!=myuid"  @click="changemod('admin')">
                <el-icon>
                  <adminIcon/>
                </el-icon>
                <span>管理员面板</span>
              </el-menu-item>
            </el-menu>
          </div>
        </el-aside>

        <!-- 右侧详细内容 -->
        <el-main>
          <div v-if="modname=='self'||modname=='like'||modname=='collect'"
           class="maindesk">

            <span v-if="modname=='self'"
              style="font-size: 30px; 
              margin-bottom: 30px;
              font-Family: 'MyCustomFont';
              color:rgba(38, 38, 38);
              font-Size:35px"
            >
              {{ isself ? '我的帖子' : '他的帖子' }}
            </span>

            <span v-if="modname=='like'"
              style="font-size: 30px; 
              margin-bottom: 30px;
              font-Family: 'MyCustomFont';
              color:rgba(38, 38, 38);
              font-Size:35px"
            >
              {{ isself ? '我喜欢的帖子' : '他喜欢的帖子' }}

            </span>

            <span v-if="modname=='collect'"
              style="font-size: 30px; 
              margin-bottom: 30px;
              font-Family: 'MyCustomFont';
              color:rgba(38, 38, 38);
              font-Size:35px"
            >
              {{ isself ? '我收藏的帖子' : '他收藏的帖子' }}
            </span>

            <div v-if="modname=='self'" style="display: flex; align-items: center; justify-content: center; gap: 10px; margin-bottom: 10px;">
              <el-input 
                v-model="searname" 
                placeholder="请输入" 
                clearable 
                @clear ="handleClear" 
                style="width: 300px;" 
              />
              <el-button @click="searchLog">搜索</el-button>
              <!-- <el-button @click="clearSearch" type="danger">清空搜索</el-button> -->
            </div>

            <div v-if="isself||logvalid" class="post-list">
              <div v-if="perlog==null||perlog.length==0">
                <p>暂无帖子</p>
              </div>
              <el-card v-for="log in perlog" :key="log.id" class="log-card"
              style="margin-top: 10px;"
              >
              <div style="display: flex; align-items: center;height: 120px;">
                <div @click="touid(log.uid)" @mouseover="isuserHovered = log.id" @mouseleave="isuserHovered = -1"
                style="display: flex; align-items: center; width: 15%;"class="clickUname">
                  <img v-if="log.uimage" :src="log.uimage" alt="用户头像" class="avatar" style="width: 55px; height: 55px; border-radius: 50%; margin-right: 10px;" />
                  <img v-else src="../assets/loading.png" alt="用户头像" class="avatar" style="width: 55px; height: 55px; border-radius: 50%; margin-right: 10px;" />
                  <!-- 用户名和用户 ID 信息 -->

                  <div>
                      <div style="font-weight: bold;font-size: 15pt;word-break: break-all;">{{ log.uname }}</div>
                      <div style="color: #999; font-size: 10pt;">{{ log.uid }}</div>
                  </div>

                </div>
                <!-- 居中的标题 -->
                <div  @click="tolog(log.id)" @mouseover="istitleHovered = log.id" @mouseleave="istitleHovered = -1"
                style="flex-grow: 2; text-align: left; font-weight: bold; cursor: pointer;
                width: 70%; margin-right: 10px;">

                  <div :style="{ textDecoration: (istitleHovered==log.id) ? 'underline' : 'none' }">
                    <div style="font-size: 14pt; margin-bottom: 8px;">{{ log.title }}：</div>
                    <div style="color: #999;font-size: 10pt; font-weight: 400;">{{ log.somecontent }}</div>
                  </div>

                  <el-tag v-for="subject in log.subjects" 
                    :key="subject" 
                    style="margin-right: 10px;margin-top: 20px;" 
                    size="medium"
                  >{{ subject }}
                  </el-tag>

                  <div style="margin-left: auto; color: #999; font-size: 8pt;
                  display: flex;align-items: center;margin-top: 5px;">
                    <el-icon name="time">
                      <calendar/>
                    </el-icon>
                    <span>{{ log.time }}</span>
                  </div>

                </div>
                <div style="width: 15%;display: flex; flex-direction: column; align-items: flex-end;">
                  <span>
                    <el-button 
                      v-if="isself&&modname=='self'"
                      style="margin-left: 10px;"
                      @click="deleteLog(log.id)" 
                      type="danger"
                    >
                    删除
                    </el-button>
                    <el-button v-if="isself&&modname=='collect'"
                      style="margin-left: 10px;"
                    @click="uncollectLog(log.id)" type="warning" plain>取消收藏</el-button>
                    <el-button v-if="isself&&modname=='like'"
                      style="margin-left: 10px;"
                    @click="unlikeLog(log.id)" type="warning" plain>取消喜欢</el-button>
                  </span>
                </div>
              </div>
              </el-card>

            </div>

            <div v-else>
              <h4>用户隐藏了此内容</h4>
            </div>

            <!-- 分页 -->
            <el-pagination
              background
              :current-page="currentPage"
              :page-count="totalPages"
              layout="prev, pager, next , jumper"
              @current-change="goToPage"
              style="margin-top: 10px;"
            />

          </div>

          <div v-else-if="modname=='info'">
            <div class="maindesk">

              <span style="font-size: 35px; 
                      margin-bottom: 30px;
                      font-Family: 'MyCustomFont';
                      color:rgba(38, 38, 38)
                       "
              >
              基本信息
              </span>

              <el-divider></el-divider>
              <div class="info-card1">
                <div class="info-row">
                  <span><strong>个人简介:</strong></span>
                  <span>{{ perinfo.introduction }}</span>
                </div>
                <div class="info-row">
                  <span><strong>性别:</strong></span>
                  <span>{{ perinfo.sex }}</span>
                </div>
                <div class="info-row" v-if=" isself ||(persetting && persetting.showmail)">
                    <span><strong>邮箱:</strong></span>
                    <span>{{ perinfo.mail }}</span>
                </div>
                <div class="info-row" v-if ="isself ||(persetting && persetting.showphone)">
                    <span><strong>电话:</strong></span>
                    <span>{{ perinfo.phone }}</span>
                </div>

                <div class="info-row">
                  <span><strong>地址:</strong></span>
                  <span>{{ perinfo.address }}</span>
                </div>
                <div class="info-row">
                  <span><strong>出生日期:</strong></span>
                  <span>{{ perinfo.birthday }}</span>
                </div>
                <div class="info-row">
                  <span><strong>注册时间:</strong></span>
                  <span>{{ perinfo.regtime }}</span>
                </div>
              </div>
            </div>
            <div class="maindesk">

              <span style="font-size: 35px; 
                      margin-bottom: 30px;
                      font-Family: 'MyCustomFont';
                      color:rgba(38, 38, 38)
                       "
              >
              教育信息
             </span>

              <el-divider></el-divider>
              <div class="info-card2">
                <div class="info-row">
                  <span><strong>学校名称:</strong></span>
                  <span>{{ perinfo.schoolname }}</span>
                </div>
                <div class="info-row">
                  <span><strong>专业:</strong></span>
                  <span>{{ perinfo.major }}</span>
                </div>
                <div class="info-row">
                  <span><strong>入学时间:</strong></span>
                  <span>{{ perinfo.edutime }}</span>
                </div>
                <div class="info-row">
                  <span><strong>学历:</strong></span>
                  <span>{{ perinfo.edulevel }}</span>
                </div>
              </div>
            </div>
            <div class="maindesk">

              <span style="font-size: 35px; 
                      margin-bottom: 30px;
                      font-Family: 'MyCustomFont';
                      color:rgba(38, 38, 38)
                       "
              >
              工作信息
              </span>

              <el-divider></el-divider>
              <div class="info-card3">
                <div class="info-row">
                  <span><strong>公司名:</strong></span>
                  <span>{{ perinfo.companyname }}</span>
                </div>
                <div class="info-row">
                  <span><strong>职位:</strong></span>
                  <span>{{ perinfo.positionname }}</span>
                </div> 
                <div class="info-row">
                  <span><strong>所属行业:</strong></span>
                  <span>{{ perinfo.industry }}</span>
                </div>
              </div>
            </div>
          </div>

          <div v-else-if="modname=='setting'" class="maindesk">
            <div class="info-card4">
              <div class="info-row">
                <span>
                  展示喜欢的帖子：
                </span>
                <el-switch v-model="persetting.showlike"
                @change="editsetting('like')"/>
              </div>
              <div class="info-row">
                <span>
                  展示收藏的帖子：
                </span>
                <el-switch v-model="persetting.showcollect"
                @change="editsetting('collect')"/>
              </div>
              <div class="info-row">
                <span>
                  显示手机号：
                </span>
                <el-switch v-model="persetting.showphone"
                @change="editsetting('phone')"/>
              </div>
              <div class="info-row">
                <span>
                  显示邮箱：
                </span>
                <el-switch v-model="persetting.showmail"
                @change="editsetting('mail')"/>
              </div>
            </div>
          </div>

          <div v-else-if="modname=='attion'">
            <div class="maindesk">

              <span
                style="font-size: 30px; 
                margin-bottom: 30px;
                font-Family: 'MyCustomFont';
                color:rgba(38, 38, 38);
                font-Size:35px"
              >
                关注的人
              </span>

              <p v-if="attionlist==null||attionlist.length==0">暂无关注</p>
              <div class="post-list">
                <el-card 
                  v-for="attion in attionlist" 
                  :key="attion.uid" 
                  class="attion-card"
                >
                <div style="display: flex; align-items: center;justify-content: space-between;">
                  <div @click="touid(attion.uid)" @mouseover="isuserHovered = attion.uid" @mouseleave="isuserHovered = -1"
                  style="display: flex; align-items: center; cursor: pointer;">
                    <img v-if="attion.uimage" :src="attion.uimage" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                    <img v-else src="../assets/loading.png" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                    <!-- 用户名和用户 ID 信息 -->
                    <div :style="{textDecoration: (isuserHovered==attion.uid) ? 'underline' : 'none'}">
                      <div style="font-weight: bold;font-size: 16pt;">{{ attion.uname }}</div>
                      <div style="color: #999; font-size: 12pt;">{{ attion.uid }}</div>
                    </div>
                  </div>
                  <el-button @click="attion_force(attion.uid,'0')" type="primary" plain>取消关注</el-button>
                </div>
                </el-card>
              </div>
              <el-pagination
                background
                :current-page="attionlistpage"
                :page-count="attionlisttotalpages"
                layout="prev, pager, next , jumper"
                @current-change="goToPageattion"
                style="margin-top: 10px;"
              />
            </div>
            <div class="maindesk">
              
              <span
                style="font-size: 30px; 
                margin-bottom: 30px;
                font-Family: 'MyCustomFont';
                color:rgba(38, 38, 38);
                font-Size:35px"
              >
                粉丝
              </span>

              <p v-if="attionedlist==null||attionedlist.length==0">暂无粉丝</p>
              <div class="post-list">
                <el-card 
                  v-for="attion in attionedlist" 
                  :key="attion.uid" 
                  class="fans-card"
                >
                <div style="display: flex; align-items: center;justify-content: space-between;">
                  <div @click="touid(attion.uid)" @mouseover="isuserHovered = attion.uid" @mouseleave="isuserHovered = -1"
                  style="display: flex; align-items: center; cursor: pointer;">
                    <img v-if="attion.uimage" :src="attion.uimage" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                    <img v-else src="../assets/loading.png" alt="用户头像" class="avatar" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 30px;" />
                    <!-- 用户名和用户 ID 信息 -->
                    <div :style="{textDecoration: (isuserHovered==attion.uid) ? 'underline' : 'none'}">
                      <div style="font-weight: bold; font-size: 16pt;">{{ attion.uname }}</div>
                      <div style="color: #999; font-size: 12pt;">{{ attion.uid }}</div>
                    </div>
                  </div>
                  <el-button v-if="!attion.isattion" @click="attion_force(attion.uid,'1')" type="primary">回关</el-button>
                  <el-button v-else @click="attion_force(attion.uid,'0')" type="primary" plain>取消关注</el-button>
                </div>
                </el-card>
              </div>
              <el-pagination
                background
                :current-page="attionedlistpage"
                :page-count="attionedlisttotalpages"
                layout="prev, pager, next , jumper"
                @current-change="goToPageattioned"
                style="margin-top: 10px;"
              />
            </div>
          </div>

          <div v-else-if="modname=='sysmessage'">
            <div class="maindesk-message" v-if="sysmsg&&sysmsg.length>0">
              <el-card 
                v-for="msg in sysmsg" 
                key="msg.msgid"
                class ="card"
              >
                    <p>消息类型：
                      <span style="font-weight: bold;">{{ msg.type }}</span>
                    </p>

                    <p>发送时间：
                      <span style="font-weight: bold;color:#999">{{msg.time}}</span>
                    </p>

                    <div >消息内容：
                      <div style="display: flex; justify-content: space-between;">
                        <p style="border: 1px solid #ccc; padding: 20px; margin-top: 5px; width: 50%;">
                            <span  style="font-weight: bold;">{{msg.content}}</span>
                        </p>
                        <el-button style="margin-top: 2%;margin-right: 3%;"
                        @click="deleteSysmsg(msg.msgid)" type="danger" plain>删除</el-button>
                      </div>
                    </div>

                </el-card>

                <el-pagination
                background
                :current-page="sysmsgpage"
                :page-count="sysmsgtotalpages"
                layout="prev, pager, next , jumper"
                @current-change="goToPagemsg"
                style="margin-top: 10px;"
                />  

            </div>
            <div class="maindesk" v-else>
              <h4>暂无系统消息</h4>
            </div>

          </div>

          <!--管理员面板-->
          <!-- <div>
            <p>管理该用户</p>
            <p>至少需要以下功能：</p>
            <p>禁言（天数），封号（天数），向用户发送系统通知。</p>
            <p>并在这个.vue中实现查看系统通知的功能。</p>
          </div> -->
          <div v-else-if="modname=='admin'" >
            
            <div class="maindesk">
              <span>用户当前状态：</span>

              <div>
                <span 
                  v-if="status=='normal'" 
                  style="font-weight: bold; 
                  color: green;"
                >
                  状态正常
                </span>
                <span 
                  v-else-if="status=='baned'"
                  style="font-weight: bold; 
                  color: red;"
                >
                  <span v-if="days>0">
                    已被封禁，剩余封禁天数:{{days}},封禁结束日期:{{ lifttime }}                  
                  </span> 
                  <span v-else>
                    已被永久封禁
                  </span>
                </span>
                <span 
                  v-else-if="status=='restrickted'"
                  style="font-weight: bold; 
                  color: red;"
                >
                  <span v-if="days>0">
                    已被禁言，剩余禁言天数:{{days}},禁言结束日期:{{ lifttime }}                  
                  </span> 
                  <span v-else>
                    已被永久禁言
                  </span>
                </span>
              </div>
            </div>

            <div class="maindesk" style="display: flex; flex-direction: column; align-items: flex-start;">
              <span>管理用户</span>
              <div style="margin-top: 10px;">
                <br>
                <el-button @click="warnUserBtn" type="danger" plain :disabled="days<0">警告用户</el-button>
                <el-button @click="rsdUserBtn" type="danger" plain :disabled="status !== 'normal'||days<0">禁言用户</el-button>
                <el-button @click="banUserBtn" type="danger" plain style="margin-right: 10px;" :disabled="(status !== 'normal' && status !== 'restrickted')||days<0">封禁用户</el-button>
              </div>
            </div>

            <div class="maindesk" style="display: flex; flex-direction: column; align-items: flex-start;">
              <span>修改限制天数</span>
              <div style="margin-top: 10px;">
                <br>
                <el-button @click="increaseBtn" type="danger " plain :disabled="status =='normal' ||days<0 ||days >=365">增加限制时间</el-button>
                <el-button @click="decreaseBtn" type="primary" style="margin-right: 10px; " :disabled="status =='normal'||days<=1">减少限制时间</el-button>
              </div>
            </div>


            <div class="maindesk" style="display: flex; flex-direction: column; align-items: flex-start;">
              <span>解除用户限制</span>
              <div style="margin-top: 10px;">
                <br>
                <el-button @click="liftRsdBtn" type="primary " :disabled="status ==='normal' || status ==='baned'">解除禁言</el-button>
                <el-button @click="liftBanBtn" type="primary" style="margin-right: 10px; " :disabled="status ==='normal'|| status ==='restrickted'">解除封禁</el-button>
              </div>
            </div>
          </div>
          



        </el-main>
      </el-container>
    </el-container>
  </div>

  <!-- 弹出框 -->
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

  <ModifyDialog
    v-if="moddialogvisible"
    :uid="uid"
    :days="days"
    :type="modtype"
    :status="status"
    @ok="modLiftDaysOk"
    @fail="modLiftDaysCancel"
  ></ModifyDialog>

  <AdminDHandleDia
    v-if="adminDhandlevisible"
    :uid="uid"
    :type="dhandletype"
    @ok="AdminDHandleOk"
    @fail="AdminDHandleFail"
  ></AdminDHandleDia>


  <el-image-viewer
    v-if="isshowuimage"
    :url-list="[userimage.src]"
    @close="showuimage"
    :hide-on-click-modal="true"
    :infinite="false"
    />
</template>

<script setup>

    import { ref, onMounted, getCurrentInstance ,computed, onUnmounted } from 'vue';
    import myDialog from './Mydialog.vue';
    import router from '@/router';
    import * as ElementPlusIconsVue from '@element-plus/icons-vue'
    import ModifyDialog from './ModifyDialog.vue';
    // import { format } from 'date-fns'
    import AdminDHandleDia from './AdminDHandleDia.vue'
// import { is } from 'core-js/core/object';

    const calendar = ElementPlusIconsVue.Calendar
    const infoIcon = ElementPlusIconsVue.Document
    const collectIcon = ElementPlusIconsVue.Star
    const sendIcon = ElementPlusIconsVue.Edit
    const attionIcon = ElementPlusIconsVue.User
    const settingIcon = ElementPlusIconsVue.Setting
    const adminIcon = ElementPlusIconsVue.Lock
    const sysmessageIcon = ElementPlusIconsVue.ChatLineRound

      const status = ref('');
      const lifttime = ref('');
      let days = ref(0);
      console.log(days.value);
      const moddialogvisible = ref(false);
      const modtype = ref('');
      const adminDhandlevisible = ref(false);
      const dhandletype = ref('');

      //弹窗组件变量
      const dialogtitle = ref('');
      const dialogtext = ref('');
      const dialogneedcancelbut = ref(false);
      const dialogsurebuttext = ref('');
      const dialogcancelbuttext = ref('');
      const dialogvisible = ref(false);
      const maindeskreadonly = ref(false);
      let dialogconfirmfuc=()=>null;
      let dialogcancelfuc=()=>null;

      const goingdeleteid = ref(null);
      const isshowuimage = ref(false);
      const istitleHovered = ref(-1);
      const isuserHovered = ref(-1);

      //系统消息
      const sysmsg = ref([]);
      const sysmsgpage = ref(1);
      const sysmsgtotalpages = ref(1);

      //关注列表变量
      const attionlist=ref([]);
      const attionedlist=ref([]);
      const attionlistpage=ref(1);
      const attionedlistpage=ref(1);
      const attionlisttotalpages=ref(1);
      const attionedlisttotalpages=ref(1);

      const modname=ref('info');
      const isself=ref(false);
      const isadmin=ref(sessionStorage.getItem('isadmin'));
      const logvalid=ref(false);
      const infoready=ref(false);
      const logready=ref(false);
      const currentPage=ref(1);
      const totalPages=ref(1);
      const headers = new Headers();
      headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));
      const app = getCurrentInstance();
      const uid = ref(window.location.pathname.split('/').pop());
      const myuid = sessionStorage.getItem('uid');
      const userimage = ref(null);
      const searname=ref('');
      const searchmod=ref(false);
      if(uid.value==myuid){
        isself.value=true;
      }
      const path = app.proxy.$backpath;
      const perinfo = ref(false);
      const perlog=ref(null);
      const persetting=ref(null);

      const fetchStatus = async()=>{
        console.log('dsadasdsadas');
        const response = await fetch(`${path}/api/adm/getUserStatus?uid=${uid.value}`,
        {
          method:'GET',
          headers:headers,
        }
        );
        const data =  await response.json();
        console.log(data);
        status.value=data.status;
        lifttime.value=data.lifttime;
        console.log(data.lifttime);
        days.value=data.days;
      }

      const fetchPerinfo = async () => {
        let fetchstr=path+'/api/perinfo?uid='+uid.value+'&requesteruid='+myuid;
        const response = await fetch(fetchstr,
        {
          method:'GET',
          headers:headers,
        }
        );
        if(response.status==404||response.status==500){
          showdialog('提示','用户不存在',false,'返回主页','',()=>{window.location.href='/';});
          return;
        }
        perinfo.value =  await response.json();
        document.title = perinfo.value.uname+'的个人主页'+'-云枢论坛';
        //从服务器获取用户头像，存储于perinfo.value.userimage，为base64编码
        userimage.value=new Image();
        userimage.value.src=perinfo.value.uimage;
        infoready.value=true;
      };
      const fetchPerlog = async()=>{
        let response=null;
        if(searchmod.value){
          let fetchstr=`${path}/api/searchlogs?page=${currentPage.value}&isattion=false&uid=${myuid}&aimuid=${uid.value}`;
          let body={
            name:searname.value
          }
          response=await fetch(fetchstr,{
            method:'POST',
            body:JSON.stringify(body),
            headers:headers,
          });
        }
        else if(modname.value=='self'){
          response=await fetch(`${path}/api/perlogs?page=${currentPage.value}&aimuid=${uid.value}&uid=${myuid}`,
            {
              method:'GET',
              headers:headers,
            }
          );
        }
        else if(modname.value=='like'){
          response=await fetch(`${path}/api/perlikelogs?page=${currentPage.value}&aimuid=${uid.value}&uid=${myuid}`,
            {
              method:'GET',
              headers:headers,
            }
          );
        }
        else if(modname.value=='collect'){
          response=await fetch(`${path}/api/percollectlogs?page=${currentPage.value}&aimuid=${uid.value}&uid=${myuid}`,
          {
            method:'GET',
            headers:headers,
          }
          );
        }
        else{
          logready.value=true;
          return;
        }
        const data =  await response.json();
        if(data.logs==null||data.logs.length==0){
          perlog.value=null;
        }
        else{
          perlog.value = data.logs;
        }
        totalPages.value = data.totalPages;
        logvalid.value=data.isvalid;
        if(modname.value=='self'){
          logvalid.value=true;
        }
        logready.value=true;
      }

      const fetchPersetting = async()=>{
        const response = await fetch(`${path}/api/persetting?uid=${uid.value}`,
        {
          method:'GET',
          headers:headers,
        }
        );
        persetting.value =  await response.json();
      }

      const fetchSysmsg = async()=>{
        let response = await fetch(`${path}/api/adm/getmessage?uid=${uid.value}`+
        `&page=${sysmsgpage.value}`,
        {
          method:'GET',
          headers:headers,
        }
        );
        let data =  await response.json();
        sysmsg.value =  data.msgobj;
        sysmsgtotalpages.value = data.totalPages;
        console.log(sysmsgtotalpages.value);
        
      } 

      const fetchPerattion =async()=>{
        let response = await fetch(`${path}/api/per/attion?uid=${uid.value}`+
        `&page=${attionlistpage.value}`,
        {
          method:'GET',
          headers:headers,
        }
      );
        let data =  await response.json();
        attionlist.value=data.datas;
        attionlisttotalpages.value=data.totalPages;
        console.log(attionedlisttotalpages.value);
        response = await fetch(`${path}/api/per/attioned?uid=${uid.value}`+
        `&page=${attionedlistpage.value}`,
        {
          method:'GET',
          headers:headers,
        }
      );
        data =  await response.json();
        attionedlist.value=data.datas;
        attionedlisttotalpages.value=data.totalPages;
      }

      const asklogout=()=>{
        showdialog('提示','确定要注销吗？',true,'确定','取消',logout,()=>null);
      }

    const handleClear = () => {
      searchmod.value=false;
      fetchPerlog();
      // window.location.reload();
    };

    const attionusr = async()=>{
        if(!myuid){
          showdialog('提示','请先登录',true,'登录','取消',()=>
          {
            let path=window.location.pathname;
            window.location.href='/login?from='+path;
          },()=>null);
          return;
        }
        console.log(perinfo.value.isattion);
        const attionstr = perinfo.value.isattion? '0':'1';//0表示取消关注，1表示关注
        const response = await fetch(path+'/api/attionusr?uid='+myuid+
        '&attionuid='+uid.value+'&type='+attionstr, {
            method: 'POST',
            headers:headers,
        });
        const data =  await response.json();
        if (data.isok) {
          perinfo.value.isattion = !perinfo.value.isattion;
          if(perinfo.value.isattion){
            perinfo.value.fansnum++;
          }
          else{
            perinfo.value.fansnum--;
          }
          if(attionstr=='1'){
            showdialog('关注成功',null,false,'确定','');
          }
          else{
            showdialog('取关成功',null,false,'确定','');
          }
        }
        else{
          if(attionstr=='1'){
            showdialog('关注失败',data.failreason,false,'确定','');
          }
          else{
            showdialog('取关失败',data.failreason,false,'确定','');
          }
        }
      }

      const attion_force =async(uidd,type)=>{
        const response = await fetch(path+'/api/attionusr?uid='+myuid+
        '&attionuid='+uidd+'&type='+type, {
            method: 'POST',
            headers:headers,
        });
        const data =  await response.json();
        if (data.isok) {
          await fetchPerattion();
        }
        else{
          if(type=="0"){
            showdialog('取关失败',data.failreason,false,'确定','');
          }
          else{
            showdialog('关注失败',data.failreason,false,'确定','');
          }
        }
      }

    const deleteLog = async (logid) => {
      showdialog('提示','确定要删除这篇帖子吗？',true,'确定','取消',deletelog,()=>null);
      goingdeleteid.value=logid;
    };

    const changemod =async (mod) => {
      searchmod.value=false;
      if(mod=='info'){
        modname.value=mod;
        await fetchPersetting();
        await fetchPerinfo();
      }
      else if(mod=='setting'){
        await fetchPersetting();
        console.log(persetting.value);
        modname.value=mod;
      }
      else if(mod=='attion'){
        modname.value=mod;
        await fetchPerattion();
      }
      else if(mod=='admin'){
        modname.value=mod;
      }
      else if(mod=='sysmessage'){
        modname.value=mod;
        await fetchSysmsg();
      }
      else{
        modname.value=mod;
        currentPage.value=1;
        await fetchPerlog();
      }
    };

    const goToPage = (page) => {
      currentPage.value = page;
      fetchPerlog();
    };

    const goToPageattion = (page) => {
      attionlistpage.value=page;
      fetchPerattion();
    }

    const goToPageattioned = (page) => {
      attionedlistpage.value=page;
      fetchPerattion();
    }

    const goToPagemsg = (page) => {
      sysmsgpage.value=page;
      fetchSysmsg();
    }

    const searchLog = async()=>{
      if(searname.value==''){
        showdialog('提示','请输入搜索内容',false,'确定','');
        return;
      }
      searchmod.value=true;
      fetchPerlog();
    }
    

    const uncollectLog = async (logid) => {
      const collectstr = '0';
      const response = await fetch(path + '/api/collectlog?uid=' + myuid + '&logid=' + logid + '&type=' + collectstr, {
        method: 'POST',
        headers:headers,
      });
      const data =  await response.json();
      if (data.isok) {
        for (let i = 0; i < perlog.value.length; i++) {
          if (perlog.value[i].id == logid) {
            //从perlog中删除这个帖子
            perlog.value.splice(i, 1);
            break;
          }
        }
      }
      else {
        showdialog('操作失败', data.failreason, false, '确定', '');
      }
    };

    const unlikeLog = async (logid) => {
      const likestr = '0';
      const response = await fetch(path + '/api/likelog?uid=' + myuid + '&logid=' + logid + '&type=' + likestr, {
        method: 'POST',
        headers:headers,
      });
      const data =  await response.json();
      if (data.isok) {
        for (let i = 0; i < perlog.value.length; i++) {
          if (perlog.value[i].id == logid) {
            //从perlog中删除这个帖子
            perlog.value.splice(i, 1);
            break;
          }
        }
      }
      else {
        showdialog('操作失败', data.failreason, false, '确定', '');
      }
    };

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


    const logout =()=>{
        sessionStorage.removeItem('uid');
        sessionStorage.removeItem('uname');
        sessionStorage.removeItem('uimage');
        sessionStorage.removeItem('isadmin');
        sessionStorage.removeItem('token');
        window.location.href='/';
    }

    const deletelog=async()=>{
        let logid=goingdeleteid.value;
        const response = await fetch(`${path}/api/deletelog?uid=${myuid}&logid=${logid}`, {
          method: 'POST',
          headers:headers,
        });
        const data =  await response.json();
        if (data.isok){
          for(let i=0;i<perlog.value.length;i++){
            if(perlog.value[i].id==logid){
              perlog.value.splice(i,1);
              break;
            }
          }
          showdialog('删除成功',null,false,'确定','');
        }
        else{
          showdialog('删除失败',data.failreason,false,'确定','');
        }
    }

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

    const editinfo =()=>{
      router.push('/editinfo/'+uid.value);
    }

    const editsetting =async(name)=>{
      name='show'+name;
      let value=persetting.value[name];
      if(value){
        value="1";
      }
      else{
        value="0";
      }
      let body={
        type:name,
        value:value,
        uid:myuid
      }
      console.log(body);
      const response = await fetch(path+'/api/persetting/edit', {
        method: 'POST',
        body: JSON.stringify(body),
        headers:headers,
      });
      const data =  await response.json();
      if(data.isok){
        return;
      }
      showdialog('修改失败',data.failreason,false,'确定','');
      persetting.value[name]=!value;
    }

    const tolog = (logid) => {
      router.push('/log/' + logid);
    }

    const touid = (uid) => {
      window.location.href='/perinfo/'+uid;
    }

    const showuimage = () => {
      isshowuimage.value = !isshowuimage.value;
    }


    // const addDaysToDateString = (dateString, days) => {
    //   const date = new Date(dateString.replace(/-/g, '/')) // 将日期字符串转换为 Date 对象
    //   date.setDate(date.getDate() + days) // 添加天数
    //   return format(date, 'yyyy-MM-dd HH:mm:ss') // 将 Date 对象格式化为字符串
    // }

    const modLiftDaysOk = async(changedays)=>{
      moddialogvisible.value=false;
      maindeskreadonly.value=false;
      showdialog('修改成功','',false,'确定','');
      days.value=days.value+changedays;
      // lifttime.value=addDaysToDateString(lifttime.value,changedays);
      fetchStatus();
    }

    const modLiftDaysCancel = (reason)=>{
      moddialogvisible.value=false;
      if(reason == 'cancel'){
        maindeskreadonly.value=false;
        return;
      }
      showdialog('修改失败',reason,false,'确定','');
    }

    const rsdUserBtn = () => {
      adminDhandlevisible.value=true;
      maindeskreadonly.value=true;
      dhandletype.value='Rsd';
    }
    const banUserBtn = () => {
      adminDhandlevisible.value=true;
      maindeskreadonly.value=true;
      dhandletype.value='Ban';
    }
    const warnUserBtn = () => {
      adminDhandlevisible.value=true;
      maindeskreadonly.value=true;
      dhandletype.value='Warn';
    }

    const AdminDHandleOk =(newstatus,newdays) =>{
      adminDhandlevisible.value = false;
      maindeskreadonly.value=false;
      showdialog('处理成功','',false,'确定','');
      if(newstatus != ''){
        status.value=newstatus;
        days.value=newdays;
        if(newdays>0){
          // lifttime.value=addDaysToDateString(lifttime.value,newdays);
          fetchStatus();
        }
      }
    }

    const AdminDHandleFail =(reason) =>{
      adminDhandlevisible.value = false;
      if(reason == 'cancel'){
        maindeskreadonly.value=false;
        return;
      }
      showdialog('处理失败',reason,false,'确定','');
    }

    const increaseBtn = () => {
      moddialogvisible.value=true;
      maindeskreadonly.value=true;
      modtype.value='increase';
      // modifyDays();
    }
    const decreaseBtn = () => {
      moddialogvisible.value=true;
      maindeskreadonly.value=true;
      modtype.value='decrease';
      // modifyDays();
    }

    const deleteSysmsg = async (msgid) => {
      let fetchstr = path + '/api/adm/deletemessage' + '?uid=' + uid.value + '&msgid=' + msgid;
      const response = await fetch(fetchstr, {
          method: 'POST',
          headers:headers,
      });
      let data = await response.json();
      if(data.isok){
        showdialog('删除成功',null,false,'确定','');
        fetchSysmsg();
      }
      else{
        showdialog('删除失败',data.failreason,false,'确定','');
      }
    };


    const liftRsdBtn = () => {
      showdialog('提示','确定要对用户解除禁言吗？',true,'确定','取消',liftRsd,()=>null);
    }
    const liftRsd = async()=>{
      let body={
        uid:uid.value,
      }
      const fetchstr = path + '/api/adm/liftBan' + '?uid=' + uid.value;
      const response = await fetch(fetchstr, {
          method: 'POST',
          body: JSON.stringify(body),
          headers:headers,
      });
      let data = await response.json();
      if(data.isok){
        showdialog('解除禁言成功',null,false,'确定','');
        status.value='normal';
        days.value=0;
      }
      else{
        showdialog('解除禁言失败',data.failreason,false,'确定','');
      }
    }

    const liftBanBtn = () => {
      showdialog('提示','确定要对用户解除封禁吗？',true,'确定','取消',liftBan,()=>null);
    }
    const liftBan = async()=>{
      let body={
        uid:uid.value,
      }
      const fetchstr = path + '/api/adm/liftBan' + '?uid=' + uid.value;
      const response = await fetch(fetchstr, {
          method: 'POST',
          body: JSON.stringify(body),
          headers:headers,
      });
      let data = await response.json();
      if(data.isok){
        showdialog('解除封禁成功',null,false,'确定','');
        status.value='normal';
        days.value=0;
      }
      else{
        showdialog('解除封禁失败',data.failreason,false,'确定','');
      }
      
    }

    const tosearch = (sname) => {
      sname=sname.substring(0);
      sname="subject--"+sname;
      router.push(`/home?sname=${sname}`);
    };

    onMounted(fetchPerinfo);
    onMounted(fetchPerlog);
    onMounted(fetchSysmsg);
    onMounted(fetchStatus);
    onMounted(fetchPersetting);
    
</script>

<style>
.disabled {
  pointer-events: none; /* 禁止点击 */
  opacity: 0.5; /* 不可用状态的视觉效果 */
}
.myHeader {
  /*圆角边框*/
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  background-color: #e9f4fbcc;
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  /*宽度为70%*/
  width: 70%;
  /*居中*/
  margin: 0 auto;
  background-image: url('../assets/userBackground.jpg');
  background-size: cover; /* 确保背景图片覆盖整个容器 */
  background-repeat: no-repeat; /* 防止背景图片重复 */
  background-position: center; /* 背景图片居中 */

}
.maindesk {
  margin-bottom: 10px;
  background-color: #e9f4fbcc;
  /*突出显示，阴影效果*/
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
}
.maindesk-message{
  margin-bottom: 10px;
  background-color: #e9f4fbcc;
  /*突出显示，阴影效果*/
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 20px;
  border-radius: 10px;
  border: 1px solid #ccc;
  margin-top: 10px;
  background-image: url('../assets/maindesks.png');
  background-size: auto; /* 确保背景图片覆盖整个容器 */
  background-repeat: repeat; /* 防止背景图片重复 */
  margin-bottom: 10px;
}
/*设计mymenu的item的样式*/
.mymenu .el-menu-item {
  background-color: rgba(0, 0, 0, 0) !important;
border:  0.1px solid #cccccc48;
}

.mymenu {
  background-color: #e9f4fbcc !important;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  border-radius: 10px;
  border: 1px solid #ccc;
}


.info-card1 {
  font-size: 16px;
  color: #555;
  line-height: 1.8;
  border: 1px solid #ddd;
  padding: 10px;
  border-radius: 5px;
  background-image: url('../assets/personInfo1.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
}

.info-card2 {
  font-size: 16px;
  color: #555;
  line-height: 1.8;
  border: 1px solid #ddd;
  padding: 10px;
  border-radius: 5px;
  background-image: url('../assets/personInfo2.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
}

.info-card3{
  font-size: 16px;
  color: #555;
  line-height: 1.8;
  border: 1px solid #ddd;
  padding: 10px;
  border-radius: 5px;
  background-image: url('../assets/personInfo3.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
}


.info-card4{
  font-size: 16px;
  color: #555;
  line-height: 1.8;
  border: 1px solid #ddd;
  padding: 10px;
  border-radius: 5px;
  background-image: url('../assets/personInfo4.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
}


.info-row {
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid #e3e3e3;
  padding: 5px 0;
}

.info-row span:first-child {
  width: 25%;
  text-align: left; /* 确保文本左对齐 */
}

.info-row span:last-child {
  width: 75%;
  text-align: left; /* 确保文本左对齐 */
}

.info-row:last-child {
  border-bottom: none; /* 去掉最后一行的下划线 */
}

.littleTitle{
  font-size: 16px; 
  color : rgb(90, 84, 84); 
  text-shadow : 0.5px 0.5px 0.5px rgba(0, 0, 0, 1);
}

.card{
  margin-top: 10px;
  background-image: url('../assets/messageBackground.jpg');
  background-size: cover; /* 确保背景图片覆盖整个容器 */
  background-repeat: no-repeat; /* 防止背景图片重复 */
  background-position: center; /* 背景图片居中 */
}

.log-card{
  margin-top: 10px;
  background-image: url('../assets/userBg.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
}

.attion-card{
  margin-top: 10px;
  background-image: url('../assets/userBg.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
}

.fans-card{
  margin-top: 10px;
  background-image: url('../assets/userBg.jpg');
  background-size: cover; 
  background-repeat: no-repeat; 
  background-position: center; 
}
/* 
.clickable-tag {
  margin-right: 10px;
  font-size: 25px;
  cursor: pointer;
  transition: font-weight 0.3s; 
} */
.clickable-tag {
  cursor: pointer;
}
.clickable-tag:hover {
  font-weight: bold; /* 鼠标移到标签上时字体变粗 */
  background-color: #f0f0f0; /* 鼠标移到标签上时背景颜色变化 */
  color: #333; /* 鼠标移到标签上时字体颜色变化 */
}

.clickUname{
  cursor: pointer;
}
.clickUname:hover {
  font-weight: bold; /* 鼠标移到标签上时字体变粗 */
  color: #2794c3; /* 鼠标移到标签上时字体颜色变化 */
}

</style>