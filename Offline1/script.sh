if [ $# -eq 2 ]; then
    echo "both present"
    dir=$1
    file=$2
elif [ $# -eq 1 ]; then
    dir=""
    file=$1
    if [ -f "$file" ]; then
        echo "$file exists"
    else 
        echo "File doesn't exist. Please enter an existing input file."
    fi   
else
    echo "You must enter a valid input file name"
fi



input=`tr "\n" "-" < $file`

var1=$(echo $input | cut -f1 -d-)
var2=$(echo $input | cut -f2 -d-)
var3=$(echo $input | cut -f3 -d-)



#trying out stuff

if [ $var1 = "begin" ]; then
    echo begin
elif [ $var1 = "end" ]; then
    echo end
else 
    echo "invalid first input"
fi


#head -$var2 $file | grep -i $var3



#file1=`cd ./working_dir/ | ls -R`
#echo $file1
#modifiedFileList=`tr " " "-" < $file1`
#echo $modifiedFileList
#for i in `cd ./working_dir/ | ls -R`
#do
 #   chmod a+rwx $i
#  head -$var2 $i | grep -i $var3
#done
cd ./$dir/

for file in `find * -type f`;do
    #echo "$file"
    temp=`head -$var2 $file | grep -i $var3`
    echo "$file has $temp"
done




#TODO: for each valid file in the directory read first/last n lines and search the word containing files and put them in a output directory