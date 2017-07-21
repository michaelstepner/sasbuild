/* Starting Timestamp */
%put Job Started Execution at %sysfunc(time(),timeampm.) on %sysfunc(date(),worddate.).;
 
/* Code */
%put First file;

/* Ending Timestamp */
%put Job Ended Execution at %sysfunc(time(),timeampm.) on %sysfunc(date(),worddate.).;
