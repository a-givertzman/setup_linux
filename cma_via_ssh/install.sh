#!/bin/bash

dirName=$(dirname -- "$0")
source "$dirName/colors.sh"
source "$dirName/gh_token.sh"
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
            ssh -t $userName@$hostName "sudo systemctl reboot"
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
hostName=192.168.120.175
proxySet="http://constr:constr@192.168.120.234:3128" # "null" | "http://user:pass@ip:port

printf -vl "%${COLUMNS:-`tput cols 2>&-||echo 80`}s\n" && echo ${l// /#};
echo -e "\n${BBlue}Installing Crane Application & envirenment on the host $hostName...${NC}\n"


installSudo=false
installLxde=false
installAutologin=false
installPackages=false
    readonly instPackages=(
        "unzip apt"
        "lxde-core apt" # GUI
        "onboard apt"   # GUI
            # build-essential_12.9_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/b/build-essential/build-essential_12.9_amd64.deb
        "build-essential apt" # for python3.10
            # zlib1g-dev_1.2.13.dfsg-1_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/z/zlib/zlib1g-dev_1.2.13.dfsg-1_amd64.deb
        "zlib1g-dev apt"    # for python3.10
            # libncurses5-dev_6.0+20161126-1+deb9u2_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/n/ncurses/libncurses5-dev_6.0+20161126-1+deb9u2_amd64.deb
        "libncurses5-dev apt"   # for python3.10
            # libgdbm-dev_1.23-3_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/g/gdbm/libgdbm-dev_1.23-3_amd64.deb
        "libgdbm-dev apt"   # for python3.10
            # libnss3-dev_3.85-1_amd64.deb
            # http://ftp.ru.debian.org/debian/pool/main/n/nss/libnss3-dev_3.85-1_amd64.deb
        "libnss3-dev apt"   # for python3.10
        "libssl-dev apt"   # for python3.10
        "libreadline-dev apt"   # for python3.10
        "libffi-dev apt"   # for python3.10
        "libbz2-dev apt"
        "wget apt"   # for python3.10"
        "xinput apt"    # for touchscreen
        # "python3.10
        #     src
        #     https://www.python.org/ftp/python/3.10.8/Python-3.10.8.tgz
        #     Python-3.10.8.tgz | Python-3.10.8
        # "
        "python3-pip apt"
        # "mysql-connector-python
        #     apt
        #     https://dev.mysql.com/get/Downloads/Connector-Python/mysql-connector-python-py3_8.0.31-1debian11_amd64.deb
        #     mysql-connector-python-py3_8.0.31-1debian11_amd64.deb
        # "
        "libaio1 apt"   # for mysql-server
        "mysql-server
            apt-conf
            https://repo.mysql.com//mysql-apt-config_0.8.24-1_all.deb
            mysql-apt-config_0.8.24-1_all.deb
        "
        "mysql-server apt"
            # https://files.pythonhosted.org/packages/ba/39/04c7476bcbb457986a83eeac80c9226bbee63ed991e62f73c100832c166a/mysql_connector_python-8.0.31-cp311-cp311-manylinux1_x86_64.whl
            # mysql_connector_python-8.0.31-cp311-cp311-manylinux1_x86_64.whl
        "mysql-connector-python
            pip
        "
            # https://files.pythonhosted.org/packages/42/38/775b43da55fa7473015eddc9a819571517d9a271a9f8134f68fb9be2f212/numpy-1.23.5.tar.gz
            # numpy-1.23.5.tar.gz
        "numpy
            pip
        "
            # https://files.pythonhosted.org/packages/d7/42/06793d68ddf1c07c975cd8b84d8240c854b718ca05b1976a2fb8588ee770/python-snap7-1.2.tar.gz
            # python-snap7-1.2.tar.gz
        "python-snap7
            pip
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
installMySqlDatabase=true
installDataServer=false
    dsAppDir='/home/scada/app/data_server/'
    dsAppName='sds_run.py'
    dsGitOwner='a-givertzman'
    dsGitRepo='s7-data-server'
    dsGitBranch='Fault-Registrator'
    dsGitAsset='s7-data-server-internal_v0.0.30.tar.gz' #'ds_release.zip' 
    # cmaGitToken='GHSAT0AAAAAAB3FNKE3CXTIR7VOFHUAF2NCY37MDRQ'
    dsGitToken='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'
    dsMySqlStructure=crane_data_servers.sql
installServices=false

# exit 0

# read -p "Enter $userName@$hostName password: " sshPass

sudoPass="null" 
# read -p "Enter [sudo] $user@$hostName password: " sudoPass    # uncomment to use common sudo pass, will be applyed to all scripts


############ INSTALLING SSH KEY ON REMOTE ############
    ssh-copy-id -i ~/.ssh/id_rsa.pub $userName@$hostName
    # ssh -t $userName@$hostName "mkdir -p ~/.ssh && /tmp/$sName'"
    # scp ~/.ssh/id_rsa.pub $userName@$hostName:/tmp/

############ INSTALL SUDO ############
if $installSudo; then
    sName=install_sudo.sh
    path=$dirName/$sName 
    echo -e "\n${BLUE}Installing sudo on remote $hostName...${NC}"
    scp $path $userName@$hostName:/tmp/
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName"
fi

############ INSTALL PACKAGES ############
if $installPackages; then
    sName=install_packages.sh
    path=$dirName/$sName
    echo -e "\n${BLUE}Installing python3.10 on remote $hostName...${NC}"
    files=""
    packages=""
    for package in "${instPackages[@]}"; do 
        # local name file url
        package=$(echo $package | sed 's/\s|*\s*/ /g')
        read -r name type url file extracted <<< $package
        tmpPath=$dirName/distro/$file
        packages="$packages '$name|$type|$url|$file|$extracted'"
        if ! [ -z "${file}" ]; then
            files="$files $tmpPath"
            if ! [ -z "${url}" ]; then
                echo -e "\tchecking local repositiry "$tmpPath""
                if [ -f "$tmpPath" ]; then
                    echo "$tmpPath exists."
                else
                    if ! [ -z "${proxySet}" ]; then
                        curl $CURL_ARGS \
                            --location --max-redirs 10 \
                            --create-dirs \
                            --progress-bar \
                            --proxy $proxySet \
                            -o $tmpPath \
                            $url
                    else
                        curl $CURL_ARGS \
                            --location --max-redirs 10 \
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
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName $sudoPass $proxySet 'null' $packages"
fi

############ INSTALL MYSQL DATABASE ############
if $installMySqlDatabase; then
    ssh -t $userName@$hostName "echo '123qweasd' | mysql -u root -p" < $dirName/conf/$dsMySqlStructure
fi


############ INSTALL LXDE ############
if $installLxde; then
    sName=install_lxde.sh
    path=$dirName/$sName 
    echo -e "\n${BLUE}Installing LXDE on remote $hostName...${NC}"
    scp $path $userName@$hostName:/tmp/
    scp $dirName/conf/$onboardAutostartDesktop $userName@$hostName:/tmp/
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName"
    rebootRemote
fi

############ INSTALL LXDE AUTO LOGIN ############
if $installAutologin || $installLxde; then
    sName=install_autologin.sh
    path=$dirName/$sName 
    echo -e "\n${BLUE}Installing LXDE autologin on remote $hostName...${NC}"
    scp $path $userName@$hostName:/tmp/
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName"
    rebootRemote
fi

############ INSTALL DATA SERVER ############
if $installDataServer; then
    sName=install_data_server.sh
    path=$dirName/$sName
    tmpPath=$dirName/distro/$dsGitAsset
    echo -e "\n${BLUE}Installing DATA SERVER on remote $hostName...${NC}"
    echo -e "\tchecking local repositiry "$tmpPath""
    if [ -f "$tmpPath" ]; then
        echo "$tmpPath exists."
    else
        echo
        # $dirName/download_src.sh $dsGitOwner $dsGitRepo $dsGitBranch $tmpPath
                        # curl --junk-session-cookies \
                        #     --location --max-redirs 10 \
                        #     --create-dirs \
                        #     --progress-bar \
                        #     --proxy $proxySet \
                        #     -o $tmpPath \
                        #     -u 'a.givertzman@icloud.com' \
                        #     'https://api.github.com/repos/a-givertzman/s7-data-server/tarball/Fault-Registrator'
                            # -H "Authorization: Bearer $dsGitToken" \
    fi
    echo -e "coping files..."
    scp $path $tmpPath $userName@$hostName:/tmp/
    echo -e "instaling application..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName /tmp/$dsGitAsset $dsAppDir $dsAppName"
fi

############ INSTALL CMA ############
if $installCma; then
    sName=install_cma.sh
    path=$dirName/$sName
    tmpPath=$dirName/distro/$cmaGitAsset
    echo -e "\n${BLUE}Installing CMA on remote $hostName...${NC}"
    echo -e "\tchecking local repositiry "$tmpPath""
    if [ -f "$tmpPath" ]; then
        echo "$tmpPath exists."
    else
        $dirName/download.sh $cmaGitOwner $cmaGitRepo $cmaGitTag $cmaGitAsset $tmpPath
    fi
    echo -e "coping files..."
    scp $path $tmpPath $userName@$hostName:/tmp/
    echo -e "instaling application..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName /tmp/$cmaGitAsset $cmaAppDir $cmaAppName"
fi

############ INSTALL SERVICES ############
if $installServices; then
    sName=install_services.sh
    path=$dirName/$sName
    path1=$dirName/services/api_server.service 
    path2=$dirName/services/data_server.service
    path3=$dirName/services/scada_app.service
    path4=$dirName/services/configure_ui.service
    path5=$dirName/configure_ui.sh
    echo -e "\n${BLUE}Installing services on remote $hostName...${NC}"
    echo -e "coping files..."
    scp $path $path1 $path2 $path3 $path4 $path5 $userName@$hostName:/tmp/
    echo -e "instaling services..."
    ssh -t $userName@$hostName "chmod +x /tmp/$sName && /tmp/$sName"
    rebootRemote
fi





############ USED FOR TESTING ONLY ############


# proxySet="http://constr:constr@192.168.120.234:3128"
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
#     --proxy $proxySet \
#     -H "Authorization: Bearer $GITHUB_API_TOKEN" \
#     -H 'Accept: application/json' \
#     "$GH_ASSET" > $target
# curl $CURL_ARGS \
#     --progress-bar \
#     --proxy $proxySet \
#     -H "Authorization: Bearer $GITHUB_API_TOKEN" \
#     -H 'Accept: application/vnd.github+json' \
#     "https://api.github.com/repos/a-givertzman/s7-data-server/zipball/Fault-Registrator" > $target


#     # -H 'Accept: application/octet-stream' \
#     # -H 'Accept: application/json' \
