#!/usr/bin/env bash
apt update
echo -e
apt install vim curl git wget zip -y
apt install python3 python3-pip git -y
wget https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_amd64.tar.gz && tar -xf caddy_v1.0.4_linux_amd64.tar.gz
echo -e
mv caddy /usr/bin/
echo -e
mkdir -p /usr/local/caddy/www/ && cd /usr/local/caddy/www/
echo -e
wget https://www.free-css.com/assets/files/free-css-templates/download/page260/wavefire.zip
echo -e
unzip wavefire.zip
echo -e
mv wavefire/* .
echo -e
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
caddy
nohup caddy &
send "\03" 
cd
echo -e
git clone https://github.com/liujang/foc-.git
echo -e
cd foc-
pip3 install -r requirements.txt
sleep 5
cp apiconfig.py userapiconfig.py && cp config.json user-config.json
echo -e
 read -p "请输入网站mukey:" key
 echo "网站mukey为：${key}"
 sleep 1
 sed -i '17s/123/'${key}'/' userapiconfig.py
 read -p "请输入节点序号:" node
 echo "节点序号为：${node}"
 sleep 1
 sed -i '2s/0/'${node}'/' userapiconfig.py
  cd
  cd foc- && chmod +x run.sh && ./run.sh
echo "已经对接完成！！！ Fly Over Cloud。。。。。。"
echo "本脚本为foc的一键对接脚本，只适用于foc机场，系统环境必须为debian9"
