  sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
  sudo systemctl restart sshd;
  sudo yum update;
  sudo yum upgrade;
  echo "root:vagrant" | sudo chpasswd