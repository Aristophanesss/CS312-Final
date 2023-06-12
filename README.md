#### Author: Chen Xue/ xueche
#### Date: 06/11/2023
#### Course: CS 312/ System Administration
#### Instructor: Alexander Ulbrich
---
# <center>Auto-Start Minecraft server on AWS EC2 via Terraform</center>
## **1. Background**
- This is my final project for CS 312 System Administration. 
- This project use Terraform to create a Minecraft server on AWS EC2. 
- The server will be started when the instance is launched. And it will automatically restart when the server is rebooted.
- The server will be terminated when the instance is terminated.
## **2. Prerequisites**
 - To run this project, you need to have an AWS account available with your desired key pair.
    - Instructions on how to create a key pair can be found at https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/create-key-pairs.html
    - Optional: you can name your key pair as "minecraft" to avoid changing the default value in the code.
 - For your local machine, you will need:
    - Terraform installed
        - To check if you already have Terraform installed, run the following command in your terminal:
            ```
            terraform -v
            ``` 
            If you see a version number, you are good to go.
        - Otherwise, following the instructions at https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli to install Terraform.
    - AWS CLI installed
        - To check if you already have AWS CLI installed, run the following command in your terminal:
            ```
            aws --version
            ```
            If you see a version number, you are good to go.
        - Otherwise, following the instructions at https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html to install AWS CLI.
    - AWS credentials configured
        - Access your your AWS account and go to the IAM dashboard, get your AWS Access Key ID and AWS Secret Access Key.
        - To config your AWS credentials, run the following command in your terminal:
            ```
            aws configure
            ``` 
            Then enter your AWS Access Key ID and AWS Secret Access Key.
        - If you are using an education account, you will need to access your credential information at "AWS Details" on your AWS Academy Learner Lab.
            - Once you are on the "AWS Details" page, click on "Show" to reveal the credentials.
            - In your local machine, run 
                ```
                vim ~/.aws/credentials
                ``` 
                then copy the credentials from your "AWS Details" tab. 
            - Save the file.
- Once you have all the prerequisites, download or clone the code from this repository.
## **3. Diagram of the pipeline**
      +---------------------+                      +------------------+
      |                     |                      |                  |
      |    Terraform        |                      |     AWS EC2      |
      |                     |                      |                  |
      +---------------------+                      +------------------+
                  |                                           |
                  |                                           |
                  |                                           |
                  |         Create resources with             |
                  |         Terraform (e.g.,                  |
                  |         EC2 instance, security group)     |
                  |                                           |
                  +------------------------------------------>|
                  |                                           |
                  |                                           |
                  |         Connect to EC2 instance           |
                  |         via SSH                           |
                  |                                           |
                  +------------------------------------------>|
                  |                                           |
                  |                                           |
                  |         Transfer MCstartup.sh script      |
                  |         to EC2 instance                   |
                  |                                           |
                  +------------------------------------------>|
                  |                                           |
                  |                                           |
                  |         Execute MCstartup.sh script       |
                  |         on EC2 instance                   |
                  |                                           |
                  +------------------------------------------>|
                  |                                           |
                  |                                           |
                  |         Minecraft server running          |
                  |                                           |
                  +------------------------------------------>|
## **4. Run the program**
 - Navigate to the folder where you downloaded the code
    ```
    cd <path_to_the_folder>
    ```
 - Make sure you have your key pair file ready in the folder, and the name of the key pair is preferably "minecraft" (or you can change this default value in the code).
 - Initialize Terraform in your directory by running:
    ```
    terraform init
    ```
    You should see a whole procedure of Terraform initializing with a message "Terraform has been successfully initialized!"
- Then if you want to format and validate the configuration, run
    ```
    terraform fmt
    ```
    and
    ```
    terraform validate
    ```
    You should see a message "Success! The configuration is valid." if everything is good.
- Now you can deploy the infrastructure by running
    ```
    terraform apply
    ```
    You will be asked to confirm the action, type "yes" and hit enter.
- Wait for a few minutes, you should see a message "Apply complete! Resources: x added, 0 changed, 0 destroyed." 
- The Public IP address of the instance will also be shown in the output with the format: *instance_public_ip = "xx.xx.xxx.xxx"*
## **5. Connect to the server**
 - Before connecting to the server, you may need to wait for a few minutes for the server to be fully started.
 - Next let's test if the server is working as we expect:
    - Open Minecraft on your own machine, click on 'Multiplayer', then 'Add Server'
    - Enter the 'instance_public_ip' of your instance, then click 'Done'
    - It may or may not take a few minutes for the server to be successfully connected
    - Once the connection is made, click on the server you just added, then click 'Join Server'
    - If you see the Minecraft world, then congratulations! You have successfully set up your own Minecraft server!
 - If you are not desired to download Minecraft, you can also test the server using nmap:
    ```
    nmap -sV -Pn -p T:25565 <instance_public_ip>
    ```
    Before that you may what to make sure you have nmap installed on your machine, details can be found at https://nmap.org.