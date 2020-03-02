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

#send_to_output_dir(){
 #   cp $1 ../

#}


check_readable_files()
{
    directory=$1

    cd ./$directory/

    for file in `ls`;do

        if [[ -d $file ]]; then
            check_readable_files $file
            cd ..
        elif [[ -f $file ]]; then


            if [ $var1 = "begin" ]; then
                temp=`head -$var2 $file | grep -i $var3`
            elif [ $var1 = "end" ]; then
                temp=`tail -$var2 $file | grep -i $var3`
            else 
                echo "invalid first input"
            fi

            if [[ -n $temp ]];then
                echo "$file has $temp"
                #send_to_output_dir $file
            fi

        fi
        #echo "$file"
        
    done

}

#mkdir output_dir

check_readable_files $dir

#TODO: put them in a output directory