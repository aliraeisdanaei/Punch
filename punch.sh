#!/bin/bash

crnt_date=`date +%F`

function punch_in {
    #checks to see no file for today's information in home dir
    if [[ -f ~/.$crnt_date ]]
    then
        echo "Already punched in at `cat ~/.$crnt_date | head -1`. Will be redirected shortly. "
        echo -n "Press enter to go back to menu "
        read x
        menu
    fi

    clear
    echo `date +%R` > ~/.$crnt_date
    echo `date +%R`
    echo "Your have punched in. Remember to punch out when you are done."
    echo -n "Press enter to exit "
    read x
    exit
}

function punch_out {
    echo hi
    
}

function output_hours_worked {
    echo hi
    
}

function break {
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
            echo hello
            ;;
        3)
            echo inn
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


menu

