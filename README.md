# Useful_Shell_Script
A collection of some shell scripts 

**Say NO to "996 ICU"**:
[![alt text](https://img.shields.io/badge/link-996.icu-red.svg "996.icu")](https://996.icu)

## 2019/8/6:
Upload a script. It downloads files through your VPS and then pack it using bzip2.
After that, it will be uploaded using bypy-tool.
So you should setup your bypy before using it. [![alt text](https://img.shields.io/pypi/v/bypy.svg "PyPi Version")](https://pypi.python.org/pypi/bypy) 
It is designed to solve web-rate problem like below:
### it works if:
  * your local computer <--> file you want to download——slow
  * your local computer <--> your VPS——slow

### it doesn't if:
  * your local computer <--> baiduyun-server——fast
  * file you want to download <--> your VPS——very fast
  * your VPS <--> baiduyun-server——fast

### supported platform:
ubuntu-16.0.4 / Centos7. It should works on some other Linux-based systems.
### usage:
  * Put the script into a directory in your PATH. Simplely run "tar_and_upload_baiduyun.sh SourceName"
  * Param "SourceName" can be a url or a local file/diretory.
