# Centos-errata
How to create errata for Katello to sync with. This will provide CentOS clients updated errata information 

## How to use 
- While building the docker container from the image, you'll have a apache webserver providing yum repositories for Centos 5/6/7/8 

## Why

This tool is a way to create a repository containing Errata for CentOS 7, 8 and 9
Foreman/Katello can then read and sync this repository to provide errata information to all of its clients

This is heavily based on 3 opensource projects : 
- CEFS project [http://cefs.steve-meier.de] 
- https://github.com/vmfarms/generate_updateinfo
- https://github.com/loitho/katello-create-errata

## Manual Build instruction 
```
git clone <input my own website here>
cd centos-errata
```
### If you're not using a proxy : 
```
docker build -t errata_server:v1 .
```
## How to run as this as a webserver

The image is based on an Centos 7, when running the image with : 
`docker run -p80:80 -it <build ID>`
you can use a web brower to see 4 repository : 
- <yourserver>:<port>/errata5
- <yourserver>:<port>/errata6
- <yourserver>:<port>/errata7
- <yourserver>:<port>/errata8
Which provides errata for the 5 major releases of CentOS

## How to sync with Katello
Select the product then create a repo and put the upstream to the web server directory for the centos version.

