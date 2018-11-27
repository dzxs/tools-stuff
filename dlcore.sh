#!/usr/bin/env bash
RED="31m"
GREEN="32m"
BLUE="36m"
V2RAYX=''

CUR_VER=""
NEW_VER=""
ZIPFILE="v2ray.zip"
VERSION=""
OS=`uname -s`

checkOS(){
    if [[ $OS == "Darwin" ]];then
        V2RAYX="./v2ray-macos"
        ZIPFILE="v2ray-macos.zip"
        colorEcho ${BLUE} "${OS} ${V2RAYX} ${ZIPFILE}"
        return 0
    elif [[ $OS == "Linux" ]];then
        V2RAYX="./v2ray-linux-64"
        ZIPFILE="v2ray-linux-64.zip"
        colorEcho ${BLUE} "${OS} ${V2RAYX} ${ZIPFILE}"
        return 0
    else
        return 1
    fi
}

colorEcho(){
    COLOR=$1
    echo -e "\033[${COLOR}${@:2}\033[0m"
}

getVersion(){
    if [[ -n "$VERSION" ]]; then
        NEW_VER="$VERSION"
        return 4
    else
        VER=`${V2RAYX}/v2ray -version 2>/dev/null`
        RETVAL="$?"
        CUR_VER=v`echo $VER | head -n 1 | cut -d " " -f2`
        TAG_URL="https://api.github.com/repos/v2ray/v2ray-core/releases/latest"
        NEW_VER=`curl -s ${TAG_URL} --connect-timeout 10| grep 'tag_name' | cut -d\" -f4`
        if [[ $? -ne 0 ]] || [[ $NEW_VER == "" ]]; then
            colorEcho ${RED} "Failed to fetch release info. Please check your network or try again."
            return 3
        elif [[ $RETVAL -ne 0 ]];then
            return 2
        elif [[ "$NEW_VER" != "$CUR_VER" ]];then
            return 1
        fi
        return 0
    fi
}

downloadV2Ray(){
    rm -f $ZIPFILE
    colorEcho ${BLUE} "Downloading V2Ray."
    DOWNLOAD_LINK="https://github.com/v2ray/v2ray-core/releases/download/${NEW_VER}/${ZIPFILE}"
    colorEcho ${GREEN} "${DOWNLOAD_LINK}"
    curl -L -H "Cache-Control: no-cache" -o ${ZIPFILE} ${DOWNLOAD_LINK}
    if [ $? != 0 ];then
        colorEcho ${RED} "Failed to download! Please check your network or try again."
        return 3
    fi
    return 0
}

extract(){
    colorEcho ${BLUE} "Extracting V2Ray package to ${V2RAYX}."
    mkdir -p $V2RAYX
    unzip -o $1 -d $V2RAYX
    if [[ $? -ne 0 ]];then
        colorEcho ${RED} "Failed to extract V2Ray."
        return 2
    fi
    return 0
}

makeExecutable() {
    chmod +x "${V2RAYX}/$1"
}

main(){
    checkOS
    RETVAL="$?"
    if [[ $RETVAL -ne 0 ]];then
        colorEcho ${RED} "Unknown OS: ${OS}"
        return 1
    fi
    getVersion
    RETVAL="$?"
    if [[ $RETVAL == 0 ]];then
        colorEcho ${GREEN} "${NEW_VER} is already installed."
        return
    elif [[ $RETVAL == 3 ]];then
        return 3
    else
        colorEcho ${GREEN} "Updateing V2Ray ${NEW_VER}"
        downloadV2Ray || return $?
        extract ${ZIPFILE} || return $?
        if [[ $? -ne 0 ]];then
            colorEcho ${RED} "Failed to copy V2Ray binary and resources."
            return 1
        fi
        makeExecutable v2ray
        makeExecutable v2ctl
        colorEcho ${GREEN} "V2ray ${NEW_VER} update successful."
    fi
    return 0
}
main
