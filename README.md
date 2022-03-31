# Phonebook 2.0 for KIM-1

original title: "Datensuche" <br>
by Herwig Feichtinger <br>
(c) 1981 in Anwendungsbeispiele<br>
    für den Mikroprozessor 6502

Advanced Version of https://github.com/netzherpes/phonebook-for-KIM-1

# Instructions:

Prepare a first Data Entry <br>
at $0201 by Hand! <br>
0201 0D<br>
0202 3E<br>
0203 00<br>

The Program saves the Data on tape,
so this needs to be initialized once.

Start the program at $0000<br>
After the start you are in search mode.

SEARCH: Enter a keyword and whole matching 
Lines of text will be presented. 

SWITCH to entry mode by pressing ESC
After you added or changed an entry you

CHANGE a line: Switch to data entry mode (ESC) 
and enter an identifying text to change,
press 'Enter' and insert a new Data Entry. 

An * indicates, that the Line was deleted

ADD an entry: Switch to data entry mode (ESC) 
and type '>'  and 'enter'. Then add a new line.
Background: the last Byte of your 
Data File is a '>'. 
It will be deleted, an Entry added 
and a '>' will be added again to 
indicate the new end of the File.

To get back to SEARCH mode hit ESC again

LOAD a File with ~P where P is a 
indicator for your File, as you can 
save more than one files on one tape.

SAVE a File with ^P 

