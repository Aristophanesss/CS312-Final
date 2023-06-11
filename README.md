#### Author: Chen Xue/ xueche
#### Date: 05/20/2023
#### Course: CS 312/ System Administration
#### Instructor: Alexander Ulbrich
---
# <center>Auto-start Minecraft server on AWS EC2</center>
## **1. Set up AWS EC2 instance**
- At the 'console home' page, search for EC2 services and nevigate to EC2 dashboard.
- Click on 'Launch Instance' to start a new instance, name your instance 'My Minecraft Server'.
- Choose 'Amazon Linux 2 AMI (HVM), SSD Volume Type' as the AMI, and 't2.medium' for instance type.
- For key pair, create a new one named 'Minecraft', store it in your desired location.
- At Network Settings section, click edit
    - Use default VPC and select 'Enable' for 'Auto-assign Public IP'
    - Select Create security group, put 'Minecraft' as the name and description
    - At Inbound security groups rules, keep the exsiting rules, then add rules:
        - Type: Custom TCP, Protocol: TCP, Port range: 25565 (default Minecraft server port), Source type: Anywhere
- Now you can launch your instance, it may take a few minutes for the instance to initialize.
## **2. Connect to the instance**
- Go back to the EC2 dashboard, once the instance is running, click on the instance ID to view the instance details.
- Copy the 'Public IPv4 DNS'
- In your own machince, open a terminal and connect to the instance using the following command:
    ```
    ssh -i <path to your key pair> ec2-user@<Public IPv4 DNS>
    ```
- Enter yes for 'Are you sure you want to continue connecting (yes/no/[fingerprint])?'
- Now you should be able to connect to the instance you just created via the terminal.
## **3. Setup the Minecraft server**
- First you may want to update the default packages on your instance:
    ```
    sudo yum update
    ```
- Then install the Jave Development Kit, which you will need to run the Minecraft server:
    ```
    sudo yum install java-17-amazon-corretto
    ```
   *Note: You will need OpenJDK 16 or later to run v1.17+ Minecraft server.*
- Next visit Minecraft's offical website at: https://www.minecraft.net/en-us/download
    - Click on Java Edition Server, this will led you to a page to download the server file.
    - Right click on 'minecraft_server..jar', copy the link address.
    - Back to the terminal, use curl to download the server file:
        ```
        curl -O <copied link>
        ```
- Run the JAR file to start the server:
    ```
    java -Xmx1024M -Xms1024M -jar server.jar nogui
    ```
- For the final step of this section, you'll need to agree to the Minecraft EULA:
    - Open the EULA file using vim:
        ```
        vim eula.txt
        ```
    - Type i to enter insert mod, change the line 'eula=false' to 'eula=true'
    - Hit ESC, then type ':wq' to save and exit
## **4. Configure auto-start for the Minecraft server**
- Create a new service file:
    ```
    sudo vim /etc/systemd/system/minecraft.service
    ```
- Copy and paste the following content into the file:
    ```
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
    ```
- Save and exit
- Now you can enable the service by running:
    ```
    sudo systemctl enable minecraft.service
    ```
## **5. Reboot and testing**
- Reboot the instance on terminal (or you can do it on the EC2 dashboard):
    ```
    sudo reboot
    ```
- Wait for a few minutes, then redo step 2 to connect to the instance.
- Check if the Minecraft server is active:
    ```
    sudo systemctl is-acive minecraft.service
    ```
- At this point your terminal should simply response with 'active', which means the server should be up and running
- Next let's test if the server is working as we expect:
    - Open Minecraft on your own machine, click on 'Multiplayer', then 'Add Server'
    - Enter the 'Public IPv4 DNS' of your instance, then click 'Done'
    - It may or may not take a few minutes for the server to be successfully connected
    - Once the connection is made, click on the server you just added, then click 'Join Server'
    - If you see the Minecraft world, then congratulations! You have successfully set up your own Minecraft server!
- To test if the minecraft server will auto-start after reboot, you can redo step 5 and see if you can still connect to the server.