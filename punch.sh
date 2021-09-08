#!/bin/bash
 
# Return is 0 iff $1 given to it as argument is an int
function is_int(){
    re='^[0-9]+$'
    if [[ $1 =~ $re ]]
    then
        # number given
        return 0
    else
        ## not a number
        return 1
    fi
}

function create_fileTemplate() {
    fullpath=$1

    echo "Work Times For $USER" > $fullpath
    echo "File created on `date`" >> $fullpath
    echo >> $fullpath
    echo Day,Month,Year,Hours Worked, Entry,Exit,Entry,Exit,Entry,Exit,Entry,Exit, Entry,Exit,Entry,Exit,Entry,Exit,Entry,Exit,Entry,Exit,Entry,Exit >> $fullpath
}

function count_numFields() {
    lastline=$1

    nxt_field=`echo  $lastline | cut -d "," -f1`
    num_fields=0 
    
    while [ -n "$nxt_field" ]
    do
        let "num_fields=$num_fields+1"
        let "field_index=$num_fields+1"

        nxt_field=`echo  $lastline | cut -d "," -f $field_index`

    done
}

function create_backup() {
    fullpath=$1
    folder=$2
    filename=$3  

    cp $fullpath $folder/.$filename.BACKUP
}

function init_entry {
    fullpath=$1
    folder=$2
    filename=$3  

    #new line needs to be added
    echo >> $fullpath
    echo -n `date +%d`,`date +%m`,`date +%Y`>> $fullpath 
    #the formula
    numline=`wc -l < $fullpath`
    let "numline = $numline + 1" 
    formula="=((F$numline-E$numline)+(H$numline-G$numline)+(J$numline - I$numline)+(L$numline - K$numline)+(N$numline - M$numline)+(P$numline-O$numline)+(R$numline-Q$numline)+(T$numline-S$numline)+(V$numline-U$numline)+(X$numline-W$numline)+(Z$numline-Y$numline))*24"
    echo -n ,$formula >> $fullpath 
    create_backup $fullpath $folder $filename
}

function punch_in() {
    lastline=$1
    lastline_day=$2
    lastline_month=$3
    lastline_year=$4
    fullpath=$5
    folder=$2
    filename=$3  

    # echo $lastline
    count_numFields $lastline
    if [ "$lastline_day" == "Day" ]
    then 
        init_entry $fullpath $folder $filename
        echo -n ,`date +%R` >> $fullpath && echo "Your have successfully punched in. Remember to punch out when you are done." && echo "Punch in time: `date +%R`"
        exit
    elif [ "$lastline_day" -ne `date +%d` ] || [ "$lastline_month" -ne `date +%m` ] || [ "$lastline_year" -ne `date +%Y` ]
    then
    #the last line was not today's date so create today's date
        init_entry $fullpath $folder $filename
        echo -n ,`date +%R` >> $fullpath && echo "Your have successfully punched in. Remember to punch out when you are done." && echo "Punch in time: `date +%R`"
        exit
    elif ! [ $((num_fields%2)) -eq 0 ]
    then
    #checks to see if there has been no previous entry before attempt to re-enter
    #odd num_fields
        echo "You have already punched in."
        exit 1
    else
    #there is no previous entry
        echo -n ,`date +%R` >> $fullpath && echo "Your have successfully re-punched in. Remember to punch out when you are done." && echo "Punch in time: `date +%R`"
        exit
    fi

}

function punch_out {
    lastline=$1
    lastline_day=$2
    lastline_month=$3
    lastline_year=$4
    fullpath=$5

    #checks to see if there has been no sign in for today
    # echo $lastline
    count_numFields $last_line
    if [ "$lastline_day" == "Day" ]
    then 
        echo "You must punch in before punching out."
        exit 2
    elif [ "$lastline_day" -ne `date +%d` ] || [ "$lastline_month" -ne `date +%m` ] || [ "$lastline_year" -ne `date +%Y` ]
    then
        echo "You must punch in before punching out."
        exit 2
    
    elif [ $((num_fields%2)) -eq 0 ]
    then
    #checks to see if there is no exit already recorded
    #there has is no exit recorded when the num_fields are even
        echo "You have already punched out."
        exit 2
    else
        echo -n ,`date +%R` >> $fullpath && echo "You have successfully punched out." && echo "Punch out time: `date +%R`"
        exit
    fi    
}

function remote_punch {
    if [ "$lastline_day" == "Day" ]
    then 
        init_entry
    elif [ "$lastline_day" -ne `date +%d` ] || [ "$lastline_month" -ne `date +%m` ] || [ "$lastline_year" -ne `date +%Y` ]
    then
        init_entry
    fi

    read -p "Enter time in hh:mm format: " remote_time
    echo -n ,$remote_time >> $fullpath && echo "Remote punch successful."
    exit
     
}

function output_hours_worked {
    echo "Showing record for: $lastline_day.$lastline_month.$lastline_year"
    echo "Hours worked: `cat $fullpath | tail -1 | cut -d "," -f4`"
    exit
}   


function output_todays_record {
    #echo $lastline
    #echo $lastline_day $lastline_month $lastline_year
    if [ "$lastline_day" == "Day" ]
    then
        echo "There is no record for today yet."
        exit

    elif [ "$lastline_day" -ne `date +%d` ] || [ "$lastline_month" -ne `date +%m` ] || [ "$lastline_year" -ne `date +%Y` ]
    then
        
        echo "There is no record for today yet."
        exit
    else

        #output today's record
        echo "Showing record for: $lastline_day.$lastline_month.$lastline_year"


        field_index=5 
        nxt_field=`echo  $lastline | cut -d "," -f $field_index`

        while [ -n "$nxt_field" ]
        do
            if [ $((field_index%2)) -eq 0 ]
            then
                echo "Exit: $nxt_field"
            else
                echo "Entry: $nxt_field"
            fi

            let "field_index=$field_index+1"
            nxt_field=`echo  $lastline | cut -d "," -f $field_index`

        done
    fi
}


function menu {
    lastline=$1
    lastline_day=$2
    lastline_month=$3
    lastline_year=$4
    fullpath=$5

    echo "#### PUNCH PUNCH PUNCH PUNCH"
    echo "(1) Punch in"
    echo "(2) Punch out"
    echo "(3) Remote Punch"
    echo "(4) See today's times"
    echo "(5) Hours Worked Today"
    echo "(6) Quit"
    read -p "Enter option: " option


    case $option in 
        1)
            punch_in $lastline $lastline_day $lastline_month $lastline_year $fullpath $folder $filename
            ;;
        2)
            punch_out
            ;;
        3)
            remote_punch
            ;;
        4)
            output_todays_record
            ;;    
        5)
            output_hours_worked
            ;;
        
        6)
            exit
            ;; 
        *)
            echo wrong
            sleep 3
            menu
    esac
}

function create_fullpath_if_empty {
    folder=$1
    fullpath=$2    

    #if the directory does not exist create it
    if ! [[ -d $folder ]]
    then

        mkdir $folder
        create_fileTemplate $fullpath
    elif ! [[ -f $fullpath ]]
    then
    #if the file does not exist create it
        create_fileTemplate $fullpath
    fi
}


# lets see which file we work with
if is_int $1
then
    # number given
    filename=work_times_$1.xlsx
    punch_cmd=$2
else
    ## not a number
    filename=work_times.xlsx
    punch_cmd=$1
fi

folder=~/Producctivity
fullpath=$folder/$filename
echo $filename
echo $fullpath
echo $punch_cmd
echo $0
echo $1
echo $2

create_fullpath_if_empty $folder $fullpath

crnt_date=`date +%F`
lastline=`tail -1 $fullpath`
lastline_day=`echo  $lastline | cut -d "," -f1`
lastline_month=`echo  $lastline | cut -d "," -f2`
lastline_year=`echo  $lastline | cut -d "," -f3`
num_fields=1 


#the direction of program based on the argument sent
case $punch_cmd in 
    "in")
        punch_in $last_line $lastline_day $lastline_month $lastline_year $fullpath $folder $filename
        ;;
    "out")
        punch_out
        ;;
    "see")
        output_todays_record
        ;;
    "rmt")
        remote_punch
        ;;

    "hrs")
        output_hours_worked
        ;;
    *)
        if [[ $1 == $punch_cmd ]]
        then
            echo "#### PUNCH PUNCH PUNCH PUNCH"
            echo "For default file, input nothing or any value not an int"
            read -p "Enter file number: " file_number

            if is_number $file_number
            then
                filename=work_times_$file_number.xlsx
            else
                ## not a number
                filename=work_times.xlsx
            fi

            fullpath=$folder/$filename
            create_fullpath_if_empty
        fi
        menu $lastline $lastline_day $lastline_month $lastline_year $fullpath
esac

