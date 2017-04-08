#!/bin/bash
echo "Update package cache!"
apt-get update
sudo apt-get dist-upgrade -y
printf "\033c"

echo "Install python & python lib!"
sudo apt-get install python python-pip python-gevent python-m2crypto git-core -y
sudo pip install --upgrade pip

echo "Install shadowsocks from github!"
sudo pip install git+https://github.com/shadowsocks/shadowsocks.git@master

echo "Create config file of shadowsocks!"
sudo mkdir /etc/shadowsocks
echo "{" | sudo tee /etc/shadowsocks/shadowsocks.json
echo "    \"server\":\"0.0.0.0\"," | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "    \"port_password\":" | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "    {" | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "        \"13571\":\"$(cat /dev/urandom | head -n 20 | md5sum | head -c 12)\"," | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "        \"13572\":\"$(cat /dev/urandom | head -n 20 | md5sum | head -c 12)\"," | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "        \"13573\":\"$(cat /dev/urandom | head -n 20 | md5sum | head -c 12)\"" | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "    }," | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "    \"timeout\":120," | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "    \"method\":\"aes-256-cfb\"," | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "    \"auth\": true" | sudo tee -a /etc/shadowsocks/shadowsocks.json
echo "}" | sudo tee -a /etc/shadowsocks/shadowsocks.json
printf "\033c"

echo "Install supervisor to monitor and control processes!"
sudo pip install supervisor

echo "Create config file of supervisor!"
sudo mkdir /etc/supervisor
sudo echo_supervisord_conf > /etc/supervisor/supervisord.conf

echo "Add shadowsocks to supervisor!"
sudo mkdir /var/log/supervisor
echo "" | sudo tee -a /etc/supervisor/supervisord.conf
echo ";shadowsocks auto start"  | sudo tee -a /etc/supervisor/supervisord.conf
echo "[program:shadowsocks]"  | sudo tee -a /etc/supervisor/supervisord.conf
echo "command = ssserver -c /etc/shadowsocks/shadowsocks.json"  | sudo tee -a /etc/supervisor/supervisord.conf
echo "user = $(whoami)"  | sudo tee -a /etc/supervisor/supervisord.conf
echo "autostart = true"  | sudo tee -a /etc/supervisor/supervisord.conf
echo "autoresart = true"  | sudo tee -a /etc/supervisor/supervisord.conf
echo "stderr_logfile = /var/log/supervisor/ss.stderr.log"  | sudo tee -a /etc/supervisor/supervisord.conf
echo "stdout_logfile = /var/log/supervisor/ss.stdout.log"  | sudo tee -a /etc/supervisor/supervisord.conf
echo "" | sudo tee -a /etc/supervisor/supervisord.conf
sudo sed -i 's/exit 0/sudo \/usr\/local\/bin\/supervisord -c \/etc\/supervisor\/supervisord.conf/g' /etc/rc.local
echo "" | sudo tee -a /etc/rc.local
echo "exit 0" | sudo tee -a /etc/rc.local

printf "\033c"
echo "All donw !"
echo "Please remember the port and password below!"
echo '++++++++++++++++++++++++++++++++++++++++++++++++'
sed -n '3,8p' /etc/shadowsocks/shadowsocks.json
echo '++++++++++++++++++++++++++++++++++++++++++++++++'
echo "Welcome to the real internet!"
