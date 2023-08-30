#!/bin/bash
# (C) Copyright 2021-2022
# ==================================================================
# Name : VPN Script Quick Installation Script
# Base : ****
# Mod By : ****
# ==================================================================

# // Export Color & Information
export RED='\033[0;31m';
export GREEN='\033[0;32m';
export BLUE='\033[0;34m';
export LIGHT='\033[0;37m';
export CYAN='\033[0;36m';
export NC='\033[0m';
export PURPLE='\033[0;35m';
export BG1='\e[36;5;44m' 
export BG='\e[30;5;47m'

# // Export Banner Status Information
export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${CYAN} INFO ${NC}]";
export PS1="${BG1} INFO ${NC}";
export OKEY="[${GREEN} OKEY ${NC}]";

# // Lag
export LANG="en_US.UTF-8";
export LANGUAGE="en_US.UTF-8"

clear
echo -e "
  ${LIGHT}---------------------------------------------------${NC}
        ${PS1} CHECKING MEDIA STREAM UNLOCKER
         Time = $(date)

         ${LIGHT}
  ---------------------------------------------------${LIGHT}";

function InstallJQ() {
    if [ -e "/etc/redhat-release" ];then
        echo -e "${GREEN}Installing dependencies: epel-release${NC}";
        yum install epel-release -y -q > /dev/null;
        echo -e "${GREEN}Installing dependencies: jq${NC}";
        yum install jq -y -q > /dev/null;
    elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
        echo -e "${GREEN}Updating package list...${NC}";
        apt-get update -y > /dev/null;
        echo -e "${GREEN}Installing dependencies: jq${NC}";
        apt-get install jq -y > /dev/null;
    else
        echo -e "${RED}Please install jq manually${NC}";
        exit;
    fi
}

function InstallCurl() {
    if [ -e "/etc/redhat-release" ];then
        echo -e "${GREEN}Installing dependencies: curl${NC}";
        yum install curl -y > /dev/null;
    elif [[ $(cat /etc/os-release | grep '^ID=') =~ ubuntu ]] || [[ $(cat /etc/os-release | grep '^ID=') =~ debian ]];then
        echo -e "${GREEN}Updating package list...${NC}";
        apt-get update -y > /dev/null;
        echo -e "${GREEN}Installing dependencies: curl${NC}";
        apt-get install curl -y > /dev/null;
    else
        echo -e "${RED}请手动安装curl${NC}";
        exit;
    fi
}

function PharseJSON() {
    # 使用方法: PharseJSON "要解析的原JSON文本" "要解析的键值"
    # Example: PharseJSON ""Value":"123456"" "Value" [返回结果: 123456]
    echo -n $1 | jq -r .$2;
}

function GameTest_Steam(){
    echo -n -e " Steam\t\t\t\t\t->\c";
    local result=$(curl --user-agent "${UA_Browser}" -${1} -fsSL --max-time 10 https://store.steampowered.com/app/761830 2>&1 | grep priceCurrency | cut -d '"' -f4);
    
    if [ ! -n "$result" ]; then
        echo -n -e "\r Steam\t\t\t\t\t= ${RED}Failed (Network Connection)${NC}\n";
    else
        echo -n -e "\r Steam\t\t\t\t\t= ${GREEN}Yes(Currency: ${result})${NC}\n";
    fi
}

function MediaUnlockTest_Netflix() {
    echo -n -e " Netflix\t\t\t\t->\c";
    local result1=$(curl $useNIC $xForward -${1} --user-agent "${UA_Browser}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81403959" 2>&1)
    if [[ "$result1" == "404" ]]; then
        echo -n -e "\r Netflix\t\t\t\t= ${Font_Yellow}Originals Only${NC}\n"
        return
    elif [[ "$result1" == "403" ]]; then
        echo -n -e "\r Netflix\t\t\t\t= ${RED}No${NC}\n"
        return
    elif [[ "$result1" == "200" ]]; then
        local region=$(curl $useNIC $xForward -${1} --user-agent "${UA_Browser}" -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1 | tr [:lower:] [:upper:])
        if [[ ! -n "$region" ]]; then
            region="US"
        fi
        echo -n -e "\r Netflix\t\t\t\t= ${GREEN}Yes(Region: ${region})${NC}\n"
        return
    elif [[ "$result1" == "000" ]]; then
        echo -n -e "\r Netflix\t\t\t\t= ${RED}Failed (Network Connection)${NC}\n"
        return
    fi
}

function MediaUnlockTest_HotStar() {
    echo -n -e " HotStar\t\t\t\t->\c"
    local result=$(curl $useNIC $xForward --user-agent "${UA_Browser}" -${1} ${ssll} -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://api.hotstar.com/o/v1/page/1557?offset=0&size=20&tao=0&tas=20")
    if [ "$result" = "000" ]; then
        echo -n -e "\r HotStar\t\t\t\t= ${RED}Failed (Network Connection)${NC}\n"
        return
    elif [ "$result" = "401" ]; then
        local region=$(curl $useNIC $xForward --user-agent "${UA_Browser}" -${1} ${ssll} -sI "https://www.hotstar.com" | grep 'geo=' | sed 's/.*geo=//' | cut -f1 -d",")
        local site_region=$(curl $useNIC $xForward -${1} ${ssll} -s -o /dev/null -L --max-time 10 -w '%{url_effective}\n' "https://www.hotstar.com" | sed 's@.*com/@@' | tr [:lower:] [:upper:])
        if [ -n "$region" ] && [ "$region" = "$site_region" ]; then
            echo -n -e "\r HotStar\t\t\t\t= ${GREEN}Yes(Region: $region)${NC}\n"
            return
        else
            echo -n -e "\r HotStar\t\t\t\t= ${RED}No${NC}\n"
            return
        fi
    elif [ "$result" = "475" ]; then
        echo -n -e "\r HotStar\t\t\t\t= ${RED}No${NC}\n"
        return
    else
        echo -n -e "\r HotStar\t\t\t\t= ${RED}Failed${NC}\n"
    fi

}

function MediaUnlockTest_iQiyi(){
    echo -n -e " iQiyi Global\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s -I "https://www.iq.com/" 2>&1);
    if [[ "$tmpresult" == "curl"* ]];then
        	echo -n -e "\r iQiyi Global\t\t\t\t= ${RED}Failed (Network Connection)${NC}\n"
        	return;
    fi
    
    local result=$(echo "${tmpresult}" | grep 'mod=' | awk '{print $2}' | cut -f2 -d'=' | cut -f1 -d';');
    if [ -n "$result" ]; then
		if [[ "$result" == "ntw" ]]; then
			echo -n -e "\r iQiyi Global\t\t\t\t= ${GREEN}Yes(Region: TW)${NC}\n"
			return;
		else
			result=$(echo ${result} | tr 'a-z' 'A-Z') 
			echo -n -e "\r iQiyi Global\t\t\t\t= ${GREEN}Yes(Region: ${result})${NC}\n"
			return;
		fi	
    else
		echo -n -e "\r iQiyi Global\t\t\t\t= ${RED}Failed${NC}\n"
		return;
	fi	
}

function MediaUnlockTest_Viu_com() {
    echo -n -e " Viu.com\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s -o /dev/null -L --max-time 30 -w '%{url_effective}\n' "https://www.viu.com/" 2>&1);
	if [[ "${tmpresult}" == "curl"* ]];then
        echo -n -e "\r Viu.com\t\t\t\t= ${RED}Failed (Network Connection)${NC}\n"
        return;
    fi
	
	local result=$(echo ${tmpresult} | cut -f5 -d"/")
	if [ -n "${result}" ]; then
		if [[ "${result}" == "no-service" ]]; then
			echo -n -e "\r Viu.com\t\t\t\t= ${RED}No${NC}\n"
			return;
		else
			result=$(echo ${result} | tr 'a-z' 'A-Z')
			echo -n -e "\r Viu.com\t\t\t\t= ${GREEN}Yes(Region: ${result})${NC}\n"
			return;
		fi
    else
		echo -n -e "\r Viu.com\t\t\t\t= ${RED}Failed${NC}\n"
		return;
	fi
}

function MediaUnlockTest_YouTube() {
    echo -n -e " YouTube\t\t\t\t->\c";
    local tmpresult=$(curl -${1} -s -H "Accept-Language: en" "https://www.youtube.com/premium")
    local region=$(curl --user-agent "${UA_Browser}" -${1} -sL "https://www.youtube.com/red" | sed 's/,/\n/g' | grep "countryCode" | cut -d '"' -f4)
	if [ -n "$region" ]; then
        sleep 0
	else
		region=US
	fi	
	
    if [[ "$tmpresult" == "curl"* ]];then
        echo -n -e "\r YouTube\t\t\t\t= ${RED}Failed (Network Connection)${NC}\n"
        return;
    fi
    
    local result=$(echo $tmpresult | grep 'Premium is not available in your country')
    if [ -n "$result" ]; then
        echo -n -e "\r YouTube\t\t\t\t= ${RED}No Premium${NC}(Region: ${region})${NC} \n"
        return;
		
    fi
    local result=$(echo $tmpresult | grep 'YouTube and YouTube Music ad-free')
    if [ -n "$result" ]; then
        echo -n -e "\r YouTube\t\t\t\t= ${GREEN}Yes(Region: ${region})${NC}\n"
        return;
	else
		echo -n -e "\r YouTube\t\t\t\t= ${RED}Failed${NC}\n"
		
    fi	
	
    
}

function IPInfo() {
    local result=$(curl -fsSL http://ip-api.com/json/ 2>&1);
	
	echo -e -n " IP\t\t\t\t\t->\c";
    local ip=$(PharseJSON "${result}" "query");
	echo -e -n "\r IP\t\t\t\t\t= ${GREEN}${ip}${NC}\n";
	
	echo -e -n " Country\t\t\t\t->\c";
	local country=$(PharseJSON "${result}" "country");
	echo -e -n "\r Country\t\t\t\t= ${GREEN}${country}${NC}\n";
	
	echo -e -n " Region\t\t\t\t\t->\c";
	local region=$(PharseJSON "${result}" "regionName");
	echo -e -n "\r Region\t\t\t\t\t= ${GREEN}${region}${NC}\n";
	
	echo -e -n " City\t\t\t\t\t->\c";
	local city=$(PharseJSON "${result}" "city");
	echo -e -n "\r City\t\t\t\t\t= ${GREEN}${city}${NC}\n";
	
	echo -e -n " ISP\t\t\t\t\t->\c";
	local isp=$(PharseJSON "${result}" "isp");
	echo -e -n "\r ISP\t\t\t\t\t= ${GREEN}${isp}${NC}\n";
}

function MediaUnlockTest() {
	IPInfo ${1};
	
    global ${1};
}

function global() {
	echo -e "\n${LIGHT}${RED}(${NC}${LIGHT}-- Global --${RED})${NC}"
	MediaUnlockTest_Netflix ${1};
	MediaUnlockTest_HotStar ${1};
	MediaUnlockTest_YouTube ${1};
	MediaUnlockTest_iQiyi ${1};
	MediaUnlockTest_Viu_com ${1};
	GameTest_Steam ${1};
}

function startcheck() {
    mode=${1}
    mode=$(echo ${mode} | tr 'A-Z' 'a-z')
    if [[ "${mode}" != "" ]]; then
        case $mode in
            'global')
                IPInfo ${2};
                global ${2};
            ;;
            *)
                MediaUnlockTest ${2};
        esac
    else
        MediaUnlockTest ${2};
    fi
}

# install curl
if ! curl -V > /dev/null 2>&1;then
    InstallCurl;
fi

# install jq
if ! jq -V > /dev/null 2>&1;then
    InstallJQ;
fi

echo -e "";
echo -e "${RED}(${LIGHT}-- IPV4 --${RED})${NC}";
check4=$(ping 1.1.1.1 -c 1 2>&1);
if [[ "$check4" != *"unreachable"* ]] && [[ "$check4" != *"Unreachable"* ]];then
    startcheck "${1}" "4";
else
    v4=""
    echo -e "${BLUE}The current host does not support IPV4, skip...${NC}";
    sleep 1
fi

echo -e "";
echo -e "${RED}(${LIGHT}-- IPV6 --${RED})${NC}";
check6=$(ping6 240c::6666 -c 1 2>&1);
if [[ "$check6" != *"unreachable"* ]] && [[ "$check6" != *"Unreachable"* ]];then
    v6="1"
else
    v6=""
    echo -e "${BLUE}The current host does not support IPV6, skip...${NC}";
    sleep 1
fi

echo -e "";
echo -e "  ${LIGHT}---------------------------------------------------${NC}"


