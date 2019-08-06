#!/bin/bash
# 1.git clone or wget if resource is from url
# 2.create a tar.gz file
# 3.upload it to baiduyun
if [ -z $1 ]
then
	echo -e "\033[1;4;42;31m Invalid param, one at least! \033[0m"
	exit 0
fi

FILENAME=$1
REMOTE_PATH=$2
InternetFlag=0
resHead=`echo $FILENAME | awk -F ":" '{print $1}'`

echo "Head=$resHead"
resTail=`echo $FILENAME | awk -F "." '{print $NF}'`
echo "Tail=$resTail"

if [[ "$resHead" == "http" ]] || [[ "$resHead" == "https" ]] 
then
	echo "Download $FILENAME from Internet!"
	InternetFlag=1
	if [ "$resTail" == "git" ]
	then
		git clone "$FILENAME"
		temp=`echo $FILENAME | awk -F "/" '{print $NF}'`
		echo $temp
		resFile=`echo $temp | awk -F "." '{print $1}'`
		echo $resFile
	else
		wget $FILENAME
		resFile=`echo $FILENAME | awk -F "/" '{print $NF}'`
	fi
	echo "filename=$resFile"
elif [ "$resHead" == "$resTail" ]
then
	resFile=$resHead
fi

# otherwise it's a local resource
# pack it directly

#dirPath=`dirname $FILENAME`
echo "start to pack $FILENAME"
tar -jcvf $resFile.tar.bz2 $resFile
echo "start to upload $resFile"
#select directoty, default bypy/Downloads
if [ $2 ]
then
	bypy -v upload $resFile.tar.bz2 $2
else
	bypy -v upload $resFile.tar.bz2 /Downloads
fi

echo "upload $FILENAME complete!"
rm -rf $resFile.tar.bz2
