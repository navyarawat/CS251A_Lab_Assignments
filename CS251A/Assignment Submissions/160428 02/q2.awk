#!/usr/bin/awk -f

function reverseip(string){
	split(string,string1,"-->")
	return (string1[2] "-->" string1[1])
}

function agb(str1,str2){
	split(str1,x1,":")
	split(str2,x2,":")
	if(x1[1]<x2[1])
		return 0
	if(x1[2]<x2[2])
		return 0
	if(x1[3]<x2[3])
		return 0
	return 1
}

function subtract(ts1,ts2){
	split(ts1,y1,":")
	split(ts2,y2,":")
	ax=y1[1]-y2[1]
	bx=y1[2]-y2[2]
	cx=y1[3]-y2[3]
	dx=ax*3600+bx*60+cx
	return dx
}

BEGIN { ipport[0]=0;
		packets[0]=0;datapackets[0]=0;data[0]=0
		maxts[0]=0;mints[0]=0
		isprinted[0]=0
}

{ transfer=($3 "-->" substr($5,1,length($5)-1))
split($0,a," ")
datasize=a[length(a)]
if (transfer in ipport) {
	packets[transfer]+=1
	if (datasize>0)
		datapackets[transfer]+=1
	data[transfer]+=datasize
	if(agb($1,maxts[transfer])==1)
		maxts[transfer]=$1
	if(agb(mints[transfer],$1)==1)
		maxts[transfer]=$1
} else {
	ipport[transfer]=transfer
	packets[transfer]=1
	if (datasize>0)
		datapackets[transfer]=1
	else
		datapackets[transfer]=0
	data[transfer]=datasize
	maxts[transfer]=$1; mints[transfer]=$1
	isprinted[transfer]=0
}
}

END {
	for (i in ipport)
	if(i!=0){
		if(isprinted[i]==1)
			continue
		s1=reverseip(i)
		isprinted[s1]=1

		split(i,s2,".")
		s3=(s2[1] "." s2[2] "." s2[3] "." s2[4])
		split(s1,s4,".")
		s5=(s4[1] "." s4[2] "." s4[3] "." s4[4])

		split(s2[5],s6,"-->")
		split(s4[5],s7,"-->")

		s8=0
		if(agb(maxts[i],maxts[s1])==1)
			s8=maxts[i]
		else
			s8=maxts[s1]
		s9=0
		if(agb(mints[i],mints[s1])==1)
			s9=mints[s1]
		else
			s9=mints[i]
		s10=subtract(s8,s9)
		print "Connection (A=" s3 ":" s6[1] " B=" s5 ":" s7[1] ")"
		printf "A-->B #packets=%d, #datapackets=%d, #bytes=%d, #retrans=0 xput=%d bytes/sec\n",packets[i],datapackets[i],data[i],int(data[i]/s10)
		printf "A-->B #packets=%d, #datapackets=%d, #bytes=%d, #retrans=0 xput=%d bytes/sec\n",packets[s1],datapackets[s1],data[s1],int(data[s1]/s10)
}
}