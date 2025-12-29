# AXI to APB Bridge Documentation

## Overview

AXI (Advanced eXtensible Interface) and APB (Advanced Peripheral Bus) are SoC bus protocols offered by ARM. AXI and APB are designed for different applications. AXI is optimized for high bandwidth, low latency designs. APB, on the other hand, is suitable for low cost, low power and low complexity designs. SoCs often comprise of modules with different bus protocols depending on the application. For example, compute clusters require a high performance interconnect like AXI whereas debug modules consist of APB interconnect, well suited for accessing the programmable control registers of peripheral devices. Protocol bridges are an important component of SoCs designed to connect modules with different protocols. AXI to APB bridge is one such component used frequently.

## Bus Architecture

AXI and APB protocols use VALID and READY handshake mechanism. The initiator uses the VALID signal to show when valid data or control information is available on the channel. The destination uses the READY signal to show when it can accept the data. 

### AXI

AXI has 5 channels as follows:
1. Write Address - memory address where data sent by the initiator needs to be written to
2. Write Data - write data sent by the initiator
3. Write Response - response sent by the target confirming the validity of write data sent by initiator
4. Read Address - memory address where data needs to be read from sent by the initiator
5. Read Data - read data sent by the target

AXI protocol has separate data and address/control phases. For a transaction between an AXI initiator and target, the initiator sends address information first, setting address valid signal HIGH. When the target is ready to accept the address information, it sets the address ready signal HIGH. 

In case of a write transaction, the initiator sends the data to the target in the next phase following the same VALID and READY handshaking. The target then sends a response to the initiator confirming if the data is OKAY. 

In case of a read transaction, the address exchange is followed by the target sending the requested data.

### APB

APB has 3 channels as follows:
1. Address - memory address where read or write transaction needs to occur; APB has 1 common channel for read and write addresses
2. Write Data - write data sent by the initiator
3. Read Data - read data sent by the target

For a write transaction between an initiator and target, the initiator sends write address and data, sets write and select signals to HIGH. When the target is ready to accept the incoming transaction, it sets ready signal to high and the transaction is completed.

For a read transaction, the initiator send read address, sets write signal to LOW and select signal to HIGH. When the target is ready for the transaction, it sets ready signal to HIGH and sends the read data back in the same cycle.

## Bridge Functionality

AXI to APB bridge converts AXI transactions, sent by an AXI initiator, to APB transactions, received by an APB target. The bridge functions as an AXI target and APB initiator. Following are some important characteristics of the bridge design - 
1. Read and Write Addresses from AXI are sent on the Address APB channel as it is common for both read and write transactions in APB.
2. Bridge needs to wait for write address and data phases on AXI to complete befroe sending write address and data on APB as AXI has separate data and address phases whereas APB only has one.
3. Bridge needs to create a response for confirming validity of the write data as APB protocol does not support that feature. 



