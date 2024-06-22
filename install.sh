#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
webPort=18080
errorMsg=����Ⱥt.me/Scoks55555
version=v3.0
downLoadUrl=https://github.com/wyx176/nps-socks5/releases/download/
serverSoft=linux_amd64_server
clientSoft=linux_amd64_client
serverUrl=${downLoadUrl}${version}/${serverSoft}.tar.gz
clientUrl=${downLoadUrl}${version}/${clientSoft}.tar.gz
s5Path=/opt/nps-socks5/
ipAdd=���ʧ��

if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ];then
    OS=CentOS
    [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
    [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
    [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ];then
    OS=CentOS
    CentOS_RHEL_version=6
elif [ -n "$(grep bian /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Debian' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Deepin /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Deepin' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Ubuntu /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Ubuntu' -o -n "$(grep 'Linux Mint' /etc/issue)" ];then
    OS=Ubuntu
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Ubuntu_version=$(lsb_release -sr | awk -F. '{print $1}')
    [ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_version=16
else
    echo "Does not support this OS, Please contact the author! "
    kill -9 $$
fi

#Install Basic Tools
init(){
if [[ ${OS} == Ubuntu ]];then
	apt-get  install git unzip wget -y
	apt-get  install curl
fi
if [[ ${OS} == CentOS ]];then
	yum install git unzip wget -y
  yum -y install curl
fi
if [[ ${OS} == Debian ]];then
	apt-get install git unzip wget -y
	apt-get install curl
fi
}

unstallServer(){
	if [[ -d ${s5Path}${serverSoft} ]];then
      cd ${s5Path}${serverSoft} && nps stop && nps uninstall
      rm -rf /etc/nps
      rm -rf /usr/bin/nps
      rm -rf ${s5Path}${serverSoft}
	fi
	 echo "ж�ط���˳ɹ�"
}

unstallClient(){
  if [[ -d ${s5Path}${clientSoft} ]];then
  	  cd ${s5Path}${clientSoft} && npc stop &&  ./npc uninstall
    	rm -rf ${s5Path}${clientSoft}
    	rm -rf ${s5Path}${clientSoft}.tar.gz
  fi
  echo "ж�ؿͻ��˳ɹ�"
}

allUninstall(){
  unstallServer
  unstallClient
  #ɾ��֮ǰ��
  if [[ -d ${s5Path} ]];then
	  rm -rf ${s5Path}
	fi
}

checkIp(){

ipAdd=`curl -4 http://ifconfig.info`
clear
echo "��ǰip��ַ��"${ipAdd}


#2.���ط����
DownloadServer()
{
echo "����nps-socks5�����������ĵȴ�..."
if [[ ! -d ${s5Path} ]];then
	mkdir -p ${s5Path}	
fi

#�����
wget -P ${s5Path} --no-cookie --no-check-certificate ${serverUrl} 2>&1 | progressfilt


if [[ ! -f ${s5Path}${serverSoft}.tar.gz ]]; then
	echo "������ļ�����ʧ��"${errorMsg}
	exit 0
fi

}

DownloadClient()
{
echo "����nps-socks5�ͻ����������ĵȴ�..."
if [[ ! -d ${s5Path} ]];then
	mkdir -p ${s5Path}	
fi


#�ͻ���
wget -P ${s5Path} --no-cookie --no-check-certificate ${clientUrl} 2>&1 | progressfilt


if [[ ! -f ${s5Path}${clientSoft}.tar.gz ]]; then
	echo "�ͻ����ļ�����ʧ��"${errorMsg}
	exit 0
fi
}

#3.��װSocks5����˳���
InstallServer()
{
echo ""
echo "������ļ���ѹ��..."

tar zxvf ${s5Path}${serverSoft}.tar.gz -C ${s5Path}

cd ${s5Path}${serverSoft}
sudo  ./nps install && nps start
}

InstallClient()
{

echo ""
echo "�ͻ����ļ���ѹ��..."
if [[ ! -d ${s5Path}${clientSoft} ]]; then
echo "-------------"${s5Path}${clientSoft}
mkdir -p ${s5Path}${clientSoft}
fi
tar zxvf ${s5Path}${clientSoft}.tar.gz -C ${s5Path}${clientSoft}

clear
echo "�ͻ����ļ���װ��..."
cd ${s5Path}${clientSoft}
if [[ $menuChoice == 1 ]];then
./npc install  -server=${ipAdd}:8025 -vkey=ij7poeu2d9btjbd3 -type=tcp && npc start
else
echo "������������[�����]->�����б�+����"
echo "���ƣ�./npc -server=xxx.xxx.xxx.172:8025 -vkey=ij7poeu2d9btjbd3 -type=tcp"
echo "ֻ��Ҫ����:-server=xxx.xxx.xxx.172:8025 -vkey=ij7poeu2d9btjbd3 -type=tcp ����"
read -p "���������˲����� " serverParam
./npc install ${serverParam} && npc start
fi
}



checkServer(){
#��������Ƿ�װ�ɹ�
SPID=`ps -ef|grep nps |grep -v grep|awk '{print $2}'`
if [[ -z ${SPID} ]]; then
echo ${SPID}"SPID----------------------"
echo "����˰�װʧ��"${errorMsg}
unstallServer
exit 0
fi
}


checkClient(){

CPID=`ps -ef|grep npc |grep -v grep|awk '{print $2}'`
if [[ -z ${CPID} ]]; then
echo "�ͻ��˰�װʧ��"${errorMsg}
unstallClient
exit 0
fi
}



function check_ip(){
        IP=$1
        VALID_CHECK=$(echo $IP|awk -F. '$1<=255 && $2<=255 && $3<=255 && $4<=255 {print "yes"}')
        
        if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$">/dev/null; then
                if [[ $VALID_CHECK == "yes" ]]; then
                        return=$IP
                else
                        echo "��װʧ�ܣ�ip����ȷ"
						exit 0
                fi
        else
               echo "��װʧ�ܣ���ip"
			   exit 0
        fi
}

progressfilt ()
{
    local flag=false c count cr=$'\r' nl=$'\n'
    while IFS='' read -d '' -rn 1 c
    do
        if $flag
        then
            printf '%s' "$c"
        else
            if [[ $c != $cr && $c != $nl ]]
            then
                count=0
            else
                ((count++))
                if ((count > 1))
                then
                    flag=true
                fi
            fi
        fi
    done
}


menu(){
$menuChoice = 0

	#��װ�����
	init
	checkIp
	
	allUninstall
	DownloadServer
	DownloadClient
	InstallServer
	InstallClient
	checkServer
	checkClient
	clear
	echo "--��װ�ɹ�------"${errorMsg}
	echo "--��̨�����ַ"${ipAdd}":"${webPort}
	echo "--��¼�˺�admin"
	echo "--��¼����admin"
	echo "Ĭ��socks5�˺���Ϣ:�˺�socks5 ����socks5 �˿�5555"
	echo "�����޸ĺ�̨����˿��Լ��˺������뿴github"
}
menu
