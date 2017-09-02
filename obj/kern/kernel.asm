
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 20 12 00       	mov    $0x122000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 20 12 f0       	mov    $0xf0122000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 c7 00 00 00       	call   f0100105 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <test_backtrace>:


// Test the stack backtrace function (lab 1 only)
void
test_backtrace(int x)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 14             	sub    $0x14,%esp
f0100047:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("entering test_backtrace %d\n", x);
f010004a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010004e:	c7 04 24 60 79 10 f0 	movl   $0xf0107960,(%esp)
f0100055:	e8 6b 3f 00 00       	call   f0103fc5 <cprintf>
	if (x > 0)
f010005a:	85 db                	test   %ebx,%ebx
f010005c:	7e 0d                	jle    f010006b <test_backtrace+0x2b>
		test_backtrace(x-1);
f010005e:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100061:	89 04 24             	mov    %eax,(%esp)
f0100064:	e8 d7 ff ff ff       	call   f0100040 <test_backtrace>
f0100069:	eb 1c                	jmp    f0100087 <test_backtrace+0x47>
	else
		mon_backtrace(0, 0, 0);
f010006b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100072:	00 
f0100073:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010007a:	00 
f010007b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0100082:	e8 04 09 00 00       	call   f010098b <mon_backtrace>
	cprintf("leaving test_backtrace %d\n", x);
f0100087:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010008b:	c7 04 24 7c 79 10 f0 	movl   $0xf010797c,(%esp)
f0100092:	e8 2e 3f 00 00       	call   f0103fc5 <cprintf>
}
f0100097:	83 c4 14             	add    $0x14,%esp
f010009a:	5b                   	pop    %ebx
f010009b:	5d                   	pop    %ebp
f010009c:	c3                   	ret    

f010009d <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f010009d:	55                   	push   %ebp
f010009e:	89 e5                	mov    %esp,%ebp
f01000a0:	56                   	push   %esi
f01000a1:	53                   	push   %ebx
f01000a2:	83 ec 10             	sub    $0x10,%esp
f01000a5:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f01000a8:	83 3d c0 8e 2b f0 00 	cmpl   $0x0,0xf02b8ec0
f01000af:	75 46                	jne    f01000f7 <_panic+0x5a>
		goto dead;
	panicstr = fmt;
f01000b1:	89 35 c0 8e 2b f0    	mov    %esi,0xf02b8ec0

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f01000b7:	fa                   	cli    
f01000b8:	fc                   	cld    

	va_start(ap, fmt);
f01000b9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f01000bc:	e8 c8 66 00 00       	call   f0106789 <cpunum>
f01000c1:	8b 55 0c             	mov    0xc(%ebp),%edx
f01000c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01000c8:	8b 55 08             	mov    0x8(%ebp),%edx
f01000cb:	89 54 24 08          	mov    %edx,0x8(%esp)
f01000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
f01000d3:	c7 04 24 f0 79 10 f0 	movl   $0xf01079f0,(%esp)
f01000da:	e8 e6 3e 00 00       	call   f0103fc5 <cprintf>



	vcprintf(fmt, ap);
f01000df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000e3:	89 34 24             	mov    %esi,(%esp)
f01000e6:	e8 a7 3e 00 00       	call   f0103f92 <vcprintf>
	cprintf("\n");
f01000eb:	c7 04 24 db 97 10 f0 	movl   $0xf01097db,(%esp)
f01000f2:	e8 ce 3e 00 00       	call   f0103fc5 <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000fe:	e8 4f 09 00 00       	call   f0100a52 <monitor>
f0100103:	eb f2                	jmp    f01000f7 <_panic+0x5a>

f0100105 <i386_init>:



void
i386_init(void)
{
f0100105:	55                   	push   %ebp
f0100106:	89 e5                	mov    %esp,%ebp
f0100108:	53                   	push   %ebx
f0100109:	83 ec 14             	sub    $0x14,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f010010c:	b8 20 ac 35 f0       	mov    $0xf035ac20,%eax
f0100111:	2d 89 76 2b f0       	sub    $0xf02b7689,%eax
f0100116:	89 44 24 08          	mov    %eax,0x8(%esp)
f010011a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100121:	00 
f0100122:	c7 04 24 89 76 2b f0 	movl   $0xf02b7689,(%esp)
f0100129:	e8 09 60 00 00       	call   f0106137 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010012e:	e8 cc 05 00 00       	call   f01006ff <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100133:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f010013a:	00 
f010013b:	c7 04 24 97 79 10 f0 	movl   $0xf0107997,(%esp)
f0100142:	e8 7e 3e 00 00       	call   f0103fc5 <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f0100147:	e8 36 13 00 00       	call   f0101482 <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f010014c:	e8 fb 35 00 00       	call   f010374c <env_init>
	trap_init();
f0100151:	e8 80 3f 00 00       	call   f01040d6 <trap_init>

	// Lab 4 multiprocessor initialization functions
	mp_init();
f0100156:	e8 1f 63 00 00       	call   f010647a <mp_init>
	lapic_init();
f010015b:	90                   	nop
f010015c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100160:	e8 3f 66 00 00       	call   f01067a4 <lapic_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f0100165:	e8 78 3d 00 00       	call   f0103ee2 <pic_init>


	// Lab 6 hardware initialization functions
	time_init();
f010016a:	e8 da 74 00 00       	call   f0107649 <time_init>
	pci_init();
f010016f:	90                   	nop
f0100170:	e8 a6 74 00 00       	call   f010761b <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0100175:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f010017c:	e8 86 68 00 00       	call   f0106a07 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100181:	83 3d c8 8e 2b f0 07 	cmpl   $0x7,0xf02b8ec8
f0100188:	77 24                	ja     f01001ae <i386_init+0xa9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010018a:	c7 44 24 0c 00 70 00 	movl   $0x7000,0xc(%esp)
f0100191:	00 
f0100192:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f0100199:	f0 
f010019a:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
f01001a1:	00 
f01001a2:	c7 04 24 b2 79 10 f0 	movl   $0xf01079b2,(%esp)
f01001a9:	e8 ef fe ff ff       	call   f010009d <_panic>
	void *code;
	struct CpuInfo *c;

	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01001ae:	b8 b2 63 10 f0       	mov    $0xf01063b2,%eax
f01001b3:	2d 38 63 10 f0       	sub    $0xf0106338,%eax
f01001b8:	89 44 24 08          	mov    %eax,0x8(%esp)
f01001bc:	c7 44 24 04 38 63 10 	movl   $0xf0106338,0x4(%esp)
f01001c3:	f0 
f01001c4:	c7 04 24 00 70 00 f0 	movl   $0xf0007000,(%esp)
f01001cb:	e8 b4 5f 00 00       	call   f0106184 <memmove>

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f01001d0:	bb 20 90 31 f0       	mov    $0xf0319020,%ebx
f01001d5:	eb 4d                	jmp    f0100224 <i386_init+0x11f>
		if (c == cpus + cpunum())  // We've started already.
f01001d7:	e8 ad 65 00 00       	call   f0106789 <cpunum>
f01001dc:	6b c0 74             	imul   $0x74,%eax,%eax
f01001df:	05 20 90 31 f0       	add    $0xf0319020,%eax
f01001e4:	39 c3                	cmp    %eax,%ebx
f01001e6:	74 39                	je     f0100221 <i386_init+0x11c>
f01001e8:	89 d8                	mov    %ebx,%eax
f01001ea:	2d 20 90 31 f0       	sub    $0xf0319020,%eax
			continue;

		// Tell mpentry.S what stack to use 
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f01001ef:	c1 f8 02             	sar    $0x2,%eax
f01001f2:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f01001f8:	c1 e0 0f             	shl    $0xf,%eax
f01001fb:	8d 80 00 20 32 f0    	lea    -0xfcde000(%eax),%eax
f0100201:	a3 c4 8e 2b f0       	mov    %eax,0xf02b8ec4
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_id, PADDR(code));
f0100206:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
f010020d:	00 
f010020e:	0f b6 03             	movzbl (%ebx),%eax
f0100211:	89 04 24             	mov    %eax,(%esp)
f0100214:	e8 db 66 00 00       	call   f01068f4 <lapic_startap>
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
f0100219:	8b 43 04             	mov    0x4(%ebx),%eax
f010021c:	83 f8 01             	cmp    $0x1,%eax
f010021f:	75 f8                	jne    f0100219 <i386_init+0x114>
	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f0100221:	83 c3 74             	add    $0x74,%ebx
f0100224:	6b 05 c4 93 31 f0 74 	imul   $0x74,0xf03193c4,%eax
f010022b:	05 20 90 31 f0       	add    $0xf0319020,%eax
f0100230:	39 c3                	cmp    %eax,%ebx
f0100232:	72 a3                	jb     f01001d7 <i386_init+0xd2>
	lock_kernel();
	// Starting non-boot CPUs
	boot_aps();

	// Start fs.
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100234:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f010023b:	00 
f010023c:	c7 04 24 76 de 1d f0 	movl   $0xf01dde76,(%esp)
f0100243:	e8 2e 37 00 00       	call   f0103976 <env_create>
#endif


#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f0100248:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010024f:	00 
f0100250:	c7 04 24 96 46 22 f0 	movl   $0xf0224696,(%esp)
f0100257:	e8 1a 37 00 00       	call   f0103976 <env_create>

	ENV_CREATE(user_icode, ENV_TYPE_USER);
#endif // TEST*

	// Should not be necessary - drains keyboard because interrupt has given up.
	kbd_intr();
f010025c:	e8 42 04 00 00       	call   f01006a3 <kbd_intr>

	// Schedule and run the first user environment!
	sched_yield();
f0100261:	e8 9c 4a 00 00       	call   f0104d02 <sched_yield>

f0100266 <mp_main>:
}

// Setup code for APs
void
mp_main(void)
{
f0100266:	55                   	push   %ebp
f0100267:	89 e5                	mov    %esp,%ebp
f0100269:	83 ec 18             	sub    $0x18,%esp
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
f010026c:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0100271:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0100276:	77 20                	ja     f0100298 <mp_main+0x32>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0100278:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010027c:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0100283:	f0 
f0100284:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
f010028b:	00 
f010028c:	c7 04 24 b2 79 10 f0 	movl   $0xf01079b2,(%esp)
f0100293:	e8 05 fe ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0100298:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f010029d:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f01002a0:	e8 e4 64 00 00       	call   f0106789 <cpunum>
f01002a5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01002a9:	c7 04 24 be 79 10 f0 	movl   $0xf01079be,(%esp)
f01002b0:	e8 10 3d 00 00       	call   f0103fc5 <cprintf>

	lapic_init();
f01002b5:	e8 ea 64 00 00       	call   f01067a4 <lapic_init>
	env_init_percpu();
f01002ba:	e8 63 34 00 00       	call   f0103722 <env_init_percpu>
	trap_init_percpu();
f01002bf:	90                   	nop
f01002c0:	e8 1b 3d 00 00       	call   f0103fe0 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01002c5:	e8 bf 64 00 00       	call   f0106789 <cpunum>
f01002ca:	6b d0 74             	imul   $0x74,%eax,%edx
f01002cd:	81 c2 20 90 31 f0    	add    $0xf0319020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f01002d3:	b8 01 00 00 00       	mov    $0x1,%eax
f01002d8:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f01002dc:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f01002e3:	e8 1f 67 00 00       	call   f0106a07 <spin_lock>
	// only one CPU can enter the scheduler at a time!
	//
	// Your code here:

	lock_kernel();
	sched_yield();
f01002e8:	e8 15 4a 00 00       	call   f0104d02 <sched_yield>

f01002ed <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01002ed:	55                   	push   %ebp
f01002ee:	89 e5                	mov    %esp,%ebp
f01002f0:	53                   	push   %ebx
f01002f1:	83 ec 14             	sub    $0x14,%esp
	va_list ap;

	va_start(ap, fmt);
f01002f4:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01002fa:	89 44 24 08          	mov    %eax,0x8(%esp)
f01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
f0100301:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100305:	c7 04 24 d4 79 10 f0 	movl   $0xf01079d4,(%esp)
f010030c:	e8 b4 3c 00 00       	call   f0103fc5 <cprintf>
	vcprintf(fmt, ap);
f0100311:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100315:	8b 45 10             	mov    0x10(%ebp),%eax
f0100318:	89 04 24             	mov    %eax,(%esp)
f010031b:	e8 72 3c 00 00       	call   f0103f92 <vcprintf>
	cprintf("\n");
f0100320:	c7 04 24 db 97 10 f0 	movl   $0xf01097db,(%esp)
f0100327:	e8 99 3c 00 00       	call   f0103fc5 <cprintf>
	va_end(ap);
}
f010032c:	83 c4 14             	add    $0x14,%esp
f010032f:	5b                   	pop    %ebx
f0100330:	5d                   	pop    %ebp
f0100331:	c3                   	ret    
f0100332:	66 90                	xchg   %ax,%ax
f0100334:	66 90                	xchg   %ax,%ax
f0100336:	66 90                	xchg   %ax,%ax
f0100338:	66 90                	xchg   %ax,%ax
f010033a:	66 90                	xchg   %ax,%ax
f010033c:	66 90                	xchg   %ax,%ax
f010033e:	66 90                	xchg   %ax,%ax

f0100340 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f0100340:	55                   	push   %ebp
f0100341:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100343:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100348:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100349:	a8 01                	test   $0x1,%al
f010034b:	74 08                	je     f0100355 <serial_proc_data+0x15>
f010034d:	b2 f8                	mov    $0xf8,%dl
f010034f:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100350:	0f b6 c0             	movzbl %al,%eax
f0100353:	eb 05                	jmp    f010035a <serial_proc_data+0x1a>

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f0100355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return inb(COM1+COM_RX);
}
f010035a:	5d                   	pop    %ebp
f010035b:	c3                   	ret    

f010035c <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010035c:	55                   	push   %ebp
f010035d:	89 e5                	mov    %esp,%ebp
f010035f:	53                   	push   %ebx
f0100360:	83 ec 04             	sub    $0x4,%esp
f0100363:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100365:	eb 2a                	jmp    f0100391 <cons_intr+0x35>
		if (c == 0)
f0100367:	85 d2                	test   %edx,%edx
f0100369:	74 26                	je     f0100391 <cons_intr+0x35>
			continue;
		cons.buf[cons.wpos++] = c;
f010036b:	a1 24 82 2b f0       	mov    0xf02b8224,%eax
f0100370:	8d 48 01             	lea    0x1(%eax),%ecx
f0100373:	89 0d 24 82 2b f0    	mov    %ecx,0xf02b8224
f0100379:	88 90 20 80 2b f0    	mov    %dl,-0xfd47fe0(%eax)
		if (cons.wpos == CONSBUFSIZE)
f010037f:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100385:	75 0a                	jne    f0100391 <cons_intr+0x35>
			cons.wpos = 0;
f0100387:	c7 05 24 82 2b f0 00 	movl   $0x0,0xf02b8224
f010038e:	00 00 00 
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f0100391:	ff d3                	call   *%ebx
f0100393:	89 c2                	mov    %eax,%edx
f0100395:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100398:	75 cd                	jne    f0100367 <cons_intr+0xb>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f010039a:	83 c4 04             	add    $0x4,%esp
f010039d:	5b                   	pop    %ebx
f010039e:	5d                   	pop    %ebp
f010039f:	c3                   	ret    

f01003a0 <kbd_proc_data>:
f01003a0:	ba 64 00 00 00       	mov    $0x64,%edx
f01003a5:	ec                   	in     (%dx),%al
{
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f01003a6:	a8 01                	test   $0x1,%al
f01003a8:	0f 84 ef 00 00 00    	je     f010049d <kbd_proc_data+0xfd>
f01003ae:	b2 60                	mov    $0x60,%dl
f01003b0:	ec                   	in     (%dx),%al
f01003b1:	89 c2                	mov    %eax,%edx
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f01003b3:	3c e0                	cmp    $0xe0,%al
f01003b5:	75 0d                	jne    f01003c4 <kbd_proc_data+0x24>
		// E0 escape character
		shift |= E0ESC;
f01003b7:	83 0d 00 80 2b f0 40 	orl    $0x40,0xf02b8000
		return 0;
f01003be:	b8 00 00 00 00       	mov    $0x0,%eax
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f01003c3:	c3                   	ret    
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f01003c4:	55                   	push   %ebp
f01003c5:	89 e5                	mov    %esp,%ebp
f01003c7:	53                   	push   %ebx
f01003c8:	83 ec 14             	sub    $0x14,%esp

	if (data == 0xE0) {
		// E0 escape character
		shift |= E0ESC;
		return 0;
	} else if (data & 0x80) {
f01003cb:	84 c0                	test   %al,%al
f01003cd:	79 37                	jns    f0100406 <kbd_proc_data+0x66>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f01003cf:	8b 0d 00 80 2b f0    	mov    0xf02b8000,%ecx
f01003d5:	89 cb                	mov    %ecx,%ebx
f01003d7:	83 e3 40             	and    $0x40,%ebx
f01003da:	83 e0 7f             	and    $0x7f,%eax
f01003dd:	85 db                	test   %ebx,%ebx
f01003df:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f01003e2:	0f b6 d2             	movzbl %dl,%edx
f01003e5:	0f b6 82 c0 7b 10 f0 	movzbl -0xfef8440(%edx),%eax
f01003ec:	83 c8 40             	or     $0x40,%eax
f01003ef:	0f b6 c0             	movzbl %al,%eax
f01003f2:	f7 d0                	not    %eax
f01003f4:	21 c1                	and    %eax,%ecx
f01003f6:	89 0d 00 80 2b f0    	mov    %ecx,0xf02b8000
		return 0;
f01003fc:	b8 00 00 00 00       	mov    $0x0,%eax
f0100401:	e9 9d 00 00 00       	jmp    f01004a3 <kbd_proc_data+0x103>
	} else if (shift & E0ESC) {
f0100406:	8b 0d 00 80 2b f0    	mov    0xf02b8000,%ecx
f010040c:	f6 c1 40             	test   $0x40,%cl
f010040f:	74 0e                	je     f010041f <kbd_proc_data+0x7f>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f0100411:	83 c8 80             	or     $0xffffff80,%eax
f0100414:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f0100416:	83 e1 bf             	and    $0xffffffbf,%ecx
f0100419:	89 0d 00 80 2b f0    	mov    %ecx,0xf02b8000
	}

	shift |= shiftcode[data];
f010041f:	0f b6 d2             	movzbl %dl,%edx
f0100422:	0f b6 82 c0 7b 10 f0 	movzbl -0xfef8440(%edx),%eax
f0100429:	0b 05 00 80 2b f0    	or     0xf02b8000,%eax
	shift ^= togglecode[data];
f010042f:	0f b6 8a c0 7a 10 f0 	movzbl -0xfef8540(%edx),%ecx
f0100436:	31 c8                	xor    %ecx,%eax
f0100438:	a3 00 80 2b f0       	mov    %eax,0xf02b8000

	c = charcode[shift & (CTL | SHIFT)][data];
f010043d:	89 c1                	mov    %eax,%ecx
f010043f:	83 e1 03             	and    $0x3,%ecx
f0100442:	8b 0c 8d a0 7a 10 f0 	mov    -0xfef8560(,%ecx,4),%ecx
f0100449:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f010044d:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100450:	a8 08                	test   $0x8,%al
f0100452:	74 1b                	je     f010046f <kbd_proc_data+0xcf>
		if ('a' <= c && c <= 'z')
f0100454:	89 da                	mov    %ebx,%edx
f0100456:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100459:	83 f9 19             	cmp    $0x19,%ecx
f010045c:	77 05                	ja     f0100463 <kbd_proc_data+0xc3>
			c += 'A' - 'a';
f010045e:	83 eb 20             	sub    $0x20,%ebx
f0100461:	eb 0c                	jmp    f010046f <kbd_proc_data+0xcf>
		else if ('A' <= c && c <= 'Z')
f0100463:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f0100466:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100469:	83 fa 19             	cmp    $0x19,%edx
f010046c:	0f 46 d9             	cmovbe %ecx,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010046f:	f7 d0                	not    %eax
f0100471:	89 c2                	mov    %eax,%edx
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f0100473:	89 d8                	mov    %ebx,%eax
			c += 'a' - 'A';
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100475:	f6 c2 06             	test   $0x6,%dl
f0100478:	75 29                	jne    f01004a3 <kbd_proc_data+0x103>
f010047a:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100480:	75 21                	jne    f01004a3 <kbd_proc_data+0x103>
		cprintf("Rebooting!\n");
f0100482:	c7 04 24 5c 7a 10 f0 	movl   $0xf0107a5c,(%esp)
f0100489:	e8 37 3b 00 00       	call   f0103fc5 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010048e:	ba 92 00 00 00       	mov    $0x92,%edx
f0100493:	b8 03 00 00 00       	mov    $0x3,%eax
f0100498:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f0100499:	89 d8                	mov    %ebx,%eax
f010049b:	eb 06                	jmp    f01004a3 <kbd_proc_data+0x103>
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
		return -1;
f010049d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01004a2:	c3                   	ret    
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f01004a3:	83 c4 14             	add    $0x14,%esp
f01004a6:	5b                   	pop    %ebx
f01004a7:	5d                   	pop    %ebp
f01004a8:	c3                   	ret    

f01004a9 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01004a9:	55                   	push   %ebp
f01004aa:	89 e5                	mov    %esp,%ebp
f01004ac:	57                   	push   %edi
f01004ad:	56                   	push   %esi
f01004ae:	53                   	push   %ebx
f01004af:	83 ec 1c             	sub    $0x1c,%esp
f01004b2:	89 c7                	mov    %eax,%edi
f01004b4:	bb 01 32 00 00       	mov    $0x3201,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004b9:	be fd 03 00 00       	mov    $0x3fd,%esi
f01004be:	b9 84 00 00 00       	mov    $0x84,%ecx
f01004c3:	eb 06                	jmp    f01004cb <cons_putc+0x22>
f01004c5:	89 ca                	mov    %ecx,%edx
f01004c7:	ec                   	in     (%dx),%al
f01004c8:	ec                   	in     (%dx),%al
f01004c9:	ec                   	in     (%dx),%al
f01004ca:	ec                   	in     (%dx),%al
f01004cb:	89 f2                	mov    %esi,%edx
f01004cd:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f01004ce:	a8 20                	test   $0x20,%al
f01004d0:	75 05                	jne    f01004d7 <cons_putc+0x2e>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01004d2:	83 eb 01             	sub    $0x1,%ebx
f01004d5:	75 ee                	jne    f01004c5 <cons_putc+0x1c>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
f01004d7:	89 f8                	mov    %edi,%eax
f01004d9:	0f b6 c0             	movzbl %al,%eax
f01004dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004df:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01004e4:	ee                   	out    %al,(%dx)
f01004e5:	bb 01 32 00 00       	mov    $0x3201,%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004ea:	be 79 03 00 00       	mov    $0x379,%esi
f01004ef:	b9 84 00 00 00       	mov    $0x84,%ecx
f01004f4:	eb 06                	jmp    f01004fc <cons_putc+0x53>
f01004f6:	89 ca                	mov    %ecx,%edx
f01004f8:	ec                   	in     (%dx),%al
f01004f9:	ec                   	in     (%dx),%al
f01004fa:	ec                   	in     (%dx),%al
f01004fb:	ec                   	in     (%dx),%al
f01004fc:	89 f2                	mov    %esi,%edx
f01004fe:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01004ff:	84 c0                	test   %al,%al
f0100501:	78 05                	js     f0100508 <cons_putc+0x5f>
f0100503:	83 eb 01             	sub    $0x1,%ebx
f0100506:	75 ee                	jne    f01004f6 <cons_putc+0x4d>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100508:	ba 78 03 00 00       	mov    $0x378,%edx
f010050d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
f0100511:	ee                   	out    %al,(%dx)
f0100512:	b2 7a                	mov    $0x7a,%dl
f0100514:	b8 0d 00 00 00       	mov    $0xd,%eax
f0100519:	ee                   	out    %al,(%dx)
f010051a:	b8 08 00 00 00       	mov    $0x8,%eax
f010051f:	ee                   	out    %al,(%dx)

static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f0100520:	89 fa                	mov    %edi,%edx
f0100522:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f0100528:	89 f8                	mov    %edi,%eax
f010052a:	80 cc 07             	or     $0x7,%ah
f010052d:	85 d2                	test   %edx,%edx
f010052f:	0f 44 f8             	cmove  %eax,%edi

	switch (c & 0xff) {
f0100532:	89 f8                	mov    %edi,%eax
f0100534:	0f b6 c0             	movzbl %al,%eax
f0100537:	83 f8 09             	cmp    $0x9,%eax
f010053a:	74 76                	je     f01005b2 <cons_putc+0x109>
f010053c:	83 f8 09             	cmp    $0x9,%eax
f010053f:	7f 0a                	jg     f010054b <cons_putc+0xa2>
f0100541:	83 f8 08             	cmp    $0x8,%eax
f0100544:	74 16                	je     f010055c <cons_putc+0xb3>
f0100546:	e9 9b 00 00 00       	jmp    f01005e6 <cons_putc+0x13d>
f010054b:	83 f8 0a             	cmp    $0xa,%eax
f010054e:	66 90                	xchg   %ax,%ax
f0100550:	74 3a                	je     f010058c <cons_putc+0xe3>
f0100552:	83 f8 0d             	cmp    $0xd,%eax
f0100555:	74 3d                	je     f0100594 <cons_putc+0xeb>
f0100557:	e9 8a 00 00 00       	jmp    f01005e6 <cons_putc+0x13d>
	case '\b':
		if (crt_pos > 0) {
f010055c:	0f b7 05 28 82 2b f0 	movzwl 0xf02b8228,%eax
f0100563:	66 85 c0             	test   %ax,%ax
f0100566:	0f 84 e5 00 00 00    	je     f0100651 <cons_putc+0x1a8>
			crt_pos--;
f010056c:	83 e8 01             	sub    $0x1,%eax
f010056f:	66 a3 28 82 2b f0    	mov    %ax,0xf02b8228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100575:	0f b7 c0             	movzwl %ax,%eax
f0100578:	66 81 e7 00 ff       	and    $0xff00,%di
f010057d:	83 cf 20             	or     $0x20,%edi
f0100580:	8b 15 2c 82 2b f0    	mov    0xf02b822c,%edx
f0100586:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f010058a:	eb 78                	jmp    f0100604 <cons_putc+0x15b>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f010058c:	66 83 05 28 82 2b f0 	addw   $0x50,0xf02b8228
f0100593:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f0100594:	0f b7 05 28 82 2b f0 	movzwl 0xf02b8228,%eax
f010059b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f01005a1:	c1 e8 16             	shr    $0x16,%eax
f01005a4:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01005a7:	c1 e0 04             	shl    $0x4,%eax
f01005aa:	66 a3 28 82 2b f0    	mov    %ax,0xf02b8228
f01005b0:	eb 52                	jmp    f0100604 <cons_putc+0x15b>
		break;
	case '\t':
		cons_putc(' ');
f01005b2:	b8 20 00 00 00       	mov    $0x20,%eax
f01005b7:	e8 ed fe ff ff       	call   f01004a9 <cons_putc>
		cons_putc(' ');
f01005bc:	b8 20 00 00 00       	mov    $0x20,%eax
f01005c1:	e8 e3 fe ff ff       	call   f01004a9 <cons_putc>
		cons_putc(' ');
f01005c6:	b8 20 00 00 00       	mov    $0x20,%eax
f01005cb:	e8 d9 fe ff ff       	call   f01004a9 <cons_putc>
		cons_putc(' ');
f01005d0:	b8 20 00 00 00       	mov    $0x20,%eax
f01005d5:	e8 cf fe ff ff       	call   f01004a9 <cons_putc>
		cons_putc(' ');
f01005da:	b8 20 00 00 00       	mov    $0x20,%eax
f01005df:	e8 c5 fe ff ff       	call   f01004a9 <cons_putc>
f01005e4:	eb 1e                	jmp    f0100604 <cons_putc+0x15b>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f01005e6:	0f b7 05 28 82 2b f0 	movzwl 0xf02b8228,%eax
f01005ed:	8d 50 01             	lea    0x1(%eax),%edx
f01005f0:	66 89 15 28 82 2b f0 	mov    %dx,0xf02b8228
f01005f7:	0f b7 c0             	movzwl %ax,%eax
f01005fa:	8b 15 2c 82 2b f0    	mov    0xf02b822c,%edx
f0100600:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f0100604:	66 81 3d 28 82 2b f0 	cmpw   $0x7cf,0xf02b8228
f010060b:	cf 07 
f010060d:	76 42                	jbe    f0100651 <cons_putc+0x1a8>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f010060f:	a1 2c 82 2b f0       	mov    0xf02b822c,%eax
f0100614:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f010061b:	00 
f010061c:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100622:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100626:	89 04 24             	mov    %eax,(%esp)
f0100629:	e8 56 5b 00 00       	call   f0106184 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f010062e:	8b 15 2c 82 2b f0    	mov    0xf02b822c,%edx
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100634:	b8 80 07 00 00       	mov    $0x780,%eax
			crt_buf[i] = 0x0700 | ' ';
f0100639:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f010063f:	83 c0 01             	add    $0x1,%eax
f0100642:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100647:	75 f0                	jne    f0100639 <cons_putc+0x190>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f0100649:	66 83 2d 28 82 2b f0 	subw   $0x50,0xf02b8228
f0100650:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f0100651:	8b 0d 30 82 2b f0    	mov    0xf02b8230,%ecx
f0100657:	b8 0e 00 00 00       	mov    $0xe,%eax
f010065c:	89 ca                	mov    %ecx,%edx
f010065e:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010065f:	0f b7 1d 28 82 2b f0 	movzwl 0xf02b8228,%ebx
f0100666:	8d 71 01             	lea    0x1(%ecx),%esi
f0100669:	89 d8                	mov    %ebx,%eax
f010066b:	66 c1 e8 08          	shr    $0x8,%ax
f010066f:	89 f2                	mov    %esi,%edx
f0100671:	ee                   	out    %al,(%dx)
f0100672:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100677:	89 ca                	mov    %ecx,%edx
f0100679:	ee                   	out    %al,(%dx)
f010067a:	89 d8                	mov    %ebx,%eax
f010067c:	89 f2                	mov    %esi,%edx
f010067e:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010067f:	83 c4 1c             	add    $0x1c,%esp
f0100682:	5b                   	pop    %ebx
f0100683:	5e                   	pop    %esi
f0100684:	5f                   	pop    %edi
f0100685:	5d                   	pop    %ebp
f0100686:	c3                   	ret    

f0100687 <serial_intr>:
}

void
serial_intr(void)
{
	if (serial_exists)
f0100687:	80 3d 34 82 2b f0 00 	cmpb   $0x0,0xf02b8234
f010068e:	74 11                	je     f01006a1 <serial_intr+0x1a>
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f0100690:	55                   	push   %ebp
f0100691:	89 e5                	mov    %esp,%ebp
f0100693:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
		cons_intr(serial_proc_data);
f0100696:	b8 40 03 10 f0       	mov    $0xf0100340,%eax
f010069b:	e8 bc fc ff ff       	call   f010035c <cons_intr>
}
f01006a0:	c9                   	leave  
f01006a1:	f3 c3                	repz ret 

f01006a3 <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f01006a3:	55                   	push   %ebp
f01006a4:	89 e5                	mov    %esp,%ebp
f01006a6:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01006a9:	b8 a0 03 10 f0       	mov    $0xf01003a0,%eax
f01006ae:	e8 a9 fc ff ff       	call   f010035c <cons_intr>
}
f01006b3:	c9                   	leave  
f01006b4:	c3                   	ret    

f01006b5 <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f01006b5:	55                   	push   %ebp
f01006b6:	89 e5                	mov    %esp,%ebp
f01006b8:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f01006bb:	e8 c7 ff ff ff       	call   f0100687 <serial_intr>
	kbd_intr();
f01006c0:	e8 de ff ff ff       	call   f01006a3 <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f01006c5:	a1 20 82 2b f0       	mov    0xf02b8220,%eax
f01006ca:	3b 05 24 82 2b f0    	cmp    0xf02b8224,%eax
f01006d0:	74 26                	je     f01006f8 <cons_getc+0x43>
		c = cons.buf[cons.rpos++];
f01006d2:	8d 50 01             	lea    0x1(%eax),%edx
f01006d5:	89 15 20 82 2b f0    	mov    %edx,0xf02b8220
f01006db:	0f b6 88 20 80 2b f0 	movzbl -0xfd47fe0(%eax),%ecx
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
f01006e2:	89 c8                	mov    %ecx,%eax
	kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
f01006e4:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01006ea:	75 11                	jne    f01006fd <cons_getc+0x48>
			cons.rpos = 0;
f01006ec:	c7 05 20 82 2b f0 00 	movl   $0x0,0xf02b8220
f01006f3:	00 00 00 
f01006f6:	eb 05                	jmp    f01006fd <cons_getc+0x48>
		return c;
	}
	return 0;
f01006f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01006fd:	c9                   	leave  
f01006fe:	c3                   	ret    

f01006ff <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f01006ff:	55                   	push   %ebp
f0100700:	89 e5                	mov    %esp,%ebp
f0100702:	57                   	push   %edi
f0100703:	56                   	push   %esi
f0100704:	53                   	push   %ebx
f0100705:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f0100708:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f010070f:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100716:	5a a5 
	if (*cp != 0xA55A) {
f0100718:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f010071f:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100723:	74 11                	je     f0100736 <cons_init+0x37>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f0100725:	c7 05 30 82 2b f0 b4 	movl   $0x3b4,0xf02b8230
f010072c:	03 00 00 

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
	*cp = (uint16_t) 0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f010072f:	bf 00 00 0b f0       	mov    $0xf00b0000,%edi
f0100734:	eb 16                	jmp    f010074c <cons_init+0x4d>
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
f0100736:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f010073d:	c7 05 30 82 2b f0 d4 	movl   $0x3d4,0xf02b8230
f0100744:	03 00 00 
{
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100747:	bf 00 80 0b f0       	mov    $0xf00b8000,%edi
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f010074c:	8b 0d 30 82 2b f0    	mov    0xf02b8230,%ecx
f0100752:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100757:	89 ca                	mov    %ecx,%edx
f0100759:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010075a:	8d 59 01             	lea    0x1(%ecx),%ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010075d:	89 da                	mov    %ebx,%edx
f010075f:	ec                   	in     (%dx),%al
f0100760:	0f b6 f0             	movzbl %al,%esi
f0100763:	c1 e6 08             	shl    $0x8,%esi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100766:	b8 0f 00 00 00       	mov    $0xf,%eax
f010076b:	89 ca                	mov    %ecx,%edx
f010076d:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010076e:	89 da                	mov    %ebx,%edx
f0100770:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f0100771:	89 3d 2c 82 2b f0    	mov    %edi,0xf02b822c

	/* Extract cursor location */
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);
f0100777:	0f b6 d8             	movzbl %al,%ebx
f010077a:	09 de                	or     %ebx,%esi

	crt_buf = (uint16_t*) cp;
	crt_pos = pos;
f010077c:	66 89 35 28 82 2b f0 	mov    %si,0xf02b8228
static void
kbd_init(void)
{

	// Drain the kbd buffer so that QEMU generates interrupts.
	kbd_intr();
f0100783:	e8 1b ff ff ff       	call   f01006a3 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f0100788:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f010078f:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100794:	89 04 24             	mov    %eax,(%esp)
f0100797:	e8 d7 36 00 00       	call   f0103e73 <irq_setmask_8259A>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010079c:	be fa 03 00 00       	mov    $0x3fa,%esi
f01007a1:	b8 00 00 00 00       	mov    $0x0,%eax
f01007a6:	89 f2                	mov    %esi,%edx
f01007a8:	ee                   	out    %al,(%dx)
f01007a9:	b2 fb                	mov    $0xfb,%dl
f01007ab:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f01007b0:	ee                   	out    %al,(%dx)
f01007b1:	bb f8 03 00 00       	mov    $0x3f8,%ebx
f01007b6:	b8 0c 00 00 00       	mov    $0xc,%eax
f01007bb:	89 da                	mov    %ebx,%edx
f01007bd:	ee                   	out    %al,(%dx)
f01007be:	b2 f9                	mov    $0xf9,%dl
f01007c0:	b8 00 00 00 00       	mov    $0x0,%eax
f01007c5:	ee                   	out    %al,(%dx)
f01007c6:	b2 fb                	mov    $0xfb,%dl
f01007c8:	b8 03 00 00 00       	mov    $0x3,%eax
f01007cd:	ee                   	out    %al,(%dx)
f01007ce:	b2 fc                	mov    $0xfc,%dl
f01007d0:	b8 00 00 00 00       	mov    $0x0,%eax
f01007d5:	ee                   	out    %al,(%dx)
f01007d6:	b2 f9                	mov    $0xf9,%dl
f01007d8:	b8 01 00 00 00       	mov    $0x1,%eax
f01007dd:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007de:	b2 fd                	mov    $0xfd,%dl
f01007e0:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01007e1:	3c ff                	cmp    $0xff,%al
f01007e3:	0f 95 c1             	setne  %cl
f01007e6:	88 0d 34 82 2b f0    	mov    %cl,0xf02b8234
f01007ec:	89 f2                	mov    %esi,%edx
f01007ee:	ec                   	in     (%dx),%al
f01007ef:	89 da                	mov    %ebx,%edx
f01007f1:	ec                   	in     (%dx),%al
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);


	// Enable serial interrupts
	if (serial_exists)
f01007f2:	84 c9                	test   %cl,%cl
f01007f4:	74 1d                	je     f0100813 <cons_init+0x114>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f01007f6:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f01007fd:	25 ef ff 00 00       	and    $0xffef,%eax
f0100802:	89 04 24             	mov    %eax,(%esp)
f0100805:	e8 69 36 00 00       	call   f0103e73 <irq_setmask_8259A>
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f010080a:	80 3d 34 82 2b f0 00 	cmpb   $0x0,0xf02b8234
f0100811:	75 0c                	jne    f010081f <cons_init+0x120>
		cprintf("Serial port does not exist!\n");
f0100813:	c7 04 24 68 7a 10 f0 	movl   $0xf0107a68,(%esp)
f010081a:	e8 a6 37 00 00       	call   f0103fc5 <cprintf>
}
f010081f:	83 c4 1c             	add    $0x1c,%esp
f0100822:	5b                   	pop    %ebx
f0100823:	5e                   	pop    %esi
f0100824:	5f                   	pop    %edi
f0100825:	5d                   	pop    %ebp
f0100826:	c3                   	ret    

f0100827 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f0100827:	55                   	push   %ebp
f0100828:	89 e5                	mov    %esp,%ebp
f010082a:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f010082d:	8b 45 08             	mov    0x8(%ebp),%eax
f0100830:	e8 74 fc ff ff       	call   f01004a9 <cons_putc>
}
f0100835:	c9                   	leave  
f0100836:	c3                   	ret    

f0100837 <getchar>:

int
getchar(void)
{
f0100837:	55                   	push   %ebp
f0100838:	89 e5                	mov    %esp,%ebp
f010083a:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010083d:	e8 73 fe ff ff       	call   f01006b5 <cons_getc>
f0100842:	85 c0                	test   %eax,%eax
f0100844:	74 f7                	je     f010083d <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100846:	c9                   	leave  
f0100847:	c3                   	ret    

f0100848 <iscons>:

int
iscons(int fdnum)
{
f0100848:	55                   	push   %ebp
f0100849:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f010084b:	b8 01 00 00 00       	mov    $0x1,%eax
f0100850:	5d                   	pop    %ebp
f0100851:	c3                   	ret    
f0100852:	66 90                	xchg   %ax,%ax
f0100854:	66 90                	xchg   %ax,%ax
f0100856:	66 90                	xchg   %ax,%ax
f0100858:	66 90                	xchg   %ax,%ax
f010085a:	66 90                	xchg   %ax,%ax
f010085c:	66 90                	xchg   %ax,%ax
f010085e:	66 90                	xchg   %ax,%ax

f0100860 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100860:	55                   	push   %ebp
f0100861:	89 e5                	mov    %esp,%ebp
f0100863:	83 ec 18             	sub    $0x18,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0100866:	c7 44 24 08 c0 7c 10 	movl   $0xf0107cc0,0x8(%esp)
f010086d:	f0 
f010086e:	c7 44 24 04 de 7c 10 	movl   $0xf0107cde,0x4(%esp)
f0100875:	f0 
f0100876:	c7 04 24 e3 7c 10 f0 	movl   $0xf0107ce3,(%esp)
f010087d:	e8 43 37 00 00       	call   f0103fc5 <cprintf>
f0100882:	c7 44 24 08 b0 7d 10 	movl   $0xf0107db0,0x8(%esp)
f0100889:	f0 
f010088a:	c7 44 24 04 ec 7c 10 	movl   $0xf0107cec,0x4(%esp)
f0100891:	f0 
f0100892:	c7 04 24 e3 7c 10 f0 	movl   $0xf0107ce3,(%esp)
f0100899:	e8 27 37 00 00       	call   f0103fc5 <cprintf>
f010089e:	c7 44 24 08 f5 7c 10 	movl   $0xf0107cf5,0x8(%esp)
f01008a5:	f0 
f01008a6:	c7 44 24 04 0e 7d 10 	movl   $0xf0107d0e,0x4(%esp)
f01008ad:	f0 
f01008ae:	c7 04 24 e3 7c 10 f0 	movl   $0xf0107ce3,(%esp)
f01008b5:	e8 0b 37 00 00       	call   f0103fc5 <cprintf>
	return 0;
}
f01008ba:	b8 00 00 00 00       	mov    $0x0,%eax
f01008bf:	c9                   	leave  
f01008c0:	c3                   	ret    

f01008c1 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01008c1:	55                   	push   %ebp
f01008c2:	89 e5                	mov    %esp,%ebp
f01008c4:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01008c7:	c7 04 24 18 7d 10 f0 	movl   $0xf0107d18,(%esp)
f01008ce:	e8 f2 36 00 00       	call   f0103fc5 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f01008d3:	c7 44 24 04 0c 00 10 	movl   $0x10000c,0x4(%esp)
f01008da:	00 
f01008db:	c7 04 24 d8 7d 10 f0 	movl   $0xf0107dd8,(%esp)
f01008e2:	e8 de 36 00 00       	call   f0103fc5 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01008e7:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f01008ee:	00 
f01008ef:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f01008f6:	f0 
f01008f7:	c7 04 24 00 7e 10 f0 	movl   $0xf0107e00,(%esp)
f01008fe:	e8 c2 36 00 00       	call   f0103fc5 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f0100903:	c7 44 24 08 47 79 10 	movl   $0x107947,0x8(%esp)
f010090a:	00 
f010090b:	c7 44 24 04 47 79 10 	movl   $0xf0107947,0x4(%esp)
f0100912:	f0 
f0100913:	c7 04 24 24 7e 10 f0 	movl   $0xf0107e24,(%esp)
f010091a:	e8 a6 36 00 00       	call   f0103fc5 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f010091f:	c7 44 24 08 89 76 2b 	movl   $0x2b7689,0x8(%esp)
f0100926:	00 
f0100927:	c7 44 24 04 89 76 2b 	movl   $0xf02b7689,0x4(%esp)
f010092e:	f0 
f010092f:	c7 04 24 48 7e 10 f0 	movl   $0xf0107e48,(%esp)
f0100936:	e8 8a 36 00 00       	call   f0103fc5 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010093b:	c7 44 24 08 20 ac 35 	movl   $0x35ac20,0x8(%esp)
f0100942:	00 
f0100943:	c7 44 24 04 20 ac 35 	movl   $0xf035ac20,0x4(%esp)
f010094a:	f0 
f010094b:	c7 04 24 6c 7e 10 f0 	movl   $0xf0107e6c,(%esp)
f0100952:	e8 6e 36 00 00       	call   f0103fc5 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
f0100957:	b8 1f b0 35 f0       	mov    $0xf035b01f,%eax
f010095c:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f0100961:	25 00 fc ff ff       	and    $0xfffffc00,%eax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100966:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f010096c:	85 c0                	test   %eax,%eax
f010096e:	0f 48 c2             	cmovs  %edx,%eax
f0100971:	c1 f8 0a             	sar    $0xa,%eax
f0100974:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100978:	c7 04 24 90 7e 10 f0 	movl   $0xf0107e90,(%esp)
f010097f:	e8 41 36 00 00       	call   f0103fc5 <cprintf>
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}
f0100984:	b8 00 00 00 00       	mov    $0x0,%eax
f0100989:	c9                   	leave  
f010098a:	c3                   	ret    

f010098b <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f010098b:	55                   	push   %ebp
f010098c:	89 e5                	mov    %esp,%ebp
f010098e:	56                   	push   %esi
f010098f:	53                   	push   %ebx
f0100990:	83 ec 40             	sub    $0x40,%esp
	// Your code here.


	cprintf("Stack Backtrace:\n");
f0100993:	c7 04 24 31 7d 10 f0 	movl   $0xf0107d31,(%esp)
f010099a:	e8 26 36 00 00       	call   f0103fc5 <cprintf>
	struct Eipdebuginfo eip_info;
	uint32_t *s = (uint32_t*)read_ebp();
f010099f:	89 eb                	mov    %ebp,%ebx
	{

	cprintf("ebp %08x ",s);
	cprintf("eip %08x ",s[1]);
	cprintf("args %08x %08x %08x %08x %08x \n",s[2],s[3],s[4],s[5],s[6]);
	debuginfo_eip(s[1],&eip_info);
f01009a1:	8d 75 e0             	lea    -0x20(%ebp),%esi


	cprintf("Stack Backtrace:\n");
	struct Eipdebuginfo eip_info;
	uint32_t *s = (uint32_t*)read_ebp();
	while(s)
f01009a4:	e9 95 00 00 00       	jmp    f0100a3e <mon_backtrace+0xb3>
	{

	cprintf("ebp %08x ",s);
f01009a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01009ad:	c7 04 24 43 7d 10 f0 	movl   $0xf0107d43,(%esp)
f01009b4:	e8 0c 36 00 00       	call   f0103fc5 <cprintf>
	cprintf("eip %08x ",s[1]);
f01009b9:	8b 43 04             	mov    0x4(%ebx),%eax
f01009bc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009c0:	c7 04 24 4d 7d 10 f0 	movl   $0xf0107d4d,(%esp)
f01009c7:	e8 f9 35 00 00       	call   f0103fc5 <cprintf>
	cprintf("args %08x %08x %08x %08x %08x \n",s[2],s[3],s[4],s[5],s[6]);
f01009cc:	8b 43 18             	mov    0x18(%ebx),%eax
f01009cf:	89 44 24 14          	mov    %eax,0x14(%esp)
f01009d3:	8b 43 14             	mov    0x14(%ebx),%eax
f01009d6:	89 44 24 10          	mov    %eax,0x10(%esp)
f01009da:	8b 43 10             	mov    0x10(%ebx),%eax
f01009dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01009e1:	8b 43 0c             	mov    0xc(%ebx),%eax
f01009e4:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009e8:	8b 43 08             	mov    0x8(%ebx),%eax
f01009eb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009ef:	c7 04 24 bc 7e 10 f0 	movl   $0xf0107ebc,(%esp)
f01009f6:	e8 ca 35 00 00       	call   f0103fc5 <cprintf>
	debuginfo_eip(s[1],&eip_info);
f01009fb:	89 74 24 04          	mov    %esi,0x4(%esp)
f01009ff:	8b 43 04             	mov    0x4(%ebx),%eax
f0100a02:	89 04 24             	mov    %eax,(%esp)
f0100a05:	e8 df 4b 00 00       	call   f01055e9 <debuginfo_eip>
	cprintf("          %s:%d: %.*s+%d\n", eip_info.eip_file, eip_info.eip_line,eip_info.eip_fn_namelen, eip_info.eip_fn_name, s[1] - (uint32_t)eip_info.eip_fn_addr);
f0100a0a:	8b 43 04             	mov    0x4(%ebx),%eax
f0100a0d:	2b 45 f0             	sub    -0x10(%ebp),%eax
f0100a10:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100a14:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0100a17:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0100a1e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100a25:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a30:	c7 04 24 57 7d 10 f0 	movl   $0xf0107d57,(%esp)
f0100a37:	e8 89 35 00 00       	call   f0103fc5 <cprintf>
	s = (uint32_t*)s[0];
f0100a3c:	8b 1b                	mov    (%ebx),%ebx


	cprintf("Stack Backtrace:\n");
	struct Eipdebuginfo eip_info;
	uint32_t *s = (uint32_t*)read_ebp();
	while(s)
f0100a3e:	85 db                	test   %ebx,%ebx
f0100a40:	0f 85 63 ff ff ff    	jne    f01009a9 <mon_backtrace+0x1e>




	return 0;
}
f0100a46:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a4b:	83 c4 40             	add    $0x40,%esp
f0100a4e:	5b                   	pop    %ebx
f0100a4f:	5e                   	pop    %esi
f0100a50:	5d                   	pop    %ebp
f0100a51:	c3                   	ret    

f0100a52 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100a52:	55                   	push   %ebp
f0100a53:	89 e5                	mov    %esp,%ebp
f0100a55:	57                   	push   %edi
f0100a56:	56                   	push   %esi
f0100a57:	53                   	push   %ebx
f0100a58:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100a5b:	c7 04 24 dc 7e 10 f0 	movl   $0xf0107edc,(%esp)
f0100a62:	e8 5e 35 00 00       	call   f0103fc5 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100a67:	c7 04 24 00 7f 10 f0 	movl   $0xf0107f00,(%esp)
f0100a6e:	e8 52 35 00 00       	call   f0103fc5 <cprintf>

	if (tf != NULL)
f0100a73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100a77:	74 0b                	je     f0100a84 <monitor+0x32>
		print_trapframe(tf);
f0100a79:	8b 45 08             	mov    0x8(%ebp),%eax
f0100a7c:	89 04 24             	mov    %eax,(%esp)
f0100a7f:	e8 39 3b 00 00       	call   f01045bd <print_trapframe>

	while (1) {
		buf = readline("K> ");
f0100a84:	c7 04 24 71 7d 10 f0 	movl   $0xf0107d71,(%esp)
f0100a8b:	e8 40 54 00 00       	call   f0105ed0 <readline>
f0100a90:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a92:	85 c0                	test   %eax,%eax
f0100a94:	74 ee                	je     f0100a84 <monitor+0x32>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100a96:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100a9d:	be 00 00 00 00       	mov    $0x0,%esi
f0100aa2:	eb 0a                	jmp    f0100aae <monitor+0x5c>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100aa4:	c6 03 00             	movb   $0x0,(%ebx)
f0100aa7:	89 f7                	mov    %esi,%edi
f0100aa9:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100aac:	89 fe                	mov    %edi,%esi
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100aae:	0f b6 03             	movzbl (%ebx),%eax
f0100ab1:	84 c0                	test   %al,%al
f0100ab3:	74 63                	je     f0100b18 <monitor+0xc6>
f0100ab5:	0f be c0             	movsbl %al,%eax
f0100ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100abc:	c7 04 24 75 7d 10 f0 	movl   $0xf0107d75,(%esp)
f0100ac3:	e8 32 56 00 00       	call   f01060fa <strchr>
f0100ac8:	85 c0                	test   %eax,%eax
f0100aca:	75 d8                	jne    f0100aa4 <monitor+0x52>
			*buf++ = 0;
		if (*buf == 0)
f0100acc:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100acf:	74 47                	je     f0100b18 <monitor+0xc6>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100ad1:	83 fe 0f             	cmp    $0xf,%esi
f0100ad4:	75 16                	jne    f0100aec <monitor+0x9a>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100ad6:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100add:	00 
f0100ade:	c7 04 24 7a 7d 10 f0 	movl   $0xf0107d7a,(%esp)
f0100ae5:	e8 db 34 00 00       	call   f0103fc5 <cprintf>
f0100aea:	eb 98                	jmp    f0100a84 <monitor+0x32>
			return 0;
		}
		argv[argc++] = buf;
f0100aec:	8d 7e 01             	lea    0x1(%esi),%edi
f0100aef:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100af3:	eb 03                	jmp    f0100af8 <monitor+0xa6>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
f0100af5:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100af8:	0f b6 03             	movzbl (%ebx),%eax
f0100afb:	84 c0                	test   %al,%al
f0100afd:	74 ad                	je     f0100aac <monitor+0x5a>
f0100aff:	0f be c0             	movsbl %al,%eax
f0100b02:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b06:	c7 04 24 75 7d 10 f0 	movl   $0xf0107d75,(%esp)
f0100b0d:	e8 e8 55 00 00       	call   f01060fa <strchr>
f0100b12:	85 c0                	test   %eax,%eax
f0100b14:	74 df                	je     f0100af5 <monitor+0xa3>
f0100b16:	eb 94                	jmp    f0100aac <monitor+0x5a>
			buf++;
	}
	argv[argc] = 0;
f0100b18:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100b1f:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100b20:	85 f6                	test   %esi,%esi
f0100b22:	0f 84 5c ff ff ff    	je     f0100a84 <monitor+0x32>
f0100b28:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100b2d:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100b30:	8b 04 85 40 7f 10 f0 	mov    -0xfef80c0(,%eax,4),%eax
f0100b37:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b3b:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100b3e:	89 04 24             	mov    %eax,(%esp)
f0100b41:	e8 56 55 00 00       	call   f010609c <strcmp>
f0100b46:	85 c0                	test   %eax,%eax
f0100b48:	75 24                	jne    f0100b6e <monitor+0x11c>
			return commands[i].func(argc, argv, tf);
f0100b4a:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100b4d:	8b 55 08             	mov    0x8(%ebp),%edx
f0100b50:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100b54:	8d 4d a8             	lea    -0x58(%ebp),%ecx
f0100b57:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100b5b:	89 34 24             	mov    %esi,(%esp)
f0100b5e:	ff 14 85 48 7f 10 f0 	call   *-0xfef80b8(,%eax,4)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100b65:	85 c0                	test   %eax,%eax
f0100b67:	78 25                	js     f0100b8e <monitor+0x13c>
f0100b69:	e9 16 ff ff ff       	jmp    f0100a84 <monitor+0x32>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f0100b6e:	83 c3 01             	add    $0x1,%ebx
f0100b71:	83 fb 03             	cmp    $0x3,%ebx
f0100b74:	75 b7                	jne    f0100b2d <monitor+0xdb>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100b76:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100b79:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b7d:	c7 04 24 97 7d 10 f0 	movl   $0xf0107d97,(%esp)
f0100b84:	e8 3c 34 00 00       	call   f0103fc5 <cprintf>
f0100b89:	e9 f6 fe ff ff       	jmp    f0100a84 <monitor+0x32>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100b8e:	83 c4 5c             	add    $0x5c,%esp
f0100b91:	5b                   	pop    %ebx
f0100b92:	5e                   	pop    %esi
f0100b93:	5f                   	pop    %edi
f0100b94:	5d                   	pop    %ebp
f0100b95:	c3                   	ret    
f0100b96:	66 90                	xchg   %ax,%ax
f0100b98:	66 90                	xchg   %ax,%ax
f0100b9a:	66 90                	xchg   %ax,%ax
f0100b9c:	66 90                	xchg   %ax,%ax
f0100b9e:	66 90                	xchg   %ax,%ax

f0100ba0 <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100ba0:	83 3d 38 82 2b f0 00 	cmpl   $0x0,0xf02b8238
f0100ba7:	75 11                	jne    f0100bba <boot_alloc+0x1a>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100ba9:	ba 1f bc 35 f0       	mov    $0xf035bc1f,%edx
f0100bae:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100bb4:	89 15 38 82 2b f0    	mov    %edx,0xf02b8238
	}


	nextfree = ROUNDUP(nextfree+n,PGSIZE);
f0100bba:	03 05 38 82 2b f0    	add    0xf02b8238,%eax
f0100bc0:	05 ff 0f 00 00       	add    $0xfff,%eax
f0100bc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100bca:	a3 38 82 2b f0       	mov    %eax,0xf02b8238
	result = nextfree;
	size_t phys_memory_total = npages*PGSIZE; //finds out the total amount of memory available
f0100bcf:	8b 0d c8 8e 2b f0    	mov    0xf02b8ec8,%ecx
f0100bd5:	c1 e1 0c             	shl    $0xc,%ecx
	if(((uint32_t)nextfree-KERNBASE)>phys_memory_total)
f0100bd8:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0100bde:	39 d1                	cmp    %edx,%ecx
f0100be0:	73 22                	jae    f0100c04 <boot_alloc+0x64>
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100be2:	55                   	push   %ebp
f0100be3:	89 e5                	mov    %esp,%ebp
f0100be5:	83 ec 18             	sub    $0x18,%esp
	nextfree = ROUNDUP(nextfree+n,PGSIZE);
	result = nextfree;
	size_t phys_memory_total = npages*PGSIZE; //finds out the total amount of memory available
	if(((uint32_t)nextfree-KERNBASE)>phys_memory_total)
	{
		panic("Cannot allocate memory\n");
f0100be8:	c7 44 24 08 64 7f 10 	movl   $0xf0107f64,0x8(%esp)
f0100bef:	f0 
f0100bf0:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
f0100bf7:	00 
f0100bf8:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100bff:	e8 99 f4 ff ff       	call   f010009d <_panic>
	return result;




}
f0100c04:	f3 c3                	repz ret 

f0100c06 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100c06:	89 d1                	mov    %edx,%ecx
f0100c08:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100c0b:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100c0e:	a8 01                	test   $0x1,%al
f0100c10:	74 5d                	je     f0100c6f <check_va2pa+0x69>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100c12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100c17:	89 c1                	mov    %eax,%ecx
f0100c19:	c1 e9 0c             	shr    $0xc,%ecx
f0100c1c:	3b 0d c8 8e 2b f0    	cmp    0xf02b8ec8,%ecx
f0100c22:	72 26                	jb     f0100c4a <check_va2pa+0x44>
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100c24:	55                   	push   %ebp
f0100c25:	89 e5                	mov    %esp,%ebp
f0100c27:	83 ec 18             	sub    $0x18,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100c2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100c2e:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f0100c35:	f0 
f0100c36:	c7 44 24 04 26 04 00 	movl   $0x426,0x4(%esp)
f0100c3d:	00 
f0100c3e:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100c45:	e8 53 f4 ff ff       	call   f010009d <_panic>

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
f0100c4a:	c1 ea 0c             	shr    $0xc,%edx
f0100c4d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100c53:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100c5a:	89 c2                	mov    %eax,%edx
f0100c5c:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100c5f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100c64:	85 d2                	test   %edx,%edx
f0100c66:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0100c6b:	0f 44 c2             	cmove  %edx,%eax
f0100c6e:	c3                   	ret    
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f0100c6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f0100c74:	c3                   	ret    

f0100c75 <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f0100c75:	55                   	push   %ebp
f0100c76:	89 e5                	mov    %esp,%ebp
f0100c78:	57                   	push   %edi
f0100c79:	56                   	push   %esi
f0100c7a:	53                   	push   %ebx
f0100c7b:	83 ec 4c             	sub    $0x4c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100c7e:	84 c0                	test   %al,%al
f0100c80:	0f 85 3f 03 00 00    	jne    f0100fc5 <check_page_free_list+0x350>
f0100c86:	e9 4c 03 00 00       	jmp    f0100fd7 <check_page_free_list+0x362>
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
		panic("'page_free_list' is a null pointer!");
f0100c8b:	c7 44 24 08 c4 82 10 	movl   $0xf01082c4,0x8(%esp)
f0100c92:	f0 
f0100c93:	c7 44 24 04 52 03 00 	movl   $0x352,0x4(%esp)
f0100c9a:	00 
f0100c9b:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100ca2:	e8 f6 f3 ff ff       	call   f010009d <_panic>

	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100ca7:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100caa:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100cad:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100cb0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100cb3:	89 c2                	mov    %eax,%edx
f0100cb5:	2b 15 d0 8e 2b f0    	sub    0xf02b8ed0,%edx
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100cbb:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100cc1:	0f 95 c2             	setne  %dl
f0100cc4:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100cc7:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100ccb:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100ccd:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100cd1:	8b 00                	mov    (%eax),%eax
f0100cd3:	85 c0                	test   %eax,%eax
f0100cd5:	75 dc                	jne    f0100cb3 <check_page_free_list+0x3e>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f0100cd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100cda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100ce0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100ce3:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100ce6:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100ce8:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100ceb:	a3 40 82 2b f0       	mov    %eax,0xf02b8240
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100cf0:	be 01 00 00 00       	mov    $0x1,%esi
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100cf5:	8b 1d 40 82 2b f0    	mov    0xf02b8240,%ebx
f0100cfb:	eb 63                	jmp    f0100d60 <check_page_free_list+0xeb>
f0100cfd:	89 d8                	mov    %ebx,%eax
f0100cff:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f0100d05:	c1 f8 03             	sar    $0x3,%eax
f0100d08:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100d0b:	89 c2                	mov    %eax,%edx
f0100d0d:	c1 ea 16             	shr    $0x16,%edx
f0100d10:	39 f2                	cmp    %esi,%edx
f0100d12:	73 4a                	jae    f0100d5e <check_page_free_list+0xe9>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100d14:	89 c2                	mov    %eax,%edx
f0100d16:	c1 ea 0c             	shr    $0xc,%edx
f0100d19:	3b 15 c8 8e 2b f0    	cmp    0xf02b8ec8,%edx
f0100d1f:	72 20                	jb     f0100d41 <check_page_free_list+0xcc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100d21:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100d25:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f0100d2c:	f0 
f0100d2d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f0100d34:	00 
f0100d35:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f0100d3c:	e8 5c f3 ff ff       	call   f010009d <_panic>
			memset(page2kva(pp), 0x97, 128);
f0100d41:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f0100d48:	00 
f0100d49:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0100d50:	00 
	return (void *)(pa + KERNBASE);
f0100d51:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100d56:	89 04 24             	mov    %eax,(%esp)
f0100d59:	e8 d9 53 00 00       	call   f0106137 <memset>
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100d5e:	8b 1b                	mov    (%ebx),%ebx
f0100d60:	85 db                	test   %ebx,%ebx
f0100d62:	75 99                	jne    f0100cfd <check_page_free_list+0x88>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f0100d64:	b8 00 00 00 00       	mov    $0x0,%eax
f0100d69:	e8 32 fe ff ff       	call   f0100ba0 <boot_alloc>
f0100d6e:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d71:	8b 15 40 82 2b f0    	mov    0xf02b8240,%edx
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0100d77:	8b 0d d0 8e 2b f0    	mov    0xf02b8ed0,%ecx
		assert(pp < pages + npages);
f0100d7d:	a1 c8 8e 2b f0       	mov    0xf02b8ec8,%eax
f0100d82:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0100d85:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0100d88:	89 45 d0             	mov    %eax,-0x30(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100d8b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f0100d8e:	bf 00 00 00 00       	mov    $0x0,%edi
f0100d93:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100d96:	e9 c4 01 00 00       	jmp    f0100f5f <check_page_free_list+0x2ea>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0100d9b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0100d9e:	73 24                	jae    f0100dc4 <check_page_free_list+0x14f>
f0100da0:	c7 44 24 0c 96 7f 10 	movl   $0xf0107f96,0xc(%esp)
f0100da7:	f0 
f0100da8:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100daf:	f0 
f0100db0:	c7 44 24 04 6c 03 00 	movl   $0x36c,0x4(%esp)
f0100db7:	00 
f0100db8:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100dbf:	e8 d9 f2 ff ff       	call   f010009d <_panic>
		assert(pp < pages + npages);
f0100dc4:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f0100dc7:	72 24                	jb     f0100ded <check_page_free_list+0x178>
f0100dc9:	c7 44 24 0c b7 7f 10 	movl   $0xf0107fb7,0xc(%esp)
f0100dd0:	f0 
f0100dd1:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100dd8:	f0 
f0100dd9:	c7 44 24 04 6d 03 00 	movl   $0x36d,0x4(%esp)
f0100de0:	00 
f0100de1:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100de8:	e8 b0 f2 ff ff       	call   f010009d <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100ded:	89 d0                	mov    %edx,%eax
f0100def:	2b 45 cc             	sub    -0x34(%ebp),%eax
f0100df2:	a8 07                	test   $0x7,%al
f0100df4:	74 24                	je     f0100e1a <check_page_free_list+0x1a5>
f0100df6:	c7 44 24 0c e8 82 10 	movl   $0xf01082e8,0xc(%esp)
f0100dfd:	f0 
f0100dfe:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100e05:	f0 
f0100e06:	c7 44 24 04 6e 03 00 	movl   $0x36e,0x4(%esp)
f0100e0d:	00 
f0100e0e:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100e15:	e8 83 f2 ff ff       	call   f010009d <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100e1a:	c1 f8 03             	sar    $0x3,%eax
f0100e1d:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0100e20:	85 c0                	test   %eax,%eax
f0100e22:	75 24                	jne    f0100e48 <check_page_free_list+0x1d3>
f0100e24:	c7 44 24 0c cb 7f 10 	movl   $0xf0107fcb,0xc(%esp)
f0100e2b:	f0 
f0100e2c:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100e33:	f0 
f0100e34:	c7 44 24 04 71 03 00 	movl   $0x371,0x4(%esp)
f0100e3b:	00 
f0100e3c:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100e43:	e8 55 f2 ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100e48:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100e4d:	75 24                	jne    f0100e73 <check_page_free_list+0x1fe>
f0100e4f:	c7 44 24 0c dc 7f 10 	movl   $0xf0107fdc,0xc(%esp)
f0100e56:	f0 
f0100e57:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100e5e:	f0 
f0100e5f:	c7 44 24 04 72 03 00 	movl   $0x372,0x4(%esp)
f0100e66:	00 
f0100e67:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100e6e:	e8 2a f2 ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100e73:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100e78:	75 24                	jne    f0100e9e <check_page_free_list+0x229>
f0100e7a:	c7 44 24 0c 1c 83 10 	movl   $0xf010831c,0xc(%esp)
f0100e81:	f0 
f0100e82:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100e89:	f0 
f0100e8a:	c7 44 24 04 73 03 00 	movl   $0x373,0x4(%esp)
f0100e91:	00 
f0100e92:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100e99:	e8 ff f1 ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100e9e:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100ea3:	75 24                	jne    f0100ec9 <check_page_free_list+0x254>
f0100ea5:	c7 44 24 0c f5 7f 10 	movl   $0xf0107ff5,0xc(%esp)
f0100eac:	f0 
f0100ead:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100eb4:	f0 
f0100eb5:	c7 44 24 04 74 03 00 	movl   $0x374,0x4(%esp)
f0100ebc:	00 
f0100ebd:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100ec4:	e8 d4 f1 ff ff       	call   f010009d <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ec9:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100ece:	0f 86 2a 01 00 00    	jbe    f0100ffe <check_page_free_list+0x389>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100ed4:	89 c1                	mov    %eax,%ecx
f0100ed6:	c1 e9 0c             	shr    $0xc,%ecx
f0100ed9:	39 4d c4             	cmp    %ecx,-0x3c(%ebp)
f0100edc:	77 20                	ja     f0100efe <check_page_free_list+0x289>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100ede:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100ee2:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f0100ee9:	f0 
f0100eea:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f0100ef1:	00 
f0100ef2:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f0100ef9:	e8 9f f1 ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0100efe:	8d 88 00 00 00 f0    	lea    -0x10000000(%eax),%ecx
f0100f04:	39 4d c8             	cmp    %ecx,-0x38(%ebp)
f0100f07:	0f 86 e1 00 00 00    	jbe    f0100fee <check_page_free_list+0x379>
f0100f0d:	c7 44 24 0c 40 83 10 	movl   $0xf0108340,0xc(%esp)
f0100f14:	f0 
f0100f15:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100f1c:	f0 
f0100f1d:	c7 44 24 04 75 03 00 	movl   $0x375,0x4(%esp)
f0100f24:	00 
f0100f25:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100f2c:	e8 6c f1 ff ff       	call   f010009d <_panic>

		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100f31:	c7 44 24 0c 0f 80 10 	movl   $0xf010800f,0xc(%esp)
f0100f38:	f0 
f0100f39:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100f40:	f0 
f0100f41:	c7 44 24 04 78 03 00 	movl   $0x378,0x4(%esp)
f0100f48:	00 
f0100f49:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100f50:	e8 48 f1 ff ff       	call   f010009d <_panic>




		if (page2pa(pp) < EXTPHYSMEM)
			++nfree_basemem;
f0100f55:	83 c3 01             	add    $0x1,%ebx
f0100f58:	eb 03                	jmp    f0100f5d <check_page_free_list+0x2e8>
		else
			++nfree_extmem;
f0100f5a:	83 c7 01             	add    $0x1,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100f5d:	8b 12                	mov    (%edx),%edx
f0100f5f:	85 d2                	test   %edx,%edx
f0100f61:	0f 85 34 fe ff ff    	jne    f0100d9b <check_page_free_list+0x126>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f0100f67:	85 db                	test   %ebx,%ebx
f0100f69:	7f 24                	jg     f0100f8f <check_page_free_list+0x31a>
f0100f6b:	c7 44 24 0c 2c 80 10 	movl   $0xf010802c,0xc(%esp)
f0100f72:	f0 
f0100f73:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100f7a:	f0 
f0100f7b:	c7 44 24 04 83 03 00 	movl   $0x383,0x4(%esp)
f0100f82:	00 
f0100f83:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100f8a:	e8 0e f1 ff ff       	call   f010009d <_panic>
	assert(nfree_extmem > 0);
f0100f8f:	85 ff                	test   %edi,%edi
f0100f91:	7f 24                	jg     f0100fb7 <check_page_free_list+0x342>
f0100f93:	c7 44 24 0c 3e 80 10 	movl   $0xf010803e,0xc(%esp)
f0100f9a:	f0 
f0100f9b:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0100fa2:	f0 
f0100fa3:	c7 44 24 04 84 03 00 	movl   $0x384,0x4(%esp)
f0100faa:	00 
f0100fab:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0100fb2:	e8 e6 f0 ff ff       	call   f010009d <_panic>
	cprintf("check_page_free_list() succeeded! \n");
f0100fb7:	c7 04 24 88 83 10 f0 	movl   $0xf0108388,(%esp)
f0100fbe:	e8 02 30 00 00       	call   f0103fc5 <cprintf>
f0100fc3:	eb 49                	jmp    f010100e <check_page_free_list+0x399>
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f0100fc5:	a1 40 82 2b f0       	mov    0xf02b8240,%eax
f0100fca:	85 c0                	test   %eax,%eax
f0100fcc:	0f 85 d5 fc ff ff    	jne    f0100ca7 <check_page_free_list+0x32>
f0100fd2:	e9 b4 fc ff ff       	jmp    f0100c8b <check_page_free_list+0x16>
f0100fd7:	83 3d 40 82 2b f0 00 	cmpl   $0x0,0xf02b8240
f0100fde:	0f 84 a7 fc ff ff    	je     f0100c8b <check_page_free_list+0x16>
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100fe4:	be 00 04 00 00       	mov    $0x400,%esi
f0100fe9:	e9 07 fd ff ff       	jmp    f0100cf5 <check_page_free_list+0x80>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
		assert(page2pa(pp) != EXTPHYSMEM);
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);

		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100fee:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100ff3:	0f 85 61 ff ff ff    	jne    f0100f5a <check_page_free_list+0x2e5>
f0100ff9:	e9 33 ff ff ff       	jmp    f0100f31 <check_page_free_list+0x2bc>
f0100ffe:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0101003:	0f 85 4c ff ff ff    	jne    f0100f55 <check_page_free_list+0x2e0>
f0101009:	e9 23 ff ff ff       	jmp    f0100f31 <check_page_free_list+0x2bc>
	assert(nfree_basemem > 0);
	assert(nfree_extmem > 0);
	cprintf("check_page_free_list() succeeded! \n");


}
f010100e:	83 c4 4c             	add    $0x4c,%esp
f0101011:	5b                   	pop    %ebx
f0101012:	5e                   	pop    %esi
f0101013:	5f                   	pop    %edi
f0101014:	5d                   	pop    %ebp
f0101015:	c3                   	ret    

f0101016 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f0101016:	55                   	push   %ebp
f0101017:	89 e5                	mov    %esp,%ebp
f0101019:	57                   	push   %edi
f010101a:	56                   	push   %esi
f010101b:	53                   	push   %ebx
f010101c:	83 ec 1c             	sub    $0x1c,%esp
	//
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!

	page_free_list = NULL;
f010101f:	c7 05 40 82 2b f0 00 	movl   $0x0,0xf02b8240
f0101026:	00 00 00 
	pages[0].pp_ref = 1;
f0101029:	a1 d0 8e 2b f0       	mov    0xf02b8ed0,%eax
f010102e:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	uint32_t pages_kernel = ((uint32_t)boot_alloc(0)-KERNBASE)/PGSIZE;
f0101034:	b8 00 00 00 00       	mov    $0x0,%eax
f0101039:	e8 62 fb ff ff       	call   f0100ba0 <boot_alloc>
f010103e:	89 c7                	mov    %eax,%edi
	cprintf("boot_alloc value %08x\n",boot_alloc(0));
f0101040:	b8 00 00 00 00       	mov    $0x0,%eax
f0101045:	e8 56 fb ff ff       	call   f0100ba0 <boot_alloc>
f010104a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010104e:	c7 04 24 4f 80 10 f0 	movl   $0xf010804f,(%esp)
f0101055:	e8 6b 2f 00 00       	call   f0103fc5 <cprintf>
	size_t i;
	for (i = 1; i < npages; i++) {
		if((i >= npages_basemem && i < npages_basemem+96) || ((i >=npages_basemem+96) &&(i < npages_basemem+96+pages_kernel))||(i==7)) //(0x7c00/PGSIZE = 7)
f010105a:	8b 35 44 82 2b f0    	mov    0xf02b8244,%esi
f0101060:	8d 5e 60             	lea    0x60(%esi),%ebx
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!

	page_free_list = NULL;
	pages[0].pp_ref = 1;
	uint32_t pages_kernel = ((uint32_t)boot_alloc(0)-KERNBASE)/PGSIZE;
f0101063:	81 c7 00 00 00 10    	add    $0x10000000,%edi
f0101069:	c1 ef 0c             	shr    $0xc,%edi
	cprintf("boot_alloc value %08x\n",boot_alloc(0));
	size_t i;
	for (i = 1; i < npages; i++) {
		if((i >= npages_basemem && i < npages_basemem+96) || ((i >=npages_basemem+96) &&(i < npages_basemem+96+pages_kernel))||(i==7)) //(0x7c00/PGSIZE = 7)
f010106c:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
f010106f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101072:	8b 3d 40 82 2b f0    	mov    0xf02b8240,%edi
	page_free_list = NULL;
	pages[0].pp_ref = 1;
	uint32_t pages_kernel = ((uint32_t)boot_alloc(0)-KERNBASE)/PGSIZE;
	cprintf("boot_alloc value %08x\n",boot_alloc(0));
	size_t i;
	for (i = 1; i < npages; i++) {
f0101078:	b8 01 00 00 00       	mov    $0x1,%eax
f010107d:	eb 4e                	jmp    f01010cd <page_init+0xb7>
		if((i >= npages_basemem && i < npages_basemem+96) || ((i >=npages_basemem+96) &&(i < npages_basemem+96+pages_kernel))||(i==7)) //(0x7c00/PGSIZE = 7)
f010107f:	39 f0                	cmp    %esi,%eax
f0101081:	72 06                	jb     f0101089 <page_init+0x73>
f0101083:	39 d8                	cmp    %ebx,%eax
f0101085:	72 15                	jb     f010109c <page_init+0x86>
f0101087:	eb 09                	jmp    f0101092 <page_init+0x7c>
f0101089:	39 d8                	cmp    %ebx,%eax
f010108b:	90                   	nop
f010108c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101090:	72 05                	jb     f0101097 <page_init+0x81>
f0101092:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
f0101095:	72 05                	jb     f010109c <page_init+0x86>
f0101097:	83 f8 07             	cmp    $0x7,%eax
f010109a:	75 0f                	jne    f01010ab <page_init+0x95>
		{
			pages[i].pp_ref = 1;
f010109c:	8b 15 d0 8e 2b f0    	mov    0xf02b8ed0,%edx
f01010a2:	66 c7 44 c2 04 01 00 	movw   $0x1,0x4(%edx,%eax,8)
f01010a9:	eb 1f                	jmp    f01010ca <page_init+0xb4>
f01010ab:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
		}
		else
		{


		pages[i].pp_ref = 0;
f01010b2:	89 d1                	mov    %edx,%ecx
f01010b4:	03 0d d0 8e 2b f0    	add    0xf02b8ed0,%ecx
f01010ba:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f01010c0:	89 39                	mov    %edi,(%ecx)
		page_free_list = &pages[i];
f01010c2:	89 d7                	mov    %edx,%edi
f01010c4:	03 3d d0 8e 2b f0    	add    0xf02b8ed0,%edi
	page_free_list = NULL;
	pages[0].pp_ref = 1;
	uint32_t pages_kernel = ((uint32_t)boot_alloc(0)-KERNBASE)/PGSIZE;
	cprintf("boot_alloc value %08x\n",boot_alloc(0));
	size_t i;
	for (i = 1; i < npages; i++) {
f01010ca:	83 c0 01             	add    $0x1,%eax
f01010cd:	3b 05 c8 8e 2b f0    	cmp    0xf02b8ec8,%eax
f01010d3:	72 aa                	jb     f010107f <page_init+0x69>
f01010d5:	89 3d 40 82 2b f0    	mov    %edi,0xf02b8240

	}



}
f01010db:	83 c4 1c             	add    $0x1c,%esp
f01010de:	5b                   	pop    %ebx
f01010df:	5e                   	pop    %esi
f01010e0:	5f                   	pop    %edi
f01010e1:	5d                   	pop    %ebp
f01010e2:	c3                   	ret    

f01010e3 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f01010e3:	55                   	push   %ebp
f01010e4:	89 e5                	mov    %esp,%ebp
f01010e6:	53                   	push   %ebx
f01010e7:	83 ec 14             	sub    $0x14,%esp
	// Fill this function in


	struct PageInfo *new_page;
	if(page_free_list == NULL)
f01010ea:	8b 1d 40 82 2b f0    	mov    0xf02b8240,%ebx
f01010f0:	85 db                	test   %ebx,%ebx
f01010f2:	74 6f                	je     f0101163 <page_alloc+0x80>
		return NULL;
	}
	else
	{
		new_page = page_free_list;
		new_page->pp_ref =0 ;
f01010f4:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)
		page_free_list = new_page->pp_link;
f01010fa:	8b 03                	mov    (%ebx),%eax
f01010fc:	a3 40 82 2b f0       	mov    %eax,0xf02b8240
		new_page->pp_link = NULL;
f0101101:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101107:	89 d8                	mov    %ebx,%eax
f0101109:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f010110f:	c1 f8 03             	sar    $0x3,%eax
f0101112:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101115:	89 c2                	mov    %eax,%edx
f0101117:	c1 ea 0c             	shr    $0xc,%edx
f010111a:	3b 15 c8 8e 2b f0    	cmp    0xf02b8ec8,%edx
f0101120:	72 20                	jb     f0101142 <page_alloc+0x5f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101122:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101126:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f010112d:	f0 
f010112e:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f0101135:	00 
f0101136:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f010113d:	e8 5b ef ff ff       	call   f010009d <_panic>
		memset(page2kva(new_page),'\0',PGSIZE);
f0101142:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101149:	00 
f010114a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101151:	00 
	return (void *)(pa + KERNBASE);
f0101152:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101157:	89 04 24             	mov    %eax,(%esp)
f010115a:	e8 d8 4f 00 00       	call   f0106137 <memset>
		return new_page;
f010115f:	89 d8                	mov    %ebx,%eax
f0101161:	eb 05                	jmp    f0101168 <page_alloc+0x85>


	struct PageInfo *new_page;
	if(page_free_list == NULL)
	{
		return NULL;
f0101163:	b8 00 00 00 00       	mov    $0x0,%eax
	}




}
f0101168:	83 c4 14             	add    $0x14,%esp
f010116b:	5b                   	pop    %ebx
f010116c:	5d                   	pop    %ebp
f010116d:	c3                   	ret    

f010116e <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f010116e:	55                   	push   %ebp
f010116f:	89 e5                	mov    %esp,%ebp
f0101171:	8b 45 08             	mov    0x8(%ebp),%eax

	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.

	if(pp->pp_ref == 0)
f0101174:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101179:	75 0d                	jne    f0101188 <page_free+0x1a>
	{
		pp->pp_link = page_free_list;
f010117b:	8b 15 40 82 2b f0    	mov    0xf02b8240,%edx
f0101181:	89 10                	mov    %edx,(%eax)
		page_free_list = pp;
f0101183:	a3 40 82 2b f0       	mov    %eax,0xf02b8240
	}



}
f0101188:	5d                   	pop    %ebp
f0101189:	c3                   	ret    

f010118a <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f010118a:	55                   	push   %ebp
f010118b:	89 e5                	mov    %esp,%ebp
f010118d:	83 ec 04             	sub    $0x4,%esp
f0101190:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0101193:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
f0101197:	8d 51 ff             	lea    -0x1(%ecx),%edx
f010119a:	66 89 50 04          	mov    %dx,0x4(%eax)
f010119e:	66 85 d2             	test   %dx,%dx
f01011a1:	75 08                	jne    f01011ab <page_decref+0x21>
		page_free(pp);
f01011a3:	89 04 24             	mov    %eax,(%esp)
f01011a6:	e8 c3 ff ff ff       	call   f010116e <page_free>
}
f01011ab:	c9                   	leave  
f01011ac:	c3                   	ret    

f01011ad <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f01011ad:	55                   	push   %ebp
f01011ae:	89 e5                	mov    %esp,%ebp
f01011b0:	56                   	push   %esi
f01011b1:	53                   	push   %ebx
f01011b2:	83 ec 10             	sub    $0x10,%esp
f01011b5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// Fill this function in


	uintptr_t *pgdir_index = &pgdir[PDX(va)];
f01011b8:	89 f3                	mov    %esi,%ebx
f01011ba:	c1 eb 16             	shr    $0x16,%ebx
f01011bd:	c1 e3 02             	shl    $0x2,%ebx
f01011c0:	03 5d 08             	add    0x8(%ebp),%ebx
	if(!(*pgdir_index & PTE_P)&&!create)
f01011c3:	f6 03 01             	testb  $0x1,(%ebx)
f01011c6:	75 2c                	jne    f01011f4 <pgdir_walk+0x47>
f01011c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01011cc:	74 6c                	je     f010123a <pgdir_walk+0x8d>
		return NULL;
	}
	else if (!(*pgdir_index & PTE_P) && create)
	{
		struct PageInfo *new_page;
		new_page = page_alloc(1);
f01011ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01011d5:	e8 09 ff ff ff       	call   f01010e3 <page_alloc>
		if(new_page == NULL)
f01011da:	85 c0                	test   %eax,%eax
f01011dc:	74 63                	je     f0101241 <pgdir_walk+0x94>
		{
			return NULL;
		}
		else
		{
			new_page->pp_ref++;
f01011de:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01011e3:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f01011e9:	c1 f8 03             	sar    $0x3,%eax
f01011ec:	c1 e0 0c             	shl    $0xc,%eax
			*pgdir_index = (page2pa(new_page)| PTE_P | PTE_U | PTE_W); 
f01011ef:	83 c8 07             	or     $0x7,%eax
f01011f2:	89 03                	mov    %eax,(%ebx)
		}

	}
	uintptr_t page_table_index = PTX(va);
f01011f4:	c1 ee 0c             	shr    $0xc,%esi
f01011f7:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	uintptr_t *page_table_address = KADDR(PTE_ADDR(*pgdir_index));
f01011fd:	8b 03                	mov    (%ebx),%eax
f01011ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101204:	89 c2                	mov    %eax,%edx
f0101206:	c1 ea 0c             	shr    $0xc,%edx
f0101209:	3b 15 c8 8e 2b f0    	cmp    0xf02b8ec8,%edx
f010120f:	72 20                	jb     f0101231 <pgdir_walk+0x84>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101211:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101215:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f010121c:	f0 
f010121d:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
f0101224:	00 
f0101225:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010122c:	e8 6c ee ff ff       	call   f010009d <_panic>
	return &page_table_address[page_table_index];
f0101231:	8d 84 b0 00 00 00 f0 	lea    -0x10000000(%eax,%esi,4),%eax
f0101238:	eb 0c                	jmp    f0101246 <pgdir_walk+0x99>


	uintptr_t *pgdir_index = &pgdir[PDX(va)];
	if(!(*pgdir_index & PTE_P)&&!create)
	{
		return NULL;
f010123a:	b8 00 00 00 00       	mov    $0x0,%eax
f010123f:	eb 05                	jmp    f0101246 <pgdir_walk+0x99>
	{
		struct PageInfo *new_page;
		new_page = page_alloc(1);
		if(new_page == NULL)
		{
			return NULL;
f0101241:	b8 00 00 00 00       	mov    $0x0,%eax
	return &page_table_address[page_table_index];




}
f0101246:	83 c4 10             	add    $0x10,%esp
f0101249:	5b                   	pop    %ebx
f010124a:	5e                   	pop    %esi
f010124b:	5d                   	pop    %ebp
f010124c:	c3                   	ret    

f010124d <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f010124d:	55                   	push   %ebp
f010124e:	89 e5                	mov    %esp,%ebp
f0101250:	57                   	push   %edi
f0101251:	56                   	push   %esi
f0101252:	53                   	push   %ebx
f0101253:	83 ec 2c             	sub    $0x2c,%esp
f0101256:	89 c7                	mov    %eax,%edi
f0101258:	89 d6                	mov    %edx,%esi
f010125a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	// Fill this function in


	uint32_t i =0;
f010125d:	bb 00 00 00 00       	mov    $0x0,%ebx
	while(i<size)
	{
		uint32_t *page_address = pgdir_walk(pgdir,(void *)(va+i),1);
		*page_address = (pa+i)|perm|PTE_P;
f0101262:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101265:	83 c8 01             	or     $0x1,%eax
f0101268:	89 45 e0             	mov    %eax,-0x20(%ebp)
{
	// Fill this function in


	uint32_t i =0;
	while(i<size)
f010126b:	eb 27                	jmp    f0101294 <boot_map_region+0x47>
	{
		uint32_t *page_address = pgdir_walk(pgdir,(void *)(va+i),1);
f010126d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0101274:	00 
f0101275:	8d 04 33             	lea    (%ebx,%esi,1),%eax
f0101278:	89 44 24 04          	mov    %eax,0x4(%esp)
f010127c:	89 3c 24             	mov    %edi,(%esp)
f010127f:	e8 29 ff ff ff       	call   f01011ad <pgdir_walk>
f0101284:	89 da                	mov    %ebx,%edx
f0101286:	03 55 08             	add    0x8(%ebp),%edx
		*page_address = (pa+i)|perm|PTE_P;
f0101289:	0b 55 e0             	or     -0x20(%ebp),%edx
f010128c:	89 10                	mov    %edx,(%eax)
		i = i+PGSIZE;
f010128e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
{
	// Fill this function in


	uint32_t i =0;
	while(i<size)
f0101294:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101297:	72 d4                	jb     f010126d <boot_map_region+0x20>
	}




}
f0101299:	83 c4 2c             	add    $0x2c,%esp
f010129c:	5b                   	pop    %ebx
f010129d:	5e                   	pop    %esi
f010129e:	5f                   	pop    %edi
f010129f:	5d                   	pop    %ebp
f01012a0:	c3                   	ret    

f01012a1 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f01012a1:	55                   	push   %ebp
f01012a2:	89 e5                	mov    %esp,%ebp
f01012a4:	53                   	push   %ebx
f01012a5:	83 ec 14             	sub    $0x14,%esp
f01012a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// Fill this function in


	pte_t *entry = pgdir_walk(pgdir,va,false);
f01012ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01012b2:	00 
f01012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01012b6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01012ba:	8b 45 08             	mov    0x8(%ebp),%eax
f01012bd:	89 04 24             	mov    %eax,(%esp)
f01012c0:	e8 e8 fe ff ff       	call   f01011ad <pgdir_walk>
	if(entry == NULL)
f01012c5:	85 c0                	test   %eax,%eax
f01012c7:	74 3f                	je     f0101308 <page_lookup+0x67>
	{
		return NULL;
	}
	if(!(*entry&PTE_P))
f01012c9:	f6 00 01             	testb  $0x1,(%eax)
f01012cc:	74 41                	je     f010130f <page_lookup+0x6e>
	{
		return NULL;
	}
	if(pte_store)
f01012ce:	85 db                	test   %ebx,%ebx
f01012d0:	74 02                	je     f01012d4 <page_lookup+0x33>
	{
		*pte_store = entry;
f01012d2:	89 03                	mov    %eax,(%ebx)
	}
	physaddr_t page_phy_address = PTE_ADDR(*entry);
f01012d4:	8b 00                	mov    (%eax),%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01012d6:	c1 e8 0c             	shr    $0xc,%eax
f01012d9:	3b 05 c8 8e 2b f0    	cmp    0xf02b8ec8,%eax
f01012df:	72 1c                	jb     f01012fd <page_lookup+0x5c>
		panic("pa2page called with invalid pa");
f01012e1:	c7 44 24 08 ac 83 10 	movl   $0xf01083ac,0x8(%esp)
f01012e8:	f0 
f01012e9:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
f01012f0:	00 
f01012f1:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f01012f8:	e8 a0 ed ff ff       	call   f010009d <_panic>
	return &pages[PGNUM(pa)];
f01012fd:	8b 15 d0 8e 2b f0    	mov    0xf02b8ed0,%edx
f0101303:	8d 04 c2             	lea    (%edx,%eax,8),%eax
	return pa2page(page_phy_address);
f0101306:	eb 0c                	jmp    f0101314 <page_lookup+0x73>


	pte_t *entry = pgdir_walk(pgdir,va,false);
	if(entry == NULL)
	{
		return NULL;
f0101308:	b8 00 00 00 00       	mov    $0x0,%eax
f010130d:	eb 05                	jmp    f0101314 <page_lookup+0x73>
	}
	if(!(*entry&PTE_P))
	{
		return NULL;
f010130f:	b8 00 00 00 00       	mov    $0x0,%eax
	return pa2page(page_phy_address);




}
f0101314:	83 c4 14             	add    $0x14,%esp
f0101317:	5b                   	pop    %ebx
f0101318:	5d                   	pop    %ebp
f0101319:	c3                   	ret    

f010131a <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f010131a:	55                   	push   %ebp
f010131b:	89 e5                	mov    %esp,%ebp
f010131d:	83 ec 08             	sub    $0x8,%esp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0101320:	e8 64 54 00 00       	call   f0106789 <cpunum>
f0101325:	6b c0 74             	imul   $0x74,%eax,%eax
f0101328:	83 b8 28 90 31 f0 00 	cmpl   $0x0,-0xfce6fd8(%eax)
f010132f:	74 16                	je     f0101347 <tlb_invalidate+0x2d>
f0101331:	e8 53 54 00 00       	call   f0106789 <cpunum>
f0101336:	6b c0 74             	imul   $0x74,%eax,%eax
f0101339:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f010133f:	8b 55 08             	mov    0x8(%ebp),%edx
f0101342:	39 50 60             	cmp    %edx,0x60(%eax)
f0101345:	75 06                	jne    f010134d <tlb_invalidate+0x33>
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101347:	8b 45 0c             	mov    0xc(%ebp),%eax
f010134a:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f010134d:	c9                   	leave  
f010134e:	c3                   	ret    

f010134f <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f010134f:	55                   	push   %ebp
f0101350:	89 e5                	mov    %esp,%ebp
f0101352:	56                   	push   %esi
f0101353:	53                   	push   %ebx
f0101354:	83 ec 20             	sub    $0x20,%esp
f0101357:	8b 5d 08             	mov    0x8(%ebp),%ebx
f010135a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// Fill this function in


	pte_t *store;
	struct PageInfo *page_removed = page_lookup(pgdir,va,&store);
f010135d:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101360:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101364:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101368:	89 1c 24             	mov    %ebx,(%esp)
f010136b:	e8 31 ff ff ff       	call   f01012a1 <page_lookup>
	if(page_removed != NULL)
f0101370:	85 c0                	test   %eax,%eax
f0101372:	74 1d                	je     f0101391 <page_remove+0x42>
	{
		page_decref(page_removed);
f0101374:	89 04 24             	mov    %eax,(%esp)
f0101377:	e8 0e fe ff ff       	call   f010118a <page_decref>

			*store = 0 ;
f010137c:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010137f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			tlb_invalidate(pgdir,va);
f0101385:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101389:	89 1c 24             	mov    %ebx,(%esp)
f010138c:	e8 89 ff ff ff       	call   f010131a <tlb_invalidate>
	}




}
f0101391:	83 c4 20             	add    $0x20,%esp
f0101394:	5b                   	pop    %ebx
f0101395:	5e                   	pop    %esi
f0101396:	5d                   	pop    %ebp
f0101397:	c3                   	ret    

f0101398 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f0101398:	55                   	push   %ebp
f0101399:	89 e5                	mov    %esp,%ebp
f010139b:	57                   	push   %edi
f010139c:	56                   	push   %esi
f010139d:	53                   	push   %ebx
f010139e:	83 ec 1c             	sub    $0x1c,%esp
f01013a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01013a4:	8b 7d 0c             	mov    0xc(%ebp),%edi
	// Fill this function in


	uintptr_t *page_table_entry = pgdir_walk(pgdir,va,true);
f01013a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01013ae:	00 
f01013af:	8b 45 10             	mov    0x10(%ebp),%eax
f01013b2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01013b6:	89 1c 24             	mov    %ebx,(%esp)
f01013b9:	e8 ef fd ff ff       	call   f01011ad <pgdir_walk>
f01013be:	89 c6                	mov    %eax,%esi
	if(page_table_entry == NULL)
f01013c0:	85 c0                	test   %eax,%eax
f01013c2:	74 42                	je     f0101406 <page_insert+0x6e>
		return -E_NO_MEM;

	}
	else
	{
		pp->pp_ref++;
f01013c4:	66 83 47 04 01       	addw   $0x1,0x4(%edi)
		if((*page_table_entry)&PTE_P)
f01013c9:	f6 00 01             	testb  $0x1,(%eax)
f01013cc:	74 0f                	je     f01013dd <page_insert+0x45>
		{
			page_remove(pgdir,va);
f01013ce:	8b 45 10             	mov    0x10(%ebp),%eax
f01013d1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01013d5:	89 1c 24             	mov    %ebx,(%esp)
f01013d8:	e8 72 ff ff ff       	call   f010134f <page_remove>
		}
		*page_table_entry = page2pa(pp)|perm|PTE_P;
f01013dd:	8b 45 14             	mov    0x14(%ebp),%eax
f01013e0:	83 c8 01             	or     $0x1,%eax
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01013e3:	2b 3d d0 8e 2b f0    	sub    0xf02b8ed0,%edi
f01013e9:	c1 ff 03             	sar    $0x3,%edi
f01013ec:	c1 e7 0c             	shl    $0xc,%edi
f01013ef:	09 c7                	or     %eax,%edi
f01013f1:	89 3e                	mov    %edi,(%esi)
		pgdir[PDX(va)] |= perm;
f01013f3:	8b 45 10             	mov    0x10(%ebp),%eax
f01013f6:	c1 e8 16             	shr    $0x16,%eax
f01013f9:	8b 55 14             	mov    0x14(%ebp),%edx
f01013fc:	09 14 83             	or     %edx,(%ebx,%eax,4)
	}




	return 0;
f01013ff:	b8 00 00 00 00       	mov    $0x0,%eax
f0101404:	eb 05                	jmp    f010140b <page_insert+0x73>


	uintptr_t *page_table_entry = pgdir_walk(pgdir,va,true);
	if(page_table_entry == NULL)
	{
		return -E_NO_MEM;
f0101406:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax




	return 0;
}
f010140b:	83 c4 1c             	add    $0x1c,%esp
f010140e:	5b                   	pop    %ebx
f010140f:	5e                   	pop    %esi
f0101410:	5f                   	pop    %edi
f0101411:	5d                   	pop    %ebp
f0101412:	c3                   	ret    

f0101413 <mmio_map_region>:
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
//
void *
mmio_map_region(physaddr_t pa, size_t size)
{
f0101413:	55                   	push   %ebp
f0101414:	89 e5                	mov    %esp,%ebp
f0101416:	53                   	push   %ebx
f0101417:	83 ec 14             	sub    $0x14,%esp
	// Hint: The staff solution uses boot_map_region.
	//
	// Your code here:

	//panic("mmio_map_region not implemented");
	size = ROUNDUP(size,PGSIZE);
f010141a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010141d:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f0101423:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if(size+base > MMIOLIM)
f0101429:	8b 15 00 43 12 f0    	mov    0xf0124300,%edx
f010142f:	8d 04 13             	lea    (%ebx,%edx,1),%eax
f0101432:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101437:	76 1c                	jbe    f0101455 <mmio_map_region+0x42>
	panic("MMIOLIM Overrun");
f0101439:	c7 44 24 08 66 80 10 	movl   $0xf0108066,0x8(%esp)
f0101440:	f0 
f0101441:	c7 44 24 04 dc 02 00 	movl   $0x2dc,0x4(%esp)
f0101448:	00 
f0101449:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101450:	e8 48 ec ff ff       	call   f010009d <_panic>
	else
	boot_map_region(kern_pgdir,base,size,pa,PTE_PCD|PTE_PWT|PTE_W);
f0101455:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
f010145c:	00 
f010145d:	8b 45 08             	mov    0x8(%ebp),%eax
f0101460:	89 04 24             	mov    %eax,(%esp)
f0101463:	89 d9                	mov    %ebx,%ecx
f0101465:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f010146a:	e8 de fd ff ff       	call   f010124d <boot_map_region>
	uintptr_t return_value = base;
f010146f:	a1 00 43 12 f0       	mov    0xf0124300,%eax
	base = base + size;
f0101474:	01 c3                	add    %eax,%ebx
f0101476:	89 1d 00 43 12 f0    	mov    %ebx,0xf0124300
	return (void*)return_value;
}
f010147c:	83 c4 14             	add    $0x14,%esp
f010147f:	5b                   	pop    %ebx
f0101480:	5d                   	pop    %ebp
f0101481:	c3                   	ret    

f0101482 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0101482:	55                   	push   %ebp
f0101483:	89 e5                	mov    %esp,%ebp
f0101485:	57                   	push   %edi
f0101486:	56                   	push   %esi
f0101487:	53                   	push   %ebx
f0101488:	83 ec 4c             	sub    $0x4c,%esp
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f010148b:	c7 04 24 15 00 00 00 	movl   $0x15,(%esp)
f0101492:	e8 b2 29 00 00       	call   f0103e49 <mc146818_read>
f0101497:	89 c3                	mov    %eax,%ebx
f0101499:	c7 04 24 16 00 00 00 	movl   $0x16,(%esp)
f01014a0:	e8 a4 29 00 00       	call   f0103e49 <mc146818_read>
f01014a5:	c1 e0 08             	shl    $0x8,%eax
f01014a8:	09 c3                	or     %eax,%ebx
{
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f01014aa:	89 d8                	mov    %ebx,%eax
f01014ac:	c1 e0 0a             	shl    $0xa,%eax
f01014af:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01014b5:	85 c0                	test   %eax,%eax
f01014b7:	0f 48 c2             	cmovs  %edx,%eax
f01014ba:	c1 f8 0c             	sar    $0xc,%eax
f01014bd:	a3 44 82 2b f0       	mov    %eax,0xf02b8244
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f01014c2:	c7 04 24 17 00 00 00 	movl   $0x17,(%esp)
f01014c9:	e8 7b 29 00 00       	call   f0103e49 <mc146818_read>
f01014ce:	89 c3                	mov    %eax,%ebx
f01014d0:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
f01014d7:	e8 6d 29 00 00       	call   f0103e49 <mc146818_read>
f01014dc:	c1 e0 08             	shl    $0x8,%eax
f01014df:	09 c3                	or     %eax,%ebx
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
	npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f01014e1:	89 d8                	mov    %ebx,%eax
f01014e3:	c1 e0 0a             	shl    $0xa,%eax
f01014e6:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01014ec:	85 c0                	test   %eax,%eax
f01014ee:	0f 48 c2             	cmovs  %edx,%eax
f01014f1:	c1 f8 0c             	sar    $0xc,%eax

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (npages_extmem)
f01014f4:	85 c0                	test   %eax,%eax
f01014f6:	74 0e                	je     f0101506 <mem_init+0x84>
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f01014f8:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
f01014fe:	89 15 c8 8e 2b f0    	mov    %edx,0xf02b8ec8
f0101504:	eb 0c                	jmp    f0101512 <mem_init+0x90>
	else
		npages = npages_basemem;
f0101506:	8b 15 44 82 2b f0    	mov    0xf02b8244,%edx
f010150c:	89 15 c8 8e 2b f0    	mov    %edx,0xf02b8ec8

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
		npages_extmem * PGSIZE / 1024);
f0101512:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101515:	c1 e8 0a             	shr    $0xa,%eax
f0101518:	89 44 24 0c          	mov    %eax,0xc(%esp)
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
f010151c:	a1 44 82 2b f0       	mov    0xf02b8244,%eax
f0101521:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101524:	c1 e8 0a             	shr    $0xa,%eax
f0101527:	89 44 24 08          	mov    %eax,0x8(%esp)
		npages * PGSIZE / 1024,
f010152b:	a1 c8 8e 2b f0       	mov    0xf02b8ec8,%eax
f0101530:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0101533:	c1 e8 0a             	shr    $0xa,%eax
f0101536:	89 44 24 04          	mov    %eax,0x4(%esp)
f010153a:	c7 04 24 cc 83 10 f0 	movl   $0xf01083cc,(%esp)
f0101541:	e8 7f 2a 00 00       	call   f0103fc5 <cprintf>



	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101546:	b8 00 10 00 00       	mov    $0x1000,%eax
f010154b:	e8 50 f6 ff ff       	call   f0100ba0 <boot_alloc>
f0101550:	a3 cc 8e 2b f0       	mov    %eax,0xf02b8ecc
	memset(kern_pgdir, 0, PGSIZE);
f0101555:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010155c:	00 
f010155d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101564:	00 
f0101565:	89 04 24             	mov    %eax,(%esp)
f0101568:	e8 ca 4b 00 00       	call   f0106137 <memset>
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f010156d:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101572:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101577:	77 20                	ja     f0101599 <mem_init+0x117>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101579:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010157d:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0101584:	f0 
f0101585:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
f010158c:	00 
f010158d:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101594:	e8 04 eb ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0101599:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010159f:	83 ca 05             	or     $0x5,%edx
f01015a2:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)


	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
	envs = (struct Env *)boot_alloc(sizeof(struct Env )*NENV);
f01015a8:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01015ad:	e8 ee f5 ff ff       	call   f0100ba0 <boot_alloc>
f01015b2:	a3 48 82 2b f0       	mov    %eax,0xf02b8248
	memset(envs,0,sizeof(struct Env)*NENV);
f01015b7:	c7 44 24 08 00 f0 01 	movl   $0x1f000,0x8(%esp)
f01015be:	00 
f01015bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01015c6:	00 
f01015c7:	89 04 24             	mov    %eax,(%esp)
f01015ca:	e8 68 4b 00 00       	call   f0106137 <memset>
	pages = (struct PageInfo *) boot_alloc(sizeof(struct PageInfo)*npages);
f01015cf:	a1 c8 8e 2b f0       	mov    0xf02b8ec8,%eax
f01015d4:	c1 e0 03             	shl    $0x3,%eax
f01015d7:	e8 c4 f5 ff ff       	call   f0100ba0 <boot_alloc>
f01015dc:	a3 d0 8e 2b f0       	mov    %eax,0xf02b8ed0
	memset(pages,0,sizeof(struct PageInfo)*npages);
f01015e1:	8b 0d c8 8e 2b f0    	mov    0xf02b8ec8,%ecx
f01015e7:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f01015ee:	89 54 24 08          	mov    %edx,0x8(%esp)
f01015f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01015f9:	00 
f01015fa:	89 04 24             	mov    %eax,(%esp)
f01015fd:	e8 35 4b 00 00       	call   f0106137 <memset>
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f0101602:	e8 0f fa ff ff       	call   f0101016 <page_init>

	check_page_free_list(1);
f0101607:	b8 01 00 00 00       	mov    $0x1,%eax
f010160c:	e8 64 f6 ff ff       	call   f0100c75 <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f0101611:	83 3d d0 8e 2b f0 00 	cmpl   $0x0,0xf02b8ed0
f0101618:	75 1c                	jne    f0101636 <mem_init+0x1b4>
		panic("'pages' is a null pointer!");
f010161a:	c7 44 24 08 76 80 10 	movl   $0xf0108076,0x8(%esp)
f0101621:	f0 
f0101622:	c7 44 24 04 98 03 00 	movl   $0x398,0x4(%esp)
f0101629:	00 
f010162a:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101631:	e8 67 ea ff ff       	call   f010009d <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101636:	a1 40 82 2b f0       	mov    0xf02b8240,%eax
f010163b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101640:	eb 05                	jmp    f0101647 <mem_init+0x1c5>
		++nfree;
f0101642:	83 c3 01             	add    $0x1,%ebx

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101645:	8b 00                	mov    (%eax),%eax
f0101647:	85 c0                	test   %eax,%eax
f0101649:	75 f7                	jne    f0101642 <mem_init+0x1c0>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f010164b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101652:	e8 8c fa ff ff       	call   f01010e3 <page_alloc>
f0101657:	89 c7                	mov    %eax,%edi
f0101659:	85 c0                	test   %eax,%eax
f010165b:	75 24                	jne    f0101681 <mem_init+0x1ff>
f010165d:	c7 44 24 0c 91 80 10 	movl   $0xf0108091,0xc(%esp)
f0101664:	f0 
f0101665:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010166c:	f0 
f010166d:	c7 44 24 04 a0 03 00 	movl   $0x3a0,0x4(%esp)
f0101674:	00 
f0101675:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010167c:	e8 1c ea ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f0101681:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101688:	e8 56 fa ff ff       	call   f01010e3 <page_alloc>
f010168d:	89 c6                	mov    %eax,%esi
f010168f:	85 c0                	test   %eax,%eax
f0101691:	75 24                	jne    f01016b7 <mem_init+0x235>
f0101693:	c7 44 24 0c a7 80 10 	movl   $0xf01080a7,0xc(%esp)
f010169a:	f0 
f010169b:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01016a2:	f0 
f01016a3:	c7 44 24 04 a1 03 00 	movl   $0x3a1,0x4(%esp)
f01016aa:	00 
f01016ab:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01016b2:	e8 e6 e9 ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f01016b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01016be:	e8 20 fa ff ff       	call   f01010e3 <page_alloc>
f01016c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01016c6:	85 c0                	test   %eax,%eax
f01016c8:	75 24                	jne    f01016ee <mem_init+0x26c>
f01016ca:	c7 44 24 0c bd 80 10 	movl   $0xf01080bd,0xc(%esp)
f01016d1:	f0 
f01016d2:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01016d9:	f0 
f01016da:	c7 44 24 04 a2 03 00 	movl   $0x3a2,0x4(%esp)
f01016e1:	00 
f01016e2:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01016e9:	e8 af e9 ff ff       	call   f010009d <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01016ee:	39 f7                	cmp    %esi,%edi
f01016f0:	75 24                	jne    f0101716 <mem_init+0x294>
f01016f2:	c7 44 24 0c d3 80 10 	movl   $0xf01080d3,0xc(%esp)
f01016f9:	f0 
f01016fa:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101701:	f0 
f0101702:	c7 44 24 04 a5 03 00 	movl   $0x3a5,0x4(%esp)
f0101709:	00 
f010170a:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101711:	e8 87 e9 ff ff       	call   f010009d <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101716:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101719:	39 c6                	cmp    %eax,%esi
f010171b:	74 04                	je     f0101721 <mem_init+0x29f>
f010171d:	39 c7                	cmp    %eax,%edi
f010171f:	75 24                	jne    f0101745 <mem_init+0x2c3>
f0101721:	c7 44 24 0c 08 84 10 	movl   $0xf0108408,0xc(%esp)
f0101728:	f0 
f0101729:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101730:	f0 
f0101731:	c7 44 24 04 a6 03 00 	movl   $0x3a6,0x4(%esp)
f0101738:	00 
f0101739:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101740:	e8 58 e9 ff ff       	call   f010009d <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101745:	8b 15 d0 8e 2b f0    	mov    0xf02b8ed0,%edx
	assert(page2pa(pp0) < npages*PGSIZE);
f010174b:	a1 c8 8e 2b f0       	mov    0xf02b8ec8,%eax
f0101750:	c1 e0 0c             	shl    $0xc,%eax
f0101753:	89 f9                	mov    %edi,%ecx
f0101755:	29 d1                	sub    %edx,%ecx
f0101757:	c1 f9 03             	sar    $0x3,%ecx
f010175a:	c1 e1 0c             	shl    $0xc,%ecx
f010175d:	39 c1                	cmp    %eax,%ecx
f010175f:	72 24                	jb     f0101785 <mem_init+0x303>
f0101761:	c7 44 24 0c e5 80 10 	movl   $0xf01080e5,0xc(%esp)
f0101768:	f0 
f0101769:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101770:	f0 
f0101771:	c7 44 24 04 a7 03 00 	movl   $0x3a7,0x4(%esp)
f0101778:	00 
f0101779:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101780:	e8 18 e9 ff ff       	call   f010009d <_panic>
f0101785:	89 f1                	mov    %esi,%ecx
f0101787:	29 d1                	sub    %edx,%ecx
f0101789:	c1 f9 03             	sar    $0x3,%ecx
f010178c:	c1 e1 0c             	shl    $0xc,%ecx
	assert(page2pa(pp1) < npages*PGSIZE);
f010178f:	39 c8                	cmp    %ecx,%eax
f0101791:	77 24                	ja     f01017b7 <mem_init+0x335>
f0101793:	c7 44 24 0c 02 81 10 	movl   $0xf0108102,0xc(%esp)
f010179a:	f0 
f010179b:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01017a2:	f0 
f01017a3:	c7 44 24 04 a8 03 00 	movl   $0x3a8,0x4(%esp)
f01017aa:	00 
f01017ab:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01017b2:	e8 e6 e8 ff ff       	call   f010009d <_panic>
f01017b7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f01017ba:	29 d1                	sub    %edx,%ecx
f01017bc:	89 ca                	mov    %ecx,%edx
f01017be:	c1 fa 03             	sar    $0x3,%edx
f01017c1:	c1 e2 0c             	shl    $0xc,%edx
	assert(page2pa(pp2) < npages*PGSIZE);
f01017c4:	39 d0                	cmp    %edx,%eax
f01017c6:	77 24                	ja     f01017ec <mem_init+0x36a>
f01017c8:	c7 44 24 0c 1f 81 10 	movl   $0xf010811f,0xc(%esp)
f01017cf:	f0 
f01017d0:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01017d7:	f0 
f01017d8:	c7 44 24 04 a9 03 00 	movl   $0x3a9,0x4(%esp)
f01017df:	00 
f01017e0:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01017e7:	e8 b1 e8 ff ff       	call   f010009d <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f01017ec:	a1 40 82 2b f0       	mov    0xf02b8240,%eax
f01017f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f01017f4:	c7 05 40 82 2b f0 00 	movl   $0x0,0xf02b8240
f01017fb:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f01017fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101805:	e8 d9 f8 ff ff       	call   f01010e3 <page_alloc>
f010180a:	85 c0                	test   %eax,%eax
f010180c:	74 24                	je     f0101832 <mem_init+0x3b0>
f010180e:	c7 44 24 0c 3c 81 10 	movl   $0xf010813c,0xc(%esp)
f0101815:	f0 
f0101816:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010181d:	f0 
f010181e:	c7 44 24 04 b0 03 00 	movl   $0x3b0,0x4(%esp)
f0101825:	00 
f0101826:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010182d:	e8 6b e8 ff ff       	call   f010009d <_panic>

	// free and re-allocate?
	page_free(pp0);
f0101832:	89 3c 24             	mov    %edi,(%esp)
f0101835:	e8 34 f9 ff ff       	call   f010116e <page_free>
	page_free(pp1);
f010183a:	89 34 24             	mov    %esi,(%esp)
f010183d:	e8 2c f9 ff ff       	call   f010116e <page_free>
	page_free(pp2);
f0101842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101845:	89 04 24             	mov    %eax,(%esp)
f0101848:	e8 21 f9 ff ff       	call   f010116e <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f010184d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101854:	e8 8a f8 ff ff       	call   f01010e3 <page_alloc>
f0101859:	89 c6                	mov    %eax,%esi
f010185b:	85 c0                	test   %eax,%eax
f010185d:	75 24                	jne    f0101883 <mem_init+0x401>
f010185f:	c7 44 24 0c 91 80 10 	movl   $0xf0108091,0xc(%esp)
f0101866:	f0 
f0101867:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010186e:	f0 
f010186f:	c7 44 24 04 b7 03 00 	movl   $0x3b7,0x4(%esp)
f0101876:	00 
f0101877:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010187e:	e8 1a e8 ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f0101883:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010188a:	e8 54 f8 ff ff       	call   f01010e3 <page_alloc>
f010188f:	89 c7                	mov    %eax,%edi
f0101891:	85 c0                	test   %eax,%eax
f0101893:	75 24                	jne    f01018b9 <mem_init+0x437>
f0101895:	c7 44 24 0c a7 80 10 	movl   $0xf01080a7,0xc(%esp)
f010189c:	f0 
f010189d:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01018a4:	f0 
f01018a5:	c7 44 24 04 b8 03 00 	movl   $0x3b8,0x4(%esp)
f01018ac:	00 
f01018ad:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01018b4:	e8 e4 e7 ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f01018b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01018c0:	e8 1e f8 ff ff       	call   f01010e3 <page_alloc>
f01018c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01018c8:	85 c0                	test   %eax,%eax
f01018ca:	75 24                	jne    f01018f0 <mem_init+0x46e>
f01018cc:	c7 44 24 0c bd 80 10 	movl   $0xf01080bd,0xc(%esp)
f01018d3:	f0 
f01018d4:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01018db:	f0 
f01018dc:	c7 44 24 04 b9 03 00 	movl   $0x3b9,0x4(%esp)
f01018e3:	00 
f01018e4:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01018eb:	e8 ad e7 ff ff       	call   f010009d <_panic>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f01018f0:	39 fe                	cmp    %edi,%esi
f01018f2:	75 24                	jne    f0101918 <mem_init+0x496>
f01018f4:	c7 44 24 0c d3 80 10 	movl   $0xf01080d3,0xc(%esp)
f01018fb:	f0 
f01018fc:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101903:	f0 
f0101904:	c7 44 24 04 bb 03 00 	movl   $0x3bb,0x4(%esp)
f010190b:	00 
f010190c:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101913:	e8 85 e7 ff ff       	call   f010009d <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101918:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010191b:	39 c7                	cmp    %eax,%edi
f010191d:	74 04                	je     f0101923 <mem_init+0x4a1>
f010191f:	39 c6                	cmp    %eax,%esi
f0101921:	75 24                	jne    f0101947 <mem_init+0x4c5>
f0101923:	c7 44 24 0c 08 84 10 	movl   $0xf0108408,0xc(%esp)
f010192a:	f0 
f010192b:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101932:	f0 
f0101933:	c7 44 24 04 bc 03 00 	movl   $0x3bc,0x4(%esp)
f010193a:	00 
f010193b:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101942:	e8 56 e7 ff ff       	call   f010009d <_panic>
	assert(!page_alloc(0));
f0101947:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010194e:	e8 90 f7 ff ff       	call   f01010e3 <page_alloc>
f0101953:	85 c0                	test   %eax,%eax
f0101955:	74 24                	je     f010197b <mem_init+0x4f9>
f0101957:	c7 44 24 0c 3c 81 10 	movl   $0xf010813c,0xc(%esp)
f010195e:	f0 
f010195f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101966:	f0 
f0101967:	c7 44 24 04 bd 03 00 	movl   $0x3bd,0x4(%esp)
f010196e:	00 
f010196f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101976:	e8 22 e7 ff ff       	call   f010009d <_panic>
f010197b:	89 f0                	mov    %esi,%eax
f010197d:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f0101983:	c1 f8 03             	sar    $0x3,%eax
f0101986:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101989:	89 c2                	mov    %eax,%edx
f010198b:	c1 ea 0c             	shr    $0xc,%edx
f010198e:	3b 15 c8 8e 2b f0    	cmp    0xf02b8ec8,%edx
f0101994:	72 20                	jb     f01019b6 <mem_init+0x534>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101996:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010199a:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f01019a1:	f0 
f01019a2:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f01019a9:	00 
f01019aa:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f01019b1:	e8 e7 e6 ff ff       	call   f010009d <_panic>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f01019b6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01019bd:	00 
f01019be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f01019c5:	00 
	return (void *)(pa + KERNBASE);
f01019c6:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01019cb:	89 04 24             	mov    %eax,(%esp)
f01019ce:	e8 64 47 00 00       	call   f0106137 <memset>
	page_free(pp0);
f01019d3:	89 34 24             	mov    %esi,(%esp)
f01019d6:	e8 93 f7 ff ff       	call   f010116e <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f01019db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01019e2:	e8 fc f6 ff ff       	call   f01010e3 <page_alloc>
f01019e7:	85 c0                	test   %eax,%eax
f01019e9:	75 24                	jne    f0101a0f <mem_init+0x58d>
f01019eb:	c7 44 24 0c 4b 81 10 	movl   $0xf010814b,0xc(%esp)
f01019f2:	f0 
f01019f3:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01019fa:	f0 
f01019fb:	c7 44 24 04 c2 03 00 	movl   $0x3c2,0x4(%esp)
f0101a02:	00 
f0101a03:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101a0a:	e8 8e e6 ff ff       	call   f010009d <_panic>
	assert(pp && pp0 == pp);
f0101a0f:	39 c6                	cmp    %eax,%esi
f0101a11:	74 24                	je     f0101a37 <mem_init+0x5b5>
f0101a13:	c7 44 24 0c 69 81 10 	movl   $0xf0108169,0xc(%esp)
f0101a1a:	f0 
f0101a1b:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101a22:	f0 
f0101a23:	c7 44 24 04 c3 03 00 	movl   $0x3c3,0x4(%esp)
f0101a2a:	00 
f0101a2b:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101a32:	e8 66 e6 ff ff       	call   f010009d <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101a37:	89 f0                	mov    %esi,%eax
f0101a39:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f0101a3f:	c1 f8 03             	sar    $0x3,%eax
f0101a42:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101a45:	89 c2                	mov    %eax,%edx
f0101a47:	c1 ea 0c             	shr    $0xc,%edx
f0101a4a:	3b 15 c8 8e 2b f0    	cmp    0xf02b8ec8,%edx
f0101a50:	72 20                	jb     f0101a72 <mem_init+0x5f0>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101a52:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101a56:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f0101a5d:	f0 
f0101a5e:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f0101a65:	00 
f0101a66:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f0101a6d:	e8 2b e6 ff ff       	call   f010009d <_panic>
f0101a72:	8d 90 00 10 00 f0    	lea    -0xffff000(%eax),%edx
	return (void *)(pa + KERNBASE);
f0101a78:	8d 80 00 00 00 f0    	lea    -0x10000000(%eax),%eax
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);
f0101a7e:	80 38 00             	cmpb   $0x0,(%eax)
f0101a81:	74 24                	je     f0101aa7 <mem_init+0x625>
f0101a83:	c7 44 24 0c 79 81 10 	movl   $0xf0108179,0xc(%esp)
f0101a8a:	f0 
f0101a8b:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101a92:	f0 
f0101a93:	c7 44 24 04 c6 03 00 	movl   $0x3c6,0x4(%esp)
f0101a9a:	00 
f0101a9b:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101aa2:	e8 f6 e5 ff ff       	call   f010009d <_panic>
f0101aa7:	83 c0 01             	add    $0x1,%eax
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f0101aaa:	39 d0                	cmp    %edx,%eax
f0101aac:	75 d0                	jne    f0101a7e <mem_init+0x5fc>
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f0101aae:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101ab1:	a3 40 82 2b f0       	mov    %eax,0xf02b8240

	// free the pages we took
	page_free(pp0);
f0101ab6:	89 34 24             	mov    %esi,(%esp)
f0101ab9:	e8 b0 f6 ff ff       	call   f010116e <page_free>
	page_free(pp1);
f0101abe:	89 3c 24             	mov    %edi,(%esp)
f0101ac1:	e8 a8 f6 ff ff       	call   f010116e <page_free>
	page_free(pp2);
f0101ac6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ac9:	89 04 24             	mov    %eax,(%esp)
f0101acc:	e8 9d f6 ff ff       	call   f010116e <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101ad1:	a1 40 82 2b f0       	mov    0xf02b8240,%eax
f0101ad6:	eb 05                	jmp    f0101add <mem_init+0x65b>
		--nfree;
f0101ad8:	83 eb 01             	sub    $0x1,%ebx
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101adb:	8b 00                	mov    (%eax),%eax
f0101add:	85 c0                	test   %eax,%eax
f0101adf:	75 f7                	jne    f0101ad8 <mem_init+0x656>
		--nfree;
	assert(nfree == 0);
f0101ae1:	85 db                	test   %ebx,%ebx
f0101ae3:	74 24                	je     f0101b09 <mem_init+0x687>
f0101ae5:	c7 44 24 0c 83 81 10 	movl   $0xf0108183,0xc(%esp)
f0101aec:	f0 
f0101aed:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101af4:	f0 
f0101af5:	c7 44 24 04 d3 03 00 	movl   $0x3d3,0x4(%esp)
f0101afc:	00 
f0101afd:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101b04:	e8 94 e5 ff ff       	call   f010009d <_panic>

	cprintf("check_page_alloc() succeeded!\n");
f0101b09:	c7 04 24 28 84 10 f0 	movl   $0xf0108428,(%esp)
f0101b10:	e8 b0 24 00 00       	call   f0103fc5 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101b15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101b1c:	e8 c2 f5 ff ff       	call   f01010e3 <page_alloc>
f0101b21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101b24:	85 c0                	test   %eax,%eax
f0101b26:	75 24                	jne    f0101b4c <mem_init+0x6ca>
f0101b28:	c7 44 24 0c 91 80 10 	movl   $0xf0108091,0xc(%esp)
f0101b2f:	f0 
f0101b30:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101b37:	f0 
f0101b38:	c7 44 24 04 3e 04 00 	movl   $0x43e,0x4(%esp)
f0101b3f:	00 
f0101b40:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101b47:	e8 51 e5 ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f0101b4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101b53:	e8 8b f5 ff ff       	call   f01010e3 <page_alloc>
f0101b58:	89 c3                	mov    %eax,%ebx
f0101b5a:	85 c0                	test   %eax,%eax
f0101b5c:	75 24                	jne    f0101b82 <mem_init+0x700>
f0101b5e:	c7 44 24 0c a7 80 10 	movl   $0xf01080a7,0xc(%esp)
f0101b65:	f0 
f0101b66:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101b6d:	f0 
f0101b6e:	c7 44 24 04 3f 04 00 	movl   $0x43f,0x4(%esp)
f0101b75:	00 
f0101b76:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101b7d:	e8 1b e5 ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f0101b82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101b89:	e8 55 f5 ff ff       	call   f01010e3 <page_alloc>
f0101b8e:	89 c6                	mov    %eax,%esi
f0101b90:	85 c0                	test   %eax,%eax
f0101b92:	75 24                	jne    f0101bb8 <mem_init+0x736>
f0101b94:	c7 44 24 0c bd 80 10 	movl   $0xf01080bd,0xc(%esp)
f0101b9b:	f0 
f0101b9c:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101ba3:	f0 
f0101ba4:	c7 44 24 04 40 04 00 	movl   $0x440,0x4(%esp)
f0101bab:	00 
f0101bac:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101bb3:	e8 e5 e4 ff ff       	call   f010009d <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101bb8:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0101bbb:	75 24                	jne    f0101be1 <mem_init+0x75f>
f0101bbd:	c7 44 24 0c d3 80 10 	movl   $0xf01080d3,0xc(%esp)
f0101bc4:	f0 
f0101bc5:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101bcc:	f0 
f0101bcd:	c7 44 24 04 43 04 00 	movl   $0x443,0x4(%esp)
f0101bd4:	00 
f0101bd5:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101bdc:	e8 bc e4 ff ff       	call   f010009d <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101be1:	39 c3                	cmp    %eax,%ebx
f0101be3:	74 05                	je     f0101bea <mem_init+0x768>
f0101be5:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101be8:	75 24                	jne    f0101c0e <mem_init+0x78c>
f0101bea:	c7 44 24 0c 08 84 10 	movl   $0xf0108408,0xc(%esp)
f0101bf1:	f0 
f0101bf2:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101bf9:	f0 
f0101bfa:	c7 44 24 04 44 04 00 	movl   $0x444,0x4(%esp)
f0101c01:	00 
f0101c02:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101c09:	e8 8f e4 ff ff       	call   f010009d <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101c0e:	a1 40 82 2b f0       	mov    0xf02b8240,%eax
f0101c13:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101c16:	c7 05 40 82 2b f0 00 	movl   $0x0,0xf02b8240
f0101c1d:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101c20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c27:	e8 b7 f4 ff ff       	call   f01010e3 <page_alloc>
f0101c2c:	85 c0                	test   %eax,%eax
f0101c2e:	74 24                	je     f0101c54 <mem_init+0x7d2>
f0101c30:	c7 44 24 0c 3c 81 10 	movl   $0xf010813c,0xc(%esp)
f0101c37:	f0 
f0101c38:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101c3f:	f0 
f0101c40:	c7 44 24 04 4b 04 00 	movl   $0x44b,0x4(%esp)
f0101c47:	00 
f0101c48:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101c4f:	e8 49 e4 ff ff       	call   f010009d <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101c54:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101c57:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101c5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101c62:	00 
f0101c63:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0101c68:	89 04 24             	mov    %eax,(%esp)
f0101c6b:	e8 31 f6 ff ff       	call   f01012a1 <page_lookup>
f0101c70:	85 c0                	test   %eax,%eax
f0101c72:	74 24                	je     f0101c98 <mem_init+0x816>
f0101c74:	c7 44 24 0c 48 84 10 	movl   $0xf0108448,0xc(%esp)
f0101c7b:	f0 
f0101c7c:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101c83:	f0 
f0101c84:	c7 44 24 04 4e 04 00 	movl   $0x44e,0x4(%esp)
f0101c8b:	00 
f0101c8c:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101c93:	e8 05 e4 ff ff       	call   f010009d <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101c98:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0101c9f:	00 
f0101ca0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101ca7:	00 
f0101ca8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101cac:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0101cb1:	89 04 24             	mov    %eax,(%esp)
f0101cb4:	e8 df f6 ff ff       	call   f0101398 <page_insert>
f0101cb9:	85 c0                	test   %eax,%eax
f0101cbb:	78 24                	js     f0101ce1 <mem_init+0x85f>
f0101cbd:	c7 44 24 0c 80 84 10 	movl   $0xf0108480,0xc(%esp)
f0101cc4:	f0 
f0101cc5:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101ccc:	f0 
f0101ccd:	c7 44 24 04 51 04 00 	movl   $0x451,0x4(%esp)
f0101cd4:	00 
f0101cd5:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101cdc:	e8 bc e3 ff ff       	call   f010009d <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101ce1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ce4:	89 04 24             	mov    %eax,(%esp)
f0101ce7:	e8 82 f4 ff ff       	call   f010116e <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101cec:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0101cf3:	00 
f0101cf4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101cfb:	00 
f0101cfc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101d00:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0101d05:	89 04 24             	mov    %eax,(%esp)
f0101d08:	e8 8b f6 ff ff       	call   f0101398 <page_insert>
f0101d0d:	85 c0                	test   %eax,%eax
f0101d0f:	74 24                	je     f0101d35 <mem_init+0x8b3>
f0101d11:	c7 44 24 0c b0 84 10 	movl   $0xf01084b0,0xc(%esp)
f0101d18:	f0 
f0101d19:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101d20:	f0 
f0101d21:	c7 44 24 04 55 04 00 	movl   $0x455,0x4(%esp)
f0101d28:	00 
f0101d29:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101d30:	e8 68 e3 ff ff       	call   f010009d <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101d35:	8b 3d cc 8e 2b f0    	mov    0xf02b8ecc,%edi
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101d3b:	a1 d0 8e 2b f0       	mov    0xf02b8ed0,%eax
f0101d40:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101d43:	8b 17                	mov    (%edi),%edx
f0101d45:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101d4b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101d4e:	29 c1                	sub    %eax,%ecx
f0101d50:	89 c8                	mov    %ecx,%eax
f0101d52:	c1 f8 03             	sar    $0x3,%eax
f0101d55:	c1 e0 0c             	shl    $0xc,%eax
f0101d58:	39 c2                	cmp    %eax,%edx
f0101d5a:	74 24                	je     f0101d80 <mem_init+0x8fe>
f0101d5c:	c7 44 24 0c e0 84 10 	movl   $0xf01084e0,0xc(%esp)
f0101d63:	f0 
f0101d64:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101d6b:	f0 
f0101d6c:	c7 44 24 04 56 04 00 	movl   $0x456,0x4(%esp)
f0101d73:	00 
f0101d74:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101d7b:	e8 1d e3 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101d80:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d85:	89 f8                	mov    %edi,%eax
f0101d87:	e8 7a ee ff ff       	call   f0100c06 <check_va2pa>
f0101d8c:	89 da                	mov    %ebx,%edx
f0101d8e:	2b 55 cc             	sub    -0x34(%ebp),%edx
f0101d91:	c1 fa 03             	sar    $0x3,%edx
f0101d94:	c1 e2 0c             	shl    $0xc,%edx
f0101d97:	39 d0                	cmp    %edx,%eax
f0101d99:	74 24                	je     f0101dbf <mem_init+0x93d>
f0101d9b:	c7 44 24 0c 08 85 10 	movl   $0xf0108508,0xc(%esp)
f0101da2:	f0 
f0101da3:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101daa:	f0 
f0101dab:	c7 44 24 04 57 04 00 	movl   $0x457,0x4(%esp)
f0101db2:	00 
f0101db3:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101dba:	e8 de e2 ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 1);
f0101dbf:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101dc4:	74 24                	je     f0101dea <mem_init+0x968>
f0101dc6:	c7 44 24 0c 8e 81 10 	movl   $0xf010818e,0xc(%esp)
f0101dcd:	f0 
f0101dce:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101dd5:	f0 
f0101dd6:	c7 44 24 04 58 04 00 	movl   $0x458,0x4(%esp)
f0101ddd:	00 
f0101dde:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101de5:	e8 b3 e2 ff ff       	call   f010009d <_panic>
	assert(pp0->pp_ref == 1);
f0101dea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ded:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0101df2:	74 24                	je     f0101e18 <mem_init+0x996>
f0101df4:	c7 44 24 0c 9f 81 10 	movl   $0xf010819f,0xc(%esp)
f0101dfb:	f0 
f0101dfc:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101e03:	f0 
f0101e04:	c7 44 24 04 59 04 00 	movl   $0x459,0x4(%esp)
f0101e0b:	00 
f0101e0c:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101e13:	e8 85 e2 ff ff       	call   f010009d <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101e18:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0101e1f:	00 
f0101e20:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101e27:	00 
f0101e28:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101e2c:	89 3c 24             	mov    %edi,(%esp)
f0101e2f:	e8 64 f5 ff ff       	call   f0101398 <page_insert>
f0101e34:	85 c0                	test   %eax,%eax
f0101e36:	74 24                	je     f0101e5c <mem_init+0x9da>
f0101e38:	c7 44 24 0c 38 85 10 	movl   $0xf0108538,0xc(%esp)
f0101e3f:	f0 
f0101e40:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101e47:	f0 
f0101e48:	c7 44 24 04 5c 04 00 	movl   $0x45c,0x4(%esp)
f0101e4f:	00 
f0101e50:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101e57:	e8 41 e2 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e5c:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e61:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0101e66:	e8 9b ed ff ff       	call   f0100c06 <check_va2pa>
f0101e6b:	89 f2                	mov    %esi,%edx
f0101e6d:	2b 15 d0 8e 2b f0    	sub    0xf02b8ed0,%edx
f0101e73:	c1 fa 03             	sar    $0x3,%edx
f0101e76:	c1 e2 0c             	shl    $0xc,%edx
f0101e79:	39 d0                	cmp    %edx,%eax
f0101e7b:	74 24                	je     f0101ea1 <mem_init+0xa1f>
f0101e7d:	c7 44 24 0c 74 85 10 	movl   $0xf0108574,0xc(%esp)
f0101e84:	f0 
f0101e85:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101e8c:	f0 
f0101e8d:	c7 44 24 04 5d 04 00 	movl   $0x45d,0x4(%esp)
f0101e94:	00 
f0101e95:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101e9c:	e8 fc e1 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f0101ea1:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101ea6:	74 24                	je     f0101ecc <mem_init+0xa4a>
f0101ea8:	c7 44 24 0c b0 81 10 	movl   $0xf01081b0,0xc(%esp)
f0101eaf:	f0 
f0101eb0:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101eb7:	f0 
f0101eb8:	c7 44 24 04 5e 04 00 	movl   $0x45e,0x4(%esp)
f0101ebf:	00 
f0101ec0:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101ec7:	e8 d1 e1 ff ff       	call   f010009d <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0101ecc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ed3:	e8 0b f2 ff ff       	call   f01010e3 <page_alloc>
f0101ed8:	85 c0                	test   %eax,%eax
f0101eda:	74 24                	je     f0101f00 <mem_init+0xa7e>
f0101edc:	c7 44 24 0c 3c 81 10 	movl   $0xf010813c,0xc(%esp)
f0101ee3:	f0 
f0101ee4:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101eeb:	f0 
f0101eec:	c7 44 24 04 61 04 00 	movl   $0x461,0x4(%esp)
f0101ef3:	00 
f0101ef4:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101efb:	e8 9d e1 ff ff       	call   f010009d <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101f00:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0101f07:	00 
f0101f08:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101f0f:	00 
f0101f10:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101f14:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0101f19:	89 04 24             	mov    %eax,(%esp)
f0101f1c:	e8 77 f4 ff ff       	call   f0101398 <page_insert>
f0101f21:	85 c0                	test   %eax,%eax
f0101f23:	74 24                	je     f0101f49 <mem_init+0xac7>
f0101f25:	c7 44 24 0c 38 85 10 	movl   $0xf0108538,0xc(%esp)
f0101f2c:	f0 
f0101f2d:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101f34:	f0 
f0101f35:	c7 44 24 04 64 04 00 	movl   $0x464,0x4(%esp)
f0101f3c:	00 
f0101f3d:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101f44:	e8 54 e1 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101f49:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101f4e:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0101f53:	e8 ae ec ff ff       	call   f0100c06 <check_va2pa>
f0101f58:	89 f2                	mov    %esi,%edx
f0101f5a:	2b 15 d0 8e 2b f0    	sub    0xf02b8ed0,%edx
f0101f60:	c1 fa 03             	sar    $0x3,%edx
f0101f63:	c1 e2 0c             	shl    $0xc,%edx
f0101f66:	39 d0                	cmp    %edx,%eax
f0101f68:	74 24                	je     f0101f8e <mem_init+0xb0c>
f0101f6a:	c7 44 24 0c 74 85 10 	movl   $0xf0108574,0xc(%esp)
f0101f71:	f0 
f0101f72:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101f79:	f0 
f0101f7a:	c7 44 24 04 65 04 00 	movl   $0x465,0x4(%esp)
f0101f81:	00 
f0101f82:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101f89:	e8 0f e1 ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f0101f8e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101f93:	74 24                	je     f0101fb9 <mem_init+0xb37>
f0101f95:	c7 44 24 0c b0 81 10 	movl   $0xf01081b0,0xc(%esp)
f0101f9c:	f0 
f0101f9d:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101fa4:	f0 
f0101fa5:	c7 44 24 04 66 04 00 	movl   $0x466,0x4(%esp)
f0101fac:	00 
f0101fad:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101fb4:	e8 e4 e0 ff ff       	call   f010009d <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101fb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101fc0:	e8 1e f1 ff ff       	call   f01010e3 <page_alloc>
f0101fc5:	85 c0                	test   %eax,%eax
f0101fc7:	74 24                	je     f0101fed <mem_init+0xb6b>
f0101fc9:	c7 44 24 0c 3c 81 10 	movl   $0xf010813c,0xc(%esp)
f0101fd0:	f0 
f0101fd1:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0101fd8:	f0 
f0101fd9:	c7 44 24 04 6a 04 00 	movl   $0x46a,0x4(%esp)
f0101fe0:	00 
f0101fe1:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0101fe8:	e8 b0 e0 ff ff       	call   f010009d <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101fed:	8b 15 cc 8e 2b f0    	mov    0xf02b8ecc,%edx
f0101ff3:	8b 02                	mov    (%edx),%eax
f0101ff5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101ffa:	89 c1                	mov    %eax,%ecx
f0101ffc:	c1 e9 0c             	shr    $0xc,%ecx
f0101fff:	3b 0d c8 8e 2b f0    	cmp    0xf02b8ec8,%ecx
f0102005:	72 20                	jb     f0102027 <mem_init+0xba5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102007:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010200b:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f0102012:	f0 
f0102013:	c7 44 24 04 6d 04 00 	movl   $0x46d,0x4(%esp)
f010201a:	00 
f010201b:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102022:	e8 76 e0 ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0102027:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010202c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f010202f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102036:	00 
f0102037:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010203e:	00 
f010203f:	89 14 24             	mov    %edx,(%esp)
f0102042:	e8 66 f1 ff ff       	call   f01011ad <pgdir_walk>
f0102047:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010204a:	8d 51 04             	lea    0x4(%ecx),%edx
f010204d:	39 d0                	cmp    %edx,%eax
f010204f:	74 24                	je     f0102075 <mem_init+0xbf3>
f0102051:	c7 44 24 0c a4 85 10 	movl   $0xf01085a4,0xc(%esp)
f0102058:	f0 
f0102059:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102060:	f0 
f0102061:	c7 44 24 04 6e 04 00 	movl   $0x46e,0x4(%esp)
f0102068:	00 
f0102069:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102070:	e8 28 e0 ff ff       	call   f010009d <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102075:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f010207c:	00 
f010207d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102084:	00 
f0102085:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102089:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f010208e:	89 04 24             	mov    %eax,(%esp)
f0102091:	e8 02 f3 ff ff       	call   f0101398 <page_insert>
f0102096:	85 c0                	test   %eax,%eax
f0102098:	74 24                	je     f01020be <mem_init+0xc3c>
f010209a:	c7 44 24 0c e4 85 10 	movl   $0xf01085e4,0xc(%esp)
f01020a1:	f0 
f01020a2:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01020a9:	f0 
f01020aa:	c7 44 24 04 71 04 00 	movl   $0x471,0x4(%esp)
f01020b1:	00 
f01020b2:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01020b9:	e8 df df ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01020be:	8b 3d cc 8e 2b f0    	mov    0xf02b8ecc,%edi
f01020c4:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020c9:	89 f8                	mov    %edi,%eax
f01020cb:	e8 36 eb ff ff       	call   f0100c06 <check_va2pa>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01020d0:	89 f2                	mov    %esi,%edx
f01020d2:	2b 15 d0 8e 2b f0    	sub    0xf02b8ed0,%edx
f01020d8:	c1 fa 03             	sar    $0x3,%edx
f01020db:	c1 e2 0c             	shl    $0xc,%edx
f01020de:	39 d0                	cmp    %edx,%eax
f01020e0:	74 24                	je     f0102106 <mem_init+0xc84>
f01020e2:	c7 44 24 0c 74 85 10 	movl   $0xf0108574,0xc(%esp)
f01020e9:	f0 
f01020ea:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01020f1:	f0 
f01020f2:	c7 44 24 04 72 04 00 	movl   $0x472,0x4(%esp)
f01020f9:	00 
f01020fa:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102101:	e8 97 df ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f0102106:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010210b:	74 24                	je     f0102131 <mem_init+0xcaf>
f010210d:	c7 44 24 0c b0 81 10 	movl   $0xf01081b0,0xc(%esp)
f0102114:	f0 
f0102115:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010211c:	f0 
f010211d:	c7 44 24 04 73 04 00 	movl   $0x473,0x4(%esp)
f0102124:	00 
f0102125:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010212c:	e8 6c df ff ff       	call   f010009d <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102131:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102138:	00 
f0102139:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102140:	00 
f0102141:	89 3c 24             	mov    %edi,(%esp)
f0102144:	e8 64 f0 ff ff       	call   f01011ad <pgdir_walk>
f0102149:	f6 00 04             	testb  $0x4,(%eax)
f010214c:	75 24                	jne    f0102172 <mem_init+0xcf0>
f010214e:	c7 44 24 0c 24 86 10 	movl   $0xf0108624,0xc(%esp)
f0102155:	f0 
f0102156:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010215d:	f0 
f010215e:	c7 44 24 04 74 04 00 	movl   $0x474,0x4(%esp)
f0102165:	00 
f0102166:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010216d:	e8 2b df ff ff       	call   f010009d <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0102172:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102177:	f6 00 04             	testb  $0x4,(%eax)
f010217a:	75 24                	jne    f01021a0 <mem_init+0xd1e>
f010217c:	c7 44 24 0c c1 81 10 	movl   $0xf01081c1,0xc(%esp)
f0102183:	f0 
f0102184:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010218b:	f0 
f010218c:	c7 44 24 04 75 04 00 	movl   $0x475,0x4(%esp)
f0102193:	00 
f0102194:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010219b:	e8 fd de ff ff       	call   f010009d <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01021a0:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01021a7:	00 
f01021a8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01021af:	00 
f01021b0:	89 74 24 04          	mov    %esi,0x4(%esp)
f01021b4:	89 04 24             	mov    %eax,(%esp)
f01021b7:	e8 dc f1 ff ff       	call   f0101398 <page_insert>
f01021bc:	85 c0                	test   %eax,%eax
f01021be:	74 24                	je     f01021e4 <mem_init+0xd62>
f01021c0:	c7 44 24 0c 38 85 10 	movl   $0xf0108538,0xc(%esp)
f01021c7:	f0 
f01021c8:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01021cf:	f0 
f01021d0:	c7 44 24 04 78 04 00 	movl   $0x478,0x4(%esp)
f01021d7:	00 
f01021d8:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01021df:	e8 b9 de ff ff       	call   f010009d <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01021e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01021eb:	00 
f01021ec:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01021f3:	00 
f01021f4:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f01021f9:	89 04 24             	mov    %eax,(%esp)
f01021fc:	e8 ac ef ff ff       	call   f01011ad <pgdir_walk>
f0102201:	f6 00 02             	testb  $0x2,(%eax)
f0102204:	75 24                	jne    f010222a <mem_init+0xda8>
f0102206:	c7 44 24 0c 58 86 10 	movl   $0xf0108658,0xc(%esp)
f010220d:	f0 
f010220e:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102215:	f0 
f0102216:	c7 44 24 04 79 04 00 	movl   $0x479,0x4(%esp)
f010221d:	00 
f010221e:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102225:	e8 73 de ff ff       	call   f010009d <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010222a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102231:	00 
f0102232:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102239:	00 
f010223a:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f010223f:	89 04 24             	mov    %eax,(%esp)
f0102242:	e8 66 ef ff ff       	call   f01011ad <pgdir_walk>
f0102247:	f6 00 04             	testb  $0x4,(%eax)
f010224a:	74 24                	je     f0102270 <mem_init+0xdee>
f010224c:	c7 44 24 0c 8c 86 10 	movl   $0xf010868c,0xc(%esp)
f0102253:	f0 
f0102254:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010225b:	f0 
f010225c:	c7 44 24 04 7a 04 00 	movl   $0x47a,0x4(%esp)
f0102263:	00 
f0102264:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010226b:	e8 2d de ff ff       	call   f010009d <_panic>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0102270:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102277:	00 
f0102278:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f010227f:	00 
f0102280:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102283:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102287:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f010228c:	89 04 24             	mov    %eax,(%esp)
f010228f:	e8 04 f1 ff ff       	call   f0101398 <page_insert>
f0102294:	85 c0                	test   %eax,%eax
f0102296:	78 24                	js     f01022bc <mem_init+0xe3a>
f0102298:	c7 44 24 0c c4 86 10 	movl   $0xf01086c4,0xc(%esp)
f010229f:	f0 
f01022a0:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01022a7:	f0 
f01022a8:	c7 44 24 04 7d 04 00 	movl   $0x47d,0x4(%esp)
f01022af:	00 
f01022b0:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01022b7:	e8 e1 dd ff ff       	call   f010009d <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01022bc:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01022c3:	00 
f01022c4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01022cb:	00 
f01022cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01022d0:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f01022d5:	89 04 24             	mov    %eax,(%esp)
f01022d8:	e8 bb f0 ff ff       	call   f0101398 <page_insert>
f01022dd:	85 c0                	test   %eax,%eax
f01022df:	74 24                	je     f0102305 <mem_init+0xe83>
f01022e1:	c7 44 24 0c fc 86 10 	movl   $0xf01086fc,0xc(%esp)
f01022e8:	f0 
f01022e9:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01022f0:	f0 
f01022f1:	c7 44 24 04 80 04 00 	movl   $0x480,0x4(%esp)
f01022f8:	00 
f01022f9:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102300:	e8 98 dd ff ff       	call   f010009d <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102305:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010230c:	00 
f010230d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102314:	00 
f0102315:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f010231a:	89 04 24             	mov    %eax,(%esp)
f010231d:	e8 8b ee ff ff       	call   f01011ad <pgdir_walk>
f0102322:	f6 00 04             	testb  $0x4,(%eax)
f0102325:	74 24                	je     f010234b <mem_init+0xec9>
f0102327:	c7 44 24 0c 8c 86 10 	movl   $0xf010868c,0xc(%esp)
f010232e:	f0 
f010232f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102336:	f0 
f0102337:	c7 44 24 04 81 04 00 	movl   $0x481,0x4(%esp)
f010233e:	00 
f010233f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102346:	e8 52 dd ff ff       	call   f010009d <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f010234b:	8b 3d cc 8e 2b f0    	mov    0xf02b8ecc,%edi
f0102351:	ba 00 00 00 00       	mov    $0x0,%edx
f0102356:	89 f8                	mov    %edi,%eax
f0102358:	e8 a9 e8 ff ff       	call   f0100c06 <check_va2pa>
f010235d:	89 c1                	mov    %eax,%ecx
f010235f:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102362:	89 d8                	mov    %ebx,%eax
f0102364:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f010236a:	c1 f8 03             	sar    $0x3,%eax
f010236d:	c1 e0 0c             	shl    $0xc,%eax
f0102370:	39 c1                	cmp    %eax,%ecx
f0102372:	74 24                	je     f0102398 <mem_init+0xf16>
f0102374:	c7 44 24 0c 38 87 10 	movl   $0xf0108738,0xc(%esp)
f010237b:	f0 
f010237c:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102383:	f0 
f0102384:	c7 44 24 04 84 04 00 	movl   $0x484,0x4(%esp)
f010238b:	00 
f010238c:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102393:	e8 05 dd ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102398:	ba 00 10 00 00       	mov    $0x1000,%edx
f010239d:	89 f8                	mov    %edi,%eax
f010239f:	e8 62 e8 ff ff       	call   f0100c06 <check_va2pa>
f01023a4:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01023a7:	74 24                	je     f01023cd <mem_init+0xf4b>
f01023a9:	c7 44 24 0c 64 87 10 	movl   $0xf0108764,0xc(%esp)
f01023b0:	f0 
f01023b1:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01023b8:	f0 
f01023b9:	c7 44 24 04 85 04 00 	movl   $0x485,0x4(%esp)
f01023c0:	00 
f01023c1:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01023c8:	e8 d0 dc ff ff       	call   f010009d <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01023cd:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f01023d2:	74 24                	je     f01023f8 <mem_init+0xf76>
f01023d4:	c7 44 24 0c d7 81 10 	movl   $0xf01081d7,0xc(%esp)
f01023db:	f0 
f01023dc:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01023e3:	f0 
f01023e4:	c7 44 24 04 87 04 00 	movl   $0x487,0x4(%esp)
f01023eb:	00 
f01023ec:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01023f3:	e8 a5 dc ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f01023f8:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01023fd:	74 24                	je     f0102423 <mem_init+0xfa1>
f01023ff:	c7 44 24 0c e8 81 10 	movl   $0xf01081e8,0xc(%esp)
f0102406:	f0 
f0102407:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010240e:	f0 
f010240f:	c7 44 24 04 88 04 00 	movl   $0x488,0x4(%esp)
f0102416:	00 
f0102417:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010241e:	e8 7a dc ff ff       	call   f010009d <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0102423:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010242a:	e8 b4 ec ff ff       	call   f01010e3 <page_alloc>
f010242f:	85 c0                	test   %eax,%eax
f0102431:	74 04                	je     f0102437 <mem_init+0xfb5>
f0102433:	39 c6                	cmp    %eax,%esi
f0102435:	74 24                	je     f010245b <mem_init+0xfd9>
f0102437:	c7 44 24 0c 94 87 10 	movl   $0xf0108794,0xc(%esp)
f010243e:	f0 
f010243f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102446:	f0 
f0102447:	c7 44 24 04 8b 04 00 	movl   $0x48b,0x4(%esp)
f010244e:	00 
f010244f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102456:	e8 42 dc ff ff       	call   f010009d <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f010245b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102462:	00 
f0102463:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102468:	89 04 24             	mov    %eax,(%esp)
f010246b:	e8 df ee ff ff       	call   f010134f <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102470:	8b 3d cc 8e 2b f0    	mov    0xf02b8ecc,%edi
f0102476:	ba 00 00 00 00       	mov    $0x0,%edx
f010247b:	89 f8                	mov    %edi,%eax
f010247d:	e8 84 e7 ff ff       	call   f0100c06 <check_va2pa>
f0102482:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102485:	74 24                	je     f01024ab <mem_init+0x1029>
f0102487:	c7 44 24 0c b8 87 10 	movl   $0xf01087b8,0xc(%esp)
f010248e:	f0 
f010248f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102496:	f0 
f0102497:	c7 44 24 04 8f 04 00 	movl   $0x48f,0x4(%esp)
f010249e:	00 
f010249f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01024a6:	e8 f2 db ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01024ab:	ba 00 10 00 00       	mov    $0x1000,%edx
f01024b0:	89 f8                	mov    %edi,%eax
f01024b2:	e8 4f e7 ff ff       	call   f0100c06 <check_va2pa>
f01024b7:	89 da                	mov    %ebx,%edx
f01024b9:	2b 15 d0 8e 2b f0    	sub    0xf02b8ed0,%edx
f01024bf:	c1 fa 03             	sar    $0x3,%edx
f01024c2:	c1 e2 0c             	shl    $0xc,%edx
f01024c5:	39 d0                	cmp    %edx,%eax
f01024c7:	74 24                	je     f01024ed <mem_init+0x106b>
f01024c9:	c7 44 24 0c 64 87 10 	movl   $0xf0108764,0xc(%esp)
f01024d0:	f0 
f01024d1:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01024d8:	f0 
f01024d9:	c7 44 24 04 90 04 00 	movl   $0x490,0x4(%esp)
f01024e0:	00 
f01024e1:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01024e8:	e8 b0 db ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 1);
f01024ed:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01024f2:	74 24                	je     f0102518 <mem_init+0x1096>
f01024f4:	c7 44 24 0c 8e 81 10 	movl   $0xf010818e,0xc(%esp)
f01024fb:	f0 
f01024fc:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102503:	f0 
f0102504:	c7 44 24 04 91 04 00 	movl   $0x491,0x4(%esp)
f010250b:	00 
f010250c:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102513:	e8 85 db ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f0102518:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f010251d:	74 24                	je     f0102543 <mem_init+0x10c1>
f010251f:	c7 44 24 0c e8 81 10 	movl   $0xf01081e8,0xc(%esp)
f0102526:	f0 
f0102527:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010252e:	f0 
f010252f:	c7 44 24 04 92 04 00 	movl   $0x492,0x4(%esp)
f0102536:	00 
f0102537:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010253e:	e8 5a db ff ff       	call   f010009d <_panic>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102543:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010254a:	00 
f010254b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102552:	00 
f0102553:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102557:	89 3c 24             	mov    %edi,(%esp)
f010255a:	e8 39 ee ff ff       	call   f0101398 <page_insert>
f010255f:	85 c0                	test   %eax,%eax
f0102561:	74 24                	je     f0102587 <mem_init+0x1105>
f0102563:	c7 44 24 0c dc 87 10 	movl   $0xf01087dc,0xc(%esp)
f010256a:	f0 
f010256b:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102572:	f0 
f0102573:	c7 44 24 04 95 04 00 	movl   $0x495,0x4(%esp)
f010257a:	00 
f010257b:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102582:	e8 16 db ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref);
f0102587:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010258c:	75 24                	jne    f01025b2 <mem_init+0x1130>
f010258e:	c7 44 24 0c f9 81 10 	movl   $0xf01081f9,0xc(%esp)
f0102595:	f0 
f0102596:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010259d:	f0 
f010259e:	c7 44 24 04 96 04 00 	movl   $0x496,0x4(%esp)
f01025a5:	00 
f01025a6:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01025ad:	e8 eb da ff ff       	call   f010009d <_panic>
	assert(pp1->pp_link == NULL);
f01025b2:	83 3b 00             	cmpl   $0x0,(%ebx)
f01025b5:	74 24                	je     f01025db <mem_init+0x1159>
f01025b7:	c7 44 24 0c 05 82 10 	movl   $0xf0108205,0xc(%esp)
f01025be:	f0 
f01025bf:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01025c6:	f0 
f01025c7:	c7 44 24 04 97 04 00 	movl   $0x497,0x4(%esp)
f01025ce:	00 
f01025cf:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01025d6:	e8 c2 da ff ff       	call   f010009d <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f01025db:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01025e2:	00 
f01025e3:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f01025e8:	89 04 24             	mov    %eax,(%esp)
f01025eb:	e8 5f ed ff ff       	call   f010134f <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01025f0:	8b 3d cc 8e 2b f0    	mov    0xf02b8ecc,%edi
f01025f6:	ba 00 00 00 00       	mov    $0x0,%edx
f01025fb:	89 f8                	mov    %edi,%eax
f01025fd:	e8 04 e6 ff ff       	call   f0100c06 <check_va2pa>
f0102602:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102605:	74 24                	je     f010262b <mem_init+0x11a9>
f0102607:	c7 44 24 0c b8 87 10 	movl   $0xf01087b8,0xc(%esp)
f010260e:	f0 
f010260f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102616:	f0 
f0102617:	c7 44 24 04 9b 04 00 	movl   $0x49b,0x4(%esp)
f010261e:	00 
f010261f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102626:	e8 72 da ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f010262b:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102630:	89 f8                	mov    %edi,%eax
f0102632:	e8 cf e5 ff ff       	call   f0100c06 <check_va2pa>
f0102637:	83 f8 ff             	cmp    $0xffffffff,%eax
f010263a:	74 24                	je     f0102660 <mem_init+0x11de>
f010263c:	c7 44 24 0c 14 88 10 	movl   $0xf0108814,0xc(%esp)
f0102643:	f0 
f0102644:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010264b:	f0 
f010264c:	c7 44 24 04 9c 04 00 	movl   $0x49c,0x4(%esp)
f0102653:	00 
f0102654:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010265b:	e8 3d da ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 0);
f0102660:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102665:	74 24                	je     f010268b <mem_init+0x1209>
f0102667:	c7 44 24 0c 1a 82 10 	movl   $0xf010821a,0xc(%esp)
f010266e:	f0 
f010266f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102676:	f0 
f0102677:	c7 44 24 04 9d 04 00 	movl   $0x49d,0x4(%esp)
f010267e:	00 
f010267f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102686:	e8 12 da ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 0);
f010268b:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102690:	74 24                	je     f01026b6 <mem_init+0x1234>
f0102692:	c7 44 24 0c e8 81 10 	movl   $0xf01081e8,0xc(%esp)
f0102699:	f0 
f010269a:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01026a1:	f0 
f01026a2:	c7 44 24 04 9e 04 00 	movl   $0x49e,0x4(%esp)
f01026a9:	00 
f01026aa:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01026b1:	e8 e7 d9 ff ff       	call   f010009d <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f01026b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01026bd:	e8 21 ea ff ff       	call   f01010e3 <page_alloc>
f01026c2:	85 c0                	test   %eax,%eax
f01026c4:	74 04                	je     f01026ca <mem_init+0x1248>
f01026c6:	39 c3                	cmp    %eax,%ebx
f01026c8:	74 24                	je     f01026ee <mem_init+0x126c>
f01026ca:	c7 44 24 0c 3c 88 10 	movl   $0xf010883c,0xc(%esp)
f01026d1:	f0 
f01026d2:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01026d9:	f0 
f01026da:	c7 44 24 04 a1 04 00 	movl   $0x4a1,0x4(%esp)
f01026e1:	00 
f01026e2:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01026e9:	e8 af d9 ff ff       	call   f010009d <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f01026ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01026f5:	e8 e9 e9 ff ff       	call   f01010e3 <page_alloc>
f01026fa:	85 c0                	test   %eax,%eax
f01026fc:	74 24                	je     f0102722 <mem_init+0x12a0>
f01026fe:	c7 44 24 0c 3c 81 10 	movl   $0xf010813c,0xc(%esp)
f0102705:	f0 
f0102706:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010270d:	f0 
f010270e:	c7 44 24 04 a4 04 00 	movl   $0x4a4,0x4(%esp)
f0102715:	00 
f0102716:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010271d:	e8 7b d9 ff ff       	call   f010009d <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102722:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102727:	8b 08                	mov    (%eax),%ecx
f0102729:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010272f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102732:	2b 15 d0 8e 2b f0    	sub    0xf02b8ed0,%edx
f0102738:	c1 fa 03             	sar    $0x3,%edx
f010273b:	c1 e2 0c             	shl    $0xc,%edx
f010273e:	39 d1                	cmp    %edx,%ecx
f0102740:	74 24                	je     f0102766 <mem_init+0x12e4>
f0102742:	c7 44 24 0c e0 84 10 	movl   $0xf01084e0,0xc(%esp)
f0102749:	f0 
f010274a:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102751:	f0 
f0102752:	c7 44 24 04 a7 04 00 	movl   $0x4a7,0x4(%esp)
f0102759:	00 
f010275a:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102761:	e8 37 d9 ff ff       	call   f010009d <_panic>
	kern_pgdir[0] = 0;
f0102766:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f010276c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010276f:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102774:	74 24                	je     f010279a <mem_init+0x1318>
f0102776:	c7 44 24 0c 9f 81 10 	movl   $0xf010819f,0xc(%esp)
f010277d:	f0 
f010277e:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102785:	f0 
f0102786:	c7 44 24 04 a9 04 00 	movl   $0x4a9,0x4(%esp)
f010278d:	00 
f010278e:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102795:	e8 03 d9 ff ff       	call   f010009d <_panic>
	pp0->pp_ref = 0;
f010279a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010279d:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f01027a3:	89 04 24             	mov    %eax,(%esp)
f01027a6:	e8 c3 e9 ff ff       	call   f010116e <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f01027ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01027b2:	00 
f01027b3:	c7 44 24 04 00 10 40 	movl   $0x401000,0x4(%esp)
f01027ba:	00 
f01027bb:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f01027c0:	89 04 24             	mov    %eax,(%esp)
f01027c3:	e8 e5 e9 ff ff       	call   f01011ad <pgdir_walk>
f01027c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01027cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01027ce:	8b 15 cc 8e 2b f0    	mov    0xf02b8ecc,%edx
f01027d4:	8b 7a 04             	mov    0x4(%edx),%edi
f01027d7:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01027dd:	8b 0d c8 8e 2b f0    	mov    0xf02b8ec8,%ecx
f01027e3:	89 f8                	mov    %edi,%eax
f01027e5:	c1 e8 0c             	shr    $0xc,%eax
f01027e8:	39 c8                	cmp    %ecx,%eax
f01027ea:	72 20                	jb     f010280c <mem_init+0x138a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01027ec:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01027f0:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f01027f7:	f0 
f01027f8:	c7 44 24 04 b0 04 00 	movl   $0x4b0,0x4(%esp)
f01027ff:	00 
f0102800:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102807:	e8 91 d8 ff ff       	call   f010009d <_panic>
	assert(ptep == ptep1 + PTX(va));
f010280c:	81 ef fc ff ff 0f    	sub    $0xffffffc,%edi
f0102812:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0102815:	74 24                	je     f010283b <mem_init+0x13b9>
f0102817:	c7 44 24 0c 2b 82 10 	movl   $0xf010822b,0xc(%esp)
f010281e:	f0 
f010281f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102826:	f0 
f0102827:	c7 44 24 04 b1 04 00 	movl   $0x4b1,0x4(%esp)
f010282e:	00 
f010282f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102836:	e8 62 d8 ff ff       	call   f010009d <_panic>
	kern_pgdir[PDX(va)] = 0;
f010283b:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
	pp0->pp_ref = 0;
f0102842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102845:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010284b:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f0102851:	c1 f8 03             	sar    $0x3,%eax
f0102854:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102857:	89 c2                	mov    %eax,%edx
f0102859:	c1 ea 0c             	shr    $0xc,%edx
f010285c:	39 d1                	cmp    %edx,%ecx
f010285e:	77 20                	ja     f0102880 <mem_init+0x13fe>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102860:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102864:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f010286b:	f0 
f010286c:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f0102873:	00 
f0102874:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f010287b:	e8 1d d8 ff ff       	call   f010009d <_panic>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102880:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102887:	00 
f0102888:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f010288f:	00 
	return (void *)(pa + KERNBASE);
f0102890:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102895:	89 04 24             	mov    %eax,(%esp)
f0102898:	e8 9a 38 00 00       	call   f0106137 <memset>
	page_free(pp0);
f010289d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01028a0:	89 3c 24             	mov    %edi,(%esp)
f01028a3:	e8 c6 e8 ff ff       	call   f010116e <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01028a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01028af:	00 
f01028b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01028b7:	00 
f01028b8:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f01028bd:	89 04 24             	mov    %eax,(%esp)
f01028c0:	e8 e8 e8 ff ff       	call   f01011ad <pgdir_walk>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01028c5:	89 fa                	mov    %edi,%edx
f01028c7:	2b 15 d0 8e 2b f0    	sub    0xf02b8ed0,%edx
f01028cd:	c1 fa 03             	sar    $0x3,%edx
f01028d0:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01028d3:	89 d0                	mov    %edx,%eax
f01028d5:	c1 e8 0c             	shr    $0xc,%eax
f01028d8:	3b 05 c8 8e 2b f0    	cmp    0xf02b8ec8,%eax
f01028de:	72 20                	jb     f0102900 <mem_init+0x147e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01028e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01028e4:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f01028eb:	f0 
f01028ec:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f01028f3:	00 
f01028f4:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f01028fb:	e8 9d d7 ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0102900:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102906:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102909:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f010290f:	f6 00 01             	testb  $0x1,(%eax)
f0102912:	74 24                	je     f0102938 <mem_init+0x14b6>
f0102914:	c7 44 24 0c 43 82 10 	movl   $0xf0108243,0xc(%esp)
f010291b:	f0 
f010291c:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102923:	f0 
f0102924:	c7 44 24 04 bb 04 00 	movl   $0x4bb,0x4(%esp)
f010292b:	00 
f010292c:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102933:	e8 65 d7 ff ff       	call   f010009d <_panic>
f0102938:	83 c0 04             	add    $0x4,%eax
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f010293b:	39 d0                	cmp    %edx,%eax
f010293d:	75 d0                	jne    f010290f <mem_init+0x148d>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f010293f:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102944:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f010294a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010294d:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102953:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102956:	89 0d 40 82 2b f0    	mov    %ecx,0xf02b8240

	// free the pages we took
	page_free(pp0);
f010295c:	89 04 24             	mov    %eax,(%esp)
f010295f:	e8 0a e8 ff ff       	call   f010116e <page_free>
	page_free(pp1);
f0102964:	89 1c 24             	mov    %ebx,(%esp)
f0102967:	e8 02 e8 ff ff       	call   f010116e <page_free>
	page_free(pp2);
f010296c:	89 34 24             	mov    %esi,(%esp)
f010296f:	e8 fa e7 ff ff       	call   f010116e <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102974:	c7 44 24 04 01 10 00 	movl   $0x1001,0x4(%esp)
f010297b:	00 
f010297c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102983:	e8 8b ea ff ff       	call   f0101413 <mmio_map_region>
f0102988:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f010298a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102991:	00 
f0102992:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102999:	e8 75 ea ff ff       	call   f0101413 <mmio_map_region>
f010299e:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f01029a0:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f01029a6:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f01029ab:	77 08                	ja     f01029b5 <mem_init+0x1533>
f01029ad:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f01029b3:	77 24                	ja     f01029d9 <mem_init+0x1557>
f01029b5:	c7 44 24 0c 60 88 10 	movl   $0xf0108860,0xc(%esp)
f01029bc:	f0 
f01029bd:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01029c4:	f0 
f01029c5:	c7 44 24 04 cb 04 00 	movl   $0x4cb,0x4(%esp)
f01029cc:	00 
f01029cd:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01029d4:	e8 c4 d6 ff ff       	call   f010009d <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f01029d9:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f01029df:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f01029e5:	77 08                	ja     f01029ef <mem_init+0x156d>
f01029e7:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f01029ed:	77 24                	ja     f0102a13 <mem_init+0x1591>
f01029ef:	c7 44 24 0c 88 88 10 	movl   $0xf0108888,0xc(%esp)
f01029f6:	f0 
f01029f7:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01029fe:	f0 
f01029ff:	c7 44 24 04 cc 04 00 	movl   $0x4cc,0x4(%esp)
f0102a06:	00 
f0102a07:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102a0e:	e8 8a d6 ff ff       	call   f010009d <_panic>
f0102a13:	89 da                	mov    %ebx,%edx
f0102a15:	09 f2                	or     %esi,%edx
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102a17:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102a1d:	74 24                	je     f0102a43 <mem_init+0x15c1>
f0102a1f:	c7 44 24 0c b0 88 10 	movl   $0xf01088b0,0xc(%esp)
f0102a26:	f0 
f0102a27:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102a2e:	f0 
f0102a2f:	c7 44 24 04 ce 04 00 	movl   $0x4ce,0x4(%esp)
f0102a36:	00 
f0102a37:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102a3e:	e8 5a d6 ff ff       	call   f010009d <_panic>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f0102a43:	39 c6                	cmp    %eax,%esi
f0102a45:	73 24                	jae    f0102a6b <mem_init+0x15e9>
f0102a47:	c7 44 24 0c 5a 82 10 	movl   $0xf010825a,0xc(%esp)
f0102a4e:	f0 
f0102a4f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102a56:	f0 
f0102a57:	c7 44 24 04 d0 04 00 	movl   $0x4d0,0x4(%esp)
f0102a5e:	00 
f0102a5f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102a66:	e8 32 d6 ff ff       	call   f010009d <_panic>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102a6b:	8b 3d cc 8e 2b f0    	mov    0xf02b8ecc,%edi
f0102a71:	89 da                	mov    %ebx,%edx
f0102a73:	89 f8                	mov    %edi,%eax
f0102a75:	e8 8c e1 ff ff       	call   f0100c06 <check_va2pa>
f0102a7a:	85 c0                	test   %eax,%eax
f0102a7c:	74 24                	je     f0102aa2 <mem_init+0x1620>
f0102a7e:	c7 44 24 0c d8 88 10 	movl   $0xf01088d8,0xc(%esp)
f0102a85:	f0 
f0102a86:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102a8d:	f0 
f0102a8e:	c7 44 24 04 d2 04 00 	movl   $0x4d2,0x4(%esp)
f0102a95:	00 
f0102a96:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102a9d:	e8 fb d5 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102aa2:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102aa8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102aab:	89 c2                	mov    %eax,%edx
f0102aad:	89 f8                	mov    %edi,%eax
f0102aaf:	e8 52 e1 ff ff       	call   f0100c06 <check_va2pa>
f0102ab4:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102ab9:	74 24                	je     f0102adf <mem_init+0x165d>
f0102abb:	c7 44 24 0c fc 88 10 	movl   $0xf01088fc,0xc(%esp)
f0102ac2:	f0 
f0102ac3:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102aca:	f0 
f0102acb:	c7 44 24 04 d3 04 00 	movl   $0x4d3,0x4(%esp)
f0102ad2:	00 
f0102ad3:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102ada:	e8 be d5 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102adf:	89 f2                	mov    %esi,%edx
f0102ae1:	89 f8                	mov    %edi,%eax
f0102ae3:	e8 1e e1 ff ff       	call   f0100c06 <check_va2pa>
f0102ae8:	85 c0                	test   %eax,%eax
f0102aea:	74 24                	je     f0102b10 <mem_init+0x168e>
f0102aec:	c7 44 24 0c 2c 89 10 	movl   $0xf010892c,0xc(%esp)
f0102af3:	f0 
f0102af4:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102afb:	f0 
f0102afc:	c7 44 24 04 d4 04 00 	movl   $0x4d4,0x4(%esp)
f0102b03:	00 
f0102b04:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102b0b:	e8 8d d5 ff ff       	call   f010009d <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102b10:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102b16:	89 f8                	mov    %edi,%eax
f0102b18:	e8 e9 e0 ff ff       	call   f0100c06 <check_va2pa>
f0102b1d:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102b20:	74 24                	je     f0102b46 <mem_init+0x16c4>
f0102b22:	c7 44 24 0c 50 89 10 	movl   $0xf0108950,0xc(%esp)
f0102b29:	f0 
f0102b2a:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102b31:	f0 
f0102b32:	c7 44 24 04 d5 04 00 	movl   $0x4d5,0x4(%esp)
f0102b39:	00 
f0102b3a:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102b41:	e8 57 d5 ff ff       	call   f010009d <_panic>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102b46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102b4d:	00 
f0102b4e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102b52:	89 3c 24             	mov    %edi,(%esp)
f0102b55:	e8 53 e6 ff ff       	call   f01011ad <pgdir_walk>
f0102b5a:	f6 00 1a             	testb  $0x1a,(%eax)
f0102b5d:	75 24                	jne    f0102b83 <mem_init+0x1701>
f0102b5f:	c7 44 24 0c 7c 89 10 	movl   $0xf010897c,0xc(%esp)
f0102b66:	f0 
f0102b67:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102b6e:	f0 
f0102b6f:	c7 44 24 04 d7 04 00 	movl   $0x4d7,0x4(%esp)
f0102b76:	00 
f0102b77:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102b7e:	e8 1a d5 ff ff       	call   f010009d <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102b83:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102b8a:	00 
f0102b8b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102b8f:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102b94:	89 04 24             	mov    %eax,(%esp)
f0102b97:	e8 11 e6 ff ff       	call   f01011ad <pgdir_walk>
f0102b9c:	f6 00 04             	testb  $0x4,(%eax)
f0102b9f:	74 24                	je     f0102bc5 <mem_init+0x1743>
f0102ba1:	c7 44 24 0c c0 89 10 	movl   $0xf01089c0,0xc(%esp)
f0102ba8:	f0 
f0102ba9:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102bb0:	f0 
f0102bb1:	c7 44 24 04 d8 04 00 	movl   $0x4d8,0x4(%esp)
f0102bb8:	00 
f0102bb9:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102bc0:	e8 d8 d4 ff ff       	call   f010009d <_panic>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102bc5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102bcc:	00 
f0102bcd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102bd1:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102bd6:	89 04 24             	mov    %eax,(%esp)
f0102bd9:	e8 cf e5 ff ff       	call   f01011ad <pgdir_walk>
f0102bde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102be4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102beb:	00 
f0102bec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102bef:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102bf3:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102bf8:	89 04 24             	mov    %eax,(%esp)
f0102bfb:	e8 ad e5 ff ff       	call   f01011ad <pgdir_walk>
f0102c00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0102c06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102c0d:	00 
f0102c0e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102c12:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102c17:	89 04 24             	mov    %eax,(%esp)
f0102c1a:	e8 8e e5 ff ff       	call   f01011ad <pgdir_walk>
f0102c1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f0102c25:	c7 04 24 6c 82 10 f0 	movl   $0xf010826c,(%esp)
f0102c2c:	e8 94 13 00 00       	call   f0103fc5 <cprintf>
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.

	//////////////////////////////////////////////////////////////////////

	boot_map_region(kern_pgdir,UENVS,PTSIZE,PADDR(envs),PTE_U | PTE_P);
f0102c31:	a1 48 82 2b f0       	mov    0xf02b8248,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102c36:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102c3b:	77 20                	ja     f0102c5d <mem_init+0x17db>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102c3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102c41:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0102c48:	f0 
f0102c49:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
f0102c50:	00 
f0102c51:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102c58:	e8 40 d4 ff ff       	call   f010009d <_panic>
f0102c5d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f0102c64:	00 
	return (physaddr_t)kva - KERNBASE;
f0102c65:	05 00 00 00 10       	add    $0x10000000,%eax
f0102c6a:	89 04 24             	mov    %eax,(%esp)
f0102c6d:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102c72:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102c77:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102c7c:	e8 cc e5 ff ff       	call   f010124d <boot_map_region>
	//////////////////////////////////////////////////////////////////////

	
	boot_map_region(kern_pgdir,UPAGES,PTSIZE,PADDR(pages),PTE_U| PTE_P);
f0102c81:	a1 d0 8e 2b f0       	mov    0xf02b8ed0,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102c86:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102c8b:	77 20                	ja     f0102cad <mem_init+0x182b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102c8d:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102c91:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0102c98:	f0 
f0102c99:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
f0102ca0:	00 
f0102ca1:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102ca8:	e8 f0 d3 ff ff       	call   f010009d <_panic>
f0102cad:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f0102cb4:	00 
	return (physaddr_t)kva - KERNBASE;
f0102cb5:	05 00 00 00 10       	add    $0x10000000,%eax
f0102cba:	89 04 24             	mov    %eax,(%esp)
f0102cbd:	b9 00 00 40 00       	mov    $0x400000,%ecx
f0102cc2:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102cc7:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102ccc:	e8 7c e5 ff ff       	call   f010124d <boot_map_region>
f0102cd1:	bf 00 a0 35 f0       	mov    $0xf035a000,%edi
f0102cd6:	bb 00 a0 31 f0       	mov    $0xf031a000,%ebx
f0102cdb:	be 00 80 ff ef       	mov    $0xefff8000,%esi
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102ce0:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102ce6:	77 20                	ja     f0102d08 <mem_init+0x1886>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ce8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0102cec:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0102cf3:	f0 
f0102cf4:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
f0102cfb:	00 
f0102cfc:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102d03:	e8 95 d3 ff ff       	call   f010009d <_panic>
	// LAB 4: Your code here:
	int i;
	int stack_dec = KSTKSIZE;
	for(i=0;i<NCPU;i++)
	{
		boot_map_region(kern_pgdir,KSTACKTOP-KSTKSIZE-i*(KSTKSIZE+KSTKGAP),KSTKSIZE,PADDR(percpu_kstacks[i]),PTE_W|PTE_P);
f0102d08:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0102d0f:	00 
f0102d10:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0102d16:	89 04 24             	mov    %eax,(%esp)
f0102d19:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102d1e:	89 f2                	mov    %esi,%edx
f0102d20:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102d25:	e8 23 e5 ff ff       	call   f010124d <boot_map_region>
f0102d2a:	81 c3 00 80 00 00    	add    $0x8000,%ebx
f0102d30:	81 ee 00 00 01 00    	sub    $0x10000,%esi
	//     Permissions: kernel RW, user NONE
	//
	// LAB 4: Your code here:
	int i;
	int stack_dec = KSTKSIZE;
	for(i=0;i<NCPU;i++)
f0102d36:	39 fb                	cmp    %edi,%ebx
f0102d38:	75 a6                	jne    f0102ce0 <mem_init+0x185e>


	// Initialize the SMP-related parts of the memory map
	mem_init_mp();

	boot_map_region(kern_pgdir,KERNBASE,0xffffffff- KERNBASE+1,0x00000000,PTE_W | PTE_P);
f0102d3a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0102d41:	00 
f0102d42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102d49:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102d4e:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102d53:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0102d58:	e8 f0 e4 ff ff       	call   f010124d <boot_map_region>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f0102d5d:	8b 3d cc 8e 2b f0    	mov    0xf02b8ecc,%edi

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0102d63:	a1 c8 8e 2b f0       	mov    0xf02b8ec8,%eax
f0102d68:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102d6b:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f0102d72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0102d77:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102d7a:	a1 d0 8e 2b f0       	mov    0xf02b8ed0,%eax
f0102d7f:	89 45 c8             	mov    %eax,-0x38(%ebp)
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102d82:	89 45 d0             	mov    %eax,-0x30(%ebp)
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
	return (physaddr_t)kva - KERNBASE;
f0102d85:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0102d8b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102d90:	eb 6a                	jmp    f0102dfc <mem_init+0x197a>
f0102d92:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102d98:	89 f8                	mov    %edi,%eax
f0102d9a:	e8 67 de ff ff       	call   f0100c06 <check_va2pa>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102d9f:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102da6:	77 23                	ja     f0102dcb <mem_init+0x1949>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102da8:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0102dab:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102daf:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0102db6:	f0 
f0102db7:	c7 44 24 04 eb 03 00 	movl   $0x3eb,0x4(%esp)
f0102dbe:	00 
f0102dbf:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102dc6:	e8 d2 d2 ff ff       	call   f010009d <_panic>
f0102dcb:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f0102dce:	39 d0                	cmp    %edx,%eax
f0102dd0:	74 24                	je     f0102df6 <mem_init+0x1974>
f0102dd2:	c7 44 24 0c f4 89 10 	movl   $0xf01089f4,0xc(%esp)
f0102dd9:	f0 
f0102dda:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102de1:	f0 
f0102de2:	c7 44 24 04 eb 03 00 	movl   $0x3eb,0x4(%esp)
f0102de9:	00 
f0102dea:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102df1:	e8 a7 d2 ff ff       	call   f010009d <_panic>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0102df6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102dfc:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0102dff:	77 91                	ja     f0102d92 <mem_init+0x1910>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102e01:	8b 1d 48 82 2b f0    	mov    0xf02b8248,%ebx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102e07:	89 de                	mov    %ebx,%esi
f0102e09:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102e0e:	89 f8                	mov    %edi,%eax
f0102e10:	e8 f1 dd ff ff       	call   f0100c06 <check_va2pa>
f0102e15:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0102e1b:	77 20                	ja     f0102e3d <mem_init+0x19bb>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e1d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0102e21:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0102e28:	f0 
f0102e29:	c7 44 24 04 f0 03 00 	movl   $0x3f0,0x4(%esp)
f0102e30:	00 
f0102e31:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102e38:	e8 60 d2 ff ff       	call   f010009d <_panic>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102e3d:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102e42:	81 c6 00 00 40 21    	add    $0x21400000,%esi
f0102e48:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102e4b:	39 d0                	cmp    %edx,%eax
f0102e4d:	74 24                	je     f0102e73 <mem_init+0x19f1>
f0102e4f:	c7 44 24 0c 28 8a 10 	movl   $0xf0108a28,0xc(%esp)
f0102e56:	f0 
f0102e57:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102e5e:	f0 
f0102e5f:	c7 44 24 04 f0 03 00 	movl   $0x3f0,0x4(%esp)
f0102e66:	00 
f0102e67:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102e6e:	e8 2a d2 ff ff       	call   f010009d <_panic>
f0102e73:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0102e79:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102e7f:	0f 85 54 06 00 00    	jne    f01034d9 <mem_init+0x2057>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102e85:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0102e88:	c1 e6 0c             	shl    $0xc,%esi
f0102e8b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102e90:	eb 3b                	jmp    f0102ecd <mem_init+0x1a4b>
f0102e92:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102e98:	89 f8                	mov    %edi,%eax
f0102e9a:	e8 67 dd ff ff       	call   f0100c06 <check_va2pa>
f0102e9f:	39 c3                	cmp    %eax,%ebx
f0102ea1:	74 24                	je     f0102ec7 <mem_init+0x1a45>
f0102ea3:	c7 44 24 0c 5c 8a 10 	movl   $0xf0108a5c,0xc(%esp)
f0102eaa:	f0 
f0102eab:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102eb2:	f0 
f0102eb3:	c7 44 24 04 f4 03 00 	movl   $0x3f4,0x4(%esp)
f0102eba:	00 
f0102ebb:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102ec2:	e8 d6 d1 ff ff       	call   f010009d <_panic>
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102ec7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102ecd:	39 f3                	cmp    %esi,%ebx
f0102ecf:	72 c1                	jb     f0102e92 <mem_init+0x1a10>
f0102ed1:	c7 45 cc 00 a0 31 f0 	movl   $0xf031a000,-0x34(%ebp)
f0102ed8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
f0102edf:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f0102ee4:	b8 00 a0 31 f0       	mov    $0xf031a000,%eax
f0102ee9:	05 00 80 00 20       	add    $0x20008000,%eax
f0102eee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0102ef1:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0102ef7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102efa:	89 f2                	mov    %esi,%edx
f0102efc:	89 f8                	mov    %edi,%eax
f0102efe:	e8 03 dd ff ff       	call   f0100c06 <check_va2pa>
f0102f03:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0102f06:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0102f0c:	77 20                	ja     f0102f2e <mem_init+0x1aac>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102f0e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0102f12:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0102f19:	f0 
f0102f1a:	c7 44 24 04 fc 03 00 	movl   $0x3fc,0x4(%esp)
f0102f21:	00 
f0102f22:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102f29:	e8 6f d1 ff ff       	call   f010009d <_panic>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0102f2e:	89 f3                	mov    %esi,%ebx
f0102f30:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0102f33:	03 4d d0             	add    -0x30(%ebp),%ecx
f0102f36:	89 75 c8             	mov    %esi,-0x38(%ebp)
f0102f39:	89 ce                	mov    %ecx,%esi
f0102f3b:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102f3e:	39 c2                	cmp    %eax,%edx
f0102f40:	74 24                	je     f0102f66 <mem_init+0x1ae4>
f0102f42:	c7 44 24 0c 84 8a 10 	movl   $0xf0108a84,0xc(%esp)
f0102f49:	f0 
f0102f4a:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102f51:	f0 
f0102f52:	c7 44 24 04 fc 03 00 	movl   $0x3fc,0x4(%esp)
f0102f59:	00 
f0102f5a:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102f61:	e8 37 d1 ff ff       	call   f010009d <_panic>
f0102f66:	81 c3 00 10 00 00    	add    $0x1000,%ebx

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102f6c:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0102f6f:	0f 85 56 05 00 00    	jne    f01034cb <mem_init+0x2049>
f0102f75:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0102f78:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102f7e:	89 da                	mov    %ebx,%edx
f0102f80:	89 f8                	mov    %edi,%eax
f0102f82:	e8 7f dc ff ff       	call   f0100c06 <check_va2pa>
f0102f87:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102f8a:	74 24                	je     f0102fb0 <mem_init+0x1b2e>
f0102f8c:	c7 44 24 0c cc 8a 10 	movl   $0xf0108acc,0xc(%esp)
f0102f93:	f0 
f0102f94:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0102f9b:	f0 
f0102f9c:	c7 44 24 04 fe 03 00 	movl   $0x3fe,0x4(%esp)
f0102fa3:	00 
f0102fa4:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0102fab:	e8 ed d0 ff ff       	call   f010009d <_panic>
f0102fb0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102fb6:	39 f3                	cmp    %esi,%ebx
f0102fb8:	75 c4                	jne    f0102f7e <mem_init+0x1afc>
f0102fba:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0102fc0:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f0102fc7:	81 45 cc 00 80 00 00 	addl   $0x8000,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
f0102fce:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f0102fd4:	0f 85 17 ff ff ff    	jne    f0102ef1 <mem_init+0x1a6f>
f0102fda:	b8 00 00 00 00       	mov    $0x0,%eax
f0102fdf:	e9 c2 00 00 00       	jmp    f01030a6 <mem_init+0x1c24>
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
	}
	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f0102fe4:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0102fea:	83 fa 04             	cmp    $0x4,%edx
f0102fed:	77 2e                	ja     f010301d <mem_init+0x1b9b>
		case PDX(UENVS):
		case PDX(MMIOBASE):



			assert(pgdir[i] & PTE_P);
f0102fef:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0102ff3:	0f 85 aa 00 00 00    	jne    f01030a3 <mem_init+0x1c21>
f0102ff9:	c7 44 24 0c 85 82 10 	movl   $0xf0108285,0xc(%esp)
f0103000:	f0 
f0103001:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0103008:	f0 
f0103009:	c7 44 24 04 0b 04 00 	movl   $0x40b,0x4(%esp)
f0103010:	00 
f0103011:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0103018:	e8 80 d0 ff ff       	call   f010009d <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f010301d:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0103022:	76 55                	jbe    f0103079 <mem_init+0x1bf7>
				assert(pgdir[i] & PTE_P);
f0103024:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0103027:	f6 c2 01             	test   $0x1,%dl
f010302a:	75 24                	jne    f0103050 <mem_init+0x1bce>
f010302c:	c7 44 24 0c 85 82 10 	movl   $0xf0108285,0xc(%esp)
f0103033:	f0 
f0103034:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010303b:	f0 
f010303c:	c7 44 24 04 0f 04 00 	movl   $0x40f,0x4(%esp)
f0103043:	00 
f0103044:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010304b:	e8 4d d0 ff ff       	call   f010009d <_panic>
				assert(pgdir[i] & PTE_W);
f0103050:	f6 c2 02             	test   $0x2,%dl
f0103053:	75 4e                	jne    f01030a3 <mem_init+0x1c21>
f0103055:	c7 44 24 0c 96 82 10 	movl   $0xf0108296,0xc(%esp)
f010305c:	f0 
f010305d:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0103064:	f0 
f0103065:	c7 44 24 04 10 04 00 	movl   $0x410,0x4(%esp)
f010306c:	00 
f010306d:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0103074:	e8 24 d0 ff ff       	call   f010009d <_panic>
			} else
				assert(pgdir[i] == 0);
f0103079:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f010307d:	74 24                	je     f01030a3 <mem_init+0x1c21>
f010307f:	c7 44 24 0c a7 82 10 	movl   $0xf01082a7,0xc(%esp)
f0103086:	f0 
f0103087:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010308e:	f0 
f010308f:	c7 44 24 04 12 04 00 	movl   $0x412,0x4(%esp)
f0103096:	00 
f0103097:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010309e:	e8 fa cf ff ff       	call   f010009d <_panic>
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
	}
	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f01030a3:	83 c0 01             	add    $0x1,%eax
f01030a6:	3d 00 04 00 00       	cmp    $0x400,%eax
f01030ab:	0f 85 33 ff ff ff    	jne    f0102fe4 <mem_init+0x1b62>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	cprintf("check_kern_pgdir() succeeded!\n");
f01030b1:	c7 04 24 f0 8a 10 f0 	movl   $0xf0108af0,(%esp)
f01030b8:	e8 08 0f 00 00       	call   f0103fc5 <cprintf>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f01030bd:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f01030c2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01030c7:	77 20                	ja     f01030e9 <mem_init+0x1c67>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01030c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01030cd:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f01030d4:	f0 
f01030d5:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
f01030dc:	00 
f01030dd:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01030e4:	e8 b4 cf ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f01030e9:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f01030ee:	0f 22 d8             	mov    %eax,%cr3

	check_page_free_list(0);
f01030f1:	b8 00 00 00 00       	mov    $0x0,%eax
f01030f6:	e8 7a db ff ff       	call   f0100c75 <check_page_free_list>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f01030fb:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
	cr0 &= ~(CR0_TS|CR0_EM);
f01030fe:	83 e0 f3             	and    $0xfffffff3,%eax
f0103101:	0d 23 00 05 80       	or     $0x80050023,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0103106:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103109:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103110:	e8 ce df ff ff       	call   f01010e3 <page_alloc>
f0103115:	89 c3                	mov    %eax,%ebx
f0103117:	85 c0                	test   %eax,%eax
f0103119:	75 24                	jne    f010313f <mem_init+0x1cbd>
f010311b:	c7 44 24 0c 91 80 10 	movl   $0xf0108091,0xc(%esp)
f0103122:	f0 
f0103123:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010312a:	f0 
f010312b:	c7 44 24 04 ed 04 00 	movl   $0x4ed,0x4(%esp)
f0103132:	00 
f0103133:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010313a:	e8 5e cf ff ff       	call   f010009d <_panic>
	assert((pp1 = page_alloc(0)));
f010313f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103146:	e8 98 df ff ff       	call   f01010e3 <page_alloc>
f010314b:	89 c7                	mov    %eax,%edi
f010314d:	85 c0                	test   %eax,%eax
f010314f:	75 24                	jne    f0103175 <mem_init+0x1cf3>
f0103151:	c7 44 24 0c a7 80 10 	movl   $0xf01080a7,0xc(%esp)
f0103158:	f0 
f0103159:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0103160:	f0 
f0103161:	c7 44 24 04 ee 04 00 	movl   $0x4ee,0x4(%esp)
f0103168:	00 
f0103169:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0103170:	e8 28 cf ff ff       	call   f010009d <_panic>
	assert((pp2 = page_alloc(0)));
f0103175:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010317c:	e8 62 df ff ff       	call   f01010e3 <page_alloc>
f0103181:	89 c6                	mov    %eax,%esi
f0103183:	85 c0                	test   %eax,%eax
f0103185:	75 24                	jne    f01031ab <mem_init+0x1d29>
f0103187:	c7 44 24 0c bd 80 10 	movl   $0xf01080bd,0xc(%esp)
f010318e:	f0 
f010318f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0103196:	f0 
f0103197:	c7 44 24 04 ef 04 00 	movl   $0x4ef,0x4(%esp)
f010319e:	00 
f010319f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01031a6:	e8 f2 ce ff ff       	call   f010009d <_panic>
	page_free(pp0);
f01031ab:	89 1c 24             	mov    %ebx,(%esp)
f01031ae:	e8 bb df ff ff       	call   f010116e <page_free>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01031b3:	89 f8                	mov    %edi,%eax
f01031b5:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f01031bb:	c1 f8 03             	sar    $0x3,%eax
f01031be:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01031c1:	89 c2                	mov    %eax,%edx
f01031c3:	c1 ea 0c             	shr    $0xc,%edx
f01031c6:	3b 15 c8 8e 2b f0    	cmp    0xf02b8ec8,%edx
f01031cc:	72 20                	jb     f01031ee <mem_init+0x1d6c>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01031ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01031d2:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f01031d9:	f0 
f01031da:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f01031e1:	00 
f01031e2:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f01031e9:	e8 af ce ff ff       	call   f010009d <_panic>
	memset(page2kva(pp1), 1, PGSIZE);
f01031ee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01031f5:	00 
f01031f6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f01031fd:	00 
	return (void *)(pa + KERNBASE);
f01031fe:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103203:	89 04 24             	mov    %eax,(%esp)
f0103206:	e8 2c 2f 00 00       	call   f0106137 <memset>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010320b:	89 f0                	mov    %esi,%eax
f010320d:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f0103213:	c1 f8 03             	sar    $0x3,%eax
f0103216:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103219:	89 c2                	mov    %eax,%edx
f010321b:	c1 ea 0c             	shr    $0xc,%edx
f010321e:	3b 15 c8 8e 2b f0    	cmp    0xf02b8ec8,%edx
f0103224:	72 20                	jb     f0103246 <mem_init+0x1dc4>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103226:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010322a:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f0103231:	f0 
f0103232:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f0103239:	00 
f010323a:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f0103241:	e8 57 ce ff ff       	call   f010009d <_panic>
	memset(page2kva(pp2), 2, PGSIZE);
f0103246:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010324d:	00 
f010324e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f0103255:	00 
	return (void *)(pa + KERNBASE);
f0103256:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010325b:	89 04 24             	mov    %eax,(%esp)
f010325e:	e8 d4 2e 00 00       	call   f0106137 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0103263:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010326a:	00 
f010326b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103272:	00 
f0103273:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0103277:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f010327c:	89 04 24             	mov    %eax,(%esp)
f010327f:	e8 14 e1 ff ff       	call   f0101398 <page_insert>
	assert(pp1->pp_ref == 1);
f0103284:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103289:	74 24                	je     f01032af <mem_init+0x1e2d>
f010328b:	c7 44 24 0c 8e 81 10 	movl   $0xf010818e,0xc(%esp)
f0103292:	f0 
f0103293:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010329a:	f0 
f010329b:	c7 44 24 04 f4 04 00 	movl   $0x4f4,0x4(%esp)
f01032a2:	00 
f01032a3:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01032aa:	e8 ee cd ff ff       	call   f010009d <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01032af:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f01032b6:	01 01 01 
f01032b9:	74 24                	je     f01032df <mem_init+0x1e5d>
f01032bb:	c7 44 24 0c 10 8b 10 	movl   $0xf0108b10,0xc(%esp)
f01032c2:	f0 
f01032c3:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01032ca:	f0 
f01032cb:	c7 44 24 04 f5 04 00 	movl   $0x4f5,0x4(%esp)
f01032d2:	00 
f01032d3:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01032da:	e8 be cd ff ff       	call   f010009d <_panic>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f01032df:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01032e6:	00 
f01032e7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01032ee:	00 
f01032ef:	89 74 24 04          	mov    %esi,0x4(%esp)
f01032f3:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f01032f8:	89 04 24             	mov    %eax,(%esp)
f01032fb:	e8 98 e0 ff ff       	call   f0101398 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103300:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0103307:	02 02 02 
f010330a:	74 24                	je     f0103330 <mem_init+0x1eae>
f010330c:	c7 44 24 0c 34 8b 10 	movl   $0xf0108b34,0xc(%esp)
f0103313:	f0 
f0103314:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010331b:	f0 
f010331c:	c7 44 24 04 f7 04 00 	movl   $0x4f7,0x4(%esp)
f0103323:	00 
f0103324:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f010332b:	e8 6d cd ff ff       	call   f010009d <_panic>
	assert(pp2->pp_ref == 1);
f0103330:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0103335:	74 24                	je     f010335b <mem_init+0x1ed9>
f0103337:	c7 44 24 0c b0 81 10 	movl   $0xf01081b0,0xc(%esp)
f010333e:	f0 
f010333f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0103346:	f0 
f0103347:	c7 44 24 04 f8 04 00 	movl   $0x4f8,0x4(%esp)
f010334e:	00 
f010334f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0103356:	e8 42 cd ff ff       	call   f010009d <_panic>
	assert(pp1->pp_ref == 0);
f010335b:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103360:	74 24                	je     f0103386 <mem_init+0x1f04>
f0103362:	c7 44 24 0c 1a 82 10 	movl   $0xf010821a,0xc(%esp)
f0103369:	f0 
f010336a:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0103371:	f0 
f0103372:	c7 44 24 04 f9 04 00 	movl   $0x4f9,0x4(%esp)
f0103379:	00 
f010337a:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0103381:	e8 17 cd ff ff       	call   f010009d <_panic>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0103386:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f010338d:	03 03 03 
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103390:	89 f0                	mov    %esi,%eax
f0103392:	2b 05 d0 8e 2b f0    	sub    0xf02b8ed0,%eax
f0103398:	c1 f8 03             	sar    $0x3,%eax
f010339b:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010339e:	89 c2                	mov    %eax,%edx
f01033a0:	c1 ea 0c             	shr    $0xc,%edx
f01033a3:	3b 15 c8 8e 2b f0    	cmp    0xf02b8ec8,%edx
f01033a9:	72 20                	jb     f01033cb <mem_init+0x1f49>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01033ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01033af:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f01033b6:	f0 
f01033b7:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f01033be:	00 
f01033bf:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f01033c6:	e8 d2 cc ff ff       	call   f010009d <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01033cb:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01033d2:	03 03 03 
f01033d5:	74 24                	je     f01033fb <mem_init+0x1f79>
f01033d7:	c7 44 24 0c 58 8b 10 	movl   $0xf0108b58,0xc(%esp)
f01033de:	f0 
f01033df:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01033e6:	f0 
f01033e7:	c7 44 24 04 fb 04 00 	movl   $0x4fb,0x4(%esp)
f01033ee:	00 
f01033ef:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01033f6:	e8 a2 cc ff ff       	call   f010009d <_panic>
	page_remove(kern_pgdir, (void*) PGSIZE);
f01033fb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0103402:	00 
f0103403:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0103408:	89 04 24             	mov    %eax,(%esp)
f010340b:	e8 3f df ff ff       	call   f010134f <page_remove>
	assert(pp2->pp_ref == 0);
f0103410:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0103415:	74 24                	je     f010343b <mem_init+0x1fb9>
f0103417:	c7 44 24 0c e8 81 10 	movl   $0xf01081e8,0xc(%esp)
f010341e:	f0 
f010341f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0103426:	f0 
f0103427:	c7 44 24 04 fd 04 00 	movl   $0x4fd,0x4(%esp)
f010342e:	00 
f010342f:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0103436:	e8 62 cc ff ff       	call   f010009d <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010343b:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
f0103440:	8b 08                	mov    (%eax),%ecx
f0103442:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103448:	89 da                	mov    %ebx,%edx
f010344a:	2b 15 d0 8e 2b f0    	sub    0xf02b8ed0,%edx
f0103450:	c1 fa 03             	sar    $0x3,%edx
f0103453:	c1 e2 0c             	shl    $0xc,%edx
f0103456:	39 d1                	cmp    %edx,%ecx
f0103458:	74 24                	je     f010347e <mem_init+0x1ffc>
f010345a:	c7 44 24 0c e0 84 10 	movl   $0xf01084e0,0xc(%esp)
f0103461:	f0 
f0103462:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0103469:	f0 
f010346a:	c7 44 24 04 00 05 00 	movl   $0x500,0x4(%esp)
f0103471:	00 
f0103472:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f0103479:	e8 1f cc ff ff       	call   f010009d <_panic>
	kern_pgdir[0] = 0;
f010347e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0103484:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103489:	74 24                	je     f01034af <mem_init+0x202d>
f010348b:	c7 44 24 0c 9f 81 10 	movl   $0xf010819f,0xc(%esp)
f0103492:	f0 
f0103493:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010349a:	f0 
f010349b:	c7 44 24 04 02 05 00 	movl   $0x502,0x4(%esp)
f01034a2:	00 
f01034a3:	c7 04 24 7c 7f 10 f0 	movl   $0xf0107f7c,(%esp)
f01034aa:	e8 ee cb ff ff       	call   f010009d <_panic>
	pp0->pp_ref = 0;
f01034af:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f01034b5:	89 1c 24             	mov    %ebx,(%esp)
f01034b8:	e8 b1 dc ff ff       	call   f010116e <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f01034bd:	c7 04 24 84 8b 10 f0 	movl   $0xf0108b84,(%esp)
f01034c4:	e8 fc 0a 00 00       	call   f0103fc5 <cprintf>
f01034c9:	eb 1c                	jmp    f01034e7 <mem_init+0x2065>
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f01034cb:	89 da                	mov    %ebx,%edx
f01034cd:	89 f8                	mov    %edi,%eax
f01034cf:	e8 32 d7 ff ff       	call   f0100c06 <check_va2pa>
f01034d4:	e9 62 fa ff ff       	jmp    f0102f3b <mem_init+0x1ab9>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01034d9:	89 da                	mov    %ebx,%edx
f01034db:	89 f8                	mov    %edi,%eax
f01034dd:	e8 24 d7 ff ff       	call   f0100c06 <check_va2pa>
f01034e2:	e9 61 f9 ff ff       	jmp    f0102e48 <mem_init+0x19c6>
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f01034e7:	83 c4 4c             	add    $0x4c,%esp
f01034ea:	5b                   	pop    %ebx
f01034eb:	5e                   	pop    %esi
f01034ec:	5f                   	pop    %edi
f01034ed:	5d                   	pop    %ebp
f01034ee:	c3                   	ret    

f01034ef <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f01034ef:	55                   	push   %ebp
f01034f0:	89 e5                	mov    %esp,%ebp
f01034f2:	57                   	push   %edi
f01034f3:	56                   	push   %esi
f01034f4:	53                   	push   %ebx
f01034f5:	83 ec 2c             	sub    $0x2c,%esp
f01034f8:	8b 7d 08             	mov    0x8(%ebp),%edi
f01034fb:	8b 45 0c             	mov    0xc(%ebp),%eax
	// LAB 3: Your code here.

	//cprintf("VA recieved %08x\n",va);
	uint32_t number_pages = len/PGSIZE;
f01034fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0103501:	c1 e9 0c             	shr    $0xc,%ecx
f0103504:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	uint32_t i;
	const void *va_temp=va;
	va= ROUNDDOWN(va,PGSIZE);
f0103507:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010350a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010350f:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0103512:	89 c3                	mov    %eax,%ebx
	for(i=0;i<=number_pages;i++)
f0103514:	be 00 00 00 00       	mov    $0x0,%esi
f0103519:	eb 7f                	jmp    f010359a <user_mem_check+0xab>
	{
		if(va == ROUNDDOWN(va_temp,PGSIZE))
f010351b:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010351e:	39 c3                	cmp    %eax,%ebx
		{
			user_mem_check_addr =(uint32_t)va_temp;
f0103520:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103523:	0f 45 c3             	cmovne %ebx,%eax
f0103526:	a3 3c 82 2b f0       	mov    %eax,0xf02b823c
		}
		else
		{
			user_mem_check_addr=(uint32_t)va;
		}
		if((uint32_t)va > ULIM)
f010352b:	81 fb 00 00 80 ef    	cmp    $0xef800000,%ebx
f0103531:	76 13                	jbe    f0103546 <user_mem_check+0x57>
		{
			//user_mem_check_addr = (uint32_t)va;
			cprintf("not permitted\n");
f0103533:	c7 04 24 b5 82 10 f0 	movl   $0xf01082b5,(%esp)
f010353a:	e8 86 0a 00 00       	call   f0103fc5 <cprintf>

			return -E_FAULT;
f010353f:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103544:	eb 62                	jmp    f01035a8 <user_mem_check+0xb9>
		}
		uint32_t *vpaddress = pgdir_walk(env->env_pgdir,va,false);
f0103546:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010354d:	00 
f010354e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103552:	8b 47 60             	mov    0x60(%edi),%eax
f0103555:	89 04 24             	mov    %eax,(%esp)
f0103558:	e8 50 dc ff ff       	call   f01011ad <pgdir_walk>
		if(!vpaddress)
f010355d:	85 c0                	test   %eax,%eax
f010355f:	75 13                	jne    f0103574 <user_mem_check+0x85>
		{	
			//user_mem_check_addr =(uint32_t)va;

			cprintf("not permitted\n");
f0103561:	c7 04 24 b5 82 10 f0 	movl   $0xf01082b5,(%esp)
f0103568:	e8 58 0a 00 00       	call   f0103fc5 <cprintf>
			return -E_FAULT;
f010356d:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103572:	eb 34                	jmp    f01035a8 <user_mem_check+0xb9>
		}
		if((*vpaddress&perm)!=perm)
f0103574:	8b 55 14             	mov    0x14(%ebp),%edx
f0103577:	23 10                	and    (%eax),%edx
f0103579:	39 55 14             	cmp    %edx,0x14(%ebp)
f010357c:	74 13                	je     f0103591 <user_mem_check+0xa2>
		{
			//user_mem_check_addr = (uint32_t)va;
			cprintf("not permitted\n");
f010357e:	c7 04 24 b5 82 10 f0 	movl   $0xf01082b5,(%esp)
f0103585:	e8 3b 0a 00 00       	call   f0103fc5 <cprintf>
			return -E_FAULT;
f010358a:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010358f:	eb 17                	jmp    f01035a8 <user_mem_check+0xb9>
		}
		va = va+PGSIZE;
f0103591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	//cprintf("VA recieved %08x\n",va);
	uint32_t number_pages = len/PGSIZE;
	uint32_t i;
	const void *va_temp=va;
	va= ROUNDDOWN(va,PGSIZE);
	for(i=0;i<=number_pages;i++)
f0103597:	83 c6 01             	add    $0x1,%esi
f010359a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
f010359d:	0f 86 78 ff ff ff    	jbe    f010351b <user_mem_check+0x2c>

	}



	return 0;
f01035a3:	b8 00 00 00 00       	mov    $0x0,%eax

}
f01035a8:	83 c4 2c             	add    $0x2c,%esp
f01035ab:	5b                   	pop    %ebx
f01035ac:	5e                   	pop    %esi
f01035ad:	5f                   	pop    %edi
f01035ae:	5d                   	pop    %ebp
f01035af:	c3                   	ret    

f01035b0 <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f01035b0:	55                   	push   %ebp
f01035b1:	89 e5                	mov    %esp,%ebp
f01035b3:	53                   	push   %ebx
f01035b4:	83 ec 14             	sub    $0x14,%esp
f01035b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U|PTE_P) < 0) {
f01035ba:	8b 45 14             	mov    0x14(%ebp),%eax
f01035bd:	83 c8 05             	or     $0x5,%eax
f01035c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01035c4:	8b 45 10             	mov    0x10(%ebp),%eax
f01035c7:	89 44 24 08          	mov    %eax,0x8(%esp)
f01035cb:	8b 45 0c             	mov    0xc(%ebp),%eax
f01035ce:	89 44 24 04          	mov    %eax,0x4(%esp)
f01035d2:	89 1c 24             	mov    %ebx,(%esp)
f01035d5:	e8 15 ff ff ff       	call   f01034ef <user_mem_check>
f01035da:	85 c0                	test   %eax,%eax
f01035dc:	79 24                	jns    f0103602 <user_mem_assert+0x52>


		cprintf("[%08x] user_mem_check assertion failure for "
f01035de:	a1 3c 82 2b f0       	mov    0xf02b823c,%eax
f01035e3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01035e7:	8b 43 48             	mov    0x48(%ebx),%eax
f01035ea:	89 44 24 04          	mov    %eax,0x4(%esp)
f01035ee:	c7 04 24 b0 8b 10 f0 	movl   $0xf0108bb0,(%esp)
f01035f5:	e8 cb 09 00 00       	call   f0103fc5 <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f01035fa:	89 1c 24             	mov    %ebx,(%esp)
f01035fd:	e8 b6 06 00 00       	call   f0103cb8 <env_destroy>
	}
}
f0103602:	83 c4 14             	add    $0x14,%esp
f0103605:	5b                   	pop    %ebx
f0103606:	5d                   	pop    %ebp
f0103607:	c3                   	ret    

f0103608 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f0103608:	55                   	push   %ebp
f0103609:	89 e5                	mov    %esp,%ebp
f010360b:	57                   	push   %edi
f010360c:	56                   	push   %esi
f010360d:	53                   	push   %ebx
f010360e:	83 ec 2c             	sub    $0x2c,%esp
f0103611:	89 c7                	mov    %eax,%edi
	// LAB 3: Your code here.
	// (But only if you need it for load_icode.)

	int no_pages = len/PGSIZE;
f0103613:	c1 e9 0c             	shr    $0xc,%ecx
f0103616:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i ;
	va =(void*)ROUNDDOWN((uint32_t)va,PGSIZE);
f0103619:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010361f:	89 d6                	mov    %edx,%esi
	struct PageInfo *p_r = NULL;
	for(i=0;i<=no_pages;i++)
f0103621:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103626:	eb 50                	jmp    f0103678 <region_alloc+0x70>
	{
		if (!(p_r = page_alloc(false)))
f0103628:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010362f:	e8 af da ff ff       	call   f01010e3 <page_alloc>
f0103634:	85 c0                	test   %eax,%eax
f0103636:	75 1c                	jne    f0103654 <region_alloc+0x4c>
				panic("Page Alloc Failed\n");
f0103638:	c7 44 24 08 e5 8b 10 	movl   $0xf0108be5,0x8(%esp)
f010363f:	f0 
f0103640:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
f0103647:	00 
f0103648:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f010364f:	e8 49 ca ff ff       	call   f010009d <_panic>
		else
		{
			page_insert(e->env_pgdir,p_r,va,PTE_W|PTE_U);
f0103654:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f010365b:	00 
f010365c:	89 74 24 08          	mov    %esi,0x8(%esp)
f0103660:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103664:	8b 47 60             	mov    0x60(%edi),%eax
f0103667:	89 04 24             	mov    %eax,(%esp)
f010366a:	e8 29 dd ff ff       	call   f0101398 <page_insert>
		}
	va = va + PGSIZE;
f010366f:	81 c6 00 10 00 00    	add    $0x1000,%esi

	int no_pages = len/PGSIZE;
	int i ;
	va =(void*)ROUNDDOWN((uint32_t)va,PGSIZE);
	struct PageInfo *p_r = NULL;
	for(i=0;i<=no_pages;i++)
f0103675:	83 c3 01             	add    $0x1,%ebx
f0103678:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f010367b:	7e ab                	jle    f0103628 <region_alloc+0x20>

	// Hint: It is easier to use region_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
	//   (Watch out for corner-cases!)
}
f010367d:	83 c4 2c             	add    $0x2c,%esp
f0103680:	5b                   	pop    %ebx
f0103681:	5e                   	pop    %esi
f0103682:	5f                   	pop    %edi
f0103683:	5d                   	pop    %ebp
f0103684:	c3                   	ret    

f0103685 <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0103685:	55                   	push   %ebp
f0103686:	89 e5                	mov    %esp,%ebp
f0103688:	56                   	push   %esi
f0103689:	53                   	push   %ebx
f010368a:	8b 45 08             	mov    0x8(%ebp),%eax
f010368d:	8b 55 10             	mov    0x10(%ebp),%edx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103690:	85 c0                	test   %eax,%eax
f0103692:	75 1a                	jne    f01036ae <envid2env+0x29>
		*env_store = curenv;
f0103694:	e8 f0 30 00 00       	call   f0106789 <cpunum>
f0103699:	6b c0 74             	imul   $0x74,%eax,%eax
f010369c:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01036a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01036a5:	89 01                	mov    %eax,(%ecx)
		return 0;
f01036a7:	b8 00 00 00 00       	mov    $0x0,%eax
f01036ac:	eb 70                	jmp    f010371e <envid2env+0x99>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f01036ae:	89 c3                	mov    %eax,%ebx
f01036b0:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f01036b6:	6b db 7c             	imul   $0x7c,%ebx,%ebx
f01036b9:	03 1d 48 82 2b f0    	add    0xf02b8248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f01036bf:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f01036c3:	74 05                	je     f01036ca <envid2env+0x45>
f01036c5:	39 43 48             	cmp    %eax,0x48(%ebx)
f01036c8:	74 10                	je     f01036da <envid2env+0x55>
		*env_store = 0;
f01036ca:	8b 45 0c             	mov    0xc(%ebp),%eax
f01036cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01036d3:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01036d8:	eb 44                	jmp    f010371e <envid2env+0x99>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01036da:	84 d2                	test   %dl,%dl
f01036dc:	74 36                	je     f0103714 <envid2env+0x8f>
f01036de:	e8 a6 30 00 00       	call   f0106789 <cpunum>
f01036e3:	6b c0 74             	imul   $0x74,%eax,%eax
f01036e6:	39 98 28 90 31 f0    	cmp    %ebx,-0xfce6fd8(%eax)
f01036ec:	74 26                	je     f0103714 <envid2env+0x8f>
f01036ee:	8b 73 4c             	mov    0x4c(%ebx),%esi
f01036f1:	e8 93 30 00 00       	call   f0106789 <cpunum>
f01036f6:	6b c0 74             	imul   $0x74,%eax,%eax
f01036f9:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01036ff:	3b 70 48             	cmp    0x48(%eax),%esi
f0103702:	74 10                	je     f0103714 <envid2env+0x8f>
		*env_store = 0;
f0103704:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f010370d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103712:	eb 0a                	jmp    f010371e <envid2env+0x99>
	}

	*env_store = e;
f0103714:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103717:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103719:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010371e:	5b                   	pop    %ebx
f010371f:	5e                   	pop    %esi
f0103720:	5d                   	pop    %ebp
f0103721:	c3                   	ret    

f0103722 <env_init_percpu>:
}

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f0103722:	55                   	push   %ebp
f0103723:	89 e5                	mov    %esp,%ebp
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
f0103725:	b8 20 43 12 f0       	mov    $0xf0124320,%eax
f010372a:	0f 01 10             	lgdtl  (%eax)
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f010372d:	b8 23 00 00 00       	mov    $0x23,%eax
f0103732:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0103734:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0103736:	b0 10                	mov    $0x10,%al
f0103738:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f010373a:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f010373c:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));
f010373e:	ea 45 37 10 f0 08 00 	ljmp   $0x8,$0xf0103745
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
f0103745:	b0 00                	mov    $0x0,%al
f0103747:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
f010374a:	5d                   	pop    %ebp
f010374b:	c3                   	ret    

f010374c <env_init>:
	// LAB 3: Your code here.

	// Per-CPU part of the initialization

	int i;
	envs[0].env_status = ENV_FREE;
f010374c:	8b 0d 48 82 2b f0    	mov    0xf02b8248,%ecx
f0103752:	c7 41 54 00 00 00 00 	movl   $0x0,0x54(%ecx)
	envs[0].env_runs = 0;
f0103759:	c7 41 58 00 00 00 00 	movl   $0x0,0x58(%ecx)
	envs[0].env_id = 0 ;
f0103760:	c7 41 48 00 00 00 00 	movl   $0x0,0x48(%ecx)
	envs[0].env_link = NULL;
f0103767:	c7 41 44 00 00 00 00 	movl   $0x0,0x44(%ecx)
	env_free_list = &envs[0];
f010376e:	89 0d 4c 82 2b f0    	mov    %ecx,0xf02b824c
f0103774:	8d 41 7c             	lea    0x7c(%ecx),%eax
f0103777:	ba ff 03 00 00       	mov    $0x3ff,%edx
	for(i=1;i<NENV;i++)
	{
		envs[i].env_status = ENV_FREE;
f010377c:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
		envs[i].env_runs =0;
f0103783:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
		envs[i].env_id =0;
f010378a:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
		envs[i-1].env_link = &envs[i];
f0103791:	89 40 c8             	mov    %eax,-0x38(%eax)
f0103794:	83 c0 7c             	add    $0x7c,%eax
	envs[0].env_status = ENV_FREE;
	envs[0].env_runs = 0;
	envs[0].env_id = 0 ;
	envs[0].env_link = NULL;
	env_free_list = &envs[0];
	for(i=1;i<NENV;i++)
f0103797:	83 ea 01             	sub    $0x1,%edx
f010379a:	75 e0                	jne    f010377c <env_init+0x30>
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f010379c:	55                   	push   %ebp
f010379d:	89 e5                	mov    %esp,%ebp
		envs[i].env_runs =0;
		envs[i].env_id =0;
		envs[i-1].env_link = &envs[i];

	}
	envs[NENV-1].env_link = NULL;
f010379f:	c7 81 c8 ef 01 00 00 	movl   $0x0,0x1efc8(%ecx)
f01037a6:	00 00 00 
	// Per-CPU part of the initialization




	env_init_percpu();
f01037a9:	e8 74 ff ff ff       	call   f0103722 <env_init_percpu>
}
f01037ae:	5d                   	pop    %ebp
f01037af:	c3                   	ret    

f01037b0 <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f01037b0:	55                   	push   %ebp
f01037b1:	89 e5                	mov    %esp,%ebp
f01037b3:	53                   	push   %ebx
f01037b4:	83 ec 14             	sub    $0x14,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f01037b7:	8b 1d 4c 82 2b f0    	mov    0xf02b824c,%ebx
f01037bd:	85 db                	test   %ebx,%ebx
f01037bf:	0f 84 9f 01 00 00    	je     f0103964 <env_alloc+0x1b4>
{
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f01037c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01037cc:	e8 12 d9 ff ff       	call   f01010e3 <page_alloc>
f01037d1:	85 c0                	test   %eax,%eax
f01037d3:	0f 84 92 01 00 00    	je     f010396b <env_alloc+0x1bb>
f01037d9:	89 c2                	mov    %eax,%edx
f01037db:	2b 15 d0 8e 2b f0    	sub    0xf02b8ed0,%edx
f01037e1:	c1 fa 03             	sar    $0x3,%edx
f01037e4:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01037e7:	89 d1                	mov    %edx,%ecx
f01037e9:	c1 e9 0c             	shr    $0xc,%ecx
f01037ec:	3b 0d c8 8e 2b f0    	cmp    0xf02b8ec8,%ecx
f01037f2:	72 20                	jb     f0103814 <env_alloc+0x64>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01037f4:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01037f8:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f01037ff:	f0 
f0103800:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
f0103807:	00 
f0103808:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f010380f:	e8 89 c8 ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0103814:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010381a:	89 53 60             	mov    %edx,0x60(%ebx)
		return -E_NO_MEM;

	e->env_pgdir = (uint32_t *)page2kva(p);
	p->pp_ref = p->pp_ref+1;
f010381d:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
f0103822:	b8 bb 03 00 00       	mov    $0x3bb,%eax
	//	pp_ref for env_free to work correctly.
	//    - The functions in kern/pmap.h are handy.

	// LAB 3: Your code here.

	for(i=0;i<PDX(UTOP);i++)
f0103827:	83 e8 01             	sub    $0x1,%eax
f010382a:	75 fb                	jne    f0103827 <env_alloc+0x77>
f010382c:	b8 ec 0e 00 00       	mov    $0xeec,%eax
	{
		e->env_pgdir[i] == 0;
	}
	for(i = PDX(UTOP) ; i<NPDENTRIES ;i++)
	{
		e->env_pgdir[i] = kern_pgdir[i];
f0103831:	8b 15 cc 8e 2b f0    	mov    0xf02b8ecc,%edx
f0103837:	8b 0c 02             	mov    (%edx,%eax,1),%ecx
f010383a:	8b 53 60             	mov    0x60(%ebx),%edx
f010383d:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
f0103840:	83 c0 04             	add    $0x4,%eax

	for(i=0;i<PDX(UTOP);i++)
	{
		e->env_pgdir[i] == 0;
	}
	for(i = PDX(UTOP) ; i<NPDENTRIES ;i++)
f0103843:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0103848:	75 e7                	jne    f0103831 <env_alloc+0x81>



	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f010384a:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010384d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103852:	77 20                	ja     f0103874 <env_alloc+0xc4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103854:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103858:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f010385f:	f0 
f0103860:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
f0103867:	00 
f0103868:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f010386f:	e8 29 c8 ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103874:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f010387a:	83 ca 05             	or     $0x5,%edx
f010387d:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103883:	8b 43 48             	mov    0x48(%ebx),%eax
f0103886:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f010388b:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103890:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103895:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103898:	89 da                	mov    %ebx,%edx
f010389a:	2b 15 48 82 2b f0    	sub    0xf02b8248,%edx
f01038a0:	c1 fa 02             	sar    $0x2,%edx
f01038a3:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f01038a9:	09 d0                	or     %edx,%eax
f01038ab:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f01038ae:	8b 45 0c             	mov    0xc(%ebp),%eax
f01038b1:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f01038b4:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f01038bb:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f01038c2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f01038c9:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f01038d0:	00 
f01038d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01038d8:	00 
f01038d9:	89 1c 24             	mov    %ebx,(%esp)
f01038dc:	e8 56 28 00 00       	call   f0106137 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f01038e1:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01038e7:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01038ed:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01038f3:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f01038fa:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.


	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags = e->env_tf.tf_eflags|FL_IF;
f0103900:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)


	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0103907:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f010390e:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f0103912:	8b 43 44             	mov    0x44(%ebx),%eax
f0103915:	a3 4c 82 2b f0       	mov    %eax,0xf02b824c
	*newenv_store = e;
f010391a:	8b 45 08             	mov    0x8(%ebp),%eax
f010391d:	89 18                	mov    %ebx,(%eax)

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f010391f:	8b 5b 48             	mov    0x48(%ebx),%ebx
f0103922:	e8 62 2e 00 00       	call   f0106789 <cpunum>
f0103927:	6b d0 74             	imul   $0x74,%eax,%edx
f010392a:	b8 00 00 00 00       	mov    $0x0,%eax
f010392f:	83 ba 28 90 31 f0 00 	cmpl   $0x0,-0xfce6fd8(%edx)
f0103936:	74 11                	je     f0103949 <env_alloc+0x199>
f0103938:	e8 4c 2e 00 00       	call   f0106789 <cpunum>
f010393d:	6b c0 74             	imul   $0x74,%eax,%eax
f0103940:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0103946:	8b 40 48             	mov    0x48(%eax),%eax
f0103949:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010394d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103951:	c7 04 24 03 8c 10 f0 	movl   $0xf0108c03,(%esp)
f0103958:	e8 68 06 00 00       	call   f0103fc5 <cprintf>


	return 0;
f010395d:	b8 00 00 00 00       	mov    $0x0,%eax
f0103962:	eb 0c                	jmp    f0103970 <env_alloc+0x1c0>
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
		return -E_NO_FREE_ENV;
f0103964:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103969:	eb 05                	jmp    f0103970 <env_alloc+0x1c0>
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
		return -E_NO_MEM;
f010396b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);


	return 0;
}
f0103970:	83 c4 14             	add    $0x14,%esp
f0103973:	5b                   	pop    %ebx
f0103974:	5d                   	pop    %ebp
f0103975:	c3                   	ret    

f0103976 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103976:	55                   	push   %ebp
f0103977:	89 e5                	mov    %esp,%ebp
f0103979:	57                   	push   %edi
f010397a:	56                   	push   %esi
f010397b:	53                   	push   %ebx
f010397c:	83 ec 3c             	sub    $0x3c,%esp
f010397f:	8b 7d 08             	mov    0x8(%ebp),%edi

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	//cprintf("Number of environments %d\n",NENV);
	struct Env *new_env;
	if(env_alloc(&new_env,0)<0)
f0103982:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103989:	00 
f010398a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010398d:	89 04 24             	mov    %eax,(%esp)
f0103990:	e8 1b fe ff ff       	call   f01037b0 <env_alloc>
f0103995:	85 c0                	test   %eax,%eax
f0103997:	79 1c                	jns    f01039b5 <env_create+0x3f>
	{
		panic("ENV CREATE FAILED ");
f0103999:	c7 44 24 08 18 8c 10 	movl   $0xf0108c18,0x8(%esp)
f01039a0:	f0 
f01039a1:	c7 44 24 04 c5 01 00 	movl   $0x1c5,0x4(%esp)
f01039a8:	00 
f01039a9:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f01039b0:	e8 e8 c6 ff ff       	call   f010009d <_panic>
	}
	else
	{
		if(type == ENV_TYPE_FS)
f01039b5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
f01039b9:	75 0a                	jne    f01039c5 <env_create+0x4f>
		{
			new_env->env_tf.tf_eflags = new_env->env_tf.tf_eflags | FL_IOPL_3;
f01039bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01039be:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)
		}
		load_icode(new_env,binary);
f01039c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01039c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	//  (The ELF header should have ph->p_filesz <= ph->p_memsz.)
	//  Use functions from the previous lab to allocate and map pages.

	struct Proghdr *ph, *eph;
	struct Elf* elf_icode = ((struct Elf*)binary);
	if(elf_icode->e_magic != ELF_MAGIC)
f01039cb:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f01039d1:	74 1c                	je     f01039ef <env_create+0x79>
		panic("ELF format of not proper type");
f01039d3:	c7 44 24 08 2b 8c 10 	movl   $0xf0108c2b,0x8(%esp)
f01039da:	f0 
f01039db:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
f01039e2:	00 
f01039e3:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f01039ea:	e8 ae c6 ff ff       	call   f010009d <_panic>
	ph = (struct Proghdr *) ((uint8_t *)elf_icode + elf_icode->e_phoff);
f01039ef:	89 fb                	mov    %edi,%ebx
f01039f1:	03 5f 1c             	add    0x1c(%edi),%ebx
	eph = ph + elf_icode->e_phnum;
f01039f4:	0f b7 77 2c          	movzwl 0x2c(%edi),%esi
f01039f8:	c1 e6 05             	shl    $0x5,%esi
f01039fb:	01 de                	add    %ebx,%esi
	lcr3(PADDR(e->env_pgdir));
f01039fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103a00:	8b 40 60             	mov    0x60(%eax),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103a03:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103a08:	77 20                	ja     f0103a2a <env_create+0xb4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103a0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103a0e:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0103a15:	f0 
f0103a16:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
f0103a1d:	00 
f0103a1e:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f0103a25:	e8 73 c6 ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103a2a:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103a2f:	0f 22 d8             	mov    %eax,%cr3
f0103a32:	eb 50                	jmp    f0103a84 <env_create+0x10e>
	for (; ph < eph; ph++)
	{
		if(ph->p_type == ELF_PROG_LOAD)
f0103a34:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103a37:	75 48                	jne    f0103a81 <env_create+0x10b>
		{
			region_alloc(e,(void*)ph->p_va,ph->p_memsz);
f0103a39:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103a3c:	8b 53 08             	mov    0x8(%ebx),%edx
f0103a3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103a42:	e8 c1 fb ff ff       	call   f0103608 <region_alloc>
			memcpy((void*)ph->p_va,binary+ph->p_offset,ph->p_filesz);
f0103a47:	8b 43 10             	mov    0x10(%ebx),%eax
f0103a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103a4e:	89 f8                	mov    %edi,%eax
f0103a50:	03 43 04             	add    0x4(%ebx),%eax
f0103a53:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103a57:	8b 43 08             	mov    0x8(%ebx),%eax
f0103a5a:	89 04 24             	mov    %eax,(%esp)
f0103a5d:	e8 8a 27 00 00       	call   f01061ec <memcpy>
			memset((void*)(ph->p_va+ph->p_filesz),0,ph->p_memsz-ph->p_filesz);
f0103a62:	8b 43 10             	mov    0x10(%ebx),%eax
f0103a65:	8b 53 14             	mov    0x14(%ebx),%edx
f0103a68:	29 c2                	sub    %eax,%edx
f0103a6a:	89 54 24 08          	mov    %edx,0x8(%esp)
f0103a6e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103a75:	00 
f0103a76:	03 43 08             	add    0x8(%ebx),%eax
f0103a79:	89 04 24             	mov    %eax,(%esp)
f0103a7c:	e8 b6 26 00 00       	call   f0106137 <memset>
	if(elf_icode->e_magic != ELF_MAGIC)
		panic("ELF format of not proper type");
	ph = (struct Proghdr *) ((uint8_t *)elf_icode + elf_icode->e_phoff);
	eph = ph + elf_icode->e_phnum;
	lcr3(PADDR(e->env_pgdir));
	for (; ph < eph; ph++)
f0103a81:	83 c3 20             	add    $0x20,%ebx
f0103a84:	39 de                	cmp    %ebx,%esi
f0103a86:	77 ac                	ja     f0103a34 <env_create+0xbe>
			memcpy((void*)ph->p_va,binary+ph->p_offset,ph->p_filesz);
			memset((void*)(ph->p_va+ph->p_filesz),0,ph->p_memsz-ph->p_filesz);
		}
		
	}
	e->env_tf.tf_eip = elf_icode->e_entry;
f0103a88:	8b 47 18             	mov    0x18(%edi),%eax
f0103a8b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0103a8e:	89 47 30             	mov    %eax,0x30(%edi)
	// LAB 3: Your code here.

	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.

	region_alloc(e,(void*)(USTACKTOP-PGSIZE),PGSIZE);
f0103a91:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103a96:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103a9b:	89 f8                	mov    %edi,%eax
f0103a9d:	e8 66 fb ff ff       	call   f0103608 <region_alloc>
		if(type == ENV_TYPE_FS)
		{
			new_env->env_tf.tf_eflags = new_env->env_tf.tf_eflags | FL_IOPL_3;
		}
		load_icode(new_env,binary);
		new_env->env_type = type;
f0103aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103aa8:	89 48 50             	mov    %ecx,0x50(%eax)
	}	


}
f0103aab:	83 c4 3c             	add    $0x3c,%esp
f0103aae:	5b                   	pop    %ebx
f0103aaf:	5e                   	pop    %esi
f0103ab0:	5f                   	pop    %edi
f0103ab1:	5d                   	pop    %ebp
f0103ab2:	c3                   	ret    

f0103ab3 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103ab3:	55                   	push   %ebp
f0103ab4:	89 e5                	mov    %esp,%ebp
f0103ab6:	57                   	push   %edi
f0103ab7:	56                   	push   %esi
f0103ab8:	53                   	push   %ebx
f0103ab9:	83 ec 2c             	sub    $0x2c,%esp
f0103abc:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103abf:	e8 c5 2c 00 00       	call   f0106789 <cpunum>
f0103ac4:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ac7:	39 b8 28 90 31 f0    	cmp    %edi,-0xfce6fd8(%eax)
f0103acd:	75 34                	jne    f0103b03 <env_free+0x50>
		lcr3(PADDR(kern_pgdir));
f0103acf:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103ad4:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103ad9:	77 20                	ja     f0103afb <env_free+0x48>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103adb:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103adf:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0103ae6:	f0 
f0103ae7:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
f0103aee:	00 
f0103aef:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f0103af6:	e8 a2 c5 ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103afb:	05 00 00 00 10       	add    $0x10000000,%eax
f0103b00:	0f 22 d8             	mov    %eax,%cr3

	// Note the environment's demise.
	cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0103b03:	8b 5f 48             	mov    0x48(%edi),%ebx
f0103b06:	e8 7e 2c 00 00       	call   f0106789 <cpunum>
f0103b0b:	6b d0 74             	imul   $0x74,%eax,%edx
f0103b0e:	b8 00 00 00 00       	mov    $0x0,%eax
f0103b13:	83 ba 28 90 31 f0 00 	cmpl   $0x0,-0xfce6fd8(%edx)
f0103b1a:	74 11                	je     f0103b2d <env_free+0x7a>
f0103b1c:	e8 68 2c 00 00       	call   f0106789 <cpunum>
f0103b21:	6b c0 74             	imul   $0x74,%eax,%eax
f0103b24:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0103b2a:	8b 40 48             	mov    0x48(%eax),%eax
f0103b2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0103b31:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103b35:	c7 04 24 49 8c 10 f0 	movl   $0xf0108c49,(%esp)
f0103b3c:	e8 84 04 00 00       	call   f0103fc5 <cprintf>



	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103b41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103b48:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103b4b:	89 c8                	mov    %ecx,%eax
f0103b4d:	c1 e0 02             	shl    $0x2,%eax
f0103b50:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103b53:	8b 47 60             	mov    0x60(%edi),%eax
f0103b56:	8b 34 88             	mov    (%eax,%ecx,4),%esi
f0103b59:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103b5f:	0f 84 b7 00 00 00    	je     f0103c1c <env_free+0x169>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103b65:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103b6b:	89 f0                	mov    %esi,%eax
f0103b6d:	c1 e8 0c             	shr    $0xc,%eax
f0103b70:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103b73:	3b 05 c8 8e 2b f0    	cmp    0xf02b8ec8,%eax
f0103b79:	72 20                	jb     f0103b9b <env_free+0xe8>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103b7b:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0103b7f:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f0103b86:	f0 
f0103b87:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
f0103b8e:	00 
f0103b8f:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f0103b96:	e8 02 c5 ff ff       	call   f010009d <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103b9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103b9e:	c1 e0 16             	shl    $0x16,%eax
f0103ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103ba4:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (pt[pteno] & PTE_P)
f0103ba9:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f0103bb0:	01 
f0103bb1:	74 17                	je     f0103bca <env_free+0x117>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103bb3:	89 d8                	mov    %ebx,%eax
f0103bb5:	c1 e0 0c             	shl    $0xc,%eax
f0103bb8:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103bbf:	8b 47 60             	mov    0x60(%edi),%eax
f0103bc2:	89 04 24             	mov    %eax,(%esp)
f0103bc5:	e8 85 d7 ff ff       	call   f010134f <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103bca:	83 c3 01             	add    $0x1,%ebx
f0103bcd:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103bd3:	75 d4                	jne    f0103ba9 <env_free+0xf6>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103bd5:	8b 47 60             	mov    0x60(%edi),%eax
f0103bd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103bdb:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103be2:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103be5:	3b 05 c8 8e 2b f0    	cmp    0xf02b8ec8,%eax
f0103beb:	72 1c                	jb     f0103c09 <env_free+0x156>
		panic("pa2page called with invalid pa");
f0103bed:	c7 44 24 08 ac 83 10 	movl   $0xf01083ac,0x8(%esp)
f0103bf4:	f0 
f0103bf5:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
f0103bfc:	00 
f0103bfd:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f0103c04:	e8 94 c4 ff ff       	call   f010009d <_panic>
	return &pages[PGNUM(pa)];
f0103c09:	a1 d0 8e 2b f0       	mov    0xf02b8ed0,%eax
f0103c0e:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103c11:	8d 04 d0             	lea    (%eax,%edx,8),%eax
		page_decref(pa2page(pa));
f0103c14:	89 04 24             	mov    %eax,(%esp)
f0103c17:	e8 6e d5 ff ff       	call   f010118a <page_decref>



	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103c1c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0103c20:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f0103c27:	0f 85 1b ff ff ff    	jne    f0103b48 <env_free+0x95>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103c2d:	8b 47 60             	mov    0x60(%edi),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103c30:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c35:	77 20                	ja     f0103c57 <env_free+0x1a4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103c37:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103c3b:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0103c42:	f0 
f0103c43:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
f0103c4a:	00 
f0103c4b:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f0103c52:	e8 46 c4 ff ff       	call   f010009d <_panic>
	e->env_pgdir = 0;
f0103c57:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103c5e:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103c63:	c1 e8 0c             	shr    $0xc,%eax
f0103c66:	3b 05 c8 8e 2b f0    	cmp    0xf02b8ec8,%eax
f0103c6c:	72 1c                	jb     f0103c8a <env_free+0x1d7>
		panic("pa2page called with invalid pa");
f0103c6e:	c7 44 24 08 ac 83 10 	movl   $0xf01083ac,0x8(%esp)
f0103c75:	f0 
f0103c76:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
f0103c7d:	00 
f0103c7e:	c7 04 24 88 7f 10 f0 	movl   $0xf0107f88,(%esp)
f0103c85:	e8 13 c4 ff ff       	call   f010009d <_panic>
	return &pages[PGNUM(pa)];
f0103c8a:	8b 15 d0 8e 2b f0    	mov    0xf02b8ed0,%edx
f0103c90:	8d 04 c2             	lea    (%edx,%eax,8),%eax
	page_decref(pa2page(pa));
f0103c93:	89 04 24             	mov    %eax,(%esp)
f0103c96:	e8 ef d4 ff ff       	call   f010118a <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0103c9b:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f0103ca2:	a1 4c 82 2b f0       	mov    0xf02b824c,%eax
f0103ca7:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0103caa:	89 3d 4c 82 2b f0    	mov    %edi,0xf02b824c
}
f0103cb0:	83 c4 2c             	add    $0x2c,%esp
f0103cb3:	5b                   	pop    %ebx
f0103cb4:	5e                   	pop    %esi
f0103cb5:	5f                   	pop    %edi
f0103cb6:	5d                   	pop    %ebp
f0103cb7:	c3                   	ret    

f0103cb8 <env_destroy>:


//
void
env_destroy(struct Env *e)
{
f0103cb8:	55                   	push   %ebp
f0103cb9:	89 e5                	mov    %esp,%ebp
f0103cbb:	53                   	push   %ebx
f0103cbc:	83 ec 14             	sub    $0x14,%esp
f0103cbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103cc2:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103cc6:	75 19                	jne    f0103ce1 <env_destroy+0x29>
f0103cc8:	e8 bc 2a 00 00       	call   f0106789 <cpunum>
f0103ccd:	6b c0 74             	imul   $0x74,%eax,%eax
f0103cd0:	39 98 28 90 31 f0    	cmp    %ebx,-0xfce6fd8(%eax)
f0103cd6:	74 09                	je     f0103ce1 <env_destroy+0x29>
		e->env_status = ENV_DYING;
f0103cd8:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103cdf:	eb 2f                	jmp    f0103d10 <env_destroy+0x58>
	}

	env_free(e);
f0103ce1:	89 1c 24             	mov    %ebx,(%esp)
f0103ce4:	e8 ca fd ff ff       	call   f0103ab3 <env_free>

	if (curenv == e) {
f0103ce9:	e8 9b 2a 00 00       	call   f0106789 <cpunum>
f0103cee:	6b c0 74             	imul   $0x74,%eax,%eax
f0103cf1:	39 98 28 90 31 f0    	cmp    %ebx,-0xfce6fd8(%eax)
f0103cf7:	75 17                	jne    f0103d10 <env_destroy+0x58>
		curenv = NULL;
f0103cf9:	e8 8b 2a 00 00       	call   f0106789 <cpunum>
f0103cfe:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d01:	c7 80 28 90 31 f0 00 	movl   $0x0,-0xfce6fd8(%eax)
f0103d08:	00 00 00 
		sched_yield();
f0103d0b:	e8 f2 0f 00 00       	call   f0104d02 <sched_yield>
	}
}
f0103d10:	83 c4 14             	add    $0x14,%esp
f0103d13:	5b                   	pop    %ebx
f0103d14:	5d                   	pop    %ebp
f0103d15:	c3                   	ret    

f0103d16 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103d16:	55                   	push   %ebp
f0103d17:	89 e5                	mov    %esp,%ebp
f0103d19:	53                   	push   %ebx
f0103d1a:	83 ec 14             	sub    $0x14,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103d1d:	e8 67 2a 00 00       	call   f0106789 <cpunum>
f0103d22:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d25:	8b 98 28 90 31 f0    	mov    -0xfce6fd8(%eax),%ebx
f0103d2b:	e8 59 2a 00 00       	call   f0106789 <cpunum>
f0103d30:	89 43 5c             	mov    %eax,0x5c(%ebx)

	__asm __volatile("movl %0,%%esp\n"
f0103d33:	8b 65 08             	mov    0x8(%ebp),%esp
f0103d36:	61                   	popa   
f0103d37:	07                   	pop    %es
f0103d38:	1f                   	pop    %ds
f0103d39:	83 c4 08             	add    $0x8,%esp
f0103d3c:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103d3d:	c7 44 24 08 5f 8c 10 	movl   $0xf0108c5f,0x8(%esp)
f0103d44:	f0 
f0103d45:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
f0103d4c:	00 
f0103d4d:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f0103d54:	e8 44 c3 ff ff       	call   f010009d <_panic>

f0103d59 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103d59:	55                   	push   %ebp
f0103d5a:	89 e5                	mov    %esp,%ebp
f0103d5c:	53                   	push   %ebx
f0103d5d:	83 ec 14             	sub    $0x14,%esp
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if(curenv !=NULL)
f0103d60:	e8 24 2a 00 00       	call   f0106789 <cpunum>
f0103d65:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d68:	83 b8 28 90 31 f0 00 	cmpl   $0x0,-0xfce6fd8(%eax)
f0103d6f:	74 29                	je     f0103d9a <env_run+0x41>
	{
		if(curenv->env_status == ENV_RUNNING)
f0103d71:	e8 13 2a 00 00       	call   f0106789 <cpunum>
f0103d76:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d79:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0103d7f:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103d83:	75 15                	jne    f0103d9a <env_run+0x41>
		{
			curenv->env_status =ENV_RUNNABLE;
f0103d85:	e8 ff 29 00 00       	call   f0106789 <cpunum>
f0103d8a:	6b c0 74             	imul   $0x74,%eax,%eax
f0103d8d:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0103d93:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
		}
	}
			curenv = e;
f0103d9a:	e8 ea 29 00 00       	call   f0106789 <cpunum>
f0103d9f:	6b c0 74             	imul   $0x74,%eax,%eax
f0103da2:	8b 55 08             	mov    0x8(%ebp),%edx
f0103da5:	89 90 28 90 31 f0    	mov    %edx,-0xfce6fd8(%eax)
			curenv->env_status = ENV_RUNNING;
f0103dab:	e8 d9 29 00 00       	call   f0106789 <cpunum>
f0103db0:	6b c0 74             	imul   $0x74,%eax,%eax
f0103db3:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0103db9:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
			curenv->env_runs = curenv->env_runs+1;
f0103dc0:	e8 c4 29 00 00       	call   f0106789 <cpunum>
f0103dc5:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dc8:	8b 98 28 90 31 f0    	mov    -0xfce6fd8(%eax),%ebx
f0103dce:	e8 b6 29 00 00       	call   f0106789 <cpunum>
f0103dd3:	6b c0 74             	imul   $0x74,%eax,%eax
f0103dd6:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0103ddc:	8b 40 58             	mov    0x58(%eax),%eax
f0103ddf:	83 c0 01             	add    $0x1,%eax
f0103de2:	89 43 58             	mov    %eax,0x58(%ebx)
			lcr3(PADDR(curenv->env_pgdir));
f0103de5:	e8 9f 29 00 00       	call   f0106789 <cpunum>
f0103dea:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ded:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0103df3:	8b 40 60             	mov    0x60(%eax),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103df6:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103dfb:	77 20                	ja     f0103e1d <env_run+0xc4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103dfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103e01:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0103e08:	f0 
f0103e09:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
f0103e10:	00 
f0103e11:	c7 04 24 f8 8b 10 f0 	movl   $0xf0108bf8,(%esp)
f0103e18:	e8 80 c2 ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103e1d:	05 00 00 00 10       	add    $0x10000000,%eax
f0103e22:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103e25:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f0103e2c:	e8 82 2c 00 00       	call   f0106ab3 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103e31:	f3 90                	pause  
			unlock_kernel();
			env_pop_tf(&(curenv->env_tf));
f0103e33:	e8 51 29 00 00       	call   f0106789 <cpunum>
f0103e38:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e3b:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0103e41:	89 04 24             	mov    %eax,(%esp)
f0103e44:	e8 cd fe ff ff       	call   f0103d16 <env_pop_tf>

f0103e49 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f0103e49:	55                   	push   %ebp
f0103e4a:	89 e5                	mov    %esp,%ebp
f0103e4c:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103e50:	ba 70 00 00 00       	mov    $0x70,%edx
f0103e55:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103e56:	b2 71                	mov    $0x71,%dl
f0103e58:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103e59:	0f b6 c0             	movzbl %al,%eax
}
f0103e5c:	5d                   	pop    %ebp
f0103e5d:	c3                   	ret    

f0103e5e <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103e5e:	55                   	push   %ebp
f0103e5f:	89 e5                	mov    %esp,%ebp
f0103e61:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103e65:	ba 70 00 00 00       	mov    $0x70,%edx
f0103e6a:	ee                   	out    %al,(%dx)
f0103e6b:	b2 71                	mov    $0x71,%dl
f0103e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103e70:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103e71:	5d                   	pop    %ebp
f0103e72:	c3                   	ret    

f0103e73 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0103e73:	55                   	push   %ebp
f0103e74:	89 e5                	mov    %esp,%ebp
f0103e76:	56                   	push   %esi
f0103e77:	53                   	push   %ebx
f0103e78:	83 ec 10             	sub    $0x10,%esp
f0103e7b:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
f0103e7e:	66 a3 a8 43 12 f0    	mov    %ax,0xf01243a8
	if (!didinit)
f0103e84:	80 3d 50 82 2b f0 00 	cmpb   $0x0,0xf02b8250
f0103e8b:	74 4e                	je     f0103edb <irq_setmask_8259A+0x68>
f0103e8d:	89 c6                	mov    %eax,%esi
f0103e8f:	ba 21 00 00 00       	mov    $0x21,%edx
f0103e94:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f0103e95:	66 c1 e8 08          	shr    $0x8,%ax
f0103e99:	b2 a1                	mov    $0xa1,%dl
f0103e9b:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0103e9c:	c7 04 24 6b 8c 10 f0 	movl   $0xf0108c6b,(%esp)
f0103ea3:	e8 1d 01 00 00       	call   f0103fc5 <cprintf>
	for (i = 0; i < 16; i++)
f0103ea8:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f0103ead:	0f b7 f6             	movzwl %si,%esi
f0103eb0:	f7 d6                	not    %esi
f0103eb2:	0f a3 de             	bt     %ebx,%esi
f0103eb5:	73 10                	jae    f0103ec7 <irq_setmask_8259A+0x54>
			cprintf(" %d", i);
f0103eb7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103ebb:	c7 04 24 6e 91 10 f0 	movl   $0xf010916e,(%esp)
f0103ec2:	e8 fe 00 00 00       	call   f0103fc5 <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f0103ec7:	83 c3 01             	add    $0x1,%ebx
f0103eca:	83 fb 10             	cmp    $0x10,%ebx
f0103ecd:	75 e3                	jne    f0103eb2 <irq_setmask_8259A+0x3f>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f0103ecf:	c7 04 24 db 97 10 f0 	movl   $0xf01097db,(%esp)
f0103ed6:	e8 ea 00 00 00       	call   f0103fc5 <cprintf>
}
f0103edb:	83 c4 10             	add    $0x10,%esp
f0103ede:	5b                   	pop    %ebx
f0103edf:	5e                   	pop    %esi
f0103ee0:	5d                   	pop    %ebp
f0103ee1:	c3                   	ret    

f0103ee2 <pic_init>:

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
f0103ee2:	c6 05 50 82 2b f0 01 	movb   $0x1,0xf02b8250
f0103ee9:	ba 21 00 00 00       	mov    $0x21,%edx
f0103eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0103ef3:	ee                   	out    %al,(%dx)
f0103ef4:	b2 a1                	mov    $0xa1,%dl
f0103ef6:	ee                   	out    %al,(%dx)
f0103ef7:	b2 20                	mov    $0x20,%dl
f0103ef9:	b8 11 00 00 00       	mov    $0x11,%eax
f0103efe:	ee                   	out    %al,(%dx)
f0103eff:	b2 21                	mov    $0x21,%dl
f0103f01:	b8 20 00 00 00       	mov    $0x20,%eax
f0103f06:	ee                   	out    %al,(%dx)
f0103f07:	b8 04 00 00 00       	mov    $0x4,%eax
f0103f0c:	ee                   	out    %al,(%dx)
f0103f0d:	b8 03 00 00 00       	mov    $0x3,%eax
f0103f12:	ee                   	out    %al,(%dx)
f0103f13:	b2 a0                	mov    $0xa0,%dl
f0103f15:	b8 11 00 00 00       	mov    $0x11,%eax
f0103f1a:	ee                   	out    %al,(%dx)
f0103f1b:	b2 a1                	mov    $0xa1,%dl
f0103f1d:	b8 28 00 00 00       	mov    $0x28,%eax
f0103f22:	ee                   	out    %al,(%dx)
f0103f23:	b8 02 00 00 00       	mov    $0x2,%eax
f0103f28:	ee                   	out    %al,(%dx)
f0103f29:	b8 01 00 00 00       	mov    $0x1,%eax
f0103f2e:	ee                   	out    %al,(%dx)
f0103f2f:	b2 20                	mov    $0x20,%dl
f0103f31:	b8 68 00 00 00       	mov    $0x68,%eax
f0103f36:	ee                   	out    %al,(%dx)
f0103f37:	b8 0a 00 00 00       	mov    $0xa,%eax
f0103f3c:	ee                   	out    %al,(%dx)
f0103f3d:	b2 a0                	mov    $0xa0,%dl
f0103f3f:	b8 68 00 00 00       	mov    $0x68,%eax
f0103f44:	ee                   	out    %al,(%dx)
f0103f45:	b8 0a 00 00 00       	mov    $0xa,%eax
f0103f4a:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0103f4b:	0f b7 05 a8 43 12 f0 	movzwl 0xf01243a8,%eax
f0103f52:	66 83 f8 ff          	cmp    $0xffff,%ax
f0103f56:	74 12                	je     f0103f6a <pic_init+0x88>
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0103f58:	55                   	push   %ebp
f0103f59:	89 e5                	mov    %esp,%ebp
f0103f5b:	83 ec 18             	sub    $0x18,%esp

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
		irq_setmask_8259A(irq_mask_8259A);
f0103f5e:	0f b7 c0             	movzwl %ax,%eax
f0103f61:	89 04 24             	mov    %eax,(%esp)
f0103f64:	e8 0a ff ff ff       	call   f0103e73 <irq_setmask_8259A>
}
f0103f69:	c9                   	leave  
f0103f6a:	f3 c3                	repz ret 

f0103f6c <irq_eoi>:
}


void
irq_eoi(void)
{
f0103f6c:	55                   	push   %ebp
f0103f6d:	89 e5                	mov    %esp,%ebp
f0103f6f:	ba 20 00 00 00       	mov    $0x20,%edx
f0103f74:	b8 20 00 00 00       	mov    $0x20,%eax
f0103f79:	ee                   	out    %al,(%dx)
f0103f7a:	b2 a0                	mov    $0xa0,%dl
f0103f7c:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f0103f7d:	5d                   	pop    %ebp
f0103f7e:	c3                   	ret    

f0103f7f <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103f7f:	55                   	push   %ebp
f0103f80:	89 e5                	mov    %esp,%ebp
f0103f82:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f0103f85:	8b 45 08             	mov    0x8(%ebp),%eax
f0103f88:	89 04 24             	mov    %eax,(%esp)
f0103f8b:	e8 97 c8 ff ff       	call   f0100827 <cputchar>
	*cnt++;
}
f0103f90:	c9                   	leave  
f0103f91:	c3                   	ret    

f0103f92 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103f92:	55                   	push   %ebp
f0103f93:	89 e5                	mov    %esp,%ebp
f0103f95:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0103f98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103fa2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103fa6:	8b 45 08             	mov    0x8(%ebp),%eax
f0103fa9:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103fad:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103fb4:	c7 04 24 7f 3f 10 f0 	movl   $0xf0103f7f,(%esp)
f0103fbb:	e8 ae 1a 00 00       	call   f0105a6e <vprintfmt>
	return cnt;
}
f0103fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103fc3:	c9                   	leave  
f0103fc4:	c3                   	ret    

f0103fc5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103fc5:	55                   	push   %ebp
f0103fc6:	89 e5                	mov    %esp,%ebp
f0103fc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103fcb:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103fce:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103fd2:	8b 45 08             	mov    0x8(%ebp),%eax
f0103fd5:	89 04 24             	mov    %eax,(%esp)
f0103fd8:	e8 b5 ff ff ff       	call   f0103f92 <vcprintf>
	va_end(ap);

	return cnt;
}
f0103fdd:	c9                   	leave  
f0103fde:	c3                   	ret    
f0103fdf:	90                   	nop

f0103fe0 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103fe0:	55                   	push   %ebp
f0103fe1:	89 e5                	mov    %esp,%ebp
f0103fe3:	57                   	push   %edi
f0103fe4:	56                   	push   %esi
f0103fe5:	53                   	push   %ebx
f0103fe6:	83 ec 0c             	sub    $0xc,%esp
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.

	thiscpu->cpu_ts.ts_esp0 = (uint32_t)percpu_kstacks[thiscpu->cpu_id]+KSTKSIZE;
f0103fe9:	e8 9b 27 00 00       	call   f0106789 <cpunum>
f0103fee:	89 c3                	mov    %eax,%ebx
f0103ff0:	e8 94 27 00 00       	call   f0106789 <cpunum>
f0103ff5:	6b db 74             	imul   $0x74,%ebx,%ebx
f0103ff8:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ffb:	0f b6 80 20 90 31 f0 	movzbl -0xfce6fe0(%eax),%eax
f0104002:	c1 e0 0f             	shl    $0xf,%eax
f0104005:	05 00 20 32 f0       	add    $0xf0322000,%eax
f010400a:	89 83 30 90 31 f0    	mov    %eax,-0xfce6fd0(%ebx)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0104010:	e8 74 27 00 00       	call   f0106789 <cpunum>
f0104015:	6b c0 74             	imul   $0x74,%eax,%eax
f0104018:	66 c7 80 34 90 31 f0 	movw   $0x10,-0xfce6fcc(%eax)
f010401f:	10 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3)+thiscpu->cpu_id] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f0104021:	e8 63 27 00 00       	call   f0106789 <cpunum>
f0104026:	6b c0 74             	imul   $0x74,%eax,%eax
f0104029:	0f b6 98 20 90 31 f0 	movzbl -0xfce6fe0(%eax),%ebx
f0104030:	83 c3 05             	add    $0x5,%ebx
f0104033:	e8 51 27 00 00       	call   f0106789 <cpunum>
f0104038:	89 c7                	mov    %eax,%edi
f010403a:	e8 4a 27 00 00       	call   f0106789 <cpunum>
f010403f:	89 c6                	mov    %eax,%esi
f0104041:	e8 43 27 00 00       	call   f0106789 <cpunum>
f0104046:	66 c7 04 dd 40 43 12 	movw   $0x67,-0xfedbcc0(,%ebx,8)
f010404d:	f0 67 00 
f0104050:	6b ff 74             	imul   $0x74,%edi,%edi
f0104053:	81 c7 2c 90 31 f0    	add    $0xf031902c,%edi
f0104059:	66 89 3c dd 42 43 12 	mov    %di,-0xfedbcbe(,%ebx,8)
f0104060:	f0 
f0104061:	6b d6 74             	imul   $0x74,%esi,%edx
f0104064:	81 c2 2c 90 31 f0    	add    $0xf031902c,%edx
f010406a:	c1 ea 10             	shr    $0x10,%edx
f010406d:	88 14 dd 44 43 12 f0 	mov    %dl,-0xfedbcbc(,%ebx,8)
f0104074:	c6 04 dd 45 43 12 f0 	movb   $0x99,-0xfedbcbb(,%ebx,8)
f010407b:	99 
f010407c:	c6 04 dd 46 43 12 f0 	movb   $0x40,-0xfedbcba(,%ebx,8)
f0104083:	40 
f0104084:	6b c0 74             	imul   $0x74,%eax,%eax
f0104087:	05 2c 90 31 f0       	add    $0xf031902c,%eax
f010408c:	c1 e8 18             	shr    $0x18,%eax
f010408f:	88 04 dd 47 43 12 f0 	mov    %al,-0xfedbcb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3)+thiscpu->cpu_id].sd_s = 0;
f0104096:	e8 ee 26 00 00       	call   f0106789 <cpunum>
f010409b:	6b c0 74             	imul   $0x74,%eax,%eax
f010409e:	0f b6 80 20 90 31 f0 	movzbl -0xfce6fe0(%eax),%eax
f01040a5:	80 24 c5 6d 43 12 f0 	andb   $0xef,-0xfedbc93(,%eax,8)
f01040ac:	ef 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0+thiscpu->cpu_id*sizeof(struct Segdesc));
f01040ad:	e8 d7 26 00 00       	call   f0106789 <cpunum>
f01040b2:	6b c0 74             	imul   $0x74,%eax,%eax
f01040b5:	0f b6 80 20 90 31 f0 	movzbl -0xfce6fe0(%eax),%eax
f01040bc:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f01040c3:	0f 00 d8             	ltr    %ax
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
f01040c6:	b8 aa 43 12 f0       	mov    $0xf01243aa,%eax
f01040cb:	0f 01 18             	lidtl  (%eax)



	// Load the IDT
	lidt(&idt_pd);
}
f01040ce:	83 c4 0c             	add    $0xc,%esp
f01040d1:	5b                   	pop    %ebx
f01040d2:	5e                   	pop    %esi
f01040d3:	5f                   	pop    %edi
f01040d4:	5d                   	pop    %ebp
f01040d5:	c3                   	ret    

f01040d6 <trap_init>:
}


void
trap_init(void)
{
f01040d6:	55                   	push   %ebp
f01040d7:	89 e5                	mov    %esp,%ebp
f01040d9:	83 ec 08             	sub    $0x8,%esp
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.


	SETGATE(idt[T_DIVIDE],0,GD_KT,T_DIVIDE_HANDLER,0);
f01040dc:	b8 7c 4b 10 f0       	mov    $0xf0104b7c,%eax
f01040e1:	66 a3 60 82 2b f0    	mov    %ax,0xf02b8260
f01040e7:	66 c7 05 62 82 2b f0 	movw   $0x8,0xf02b8262
f01040ee:	08 00 
f01040f0:	c6 05 64 82 2b f0 00 	movb   $0x0,0xf02b8264
f01040f7:	c6 05 65 82 2b f0 8e 	movb   $0x8e,0xf02b8265
f01040fe:	c1 e8 10             	shr    $0x10,%eax
f0104101:	66 a3 66 82 2b f0    	mov    %ax,0xf02b8266
	SETGATE(idt[T_DEBUG],0,GD_KT,T_DEBUG_HANDLER,0);
f0104107:	b8 86 4b 10 f0       	mov    $0xf0104b86,%eax
f010410c:	66 a3 68 82 2b f0    	mov    %ax,0xf02b8268
f0104112:	66 c7 05 6a 82 2b f0 	movw   $0x8,0xf02b826a
f0104119:	08 00 
f010411b:	c6 05 6c 82 2b f0 00 	movb   $0x0,0xf02b826c
f0104122:	c6 05 6d 82 2b f0 8e 	movb   $0x8e,0xf02b826d
f0104129:	c1 e8 10             	shr    $0x10,%eax
f010412c:	66 a3 6e 82 2b f0    	mov    %ax,0xf02b826e
	SETGATE(idt[T_NMI],0,GD_KT,T_NMI_HANDLER,0);
f0104132:	b8 90 4b 10 f0       	mov    $0xf0104b90,%eax
f0104137:	66 a3 70 82 2b f0    	mov    %ax,0xf02b8270
f010413d:	66 c7 05 72 82 2b f0 	movw   $0x8,0xf02b8272
f0104144:	08 00 
f0104146:	c6 05 74 82 2b f0 00 	movb   $0x0,0xf02b8274
f010414d:	c6 05 75 82 2b f0 8e 	movb   $0x8e,0xf02b8275
f0104154:	c1 e8 10             	shr    $0x10,%eax
f0104157:	66 a3 76 82 2b f0    	mov    %ax,0xf02b8276
	SETGATE(idt[T_BRKPT],0,GD_KT,T_BRKPT_HANDLER,3);
f010415d:	b8 9a 4b 10 f0       	mov    $0xf0104b9a,%eax
f0104162:	66 a3 78 82 2b f0    	mov    %ax,0xf02b8278
f0104168:	66 c7 05 7a 82 2b f0 	movw   $0x8,0xf02b827a
f010416f:	08 00 
f0104171:	c6 05 7c 82 2b f0 00 	movb   $0x0,0xf02b827c
f0104178:	c6 05 7d 82 2b f0 ee 	movb   $0xee,0xf02b827d
f010417f:	c1 e8 10             	shr    $0x10,%eax
f0104182:	66 a3 7e 82 2b f0    	mov    %ax,0xf02b827e
	SETGATE(idt[T_OFLOW],0,GD_KT,T_OFLOW_HANDLER,0);
f0104188:	b8 a0 4b 10 f0       	mov    $0xf0104ba0,%eax
f010418d:	66 a3 80 82 2b f0    	mov    %ax,0xf02b8280
f0104193:	66 c7 05 82 82 2b f0 	movw   $0x8,0xf02b8282
f010419a:	08 00 
f010419c:	c6 05 84 82 2b f0 00 	movb   $0x0,0xf02b8284
f01041a3:	c6 05 85 82 2b f0 8e 	movb   $0x8e,0xf02b8285
f01041aa:	c1 e8 10             	shr    $0x10,%eax
f01041ad:	66 a3 86 82 2b f0    	mov    %ax,0xf02b8286
	SETGATE(idt[T_BOUND],0,GD_KT,T_BOUND_HANDLER,0);
f01041b3:	b8 a6 4b 10 f0       	mov    $0xf0104ba6,%eax
f01041b8:	66 a3 88 82 2b f0    	mov    %ax,0xf02b8288
f01041be:	66 c7 05 8a 82 2b f0 	movw   $0x8,0xf02b828a
f01041c5:	08 00 
f01041c7:	c6 05 8c 82 2b f0 00 	movb   $0x0,0xf02b828c
f01041ce:	c6 05 8d 82 2b f0 8e 	movb   $0x8e,0xf02b828d
f01041d5:	c1 e8 10             	shr    $0x10,%eax
f01041d8:	66 a3 8e 82 2b f0    	mov    %ax,0xf02b828e
	SETGATE(idt[T_ILLOP],0,GD_KT,T_ILLOP_HANDLER,0);
f01041de:	b8 ac 4b 10 f0       	mov    $0xf0104bac,%eax
f01041e3:	66 a3 90 82 2b f0    	mov    %ax,0xf02b8290
f01041e9:	66 c7 05 92 82 2b f0 	movw   $0x8,0xf02b8292
f01041f0:	08 00 
f01041f2:	c6 05 94 82 2b f0 00 	movb   $0x0,0xf02b8294
f01041f9:	c6 05 95 82 2b f0 8e 	movb   $0x8e,0xf02b8295
f0104200:	c1 e8 10             	shr    $0x10,%eax
f0104203:	66 a3 96 82 2b f0    	mov    %ax,0xf02b8296
	SETGATE(idt[T_DEVICE],0,GD_KT,T_DEVICE_HANDLER,0);
f0104209:	b8 b2 4b 10 f0       	mov    $0xf0104bb2,%eax
f010420e:	66 a3 98 82 2b f0    	mov    %ax,0xf02b8298
f0104214:	66 c7 05 9a 82 2b f0 	movw   $0x8,0xf02b829a
f010421b:	08 00 
f010421d:	c6 05 9c 82 2b f0 00 	movb   $0x0,0xf02b829c
f0104224:	c6 05 9d 82 2b f0 8e 	movb   $0x8e,0xf02b829d
f010422b:	c1 e8 10             	shr    $0x10,%eax
f010422e:	66 a3 9e 82 2b f0    	mov    %ax,0xf02b829e
	SETGATE(idt[T_DBLFLT],0,GD_KT,T_DBLFLT_HANDLER,0);
f0104234:	b8 b8 4b 10 f0       	mov    $0xf0104bb8,%eax
f0104239:	66 a3 a0 82 2b f0    	mov    %ax,0xf02b82a0
f010423f:	66 c7 05 a2 82 2b f0 	movw   $0x8,0xf02b82a2
f0104246:	08 00 
f0104248:	c6 05 a4 82 2b f0 00 	movb   $0x0,0xf02b82a4
f010424f:	c6 05 a5 82 2b f0 8e 	movb   $0x8e,0xf02b82a5
f0104256:	c1 e8 10             	shr    $0x10,%eax
f0104259:	66 a3 a6 82 2b f0    	mov    %ax,0xf02b82a6
	SETGATE(idt[T_TSS],0,GD_KT,T_TSS_HANDLER,0);
f010425f:	b8 bc 4b 10 f0       	mov    $0xf0104bbc,%eax
f0104264:	66 a3 b0 82 2b f0    	mov    %ax,0xf02b82b0
f010426a:	66 c7 05 b2 82 2b f0 	movw   $0x8,0xf02b82b2
f0104271:	08 00 
f0104273:	c6 05 b4 82 2b f0 00 	movb   $0x0,0xf02b82b4
f010427a:	c6 05 b5 82 2b f0 8e 	movb   $0x8e,0xf02b82b5
f0104281:	c1 e8 10             	shr    $0x10,%eax
f0104284:	66 a3 b6 82 2b f0    	mov    %ax,0xf02b82b6
	SETGATE(idt[T_SEGNP],0,GD_KT,T_SEGNP_HANDLER,0);
f010428a:	b8 c2 4b 10 f0       	mov    $0xf0104bc2,%eax
f010428f:	66 a3 b8 82 2b f0    	mov    %ax,0xf02b82b8
f0104295:	66 c7 05 ba 82 2b f0 	movw   $0x8,0xf02b82ba
f010429c:	08 00 
f010429e:	c6 05 bc 82 2b f0 00 	movb   $0x0,0xf02b82bc
f01042a5:	c6 05 bd 82 2b f0 8e 	movb   $0x8e,0xf02b82bd
f01042ac:	c1 e8 10             	shr    $0x10,%eax
f01042af:	66 a3 be 82 2b f0    	mov    %ax,0xf02b82be
	SETGATE(idt[T_STACK],0,GD_KT,T_STACK_HANDLER,0);
f01042b5:	b8 c6 4b 10 f0       	mov    $0xf0104bc6,%eax
f01042ba:	66 a3 c0 82 2b f0    	mov    %ax,0xf02b82c0
f01042c0:	66 c7 05 c2 82 2b f0 	movw   $0x8,0xf02b82c2
f01042c7:	08 00 
f01042c9:	c6 05 c4 82 2b f0 00 	movb   $0x0,0xf02b82c4
f01042d0:	c6 05 c5 82 2b f0 8e 	movb   $0x8e,0xf02b82c5
f01042d7:	c1 e8 10             	shr    $0x10,%eax
f01042da:	66 a3 c6 82 2b f0    	mov    %ax,0xf02b82c6
	SETGATE(idt[T_GPFLT],0,GD_KT,T_GPFLT_HANDLER,0);
f01042e0:	b8 ca 4b 10 f0       	mov    $0xf0104bca,%eax
f01042e5:	66 a3 c8 82 2b f0    	mov    %ax,0xf02b82c8
f01042eb:	66 c7 05 ca 82 2b f0 	movw   $0x8,0xf02b82ca
f01042f2:	08 00 
f01042f4:	c6 05 cc 82 2b f0 00 	movb   $0x0,0xf02b82cc
f01042fb:	c6 05 cd 82 2b f0 8e 	movb   $0x8e,0xf02b82cd
f0104302:	c1 e8 10             	shr    $0x10,%eax
f0104305:	66 a3 ce 82 2b f0    	mov    %ax,0xf02b82ce
	SETGATE(idt[T_PGFLT],0,GD_KT,T_PGFLT_HANDLER,0);
f010430b:	b8 ce 4b 10 f0       	mov    $0xf0104bce,%eax
f0104310:	66 a3 d0 82 2b f0    	mov    %ax,0xf02b82d0
f0104316:	66 c7 05 d2 82 2b f0 	movw   $0x8,0xf02b82d2
f010431d:	08 00 
f010431f:	c6 05 d4 82 2b f0 00 	movb   $0x0,0xf02b82d4
f0104326:	c6 05 d5 82 2b f0 8e 	movb   $0x8e,0xf02b82d5
f010432d:	c1 e8 10             	shr    $0x10,%eax
f0104330:	66 a3 d6 82 2b f0    	mov    %ax,0xf02b82d6
	SETGATE(idt[T_FPERR],0,GD_KT,T_FPERR_HANDLER,0);
f0104336:	b8 d2 4b 10 f0       	mov    $0xf0104bd2,%eax
f010433b:	66 a3 e0 82 2b f0    	mov    %ax,0xf02b82e0
f0104341:	66 c7 05 e2 82 2b f0 	movw   $0x8,0xf02b82e2
f0104348:	08 00 
f010434a:	c6 05 e4 82 2b f0 00 	movb   $0x0,0xf02b82e4
f0104351:	c6 05 e5 82 2b f0 8e 	movb   $0x8e,0xf02b82e5
f0104358:	c1 e8 10             	shr    $0x10,%eax
f010435b:	66 a3 e6 82 2b f0    	mov    %ax,0xf02b82e6
	SETGATE(idt[T_ALIGN],0,GD_KT,T_ALIGN_HANDLER,0);
f0104361:	b8 d6 4b 10 f0       	mov    $0xf0104bd6,%eax
f0104366:	66 a3 e8 82 2b f0    	mov    %ax,0xf02b82e8
f010436c:	66 c7 05 ea 82 2b f0 	movw   $0x8,0xf02b82ea
f0104373:	08 00 
f0104375:	c6 05 ec 82 2b f0 00 	movb   $0x0,0xf02b82ec
f010437c:	c6 05 ed 82 2b f0 8e 	movb   $0x8e,0xf02b82ed
f0104383:	c1 e8 10             	shr    $0x10,%eax
f0104386:	66 a3 ee 82 2b f0    	mov    %ax,0xf02b82ee
	SETGATE(idt[T_MCHK],0,GD_KT,T_MCHK_HANDLER,0);
f010438c:	b8 dc 4b 10 f0       	mov    $0xf0104bdc,%eax
f0104391:	66 a3 f0 82 2b f0    	mov    %ax,0xf02b82f0
f0104397:	66 c7 05 f2 82 2b f0 	movw   $0x8,0xf02b82f2
f010439e:	08 00 
f01043a0:	c6 05 f4 82 2b f0 00 	movb   $0x0,0xf02b82f4
f01043a7:	c6 05 f5 82 2b f0 8e 	movb   $0x8e,0xf02b82f5
f01043ae:	c1 e8 10             	shr    $0x10,%eax
f01043b1:	66 a3 f6 82 2b f0    	mov    %ax,0xf02b82f6
	SETGATE(idt[T_SIMDERR],0,GD_KT,T_SIMDERR_HANDLER,0);
f01043b7:	b8 e2 4b 10 f0       	mov    $0xf0104be2,%eax
f01043bc:	66 a3 f8 82 2b f0    	mov    %ax,0xf02b82f8
f01043c2:	66 c7 05 fa 82 2b f0 	movw   $0x8,0xf02b82fa
f01043c9:	08 00 
f01043cb:	c6 05 fc 82 2b f0 00 	movb   $0x0,0xf02b82fc
f01043d2:	c6 05 fd 82 2b f0 8e 	movb   $0x8e,0xf02b82fd
f01043d9:	c1 e8 10             	shr    $0x10,%eax
f01043dc:	66 a3 fe 82 2b f0    	mov    %ax,0xf02b82fe
	SETGATE(idt[T_SYSCALL],0,GD_KT,T_SYSCALL_HANDLER,3);
f01043e2:	b8 e6 4b 10 f0       	mov    $0xf0104be6,%eax
f01043e7:	66 a3 e0 83 2b f0    	mov    %ax,0xf02b83e0
f01043ed:	66 c7 05 e2 83 2b f0 	movw   $0x8,0xf02b83e2
f01043f4:	08 00 
f01043f6:	c6 05 e4 83 2b f0 00 	movb   $0x0,0xf02b83e4
f01043fd:	c6 05 e5 83 2b f0 ee 	movb   $0xee,0xf02b83e5
f0104404:	c1 e8 10             	shr    $0x10,%eax
f0104407:	66 a3 e6 83 2b f0    	mov    %ax,0xf02b83e6
	SETGATE(idt[T_DEFAULT],0,GD_KT,T_DEFAULT_HANDLER,0);
f010440d:	b8 ec 4b 10 f0       	mov    $0xf0104bec,%eax
f0104412:	66 a3 00 92 2b f0    	mov    %ax,0xf02b9200
f0104418:	66 c7 05 02 92 2b f0 	movw   $0x8,0xf02b9202
f010441f:	08 00 
f0104421:	c6 05 04 92 2b f0 00 	movb   $0x0,0xf02b9204
f0104428:	c6 05 05 92 2b f0 8e 	movb   $0x8e,0xf02b9205
f010442f:	c1 e8 10             	shr    $0x10,%eax
f0104432:	66 a3 06 92 2b f0    	mov    %ax,0xf02b9206
	SETGATE(idt[IRQ_OFFSET+IRQ_TIMER],0,GD_KT,IRQ_TIMER_HANDLER,0);
f0104438:	b8 f6 4b 10 f0       	mov    $0xf0104bf6,%eax
f010443d:	66 a3 60 83 2b f0    	mov    %ax,0xf02b8360
f0104443:	66 c7 05 62 83 2b f0 	movw   $0x8,0xf02b8362
f010444a:	08 00 
f010444c:	c6 05 64 83 2b f0 00 	movb   $0x0,0xf02b8364
f0104453:	c6 05 65 83 2b f0 8e 	movb   $0x8e,0xf02b8365
f010445a:	c1 e8 10             	shr    $0x10,%eax
f010445d:	66 a3 66 83 2b f0    	mov    %ax,0xf02b8366
	SETGATE(idt[IRQ_OFFSET+IRQ_KBD],0,GD_KT,IRQ_KBD_HANDLER,0);
f0104463:	b8 fc 4b 10 f0       	mov    $0xf0104bfc,%eax
f0104468:	66 a3 68 83 2b f0    	mov    %ax,0xf02b8368
f010446e:	66 c7 05 6a 83 2b f0 	movw   $0x8,0xf02b836a
f0104475:	08 00 
f0104477:	c6 05 6c 83 2b f0 00 	movb   $0x0,0xf02b836c
f010447e:	c6 05 6d 83 2b f0 8e 	movb   $0x8e,0xf02b836d
f0104485:	c1 e8 10             	shr    $0x10,%eax
f0104488:	66 a3 6e 83 2b f0    	mov    %ax,0xf02b836e
	SETGATE(idt[IRQ_OFFSET+IRQ_SERIAL],0,GD_KT,IRQ_SERIAL_HANDLER,0);
f010448e:	b8 02 4c 10 f0       	mov    $0xf0104c02,%eax
f0104493:	66 a3 80 83 2b f0    	mov    %ax,0xf02b8380
f0104499:	66 c7 05 82 83 2b f0 	movw   $0x8,0xf02b8382
f01044a0:	08 00 
f01044a2:	c6 05 84 83 2b f0 00 	movb   $0x0,0xf02b8384
f01044a9:	c6 05 85 83 2b f0 8e 	movb   $0x8e,0xf02b8385
f01044b0:	c1 e8 10             	shr    $0x10,%eax
f01044b3:	66 a3 86 83 2b f0    	mov    %ax,0xf02b8386
	SETGATE(idt[IRQ_OFFSET+IRQ_IDE],0,GD_KT,IRQ_IDE_HANDLER,0);
f01044b9:	b8 0e 4c 10 f0       	mov    $0xf0104c0e,%eax
f01044be:	66 a3 d0 83 2b f0    	mov    %ax,0xf02b83d0
f01044c4:	66 c7 05 d2 83 2b f0 	movw   $0x8,0xf02b83d2
f01044cb:	08 00 
f01044cd:	c6 05 d4 83 2b f0 00 	movb   $0x0,0xf02b83d4
f01044d4:	c6 05 d5 83 2b f0 8e 	movb   $0x8e,0xf02b83d5
f01044db:	c1 e8 10             	shr    $0x10,%eax
f01044de:	66 a3 d6 83 2b f0    	mov    %ax,0xf02b83d6
	SETGATE(idt[IRQ_OFFSET+IRQ_ERROR],0,GD_KT,IRQ_ERROR_HANDLER,0);
f01044e4:	b8 14 4c 10 f0       	mov    $0xf0104c14,%eax
f01044e9:	66 a3 f8 83 2b f0    	mov    %ax,0xf02b83f8
f01044ef:	66 c7 05 fa 83 2b f0 	movw   $0x8,0xf02b83fa
f01044f6:	08 00 
f01044f8:	c6 05 fc 83 2b f0 00 	movb   $0x0,0xf02b83fc
f01044ff:	c6 05 fd 83 2b f0 8e 	movb   $0x8e,0xf02b83fd
f0104506:	c1 e8 10             	shr    $0x10,%eax
f0104509:	66 a3 fe 83 2b f0    	mov    %ax,0xf02b83fe



	// Per-CPU setup 
	trap_init_percpu();
f010450f:	e8 cc fa ff ff       	call   f0103fe0 <trap_init_percpu>
}
f0104514:	c9                   	leave  
f0104515:	c3                   	ret    

f0104516 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0104516:	55                   	push   %ebp
f0104517:	89 e5                	mov    %esp,%ebp
f0104519:	53                   	push   %ebx
f010451a:	83 ec 14             	sub    $0x14,%esp
f010451d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0104520:	8b 03                	mov    (%ebx),%eax
f0104522:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104526:	c7 04 24 7f 8c 10 f0 	movl   $0xf0108c7f,(%esp)
f010452d:	e8 93 fa ff ff       	call   f0103fc5 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0104532:	8b 43 04             	mov    0x4(%ebx),%eax
f0104535:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104539:	c7 04 24 8e 8c 10 f0 	movl   $0xf0108c8e,(%esp)
f0104540:	e8 80 fa ff ff       	call   f0103fc5 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0104545:	8b 43 08             	mov    0x8(%ebx),%eax
f0104548:	89 44 24 04          	mov    %eax,0x4(%esp)
f010454c:	c7 04 24 9d 8c 10 f0 	movl   $0xf0108c9d,(%esp)
f0104553:	e8 6d fa ff ff       	call   f0103fc5 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104558:	8b 43 0c             	mov    0xc(%ebx),%eax
f010455b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010455f:	c7 04 24 ac 8c 10 f0 	movl   $0xf0108cac,(%esp)
f0104566:	e8 5a fa ff ff       	call   f0103fc5 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f010456b:	8b 43 10             	mov    0x10(%ebx),%eax
f010456e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104572:	c7 04 24 bb 8c 10 f0 	movl   $0xf0108cbb,(%esp)
f0104579:	e8 47 fa ff ff       	call   f0103fc5 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f010457e:	8b 43 14             	mov    0x14(%ebx),%eax
f0104581:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104585:	c7 04 24 ca 8c 10 f0 	movl   $0xf0108cca,(%esp)
f010458c:	e8 34 fa ff ff       	call   f0103fc5 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0104591:	8b 43 18             	mov    0x18(%ebx),%eax
f0104594:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104598:	c7 04 24 d9 8c 10 f0 	movl   $0xf0108cd9,(%esp)
f010459f:	e8 21 fa ff ff       	call   f0103fc5 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f01045a4:	8b 43 1c             	mov    0x1c(%ebx),%eax
f01045a7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01045ab:	c7 04 24 e8 8c 10 f0 	movl   $0xf0108ce8,(%esp)
f01045b2:	e8 0e fa ff ff       	call   f0103fc5 <cprintf>
}
f01045b7:	83 c4 14             	add    $0x14,%esp
f01045ba:	5b                   	pop    %ebx
f01045bb:	5d                   	pop    %ebp
f01045bc:	c3                   	ret    

f01045bd <print_trapframe>:
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
f01045bd:	55                   	push   %ebp
f01045be:	89 e5                	mov    %esp,%ebp
f01045c0:	56                   	push   %esi
f01045c1:	53                   	push   %ebx
f01045c2:	83 ec 10             	sub    $0x10,%esp
f01045c5:	8b 5d 08             	mov    0x8(%ebp),%ebx

	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f01045c8:	e8 bc 21 00 00       	call   f0106789 <cpunum>
f01045cd:	89 44 24 08          	mov    %eax,0x8(%esp)
f01045d1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01045d5:	c7 04 24 4c 8d 10 f0 	movl   $0xf0108d4c,(%esp)
f01045dc:	e8 e4 f9 ff ff       	call   f0103fc5 <cprintf>
	print_regs(&tf->tf_regs);
f01045e1:	89 1c 24             	mov    %ebx,(%esp)
f01045e4:	e8 2d ff ff ff       	call   f0104516 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f01045e9:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f01045ed:	89 44 24 04          	mov    %eax,0x4(%esp)
f01045f1:	c7 04 24 6a 8d 10 f0 	movl   $0xf0108d6a,(%esp)
f01045f8:	e8 c8 f9 ff ff       	call   f0103fc5 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01045fd:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104601:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104605:	c7 04 24 7d 8d 10 f0 	movl   $0xf0108d7d,(%esp)
f010460c:	e8 b4 f9 ff ff       	call   f0103fc5 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104611:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f0104614:	83 f8 13             	cmp    $0x13,%eax
f0104617:	77 09                	ja     f0104622 <print_trapframe+0x65>
		return excnames[trapno];
f0104619:	8b 14 85 00 90 10 f0 	mov    -0xfef7000(,%eax,4),%edx
f0104620:	eb 1f                	jmp    f0104641 <print_trapframe+0x84>
	if (trapno == T_SYSCALL)
f0104622:	83 f8 30             	cmp    $0x30,%eax
f0104625:	74 15                	je     f010463c <print_trapframe+0x7f>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104627:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f010462a:	83 fa 0f             	cmp    $0xf,%edx
f010462d:	ba 03 8d 10 f0       	mov    $0xf0108d03,%edx
f0104632:	b9 16 8d 10 f0       	mov    $0xf0108d16,%ecx
f0104637:	0f 47 d1             	cmova  %ecx,%edx
f010463a:	eb 05                	jmp    f0104641 <print_trapframe+0x84>
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
f010463c:	ba f7 8c 10 f0       	mov    $0xf0108cf7,%edx

	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104641:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104645:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104649:	c7 04 24 90 8d 10 f0 	movl   $0xf0108d90,(%esp)
f0104650:	e8 70 f9 ff ff       	call   f0103fc5 <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104655:	3b 1d 60 8a 2b f0    	cmp    0xf02b8a60,%ebx
f010465b:	75 19                	jne    f0104676 <print_trapframe+0xb9>
f010465d:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104661:	75 13                	jne    f0104676 <print_trapframe+0xb9>

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0104663:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104666:	89 44 24 04          	mov    %eax,0x4(%esp)
f010466a:	c7 04 24 a2 8d 10 f0 	movl   $0xf0108da2,(%esp)
f0104671:	e8 4f f9 ff ff       	call   f0103fc5 <cprintf>
	cprintf("  err  0x%08x", tf->tf_err);
f0104676:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104679:	89 44 24 04          	mov    %eax,0x4(%esp)
f010467d:	c7 04 24 b1 8d 10 f0 	movl   $0xf0108db1,(%esp)
f0104684:	e8 3c f9 ff ff       	call   f0103fc5 <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0104689:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f010468d:	75 51                	jne    f01046e0 <print_trapframe+0x123>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f010468f:	8b 43 2c             	mov    0x2c(%ebx),%eax
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
f0104692:	89 c2                	mov    %eax,%edx
f0104694:	83 e2 01             	and    $0x1,%edx
f0104697:	ba 25 8d 10 f0       	mov    $0xf0108d25,%edx
f010469c:	b9 30 8d 10 f0       	mov    $0xf0108d30,%ecx
f01046a1:	0f 45 ca             	cmovne %edx,%ecx
f01046a4:	89 c2                	mov    %eax,%edx
f01046a6:	83 e2 02             	and    $0x2,%edx
f01046a9:	ba 3c 8d 10 f0       	mov    $0xf0108d3c,%edx
f01046ae:	be 42 8d 10 f0       	mov    $0xf0108d42,%esi
f01046b3:	0f 44 d6             	cmove  %esi,%edx
f01046b6:	83 e0 04             	and    $0x4,%eax
f01046b9:	b8 47 8d 10 f0       	mov    $0xf0108d47,%eax
f01046be:	be 7c 8e 10 f0       	mov    $0xf0108e7c,%esi
f01046c3:	0f 44 c6             	cmove  %esi,%eax
f01046c6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f01046ca:	89 54 24 08          	mov    %edx,0x8(%esp)
f01046ce:	89 44 24 04          	mov    %eax,0x4(%esp)
f01046d2:	c7 04 24 bf 8d 10 f0 	movl   $0xf0108dbf,(%esp)
f01046d9:	e8 e7 f8 ff ff       	call   f0103fc5 <cprintf>
f01046de:	eb 0c                	jmp    f01046ec <print_trapframe+0x12f>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
f01046e0:	c7 04 24 db 97 10 f0 	movl   $0xf01097db,(%esp)
f01046e7:	e8 d9 f8 ff ff       	call   f0103fc5 <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f01046ec:	8b 43 30             	mov    0x30(%ebx),%eax
f01046ef:	89 44 24 04          	mov    %eax,0x4(%esp)
f01046f3:	c7 04 24 ce 8d 10 f0 	movl   $0xf0108dce,(%esp)
f01046fa:	e8 c6 f8 ff ff       	call   f0103fc5 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f01046ff:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104703:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104707:	c7 04 24 dd 8d 10 f0 	movl   $0xf0108ddd,(%esp)
f010470e:	e8 b2 f8 ff ff       	call   f0103fc5 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104713:	8b 43 38             	mov    0x38(%ebx),%eax
f0104716:	89 44 24 04          	mov    %eax,0x4(%esp)
f010471a:	c7 04 24 f0 8d 10 f0 	movl   $0xf0108df0,(%esp)
f0104721:	e8 9f f8 ff ff       	call   f0103fc5 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104726:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f010472a:	74 27                	je     f0104753 <print_trapframe+0x196>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f010472c:	8b 43 3c             	mov    0x3c(%ebx),%eax
f010472f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104733:	c7 04 24 ff 8d 10 f0 	movl   $0xf0108dff,(%esp)
f010473a:	e8 86 f8 ff ff       	call   f0103fc5 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f010473f:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104743:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104747:	c7 04 24 0e 8e 10 f0 	movl   $0xf0108e0e,(%esp)
f010474e:	e8 72 f8 ff ff       	call   f0103fc5 <cprintf>
	}
}
f0104753:	83 c4 10             	add    $0x10,%esp
f0104756:	5b                   	pop    %ebx
f0104757:	5e                   	pop    %esi
f0104758:	5d                   	pop    %ebp
f0104759:	c3                   	ret    

f010475a <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f010475a:	55                   	push   %ebp
f010475b:	89 e5                	mov    %esp,%ebp
f010475d:	57                   	push   %edi
f010475e:	56                   	push   %esi
f010475f:	53                   	push   %ebx
f0104760:	83 ec 2c             	sub    $0x2c,%esp
f0104763:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104766:	0f 20 d6             	mov    %cr2,%esi
	//cprintf("UXSTACKTOP %08x\n",UXSTACKTOP);
	if(tf->tf_cs && 1 ==0)
	{
		panic("Page Fault at kernel mode \n");
	}
	if(!(curenv->env_pgfault_upcall) ||(tf->tf_esp > USTACKTOP && tf->tf_esp <= (UXSTACKTOP - PGSIZE)))
f0104769:	e8 1b 20 00 00       	call   f0106789 <cpunum>
f010476e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104771:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104777:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f010477b:	74 11                	je     f010478e <page_fault_handler+0x34>
f010477d:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104780:	8d 90 ff 1f 40 11    	lea    0x11401fff(%eax),%edx
f0104786:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f010478c:	77 4f                	ja     f01047dd <page_fault_handler+0x83>
	{

	cprintf("[%08x] user fault va %08x ip %08x\n",
f010478e:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f0104791:	e8 f3 1f 00 00       	call   f0106789 <cpunum>
		panic("Page Fault at kernel mode \n");
	}
	if(!(curenv->env_pgfault_upcall) ||(tf->tf_esp > USTACKTOP && tf->tf_esp <= (UXSTACKTOP - PGSIZE)))
	{

	cprintf("[%08x] user fault va %08x ip %08x\n",
f0104796:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010479a:	89 74 24 08          	mov    %esi,0x8(%esp)
		curenv->env_id, fault_va, tf->tf_eip);
f010479e:	6b c0 74             	imul   $0x74,%eax,%eax
		panic("Page Fault at kernel mode \n");
	}
	if(!(curenv->env_pgfault_upcall) ||(tf->tf_esp > USTACKTOP && tf->tf_esp <= (UXSTACKTOP - PGSIZE)))
	{

	cprintf("[%08x] user fault va %08x ip %08x\n",
f01047a1:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01047a7:	8b 40 48             	mov    0x48(%eax),%eax
f01047aa:	89 44 24 04          	mov    %eax,0x4(%esp)
f01047ae:	c7 04 24 c8 8f 10 f0 	movl   $0xf0108fc8,(%esp)
f01047b5:	e8 0b f8 ff ff       	call   f0103fc5 <cprintf>
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
f01047ba:	89 1c 24             	mov    %ebx,(%esp)
f01047bd:	e8 fb fd ff ff       	call   f01045bd <print_trapframe>

	env_destroy(curenv);
f01047c2:	e8 c2 1f 00 00       	call   f0106789 <cpunum>
f01047c7:	6b c0 74             	imul   $0x74,%eax,%eax
f01047ca:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01047d0:	89 04 24             	mov    %eax,(%esp)
f01047d3:	e8 e0 f4 ff ff       	call   f0103cb8 <env_destroy>
f01047d8:	e9 1b 01 00 00       	jmp    f01048f8 <page_fault_handler+0x19e>
	}
	else
	{

		if((tf->tf_esp >= UXSTACKTOP-PGSIZE) && (tf->tf_esp<UXSTACKTOP))
f01047dd:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx

		else
		{

			exception_stack_size = sizeof(struct UTrapframe);
			top = UXSTACKTOP-exception_stack_size;
f01047e3:	c7 45 e4 cc ff bf ee 	movl   $0xeebfffcc,-0x1c(%ebp)
	env_destroy(curenv);
	}
	else
	{

		if((tf->tf_esp >= UXSTACKTOP-PGSIZE) && (tf->tf_esp<UXSTACKTOP))
f01047ea:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f01047f0:	77 4a                	ja     f010483c <page_fault_handler+0xe2>
		{
			exception_stack_size = sizeof(struct UTrapframe)+4;
			
			top = tf->tf_esp-exception_stack_size;
f01047f2:	83 e8 38             	sub    $0x38,%eax
f01047f5:	89 c7                	mov    %eax,%edi
f01047f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)

			exception_stack_size = sizeof(struct UTrapframe);
			top = UXSTACKTOP-exception_stack_size;
		}
		//cprintf("Top %08x\n",top);
		if(top<(UXSTACKTOP-PGSIZE))
f01047fa:	3d ff ef bf ee       	cmp    $0xeebfefff,%eax
f01047ff:	77 3b                	ja     f010483c <page_fault_handler+0xe2>
		{
			cprintf("[%08x] user_mem_check assertion failure for "
			"va %08x\n", curenv->env_id, top);
f0104801:	e8 83 1f 00 00       	call   f0106789 <cpunum>
			top = UXSTACKTOP-exception_stack_size;
		}
		//cprintf("Top %08x\n",top);
		if(top<(UXSTACKTOP-PGSIZE))
		{
			cprintf("[%08x] user_mem_check assertion failure for "
f0104806:	89 7c 24 08          	mov    %edi,0x8(%esp)
			"va %08x\n", curenv->env_id, top);
f010480a:	6b c0 74             	imul   $0x74,%eax,%eax
			top = UXSTACKTOP-exception_stack_size;
		}
		//cprintf("Top %08x\n",top);
		if(top<(UXSTACKTOP-PGSIZE))
		{
			cprintf("[%08x] user_mem_check assertion failure for "
f010480d:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104813:	8b 40 48             	mov    0x48(%eax),%eax
f0104816:	89 44 24 04          	mov    %eax,0x4(%esp)
f010481a:	c7 04 24 b0 8b 10 f0 	movl   $0xf0108bb0,(%esp)
f0104821:	e8 9f f7 ff ff       	call   f0103fc5 <cprintf>
			"va %08x\n", curenv->env_id, top);
			env_destroy(curenv);
f0104826:	e8 5e 1f 00 00       	call   f0106789 <cpunum>
f010482b:	6b c0 74             	imul   $0x74,%eax,%eax
f010482e:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104834:	89 04 24             	mov    %eax,(%esp)
f0104837:	e8 7c f4 ff ff       	call   f0103cb8 <env_destroy>
		}
		user_mem_assert(curenv,(void *)top,sizeof(struct UTrapframe),PTE_W|PTE_U);
f010483c:	e8 48 1f 00 00       	call   f0106789 <cpunum>
f0104841:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0104848:	00 
f0104849:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
f0104850:	00 
f0104851:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104854:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104858:	6b c0 74             	imul   $0x74,%eax,%eax
f010485b:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104861:	89 04 24             	mov    %eax,(%esp)
f0104864:	e8 47 ed ff ff       	call   f01035b0 <user_mem_assert>
		struct UTrapframe *ut = (struct UTrapframe*) top;
f0104869:	89 fa                	mov    %edi,%edx
		ut->utf_fault_va = fault_va;
f010486b:	89 37                	mov    %esi,(%edi)
		ut->utf_err =tf->tf_err;
f010486d:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104870:	89 47 04             	mov    %eax,0x4(%edi)
		ut->utf_regs = tf->tf_regs;
f0104873:	8d 7f 08             	lea    0x8(%edi),%edi
f0104876:	89 de                	mov    %ebx,%esi
f0104878:	b8 20 00 00 00       	mov    $0x20,%eax
f010487d:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0104883:	74 03                	je     f0104888 <page_fault_handler+0x12e>
f0104885:	a4                   	movsb  %ds:(%esi),%es:(%edi)
f0104886:	b0 1f                	mov    $0x1f,%al
f0104888:	f7 c7 02 00 00 00    	test   $0x2,%edi
f010488e:	74 05                	je     f0104895 <page_fault_handler+0x13b>
f0104890:	66 a5                	movsw  %ds:(%esi),%es:(%edi)
f0104892:	83 e8 02             	sub    $0x2,%eax
f0104895:	89 c1                	mov    %eax,%ecx
f0104897:	c1 e9 02             	shr    $0x2,%ecx
f010489a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010489c:	a8 02                	test   $0x2,%al
f010489e:	74 0b                	je     f01048ab <page_fault_handler+0x151>
f01048a0:	0f b7 0e             	movzwl (%esi),%ecx
f01048a3:	66 89 0f             	mov    %cx,(%edi)
f01048a6:	b9 02 00 00 00       	mov    $0x2,%ecx
f01048ab:	a8 01                	test   $0x1,%al
f01048ad:	74 07                	je     f01048b6 <page_fault_handler+0x15c>
f01048af:	0f b6 04 0e          	movzbl (%esi,%ecx,1),%eax
f01048b3:	88 04 0f             	mov    %al,(%edi,%ecx,1)
		ut->utf_eip = tf->tf_eip;
f01048b6:	8b 43 30             	mov    0x30(%ebx),%eax
f01048b9:	89 42 28             	mov    %eax,0x28(%edx)
		ut->utf_eflags = tf->tf_eflags;
f01048bc:	8b 43 38             	mov    0x38(%ebx),%eax
f01048bf:	89 42 2c             	mov    %eax,0x2c(%edx)
		ut->utf_esp = tf->tf_esp;
f01048c2:	8b 43 3c             	mov    0x3c(%ebx),%eax
f01048c5:	89 42 30             	mov    %eax,0x30(%edx)
		tf->tf_esp = (uint32_t)top;
f01048c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01048cb:	89 43 3c             	mov    %eax,0x3c(%ebx)
		tf->tf_eip = (uint32_t)curenv->env_pgfault_upcall;
f01048ce:	e8 b6 1e 00 00       	call   f0106789 <cpunum>
f01048d3:	6b c0 74             	imul   $0x74,%eax,%eax
f01048d6:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01048dc:	8b 40 64             	mov    0x64(%eax),%eax
f01048df:	89 43 30             	mov    %eax,0x30(%ebx)
		env_run(curenv);
f01048e2:	e8 a2 1e 00 00       	call   f0106789 <cpunum>
f01048e7:	6b c0 74             	imul   $0x74,%eax,%eax
f01048ea:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01048f0:	89 04 24             	mov    %eax,(%esp)
f01048f3:	e8 61 f4 ff ff       	call   f0103d59 <env_run>
	// the page fault happened in user mode.

	// Destroy the environment that caused the fault.
	

}
f01048f8:	83 c4 2c             	add    $0x2c,%esp
f01048fb:	5b                   	pop    %ebx
f01048fc:	5e                   	pop    %esi
f01048fd:	5f                   	pop    %edi
f01048fe:	5d                   	pop    %ebp
f01048ff:	c3                   	ret    

f0104900 <trap>:

}

void
trap(struct Trapframe *tf)
{
f0104900:	55                   	push   %ebp
f0104901:	89 e5                	mov    %esp,%ebp
f0104903:	57                   	push   %edi
f0104904:	56                   	push   %esi
f0104905:	83 ec 20             	sub    $0x20,%esp
f0104908:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f010490b:	fc                   	cld    


	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
f010490c:	83 3d c0 8e 2b f0 00 	cmpl   $0x0,0xf02b8ec0
f0104913:	74 01                	je     f0104916 <trap+0x16>
		asm volatile("hlt");
f0104915:	f4                   	hlt    

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104916:	e8 6e 1e 00 00       	call   f0106789 <cpunum>
f010491b:	6b d0 74             	imul   $0x74,%eax,%edx
f010491e:	81 c2 20 90 31 f0    	add    $0xf0319020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0104924:	b8 01 00 00 00       	mov    $0x1,%eax
f0104929:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f010492d:	83 f8 02             	cmp    $0x2,%eax
f0104930:	75 0c                	jne    f010493e <trap+0x3e>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0104932:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f0104939:	e8 c9 20 00 00       	call   f0106a07 <spin_lock>

static __inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	__asm __volatile("pushfl; popl %0" : "=r" (eflags));
f010493e:	9c                   	pushf  
f010493f:	58                   	pop    %eax
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0104940:	f6 c4 02             	test   $0x2,%ah
f0104943:	74 24                	je     f0104969 <trap+0x69>
f0104945:	c7 44 24 0c 21 8e 10 	movl   $0xf0108e21,0xc(%esp)
f010494c:	f0 
f010494d:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0104954:	f0 
f0104955:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
f010495c:	00 
f010495d:	c7 04 24 3a 8e 10 f0 	movl   $0xf0108e3a,(%esp)
f0104964:	e8 34 b7 ff ff       	call   f010009d <_panic>


	if ((tf->tf_cs & 3) == 3) {
f0104969:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f010496d:	83 e0 03             	and    $0x3,%eax
f0104970:	66 83 f8 03          	cmp    $0x3,%ax
f0104974:	0f 85 a7 00 00 00    	jne    f0104a21 <trap+0x121>
f010497a:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f0104981:	e8 81 20 00 00       	call   f0106a07 <spin_lock>
		// LAB 4: Your code here.


		lock_kernel();

		assert(curenv);
f0104986:	e8 fe 1d 00 00       	call   f0106789 <cpunum>
f010498b:	6b c0 74             	imul   $0x74,%eax,%eax
f010498e:	83 b8 28 90 31 f0 00 	cmpl   $0x0,-0xfce6fd8(%eax)
f0104995:	75 24                	jne    f01049bb <trap+0xbb>
f0104997:	c7 44 24 0c 46 8e 10 	movl   $0xf0108e46,0xc(%esp)
f010499e:	f0 
f010499f:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01049a6:	f0 
f01049a7:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
f01049ae:	00 
f01049af:	c7 04 24 3a 8e 10 f0 	movl   $0xf0108e3a,(%esp)
f01049b6:	e8 e2 b6 ff ff       	call   f010009d <_panic>

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
f01049bb:	e8 c9 1d 00 00       	call   f0106789 <cpunum>
f01049c0:	6b c0 74             	imul   $0x74,%eax,%eax
f01049c3:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01049c9:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f01049cd:	75 2d                	jne    f01049fc <trap+0xfc>
			env_free(curenv);
f01049cf:	e8 b5 1d 00 00       	call   f0106789 <cpunum>
f01049d4:	6b c0 74             	imul   $0x74,%eax,%eax
f01049d7:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01049dd:	89 04 24             	mov    %eax,(%esp)
f01049e0:	e8 ce f0 ff ff       	call   f0103ab3 <env_free>
			curenv = NULL;
f01049e5:	e8 9f 1d 00 00       	call   f0106789 <cpunum>
f01049ea:	6b c0 74             	imul   $0x74,%eax,%eax
f01049ed:	c7 80 28 90 31 f0 00 	movl   $0x0,-0xfce6fd8(%eax)
f01049f4:	00 00 00 
			sched_yield();
f01049f7:	e8 06 03 00 00       	call   f0104d02 <sched_yield>


		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f01049fc:	e8 88 1d 00 00       	call   f0106789 <cpunum>
f0104a01:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a04:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104a0a:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104a0f:	89 c7                	mov    %eax,%edi
f0104a11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0104a13:	e8 71 1d 00 00       	call   f0106789 <cpunum>
f0104a18:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a1b:	8b b0 28 90 31 f0    	mov    -0xfce6fd8(%eax),%esi
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f0104a21:	89 35 60 8a 2b f0    	mov    %esi,0xf02b8a60


	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104a27:	8b 46 28             	mov    0x28(%esi),%eax
f0104a2a:	83 f8 27             	cmp    $0x27,%eax
f0104a2d:	75 19                	jne    f0104a48 <trap+0x148>
		cprintf("Spurious interrupt on irq 7\n");
f0104a2f:	c7 04 24 4d 8e 10 f0 	movl   $0xf0108e4d,(%esp)
f0104a36:	e8 8a f5 ff ff       	call   f0103fc5 <cprintf>
		print_trapframe(tf);
f0104a3b:	89 34 24             	mov    %esi,(%esp)
f0104a3e:	e8 7a fb ff ff       	call   f01045bd <print_trapframe>
f0104a43:	e9 f3 00 00 00       	jmp    f0104b3b <trap+0x23b>

		// Unexpected trap: The user process or the kernel has a bug.
	int returncode;
	//print_trapframe(tf);
	//cprintf("%d\n",tf->tf_trapno);
	switch(tf->tf_trapno)
f0104a48:	83 f8 20             	cmp    $0x20,%eax
f0104a4b:	0f 84 7d 00 00 00    	je     f0104ace <trap+0x1ce>
f0104a51:	83 f8 20             	cmp    $0x20,%eax
f0104a54:	77 11                	ja     f0104a67 <trap+0x167>
f0104a56:	83 f8 03             	cmp    $0x3,%eax
f0104a59:	74 34                	je     f0104a8f <trap+0x18f>
f0104a5b:	83 f8 0e             	cmp    $0xe,%eax
f0104a5e:	66 90                	xchg   %ax,%ax
f0104a60:	74 20                	je     f0104a82 <trap+0x182>
f0104a62:	e9 9b 00 00 00       	jmp    f0104b02 <trap+0x202>
f0104a67:	83 f8 24             	cmp    $0x24,%eax
f0104a6a:	0f 84 82 00 00 00    	je     f0104af2 <trap+0x1f2>
f0104a70:	83 f8 30             	cmp    $0x30,%eax
f0104a73:	74 27                	je     f0104a9c <trap+0x19c>
f0104a75:	83 f8 21             	cmp    $0x21,%eax
f0104a78:	0f 85 84 00 00 00    	jne    f0104b02 <trap+0x202>
f0104a7e:	66 90                	xchg   %ax,%ax
f0104a80:	eb 63                	jmp    f0104ae5 <trap+0x1e5>
	{
		case T_PGFLT : page_fault_handler(tf);
f0104a82:	89 34 24             	mov    %esi,(%esp)
f0104a85:	e8 d0 fc ff ff       	call   f010475a <page_fault_handler>
f0104a8a:	e9 ac 00 00 00       	jmp    f0104b3b <trap+0x23b>
						break;
		case T_BRKPT : monitor(tf);
f0104a8f:	89 34 24             	mov    %esi,(%esp)
f0104a92:	e8 bb bf ff ff       	call   f0100a52 <monitor>
f0104a97:	e9 9f 00 00 00       	jmp    f0104b3b <trap+0x23b>
					   break;
		case T_SYSCALL: returncode = syscall(tf->tf_regs.reg_eax,tf->tf_regs.reg_edx,tf->tf_regs.reg_ecx,tf->tf_regs.reg_ebx,tf->tf_regs.reg_edi,tf->tf_regs.reg_esi);
f0104a9c:	8b 46 04             	mov    0x4(%esi),%eax
f0104a9f:	89 44 24 14          	mov    %eax,0x14(%esp)
f0104aa3:	8b 06                	mov    (%esi),%eax
f0104aa5:	89 44 24 10          	mov    %eax,0x10(%esp)
f0104aa9:	8b 46 10             	mov    0x10(%esi),%eax
f0104aac:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104ab0:	8b 46 18             	mov    0x18(%esi),%eax
f0104ab3:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104ab7:	8b 46 14             	mov    0x14(%esi),%eax
f0104aba:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104abe:	8b 46 1c             	mov    0x1c(%esi),%eax
f0104ac1:	89 04 24             	mov    %eax,(%esp)
f0104ac4:	e8 07 03 00 00       	call   f0104dd0 <syscall>
						tf->tf_regs.reg_eax = returncode;
f0104ac9:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104acc:	eb 6d                	jmp    f0104b3b <trap+0x23b>
						break;
		case IRQ_OFFSET+IRQ_TIMER: //cprintf("i am in IRQ_TIMER\n");
						lapic_eoi();
f0104ace:	e8 03 1e 00 00       	call   f01068d6 <lapic_eoi>
						time_tick(cpunum());
f0104ad3:	e8 b1 1c 00 00       	call   f0106789 <cpunum>
f0104ad8:	89 04 24             	mov    %eax,(%esp)
f0104adb:	e8 86 2b 00 00       	call   f0107666 <time_tick>
						sched_yield();
f0104ae0:	e8 1d 02 00 00       	call   f0104d02 <sched_yield>
						break;
		case IRQ_OFFSET+IRQ_KBD:lapic_eoi(); 
f0104ae5:	e8 ec 1d 00 00       	call   f01068d6 <lapic_eoi>
								kbd_intr();
f0104aea:	e8 b4 bb ff ff       	call   f01006a3 <kbd_intr>
f0104aef:	90                   	nop
f0104af0:	eb 49                	jmp    f0104b3b <trap+0x23b>
								 break;
		case IRQ_OFFSET+IRQ_SERIAL:lapic_eoi();
f0104af2:	e8 df 1d 00 00       	call   f01068d6 <lapic_eoi>
									serial_intr();
f0104af7:	e8 8b bb ff ff       	call   f0100687 <serial_intr>
f0104afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104b00:	eb 39                	jmp    f0104b3b <trap+0x23b>
									break;
		default :if (tf->tf_cs == GD_KT)
f0104b02:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104b07:	75 1c                	jne    f0104b25 <trap+0x225>
						panic("unhandled trap in kernel");
f0104b09:	c7 44 24 08 6a 8e 10 	movl   $0xf0108e6a,0x8(%esp)
f0104b10:	f0 
f0104b11:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
f0104b18:	00 
f0104b19:	c7 04 24 3a 8e 10 f0 	movl   $0xf0108e3a,(%esp)
f0104b20:	e8 78 b5 ff ff       	call   f010009d <_panic>
						else {
						env_destroy(curenv);
f0104b25:	e8 5f 1c 00 00       	call   f0106789 <cpunum>
f0104b2a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b2d:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104b33:	89 04 24             	mov    %eax,(%esp)
f0104b36:	e8 7d f1 ff ff       	call   f0103cb8 <env_destroy>


	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104b3b:	e8 49 1c 00 00       	call   f0106789 <cpunum>
f0104b40:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b43:	83 b8 28 90 31 f0 00 	cmpl   $0x0,-0xfce6fd8(%eax)
f0104b4a:	74 2a                	je     f0104b76 <trap+0x276>
f0104b4c:	e8 38 1c 00 00       	call   f0106789 <cpunum>
f0104b51:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b54:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104b5a:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104b5e:	75 16                	jne    f0104b76 <trap+0x276>
		env_run(curenv);
f0104b60:	e8 24 1c 00 00       	call   f0106789 <cpunum>
f0104b65:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b68:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104b6e:	89 04 24             	mov    %eax,(%esp)
f0104b71:	e8 e3 f1 ff ff       	call   f0103d59 <env_run>
	else
		sched_yield();
f0104b76:	e8 87 01 00 00       	call   f0104d02 <sched_yield>
f0104b7b:	90                   	nop

f0104b7c <T_DIVIDE_HANDLER>:
 * Lab 3: Your code here for generating entry points for the different traps.
 */



TRAPHANDLER_NOEC(T_DIVIDE_HANDLER,T_DIVIDE)
f0104b7c:	6a 00                	push   $0x0
f0104b7e:	6a 00                	push   $0x0
f0104b80:	e9 95 00 00 00       	jmp    f0104c1a <_alltraps>
f0104b85:	90                   	nop

f0104b86 <T_DEBUG_HANDLER>:
TRAPHANDLER_NOEC(T_DEBUG_HANDLER,T_DEBUG)
f0104b86:	6a 00                	push   $0x0
f0104b88:	6a 01                	push   $0x1
f0104b8a:	e9 8b 00 00 00       	jmp    f0104c1a <_alltraps>
f0104b8f:	90                   	nop

f0104b90 <T_NMI_HANDLER>:
TRAPHANDLER_NOEC(T_NMI_HANDLER,T_NMI)
f0104b90:	6a 00                	push   $0x0
f0104b92:	6a 02                	push   $0x2
f0104b94:	e9 81 00 00 00       	jmp    f0104c1a <_alltraps>
f0104b99:	90                   	nop

f0104b9a <T_BRKPT_HANDLER>:
TRAPHANDLER_NOEC(T_BRKPT_HANDLER,T_BRKPT)
f0104b9a:	6a 00                	push   $0x0
f0104b9c:	6a 03                	push   $0x3
f0104b9e:	eb 7a                	jmp    f0104c1a <_alltraps>

f0104ba0 <T_OFLOW_HANDLER>:
TRAPHANDLER_NOEC(T_OFLOW_HANDLER,T_OFLOW)
f0104ba0:	6a 00                	push   $0x0
f0104ba2:	6a 04                	push   $0x4
f0104ba4:	eb 74                	jmp    f0104c1a <_alltraps>

f0104ba6 <T_BOUND_HANDLER>:
TRAPHANDLER_NOEC(T_BOUND_HANDLER,T_BOUND)
f0104ba6:	6a 00                	push   $0x0
f0104ba8:	6a 05                	push   $0x5
f0104baa:	eb 6e                	jmp    f0104c1a <_alltraps>

f0104bac <T_ILLOP_HANDLER>:
TRAPHANDLER_NOEC(T_ILLOP_HANDLER,T_ILLOP)
f0104bac:	6a 00                	push   $0x0
f0104bae:	6a 06                	push   $0x6
f0104bb0:	eb 68                	jmp    f0104c1a <_alltraps>

f0104bb2 <T_DEVICE_HANDLER>:
TRAPHANDLER_NOEC(T_DEVICE_HANDLER,T_DEVICE)
f0104bb2:	6a 00                	push   $0x0
f0104bb4:	6a 07                	push   $0x7
f0104bb6:	eb 62                	jmp    f0104c1a <_alltraps>

f0104bb8 <T_DBLFLT_HANDLER>:
TRAPHANDLER(T_DBLFLT_HANDLER,T_DBLFLT)
f0104bb8:	6a 08                	push   $0x8
f0104bba:	eb 5e                	jmp    f0104c1a <_alltraps>

f0104bbc <T_TSS_HANDLER>:
TRAPHANDLER_NOEC(T_TSS_HANDLER,T_TSS)
f0104bbc:	6a 00                	push   $0x0
f0104bbe:	6a 0a                	push   $0xa
f0104bc0:	eb 58                	jmp    f0104c1a <_alltraps>

f0104bc2 <T_SEGNP_HANDLER>:
TRAPHANDLER(T_SEGNP_HANDLER,T_SEGNP)
f0104bc2:	6a 0b                	push   $0xb
f0104bc4:	eb 54                	jmp    f0104c1a <_alltraps>

f0104bc6 <T_STACK_HANDLER>:
TRAPHANDLER(T_STACK_HANDLER,T_STACK)
f0104bc6:	6a 0c                	push   $0xc
f0104bc8:	eb 50                	jmp    f0104c1a <_alltraps>

f0104bca <T_GPFLT_HANDLER>:
TRAPHANDLER(T_GPFLT_HANDLER,T_GPFLT)
f0104bca:	6a 0d                	push   $0xd
f0104bcc:	eb 4c                	jmp    f0104c1a <_alltraps>

f0104bce <T_PGFLT_HANDLER>:
TRAPHANDLER(T_PGFLT_HANDLER,T_PGFLT)
f0104bce:	6a 0e                	push   $0xe
f0104bd0:	eb 48                	jmp    f0104c1a <_alltraps>

f0104bd2 <T_FPERR_HANDLER>:
TRAPHANDLER(T_FPERR_HANDLER,T_FPERR)
f0104bd2:	6a 10                	push   $0x10
f0104bd4:	eb 44                	jmp    f0104c1a <_alltraps>

f0104bd6 <T_ALIGN_HANDLER>:
TRAPHANDLER_NOEC(T_ALIGN_HANDLER,T_ALIGN)
f0104bd6:	6a 00                	push   $0x0
f0104bd8:	6a 11                	push   $0x11
f0104bda:	eb 3e                	jmp    f0104c1a <_alltraps>

f0104bdc <T_MCHK_HANDLER>:
TRAPHANDLER_NOEC(T_MCHK_HANDLER,T_MCHK)
f0104bdc:	6a 00                	push   $0x0
f0104bde:	6a 12                	push   $0x12
f0104be0:	eb 38                	jmp    f0104c1a <_alltraps>

f0104be2 <T_SIMDERR_HANDLER>:
TRAPHANDLER(T_SIMDERR_HANDLER,T_SIMDERR)
f0104be2:	6a 13                	push   $0x13
f0104be4:	eb 34                	jmp    f0104c1a <_alltraps>

f0104be6 <T_SYSCALL_HANDLER>:
TRAPHANDLER_NOEC(T_SYSCALL_HANDLER,T_SYSCALL)
f0104be6:	6a 00                	push   $0x0
f0104be8:	6a 30                	push   $0x30
f0104bea:	eb 2e                	jmp    f0104c1a <_alltraps>

f0104bec <T_DEFAULT_HANDLER>:
TRAPHANDLER_NOEC(T_DEFAULT_HANDLER,T_DEFAULT)
f0104bec:	6a 00                	push   $0x0
f0104bee:	68 f4 01 00 00       	push   $0x1f4
f0104bf3:	eb 25                	jmp    f0104c1a <_alltraps>
f0104bf5:	90                   	nop

f0104bf6 <IRQ_TIMER_HANDLER>:
TRAPHANDLER_NOEC(IRQ_TIMER_HANDLER,IRQ_TIMER+IRQ_OFFSET);
f0104bf6:	6a 00                	push   $0x0
f0104bf8:	6a 20                	push   $0x20
f0104bfa:	eb 1e                	jmp    f0104c1a <_alltraps>

f0104bfc <IRQ_KBD_HANDLER>:
TRAPHANDLER_NOEC(IRQ_KBD_HANDLER,IRQ_KBD+IRQ_OFFSET);
f0104bfc:	6a 00                	push   $0x0
f0104bfe:	6a 21                	push   $0x21
f0104c00:	eb 18                	jmp    f0104c1a <_alltraps>

f0104c02 <IRQ_SERIAL_HANDLER>:
TRAPHANDLER_NOEC(IRQ_SERIAL_HANDLER,IRQ_SERIAL+IRQ_OFFSET);
f0104c02:	6a 00                	push   $0x0
f0104c04:	6a 24                	push   $0x24
f0104c06:	eb 12                	jmp    f0104c1a <_alltraps>

f0104c08 <IRQ_SPURIOUS_HANDLER>:
TRAPHANDLER_NOEC(IRQ_SPURIOUS_HANDLER,IRQ_SPURIOUS+IRQ_OFFSET);
f0104c08:	6a 00                	push   $0x0
f0104c0a:	6a 27                	push   $0x27
f0104c0c:	eb 0c                	jmp    f0104c1a <_alltraps>

f0104c0e <IRQ_IDE_HANDLER>:
TRAPHANDLER_NOEC(IRQ_IDE_HANDLER,IRQ_IDE+IRQ_OFFSET);
f0104c0e:	6a 00                	push   $0x0
f0104c10:	6a 2e                	push   $0x2e
f0104c12:	eb 06                	jmp    f0104c1a <_alltraps>

f0104c14 <IRQ_ERROR_HANDLER>:
TRAPHANDLER_NOEC(IRQ_ERROR_HANDLER,IRQ_ERROR+IRQ_OFFSET);
f0104c14:	6a 00                	push   $0x0
f0104c16:	6a 33                	push   $0x33
f0104c18:	eb 00                	jmp    f0104c1a <_alltraps>

f0104c1a <_alltraps>:
 */



_alltraps:
	pushl %ds;
f0104c1a:	1e                   	push   %ds
	pushl %es;
f0104c1b:	06                   	push   %es
	pushal;
f0104c1c:	60                   	pusha  
	movl $GD_KD,%eax;
f0104c1d:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax,%ds;
f0104c22:	8e d8                	mov    %eax,%ds
	movw %ax,%es;
f0104c24:	8e c0                	mov    %eax,%es
	pushl %esp;
f0104c26:	54                   	push   %esp
	call trap;
f0104c27:	e8 d4 fc ff ff       	call   f0104900 <trap>

f0104c2c <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104c2c:	55                   	push   %ebp
f0104c2d:	89 e5                	mov    %esp,%ebp
f0104c2f:	83 ec 18             	sub    $0x18,%esp
f0104c32:	8b 15 48 82 2b f0    	mov    0xf02b8248,%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104c38:	b8 00 00 00 00       	mov    $0x0,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0104c3d:	8b 4a 54             	mov    0x54(%edx),%ecx
f0104c40:	83 e9 01             	sub    $0x1,%ecx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0104c43:	83 f9 02             	cmp    $0x2,%ecx
f0104c46:	76 0f                	jbe    f0104c57 <sched_halt+0x2b>
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104c48:	83 c0 01             	add    $0x1,%eax
f0104c4b:	83 c2 7c             	add    $0x7c,%edx
f0104c4e:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104c53:	75 e8                	jne    f0104c3d <sched_halt+0x11>
f0104c55:	eb 07                	jmp    f0104c5e <sched_halt+0x32>
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
f0104c57:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104c5c:	75 1a                	jne    f0104c78 <sched_halt+0x4c>
		cprintf("No runnable environments in the system!\n");
f0104c5e:	c7 04 24 50 90 10 f0 	movl   $0xf0109050,(%esp)
f0104c65:	e8 5b f3 ff ff       	call   f0103fc5 <cprintf>
		while (1)
			monitor(NULL);
f0104c6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0104c71:	e8 dc bd ff ff       	call   f0100a52 <monitor>
f0104c76:	eb f2                	jmp    f0104c6a <sched_halt+0x3e>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104c78:	e8 0c 1b 00 00       	call   f0106789 <cpunum>
f0104c7d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c80:	c7 80 28 90 31 f0 00 	movl   $0x0,-0xfce6fd8(%eax)
f0104c87:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104c8a:	a1 cc 8e 2b f0       	mov    0xf02b8ecc,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0104c8f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104c94:	77 20                	ja     f0104cb6 <sched_halt+0x8a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104c96:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104c9a:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0104ca1:	f0 
f0104ca2:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
f0104ca9:	00 
f0104caa:	c7 04 24 79 90 10 f0 	movl   $0xf0109079,(%esp)
f0104cb1:	e8 e7 b3 ff ff       	call   f010009d <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104cb6:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0104cbb:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104cbe:	e8 c6 1a 00 00       	call   f0106789 <cpunum>
f0104cc3:	6b d0 74             	imul   $0x74,%eax,%edx
f0104cc6:	81 c2 20 90 31 f0    	add    $0xf0319020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0104ccc:	b8 02 00 00 00       	mov    $0x2,%eax
f0104cd1:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0104cd5:	c7 04 24 c0 43 12 f0 	movl   $0xf01243c0,(%esp)
f0104cdc:	e8 d2 1d 00 00       	call   f0106ab3 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0104ce1:	f3 90                	pause  
		"pushl $0\n"
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f0104ce3:	e8 a1 1a 00 00       	call   f0106789 <cpunum>
f0104ce8:	6b c0 74             	imul   $0x74,%eax,%eax

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
f0104ceb:	8b 80 30 90 31 f0    	mov    -0xfce6fd0(%eax),%eax
f0104cf1:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104cf6:	89 c4                	mov    %eax,%esp
f0104cf8:	6a 00                	push   $0x0
f0104cfa:	6a 00                	push   $0x0
f0104cfc:	fb                   	sti    
f0104cfd:	f4                   	hlt    
f0104cfe:	eb fd                	jmp    f0104cfd <sched_halt+0xd1>
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
}
f0104d00:	c9                   	leave  
f0104d01:	c3                   	ret    

f0104d02 <sched_yield>:
void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f0104d02:	55                   	push   %ebp
f0104d03:	89 e5                	mov    %esp,%ebp
f0104d05:	53                   	push   %ebx
f0104d06:	83 ec 14             	sub    $0x14,%esp


	uint32_t env_count=0;
	uint32_t ce_id ;//= curenv ? ENVX(curenv->env_id) : 0;
	//int current_env_idx = curenv ? ENVX(curenv->env_id) : 0;
	if(curenv == NULL)
f0104d09:	e8 7b 1a 00 00       	call   f0106789 <cpunum>
f0104d0e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d11:	83 b8 28 90 31 f0 00 	cmpl   $0x0,-0xfce6fd8(%eax)
f0104d18:	0f 84 91 00 00 00    	je     f0104daf <sched_yield+0xad>
	{
		ce_id = 0;
	}
	else
	{
		ce_id = ENVX(curenv->env_id+1)%NENV;
f0104d1e:	e8 66 1a 00 00       	call   f0106789 <cpunum>
f0104d23:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d26:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104d2c:	8b 50 48             	mov    0x48(%eax),%edx
f0104d2f:	83 c2 01             	add    $0x1,%edx
f0104d32:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
		env_count =1;
f0104d38:	b8 01 00 00 00       	mov    $0x1,%eax
f0104d3d:	eb 7a                	jmp    f0104db9 <sched_yield+0xb7>
	//cprintf("%d\n",ce_id);
	
	//ce_id = (current_env_idx + 1) % NENV;
	while(env_count<NENV)
	{
		if(envs[ce_id].env_status == ENV_RUNNABLE)
f0104d3f:	6b ca 7c             	imul   $0x7c,%edx,%ecx
f0104d42:	83 7c 0b 54 02       	cmpl   $0x2,0x54(%ebx,%ecx,1)
f0104d47:	75 0a                	jne    f0104d53 <sched_yield+0x51>
		{
			//cprintf("i am going to be rnning something\n");
			env_run(&envs[ENVX(ce_id)]);
f0104d49:	01 cb                	add    %ecx,%ebx
f0104d4b:	89 1c 24             	mov    %ebx,(%esp)
f0104d4e:	e8 06 f0 ff ff       	call   f0103d59 <env_run>
			break;
		}
		ce_id = (ce_id+1)%NENV;
f0104d53:	83 c2 01             	add    $0x1,%edx
f0104d56:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
		//ce_id = ce_id % NENV;
		env_count = env_count+1;
f0104d5c:	83 c0 01             	add    $0x1,%eax
		env_count =1;
	}
	//cprintf("%d\n",ce_id);
	
	//ce_id = (current_env_idx + 1) % NENV;
	while(env_count<NENV)
f0104d5f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0104d64:	76 d9                	jbe    f0104d3f <sched_yield+0x3d>
		}
		ce_id = (ce_id+1)%NENV;
		//ce_id = ce_id % NENV;
		env_count = env_count+1;
	}
	if(env_count ==NENV)
f0104d66:	3d 00 04 00 00       	cmp    $0x400,%eax
f0104d6b:	75 3b                	jne    f0104da8 <sched_yield+0xa6>
	{
		if(curenv!=NULL && (curenv->env_status == ENV_RUNNING))
f0104d6d:	e8 17 1a 00 00       	call   f0106789 <cpunum>
f0104d72:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d75:	83 b8 28 90 31 f0 00 	cmpl   $0x0,-0xfce6fd8(%eax)
f0104d7c:	74 2a                	je     f0104da8 <sched_yield+0xa6>
f0104d7e:	e8 06 1a 00 00       	call   f0106789 <cpunum>
f0104d83:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d86:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104d8c:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104d90:	75 16                	jne    f0104da8 <sched_yield+0xa6>
		env_run(curenv);
f0104d92:	e8 f2 19 00 00       	call   f0106789 <cpunum>
f0104d97:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d9a:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104da0:	89 04 24             	mov    %eax,(%esp)
f0104da3:	e8 b1 ef ff ff       	call   f0103d59 <env_run>
	}
	


	// sched_halt never returns
	sched_halt();
f0104da8:	e8 7f fe ff ff       	call   f0104c2c <sched_halt>
f0104dad:	eb 15                	jmp    f0104dc4 <sched_yield+0xc2>
	uint32_t env_count=0;
	uint32_t ce_id ;//= curenv ? ENVX(curenv->env_id) : 0;
	//int current_env_idx = curenv ? ENVX(curenv->env_id) : 0;
	if(curenv == NULL)
	{
		ce_id = 0;
f0104daf:	ba 00 00 00 00       	mov    $0x0,%edx
	// below to halt the cpu.

	// LAB 4: Your code here.


	uint32_t env_count=0;
f0104db4:	b8 00 00 00 00       	mov    $0x0,%eax
	//cprintf("%d\n",ce_id);
	
	//ce_id = (current_env_idx + 1) % NENV;
	while(env_count<NENV)
	{
		if(envs[ce_id].env_status == ENV_RUNNABLE)
f0104db9:	8b 1d 48 82 2b f0    	mov    0xf02b8248,%ebx
f0104dbf:	e9 7b ff ff ff       	jmp    f0104d3f <sched_yield+0x3d>
	


	// sched_halt never returns
	sched_halt();
}
f0104dc4:	83 c4 14             	add    $0x14,%esp
f0104dc7:	5b                   	pop    %ebx
f0104dc8:	5d                   	pop    %ebp
f0104dc9:	c3                   	ret    
f0104dca:	66 90                	xchg   %ax,%ax
f0104dcc:	66 90                	xchg   %ax,%ax
f0104dce:	66 90                	xchg   %ax,%ax

f0104dd0 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104dd0:	55                   	push   %ebp
f0104dd1:	89 e5                	mov    %esp,%ebp
f0104dd3:	57                   	push   %edi
f0104dd4:	56                   	push   %esi
f0104dd5:	53                   	push   %ebx
f0104dd6:	83 ec 2c             	sub    $0x2c,%esp
f0104dd9:	8b 45 08             	mov    0x8(%ebp),%eax
f0104ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
	//panic("syscall not implemented");
	int return_code = 0;
	switch (syscallno) {
f0104ddf:	83 f8 10             	cmp    $0x10,%eax
f0104de2:	0f 87 10 07 00 00    	ja     f01054f8 <syscall+0x728>
f0104de8:	ff 24 85 e8 90 10 f0 	jmp    *-0xfef6f18(,%eax,4)
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.

	user_mem_assert(curenv,s,len,0);
f0104def:	e8 95 19 00 00       	call   f0106789 <cpunum>
f0104df4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0104dfb:	00 
f0104dfc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0104e00:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0104e03:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104e07:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e0a:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104e10:	89 04 24             	mov    %eax,(%esp)
f0104e13:	e8 98 e7 ff ff       	call   f01035b0 <user_mem_assert>



	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f0104e18:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104e1b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104e1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104e23:	c7 04 24 86 90 10 f0 	movl   $0xf0109086,(%esp)
f0104e2a:	e8 96 f1 ff ff       	call   f0103fc5 <cprintf>
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
	//panic("syscall not implemented");
	int return_code = 0;
f0104e2f:	b8 00 00 00 00       	mov    $0x0,%eax
f0104e34:	e9 cb 06 00 00       	jmp    f0105504 <syscall+0x734>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f0104e39:	e8 77 b8 ff ff       	call   f01006b5 <cons_getc>
	int return_code = 0;
	switch (syscallno) {
	case SYS_cputs: sys_cputs((char *)a1,a2);
					break;
	case SYS_cgetc: return_code =sys_cgetc();
				   break;
f0104e3e:	66 90                	xchg   %ax,%ax
f0104e40:	e9 bf 06 00 00       	jmp    f0105504 <syscall+0x734>

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f0104e45:	e8 3f 19 00 00       	call   f0106789 <cpunum>
f0104e4a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e4d:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104e53:	8b 40 48             	mov    0x48(%eax),%eax
	case SYS_cputs: sys_cputs((char *)a1,a2);
					break;
	case SYS_cgetc: return_code =sys_cgetc();
				   break;
	case SYS_getenvid:return_code =sys_getenvid();
					   break;
f0104e56:	e9 a9 06 00 00       	jmp    f0105504 <syscall+0x734>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0104e5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104e62:	00 
f0104e63:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104e66:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104e6d:	89 04 24             	mov    %eax,(%esp)
f0104e70:	e8 10 e8 ff ff       	call   f0103685 <envid2env>
		return r;
f0104e75:	89 c2                	mov    %eax,%edx
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0104e77:	85 c0                	test   %eax,%eax
f0104e79:	78 6e                	js     f0104ee9 <syscall+0x119>
		return r;

	if (e == curenv)
f0104e7b:	e8 09 19 00 00       	call   f0106789 <cpunum>
f0104e80:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104e83:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e86:	39 90 28 90 31 f0    	cmp    %edx,-0xfce6fd8(%eax)
f0104e8c:	75 23                	jne    f0104eb1 <syscall+0xe1>
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
f0104e8e:	e8 f6 18 00 00       	call   f0106789 <cpunum>
f0104e93:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e96:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104e9c:	8b 40 48             	mov    0x48(%eax),%eax
f0104e9f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ea3:	c7 04 24 8b 90 10 f0 	movl   $0xf010908b,(%esp)
f0104eaa:	e8 16 f1 ff ff       	call   f0103fc5 <cprintf>
f0104eaf:	eb 28                	jmp    f0104ed9 <syscall+0x109>
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);
f0104eb1:	8b 5a 48             	mov    0x48(%edx),%ebx
f0104eb4:	e8 d0 18 00 00       	call   f0106789 <cpunum>
f0104eb9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0104ebd:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ec0:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104ec6:	8b 40 48             	mov    0x48(%eax),%eax
f0104ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ecd:	c7 04 24 a6 90 10 f0 	movl   $0xf01090a6,(%esp)
f0104ed4:	e8 ec f0 ff ff       	call   f0103fc5 <cprintf>


	env_destroy(e);
f0104ed9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104edc:	89 04 24             	mov    %eax,(%esp)
f0104edf:	e8 d4 ed ff ff       	call   f0103cb8 <env_destroy>
	return 0;
f0104ee4:	ba 00 00 00 00       	mov    $0x0,%edx
					break;
	case SYS_cgetc: return_code =sys_cgetc();
				   break;
	case SYS_getenvid:return_code =sys_getenvid();
					   break;
	case SYS_env_destroy:return_code = sys_env_destroy(a1);
f0104ee9:	89 d0                	mov    %edx,%eax
						  break;
f0104eeb:	e9 14 06 00 00       	jmp    f0105504 <syscall+0x734>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f0104ef0:	e8 0d fe ff ff       	call   f0104d02 <sched_yield>
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	struct Env *forked_env ;
	int err_code = env_alloc(&forked_env,curenv->env_id);
f0104ef5:	e8 8f 18 00 00       	call   f0106789 <cpunum>
f0104efa:	6b c0 74             	imul   $0x74,%eax,%eax
f0104efd:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0104f03:	8b 40 48             	mov    0x48(%eax),%eax
f0104f06:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f0a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104f0d:	89 04 24             	mov    %eax,(%esp)
f0104f10:	e8 9b e8 ff ff       	call   f01037b0 <env_alloc>
	if(err_code < 0)
	{
		return err_code;
f0104f15:	89 c2                	mov    %eax,%edx
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	struct Env *forked_env ;
	int err_code = env_alloc(&forked_env,curenv->env_id);
	if(err_code < 0)
f0104f17:	85 c0                	test   %eax,%eax
f0104f19:	78 2e                	js     f0104f49 <syscall+0x179>
	{
		return err_code;
	}
	forked_env->env_status = ENV_NOT_RUNNABLE;
f0104f1b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104f1e:	c7 43 54 04 00 00 00 	movl   $0x4,0x54(%ebx)
	forked_env->env_tf = curenv->env_tf;
f0104f25:	e8 5f 18 00 00       	call   f0106789 <cpunum>
f0104f2a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f2d:	8b b0 28 90 31 f0    	mov    -0xfce6fd8(%eax),%esi
f0104f33:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104f38:	89 df                	mov    %ebx,%edi
f0104f3a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	forked_env->env_tf.tf_regs.reg_eax=0;
f0104f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f3f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	//cprintf("forked_env id %d\n",forked_env->env_id);
	return forked_env->env_id;
f0104f46:	8b 50 48             	mov    0x48(%eax),%edx
					   break;
	case SYS_env_destroy:return_code = sys_env_destroy(a1);
						  break;
	case SYS_yield:sys_yield();
				    break;
	case SYS_exofork: return_code =sys_exofork();
f0104f49:	89 d0                	mov    %edx,%eax
					  break;
f0104f4b:	e9 b4 05 00 00       	jmp    f0105504 <syscall+0x734>
	// check whether the current environment has permission to set
	// envid's status.

struct Env *env_ptr;
	int rcode;
	rcode = envid2env(envid,&env_ptr,1);
f0104f50:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104f57:	00 
f0104f58:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104f5b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104f62:	89 04 24             	mov    %eax,(%esp)
f0104f65:	e8 1b e7 ff ff       	call   f0103685 <envid2env>
	if(rcode < 0)
f0104f6a:	85 c0                	test   %eax,%eax
f0104f6c:	78 1a                	js     f0104f88 <syscall+0x1b8>
		return -E_BAD_ENV;
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
f0104f6e:	83 fb 04             	cmp    $0x4,%ebx
f0104f71:	74 05                	je     f0104f78 <syscall+0x1a8>
f0104f73:	83 fb 02             	cmp    $0x2,%ebx
f0104f76:	75 1a                	jne    f0104f92 <syscall+0x1c2>
		return -E_INVAL;
		env_ptr->env_status = status;
f0104f78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104f7b:	89 58 54             	mov    %ebx,0x54(%eax)
		return 0;
f0104f7e:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f83:	e9 7c 05 00 00       	jmp    f0105504 <syscall+0x734>

struct Env *env_ptr;
	int rcode;
	rcode = envid2env(envid,&env_ptr,1);
	if(rcode < 0)
		return -E_BAD_ENV;
f0104f88:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104f8d:	e9 72 05 00 00       	jmp    f0105504 <syscall+0x734>
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
		return -E_INVAL;
f0104f92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	case SYS_yield:sys_yield();
				    break;
	case SYS_exofork: return_code =sys_exofork();
					  break;
	case SYS_env_set_status:return_code = sys_env_set_status(a1,a2);
							break;
f0104f97:	e9 68 05 00 00       	jmp    f0105504 <syscall+0x734>
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	if((((perm & PTE_U) !=PTE_U) && ((perm & PTE_P) !=PTE_P)) || (uint32_t)va>=UTOP || (perm & ~PTE_SYSCALL) || (uint32_t)va%PGSIZE!=0)
f0104f9c:	f6 45 14 05          	testb  $0x5,0x14(%ebp)
f0104fa0:	0f 84 8c 00 00 00    	je     f0105032 <syscall+0x262>
f0104fa6:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0104fac:	0f 87 8a 00 00 00    	ja     f010503c <syscall+0x26c>
f0104fb2:	f7 45 14 f8 f1 ff ff 	testl  $0xfffff1f8,0x14(%ebp)
f0104fb9:	0f 85 87 00 00 00    	jne    f0105046 <syscall+0x276>
f0104fbf:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f0104fc5:	0f 85 85 00 00 00    	jne    f0105050 <syscall+0x280>
		return -E_INVAL;

	struct Env *env_ptr;
	if(envid2env(envid,&env_ptr,1)!=0)
f0104fcb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104fd2:	00 
f0104fd3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104fda:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104fdd:	89 04 24             	mov    %eax,(%esp)
f0104fe0:	e8 a0 e6 ff ff       	call   f0103685 <envid2env>
f0104fe5:	85 c0                	test   %eax,%eax
f0104fe7:	75 71                	jne    f010505a <syscall+0x28a>
		return -E_BAD_ENV;

	struct PageInfo *pg = page_alloc(ALLOC_ZERO);
f0104fe9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0104ff0:	e8 ee c0 ff ff       	call   f01010e3 <page_alloc>
f0104ff5:	89 c6                	mov    %eax,%esi
	if(pg == NULL)
f0104ff7:	85 c0                	test   %eax,%eax
f0104ff9:	74 69                	je     f0105064 <syscall+0x294>
		return -E_NO_MEM;
	if(page_insert(env_ptr->env_pgdir,pg,va,perm)!=0)
f0104ffb:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ffe:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105002:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0105006:	89 74 24 04          	mov    %esi,0x4(%esp)
f010500a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010500d:	8b 40 60             	mov    0x60(%eax),%eax
f0105010:	89 04 24             	mov    %eax,(%esp)
f0105013:	e8 80 c3 ff ff       	call   f0101398 <page_insert>
f0105018:	85 c0                	test   %eax,%eax
f010501a:	0f 84 e4 04 00 00    	je     f0105504 <syscall+0x734>
	{
		page_free(pg);
f0105020:	89 34 24             	mov    %esi,(%esp)
f0105023:	e8 46 c1 ff ff       	call   f010116e <page_free>
		return -E_NO_MEM;
f0105028:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010502d:	e9 d2 04 00 00       	jmp    f0105504 <syscall+0x734>
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	if((((perm & PTE_U) !=PTE_U) && ((perm & PTE_P) !=PTE_P)) || (uint32_t)va>=UTOP || (perm & ~PTE_SYSCALL) || (uint32_t)va%PGSIZE!=0)
		return -E_INVAL;
f0105032:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105037:	e9 c8 04 00 00       	jmp    f0105504 <syscall+0x734>
f010503c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105041:	e9 be 04 00 00       	jmp    f0105504 <syscall+0x734>
f0105046:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010504b:	e9 b4 04 00 00       	jmp    f0105504 <syscall+0x734>
f0105050:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105055:	e9 aa 04 00 00       	jmp    f0105504 <syscall+0x734>

	struct Env *env_ptr;
	if(envid2env(envid,&env_ptr,1)!=0)
		return -E_BAD_ENV;
f010505a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010505f:	e9 a0 04 00 00       	jmp    f0105504 <syscall+0x734>

	struct PageInfo *pg = page_alloc(ALLOC_ZERO);
	if(pg == NULL)
		return -E_NO_MEM;
f0105064:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	case SYS_exofork: return_code =sys_exofork();
					  break;
	case SYS_env_set_status:return_code = sys_env_set_status(a1,a2);
							break;
	case SYS_page_alloc: return_code = sys_page_alloc(a1,(void*)a2,a3);
						 break;
f0105069:	e9 96 04 00 00       	jmp    f0105504 <syscall+0x734>
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

    struct Env *src_env_ptr, *dst_env_ptr;
    if((envid2env(srcenvid,&src_env_ptr,1)) < 0 ||(envid2env(dstenvid,&dst_env_ptr,1))<0)
f010506e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105075:	00 
f0105076:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0105079:	89 44 24 04          	mov    %eax,0x4(%esp)
f010507d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105080:	89 04 24             	mov    %eax,(%esp)
f0105083:	e8 fd e5 ff ff       	call   f0103685 <envid2env>
f0105088:	85 c0                	test   %eax,%eax
f010508a:	0f 88 bc 00 00 00    	js     f010514c <syscall+0x37c>
f0105090:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105097:	00 
f0105098:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010509b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010509f:	8b 45 14             	mov    0x14(%ebp),%eax
f01050a2:	89 04 24             	mov    %eax,(%esp)
f01050a5:	e8 db e5 ff ff       	call   f0103685 <envid2env>
f01050aa:	85 c0                	test   %eax,%eax
f01050ac:	0f 88 a4 00 00 00    	js     f0105156 <syscall+0x386>
    	return -E_BAD_ENV;
    if((uint32_t)srcva>=UTOP || (uint32_t)dstva>=UTOP || (uint32_t)srcva%PGSIZE!=0 || (uint32_t)dstva%PGSIZE!=0)
f01050b2:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f01050b8:	0f 87 a2 00 00 00    	ja     f0105160 <syscall+0x390>
f01050be:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f01050c5:	0f 87 95 00 00 00    	ja     f0105160 <syscall+0x390>
f01050cb:	89 d8                	mov    %ebx,%eax
f01050cd:	0b 45 18             	or     0x18(%ebp),%eax
f01050d0:	a9 ff 0f 00 00       	test   $0xfff,%eax
f01050d5:	0f 85 8f 00 00 00    	jne    f010516a <syscall+0x39a>
    	return -E_INVAL;
    if((((perm & PTE_U) !=PTE_U) && ((perm & PTE_P) !=PTE_P)) || (perm & ~PTE_SYSCALL))
f01050db:	f6 45 1c 05          	testb  $0x5,0x1c(%ebp)
f01050df:	0f 84 8f 00 00 00    	je     f0105174 <syscall+0x3a4>
f01050e5:	f7 45 1c f8 f1 ff ff 	testl  $0xfffff1f8,0x1c(%ebp)
f01050ec:	0f 85 8c 00 00 00    	jne    f010517e <syscall+0x3ae>
    	return -E_INVAL;
    uint32_t *env_pg_addr;
    struct PageInfo *env_page = page_lookup(src_env_ptr->env_pgdir,srcva,&env_pg_addr);
f01050f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01050f5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01050f9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01050fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105100:	8b 40 60             	mov    0x60(%eax),%eax
f0105103:	89 04 24             	mov    %eax,(%esp)
f0105106:	e8 96 c1 ff ff       	call   f01012a1 <page_lookup>
    if(env_pg_addr == NULL)
f010510b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010510e:	85 d2                	test   %edx,%edx
f0105110:	74 76                	je     f0105188 <syscall+0x3b8>
    	return -E_INVAL;
    if((perm&PTE_W) == PTE_W &&((*env_pg_addr&PTE_W) ==0))
f0105112:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0105116:	74 05                	je     f010511d <syscall+0x34d>
f0105118:	f6 02 02             	testb  $0x2,(%edx)
f010511b:	74 75                	je     f0105192 <syscall+0x3c2>
    	return -E_INVAL;
    if(page_insert(dst_env_ptr->env_pgdir,env_page,dstva,perm)!=0)
f010511d:	8b 7d 1c             	mov    0x1c(%ebp),%edi
f0105120:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0105124:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105127:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010512b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010512f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105132:	8b 40 60             	mov    0x60(%eax),%eax
f0105135:	89 04 24             	mov    %eax,(%esp)
f0105138:	e8 5b c2 ff ff       	call   f0101398 <page_insert>
    	return -E_NO_MEM;
f010513d:	85 c0                	test   %eax,%eax
f010513f:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
f0105144:	0f 45 c2             	cmovne %edx,%eax
f0105147:	e9 b8 03 00 00       	jmp    f0105504 <syscall+0x734>
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

    struct Env *src_env_ptr, *dst_env_ptr;
    if((envid2env(srcenvid,&src_env_ptr,1)) < 0 ||(envid2env(dstenvid,&dst_env_ptr,1))<0)
    	return -E_BAD_ENV;
f010514c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105151:	e9 ae 03 00 00       	jmp    f0105504 <syscall+0x734>
f0105156:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010515b:	e9 a4 03 00 00       	jmp    f0105504 <syscall+0x734>
    if((uint32_t)srcva>=UTOP || (uint32_t)dstva>=UTOP || (uint32_t)srcva%PGSIZE!=0 || (uint32_t)dstva%PGSIZE!=0)
    	return -E_INVAL;
f0105160:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105165:	e9 9a 03 00 00       	jmp    f0105504 <syscall+0x734>
f010516a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010516f:	e9 90 03 00 00       	jmp    f0105504 <syscall+0x734>
    if((((perm & PTE_U) !=PTE_U) && ((perm & PTE_P) !=PTE_P)) || (perm & ~PTE_SYSCALL))
    	return -E_INVAL;
f0105174:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105179:	e9 86 03 00 00       	jmp    f0105504 <syscall+0x734>
f010517e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105183:	e9 7c 03 00 00       	jmp    f0105504 <syscall+0x734>
    uint32_t *env_pg_addr;
    struct PageInfo *env_page = page_lookup(src_env_ptr->env_pgdir,srcva,&env_pg_addr);
    if(env_pg_addr == NULL)
    	return -E_INVAL;
f0105188:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010518d:	e9 72 03 00 00       	jmp    f0105504 <syscall+0x734>
    if((perm&PTE_W) == PTE_W &&((*env_pg_addr&PTE_W) ==0))
    	return -E_INVAL;
f0105192:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	case SYS_env_set_status:return_code = sys_env_set_status(a1,a2);
							break;
	case SYS_page_alloc: return_code = sys_page_alloc(a1,(void*)a2,a3);
						 break;
	case SYS_page_map : return_code = sys_page_map(a1,(void*)a2,a3,(void*)a4,a5);
						break;
f0105197:	e9 68 03 00 00       	jmp    f0105504 <syscall+0x734>
sys_page_unmap(envid_t envid, void *va)
{
	// Hint: This function is a wrapper around page_remove().

	struct Env *env_ptr;
	if(envid2env(envid,&env_ptr,1)<0)
f010519c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01051a3:	00 
f01051a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01051a7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01051ab:	8b 45 0c             	mov    0xc(%ebp),%eax
f01051ae:	89 04 24             	mov    %eax,(%esp)
f01051b1:	e8 cf e4 ff ff       	call   f0103685 <envid2env>
f01051b6:	85 c0                	test   %eax,%eax
f01051b8:	78 2c                	js     f01051e6 <syscall+0x416>
		return -E_BAD_ENV;
	if((uint32_t)va>UTOP && (uint32_t)va%PGSIZE!=0)
f01051ba:	81 fb 00 00 c0 ee    	cmp    $0xeec00000,%ebx
f01051c0:	76 08                	jbe    f01051ca <syscall+0x3fa>
f01051c2:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f01051c8:	75 26                	jne    f01051f0 <syscall+0x420>
		return -E_INVAL;
	page_remove(env_ptr->env_pgdir,va);
f01051ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01051ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01051d1:	8b 40 60             	mov    0x60(%eax),%eax
f01051d4:	89 04 24             	mov    %eax,(%esp)
f01051d7:	e8 73 c1 ff ff       	call   f010134f <page_remove>
	return 0;
f01051dc:	b8 00 00 00 00       	mov    $0x0,%eax
f01051e1:	e9 1e 03 00 00       	jmp    f0105504 <syscall+0x734>
{
	// Hint: This function is a wrapper around page_remove().

	struct Env *env_ptr;
	if(envid2env(envid,&env_ptr,1)<0)
		return -E_BAD_ENV;
f01051e6:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01051eb:	e9 14 03 00 00       	jmp    f0105504 <syscall+0x734>
	if((uint32_t)va>UTOP && (uint32_t)va%PGSIZE!=0)
		return -E_INVAL;
f01051f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	case SYS_page_alloc: return_code = sys_page_alloc(a1,(void*)a2,a3);
						 break;
	case SYS_page_map : return_code = sys_page_map(a1,(void*)a2,a3,(void*)a4,a5);
						break;
	case SYS_page_unmap: return_code =sys_page_unmap(a1,(void*)a2);
						  break;
f01051f5:	e9 0a 03 00 00       	jmp    f0105504 <syscall+0x734>
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)

{   
	struct Env *env_ptr;
	if(envid2env(envid,&env_ptr,1)==0)
f01051fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105201:	00 
f0105202:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105205:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105209:	8b 45 0c             	mov    0xc(%ebp),%eax
f010520c:	89 04 24             	mov    %eax,(%esp)
f010520f:	e8 71 e4 ff ff       	call   f0103685 <envid2env>
f0105214:	85 c0                	test   %eax,%eax
f0105216:	75 0b                	jne    f0105223 <syscall+0x453>
	{
		env_ptr->env_pgfault_upcall = func;
f0105218:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010521b:	89 5a 64             	mov    %ebx,0x64(%edx)
f010521e:	e9 e1 02 00 00       	jmp    f0105504 <syscall+0x734>
		return 0;
	}
	return -E_BAD_ENV;
f0105223:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
	case SYS_page_map : return_code = sys_page_map(a1,(void*)a2,a3,(void*)a4,a5);
						break;
	case SYS_page_unmap: return_code =sys_page_unmap(a1,(void*)a2);
						  break;
	case SYS_env_set_pgfault_upcall: return_code=sys_env_set_pgfault_upcall(a1,(void*)a2);
									  break;
f0105228:	e9 d7 02 00 00       	jmp    f0105504 <syscall+0x734>
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
		//cprintf("In sys_ipc_recv funcion\n");
	if(((uint32_t)dstva<UTOP)&&(((uint32_t)dstva%PGSIZE)!=0))
f010522d:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105234:	77 0d                	ja     f0105243 <syscall+0x473>
f0105236:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f010523d:	0f 85 bc 02 00 00    	jne    f01054ff <syscall+0x72f>
		return -E_INVAL;
	curenv->env_ipc_dstva = dstva;
f0105243:	e8 41 15 00 00       	call   f0106789 <cpunum>
f0105248:	6b c0 74             	imul   $0x74,%eax,%eax
f010524b:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0105251:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105254:	89 78 6c             	mov    %edi,0x6c(%eax)
	curenv->env_ipc_recving = true;
f0105257:	e8 2d 15 00 00       	call   f0106789 <cpunum>
f010525c:	6b c0 74             	imul   $0x74,%eax,%eax
f010525f:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0105265:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f0105269:	e8 1b 15 00 00       	call   f0106789 <cpunum>
f010526e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105271:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0105277:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
	curenv->env_tf.tf_regs.reg_eax = 0;
f010527e:	e8 06 15 00 00       	call   f0106789 <cpunum>
f0105283:	6b c0 74             	imul   $0x74,%eax,%eax
f0105286:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f010528c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f0105293:	e8 6a fa ff ff       	call   f0104d02 <sched_yield>

	//cprintf("sys_ipc_try_send function called \n");
	struct Env *env;
	uint32_t *page_address;
	struct PageInfo *p_info;
	if(envid2env(envid,&env,0)<0)
f0105298:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010529f:	00 
f01052a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01052a3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01052a7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01052aa:	89 04 24             	mov    %eax,(%esp)
f01052ad:	e8 d3 e3 ff ff       	call   f0103685 <envid2env>
f01052b2:	85 c0                	test   %eax,%eax
f01052b4:	0f 88 d8 00 00 00    	js     f0105392 <syscall+0x5c2>
	{
		return -E_BAD_ENV;
	}
	if((uint32_t)srcva<UTOP && (uint32_t)srcva%PGSIZE!=0)
f01052ba:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01052c1:	77 0d                	ja     f01052d0 <syscall+0x500>
f01052c3:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f01052ca:	0f 85 cc 00 00 00    	jne    f010539c <syscall+0x5cc>
	{
		return -E_INVAL;
	}
	if(env->env_ipc_recving == false)
f01052d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01052d3:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f01052d7:	0f 84 c9 00 00 00    	je     f01053a6 <syscall+0x5d6>
	{
		return -E_IPC_NOT_RECV;
	}
	if((p_info = page_lookup(curenv->env_pgdir,srcva,&page_address))<0)
f01052dd:	e8 a7 14 00 00       	call   f0106789 <cpunum>
f01052e2:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f01052e5:	89 54 24 08          	mov    %edx,0x8(%esp)
f01052e9:	8b 4d 14             	mov    0x14(%ebp),%ecx
f01052ec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01052f0:	6b c0 74             	imul   $0x74,%eax,%eax
f01052f3:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01052f9:	8b 40 60             	mov    0x60(%eax),%eax
f01052fc:	89 04 24             	mov    %eax,(%esp)
f01052ff:	e8 9d bf ff ff       	call   f01012a1 <page_lookup>
		return -E_INVAL;
	//cprintf("page info is %08x\n",p_info);
	if((perm&PTE_W)&&((*page_address & PTE_W)==0))
f0105304:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0105308:	74 0c                	je     f0105316 <syscall+0x546>
f010530a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f010530d:	f6 02 02             	testb  $0x2,(%edx)
f0105310:	0f 84 9a 00 00 00    	je     f01053b0 <syscall+0x5e0>
		return -E_INVAL;
	if(((uint32_t)srcva<UTOP)&&((uint32_t)env->env_ipc_dstva<UTOP))
f0105316:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f010531d:	77 37                	ja     f0105356 <syscall+0x586>
f010531f:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105322:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0105325:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f010532b:	77 29                	ja     f0105356 <syscall+0x586>
	{
	if((page_insert(env->env_pgdir,p_info,env->env_ipc_dstva,perm))<0)
f010532d:	8b 7d 18             	mov    0x18(%ebp),%edi
f0105330:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0105334:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105338:	89 44 24 04          	mov    %eax,0x4(%esp)
f010533c:	8b 42 60             	mov    0x60(%edx),%eax
f010533f:	89 04 24             	mov    %eax,(%esp)
f0105342:	e8 51 c0 ff ff       	call   f0101398 <page_insert>
f0105347:	85 c0                	test   %eax,%eax
f0105349:	78 6f                	js     f01053ba <syscall+0x5ea>
		return -E_NO_MEM;
	env->env_ipc_perm = perm;
f010534b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010534e:	8b 7d 18             	mov    0x18(%ebp),%edi
f0105351:	89 78 78             	mov    %edi,0x78(%eax)
f0105354:	eb 0a                	jmp    f0105360 <syscall+0x590>
}
else
{
env->env_ipc_perm = 0;	
f0105356:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105359:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
}
	env->env_ipc_recving =false;
f0105360:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0105363:	c6 46 68 00          	movb   $0x0,0x68(%esi)
	env->env_ipc_from = curenv->env_id;
f0105367:	e8 1d 14 00 00       	call   f0106789 <cpunum>
f010536c:	6b c0 74             	imul   $0x74,%eax,%eax
f010536f:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0105375:	8b 40 48             	mov    0x48(%eax),%eax
f0105378:	89 46 74             	mov    %eax,0x74(%esi)
	env->env_ipc_value = value;
f010537b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010537e:	89 58 70             	mov    %ebx,0x70(%eax)
	env->env_status = ENV_RUNNABLE;
f0105381:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	return 0;
f0105388:	b8 00 00 00 00       	mov    $0x0,%eax
f010538d:	e9 72 01 00 00       	jmp    f0105504 <syscall+0x734>
	struct Env *env;
	uint32_t *page_address;
	struct PageInfo *p_info;
	if(envid2env(envid,&env,0)<0)
	{
		return -E_BAD_ENV;
f0105392:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0105397:	e9 68 01 00 00       	jmp    f0105504 <syscall+0x734>
	}
	if((uint32_t)srcva<UTOP && (uint32_t)srcva%PGSIZE!=0)
	{
		return -E_INVAL;
f010539c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01053a1:	e9 5e 01 00 00       	jmp    f0105504 <syscall+0x734>
	}
	if(env->env_ipc_recving == false)
	{
		return -E_IPC_NOT_RECV;
f01053a6:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
f01053ab:	e9 54 01 00 00       	jmp    f0105504 <syscall+0x734>
	}
	if((p_info = page_lookup(curenv->env_pgdir,srcva,&page_address))<0)
		return -E_INVAL;
	//cprintf("page info is %08x\n",p_info);
	if((perm&PTE_W)&&((*page_address & PTE_W)==0))
		return -E_INVAL;
f01053b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01053b5:	e9 4a 01 00 00       	jmp    f0105504 <syscall+0x734>
	if(((uint32_t)srcva<UTOP)&&((uint32_t)env->env_ipc_dstva<UTOP))
	{
	if((page_insert(env->env_pgdir,p_info,env->env_ipc_dstva,perm))<0)
		return -E_NO_MEM;
f01053ba:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
									  break;
	case SYS_ipc_recv : return_code = sys_ipc_recv((void*)a1);
									  //cprintf("In sys_ipc_recv\n");
									  break;
	case SYS_ipc_try_send: return_code = sys_ipc_try_send(a1,a2,(void*)a3,a4);
							break;
f01053bf:	e9 40 01 00 00       	jmp    f0105504 <syscall+0x734>

	case SYS_env_set_trapframe: return_code = sys_env_set_trapframe(a1,(void*)a2);
f01053c4:	89 de                	mov    %ebx,%esi
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	//panic("sys_env_set_trapframe not implemented");
	struct Env *sys_env;
	if(envid2env(envid,&sys_env,1)<0)
f01053c6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01053cd:	00 
f01053ce:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01053d1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053d5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01053d8:	89 04 24             	mov    %eax,(%esp)
f01053db:	e8 a5 e2 ff ff       	call   f0103685 <envid2env>
f01053e0:	85 c0                	test   %eax,%eax
f01053e2:	78 3d                	js     f0105421 <syscall+0x651>
		return -E_BAD_ENV;
	else
	{
		sys_env->env_tf = *tf;
f01053e4:	b9 11 00 00 00       	mov    $0x11,%ecx
f01053e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01053ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		user_mem_assert(sys_env,tf,sizeof(tf),PTE_U);
f01053ee:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f01053f5:	00 
f01053f6:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f01053fd:	00 
f01053fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105405:	89 04 24             	mov    %eax,(%esp)
f0105408:	e8 a3 e1 ff ff       	call   f01035b0 <user_mem_assert>
		sys_env->env_tf.tf_eflags = sys_env->env_tf.tf_eflags | FL_IF;
f010540d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105410:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
		return 0;
f0105417:	b8 00 00 00 00       	mov    $0x0,%eax
f010541c:	e9 e3 00 00 00       	jmp    f0105504 <syscall+0x734>
	// Remember to check whether the user has supplied us with a good
	// address!
	//panic("sys_env_set_trapframe not implemented");
	struct Env *sys_env;
	if(envid2env(envid,&sys_env,1)<0)
		return -E_BAD_ENV;
f0105421:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
									  break;
	case SYS_ipc_try_send: return_code = sys_ipc_try_send(a1,a2,(void*)a3,a4);
							break;

	case SYS_env_set_trapframe: return_code = sys_env_set_trapframe(a1,(void*)a2);
								break;
f0105426:	e9 d9 00 00 00       	jmp    f0105504 <syscall+0x734>
static int
sys_time_msec(void)
{
	// LAB 6: Your code here.
	//panic("sys_time_msec not implemented");
	return time_msec(cpunum());
f010542b:	e8 59 13 00 00       	call   f0106789 <cpunum>
f0105430:	89 04 24             	mov    %eax,(%esp)
f0105433:	e8 6f 22 00 00       	call   f01076a7 <time_msec>
							break;

	case SYS_env_set_trapframe: return_code = sys_env_set_trapframe(a1,(void*)a2);
								break;
	case SYS_time_msec : return_code = sys_time_msec();
						 break;
f0105438:	e9 c7 00 00 00       	jmp    f0105504 <syscall+0x734>
	return time_msec(cpunum());
}

static int sys_e1000_transmit(char *data,int len)
{
	cprintf("Length recieved in syscall.c is %d \n",len);
f010543d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105441:	c7 04 24 c0 90 10 f0 	movl   $0xf01090c0,(%esp)
f0105448:	e8 78 eb ff ff       	call   f0103fc5 <cprintf>
	user_mem_assert(curenv,data,len,0);
f010544d:	e8 37 13 00 00       	call   f0106789 <cpunum>
f0105452:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0105459:	00 
f010545a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f010545e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105461:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105465:	6b c0 74             	imul   $0x74,%eax,%eax
f0105468:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f010546e:	89 04 24             	mov    %eax,(%esp)
f0105471:	e8 3a e1 ff ff       	call   f01035b0 <user_mem_assert>
	int r = transmit_packet(data,len);
f0105476:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010547a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010547d:	89 04 24             	mov    %eax,(%esp)
f0105480:	e8 ba 18 00 00       	call   f0106d3f <transmit_packet>
	case SYS_env_set_trapframe: return_code = sys_env_set_trapframe(a1,(void*)a2);
								break;
	case SYS_time_msec : return_code = sys_time_msec();
						 break;
	case SYS_e1000_transmit : return_code = sys_e1000_transmit((char*)a1,(int)a2);
							 break;
f0105485:	eb 7d                	jmp    f0105504 <syscall+0x734>
	return r;
}
static int sys_e1000_recieve(char *data,int *len)
{
	int r ;
	user_mem_assert(curenv,data,strlen(data),0);
f0105487:	8b 45 0c             	mov    0xc(%ebp),%eax
f010548a:	89 04 24             	mov    %eax,(%esp)
f010548d:	e8 1e 0b 00 00       	call   f0105fb0 <strlen>
f0105492:	89 c6                	mov    %eax,%esi
f0105494:	e8 f0 12 00 00       	call   f0106789 <cpunum>
f0105499:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01054a0:	00 
f01054a1:	89 74 24 08          	mov    %esi,0x8(%esp)
f01054a5:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01054a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01054ac:	6b c0 74             	imul   $0x74,%eax,%eax
f01054af:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01054b5:	89 04 24             	mov    %eax,(%esp)
f01054b8:	e8 f3 e0 ff ff       	call   f01035b0 <user_mem_assert>
	user_mem_assert(curenv,len,sizeof(len),0);
f01054bd:	e8 c7 12 00 00       	call   f0106789 <cpunum>
f01054c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01054c9:	00 
f01054ca:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f01054d1:	00 
f01054d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01054d6:	6b c0 74             	imul   $0x74,%eax,%eax
f01054d9:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01054df:	89 04 24             	mov    %eax,(%esp)
f01054e2:	e8 c9 e0 ff ff       	call   f01035b0 <user_mem_assert>
		//sched_yield();
		r = recv_packet(data,len);
f01054e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01054eb:	8b 45 0c             	mov    0xc(%ebp),%eax
f01054ee:	89 04 24             	mov    %eax,(%esp)
f01054f1:	e8 5a 1a 00 00       	call   f0106f50 <recv_packet>
	case SYS_time_msec : return_code = sys_time_msec();
						 break;
	case SYS_e1000_transmit : return_code = sys_e1000_transmit((char*)a1,(int)a2);
							 break;
	case SYS_e1000_recieve  : return_code = sys_e1000_recieve((char*)a1,(int*)a2);
							  break;
f01054f6:	eb 0c                	jmp    f0105504 <syscall+0x734>
	default:
		return -E_INVAL;
f01054f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01054fd:	eb 05                	jmp    f0105504 <syscall+0x734>
						break;
	case SYS_page_unmap: return_code =sys_page_unmap(a1,(void*)a2);
						  break;
	case SYS_env_set_pgfault_upcall: return_code=sys_env_set_pgfault_upcall(a1,(void*)a2);
									  break;
	case SYS_ipc_recv : return_code = sys_ipc_recv((void*)a1);
f01054ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	return return_code;



}
f0105504:	83 c4 2c             	add    $0x2c,%esp
f0105507:	5b                   	pop    %ebx
f0105508:	5e                   	pop    %esi
f0105509:	5f                   	pop    %edi
f010550a:	5d                   	pop    %ebp
f010550b:	c3                   	ret    

f010550c <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f010550c:	55                   	push   %ebp
f010550d:	89 e5                	mov    %esp,%ebp
f010550f:	57                   	push   %edi
f0105510:	56                   	push   %esi
f0105511:	53                   	push   %ebx
f0105512:	83 ec 10             	sub    $0x10,%esp
f0105515:	89 c6                	mov    %eax,%esi
f0105517:	89 55 e8             	mov    %edx,-0x18(%ebp)
f010551a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f010551d:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105520:	8b 1a                	mov    (%edx),%ebx
f0105522:	8b 01                	mov    (%ecx),%eax
f0105524:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105527:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

	while (l <= r) {
f010552e:	eb 77                	jmp    f01055a7 <stab_binsearch+0x9b>
		int true_m = (l + r) / 2, m = true_m;
f0105530:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105533:	01 d8                	add    %ebx,%eax
f0105535:	b9 02 00 00 00       	mov    $0x2,%ecx
f010553a:	99                   	cltd   
f010553b:	f7 f9                	idiv   %ecx
f010553d:	89 c1                	mov    %eax,%ecx

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f010553f:	eb 01                	jmp    f0105542 <stab_binsearch+0x36>
			m--;
f0105541:	49                   	dec    %ecx

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105542:	39 d9                	cmp    %ebx,%ecx
f0105544:	7c 1d                	jl     f0105563 <stab_binsearch+0x57>
f0105546:	6b d1 0c             	imul   $0xc,%ecx,%edx
f0105549:	0f b6 54 16 04       	movzbl 0x4(%esi,%edx,1),%edx
f010554e:	39 fa                	cmp    %edi,%edx
f0105550:	75 ef                	jne    f0105541 <stab_binsearch+0x35>
f0105552:	89 4d ec             	mov    %ecx,-0x14(%ebp)
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105555:	6b d1 0c             	imul   $0xc,%ecx,%edx
f0105558:	8b 54 16 08          	mov    0x8(%esi,%edx,1),%edx
f010555c:	3b 55 0c             	cmp    0xc(%ebp),%edx
f010555f:	73 18                	jae    f0105579 <stab_binsearch+0x6d>
f0105561:	eb 05                	jmp    f0105568 <stab_binsearch+0x5c>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105563:	8d 58 01             	lea    0x1(%eax),%ebx
			continue;
f0105566:	eb 3f                	jmp    f01055a7 <stab_binsearch+0x9b>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0105568:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f010556b:	89 0b                	mov    %ecx,(%ebx)
			l = true_m + 1;
f010556d:	8d 58 01             	lea    0x1(%eax),%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105570:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
f0105577:	eb 2e                	jmp    f01055a7 <stab_binsearch+0x9b>
		if (stabs[m].n_value < addr) {
			*region_left = m;
			l = true_m + 1;
		} else if (stabs[m].n_value > addr) {
f0105579:	39 55 0c             	cmp    %edx,0xc(%ebp)
f010557c:	73 15                	jae    f0105593 <stab_binsearch+0x87>
			*region_right = m - 1;
f010557e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105581:	48                   	dec    %eax
f0105582:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105585:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105588:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f010558a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
f0105591:	eb 14                	jmp    f01055a7 <stab_binsearch+0x9b>
			*region_right = m - 1;
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105593:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105596:	8b 5d ec             	mov    -0x14(%ebp),%ebx
f0105599:	89 18                	mov    %ebx,(%eax)
			l = m;
			addr++;
f010559b:	ff 45 0c             	incl   0xc(%ebp)
f010559e:	89 cb                	mov    %ecx,%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f01055a0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
f01055a7:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f01055aa:	7e 84                	jle    f0105530 <stab_binsearch+0x24>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f01055ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
f01055b0:	75 0d                	jne    f01055bf <stab_binsearch+0xb3>
		*region_right = *region_left - 1;
f01055b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01055b5:	8b 00                	mov    (%eax),%eax
f01055b7:	48                   	dec    %eax
f01055b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01055bb:	89 07                	mov    %eax,(%edi)
f01055bd:	eb 22                	jmp    f01055e1 <stab_binsearch+0xd5>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01055bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01055c2:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f01055c4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f01055c7:	8b 0b                	mov    (%ebx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01055c9:	eb 01                	jmp    f01055cc <stab_binsearch+0xc0>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
f01055cb:	48                   	dec    %eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01055cc:	39 c1                	cmp    %eax,%ecx
f01055ce:	7d 0c                	jge    f01055dc <stab_binsearch+0xd0>
f01055d0:	6b d0 0c             	imul   $0xc,%eax,%edx
		     l > *region_left && stabs[l].n_type != type;
f01055d3:	0f b6 54 16 04       	movzbl 0x4(%esi,%edx,1),%edx
f01055d8:	39 fa                	cmp    %edi,%edx
f01055da:	75 ef                	jne    f01055cb <stab_binsearch+0xbf>
		     l--)
			/* do nothing */;
		*region_left = l;
f01055dc:	8b 7d e8             	mov    -0x18(%ebp),%edi
f01055df:	89 07                	mov    %eax,(%edi)
	}
}
f01055e1:	83 c4 10             	add    $0x10,%esp
f01055e4:	5b                   	pop    %ebx
f01055e5:	5e                   	pop    %esi
f01055e6:	5f                   	pop    %edi
f01055e7:	5d                   	pop    %ebp
f01055e8:	c3                   	ret    

f01055e9 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f01055e9:	55                   	push   %ebp
f01055ea:	89 e5                	mov    %esp,%ebp
f01055ec:	57                   	push   %edi
f01055ed:	56                   	push   %esi
f01055ee:	53                   	push   %ebx
f01055ef:	83 ec 4c             	sub    $0x4c,%esp
f01055f2:	8b 75 08             	mov    0x8(%ebp),%esi
f01055f5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f01055f8:	c7 03 2c 91 10 f0    	movl   $0xf010912c,(%ebx)
	info->eip_line = 0;
f01055fe:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105605:	c7 43 08 2c 91 10 f0 	movl   $0xf010912c,0x8(%ebx)
	info->eip_fn_namelen = 9;
f010560c:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105613:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105616:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f010561d:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0105623:	76 15                	jbe    f010563a <debuginfo_eip+0x51>


	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105625:	b8 6a 9c 11 f0       	mov    $0xf0119c6a,%eax
f010562a:	3d fd 56 11 f0       	cmp    $0xf01156fd,%eax
f010562f:	0f 86 8c 02 00 00    	jbe    f01058c1 <debuginfo_eip+0x2d8>
f0105635:	e9 d8 00 00 00       	jmp    f0105712 <debuginfo_eip+0x129>
		const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if(user_mem_check(curenv,usd,sizeof(struct UserStabData),PTE_U|PTE_P))
f010563a:	e8 4a 11 00 00       	call   f0106789 <cpunum>
f010563f:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f0105646:	00 
f0105647:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f010564e:	00 
f010564f:	c7 44 24 04 00 00 20 	movl   $0x200000,0x4(%esp)
f0105656:	00 
f0105657:	6b c0 74             	imul   $0x74,%eax,%eax
f010565a:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f0105660:	89 04 24             	mov    %eax,(%esp)
f0105663:	e8 87 de ff ff       	call   f01034ef <user_mem_check>
f0105668:	85 c0                	test   %eax,%eax
f010566a:	0f 85 58 02 00 00    	jne    f01058c8 <debuginfo_eip+0x2df>
			return -1;
		}



		stabs = usd->stabs;
f0105670:	8b 1d 00 00 20 00    	mov    0x200000,%ebx
		stab_end = usd->stab_end;
		stabstr = usd->stabstr;
f0105676:	8b 35 08 00 20 00    	mov    0x200008,%esi
		stabstr_end = usd->stabstr_end;
f010567c:	a1 0c 00 20 00       	mov    0x20000c,%eax
f0105681:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if(user_mem_check(curenv,stabs,stab_end-stabs,PTE_U|PTE_P)<0)
f0105684:	8b 3d 04 00 20 00    	mov    0x200004,%edi
f010568a:	29 df                	sub    %ebx,%edi
f010568c:	c1 ff 02             	sar    $0x2,%edi
f010568f:	69 ff ab aa aa aa    	imul   $0xaaaaaaab,%edi,%edi
f0105695:	e8 ef 10 00 00       	call   f0106789 <cpunum>
f010569a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f01056a1:	00 
f01056a2:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01056a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01056aa:	6b c0 74             	imul   $0x74,%eax,%eax
f01056ad:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01056b3:	89 04 24             	mov    %eax,(%esp)
f01056b6:	e8 34 de ff ff       	call   f01034ef <user_mem_check>
f01056bb:	85 c0                	test   %eax,%eax
f01056bd:	0f 88 0c 02 00 00    	js     f01058cf <debuginfo_eip+0x2e6>
		{
			return -1;
		}
		if(user_mem_check(curenv,stabstr,stabstr_end-stabstr,PTE_U|PTE_P)<0)
f01056c3:	e8 c1 10 00 00       	call   f0106789 <cpunum>
f01056c8:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
f01056cf:	00 
f01056d0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f01056d3:	29 f2                	sub    %esi,%edx
f01056d5:	89 54 24 08          	mov    %edx,0x8(%esp)
f01056d9:	89 74 24 04          	mov    %esi,0x4(%esp)
f01056dd:	6b c0 74             	imul   $0x74,%eax,%eax
f01056e0:	8b 80 28 90 31 f0    	mov    -0xfce6fd8(%eax),%eax
f01056e6:	89 04 24             	mov    %eax,(%esp)
f01056e9:	e8 01 de ff ff       	call   f01034ef <user_mem_check>
f01056ee:	85 c0                	test   %eax,%eax
f01056f0:	0f 88 e0 01 00 00    	js     f01058d6 <debuginfo_eip+0x2ed>
		{
			return -1;
		}
		// Can't search for user-level addresses yet!
  	        panic("User address");
f01056f6:	c7 44 24 08 36 91 10 	movl   $0xf0109136,0x8(%esp)
f01056fd:	f0 
f01056fe:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
f0105705:	00 
f0105706:	c7 04 24 43 91 10 f0 	movl   $0xf0109143,(%esp)
f010570d:	e8 8b a9 ff ff       	call   f010009d <_panic>


	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105712:	80 3d 69 9c 11 f0 00 	cmpb   $0x0,0xf0119c69
f0105719:	0f 85 be 01 00 00    	jne    f01058dd <debuginfo_eip+0x2f4>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f010571f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0105726:	b8 fc 56 11 f0       	mov    $0xf01156fc,%eax
f010572b:	2d 98 9a 10 f0       	sub    $0xf0109a98,%eax
f0105730:	c1 f8 02             	sar    $0x2,%eax
f0105733:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0105739:	83 e8 01             	sub    $0x1,%eax
f010573c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f010573f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105743:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f010574a:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f010574d:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105750:	b8 98 9a 10 f0       	mov    $0xf0109a98,%eax
f0105755:	e8 b2 fd ff ff       	call   f010550c <stab_binsearch>
	if (lfile == 0)
f010575a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010575d:	85 c0                	test   %eax,%eax
f010575f:	0f 84 7f 01 00 00    	je     f01058e4 <debuginfo_eip+0x2fb>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105765:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105768:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010576b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f010576e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105772:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0105779:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f010577c:	8d 55 dc             	lea    -0x24(%ebp),%edx
f010577f:	b8 98 9a 10 f0       	mov    $0xf0109a98,%eax
f0105784:	e8 83 fd ff ff       	call   f010550c <stab_binsearch>

	if (lfun <= rfun) {
f0105789:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010578c:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010578f:	39 d0                	cmp    %edx,%eax
f0105791:	7f 3d                	jg     f01057d0 <debuginfo_eip+0x1e7>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105793:	6b c8 0c             	imul   $0xc,%eax,%ecx
f0105796:	8d b9 98 9a 10 f0    	lea    -0xfef6568(%ecx),%edi
f010579c:	89 7d c4             	mov    %edi,-0x3c(%ebp)
f010579f:	8b 89 98 9a 10 f0    	mov    -0xfef6568(%ecx),%ecx
f01057a5:	bf 6a 9c 11 f0       	mov    $0xf0119c6a,%edi
f01057aa:	81 ef fd 56 11 f0    	sub    $0xf01156fd,%edi
f01057b0:	39 f9                	cmp    %edi,%ecx
f01057b2:	73 09                	jae    f01057bd <debuginfo_eip+0x1d4>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f01057b4:	81 c1 fd 56 11 f0    	add    $0xf01156fd,%ecx
f01057ba:	89 4b 08             	mov    %ecx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f01057bd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f01057c0:	8b 49 08             	mov    0x8(%ecx),%ecx
f01057c3:	89 4b 10             	mov    %ecx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f01057c6:	29 ce                	sub    %ecx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f01057c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f01057cb:	89 55 d0             	mov    %edx,-0x30(%ebp)
f01057ce:	eb 0f                	jmp    f01057df <debuginfo_eip+0x1f6>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f01057d0:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f01057d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01057d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f01057d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01057dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01057df:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f01057e6:	00 
f01057e7:	8b 43 08             	mov    0x8(%ebx),%eax
f01057ea:	89 04 24             	mov    %eax,(%esp)
f01057ed:	e8 29 09 00 00       	call   f010611b <strfind>
f01057f2:	2b 43 08             	sub    0x8(%ebx),%eax
f01057f5:	89 43 0c             	mov    %eax,0xc(%ebx)

	stab_binsearch(stabs,&lline,&rline,N_SLINE,addr);
f01057f8:	89 74 24 04          	mov    %esi,0x4(%esp)
f01057fc:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0105803:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105806:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105809:	b8 98 9a 10 f0       	mov    $0xf0109a98,%eax
f010580e:	e8 f9 fc ff ff       	call   f010550c <stab_binsearch>
	if(lline<=rline)
f0105813:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105816:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f0105819:	0f 8f cc 00 00 00    	jg     f01058eb <debuginfo_eip+0x302>
	{
		info->eip_line = stabs[lline].n_desc;
f010581f:	6b c0 0c             	imul   $0xc,%eax,%eax
f0105822:	0f b7 80 9e 9a 10 f0 	movzwl -0xfef6562(%eax),%eax
f0105829:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010582c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010582f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0105832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105835:	6b d0 0c             	imul   $0xc,%eax,%edx
f0105838:	81 c2 98 9a 10 f0    	add    $0xf0109a98,%edx
f010583e:	eb 06                	jmp    f0105846 <debuginfo_eip+0x25d>
f0105840:	83 e8 01             	sub    $0x1,%eax
f0105843:	83 ea 0c             	sub    $0xc,%edx
f0105846:	89 c6                	mov    %eax,%esi
f0105848:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
f010584b:	7f 33                	jg     f0105880 <debuginfo_eip+0x297>
	       && stabs[lline].n_type != N_SOL
f010584d:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0105851:	80 f9 84             	cmp    $0x84,%cl
f0105854:	74 0b                	je     f0105861 <debuginfo_eip+0x278>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105856:	80 f9 64             	cmp    $0x64,%cl
f0105859:	75 e5                	jne    f0105840 <debuginfo_eip+0x257>
f010585b:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
f010585f:	74 df                	je     f0105840 <debuginfo_eip+0x257>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105861:	6b f6 0c             	imul   $0xc,%esi,%esi
f0105864:	8b 86 98 9a 10 f0    	mov    -0xfef6568(%esi),%eax
f010586a:	ba 6a 9c 11 f0       	mov    $0xf0119c6a,%edx
f010586f:	81 ea fd 56 11 f0    	sub    $0xf01156fd,%edx
f0105875:	39 d0                	cmp    %edx,%eax
f0105877:	73 07                	jae    f0105880 <debuginfo_eip+0x297>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105879:	05 fd 56 11 f0       	add    $0xf01156fd,%eax
f010587e:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105880:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105883:	8b 4d d8             	mov    -0x28(%ebp),%ecx
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105886:	b8 00 00 00 00       	mov    $0x0,%eax
		info->eip_file = stabstr + stabs[lline].n_strx;


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f010588b:	39 ca                	cmp    %ecx,%edx
f010588d:	7d 68                	jge    f01058f7 <debuginfo_eip+0x30e>
		for (lline = lfun + 1;
f010588f:	8d 42 01             	lea    0x1(%edx),%eax
f0105892:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105895:	89 c2                	mov    %eax,%edx
f0105897:	6b c0 0c             	imul   $0xc,%eax,%eax
f010589a:	05 98 9a 10 f0       	add    $0xf0109a98,%eax
f010589f:	89 ce                	mov    %ecx,%esi
f01058a1:	eb 04                	jmp    f01058a7 <debuginfo_eip+0x2be>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f01058a3:	83 43 14 01          	addl   $0x1,0x14(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f01058a7:	39 d6                	cmp    %edx,%esi
f01058a9:	7e 47                	jle    f01058f2 <debuginfo_eip+0x309>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f01058ab:	0f b6 48 04          	movzbl 0x4(%eax),%ecx
f01058af:	83 c2 01             	add    $0x1,%edx
f01058b2:	83 c0 0c             	add    $0xc,%eax
f01058b5:	80 f9 a0             	cmp    $0xa0,%cl
f01058b8:	74 e9                	je     f01058a3 <debuginfo_eip+0x2ba>
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01058ba:	b8 00 00 00 00       	mov    $0x0,%eax
f01058bf:	eb 36                	jmp    f01058f7 <debuginfo_eip+0x30e>

	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f01058c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01058c6:	eb 2f                	jmp    f01058f7 <debuginfo_eip+0x30e>
		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.
		if(user_mem_check(curenv,usd,sizeof(struct UserStabData),PTE_U|PTE_P))
		{
			return -1;
f01058c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01058cd:	eb 28                	jmp    f01058f7 <debuginfo_eip+0x30e>

		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
		if(user_mem_check(curenv,stabs,stab_end-stabs,PTE_U|PTE_P)<0)
		{
			return -1;
f01058cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01058d4:	eb 21                	jmp    f01058f7 <debuginfo_eip+0x30e>
		}
		if(user_mem_check(curenv,stabstr,stabstr_end-stabstr,PTE_U|PTE_P)<0)
		{
			return -1;
f01058d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01058db:	eb 1a                	jmp    f01058f7 <debuginfo_eip+0x30e>

	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f01058dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01058e2:	eb 13                	jmp    f01058f7 <debuginfo_eip+0x30e>
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
	rfile = (stab_end - stabs) - 1;
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
	if (lfile == 0)
		return -1;
f01058e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01058e9:	eb 0c                	jmp    f01058f7 <debuginfo_eip+0x30e>
	{
		info->eip_line = stabs[lline].n_desc;
	}
	else
	{
		return -1;
f01058eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01058f0:	eb 05                	jmp    f01058f7 <debuginfo_eip+0x30e>
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f01058f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01058f7:	83 c4 4c             	add    $0x4c,%esp
f01058fa:	5b                   	pop    %ebx
f01058fb:	5e                   	pop    %esi
f01058fc:	5f                   	pop    %edi
f01058fd:	5d                   	pop    %ebp
f01058fe:	c3                   	ret    
f01058ff:	90                   	nop

f0105900 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105900:	55                   	push   %ebp
f0105901:	89 e5                	mov    %esp,%ebp
f0105903:	57                   	push   %edi
f0105904:	56                   	push   %esi
f0105905:	53                   	push   %ebx
f0105906:	83 ec 3c             	sub    $0x3c,%esp
f0105909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010590c:	89 d7                	mov    %edx,%edi
f010590e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105911:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105914:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105917:	89 c3                	mov    %eax,%ebx
f0105919:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010591c:	8b 45 10             	mov    0x10(%ebp),%eax
f010591f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105922:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105927:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010592a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010592d:	39 d9                	cmp    %ebx,%ecx
f010592f:	72 05                	jb     f0105936 <printnum+0x36>
f0105931:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f0105934:	77 69                	ja     f010599f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105936:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105939:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f010593d:	83 ee 01             	sub    $0x1,%esi
f0105940:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105944:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105948:	8b 44 24 08          	mov    0x8(%esp),%eax
f010594c:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0105950:	89 c3                	mov    %eax,%ebx
f0105952:	89 d6                	mov    %edx,%esi
f0105954:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105957:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010595a:	89 54 24 08          	mov    %edx,0x8(%esp)
f010595e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0105962:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105965:	89 04 24             	mov    %eax,(%esp)
f0105968:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010596b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010596f:	e8 4c 1d 00 00       	call   f01076c0 <__udivdi3>
f0105974:	89 d9                	mov    %ebx,%ecx
f0105976:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010597a:	89 74 24 0c          	mov    %esi,0xc(%esp)
f010597e:	89 04 24             	mov    %eax,(%esp)
f0105981:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105985:	89 fa                	mov    %edi,%edx
f0105987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010598a:	e8 71 ff ff ff       	call   f0105900 <printnum>
f010598f:	eb 1b                	jmp    f01059ac <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0105991:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105995:	8b 45 18             	mov    0x18(%ebp),%eax
f0105998:	89 04 24             	mov    %eax,(%esp)
f010599b:	ff d3                	call   *%ebx
f010599d:	eb 03                	jmp    f01059a2 <printnum+0xa2>
f010599f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f01059a2:	83 ee 01             	sub    $0x1,%esi
f01059a5:	85 f6                	test   %esi,%esi
f01059a7:	7f e8                	jg     f0105991 <printnum+0x91>
f01059a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01059ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01059b0:	8b 7c 24 04          	mov    0x4(%esp),%edi
f01059b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01059b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01059ba:	89 44 24 08          	mov    %eax,0x8(%esp)
f01059be:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01059c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01059c5:	89 04 24             	mov    %eax,(%esp)
f01059c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01059cb:	89 44 24 04          	mov    %eax,0x4(%esp)
f01059cf:	e8 1c 1e 00 00       	call   f01077f0 <__umoddi3>
f01059d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01059d8:	0f be 80 51 91 10 f0 	movsbl -0xfef6eaf(%eax),%eax
f01059df:	89 04 24             	mov    %eax,(%esp)
f01059e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01059e5:	ff d0                	call   *%eax
}
f01059e7:	83 c4 3c             	add    $0x3c,%esp
f01059ea:	5b                   	pop    %ebx
f01059eb:	5e                   	pop    %esi
f01059ec:	5f                   	pop    %edi
f01059ed:	5d                   	pop    %ebp
f01059ee:	c3                   	ret    

f01059ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f01059ef:	55                   	push   %ebp
f01059f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f01059f2:	83 fa 01             	cmp    $0x1,%edx
f01059f5:	7e 0e                	jle    f0105a05 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f01059f7:	8b 10                	mov    (%eax),%edx
f01059f9:	8d 4a 08             	lea    0x8(%edx),%ecx
f01059fc:	89 08                	mov    %ecx,(%eax)
f01059fe:	8b 02                	mov    (%edx),%eax
f0105a00:	8b 52 04             	mov    0x4(%edx),%edx
f0105a03:	eb 22                	jmp    f0105a27 <getuint+0x38>
	else if (lflag)
f0105a05:	85 d2                	test   %edx,%edx
f0105a07:	74 10                	je     f0105a19 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0105a09:	8b 10                	mov    (%eax),%edx
f0105a0b:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105a0e:	89 08                	mov    %ecx,(%eax)
f0105a10:	8b 02                	mov    (%edx),%eax
f0105a12:	ba 00 00 00 00       	mov    $0x0,%edx
f0105a17:	eb 0e                	jmp    f0105a27 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0105a19:	8b 10                	mov    (%eax),%edx
f0105a1b:	8d 4a 04             	lea    0x4(%edx),%ecx
f0105a1e:	89 08                	mov    %ecx,(%eax)
f0105a20:	8b 02                	mov    (%edx),%eax
f0105a22:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0105a27:	5d                   	pop    %ebp
f0105a28:	c3                   	ret    

f0105a29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0105a29:	55                   	push   %ebp
f0105a2a:	89 e5                	mov    %esp,%ebp
f0105a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f0105a2f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0105a33:	8b 10                	mov    (%eax),%edx
f0105a35:	3b 50 04             	cmp    0x4(%eax),%edx
f0105a38:	73 0a                	jae    f0105a44 <sprintputch+0x1b>
		*b->buf++ = ch;
f0105a3a:	8d 4a 01             	lea    0x1(%edx),%ecx
f0105a3d:	89 08                	mov    %ecx,(%eax)
f0105a3f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a42:	88 02                	mov    %al,(%edx)
}
f0105a44:	5d                   	pop    %ebp
f0105a45:	c3                   	ret    

f0105a46 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0105a46:	55                   	push   %ebp
f0105a47:	89 e5                	mov    %esp,%ebp
f0105a49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
f0105a4c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f0105a4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105a53:	8b 45 10             	mov    0x10(%ebp),%eax
f0105a56:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105a61:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a64:	89 04 24             	mov    %eax,(%esp)
f0105a67:	e8 02 00 00 00       	call   f0105a6e <vprintfmt>
	va_end(ap);
}
f0105a6c:	c9                   	leave  
f0105a6d:	c3                   	ret    

f0105a6e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0105a6e:	55                   	push   %ebp
f0105a6f:	89 e5                	mov    %esp,%ebp
f0105a71:	57                   	push   %edi
f0105a72:	56                   	push   %esi
f0105a73:	53                   	push   %ebx
f0105a74:	83 ec 3c             	sub    $0x3c,%esp
f0105a77:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105a7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0105a7d:	eb 14                	jmp    f0105a93 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f0105a7f:	85 c0                	test   %eax,%eax
f0105a81:	0f 84 b3 03 00 00    	je     f0105e3a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
f0105a87:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105a8b:	89 04 24             	mov    %eax,(%esp)
f0105a8e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0105a91:	89 f3                	mov    %esi,%ebx
f0105a93:	8d 73 01             	lea    0x1(%ebx),%esi
f0105a96:	0f b6 03             	movzbl (%ebx),%eax
f0105a99:	83 f8 25             	cmp    $0x25,%eax
f0105a9c:	75 e1                	jne    f0105a7f <vprintfmt+0x11>
f0105a9e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
f0105aa2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0105aa9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
f0105ab0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
f0105ab7:	ba 00 00 00 00       	mov    $0x0,%edx
f0105abc:	eb 1d                	jmp    f0105adb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105abe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
f0105ac0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
f0105ac4:	eb 15                	jmp    f0105adb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105ac6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f0105ac8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
f0105acc:	eb 0d                	jmp    f0105adb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f0105ace:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105ad1:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0105ad4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105adb:	8d 5e 01             	lea    0x1(%esi),%ebx
f0105ade:	0f b6 0e             	movzbl (%esi),%ecx
f0105ae1:	0f b6 c1             	movzbl %cl,%eax
f0105ae4:	83 e9 23             	sub    $0x23,%ecx
f0105ae7:	80 f9 55             	cmp    $0x55,%cl
f0105aea:	0f 87 2a 03 00 00    	ja     f0105e1a <vprintfmt+0x3ac>
f0105af0:	0f b6 c9             	movzbl %cl,%ecx
f0105af3:	ff 24 8d a0 92 10 f0 	jmp    *-0xfef6d60(,%ecx,4)
f0105afa:	89 de                	mov    %ebx,%esi
f0105afc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f0105b01:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
f0105b04:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
f0105b08:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
f0105b0b:	8d 58 d0             	lea    -0x30(%eax),%ebx
f0105b0e:	83 fb 09             	cmp    $0x9,%ebx
f0105b11:	77 36                	ja     f0105b49 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0105b13:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
f0105b16:	eb e9                	jmp    f0105b01 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0105b18:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b1b:	8d 48 04             	lea    0x4(%eax),%ecx
f0105b1e:	89 4d 14             	mov    %ecx,0x14(%ebp)
f0105b21:	8b 00                	mov    (%eax),%eax
f0105b23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105b26:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0105b28:	eb 22                	jmp    f0105b4c <vprintfmt+0xde>
f0105b2a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105b2d:	85 c9                	test   %ecx,%ecx
f0105b2f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105b34:	0f 49 c1             	cmovns %ecx,%eax
f0105b37:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105b3a:	89 de                	mov    %ebx,%esi
f0105b3c:	eb 9d                	jmp    f0105adb <vprintfmt+0x6d>
f0105b3e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f0105b40:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
f0105b47:	eb 92                	jmp    f0105adb <vprintfmt+0x6d>
f0105b49:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
f0105b4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f0105b50:	79 89                	jns    f0105adb <vprintfmt+0x6d>
f0105b52:	e9 77 ff ff ff       	jmp    f0105ace <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f0105b57:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105b5a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
f0105b5c:	e9 7a ff ff ff       	jmp    f0105adb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0105b61:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b64:	8d 50 04             	lea    0x4(%eax),%edx
f0105b67:	89 55 14             	mov    %edx,0x14(%ebp)
f0105b6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105b6e:	8b 00                	mov    (%eax),%eax
f0105b70:	89 04 24             	mov    %eax,(%esp)
f0105b73:	ff 55 08             	call   *0x8(%ebp)
			break;
f0105b76:	e9 18 ff ff ff       	jmp    f0105a93 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
f0105b7b:	8b 45 14             	mov    0x14(%ebp),%eax
f0105b7e:	8d 50 04             	lea    0x4(%eax),%edx
f0105b81:	89 55 14             	mov    %edx,0x14(%ebp)
f0105b84:	8b 00                	mov    (%eax),%eax
f0105b86:	99                   	cltd   
f0105b87:	31 d0                	xor    %edx,%eax
f0105b89:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105b8b:	83 f8 0f             	cmp    $0xf,%eax
f0105b8e:	7f 0b                	jg     f0105b9b <vprintfmt+0x12d>
f0105b90:	8b 14 85 00 94 10 f0 	mov    -0xfef6c00(,%eax,4),%edx
f0105b97:	85 d2                	test   %edx,%edx
f0105b99:	75 20                	jne    f0105bbb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
f0105b9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105b9f:	c7 44 24 08 69 91 10 	movl   $0xf0109169,0x8(%esp)
f0105ba6:	f0 
f0105ba7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105bab:	8b 45 08             	mov    0x8(%ebp),%eax
f0105bae:	89 04 24             	mov    %eax,(%esp)
f0105bb1:	e8 90 fe ff ff       	call   f0105a46 <printfmt>
f0105bb6:	e9 d8 fe ff ff       	jmp    f0105a93 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
f0105bbb:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105bbf:	c7 44 24 08 b4 7f 10 	movl   $0xf0107fb4,0x8(%esp)
f0105bc6:	f0 
f0105bc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105bcb:	8b 45 08             	mov    0x8(%ebp),%eax
f0105bce:	89 04 24             	mov    %eax,(%esp)
f0105bd1:	e8 70 fe ff ff       	call   f0105a46 <printfmt>
f0105bd6:	e9 b8 fe ff ff       	jmp    f0105a93 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0105bdb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0105bde:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105be1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0105be4:	8b 45 14             	mov    0x14(%ebp),%eax
f0105be7:	8d 50 04             	lea    0x4(%eax),%edx
f0105bea:	89 55 14             	mov    %edx,0x14(%ebp)
f0105bed:	8b 30                	mov    (%eax),%esi
				p = "(null)";
f0105bef:	85 f6                	test   %esi,%esi
f0105bf1:	b8 62 91 10 f0       	mov    $0xf0109162,%eax
f0105bf6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
f0105bf9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
f0105bfd:	0f 84 97 00 00 00    	je     f0105c9a <vprintfmt+0x22c>
f0105c03:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0105c07:	0f 8e 9b 00 00 00    	jle    f0105ca8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
f0105c0d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105c11:	89 34 24             	mov    %esi,(%esp)
f0105c14:	e8 af 03 00 00       	call   f0105fc8 <strnlen>
f0105c19:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0105c1c:	29 c2                	sub    %eax,%edx
f0105c1e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
f0105c21:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
f0105c25:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0105c28:	89 75 d8             	mov    %esi,-0x28(%ebp)
f0105c2b:	8b 75 08             	mov    0x8(%ebp),%esi
f0105c2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105c31:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0105c33:	eb 0f                	jmp    f0105c44 <vprintfmt+0x1d6>
					putch(padc, putdat);
f0105c35:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105c3c:	89 04 24             	mov    %eax,(%esp)
f0105c3f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0105c41:	83 eb 01             	sub    $0x1,%ebx
f0105c44:	85 db                	test   %ebx,%ebx
f0105c46:	7f ed                	jg     f0105c35 <vprintfmt+0x1c7>
f0105c48:	8b 75 d8             	mov    -0x28(%ebp),%esi
f0105c4b:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0105c4e:	85 d2                	test   %edx,%edx
f0105c50:	b8 00 00 00 00       	mov    $0x0,%eax
f0105c55:	0f 49 c2             	cmovns %edx,%eax
f0105c58:	29 c2                	sub    %eax,%edx
f0105c5a:	89 7d 0c             	mov    %edi,0xc(%ebp)
f0105c5d:	89 d7                	mov    %edx,%edi
f0105c5f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0105c62:	eb 50                	jmp    f0105cb4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f0105c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105c68:	74 1e                	je     f0105c88 <vprintfmt+0x21a>
f0105c6a:	0f be d2             	movsbl %dl,%edx
f0105c6d:	83 ea 20             	sub    $0x20,%edx
f0105c70:	83 fa 5e             	cmp    $0x5e,%edx
f0105c73:	76 13                	jbe    f0105c88 <vprintfmt+0x21a>
					putch('?', putdat);
f0105c75:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105c78:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105c7c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f0105c83:	ff 55 08             	call   *0x8(%ebp)
f0105c86:	eb 0d                	jmp    f0105c95 <vprintfmt+0x227>
				else
					putch(ch, putdat);
f0105c88:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c8b:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105c8f:	89 04 24             	mov    %eax,(%esp)
f0105c92:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0105c95:	83 ef 01             	sub    $0x1,%edi
f0105c98:	eb 1a                	jmp    f0105cb4 <vprintfmt+0x246>
f0105c9a:	89 7d 0c             	mov    %edi,0xc(%ebp)
f0105c9d:	8b 7d dc             	mov    -0x24(%ebp),%edi
f0105ca0:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105ca3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0105ca6:	eb 0c                	jmp    f0105cb4 <vprintfmt+0x246>
f0105ca8:	89 7d 0c             	mov    %edi,0xc(%ebp)
f0105cab:	8b 7d dc             	mov    -0x24(%ebp),%edi
f0105cae:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0105cb1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0105cb4:	83 c6 01             	add    $0x1,%esi
f0105cb7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
f0105cbb:	0f be c2             	movsbl %dl,%eax
f0105cbe:	85 c0                	test   %eax,%eax
f0105cc0:	74 27                	je     f0105ce9 <vprintfmt+0x27b>
f0105cc2:	85 db                	test   %ebx,%ebx
f0105cc4:	78 9e                	js     f0105c64 <vprintfmt+0x1f6>
f0105cc6:	83 eb 01             	sub    $0x1,%ebx
f0105cc9:	79 99                	jns    f0105c64 <vprintfmt+0x1f6>
f0105ccb:	89 f8                	mov    %edi,%eax
f0105ccd:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105cd0:	8b 75 08             	mov    0x8(%ebp),%esi
f0105cd3:	89 c3                	mov    %eax,%ebx
f0105cd5:	eb 1a                	jmp    f0105cf1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0105cd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105cdb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0105ce2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0105ce4:	83 eb 01             	sub    $0x1,%ebx
f0105ce7:	eb 08                	jmp    f0105cf1 <vprintfmt+0x283>
f0105ce9:	89 fb                	mov    %edi,%ebx
f0105ceb:	8b 75 08             	mov    0x8(%ebp),%esi
f0105cee:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105cf1:	85 db                	test   %ebx,%ebx
f0105cf3:	7f e2                	jg     f0105cd7 <vprintfmt+0x269>
f0105cf5:	89 75 08             	mov    %esi,0x8(%ebp)
f0105cf8:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0105cfb:	e9 93 fd ff ff       	jmp    f0105a93 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0105d00:	83 fa 01             	cmp    $0x1,%edx
f0105d03:	7e 16                	jle    f0105d1b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
f0105d05:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d08:	8d 50 08             	lea    0x8(%eax),%edx
f0105d0b:	89 55 14             	mov    %edx,0x14(%ebp)
f0105d0e:	8b 50 04             	mov    0x4(%eax),%edx
f0105d11:	8b 00                	mov    (%eax),%eax
f0105d13:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105d16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105d19:	eb 32                	jmp    f0105d4d <vprintfmt+0x2df>
	else if (lflag)
f0105d1b:	85 d2                	test   %edx,%edx
f0105d1d:	74 18                	je     f0105d37 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
f0105d1f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d22:	8d 50 04             	lea    0x4(%eax),%edx
f0105d25:	89 55 14             	mov    %edx,0x14(%ebp)
f0105d28:	8b 30                	mov    (%eax),%esi
f0105d2a:	89 75 e0             	mov    %esi,-0x20(%ebp)
f0105d2d:	89 f0                	mov    %esi,%eax
f0105d2f:	c1 f8 1f             	sar    $0x1f,%eax
f0105d32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105d35:	eb 16                	jmp    f0105d4d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
f0105d37:	8b 45 14             	mov    0x14(%ebp),%eax
f0105d3a:	8d 50 04             	lea    0x4(%eax),%edx
f0105d3d:	89 55 14             	mov    %edx,0x14(%ebp)
f0105d40:	8b 30                	mov    (%eax),%esi
f0105d42:	89 75 e0             	mov    %esi,-0x20(%ebp)
f0105d45:	89 f0                	mov    %esi,%eax
f0105d47:	c1 f8 1f             	sar    $0x1f,%eax
f0105d4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f0105d4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f0105d53:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f0105d58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0105d5c:	0f 89 80 00 00 00    	jns    f0105de2 <vprintfmt+0x374>
				putch('-', putdat);
f0105d62:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105d66:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f0105d6d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f0105d70:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105d76:	f7 d8                	neg    %eax
f0105d78:	83 d2 00             	adc    $0x0,%edx
f0105d7b:	f7 da                	neg    %edx
			}
			base = 10;
f0105d7d:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0105d82:	eb 5e                	jmp    f0105de2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0105d84:	8d 45 14             	lea    0x14(%ebp),%eax
f0105d87:	e8 63 fc ff ff       	call   f01059ef <getuint>
			base = 10;
f0105d8c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
f0105d91:	eb 4f                	jmp    f0105de2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
f0105d93:	8d 45 14             	lea    0x14(%ebp),%eax
f0105d96:	e8 54 fc ff ff       	call   f01059ef <getuint>
			base =8;
f0105d9b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
f0105da0:	eb 40                	jmp    f0105de2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
f0105da2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105da6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0105dad:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f0105db0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105db4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0105dbb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f0105dbe:	8b 45 14             	mov    0x14(%ebp),%eax
f0105dc1:	8d 50 04             	lea    0x4(%eax),%edx
f0105dc4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f0105dc7:	8b 00                	mov    (%eax),%eax
f0105dc9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f0105dce:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
f0105dd3:	eb 0d                	jmp    f0105de2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0105dd5:	8d 45 14             	lea    0x14(%ebp),%eax
f0105dd8:	e8 12 fc ff ff       	call   f01059ef <getuint>
			base = 16;
f0105ddd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
f0105de2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
f0105de6:	89 74 24 10          	mov    %esi,0x10(%esp)
f0105dea:	8b 75 dc             	mov    -0x24(%ebp),%esi
f0105ded:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105df1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105df5:	89 04 24             	mov    %eax,(%esp)
f0105df8:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105dfc:	89 fa                	mov    %edi,%edx
f0105dfe:	8b 45 08             	mov    0x8(%ebp),%eax
f0105e01:	e8 fa fa ff ff       	call   f0105900 <printnum>
			break;
f0105e06:	e9 88 fc ff ff       	jmp    f0105a93 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0105e0b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105e0f:	89 04 24             	mov    %eax,(%esp)
f0105e12:	ff 55 08             	call   *0x8(%ebp)
			break;
f0105e15:	e9 79 fc ff ff       	jmp    f0105a93 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0105e1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105e1e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0105e25:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105e28:	89 f3                	mov    %esi,%ebx
f0105e2a:	eb 03                	jmp    f0105e2f <vprintfmt+0x3c1>
f0105e2c:	83 eb 01             	sub    $0x1,%ebx
f0105e2f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f0105e33:	75 f7                	jne    f0105e2c <vprintfmt+0x3be>
f0105e35:	e9 59 fc ff ff       	jmp    f0105a93 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
f0105e3a:	83 c4 3c             	add    $0x3c,%esp
f0105e3d:	5b                   	pop    %ebx
f0105e3e:	5e                   	pop    %esi
f0105e3f:	5f                   	pop    %edi
f0105e40:	5d                   	pop    %ebp
f0105e41:	c3                   	ret    

f0105e42 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0105e42:	55                   	push   %ebp
f0105e43:	89 e5                	mov    %esp,%ebp
f0105e45:	83 ec 28             	sub    $0x28,%esp
f0105e48:	8b 45 08             	mov    0x8(%ebp),%eax
f0105e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0105e4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105e51:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0105e55:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0105e58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0105e5f:	85 c0                	test   %eax,%eax
f0105e61:	74 30                	je     f0105e93 <vsnprintf+0x51>
f0105e63:	85 d2                	test   %edx,%edx
f0105e65:	7e 2c                	jle    f0105e93 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0105e67:	8b 45 14             	mov    0x14(%ebp),%eax
f0105e6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105e6e:	8b 45 10             	mov    0x10(%ebp),%eax
f0105e71:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105e75:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105e78:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105e7c:	c7 04 24 29 5a 10 f0 	movl   $0xf0105a29,(%esp)
f0105e83:	e8 e6 fb ff ff       	call   f0105a6e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0105e88:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105e8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105e91:	eb 05                	jmp    f0105e98 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f0105e93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f0105e98:	c9                   	leave  
f0105e99:	c3                   	ret    

f0105e9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105e9a:	55                   	push   %ebp
f0105e9b:	89 e5                	mov    %esp,%ebp
f0105e9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105ea0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105ea3:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105ea7:	8b 45 10             	mov    0x10(%ebp),%eax
f0105eaa:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105eae:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105eb5:	8b 45 08             	mov    0x8(%ebp),%eax
f0105eb8:	89 04 24             	mov    %eax,(%esp)
f0105ebb:	e8 82 ff ff ff       	call   f0105e42 <vsnprintf>
	va_end(ap);

	return rc;
}
f0105ec0:	c9                   	leave  
f0105ec1:	c3                   	ret    
f0105ec2:	66 90                	xchg   %ax,%ax
f0105ec4:	66 90                	xchg   %ax,%ax
f0105ec6:	66 90                	xchg   %ax,%ax
f0105ec8:	66 90                	xchg   %ax,%ax
f0105eca:	66 90                	xchg   %ax,%ax
f0105ecc:	66 90                	xchg   %ax,%ax
f0105ece:	66 90                	xchg   %ax,%ax

f0105ed0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0105ed0:	55                   	push   %ebp
f0105ed1:	89 e5                	mov    %esp,%ebp
f0105ed3:	57                   	push   %edi
f0105ed4:	56                   	push   %esi
f0105ed5:	53                   	push   %ebx
f0105ed6:	83 ec 1c             	sub    $0x1c,%esp
f0105ed9:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;


#if JOS_KERNEL
	if (prompt != NULL)
f0105edc:	85 c0                	test   %eax,%eax
f0105ede:	74 10                	je     f0105ef0 <readline+0x20>
		cprintf("%s", prompt);
f0105ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105ee4:	c7 04 24 b4 7f 10 f0 	movl   $0xf0107fb4,(%esp)
f0105eeb:	e8 d5 e0 ff ff       	call   f0103fc5 <cprintf>
		fprintf(1, "%s", prompt);
#endif


	i = 0;
	echoing = iscons(0);
f0105ef0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0105ef7:	e8 4c a9 ff ff       	call   f0100848 <iscons>
f0105efc:	89 c7                	mov    %eax,%edi
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif


	i = 0;
f0105efe:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
f0105f03:	e8 2f a9 ff ff       	call   f0100837 <getchar>
f0105f08:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0105f0a:	85 c0                	test   %eax,%eax
f0105f0c:	79 25                	jns    f0105f33 <readline+0x63>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);

			return NULL;
f0105f0e:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
f0105f13:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0105f16:	0f 84 89 00 00 00    	je     f0105fa5 <readline+0xd5>
				cprintf("read error: %e\n", c);
f0105f1c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105f20:	c7 04 24 5f 94 10 f0 	movl   $0xf010945f,(%esp)
f0105f27:	e8 99 e0 ff ff       	call   f0103fc5 <cprintf>

			return NULL;
f0105f2c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f31:	eb 72                	jmp    f0105fa5 <readline+0xd5>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105f33:	83 f8 7f             	cmp    $0x7f,%eax
f0105f36:	74 05                	je     f0105f3d <readline+0x6d>
f0105f38:	83 f8 08             	cmp    $0x8,%eax
f0105f3b:	75 1a                	jne    f0105f57 <readline+0x87>
f0105f3d:	85 f6                	test   %esi,%esi
f0105f3f:	90                   	nop
f0105f40:	7e 15                	jle    f0105f57 <readline+0x87>
			if (echoing)
f0105f42:	85 ff                	test   %edi,%edi
f0105f44:	74 0c                	je     f0105f52 <readline+0x82>
				cputchar('\b');
f0105f46:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0105f4d:	e8 d5 a8 ff ff       	call   f0100827 <cputchar>
			i--;
f0105f52:	83 ee 01             	sub    $0x1,%esi
f0105f55:	eb ac                	jmp    f0105f03 <readline+0x33>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0105f57:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0105f5d:	7f 1c                	jg     f0105f7b <readline+0xab>
f0105f5f:	83 fb 1f             	cmp    $0x1f,%ebx
f0105f62:	7e 17                	jle    f0105f7b <readline+0xab>
			if (echoing)
f0105f64:	85 ff                	test   %edi,%edi
f0105f66:	74 08                	je     f0105f70 <readline+0xa0>
				cputchar(c);
f0105f68:	89 1c 24             	mov    %ebx,(%esp)
f0105f6b:	e8 b7 a8 ff ff       	call   f0100827 <cputchar>
			buf[i++] = c;
f0105f70:	88 9e 80 8a 2b f0    	mov    %bl,-0xfd47580(%esi)
f0105f76:	8d 76 01             	lea    0x1(%esi),%esi
f0105f79:	eb 88                	jmp    f0105f03 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0105f7b:	83 fb 0d             	cmp    $0xd,%ebx
f0105f7e:	74 09                	je     f0105f89 <readline+0xb9>
f0105f80:	83 fb 0a             	cmp    $0xa,%ebx
f0105f83:	0f 85 7a ff ff ff    	jne    f0105f03 <readline+0x33>
			if (echoing)
f0105f89:	85 ff                	test   %edi,%edi
f0105f8b:	74 0c                	je     f0105f99 <readline+0xc9>
				cputchar('\n');
f0105f8d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f0105f94:	e8 8e a8 ff ff       	call   f0100827 <cputchar>
			buf[i] = 0;
f0105f99:	c6 86 80 8a 2b f0 00 	movb   $0x0,-0xfd47580(%esi)
			return buf;
f0105fa0:	b8 80 8a 2b f0       	mov    $0xf02b8a80,%eax
		}
	}
}
f0105fa5:	83 c4 1c             	add    $0x1c,%esp
f0105fa8:	5b                   	pop    %ebx
f0105fa9:	5e                   	pop    %esi
f0105faa:	5f                   	pop    %edi
f0105fab:	5d                   	pop    %ebp
f0105fac:	c3                   	ret    
f0105fad:	66 90                	xchg   %ax,%ax
f0105faf:	90                   	nop

f0105fb0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105fb0:	55                   	push   %ebp
f0105fb1:	89 e5                	mov    %esp,%ebp
f0105fb3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105fb6:	b8 00 00 00 00       	mov    $0x0,%eax
f0105fbb:	eb 03                	jmp    f0105fc0 <strlen+0x10>
		n++;
f0105fbd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0105fc0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105fc4:	75 f7                	jne    f0105fbd <strlen+0xd>
		n++;
	return n;
}
f0105fc6:	5d                   	pop    %ebp
f0105fc7:	c3                   	ret    

f0105fc8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105fc8:	55                   	push   %ebp
f0105fc9:	89 e5                	mov    %esp,%ebp
f0105fcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105fce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105fd1:	b8 00 00 00 00       	mov    $0x0,%eax
f0105fd6:	eb 03                	jmp    f0105fdb <strnlen+0x13>
		n++;
f0105fd8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105fdb:	39 d0                	cmp    %edx,%eax
f0105fdd:	74 06                	je     f0105fe5 <strnlen+0x1d>
f0105fdf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0105fe3:	75 f3                	jne    f0105fd8 <strnlen+0x10>
		n++;
	return n;
}
f0105fe5:	5d                   	pop    %ebp
f0105fe6:	c3                   	ret    

f0105fe7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105fe7:	55                   	push   %ebp
f0105fe8:	89 e5                	mov    %esp,%ebp
f0105fea:	53                   	push   %ebx
f0105feb:	8b 45 08             	mov    0x8(%ebp),%eax
f0105fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105ff1:	89 c2                	mov    %eax,%edx
f0105ff3:	83 c2 01             	add    $0x1,%edx
f0105ff6:	83 c1 01             	add    $0x1,%ecx
f0105ff9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f0105ffd:	88 5a ff             	mov    %bl,-0x1(%edx)
f0106000:	84 db                	test   %bl,%bl
f0106002:	75 ef                	jne    f0105ff3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0106004:	5b                   	pop    %ebx
f0106005:	5d                   	pop    %ebp
f0106006:	c3                   	ret    

f0106007 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0106007:	55                   	push   %ebp
f0106008:	89 e5                	mov    %esp,%ebp
f010600a:	53                   	push   %ebx
f010600b:	83 ec 08             	sub    $0x8,%esp
f010600e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0106011:	89 1c 24             	mov    %ebx,(%esp)
f0106014:	e8 97 ff ff ff       	call   f0105fb0 <strlen>
	strcpy(dst + len, src);
f0106019:	8b 55 0c             	mov    0xc(%ebp),%edx
f010601c:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106020:	01 d8                	add    %ebx,%eax
f0106022:	89 04 24             	mov    %eax,(%esp)
f0106025:	e8 bd ff ff ff       	call   f0105fe7 <strcpy>
	return dst;
}
f010602a:	89 d8                	mov    %ebx,%eax
f010602c:	83 c4 08             	add    $0x8,%esp
f010602f:	5b                   	pop    %ebx
f0106030:	5d                   	pop    %ebp
f0106031:	c3                   	ret    

f0106032 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0106032:	55                   	push   %ebp
f0106033:	89 e5                	mov    %esp,%ebp
f0106035:	56                   	push   %esi
f0106036:	53                   	push   %ebx
f0106037:	8b 75 08             	mov    0x8(%ebp),%esi
f010603a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010603d:	89 f3                	mov    %esi,%ebx
f010603f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0106042:	89 f2                	mov    %esi,%edx
f0106044:	eb 0f                	jmp    f0106055 <strncpy+0x23>
		*dst++ = *src;
f0106046:	83 c2 01             	add    $0x1,%edx
f0106049:	0f b6 01             	movzbl (%ecx),%eax
f010604c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f010604f:	80 39 01             	cmpb   $0x1,(%ecx)
f0106052:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0106055:	39 da                	cmp    %ebx,%edx
f0106057:	75 ed                	jne    f0106046 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0106059:	89 f0                	mov    %esi,%eax
f010605b:	5b                   	pop    %ebx
f010605c:	5e                   	pop    %esi
f010605d:	5d                   	pop    %ebp
f010605e:	c3                   	ret    

f010605f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f010605f:	55                   	push   %ebp
f0106060:	89 e5                	mov    %esp,%ebp
f0106062:	56                   	push   %esi
f0106063:	53                   	push   %ebx
f0106064:	8b 75 08             	mov    0x8(%ebp),%esi
f0106067:	8b 55 0c             	mov    0xc(%ebp),%edx
f010606a:	8b 4d 10             	mov    0x10(%ebp),%ecx
f010606d:	89 f0                	mov    %esi,%eax
f010606f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0106073:	85 c9                	test   %ecx,%ecx
f0106075:	75 0b                	jne    f0106082 <strlcpy+0x23>
f0106077:	eb 1d                	jmp    f0106096 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0106079:	83 c0 01             	add    $0x1,%eax
f010607c:	83 c2 01             	add    $0x1,%edx
f010607f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0106082:	39 d8                	cmp    %ebx,%eax
f0106084:	74 0b                	je     f0106091 <strlcpy+0x32>
f0106086:	0f b6 0a             	movzbl (%edx),%ecx
f0106089:	84 c9                	test   %cl,%cl
f010608b:	75 ec                	jne    f0106079 <strlcpy+0x1a>
f010608d:	89 c2                	mov    %eax,%edx
f010608f:	eb 02                	jmp    f0106093 <strlcpy+0x34>
f0106091:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
f0106093:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
f0106096:	29 f0                	sub    %esi,%eax
}
f0106098:	5b                   	pop    %ebx
f0106099:	5e                   	pop    %esi
f010609a:	5d                   	pop    %ebp
f010609b:	c3                   	ret    

f010609c <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010609c:	55                   	push   %ebp
f010609d:	89 e5                	mov    %esp,%ebp
f010609f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01060a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01060a5:	eb 06                	jmp    f01060ad <strcmp+0x11>
		p++, q++;
f01060a7:	83 c1 01             	add    $0x1,%ecx
f01060aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f01060ad:	0f b6 01             	movzbl (%ecx),%eax
f01060b0:	84 c0                	test   %al,%al
f01060b2:	74 04                	je     f01060b8 <strcmp+0x1c>
f01060b4:	3a 02                	cmp    (%edx),%al
f01060b6:	74 ef                	je     f01060a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f01060b8:	0f b6 c0             	movzbl %al,%eax
f01060bb:	0f b6 12             	movzbl (%edx),%edx
f01060be:	29 d0                	sub    %edx,%eax
}
f01060c0:	5d                   	pop    %ebp
f01060c1:	c3                   	ret    

f01060c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01060c2:	55                   	push   %ebp
f01060c3:	89 e5                	mov    %esp,%ebp
f01060c5:	53                   	push   %ebx
f01060c6:	8b 45 08             	mov    0x8(%ebp),%eax
f01060c9:	8b 55 0c             	mov    0xc(%ebp),%edx
f01060cc:	89 c3                	mov    %eax,%ebx
f01060ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f01060d1:	eb 06                	jmp    f01060d9 <strncmp+0x17>
		n--, p++, q++;
f01060d3:	83 c0 01             	add    $0x1,%eax
f01060d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f01060d9:	39 d8                	cmp    %ebx,%eax
f01060db:	74 15                	je     f01060f2 <strncmp+0x30>
f01060dd:	0f b6 08             	movzbl (%eax),%ecx
f01060e0:	84 c9                	test   %cl,%cl
f01060e2:	74 04                	je     f01060e8 <strncmp+0x26>
f01060e4:	3a 0a                	cmp    (%edx),%cl
f01060e6:	74 eb                	je     f01060d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f01060e8:	0f b6 00             	movzbl (%eax),%eax
f01060eb:	0f b6 12             	movzbl (%edx),%edx
f01060ee:	29 d0                	sub    %edx,%eax
f01060f0:	eb 05                	jmp    f01060f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
f01060f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f01060f7:	5b                   	pop    %ebx
f01060f8:	5d                   	pop    %ebp
f01060f9:	c3                   	ret    

f01060fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f01060fa:	55                   	push   %ebp
f01060fb:	89 e5                	mov    %esp,%ebp
f01060fd:	8b 45 08             	mov    0x8(%ebp),%eax
f0106100:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106104:	eb 07                	jmp    f010610d <strchr+0x13>
		if (*s == c)
f0106106:	38 ca                	cmp    %cl,%dl
f0106108:	74 0f                	je     f0106119 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f010610a:	83 c0 01             	add    $0x1,%eax
f010610d:	0f b6 10             	movzbl (%eax),%edx
f0106110:	84 d2                	test   %dl,%dl
f0106112:	75 f2                	jne    f0106106 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
f0106114:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106119:	5d                   	pop    %ebp
f010611a:	c3                   	ret    

f010611b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010611b:	55                   	push   %ebp
f010611c:	89 e5                	mov    %esp,%ebp
f010611e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106121:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106125:	eb 07                	jmp    f010612e <strfind+0x13>
		if (*s == c)
f0106127:	38 ca                	cmp    %cl,%dl
f0106129:	74 0a                	je     f0106135 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f010612b:	83 c0 01             	add    $0x1,%eax
f010612e:	0f b6 10             	movzbl (%eax),%edx
f0106131:	84 d2                	test   %dl,%dl
f0106133:	75 f2                	jne    f0106127 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
f0106135:	5d                   	pop    %ebp
f0106136:	c3                   	ret    

f0106137 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0106137:	55                   	push   %ebp
f0106138:	89 e5                	mov    %esp,%ebp
f010613a:	57                   	push   %edi
f010613b:	56                   	push   %esi
f010613c:	53                   	push   %ebx
f010613d:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106140:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0106143:	85 c9                	test   %ecx,%ecx
f0106145:	74 36                	je     f010617d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0106147:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010614d:	75 28                	jne    f0106177 <memset+0x40>
f010614f:	f6 c1 03             	test   $0x3,%cl
f0106152:	75 23                	jne    f0106177 <memset+0x40>
		c &= 0xFF;
f0106154:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0106158:	89 d3                	mov    %edx,%ebx
f010615a:	c1 e3 08             	shl    $0x8,%ebx
f010615d:	89 d6                	mov    %edx,%esi
f010615f:	c1 e6 18             	shl    $0x18,%esi
f0106162:	89 d0                	mov    %edx,%eax
f0106164:	c1 e0 10             	shl    $0x10,%eax
f0106167:	09 f0                	or     %esi,%eax
f0106169:	09 c2                	or     %eax,%edx
f010616b:	89 d0                	mov    %edx,%eax
f010616d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f010616f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f0106172:	fc                   	cld    
f0106173:	f3 ab                	rep stos %eax,%es:(%edi)
f0106175:	eb 06                	jmp    f010617d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0106177:	8b 45 0c             	mov    0xc(%ebp),%eax
f010617a:	fc                   	cld    
f010617b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f010617d:	89 f8                	mov    %edi,%eax
f010617f:	5b                   	pop    %ebx
f0106180:	5e                   	pop    %esi
f0106181:	5f                   	pop    %edi
f0106182:	5d                   	pop    %ebp
f0106183:	c3                   	ret    

f0106184 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0106184:	55                   	push   %ebp
f0106185:	89 e5                	mov    %esp,%ebp
f0106187:	57                   	push   %edi
f0106188:	56                   	push   %esi
f0106189:	8b 45 08             	mov    0x8(%ebp),%eax
f010618c:	8b 75 0c             	mov    0xc(%ebp),%esi
f010618f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106192:	39 c6                	cmp    %eax,%esi
f0106194:	73 35                	jae    f01061cb <memmove+0x47>
f0106196:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106199:	39 d0                	cmp    %edx,%eax
f010619b:	73 2e                	jae    f01061cb <memmove+0x47>
		s += n;
		d += n;
f010619d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f01061a0:	89 d6                	mov    %edx,%esi
f01061a2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01061a4:	f7 c6 03 00 00 00    	test   $0x3,%esi
f01061aa:	75 13                	jne    f01061bf <memmove+0x3b>
f01061ac:	f6 c1 03             	test   $0x3,%cl
f01061af:	75 0e                	jne    f01061bf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f01061b1:	83 ef 04             	sub    $0x4,%edi
f01061b4:	8d 72 fc             	lea    -0x4(%edx),%esi
f01061b7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
f01061ba:	fd                   	std    
f01061bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01061bd:	eb 09                	jmp    f01061c8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f01061bf:	83 ef 01             	sub    $0x1,%edi
f01061c2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f01061c5:	fd                   	std    
f01061c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f01061c8:	fc                   	cld    
f01061c9:	eb 1d                	jmp    f01061e8 <memmove+0x64>
f01061cb:	89 f2                	mov    %esi,%edx
f01061cd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f01061cf:	f6 c2 03             	test   $0x3,%dl
f01061d2:	75 0f                	jne    f01061e3 <memmove+0x5f>
f01061d4:	f6 c1 03             	test   $0x3,%cl
f01061d7:	75 0a                	jne    f01061e3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f01061d9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
f01061dc:	89 c7                	mov    %eax,%edi
f01061de:	fc                   	cld    
f01061df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01061e1:	eb 05                	jmp    f01061e8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f01061e3:	89 c7                	mov    %eax,%edi
f01061e5:	fc                   	cld    
f01061e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f01061e8:	5e                   	pop    %esi
f01061e9:	5f                   	pop    %edi
f01061ea:	5d                   	pop    %ebp
f01061eb:	c3                   	ret    

f01061ec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f01061ec:	55                   	push   %ebp
f01061ed:	89 e5                	mov    %esp,%ebp
f01061ef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f01061f2:	8b 45 10             	mov    0x10(%ebp),%eax
f01061f5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01061f9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01061fc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106200:	8b 45 08             	mov    0x8(%ebp),%eax
f0106203:	89 04 24             	mov    %eax,(%esp)
f0106206:	e8 79 ff ff ff       	call   f0106184 <memmove>
}
f010620b:	c9                   	leave  
f010620c:	c3                   	ret    

f010620d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010620d:	55                   	push   %ebp
f010620e:	89 e5                	mov    %esp,%ebp
f0106210:	56                   	push   %esi
f0106211:	53                   	push   %ebx
f0106212:	8b 55 08             	mov    0x8(%ebp),%edx
f0106215:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106218:	89 d6                	mov    %edx,%esi
f010621a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010621d:	eb 1a                	jmp    f0106239 <memcmp+0x2c>
		if (*s1 != *s2)
f010621f:	0f b6 02             	movzbl (%edx),%eax
f0106222:	0f b6 19             	movzbl (%ecx),%ebx
f0106225:	38 d8                	cmp    %bl,%al
f0106227:	74 0a                	je     f0106233 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
f0106229:	0f b6 c0             	movzbl %al,%eax
f010622c:	0f b6 db             	movzbl %bl,%ebx
f010622f:	29 d8                	sub    %ebx,%eax
f0106231:	eb 0f                	jmp    f0106242 <memcmp+0x35>
		s1++, s2++;
f0106233:	83 c2 01             	add    $0x1,%edx
f0106236:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0106239:	39 f2                	cmp    %esi,%edx
f010623b:	75 e2                	jne    f010621f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f010623d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106242:	5b                   	pop    %ebx
f0106243:	5e                   	pop    %esi
f0106244:	5d                   	pop    %ebp
f0106245:	c3                   	ret    

f0106246 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0106246:	55                   	push   %ebp
f0106247:	89 e5                	mov    %esp,%ebp
f0106249:	8b 45 08             	mov    0x8(%ebp),%eax
f010624c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f010624f:	89 c2                	mov    %eax,%edx
f0106251:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0106254:	eb 07                	jmp    f010625d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
f0106256:	38 08                	cmp    %cl,(%eax)
f0106258:	74 07                	je     f0106261 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f010625a:	83 c0 01             	add    $0x1,%eax
f010625d:	39 d0                	cmp    %edx,%eax
f010625f:	72 f5                	jb     f0106256 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0106261:	5d                   	pop    %ebp
f0106262:	c3                   	ret    

f0106263 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0106263:	55                   	push   %ebp
f0106264:	89 e5                	mov    %esp,%ebp
f0106266:	57                   	push   %edi
f0106267:	56                   	push   %esi
f0106268:	53                   	push   %ebx
f0106269:	8b 55 08             	mov    0x8(%ebp),%edx
f010626c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f010626f:	eb 03                	jmp    f0106274 <strtol+0x11>
		s++;
f0106271:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0106274:	0f b6 0a             	movzbl (%edx),%ecx
f0106277:	80 f9 09             	cmp    $0x9,%cl
f010627a:	74 f5                	je     f0106271 <strtol+0xe>
f010627c:	80 f9 20             	cmp    $0x20,%cl
f010627f:	74 f0                	je     f0106271 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
f0106281:	80 f9 2b             	cmp    $0x2b,%cl
f0106284:	75 0a                	jne    f0106290 <strtol+0x2d>
		s++;
f0106286:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f0106289:	bf 00 00 00 00       	mov    $0x0,%edi
f010628e:	eb 11                	jmp    f01062a1 <strtol+0x3e>
f0106290:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f0106295:	80 f9 2d             	cmp    $0x2d,%cl
f0106298:	75 07                	jne    f01062a1 <strtol+0x3e>
		s++, neg = 1;
f010629a:	8d 52 01             	lea    0x1(%edx),%edx
f010629d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f01062a1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
f01062a6:	75 15                	jne    f01062bd <strtol+0x5a>
f01062a8:	80 3a 30             	cmpb   $0x30,(%edx)
f01062ab:	75 10                	jne    f01062bd <strtol+0x5a>
f01062ad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01062b1:	75 0a                	jne    f01062bd <strtol+0x5a>
		s += 2, base = 16;
f01062b3:	83 c2 02             	add    $0x2,%edx
f01062b6:	b8 10 00 00 00       	mov    $0x10,%eax
f01062bb:	eb 10                	jmp    f01062cd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
f01062bd:	85 c0                	test   %eax,%eax
f01062bf:	75 0c                	jne    f01062cd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01062c1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f01062c3:	80 3a 30             	cmpb   $0x30,(%edx)
f01062c6:	75 05                	jne    f01062cd <strtol+0x6a>
		s++, base = 8;
f01062c8:	83 c2 01             	add    $0x1,%edx
f01062cb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
f01062cd:	bb 00 00 00 00       	mov    $0x0,%ebx
f01062d2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f01062d5:	0f b6 0a             	movzbl (%edx),%ecx
f01062d8:	8d 71 d0             	lea    -0x30(%ecx),%esi
f01062db:	89 f0                	mov    %esi,%eax
f01062dd:	3c 09                	cmp    $0x9,%al
f01062df:	77 08                	ja     f01062e9 <strtol+0x86>
			dig = *s - '0';
f01062e1:	0f be c9             	movsbl %cl,%ecx
f01062e4:	83 e9 30             	sub    $0x30,%ecx
f01062e7:	eb 20                	jmp    f0106309 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
f01062e9:	8d 71 9f             	lea    -0x61(%ecx),%esi
f01062ec:	89 f0                	mov    %esi,%eax
f01062ee:	3c 19                	cmp    $0x19,%al
f01062f0:	77 08                	ja     f01062fa <strtol+0x97>
			dig = *s - 'a' + 10;
f01062f2:	0f be c9             	movsbl %cl,%ecx
f01062f5:	83 e9 57             	sub    $0x57,%ecx
f01062f8:	eb 0f                	jmp    f0106309 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
f01062fa:	8d 71 bf             	lea    -0x41(%ecx),%esi
f01062fd:	89 f0                	mov    %esi,%eax
f01062ff:	3c 19                	cmp    $0x19,%al
f0106301:	77 16                	ja     f0106319 <strtol+0xb6>
			dig = *s - 'A' + 10;
f0106303:	0f be c9             	movsbl %cl,%ecx
f0106306:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0106309:	3b 4d 10             	cmp    0x10(%ebp),%ecx
f010630c:	7d 0f                	jge    f010631d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
f010630e:	83 c2 01             	add    $0x1,%edx
f0106311:	0f af 5d 10          	imul   0x10(%ebp),%ebx
f0106315:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
f0106317:	eb bc                	jmp    f01062d5 <strtol+0x72>
f0106319:	89 d8                	mov    %ebx,%eax
f010631b:	eb 02                	jmp    f010631f <strtol+0xbc>
f010631d:	89 d8                	mov    %ebx,%eax

	if (endptr)
f010631f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0106323:	74 05                	je     f010632a <strtol+0xc7>
		*endptr = (char *) s;
f0106325:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106328:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f010632a:	f7 d8                	neg    %eax
f010632c:	85 ff                	test   %edi,%edi
f010632e:	0f 44 c3             	cmove  %ebx,%eax
}
f0106331:	5b                   	pop    %ebx
f0106332:	5e                   	pop    %esi
f0106333:	5f                   	pop    %edi
f0106334:	5d                   	pop    %ebp
f0106335:	c3                   	ret    
f0106336:	66 90                	xchg   %ax,%ax

f0106338 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0106338:	fa                   	cli    

	xorw    %ax, %ax
f0106339:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f010633b:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f010633d:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f010633f:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0106341:	0f 01 16             	lgdtl  (%esi)
f0106344:	74 70                	je     f01063b6 <mpentry_end+0x4>
	movl    %cr0, %eax
f0106346:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0106349:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f010634d:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0106350:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0106356:	08 00                	or     %al,(%eax)

f0106358 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0106358:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f010635c:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f010635e:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0106360:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0106362:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0106366:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0106368:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f010636a:	b8 00 20 12 00       	mov    $0x122000,%eax
	movl    %eax, %cr3
f010636f:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0106372:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0106375:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f010637a:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f010637d:	8b 25 c4 8e 2b f0    	mov    0xf02b8ec4,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106383:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0106388:	b8 66 02 10 f0       	mov    $0xf0100266,%eax
	call    *%eax
f010638d:	ff d0                	call   *%eax

f010638f <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f010638f:	eb fe                	jmp    f010638f <spin>
f0106391:	8d 76 00             	lea    0x0(%esi),%esi

f0106394 <gdt>:
	...
f010639c:	ff                   	(bad)  
f010639d:	ff 00                	incl   (%eax)
f010639f:	00 00                	add    %al,(%eax)
f01063a1:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f01063a8:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f01063ac <gdtdesc>:
f01063ac:	17                   	pop    %ss
f01063ad:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f01063b2 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f01063b2:	90                   	nop
f01063b3:	66 90                	xchg   %ax,%ax
f01063b5:	66 90                	xchg   %ax,%ax
f01063b7:	66 90                	xchg   %ax,%ax
f01063b9:	66 90                	xchg   %ax,%ax
f01063bb:	66 90                	xchg   %ax,%ax
f01063bd:	66 90                	xchg   %ax,%ax
f01063bf:	90                   	nop

f01063c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f01063c0:	55                   	push   %ebp
f01063c1:	89 e5                	mov    %esp,%ebp
f01063c3:	56                   	push   %esi
f01063c4:	53                   	push   %ebx
f01063c5:	83 ec 10             	sub    $0x10,%esp
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01063c8:	8b 0d c8 8e 2b f0    	mov    0xf02b8ec8,%ecx
f01063ce:	89 c3                	mov    %eax,%ebx
f01063d0:	c1 eb 0c             	shr    $0xc,%ebx
f01063d3:	39 cb                	cmp    %ecx,%ebx
f01063d5:	72 20                	jb     f01063f7 <mpsearch1+0x37>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01063d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01063db:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f01063e2:	f0 
f01063e3:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f01063ea:	00 
f01063eb:	c7 04 24 fd 95 10 f0 	movl   $0xf01095fd,(%esp)
f01063f2:	e8 a6 9c ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f01063f7:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f01063fd:	01 d0                	add    %edx,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01063ff:	89 c2                	mov    %eax,%edx
f0106401:	c1 ea 0c             	shr    $0xc,%edx
f0106404:	39 d1                	cmp    %edx,%ecx
f0106406:	77 20                	ja     f0106428 <mpsearch1+0x68>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106408:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010640c:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f0106413:	f0 
f0106414:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f010641b:	00 
f010641c:	c7 04 24 fd 95 10 f0 	movl   $0xf01095fd,(%esp)
f0106423:	e8 75 9c ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0106428:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi

	for (; mp < end; mp++)
f010642e:	eb 36                	jmp    f0106466 <mpsearch1+0xa6>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106430:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0106437:	00 
f0106438:	c7 44 24 04 0d 96 10 	movl   $0xf010960d,0x4(%esp)
f010643f:	f0 
f0106440:	89 1c 24             	mov    %ebx,(%esp)
f0106443:	e8 c5 fd ff ff       	call   f010620d <memcmp>
f0106448:	85 c0                	test   %eax,%eax
f010644a:	75 17                	jne    f0106463 <mpsearch1+0xa3>
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f010644c:	ba 00 00 00 00       	mov    $0x0,%edx
		sum += ((uint8_t *)addr)[i];
f0106451:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106455:	01 c8                	add    %ecx,%eax
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106457:	83 c2 01             	add    $0x1,%edx
f010645a:	83 fa 10             	cmp    $0x10,%edx
f010645d:	75 f2                	jne    f0106451 <mpsearch1+0x91>
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f010645f:	84 c0                	test   %al,%al
f0106461:	74 0e                	je     f0106471 <mpsearch1+0xb1>
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
f0106463:	83 c3 10             	add    $0x10,%ebx
f0106466:	39 f3                	cmp    %esi,%ebx
f0106468:	72 c6                	jb     f0106430 <mpsearch1+0x70>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f010646a:	b8 00 00 00 00       	mov    $0x0,%eax
f010646f:	eb 02                	jmp    f0106473 <mpsearch1+0xb3>
f0106471:	89 d8                	mov    %ebx,%eax
}
f0106473:	83 c4 10             	add    $0x10,%esp
f0106476:	5b                   	pop    %ebx
f0106477:	5e                   	pop    %esi
f0106478:	5d                   	pop    %ebp
f0106479:	c3                   	ret    

f010647a <mp_init>:
	return conf;
}

void
mp_init(void)
{
f010647a:	55                   	push   %ebp
f010647b:	89 e5                	mov    %esp,%ebp
f010647d:	57                   	push   %edi
f010647e:	56                   	push   %esi
f010647f:	53                   	push   %ebx
f0106480:	83 ec 2c             	sub    $0x2c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0106483:	c7 05 c0 93 31 f0 20 	movl   $0xf0319020,0xf03193c0
f010648a:	90 31 f0 
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010648d:	83 3d c8 8e 2b f0 00 	cmpl   $0x0,0xf02b8ec8
f0106494:	75 24                	jne    f01064ba <mp_init+0x40>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106496:	c7 44 24 0c 00 04 00 	movl   $0x400,0xc(%esp)
f010649d:	00 
f010649e:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f01064a5:	f0 
f01064a6:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
f01064ad:	00 
f01064ae:	c7 04 24 fd 95 10 f0 	movl   $0xf01095fd,(%esp)
f01064b5:	e8 e3 9b ff ff       	call   f010009d <_panic>
	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f01064ba:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f01064c1:	85 c0                	test   %eax,%eax
f01064c3:	74 16                	je     f01064db <mp_init+0x61>
		p <<= 4;	// Translate from segment to PA
f01064c5:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f01064c8:	ba 00 04 00 00       	mov    $0x400,%edx
f01064cd:	e8 ee fe ff ff       	call   f01063c0 <mpsearch1>
f01064d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01064d5:	85 c0                	test   %eax,%eax
f01064d7:	75 3c                	jne    f0106515 <mp_init+0x9b>
f01064d9:	eb 20                	jmp    f01064fb <mp_init+0x81>
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
f01064db:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f01064e2:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f01064e5:	2d 00 04 00 00       	sub    $0x400,%eax
f01064ea:	ba 00 04 00 00       	mov    $0x400,%edx
f01064ef:	e8 cc fe ff ff       	call   f01063c0 <mpsearch1>
f01064f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01064f7:	85 c0                	test   %eax,%eax
f01064f9:	75 1a                	jne    f0106515 <mp_init+0x9b>
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f01064fb:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106500:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106505:	e8 b6 fe ff ff       	call   f01063c0 <mpsearch1>
f010650a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f010650d:	85 c0                	test   %eax,%eax
f010650f:	0f 84 54 02 00 00    	je     f0106769 <mp_init+0x2ef>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f0106515:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106518:	8b 70 04             	mov    0x4(%eax),%esi
f010651b:	85 f6                	test   %esi,%esi
f010651d:	74 06                	je     f0106525 <mp_init+0xab>
f010651f:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106523:	74 11                	je     f0106536 <mp_init+0xbc>
		cprintf("SMP: Default configurations not implemented\n");
f0106525:	c7 04 24 70 94 10 f0 	movl   $0xf0109470,(%esp)
f010652c:	e8 94 da ff ff       	call   f0103fc5 <cprintf>
f0106531:	e9 33 02 00 00       	jmp    f0106769 <mp_init+0x2ef>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106536:	89 f0                	mov    %esi,%eax
f0106538:	c1 e8 0c             	shr    $0xc,%eax
f010653b:	3b 05 c8 8e 2b f0    	cmp    0xf02b8ec8,%eax
f0106541:	72 20                	jb     f0106563 <mp_init+0xe9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106543:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106547:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f010654e:	f0 
f010654f:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
f0106556:	00 
f0106557:	c7 04 24 fd 95 10 f0 	movl   $0xf01095fd,(%esp)
f010655e:	e8 3a 9b ff ff       	call   f010009d <_panic>
	return (void *)(pa + KERNBASE);
f0106563:	8d 9e 00 00 00 f0    	lea    -0x10000000(%esi),%ebx
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106569:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0106570:	00 
f0106571:	c7 44 24 04 12 96 10 	movl   $0xf0109612,0x4(%esp)
f0106578:	f0 
f0106579:	89 1c 24             	mov    %ebx,(%esp)
f010657c:	e8 8c fc ff ff       	call   f010620d <memcmp>
f0106581:	85 c0                	test   %eax,%eax
f0106583:	74 11                	je     f0106596 <mp_init+0x11c>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106585:	c7 04 24 a0 94 10 f0 	movl   $0xf01094a0,(%esp)
f010658c:	e8 34 da ff ff       	call   f0103fc5 <cprintf>
f0106591:	e9 d3 01 00 00       	jmp    f0106769 <mp_init+0x2ef>
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0106596:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
f010659a:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
f010659e:	0f b7 f8             	movzwl %ax,%edi
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f01065a1:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f01065a6:	b8 00 00 00 00       	mov    $0x0,%eax
f01065ab:	eb 0d                	jmp    f01065ba <mp_init+0x140>
		sum += ((uint8_t *)addr)[i];
f01065ad:	0f b6 8c 30 00 00 00 	movzbl -0x10000000(%eax,%esi,1),%ecx
f01065b4:	f0 
f01065b5:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f01065b7:	83 c0 01             	add    $0x1,%eax
f01065ba:	39 c7                	cmp    %eax,%edi
f01065bc:	7f ef                	jg     f01065ad <mp_init+0x133>
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
		cprintf("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f01065be:	84 d2                	test   %dl,%dl
f01065c0:	74 11                	je     f01065d3 <mp_init+0x159>
		cprintf("SMP: Bad MP configuration checksum\n");
f01065c2:	c7 04 24 d4 94 10 f0 	movl   $0xf01094d4,(%esp)
f01065c9:	e8 f7 d9 ff ff       	call   f0103fc5 <cprintf>
f01065ce:	e9 96 01 00 00       	jmp    f0106769 <mp_init+0x2ef>
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f01065d3:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
f01065d7:	3c 04                	cmp    $0x4,%al
f01065d9:	74 1f                	je     f01065fa <mp_init+0x180>
f01065db:	3c 01                	cmp    $0x1,%al
f01065dd:	8d 76 00             	lea    0x0(%esi),%esi
f01065e0:	74 18                	je     f01065fa <mp_init+0x180>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f01065e2:	0f b6 c0             	movzbl %al,%eax
f01065e5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01065e9:	c7 04 24 f8 94 10 f0 	movl   $0xf01094f8,(%esp)
f01065f0:	e8 d0 d9 ff ff       	call   f0103fc5 <cprintf>
f01065f5:	e9 6f 01 00 00       	jmp    f0106769 <mp_init+0x2ef>
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f01065fa:	0f b7 73 28          	movzwl 0x28(%ebx),%esi
f01065fe:	0f b7 7d e2          	movzwl -0x1e(%ebp),%edi
f0106602:	01 df                	add    %ebx,%edi
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0106604:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f0106609:	b8 00 00 00 00       	mov    $0x0,%eax
f010660e:	eb 09                	jmp    f0106619 <mp_init+0x19f>
		sum += ((uint8_t *)addr)[i];
f0106610:	0f b6 0c 07          	movzbl (%edi,%eax,1),%ecx
f0106614:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106616:	83 c0 01             	add    $0x1,%eax
f0106619:	39 c6                	cmp    %eax,%esi
f010661b:	7f f3                	jg     f0106610 <mp_init+0x196>
	}
	if (conf->version != 1 && conf->version != 4) {
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f010661d:	02 53 2a             	add    0x2a(%ebx),%dl
f0106620:	84 d2                	test   %dl,%dl
f0106622:	74 11                	je     f0106635 <mp_init+0x1bb>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106624:	c7 04 24 18 95 10 f0 	movl   $0xf0109518,(%esp)
f010662b:	e8 95 d9 ff ff       	call   f0103fc5 <cprintf>
f0106630:	e9 34 01 00 00       	jmp    f0106769 <mp_init+0x2ef>
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
f0106635:	85 db                	test   %ebx,%ebx
f0106637:	0f 84 2c 01 00 00    	je     f0106769 <mp_init+0x2ef>
		return;
	ismp = 1;
f010663d:	c7 05 00 90 31 f0 01 	movl   $0x1,0xf0319000
f0106644:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106647:	8b 43 24             	mov    0x24(%ebx),%eax
f010664a:	a3 00 a0 35 f0       	mov    %eax,0xf035a000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f010664f:	8d 7b 2c             	lea    0x2c(%ebx),%edi
f0106652:	be 00 00 00 00       	mov    $0x0,%esi
f0106657:	e9 86 00 00 00       	jmp    f01066e2 <mp_init+0x268>
		switch (*p) {
f010665c:	0f b6 07             	movzbl (%edi),%eax
f010665f:	84 c0                	test   %al,%al
f0106661:	74 06                	je     f0106669 <mp_init+0x1ef>
f0106663:	3c 04                	cmp    $0x4,%al
f0106665:	77 57                	ja     f01066be <mp_init+0x244>
f0106667:	eb 50                	jmp    f01066b9 <mp_init+0x23f>
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106669:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f010666d:	8d 76 00             	lea    0x0(%esi),%esi
f0106670:	74 11                	je     f0106683 <mp_init+0x209>
				bootcpu = &cpus[ncpu];
f0106672:	6b 05 c4 93 31 f0 74 	imul   $0x74,0xf03193c4,%eax
f0106679:	05 20 90 31 f0       	add    $0xf0319020,%eax
f010667e:	a3 c0 93 31 f0       	mov    %eax,0xf03193c0
			if (ncpu < NCPU) {
f0106683:	a1 c4 93 31 f0       	mov    0xf03193c4,%eax
f0106688:	83 f8 07             	cmp    $0x7,%eax
f010668b:	7f 13                	jg     f01066a0 <mp_init+0x226>
				cpus[ncpu].cpu_id = ncpu;
f010668d:	6b d0 74             	imul   $0x74,%eax,%edx
f0106690:	88 82 20 90 31 f0    	mov    %al,-0xfce6fe0(%edx)
				ncpu++;
f0106696:	83 c0 01             	add    $0x1,%eax
f0106699:	a3 c4 93 31 f0       	mov    %eax,0xf03193c4
f010669e:	eb 14                	jmp    f01066b4 <mp_init+0x23a>
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f01066a0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f01066a4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01066a8:	c7 04 24 48 95 10 f0 	movl   $0xf0109548,(%esp)
f01066af:	e8 11 d9 ff ff       	call   f0103fc5 <cprintf>
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f01066b4:	83 c7 14             	add    $0x14,%edi
			continue;
f01066b7:	eb 26                	jmp    f01066df <mp_init+0x265>
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f01066b9:	83 c7 08             	add    $0x8,%edi
			continue;
f01066bc:	eb 21                	jmp    f01066df <mp_init+0x265>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f01066be:	0f b6 c0             	movzbl %al,%eax
f01066c1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01066c5:	c7 04 24 70 95 10 f0 	movl   $0xf0109570,(%esp)
f01066cc:	e8 f4 d8 ff ff       	call   f0103fc5 <cprintf>
			ismp = 0;
f01066d1:	c7 05 00 90 31 f0 00 	movl   $0x0,0xf0319000
f01066d8:	00 00 00 
			i = conf->entry;
f01066db:	0f b7 73 22          	movzwl 0x22(%ebx),%esi
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f01066df:	83 c6 01             	add    $0x1,%esi
f01066e2:	0f b7 43 22          	movzwl 0x22(%ebx),%eax
f01066e6:	39 c6                	cmp    %eax,%esi
f01066e8:	0f 82 6e ff ff ff    	jb     f010665c <mp_init+0x1e2>
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f01066ee:	a1 c0 93 31 f0       	mov    0xf03193c0,%eax
f01066f3:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f01066fa:	83 3d 00 90 31 f0 00 	cmpl   $0x0,0xf0319000
f0106701:	75 22                	jne    f0106725 <mp_init+0x2ab>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0106703:	c7 05 c4 93 31 f0 01 	movl   $0x1,0xf03193c4
f010670a:	00 00 00 
		lapicaddr = 0;
f010670d:	c7 05 00 a0 35 f0 00 	movl   $0x0,0xf035a000
f0106714:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106717:	c7 04 24 90 95 10 f0 	movl   $0xf0109590,(%esp)
f010671e:	e8 a2 d8 ff ff       	call   f0103fc5 <cprintf>
		return;
f0106723:	eb 44                	jmp    f0106769 <mp_init+0x2ef>
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106725:	8b 15 c4 93 31 f0    	mov    0xf03193c4,%edx
f010672b:	89 54 24 08          	mov    %edx,0x8(%esp)
f010672f:	0f b6 00             	movzbl (%eax),%eax
f0106732:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106736:	c7 04 24 17 96 10 f0 	movl   $0xf0109617,(%esp)
f010673d:	e8 83 d8 ff ff       	call   f0103fc5 <cprintf>

	if (mp->imcrp) {
f0106742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106745:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106749:	74 1e                	je     f0106769 <mp_init+0x2ef>
		// [MP 3.2.6.1] If the hardware implements PIC mode,
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f010674b:	c7 04 24 bc 95 10 f0 	movl   $0xf01095bc,(%esp)
f0106752:	e8 6e d8 ff ff       	call   f0103fc5 <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106757:	ba 22 00 00 00       	mov    $0x22,%edx
f010675c:	b8 70 00 00 00       	mov    $0x70,%eax
f0106761:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106762:	b2 23                	mov    $0x23,%dl
f0106764:	ec                   	in     (%dx),%al
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106765:	83 c8 01             	or     $0x1,%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106768:	ee                   	out    %al,(%dx)
	}
}
f0106769:	83 c4 2c             	add    $0x2c,%esp
f010676c:	5b                   	pop    %ebx
f010676d:	5e                   	pop    %esi
f010676e:	5f                   	pop    %edi
f010676f:	5d                   	pop    %ebp
f0106770:	c3                   	ret    

f0106771 <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f0106771:	55                   	push   %ebp
f0106772:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f0106774:	8b 0d 04 a0 35 f0    	mov    0xf035a004,%ecx
f010677a:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f010677d:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f010677f:	a1 04 a0 35 f0       	mov    0xf035a004,%eax
f0106784:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106787:	5d                   	pop    %ebp
f0106788:	c3                   	ret    

f0106789 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0106789:	55                   	push   %ebp
f010678a:	89 e5                	mov    %esp,%ebp
	if (lapic)
f010678c:	a1 04 a0 35 f0       	mov    0xf035a004,%eax
f0106791:	85 c0                	test   %eax,%eax
f0106793:	74 08                	je     f010679d <cpunum+0x14>
		return lapic[ID] >> 24;
f0106795:	8b 40 20             	mov    0x20(%eax),%eax
f0106798:	c1 e8 18             	shr    $0x18,%eax
f010679b:	eb 05                	jmp    f01067a2 <cpunum+0x19>
	return 0;
f010679d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01067a2:	5d                   	pop    %ebp
f01067a3:	c3                   	ret    

f01067a4 <lapic_init>:
}

void
lapic_init(void)
{
	if (!lapicaddr)
f01067a4:	a1 00 a0 35 f0       	mov    0xf035a000,%eax
f01067a9:	85 c0                	test   %eax,%eax
f01067ab:	0f 84 23 01 00 00    	je     f01068d4 <lapic_init+0x130>
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
f01067b1:	55                   	push   %ebp
f01067b2:	89 e5                	mov    %esp,%ebp
f01067b4:	83 ec 18             	sub    $0x18,%esp
	if (!lapicaddr)
		return;

	// lapicaddr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	lapic = mmio_map_region(lapicaddr, 4096);
f01067b7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01067be:	00 
f01067bf:	89 04 24             	mov    %eax,(%esp)
f01067c2:	e8 4c ac ff ff       	call   f0101413 <mmio_map_region>
f01067c7:	a3 04 a0 35 f0       	mov    %eax,0xf035a004

	// Enable local APIC; set spurious interrupt vector.
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f01067cc:	ba 27 01 00 00       	mov    $0x127,%edx
f01067d1:	b8 3c 00 00 00       	mov    $0x3c,%eax
f01067d6:	e8 96 ff ff ff       	call   f0106771 <lapicw>

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.  
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapicw(TDCR, X1);
f01067db:	ba 0b 00 00 00       	mov    $0xb,%edx
f01067e0:	b8 f8 00 00 00       	mov    $0xf8,%eax
f01067e5:	e8 87 ff ff ff       	call   f0106771 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f01067ea:	ba 20 00 02 00       	mov    $0x20020,%edx
f01067ef:	b8 c8 00 00 00       	mov    $0xc8,%eax
f01067f4:	e8 78 ff ff ff       	call   f0106771 <lapicw>
	lapicw(TICR, 10000000); 
f01067f9:	ba 80 96 98 00       	mov    $0x989680,%edx
f01067fe:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106803:	e8 69 ff ff ff       	call   f0106771 <lapicw>
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)
f0106808:	e8 7c ff ff ff       	call   f0106789 <cpunum>
f010680d:	6b c0 74             	imul   $0x74,%eax,%eax
f0106810:	05 20 90 31 f0       	add    $0xf0319020,%eax
f0106815:	39 05 c0 93 31 f0    	cmp    %eax,0xf03193c0
f010681b:	74 0f                	je     f010682c <lapic_init+0x88>
		lapicw(LINT0, MASKED);
f010681d:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106822:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106827:	e8 45 ff ff ff       	call   f0106771 <lapicw>

	// Disable NMI (LINT1) on all CPUs
	lapicw(LINT1, MASKED);
f010682c:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106831:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106836:	e8 36 ff ff ff       	call   f0106771 <lapicw>

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f010683b:	a1 04 a0 35 f0       	mov    0xf035a004,%eax
f0106840:	8b 40 30             	mov    0x30(%eax),%eax
f0106843:	c1 e8 10             	shr    $0x10,%eax
f0106846:	3c 03                	cmp    $0x3,%al
f0106848:	76 0f                	jbe    f0106859 <lapic_init+0xb5>
		lapicw(PCINT, MASKED);
f010684a:	ba 00 00 01 00       	mov    $0x10000,%edx
f010684f:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106854:	e8 18 ff ff ff       	call   f0106771 <lapicw>

	// Map error interrupt to IRQ_ERROR.
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106859:	ba 33 00 00 00       	mov    $0x33,%edx
f010685e:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106863:	e8 09 ff ff ff       	call   f0106771 <lapicw>

	// Clear error status register (requires back-to-back writes).
	lapicw(ESR, 0);
f0106868:	ba 00 00 00 00       	mov    $0x0,%edx
f010686d:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106872:	e8 fa fe ff ff       	call   f0106771 <lapicw>
	lapicw(ESR, 0);
f0106877:	ba 00 00 00 00       	mov    $0x0,%edx
f010687c:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106881:	e8 eb fe ff ff       	call   f0106771 <lapicw>

	// Ack any outstanding interrupts.
	lapicw(EOI, 0);
f0106886:	ba 00 00 00 00       	mov    $0x0,%edx
f010688b:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106890:	e8 dc fe ff ff       	call   f0106771 <lapicw>

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapicw(ICRHI, 0);
f0106895:	ba 00 00 00 00       	mov    $0x0,%edx
f010689a:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010689f:	e8 cd fe ff ff       	call   f0106771 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f01068a4:	ba 00 85 08 00       	mov    $0x88500,%edx
f01068a9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01068ae:	e8 be fe ff ff       	call   f0106771 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f01068b3:	8b 15 04 a0 35 f0    	mov    0xf035a004,%edx
f01068b9:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01068bf:	f6 c4 10             	test   $0x10,%ah
f01068c2:	75 f5                	jne    f01068b9 <lapic_init+0x115>
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f01068c4:	ba 00 00 00 00       	mov    $0x0,%edx
f01068c9:	b8 20 00 00 00       	mov    $0x20,%eax
f01068ce:	e8 9e fe ff ff       	call   f0106771 <lapicw>
}
f01068d3:	c9                   	leave  
f01068d4:	f3 c3                	repz ret 

f01068d6 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f01068d6:	83 3d 04 a0 35 f0 00 	cmpl   $0x0,0xf035a004
f01068dd:	74 13                	je     f01068f2 <lapic_eoi+0x1c>
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f01068df:	55                   	push   %ebp
f01068e0:	89 e5                	mov    %esp,%ebp
	if (lapic)
		lapicw(EOI, 0);
f01068e2:	ba 00 00 00 00       	mov    $0x0,%edx
f01068e7:	b8 2c 00 00 00       	mov    $0x2c,%eax
f01068ec:	e8 80 fe ff ff       	call   f0106771 <lapicw>
}
f01068f1:	5d                   	pop    %ebp
f01068f2:	f3 c3                	repz ret 

f01068f4 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f01068f4:	55                   	push   %ebp
f01068f5:	89 e5                	mov    %esp,%ebp
f01068f7:	56                   	push   %esi
f01068f8:	53                   	push   %ebx
f01068f9:	83 ec 10             	sub    $0x10,%esp
f01068fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01068ff:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106902:	ba 70 00 00 00       	mov    $0x70,%edx
f0106907:	b8 0f 00 00 00       	mov    $0xf,%eax
f010690c:	ee                   	out    %al,(%dx)
f010690d:	b2 71                	mov    $0x71,%dl
f010690f:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106914:	ee                   	out    %al,(%dx)
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106915:	83 3d c8 8e 2b f0 00 	cmpl   $0x0,0xf02b8ec8
f010691c:	75 24                	jne    f0106942 <lapic_startap+0x4e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010691e:	c7 44 24 0c 67 04 00 	movl   $0x467,0xc(%esp)
f0106925:	00 
f0106926:	c7 44 24 08 14 7a 10 	movl   $0xf0107a14,0x8(%esp)
f010692d:	f0 
f010692e:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
f0106935:	00 
f0106936:	c7 04 24 34 96 10 f0 	movl   $0xf0109634,(%esp)
f010693d:	e8 5b 97 ff ff       	call   f010009d <_panic>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106942:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106949:	00 00 
	wrv[1] = addr >> 4;
f010694b:	89 f0                	mov    %esi,%eax
f010694d:	c1 e8 04             	shr    $0x4,%eax
f0106950:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106956:	c1 e3 18             	shl    $0x18,%ebx
f0106959:	89 da                	mov    %ebx,%edx
f010695b:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106960:	e8 0c fe ff ff       	call   f0106771 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106965:	ba 00 c5 00 00       	mov    $0xc500,%edx
f010696a:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010696f:	e8 fd fd ff ff       	call   f0106771 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106974:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106979:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010697e:	e8 ee fd ff ff       	call   f0106771 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106983:	c1 ee 0c             	shr    $0xc,%esi
f0106986:	81 ce 00 06 00 00    	or     $0x600,%esi
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f010698c:	89 da                	mov    %ebx,%edx
f010698e:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106993:	e8 d9 fd ff ff       	call   f0106771 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0106998:	89 f2                	mov    %esi,%edx
f010699a:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010699f:	e8 cd fd ff ff       	call   f0106771 <lapicw>
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f01069a4:	89 da                	mov    %ebx,%edx
f01069a6:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01069ab:	e8 c1 fd ff ff       	call   f0106771 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f01069b0:	89 f2                	mov    %esi,%edx
f01069b2:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01069b7:	e8 b5 fd ff ff       	call   f0106771 <lapicw>
		microdelay(200);
	}
}
f01069bc:	83 c4 10             	add    $0x10,%esp
f01069bf:	5b                   	pop    %ebx
f01069c0:	5e                   	pop    %esi
f01069c1:	5d                   	pop    %ebp
f01069c2:	c3                   	ret    

f01069c3 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f01069c3:	55                   	push   %ebp
f01069c4:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f01069c6:	8b 55 08             	mov    0x8(%ebp),%edx
f01069c9:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f01069cf:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01069d4:	e8 98 fd ff ff       	call   f0106771 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f01069d9:	8b 15 04 a0 35 f0    	mov    0xf035a004,%edx
f01069df:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f01069e5:	f6 c4 10             	test   $0x10,%ah
f01069e8:	75 f5                	jne    f01069df <lapic_ipi+0x1c>
		;
}
f01069ea:	5d                   	pop    %ebp
f01069eb:	c3                   	ret    

f01069ec <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f01069ec:	55                   	push   %ebp
f01069ed:	89 e5                	mov    %esp,%ebp
f01069ef:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f01069f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f01069f8:	8b 55 0c             	mov    0xc(%ebp),%edx
f01069fb:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f01069fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106a05:	5d                   	pop    %ebp
f0106a06:	c3                   	ret    

f0106a07 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106a07:	55                   	push   %ebp
f0106a08:	89 e5                	mov    %esp,%ebp
f0106a0a:	56                   	push   %esi
f0106a0b:	53                   	push   %ebx
f0106a0c:	83 ec 20             	sub    $0x20,%esp
f0106a0f:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f0106a12:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106a15:	75 07                	jne    f0106a1e <spin_lock+0x17>
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0106a17:	ba 01 00 00 00       	mov    $0x1,%edx
f0106a1c:	eb 42                	jmp    f0106a60 <spin_lock+0x59>
f0106a1e:	8b 73 08             	mov    0x8(%ebx),%esi
f0106a21:	e8 63 fd ff ff       	call   f0106789 <cpunum>
f0106a26:	6b c0 74             	imul   $0x74,%eax,%eax
f0106a29:	05 20 90 31 f0       	add    $0xf0319020,%eax
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0106a2e:	39 c6                	cmp    %eax,%esi
f0106a30:	75 e5                	jne    f0106a17 <spin_lock+0x10>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106a32:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0106a35:	e8 4f fd ff ff       	call   f0106789 <cpunum>
f0106a3a:	89 5c 24 10          	mov    %ebx,0x10(%esp)
f0106a3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106a42:	c7 44 24 08 44 96 10 	movl   $0xf0109644,0x8(%esp)
f0106a49:	f0 
f0106a4a:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
f0106a51:	00 
f0106a52:	c7 04 24 a6 96 10 f0 	movl   $0xf01096a6,(%esp)
f0106a59:	e8 3f 96 ff ff       	call   f010009d <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0106a5e:	f3 90                	pause  
f0106a60:	89 d0                	mov    %edx,%eax
f0106a62:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0106a65:	85 c0                	test   %eax,%eax
f0106a67:	75 f5                	jne    f0106a5e <spin_lock+0x57>
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106a69:	e8 1b fd ff ff       	call   f0106789 <cpunum>
f0106a6e:	6b c0 74             	imul   $0x74,%eax,%eax
f0106a71:	05 20 90 31 f0       	add    $0xf0319020,%eax
f0106a76:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f0106a79:	83 c3 0c             	add    $0xc,%ebx
get_caller_pcs(uint32_t pcs[])
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
f0106a7c:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106a7e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106a83:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0106a89:	76 12                	jbe    f0106a9d <spin_lock+0x96>
			break;
		pcs[i] = ebp[1];          // saved %eip
f0106a8b:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106a8e:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106a91:	8b 12                	mov    (%edx),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0106a93:	83 c0 01             	add    $0x1,%eax
f0106a96:	83 f8 0a             	cmp    $0xa,%eax
f0106a99:	75 e8                	jne    f0106a83 <spin_lock+0x7c>
f0106a9b:	eb 0f                	jmp    f0106aac <spin_lock+0xa5>
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f0106a9d:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
f0106aa4:	83 c0 01             	add    $0x1,%eax
f0106aa7:	83 f8 09             	cmp    $0x9,%eax
f0106aaa:	7e f1                	jle    f0106a9d <spin_lock+0x96>
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
	get_caller_pcs(lk->pcs);
#endif
}
f0106aac:	83 c4 20             	add    $0x20,%esp
f0106aaf:	5b                   	pop    %ebx
f0106ab0:	5e                   	pop    %esi
f0106ab1:	5d                   	pop    %ebp
f0106ab2:	c3                   	ret    

f0106ab3 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0106ab3:	55                   	push   %ebp
f0106ab4:	89 e5                	mov    %esp,%ebp
f0106ab6:	57                   	push   %edi
f0106ab7:	56                   	push   %esi
f0106ab8:	53                   	push   %ebx
f0106ab9:	83 ec 6c             	sub    $0x6c,%esp
f0106abc:	8b 75 08             	mov    0x8(%ebp),%esi

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f0106abf:	83 3e 00             	cmpl   $0x0,(%esi)
f0106ac2:	74 18                	je     f0106adc <spin_unlock+0x29>
f0106ac4:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106ac7:	e8 bd fc ff ff       	call   f0106789 <cpunum>
f0106acc:	6b c0 74             	imul   $0x74,%eax,%eax
f0106acf:	05 20 90 31 f0       	add    $0xf0319020,%eax
// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f0106ad4:	39 c3                	cmp    %eax,%ebx
f0106ad6:	0f 84 ce 00 00 00    	je     f0106baa <spin_unlock+0xf7>
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0106adc:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
f0106ae3:	00 
f0106ae4:	8d 46 0c             	lea    0xc(%esi),%eax
f0106ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106aeb:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f0106aee:	89 1c 24             	mov    %ebx,(%esp)
f0106af1:	e8 8e f6 ff ff       	call   f0106184 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0106af6:	8b 46 08             	mov    0x8(%esi),%eax
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0106af9:	0f b6 38             	movzbl (%eax),%edi
f0106afc:	8b 76 04             	mov    0x4(%esi),%esi
f0106aff:	e8 85 fc ff ff       	call   f0106789 <cpunum>
f0106b04:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0106b08:	89 74 24 08          	mov    %esi,0x8(%esp)
f0106b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b10:	c7 04 24 70 96 10 f0 	movl   $0xf0109670,(%esp)
f0106b17:	e8 a9 d4 ff ff       	call   f0103fc5 <cprintf>
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106b1c:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106b1f:	eb 65                	jmp    f0106b86 <spin_unlock+0xd3>
f0106b21:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106b25:	89 04 24             	mov    %eax,(%esp)
f0106b28:	e8 bc ea ff ff       	call   f01055e9 <debuginfo_eip>
f0106b2d:	85 c0                	test   %eax,%eax
f0106b2f:	78 39                	js     f0106b6a <spin_unlock+0xb7>
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
f0106b31:	8b 06                	mov    (%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106b33:	89 c2                	mov    %eax,%edx
f0106b35:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106b38:	89 54 24 18          	mov    %edx,0x18(%esp)
f0106b3c:	8b 55 b0             	mov    -0x50(%ebp),%edx
f0106b3f:	89 54 24 14          	mov    %edx,0x14(%esp)
f0106b43:	8b 55 b4             	mov    -0x4c(%ebp),%edx
f0106b46:	89 54 24 10          	mov    %edx,0x10(%esp)
f0106b4a:	8b 55 ac             	mov    -0x54(%ebp),%edx
f0106b4d:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106b51:	8b 55 a8             	mov    -0x58(%ebp),%edx
f0106b54:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106b58:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b5c:	c7 04 24 b6 96 10 f0 	movl   $0xf01096b6,(%esp)
f0106b63:	e8 5d d4 ff ff       	call   f0103fc5 <cprintf>
f0106b68:	eb 12                	jmp    f0106b7c <spin_unlock+0xc9>
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
f0106b6a:	8b 06                	mov    (%esi),%eax
f0106b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106b70:	c7 04 24 cd 96 10 f0 	movl   $0xf01096cd,(%esp)
f0106b77:	e8 49 d4 ff ff       	call   f0103fc5 <cprintf>
f0106b7c:	83 c3 04             	add    $0x4,%ebx
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106b7f:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106b82:	39 c3                	cmp    %eax,%ebx
f0106b84:	74 08                	je     f0106b8e <spin_unlock+0xdb>
f0106b86:	89 de                	mov    %ebx,%esi
f0106b88:	8b 03                	mov    (%ebx),%eax
f0106b8a:	85 c0                	test   %eax,%eax
f0106b8c:	75 93                	jne    f0106b21 <spin_unlock+0x6e>
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
f0106b8e:	c7 44 24 08 d5 96 10 	movl   $0xf01096d5,0x8(%esp)
f0106b95:	f0 
f0106b96:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
f0106b9d:	00 
f0106b9e:	c7 04 24 a6 96 10 f0 	movl   $0xf01096a6,(%esp)
f0106ba5:	e8 f3 94 ff ff       	call   f010009d <_panic>
	}

	lk->pcs[0] = 0;
f0106baa:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0106bb1:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
f0106bb8:	b8 00 00 00 00       	mov    $0x0,%eax
f0106bbd:	f0 87 06             	lock xchg %eax,(%esi)
	// Paper says that Intel 64 and IA-32 will not move a load
	// after a store. So lock->locked = 0 would work here.
	// The xchg being asm volatile ensures gcc emits it after
	// the above assignments (and after the critical section).
	xchg(&lk->locked, 0);
}
f0106bc0:	83 c4 6c             	add    $0x6c,%esp
f0106bc3:	5b                   	pop    %ebx
f0106bc4:	5e                   	pop    %esi
f0106bc5:	5f                   	pop    %edi
f0106bc6:	5d                   	pop    %ebp
f0106bc7:	c3                   	ret    

f0106bc8 <transmit_initalize>:
#include <kern/sched.h>
struct transmit_descriptor e1000_transmit_descriptors[E1000_TX_DESCS] __attribute__ ((aligned(16)));
struct recieve_descriptor  e1000_recieve_descriptors[E1000_RX_DESCS];

void transmit_initalize()
{
f0106bc8:	55                   	push   %ebp
f0106bc9:	89 e5                	mov    %esp,%ebp
f0106bcb:	53                   	push   %ebx
f0106bcc:	83 ec 14             	sub    $0x14,%esp
	cprintf("Initializing e1000 tansmit queue\n");
f0106bcf:	c7 04 24 f0 96 10 f0 	movl   $0xf01096f0,(%esp)
f0106bd6:	e8 ea d3 ff ff       	call   f0103fc5 <cprintf>
	cprintf("Address of transmit_descriptor %08x\n",e1000_transmit_descriptors);
f0106bdb:	c7 44 24 04 20 a0 35 	movl   $0xf035a020,0x4(%esp)
f0106be2:	f0 
f0106be3:	c7 04 24 14 97 10 f0 	movl   $0xf0109714,(%esp)
f0106bea:	e8 d6 d3 ff ff       	call   f0103fc5 <cprintf>
	e1000_bar0_addr[E1000_TDLEN] = E1000_TX_DESCS * sizeof(struct transmit_descriptor); //Number of descriptors x Size of each descriptor
f0106bef:	a1 e0 8e 2b f0       	mov    0xf02b8ee0,%eax
f0106bf4:	c7 80 08 38 00 00 00 	movl   $0x400,0x3808(%eax)
f0106bfb:	04 00 00 
	e1000_bar0_addr[E1000_TDH] = 0;
f0106bfe:	c7 80 10 38 00 00 00 	movl   $0x0,0x3810(%eax)
f0106c05:	00 00 00 
	e1000_bar0_addr[E1000_TDT] = 0;
f0106c08:	c7 80 18 38 00 00 00 	movl   $0x0,0x3818(%eax)
f0106c0f:	00 00 00 
	e1000_bar0_addr[E1000_TCTL] = e1000_bar0_addr[E1000_TCTL] | E1000_TCTL_EN;
f0106c12:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0106c18:	83 ca 02             	or     $0x2,%edx
f0106c1b:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	e1000_bar0_addr[E1000_TCTL] = e1000_bar0_addr[E1000_TCTL] | E1000_TCTL_PSP;
f0106c21:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0106c27:	83 ca 08             	or     $0x8,%edx
f0106c2a:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	e1000_bar0_addr[E1000_TCTL] = e1000_bar0_addr[E1000_TCTL] | E1000_TCTL_CT;
f0106c30:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0106c36:	81 ca f0 0f 00 00    	or     $0xff0,%edx
f0106c3c:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	e1000_bar0_addr[E1000_TCTL] = e1000_bar0_addr[E1000_TCTL] | E1000_TCTL_COLD;
f0106c42:	8b 90 00 04 00 00    	mov    0x400(%eax),%edx
f0106c48:	81 ca 00 f0 3f 00    	or     $0x3ff000,%edx
f0106c4e:	89 90 00 04 00 00    	mov    %edx,0x400(%eax)
	e1000_bar0_addr[E1000_TIPG] = 0x0;
f0106c54:	c7 80 10 04 00 00 00 	movl   $0x0,0x410(%eax)
f0106c5b:	00 00 00 
	e1000_bar0_addr[E1000_TIPG] = 0xA;
f0106c5e:	c7 80 10 04 00 00 0a 	movl   $0xa,0x410(%eax)
f0106c65:	00 00 00 
	e1000_bar0_addr[E1000_TIPG] = e1000_bar0_addr[E1000_TIPG] | 0x4 << 10;
f0106c68:	8b 90 10 04 00 00    	mov    0x410(%eax),%edx
f0106c6e:	80 ce 10             	or     $0x10,%dh
f0106c71:	89 90 10 04 00 00    	mov    %edx,0x410(%eax)
	e1000_bar0_addr[E1000_TIPG] = e1000_bar0_addr[E1000_TIPG] | 0x6 << 20;
f0106c77:	8b 90 10 04 00 00    	mov    0x410(%eax),%edx
f0106c7d:	81 ca 00 00 60 00    	or     $0x600000,%edx
f0106c83:	89 90 10 04 00 00    	mov    %edx,0x410(%eax)
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0106c89:	ba 20 a0 35 f0       	mov    $0xf035a020,%edx
f0106c8e:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0106c94:	77 20                	ja     f0106cb6 <transmit_initalize+0xee>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0106c96:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106c9a:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0106ca1:	f0 
f0106ca2:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
f0106ca9:	00 
f0106caa:	c7 04 24 70 97 10 f0 	movl   $0xf0109770,(%esp)
f0106cb1:	e8 e7 93 ff ff       	call   f010009d <_panic>
	e1000_bar0_addr[E1000_TDBAL] = PADDR(e1000_transmit_descriptors);
f0106cb6:	c7 80 00 38 00 00 20 	movl   $0x35a020,0x3800(%eax)
f0106cbd:	a0 35 00 
	e1000_bar0_addr[E1000_TDBAH] = 0;
f0106cc0:	c7 80 04 38 00 00 00 	movl   $0x0,0x3804(%eax)
f0106cc7:	00 00 00 
f0106cca:	ba 00 8f 2b f0       	mov    $0xf02b8f00,%edx
f0106ccf:	b8 20 a0 35 f0       	mov    $0xf035a020,%eax
	uint32_t i;
	for(i=0;i<E1000_TX_DESCS;i++)
f0106cd4:	b9 00 00 00 00       	mov    $0x0,%ecx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0106cd9:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0106cdf:	77 20                	ja     f0106d01 <transmit_initalize+0x139>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0106ce1:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106ce5:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0106cec:	f0 
f0106ced:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
f0106cf4:	00 
f0106cf5:	c7 04 24 70 97 10 f0 	movl   $0xf0109770,(%esp)
f0106cfc:	e8 9c 93 ff ff       	call   f010009d <_panic>
f0106d01:	8d 9a 00 00 00 10    	lea    0x10000000(%edx),%ebx
	{
		e1000_transmit_descriptors[i].buff_addr = PADDR(&send_packet[i]);
f0106d07:	89 18                	mov    %ebx,(%eax)
f0106d09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		e1000_transmit_descriptors[i].cmd = e1000_transmit_descriptors[i].cmd | 0x10011111;
f0106d10:	80 48 0b 11          	orb    $0x11,0xb(%eax)
		e1000_transmit_descriptors[i].status = e1000_transmit_descriptors[i].status | E1000_TXD_STAT_DD;
f0106d14:	80 48 0c 01          	orb    $0x1,0xc(%eax)
	e1000_bar0_addr[E1000_TIPG] = e1000_bar0_addr[E1000_TIPG] | 0x4 << 10;
	e1000_bar0_addr[E1000_TIPG] = e1000_bar0_addr[E1000_TIPG] | 0x6 << 20;
	e1000_bar0_addr[E1000_TDBAL] = PADDR(e1000_transmit_descriptors);
	e1000_bar0_addr[E1000_TDBAH] = 0;
	uint32_t i;
	for(i=0;i<E1000_TX_DESCS;i++)
f0106d18:	83 c1 01             	add    $0x1,%ecx
f0106d1b:	81 c2 00 08 00 00    	add    $0x800,%edx
f0106d21:	83 c0 10             	add    $0x10,%eax
f0106d24:	83 f9 40             	cmp    $0x40,%ecx
f0106d27:	75 b0                	jne    f0106cd9 <transmit_initalize+0x111>
	{
		e1000_transmit_descriptors[i].buff_addr = PADDR(&send_packet[i]);
		e1000_transmit_descriptors[i].cmd = e1000_transmit_descriptors[i].cmd | 0x10011111;
		e1000_transmit_descriptors[i].status = e1000_transmit_descriptors[i].status | E1000_TXD_STAT_DD;
	}
	cprintf("Number of transmit_descriptors initialized are %d \n",i);
f0106d29:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106d2d:	c7 04 24 3c 97 10 f0 	movl   $0xf010973c,(%esp)
f0106d34:	e8 8c d2 ff ff       	call   f0103fc5 <cprintf>
}
f0106d39:	83 c4 14             	add    $0x14,%esp
f0106d3c:	5b                   	pop    %ebx
f0106d3d:	5d                   	pop    %ebp
f0106d3e:	c3                   	ret    

f0106d3f <transmit_packet>:

int transmit_packet(char *packet,int len)
{
f0106d3f:	55                   	push   %ebp
f0106d40:	89 e5                	mov    %esp,%ebp
f0106d42:	57                   	push   %edi
f0106d43:	56                   	push   %esi
f0106d44:	53                   	push   %ebx
f0106d45:	83 ec 1c             	sub    $0x1c,%esp
f0106d48:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0106d4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	cprintf("Transmitting packet %s\n",packet);
f0106d4e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0106d52:	c7 04 24 7d 97 10 f0 	movl   $0xf010977d,(%esp)
f0106d59:	e8 67 d2 ff ff       	call   f0103fc5 <cprintf>
	cprintf("Length is %d\n",len);
f0106d5e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106d62:	c7 04 24 95 97 10 f0 	movl   $0xf0109795,(%esp)
f0106d69:	e8 57 d2 ff ff       	call   f0103fc5 <cprintf>
	if(strlen(packet) > E1000_TX_PKT_SIZE)
f0106d6e:	89 1c 24             	mov    %ebx,(%esp)
f0106d71:	e8 3a f2 ff ff       	call   f0105fb0 <strlen>
f0106d76:	3d 00 08 00 00       	cmp    $0x800,%eax
f0106d7b:	7f 63                	jg     f0106de0 <transmit_packet+0xa1>
	{
		return -1;
	}
	uint32_t cur_tail = e1000_bar0_addr[E1000_TDT];
f0106d7d:	a1 e0 8e 2b f0       	mov    0xf02b8ee0,%eax
f0106d82:	8b b0 18 38 00 00    	mov    0x3818(%eax),%esi
	if((e1000_transmit_descriptors[cur_tail].status & E1000_TXD_STAT_DD) == ~E1000_TXD_STAT_DD)
	{
		sched_yield();
	}
	if((e1000_transmit_descriptors[cur_tail].status & E1000_TXD_STAT_DD) == E1000_TXD_STAT_DD)
f0106d88:	89 f2                	mov    %esi,%edx
f0106d8a:	c1 e2 04             	shl    $0x4,%edx
		e1000_transmit_descriptors[cur_tail].length = len;
		e1000_transmit_descriptors[cur_tail].status = e1000_transmit_descriptors[cur_tail].status & 0;
		e1000_bar0_addr[E1000_TDT] = (cur_tail + 1 ) % E1000_TX_DESCS;
	}
	
	return 0;
f0106d8d:	b8 00 00 00 00       	mov    $0x0,%eax
	uint32_t cur_tail = e1000_bar0_addr[E1000_TDT];
	if((e1000_transmit_descriptors[cur_tail].status & E1000_TXD_STAT_DD) == ~E1000_TXD_STAT_DD)
	{
		sched_yield();
	}
	if((e1000_transmit_descriptors[cur_tail].status & E1000_TXD_STAT_DD) == E1000_TXD_STAT_DD)
f0106d92:	f6 82 2c a0 35 f0 01 	testb  $0x1,-0xfca5fd4(%edx)
f0106d99:	74 4a                	je     f0106de5 <transmit_packet+0xa6>
	{
		memmove((void*)&send_packet[cur_tail],packet,len);
f0106d9b:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0106d9f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0106da3:	89 f0                	mov    %esi,%eax
f0106da5:	c1 e0 0b             	shl    $0xb,%eax
f0106da8:	05 00 8f 2b f0       	add    $0xf02b8f00,%eax
f0106dad:	89 04 24             	mov    %eax,(%esp)
f0106db0:	e8 cf f3 ff ff       	call   f0106184 <memmove>
		e1000_transmit_descriptors[cur_tail].length = len;
f0106db5:	89 f0                	mov    %esi,%eax
f0106db7:	c1 e0 04             	shl    $0x4,%eax
f0106dba:	66 89 b8 28 a0 35 f0 	mov    %di,-0xfca5fd8(%eax)
		e1000_transmit_descriptors[cur_tail].status = e1000_transmit_descriptors[cur_tail].status & 0;
f0106dc1:	c6 80 2c a0 35 f0 00 	movb   $0x0,-0xfca5fd4(%eax)
		e1000_bar0_addr[E1000_TDT] = (cur_tail + 1 ) % E1000_TX_DESCS;
f0106dc8:	83 c6 01             	add    $0x1,%esi
f0106dcb:	83 e6 3f             	and    $0x3f,%esi
f0106dce:	a1 e0 8e 2b f0       	mov    0xf02b8ee0,%eax
f0106dd3:	89 b0 18 38 00 00    	mov    %esi,0x3818(%eax)
	}
	
	return 0;
f0106dd9:	b8 00 00 00 00       	mov    $0x0,%eax
f0106dde:	eb 05                	jmp    f0106de5 <transmit_packet+0xa6>
{
	cprintf("Transmitting packet %s\n",packet);
	cprintf("Length is %d\n",len);
	if(strlen(packet) > E1000_TX_PKT_SIZE)
	{
		return -1;
f0106de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
		e1000_transmit_descriptors[cur_tail].status = e1000_transmit_descriptors[cur_tail].status & 0;
		e1000_bar0_addr[E1000_TDT] = (cur_tail + 1 ) % E1000_TX_DESCS;
	}
	
	return 0;
}
f0106de5:	83 c4 1c             	add    $0x1c,%esp
f0106de8:	5b                   	pop    %ebx
f0106de9:	5e                   	pop    %esi
f0106dea:	5f                   	pop    %edi
f0106deb:	5d                   	pop    %ebp
f0106dec:	c3                   	ret    

f0106ded <recieve_initalize>:

void recieve_initalize()
{
f0106ded:	55                   	push   %ebp
f0106dee:	89 e5                	mov    %esp,%ebp
f0106df0:	53                   	push   %ebx
f0106df1:	83 ec 14             	sub    $0x14,%esp
	cprintf("Initializing E1000 recieve\n");
f0106df4:	c7 04 24 a3 97 10 f0 	movl   $0xf01097a3,(%esp)
f0106dfb:	e8 c5 d1 ff ff       	call   f0103fc5 <cprintf>
	e1000_bar0_addr[E1000_RA] = 0x12005452;
f0106e00:	a1 e0 8e 2b f0       	mov    0xf02b8ee0,%eax
f0106e05:	c7 80 00 54 00 00 52 	movl   $0x12005452,0x5400(%eax)
f0106e0c:	54 00 12 
	e1000_bar0_addr[E1000_RA+1] = 0x5634;
f0106e0f:	c7 80 04 54 00 00 34 	movl   $0x5634,0x5404(%eax)
f0106e16:	56 00 00 
	e1000_bar0_addr[E1000_RA+1] = e1000_bar0_addr[E1000_RA+1] | E1000_RAH_AV ;
f0106e19:	8b 90 04 54 00 00    	mov    0x5404(%eax),%edx
f0106e1f:	81 ca 00 00 00 80    	or     $0x80000000,%edx
f0106e25:	89 90 04 54 00 00    	mov    %edx,0x5404(%eax)
	e1000_bar0_addr[E1000_MTA] = 0;
f0106e2b:	c7 80 00 52 00 00 00 	movl   $0x0,0x5200(%eax)
f0106e32:	00 00 00 
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0106e35:	ba 20 a4 35 f0       	mov    $0xf035a420,%edx
f0106e3a:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0106e40:	77 20                	ja     f0106e62 <recieve_initalize+0x75>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0106e42:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106e46:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0106e4d:	f0 
f0106e4e:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
f0106e55:	00 
f0106e56:	c7 04 24 70 97 10 f0 	movl   $0xf0109770,(%esp)
f0106e5d:	e8 3b 92 ff ff       	call   f010009d <_panic>
	e1000_bar0_addr[E1000_RDBAL] = PADDR(e1000_recieve_descriptors);
f0106e62:	c7 80 00 28 00 00 20 	movl   $0x35a420,0x2800(%eax)
f0106e69:	a4 35 00 
	e1000_bar0_addr[E1000_RDBAH] = 0;
f0106e6c:	c7 80 04 28 00 00 00 	movl   $0x0,0x2804(%eax)
f0106e73:	00 00 00 
	//e1000_bar0_addr[E1000_RCTL] = 0x4000002;
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] | E1000_RCTL_EN;
f0106e76:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f0106e7c:	83 ca 02             	or     $0x2,%edx
f0106e7f:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] | E1000_RCTL_BAM;
f0106e85:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f0106e8b:	80 ce 80             	or     $0x80,%dh
f0106e8e:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] | E1000_RCTL_SZ_2048;
f0106e94:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f0106e9a:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] | E1000_RCTL_SECRC;
f0106ea0:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f0106ea6:	81 ca 00 00 00 04    	or     $0x4000000,%edx
f0106eac:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] & ~E1000_RCTL_LPE;
f0106eb2:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f0106eb8:	83 e2 df             	and    $0xffffffdf,%edx
f0106ebb:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	e1000_bar0_addr[E1000_RDLEN] = E1000_RX_DESCS * sizeof(struct recieve_descriptor);
f0106ec1:	c7 80 08 28 00 00 00 	movl   $0x800,0x2808(%eax)
f0106ec8:	08 00 00 
	e1000_bar0_addr[E1000_RDH] = 0;
f0106ecb:	c7 80 10 28 00 00 00 	movl   $0x0,0x2810(%eax)
f0106ed2:	00 00 00 
	e1000_bar0_addr[E1000_RDT] = E1000_RX_DESCS -1;
f0106ed5:	c7 80 18 28 00 00 7f 	movl   $0x7f,0x2818(%eax)
f0106edc:	00 00 00 
	uint32_t i;
	cprintf("RCTL register value is %08x \n",e1000_bar0_addr[E1000_RCTL]);
f0106edf:	8b 80 00 01 00 00    	mov    0x100(%eax),%eax
f0106ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106ee9:	c7 04 24 bf 97 10 f0 	movl   $0xf01097bf,(%esp)
f0106ef0:	e8 d0 d0 ff ff       	call   f0103fc5 <cprintf>
f0106ef5:	b8 00 8f 2d f0       	mov    $0xf02d8f00,%eax
f0106efa:	ba 20 a4 35 f0       	mov    $0xf035a420,%edx
f0106eff:	bb 00 8f 31 f0       	mov    $0xf0318f00,%ebx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0106f04:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0106f09:	77 20                	ja     f0106f2b <recieve_initalize+0x13e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0106f0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106f0f:	c7 44 24 08 38 7a 10 	movl   $0xf0107a38,0x8(%esp)
f0106f16:	f0 
f0106f17:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
f0106f1e:	00 
f0106f1f:	c7 04 24 70 97 10 f0 	movl   $0xf0109770,(%esp)
f0106f26:	e8 72 91 ff ff       	call   f010009d <_panic>
f0106f2b:	8d 88 00 00 00 10    	lea    0x10000000(%eax),%ecx
	for(i=0;i<E1000_RX_DESCS;i++)
	{
		e1000_recieve_descriptors[i].buff_addr = PADDR(&recieve_packet[i]);
f0106f31:	89 0a                	mov    %ecx,(%edx)
f0106f33:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
		e1000_recieve_descriptors[i].status  = 0;
f0106f3a:	c6 42 0c 00          	movb   $0x0,0xc(%edx)
f0106f3e:	05 00 08 00 00       	add    $0x800,%eax
f0106f43:	83 c2 10             	add    $0x10,%edx
	e1000_bar0_addr[E1000_RDLEN] = E1000_RX_DESCS * sizeof(struct recieve_descriptor);
	e1000_bar0_addr[E1000_RDH] = 0;
	e1000_bar0_addr[E1000_RDT] = E1000_RX_DESCS -1;
	uint32_t i;
	cprintf("RCTL register value is %08x \n",e1000_bar0_addr[E1000_RCTL]);
	for(i=0;i<E1000_RX_DESCS;i++)
f0106f46:	39 d8                	cmp    %ebx,%eax
f0106f48:	75 ba                	jne    f0106f04 <recieve_initalize+0x117>
	{
		e1000_recieve_descriptors[i].buff_addr = PADDR(&recieve_packet[i]);
		e1000_recieve_descriptors[i].status  = 0;
	}

}
f0106f4a:	83 c4 14             	add    $0x14,%esp
f0106f4d:	5b                   	pop    %ebx
f0106f4e:	5d                   	pop    %ebp
f0106f4f:	c3                   	ret    

f0106f50 <recv_packet>:

int recv_packet(char *data, int *len)
{
f0106f50:	55                   	push   %ebp
f0106f51:	89 e5                	mov    %esp,%ebp
f0106f53:	56                   	push   %esi
f0106f54:	53                   	push   %ebx
f0106f55:	83 ec 10             	sub    $0x10,%esp
	uint32_t c_tail = (e1000_bar0_addr[E1000_RDT] + 1) % E1000_RX_DESCS;		
f0106f58:	a1 e0 8e 2b f0       	mov    0xf02b8ee0,%eax
f0106f5d:	8b 98 18 28 00 00    	mov    0x2818(%eax),%ebx
f0106f63:	83 c3 01             	add    $0x1,%ebx
f0106f66:	83 e3 7f             	and    $0x7f,%ebx
	if ((e1000_recieve_descriptors[c_tail].status & E1000_RXD_STAT_DD) != E1000_RXD_STAT_DD) 
f0106f69:	89 da                	mov    %ebx,%edx
f0106f6b:	c1 e2 04             	shl    $0x4,%edx
f0106f6e:	f6 82 2c a4 35 f0 01 	testb  $0x1,-0xfca5bd4(%edx)
f0106f75:	74 6d                	je     f0106fe4 <recv_packet+0x94>
		return -1;
	if ((e1000_recieve_descriptors[c_tail].status & E1000_RXD_STAT_DD) == E1000_RXD_STAT_DD) 
	{
	cprintf("Head is %d\n",e1000_bar0_addr[E1000_RDH]);
f0106f77:	8b 80 10 28 00 00    	mov    0x2810(%eax),%eax
f0106f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106f81:	c7 04 24 dd 97 10 f0 	movl   $0xf01097dd,(%esp)
f0106f88:	e8 38 d0 ff ff       	call   f0103fc5 <cprintf>
	cprintf("Tail is %d\n",c_tail);
f0106f8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0106f91:	c7 04 24 e9 97 10 f0 	movl   $0xf01097e9,(%esp)
f0106f98:	e8 28 d0 ff ff       	call   f0103fc5 <cprintf>
	*len = e1000_recieve_descriptors[c_tail].length;
f0106f9d:	89 de                	mov    %ebx,%esi
f0106f9f:	c1 e6 04             	shl    $0x4,%esi
f0106fa2:	0f b7 86 28 a4 35 f0 	movzwl -0xfca5bd8(%esi),%eax
f0106fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
f0106fac:	89 02                	mov    %eax,(%edx)
	memmove(data, recieve_packet[c_tail], *len);
f0106fae:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106fb2:	89 d8                	mov    %ebx,%eax
f0106fb4:	c1 e0 0b             	shl    $0xb,%eax
f0106fb7:	05 00 8f 2d f0       	add    $0xf02d8f00,%eax
f0106fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106fc0:	8b 45 08             	mov    0x8(%ebp),%eax
f0106fc3:	89 04 24             	mov    %eax,(%esp)
f0106fc6:	e8 b9 f1 ff ff       	call   f0106184 <memmove>

	e1000_recieve_descriptors[c_tail].status &= 0;
f0106fcb:	c6 86 2c a4 35 f0 00 	movb   $0x0,-0xfca5bd4(%esi)
	e1000_bar0_addr[E1000_RDT] = c_tail;
f0106fd2:	a1 e0 8e 2b f0       	mov    0xf02b8ee0,%eax
f0106fd7:	89 98 18 28 00 00    	mov    %ebx,0x2818(%eax)
	}
return 0;
f0106fdd:	b8 00 00 00 00       	mov    $0x0,%eax
f0106fe2:	eb 05                	jmp    f0106fe9 <recv_packet+0x99>

int recv_packet(char *data, int *len)
{
	uint32_t c_tail = (e1000_bar0_addr[E1000_RDT] + 1) % E1000_RX_DESCS;		
	if ((e1000_recieve_descriptors[c_tail].status & E1000_RXD_STAT_DD) != E1000_RXD_STAT_DD) 
		return -1;
f0106fe4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	e1000_recieve_descriptors[c_tail].status &= 0;
	e1000_bar0_addr[E1000_RDT] = c_tail;
	}
return 0;
	
}
f0106fe9:	83 c4 10             	add    $0x10,%esp
f0106fec:	5b                   	pop    %ebx
f0106fed:	5e                   	pop    %esi
f0106fee:	5d                   	pop    %ebp
f0106fef:	c3                   	ret    

f0106ff0 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0106ff0:	55                   	push   %ebp
f0106ff1:	89 e5                	mov    %esp,%ebp
f0106ff3:	57                   	push   %edi
f0106ff4:	56                   	push   %esi
f0106ff5:	53                   	push   %ebx
f0106ff6:	83 ec 2c             	sub    $0x2c,%esp
f0106ff9:	8b 7d 08             	mov    0x8(%ebp),%edi
f0106ffc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0106fff:	eb 41                	jmp    f0107042 <pci_attach_match+0x52>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0107001:	39 3b                	cmp    %edi,(%ebx)
f0107003:	75 3a                	jne    f010703f <pci_attach_match+0x4f>
f0107005:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107008:	39 56 04             	cmp    %edx,0x4(%esi)
f010700b:	75 32                	jne    f010703f <pci_attach_match+0x4f>
			int r = list[i].attachfn(pcif);
f010700d:	8b 4d 14             	mov    0x14(%ebp),%ecx
f0107010:	89 0c 24             	mov    %ecx,(%esp)
f0107013:	ff d0                	call   *%eax
			if (r > 0)
f0107015:	85 c0                	test   %eax,%eax
f0107017:	7f 32                	jg     f010704b <pci_attach_match+0x5b>
				return r;
			if (r < 0)
f0107019:	85 c0                	test   %eax,%eax
f010701b:	79 22                	jns    f010703f <pci_attach_match+0x4f>
				cprintf("pci_attach_match: attaching "
f010701d:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107021:	8b 46 08             	mov    0x8(%esi),%eax
f0107024:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107028:	8b 45 0c             	mov    0xc(%ebp),%eax
f010702b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010702f:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0107033:	c7 04 24 f8 97 10 f0 	movl   $0xf01097f8,(%esp)
f010703a:	e8 86 cf ff ff       	call   f0103fc5 <cprintf>
f010703f:	83 c3 0c             	add    $0xc,%ebx
f0107042:	89 de                	mov    %ebx,%esi
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107044:	8b 43 08             	mov    0x8(%ebx),%eax
f0107047:	85 c0                	test   %eax,%eax
f0107049:	75 b6                	jne    f0107001 <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f010704b:	83 c4 2c             	add    $0x2c,%esp
f010704e:	5b                   	pop    %ebx
f010704f:	5e                   	pop    %esi
f0107050:	5f                   	pop    %edi
f0107051:	5d                   	pop    %ebp
f0107052:	c3                   	ret    

f0107053 <pci_conf1_set_addr>:
static void
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f0107053:	55                   	push   %ebp
f0107054:	89 e5                	mov    %esp,%ebp
f0107056:	56                   	push   %esi
f0107057:	53                   	push   %ebx
f0107058:	83 ec 10             	sub    $0x10,%esp
f010705b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f010705e:	3d ff 00 00 00       	cmp    $0xff,%eax
f0107063:	76 24                	jbe    f0107089 <pci_conf1_set_addr+0x36>
f0107065:	c7 44 24 0c 80 99 10 	movl   $0xf0109980,0xc(%esp)
f010706c:	f0 
f010706d:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f0107074:	f0 
f0107075:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
f010707c:	00 
f010707d:	c7 04 24 8a 99 10 f0 	movl   $0xf010998a,(%esp)
f0107084:	e8 14 90 ff ff       	call   f010009d <_panic>
	assert(dev < 32);
f0107089:	83 fa 1f             	cmp    $0x1f,%edx
f010708c:	76 24                	jbe    f01070b2 <pci_conf1_set_addr+0x5f>
f010708e:	c7 44 24 0c 95 99 10 	movl   $0xf0109995,0xc(%esp)
f0107095:	f0 
f0107096:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010709d:	f0 
f010709e:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
f01070a5:	00 
f01070a6:	c7 04 24 8a 99 10 f0 	movl   $0xf010998a,(%esp)
f01070ad:	e8 eb 8f ff ff       	call   f010009d <_panic>
	assert(func < 8);
f01070b2:	83 f9 07             	cmp    $0x7,%ecx
f01070b5:	76 24                	jbe    f01070db <pci_conf1_set_addr+0x88>
f01070b7:	c7 44 24 0c 9e 99 10 	movl   $0xf010999e,0xc(%esp)
f01070be:	f0 
f01070bf:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01070c6:	f0 
f01070c7:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
f01070ce:	00 
f01070cf:	c7 04 24 8a 99 10 f0 	movl   $0xf010998a,(%esp)
f01070d6:	e8 c2 8f ff ff       	call   f010009d <_panic>
	assert(offset < 256);
f01070db:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f01070e1:	76 24                	jbe    f0107107 <pci_conf1_set_addr+0xb4>
f01070e3:	c7 44 24 0c a7 99 10 	movl   $0xf01099a7,0xc(%esp)
f01070ea:	f0 
f01070eb:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f01070f2:	f0 
f01070f3:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
f01070fa:	00 
f01070fb:	c7 04 24 8a 99 10 f0 	movl   $0xf010998a,(%esp)
f0107102:	e8 96 8f ff ff       	call   f010009d <_panic>
	assert((offset & 0x3) == 0);
f0107107:	f6 c3 03             	test   $0x3,%bl
f010710a:	74 24                	je     f0107130 <pci_conf1_set_addr+0xdd>
f010710c:	c7 44 24 0c b4 99 10 	movl   $0xf01099b4,0xc(%esp)
f0107113:	f0 
f0107114:	c7 44 24 08 a2 7f 10 	movl   $0xf0107fa2,0x8(%esp)
f010711b:	f0 
f010711c:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
f0107123:	00 
f0107124:	c7 04 24 8a 99 10 f0 	movl   $0xf010998a,(%esp)
f010712b:	e8 6d 8f ff ff       	call   f010009d <_panic>

	uint32_t v = (1 << 31) |		// config-space
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0107130:	81 cb 00 00 00 80    	or     $0x80000000,%ebx
f0107136:	c1 e1 08             	shl    $0x8,%ecx
f0107139:	09 cb                	or     %ecx,%ebx
f010713b:	89 d6                	mov    %edx,%esi
f010713d:	c1 e6 0b             	shl    $0xb,%esi
f0107140:	09 f3                	or     %esi,%ebx
f0107142:	c1 e0 10             	shl    $0x10,%eax
f0107145:	89 c6                	mov    %eax,%esi
	assert(dev < 32);
	assert(func < 8);
	assert(offset < 256);
	assert((offset & 0x3) == 0);

	uint32_t v = (1 << 31) |		// config-space
f0107147:	89 d8                	mov    %ebx,%eax
f0107149:	09 f0                	or     %esi,%eax
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010714b:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0107150:	ef                   	out    %eax,(%dx)
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
	outl(pci_conf1_addr_ioport, v);
}
f0107151:	83 c4 10             	add    $0x10,%esp
f0107154:	5b                   	pop    %ebx
f0107155:	5e                   	pop    %esi
f0107156:	5d                   	pop    %ebp
f0107157:	c3                   	ret    

f0107158 <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f0107158:	55                   	push   %ebp
f0107159:	89 e5                	mov    %esp,%ebp
f010715b:	53                   	push   %ebx
f010715c:	83 ec 14             	sub    $0x14,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010715f:	8b 48 08             	mov    0x8(%eax),%ecx
f0107162:	8b 58 04             	mov    0x4(%eax),%ebx
f0107165:	8b 00                	mov    (%eax),%eax
f0107167:	8b 40 04             	mov    0x4(%eax),%eax
f010716a:	89 14 24             	mov    %edx,(%esp)
f010716d:	89 da                	mov    %ebx,%edx
f010716f:	e8 df fe ff ff       	call   f0107053 <pci_conf1_set_addr>

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0107174:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107179:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f010717a:	83 c4 14             	add    $0x14,%esp
f010717d:	5b                   	pop    %ebx
f010717e:	5d                   	pop    %ebp
f010717f:	c3                   	ret    

f0107180 <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0107180:	55                   	push   %ebp
f0107181:	89 e5                	mov    %esp,%ebp
f0107183:	57                   	push   %edi
f0107184:	56                   	push   %esi
f0107185:	53                   	push   %ebx
f0107186:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
f010718c:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f010718e:	c7 44 24 08 48 00 00 	movl   $0x48,0x8(%esp)
f0107195:	00 
f0107196:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010719d:	00 
f010719e:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01071a1:	89 04 24             	mov    %eax,(%esp)
f01071a4:	e8 8e ef ff ff       	call   f0106137 <memset>
	df.bus = bus;
f01071a9:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f01071ac:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
}

static int
pci_scan_bus(struct pci_bus *bus)
{
	int totaldev = 0;
f01071b3:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f01071ba:	00 00 00 
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f01071bd:	ba 0c 00 00 00       	mov    $0xc,%edx
f01071c2:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01071c5:	e8 8e ff ff ff       	call   f0107158 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f01071ca:	89 c2                	mov    %eax,%edx
f01071cc:	c1 ea 10             	shr    $0x10,%edx
f01071cf:	83 e2 7f             	and    $0x7f,%edx
f01071d2:	83 fa 01             	cmp    $0x1,%edx
f01071d5:	0f 87 6f 01 00 00    	ja     f010734a <pci_scan_bus+0x1ca>
			continue;

		totaldev++;
f01071db:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)

		struct pci_func f = df;
f01071e2:	b9 12 00 00 00       	mov    $0x12,%ecx
f01071e7:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f01071ed:	8d 75 a0             	lea    -0x60(%ebp),%esi
f01071f0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f01071f2:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f01071f9:	00 00 00 
f01071fc:	25 00 00 80 00       	and    $0x800000,%eax
f0107201:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
		     f.func++) {
			struct pci_func af = f;
f0107207:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f010720d:	e9 1d 01 00 00       	jmp    f010732f <pci_scan_bus+0x1af>
		     f.func++) {
			struct pci_func af = f;
f0107212:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107217:	89 df                	mov    %ebx,%edi
f0107219:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f010721f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0107221:	ba 00 00 00 00       	mov    $0x0,%edx
f0107226:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f010722c:	e8 27 ff ff ff       	call   f0107158 <pci_conf_read>
f0107231:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0107237:	66 83 f8 ff          	cmp    $0xffff,%ax
f010723b:	0f 84 e7 00 00 00    	je     f0107328 <pci_scan_bus+0x1a8>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107241:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0107246:	89 d8                	mov    %ebx,%eax
f0107248:	e8 0b ff ff ff       	call   f0107158 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f010724d:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107250:	ba 08 00 00 00       	mov    $0x8,%edx
f0107255:	89 d8                	mov    %ebx,%eax
f0107257:	e8 fc fe ff ff       	call   f0107158 <pci_conf_read>
f010725c:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f0107262:	89 c2                	mov    %eax,%edx
f0107264:	c1 ea 18             	shr    $0x18,%edx
};

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
f0107267:	b9 c8 99 10 f0       	mov    $0xf01099c8,%ecx
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f010726c:	83 fa 06             	cmp    $0x6,%edx
f010726f:	77 07                	ja     f0107278 <pci_scan_bus+0xf8>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0107271:	8b 0c 95 54 9a 10 f0 	mov    -0xfef65ac(,%edx,4),%ecx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107278:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f010727e:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f0107282:	89 7c 24 24          	mov    %edi,0x24(%esp)
f0107286:	89 4c 24 20          	mov    %ecx,0x20(%esp)
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f010728a:	c1 e8 10             	shr    $0x10,%eax
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f010728d:	0f b6 c0             	movzbl %al,%eax
f0107290:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0107294:	89 54 24 18          	mov    %edx,0x18(%esp)
f0107298:	89 f0                	mov    %esi,%eax
f010729a:	c1 e8 10             	shr    $0x10,%eax
f010729d:	89 44 24 14          	mov    %eax,0x14(%esp)
f01072a1:	0f b7 f6             	movzwl %si,%esi
f01072a4:	89 74 24 10          	mov    %esi,0x10(%esp)
f01072a8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f01072ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01072b2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
f01072b8:	89 44 24 08          	mov    %eax,0x8(%esp)
f01072bc:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f01072c2:	8b 40 04             	mov    0x4(%eax),%eax
f01072c5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01072c9:	c7 04 24 24 98 10 f0 	movl   $0xf0109824,(%esp)
f01072d0:	e8 f0 cc ff ff       	call   f0103fc5 <cprintf>
static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
f01072d5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax

static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
f01072db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01072df:	c7 44 24 08 0c 44 12 	movl   $0xf012440c,0x8(%esp)
f01072e6:	f0 
				 PCI_SUBCLASS(f->dev_class),
f01072e7:	89 c2                	mov    %eax,%edx
f01072e9:	c1 ea 10             	shr    $0x10,%edx

static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
f01072ec:	0f b6 d2             	movzbl %dl,%edx
f01072ef:	89 54 24 04          	mov    %edx,0x4(%esp)
f01072f3:	c1 e8 18             	shr    $0x18,%eax
f01072f6:	89 04 24             	mov    %eax,(%esp)
f01072f9:	e8 f2 fc ff ff       	call   f0106ff0 <pci_attach_match>
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
f01072fe:	85 c0                	test   %eax,%eax
f0107300:	75 26                	jne    f0107328 <pci_scan_bus+0x1a8>
		pci_attach_match(PCI_VENDOR(f->dev_id),
				 PCI_PRODUCT(f->dev_id),
f0107302:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0107308:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010730c:	c7 44 24 08 f4 43 12 	movl   $0xf01243f4,0x8(%esp)
f0107313:	f0 
f0107314:	89 c2                	mov    %eax,%edx
f0107316:	c1 ea 10             	shr    $0x10,%edx
f0107319:	89 54 24 04          	mov    %edx,0x4(%esp)
f010731d:	0f b7 c0             	movzwl %ax,%eax
f0107320:	89 04 24             	mov    %eax,(%esp)
f0107323:	e8 c8 fc ff ff       	call   f0106ff0 <pci_attach_match>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0107328:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f010732f:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
f0107336:	19 c0                	sbb    %eax,%eax
f0107338:	83 e0 f9             	and    $0xfffffff9,%eax
f010733b:	83 c0 08             	add    $0x8,%eax
f010733e:	3b 85 18 ff ff ff    	cmp    -0xe8(%ebp),%eax
f0107344:	0f 87 c8 fe ff ff    	ja     f0107212 <pci_scan_bus+0x92>
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
f010734a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f010734d:	83 c0 01             	add    $0x1,%eax
f0107350:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0107353:	83 f8 1f             	cmp    $0x1f,%eax
f0107356:	0f 86 61 fe ff ff    	jbe    f01071bd <pci_scan_bus+0x3d>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f010735c:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0107362:	81 c4 1c 01 00 00    	add    $0x11c,%esp
f0107368:	5b                   	pop    %ebx
f0107369:	5e                   	pop    %esi
f010736a:	5f                   	pop    %edi
f010736b:	5d                   	pop    %ebp
f010736c:	c3                   	ret    

f010736d <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f010736d:	55                   	push   %ebp
f010736e:	89 e5                	mov    %esp,%ebp
f0107370:	57                   	push   %edi
f0107371:	56                   	push   %esi
f0107372:	53                   	push   %ebx
f0107373:	83 ec 3c             	sub    $0x3c,%esp
f0107376:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0107379:	ba 1c 00 00 00       	mov    $0x1c,%edx
f010737e:	89 d8                	mov    %ebx,%eax
f0107380:	e8 d3 fd ff ff       	call   f0107158 <pci_conf_read>
f0107385:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0107387:	ba 18 00 00 00       	mov    $0x18,%edx
f010738c:	89 d8                	mov    %ebx,%eax
f010738e:	e8 c5 fd ff ff       	call   f0107158 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0107393:	83 e7 0f             	and    $0xf,%edi
f0107396:	83 ff 01             	cmp    $0x1,%edi
f0107399:	75 2a                	jne    f01073c5 <pci_bridge_attach+0x58>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f010739b:	8b 43 08             	mov    0x8(%ebx),%eax
f010739e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01073a2:	8b 43 04             	mov    0x4(%ebx),%eax
f01073a5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01073a9:	8b 03                	mov    (%ebx),%eax
f01073ab:	8b 40 04             	mov    0x4(%eax),%eax
f01073ae:	89 44 24 04          	mov    %eax,0x4(%esp)
f01073b2:	c7 04 24 60 98 10 f0 	movl   $0xf0109860,(%esp)
f01073b9:	e8 07 cc ff ff       	call   f0103fc5 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
f01073be:	b8 00 00 00 00       	mov    $0x0,%eax
f01073c3:	eb 67                	jmp    f010742c <pci_bridge_attach+0xbf>
f01073c5:	89 c6                	mov    %eax,%esi
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f01073c7:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f01073ce:	00 
f01073cf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01073d6:	00 
f01073d7:	8d 7d e0             	lea    -0x20(%ebp),%edi
f01073da:	89 3c 24             	mov    %edi,(%esp)
f01073dd:	e8 55 ed ff ff       	call   f0106137 <memset>
	nbus.parent_bridge = pcif;
f01073e2:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f01073e5:	89 f0                	mov    %esi,%eax
f01073e7:	0f b6 c4             	movzbl %ah,%eax
f01073ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f01073ed:	89 f2                	mov    %esi,%edx
f01073ef:	c1 ea 10             	shr    $0x10,%edx
	memset(&nbus, 0, sizeof(nbus));
	nbus.parent_bridge = pcif;
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f01073f2:	0f b6 f2             	movzbl %dl,%esi
f01073f5:	89 74 24 14          	mov    %esi,0x14(%esp)
f01073f9:	89 44 24 10          	mov    %eax,0x10(%esp)
f01073fd:	8b 43 08             	mov    0x8(%ebx),%eax
f0107400:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107404:	8b 43 04             	mov    0x4(%ebx),%eax
f0107407:	89 44 24 08          	mov    %eax,0x8(%esp)
f010740b:	8b 03                	mov    (%ebx),%eax
f010740d:	8b 40 04             	mov    0x4(%eax),%eax
f0107410:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107414:	c7 04 24 94 98 10 f0 	movl   $0xf0109894,(%esp)
f010741b:	e8 a5 cb ff ff       	call   f0103fc5 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);

	pci_scan_bus(&nbus);
f0107420:	89 f8                	mov    %edi,%eax
f0107422:	e8 59 fd ff ff       	call   f0107180 <pci_scan_bus>
	return 1;
f0107427:	b8 01 00 00 00       	mov    $0x1,%eax
}
f010742c:	83 c4 3c             	add    $0x3c,%esp
f010742f:	5b                   	pop    %ebx
f0107430:	5e                   	pop    %esi
f0107431:	5f                   	pop    %edi
f0107432:	5d                   	pop    %ebp
f0107433:	c3                   	ret    

f0107434 <pci_conf_write>:
	return inl(pci_conf1_data_ioport);
}

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f0107434:	55                   	push   %ebp
f0107435:	89 e5                	mov    %esp,%ebp
f0107437:	56                   	push   %esi
f0107438:	53                   	push   %ebx
f0107439:	83 ec 10             	sub    $0x10,%esp
f010743c:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010743e:	8b 48 08             	mov    0x8(%eax),%ecx
f0107441:	8b 70 04             	mov    0x4(%eax),%esi
f0107444:	8b 00                	mov    (%eax),%eax
f0107446:	8b 40 04             	mov    0x4(%eax),%eax
f0107449:	89 14 24             	mov    %edx,(%esp)
f010744c:	89 f2                	mov    %esi,%edx
f010744e:	e8 00 fc ff ff       	call   f0107053 <pci_conf1_set_addr>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107453:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107458:	89 d8                	mov    %ebx,%eax
f010745a:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f010745b:	83 c4 10             	add    $0x10,%esp
f010745e:	5b                   	pop    %ebx
f010745f:	5e                   	pop    %esi
f0107460:	5d                   	pop    %ebp
f0107461:	c3                   	ret    

f0107462 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0107462:	55                   	push   %ebp
f0107463:	89 e5                	mov    %esp,%ebp
f0107465:	57                   	push   %edi
f0107466:	56                   	push   %esi
f0107467:	53                   	push   %ebx
f0107468:	83 ec 4c             	sub    $0x4c,%esp
f010746b:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f010746e:	b9 07 00 00 00       	mov    $0x7,%ecx
f0107473:	ba 04 00 00 00       	mov    $0x4,%edx
f0107478:	89 f8                	mov    %edi,%eax
f010747a:	e8 b5 ff ff ff       	call   f0107434 <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f010747f:	be 10 00 00 00       	mov    $0x10,%esi
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f0107484:	89 f2                	mov    %esi,%edx
f0107486:	89 f8                	mov    %edi,%eax
f0107488:	e8 cb fc ff ff       	call   f0107158 <pci_conf_read>
f010748d:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		bar_width = 4;
		pci_conf_write(f, bar, 0xffffffff);
f0107490:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0107495:	89 f2                	mov    %esi,%edx
f0107497:	89 f8                	mov    %edi,%eax
f0107499:	e8 96 ff ff ff       	call   f0107434 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f010749e:	89 f2                	mov    %esi,%edx
f01074a0:	89 f8                	mov    %edi,%eax
f01074a2:	e8 b1 fc ff ff       	call   f0107158 <pci_conf_read>
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f01074a7:	bb 04 00 00 00       	mov    $0x4,%ebx
		pci_conf_write(f, bar, 0xffffffff);
		uint32_t rv = pci_conf_read(f, bar);

		if (rv == 0)
f01074ac:	85 c0                	test   %eax,%eax
f01074ae:	0f 84 c1 00 00 00    	je     f0107575 <pci_func_enable+0x113>
			continue;

		int regnum = PCI_MAPREG_NUM(bar);
f01074b4:	8d 56 f0             	lea    -0x10(%esi),%edx
f01074b7:	c1 ea 02             	shr    $0x2,%edx
f01074ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f01074bd:	a8 01                	test   $0x1,%al
f01074bf:	75 2c                	jne    f01074ed <pci_func_enable+0x8b>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f01074c1:	89 c2                	mov    %eax,%edx
f01074c3:	83 e2 06             	and    $0x6,%edx
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f01074c6:	83 fa 04             	cmp    $0x4,%edx
f01074c9:	0f 94 c3             	sete   %bl
f01074cc:	0f b6 db             	movzbl %bl,%ebx
f01074cf:	8d 1c 9d 04 00 00 00 	lea    0x4(,%ebx,4),%ebx
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
				bar_width = 8;

			size = PCI_MAPREG_MEM_SIZE(rv);
f01074d6:	83 e0 f0             	and    $0xfffffff0,%eax
f01074d9:	89 c2                	mov    %eax,%edx
f01074db:	f7 da                	neg    %edx
f01074dd:	21 d0                	and    %edx,%eax
f01074df:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
f01074e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01074e5:	83 e0 f0             	and    $0xfffffff0,%eax
f01074e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01074eb:	eb 1a                	jmp    f0107507 <pci_func_enable+0xa5>
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f01074ed:	83 e0 fc             	and    $0xfffffffc,%eax
f01074f0:	89 c2                	mov    %eax,%edx
f01074f2:	f7 da                	neg    %edx
f01074f4:	21 d0                	and    %edx,%eax
f01074f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
f01074f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01074fc:	83 e0 fc             	and    $0xfffffffc,%eax
f01074ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f0107502:	bb 04 00 00 00       	mov    $0x4,%ebx
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0107507:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f010750a:	89 f2                	mov    %esi,%edx
f010750c:	89 f8                	mov    %edi,%eax
f010750e:	e8 21 ff ff ff       	call   f0107434 <pci_conf_write>
f0107513:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0107516:	8d 04 87             	lea    (%edi,%eax,4),%eax
		f->reg_base[regnum] = base;
f0107519:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f010751c:	89 48 14             	mov    %ecx,0x14(%eax)
		f->reg_size[regnum] = size;
f010751f:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0107522:	89 50 2c             	mov    %edx,0x2c(%eax)

		if (size && !base)
f0107525:	85 c9                	test   %ecx,%ecx
f0107527:	75 4c                	jne    f0107575 <pci_func_enable+0x113>
f0107529:	85 d2                	test   %edx,%edx
f010752b:	74 48                	je     f0107575 <pci_func_enable+0x113>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f010752d:	8b 47 0c             	mov    0xc(%edi),%eax
		pci_conf_write(f, bar, oldv);
		f->reg_base[regnum] = base;
		f->reg_size[regnum] = size;

		if (size && !base)
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0107530:	89 54 24 20          	mov    %edx,0x20(%esp)
f0107534:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0107537:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
f010753b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010753e:	89 4c 24 18          	mov    %ecx,0x18(%esp)
f0107542:	89 c2                	mov    %eax,%edx
f0107544:	c1 ea 10             	shr    $0x10,%edx
f0107547:	89 54 24 14          	mov    %edx,0x14(%esp)
f010754b:	0f b7 c0             	movzwl %ax,%eax
f010754e:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107552:	8b 47 08             	mov    0x8(%edi),%eax
f0107555:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107559:	8b 47 04             	mov    0x4(%edi),%eax
f010755c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107560:	8b 07                	mov    (%edi),%eax
f0107562:	8b 40 04             	mov    0x4(%eax),%eax
f0107565:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107569:	c7 04 24 c4 98 10 f0 	movl   $0xf01098c4,(%esp)
f0107570:	e8 50 ca ff ff       	call   f0103fc5 <cprintf>
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
f0107575:	01 de                	add    %ebx,%esi
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107577:	83 fe 27             	cmp    $0x27,%esi
f010757a:	0f 86 04 ff ff ff    	jbe    f0107484 <pci_func_enable+0x22>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0107580:	8b 47 0c             	mov    0xc(%edi),%eax
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0107583:	89 c2                	mov    %eax,%edx
f0107585:	c1 ea 10             	shr    $0x10,%edx
f0107588:	89 54 24 14          	mov    %edx,0x14(%esp)
f010758c:	0f b7 c0             	movzwl %ax,%eax
f010758f:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107593:	8b 47 08             	mov    0x8(%edi),%eax
f0107596:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010759a:	8b 47 04             	mov    0x4(%edi),%eax
f010759d:	89 44 24 08          	mov    %eax,0x8(%esp)
f01075a1:	8b 07                	mov    (%edi),%eax
f01075a3:	8b 40 04             	mov    0x4(%eax),%eax
f01075a6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01075aa:	c7 04 24 20 99 10 f0 	movl   $0xf0109920,(%esp)
f01075b1:	e8 0f ca ff ff       	call   f0103fc5 <cprintf>
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}
f01075b6:	83 c4 4c             	add    $0x4c,%esp
f01075b9:	5b                   	pop    %ebx
f01075ba:	5e                   	pop    %esi
f01075bb:	5f                   	pop    %edi
f01075bc:	5d                   	pop    %ebp
f01075bd:	c3                   	ret    

f01075be <e1000_bridge_attach>:
	return pci_scan_bus(&root_bus);
}

static int
e1000_bridge_attach(struct pci_func *pcif)
{
f01075be:	55                   	push   %ebp
f01075bf:	89 e5                	mov    %esp,%ebp
f01075c1:	53                   	push   %ebx
f01075c2:	83 ec 14             	sub    $0x14,%esp
f01075c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("I am going to be initializing e1000 hardware\n");
f01075c8:	c7 04 24 50 99 10 f0 	movl   $0xf0109950,(%esp)
f01075cf:	e8 f1 c9 ff ff       	call   f0103fc5 <cprintf>
	pci_func_enable(pcif);
f01075d4:	89 1c 24             	mov    %ebx,(%esp)
f01075d7:	e8 86 fe ff ff       	call   f0107462 <pci_func_enable>
	e1000_bar0_addr =  mmio_map_region(pcif->reg_base[0],pcif->reg_size[0]);
f01075dc:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01075df:	89 44 24 04          	mov    %eax,0x4(%esp)
f01075e3:	8b 43 14             	mov    0x14(%ebx),%eax
f01075e6:	89 04 24             	mov    %eax,(%esp)
f01075e9:	e8 25 9e ff ff       	call   f0101413 <mmio_map_region>
f01075ee:	a3 e0 8e 2b f0       	mov    %eax,0xf02b8ee0
	cprintf("Status register %08x\n",e1000_bar0_addr[E1000_STATUS]);
f01075f3:	8b 40 08             	mov    0x8(%eax),%eax
f01075f6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01075fa:	c7 04 24 d0 99 10 f0 	movl   $0xf01099d0,(%esp)
f0107601:	e8 bf c9 ff ff       	call   f0103fc5 <cprintf>
	transmit_initalize();
f0107606:	e8 bd f5 ff ff       	call   f0106bc8 <transmit_initalize>
	recieve_initalize();
f010760b:	e8 dd f7 ff ff       	call   f0106ded <recieve_initalize>
	int len =20;
	
	return 0;
}
f0107610:	b8 00 00 00 00       	mov    $0x0,%eax
f0107615:	83 c4 14             	add    $0x14,%esp
f0107618:	5b                   	pop    %ebx
f0107619:	5d                   	pop    %ebp
f010761a:	c3                   	ret    

f010761b <pci_init>:
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}

int
pci_init(void)
{
f010761b:	55                   	push   %ebp
f010761c:	89 e5                	mov    %esp,%ebp
f010761e:	83 ec 18             	sub    $0x18,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107621:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f0107628:	00 
f0107629:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107630:	00 
f0107631:	c7 04 24 80 8e 2b f0 	movl   $0xf02b8e80,(%esp)
f0107638:	e8 fa ea ff ff       	call   f0106137 <memset>

	return pci_scan_bus(&root_bus);
f010763d:	b8 80 8e 2b f0       	mov    $0xf02b8e80,%eax
f0107642:	e8 39 fb ff ff       	call   f0107180 <pci_scan_bus>
}
f0107647:	c9                   	leave  
f0107648:	c3                   	ret    

f0107649 <time_init>:

static unsigned int ticks[NCPU];

void
time_init(void)
{
f0107649:	55                   	push   %ebp
f010764a:	89 e5                	mov    %esp,%ebp
	unsigned int i;
	for(i=0;i<NCPU;i++)
f010764c:	b8 00 00 00 00       	mov    $0x0,%eax
		ticks[i]=0;
f0107651:	c7 04 85 a0 8e 2b f0 	movl   $0x0,-0xfd47160(,%eax,4)
f0107658:	00 00 00 00 

void
time_init(void)
{
	unsigned int i;
	for(i=0;i<NCPU;i++)
f010765c:	83 c0 01             	add    $0x1,%eax
f010765f:	83 f8 08             	cmp    $0x8,%eax
f0107662:	75 ed                	jne    f0107651 <time_init+0x8>
		ticks[i]=0;
}
f0107664:	5d                   	pop    %ebp
f0107665:	c3                   	ret    

f0107666 <time_tick>:

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(unsigned int c_no)
{
f0107666:	55                   	push   %ebp
f0107667:	89 e5                	mov    %esp,%ebp
f0107669:	83 ec 18             	sub    $0x18,%esp
f010766c:	8b 55 08             	mov    0x8(%ebp),%edx
	ticks[c_no] = ticks[c_no]+1;
f010766f:	8b 04 95 a0 8e 2b f0 	mov    -0xfd47160(,%edx,4),%eax
f0107676:	83 c0 01             	add    $0x1,%eax
f0107679:	89 04 95 a0 8e 2b f0 	mov    %eax,-0xfd47160(,%edx,4)
	if (ticks[c_no] * 10 < ticks[c_no])
f0107680:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0107683:	01 d2                	add    %edx,%edx
f0107685:	39 d0                	cmp    %edx,%eax
f0107687:	76 1c                	jbe    f01076a5 <time_tick+0x3f>
		panic("time_tick: time overflowed");
f0107689:	c7 44 24 08 70 9a 10 	movl   $0xf0109a70,0x8(%esp)
f0107690:	f0 
f0107691:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
f0107698:	00 
f0107699:	c7 04 24 8b 9a 10 f0 	movl   $0xf0109a8b,(%esp)
f01076a0:	e8 f8 89 ff ff       	call   f010009d <_panic>
}
f01076a5:	c9                   	leave  
f01076a6:	c3                   	ret    

f01076a7 <time_msec>:

unsigned int
time_msec(unsigned int c_no)
{
f01076a7:	55                   	push   %ebp
f01076a8:	89 e5                	mov    %esp,%ebp
	return ticks[c_no] * 10;
f01076aa:	8b 45 08             	mov    0x8(%ebp),%eax
f01076ad:	8b 04 85 a0 8e 2b f0 	mov    -0xfd47160(,%eax,4),%eax
f01076b4:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01076b7:	01 c0                	add    %eax,%eax
}
f01076b9:	5d                   	pop    %ebp
f01076ba:	c3                   	ret    
f01076bb:	66 90                	xchg   %ax,%ax
f01076bd:	66 90                	xchg   %ax,%ax
f01076bf:	90                   	nop

f01076c0 <__udivdi3>:
f01076c0:	55                   	push   %ebp
f01076c1:	57                   	push   %edi
f01076c2:	56                   	push   %esi
f01076c3:	83 ec 0c             	sub    $0xc,%esp
f01076c6:	8b 44 24 28          	mov    0x28(%esp),%eax
f01076ca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
f01076ce:	8b 6c 24 20          	mov    0x20(%esp),%ebp
f01076d2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f01076d6:	85 c0                	test   %eax,%eax
f01076d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01076dc:	89 ea                	mov    %ebp,%edx
f01076de:	89 0c 24             	mov    %ecx,(%esp)
f01076e1:	75 2d                	jne    f0107710 <__udivdi3+0x50>
f01076e3:	39 e9                	cmp    %ebp,%ecx
f01076e5:	77 61                	ja     f0107748 <__udivdi3+0x88>
f01076e7:	85 c9                	test   %ecx,%ecx
f01076e9:	89 ce                	mov    %ecx,%esi
f01076eb:	75 0b                	jne    f01076f8 <__udivdi3+0x38>
f01076ed:	b8 01 00 00 00       	mov    $0x1,%eax
f01076f2:	31 d2                	xor    %edx,%edx
f01076f4:	f7 f1                	div    %ecx
f01076f6:	89 c6                	mov    %eax,%esi
f01076f8:	31 d2                	xor    %edx,%edx
f01076fa:	89 e8                	mov    %ebp,%eax
f01076fc:	f7 f6                	div    %esi
f01076fe:	89 c5                	mov    %eax,%ebp
f0107700:	89 f8                	mov    %edi,%eax
f0107702:	f7 f6                	div    %esi
f0107704:	89 ea                	mov    %ebp,%edx
f0107706:	83 c4 0c             	add    $0xc,%esp
f0107709:	5e                   	pop    %esi
f010770a:	5f                   	pop    %edi
f010770b:	5d                   	pop    %ebp
f010770c:	c3                   	ret    
f010770d:	8d 76 00             	lea    0x0(%esi),%esi
f0107710:	39 e8                	cmp    %ebp,%eax
f0107712:	77 24                	ja     f0107738 <__udivdi3+0x78>
f0107714:	0f bd e8             	bsr    %eax,%ebp
f0107717:	83 f5 1f             	xor    $0x1f,%ebp
f010771a:	75 3c                	jne    f0107758 <__udivdi3+0x98>
f010771c:	8b 74 24 04          	mov    0x4(%esp),%esi
f0107720:	39 34 24             	cmp    %esi,(%esp)
f0107723:	0f 86 9f 00 00 00    	jbe    f01077c8 <__udivdi3+0x108>
f0107729:	39 d0                	cmp    %edx,%eax
f010772b:	0f 82 97 00 00 00    	jb     f01077c8 <__udivdi3+0x108>
f0107731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107738:	31 d2                	xor    %edx,%edx
f010773a:	31 c0                	xor    %eax,%eax
f010773c:	83 c4 0c             	add    $0xc,%esp
f010773f:	5e                   	pop    %esi
f0107740:	5f                   	pop    %edi
f0107741:	5d                   	pop    %ebp
f0107742:	c3                   	ret    
f0107743:	90                   	nop
f0107744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107748:	89 f8                	mov    %edi,%eax
f010774a:	f7 f1                	div    %ecx
f010774c:	31 d2                	xor    %edx,%edx
f010774e:	83 c4 0c             	add    $0xc,%esp
f0107751:	5e                   	pop    %esi
f0107752:	5f                   	pop    %edi
f0107753:	5d                   	pop    %ebp
f0107754:	c3                   	ret    
f0107755:	8d 76 00             	lea    0x0(%esi),%esi
f0107758:	89 e9                	mov    %ebp,%ecx
f010775a:	8b 3c 24             	mov    (%esp),%edi
f010775d:	d3 e0                	shl    %cl,%eax
f010775f:	89 c6                	mov    %eax,%esi
f0107761:	b8 20 00 00 00       	mov    $0x20,%eax
f0107766:	29 e8                	sub    %ebp,%eax
f0107768:	89 c1                	mov    %eax,%ecx
f010776a:	d3 ef                	shr    %cl,%edi
f010776c:	89 e9                	mov    %ebp,%ecx
f010776e:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0107772:	8b 3c 24             	mov    (%esp),%edi
f0107775:	09 74 24 08          	or     %esi,0x8(%esp)
f0107779:	89 d6                	mov    %edx,%esi
f010777b:	d3 e7                	shl    %cl,%edi
f010777d:	89 c1                	mov    %eax,%ecx
f010777f:	89 3c 24             	mov    %edi,(%esp)
f0107782:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0107786:	d3 ee                	shr    %cl,%esi
f0107788:	89 e9                	mov    %ebp,%ecx
f010778a:	d3 e2                	shl    %cl,%edx
f010778c:	89 c1                	mov    %eax,%ecx
f010778e:	d3 ef                	shr    %cl,%edi
f0107790:	09 d7                	or     %edx,%edi
f0107792:	89 f2                	mov    %esi,%edx
f0107794:	89 f8                	mov    %edi,%eax
f0107796:	f7 74 24 08          	divl   0x8(%esp)
f010779a:	89 d6                	mov    %edx,%esi
f010779c:	89 c7                	mov    %eax,%edi
f010779e:	f7 24 24             	mull   (%esp)
f01077a1:	39 d6                	cmp    %edx,%esi
f01077a3:	89 14 24             	mov    %edx,(%esp)
f01077a6:	72 30                	jb     f01077d8 <__udivdi3+0x118>
f01077a8:	8b 54 24 04          	mov    0x4(%esp),%edx
f01077ac:	89 e9                	mov    %ebp,%ecx
f01077ae:	d3 e2                	shl    %cl,%edx
f01077b0:	39 c2                	cmp    %eax,%edx
f01077b2:	73 05                	jae    f01077b9 <__udivdi3+0xf9>
f01077b4:	3b 34 24             	cmp    (%esp),%esi
f01077b7:	74 1f                	je     f01077d8 <__udivdi3+0x118>
f01077b9:	89 f8                	mov    %edi,%eax
f01077bb:	31 d2                	xor    %edx,%edx
f01077bd:	e9 7a ff ff ff       	jmp    f010773c <__udivdi3+0x7c>
f01077c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01077c8:	31 d2                	xor    %edx,%edx
f01077ca:	b8 01 00 00 00       	mov    $0x1,%eax
f01077cf:	e9 68 ff ff ff       	jmp    f010773c <__udivdi3+0x7c>
f01077d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01077d8:	8d 47 ff             	lea    -0x1(%edi),%eax
f01077db:	31 d2                	xor    %edx,%edx
f01077dd:	83 c4 0c             	add    $0xc,%esp
f01077e0:	5e                   	pop    %esi
f01077e1:	5f                   	pop    %edi
f01077e2:	5d                   	pop    %ebp
f01077e3:	c3                   	ret    
f01077e4:	66 90                	xchg   %ax,%ax
f01077e6:	66 90                	xchg   %ax,%ax
f01077e8:	66 90                	xchg   %ax,%ax
f01077ea:	66 90                	xchg   %ax,%ax
f01077ec:	66 90                	xchg   %ax,%ax
f01077ee:	66 90                	xchg   %ax,%ax

f01077f0 <__umoddi3>:
f01077f0:	55                   	push   %ebp
f01077f1:	57                   	push   %edi
f01077f2:	56                   	push   %esi
f01077f3:	83 ec 14             	sub    $0x14,%esp
f01077f6:	8b 44 24 28          	mov    0x28(%esp),%eax
f01077fa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f01077fe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
f0107802:	89 c7                	mov    %eax,%edi
f0107804:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107808:	8b 44 24 30          	mov    0x30(%esp),%eax
f010780c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0107810:	89 34 24             	mov    %esi,(%esp)
f0107813:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107817:	85 c0                	test   %eax,%eax
f0107819:	89 c2                	mov    %eax,%edx
f010781b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f010781f:	75 17                	jne    f0107838 <__umoddi3+0x48>
f0107821:	39 fe                	cmp    %edi,%esi
f0107823:	76 4b                	jbe    f0107870 <__umoddi3+0x80>
f0107825:	89 c8                	mov    %ecx,%eax
f0107827:	89 fa                	mov    %edi,%edx
f0107829:	f7 f6                	div    %esi
f010782b:	89 d0                	mov    %edx,%eax
f010782d:	31 d2                	xor    %edx,%edx
f010782f:	83 c4 14             	add    $0x14,%esp
f0107832:	5e                   	pop    %esi
f0107833:	5f                   	pop    %edi
f0107834:	5d                   	pop    %ebp
f0107835:	c3                   	ret    
f0107836:	66 90                	xchg   %ax,%ax
f0107838:	39 f8                	cmp    %edi,%eax
f010783a:	77 54                	ja     f0107890 <__umoddi3+0xa0>
f010783c:	0f bd e8             	bsr    %eax,%ebp
f010783f:	83 f5 1f             	xor    $0x1f,%ebp
f0107842:	75 5c                	jne    f01078a0 <__umoddi3+0xb0>
f0107844:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0107848:	39 3c 24             	cmp    %edi,(%esp)
f010784b:	0f 87 e7 00 00 00    	ja     f0107938 <__umoddi3+0x148>
f0107851:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0107855:	29 f1                	sub    %esi,%ecx
f0107857:	19 c7                	sbb    %eax,%edi
f0107859:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010785d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0107861:	8b 44 24 08          	mov    0x8(%esp),%eax
f0107865:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0107869:	83 c4 14             	add    $0x14,%esp
f010786c:	5e                   	pop    %esi
f010786d:	5f                   	pop    %edi
f010786e:	5d                   	pop    %ebp
f010786f:	c3                   	ret    
f0107870:	85 f6                	test   %esi,%esi
f0107872:	89 f5                	mov    %esi,%ebp
f0107874:	75 0b                	jne    f0107881 <__umoddi3+0x91>
f0107876:	b8 01 00 00 00       	mov    $0x1,%eax
f010787b:	31 d2                	xor    %edx,%edx
f010787d:	f7 f6                	div    %esi
f010787f:	89 c5                	mov    %eax,%ebp
f0107881:	8b 44 24 04          	mov    0x4(%esp),%eax
f0107885:	31 d2                	xor    %edx,%edx
f0107887:	f7 f5                	div    %ebp
f0107889:	89 c8                	mov    %ecx,%eax
f010788b:	f7 f5                	div    %ebp
f010788d:	eb 9c                	jmp    f010782b <__umoddi3+0x3b>
f010788f:	90                   	nop
f0107890:	89 c8                	mov    %ecx,%eax
f0107892:	89 fa                	mov    %edi,%edx
f0107894:	83 c4 14             	add    $0x14,%esp
f0107897:	5e                   	pop    %esi
f0107898:	5f                   	pop    %edi
f0107899:	5d                   	pop    %ebp
f010789a:	c3                   	ret    
f010789b:	90                   	nop
f010789c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01078a0:	8b 04 24             	mov    (%esp),%eax
f01078a3:	be 20 00 00 00       	mov    $0x20,%esi
f01078a8:	89 e9                	mov    %ebp,%ecx
f01078aa:	29 ee                	sub    %ebp,%esi
f01078ac:	d3 e2                	shl    %cl,%edx
f01078ae:	89 f1                	mov    %esi,%ecx
f01078b0:	d3 e8                	shr    %cl,%eax
f01078b2:	89 e9                	mov    %ebp,%ecx
f01078b4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01078b8:	8b 04 24             	mov    (%esp),%eax
f01078bb:	09 54 24 04          	or     %edx,0x4(%esp)
f01078bf:	89 fa                	mov    %edi,%edx
f01078c1:	d3 e0                	shl    %cl,%eax
f01078c3:	89 f1                	mov    %esi,%ecx
f01078c5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01078c9:	8b 44 24 10          	mov    0x10(%esp),%eax
f01078cd:	d3 ea                	shr    %cl,%edx
f01078cf:	89 e9                	mov    %ebp,%ecx
f01078d1:	d3 e7                	shl    %cl,%edi
f01078d3:	89 f1                	mov    %esi,%ecx
f01078d5:	d3 e8                	shr    %cl,%eax
f01078d7:	89 e9                	mov    %ebp,%ecx
f01078d9:	09 f8                	or     %edi,%eax
f01078db:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01078df:	f7 74 24 04          	divl   0x4(%esp)
f01078e3:	d3 e7                	shl    %cl,%edi
f01078e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01078e9:	89 d7                	mov    %edx,%edi
f01078eb:	f7 64 24 08          	mull   0x8(%esp)
f01078ef:	39 d7                	cmp    %edx,%edi
f01078f1:	89 c1                	mov    %eax,%ecx
f01078f3:	89 14 24             	mov    %edx,(%esp)
f01078f6:	72 2c                	jb     f0107924 <__umoddi3+0x134>
f01078f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
f01078fc:	72 22                	jb     f0107920 <__umoddi3+0x130>
f01078fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
f0107902:	29 c8                	sub    %ecx,%eax
f0107904:	19 d7                	sbb    %edx,%edi
f0107906:	89 e9                	mov    %ebp,%ecx
f0107908:	89 fa                	mov    %edi,%edx
f010790a:	d3 e8                	shr    %cl,%eax
f010790c:	89 f1                	mov    %esi,%ecx
f010790e:	d3 e2                	shl    %cl,%edx
f0107910:	89 e9                	mov    %ebp,%ecx
f0107912:	d3 ef                	shr    %cl,%edi
f0107914:	09 d0                	or     %edx,%eax
f0107916:	89 fa                	mov    %edi,%edx
f0107918:	83 c4 14             	add    $0x14,%esp
f010791b:	5e                   	pop    %esi
f010791c:	5f                   	pop    %edi
f010791d:	5d                   	pop    %ebp
f010791e:	c3                   	ret    
f010791f:	90                   	nop
f0107920:	39 d7                	cmp    %edx,%edi
f0107922:	75 da                	jne    f01078fe <__umoddi3+0x10e>
f0107924:	8b 14 24             	mov    (%esp),%edx
f0107927:	89 c1                	mov    %eax,%ecx
f0107929:	2b 4c 24 08          	sub    0x8(%esp),%ecx
f010792d:	1b 54 24 04          	sbb    0x4(%esp),%edx
f0107931:	eb cb                	jmp    f01078fe <__umoddi3+0x10e>
f0107933:	90                   	nop
f0107934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107938:	3b 44 24 0c          	cmp    0xc(%esp),%eax
f010793c:	0f 82 0f ff ff ff    	jb     f0107851 <__umoddi3+0x61>
f0107942:	e9 1a ff ff ff       	jmp    f0107861 <__umoddi3+0x71>
