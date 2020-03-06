#!/bin/bash

# Colors
CL_XOS="\033[34;1m"
CL_PFX="\033[33m"
CL_INS="\033[36m"
CL_RED="\033[31m"
CL_GRN="\033[32m"
CL_YLW="\033[33m"
CL_BLU="\033[34m"
CL_MAG="\033[35m"
CL_CYN="\033[36m"
CL_RST="\033[0m"

DIR=$(pwd)

mkdir tranSKadooSH
cd tranSKadooSH

echo -e "\n" $CL_INS "Github Authorization Setting Up" $CL_RST
git config --global user.email $GitHubMail
git config --global user.name $GitHubName
git config --global color.ui true
git config --global credential.helper store 

echo -en "\n" $CL_INS "Setup Google Cookies for Smooth googlesource Cloning" $CL_RST
git clone -q "https://$GITHUB_TOKEN@github.com/rokibhasansagar/google-git-cookies.git" &> /dev/null
if [ -e google-git-cookies ]; then
  bash google-git-cookies/setup_cookies.sh
  rm -rf google-git-cookies
fi

### Get the script
wget -q https://gist.github.com/rokibhasansagar/d60c6ea6f61c51a430d16c6f1c638ded/raw/4664f224596cb81a2ae10c90ffdcb6523bff079e/update-omni.sh
chmod a+x ./update-omni.sh

### Some checks
cd ~/.ssh && ls -a .

if [ ! -f id_rsa.pub ]; then
  echo "Add this public key into Gerrit before editing project"
  ssh-keygen -y -f id_rsa > id_rsa.pub || echo yes | ssh-keygen -y -f id_rsa > id_rsa.pub
fi
echo -e "\n\n" && cat id_rsa.pub && echo -e "\n\n"

cd -

### Do This Separately
# ./aosp-merge.sh

# Add ssh known hosts
ssh-keyscan -H gerrit.omnirom.org >> ~/.ssh/known_hosts || ssh-keyscan -t rsa -H gerrit.omnirom.org:29418 >> ~/.ssh/known_hosts
ssh -o StrictHostKeyChecking=no rokibhasansagar@gerrit.omnirom.org:29418 || true

# cd $DIR/tranSKadooSH/vendor/omni/utils
# ./aosp-push-merge.sh
