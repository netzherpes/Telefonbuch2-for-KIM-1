# Telefonbuch2-for-KIM-1
Telefonbuch 2.0<br>
by Herwig Feichtinger <br>
(c) 1981 in Anwendungsbeispiele<br>
    für den Mikroprozessor 6502

# Instructions:

Prepare a first Data Entry <br>
at $0201 by Hand! <br>
0201 0D<br>
0202 3E<br>
0203 00<br>

The Program saves the Data on tape,
so this needs to be initialized once.

Start the program at $0000
After the start you are in search mode.
Enter a keyword and whole matching 
Lines of text will be presented. 

To change or add an entry press ESC
change a line: Enter the identifying 
text to change, press Enter and 
insert a new Data Entry. 

To add an entry Type >  and enter 
(after the ESC). Background: the last
Byte of your Data File is a '>'. 
It will be deleted, an Entry added 
and a '>' will be added again to 
indicate the new end of the File.

LOAD a File with ~P where P is a 
indicator for your File, as you can 
save more than one files on one tape.

SAVE a File with ^P 

