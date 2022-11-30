#!/bin/bash

dirName=$(dirname -- "$0")
source "$dirName/colors.sh"
# echo -e "\n${RED}start from dir: $dirName${NC}"

isInstalled() {
  target=$1
  isInstalledResult=$(dpkg-query -l $target)
  if [[ $isInstalledResult ]]; then
  # if dpkg-query -l xinit; then
    #   echo -e "$target is allready installed"
    return 0
  else
    #   echo -e "$target is not installed"
    return 1
  fi
}

installPackage() {
    packageName=$1
    if isInstalled $packageName; then
        echo -e "$packageName already installed"
    else
        echo -e "installing $packageName..."
        sudo apt install $packageName
    fi 
}

rebootRemote() {
    read -p "$(echo -e "\n${BLUE}Reboot remote \"hostName\" (y/n)?${NC} ")" answer
    case ${answer:0:1} in
        y|Y )
            echo -e "\nrebooting remote $hostName..."
            ssh -t $userName@$hostName 'su -c "systemctl reboot"'
            sleep 5s
            while ! ping -c 1 $hostName &>/dev/null; do :; done
            echo -e "\treboot remote $hostName done."
        ;;
        * )
            echo -e "\treboot canceled."
        ;;
    esac
}


############ INSTALLING DEPENDENCIES ON LOCAL ############
# installPackage sshpass

############ INSTALLETION SETTINGS ############
userName=scada
hostName=192.168.120.171
proxy_set="http://constr:constr@192.168.120.234:3128"


installSudo=false
installLxde=false
installAutologin=true
installPackages=true
    readonly instPackages=(
        "lxde-core apt"
            # build-essential_12.9_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/b/build-essential/build-essential_12.9_amd64.deb
        "build-essential apt"
            # zlib1g-dev_1.2.13.dfsg-1_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/z/zlib/zlib1g-dev_1.2.13.dfsg-1_amd64.deb
        "zlib1g-dev apt"
            # libncurses5-dev_6.0+20161126-1+deb9u2_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/n/ncurses/libncurses5-dev_6.0+20161126-1+deb9u2_amd64.deb
        "libncurses5-dev apt"
            # libgdbm-dev_1.23-3_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/g/gdbm/libgdbm-dev_1.23-3_amd64.deb
        "libgdbm-dev apt"
            # libnss3-dev_3.85-1_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/n/nss/libnss3-dev_3.85-1_amd64.deb
        "libnss3-dev apt"
        # "python3.10
        #     src
        #     https://www.python.org/ftp/python/3.10.8/Python-3.10.8.tgz
        #     Python-3.10.8.tgz | Python-3.10.8
        # "
        "python3-pip apt"
        "libaio1 apt" # mysql-server
        "mysql-server
            apt
            http://ftp.ru.debian.org/debian/pool/main/m/mysql-8.0/mysql-server-8.0_8.0.31-1+b1_amd64.deb
            mysql-server-8.0_8.0.31-1+b1_amd64.deb
        "
        "mysql-connector-python
            pip
            https://files.pythonhosted.org/packages/cd/a7/42f58c5f8bd6a52a0faabc92b04928ec4014eba5986ca11c02bb26abd1f5/mysql-connector-python-8.0.31.tar.gz
            mysql-connector-python-8.0.31.tar.gz
        "
        "numpy
            pip
            https://files.pythonhosted.org/packages/42/38/775b43da55fa7473015eddc9a819571517d9a271a9f8134f68fb9be2f212/numpy-1.23.5.tar.gz
            numpy-1.23.5.tar.gz
        "
        "python-snap7
            pip
            https://files.pythonhosted.org/packages/d7/42/06793d68ddf1c07c975cd8b84d8240c854b718ca05b1976a2fb8588ee770/python-snap7-1.2.tar.gz
            python-snap7-1.2.tar.gz
        "
    )
installCma=false
    cmaAppDir='/home/scada/app/cma/'
    cmaAppName='crane_monitoring_app'
    cmaGitOwner='a-givertzman'
    cmaGitRepo='crane_monitoring_app'
    cmaGitTag='internal_v0.0.33'
    cmaGitAsset='release.zip'
    # cmaGitToken='GHSAT0AAAAAAB3FNKE3CXTIR7VOFHUAF2NCY37MDRQ'
    cmaGitToken='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'
# installApiServer=false
installDataServer=false
    dsAppDir='/home/scada/app/data_server/'
    dsAppName='sds_run.py'
    dsGitOwner='a-givertzman'
    dsGitRepo='s7-data-server'
    dsGitBranch='Fault-Registrator'
    dsGitAsset='ds_release.zip'
    # cmaGitToken='GHSAT0AAAAAAB3FNKE3CXTIR7VOFHUAF2NCY37MDRQ'
    dsGitToken='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'
installServices=false

# exit 0

# read -p "Enter $userName@$hostName password: " sshPassword
# read -p "Enter root@$hostName password: " rPassword


############ INSTALLING SSH KEY ON REMOTE ############
    ssh-copy-id -i ~/.ssh/id_rsa.pub $userName@$hostName
    # ssh -t $userName@$hostName "mkdir -p ~/.ssh && /tmp/$sName'"
    # scp ~/.ssh/id_rsa.pub $userName@$hostName:/tmp/

############ INSTALL SUDO ############
if $installSudo; then
    sName=install_sudo.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing sudo on remote $hostName...${NC}"
    scp $path $userName@$hostName:/tmp/
    ssh -t $userName@$hostName "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
fi

############ INSTALL LXDE ############
if $installLxde; then
    sName=install_lxde.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing LXDE on remote $hostName...${NC}"
    scp $path $userName@$hostName:/tmp/
    ssh -t $userName@$hostName "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
    rebootRemote
fi

############ INSTALL LXDE AUTO LOGIN ############
if $installAutologin || $installLxde; then
    sName=install_autologin.sh
    path=$(dirname -- "$0")/$sName 
    echo -e "\n${BLUE}Installing LXDE autologin on remote $hostName...${NC}"
    scp $path $userName@$hostName:/tmp/
    ssh -t $userName@$hostName "su -c 'chmod +x /tmp/$sName && /tmp/$sName'"
    rebootRemote
fi

############ INSTALL PYTHON3.10 ############
if $installPackages; then
    sName=install_python310.sh
    path=$(dirname -- "$0")/$sName
    echo -e "\n${BLUE}Installing python3.10 on remote $hostName...${NC}"
    files=""
    packages=""
    for package in "${instPackages[@]}"; do 
        # local name file url
        package=$(echo $package | sed 's/\s|*\s*/ /g')
        read -r name type url file extracted <<< $package
        tmpPath=$(dirname -- "$0")/distro/$file
        packages="$packages '$name|$type|$url|$file|$extracted'"
        if ! [ -z "${file}" ]; then
            files="$files $tmpPath"
            if ! [ -z "${url}" ]; then
                echo -e "\tchecking local repositiry "$tmpPath""
                if [ -f "$tmpPath" ]; then
                    echo "$tmpPath exists."
                else
                    if ! [ -z "${proxy_set}" ]; then
                        curl $CURL_ARGS \
                            --create-dirs \
                            --progress-bar \
                            --proxy $proxy_set \
                            -o $tmpPath \
                            $url
                    else
                        curl $CURL_ARGS \
                            --create-dirs \
                            --progress-bar \
                            -o $tmpPath \
                            $url
                    fi
                fi
            fi
        fi
    done
    echo -e "coping files..."
    # echo -e "$files"
    scp $path$files $userName@$hostName:/tmp/
    echo -e "instaling applications..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName$packages"
fi

############ INSTALL DATA SERVER ############
if $installDataServer; then
    sName=install_data_server.sh
    path=$(dirname -- "$0")/$sName
    tmpPath=$(dirname -- "$0")/distro/$dsGitAsset
    echo -e "\n${BLUE}Installing DATA SERVER on remote $hostName...${NC}"
    echo -e "\tchecking local repositiry "$tmpPath""
    if [ -f "$tmpPath" ]; then
        echo "$tmpPath exists."
    else
        $(dirname -- "$0")/download_src.sh $dsGitOwner $dsGitRepo $dsGitBranch $tmpPath
    fi
    echo -e "coping files..."
    scp $path $tmpPath $userName@$hostName:/tmp/
    echo -e "instaling application..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName /tmp/$dsGitAsset $dsAppDir $dsAppName"
fi

############ INSTALL CMA ############
if $installCma; then
    sName=install_cma.sh
    path=$(dirname -- "$0")/$sName
    tmpPath=$(dirname -- "$0")/distro/$cmaGitAsset
    echo -e "\n${BLUE}Installing CMA on remote $hostName...${NC}"
    echo -e "\tchecking local repositiry "$tmpPath""
    if [ -f "$tmpPath" ]; then
        echo "$tmpPath exists."
    else
        $(dirname -- "$0")/download.sh $cmaGitOwner $cmaGitRepo $cmaGitTag $cmaGitAsset $tmpPath
    fi
    echo -e "coping files..."
    scp $path $tmpPath $userName@$hostName:/tmp/
    echo -e "instaling application..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName /tmp/$cmaGitAsset $cmaAppDir $cmaAppName"
fi

############ INSTALL SERVICES ############
if $installServices; then
    sName=install_services.sh
    path=$(dirname -- "$0")/$sName
    path1=$(dirname -- "$0")/services/api_server.service 
    path2=$(dirname -- "$0")/services/data_server.service
    path3=$(dirname -- "$0")/services/scada_app.service
    path4=$(dirname -- "$0")/services/configure_ui.service
    path5=$(dirname -- "$0")/configure_ui.sh
    echo -e "\n${BLUE}Installing services on remote $hostName...${NC}"
    echo -e "coping files..."
    scp $path $path1 $path2 $path3 $path4 $path5 $userName@$hostName:/tmp/
    echo -e "instaling services..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && su -c'/tmp/$sName'"
    rebootRemote
fi





############ USED FOR TESTING ONLY ############


# proxy_set="http://constr:constr@192.168.120.234:3128"
# GITHUB_API_TOKEN=$dsGitToken
# CURL_ARGS="-LJ"

# owner=$dsGitOwner
# repo=$dsGitRepo
# tag=$dsGitTag
# GH_API="https://api.github.com"
# GH_REPO="$GH_API/repos/$owner/$repo"
# GH_TAGS="$GH_REPO/releases/tags/$tag"
# GH_ASSET="$GH_REPO/releases/assets/"
# GH_ASSET="$GH_REPO/releases/tags/$tag"

# target=$dirName/distro/ds_src.zip

# echo "url: $GH_ASSET"
# echo "target: $target"

# curl $CURL_ARGS \
#     --progress-bar \
#     --proxy $proxy_set \
#     -H "Authorization: Bearer $GITHUB_API_TOKEN" \
#     -H 'Accept: application/json' \
#     "$GH_ASSET" > $target
# curl $CURL_ARGS \
#     --progress-bar \
#     --proxy $proxy_set \
#     -H "Authorization: Bearer $GITHUB_API_TOKEN" \
#     -H 'Accept: application/vnd.github+json' \
#     "https://api.github.com/repos/a-givertzman/s7-data-server/zipball/Fault-Registrator" > $target


#     # -H 'Accept: application/octet-stream' \
#     # -H 'Accept: application/json' \
