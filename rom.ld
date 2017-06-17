OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

SECTIONS{

	.text 0x080000C0 : { *(.text) }
    .rodata : { *(.rodate*); _erdata = .; }

	.data 0x02000000 : AT(ADDR(.text) + SIZEOF(.rodate) + SIZEOF(.data)) {
		_data = .; *(.data); _edata = .;
	}
	.bss : AT(ADDR(.text) + SIZEOF(.text) + SIZEOF(.rodate) + SIZEOF(.data)) {
		_bstart = .; *(.bss) *(COMMON); _bend = .;
	}

	__exidx_start = .;
	.ARM.exidx : ALIGN(4)
	{
		*(.ARM.exidx* .gnu.linkonce.armexidx.*)
	}
	__exidx_end = .;
}
