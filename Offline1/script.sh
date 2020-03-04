
#task 1,2,3


if [ $# -eq 2 ]; then
    #echo "both present"
    dir=$1
    file=$2
elif [ $# -eq 1 ]; then
    dir=""
    file=$1   
else
    echo "You must enter a valid input file name"
fi

#task 4

if [[ -f "$file" ]]; then
        echo "$file exists"
else 
        echo "File doesn't exist. Please enter an existing input file."
fi



input=`tr "\n" "-" < $file`

var1=$(echo $input | cut -f1 -d-)
var2=$(echo $input | cut -f2 -d-)
var3=$(echo $input | cut -f3 -d-)

#task 5,6




check_readable_files()
{
    directory=$1
    cd ./$directory/
    #pushd . > /dev/null
    OIFS="$IFS"
    IFS=$'\n'
    for file in `ls`;do
        #echo "$file"
        if [[ -d "$file" ]]; then
            check_readable_files $file
            cd ..
            #popd > /dev/null
        elif [[ -f "$file" ]]; then
            if [ $var1 = "begin" ]; then
                temp=`head -$var2 $file | grep -i $var3`
            elif [ $var1 = "end" ]; then
                temp=`tail -$var2 $file | grep -i $var3`
            else 
                echo "invalid first input"
            fi
            if [[ -n $temp ]];then
                echo "$file has $temp"
                newName="$PWD/$file"
                dot="."
                newName=${newName////$dot}
                cp ./$file $dest
                cd $dest/ 
                mv $file $newName
                cd $OLDPWD
            fi
        else
            echo "$file is invalid"
        fi
    done
    IFS="$OIFS"

}

mkdir output_dir
dest=`pwd`
dest="$dest/output_dir"
check_readable_files $dir
