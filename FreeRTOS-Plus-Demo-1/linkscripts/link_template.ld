/* INSERT HEADER */

/* INSERT INCLUDES */

_Privileged_Functions_Region_Size = 16K; 
_Privileged_Data_Region_Size = 256; 
 
__FLASH_segment_start__ = ORIGIN( MFlash512 ); 
__FLASH_segment_end__ = __FLASH_segment_start__ + LENGTH( MFlash512 ); 
 
__privileged_functions_start__ = ORIGIN( MFlash512 ); 
__privileged_functions_end__ = __privileged_functions_start__ + _Privileged_Functions_Region_Size; 
 
__SRAM_segment_start__ = ORIGIN( RamLoc32 ); 
__SRAM_segment_end__ = __SRAM_segment_start__ + LENGTH( RamLoc32 ); 
 
__privileged_data_start__ = ORIGIN( RamLoc32 ); 
__privileged_data_end__ = ORIGIN( RamLoc32 ) + _Privileged_Data_Region_Size;	 



ENTRY(${start_symbol})

SECTIONS
{
    
    .text : ALIGN(${text_align})
    {
        __vectors_start__ = ABSOLUTE(.) ;
        KEEP(*(.isr_vector))

        /* INSERT SECTION_TABLE */
        
        *(privileged_functions)
        
    } >${CODE}
    
    
    .text : ALIGN(${text_align})    
    {
         . = ORIGIN(MFlash512) + _Privileged_Functions_Region_Size;
         *(.text*)
        
        
    } > ${CODE}

    /* INSERT EXDATA */
    
    _etext = .;

	/* zero initialized data */		
	privileged_data :
	{
		_bss = .;
		*(privileged_data)
		/* Non kernel data is kept out of the first 256 bytes of SRAM. */
	} > ${DATA}	

    . = ORIGIN( RamLoc32 ) + _Privileged_Data_Region_Size;
    
    	.bss :
	{
	__privileged_data_end__ = ABSOLUTE(.) ;
		*(.bss*)
		*(COMMON)
		_ebss = .;
	} > ${DATA}

     
		.data : AT (__exidx_end)
	{
		_data = .;	
		*(vtable)
		*(.data*)
		_edata = .;
	} > ${DATA}

PROVIDE(${heap_symbol} = DEFINED(__user_heap_base) ? __user_heap_base : .);
PROVIDE(_vStackTop = DEFINED(__user_stack_top) ? __user_stack_top : __top_${DATA} - 16);        
    /* INSERT DATA_SECTION */
	
	/* INSERT BSS_SECTION */



       
}