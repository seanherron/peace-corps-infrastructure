#!/bin/bash
git pull origin master
aws s3 cp s3://peacecorps-secrets secrets/ --recursive

echo -n "Enter the secret key for decryption and press [ENTER]: "
read pcenckey

export PC_ENC_KEY=$pcenckey

for filename in secrets/*.enc
do
    openssl aes-256-cbc -d -a -salt -pass env:PC_ENC_KEY -in $filename -out $filename.unencrypted
done;

# We have to go file by file for this, which kind of sucks!
cp secrets/deploy.enc.unencrypted ../deploy.pem
chmod 600 deploy.pem

cp secrets/all.secret.enc.unencrypted group_vars/all