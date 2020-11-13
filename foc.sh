#!/bin/bash
apt update
apt install vim curl git wget zip -y
apt install python3 python3-pip git -y
toos_install(){
wget https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_amd64.tar.gz
tar -xf caddy_v1.0.4_linux_amd64.tar.gz
mv caddy /usr/bin/
mkdir -p /usr/local/caddy/www/ && cd /usr/local/caddy/www/
wget https://www.free-css.com/assets/files/free-css-templates/download/page260/wavefire.zip
unzip wavefire.zip
mv wavefire/* .
}
caddy_conf(){
  read -p "输入您的域名:" domainname
  real_addr=`ping ${domainname} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
  local_addr=`curl ipv4.icanhazip.com`
  while [ "$real_addr" != "$local_addr" ]; do
     read -p "本机ip和绑定域名的IP不一致，请检查域名是否解析成功,并重新输入域名:" domainname
     real_addr=`ping ${domainname} -c 1 | sed '1{s/[^(]*(//;s/).*//;q}'`
     local_addr=`curl ipv4.icanhazip.com`
  done
  echo "https://${domainname}:2333 {
root /usr/local/caddy/www/
timeouts none
tls duyuanchao.me@gmail.com
}" > /usr/local/caddy/Caddyfile
cd ../
nohup caddy & -y
cd
}
foc_install(){
cd
git clone https://github.com/liujang/foc-.git
cd foc- && pip3 install -r requirements.txt
cp apiconfig.py userapiconfig.py && cp config.json user-config.json
sed -i '16s/123456/https://foc.ljfxz.com/' /foc-/userapiconfig.py
sed -i '17s/123/lj/' /foc-/userapiconfig.py
}
 none_get(){
 read -p "请输入节点序号:" node
 sed -i '2s/0/${node}/' /foc-/userapiconfig.py
}
run(){
  cd
  cd foc- && chmod +x run.sh && ./run.sh
}
echo "已经对接完成！！！ Fly Over Cloud。。。。。。"
echo "本脚本为foc的一键对接脚本，只适用于foc机场，系统环境必须为debian9"
