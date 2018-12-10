#!/bin/bash
function traffic_monitor {
#系统版本
os_name=`cat /etc/redhat-release`
#网口名
eth=$1
#判断网卡是否存在，不存在退出
if [ ! -d /sys/class/net/$eth ];then
     echo -e "Network-Interface Not Found"
     echo -e "You system have network-interface:\n `ls /sys/class/net/`"
     exit
fi
while :
do
 #状态
 status="fine"
 #获取当前时刻网口接收与发送的流量
 RXpre=$(cat /proc/net/dev | grep $eth | tr : " " | awk '{print $2}')
 TXpre=$(cat /proc/net/dev | grep $eth | tr : " " | awk '{print $10}')
 #获取1s后网卡接收与发送的流量
 sleep 1
 RXnext=$(cat /proc/net/dev | grep $eth | tr : " " | awk '{print $2}')
 TXnext=$(cat /proc/net/dev | grep $eth | tr : " " | awk '{print $10}')
 clear
 #获取这1s实际的进出流量
 RX=${RXnext-RXpre}
 TX=${TXnext-RXpre}
 #判断接受流量如果大于MB数量级则显示MB单位，否则现实kb数量级
 if [ $RX -lt 1024 ];then
    RX="${RX}B/s"
 elif [[ $RX -gt 1048576 ]];then
   RX=$(echo $RX | awk '{print  $1/1048576 "MB/s" }')
   $STATUS="busy"
 else
   RX=$(echo $RX | awk '{print $1/1024 "KB/s"}')
 fi
 #TX判断
 if [ $TX -lt 1024 ];then
    TX="${TX}B/s"
 elif [[ $TX -gt 1048576 ]];then
    TX=$(echo $TX | awk '{print  $1/1048576 "MB/s"}')
    $STATUS="busy"
 else
    TX=$(echo $TX | awk '{print $1/1024 "KB/s"}')
 fi
 #打印界面
 echo -e "==================================="
 echo -e "welcome to Tracffic_Monitor stage"
 echo -e "version 1.0"
 echo -e "Since 2018.12.07"
 echo -e "Created by wake"
 echo -e "==================================="
 echo -e "System:$os_name"
 echo -e "Date:  `date +%F`"
 echo -e "Time:  `date +%H:%M:%S`"
 echo -e "Status: $status"
 echo -e " \t RX  \tTX"
 echo '----------------------------'
 #打印时实流量
 echo -e " \t $RX  \t$TX"
 echo -e "-------------------------"
 echo -e "Press 'Ctrl+C' to exit"
done
}
if [[ -n "$1" ]];then
   traffic_monitor $1
else
echo -e "None parameter,please add system netport after run the script! \nExample:'sh traffic_monitor eth0"
fi

