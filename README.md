## PIC Microcontroller Projects: Assembly Language for PIC18F452
Welcome to a comprehensive collection of PIC18F452 projects developed using assembly language. These projects are crafted for implementation with Proteus and MPLAB IDE, utilizing the assembly programming language to provide a detailed understanding of PIC microcontroller functionality.


![PIC18F452-Pin-Description](https://github.com/LatifEmbedded/Pic18f452/assets/155848361/4544c5d6-0aa8-4b1f-9d60-32abe94740c9)


### Materials Required:
- Proteus Software
- MPLAB IDE
- PIC18F452 Microcontroller
- Assembly Programming Language Skills
- 14-segment display
- 7-segment display
- Leds
- Switches
- Bcd/7 segment decoder
- Resistors
- Lcd 16*2

### How to Use:
- Create a New Project:
Initiate a new project in MPLAB IDE, selecting the target platform as PIC18F452.
- Add ASM Source File:
Incorporate the assembly source file containing the code for the specific project within the created project.
- Assemble the Code:
Assemble the code using MPLAB IDE to generate the corresponding hex file, essential for uploading into the PIC18F452 microcontroller.
- Upload Hex File:
Use a suitable programmer or tool to upload the generated hex file into the PIC18F452 microcontroller.
- Simulation Testing:
Thoroughly test the projects in simulations using the Proteus software to ensure reliable and accurate results.
#### Table of Contents:
- Project 1: 7 Segment Display
Display numbers from 00 to 99 with advanced features like clearing the screen and stopping the numbers (similar to a stopwatch). This project utilizes interrupts for enhanced efficiency.

- Project 2: Number Display with Polling
Display numbers using the polling method, although not recommended for modern microcontrollers. Manual incrementation is done through an external button.

- Project 3: Keypad Interfacing
Interface a matrix of switches with a 7-segment display. When a button is pressed, the associated number is displayed on the 7-segment.

- Project 4: Shift LEDs
Shift LEDs one by one from the Least Significant Bit (LSB) to the Most Significant Bit (MSB).

- Project 5: Traffic Light
Using three LEDs (Red = 60 s, Green = 30 s, Yellow = 5 s) and controlling them via the PIC18F452. The timing can be changed by altering the Timer0 value.

- Project 6: ASCII Character Display
This project involves displaying ASCII characters, specifically the alphabet from A to Z, using a 14-segment display. With 26 alphabetic characters in mind, the project incorporates buttons where each button corresponds to two letters, selected by toggling a switch.

- Project 7: Numbers on LCD 16x2
This project uses PIC18F452 and external switches with an LCD 16x2. It uses portb change interrupt where all the switches are connected with the portb pins (RB4-5-6), and each switch corresponds to a specific number that is displayed on the screen.

#### Important Notes:
- Code Modification:
Feel free to modify and improve the code if any issues or bugs are encountered. The projects are open for customization to meet specific requirements.

- Testing and Verification:
It is highly recommended to test the projects in a simulation environment before deploying them onto physical hardware to identify and address potential issues.

- Community Collaboration:
Enhance and optimize the projects? Share your improvements with the community to foster collaboration and the development of more robust PIC microcontroller applications.

- Learning Purpose:
These projects are intended for learning purposes to cover some basic peripherals of the PIC18F452 microcontroller.
