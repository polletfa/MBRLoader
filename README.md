# Abandoned version: MBRLoader v3.0 (The Mini-OS Specification)

At some point I started to rewrite a new version, which was designed almost like a mini operating system, with its own file system and standard library.
I never finished it (probably stopped when I went to the university), but you can still see the code and the design draft in this branch.

## System Layers
1. **Boot Stage (Stage 1):** Pure 512-byte boot sector. Its only job is to load Stage 2. (Status: *OK*)
2. **Stage 2 (The Kernel):** Limited to exactly 18 sectors. It contained:
   - **Disk Driver:** BIOS-based floppy and hard drive abstraction (`dsk_*` API). (Status: *OK*)
   - **Memory Manager:** Page-based allocation within the 1st Megabyte using an 8KB allocation bitmap. (Status: *OK*)
   - **Executable Manager:** Single-tasking stack-based binary loader with compatibility checks (`exec_*` API).
   - **Localization Engine:** Operating-system-level multi-language handler (`lng_*` API).
   - **File System Drivers:** Full support for a custom file system (`MBRL/FS1`) and basic volume-name parsing for FAT/Ext2.

## MBRL/FS1 (MBRLoader File System v1)

### Disk Layout:
- **Kernel Zone (18 sectors):** Reserved at the very beginning of the partition for the Stage 2 Kernel.
- **Identification (1 sector):** Holds the magic signature string `"MBRL/FS1"`.
- **File Allocation Table / TAF (6 sectors):** Fixed table supporting up to 100 file entries. 
- **Bitmap (1 to 16 sectors):** Tracking free sectors in the data zone.
- **Data Zone (1 to 65,535 sectors):** Storing unfragmented files (Max size per partition ~= 32 MB).

### TAF File Entry Format (29 bytes per entry):
- File Name: `21 bytes` (Max 20 chars + `\0`)
- Extension: `4 bytes` (Max 3 chars + `\0`)
- Size in Sectors: `2 bytes`
- Characters in last sector: `1 byte`
- Sector Address: `2 bytes`

## Memory Map (The 1st Megabyte)
Memory allocation was strictly tracked using an 8KB bitmap, where **1 bit represented a 16-byte page** (a standard x86 real-mode paragraph).
This allowed exactly `8192 * 8 * 16 = 1,048,576 bytes` (1 MB) of RAM to be managed.

- `Pages 0x0000 - 0x004F`: **Occupied** (BIOS Data Area & IVT)
- `Pages 0x0050 - 0x024F`: **Occupied** (MBRLoader Memory Manager Bitmap)
- `Pages 0x0250 - 0x06CF`: **Occupied** (MBRLoader Kernel)
- `Pages 0x06D0 - 0x8FFF`: **FREE** (User space for applications/toolboxes)
- `Pages 0x9000 - 0x9FFF`: **Occupied** (MBRLoader Stack)
- `Pages 0xA000 - 0xFFFF`: **Occupied** (Video RAM & BIOS ROM)

### Advanced 32-bit Memory Math
Because 16-bit real-mode segments can be tricky to map linearly, the `mem_busy` and `mem_free` routines bypassed 16-bit limitations by utilizing
QuickASM raw byte injections (`.octet 0x66`) to execute 32-bit arithmetic (`SHL EBX, 4` and `ADD EBX, EAX`) to calculate absolute linear page offsets on bare-metal.

## OS-Level Internationalization (`lng_*`)

Instead of hardcoding text arrays, the Kernel dynamically patched language strings into running executables:
1. When an app launched, the OS looked for matching localized data files (`.fr`, `.en`, `.eo`, `.de`).
2. It loaded the language file directly behind the executable in memory.
3. The language file started with a custom jump/pointer table. Interestingly, I designed the translation file header format
   using `RET` (`0xC2`) and `NOP` (`0x90`) instructions so they could be compiled using native QuickASM syntax.

## System API and Implementation Status

### Disk Abstraction (`dsk_*`)
Low-level disk subsystem wrapping BIOS interrupts to handle CHS/LBA translation and raw sector I/O.
- `dsk_chs2lba` [ok] — Converts Cylinder-Head-Sector to Logical Block Addressing.
- `dsk_diskexists` [ok] — Checks if a physical drive (e.g., 0x80) is connected.
- `dsk_getinf` [ok] — Queries drive geometry from the BIOS.
- `dsk_lba2chs` [ok] — Converts LBA back to CHS.
- `dsk_read` [ok] — Reads raw sectors into memory.
- `dsk_reset` [ok] — Resets the disk controller.
- `dsk_write` [ok] — Writes raw sectors to disk.

### File System (`fs_*`)
The high-level file system interface for the custom `MBRL/FS1` structure.
- `fs_init` / `fs_getfs` / `fs_getvolname` / `fs_selectpart`
- `fs_open` / `fs_close` / `fs_read` / `fs_write` / `fs_seek` / `fs_tell` / `fs_del` / `fs_reorg`
- `fs_listopen` / `fs_listread` / `fs_listclose` (For directory listings)

### UI & Interface (`intf_*`)
A text-mode windowing and UI framework to draw dialogs, custom windows, and capture user inputs.
- `intf_init` [ok]
- `intf_clearscreen` [ok] / `intf_dispcursor` [ok]
- `intf_window` [ok] — Draws a bordered UI frame on the screen.
- `intf_dialog` [ok] — Generates prompt dialog boxes.
- `intf_inputbox` [ok] — Renders an interactive input field for text.
- `intf_additem` [ok] / `intf_selectitem` [ok] / `intf_unselectitem` [ok] — Handlers for menu selections.
- `intf_mainloop` [ok] — The central UI event loop.

### Input/Output (`io_*`)
Custom formatting utilities for reading and printing data.
- `io_printstr` [ok] / `io_readstr` [ok] — Basic string console I/O.
- `io_printintdec` [ok] — Prints integers in decimal format.
- `io_printinthex` [ok] — Prints integers in hexadecimal format (crucial for debugging raw bytes!).

### Memory Management (`mem_*`)
The custom page-allocated allocator tracking the 1st Megabyte of RAM.
- `mem_alloc` [ok] — Requests pages using the internal 8KB bitmap.
- `mem_free` [ok] — Frees allocated pages and updates the bitmap.

### String Utilities (`str_*`)
A completely custom string library mimicking standard C features (`string.h`) implemented natively.
- `str_blank` [ok]
- `str_getnthword` [ok] — Extremely useful for parsing tokens from commands read via `io_readstr`!
- `str_str2int` [ok] / `str_strcmp` [ok] / `str_strcpy` [ok] / `str_strlen` [ok] / `str_strncpy` [ok]

### Core System & Partitioning (`sys_*` / `parts_*` / `exec_*` / `lng_*`)
- `sys_reboot` [ok] — Warm reboot.
- `parts_findparts` [ok] / `parts_osname` [ok] — Scans and identifies existing MBR partition types.
- `exec_run` — Launches an executable file from the memory stack.
- `lng_init` / `lng_selectlang` / `lng_getselectedlang` — Triggers dynamic OS-level translations.

## The Application Interface: Jump Table Design (`api.qas`)

To allow external toolbox applications to execute Kernel functions without breaking backwards-compatibility when
Kernel memory layout changed, I designed a **Jump Table** API routing interface.

The Kernel was planned to be anchored at a fixed address, exposing a stur structure of 3-byte x86 near jumps at its base.
Applications would call these static entry vectors, which silently dispatched requests to the actual internal Kernel addresses.
See [api.qas](https://github.com/polletfa/MBRLoader/blob/develop/kernel/api.qas)
