# PX Proxy
Shell Script to configure `SSN wifi` proxy settings in ubuntu

#### Install
Grab using `cURL` 
```sh
curl -o px https://raw.githubusercontent.com/SudarAbisheck/px-proxy/master/px.sh\
&& chmod +x px && sudo mv px /usr/bin
```
or using `wget`
```sh
wget -O px https://raw.githubusercontent.com/SudarAbisheck/px-proxy/master/px.sh\
&& chmod +x px && sudo mv px /usr/bin
```

#### Usage
```sh
px 1    ## Setting System proxy
px 0    ## Unsetting System proxy

px 1g   ## Setting Git proxy
px 0g   ## Unsetting Git proxy

px stat ## Checking proxy status
```
