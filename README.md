```
  ██████╗██████╗ ██╗   ██╗██████╗ ████████╗    ██╗  ██╗ ██╗  ██████╗
 ██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝    ╚██╗██╔╝███║ ██╔════╝
 ██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║        ╚███╔╝ ╚██║ ███████╗
 ██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║        ██╔██╗  ██║ ██╔═══██╗
 ╚██████╗██║  ██║   ██║   ██║        ██║       ██╔╝ ██╗ ██║ ╚██████╔╝
  ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝      ╚═╝    ╚═╝╚═╝  ╚═════╝

            a 16-bit cryptographic coprocessor - built in VHDL
         ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              CSE 226 · Hardware Design · Zagazig University
```

---

the processor handles encryption operations including arithmetic, logic, bit rotation, and nonlinear S-Box substitution. it is designed to offload crypto math from a main CPU, running dedicated hardware operations faster than any software implementation.

the architecture is built around a **CLU** (Combinational Logic Unit) that integrates an ALU, a barrel shifter, and a nonlinear S-Box lookup - all sitting on top of a 16×16-bit register file and a single-cycle input pipeline register.

---

## setup in Active-HDL

**1. clone the repo**

open GitHub Desktop → File → Clone repository → pick `crypt-X16` → choose where to save it

**2. create a new workspace**

open Active-HDL → File → New → Workspace  
name it anything, save it anywhere on your machine

**3. add the source files**

in the design browser right-click your design → Add files  
navigate to the cloned `src/` folder → select all `.vhd` files → open

**4. set the compilation order**

Design → Compilation Order → drag files into this exact order:

```
1. ALU.vhd
2. shifter.vhd
3. non_linear_lookup.vhd
4. register_file.vhd
5. Control_Logic.vhd
6. MUX.vhd
7. CLU.vhd
8. input_reg.vhd
9. crypto_coprocessor.vhd
10. testbench(es).vhd
```

**5. compile**

press F11 or Design → Compile All  
if everything is green you are good to go

---

## The Team

<br>

<table align="center">
  <tr>
    <td align="center">
      <a href="https://github.com/FearThePLOTO">
        <img src="https://github.com/FearThePLOTO.png" width="100" style="border-radius:50%"/><br/>
        <sub><h6>Abdallh Ashraf</h6></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Shaza-Walid">
        <img src="https://github.com/Shaza-Walid.png" width="100" style="border-radius:50%"/><br/>
        <sub><h6>Shaza Walid</h6></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/therevenant9342-beep">
        <img src="https://github.com/therevenant9342-beep.png" width="100" style="border-radius:50%"/><br/>
        <sub><h6>Ali Khalil</h6></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/othman-su57">
        <img src="https://github.com/othman-su57.png" width="100" style="border-radius:50%"/><br/>
        <sub><h6>Othman Mohammed</h6></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/yousef394">
        <img src="https://github.com/yousef394.png" width="100" style="border-radius:50%"/><br/>
        <sub><h6>Yousef Ahmed</h6></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/rylALI">
        <img src="https://github.com/rylALI.png" width="100" style="border-radius:50%"/><br/>
        <sub><h6>Ali Mohammed</h6></sub>
      </a>
    </td>
  </tr>
</table>

<br>

---

<p align="center">
  built in hardware, because software was never fast enough
</p>
