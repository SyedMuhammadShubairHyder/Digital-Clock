INCLUDE Irvine32.inc
INCLUDELIB user32.lib
GetAsyncKeyState PROTO STDCALL :DWORD

.data

consoleWidth DWORD 80
consoleHeight DWORD 25
circleHeight DWORD 14
menuHeight DWORD 9
totalHeight DWORD 23

; Define data for the alarm feature
alarmTimeSet BYTE "Alarm time set to: ", 0
alarmPromptHour BYTE "Enter Alarm Hour (0-23): ", 0
alarmPromptMin BYTE "Enter Alarm Minute (0-59): ", 0
alarmPromptSec BYTE "Enter Alarm Second (0-59): ", 0
alarmMsg BYTE "ALARM! Time's up!", 0
alarmStopMsg BYTE "Press any key to stop the alarm.", 0
alarmHour DWORD 0
alarmMin DWORD 0
alarmSec DWORD 0



ctime byte " - Current Time: ",0
circleLine1 BYTE " ***** ", 0
circleLine2 BYTE " ** ** ", 0
circleLine3 BYTE " * * ", 0
circleLine4 BYTE " * * ", 0
circleLine5 BYTE " * * ", 0
circleLine6 BYTE " * * ", 0
circleLine7 BYTE "* *", 0
circleLine8 BYTE "* *", 0
circleLine9 BYTE " * * ", 0
circleLine10 BYTE " * * ", 0
circleLine11 BYTE " * * ", 0
circleLine12 BYTE " * * ", 0
circleLine13 BYTE " ** ** ", 0
circleLine14 BYTE " ***** ", 0

menuTitle BYTE " Digital Clock Menu ", 0
border BYTE "==============================", 0
menuOption1 BYTE "1. Display Current Time", 0
menuOption2 BYTE "2. Timer", 0
menuOption3 BYTE "3. Stopwatch", 0
menuOption4 BYTE "4. Alarm Clock", 0
menuOption5 BYTE "5. Exit", 0

prompt BYTE " --> Choose an option: ", 0
invalidInput BYTE "Invalid choice. Please enter a number between 1 and 5.", 0

timerInputHour BYTE "Enter Timer Hour: ", 0
timerInputMin BYTE "Enter Timer Minute: ", 0
timerInputSec BYTE "Enter Timer Second: ", 0
timerStarted BYTE "Timer started... Countdown begins.", 0
delayTime DWORD 300
hour DWORD 0
min DWORD 0
sec DWORD 0
colon BYTE ':', 0
msg BYTE "Time Has Been Stopped", 0
msgStart BYTE "Enter S to Stop Time", 0
stopwatchMsgStart BYTE "Stopwatch started... Press S to stop.", 0

sysTime SYSTEMTIME <>
currhour DWORD ?
currmin DWORD ?
currsec DWORD ?

.code

main PROC
START:
    call ClrScr

    mov eax, consoleHeight
    sub eax, totalHeight
    shr eax, 1
    mov ecx, eax

printPadding:
    cmp ecx, 0
    je displayContent
    call Crlf
    dec ecx
    jmp printPadding

displayContent:
    mov eax, 2
    call SetTextColor

    mov edx, OFFSET circleLine1
    call CenterPrint

    mov edx, OFFSET circleLine2
    call CenterPrint

    mov edx, OFFSET circleLine3
    call CenterPrint

    mov edx, OFFSET circleLine4
    call CenterPrint

    mov edx, OFFSET circleLine5
    call CenterPrint

    mov edx, OFFSET circleLine6
    call CenterPrint

    mov eax, 14
    call SetTextColor

    mov edx, OFFSET menuTitle
    call CenterPrint

    mov edx, OFFSET border
    call CenterPrint

    mov edx, OFFSET menuOption1
    call CenterPrint

    mov edx, OFFSET menuOption2
    call CenterPrint

    mov edx, OFFSET menuOption3
    call CenterPrint

    mov edx, OFFSET menuOption4
    call CenterPrint

    mov edx, OFFSET menuOption5
    call CenterPrint

    mov edx, OFFSET border
    call CenterPrint

    mov eax, 2
    call SetTextColor

    mov edx, OFFSET circleLine7
    call CenterPrint

    mov edx, OFFSET circleLine8
    call CenterPrint

    mov edx, OFFSET circleLine9
    call CenterPrint

    mov edx, OFFSET circleLine10
    call CenterPrint

    mov edx, OFFSET circleLine11
    call CenterPrint

    mov edx, OFFSET circleLine12
    call CenterPrint

    mov edx, OFFSET circleLine13
    call CenterPrint

    mov edx, OFFSET circleLine14
    call CenterPrint

    

    mov eax,14
    call settextcolor
    mov edx, OFFSET prompt
    call WriteString

    call ReadChar
    call WriteChar
    call Crlf

    cmp al, '1'
    je fetchtime
    cmp al, '2'
    je TIMER
    cmp al, '3'
    je STOPWATCH
    cmp al, '4'
    je ALARM_CLOCK
    cmp al, '5'
    je ExitProgram
    mov edx, OFFSET invalidInput
    call CenterPrint
    jmp main

ExitProgram:
    mov eax, 0
    call ExitProcess

ALARM_CLOCK PROC
    ; Set the alarm time
    mov edx, OFFSET alarmPromptHour
    call WriteString
    call ReadInt
    mov alarmHour, eax

    mov edx, OFFSET alarmPromptMin
    call WriteString
    call ReadInt
    mov alarmMin, eax

    mov edx, OFFSET alarmPromptSec
    call WriteString
    call ReadInt
    mov alarmSec, eax

    ; Display alarm time set message
    mov edx, OFFSET alarmTimeSet
    call WriteString
    mov eax, alarmHour
    call WriteDec
    mov edx, OFFSET colon
    call WriteString
    mov eax, alarmMin
    call WriteDec
    mov edx, OFFSET colon
    call WriteString
    mov eax, alarmSec
    call WriteDec
    call Crlf

    ; Loop to check if it's the alarm time
checkAlarm:
    ; Get current system time
    call currtime

    ; Compare current time with alarm time
    mov eax , currhour
    cmp eax, alarmHour
    jne continueChecking
    mov eax , currmin
    cmp eax , alarmMin
    jne continueChecking
    cmp eax , currsec
    cmp eax , alarmSec
    jne continueChecking

    ; If time matches, show alarm message
    mov edx, OFFSET alarmMsg
    call WriteString
    call Crlf
    mov edx, OFFSET alarmStopMsg
    call WriteString
    call Crlf

    ; Wait for user to press any key to stop the alarm
    call ReadChar
    call WriteChar
    call Crlf

    ; Return to main menu after stopping alarm
    jmp main

continueChecking:
    ; Wait for a small delay and check again
    mov eax, delayTime
    call Delay
    jmp checkAlarm

ALARM_CLOCK ENDP


CenterPrint PROC
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, 0
    mov edi, edx
countLoop:
    mov al, [edi + ecx]
    cmp al, 0
    je lengthCalculated
    inc ecx
    jmp countLoop

lengthCalculated:
    mov eax, consoleWidth
    sub eax, ecx
    shr eax, 1
    mov ebx, eax

printSpaces:
    cmp ebx, 0
    je printString
    mov al, ' '
    call WriteChar
    dec ebx
    jmp printSpaces

printString:
    mov edx, edi
    call WriteString
    call Crlf

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
CenterPrint ENDP

fetchtime PROC
    call currtime
    call printtime
   
    ret
fetchtime ENDP

currtime PROC
    lea eax, sysTime
    push eax
    call GetSystemTime
    add esp, 4

    movzx eax, sysTime.wHour
    mov currhour, eax

    movzx eax, sysTime.wMinute
    mov currmin, eax

    movzx eax, sysTime.wSecond
    mov currsec, eax

    call crlf
    ret
currtime ENDP

printtime PROC

    mov eax,2
     call settextcolor
     call crlf
     call crlf
    mov edx,offset ctime
    call writestring
    mov eax, currhour
    add eax, 5
    call WriteDec

    mov edx, OFFSET colon
    call WriteString

    mov eax, currmin
    call WriteDec

    mov edx, OFFSET colon
    call WriteString

    mov eax, currsec
    call WriteDec
    call Crlf
    call crlf
   
    call waitmsg
    JMP main
    ret
printtime ENDP

; Timer Procedure
TIMER PROC
    mov edx, OFFSET timerInputHour
    call WriteString
    call ReadInt
    mov hour, eax

    mov edx, OFFSET timerInputMin
    call WriteString
    call ReadInt
    mov min, eax

    mov edx, OFFSET timerInputSec
    call WriteString
    call ReadInt
    mov sec, eax

    mov edx, OFFSET timerStarted
    call WriteString

countLoop:
    call ClrScr

    mov eax,2
    call settextcolor


    mov eax, hour
    mov edx, 0
    mov ecx, 10
    div ecx
    call WriteDec
    mov eax, edx
    call WriteDec
    mov edx, OFFSET colon
    call WriteString

    mov eax, min
    mov edx, 0
    mov ecx, 10
    div ecx
    call WriteDec
    mov eax, edx
    call WriteDec
    mov edx, OFFSET colon
    call WriteString

    mov eax, sec
    mov edx, 0
    mov ecx, 10
    div ecx
    call WriteDec
    mov eax, edx
    call WriteDec
    call Crlf

    cmp hour, 0
    jne continueLoop
    cmp min, 0
    jne continueLoop
    cmp sec, 0
    jne continueLoop
    JMP main
    ret

continueLoop:
    cmp sec, 0
    jne decrementSeconds
    mov sec, 59
    cmp min, 0
    jne decrementMinutes
    mov min, 59
    dec hour

decrementMinutes:
    dec min
    jmp decrementSeconds

decrementSeconds:
    dec sec

    mov eax, delayTime
    call Delay
    jmp countLoop

TIMER ENDP

; Stopwatch Procedure
STOPWATCH PROC
    mov edx, OFFSET stopwatchMsgStart
    call WriteString
countLoopStopwatch:
    call ClrScr

    mov eax, hour
    mov edx, 0
    mov ecx, 10
    div ecx
    call WriteDec
    mov eax, edx
    call WriteDec
    mov edx, OFFSET colon
    call WriteString

    mov eax, min
    mov edx, 0
    mov ecx, 10
    div ecx
    call WriteDec
    mov eax, edx
    call WriteDec
    mov edx, OFFSET colon
    call WriteString

    mov eax, sec
    mov edx, 0
    mov ecx, 10
    div ecx
    call WriteDec
    mov eax, edx
    call WriteDec
    call Crlf

    cmp sec, 59
    jne continueStopwatch
    mov sec, 0
    inc min
    cmp min, 60
    jne continueStopwatch
    mov min, 0
    inc hour

continueStopwatch:
    mov eax, delayTime
    call Delay
    inc sec

    invoke GetAsyncKeyState, 'S'
    test eax, eax
    jz notPressed

    mov edx, OFFSET msg
    call WriteString
    call Crlf
    mov eax, hour
    call WriteDec
    mov edx, OFFSET colon
    call WriteString
    mov eax, min
    call WriteDec
    call WriteString
    mov eax, sec
    call WriteDec
    call Crlf

    mov ecx, 3
printStopwatchTime:
    mov eax, delayTime
    call Delay
    call Delay
    loop printStopwatchTime

    JMP main
    ret
notPressed:
    jmp countLoopStopwatch

STOPWATCH ENDP

goout:

main ENDP
END main
