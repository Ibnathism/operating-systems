
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

#task 5
send_to_output_dir(){
    cp $1 "$2/../../output_dir/"
    
}



check_readable_files()
{
    directory=$1

    global="$global/$directory"
    depthCount=`expr $depthCount + 1`
    #echo $global
    cd ./$directory/

    for file in `ls`;do

        if [[ -d $file ]]; then
            check_readable_files $file
            cd ..
            #echo $global
            #global=`cut -d / -f 2 < ..$global/`
            oldPwd=$OLDPWD
            depthCount=`expr $depthCount - 1`
        elif [[ -f $file ]]; then
            if [ $var1 = "begin" ]; then
                temp=`head -$var2 $file | grep -i $var3`
            elif [ $var1 = "end" ]; then
                temp=`tail -$var2 $file | grep -i $var3`
            else 
                echo "invalid first input"
            fi

            if [[ -n $temp ]];then
                #echo "$file has $temp"
                #rename_file $file $global
                #echo $oldPwd
                echo "$file transferring from $oldPwd"
                send_to_output_dir $file $oldPwd
                #send_to_output_dir $file $depthCount
                depthCount=1
            fi

        fi
        #echo "$file"
        
    done

}

mkdir output_dir

depthCount=1
global=""
check_readable_files $dir

#TODO: put them in a output directory