```
 ██████╗██████╗ ██╗   ██╗██████╗ ████████╗    ██╗  ██╗ ██╗ ██████╗
██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝    ╚██╗██╔╝███║██╔════╝
██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║        ╚███╔╝ ╚██║███████╗
██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║        ██╔██╗  ██║██╔═══██╗
╚██████╗██║  ██║   ██║   ██║        ██║        ██╔╝ ██╗ ██║╚██████╔╝
 ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝        ╚═╝  ╚═╝╚═╝ ╚═════╝
```

# Crypt-X16

a 16-bit cryptographic coprocessor built in VHDL - CSE 226 Hardware Design, Zagazig University.

the processor handles encryption operations including arithmetic, logic, bit rotation, and nonlinear S-Box substitution. it is designed to offload crypto math from a main CPU running dedicated hardware operations faster than any software implementation.

---
<!--
## what's inside

```
src/
├── ALU.vhd                 add sub and or xor not mov nop
├── shifter.vhd             ror8 ror4 sll8
├── non_linear_lookup.vhd   s-box substitution
├── register.vhd            16x16 bit register file
├── CLU.vhd                 combinational logic unit
└── crypto_coprocessor.vhd  top level
```
---
-->

## setup in Active-HDL

**1. clone the repo**

open GitHub Desktop -> File -> Clone repository -> pick `crypt-X16` -> choose where to save it

**2. create a new workspace**

open Active-HDL -> File -> New -> Workspace  
name it anything, save it anywhere on your machine

**3. add the source files**

in the design browser right-click your design -> Add files  
navigate to the cloned `src/` folder -> select all `.vhd` files -> open

**4. set the compilation order**

Design -> Compilation Order -> drag files into this exact order:

```
1. ALU.vhd
2. shifter.vhd
3. non_linear_lookup.vhd
4. register.vhd
5. CLU.vhd
6. crypto_coprocessor.vhd
7. testbench.vhd
```

**5. compile**

press F11 or Design -> Compile All  
if everything is green you are good to go

---
<!--
## the team

<br>

<table align="center">
  <tr>
    <td align="center">
      <a href="https://github.com/username1">
        <img src="https://github.com/username1.png" width="80" style="border-radius:50%"/><br/>
        <sub>Name 1</sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/username2">
        <img src="https://github.com/username2.png" width="80" style="border-radius:50%"/><br/>
        <sub>Name 2</sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/username3">
        <img src="https://github.com/username3.png" width="80" style="border-radius:50%"/><br/>
        <sub>Name 3</sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/username4">
        <img src="https://github.com/username4.png" width="80" style="border-radius:50%"/><br/>
        <sub>Name 4</sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/username5">
        <img src="https://github.com/username5.png" width="80" style="border-radius:50%"/><br/>
        <sub>Name 5</sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/username6">
        <img src="https://github.com/username6.png" width="80" style="border-radius:50%"/><br/>
        <sub>Name 6</sub>
      </a>
    </td>
  </tr>
</table>

<br>

---
-->
<p align="center">
  built in hardware, because software was never fast enough
</p>
