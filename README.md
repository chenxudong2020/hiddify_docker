# hiddify_docker
docker run -itd --name hiddify --restart=always -p 6756:6756 -p 2334:2334 -e SUB_URL="" -e WEB_SECRET="hiddify" -e PROXY_USER="hiddify" -e PROXY_PASS="hiddify" registry.cn-hangzhou.aliyuncs.com/dubux/hiddify


SUB_URL Your airport subscription connection </br>
WEB_SECRET Your password for clashweb access page</br>
PROXY_USER proxy user default hiddify</br>
PROXY_PASS proxy password default hiddify</br>

Deployed, please visit http://docker host ip:6756/ui/ </br>
2334 socks5 and http proxy share port with authentication

![image](https://github.com/user-attachments/assets/05b91d66-8ff6-4bd0-9fa5-a5699a8c2b90)

