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
