
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

count_line_number()
{
    myfile=$1

    if [ $var1 = "begin" ]; then
        lineNumber=`head -$var2 $myfile | grep -n -i $var3 | sed 's/^\([0-9]\+\):.*$/\1/'`
        #echo $lineNumber
    elif [ $var1 = "end" ]; then
        lineNumber=`tail -$var2 $myfile | grep -n -i $var3 | sed 's/^\([0-9]\+\):.*$/\1/'`
        totalLines=`wc -l $myfile | sed 's/^\([0-9]\+\)\ .*$/\1/'`
        #echo "$myfile Total : $totalLines  lineNumber = $lineNumber"
        if [[ $totalLines -le $var2 ]];then
            echo $lineNumber
        else 
            lineNumber=`expr $totalLines + $lineNumber`
            lineNumber=`expr $lineNumber - $var2`
            #echo $lineNumber
        fi
    else
        echo "$file is invalid"
    fi
}

check_files(){
    directory=$1
    cd $PWD/$directory/
    OIFS="$IFS"
    IFS=$'\n'
    for file in `find ./ -type f -exec grep -Iq . {} \; -print`
    do
      #echo $file  
        if [ $var1 = "begin" ]; then
            temp=`head -$var2 $file | grep -i $var3`
        elif [ $var1 = "end" ]; then
            temp=`tail -$var2 $file | grep -i $var3`
        else 
            echo "invalid first input"
        fi
        if [[ -n $temp ]];then
            #echo "$file has $temp"
            count_line_number $file
            lines=$lineNumber
            cp $file $dest
            cd $dest/ 
            case `basename "$file"` in
            *.* ) 
            extension="${file##*.}"
            filename="${file%.*}"
            filename=$filename\_$lines"."$extension
            ;;
            * ) filename=$file\_$lines
            ;;
            esac
            dot="."
            newName="$filename"
            newName=${newName////$dot}
            newName=${newName#".."}
            directory=${directory////$dot}
            newName=$directory$newName
            newFile=${file##*/}
            mv $newFile $newName
            #echo $newName
            cd $OLDPWD
        fi
    done
    IFS="$OIFS"
}

mkdir output_dir
dest=`pwd`
dest="$dest/output_dir"
#check_readable_files $dir

check_files $dir