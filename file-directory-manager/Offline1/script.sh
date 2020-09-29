
#task 1,2,3

if [[ -f "output.csv" ]]; then
        rm -r output_dir/
        rm output.csv
fi

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
        echo ""
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
        all=`head -$var2 $myfile | grep -n -i $var3`
        #echo $lineNumber
    elif [ $var1 = "end" ]; then
        lineNumber=`tail -$var2 $myfile | grep -n -i $var3 | sed 's/^\([0-9]\+\):.*$/\1/'`
        all=`tail -$var2 $myfile | grep -n -i $var3`
        totalLines=`wc -l $myfile | sed 's/^\([0-9]\+\)\ .*$/\1/'`
        #echo "$myfile Total : $totalLines  lineNumber = $lineNumber"
        if [[ $totalLines -le $var2 ]];then
            #echo $lineNumber
            echo ""
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
    count=0;
    echo "File Path,Line Number,Line Containing Searched String" >> output.csv
    cd $PWD/$directory/
    OIFS="$IFS"
    IFS=$'\n'
    for file in `find ./ -type f -exec grep -Iq . {} \; -print`
    do
      #echo $file  
        if [ $var1 = "begin" ]; then
            temp=`head -$var2 $file | grep -i $var3`
            #echo $temp
        elif [ $var1 = "end" ]; then
            temp=`tail -$var2 $file | grep -i $var3`
        else 
            echo "invalid first input"
        fi
        if [[ -n $temp ]];then
            count=`expr $count + 1`
            #echo "$file has $temp"
            count_line_number $file
            lines=$lineNumber
            min=1000000000
            for m in $lines
            do
                if [ $m -lt $min ];then
                    min=$m
                fi
            done
            allLines=$all
            #echo $allLines
            lines=$min
            #echo $lines

            cp $file $dest
            cd ..
            forCsv=${file#"./"}
            #echo $dir 
            #echo $forCsv
            forCsv="$dir$forCsv"
            #echo $forCsv
            for i in $allLines 
            do
                #echo "i = $i"
                temp=${i##*:}
                #echo "temp = $temp"
                i=${i%%:*}
                #echo "i = $i"
                #echo $temp
                if [ $var1 = "end" ];then
                    if [[ $totalLines -le $var2 ]];then
                        #echo $lineNumber
                        echo ""
                    else 
                        i=`expr $totalLines + $i`
                        i=`expr $i - $var2`
                    fi
                fi
                echo "$forCsv,$i,\"$temp\"" >> output.csv
            done
            #echo "final line $lines"
            cd $OLDPWD
            cd $dest/ 
            case `basename "$file"` in
            *.* ) 
            extension="${file##*.}"
            filename="${file%.*}"
            filename=$filename$lines"."$extension
            ;;
            * ) filename=$file$lines
            ;;
            esac
            dot="."
            newName="$filename"
            newName=${newName////$dot}
            newName=${newName#".."}
            directory=${directory////$dot}
            newName=$directory$newName
            #echo $file
            newFile=${file##*/}
            #echo $newFile
            #echo $newName
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
check_files $dir
echo "File Count : $count"