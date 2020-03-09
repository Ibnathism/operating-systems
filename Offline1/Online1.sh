make_tree(){
    directory=$1
    cd $PWD/$directory/
    tree=$1
    #OIFS="$IFS"
    #IFS=$'\n'
    for file in `ls`
    do
        #echo $file
        if [[ -d $file ]]; then
            #echo $file
            tree=$"$tree$file"
            make_tree $file
            cd ..
            tree=""
        else 
            tree=$"$tree||$file"
            #echo "|-$file"
        fi

        
    done
    #IFS="$OIFS"
    echo "$tree"


}

make_tree2(){
    directory=$1
    cd $PWD/$directory/
    OIFS="$IFS"
    IFS=$'\n'
    count=0
    i=1
    for file in `find ./ -type f -exec grep -Iq . {} \; -print`
    do
        #if [[ -d $file ]]
        count[$i]=`echo "$file" | awk -F'/' '{ print NF }'` 
        name=$file

        echo $file
        #echo $count
        count[$i]=`expr ${count[$i]} - 1`
        #echo ${count[$i]}
        for ((j=0;j<${count[i]};j++))
        do
            echo ""
        done
        echo 
    done
    for i in $count
    do
        echo $i
    done
}

make_tree2 $1