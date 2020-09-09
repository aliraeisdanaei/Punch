#!/bin/bash

function create_fileTemplate {
    echo "Work Times For $USER" > ~/Productivity/work_times.xlsx
    echo "File created on `date`" >> ~/Productivity/work_times.xlsx
    echo >> ~/Productivity/work_times.xlsx
    echo Day,Month,Year,Hours Worked, Entry,Exit,Entry,Exit,Entry,Exit,Entry,Exit,Entry,Exit >> ~/Productivity/work_times.xlsx
}

#if the directory does not exist create it
if ! [[ -d ~/Productivity ]]
then

    mkdir ~/Productivity
    create_fileTemplate
elif ! [[ -f ~/Productivity/work_times.xlsx ]]
then
#if the file does not exist create it
    create_fileTemplate
fi

crnt_date=`date +%F`
lastline=`tail -1 ~/Productivity/work_times.xlsx`
lastline_day=`echo  $lastline | cut -d "," -f1`
lastline_month=`echo  $lastline | cut -d "," -f2`
lastline_year=`echo  $lastline | cut -d "," -f3`
num_commas=`echo $lastline| tr -cd , | wc -c`


function punch_in {
    if [ "$lastline_day" != `date +%d` ] || [ "$lastline_month" != `date +%m` ] || [ "$lastline_year" != `date +%Y` ]
    then
    #the last line was not today's date so create today's date
        echo -n `date +%d`,`date +%m`,`date +%Y`>> ~/Productivity/work_times.xlsx
        
        #the formula
        numline=`wc -l < ~/Productivity/work_times.xlsx`
        let "numline = $numline + 1" 
        formula="=((F$numline-E$numline)+(H$numline-G$numline)+(J$numline - I$numline)+(L$numline - K$numline)+(N$numline - M$numline))*24"
        echo -n ,$formula >> ~/Productivity/work_times.xlsx

        echo -n ,`date +%R` >> ~/Productivity/work_times.xlsx && echo "Your have successfully punched in. Remember to punch out when you are done." && echo "Punch in time: `date +%R`"
        exit 
    elif [ $((num_commas%2)) -eq 0 ]
    then
    #checks to see if there has been no previous entry before attempt to re-enter
    #even num_commas
        echo "You have already punched in."
        exit 1
    else
    #there is no previous entry
        echo -n ,`date +%R` >> ~/Productivity/work_times.xlsx && echo "Your have successfully re-punched in. Remember to punch out when you are done." && echo "Punch in time: `date +%R`"
        exit
    fi

}

function punch_out {
    #checks to see if there has been no sign in for today
    if [ "$lastline_day" != `date +%d` ] || [ "$lastline_month" != `date +%m` ] || [ "$lastline_year" != `date +%Y` ]
    then
        echo "You must punch in before punching out."
        exit 2
    
    elif ! [ $((num_commas%2)) -eq 0 ]
    then
    #checks to see if there is no exit already recorded
    #there has is no exit recorded when the commas are odd
        echo "You have already punched out."
        exit 2
    else
        echo -n ,`date +%R` >> ~/Productivity/work_times.xlsx && echo "You have successfully punched out." && echo "Punch out time: `date +%R`"
        exit
    fi    
}

function output_hours_worked {
    echo this has not been implemented yet
}


function output_todays_record {
    if [ "$lastline_day" != `date +%d` ] || [ "$lastline_month" != `date +%m` ] || [ "$lastline_year" != `date +%Y` ]
    then
        echo "There is no record for today yet."
        exit
    else
        echo $lastline
    fi
}


function menu {
    clear
    echo "#### PUNCH PUNCH PUNCH PUNCH"
    echo "(1) Punch in"
    echo "(2) Punch out"
    echo "(3) See today's times"
    echo "(4) Quit"
    read -p "Enter option: " option


    case $option in 
        1)
            clear
            punch_in
            ;;
        2)
            clear
            punch_out
            ;;
        3)
            output_todays_record
            ;;
        4)
            clear
            exit
            ;; 
        *)
            echo wrong
            sleep 3
            menu
    esac
}



#the direction of program based on the argument sent
case $1 in 
    "in")
        punch_in
        ;;
    "out")
        punch_out
        ;;
    "see")
        output_todays_record
        ;;
    *)
        menu
esac

