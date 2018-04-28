#!/usr/bin/awk -f

function seconds(time){
	split(time,a,":");
	s=a[1]*3600+a[2]*60+a[3];
	return s;
}

BEGIN { isfirstline=1;
		colorder[""]=0;
		user["0"]="0";
		processes["0"]=0;
		noofprocesses["0"]=0;
		threads["0"]=0;
		cpu["0"]=0;
		memory["0"]=0;
}

{
	if (isfirstline>0){
		colorder[$1]=1;
		colorder[$2]=2;
		colorder[$3]=3;
		colorder[$4]=4;
		colorder[$5]=5;
		colorder[$6]=6;
		colorder[$7]=7;
		colorder[$8]=8;
		isfirstline=0;
	}
	else{
		if ($colorder["USER"] in user){
			threads[$colorder["USER"]]+=1;
			cpu[$colorder["USER"]]+=seconds($colorder["TIME"]);
			if (($colorder["USER"]"@"$colorder["PID"]) in processes){
				isfirstline=0;
			} else {
				memory[$colorder["USER"]]+=$colorder["SZ"];
				noofprocesses[$colorder["USER"]]+=1;
			}
			processes[$colorder["USER"]"@"$colorder["PID"]]=0;
		}
		else {
			user[$colorder["USER"]]=$colorder["USER"];
			processes[$colorder["USER"]"@"$colorder["PID"]]=0;
			threads[$colorder["USER"]]=1;
			cpu[$colorder["USER"]]=seconds($colorder["TIME"]);
			memory[$colorder["USER"]]=$colorder["SZ"];
			noofprocesses[$colorder["USER"]]=1;
		}
	}
}

END {
	for (usr in user){
		if (usr == "0"){
			continue;
		}
		print "USER: ",usr;
		print "No of Processes: ",noofprocesses[usr];
		print "No of Threads: ",threads[usr];
		print "CPU Usage: ",cpu[usr];
		print "Memory Usage: ",memory[usr];
		print "========================================";
	}
}