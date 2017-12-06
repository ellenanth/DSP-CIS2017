%%test 1
%settings
OOK_on = false;

%run transmit_pic
transmit_pic;

%pause between experiments
pause on;
pause;

%%test 2
%settings
BWusage = 50;
OOK_on = true;

%run transmit_pic
transmit_pic;