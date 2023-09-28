#!/bin/bash


# updated by: Str0kednova
# date:       September 28, 2023
# purpose:    Added more to the original dashy.sh script
#             to include a new configuration and pull icons into
#             the portainer directory's.


function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}


function check_internet() {
  printf "Checking if you are online... "
  wget -q --spider http://github.com
  if [ $? -eq 0 ]; then
    echo -e "You're Online, Continuing..."
  else
    error "You're Offline, Connect to the internet then run the script again..."
  fi
}

function add_config() {

cat << EOF > '/portainer/Files/AppData/Config/Dashy/public/conf.yml'
appConfig:
  theme: colorful
  layout: auto
  iconSize: medium
  language: en
pageInfo:
  title: Home Lab
  description: Welcome to your Home Lab!
  navLinks:
    - title: GitHub
      path: https://github.com/Lissy93/dashy
    - title: Documentation
      path: https://dashy.to/docs
  footerText: ''
sections:
  - name: Starter Only
    icon: fas fa-server
    items:
      - title: Google
        description: Search
        url: https://google.com
EOF

}


function add_icons() {
  cd '/portainer/Files/AppData/Config/Dashy/icons/'
  git clone 'https://github.com/walkxcode/dashboard-icons.git'
}


check_internet


if [ ! -d '/portainer/Files/AppData/Config/' ]; then
  add_config
  echo -e "Directory does not exist, creating portainer config directory"
  mkdir -p /portainer/Files/AppData/Config/ || error "Failed to create '/portainer' config directory..."
else
  echo -e "Directory already exists, continuing..."
fi


if [ ! '/portainer/Files/AppData/Config/Dashy' ]; then
  cd '/portainer/Files/AppData/Config/Dashy/'
  mkdir -p /portainer/Files/AppData/Config/Dashy/{public,icons}
  touch /portainer/Files/AppData/Config/Dashy/public/conf.yml
fi


if [ ! -d '/portainer/Files/AppData/Config/Dashy/icons' ] && [ ! -d '/portainer/Files/AppData/Config/Dashy/public' ]; then
  echo "Dashy configuration does not exist.\n Creating required subdirectories"
  mkdir -p '/portainer/Files/AppData/Config/Dashy/'{public,icons}
  cd '/portainer/Files/AppData/Config/Dashy/'
fi

add_config

if [ ! -d '/portainer/Files/AppData/Config/Dashy/icons/dashboard-icons/' ]; then
  echo -e "Adding/Cloning icons for Dashy..."
  add_icons
else
  echo -e "Dashy Icons already exist..."
fi
