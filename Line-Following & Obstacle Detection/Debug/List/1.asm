
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
	.DEF _gg=R8

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
	JMP  _ext_int5_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
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

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x3:
	.DB  0x2
_0x4:
	.DB  0x64
_0x0:
	.DB  0x2D,0x2D,0x0,0x31,0x32,0x0,0x31,0x33
	.DB  0x0,0x31,0x31,0x0,0x31,0x34,0x0,0x31
	.DB  0x30,0x0,0x31,0x35,0x0,0x30,0x39,0x0
	.DB  0x31,0x36,0x0,0x30,0x38,0x0,0x31,0x37
	.DB  0x0,0x30,0x37,0x0,0x31,0x38,0x0,0x30
	.DB  0x36,0x0,0x31,0x39,0x0,0x30,0x35,0x0
	.DB  0x32,0x30,0x0,0x30,0x34,0x0,0x32,0x31
	.DB  0x0,0x30,0x33,0x0,0x32,0x32,0x0,0x30
	.DB  0x32,0x0,0x32,0x33,0x0,0x30,0x31,0x0
	.DB  0x32,0x34,0x0,0x4C,0x69,0x6E,0x65,0x20
	.DB  0x46,0x6F,0x6C,0x6C,0x6F,0x77,0x65,0x0
	.DB  0x3C,0x30,0x3E,0x0,0x73,0x70,0x65,0x65
	.DB  0x64,0x3A,0x20,0x2B,0x0,0x25,0x0,0x43
	.DB  0x6F,0x6C,0x6F,0x72,0x20,0x53,0x65,0x6E
	.DB  0x73,0x6F,0x72,0x0,0x73,0x65,0x74,0x3D
	.DB  0x0,0x55,0x6C,0x74,0x72,0x61,0x53,0x6F
	.DB  0x6E,0x69,0x63,0x0,0x63,0x6D,0x0,0x20
	.DB  0x73,0x65,0x74,0x3D,0x35,0x7E,0x31,0x36
	.DB  0x0,0x48,0x45,0x4C,0x50,0x3A,0x20,0x20
	.DB  0x20,0x20,0x6F,0x20,0x20,0x6F,0x20,0x20
	.DB  0x6F,0x20,0x0,0x73,0x77,0x69,0x74,0x63
	.DB  0x68,0x73,0x20,0x20,0x5E,0x20,0x20,0x5E
	.DB  0x20,0x20,0x5E,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x2B
	.DB  0x20,0x20,0x6F,0x20,0x20,0x6F,0x20,0x0
	.DB  0x20,0x3C,0x2D,0x20,0x20,0x20,0x20,0x42
	.DB  0x61,0x63,0x6B,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x6F,0x20,0x20,0x2B,0x20
	.DB  0x20,0x6F,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x2D,0x20,0x20,0x20,0x20,0x53,0x65,0x74
	.DB  0x20,0x20,0x20,0x2D,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x6F,0x20,0x20,0x6F,0x20,0x20,0x2B
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x53
	.DB  0x74,0x61,0x72,0x74,0x20,0x20,0x20,0x2D
	.DB  0x3E,0x20,0x0,0x20,0x20,0x20,0x57,0x65
	.DB  0x6C,0x63,0x6F,0x6D,0x65,0x20,0x21,0x20
	.DB  0x20,0x20,0x20,0x0,0x43,0x68,0x6F,0x6F
	.DB  0x73,0x65,0x3A,0x20,0x20,0x31,0x20,0x20
	.DB  0x32,0x20,0x20,0x33,0x0,0x31,0x3A,0x20
	.DB  0x4C,0x69,0x6E,0x65,0x20,0x46,0x6F,0x6C
	.DB  0x6C,0x6F,0x77,0x0,0x32,0x3A,0x20,0x2B
	.DB  0x43,0x6F,0x6C,0x6F,0x72,0x0,0x33,0x3A
	.DB  0x20,0x2B,0x4F,0x62,0x73,0x74,0x61,0x63
	.DB  0x6C,0x65,0x0
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

	.DW  0x01
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _f
	.DW  _0x3*2

	.DW  0x01
	.DW  _j
	.DW  _0x4*2

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
;Project : Line Follower Robot with ability of Obstacle Detection
;Version : Final
;Date    : 05/30/2017
;Author  : Mohammad Amir Eshraghi
;Company : www.github.com/MAmirEshraghi/Line_Follower_Robot
;Comments: Description and Album available on my GitHub.
;
;
;Chip type               : ATmega64A
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
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
;#define UsKey  PORTB.0
;#define UsTrig PORTE.6
;
;//--------------------------------------------------
;
;bit i=0,f2;
;int a[23];
;int l;
;bit DirectionR,DirectionL,b;
;unsigned char SpeedR,SpeedL;
;
;unsigned char V;
;int RS;
;int LsenKeyON,RsenKeyON,LsenKeyOFF,RsenKeyOFF;
;unsigned int ColorNumL,ColorNumR,ColorCalL,ColorCalR,c,d;
;
;char m[33];
;char str[5];
;char gg=0,f=2;

	.DSEG
;char p,e,j=100,j1;
;unsigned int Time_us=0,cunter_ms=0,space_cm=0;
;unsigned int cunter_us=0;
;unsigned int cunter_ms,cunter_s;
;
;float u = 0.0;
;char k;
;
;
;//--------------------------------------------------
;
;
;void LEDG (char a)
; 0000 0078  {

	.CSEG
_LEDG:
; .FSTART _LEDG
; 0000 0079        if ( a == 1)PORTF|=0b00000100;
	ST   -Y,R26
;	a -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x5
	LDS  R30,98
	ORI  R30,4
	RJMP _0xD4
; 0000 007A   else if ( a == 0)PORTF&=0b11111011;
_0x5:
	LD   R30,Y
	CPI  R30,0
	BRNE _0x7
	LDS  R30,98
	ANDI R30,0xFB
_0xD4:
	STS  98,R30
; 0000 007B  }
_0x7:
	RJMP _0x20C0003
; .FEND
;void LEDY (char a)
; 0000 007D  {
_LEDY:
; .FSTART _LEDY
; 0000 007E        if ( a == 1)PORTF|=0b00000010;
	ST   -Y,R26
;	a -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x8
	LDS  R30,98
	ORI  R30,2
	RJMP _0xD5
; 0000 007F   else if ( a == 0)PORTF&=0b11111101;
_0x8:
	LD   R30,Y
	CPI  R30,0
	BRNE _0xA
	LDS  R30,98
	ANDI R30,0xFD
_0xD5:
	STS  98,R30
; 0000 0080  }
_0xA:
_0x20C0003:
	ADIW R28,1
	RET
; .FEND
;void LEDR (char a)
; 0000 0082  {
; 0000 0083        if ( a == 1)PORTF|=0b00000001;
;	a -> Y+0
; 0000 0084   else if ( a == 0)PORTF&=0b11111110;
; 0000 0085  }
;
;
;
;interrupt [EXT_INT5] void ext_int5_isr(void)
; 0000 008A {
_ext_int5_isr:
; .FSTART _ext_int5_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 008B   // Time_us = ((cunter_us*10)+ (cunter_ms*1000) );
; 0000 008C 
; 0000 008D       if( (PINE.5==1) )
	SBIS 0x1,5
	RJMP _0xE
; 0000 008E     {
; 0000 008F     cunter_us=0;
	CALL SUBOPT_0x0
; 0000 0090     cunter_ms=0;
; 0000 0091     Time_us=0;
	LDI  R30,LOW(0)
	STS  _Time_us,R30
	STS  _Time_us+1,R30
; 0000 0092 
; 0000 0093     TCNT1H=0xFF60 >> 8;
	CALL SUBOPT_0x1
; 0000 0094     TCNT1L=0xFF60 & 0xff;
; 0000 0095 
; 0000 0096     f=3;
	LDI  R30,LOW(3)
	STS  _f,R30
; 0000 0097 
; 0000 0098     LEDY(1);
	LDI  R26,LOW(1)
	RCALL _LEDY
; 0000 0099     LEDG(0);
	LDI  R26,LOW(0)
	RJMP _0xD7
; 0000 009A         }
; 0000 009B     else if( (PINE.5==0) )
_0xE:
	SBIC 0x1,5
	RJMP _0x10
; 0000 009C     {
; 0000 009D 
; 0000 009E    // Time_us = ((cunter_us*10) );
; 0000 009F     u = ( ( (340) * cunter_us ) / 2000 ) ;
	LDS  R30,_cunter_us
	LDS  R31,_cunter_us+1
	LDI  R26,LOW(340)
	LDI  R27,HIGH(340)
	CALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL __DIVW21U
	LDI  R26,LOW(_u)
	LDI  R27,HIGH(_u)
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __PUTDP1
; 0000 00A0 
; 0000 00A1     f=2;
	LDI  R30,LOW(2)
	STS  _f,R30
; 0000 00A2 
; 0000 00A3      cunter_us=0;
	CALL SUBOPT_0x0
; 0000 00A4      cunter_ms=0;
; 0000 00A5      //Time_us=0;
; 0000 00A6 
; 0000 00A7      TCNT1H=0xFF60 >> 8;
	CALL SUBOPT_0x1
; 0000 00A8      TCNT1L=0xFF60 & 0xff;
; 0000 00A9 
; 0000 00AA     LEDY(0);
	LDI  R26,LOW(0)
	RCALL _LEDY
; 0000 00AB     LEDG(1);
	LDI  R26,LOW(1)
_0xD7:
	RCALL _LEDG
; 0000 00AC 
; 0000 00AD     }
; 0000 00AE 
; 0000 00AF //    Time_us =  (cunter_us) ;
; 0000 00B0 //    //space_cm=0;
; 0000 00B1 //  //  space_cm = (17 * Time_us) / 1000 ;
; 0000 00B2 //    space_cm = ( ( (340) * Time_us) / 2000 ) ;
; 0000 00B3 
; 0000 00B4 //    cunter_us=0;
; 0000 00B5 //    cunter_ms=0;
; 0000 00B6 
; 0000 00B7 }
_0x10:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00B9 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00BA // Reinitialize Timer1 value
; 0000 00BB TCNT1H=0xFF60 >> 8;
	CALL SUBOPT_0x1
; 0000 00BC TCNT1L=0xFF60 & 0xff;
; 0000 00BD 
; 0000 00BE 
; 0000 00BF  //TCNT0=0xF6;
; 0000 00C0  cunter_us++;
	LDI  R26,LOW(_cunter_us)
	LDI  R27,HIGH(_cunter_us)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00C1  //cunter_ms++;
; 0000 00C2 
; 0000 00C3 // delay_us(500);
; 0000 00C4  if ( cunter_us == 500 )
	LDS  R26,_cunter_us
	LDS  R27,_cunter_us+1
	CPI  R26,LOW(0x1F4)
	LDI  R30,HIGH(0x1F4)
	CPC  R27,R30
	BRNE _0x11
; 0000 00C5  {
; 0000 00C6   cunter_us=0;
	LDI  R30,LOW(0)
	STS  _cunter_us,R30
	STS  _cunter_us+1,R30
; 0000 00C7   cunter_ms++;
	LDI  R26,LOW(_cunter_ms)
	LDI  R27,HIGH(_cunter_ms)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00C8  }
; 0000 00C9  if ( cunter_ms == 50 )
_0x11:
	LDS  R26,_cunter_ms
	LDS  R27,_cunter_ms+1
	SBIW R26,50
	BRNE _0x12
; 0000 00CA  {
; 0000 00CB  cunter_ms=0;
	LDI  R30,LOW(0)
	STS  _cunter_ms,R30
	STS  _cunter_ms+1,R30
; 0000 00CC  }
; 0000 00CD // else LEDR(0);
; 0000 00CE // if ( cunter_s == 100 )
; 0000 00CF // {
; 0000 00D0 //  cunter_s=0;
; 0000 00D1 // }
; 0000 00D2 
; 0000 00D3  }
_0x12:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00D9  {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00DA   static bit K0=0;
; 0000 00DB 
; 0000 00DC   if ( K0 )
	SBRS R2,5
	RJMP _0x13
; 0000 00DD   {
; 0000 00DE    TCNT0 = 255 - SpeedR;
	LDI  R30,LOW(255)
	SUB  R30,R7
	OUT  0x32,R30
; 0000 00DF    K0=0;
	CLT
	BLD  R2,5
; 0000 00E0 
; 0000 00E1    if      ( DirectionR ==  CW )
	SBRC R2,2
	RJMP _0x14
; 0000 00E2    {
; 0000 00E3     In1MotR = 1;
	SBI  0x1B,1
; 0000 00E4     In2MotR = 0;
	CBI  0x1B,2
; 0000 00E5    }
; 0000 00E6    else if ( DirectionR == CCW )
	RJMP _0x19
_0x14:
	SBRS R2,2
	RJMP _0x1A
; 0000 00E7    {
; 0000 00E8     In1MotR = 0;
	CBI  0x1B,1
; 0000 00E9     In2MotR = 1;
	SBI  0x1B,2
; 0000 00EA    }
; 0000 00EB 
; 0000 00EC   }
_0x1A:
_0x19:
; 0000 00ED   else if ( !K0 )
	RJMP _0x1F
_0x13:
	SBRC R2,5
	RJMP _0x20
; 0000 00EE   {
; 0000 00EF    TCNT0=SpeedR;
	OUT  0x32,R7
; 0000 00F0    K0=1;
	SET
	BLD  R2,5
; 0000 00F1 
; 0000 00F2    In1MotR = 0;
	CBI  0x1B,1
; 0000 00F3    In2MotR = 0;
	CBI  0x1B,2
; 0000 00F4   }
; 0000 00F5 
; 0000 00F6  }
_0x20:
_0x1F:
	RJMP _0xD9
; .FEND
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 00F8  {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00F9   static bit KP2=0;
; 0000 00FA   if(KP2)
	SBRS R2,6
	RJMP _0x25
; 0000 00FB   {
; 0000 00FC     TCNT2=255-SpeedL;
	LDI  R30,LOW(255)
	SUB  R30,R6
	OUT  0x24,R30
; 0000 00FD     KP2=0;
	CLT
	BLD  R2,6
; 0000 00FE     if(DirectionL==CW)
	SBRC R2,3
	RJMP _0x26
; 0000 00FF     {
; 0000 0100         In1MotL=0;
	CBI  0x1B,0
; 0000 0101         //In2MotL=1;
; 0000 0102         PORTF|=0b10000000;
	LDS  R30,98
	ORI  R30,0x80
	RJMP _0xD8
; 0000 0103     }
; 0000 0104     else if(DirectionL==CCW)
_0x26:
	SBRS R2,3
	RJMP _0x2A
; 0000 0105     {
; 0000 0106         In1MotL=1;
	SBI  0x1B,0
; 0000 0107         //In2MotL=0;
; 0000 0108         PORTF&=0b01111111;
	LDS  R30,98
	ANDI R30,0x7F
_0xD8:
	STS  98,R30
; 0000 0109     }
; 0000 010A   }
_0x2A:
; 0000 010B   else if(!KP2)
	RJMP _0x2D
_0x25:
	SBRC R2,6
	RJMP _0x2E
; 0000 010C   {
; 0000 010D     TCNT2=SpeedL;
	OUT  0x24,R6
; 0000 010E     KP2=1;
	SET
	BLD  R2,6
; 0000 010F 
; 0000 0110     In1MotL=0;
	CBI  0x1B,0
; 0000 0111     //In2MotL=0;
; 0000 0112     PORTF&=0b01111111;
	LDS  R30,98
	ANDI R30,0x7F
	STS  98,R30
; 0000 0113   }
; 0000 0114  }
_0x2E:
_0x2D:
_0xD9:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;// Voltage Reference: AVCC pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (1<<ADLAR))
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 011C {
_read_adc:
; .FSTART _read_adc
; 0000 011D ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 011E // Delay needed for the stabilization of the ADC input voltage
; 0000 011F delay_us(10);
	__DELAY_USB 53
; 0000 0120 // Start the AD conversion
; 0000 0121 ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 0122 // Wait for the AD conversion to complete
; 0000 0123 while ((ADCSRA & (1<<ADIF))==0);
_0x31:
	SBIS 0x6,4
	RJMP _0x31
; 0000 0124 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0125 return ADCH;
	IN   R30,0x5
	JMP  _0x20C0001
; 0000 0126 }
; .FEND
;
;
;void Move(char DL,char DR,unsigned char SL,unsigned char SR)
; 0000 012A {
_Move:
; .FSTART _Move
; 0000 012B     DirectionL=DL;
	ST   -Y,R26
;	DL -> Y+3
;	DR -> Y+2
;	SL -> Y+1
;	SR -> Y+0
	LDD  R30,Y+3
	CALL __BSTB1
	BLD  R2,3
; 0000 012C     DirectionR=DR;
	LDD  R30,Y+2
	CALL __BSTB1
	BLD  R2,2
; 0000 012D     SpeedL=SL;
	LDD  R6,Y+1
; 0000 012E     SpeedR=SR;
	LDD  R7,Y+0
; 0000 012F }
	ADIW R28,4
	RET
; .FEND
;
;void revolve()
; 0000 0132 {
; 0000 0133  while (!SEN1)    Move(CCW,CW,100,150);
; 0000 0135 Move(0,0,200,200);
; 0000 0136   delay_ms(40);
; 0000 0137 
; 0000 0138  while ( !SEN12 )
; 0000 0139  {
; 0000 013A 
; 0000 013B   for (e=0;e<150;e++)
; 0000 013C    {
; 0000 013D 
; 0000 013E     Move(CW,CW,(100+e),(70));
; 0000 013F     delay_ms(10);
; 0000 0140     if           ( (SEN12) || (SEN13) )
; 0000 0141     {
; 0000 0142      break;
; 0000 0143     }
; 0000 0144     else if      ( (!SEN12) || (!SEN13) )
; 0000 0145     {
; 0000 0146      if ( e == 149 )
; 0000 0147      {
; 0000 0148       e=0;
; 0000 0149      }
; 0000 014A     }
; 0000 014B 
; 0000 014C    }
; 0000 014D  break;
; 0000 014E  }
; 0000 014F 
; 0000 0150 }
;
;void space()
; 0000 0153 {
; 0000 0154 
; 0000 0155 // if      ( (p==0) && ( 20 < k < 30 ) )
; 0000 0156 // {
; 0000 0157 // p=1;
; 0000 0158 // LEDR(1);
; 0000 0159 // }
; 0000 015A // else if ( (p==1) && (( k > 15) && ( k < 21 )) )
; 0000 015B //
; 0000 015C // {
; 0000 015D // p=2;
; 0000 015E // //LEDR(1);
; 0000 015F // }
; 0000 0160 //
; 0000 0161 
; 0000 0162        UsTrig=1;
; 0000 0163        delay_us(20);
; 0000 0164        UsTrig=0;
; 0000 0165        delay_us(20);
; 0000 0166 
; 0000 0167        k=u;
; 0000 0168 
; 0000 0169   if (  (( k > 5) && ( k < 16 )) )
; 0000 016A  {
; 0000 016B   LEDR(1);
; 0000 016C   revolve();
; 0000 016D  }
; 0000 016E  else {LEDR(0);}
; 0000 016F }
;
;void LineFollower ()
; 0000 0172  {
_LineFollower:
; .FSTART _LineFollower
; 0000 0173      i=0;
	CLT
	BLD  R2,0
; 0000 0174 //  //ReadSen();
; 0000 0175 //
; 0000 0176 //  if ( SEN7 && SEN8 &&  SEN11 && SEN12 && SEN13 && SEN14 && SEN15 && SEN16 && SEN17 && SEN18 )
; 0000 0177 //  {
; 0000 0178 //   i=!i;
; 0000 0179 //  }
; 0000 017A //       if ( i==1 ) LEDR(1);
; 0000 017B //  else if ( i==0 ) LEDR(0);
; 0000 017C  /*
; 0000 017D  if (p==1){
; 0000 017E        if  ( SEN12 && SEN13 )  {Move(CW,CW,V,V);space();}
; 0000 017F   else if  ( SEN12 )           {Move(CW,CW,20+V,V);space();}
; 0000 0180   else if  ( SEN13 )           {Move(CW,CW,V,20+V);space();}
; 0000 0181   }
; 0000 0182   */
; 0000 0183    //else if (p==0){
; 0000 0184        if  ( SEN12 && SEN13 )  {Move(CW,CW,V,V);lcd_gotoxy(0,0);lcd_putsf("--");}
	CALL SUBOPT_0x2
	BREQ _0x4E
	CALL SUBOPT_0x3
	BRNE _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
	CALL SUBOPT_0x4
	ST   -Y,R9
	CALL SUBOPT_0x5
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0185   else if  ( SEN12 )           {Move(CW,CW,20+V,V);lcd_gotoxy(0,0);lcd_putsf("12");}
	RJMP _0x50
_0x4D:
	CALL SUBOPT_0x2
	BREQ _0x51
	CALL SUBOPT_0x4
	MOV  R30,R9
	SUBI R30,-LOW(20)
	ST   -Y,R30
	CALL SUBOPT_0x5
	__POINTW2FN _0x0,3
	CALL _lcd_putsf
; 0000 0186   else if  ( SEN13 )           {Move(CW,CW,V,20+V);lcd_gotoxy(0,0);lcd_putsf("13");}
	RJMP _0x52
_0x51:
	CALL SUBOPT_0x3
	BREQ _0x53
	CALL SUBOPT_0x4
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(20)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,6
	CALL _lcd_putsf
; 0000 0187   //}
; 0000 0188   else if  ( SEN11 )           {Move(CW,CW,40+V,V);lcd_gotoxy(0,0);lcd_putsf("11");}
	RJMP _0x54
_0x53:
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x55
	CALL SUBOPT_0x4
	MOV  R30,R9
	SUBI R30,-LOW(40)
	ST   -Y,R30
	CALL SUBOPT_0x5
	__POINTW2FN _0x0,9
	CALL _lcd_putsf
; 0000 0189   else if  ( SEN14 )           {Move(CW,CW,V,40+V);lcd_gotoxy(0,0);lcd_putsf("14");}
	RJMP _0x56
_0x55:
	LDI  R26,0
	SBIC 0x13,3
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x57
	CALL SUBOPT_0x4
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(40)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,12
	CALL _lcd_putsf
; 0000 018A 
; 0000 018B   //        ( SEN10 )              Move(CW,CW,60+V,V);
; 0000 018C   else if  ( i == 0 ) if ( SEN10  ){{Move(CW,CW,60+V,V);lcd_gotoxy(0,0);lcd_putsf("10");}}
	RJMP _0x58
_0x57:
	SBRC R2,0
	RJMP _0x59
	LDS  R30,99
	ANDI R30,LOW(0x2)
	BREQ _0x5A
	CALL SUBOPT_0x4
	MOV  R30,R9
	SUBI R30,-LOW(60)
	ST   -Y,R30
	CALL SUBOPT_0x5
	__POINTW2FN _0x0,15
	CALL _lcd_putsf
; 0000 018D   else if  ( i == 1 ) if ( SEN10N ) {Move(CW,CW,60+V,V);}
	RJMP _0x5B
_0x5A:
	SBRS R2,0
	RJMP _0x5C
	LDS  R30,99
	ANDI R30,LOW(0x0)
	BREQ _0x5D
	CALL SUBOPT_0x4
	MOV  R30,R9
	SUBI R30,-LOW(60)
	ST   -Y,R30
	MOV  R26,R9
	RCALL _Move
; 0000 018E   else if  ( SEN15 )                {Move(CW,CW,V,60+V);lcd_gotoxy(0,0);lcd_putsf("15");}
	RJMP _0x5E
_0x5D:
	LDI  R26,0
	SBIC 0x13,4
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x5F
	CALL SUBOPT_0x4
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(60)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,18
	CALL _lcd_putsf
; 0000 018F 
; 0000 0190 
; 0000 0191   //         ( SEN9 )               Move(CW,CW,80+V,V);
; 0000 0192   else if  ( i == 0 ){if ( SEN9  )  {Move(CW,CW,80+V,V);lcd_gotoxy(0,0);lcd_putsf("09");}}
	RJMP _0x60
_0x5F:
	SBRC R2,0
	RJMP _0x61
	LDS  R30,99
	ANDI R30,LOW(0x1)
	BREQ _0x62
	CALL SUBOPT_0x4
	MOV  R30,R9
	SUBI R30,-LOW(80)
	ST   -Y,R30
	CALL SUBOPT_0x5
	__POINTW2FN _0x0,21
	CALL _lcd_putsf
_0x62:
; 0000 0193   else if  ( i == 1 ){if ( SEN9N )  {Move(CW,CW,80+V,V);}}
	RJMP _0x63
_0x61:
	SBRS R2,0
	RJMP _0x64
	LDS  R30,99
	ANDI R30,LOW(0x0)
	BREQ _0x65
	CALL SUBOPT_0x4
	MOV  R30,R9
	SUBI R30,-LOW(80)
	ST   -Y,R30
	MOV  R26,R9
	RCALL _Move
_0x65:
; 0000 0194   else if  ( SEN16 )                {Move(CW,CW,V,80+V);lcd_gotoxy(0,0);lcd_putsf("16");}
	RJMP _0x66
_0x64:
	LDI  R26,0
	SBIC 0x13,5
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x67
	CALL SUBOPT_0x4
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(80)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,24
	CALL _lcd_putsf
; 0000 0195 
; 0000 0196   else if  ( SEN8 )            {Move(CW,CW,100+V,V);lcd_gotoxy(0,0);lcd_putsf("08");}
	RJMP _0x68
_0x67:
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x69
	CALL SUBOPT_0x4
	MOV  R30,R9
	SUBI R30,-LOW(100)
	ST   -Y,R30
	CALL SUBOPT_0x5
	__POINTW2FN _0x0,27
	CALL _lcd_putsf
; 0000 0197   else if  ( SEN17 )           {Move(CW,CW,V,100+V);lcd_gotoxy(0,0);lcd_putsf("17");}
	RJMP _0x6A
_0x69:
	LDI  R26,0
	SBIC 0x13,6
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x6B
	CALL SUBOPT_0x4
	ST   -Y,R9
	MOV  R26,R9
	SUBI R26,-LOW(100)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,30
	CALL _lcd_putsf
; 0000 0198 
; 0000 0199   else if  ( SEN7 )            {Move(CW,CW,150,0);lcd_gotoxy(0,0);lcd_putsf("07");}
	RJMP _0x6C
_0x6B:
	LDI  R26,0
	SBIC 0x10,6
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x6D
	CALL SUBOPT_0x4
	LDI  R30,LOW(150)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,33
	CALL _lcd_putsf
; 0000 019A   else if  ( SEN18 )           {Move(CW,CW,0,150);lcd_gotoxy(0,0);lcd_putsf("18");}
	RJMP _0x6E
_0x6D:
	LDI  R26,0
	SBIC 0x13,7
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x6F
	CALL SUBOPT_0x4
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(150)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,36
	CALL _lcd_putsf
; 0000 019B 
; 0000 019C 
; 0000 019D   else if  ( SEN6 )                 {lcd_gotoxy(0,0);lcd_putsf("06");Move(CW,CW,250,0);}
	RJMP _0x70
_0x6F:
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x71
	CALL SUBOPT_0x8
	__POINTW2FN _0x0,39
	CALL _lcd_putsf
	CALL SUBOPT_0x4
	LDI  R30,LOW(250)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _Move
; 0000 019E   //        ( SEN19 )              Move(CW,CW,0,250);
; 0000 019F   else if  ( i == 0 ) {if ( SEN19  ){lcd_gotoxy(0,0);lcd_putsf("19");Move(CW,CW,0,250);}}
	RJMP _0x72
_0x71:
	SBRC R2,0
	RJMP _0x73
	LDS  R30,99
	ANDI R30,LOW(0x4)
	BREQ _0x74
	CALL SUBOPT_0x8
	__POINTW2FN _0x0,42
	CALL _lcd_putsf
	CALL SUBOPT_0x4
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(250)
	RCALL _Move
_0x74:
; 0000 01A0   else if  ( i == 1 ) {if ( SEN19N ){Move(CW,CW,0,250);}}
	RJMP _0x75
_0x73:
	SBRS R2,0
	RJMP _0x76
	LDS  R30,99
	ANDI R30,LOW(0x0)
	BREQ _0x77
	CALL SUBOPT_0x4
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(250)
	RCALL _Move
_0x77:
; 0000 01A1 
; 0000 01A2   else if  ( SEN5 )            {Move(CW,CCW,200,100);lcd_gotoxy(0,0);lcd_putsf("05");}
	RJMP _0x78
_0x76:
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x79
	CALL SUBOPT_0x9
	LDI  R30,LOW(200)
	ST   -Y,R30
	LDI  R26,LOW(100)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,45
	CALL _lcd_putsf
; 0000 01A3   else if  ( SEN20 )           {Move(CCW,CW,190,200);lcd_gotoxy(0,0);lcd_putsf("20");}
	RJMP _0x7A
_0x79:
	LDI  R26,0
	SBIC 0x19,7
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x7B
	CALL SUBOPT_0xA
	LDI  R26,LOW(200)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,48
	CALL _lcd_putsf
; 0000 01A4 
; 0000 01A5   else if  ( SEN4 )            {Move(CW,CCW,190,190);lcd_gotoxy(0,0);lcd_putsf("04");}
	RJMP _0x7C
_0x7B:
	LDI  R26,0
	SBIC 0x10,3
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x7D
	CALL SUBOPT_0x9
	LDI  R30,LOW(190)
	ST   -Y,R30
	LDI  R26,LOW(190)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,51
	CALL _lcd_putsf
; 0000 01A6   else if  ( SEN21 )           {Move(CCW,CW,190,190);lcd_gotoxy(0,0);lcd_putsf("21");}
	RJMP _0x7E
_0x7D:
	LDI  R26,0
	SBIC 0x19,6
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x7F
	CALL SUBOPT_0xA
	LDI  R26,LOW(190)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,54
	CALL _lcd_putsf
; 0000 01A7 
; 0000 01A8 
; 0000 01A9   else if  ( SEN3 )            {Move(CW,CCW,190,255);lcd_gotoxy(0,0);lcd_putsf("03");}
	RJMP _0x80
_0x7F:
	LDI  R26,0
	SBIC 0x10,2
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x81
	CALL SUBOPT_0x9
	LDI  R30,LOW(190)
	CALL SUBOPT_0xB
	__POINTW2FN _0x0,57
	CALL _lcd_putsf
; 0000 01AA   else if  ( SEN22 )           {Move(CCW,CW,255,190);lcd_gotoxy(0,0);lcd_putsf("22");}
	RJMP _0x82
_0x81:
	LDI  R26,0
	SBIC 0x19,3
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x83
	CALL SUBOPT_0xC
	LDI  R26,LOW(190)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,60
	CALL _lcd_putsf
; 0000 01AB 
; 0000 01AC   else if  ( SEN2 )            {Move(CW,CCW,100,255);lcd_gotoxy(0,0);lcd_putsf("02");}
	RJMP _0x84
_0x83:
	LDI  R26,0
	SBIC 0x10,1
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x85
	CALL SUBOPT_0x9
	LDI  R30,LOW(100)
	CALL SUBOPT_0xB
	__POINTW2FN _0x0,63
	CALL _lcd_putsf
; 0000 01AD   else if  ( SEN23 )           {Move(CCW,CW,255,100);lcd_gotoxy(0,0);lcd_putsf("23");}
	RJMP _0x86
_0x85:
	LDI  R26,0
	SBIC 0x19,4
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x87
	CALL SUBOPT_0xC
	LDI  R26,LOW(100)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,66
	CALL _lcd_putsf
; 0000 01AE 
; 0000 01AF   else if  ( SEN1 )            {Move(CW,CCW,50,255);lcd_gotoxy(0,0);lcd_putsf("01");}
	RJMP _0x88
_0x87:
	LDI  R26,0
	SBIC 0x10,0
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x89
	CALL SUBOPT_0x9
	LDI  R30,LOW(50)
	CALL SUBOPT_0xB
	__POINTW2FN _0x0,69
	CALL _lcd_putsf
; 0000 01B0   else if  ( SEN24 )           {Move(CCW,CW,255,50);lcd_gotoxy(0,0);lcd_putsf("24");}
	RJMP _0x8A
_0x89:
	LDI  R26,0
	SBIC 0x19,5
	LDI  R26,1
	CALL SUBOPT_0x7
	BREQ _0x8B
	CALL SUBOPT_0xC
	LDI  R26,LOW(50)
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,72
	CALL _lcd_putsf
; 0000 01B1 
; 0000 01B2   else {Move(CW,CW,0,0);lcd_clear();}
	RJMP _0x8C
_0x8B:
	CALL SUBOPT_0x4
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _Move
	CALL _lcd_clear
_0x8C:
_0x8A:
_0x88:
_0x86:
_0x84:
_0x82:
_0x80:
_0x7E:
_0x7C:
_0x7A:
_0x78:
_0x75:
_0x72:
_0x70:
_0x6E:
_0x6C:
_0x6A:
_0x68:
_0x66:
_0x63:
_0x60:
_0x5E:
; 0000 01B3  }
_0x5C:
_0x5B:
_0x59:
_0x58:
_0x56:
_0x54:
_0x52:
_0x50:
	RET
; .FEND
;
;
;void choose()
; 0000 01B7 {
_choose:
; .FSTART _choose
; 0000 01B8 
; 0000 01B9 
; 0000 01BA 
; 0000 01BB  if ( !SWR &&  SWM &&  SWL) {f2=1;delay_ms(20);while(f2==1)
	SBIC 0x1,3
	RJMP _0x8E
	SBIS 0x1,1
	RJMP _0x8E
	SBIC 0x1,2
	RJMP _0x8F
_0x8E:
	RJMP _0x8D
_0x8F:
	CALL SUBOPT_0xD
_0x90:
	SBRS R2,1
	RJMP _0x92
; 0000 01BC   {
; 0000 01BD 
; 0000 01BE    if ( SWR &&  SWM &&  !SWL){lcd_clear();while(1){LineFollower();}}
	SBIS 0x1,3
	RJMP _0x94
	SBIS 0x1,1
	RJMP _0x94
	SBIS 0x1,2
	RJMP _0x95
_0x94:
	RJMP _0x93
_0x95:
	CALL _lcd_clear
_0x96:
	RCALL _LineFollower
	RJMP _0x96
; 0000 01BF 
; 0000 01C0    V = VolomADC;
_0x93:
	LDI  R26,LOW(6)
	RCALL _read_adc
	MOV  R9,R30
; 0000 01C1       lcd_gotoxy(0,0);
	CALL SUBOPT_0x8
; 0000 01C2       lcd_putsf("Line Followe");
	__POINTW2FN _0x0,75
	CALL SUBOPT_0xE
; 0000 01C3       lcd_gotoxy(13,0);
; 0000 01C4         lcd_putsf("<0>");
; 0000 01C5       lcd_gotoxy(0,1);
; 0000 01C6        lcd_putsf("speed: +");
	__POINTW2FN _0x0,92
	CALL SUBOPT_0xF
; 0000 01C7       lcd_gotoxy(0,13);
	LDI  R26,LOW(13)
	CALL SUBOPT_0x10
; 0000 01C8        itoa(V,str);
; 0000 01C9        lcd_puts(str);
; 0000 01CA        lcd_putsf("%");
	__POINTW2FN _0x0,101
	CALL _lcd_putsf
; 0000 01CB 
; 0000 01CC    if(V==9 || V==99)lcd_clear();
	LDI  R30,LOW(9)
	CP   R30,R9
	BREQ _0x9A
	LDI  R30,LOW(99)
	CP   R30,R9
	BRNE _0x99
_0x9A:
	CALL _lcd_clear
; 0000 01CD 
; 0000 01CE    //p=0;LineFollower();
; 0000 01CF 
; 0000 01D0    if ( !SWR &&  SWM &&  SWL)f2=0;      //sicktir
_0x99:
	SBIC 0x1,3
	RJMP _0x9D
	SBIS 0x1,1
	RJMP _0x9D
	SBIC 0x1,2
	RJMP _0x9E
_0x9D:
	RJMP _0x9C
_0x9E:
	CLT
	BLD  R2,1
; 0000 01D1   }}
_0x9C:
	RJMP _0x90
_0x92:
; 0000 01D2 
; 0000 01D3  if (  SWR && !SWM &&  SWL) {f2=1;delay_ms(20);while(f2==1)
_0x8D:
	SBIS 0x1,3
	RJMP _0xA0
	SBIC 0x1,1
	RJMP _0xA0
	SBIC 0x1,2
	RJMP _0xA1
_0xA0:
	RJMP _0x9F
_0xA1:
	CALL SUBOPT_0xD
_0xA2:
	SBRS R2,1
	RJMP _0xA4
; 0000 01D4   {
; 0000 01D5       lcd_gotoxy(0,0);
	CALL SUBOPT_0x8
; 0000 01D6       lcd_putsf("Color Sensor");
	__POINTW2FN _0x0,103
	CALL SUBOPT_0xE
; 0000 01D7       lcd_gotoxy(13,0);
; 0000 01D8         lcd_putsf("<0>");
; 0000 01D9       lcd_gotoxy(0,1);
; 0000 01DA       lcd_putsf("set=");
	__POINTW2FN _0x0,116
	CALL SUBOPT_0xF
; 0000 01DB       lcd_gotoxy(0,14);
	LDI  R26,LOW(14)
	CALL SUBOPT_0x10
; 0000 01DC       itoa(V,str);
; 0000 01DD       lcd_puts(str);
; 0000 01DE       if(V==9 || V==99)lcd_clear();
	LDI  R30,LOW(9)
	CP   R30,R9
	BREQ _0xA6
	LDI  R30,LOW(99)
	CP   R30,R9
	BRNE _0xA5
_0xA6:
	CALL _lcd_clear
; 0000 01DF       if ( !SWR && SWM &&  SWL)f2=0;      //sicktir
_0xA5:
	SBIC 0x1,3
	RJMP _0xA9
	SBIS 0x1,1
	RJMP _0xA9
	SBIC 0x1,2
	RJMP _0xAA
_0xA9:
	RJMP _0xA8
_0xAA:
	CLT
	BLD  R2,1
; 0000 01E0   }}
_0xA8:
	RJMP _0xA2
_0xA4:
; 0000 01E1 
; 0000 01E2  if (  SWR &&  SWM && !SWL) {f2=1;delay_ms(20);while(f2==1)
_0x9F:
	SBIS 0x1,3
	RJMP _0xAC
	SBIS 0x1,1
	RJMP _0xAC
	SBIS 0x1,2
	RJMP _0xAD
_0xAC:
	RJMP _0xAB
_0xAD:
	CALL SUBOPT_0xD
_0xAE:
	SBRS R2,1
	RJMP _0xB0
; 0000 01E3   {
; 0000 01E4       lcd_gotoxy(0,0);
	CALL SUBOPT_0x8
; 0000 01E5       lcd_putsf("UltraSonic");
	__POINTW2FN _0x0,121
	CALL SUBOPT_0xE
; 0000 01E6       lcd_gotoxy(13,0);
; 0000 01E7         lcd_putsf("<0>");
; 0000 01E8       lcd_gotoxy(0,1);
; 0000 01E9       lcd_putsf("=");
	__POINTW2FN _0x0,119
	CALL _lcd_putsf
; 0000 01EA 
; 0000 01EB        UsTrig=1;
	SBI  0x3,6
; 0000 01EC        delay_us(20);
	__DELAY_USB 107
; 0000 01ED        UsTrig=0;
	CBI  0x3,6
; 0000 01EE        delay_us(20);
	__DELAY_USB 107
; 0000 01EF 
; 0000 01F0       lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x11
; 0000 01F1       itoa(u,str);
	LDS  R30,_u
	LDS  R31,_u+1
	LDS  R22,_u+2
	LDS  R23,_u+3
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _itoa
; 0000 01F2       lcd_puts(str);
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _lcd_puts
; 0000 01F3       lcd_putsf("cm");
	__POINTW2FN _0x0,132
	CALL _lcd_putsf
; 0000 01F4 
; 0000 01F5       lcd_gotoxy(6,1);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x11
; 0000 01F6       lcd_putsf(" set=5~16");
	__POINTW2FN _0x0,135
	CALL _lcd_putsf
; 0000 01F7 
; 0000 01F8 
; 0000 01F9       if(u==9 || u==99)lcd_clear();
	CALL SUBOPT_0x12
	__CPD2N 0x41100000
	BREQ _0xB6
	CALL SUBOPT_0x12
	__CPD2N 0x42C60000
	BRNE _0xB5
_0xB6:
	CALL _lcd_clear
; 0000 01FA 
; 0000 01FB       p=1;LineFollower();
_0xB5:
	LDI  R30,LOW(1)
	STS  _p,R30
	RCALL _LineFollower
; 0000 01FC 
; 0000 01FD       if ( !SWR &&  SWM &&  SWL)f2=0;      //sicktir
	SBIC 0x1,3
	RJMP _0xB9
	SBIS 0x1,1
	RJMP _0xB9
	SBIC 0x1,2
	RJMP _0xBA
_0xB9:
	RJMP _0xB8
_0xBA:
	CLT
	BLD  R2,1
; 0000 01FE   }}
_0xB8:
	RJMP _0xAE
_0xB0:
; 0000 01FF 
; 0000 0200 
; 0000 0201 }
_0xAB:
	RET
; .FEND
;
;void main(void)
; 0000 0204 {
_main:
; .FSTART _main
; 0000 0205 DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(7)
	OUT  0x1A,R30
; 0000 0206 PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0207 
; 0000 0208 DDRB=(0<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(127)
	OUT  0x17,R30
; 0000 0209 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 020A 
; 0000 020B DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 020C PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 020D 
; 0000 020E DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 020F PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 0210 
; 0000 0211 DDRE=(1<<DDE7) | (1<<DDE6) | (0<<DDE5) | (0<<DDE4) | (0<<DDE3) | (0<<DDE2) | (0<<DDE1) | (1<<DDE0);
	LDI  R30,LOW(193)
	OUT  0x2,R30
; 0000 0212 PORTE=(0<<PORTE7) | (1<<PORTE6) | (1<<PORTE5) | (1<<PORTE4) | (1<<PORTE3) | (1<<PORTE2) | (1<<PORTE1) | (0<<PORTE0);
	LDI  R30,LOW(126)
	OUT  0x3,R30
; 0000 0213 
; 0000 0214 DDRF=(1<<DDF7) | (0<<DDF6) | (0<<DDF5) | (1<<DDF4) | (0<<DDF3) | (1<<DDF2) | (1<<DDF1) | (1<<DDF0);
	LDI  R30,LOW(151)
	STS  97,R30
; 0000 0215 PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0216 
; 0000 0217 DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 0218 PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 0219 
; 0000 021A // Timer/Counter 0 initialization
; 0000 021B // Clock source: System Clock
; 0000 021C // Clock value: 62.500 kHz
; 0000 021D // Mode: Normal top=0xFF
; 0000 021E // OC0 output: Disconnected
; 0000 021F // Timer Period: 4.096 ms
; 0000 0220 ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 0221 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(6)
	OUT  0x33,R30
; 0000 0222 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0223 OCR0=0x00;
	OUT  0x31,R30
; 0000 0224 // Timer/Counter 1 initialization
; 0000 0225 // Clock source: System Clock
; 0000 0226 // Clock value: 16000.000 kHz
; 0000 0227 // Mode: Normal top=0xFFFF
; 0000 0228 // OC1A output: Disconnected
; 0000 0229 // OC1B output: Disconnected
; 0000 022A // OC1C output: Disconnected
; 0000 022B // Noise Canceler: Off
; 0000 022C // Input Capture on Falling Edge
; 0000 022D // Timer Period: 0.01 ms
; 0000 022E // Timer1 Overflow Interrupt: On
; 0000 022F // Input Capture Interrupt: Off
; 0000 0230 // Compare A Match Interrupt: Off
; 0000 0231 // Compare B Match Interrupt: Off
; 0000 0232 // Compare C Match Interrupt: Off
; 0000 0233 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0234 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 0235 TCNT1H=0xFF;
	CALL SUBOPT_0x1
; 0000 0236 TCNT1L=0x60;
; 0000 0237 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0238 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0239 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 023A OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 023B OCR1BH=0x00;
	OUT  0x29,R30
; 0000 023C OCR1BL=0x00;
	OUT  0x28,R30
; 0000 023D OCR1CH=0x00;
	STS  121,R30
; 0000 023E OCR1CL=0x00;
	STS  120,R30
; 0000 023F 
; 0000 0240 // Timer/Counter 2 initialization
; 0000 0241 // Clock source: System Clock
; 0000 0242 // Clock value: 62.500 kHz
; 0000 0243 // Mode: Normal top=0xFF
; 0000 0244 // OC2 output: Disconnected
; 0000 0245 // Timer Period: 4.096 ms
; 0000 0246 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (1<<CS22) | (0<<CS21) | (0<<CS20);
	LDI  R30,LOW(4)
	OUT  0x25,R30
; 0000 0247 TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0248 OCR2=0x00;
	OUT  0x23,R30
; 0000 0249 
; 0000 024A // Timer/Counter 3 initialization
; 0000 024B // Clock source: System Clock
; 0000 024C // Clock value: 15.625 kHz
; 0000 024D // Mode: Normal top=0xFFFF
; 0000 024E // OC3A output: Disconnected
; 0000 024F // OC3B output: Disconnected
; 0000 0250 // OC3C output: Disconnected
; 0000 0251 // Noise Canceler: Off
; 0000 0252 // Input Capture on Falling Edge
; 0000 0253 // Timer Period: 4.1943 s
; 0000 0254 // Timer3 Overflow Interrupt: Off
; 0000 0255 // Input Capture Interrupt: Off
; 0000 0256 // Compare A Match Interrupt: Off
; 0000 0257 // Compare B Match Interrupt: Off
; 0000 0258 // Compare C Match Interrupt: Off
; 0000 0259 TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 025A TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 025B TCNT3H=0x00;
	STS  137,R30
; 0000 025C TCNT3L=0x00;
	STS  136,R30
; 0000 025D ICR3H=0x00;
	STS  129,R30
; 0000 025E ICR3L=0x00;
	STS  128,R30
; 0000 025F OCR3AH=0x00;
	STS  135,R30
; 0000 0260 OCR3AL=0x00;
	STS  134,R30
; 0000 0261 OCR3BH=0x00;
	STS  133,R30
; 0000 0262 OCR3BL=0x00;
	STS  132,R30
; 0000 0263 OCR3CH=0x00;
	STS  131,R30
; 0000 0264 OCR3CL=0x00;
	STS  130,R30
; 0000 0265 
; 0000 0266 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0267 TIMSK=(0<<OCIE2) | (1<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (1<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(69)
	OUT  0x37,R30
; 0000 0268 ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0269 
; 0000 026A // External Interrupt(s) initialization
; 0000 026B // INT0: Off
; 0000 026C // INT1: Off
; 0000 026D // INT2: Off
; 0000 026E // INT3: Off
; 0000 026F // INT4: Off
; 0000 0270 // INT5: On
; 0000 0271 // INT5 Mode: Any change
; 0000 0272 // INT6: Off
; 0000 0273 // INT7: Off
; 0000 0274 EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 0275 EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (1<<ISC50) | (0<<ISC41) | (0<<ISC40);
	LDI  R30,LOW(4)
	OUT  0x3A,R30
; 0000 0276 EIMSK=(0<<INT7) | (0<<INT6) | (1<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	LDI  R30,LOW(32)
	OUT  0x39,R30
; 0000 0277 EIFR=(0<<INTF7) | (0<<INTF6) | (1<<INTF5) | (0<<INTF4) | (0<<INTF3) | (0<<INTF2) | (0<<INTF1) | (0<<INTF0);
	OUT  0x38,R30
; 0000 0278 
; 0000 0279 // USART0 initialization
; 0000 027A // USART0 disabled
; 0000 027B UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (0<<RXEN0) | (0<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 027C 
; 0000 027D // USART1 initialization
; 0000 027E // USART1 disabled
; 0000 027F UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	STS  154,R30
; 0000 0280 
; 0000 0281 // Analog Comparator initialization
; 0000 0282 // Analog Comparator: Off
; 0000 0283 // The Analog Comparator's positive input is
; 0000 0284 // connected to the AIN0 pin
; 0000 0285 // The Analog Comparator's negative input is
; 0000 0286 // connected to the AIN1 pin
; 0000 0287 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0288 
; 0000 0289 // ADC initialization
; 0000 028A // ADC Clock frequency: 1000.000 kHz
; 0000 028B // ADC Voltage Reference: AVCC pin
; 0000 028C // Only the 8 most significant bits of
; 0000 028D // the AD conversion result are used
; 0000 028E ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 028F ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0290 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0291 
; 0000 0292 // SPI initialization
; 0000 0293 // SPI disabled
; 0000 0294 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0295 
; 0000 0296 // TWI initialization
; 0000 0297 // TWI disabled
; 0000 0298 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 0299 
; 0000 029A // Alphanumeric LCD initialization
; 0000 029B // Connections are specified in the
; 0000 029C // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 029D // RS - PORTB Bit 6
; 0000 029E // RD - PORTB Bit 5
; 0000 029F // EN - PORTB Bit 4
; 0000 02A0 // D4 - PORTB Bit 3
; 0000 02A1 // D5 - PORTB Bit 2
; 0000 02A2 // D6 - PORTB Bit 1
; 0000 02A3 // D7 - PORTE Bit 7
; 0000 02A4 // Characters/line: 16
; 0000 02A5 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 02A6 
; 0000 02A7 // Global enable interrupts
; 0000 02A8 #asm("sei")
	sei
; 0000 02A9 
; 0000 02AA 
; 0000 02AB   j=10;
	LDI  R30,LOW(10)
	STS  _j,R30
; 0000 02AC 
; 0000 02AD lcd_gotoxy(0,0);
	CALL SUBOPT_0x8
; 0000 02AE lcd_putsf("HELP:    o  o  o ");
	__POINTW2FN _0x0,145
	CALL SUBOPT_0xF
; 0000 02AF lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 02B0 lcd_putsf("switchs  ^  ^  ^ ");
	__POINTW2FN _0x0,163
	CALL SUBOPT_0x13
; 0000 02B1 
; 0000 02B2 delay_ms(1000);
; 0000 02B3 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x11
; 0000 02B4 lcd_putsf("                ");
	__POINTW2FN _0x0,181
	CALL _lcd_putsf
; 0000 02B5 
; 0000 02B6 delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 02B7 lcd_gotoxy(0,0);
	CALL SUBOPT_0x8
; 0000 02B8 lcd_putsf("         +  o  o ");
	__POINTW2FN _0x0,198
	CALL _lcd_putsf
; 0000 02B9 
; 0000 02BA delay_ms(100);
	LDI  R26,LOW(100)
	CALL SUBOPT_0x14
; 0000 02BB lcd_gotoxy(0,1);
; 0000 02BC lcd_putsf(" <-    Back      ");
	__POINTW2FN _0x0,216
	CALL SUBOPT_0x13
; 0000 02BD 
; 0000 02BE delay_ms(1000);
; 0000 02BF 
; 0000 02C0 lcd_gotoxy(0,0);
	CALL SUBOPT_0x8
; 0000 02C1 lcd_putsf("         o  +  o ");
	__POINTW2FN _0x0,234
	CALL SUBOPT_0xF
; 0000 02C2 lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 02C3 lcd_putsf("                 ");
	__POINTW2FN _0x0,252
	CALL _lcd_putsf
; 0000 02C4 
; 0000 02C5 delay_ms(90);
	LDI  R26,LOW(90)
	CALL SUBOPT_0x14
; 0000 02C6 lcd_gotoxy(0,1);
; 0000 02C7 lcd_putsf("  -    Set   -   ");
	__POINTW2FN _0x0,270
	CALL SUBOPT_0x13
; 0000 02C8 
; 0000 02C9 delay_ms(1000);
; 0000 02CA 
; 0000 02CB lcd_gotoxy(0,0);
	CALL SUBOPT_0x8
; 0000 02CC lcd_putsf("         o  o  + ");
	__POINTW2FN _0x0,288
	CALL SUBOPT_0xF
; 0000 02CD lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 02CE lcd_putsf("                ");
	__POINTW2FN _0x0,181
	CALL _lcd_putsf
; 0000 02CF 
; 0000 02D0 delay_ms(90);
	LDI  R26,LOW(90)
	CALL SUBOPT_0x14
; 0000 02D1 lcd_gotoxy(0,1);
; 0000 02D2 lcd_putsf("     Start   -> ");
	__POINTW2FN _0x0,306
	CALL SUBOPT_0x13
; 0000 02D3 
; 0000 02D4 delay_ms(1000);
; 0000 02D5 
; 0000 02D6 
; 0000 02D7 
; 0000 02D8 lcd_gotoxy(0,0);
	CALL SUBOPT_0x8
; 0000 02D9 lcd_putsf("   Welcome !    ");
	__POINTW2FN _0x0,323
	CALL SUBOPT_0xF
; 0000 02DA lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 02DB delay_ms(j);
	LDS  R26,_j
	CLR  R27
	CALL _delay_ms
; 0000 02DC 
; 0000 02DD  j=0;
	LDI  R30,LOW(0)
	STS  _j,R30
; 0000 02DE 
; 0000 02DF while (1)
_0xBB:
; 0000 02E0       {
; 0000 02E1        choose();
	RCALL _choose
; 0000 02E2 
; 0000 02E3         for (j=8;j>0;j--)
	LDI  R30,LOW(8)
	STS  _j,R30
_0xBF:
	LDS  R26,_j
	CPI  R26,LOW(0x1)
	BRLO _0xC0
; 0000 02E4         {
; 0000 02E5                choose();
	CALL SUBOPT_0x15
; 0000 02E6         lcd_gotoxy(0,0);
; 0000 02E7         lcd_putsf("Choose:  1  2  3");
	CALL SUBOPT_0x16
; 0000 02E8         lcd_gotoxy(j,1);
; 0000 02E9         lcd_putsf("1: Line Follow");
	__POINTW2FN _0x0,357
	CALL SUBOPT_0x17
; 0000 02EA         delay_ms(15);
; 0000 02EB          if(j==1) {for(j1=0;j1<51;j1++){choose();delay_ms(20);}} //delay_ms(500);
	BRNE _0xC1
	LDI  R30,LOW(0)
	STS  _j1,R30
_0xC3:
	LDS  R26,_j1
	CPI  R26,LOW(0x33)
	BRSH _0xC4
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	RJMP _0xC3
_0xC4:
; 0000 02EC         lcd_clear();
_0xC1:
	CALL _lcd_clear
; 0000 02ED         }
	CALL SUBOPT_0x1A
	RJMP _0xBF
_0xC0:
; 0000 02EE 
; 0000 02EF         for (j=8;j>0;j--)
	LDI  R30,LOW(8)
	STS  _j,R30
_0xC6:
	LDS  R26,_j
	CPI  R26,LOW(0x1)
	BRLO _0xC7
; 0000 02F0         {
; 0000 02F1                choose();
	CALL SUBOPT_0x15
; 0000 02F2         lcd_gotoxy(0,0);
; 0000 02F3         lcd_putsf("Choose:  1  2  3");
	CALL SUBOPT_0x16
; 0000 02F4         lcd_gotoxy(j,1);
; 0000 02F5         lcd_putsf("2: +Color");
	__POINTW2FN _0x0,372
	CALL SUBOPT_0x17
; 0000 02F6         delay_ms(15);
; 0000 02F7         //if(j==1) delay_ms(500);
; 0000 02F8          if(j==1) {for(j1=0;j1<51;j1++){choose();delay_ms(20);}}
	BRNE _0xC8
	LDI  R30,LOW(0)
	STS  _j1,R30
_0xCA:
	LDS  R26,_j1
	CPI  R26,LOW(0x33)
	BRSH _0xCB
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	RJMP _0xCA
_0xCB:
; 0000 02F9         lcd_clear();
_0xC8:
	CALL _lcd_clear
; 0000 02FA         }
	CALL SUBOPT_0x1A
	RJMP _0xC6
_0xC7:
; 0000 02FB 
; 0000 02FC         for (j=8;j>0;j--)
	LDI  R30,LOW(8)
	STS  _j,R30
_0xCD:
	LDS  R26,_j
	CPI  R26,LOW(0x1)
	BRLO _0xCE
; 0000 02FD         {
; 0000 02FE                choose();
	CALL SUBOPT_0x15
; 0000 02FF         lcd_gotoxy(0,0);
; 0000 0300         lcd_putsf("Choose:  1  2  3");
	CALL SUBOPT_0x16
; 0000 0301         lcd_gotoxy(j,1);
; 0000 0302         lcd_putsf("3: +Obstacle");
	__POINTW2FN _0x0,382
	CALL SUBOPT_0x17
; 0000 0303         delay_ms(15);
; 0000 0304         //if(j==1) delay_ms(500);
; 0000 0305          if(j==1) {for(j1=0;j1<51;j1++){choose();delay_ms(20);}}
	BRNE _0xCF
	LDI  R30,LOW(0)
	STS  _j1,R30
_0xD1:
	LDS  R26,_j1
	CPI  R26,LOW(0x33)
	BRSH _0xD2
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	RJMP _0xD1
_0xD2:
; 0000 0306         lcd_clear();
_0xCF:
	CALL _lcd_clear
; 0000 0307         }
	CALL SUBOPT_0x1A
	RJMP _0xCD
_0xCE:
; 0000 0308 
; 0000 0309 
; 0000 030A       }
	RJMP _0xBB
; 0000 030B }
_0xD3:
	RJMP _0xD3
; .FEND
;   /***
;
;lcd_gotoxy(0,0);
;lcd_putsf("Hi World !");
;
;for (j=16;j>0;j--)
;{
;lcd_gotoxy(0,0);
;lcd_putsf("Hi World !");
;lcd_gotoxy((j),1);
;lcd_putsf(" i'm RoboNoise.");
;delay_ms(50);
; if(j==1)
; {
; delay_ms(1500);
;
; }
;lcd_clear();
;}
;for (j=8;j>0;j--)
;{
;lcd_gotoxy(0,0);
;lcd_putsf("Hi World !");
;lcd_gotoxy(1,j);
;lcd_putsf("  Welcome ");
;delay_ms(30);
;if(j==1)
; {
; lcd_gotoxy(1,1);
; lcd_putsf("  Welcome ");
; delay_ms(200);
; lcd_gotoxy(1,1);
; lcd_putsf("           ");
; delay_ms(200);
; lcd_gotoxy(1,1);
; lcd_putsf("  Welcome ");
; delay_ms(200);
; lcd_gotoxy(1,1);
; lcd_putsf("           ");
; delay_ms(200);
; lcd_gotoxy(1,1);
; lcd_putsf("  Welcome !");
; delay_ms(500);
;
; }
;lcd_clear();
;}
;
;lcd_gotoxy(0,0);
;lcd_putsf("Choose  Option  Menu:");
;lcd_gotoxy(5,1);
;lcd_putsf("    -1-2-3-  ");
;delay_ms(1000);
;lcd_clear();
;lcd_gotoxy(0,0);
;lcd_putsf("Choose:  1  2  3");
;delay_ms(100);
;
;
;
;------------------------------------------------------------
;
;      if ( !SWL )
;       {
;
;       delay_us(20);
;       UsTrig=1;
;       delay_us(20);
;       UsTrig=0;
;       delay_us(20);
;
;       k=u;
;       LEDG(1);
;         //   LineFollower ();
;        }
;
;      else LEDG(0);
; //     else UsKey=0;
;
;    // Time_us = ((cunter_us*10)+ (cunter_ms*1000) );
;
;//
;       lcd_gotoxy(0,0);
;       lcd_putsf("x:");
;       lcd_gotoxy(4,0);
;       ftoa(u,3,str);
;       lcd_puts(str);
;
;       lcd_gotoxy(8,0);
;       itoa(Time_us,str);
;       lcd_puts(str);
;//       if (!SWL )
;//       {
;//       KeySen=1;
;//             }
;//             else KeySen=0;
;//
;
;//       lcd_gotoxy(0,1);
;//       itoa(read_adc(4),str);
;//       lcd_puts(str);
;//
;//       lcd_gotoxy(8,1);
;//       itoa((p),str);
;//       lcd_puts(str);
;//
;       delay_ms(150);
;       lcd_clear();
;//
;
;**/

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret
; .FEND

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
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x1B
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1B
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
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
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
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
	RJMP _0x20C0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2040017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2040017
_0x2040019:
_0x20C0002:
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
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1C
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

	.DSEG
_str:
	.BYTE 0x5
_f:
	.BYTE 0x1
_p:
	.BYTE 0x1
_e:
	.BYTE 0x1
_j:
	.BYTE 0x1
_j1:
	.BYTE 0x1
_Time_us:
	.BYTE 0x2
_cunter_ms:
	.BYTE 0x2
_cunter_us:
	.BYTE 0x2
_u:
	.BYTE 0x4
_k:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  _cunter_us,R30
	STS  _cunter_us+1,R30
	STS  _cunter_ms,R30
	STS  _cunter_ms+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(255)
	OUT  0x2D,R30
	LDI  R30,LOW(96)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDI  R26,0
	SBIC 0x13,1
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R26,0
	SBIC 0x13,2
	LDI  R26,1
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x5:
	MOV  R26,R9
	CALL _Move
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x6:
	CALL _Move
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x7:
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	EOR  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(190)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	LDI  R26,LOW(255)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	SET
	BLD  R2,1
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xE:
	CALL _lcd_putsf
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	__POINTW2FN _0x0,88
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	CALL _lcd_gotoxy
	MOV  R30,R9
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _itoa
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDS  R26,_u
	LDS  R27,_u+1
	LDS  R24,_u+2
	LDS  R25,_u+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	CALL _lcd_putsf
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R27,0
	CALL _delay_ms
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	CALL _choose
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x16:
	__POINTW2FN _0x0,340
	CALL _lcd_putsf
	LDS  R30,_j
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x17:
	CALL _lcd_putsf
	LDI  R26,LOW(15)
	LDI  R27,0
	CALL _delay_ms
	LDS  R26,_j
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	CALL _choose
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDS  R30,_j1
	SUBI R30,-LOW(1)
	STS  _j1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDS  R30,_j
	SUBI R30,LOW(1)
	STS  _j,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
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

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
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

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

;END OF CODE MARKER
__END_OF_CODE:
