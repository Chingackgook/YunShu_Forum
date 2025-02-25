<template>
  <div :class="{disabled: maindeskreadonly}" class="main" style="margin-left: 12%;margin-right: 12%;">
      <el-card class="maincard" v-if="perinfo" name="基础信息">
        <h1>基本信息</h1>
        <el-divider></el-divider>
        <div class="maindiv">
        <div  style="width: 25%;">
            <img v-if="perinfo.uimage" :src="perinfo.uimage" alt="用户头像" 
            @click="showuimage"
            style="width: 60px; height: 60px; border-radius: 50%; margin-right: 10px; cursor: pointer;" />
            <img v-else src="../assets/loading.png" alt="用户头像" 
            @click="showuimage"
            style="width: 60px; height: 60px; border-radius: 50%; margin-right: 10px; cursor: pointer;" />
        </div>
          <div style=" width: 75%;">
            <el-button @click="upbutclick" plain type="primary" size="small">更改头像</el-button>
          </div>
          <input type="file" @change="uploadImage" ref="uploadbut" style="display: none;">
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">用户名:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.uname" @click="edit('uname')">
              <el-button class="context" text>{{ editbaleData['uname'] }}</el-button>
            </div>
            <div v-else>
              <el-input v-model="editbaleData['uname']" placeholder="请输入用户名"
              autosize type="textarea" @keydown.enter="send('uname')"
              style="width: 60%;"></el-input>
              <el-button style="margin-left:10px;" @click="send('uname')">确认</el-button>
              <el-button @click="canceledit('uname')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">个性签名:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.persign" @click="edit('persign')">
              <el-button class="context" text>{{ editbaleData['persign'] }}</el-button>
            </div>
            <div v-else>
              <el-input v-model="editbaleData['persign']" placeholder="请输入个性签名"
              autosize type="textarea" @keydown.enter="send('persign')"
              style="width: 60%;"></el-input>
              <el-button style="margin-left:10px;" @click="send('persign')">确认</el-button>
              <el-button @click="canceledit('persign')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">兴趣标签:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.interests" @click="edit('interests')">
              <el-tag v-for="interest in editbaleData['interests']" :key="interest" 
              style="margin-left: 10px; cursor: pointer;" @keydown.enter="send('interests')"
              size="large">{{ interest }}</el-tag>
              <el-button v-if="editbaleData['interests'].length==0" plain type="primary"
              style="margin-left: 10px;" size="small">
                添加兴趣标签
              </el-button>
            </div>
            <div v-else>
              <div>
                <el-select v-model="editbaleData['interests']" placeholder="请选择兴趣" multiple
                autosize style="width: 60%;">
                  <el-option label="阅读" value="阅读"></el-option>
                  <el-option label="旅行" value="旅行"></el-option>
                  <el-option label="运动" value="运动"></el-option>
                  <el-option label="音乐" value="音乐"></el-option>
                  <el-option label="电影" value="电影"></el-option>
                  <el-option label="美食" value="美食"></el-option>
                  <el-option label="摄影" value="摄影"></el-option>
                  <el-option label="游戏" value="游戏"></el-option>
                  <el-option label="编程" value="编程"></el-option>
                  <el-option label="绘画" value="绘画"></el-option>
                </el-select>
                <el-button style="margin-left:10px;" @click="send('interests')">确认</el-button>
                <el-button @click="canceledit('interests')">取消</el-button>
              </div>
              <div style="margin-top: 10px;margin-bottom: 10px;">
                <el-input v-model="selfinterst" placeholder="自定义兴趣标签"
                style="width: 60%;"
                ></el-input>
                <el-button style="margin-left: 10px;" @click="addselfinterest">添加</el-button>
              </div>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">邮箱:</p>
          </div>
          <div style="width: 75%;">
            <div @click="showmaildialog">
              <el-button class="context" text>{{ editbaleData['mail'] }}</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">电话:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.phone" @click="edit('phone')">
              <el-button class="context" text>{{ editbaleData['phone'] }}</el-button>
            </div>
            <div v-else>
              <el-input v-model="editbaleData['phone']" placeholder="请输入电话"
              autosize type="textarea" @keydown.enter="send('phone')"
              style="width: 60%;"></el-input>
              <el-button style="margin-left:10px;" @click="send('phone')">确认</el-button>
              <el-button @click="canceledit('phone')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">地址:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.address" @click="edit('address')">
              <el-button class="context" text>{{ editbaleData['address'] }}</el-button>
            </div>
            <div v-else>
              <el-input v-model="editbaleData['address']" placeholder="请输入地址"
              autosize type="textarea"  @keydown.enter="send('address')"
              style="width: 60%;"></el-input>
              <el-button style="margin-left:10px;" @click="send('address')">确认</el-button>
              <el-button @click="canceledit('address')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">出生日期:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.birthday" @click="edit('birthday')">
              <el-button class="context" text>{{ editbaleData['birthday'] }}</el-button>
            </div>
            <div v-else>
              <el-date-picker v-model="editbaleData['birthday']" placeholder="请选择日期"
              autosize type="date" format="YYYY/MM/DD" value-format="YYYY-MM-DD" @keydown.enter="send('birthday')"
              style="width: 60%;"></el-date-picker>
              <el-button style="margin-left:10px;" @click="send('birthday')">确认</el-button>
              <el-button @click="canceledit('birthday')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">性别:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.sex" @click="edit('sex')">
              <el-button class="context" text>{{ editbaleData['sex']  }} </el-button>
            </div>
            <div v-else>
              <el-select v-model="editbaleData['sex']" placeholder="请选择性别"
              autosize style="width: 60%;">
                <el-option label="男" value="男"></el-option>
                <el-option label="女" value="女"></el-option>
                <el-option label="保密" value="保密"></el-option>
              </el-select>
              <el-button style="margin-left:10px;" @click="send('sex')">确认</el-button>
              <el-button @click="canceledit('sex')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">简介:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.introduction" @click="edit('introduction')">
              <el-button class="context" text>{{ editbaleData['introduction'] }}</el-button>
            </div>
            <div v-else>
              <el-input v-model="editbaleData['introduction']" placeholder="请输入简介"
              autosize type="textarea" @keydown.enter="send('introduction')"
              style="width: 60%;"></el-input>
              <el-button style="margin-left:10px;" @click="send('introduction')">确认</el-button>
              <el-button @click="canceledit('introduction')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
      </el-card>
      <el-card class="maincard" v-if="perinfo" name="学校信息">
        <h1>教育信息</h1>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">学校:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.schoolname" @click="edit('schoolname')">
              <el-button class="context" text>{{ editbaleData['schoolname'] }}</el-button>
            </div>
            <div v-else>
              <el-input v-model="editbaleData['schoolname']" placeholder="请输入学校"
              autosize type="textarea" @keydown.enter="send('schoolname')"
              style="width: 60%;"></el-input>
              <el-button style="margin-left:10px;" @click="send('schoolname')">确认</el-button>
              <el-button @click="canceledit('schoolname')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">专业:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.major" @click="edit('major')">
              <el-button class="context" text>{{ editbaleData['major'] }}</el-button>
            </div>
            <div v-else>
              <el-input v-model="editbaleData['major']" placeholder="请输入专业"
              autosize type="textarea" @keydown.enter="send('major')"
              style="width: 60%;"></el-input>
              <el-button style="margin-left:10px;" @click="send('major')">确认</el-button>
              <el-button @click="canceledit('major')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">入学时间:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.edutime" @click="edit('edutime')">
              <el-button class="context" text>{{ editbaleData['edutime'] }}</el-button>
            </div>
            <div v-else>
              <el-date-picker v-model="editbaleData['edutime']" placeholder="请选择日期"
              autosize type="date" format="YYYY/MM/DD" value-format="YYYY-MM-DD"
              style="width: 60%;"></el-date-picker>
              <el-button style="margin-left:10px;" @click="send('edutime')">确认</el-button>
              <el-button @click="canceledit('edutime')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">学历:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.edulevel" @click="edit('edulevel')">
              <el-button class="context" text>{{ editbaleData['edulevel'] }}</el-button>
            </div>
            <div v-else>
              <el-select v-model="editbaleData['edulevel']" placeholder="请选择学历"
              autosize style="width: 60%;">
                <el-option label="小学" value="小学"></el-option>
                <el-option label="初中" value="初中"></el-option>
                <el-option label="高中" value="高中"></el-option>
                <el-option label="本科" value="本科"></el-option>
                <el-option label="硕士" value="硕士"></el-option>
                <el-option label="博士" value="博士"></el-option>
              </el-select>
              <el-button style="margin-left:10px;" @click="send('edulevel')">确认</el-button>
              <el-button @click="canceledit('edulevel')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
      </el-card>
      <el-card class="maincard" v-if="perinfo" name="工作信息">
        <h1>工作信息</h1>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">公司:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.companyname" @click="edit('companyname')">
              <el-button class="context" text>{{ editbaleData['companyname'] }}</el-button>
            </div>
            <div v-else>
              <el-input v-model="editbaleData['companyname']" placeholder="请输入公司"
              autosize type="textarea" @keydown.enter="send('companyname')"
              style="width: 60%;"></el-input>
              <el-button style="margin-left:10px;" @click="send('companyname')">确认</el-button>
              <el-button @click="canceledit('companyname')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">职位:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.positionname" @click="edit('positionname')">
              <el-button class="context" text>{{ editbaleData['positionname'] }}</el-button>
            </div> 
            <div v-else>
              <el-input v-model="editbaleData['positionname']" placeholder="请输入职位"
              autosize type="textarea" @keydown.enter="send('positionname')"
              style="width: 60%;"></el-input>
              <el-button style="margin-left:10px;" @click="send('positionname')">确认</el-button>
              <el-button @click="canceledit('positionname')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
        <div class="maindiv" style="margin-top: 10px;">
          <div style="width: 25%;">
            <p class="labeltext">行业:</p>
          </div>
          <div style="width: 75%;">
            <div v-if="!isediting.industry" @click="edit('industry')">
              <el-button class="context" text>{{ editbaleData['industry'] }}</el-button>
            </div>
            <div v-else>
              <el-select v-model="editbaleData['industry']" placeholder="请选择行业"
              autosize style="width: 60%;">
              <el-option label="IT" value="IT"></el-option>
                <el-option label="金融" value="金融"></el-option>
                <el-option label="教育" value="教育"></el-option>
                <el-option label="医疗" value="医疗"></el-option>
                <el-option label="制造业" value="制造业"></el-option>
                <el-option label="房地产" value="房地产"></el-option>
                <el-option label="零售" value="零售"></el-option>
                <el-option label="物流" value="物流"></el-option>
                <el-option label="能源" value="能源"></el-option>
                <el-option label="法律" value="法律"></el-option>
                <el-option label="其他" value="其他"></el-option>
              </el-select>
              <el-button style="margin-left:10px;" @click="send('industry')">确认</el-button>
              <el-button @click="canceledit('industry')">取消</el-button>
            </div>
          </div>
        </div>
        <el-divider></el-divider>
      </el-card>
      <!---返回个人中心-->

      <el-button 
        @click="toperinfo" 
        style="
          margin-top: 10px;
          width: 150px;
          height: 50px;
          font-size: 20px;"
        plain type="primary"
      >
      返回个人中心
      </el-button>

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

  <!-- 编辑邮箱对话框 -->
  <Editmaildialog
    v-if="editmaildialogvisible"
    :uid="uid"
    @ok="maildialogok"
    @cancel="maildialogcancel"
  ></Editmaildialog>

  <el-image-viewer
    v-if="isshowimage"
    :url-list="[perinfo.uimage]"
    @close="showuimage"
    :hide-on-click-modal="true"
    />
  
</template>
  
<script>
import { ref, getCurrentInstance, onMounted } from 'vue';
import myDialog from './Mydialog.vue';
import Editmaildialog from './Editmaildialog.vue';

  export default {
    name: 'Editinfo',
    components: {
      myDialog,
      Editmaildialog,
    },
    setup() {
      const app = getCurrentInstance();
      const path = app.proxy.$backpath;
      const uid = ref(sessionStorage.getItem('uid'));
      const perinfo = ref(null);
      const editbaleData = ref(
        [
          {name:'uname',text:'用户名'},
          {name:'persign',text:'个性签名'},
          {name:'uimage',text:'头像'},
          {name:'mail',text:'邮箱'},
          {name:'phone',text:'电话'},
          {name:'address',text:'地址'},
          {name:'birthday',text:'出生日期'},
          {name:'sex',text:'性别'},
          {name:'introduction',text:'简介'},
          {name:'schoolname',text:'学校'},
          {name:'major',text:'专业'},
          {name:'edutime',text:'入学时间'},
          {name:'edulevel',text:'学历'},
          {name:'companyname',text:'公司'},
          {name:'positionname',text:'职位'},
          {name:'industry',text:'行业'},
          {name:'interests',text:[
            '兴趣1',
            '兴趣2',
            '兴趣3',
            '兴趣4',
            '兴趣5',
          ]}
        ]
      )
      const isediting = ref(
        {
          uname: false,
          persign: false,
          uimage: false,
          mail: false,
          phone: false,
          address: false,
          birthday: false,
          sex: false,
          introduction: false,
          schoolname: false,
          major: false,
          edutime: false,
          edulevel: false,
          companyname: false,
          positionname: false,
          industry: false,
          interests: false,
        }
      )
      const editing= ref(null);
      const inputvalue= ref(null);
      const uploadbut=ref(null);
      const selfinterst=ref('');

      const isshowimage=ref(false);
      const headers = new Headers();
      headers.append('Authorization', 'Bearer ' + sessionStorage.getItem('token'));
      const showuimage=()=>{
        console.log('showuimage');
        isshowimage.value=!isshowimage.value;
      }

      //对话框
      const dialogtitle = ref('');
      const dialogtext = ref('');
      const dialogneedcancelbut = ref(false);
      const dialogsurebuttext = ref('');
      const dialogcancelbuttext = ref('');
      const dialogvisible = ref(false);
      const maindeskreadonly = ref(false);
      const showdialog = (title, text, needcancelbut, surebuttext, cancelbuttext) => {
        dialogtitle.value = title;
        dialogtext.value = text;
        dialogneedcancelbut.value = needcancelbut;
        dialogsurebuttext.value = surebuttext;
        dialogcancelbuttext.value = cancelbuttext;
        dialogvisible.value = true;
        maindeskreadonly.value = true;
      };
      const myDialogConfirm = () => {
        dialogvisible.value = false;
        maindeskreadonly.value = false;
      };
      const myDialogCancel = () => {
        dialogvisible.value = false;
        maindeskreadonly.value = false;
      };
      //对话框结束

      //编辑邮箱对话框
      const editmaildialogvisible = ref(false);
      const showmaildialog = () => {
        editmaildialogvisible.value = true;
        maindeskreadonly.value = true;
      };
      const maildialogok=(newmail) => {
        editmaildialogvisible.value = false;
        editbaleData.value['mail']=newmail;
        perinfo.value['mail']=newmail;
        showdialog('修改成功','',false,'确定','');
      }
      const maildialogcancel = () => {
        editmaildialogvisible.value = false;
        maindeskreadonly.value = false;
      };
      //编辑邮箱对话框结束
      const addselfinterest=()=>{
        if(selfinterst.value==''){
          showdialog('提示','输入不能为空',false,'确定','');
          return;
        }
        //如果有逗号，返回
        if(selfinterst.value.indexOf(',')!=-1){
          showdialog('提示','输入不能包含逗号',false,'确定','');
          return;
        }
        editbaleData.value['interests']=editbaleData.value['interests'].concat(selfinterst.value);
        selfinterst.value='';
      }

      const fetchPerinfo = async () => {
        const response = await fetch(`${path}/api/perinfo?uid=${uid.value}&requesteruid=${uid.value}`, {
          method: 'GET',
          headers: headers,
        }
        );
        perinfo.value = await response.json();
        console.log(perinfo.value);
        document.title = '编辑个人信息-云枢论坛';
        editbaleData.value.forEach((item) => {
          if (perinfo.value[item.name] == null||perinfo.value[item.name]=='') {
            editbaleData.value[item.name] = '未设置';
            if(item.name=='interests'){
              editbaleData.value[item.name]=[];
            }
          }
          else{
            const value=perinfo.value[item.name];
            editbaleData.value[item.name] = value;
          }
        });
      };

      const edit = (name) => {
        isediting.value[name] = !isediting.value[name];
        if(editbaleData.value[name]=='未设置'){
          editbaleData.value[name]='';
        }
      };

      const canceledit = (name) => {
        selfinterst.value='';
        isediting.value[name] = false;
        editbaleData.value[name] = perinfo.value[name];
        if(editbaleData.value[name]==null||perinfo.value[name]==''){
          editbaleData.value[name]='未设置';
          if(name=='interests'){
            editbaleData.value[name]=[];
          }
        }
      };

      const send = async(name,value)=>{
        let thevalue = editbaleData.value[name];
        let tempvalue=thevalue;
        if(name=='interests'&&thevalue.length>5){
          showdialog('提示','最多选择5个兴趣标签',false,'确定','');
          return;
        }
        if(value!=null){
          thevalue=value;
        }
        if(thevalue==perinfo.value[name]){
          isediting.value[name]=false;
          return;
        }
        if(thevalue==null){
          showdialog('提示','输入不能为空',false,'确定','');
          return;
        }
        if(name=='interests'){
          let str="";
          thevalue.forEach((item)=>{
            str+=item;
            str+=",";
          });
          str=str.substring(0,str.length-1);
          thevalue=str;
        }
        let body={
          uid:uid.value,
          type:name,
          value:thevalue
        }
        if (name == 'interests') {
          thevalue = tempvalue;
        }
        console.log(body.value);
        const response =await fetch(`${path}/api/perinfo/edit`, {
          method: 'POST',
          body: JSON.stringify(body),
          headers: headers,
        });
        const data =await response.json();
        if(data.isok){
          perinfo.value[name]=thevalue;
          showdialog('修改成功','',false,'确定','');
          if(name=='uimage'){
            sessionStorage.setItem('uimage',thevalue);
          }
          else if(name=='uname'){
            sessionStorage.setItem('uname',thevalue);
          }
        }
        else{
          editbaleData.value[name]=perinfo.value[name];
          if(editbaleData.value[name]==null||perinfo.value[name]==''){
            editbaleData.value[name]='未设置';
            if(name=='interests'){
              editbaleData.value[name]=[];
            }
          }
          showdialog('修改失败',data.failreason,false,'确定','');
        }
        isediting.value[name]=false;
      }
      
      const uploadImage= (event)=>{
        const files = Array.from(event.target.files);
        const reader = new FileReader();
        reader.onloadend = async() => {
          send('uimage',reader.result);
        };
        reader.readAsDataURL(files[0]);
      }

      const upbutclick=()=>{
        uploadbut.value.click();
      }

      const toperinfo = () => {
        // 跳转到个人信息页面
        window.location.href = '/perinfo/'+uid.value;
      };

      onMounted(() => {
        fetchPerinfo();
      });
  
      return {
        uid,
        perinfo,
        edit,
        send,
        editing,
        inputvalue,
        uploadbut,
        upbutclick,
        uploadImage,
        editbaleData,
        isediting,
        canceledit,
        toperinfo,
        isshowimage,
        showuimage,
        addselfinterest,
        selfinterst,

        //对话框
        dialogtitle,
        dialogtext,
        dialogneedcancelbut,
        dialogsurebuttext,
        dialogcancelbuttext,
        dialogvisible,
        myDialogConfirm,
        myDialogCancel,
        maindeskreadonly,
        showdialog,

        //编辑邮箱对话框
        editmaildialogvisible,
        showmaildialog,
        maildialogok,
        maildialogcancel,
        
      };
    },
  };
</script>

<style>
.disabled {
  pointer-events: none; /* 禁止点击 */
  opacity: 0.5; /* 不可用状态的视觉效果 */
}
.maindiv{
  display: flex;
  align-items: center;
  height: auto;
}
.labeltext{
  font-size: 14pt;
}
.context{
  font-size: 14pt !important;
  /* 颜色深度为0.6 */
  color: rgba(0, 0, 0, 0.6) ;
}
.el-divider{
  margin: 1px !important;
}
</style>