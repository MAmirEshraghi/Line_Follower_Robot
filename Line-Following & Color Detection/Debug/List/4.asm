
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64A
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64A
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _l=R4
	.DEF _l_msb=R5
	.DEF _SpeedR=R7
	.DEF _SpeedL=R6
	.DEF _V=R9
	.DEF _RS=R10
	.DEF _RS_msb=R11
	.DEF _LsenKeyON=R12
	.DEF _LsenKeyON_msb=R13
	.DEF __lcd_x=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x52,0x69,0x67,0x68,0x74,0x3D,0x20,0x25
	.DB  0x64,0x0,0x4C,0x65,0x66,0x74,0x3D,0x20
	.DB  0x25,0x64,0x0,0x53,0x57,0x52,0x3D,0x20
	.DB  0x43,0x61,0x6C,0x52,0x0,0x53,0x57,0x4C
	.DB  0x3D,0x20,0x43,0x61,0x6C,0x4C,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  _0x150
	.DW  _0x0*2+19

	.DW  0x0A
	.DW  _0x150+10
	.DW  _0x0*2+29

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*******************************************************
;Project : Line Follower Robot with ability of Color Detection
;Version : Final
;Date    : 04/12/2015
;Author  : Mohammad Amir Eshraghi
;Company : www.github.com/MAmirEshraghi/Line_Follower_Robot
;Comments: Description and Album available on my GitHub.
;
;Chip type               : ATmega64A
;Program type            : Application
;AVR Core Clock frequency: 16/000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
;#include <mega64a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <stdlib.h>
;#include <stdio.h>
;#include <delay.h>
;#include <alcd.h>
;
;//#define LEDG PORTF.1
;//#define LEDY PORTF.2
;//#define LEDR PORTF.3
;
;#define SWR  PINE.3
;#define SWM  PINE.1
;#define SWL  PINE.2
;
;#define on  1
;#define off 0
;
;#define CW    0
;#define CCW   1
;
;#define In1MotR PORTA.1
;#define In2MotR PORTA.2
;#define In1MotL PORTA.0
;// #define In2MotL PORTF.7
;
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;#define SEN1   (PIND.0^i)
;#define SEN2   (PIND.1^i)
;#define SEN3   (PIND.2^i)
;#define SEN4   (PIND.3^i)
;#define SEN5   (PIND.4^i)
;#define SEN6   (PIND.5^i)
;#define SEN7   (PIND.6^i)
;#define SEN8   (PIND.7^i)
;
;#define SEN9   (PING&0b00000001)    //PING.0
;#define SEN9N  (PING&0b00000000)    //PING.0
;
;#define SEN10  (PING&0b00000010)    //PING.1
;#define SEN10N (PING&0b00000000)    //PING.1
;
;#define SEN11  (PINC.0^i)
;#define SEN12  (PINC.1^i)
;#define SEN13  (PINC.2^i)
;#define SEN14  (PINC.3^i)
;#define SEN15  (PINC.4^i)
;#define SEN16  (PINC.5^i)
;#define SEN17  (PINC.6^i)
;#define SEN18  (PINC.7^i)
;
;#define SEN19  (PING&0b00000100)    //PING.2
;#define SEN19N (PING&0b00000000)    //PING.2
;
;#define SEN20  (PINA.7^i)
;#define SEN21  (PINA.6^i)
;#define SEN22  (PINA.3^i)
;#define SEN23  (PINA.4^i)
;#define SEN24  (PINA.5^i)
;
;#define VolomADC   read_adc(6)
;
;#define adcNumberL read_adc(3);
;#define adcNumberR read_adc(4);
;#define KeySen PORTE.0
;#define N 2
;
;#define SWG (PINF&0b00100000)
;
;//--------------------------------------------------
;
;bit i=0;
;int a[23];
;int l;
;bit DirectionR,DirectionL;
;unsigned char SpeedR,SpeedL;
;
;unsigned char V;
;int RS;
;int LsenKeyON,RsenKeyON,LsenKeyOFF,RsenKeyOFF;
;unsigned int ColorNumL,ColorNumR,ColorCalL,ColorCalR,c,d;
;
;char m[33];
;
;int p;
;//--------------------------------------------------
;
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 006B  {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 006C   static bit K0=0;
; 0000 006D 
; 0000 006E   if ( K0 )
	SBRS R2,3
	RJMP _0x3
; 0000 006F   {
; 0000 0070    TCNT0 = 255 - SpeedR;
	LDI  R30,LOW(255)
	SUB  R30,R7
	OUT  0x32,R30
; 0000 0071    K0=0;
	CLT
	BLD  R2,3
; 0000 0072 
; 0000 0073    if      ( DirectionR ==  CW )
	SBRC R2,1
	RJMP _0x4
; 0000 0074    {
; 0000 0075     In1MotR = 1;
	SBI  0x1B,1
; 0000 0076     In2MotR = 0;
	CBI  0x1B,2
; 0000 0077    }
; 0000 0078    else if ( DirectionR == CCW )
	RJMP _0x9
_0x4:
	SBRS R2,1
	RJMP _0xA
; 0000 0079    {
; 0000 007A     In1MotR = 0;
	CBI  0x1B,1
; 0000 007B     In2MotR = 1;
	SBI  0x1B,2
; 0000 007C    }
; 0000 007D 
; 0000 007E   }
_0xA:
_0x9:
; 0000 007F   else if ( !K0 )
	RJMP _0xF
_0x3:
	SBRC R2,3
	RJMP _0x10
; 0000 0080   {
; 0000 0081    TCNT0=SpeedR;
	OUT  0x32,R7
; 0000 0082    K0=1;
	SET
	BLD  R2,3
; 0000 0083 
; 0000 0084    In1MotR = 0;
	CBI  0x1B,1
; 0000 0085    In2MotR = 0;
	CBI  0x1B,2
; 0000 0086   }
; 0000 0087 
; 0000 0088  }
_0x10:
_0xF:
	RJMP _0x169
; .FEND
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 008A  {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 008B   static bit KP2=0;
; 0000 008C   if(KP2)
	SBRS R2,4
	RJMP _0x15
; 0000 008D   {
; 0000 008E     TCNT2=255-SpeedL;
	LDI  R30,LOW(255)
	SUB  R30,R6
	OUT  0x24,R30
; 0000 008F     KP2=0;
	CLT
	BLD  R2,4
; 0000 0090     if(DirectionL==CW)
	SBRC R2,2
	RJMP _0x16
; 0000 0091     {
; 0000 0092         In1MotL=0;
	CBI  0x1B,0
; 0000 0093         //In2MotL=1;
; 0000 0094         PORTF|=0b10000000;
	LDS  R30,98
	ORI  R30,0x80
	RJMP _0x158
; 0000 0095     }
; 0000 0096     else if(DirectionL==CCW)
_0x16:
	SBRS R2,2
	RJMP _0x1A
; 0000 0097     {
; 0000 0098         In1MotL=1;
	SBI  0x1B,0
; 0000 0099         //In2MotL=0;
; 0000 009A         PORTF&=0b01111111;
	LDS  R30,98
	ANDI R30,0x7F
_0x158:
	STS  98,R30
; 0000 009B     }
; 0000 009C   }
_0x1A:
; 0000 009D   else if(!KP2)
	RJMP _0x1D
_0x15:
	SBRC R2,4
	RJMP _0x1E
; 0000 009E   {
; 0000 009F     TCNT2=SpeedL;
	OUT  0x24,R6
; 0000 00A0     KP2=1;
	SET
	BLD  R2,4
; 0000 00A1 
; 0000 00A2     In1MotL=0;
	CBI  0x1B,0
; 0000 00A3     //In2MotL=0;
; 0000 00A4     PORTF&=0b01111111;
	LDS  R30,98
	ANDI R30,0x7F
	STS  98,R30
; 0000 00A5   }
; 0000 00A6  }
_0x1E:
_0x1D:
_0x169:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;unsigned int read_adc(unsigned char adc_input)
; 0000 00A9 {
_read_adc:
; .FSTART _read_adc
; 0000 00AA ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 00AB // Delay needed for the stabilization of the ADC input voltage
; 0000 00AC delay_us(10);
	__DELAY_USB 53
; 0000 00AD // Start the AD conversion
; 0000 00AE ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 00AF // Wait for the AD conversion to complete
; 0000 00B0 while ((ADCSRA & (1<<ADIF))==0);
_0x21:
	SBIS 0x6,4
	RJMP _0x21
; 0000 00B1 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 00B2 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20C0006
; 0000 00B3 }
; .FEND
;
;void LEDG (char a)
; 0000 00B6  {
_LEDG:
; .FSTART _LEDG
; 0000 00B7        if ( a == 1)PORTF|=0b00000100;
	ST   -Y,R26
;	a -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x24
	LDS  R30,98
	ORI  R30,4
	RJMP _0x159
; 0000 00B8   else if ( a == 0)PORTF&=0b11111011;
_0x24:
	LD   R30,Y
	CPI  R30,0
	BRNE _0x26
	LDS  R30,98
	ANDI R30,0xFB
_0x159:
	STS  98,R30
; 0000 00B9  }
_0x26:
	RJMP _0x20C0006
; .FEND
;void LEDY (char a)
; 0000 00BB  {
_LEDY:
; .FSTART _LEDY
; 0000 00BC        if ( a == 1)PORTF|=0b00000010;
	ST   -Y,R26
;	a -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x27
	LDS  R30,98
	ORI  R30,2
	RJMP _0x15A
; 0000 00BD   else if ( a == 0)PORTF&=0b11111101;
_0x27:
	LD   R30,Y
	CPI  R30,0
	BRNE _0x29
	LDS  R30,98
	ANDI R30,0xFD
_0x15A:
	STS  98,R30
; 0000 00BE  }
_0x29:
	RJMP _0x20C0006
; .FEND
;void LEDR (char a)
; 0000 00C0  {
_LEDR:
; .FSTART _LEDR
; 0000 00C1        if ( a == 1)PORTF|=0b00000001;
	ST   -Y,R26
;	a -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x2A
	LDS  R30,98
	ORI  R30,1
	RJMP _0x15B
; 0000 00C2   else if ( a == 0)PORTF&=0b11111110;
_0x2A:
	LD   R30,Y
	CPI  R30,0
	BRNE _0x2C
	LDS  R30,98
	ANDI R30,0xFE
_0x15B:
	STS  98,R30
; 0000 00C3  }
_0x2C:
_0x20C0006:
	ADIW R28,1
	RET
; .FEND
;
;void Move(char DL,char DR,unsigned char SL,unsigned char SR)
; 0000 00C6 {
_Move:
; .FSTART _Move
; 0000 00C7     DirectionL=DL;
	ST   -Y,R26
;	DL -> Y+3
;	DR -> Y+2
;	SL -> Y+1
;	SR -> Y+0
	LDD  R30,Y+3
	CALL __BSTB1
	BLD  R2,2
; 0000 00C8     DirectionR=DR;
	LDD  R30,Y+2
	CALL __BSTB1
	BLD  R2,1
; 0000 00C9     SpeedL=SL;
	LDD  R6,Y+1
; 0000 00CA     SpeedR=SR;
	LDD  R7,Y+0
; 0000 00CB }
	RJMP _0x20C0005
; .FEND
;
;void CalR()
; 0000 00CE  {
_CalR:
; .FSTART _CalR
; 0000 00CF   int RKeyON,RKeyOFF;
; 0000 00D0 
; 0000 00D1   ColorCalR=RKeyON=RKeyOFF=0;
	CALL SUBOPT_0x0
;	RKeyON -> R16,R17
;	RKeyOFF -> R18,R19
	STS  _ColorCalR,R30
	STS  _ColorCalR+1,R31
; 0000 00D2 
; 0000 00D3   KeySen=off;
	CALL SUBOPT_0x1
; 0000 00D4 
; 0000 00D5   for (c=0;c<N;c++)
_0x30:
	CALL SUBOPT_0x2
	BRSH _0x31
; 0000 00D6   {
; 0000 00D7    RKeyOFF+=adcNumberR;
	LDI  R26,LOW(4)
	RCALL _read_adc
	__ADDWRR 18,19,30,31
; 0000 00D8   }
	CALL SUBOPT_0x3
	RJMP _0x30
_0x31:
; 0000 00D9 
; 0000 00DA   KeySen=on;
	CALL SUBOPT_0x4
; 0000 00DB 
; 0000 00DC   for (d=0;d<N;d++)
_0x35:
	CALL SUBOPT_0x5
	BRSH _0x36
; 0000 00DD   {
; 0000 00DE    RKeyON+=adcNumberR;
	LDI  R26,LOW(4)
	RCALL _read_adc
	__ADDWRR 16,17,30,31
; 0000 00DF   }
	CALL SUBOPT_0x6
	RJMP _0x35
_0x36:
; 0000 00E0 
; 0000 00E1   KeySen=off;
	CALL SUBOPT_0x7
; 0000 00E2 
; 0000 00E3   RKeyOFF/=N;
; 0000 00E4   RKeyON /=N;
; 0000 00E5 
; 0000 00E6   ColorCalR = RKeyON - RKeyOFF;
	STS  _ColorCalR,R30
	STS  _ColorCalR+1,R31
; 0000 00E7 
; 0000 00E8   lcd_clear();
	CALL SUBOPT_0x8
; 0000 00E9   lcd_gotoxy(0,0);
; 0000 00EA   sprintf(m,"Right= %d",ColorCalR);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x9
	RJMP _0x20C0004
; 0000 00EB   lcd_puts(m);
; 0000 00EC  }
; .FEND
;void CalL()
; 0000 00EE  {
_CalL:
; .FSTART _CalL
; 0000 00EF   int LKeyON,LKeyOFF;
; 0000 00F0 
; 0000 00F1   ColorCalL=LKeyON=LKeyOFF=0;
	CALL SUBOPT_0x0
;	LKeyON -> R16,R17
;	LKeyOFF -> R18,R19
	STS  _ColorCalL,R30
	STS  _ColorCalL+1,R31
; 0000 00F2 
; 0000 00F3   KeySen=off;
	CALL SUBOPT_0x1
; 0000 00F4 
; 0000 00F5   for (c=0;c<N;c++)
_0x3C:
	CALL SUBOPT_0x2
	BRSH _0x3D
; 0000 00F6   {
; 0000 00F7    LKeyOFF+=adcNumberL;
	LDI  R26,LOW(3)
	RCALL _read_adc
	__ADDWRR 18,19,30,31
; 0000 00F8   }
	CALL SUBOPT_0x3
	RJMP _0x3C
_0x3D:
; 0000 00F9 
; 0000 00FA   KeySen=on;
	CALL SUBOPT_0x4
; 0000 00FB 
; 0000 00FC   for (d=0;d<N;d++)
_0x41:
	CALL SUBOPT_0x5
	BRSH _0x42
; 0000 00FD   {
; 0000 00FE    LKeyON+=adcNumberL;
	LDI  R26,LOW(3)
	RCALL _read_adc
	__ADDWRR 16,17,30,31
; 0000 00FF   }
	CALL SUBOPT_0x6
	RJMP _0x41
_0x42:
; 0000 0100 
; 0000 0101   KeySen=off;
	CALL SUBOPT_0x7
; 0000 0102 
; 0000 0103   LKeyOFF/=N;
; 0000 0104   LKeyON /=N;
; 0000 0105 
; 0000 0106   ColorCalL = LKeyON - LKeyOFF;
	STS  _ColorCalL,R30
	STS  _ColorCalL+1,R31
; 0000 0107 
; 0000 0108   lcd_clear();
	CALL SUBOPT_0x8
; 0000 0109   lcd_gotoxy(0,0);
; 0000 010A   sprintf(m,"Left= %d",ColorCalL);
	__POINTW1FN _0x0,10
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xA
_0x20C0004:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 010B   lcd_puts(m);
	LDI  R26,LOW(_m)
	LDI  R27,HIGH(_m)
	CALL _lcd_puts
; 0000 010C  }
	CALL __LOADLOCR4
_0x20C0005:
	ADIW R28,4
	RET
; .FEND
;
;void Color()
; 0000 010F  {
_Color:
; .FSTART _Color
; 0000 0110   ColorNumL=LsenKeyON=LsenKeyOFF=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xB
	MOVW R12,R30
	STS  _ColorNumL,R30
	STS  _ColorNumL+1,R31
; 0000 0111   ColorNumR=RsenKeyON=RsenKeyOFF=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	STS  _ColorNumR,R30
	STS  _ColorNumR+1,R31
; 0000 0112 
; 0000 0113   KeySen=off;
	CALL SUBOPT_0x1
; 0000 0114 
; 0000 0115   for (c=0;c<N;c++)
_0x48:
	CALL SUBOPT_0x2
	BRSH _0x49
; 0000 0116   {
; 0000 0117    LsenKeyOFF+=adcNumberL;
	LDI  R26,LOW(3)
	RCALL _read_adc
	CALL SUBOPT_0xE
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xB
; 0000 0118    RsenKeyOFF+=adcNumberR;
	LDI  R26,LOW(4)
	RCALL _read_adc
	CALL SUBOPT_0xF
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xC
; 0000 0119   }
	CALL SUBOPT_0x3
	RJMP _0x48
_0x49:
; 0000 011A 
; 0000 011B   KeySen=on;
	CALL SUBOPT_0x4
; 0000 011C 
; 0000 011D   for (d=0;d<N;d++)
_0x4D:
	CALL SUBOPT_0x5
	BRSH _0x4E
; 0000 011E   {
; 0000 011F    LsenKeyON+=adcNumberL;
	LDI  R26,LOW(3)
	RCALL _read_adc
	__ADDWRR 12,13,30,31
; 0000 0120    RsenKeyON+=adcNumberR;
	LDI  R26,LOW(4)
	RCALL _read_adc
	LDS  R26,_RsenKeyON
	LDS  R27,_RsenKeyON+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0xD
; 0000 0121   }
	CALL SUBOPT_0x6
	RJMP _0x4D
_0x4E:
; 0000 0122 
; 0000 0123   KeySen=off;
	CBI  0x3,0
; 0000 0124 
; 0000 0125   LsenKeyOFF/=N;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x10
	CALL SUBOPT_0xB
; 0000 0126   LsenKeyON /=N;
	MOVW R26,R12
	CALL SUBOPT_0x10
	MOVW R12,R30
; 0000 0127   RsenKeyOFF/=N;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0xC
; 0000 0128   RsenKeyON /=N;
	LDS  R26,_RsenKeyON
	LDS  R27,_RsenKeyON+1
	CALL SUBOPT_0x10
	CALL SUBOPT_0xD
; 0000 0129 
; 0000 012A   ColorNumL = LsenKeyON - LsenKeyOFF;
	CALL SUBOPT_0xE
	MOVW R30,R12
	SUB  R30,R26
	SBC  R31,R27
	STS  _ColorNumL,R30
	STS  _ColorNumL+1,R31
; 0000 012B   ColorNumR = RsenKeyON - RsenKeyOFF;
	CALL SUBOPT_0xF
	LDS  R30,_RsenKeyON
	LDS  R31,_RsenKeyON+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _ColorNumR,R30
	STS  _ColorNumR+1,R31
; 0000 012C  }
	RET
; .FEND
;
;void LeftMove ()
; 0000 012F  {
_LeftMove:
; .FSTART _LeftMove
; 0000 0130    LEDR(1);
	CALL SUBOPT_0x11
; 0000 0131    Move(CW,CW,150,150);
; 0000 0132    delay_ms(100);
; 0000 0133 
; 0000 0134    while (!SEN1)
_0x51:
	CALL SUBOPT_0x12
	BREQ PC+2
	RJMP _0x53
; 0000 0135      {
; 0000 0136 
; 0000 0137            if  ( SEN24 )           Move(CCW,CW,250,50);
	CALL SUBOPT_0x13
	BREQ _0x54
	CALL SUBOPT_0x14
	LDI  R30,LOW(250)
	ST   -Y,R30
	LDI  R26,LOW(50)
	RJMP _0x15C
; 0000 0138       else if  ( SEN23 )           Move(CCW,CW,255,170);
_0x54:
	CALL SUBOPT_0x15
	BREQ _0x56
	CALL SUBOPT_0x14
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(170)
	RJMP _0x15C
; 0000 0139       else if  ( SEN22 )           Move(CCW,CW,200,255);
_0x56:
	CALL SUBOPT_0x16
	BREQ _0x58
	CALL SUBOPT_0x14
	LDI  R30,LOW(200)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x15C
; 0000 013A       else if  ( SEN21 )           Move(CCW,CW,140,255);
_0x58:
	CALL SUBOPT_0x17
	BREQ _0x5A
	CALL SUBOPT_0x14
	LDI  R30,LOW(140)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x15C
; 0000 013B       else if  ( SEN20 )           Move(CCW,CW,80,255);
_0x5A:
	CALL SUBOPT_0x18
	BREQ _0x5C
	CALL SUBOPT_0x14
	LDI  R30,LOW(80)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x15C
; 0000 013C       else if  ( SEN19 )           Move(CCW,CW,40,255);
_0x5C:
	LDS  R30,99
	ANDI R30,LOW(0x4)
	BREQ _0x5E
	CALL SUBOPT_0x14
	LDI  R30,LOW(40)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x15C
; 0000 013D       else if  ( SEN18 )           Move(CW,CW,0,255);
_0x5E:
	CALL SUBOPT_0x19
	BREQ _0x60
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x15C
; 0000 013E       else if  ( SEN17 )           Move(CW,CW,60,250);
_0x60:
	CALL SUBOPT_0x1B
	BREQ _0x62
	CALL SUBOPT_0x1A
	LDI  R30,LOW(60)
	ST   -Y,R30
	LDI  R26,LOW(250)
	RJMP _0x15C
; 0000 013F       else if  ( SEN16 )           Move(CW,CW,120,255);
_0x62:
	CALL SUBOPT_0x1C
	BREQ _0x64
	CALL SUBOPT_0x1A
	LDI  R30,LOW(120)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x15C
; 0000 0140       else if  ( SEN15 )           Move(CW,CW,140,220);
_0x64:
	CALL SUBOPT_0x1D
	BREQ _0x66
	CALL SUBOPT_0x1A
	LDI  R30,LOW(140)
	ST   -Y,R30
	LDI  R26,LOW(220)
	RJMP _0x15C
; 0000 0141       else if  ( SEN14 )           Move(CW,CW,140,180);
_0x66:
	CALL SUBOPT_0x1E
	BREQ _0x68
	CALL SUBOPT_0x1A
	LDI  R30,LOW(140)
	ST   -Y,R30
	LDI  R26,LOW(180)
	RJMP _0x15C
; 0000 0142       else if  ( SEN13 )           Move(CW,CW,140,160);
_0x68:
	CALL SUBOPT_0x1F
	BREQ _0x6A
	CALL SUBOPT_0x1A
	LDI  R30,LOW(140)
	ST   -Y,R30
	LDI  R26,LOW(160)
	RJMP _0x15C
; 0000 0143       else if  ( SEN12 )           Move(CW,CW,160,140);
_0x6A:
	CALL SUBOPT_0x20
	BREQ _0x6C
	CALL SUBOPT_0x1A
	LDI  R30,LOW(160)
	RJMP _0x15D
; 0000 0144       else if  ( SEN12 && SEN13 )  Move(CW,CW,140,140);
_0x6C:
	CALL SUBOPT_0x20
	BREQ _0x6F
	CALL SUBOPT_0x1F
	BRNE _0x70
_0x6F:
	RJMP _0x6E
_0x70:
	CALL SUBOPT_0x1A
	LDI  R30,LOW(140)
_0x15D:
	ST   -Y,R30
	LDI  R26,LOW(140)
_0x15C:
	RCALL _Move
; 0000 0145 
; 0000 0146      }
_0x6E:
	RJMP _0x51
_0x53:
; 0000 0147 
; 0000 0148      LEDR(0);
	RJMP _0x20C0003
; 0000 0149  }
; .FEND
;void RightMove()
; 0000 014B  {
_RightMove:
; .FSTART _RightMove
; 0000 014C    LEDR(1);
	CALL SUBOPT_0x11
; 0000 014D    Move(CW,CW,150,150);
; 0000 014E    delay_ms(100);
; 0000 014F 
; 0000 0150    while (!SEN24)
_0x71:
	CALL SUBOPT_0x13
	BREQ PC+2
	RJMP _0x73
; 0000 0151      {
; 0000 0152 
; 0000 0153            if  ( SEN1 )           Move(CW,CCW,50,250);
	CALL SUBOPT_0x12
	BREQ _0x74
	CALL SUBOPT_0x21
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R26,LOW(250)
	RJMP _0x15E
; 0000 0154       else if  ( SEN2 )           Move(CW,CCW,170,255);
_0x74:
	CALL SUBOPT_0x22
	BREQ _0x76
	CALL SUBOPT_0x21
	LDI  R30,LOW(170)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x15E
; 0000 0155       else if  ( SEN3 )           Move(CW,CCW,255,200);
_0x76:
	CALL SUBOPT_0x23
	BREQ _0x78
	CALL SUBOPT_0x21
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(200)
	RJMP _0x15E
; 0000 0156       else if  ( SEN4 )           Move(CW,CCW,255,140);
_0x78:
	CALL SUBOPT_0x24
	BREQ _0x7A
	CALL SUBOPT_0x21
	LDI  R30,LOW(255)
	RJMP _0x15F
; 0000 0157       else if  ( SEN5 )           Move(CW,CCW,255,80);
_0x7A:
	CALL SUBOPT_0x25
	BREQ _0x7C
	CALL SUBOPT_0x21
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(80)
	RJMP _0x15E
; 0000 0158       else if  ( SEN6 )           Move(CW,CCW,255,40);
_0x7C:
	CALL SUBOPT_0x26
	BREQ _0x7E
	CALL SUBOPT_0x21
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(40)
	RJMP _0x15E
; 0000 0159       else if  ( SEN7 )           Move(CW,CW,255,0);
_0x7E:
	CALL SUBOPT_0x27
	BREQ _0x80
	CALL SUBOPT_0x1A
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x15E
; 0000 015A       else if  ( SEN8 )           Move(CW,CW,250,60);
_0x80:
	CALL SUBOPT_0x28
	BREQ _0x82
	CALL SUBOPT_0x1A
	LDI  R30,LOW(250)
	ST   -Y,R30
	LDI  R26,LOW(60)
	RJMP _0x15E
; 0000 015B       else if  ( SEN9 )           Move(CW,CW,255,120);
_0x82:
	LDS  R30,99
	ANDI R30,LOW(0x1)
	BREQ _0x84
	CALL SUBOPT_0x1A
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(120)
	RJMP _0x15E
; 0000 015C       else if  ( SEN10 )          Move(CW,CW,220,140);
_0x84:
	LDS  R30,99
	ANDI R30,LOW(0x2)
	BREQ _0x86
	CALL SUBOPT_0x1A
	LDI  R30,LOW(220)
	RJMP _0x15F
; 0000 015D       else if  ( SEN11 )          Move(CW,CW,180,140);
_0x86:
	CALL SUBOPT_0x29
	BREQ _0x88
	CALL SUBOPT_0x1A
	LDI  R30,LOW(180)
	RJMP _0x15F
; 0000 015E       else if  ( SEN12 )          Move(CW,CW,160,140);
_0x88:
	CALL SUBOPT_0x20
	BREQ _0x8A
	CALL SUBOPT_0x1A
	LDI  R30,LOW(160)
	RJMP _0x15F
; 0000 015F       else if  ( SEN13 )          Move(CW,CW,140,160);
_0x8A:
	CALL SUBOPT_0x1F
	BREQ _0x8C
	CALL SUBOPT_0x1A
	LDI  R30,LOW(140)
	ST   -Y,R30
	LDI  R26,LOW(160)
	RJMP _0x15E
; 0000 0160       else if  ( SEN12 && SEN13 ) Move(CW,CW,140,140);
_0x8C:
	CALL SUBOPT_0x20
	BREQ _0x8F
	CALL SUBOPT_0x1F
	BRNE _0x90
_0x8F:
	RJMP _0x8E
_0x90:
	CALL SUBOPT_0x1A
	LDI  R30,LOW(140)
_0x15F:
	ST   -Y,R30
	LDI  R26,LOW(140)
_0x15E:
	RCALL _Move
; 0000 0161 
; 0000 0162      }
_0x8E:
	RJMP _0x71
_0x73:
; 0000 0163 
; 0000 0164      LEDR(0);
_0x20C0003:
	LDI  R26,LOW(0)
	RCALL _LEDR
; 0000 0165  }
	RET
; .FEND
;
;void Distinction()
; 0000 0168  {
_Distinction:
; .FSTART _Distinction
; 0000 0169 
; 0000 016A   Color();
	RCALL _Color
; 0000 016B 
; 0000 016C   if      (!SWG ){ }
	SBIS 0x0,5
; 0000 016D   else if ( SWG )
	RJMP _0x92
	SBIS 0x0,5
	RJMP _0x93
; 0000 016E   {
; 0000 016F         if ( ColorNumL ==  ColorCalL    ) LeftMove();
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2A
	BRNE _0x94
	RCALL _LeftMove
; 0000 0170    else if ( ColorNumL == (ColorCalL+1) ) LeftMove();
	RJMP _0x95
_0x94:
	CALL SUBOPT_0xA
	ADIW R30,1
	CALL SUBOPT_0x2A
	BRNE _0x96
	RCALL _LeftMove
; 0000 0171    else if ( ColorNumL == (ColorCalL+2) ) LeftMove();
	RJMP _0x97
_0x96:
	CALL SUBOPT_0xA
	ADIW R30,2
	CALL SUBOPT_0x2A
	BRNE _0x98
	RCALL _LeftMove
; 0000 0172    else if ( ColorNumL == (ColorCalL+3) ) LeftMove();
	RJMP _0x99
_0x98:
	CALL SUBOPT_0xA
	ADIW R30,3
	CALL SUBOPT_0x2A
	BRNE _0x9A
	RCALL _LeftMove
; 0000 0173    else if ( ColorNumL == (ColorCalL-1) ) LeftMove();
	RJMP _0x9B
_0x9A:
	CALL SUBOPT_0xA
	SBIW R30,1
	CALL SUBOPT_0x2A
	BRNE _0x9C
	RCALL _LeftMove
; 0000 0174    else if ( ColorNumL == (ColorCalL-2) ) LeftMove();
	RJMP _0x9D
_0x9C:
	CALL SUBOPT_0xA
	SBIW R30,2
	CALL SUBOPT_0x2A
	BRNE _0x9E
	RCALL _LeftMove
; 0000 0175    else if ( ColorNumL == (ColorCalL-3) ) LeftMove();
	RJMP _0x9F
_0x9E:
	CALL SUBOPT_0xA
	SBIW R30,3
	CALL SUBOPT_0x2A
	BRNE _0xA0
	RCALL _LeftMove
; 0000 0176 
; 0000 0177    else if ( ColorNumR ==  ColorCalR    ) RightMove();
	RJMP _0xA1
_0xA0:
	CALL SUBOPT_0x9
	CALL SUBOPT_0x2B
	BREQ _0x160
; 0000 0178    else if ( ColorNumR == (ColorCalR+1) ) RightMove();
	CALL SUBOPT_0x9
	ADIW R30,1
	CALL SUBOPT_0x2B
	BREQ _0x160
; 0000 0179    else if ( ColorNumR == (ColorCalR+2) ) RightMove();
	CALL SUBOPT_0x9
	ADIW R30,2
	CALL SUBOPT_0x2B
	BREQ _0x160
; 0000 017A    else if ( ColorNumR == (ColorCalR+3) ) RightMove();
	CALL SUBOPT_0x9
	ADIW R30,3
	CALL SUBOPT_0x2B
	BREQ _0x160
; 0000 017B    else if ( ColorNumR == (ColorCalR-1) ) RightMove();
	CALL SUBOPT_0x9
	SBIW R30,1
	CALL SUBOPT_0x2B
	BREQ _0x160
; 0000 017C    else if ( ColorNumR == (ColorCalR-2) ) RightMove();
	CALL SUBOPT_0x9
	SBIW R30,2
	CALL SUBOPT_0x2B
	BREQ _0x160
; 0000 017D    else if ( ColorNumR == (ColorCalR-3) ) RightMove();
	CALL SUBOPT_0x9
	SBIW R30,3
	CALL SUBOPT_0x2B
	BRNE _0xAE
_0x160:
	RCALL _RightMove
; 0000 017E    // else LineFollower();
; 0000 017F   }
_0xAE:
_0xA1:
_0x9F:
_0x9D:
_0x9B:
_0x99:
_0x97:
_0x95:
; 0000 0180 
; 0000 0181  }
_0x93:
_0x92:
	RET
; .FEND
;
;void ReadSen ()
; 0000 0184 {
_ReadSen:
; .FSTART _ReadSen
; 0000 0185  if ( SEN1 ) RS|=0b000000000000000000000001;
	CALL SUBOPT_0x12
	BREQ _0xAF
	LDI  R30,LOW(1)
	OR   R10,R30
; 0000 0186  if ( SEN2 ) RS|=0b000000000000000000000010;
_0xAF:
	CALL SUBOPT_0x22
	BREQ _0xB0
	LDI  R30,LOW(2)
	OR   R10,R30
; 0000 0187  if ( SEN3 ) RS|=0b000000000000000000000100;
_0xB0:
	CALL SUBOPT_0x23
	BREQ _0xB1
	LDI  R30,LOW(4)
	OR   R10,R30
; 0000 0188  if ( SEN4 ) RS|=0b000000000000000000001000;
_0xB1:
	CALL SUBOPT_0x24
	BREQ _0xB2
	LDI  R30,LOW(8)
	OR   R10,R30
; 0000 0189  if ( SEN5 ) RS|=0b000000000000000000010000;
_0xB2:
	CALL SUBOPT_0x25
	BREQ _0xB3
	LDI  R30,LOW(16)
	OR   R10,R30
; 0000 018A  if ( SEN6 ) RS|=0b000000000000000000100000;
_0xB3:
	CALL SUBOPT_0x26
	BREQ _0xB4
	LDI  R30,LOW(32)
	OR   R10,R30
; 0000 018B  if ( SEN7 ) RS|=0b000000000000000001000000;
_0xB4:
	CALL SUBOPT_0x27
	BREQ _0xB5
	LDI  R30,LOW(64)
	OR   R10,R30
; 0000 018C  if ( SEN8 ) RS|=0b000000000000000010000000;
_0xB5:
	CALL SUBOPT_0x28
	BREQ _0xB6
	LDI  R30,LOW(128)
	OR   R10,R30
; 0000 018D  if ( SEN9 ) RS|=0b000000000000000100000000;
_0xB6:
	LDS  R30,99
	ANDI R30,LOW(0x1)
	BREQ _0xB7
	LDI  R30,LOW(1)
	OR   R11,R30
; 0000 018E  if ( SEN10) RS|=0b000000000000001000000000;
_0xB7:
	LDS  R30,99
	ANDI R30,LOW(0x2)
	BREQ _0xB8
	LDI  R30,LOW(2)
	OR   R11,R30
; 0000 018F  if ( SEN11) RS|=0b000000000000010000000000;
_0xB8:
	CALL SUBOPT_0x29
	BREQ _0xB9
	LDI  R30,LOW(4)
	OR   R11,R30
; 0000 0190  if ( SEN12) RS|=0b000000000000100000000000;
_0xB9:
	CALL SUBOPT_0x20
	BREQ _0xBA
	LDI  R30,LOW(8)
	OR   R11,R30
; 0000 0191  if ( SEN13) RS|=0b000000000001000000000000;
_0xBA:
	CALL SUBOPT_0x1F
	BREQ _0xBB
	LDI  R30,LOW(16)
	OR   R11,R30
; 0000 0192  if ( SEN14) RS|=0b000000000010000000000000;
_0xBB:
	CALL SUBOPT_0x1E
	BREQ _0xBC
	LDI  R30,LOW(32)
	OR   R11,R30
; 0000 0193  if ( SEN15) RS|=0b000000000100000000000000;
_0xBC:
	CALL SUBOPT_0x1D
	BREQ _0xBD
	LDI  R30,LOW(64)
	OR   R11,R30
; 0000 0194  if ( SEN16) RS|=0b000000001000000000000000;
_0xBD:
	CALL SUBOPT_0x1C
	BREQ _0xBE
	LDI  R30,LOW(128)
	OR   R11,R30
; 0000 0195  if ( SEN17) RS|=0b000000010000000000000000;
_0xBE:
	CALL SUBOPT_0x1B
	BREQ _0xBF
	LDI  R30,LOW(0)
	OR   R10,R30
; 0000 0196  if ( SEN18) RS|=0b000000100000000000000000;
_0xBF:
	CALL SUBOPT_0x19
	BREQ _0xC0
	LDI  R30,LOW(0)
	OR   R10,R30
; 0000 0197  if ( SEN19) RS|=0b000001000000000000000000;
_0xC0:
	LDS  R30,99
	ANDI R30,LOW(0x4)
	BREQ _0xC1
	LDI  R30,LOW(0)
	OR   R10,R30
; 0000 0198  if ( SEN20) RS|=0b000010000000000000000000;
_0xC1:
	CALL SUBOPT_0x18
	BREQ _0xC2
	LDI  R30,LOW(0)
	OR   R10,R30
; 0000 0199  if ( SEN21) RS|=0b000100000000000000000000;
_0xC2:
	CALL SUBOPT_0x17
	BREQ _0xC3
	LDI  R30,LOW(0)
	OR   R10,R30
; 0000 019A  if ( SEN22) RS|=0b001000000000000000000000;
_0xC3:
	CALL SUBOPT_0x16
	BREQ _0xC4
	LDI  R30,LOW(0)
	OR   R10,R30
; 0000 019B  if ( SEN23) RS|=0b010000000000000000000000;
_0xC4:
	CALL SUBOPT_0x15
	BREQ _0xC5
	LDI  R30,LOW(0)
	OR   R10,R30
; 0000 019C  if ( SEN24) RS|=0b100000000000000000000000;
_0xC5:
	CALL SUBOPT_0x13
	BREQ _0xC6
	LDI  R30,LOW(0)
	OR   R10,R30
; 0000 019D }
_0xC6:
	RET
; .FEND
;
;void LineFollowerRGB ()
; 0000 01A0  {
_LineFollowerRGB:
; .FSTART _LineFollowerRGB
; 0000 01A1   V = VolomADC;
	LDI  R26,LOW(6)
	RCALL _read_adc
	MOV  R9,R30
; 0000 01A2 
; 0000 01A3   if ( SEN12 || SEN13 )
	CALL SUBOPT_0x20
	BRNE _0xC8
	CALL SUBOPT_0x1F
	BRNE _0xC8
	RJMP _0xC7
_0xC8:
; 0000 01A4   {
; 0000 01A5    ReadSen();
	RCALL _ReadSen
; 0000 01A6 
; 0000 01A7    if ( (RS == 0b000000000001100000000000) ||
; 0000 01A8         (RS == 0b000000000001000000000000) ||
; 0000 01A9         (RS == 0b000000000000100000000000)
; 0000 01AA       )
	LDI  R30,LOW(6144)
	LDI  R31,HIGH(6144)
	CP   R30,R10
	CPC  R31,R11
	BREQ _0xCB
	LDI  R30,LOW(4096)
	LDI  R31,HIGH(4096)
	CP   R30,R10
	CPC  R31,R11
	BREQ _0xCB
	LDI  R30,LOW(2048)
	LDI  R31,HIGH(2048)
	CP   R30,R10
	CPC  R31,R11
	BRNE _0xCA
_0xCB:
; 0000 01AB       {
; 0000 01AC        Distinction();
	RCALL _Distinction
; 0000 01AD 
; 0000 01AE             if  ( SEN12 && SEN13 )  Move(CW,CW,V,V);
	CALL SUBOPT_0x20
	BREQ _0xCE
	CALL SUBOPT_0x1F
	BRNE _0xCF
_0xCE:
	RJMP _0xCD
_0xCF:
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	RJMP _0x161
; 0000 01AF        else if  ( SEN12 )           Move(CW,CW,20+V,V);
_0xCD:
	CALL SUBOPT_0x20
	BREQ _0xD1
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2C
	RJMP _0x161
; 0000 01B0        else if  ( SEN13 )           Move(CW,CW,V,20+V);
_0xD1:
	CALL SUBOPT_0x1F
	BREQ _0xD3
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(20)
_0x161:
	RCALL _Move
; 0000 01B1       }
_0xD3:
; 0000 01B2 
; 0000 01B3    else
	RJMP _0xD4
_0xCA:
; 0000 01B4       {
; 0000 01B5             if  ( SEN12 && SEN13 )  Move(CW,CW,V,V);
	CALL SUBOPT_0x20
	BREQ _0xD6
	CALL SUBOPT_0x1F
	BRNE _0xD7
_0xD6:
	RJMP _0xD5
_0xD7:
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	RJMP _0x162
; 0000 01B6        else if  ( SEN12 )           Move(CW,CW,20+V,V);
_0xD5:
	CALL SUBOPT_0x20
	BREQ _0xD9
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2C
	RJMP _0x162
; 0000 01B7        else if  ( SEN13 )           Move(CW,CW,V,20+V);
_0xD9:
	CALL SUBOPT_0x1F
	BREQ _0xDB
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(20)
_0x162:
	RCALL _Move
; 0000 01B8       }
_0xDB:
_0xD4:
; 0000 01B9 
; 0000 01BA 
; 0000 01BB   }
; 0000 01BC 
; 0000 01BD   else if  ( SEN11 )           Move(CW,CW,40+V,V);
	RJMP _0xDC
_0xC7:
	CALL SUBOPT_0x29
	BREQ _0xDD
	CALL SUBOPT_0x1A
	MOV  R30,R9
	SUBI R30,-LOW(40)
	ST   -Y,R30
	MOV  R26,R9
	RJMP _0x163
; 0000 01BE   else if  ( SEN14 )           Move(CW,CW,V,40+V);
_0xDD:
	CALL SUBOPT_0x1E
	BREQ _0xDF
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(40)
	RJMP _0x163
; 0000 01BF 
; 0000 01C0   else if  ( SEN10 )           Move(CW,CW,60+V,V);
_0xDF:
	LDS  R30,99
	ANDI R30,LOW(0x2)
	BREQ _0xE1
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2D
	RJMP _0x163
; 0000 01C1   else if  ( SEN15 )           Move(CW,CW,V,60+V);
_0xE1:
	CALL SUBOPT_0x1D
	BREQ _0xE3
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(60)
	RJMP _0x163
; 0000 01C2 
; 0000 01C3   else if  ( SEN9 )            Move(CW,CW,80+V,V);
_0xE3:
	LDS  R30,99
	ANDI R30,LOW(0x1)
	BREQ _0xE5
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2E
	RJMP _0x163
; 0000 01C4   else if  ( SEN16 )           Move(CW,CW,V,80+V);
_0xE5:
	CALL SUBOPT_0x1C
	BREQ _0xE7
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(80)
	RJMP _0x163
; 0000 01C5 
; 0000 01C6   else if  ( SEN8 )            Move(CW,CW,100+V,V);
_0xE7:
	CALL SUBOPT_0x28
	BREQ _0xE9
	CALL SUBOPT_0x1A
	MOV  R30,R9
	SUBI R30,-LOW(100)
	ST   -Y,R30
	MOV  R26,R9
	RJMP _0x163
; 0000 01C7   else if  ( SEN17 )           Move(CW,CW,V,100+V);
_0xE9:
	CALL SUBOPT_0x1B
	BREQ _0xEB
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(100)
	RJMP _0x163
; 0000 01C8 //-----------------------------------------------------------
; 0000 01C9   else if  ( SEN7 )            Move(CW,CW,150,0);
_0xEB:
	CALL SUBOPT_0x27
	BREQ _0xED
	CALL SUBOPT_0x1A
	LDI  R30,LOW(150)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x163
; 0000 01CA   else if  ( SEN18 )           Move(CW,CW,0,150);
_0xED:
	CALL SUBOPT_0x19
	BREQ _0xEF
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(150)
	RJMP _0x163
; 0000 01CB 
; 0000 01CC   else if  ( SEN6 )            Move(CW,CW,250,0);
_0xEF:
	CALL SUBOPT_0x26
	BREQ _0xF1
	CALL SUBOPT_0x1A
	LDI  R30,LOW(250)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x163
; 0000 01CD   else if  ( SEN19 )           Move(CW,CW,0,250);
_0xF1:
	LDS  R30,99
	ANDI R30,LOW(0x4)
	BREQ _0xF3
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(250)
	RJMP _0x163
; 0000 01CE 
; 0000 01CF   else if  ( SEN5 )            Move(CW,CCW,200,100);
_0xF3:
	CALL SUBOPT_0x25
	BREQ _0xF5
	CALL SUBOPT_0x21
	LDI  R30,LOW(200)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RJMP _0x163
; 0000 01D0   else if  ( SEN20 )           Move(CCW,CW,190,200);
_0xF5:
	CALL SUBOPT_0x18
	BREQ _0xF7
	CALL SUBOPT_0x14
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDI  R26,LOW(200)
	RJMP _0x163
; 0000 01D1 
; 0000 01D2   else if  ( SEN4 )            Move(CW,CCW,190,190);
_0xF7:
	CALL SUBOPT_0x24
	BREQ _0xF9
	CALL SUBOPT_0x21
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDI  R26,LOW(190)
	RJMP _0x163
; 0000 01D3   else if  ( SEN21 )           Move(CCW,CW,190,190);
_0xF9:
	CALL SUBOPT_0x17
	BREQ _0xFB
	CALL SUBOPT_0x14
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDI  R26,LOW(190)
	RJMP _0x163
; 0000 01D4 
; 0000 01D5   else if  ( SEN3 )            Move(CW,CCW,190,255);
_0xFB:
	CALL SUBOPT_0x23
	BREQ _0xFD
	CALL SUBOPT_0x21
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x163
; 0000 01D6   else if  ( SEN22 )           Move(CCW,CW,255,190);
_0xFD:
	CALL SUBOPT_0x16
	BREQ _0xFF
	CALL SUBOPT_0x14
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(190)
	RJMP _0x163
; 0000 01D7 
; 0000 01D8   else if  ( SEN2 )            Move(CW,CCW,100,255);
_0xFF:
	CALL SUBOPT_0x22
	BREQ _0x101
	CALL SUBOPT_0x21
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x163
; 0000 01D9   else if  ( SEN23 )           Move(CCW,CW,255,100);
_0x101:
	CALL SUBOPT_0x15
	BREQ _0x103
	CALL SUBOPT_0x14
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RJMP _0x163
; 0000 01DA 
; 0000 01DB   else if  ( SEN1 )            Move(CW,CCW,50,255);
_0x103:
	CALL SUBOPT_0x12
	BREQ _0x105
	CALL SUBOPT_0x21
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x163
; 0000 01DC   else if  ( SEN24 )           Move(CCW,CW,255,50);
_0x105:
	CALL SUBOPT_0x13
	BREQ _0x107
	CALL SUBOPT_0x14
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(50)
_0x163:
	RCALL _Move
; 0000 01DD 
; 0000 01DE  // else Move(CW,CW,0,0);
; 0000 01DF  }
_0x107:
_0xDC:
	RET
; .FEND
;
;void LineFollower ()
; 0000 01E2  {
_LineFollower:
; .FSTART _LineFollower
; 0000 01E3   V = VolomADC;
	LDI  R26,LOW(6)
	RCALL _read_adc
	MOV  R9,R30
; 0000 01E4 
; 0000 01E5   //ReadSen();
; 0000 01E6 
; 0000 01E7 //
; 0000 01E8 //  if ( SEN7 && SEN8 &&  SEN11 && SEN12 && SEN13 && SEN14 && SEN15 && SEN16 && SEN17 && SEN18 )
; 0000 01E9 //  {
; 0000 01EA //   i=!i;
; 0000 01EB //  }
; 0000 01EC //       if ( i==1 ) {LEDY(1);}
; 0000 01ED //  else if ( i==0 ) {LEDY(0);}
; 0000 01EE 
; 0000 01EF if (  p== 0 )
	LDS  R30,_p
	LDS  R31,_p+1
	SBIW R30,0
	BREQ PC+2
	RJMP _0x108
; 0000 01F0 {
; 0000 01F1        if  ( SEN12 && SEN13 )  {Move(CW,CW,V,V);}
	CALL SUBOPT_0x20
	BREQ _0x10A
	CALL SUBOPT_0x1F
	BRNE _0x10B
_0x10A:
	RJMP _0x109
_0x10B:
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	RJMP _0x164
; 0000 01F2   else if  ( SEN12 )           {Move(CW,CW,20+V,V);}
_0x109:
	CALL SUBOPT_0x20
	BREQ _0x10D
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2C
	RJMP _0x164
; 0000 01F3   else if  ( SEN13 )           {Move(CW,CW,V,20+V);}
_0x10D:
	CALL SUBOPT_0x1F
	BREQ _0x10F
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(20)
	RJMP _0x164
; 0000 01F4 
; 0000 01F5   else if  ( SEN11 )           {Move(CW,CW,40+V,V);}
_0x10F:
	CALL SUBOPT_0x29
	BREQ _0x111
	CALL SUBOPT_0x1A
	MOV  R30,R9
	SUBI R30,-LOW(40)
	ST   -Y,R30
	MOV  R26,R9
	RJMP _0x164
; 0000 01F6   else if  ( SEN14 )           {Move(CW,CW,V,40+V);}
_0x111:
	CALL SUBOPT_0x1E
	BREQ _0x113
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(40)
	RJMP _0x164
; 0000 01F7 
; 0000 01F8   //else if  ( SEN10 )              Move(CW,CW,60+V,V);
; 0000 01F9   else if  ( i == 0 ) {if ( SEN10  ) {Move(CW,CW,60+V,V);}}
_0x113:
	SBRC R2,0
	RJMP _0x115
	LDS  R30,99
	ANDI R30,LOW(0x2)
	BREQ _0x116
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2D
	RCALL _Move
_0x116:
; 0000 01FA   else if  ( i == 1 ) {if ( SEN10N ) {Move(CW,CW,60+V,V);}}
	RJMP _0x117
_0x115:
	SBRS R2,0
	RJMP _0x118
	LDS  R30,99
	ANDI R30,LOW(0x0)
	BREQ _0x119
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2D
	RCALL _Move
_0x119:
; 0000 01FB   else if  ( SEN15 )                {Move(CW,CW,V,60+V);}
	RJMP _0x11A
_0x118:
	CALL SUBOPT_0x1D
	BREQ _0x11B
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(60)
_0x164:
	RCALL _Move
; 0000 01FC   p=1;
_0x11B:
_0x11A:
_0x117:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x2F
; 0000 01FD }
; 0000 01FE  if ( p==1 )
_0x108:
	CALL SUBOPT_0x30
	SBIW R26,1
	BREQ PC+2
	RJMP _0x11C
; 0000 01FF  {
; 0000 0200  // else if  ( SEN9 )               Move(CW,CW,80+V,V);
; 0000 0201    if  ( i == 0 ) if ( SEN9  )  {Move(CW,CW,80+V,V);}
	SBRC R2,0
	RJMP _0x11D
	LDS  R30,99
	ANDI R30,LOW(0x1)
	BREQ _0x11E
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2E
	RJMP _0x165
; 0000 0202   else if  ( i == 1 ) if ( SEN9N )  {Move(CW,CW,80+V,V);}
_0x11E:
	SBRS R2,0
	RJMP _0x120
	LDS  R30,99
	ANDI R30,LOW(0x0)
	BREQ _0x121
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2E
	RJMP _0x165
; 0000 0203   else if  ( SEN16 )                {Move(CW,CW,V,80+V);}
_0x121:
	CALL SUBOPT_0x1C
	BREQ _0x123
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(80)
	RJMP _0x165
; 0000 0204 
; 0000 0205   else if  ( SEN8 )            {Move(CW,CW,100+V,V);}
_0x123:
	CALL SUBOPT_0x28
	BREQ _0x125
	CALL SUBOPT_0x1A
	MOV  R30,R9
	SUBI R30,-LOW(100)
	ST   -Y,R30
	MOV  R26,R9
	RJMP _0x165
; 0000 0206   else if  ( SEN17 )           {Move(CW,CW,V,100+V);}
_0x125:
	CALL SUBOPT_0x1B
	BREQ _0x127
	CALL SUBOPT_0x1A
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(100)
	RJMP _0x165
; 0000 0207 
; 0000 0208   else if  ( SEN7 )            {Move(CW,CW,150,0);}
_0x127:
	CALL SUBOPT_0x27
	BREQ _0x129
	CALL SUBOPT_0x1A
	LDI  R30,LOW(150)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x165
; 0000 0209   else if  ( SEN18 )           {Move(CW,CW,0,150);}
_0x129:
	CALL SUBOPT_0x19
	BREQ _0x12B
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(150)
_0x165:
	RCALL _Move
; 0000 020A   p=2;
_0x12B:
_0x120:
_0x11D:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x2F
; 0000 020B   }
; 0000 020C   if ( p==2 )
_0x11C:
	CALL SUBOPT_0x30
	SBIW R26,2
	BREQ PC+2
	RJMP _0x12C
; 0000 020D   {
; 0000 020E    if  ( SEN6 )                 {Move(CW,CW,250,0);}
	CALL SUBOPT_0x26
	BREQ _0x12D
	CALL SUBOPT_0x1A
	LDI  R30,LOW(250)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _0x166
; 0000 020F   //else if  ( SEN19 )              Move(CW,CW,0,250);
; 0000 0210   else if  ( i == 0 ){ if ( SEN19  ) {Move(CW,CW,0,250);}}
_0x12D:
	SBRC R2,0
	RJMP _0x12F
	LDS  R30,99
	ANDI R30,LOW(0x4)
	BREQ _0x130
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(250)
	RCALL _Move
_0x130:
; 0000 0211   else if  ( i == 1 ){ if ( SEN19N ) {Move(CW,CW,0,250);}}
	RJMP _0x131
_0x12F:
	SBRS R2,0
	RJMP _0x132
	LDS  R30,99
	ANDI R30,LOW(0x0)
	BREQ _0x133
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(250)
	RCALL _Move
_0x133:
; 0000 0212 
; 0000 0213   else if  ( SEN5 )            {Move(CW,CCW,200,100);}
	RJMP _0x134
_0x132:
	CALL SUBOPT_0x25
	BREQ _0x135
	CALL SUBOPT_0x21
	LDI  R30,LOW(200)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RJMP _0x166
; 0000 0214   else if  ( SEN20 )           {Move(CCW,CW,190,200);}
_0x135:
	CALL SUBOPT_0x18
	BREQ _0x137
	CALL SUBOPT_0x14
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDI  R26,LOW(200)
	RJMP _0x166
; 0000 0215 
; 0000 0216   else if  ( SEN4 )            {Move(CW,CCW,190,190);}
_0x137:
	CALL SUBOPT_0x24
	BREQ _0x139
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	RJMP _0x167
; 0000 0217   else if  ( SEN21 )           {Move(CCW,CW,190,190);}
_0x139:
	CALL SUBOPT_0x17
	BREQ _0x13B
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
_0x167:
	ST   -Y,R30
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDI  R26,LOW(190)
_0x166:
	RCALL _Move
; 0000 0218  p=3;
_0x13B:
_0x134:
_0x131:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x2F
; 0000 0219  }
; 0000 021A   if ( p==3 )
_0x12C:
	CALL SUBOPT_0x30
	SBIW R26,3
	BRNE _0x13C
; 0000 021B   {
; 0000 021C    if  ( SEN3 )            {Move(CW,CCW,190,255);}
	CALL SUBOPT_0x23
	BREQ _0x13D
	CALL SUBOPT_0x21
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x168
; 0000 021D   else if  ( SEN22 )           {Move(CCW,CW,255,190);}
_0x13D:
	CALL SUBOPT_0x16
	BREQ _0x13F
	CALL SUBOPT_0x14
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(190)
	RJMP _0x168
; 0000 021E 
; 0000 021F   else if  ( SEN2 )            {Move(CW,CCW,100,255);}
_0x13F:
	CALL SUBOPT_0x22
	BREQ _0x141
	CALL SUBOPT_0x21
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x168
; 0000 0220   else if  ( SEN23 )           {Move(CCW,CW,255,100);}
_0x141:
	CALL SUBOPT_0x15
	BREQ _0x143
	CALL SUBOPT_0x14
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(100)
	RJMP _0x168
; 0000 0221 
; 0000 0222   else if  ( SEN1 )            {Move(CW,CCW,50,255);}
_0x143:
	CALL SUBOPT_0x12
	BREQ _0x145
	CALL SUBOPT_0x21
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP _0x168
; 0000 0223   else if  ( SEN24 )           {Move(CCW,CW,255,50);}
_0x145:
	CALL SUBOPT_0x13
	BREQ _0x147
	CALL SUBOPT_0x14
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(50)
_0x168:
	RCALL _Move
; 0000 0224   p=0;
_0x147:
	LDI  R30,LOW(0)
	STS  _p,R30
	STS  _p+1,R30
; 0000 0225   }
; 0000 0226  // else {Move(CW,CW,0,0);}
; 0000 0227  }
_0x13C:
	RET
; .FEND
;
;void main(void)
; 0000 022A {
_main:
; .FSTART _main
; 0000 022B 
; 0000 022C // Input/Output Ports initialization
; 0000 022D // Port A initialization
; 0000 022E // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 022F DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(7)
	OUT  0x1A,R30
; 0000 0230 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 0231 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0232 // Port B initialization
; 0000 0233 // Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=out
; 0000 0234 DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(127)
	OUT  0x17,R30
; 0000 0235 // State: Bit7=T Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=T
; 0000 0236 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0237 // Port C initialization
; 0000 0238 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0239 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 023A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 023B PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 023C // Port D initialization
; 0000 023D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 023E DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 023F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0240 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0241 // Port E initialization
; 0000 0242 // Function: Bit7=Out Bit6=out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 0243 DDRE=(1<<DDE7) | (1<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (1<<DDE0);
	LDI  R30,LOW(193)
	OUT  0x2,R30
; 0000 0244 // State: Bit7=0 Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=0
; 0000 0245 PORTE=(0<<PORTE7) | (1<<PORTE6) | (1<<PORTE5) | (1<<PORTE4) | (1<<PORTE3) | (1<<PORTE2) | (1<<PORTE1) | (0<<PORTE0);
	LDI  R30,LOW(126)
	OUT  0x3,R30
; 0000 0246 // Port F initialization
; 0000 0247 // Function: Bit7=Out Bit6=In Bit5=In Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 0248 DDRF=(1<<DDF7) | (0<<DDF6) | (0<<DDF5) | (1<<DDF4) | (0<<DDF3) | (1<<DDF2) | (1<<DDF1) | (1<<DDF0);
	LDI  R30,LOW(151)
	STS  97,R30
; 0000 0249 // State: Bit7=0 Bit6=T Bit5=T Bit4=0 Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 024A PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 024B // Port G initialization
; 0000 024C // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 024D DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 024E // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 024F PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 0250 
; 0000 0251 // Timer/Counter 0 initialization
; 0000 0252 // Clock source: System Clock
; 0000 0253 // Clock value: 62/500 kHz
; 0000 0254 // Mode: Normal top=0xFF
; 0000 0255 // OC0 output: Disconnected
; 0000 0256 // Timer Period: 4/096 ms
; 0000 0257 ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 0258 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(6)
	OUT  0x33,R30
; 0000 0259 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 025A OCR0=0x00;
	OUT  0x31,R30
; 0000 025B 
; 0000 025C // Timer/Counter 1 initialization
; 0000 025D // Clock source: System Clock
; 0000 025E // Clock value: Timer1 Stopped
; 0000 025F // Mode: Normal top=0xFFFF
; 0000 0260 // OC1A output: Disconnected
; 0000 0261 // OC1B output: Disconnected
; 0000 0262 // OC1C output: Disconnected
; 0000 0263 // Noise Canceler: Off
; 0000 0264 // Input Capture on Falling Edge
; 0000 0265 // Timer1 Overflow Interrupt: Off
; 0000 0266 // Input Capture Interrupt: Off
; 0000 0267 // Compare A Match Interrupt: Off
; 0000 0268 // Compare B Match Interrupt: Off
; 0000 0269 // Compare C Match Interrupt: Off
; 0000 026A TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 026B TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 026C TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 026D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 026E ICR1H=0x00;
	OUT  0x27,R30
; 0000 026F ICR1L=0x00;
	OUT  0x26,R30
; 0000 0270 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0271 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0272 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0273 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0274 OCR1CH=0x00;
	STS  121,R30
; 0000 0275 OCR1CL=0x00;
	STS  120,R30
; 0000 0276 
; 0000 0277 // Timer/Counter 2 initialization
; 0000 0278 // Clock source: System Clock
; 0000 0279 // Clock value: 62/500 kHz
; 0000 027A // Mode: Normal top=0xFF
; 0000 027B // OC2 output: Disconnected
; 0000 027C // Timer Period: 4/096 ms
; 0000 027D TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 027E TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 027F OCR2=0x00;
	OUT  0x23,R30
; 0000 0280 
; 0000 0281 // Timer/Counter 3 initialization
; 0000 0282 // Clock source: System Clock
; 0000 0283 // Clock value: Timer3 Stopped
; 0000 0284 // Mode: Normal top=0xFFFF
; 0000 0285 // OC3A output: Disconnected
; 0000 0286 // OC3B output: Disconnected
; 0000 0287 // OC3C output: Disconnected
; 0000 0288 // Noise Canceler: Off
; 0000 0289 // Input Capture on Falling Edge
; 0000 028A // Timer3 Overflow Interrupt: Off
; 0000 028B // Input Capture Interrupt: Off
; 0000 028C // Compare A Match Interrupt: Off
; 0000 028D // Compare B Match Interrupt: Off
; 0000 028E // Compare C Match Interrupt: Off
; 0000 028F TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 0290 TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 0291 TCNT3H=0x00;
	STS  137,R30
; 0000 0292 TCNT3L=0x00;
	STS  136,R30
; 0000 0293 ICR3H=0x00;
	STS  129,R30
; 0000 0294 ICR3L=0x00;
	STS  128,R30
; 0000 0295 OCR3AH=0x00;
	STS  135,R30
; 0000 0296 OCR3AL=0x00;
	STS  134,R30
; 0000 0297 OCR3BH=0x00;
	STS  133,R30
; 0000 0298 OCR3BL=0x00;
	STS  132,R30
; 0000 0299 OCR3CH=0x00;
	STS  131,R30
; 0000 029A OCR3CL=0x00;
	STS  130,R30
; 0000 029B 
; 0000 029C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 029D TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(65)
	OUT  0x37,R30
; 0000 029E ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 029F 
; 0000 02A0 // External Interrupt(s) initialization
; 0000 02A1 // INT0: Off
; 0000 02A2 // INT1: Off
; 0000 02A3 // INT2: Off
; 0000 02A4 // INT3: Off
; 0000 02A5 // INT4: Off
; 0000 02A6 // INT5: Off
; 0000 02A7 // INT6: Off
; 0000 02A8 // INT7: Off
; 0000 02A9 EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 02AA EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 02AB EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 02AC 
; 0000 02AD // USART0 initialization
; 0000 02AE // USART0 disabled
; 0000 02AF UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	OUT  0xA,R30
; 0000 02B0 
; 0000 02B1 // USART1 initialization
; 0000 02B2 // USART1 disabled
; 0000 02B3 UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  154,R30
; 0000 02B4 
; 0000 02B5 // Analog Comparator initialization
; 0000 02B6 // Analog Comparator: Off
; 0000 02B7 // The Analog Comparator's positive input is
; 0000 02B8 // connected to the AIN0 pin
; 0000 02B9 // The Analog Comparator's negative input is
; 0000 02BA // connected to the AIN1 pin
; 0000 02BB ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02BC 
; 0000 02BD // ADC initialization
; 0000 02BE // ADC Clock frequency: 1000/000 kHz
; 0000 02BF // ADC Voltage Reference: AREF pin
; 0000 02C0 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 02C1 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 02C2 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02C3 
; 0000 02C4 // SPI initialization
; 0000 02C5 // SPI disabled
; 0000 02C6 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 02C7 
; 0000 02C8 // TWI initialization
; 0000 02C9 // TWI disabled
; 0000 02CA TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 02CB 
; 0000 02CC // Alphanumeric LCD initialization
; 0000 02CD // Connections are specified in the
; 0000 02CE // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 02CF // RS - PORTB Bit 6
; 0000 02D0 // RD - PORTB Bit 5
; 0000 02D1 // EN - PORTB Bit 4
; 0000 02D2 // D4 - PORTB Bit 3
; 0000 02D3 // D5 - PORTB Bit 2
; 0000 02D4 // D6 - PORTB Bit 1
; 0000 02D5 // D7 - PORTE Bit 7
; 0000 02D6 // Characters/line: 8
; 0000 02D7 lcd_init(8);
	LDI  R26,LOW(8)
	CALL _lcd_init
; 0000 02D8 
; 0000 02D9 // Global enable interrupts
; 0000 02DA #asm("sei")
	sei
; 0000 02DB while (1)
_0x148:
; 0000 02DC       {
; 0000 02DD 
; 0000 02DE         if ( !SWR )
	SBIC 0x1,3
	RJMP _0x14B
; 0000 02DF         {
; 0000 02E0          lcd_clear();
	CALL SUBOPT_0x31
; 0000 02E1          LEDG(1);
; 0000 02E2 
; 0000 02E3          while (1) {LineFollower();}
_0x14C:
	RCALL _LineFollower
	RJMP _0x14C
; 0000 02E4         }
; 0000 02E5         if ( !SWL )
_0x14B:
	SBIC 0x1,2
	RJMP _0x14F
; 0000 02E6         {
; 0000 02E7 
; 0000 02E8          LEDY(1);
	LDI  R26,LOW(1)
	RCALL _LEDY
; 0000 02E9 
; 0000 02EA          lcd_clear();
	CALL _lcd_clear
; 0000 02EB          lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 02EC          lcd_puts("SWR= CalR");
	__POINTW2MN _0x150,0
	CALL _lcd_puts
; 0000 02ED          lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 02EE          lcd_puts("SWL= CalL");
	__POINTW2MN _0x150,10
	CALL _lcd_puts
; 0000 02EF 
; 0000 02F0 
; 0000 02F1          if ( !SWR )
	SBIC 0x1,3
	RJMP _0x151
; 0000 02F2          {
; 0000 02F3          CalR();
	RCALL _CalR
; 0000 02F4 
; 0000 02F5          lcd_clear();
	CALL SUBOPT_0x31
; 0000 02F6 
; 0000 02F7          LEDG(1);
; 0000 02F8          delay_ms(100);
	CALL SUBOPT_0x32
; 0000 02F9          LEDG(0);
; 0000 02FA 
; 0000 02FB          // while (1) LineFollowerRGB();
; 0000 02FC          }
; 0000 02FD 
; 0000 02FE          if ( !SWL )
_0x151:
	SBIC 0x1,2
	RJMP _0x152
; 0000 02FF          {
; 0000 0300          CalL();
	RCALL _CalL
; 0000 0301 
; 0000 0302          lcd_clear();
	CALL SUBOPT_0x31
; 0000 0303 
; 0000 0304          LEDG(1);
; 0000 0305          delay_ms(100);
	CALL SUBOPT_0x32
; 0000 0306          LEDG(0);
; 0000 0307 
; 0000 0308           //  while (1) LineFollowerRGB();
; 0000 0309          }
; 0000 030A          if ( !SWM ) while (1) LineFollowerRGB();
_0x152:
	SBIC 0x1,1
	RJMP _0x153
_0x154:
	RCALL _LineFollowerRGB
	RJMP _0x154
; 0000 030C }
_0x153:
; 0000 030D 
; 0000 030E         }
_0x14F:
	RJMP _0x148
; 0000 030F 
; 0000 0310 }
_0x157:
	RJMP _0x157
; .FEND

	.DSEG
_0x150:
	.BYTE 0x14
;
;
;
;

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x33
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x33
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x34
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x35
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x34
	CALL SUBOPT_0x36
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x34
	CALL SUBOPT_0x36
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x34
	CALL SUBOPT_0x37
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x37
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x33
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x35
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x35
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x38
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x38
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G102:
; .FSTART __lcd_write_nibble_G102
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x18,3
	RJMP _0x2040005
_0x2040004:
	CBI  0x18,3
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x18,2
	RJMP _0x2040007
_0x2040006:
	CBI  0x18,2
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x18,1
	RJMP _0x2040009
_0x2040008:
	CBI  0x18,1
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x3,7
	RJMP _0x204000B
_0x204000A:
	CBI  0x3,7
_0x204000B:
	__DELAY_USB 27
	SBI  0x18,4
	__DELAY_USB 27
	CBI  0x18,4
	__DELAY_USB 27
	RJMP _0x20C0001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RJMP _0x20C0001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R8,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x39
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x39
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R8,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	CP   R8,R30
	BRLO _0x2040010
_0x2040011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040013
	RJMP _0x20C0001
_0x2040013:
_0x2040010:
	INC  R8
	SBI  0x18,6
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,6
	RJMP _0x20C0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x17,3
	SBI  0x17,2
	SBI  0x17,1
	SBI  0x2,7
	SBI  0x17,4
	SBI  0x17,6
	SBI  0x17,5
	CBI  0x18,4
	CBI  0x18,6
	CBI  0x18,5
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3A
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_RsenKeyON:
	.BYTE 0x2
_LsenKeyOFF:
	.BYTE 0x2
_RsenKeyOFF:
	.BYTE 0x2
_ColorNumL:
	.BYTE 0x2
_ColorNumR:
	.BYTE 0x2
_ColorCalL:
	.BYTE 0x2
_ColorCalR:
	.BYTE 0x2
_c:
	.BYTE 0x2
_d:
	.BYTE 0x2
_m:
	.BYTE 0x21
_p:
	.BYTE 0x2
__seed_G100:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CALL __SAVELOCR4
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	MOVW R18,R30
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	CBI  0x3,0
	LDI  R30,LOW(0)
	STS  _c,R30
	STS  _c+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R26,_c
	LDS  R27,_c+1
	SBIW R26,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_c)
	LDI  R27,HIGH(_c)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	SBI  0x3,0
	LDI  R30,LOW(0)
	STS  _d,R30
	STS  _d+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDS  R26,_d
	LDS  R27,_d+1
	SBIW R26,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_d)
	LDI  R27,HIGH(_d)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	CBI  0x3,0
	MOVW R26,R18
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R18,R30
	MOVW R26,R16
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOVW R16,R30
	SUB  R30,R18
	SBC  R31,R19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_m)
	LDI  R31,HIGH(_m)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x9:
	LDS  R30,_ColorCalR
	LDS  R31,_ColorCalR+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA:
	LDS  R30,_ColorCalL
	LDS  R31,_ColorCalL+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	STS  _LsenKeyOFF,R30
	STS  _LsenKeyOFF+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	STS  _RsenKeyOFF,R30
	STS  _RsenKeyOFF+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	STS  _RsenKeyON,R30
	STS  _RsenKeyON+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDS  R26,_LsenKeyOFF
	LDS  R27,_LsenKeyOFF+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDS  R26,_RsenKeyOFF
	LDS  R27,_RsenKeyOFF+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(1)
	CALL _LEDR
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(150)
	ST   -Y,R30
	LDI  R26,LOW(150)
	CALL _Move
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x12:
	LDI  R26,0
	SBIC 0x10,0
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x13:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x15:
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x16:
	LDI  R26,0
	SBIC 0x19,3
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x17:
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	LDI  R26,0
	SBIC 0x19,7
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x19:
	LDI  R26,0
	SBIC 0x13,7
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 52 TIMES, CODE SIZE REDUCTION:99 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1B:
	LDI  R26,0
	SBIC 0x13,6
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1C:
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1D:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1E:
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x1F:
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x20:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x22:
	LDI  R26,0
	SBIC 0x10,1
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x23:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x24:
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x25:
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x26:
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x27:
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x28:
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x29:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2A:
	LDS  R26,_ColorNumL
	LDS  R27,_ColorNumL+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2B:
	LDS  R26,_ColorNumR
	LDS  R27,_ColorNumR+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	MOV  R30,R9
	SUBI R30,-LOW(20)
	ST   -Y,R30
	MOV  R26,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	MOV  R30,R9
	SUBI R30,-LOW(60)
	ST   -Y,R30
	MOV  R26,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	MOV  R30,R9
	SUBI R30,-LOW(80)
	ST   -Y,R30
	MOV  R26,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	STS  _p,R30
	STS  _p+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDS  R26,_p
	LDS  R27,_p+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	CALL _lcd_clear
	LDI  R26,LOW(1)
	JMP  _LEDG

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(0)
	JMP  _LEDG

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x33:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x34:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x36:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x37:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3A:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G102
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
