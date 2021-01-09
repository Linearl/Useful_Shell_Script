#!/bin/bash
# 1.git clone or wget if resource is from url
# 2.create a tar.bz2 file
# 3.upload it to baiduyun
if [ -z $1 ]
then
	echo -e "\033[1;4;42;31m Invalid param, provide one at least! \033[0m"
	exit 0
fi

FILENAME=$1
REMOTE_PATH=$2
InternetFlag=0

DOWANLOAD_PATH="/ByPyDownloads/"
TEMPFILE_PATH=$HOME$DOWANLOAD_PATH

if [ ! -d $TEMPFILE_PATH ]
then
	echo "create $TEMPFILE_PATH directory."
	mkdir $TEMPFILE_PATH
fi

cd $TEMPFILE_PATH

# find head(mostly filename) and tail(filename extension)
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
#folder
elif [ "$resHead" == "$resTail" ]
then
	resFile=$resHead
#filetype = bz2
elif [ $resTail == "bz2" ]
then
	resFile=$resHead
fi

# otherwise it's a local resource
# check whether it is a bz2/zip file
# if not, pack it to bz2
#dirPath=`dirname $FILENAME`
file_type=`echo $resFile | awk -F "." '{print $NF}'`
echo "file_type=$file_type"

if [ $file_type != "bz2" -a $file_type != "zip" ]
then
	echo "start to pack $FILENAME"
	tar -jcvf $resFile.tar.bz2 $resFile
	#update file name
	resFile = $resFile.tar.bz2
fi
echo "start to upload $resFile"
#select Baiduyun directory, default bypy/Downloads
if [ $2 ]
then
	bypy -v upload $resFile $2
else
	bypy -v upload $resFile /Downloads
fi

echo "upload $FILENAME complete!"
used_percent=`df -h | grep /dev/vda1 | awk '{print $5}' | awk  -F '%'  '{print $1}'`
#rm file when there are few space in disk
if [[ used_percent -gt 92 ]]
then
	echo "Few free disk space, romove tar.bz2 file."
	rm -rf $resFile.tar.bz2
fi

#return previous dir
cd -

echo "Jobs Done!"
