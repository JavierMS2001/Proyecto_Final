sudo apt-get -y update && sudo apt-get -y upgrade

sudo apt-get -y install vim

sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config;
sudo sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config;
sudo systemctl restart sshd;

echo "root:vagrant" | sudo chpasswd
echo "vagrant:vagrant" | sudo chpasswd