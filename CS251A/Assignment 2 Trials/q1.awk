#!/usr/bin/awk -f
BEGIN {count1=0;count2=0;flag=0;temp=0;line=1}

{gsub(/"[^"]*"/,"\"\"")}
/\/\*/ {flag=1}
{if(flag==0)count2+=gsub(/\/\*.*\*\//,"\/\*\*\/")}
{if(flag==0)count2+=gsub(/\/\/.*/,"\/\/")}
{if(flag==1)temp++}
{if(flag==0)count1+=gsub(/""/,"\"\"")}
/\*\// {flag=0;count2+=temp;temp=0}
/"".*\/\*/ {count1++}
#{print}
#{print "\t" line ". count1= " count1 " count2= " count2}
{line++}
END {print count1 " " count2}