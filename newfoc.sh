#!/usr/bin/env bash
#######color code########
RED_COLOR="\033[0;31m"
NO_COLOR="\033[0m"
GREEN="\033[32m\033[01m"
BLUE="\033[0;36m"
FUCHSIA="\033[0;35m"
echo "export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
echo "本脚是基于Jeannie的修改和添加"
sleep 3
mkdir /etc/caddy /etc/ssl/caddy /var/www
isRoot(){
  if [[ "$EUID" -ne 0 ]]; then
    echo "false"
  else
    echo "true"
  fi
}
init_release(){
  if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
  if [[ $release = "ubuntu" || $release = "debian" ]]; then
    PM='apt'
  elif [[ $release = "centos" ]]; then
    PM='yum'
  else
    exit 1
  fi
  # PM='apt'
}
tools_install(){
  caddy -service stop
  init_release
  if [ $PM = 'apt' ] ; then
    apt-get update -y
    apt-get install vim curl git wget zip unzip python3 python3-pip git -y
  elif [ $PM = 'yum' ]; then
    yum update -y
    yum install vim curl git wget zip unzip python3 python3-pip git -y
  fi
}
left_second(){
    seconds_left=30
    while [ $seconds_left -gt 0 ];do
      echo -n $seconds_left
      sleep 1
      seconds_left=$(($seconds_left - 1))
      echo -ne "\r     \r"
    done
}
caddy_install(){
  wget https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_amd64.tar.gz && tar -xf caddy_v1.0.4_linux_amd64.tar.gz && mv caddy /usr/bin/
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
  echo "https://jp8.ljfxz.com:2333 {
root /usr/local/caddy/www/
timeouts none
tls duyuanchao.me@gmail.com
}" > /etc/caddy/Caddyfile
}
web_get(){
  rm -rf /var/www
  mkdir /var/www
  echo -e "下面提供了15个不同的伪装网站模板，按对应的数字进行安装，安装之前可以查看网站demo:
  ${GREEN}1. https://templated.co/intensify
  ${GREEN}2. https://templated.co/binary
  ${GREEN}3. https://templated.co/retrospect
  ${GREEN}4. https://templated.co/spatial
  ${GREEN}5. https://templated.co/monochromed
  ${GREEN}6. https://templated.co/transit
  ${GREEN}7. https://templated.co/interphase
  ${GREEN}8. https://templated.co/ion
  ${GREEN}9. https://templated.co/solarize
  ${GREEN}10. https://templated.co/phaseshift
  ${GREEN}11. https://templated.co/horizons
  ${GREEN}12. https://templated.co/grassygrass
  ${GREEN}13. https://templated.co/breadth
  ${GREEN}14. https://templated.co/undeviating
  ${GREEN}15. https://templated.co/lorikeet${NO_COLOR}
  "
read -p "您输入你要安装的网站的数字:" aNum
case $aNum in
    1)wget -O web.zip --no-check-certificate https://templated.co/intensify/download
    ;;
    2)wget -O web.zip --no-check-certificate https://templated.co/binary/download
    ;;
    3)wget -O web.zip --no-check-certificate https://templated.co/retrospect/download
    ;;
    4)wget -O web.zip --no-check-certificate https://templated.co/spatial/download
    ;;
    5)wget -O web.zip --no-check-certificate https://templated.co/monochromed/download
    ;;
    6)wget -O web.zip --no-check-certificate https://templated.co/transit/download
    ;;
    7)wget -O web.zip --no-check-certificate https://templated.co/interphase/download
    ;;
    8)wget -O web.zip --no-check-certificate https://templated.co/ion/download
    ;;
    9)wget -O web.zip --no-check-certificate https://templated.co/solarize/download
    ;;
    10)wget -O web.zip --no-check-certificate https://templated.co/phaseshift/download
    ;;
    11)wget -O web.zip --no-check-certificate https://templated.co/horizons/download
    ;;
    12)wget -O web.zip --no-check-certificate https://templated.co/grassygrass/download
    ;;
    13)wget -O web.zip --no-check-certificate https://templated.co/breadth/download
    ;;
    14)wget -O web.zip --no-check-certificate https://templated.co/undeviating/download
    ;;
    15)wget -O web.zip --no-check-certificate https://templated.co/lorikeet/download
    ;;
    *)wget -O web.zip --no-check-certificate https://templated.co/intensify/download
    ;;
esac
    unzip -o -d /var/www web.zip
}
check_CA(){
    end_time=$(echo | openssl s_client -servername $domainname -connect $domainname:443 2>/dev/null | openssl x509 -noout -dates |grep 'After'| awk -F '=' '{print $2}'| awk -F ' +' '{print $1,$2,$4 }' )
    end_times=$(date +%s -d "$end_time")
    now_time=$(date +%s -d "$(date | awk -F ' +'  '{print $2,$3,$6}')")
    RST=$(($(($end_times-$now_time))/(60*60*24)))
}
CA_exist(){
  if [ -d "/root/.caddy/acme/acme-v02.api.letsencrypt.org/sites/$domainname" -o -d "/.caddy/acme/acme-v02.api.letsencrypt.org/sites/$domainname" ]; then
    FLAG="YES"
  else
    FLAG="NO"
  fi
}
main(){
   isRoot=$( isRoot )
  if [[ "${isRoot}" != "true" ]]; then
    echo -e "${RED_COLOR}error:${NO_COLOR}Please run this script as as root"
    exit 1
  else
  tools_install
  web_get
  caddy_install
  caddy_conf
  ssr_install
  caddy -service stop
  caddy -service uninstall
  caddy -service install -agree -email ${emailname} -conf /etc/caddy/Caddyfile
  caddy -service start
  echo -e " ${GREEN}正在下载证书，请稍等……${NO_COLOR}"
  left_second
  caddy -service start
  cd /etc/caddy/ && nohup caddy &
  send "\03"
}
main
foc_install(){
   git clone https://github.com/liujang/foc-.git
   cd foc-
   pip3 install -r requirements.txt
sleep 5
cp apiconfig.py userapiconfig.py && cp config.json user-config.json
}
node_install(){
echo -e "提供两种安装方式，请选择:
 ${GREEN}1. webapi对接
  ${GREEN}2. mysql对接
"
case $aNum in
1)read -p "请输入网站mukey:" key
 echo "网站mukey为：${key}"
 sleep 1
 sed -i '17s/123/'${key}'/' userapiconfig.py
 read -p "请输入节点序号:" node
 echo "节点序号为：${node}"
 sleep 1
 sed -i '2s/0/'${node}'/' userapiconfig.py
  cd
  cd foc- && chmod +x run.sh && ./run.sh
 ;;
2)read -p "请输入数据库地址:" ip
 echo "网站mukey为：${ip}"
 sleep 1
 sed -i '23s/127.0.0.1/'${ip}'/' userapiconfig.py
 read -p "请输入数据库用户名:" user
 echo "数据库用户名为：${user}"
 sleep 1
 sed -i '25s/ss/'${user}'/' userapiconfig.py
 read -p "请输入数据库名:" db
 echo "数据库名为：${db}"
 sleep 1
 sed -i '27s/shadowsocks/'${db}'/' userapiconfig.py
 read -p "请输入数据库密码:" passwd
 echo "数据库密码为：${passwd}"
 sleep 1
 sed -i '26s/ss/'${passwd}'/' userapiconfig.py
  cd
  cd foc- && chmod +x run.sh && ./run.sh
}