OUTPUT_ARCH( "riscv" )
ENTRY( _start )

BASE_ADDR = 0xffffffe000000000;

MEMORY {
  ram   (wxa!ri) : ORIGIN = 0x80000000, LENGTH = 16M
  ramv   (wxa!ri) : ORIGIN = 0xffffffe000000000, LENGTH = 4096M
}
PHDRS {
  text PT_LOAD;
  rodata PT_LOAD;
  data PT_LOAD;
  bss PT_LOAD;
}
SECTIONS {
	. = BASE_ADDR;
	
	.text : {
		PROVIDE(text_start = .);
		*(.text.init)
		*(.text.entry)
		*(.text .text.*)
		PROVIDE(text_end = .);
	} >ramv AT>ram :text

	.rodata : ALIGN(0x1000) { 
		PROVIDE(rodata_start = .);
		. = ALIGN(16);
		*(.srodata .srodata.*)
		. = ALIGN(16);
		*(.rodata .rodata.*)
		PROVIDE(rodata_end = .);
	} >ramv AT>ram :rodata

	.data : ALIGN(0x1000) { 
		PROVIDE(data_start = .);
		. = ALIGN(16);
		*(.sdata .sdata.*)
		. = ALIGN(16);
		*(.data .data.*)
		PROVIDE(data_end = .);
	} >ramv AT>ram :data

	
	.bss : ALIGN(0x1000) { 
		PROVIDE(bss_start = .);
		. = ALIGN(16);
		*(.sbss .sbss.*)
		. = ALIGN(16);
		*(.bss .bss.*)
		PROVIDE(bss_end = .);
	} >ramv AT>ram :bss
	
	. = ALIGN(0x1000);

	. += 0x4000;
	init_stack_top = .;
	_end = .;
}
