/* Starting Timestamp */
%put Job Started Execution at %sysfunc(time(),timeampm.) on %sysfunc(date(),worddate.).;

/* Code */
data foo;
	set foobar;
run;

%put This should should throw an error.;

/* Ending Timestamp */
%put Job Ended Execution at %sysfunc(time(),timeampm.) on %sysfunc(date(),worddate.).;
