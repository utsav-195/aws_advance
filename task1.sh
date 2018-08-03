#taking input of buckets from user
echo "enter source bucket: "
read source
echo "enter dest bucekt:"
read destination

#creating sync file for sync command and creating cronjob to execute the file every minute
echo -e "#!/bin/bash\necho \"aws s3 sync s3://$source s3://$destination --delete\necho complete\" > /home/ec2-user/sync.sh\nsudo crontab -l > mycron\necho \"* * * * * /home/ec2-user/sync.sh\" >> mycron\nsudo crontab mycron\nsudo chmod 755 /home/ec2-user/sync.sh" > my_script.txt

#creating an ec2 instance with IAM user role and startup script made in the previous command
aws ec2 run-instances --image-id ami-b70554c8 --count 1 --instance-type t2.micro --key-name MyKeyPair --user-data file://my_script.txt --region us-east-1 --iam-instance-profile="Arn"="arn:aws:iam::488599217855:instance-profile/FullAccess" --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=utsav-ec23}]"
