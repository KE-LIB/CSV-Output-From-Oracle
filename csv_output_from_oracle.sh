#!/bin/bash

	targetfile="/path/to/target/file/filename_$(date +'%Y%m%d').csv" #filename contains current date
	month=$(date +'%m') #current month
	semester="'YYYY/YY/S'" #current semster

	############################################
	# REQUIRED VARAIBLE: $month
	# EFFECT: $semester (adding value to a variable) 
	# DESCRIPTION: calculate current semester
	############################################
	if [ $month == "08" ] || [ $month == "09" ] || [ $month == "10" ] || [ $month == "11" ] || [ $month == "12" ] || [ $month == "01" ]; then
		semester="'"$(date +%Y)"/"$(echo $(date +%Y -d "+1 years")| cut -d'0' -f 2)"/1'"
	fi
	if [ $month == "02" ] || [ $month == "03" ] || [ $month == "04" ] || [ $month == "05" ] || [ $month == "06" ] || [ $month == "07" ]; then
			semester="'"$(date +%Y -d "-1 years")"/"$(echo $(date +%Y)| cut -d'0' -f 2)"/2'"
	fi

	############################################
	# REQUIRED VARAIBLE: $semester, $day
	# EFFECT: $sql (adding value to a variable) 
	# DESCRIPTION: Oracle sql query 
	############################################
	sql="COLUMN Col1 FORMAT A<num> SELECT OrigCol1 AS Col1 FROM table WHERE conditions"

	############################################
	# REQUIRED VARAIBLE: $sql, $targetfile 
	# EFFECT: $targetfile (create file and saving content) 
	# DESCRIPTION: start oracle session and run $sql
	############################################
	sqlplus -s user/password << EOF
	set echo off
	set pause off
	set heading off
	set colsep ";"
	set linesize 32767
	set trimspool on
	set wrap off
	set termout off
	set feedback off
	set pagesize 0
	spool $targetfile
	$sql
	spool off
	exit
EOF

	############################################
	# REQUIRED VARAIBLE: $targetfile 
	# EFFECT: $targetfile (read and write file) 
	# DESCRIPTION: some replace
	############################################
	sed -i 's/#\(a\|b\|c\)#/ALPHABET-/g' "$targetfile";
	#delete space caracters from columns
	sed -i 's/[ ]*;/;/g' "$targetfile";
	sed -i 's/;[ ]*/;/g' "$targetfile";
	#add header to first line
	sed -i -e '1iHEADER1;HEADER2;HEADER3\' $targetfile;
	#iconv -f UTF8 -t ISO88592 $targetfile > "ISO88592_$targetfile";
