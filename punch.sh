#!/bin/bash

crnt_date=`date +%F`
#checks to see if there has already been a punch in recorded
lastline=`tail -1 ~/Productivity/work_times.xlsx`
lastline_day=`echo  $lastline | cut -d "," -f1`
lastline_month=`echo  $lastline | cut -d "," -f2`
lastline_year=`echo  $lastline | cut -d "," -f3`



function punch_in {
clear
    if [ $lastline_day == `date +%d` ] && [ $lastline_month == `date +%m` ] && [ $lastline_year == `date +%Y` ]
    then
        echo "You have already punched in at `echo  $lastline | cut -d "," -f4`. You will be redirected shortly. "
        echo -n "Press enter to go back to menu "
        read x
        menu
    else
        echo `date +%d`,`date +%m`,`date +%Y`,`date +%R` >> ~/Productivity/work_times.xlsx
        echo "Your have punched in. Remember to punch out when you are done."
        echo "Punch in time: `date +%R`"
        exit
    fi
}

function punch_out {
    
    if ! [[ -f ~/.$crnt_date ]]
    then
        echo "You must punch in before punching out."
        echo -n "Press enter to go back to menu "
        read x
        menu
    fi

    

    
}

function output_hours_worked {
    echo hi
    
}

function goto_break {
    echo hi

}

function menu {
    clear
    echo "#### PUNCH PUNCH PUNCH PUNCH"
    echo "(1) Punch in"
    echo "(2) Punch out"
    echo "(3) Break"
    echo "(4) Quit"
    echo -n "Enter option: "
    read option


    case $option in 
        1)
            punch_in
            ;;
        2)
            punch_out
            ;;
        3)
            goto_break
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

function create_fileTemplate {
    echo "Work Times For $USER" > ~/Productivity/work_times.xlsx
    echo "File created on `date`" >> ~/Productivity/work_times.xlsx
    echo >> ~/Productivity/work_times.xlsx
    echo Day,Month,Year,Entry,Exit,Entry,Exit,Entry,Exit,Entry,Exit,Entry,Exit >> ~/Productivity/work_times.xlsx
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

menu

