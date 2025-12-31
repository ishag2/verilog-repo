# AXI to APB Bridge Documentation

## Overview

AXI (Advanced eXtensible Interface) and APB (Advanced Peripheral Bus) are SoC (System on Chip) interconnect protocols offered by ARM. Interconnect protocols are standardized communication methods that enable the different modules on chip to exchange data efficiently. AXI and APB are optimized for different applications. AXI is suitable for high-bandwidth, low-latency communication. APB, on the other hand, is designed for low-cost, low-power and low-complexity communication. 

SoCs often comprise of modules with different interconnects, depending on the application. For example, compute clusters require a high performance communication supported by AXI whereas debug modules consist of APB, well-suited for accessing the programmable control registers of peripheral devices. Interconnect bridges are an important component of SoCs designed to connect modules with different interconnect protocols. AXI to APB bridge is one such component used in SoC designs frequently.

## Interconnect Architecture

Interconnects facilitate communication between an initiator and a target through read and write transactions. An initiator can send a write transaction to write to a memory address in the target or request data through a read transaction from a memory address in the target.

AXI and APB protocols use VALID and READY handshake mechanism. The source, which could be initiator or target, uses the VALID signal to signal when valid data or address information is available on the channel. The destination uses the READY signal to signal when it can accept the data. 

### AXI

AXI interconnect has 5 channels as follows:
1. Write Address - memory address where data sent by the initiator needs to be written to
2. Write Data - write data sent by the initiator
3. Write Response - response sent by the target confirming the validity of write data sent by the initiator
4. Read Address - memory address where data needs to be read from sent by the initiator
5. Read Data - read data sent by the target

AXI protocol has separate data and address phases. For a transaction between an AXI initiator and target, the initiator sends address information first, setting address valid signal HIGH. When the target is ready to accept the address information, it sets the address ready signal HIGH. 

In case of a write transaction, the initiator sends the data to the target in the next phase following the same VALID and READY handshaking. The target then sends a response to the initiator confirming if the data is OKAY. AXI supports burst write transactions. In a burst write transaction, the initiator writes multiple data beats to a sequence of consecutive addresses using one address phase and a stream of write-data beats. For each valid write beat in a burst transaction, initiator sets wvalid to HIGH. On the last beat of a burst transaction, initiator sets wlast to HIGH.

In case of a read transaction, the address exchange is followed by the target sending the requested data.

### APB

APB has 3 channels as follows:
1. Address - memory address where read or write transaction needs to occur; APB has 1 common channel for read and write addresses
2. Write Data - write data sent by the initiator
3. Read Data - read data sent by the target

For a write transaction between an initiator and target, the initiator sends write address and data, sets write and select signals to HIGH. When the target is ready to accept the incoming transaction, it sets ready signal to high and the transaction is completed.

For a read transaction, the initiator sends read address, sets write signal to LOW and selects signal to HIGH. When the target is ready for the transaction, it sets ready signal to HIGH and sends the read data back in the same cycle.

## Bridge Functionality

AXI to APB bridge converts AXI transactions, sent by an AXI initiator, to APB transactions, received by an APB target. The bridge functions as an AXI target and APB initiator. Following are some important characteristics of the bridge design - 
1. Read and Write Addresses from AXI are sent on the Address APB channel as it is common for both read and write transactions in APB.
2. Bridge needs to wait for write address and data phases on AXI to complete before sending write address and data on APB as AXI has separate data and address phases whereas APB only has one.
3. Bridge needs to create a response for confirming the validity of the write data as APB protocol does not support that feature. 
4. AXI supports burst write transactions but APB does not. Hence, AXI burst transactions will need to be converted to individual APB write transactions. The first APB transaction in this case will use the address sent by AXI. For the following transactions, APB will need to increment the address by one each time.



