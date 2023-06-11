#!/bin/bash

# Update default packages
sudo yum update -y

# Install Java Development Kit
sudo yum install -y java-17-amazon-corretto

# Download Minecraft server JAR file
curl -O https://piston-data.mojang.com/v1/objects/15c777e2cfe0556eef19aab534b186c0c6f277e1/server.jar

# Start the Minecraft server for the first time
java -Xmx1024M -Xms1024M -jar server.jar nogui

sleep 10

# Agree to the Minecraft EULA
echo "eula=true" >eula.txt

# Create a systemd service file for Minecraft server
sudo tee /etc/systemd/system/minecraft.service > /dev/null <<EOT
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=ec2-user
ExecStart=/usr/bin/java -Xmx1024M -Xms1024M -jar /home/ec2-user/server.jar nogui
WorkingDirectory=/home/ec2-user
Restart=always

[Install]
WantedBy=multi-user.target
EOT

sleep 10

# Enable the Minecraft service
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service