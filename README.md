# Punch

This program is designed to create an easy way to record and track the hours one stays productive. You can punch in and punch out, and the program will then echo the current time to a spreadsheet under Productivity. 

One can only punch in and out as many times as they would like. 
The script works with a text based menu as well as with arguments.

The spreadsheet is kept under ~/Productivity under the name work_times.xlsx. If the file or the directory is not present, it will make these files upon running the script, and it will initialise them with a basic header. 

## Sample User Interface
### Main Menu
```
#### PUNCH PUNCH PUNCH PUNCH
(1) Punch in
(2) Punch [out](out)
(3) Remote Punch
(4) See today's times
(5) Hours Worked Today
(6) Quit
Enter option: 1
You have already punched in.
```

### Punch With Arguments
```
$ punch in
Your have successfully re-punched in. Remember to punch out when you are done.
Punch in time: 20:39

```

### Punch See
```
$ punch see
Showing record for: 21.01.2021
Entry: 10:32
Exit: 12:28
Entry: 12:48
Exit: 12:49
Entry: 13:01
Exit: 14:42
Entry: 14:42
Exit: 14:44
Entry: 15:23
Exit: 16:08
Entry: 16:08
Exit: 16:18
Entry: 16:55
Exit: 18:37
Entry: 18:38
Exit: 19:33
Entry: 20:35
```


## Important
The script is limited to only echoing text to the spreadsheet. As a result any changes to the last line of the spreadsheet by the user outside of the script could result in the script crashing. 

The user should refrain from doing so, but instead use the remote punch feature. 

The spreadsheet can be modified on all other lines except for the last line. 

## Back Up
There is a hidden back up spreadsheet created on every new day of punch.

