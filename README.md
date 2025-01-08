# hiddify_docker
docker run -itd --name hiddify --restart=always  -p 2335:2335  -p 6756:6756 -p 2334:2334 -e SUB_URL="" -e WEB_SECRET=""  registry.cn-hangzhou.aliyuncs.com/dubux/hiddify


SUB_URL Your airport subscription connection
WEB_SECRET Your password for clashweb access page


Deployed, please visit http://docker host ip:6756/ui/
2335 http proxy port requires authentication
2334 socks5 and http proxy share port without authentication