#!/bin/bash

echo "Please enter the Public Ip of instance 1"
read ip1

echo "Please mention the path to the private key to instance1"
read key1

echo "Please enter the Public Ip of instance 2"
read ip2

echo "Please mention the path to the private key to instance2"
read key2

startScript="ssh-keygen -f .ssh/id_rsa -t rsa -N ''"

echo "Generating public keys in both the instances"

ssh -i $key1 ec2-user@$ip1 "${startScript}"
echo "key 1 generated !!!!!!"

ssh -i $key2 ec2-user@$ip2 "${startScript}"
echo "key2 generated !!!!!"

scp -i $key1 ec2-user@$ip1:.ssh/id_rsa.pub pub1.txt
scp -i $key2 ec2-user@$ip2:.ssh/id_rsa.pub pub2.txt

pub1=`cat pub1.txt`
pub2=`cat pub2.txt`

echo "Connecting the two instances"
S1="echo $pub2 >> .ssh/authorized_keys;"
echo  "key1 addedd!!"

S2="echo $pub1 >> .ssh/authorized_keys;"
echo "key2 addedd !!"

ssh -i $key1 ec2-user@$ip1 "${S1}"
ssh -i $key2 ec2-user@$ip2 "${S2}"

echo "Now the instances can connect to each other password less"

#removing files from local directory
rm pub1.txt
rm pub2.txt
