#/bin/bash

filename='url-list'
ListNumber=1

# Clean tmp directory before start
rm -rf ./tmp/*
# delete old blacklist
rm -f all.list.use


echo "Starting Refreshing of Blacklists into ./tmp" 
while read link; do 
	echo "Downloading $link as list: $ListNumber ......"
	#curl --silent --compressed --output ./tmp/$ListNumber.list $link
	#curl --output ./tmp/$ListNumber.list $link
	wget --timeout=10 --output-document=./tmp/$ListNumber.list $link
	if [ $? != 0 ]; then
		echo "Download of $link failed"
	fi
    echo "Done"
    ((ListNumber+=1))
done < "$filename"


echo "Cleaning Files"
for file in ./tmp/*.list ; do
	grep -v '^#' $file | grep -v '^;' | sed 's/;.*//' > $file.use
done

echo "Joining Blacklists"
cat ./tmp/*.list.use > ./tmp/all.list
echo "Adding Manual Blacklist"
cat blacklist >> ./tmp/all.list

echo "Unique IPs"
sort ./tmp/all.list | uniq > ./tmp/all.list.uniq



echo "Removing IPs from whitelist"
grep -v -f whitelist ./tmp/all.list.uniq > all.list.use

# Delete tmp file
rm -rf ./tmp/*

