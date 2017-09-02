
obj/user/dumbfork.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 2d 02 00 00       	call   80025e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
  800048:	8b 75 08             	mov    0x8(%ebp),%esi
  80004b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.

	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80004e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800055:	00 
  800056:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80005a:	89 34 24             	mov    %esi,(%esp)
  80005d:	e8 a1 0d 00 00       	call   800e03 <sys_page_alloc>
  800062:	85 c0                	test   %eax,%eax
  800064:	79 20                	jns    800086 <duppage+0x46>
		panic("sys_page_alloc: %e", r);
  800066:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80006a:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  800071:	00 
  800072:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800079:	00 
  80007a:	c7 04 24 d3 27 80 00 	movl   $0x8027d3,(%esp)
  800081:	e8 43 02 00 00       	call   8002c9 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800086:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80008d:	00 
  80008e:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  800095:	00 
  800096:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80009d:	00 
  80009e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a2:	89 34 24             	mov    %esi,(%esp)
  8000a5:	e8 ad 0d 00 00       	call   800e57 <sys_page_map>
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 20                	jns    8000ce <duppage+0x8e>
		panic("sys_page_map: %e", r);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 e3 27 80 	movl   $0x8027e3,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 d3 27 80 00 	movl   $0x8027d3,(%esp)
  8000c9:	e8 fb 01 00 00       	call   8002c9 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8000ce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8000d5:	00 
  8000d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000da:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8000e1:	e8 9e 0a 00 00       	call   800b84 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8000e6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8000ed:	00 
  8000ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f5:	e8 b0 0d 00 00       	call   800eaa <sys_page_unmap>
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	79 20                	jns    80011e <duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8000fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800102:	c7 44 24 08 f4 27 80 	movl   $0x8027f4,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 d3 27 80 00 	movl   $0x8027d3,(%esp)
  800119:	e8 ab 01 00 00       	call   8002c9 <_panic>
}
  80011e:	83 c4 20             	add    $0x20,%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    

00800125 <dumbfork>:

envid_t
dumbfork(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	83 ec 20             	sub    $0x20,%esp
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80012d:	b8 07 00 00 00       	mov    $0x7,%eax
  800132:	cd 30                	int    $0x30
  800134:	89 c6                	mov    %eax,%esi
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();


	cprintf("envid %d\n",envid);
  800136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013a:	c7 04 24 07 28 80 00 	movl   $0x802807,(%esp)
  800141:	e8 7c 02 00 00       	call   8003c2 <cprintf>

	if (envid < 0)
  800146:	85 f6                	test   %esi,%esi
  800148:	79 20                	jns    80016a <dumbfork+0x45>
		panic("sys_exofork: %e", envid);
  80014a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80014e:	c7 44 24 08 11 28 80 	movl   $0x802811,0x8(%esp)
  800155:	00 
  800156:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  80015d:	00 
  80015e:	c7 04 24 d3 27 80 00 	movl   $0x8027d3,(%esp)
  800165:	e8 5f 01 00 00       	call   8002c9 <_panic>
  80016a:	89 f3                	mov    %esi,%ebx
	if (envid == 0) {
  80016c:	85 f6                	test   %esi,%esi
  80016e:	75 1e                	jne    80018e <dumbfork+0x69>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.

		thisenv = &envs[ENVX(sys_getenvid())];
  800170:	e8 50 0c 00 00       	call   800dc5 <sys_getenvid>
  800175:	25 ff 03 00 00       	and    $0x3ff,%eax
  80017a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80017d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800182:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800187:	b8 00 00 00 00       	mov    $0x0,%eax
  80018c:	eb 71                	jmp    8001ff <dumbfork+0xda>


	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80018e:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800195:	eb 13                	jmp    8001aa <dumbfork+0x85>
		duppage(envid, addr);
  800197:	89 54 24 04          	mov    %edx,0x4(%esp)
  80019b:	89 1c 24             	mov    %ebx,(%esp)
  80019e:	e8 9d fe ff ff       	call   800040 <duppage>


	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  8001a3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  8001aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001ad:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
  8001b3:	72 e2                	jb     800197 <dumbfork+0x72>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.

	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8001b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c1:	89 34 24             	mov    %esi,(%esp)
  8001c4:	e8 77 fe ff ff       	call   800040 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8001c9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8001d0:	00 
  8001d1:	89 34 24             	mov    %esi,(%esp)
  8001d4:	e8 24 0d 00 00       	call   800efd <sys_env_set_status>
  8001d9:	85 c0                	test   %eax,%eax
  8001db:	79 20                	jns    8001fd <dumbfork+0xd8>
		panic("sys_env_set_status: %e", r);
  8001dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001e1:	c7 44 24 08 21 28 80 	movl   $0x802821,0x8(%esp)
  8001e8:	00 
  8001e9:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8001f0:	00 
  8001f1:	c7 04 24 d3 27 80 00 	movl   $0x8027d3,(%esp)
  8001f8:	e8 cc 00 00 00       	call   8002c9 <_panic>

	return envid;
  8001fd:	89 f0                	mov    %esi,%eax
}
  8001ff:	83 c4 20             	add    $0x20,%esp
  800202:	5b                   	pop    %ebx
  800203:	5e                   	pop    %esi
  800204:	5d                   	pop    %ebp
  800205:	c3                   	ret    

00800206 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	56                   	push   %esi
  80020a:	53                   	push   %ebx
  80020b:	83 ec 10             	sub    $0x10,%esp
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  80020e:	e8 12 ff ff ff       	call   800125 <dumbfork>
  800213:	89 c6                	mov    %eax,%esi

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800215:	bb 00 00 00 00       	mov    $0x0,%ebx
  80021a:	eb 28                	jmp    800244 <umain+0x3e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80021c:	b8 3f 28 80 00       	mov    $0x80283f,%eax
  800221:	eb 05                	jmp    800228 <umain+0x22>
  800223:	b8 38 28 80 00       	mov    $0x802838,%eax
  800228:	89 44 24 08          	mov    %eax,0x8(%esp)
  80022c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800230:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  800237:	e8 86 01 00 00       	call   8003c2 <cprintf>
		sys_yield();
  80023c:	e8 a3 0b 00 00       	call   800de4 <sys_yield>

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800241:	83 c3 01             	add    $0x1,%ebx
  800244:	85 f6                	test   %esi,%esi
  800246:	75 0a                	jne    800252 <umain+0x4c>
  800248:	83 fb 13             	cmp    $0x13,%ebx
  80024b:	7e cf                	jle    80021c <umain+0x16>
  80024d:	8d 76 00             	lea    0x0(%esi),%esi
  800250:	eb 05                	jmp    800257 <umain+0x51>
  800252:	83 fb 09             	cmp    $0x9,%ebx
  800255:	7e cc                	jle    800223 <umain+0x1d>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	5b                   	pop    %ebx
  80025b:	5e                   	pop    %esi
  80025c:	5d                   	pop    %ebp
  80025d:	c3                   	ret    

0080025e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	56                   	push   %esi
  800262:	53                   	push   %ebx
  800263:	83 ec 10             	sub    $0x10,%esp
  800266:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800269:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80026c:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800273:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800276:	e8 4a 0b 00 00       	call   800dc5 <sys_getenvid>
  80027b:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800280:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800283:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800288:	a3 08 40 80 00       	mov    %eax,0x804008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80028d:	85 db                	test   %ebx,%ebx
  80028f:	7e 07                	jle    800298 <libmain+0x3a>
		binaryname = argv[0];
  800291:	8b 06                	mov    (%esi),%eax
  800293:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800298:	89 74 24 04          	mov    %esi,0x4(%esp)
  80029c:	89 1c 24             	mov    %ebx,(%esp)
  80029f:	e8 62 ff ff ff       	call   800206 <umain>

	// exit gracefully
	exit();
  8002a4:	e8 07 00 00 00       	call   8002b0 <exit>
}
  8002a9:	83 c4 10             	add    $0x10,%esp
  8002ac:	5b                   	pop    %ebx
  8002ad:	5e                   	pop    %esi
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8002b6:	e8 4f 10 00 00       	call   80130a <close_all>
	sys_env_destroy(0);
  8002bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002c2:	e8 ac 0a 00 00       	call   800d73 <sys_env_destroy>
}
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	56                   	push   %esi
  8002cd:	53                   	push   %ebx
  8002ce:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8002d1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002d4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002da:	e8 e6 0a 00 00       	call   800dc5 <sys_getenvid>
  8002df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002ed:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f5:	c7 04 24 64 28 80 00 	movl   $0x802864,(%esp)
  8002fc:	e8 c1 00 00 00       	call   8003c2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800301:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800305:	8b 45 10             	mov    0x10(%ebp),%eax
  800308:	89 04 24             	mov    %eax,(%esp)
  80030b:	e8 51 00 00 00       	call   800361 <vcprintf>
	cprintf("\n");
  800310:	c7 04 24 55 28 80 00 	movl   $0x802855,(%esp)
  800317:	e8 a6 00 00 00       	call   8003c2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80031c:	cc                   	int3   
  80031d:	eb fd                	jmp    80031c <_panic+0x53>

0080031f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	53                   	push   %ebx
  800323:	83 ec 14             	sub    $0x14,%esp
  800326:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800329:	8b 13                	mov    (%ebx),%edx
  80032b:	8d 42 01             	lea    0x1(%edx),%eax
  80032e:	89 03                	mov    %eax,(%ebx)
  800330:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800333:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800337:	3d ff 00 00 00       	cmp    $0xff,%eax
  80033c:	75 19                	jne    800357 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80033e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800345:	00 
  800346:	8d 43 08             	lea    0x8(%ebx),%eax
  800349:	89 04 24             	mov    %eax,(%esp)
  80034c:	e8 e5 09 00 00       	call   800d36 <sys_cputs>
		b->idx = 0;
  800351:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800357:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80035b:	83 c4 14             	add    $0x14,%esp
  80035e:	5b                   	pop    %ebx
  80035f:	5d                   	pop    %ebp
  800360:	c3                   	ret    

00800361 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800361:	55                   	push   %ebp
  800362:	89 e5                	mov    %esp,%ebp
  800364:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80036a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800371:	00 00 00 
	b.cnt = 0;
  800374:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80037b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80037e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800381:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800385:	8b 45 08             	mov    0x8(%ebp),%eax
  800388:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800392:	89 44 24 04          	mov    %eax,0x4(%esp)
  800396:	c7 04 24 1f 03 80 00 	movl   $0x80031f,(%esp)
  80039d:	e8 ac 01 00 00       	call   80054e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003a2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ac:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003b2:	89 04 24             	mov    %eax,(%esp)
  8003b5:	e8 7c 09 00 00       	call   800d36 <sys_cputs>

	return b.cnt;
}
  8003ba:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003c8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	89 04 24             	mov    %eax,(%esp)
  8003d5:	e8 87 ff ff ff       	call   800361 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003da:	c9                   	leave  
  8003db:	c3                   	ret    
  8003dc:	66 90                	xchg   %ax,%ax
  8003de:	66 90                	xchg   %ax,%ax

008003e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	57                   	push   %edi
  8003e4:	56                   	push   %esi
  8003e5:	53                   	push   %ebx
  8003e6:	83 ec 3c             	sub    $0x3c,%esp
  8003e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ec:	89 d7                	mov    %edx,%edi
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f7:	89 c3                	mov    %eax,%ebx
  8003f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800402:	b9 00 00 00 00       	mov    $0x0,%ecx
  800407:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80040d:	39 d9                	cmp    %ebx,%ecx
  80040f:	72 05                	jb     800416 <printnum+0x36>
  800411:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800414:	77 69                	ja     80047f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800416:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800419:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80041d:	83 ee 01             	sub    $0x1,%esi
  800420:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800424:	89 44 24 08          	mov    %eax,0x8(%esp)
  800428:	8b 44 24 08          	mov    0x8(%esp),%eax
  80042c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800430:	89 c3                	mov    %eax,%ebx
  800432:	89 d6                	mov    %edx,%esi
  800434:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800437:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80043a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80043e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800445:	89 04 24             	mov    %eax,(%esp)
  800448:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80044b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80044f:	e8 dc 20 00 00       	call   802530 <__udivdi3>
  800454:	89 d9                	mov    %ebx,%ecx
  800456:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80045a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80045e:	89 04 24             	mov    %eax,(%esp)
  800461:	89 54 24 04          	mov    %edx,0x4(%esp)
  800465:	89 fa                	mov    %edi,%edx
  800467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046a:	e8 71 ff ff ff       	call   8003e0 <printnum>
  80046f:	eb 1b                	jmp    80048c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800471:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800475:	8b 45 18             	mov    0x18(%ebp),%eax
  800478:	89 04 24             	mov    %eax,(%esp)
  80047b:	ff d3                	call   *%ebx
  80047d:	eb 03                	jmp    800482 <printnum+0xa2>
  80047f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800482:	83 ee 01             	sub    $0x1,%esi
  800485:	85 f6                	test   %esi,%esi
  800487:	7f e8                	jg     800471 <printnum+0x91>
  800489:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80048c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800490:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800494:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800497:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80049a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80049e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a5:	89 04 24             	mov    %eax,(%esp)
  8004a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004af:	e8 ac 21 00 00       	call   802660 <__umoddi3>
  8004b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004b8:	0f be 80 87 28 80 00 	movsbl 0x802887(%eax),%eax
  8004bf:	89 04 24             	mov    %eax,(%esp)
  8004c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004c5:	ff d0                	call   *%eax
}
  8004c7:	83 c4 3c             	add    $0x3c,%esp
  8004ca:	5b                   	pop    %ebx
  8004cb:	5e                   	pop    %esi
  8004cc:	5f                   	pop    %edi
  8004cd:	5d                   	pop    %ebp
  8004ce:	c3                   	ret    

008004cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d2:	83 fa 01             	cmp    $0x1,%edx
  8004d5:	7e 0e                	jle    8004e5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004d7:	8b 10                	mov    (%eax),%edx
  8004d9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004dc:	89 08                	mov    %ecx,(%eax)
  8004de:	8b 02                	mov    (%edx),%eax
  8004e0:	8b 52 04             	mov    0x4(%edx),%edx
  8004e3:	eb 22                	jmp    800507 <getuint+0x38>
	else if (lflag)
  8004e5:	85 d2                	test   %edx,%edx
  8004e7:	74 10                	je     8004f9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004e9:	8b 10                	mov    (%eax),%edx
  8004eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ee:	89 08                	mov    %ecx,(%eax)
  8004f0:	8b 02                	mov    (%edx),%eax
  8004f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f7:	eb 0e                	jmp    800507 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004f9:	8b 10                	mov    (%eax),%edx
  8004fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004fe:	89 08                	mov    %ecx,(%eax)
  800500:	8b 02                	mov    (%edx),%eax
  800502:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800507:	5d                   	pop    %ebp
  800508:	c3                   	ret    

00800509 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80050f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800513:	8b 10                	mov    (%eax),%edx
  800515:	3b 50 04             	cmp    0x4(%eax),%edx
  800518:	73 0a                	jae    800524 <sprintputch+0x1b>
		*b->buf++ = ch;
  80051a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80051d:	89 08                	mov    %ecx,(%eax)
  80051f:	8b 45 08             	mov    0x8(%ebp),%eax
  800522:	88 02                	mov    %al,(%edx)
}
  800524:	5d                   	pop    %ebp
  800525:	c3                   	ret    

00800526 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80052c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80052f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800533:	8b 45 10             	mov    0x10(%ebp),%eax
  800536:	89 44 24 08          	mov    %eax,0x8(%esp)
  80053a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800541:	8b 45 08             	mov    0x8(%ebp),%eax
  800544:	89 04 24             	mov    %eax,(%esp)
  800547:	e8 02 00 00 00       	call   80054e <vprintfmt>
	va_end(ap);
}
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	57                   	push   %edi
  800552:	56                   	push   %esi
  800553:	53                   	push   %ebx
  800554:	83 ec 3c             	sub    $0x3c,%esp
  800557:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80055a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80055d:	eb 14                	jmp    800573 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80055f:	85 c0                	test   %eax,%eax
  800561:	0f 84 b3 03 00 00    	je     80091a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800567:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056b:	89 04 24             	mov    %eax,(%esp)
  80056e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800571:	89 f3                	mov    %esi,%ebx
  800573:	8d 73 01             	lea    0x1(%ebx),%esi
  800576:	0f b6 03             	movzbl (%ebx),%eax
  800579:	83 f8 25             	cmp    $0x25,%eax
  80057c:	75 e1                	jne    80055f <vprintfmt+0x11>
  80057e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800582:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800589:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800590:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800597:	ba 00 00 00 00       	mov    $0x0,%edx
  80059c:	eb 1d                	jmp    8005bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8005a0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8005a4:	eb 15                	jmp    8005bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005a8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8005ac:	eb 0d                	jmp    8005bb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8005ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005bb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8005be:	0f b6 0e             	movzbl (%esi),%ecx
  8005c1:	0f b6 c1             	movzbl %cl,%eax
  8005c4:	83 e9 23             	sub    $0x23,%ecx
  8005c7:	80 f9 55             	cmp    $0x55,%cl
  8005ca:	0f 87 2a 03 00 00    	ja     8008fa <vprintfmt+0x3ac>
  8005d0:	0f b6 c9             	movzbl %cl,%ecx
  8005d3:	ff 24 8d c0 29 80 00 	jmp    *0x8029c0(,%ecx,4)
  8005da:	89 de                	mov    %ebx,%esi
  8005dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005e1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005e4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8005e8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005eb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005ee:	83 fb 09             	cmp    $0x9,%ebx
  8005f1:	77 36                	ja     800629 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005f3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005f6:	eb e9                	jmp    8005e1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fb:	8d 48 04             	lea    0x4(%eax),%ecx
  8005fe:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800601:	8b 00                	mov    (%eax),%eax
  800603:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800606:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800608:	eb 22                	jmp    80062c <vprintfmt+0xde>
  80060a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80060d:	85 c9                	test   %ecx,%ecx
  80060f:	b8 00 00 00 00       	mov    $0x0,%eax
  800614:	0f 49 c1             	cmovns %ecx,%eax
  800617:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061a:	89 de                	mov    %ebx,%esi
  80061c:	eb 9d                	jmp    8005bb <vprintfmt+0x6d>
  80061e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800620:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800627:	eb 92                	jmp    8005bb <vprintfmt+0x6d>
  800629:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80062c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800630:	79 89                	jns    8005bb <vprintfmt+0x6d>
  800632:	e9 77 ff ff ff       	jmp    8005ae <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800637:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80063c:	e9 7a ff ff ff       	jmp    8005bb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8d 50 04             	lea    0x4(%eax),%edx
  800647:	89 55 14             	mov    %edx,0x14(%ebp)
  80064a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 04 24             	mov    %eax,(%esp)
  800653:	ff 55 08             	call   *0x8(%ebp)
			break;
  800656:	e9 18 ff ff ff       	jmp    800573 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8d 50 04             	lea    0x4(%eax),%edx
  800661:	89 55 14             	mov    %edx,0x14(%ebp)
  800664:	8b 00                	mov    (%eax),%eax
  800666:	99                   	cltd   
  800667:	31 d0                	xor    %edx,%eax
  800669:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80066b:	83 f8 0f             	cmp    $0xf,%eax
  80066e:	7f 0b                	jg     80067b <vprintfmt+0x12d>
  800670:	8b 14 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%edx
  800677:	85 d2                	test   %edx,%edx
  800679:	75 20                	jne    80069b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80067b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80067f:	c7 44 24 08 9f 28 80 	movl   $0x80289f,0x8(%esp)
  800686:	00 
  800687:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 04 24             	mov    %eax,(%esp)
  800691:	e8 90 fe ff ff       	call   800526 <printfmt>
  800696:	e9 d8 fe ff ff       	jmp    800573 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80069b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80069f:	c7 44 24 08 59 2c 80 	movl   $0x802c59,0x8(%esp)
  8006a6:	00 
  8006a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	89 04 24             	mov    %eax,(%esp)
  8006b1:	e8 70 fe ff ff       	call   800526 <printfmt>
  8006b6:	e9 b8 fe ff ff       	jmp    800573 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8006cd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8006cf:	85 f6                	test   %esi,%esi
  8006d1:	b8 98 28 80 00       	mov    $0x802898,%eax
  8006d6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8006d9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8006dd:	0f 84 97 00 00 00    	je     80077a <vprintfmt+0x22c>
  8006e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006e7:	0f 8e 9b 00 00 00    	jle    800788 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006f1:	89 34 24             	mov    %esi,(%esp)
  8006f4:	e8 cf 02 00 00       	call   8009c8 <strnlen>
  8006f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006fc:	29 c2                	sub    %eax,%edx
  8006fe:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800701:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800705:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800708:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80070b:	8b 75 08             	mov    0x8(%ebp),%esi
  80070e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800711:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800713:	eb 0f                	jmp    800724 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800715:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800719:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80071c:	89 04 24             	mov    %eax,(%esp)
  80071f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800721:	83 eb 01             	sub    $0x1,%ebx
  800724:	85 db                	test   %ebx,%ebx
  800726:	7f ed                	jg     800715 <vprintfmt+0x1c7>
  800728:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80072b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80072e:	85 d2                	test   %edx,%edx
  800730:	b8 00 00 00 00       	mov    $0x0,%eax
  800735:	0f 49 c2             	cmovns %edx,%eax
  800738:	29 c2                	sub    %eax,%edx
  80073a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80073d:	89 d7                	mov    %edx,%edi
  80073f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800742:	eb 50                	jmp    800794 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800744:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800748:	74 1e                	je     800768 <vprintfmt+0x21a>
  80074a:	0f be d2             	movsbl %dl,%edx
  80074d:	83 ea 20             	sub    $0x20,%edx
  800750:	83 fa 5e             	cmp    $0x5e,%edx
  800753:	76 13                	jbe    800768 <vprintfmt+0x21a>
					putch('?', putdat);
  800755:	8b 45 0c             	mov    0xc(%ebp),%eax
  800758:	89 44 24 04          	mov    %eax,0x4(%esp)
  80075c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800763:	ff 55 08             	call   *0x8(%ebp)
  800766:	eb 0d                	jmp    800775 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800768:	8b 55 0c             	mov    0xc(%ebp),%edx
  80076b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80076f:	89 04 24             	mov    %eax,(%esp)
  800772:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800775:	83 ef 01             	sub    $0x1,%edi
  800778:	eb 1a                	jmp    800794 <vprintfmt+0x246>
  80077a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80077d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800780:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800783:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800786:	eb 0c                	jmp    800794 <vprintfmt+0x246>
  800788:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80078b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80078e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800791:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800794:	83 c6 01             	add    $0x1,%esi
  800797:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80079b:	0f be c2             	movsbl %dl,%eax
  80079e:	85 c0                	test   %eax,%eax
  8007a0:	74 27                	je     8007c9 <vprintfmt+0x27b>
  8007a2:	85 db                	test   %ebx,%ebx
  8007a4:	78 9e                	js     800744 <vprintfmt+0x1f6>
  8007a6:	83 eb 01             	sub    $0x1,%ebx
  8007a9:	79 99                	jns    800744 <vprintfmt+0x1f6>
  8007ab:	89 f8                	mov    %edi,%eax
  8007ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007b3:	89 c3                	mov    %eax,%ebx
  8007b5:	eb 1a                	jmp    8007d1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007c2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007c4:	83 eb 01             	sub    $0x1,%ebx
  8007c7:	eb 08                	jmp    8007d1 <vprintfmt+0x283>
  8007c9:	89 fb                	mov    %edi,%ebx
  8007cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007d1:	85 db                	test   %ebx,%ebx
  8007d3:	7f e2                	jg     8007b7 <vprintfmt+0x269>
  8007d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8007d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007db:	e9 93 fd ff ff       	jmp    800573 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007e0:	83 fa 01             	cmp    $0x1,%edx
  8007e3:	7e 16                	jle    8007fb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 50 08             	lea    0x8(%eax),%edx
  8007eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ee:	8b 50 04             	mov    0x4(%eax),%edx
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007f9:	eb 32                	jmp    80082d <vprintfmt+0x2df>
	else if (lflag)
  8007fb:	85 d2                	test   %edx,%edx
  8007fd:	74 18                	je     800817 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8d 50 04             	lea    0x4(%eax),%edx
  800805:	89 55 14             	mov    %edx,0x14(%ebp)
  800808:	8b 30                	mov    (%eax),%esi
  80080a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80080d:	89 f0                	mov    %esi,%eax
  80080f:	c1 f8 1f             	sar    $0x1f,%eax
  800812:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800815:	eb 16                	jmp    80082d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8d 50 04             	lea    0x4(%eax),%edx
  80081d:	89 55 14             	mov    %edx,0x14(%ebp)
  800820:	8b 30                	mov    (%eax),%esi
  800822:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800825:	89 f0                	mov    %esi,%eax
  800827:	c1 f8 1f             	sar    $0x1f,%eax
  80082a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80082d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800830:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800833:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800838:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083c:	0f 89 80 00 00 00    	jns    8008c2 <vprintfmt+0x374>
				putch('-', putdat);
  800842:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800846:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80084d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800853:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800856:	f7 d8                	neg    %eax
  800858:	83 d2 00             	adc    $0x0,%edx
  80085b:	f7 da                	neg    %edx
			}
			base = 10;
  80085d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800862:	eb 5e                	jmp    8008c2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800864:	8d 45 14             	lea    0x14(%ebp),%eax
  800867:	e8 63 fc ff ff       	call   8004cf <getuint>
			base = 10;
  80086c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800871:	eb 4f                	jmp    8008c2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800873:	8d 45 14             	lea    0x14(%ebp),%eax
  800876:	e8 54 fc ff ff       	call   8004cf <getuint>
			base =8;
  80087b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800880:	eb 40                	jmp    8008c2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800882:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800886:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80088d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800890:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800894:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80089b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80089e:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a1:	8d 50 04             	lea    0x4(%eax),%edx
  8008a4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008a7:	8b 00                	mov    (%eax),%eax
  8008a9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8008ae:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8008b3:	eb 0d                	jmp    8008c2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008b8:	e8 12 fc ff ff       	call   8004cf <getuint>
			base = 16;
  8008bd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008c2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8008c6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8008ca:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8008cd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8008d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008d5:	89 04 24             	mov    %eax,(%esp)
  8008d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008dc:	89 fa                	mov    %edi,%edx
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	e8 fa fa ff ff       	call   8003e0 <printnum>
			break;
  8008e6:	e9 88 fc ff ff       	jmp    800573 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ef:	89 04 24             	mov    %eax,(%esp)
  8008f2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008f5:	e9 79 fc ff ff       	jmp    800573 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008fe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800905:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800908:	89 f3                	mov    %esi,%ebx
  80090a:	eb 03                	jmp    80090f <vprintfmt+0x3c1>
  80090c:	83 eb 01             	sub    $0x1,%ebx
  80090f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800913:	75 f7                	jne    80090c <vprintfmt+0x3be>
  800915:	e9 59 fc ff ff       	jmp    800573 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80091a:	83 c4 3c             	add    $0x3c,%esp
  80091d:	5b                   	pop    %ebx
  80091e:	5e                   	pop    %esi
  80091f:	5f                   	pop    %edi
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	83 ec 28             	sub    $0x28,%esp
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80092e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800931:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800935:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80093f:	85 c0                	test   %eax,%eax
  800941:	74 30                	je     800973 <vsnprintf+0x51>
  800943:	85 d2                	test   %edx,%edx
  800945:	7e 2c                	jle    800973 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80094e:	8b 45 10             	mov    0x10(%ebp),%eax
  800951:	89 44 24 08          	mov    %eax,0x8(%esp)
  800955:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095c:	c7 04 24 09 05 80 00 	movl   $0x800509,(%esp)
  800963:	e8 e6 fb ff ff       	call   80054e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800968:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80096b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80096e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800971:	eb 05                	jmp    800978 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800973:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800980:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800983:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800987:	8b 45 10             	mov    0x10(%ebp),%eax
  80098a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80098e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800991:	89 44 24 04          	mov    %eax,0x4(%esp)
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	89 04 24             	mov    %eax,(%esp)
  80099b:	e8 82 ff ff ff       	call   800922 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    
  8009a2:	66 90                	xchg   %ax,%ax
  8009a4:	66 90                	xchg   %ax,%ax
  8009a6:	66 90                	xchg   %ax,%ax
  8009a8:	66 90                	xchg   %ax,%ax
  8009aa:	66 90                	xchg   %ax,%ax
  8009ac:	66 90                	xchg   %ax,%ax
  8009ae:	66 90                	xchg   %ax,%ax

008009b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bb:	eb 03                	jmp    8009c0 <strlen+0x10>
		n++;
  8009bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009c4:	75 f7                	jne    8009bd <strlen+0xd>
		n++;
	return n;
}
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009d6:	eb 03                	jmp    8009db <strnlen+0x13>
		n++;
  8009d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009db:	39 d0                	cmp    %edx,%eax
  8009dd:	74 06                	je     8009e5 <strnlen+0x1d>
  8009df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009e3:	75 f3                	jne    8009d8 <strnlen+0x10>
		n++;
	return n;
}
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	53                   	push   %ebx
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009f1:	89 c2                	mov    %eax,%edx
  8009f3:	83 c2 01             	add    $0x1,%edx
  8009f6:	83 c1 01             	add    $0x1,%ecx
  8009f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a00:	84 db                	test   %bl,%bl
  800a02:	75 ef                	jne    8009f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a04:	5b                   	pop    %ebx
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	53                   	push   %ebx
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a11:	89 1c 24             	mov    %ebx,(%esp)
  800a14:	e8 97 ff ff ff       	call   8009b0 <strlen>
	strcpy(dst + len, src);
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a20:	01 d8                	add    %ebx,%eax
  800a22:	89 04 24             	mov    %eax,(%esp)
  800a25:	e8 bd ff ff ff       	call   8009e7 <strcpy>
	return dst;
}
  800a2a:	89 d8                	mov    %ebx,%eax
  800a2c:	83 c4 08             	add    $0x8,%esp
  800a2f:	5b                   	pop    %ebx
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	56                   	push   %esi
  800a36:	53                   	push   %ebx
  800a37:	8b 75 08             	mov    0x8(%ebp),%esi
  800a3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a3d:	89 f3                	mov    %esi,%ebx
  800a3f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a42:	89 f2                	mov    %esi,%edx
  800a44:	eb 0f                	jmp    800a55 <strncpy+0x23>
		*dst++ = *src;
  800a46:	83 c2 01             	add    $0x1,%edx
  800a49:	0f b6 01             	movzbl (%ecx),%eax
  800a4c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a4f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a52:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a55:	39 da                	cmp    %ebx,%edx
  800a57:	75 ed                	jne    800a46 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a59:	89 f0                	mov    %esi,%eax
  800a5b:	5b                   	pop    %ebx
  800a5c:	5e                   	pop    %esi
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	56                   	push   %esi
  800a63:	53                   	push   %ebx
  800a64:	8b 75 08             	mov    0x8(%ebp),%esi
  800a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a6d:	89 f0                	mov    %esi,%eax
  800a6f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a73:	85 c9                	test   %ecx,%ecx
  800a75:	75 0b                	jne    800a82 <strlcpy+0x23>
  800a77:	eb 1d                	jmp    800a96 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a79:	83 c0 01             	add    $0x1,%eax
  800a7c:	83 c2 01             	add    $0x1,%edx
  800a7f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a82:	39 d8                	cmp    %ebx,%eax
  800a84:	74 0b                	je     800a91 <strlcpy+0x32>
  800a86:	0f b6 0a             	movzbl (%edx),%ecx
  800a89:	84 c9                	test   %cl,%cl
  800a8b:	75 ec                	jne    800a79 <strlcpy+0x1a>
  800a8d:	89 c2                	mov    %eax,%edx
  800a8f:	eb 02                	jmp    800a93 <strlcpy+0x34>
  800a91:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a93:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a96:	29 f0                	sub    %esi,%eax
}
  800a98:	5b                   	pop    %ebx
  800a99:	5e                   	pop    %esi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800aa5:	eb 06                	jmp    800aad <strcmp+0x11>
		p++, q++;
  800aa7:	83 c1 01             	add    $0x1,%ecx
  800aaa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aad:	0f b6 01             	movzbl (%ecx),%eax
  800ab0:	84 c0                	test   %al,%al
  800ab2:	74 04                	je     800ab8 <strcmp+0x1c>
  800ab4:	3a 02                	cmp    (%edx),%al
  800ab6:	74 ef                	je     800aa7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ab8:	0f b6 c0             	movzbl %al,%eax
  800abb:	0f b6 12             	movzbl (%edx),%edx
  800abe:	29 d0                	sub    %edx,%eax
}
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	53                   	push   %ebx
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acc:	89 c3                	mov    %eax,%ebx
  800ace:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ad1:	eb 06                	jmp    800ad9 <strncmp+0x17>
		n--, p++, q++;
  800ad3:	83 c0 01             	add    $0x1,%eax
  800ad6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ad9:	39 d8                	cmp    %ebx,%eax
  800adb:	74 15                	je     800af2 <strncmp+0x30>
  800add:	0f b6 08             	movzbl (%eax),%ecx
  800ae0:	84 c9                	test   %cl,%cl
  800ae2:	74 04                	je     800ae8 <strncmp+0x26>
  800ae4:	3a 0a                	cmp    (%edx),%cl
  800ae6:	74 eb                	je     800ad3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ae8:	0f b6 00             	movzbl (%eax),%eax
  800aeb:	0f b6 12             	movzbl (%edx),%edx
  800aee:	29 d0                	sub    %edx,%eax
  800af0:	eb 05                	jmp    800af7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800af2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800af7:	5b                   	pop    %ebx
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b04:	eb 07                	jmp    800b0d <strchr+0x13>
		if (*s == c)
  800b06:	38 ca                	cmp    %cl,%dl
  800b08:	74 0f                	je     800b19 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b0a:	83 c0 01             	add    $0x1,%eax
  800b0d:	0f b6 10             	movzbl (%eax),%edx
  800b10:	84 d2                	test   %dl,%dl
  800b12:	75 f2                	jne    800b06 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b25:	eb 07                	jmp    800b2e <strfind+0x13>
		if (*s == c)
  800b27:	38 ca                	cmp    %cl,%dl
  800b29:	74 0a                	je     800b35 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b2b:	83 c0 01             	add    $0x1,%eax
  800b2e:	0f b6 10             	movzbl (%eax),%edx
  800b31:	84 d2                	test   %dl,%dl
  800b33:	75 f2                	jne    800b27 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	57                   	push   %edi
  800b3b:	56                   	push   %esi
  800b3c:	53                   	push   %ebx
  800b3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b43:	85 c9                	test   %ecx,%ecx
  800b45:	74 36                	je     800b7d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b47:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b4d:	75 28                	jne    800b77 <memset+0x40>
  800b4f:	f6 c1 03             	test   $0x3,%cl
  800b52:	75 23                	jne    800b77 <memset+0x40>
		c &= 0xFF;
  800b54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b58:	89 d3                	mov    %edx,%ebx
  800b5a:	c1 e3 08             	shl    $0x8,%ebx
  800b5d:	89 d6                	mov    %edx,%esi
  800b5f:	c1 e6 18             	shl    $0x18,%esi
  800b62:	89 d0                	mov    %edx,%eax
  800b64:	c1 e0 10             	shl    $0x10,%eax
  800b67:	09 f0                	or     %esi,%eax
  800b69:	09 c2                	or     %eax,%edx
  800b6b:	89 d0                	mov    %edx,%eax
  800b6d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b6f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b72:	fc                   	cld    
  800b73:	f3 ab                	rep stos %eax,%es:(%edi)
  800b75:	eb 06                	jmp    800b7d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7a:	fc                   	cld    
  800b7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b7d:	89 f8                	mov    %edi,%eax
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b92:	39 c6                	cmp    %eax,%esi
  800b94:	73 35                	jae    800bcb <memmove+0x47>
  800b96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b99:	39 d0                	cmp    %edx,%eax
  800b9b:	73 2e                	jae    800bcb <memmove+0x47>
		s += n;
		d += n;
  800b9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ba0:	89 d6                	mov    %edx,%esi
  800ba2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800baa:	75 13                	jne    800bbf <memmove+0x3b>
  800bac:	f6 c1 03             	test   $0x3,%cl
  800baf:	75 0e                	jne    800bbf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800bb1:	83 ef 04             	sub    $0x4,%edi
  800bb4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bb7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800bba:	fd                   	std    
  800bbb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bbd:	eb 09                	jmp    800bc8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bbf:	83 ef 01             	sub    $0x1,%edi
  800bc2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bc5:	fd                   	std    
  800bc6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bc8:	fc                   	cld    
  800bc9:	eb 1d                	jmp    800be8 <memmove+0x64>
  800bcb:	89 f2                	mov    %esi,%edx
  800bcd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bcf:	f6 c2 03             	test   $0x3,%dl
  800bd2:	75 0f                	jne    800be3 <memmove+0x5f>
  800bd4:	f6 c1 03             	test   $0x3,%cl
  800bd7:	75 0a                	jne    800be3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bd9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bdc:	89 c7                	mov    %eax,%edi
  800bde:	fc                   	cld    
  800bdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800be1:	eb 05                	jmp    800be8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800be3:	89 c7                	mov    %eax,%edi
  800be5:	fc                   	cld    
  800be6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800be8:	5e                   	pop    %esi
  800be9:	5f                   	pop    %edi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	89 04 24             	mov    %eax,(%esp)
  800c06:	e8 79 ff ff ff       	call   800b84 <memmove>
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	8b 55 08             	mov    0x8(%ebp),%edx
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	89 d6                	mov    %edx,%esi
  800c1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c1d:	eb 1a                	jmp    800c39 <memcmp+0x2c>
		if (*s1 != *s2)
  800c1f:	0f b6 02             	movzbl (%edx),%eax
  800c22:	0f b6 19             	movzbl (%ecx),%ebx
  800c25:	38 d8                	cmp    %bl,%al
  800c27:	74 0a                	je     800c33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c29:	0f b6 c0             	movzbl %al,%eax
  800c2c:	0f b6 db             	movzbl %bl,%ebx
  800c2f:	29 d8                	sub    %ebx,%eax
  800c31:	eb 0f                	jmp    800c42 <memcmp+0x35>
		s1++, s2++;
  800c33:	83 c2 01             	add    $0x1,%edx
  800c36:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c39:	39 f2                	cmp    %esi,%edx
  800c3b:	75 e2                	jne    800c1f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c4f:	89 c2                	mov    %eax,%edx
  800c51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c54:	eb 07                	jmp    800c5d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c56:	38 08                	cmp    %cl,(%eax)
  800c58:	74 07                	je     800c61 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c5a:	83 c0 01             	add    $0x1,%eax
  800c5d:	39 d0                	cmp    %edx,%eax
  800c5f:	72 f5                	jb     800c56 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6f:	eb 03                	jmp    800c74 <strtol+0x11>
		s++;
  800c71:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c74:	0f b6 0a             	movzbl (%edx),%ecx
  800c77:	80 f9 09             	cmp    $0x9,%cl
  800c7a:	74 f5                	je     800c71 <strtol+0xe>
  800c7c:	80 f9 20             	cmp    $0x20,%cl
  800c7f:	74 f0                	je     800c71 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c81:	80 f9 2b             	cmp    $0x2b,%cl
  800c84:	75 0a                	jne    800c90 <strtol+0x2d>
		s++;
  800c86:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c89:	bf 00 00 00 00       	mov    $0x0,%edi
  800c8e:	eb 11                	jmp    800ca1 <strtol+0x3e>
  800c90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c95:	80 f9 2d             	cmp    $0x2d,%cl
  800c98:	75 07                	jne    800ca1 <strtol+0x3e>
		s++, neg = 1;
  800c9a:	8d 52 01             	lea    0x1(%edx),%edx
  800c9d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ca6:	75 15                	jne    800cbd <strtol+0x5a>
  800ca8:	80 3a 30             	cmpb   $0x30,(%edx)
  800cab:	75 10                	jne    800cbd <strtol+0x5a>
  800cad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cb1:	75 0a                	jne    800cbd <strtol+0x5a>
		s += 2, base = 16;
  800cb3:	83 c2 02             	add    $0x2,%edx
  800cb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800cbb:	eb 10                	jmp    800ccd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	75 0c                	jne    800ccd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cc1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800cc6:	75 05                	jne    800ccd <strtol+0x6a>
		s++, base = 8;
  800cc8:	83 c2 01             	add    $0x1,%edx
  800ccb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ccd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cd5:	0f b6 0a             	movzbl (%edx),%ecx
  800cd8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800cdb:	89 f0                	mov    %esi,%eax
  800cdd:	3c 09                	cmp    $0x9,%al
  800cdf:	77 08                	ja     800ce9 <strtol+0x86>
			dig = *s - '0';
  800ce1:	0f be c9             	movsbl %cl,%ecx
  800ce4:	83 e9 30             	sub    $0x30,%ecx
  800ce7:	eb 20                	jmp    800d09 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ce9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cec:	89 f0                	mov    %esi,%eax
  800cee:	3c 19                	cmp    $0x19,%al
  800cf0:	77 08                	ja     800cfa <strtol+0x97>
			dig = *s - 'a' + 10;
  800cf2:	0f be c9             	movsbl %cl,%ecx
  800cf5:	83 e9 57             	sub    $0x57,%ecx
  800cf8:	eb 0f                	jmp    800d09 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800cfa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cfd:	89 f0                	mov    %esi,%eax
  800cff:	3c 19                	cmp    $0x19,%al
  800d01:	77 16                	ja     800d19 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800d03:	0f be c9             	movsbl %cl,%ecx
  800d06:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d09:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d0c:	7d 0f                	jge    800d1d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800d0e:	83 c2 01             	add    $0x1,%edx
  800d11:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d15:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d17:	eb bc                	jmp    800cd5 <strtol+0x72>
  800d19:	89 d8                	mov    %ebx,%eax
  800d1b:	eb 02                	jmp    800d1f <strtol+0xbc>
  800d1d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d23:	74 05                	je     800d2a <strtol+0xc7>
		*endptr = (char *) s;
  800d25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d28:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d2a:	f7 d8                	neg    %eax
  800d2c:	85 ff                	test   %edi,%edi
  800d2e:	0f 44 c3             	cmove  %ebx,%eax
}
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    

00800d36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	57                   	push   %edi
  800d3a:	56                   	push   %esi
  800d3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	89 c3                	mov    %eax,%ebx
  800d49:	89 c7                	mov    %eax,%edi
  800d4b:	89 c6                	mov    %eax,%esi
  800d4d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d64:	89 d1                	mov    %edx,%ecx
  800d66:	89 d3                	mov    %edx,%ebx
  800d68:	89 d7                	mov    %edx,%edi
  800d6a:	89 d6                	mov    %edx,%esi
  800d6c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d81:	b8 03 00 00 00       	mov    $0x3,%eax
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	89 cb                	mov    %ecx,%ebx
  800d8b:	89 cf                	mov    %ecx,%edi
  800d8d:	89 ce                	mov    %ecx,%esi
  800d8f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d91:	85 c0                	test   %eax,%eax
  800d93:	7e 28                	jle    800dbd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d99:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800da0:	00 
  800da1:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800da8:	00 
  800da9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db0:	00 
  800db1:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800db8:	e8 0c f5 ff ff       	call   8002c9 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dbd:	83 c4 2c             	add    $0x2c,%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd0:	b8 02 00 00 00       	mov    $0x2,%eax
  800dd5:	89 d1                	mov    %edx,%ecx
  800dd7:	89 d3                	mov    %edx,%ebx
  800dd9:	89 d7                	mov    %edx,%edi
  800ddb:	89 d6                	mov    %edx,%esi
  800ddd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ddf:	5b                   	pop    %ebx
  800de0:	5e                   	pop    %esi
  800de1:	5f                   	pop    %edi
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <sys_yield>:

void
sys_yield(void)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	57                   	push   %edi
  800de8:	56                   	push   %esi
  800de9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dea:	ba 00 00 00 00       	mov    $0x0,%edx
  800def:	b8 0b 00 00 00       	mov    $0xb,%eax
  800df4:	89 d1                	mov    %edx,%ecx
  800df6:	89 d3                	mov    %edx,%ebx
  800df8:	89 d7                	mov    %edx,%edi
  800dfa:	89 d6                	mov    %edx,%esi
  800dfc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
  800e09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0c:	be 00 00 00 00       	mov    $0x0,%esi
  800e11:	b8 04 00 00 00       	mov    $0x4,%eax
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1f:	89 f7                	mov    %esi,%edi
  800e21:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e23:	85 c0                	test   %eax,%eax
  800e25:	7e 28                	jle    800e4f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e2b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e32:	00 
  800e33:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800e3a:	00 
  800e3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e42:	00 
  800e43:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800e4a:	e8 7a f4 ff ff       	call   8002c9 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e4f:	83 c4 2c             	add    $0x2c,%esp
  800e52:	5b                   	pop    %ebx
  800e53:	5e                   	pop    %esi
  800e54:	5f                   	pop    %edi
  800e55:	5d                   	pop    %ebp
  800e56:	c3                   	ret    

00800e57 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e57:	55                   	push   %ebp
  800e58:	89 e5                	mov    %esp,%ebp
  800e5a:	57                   	push   %edi
  800e5b:	56                   	push   %esi
  800e5c:	53                   	push   %ebx
  800e5d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e60:	b8 05 00 00 00       	mov    $0x5,%eax
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e71:	8b 75 18             	mov    0x18(%ebp),%esi
  800e74:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e76:	85 c0                	test   %eax,%eax
  800e78:	7e 28                	jle    800ea2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e85:	00 
  800e86:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800e8d:	00 
  800e8e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e95:	00 
  800e96:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800e9d:	e8 27 f4 ff ff       	call   8002c9 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ea2:	83 c4 2c             	add    $0x2c,%esp
  800ea5:	5b                   	pop    %ebx
  800ea6:	5e                   	pop    %esi
  800ea7:	5f                   	pop    %edi
  800ea8:	5d                   	pop    %ebp
  800ea9:	c3                   	ret    

00800eaa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800eaa:	55                   	push   %ebp
  800eab:	89 e5                	mov    %esp,%ebp
  800ead:	57                   	push   %edi
  800eae:	56                   	push   %esi
  800eaf:	53                   	push   %ebx
  800eb0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ebd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec3:	89 df                	mov    %ebx,%edi
  800ec5:	89 de                	mov    %ebx,%esi
  800ec7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec9:	85 c0                	test   %eax,%eax
  800ecb:	7e 28                	jle    800ef5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ed8:	00 
  800ed9:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800ee0:	00 
  800ee1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee8:	00 
  800ee9:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800ef0:	e8 d4 f3 ff ff       	call   8002c9 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ef5:	83 c4 2c             	add    $0x2c,%esp
  800ef8:	5b                   	pop    %ebx
  800ef9:	5e                   	pop    %esi
  800efa:	5f                   	pop    %edi
  800efb:	5d                   	pop    %ebp
  800efc:	c3                   	ret    

00800efd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	57                   	push   %edi
  800f01:	56                   	push   %esi
  800f02:	53                   	push   %ebx
  800f03:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
  800f16:	89 df                	mov    %ebx,%edi
  800f18:	89 de                	mov    %ebx,%esi
  800f1a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	7e 28                	jle    800f48 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f24:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f2b:	00 
  800f2c:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800f33:	00 
  800f34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3b:	00 
  800f3c:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800f43:	e8 81 f3 ff ff       	call   8002c9 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f48:	83 c4 2c             	add    $0x2c,%esp
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5f                   	pop    %edi
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	57                   	push   %edi
  800f54:	56                   	push   %esi
  800f55:	53                   	push   %ebx
  800f56:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	89 df                	mov    %ebx,%edi
  800f6b:	89 de                	mov    %ebx,%esi
  800f6d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	7e 28                	jle    800f9b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f73:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f77:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f7e:	00 
  800f7f:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800f86:	00 
  800f87:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f8e:	00 
  800f8f:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800f96:	e8 2e f3 ff ff       	call   8002c9 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f9b:	83 c4 2c             	add    $0x2c,%esp
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
  800fa9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	89 df                	mov    %ebx,%edi
  800fbe:	89 de                	mov    %ebx,%esi
  800fc0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	7e 28                	jle    800fee <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fd1:	00 
  800fd2:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  800fd9:	00 
  800fda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe1:	00 
  800fe2:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  800fe9:	e8 db f2 ff ff       	call   8002c9 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fee:	83 c4 2c             	add    $0x2c,%esp
  800ff1:	5b                   	pop    %ebx
  800ff2:	5e                   	pop    %esi
  800ff3:	5f                   	pop    %edi
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    

00800ff6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	57                   	push   %edi
  800ffa:	56                   	push   %esi
  800ffb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffc:	be 00 00 00 00       	mov    $0x0,%esi
  801001:	b8 0c 00 00 00       	mov    $0xc,%eax
  801006:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801009:	8b 55 08             	mov    0x8(%ebp),%edx
  80100c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80100f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801012:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801014:	5b                   	pop    %ebx
  801015:	5e                   	pop    %esi
  801016:	5f                   	pop    %edi
  801017:	5d                   	pop    %ebp
  801018:	c3                   	ret    

00801019 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	57                   	push   %edi
  80101d:	56                   	push   %esi
  80101e:	53                   	push   %ebx
  80101f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801022:	b9 00 00 00 00       	mov    $0x0,%ecx
  801027:	b8 0d 00 00 00       	mov    $0xd,%eax
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	89 cb                	mov    %ecx,%ebx
  801031:	89 cf                	mov    %ecx,%edi
  801033:	89 ce                	mov    %ecx,%esi
  801035:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801037:	85 c0                	test   %eax,%eax
  801039:	7e 28                	jle    801063 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80103f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801046:	00 
  801047:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  80104e:	00 
  80104f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801056:	00 
  801057:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  80105e:	e8 66 f2 ff ff       	call   8002c9 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801063:	83 c4 2c             	add    $0x2c,%esp
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	57                   	push   %edi
  80106f:	56                   	push   %esi
  801070:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801071:	ba 00 00 00 00       	mov    $0x0,%edx
  801076:	b8 0e 00 00 00       	mov    $0xe,%eax
  80107b:	89 d1                	mov    %edx,%ecx
  80107d:	89 d3                	mov    %edx,%ebx
  80107f:	89 d7                	mov    %edx,%edi
  801081:	89 d6                	mov    %edx,%esi
  801083:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801085:	5b                   	pop    %ebx
  801086:	5e                   	pop    %esi
  801087:	5f                   	pop    %edi
  801088:	5d                   	pop    %ebp
  801089:	c3                   	ret    

0080108a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
  801090:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801093:	bb 00 00 00 00       	mov    $0x0,%ebx
  801098:	b8 0f 00 00 00       	mov    $0xf,%eax
  80109d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a3:	89 df                	mov    %ebx,%edi
  8010a5:	89 de                	mov    %ebx,%esi
  8010a7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	7e 28                	jle    8010d5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8010b8:	00 
  8010b9:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  8010c0:	00 
  8010c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c8:	00 
  8010c9:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  8010d0:	e8 f4 f1 ff ff       	call   8002c9 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  8010d5:	83 c4 2c             	add    $0x2c,%esp
  8010d8:	5b                   	pop    %ebx
  8010d9:	5e                   	pop    %esi
  8010da:	5f                   	pop    %edi
  8010db:	5d                   	pop    %ebp
  8010dc:	c3                   	ret    

008010dd <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	57                   	push   %edi
  8010e1:	56                   	push   %esi
  8010e2:	53                   	push   %ebx
  8010e3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010eb:	b8 10 00 00 00       	mov    $0x10,%eax
  8010f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f6:	89 df                	mov    %ebx,%edi
  8010f8:	89 de                	mov    %ebx,%esi
  8010fa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	7e 28                	jle    801128 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801100:	89 44 24 10          	mov    %eax,0x10(%esp)
  801104:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80110b:	00 
  80110c:	c7 44 24 08 7f 2b 80 	movl   $0x802b7f,0x8(%esp)
  801113:	00 
  801114:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80111b:	00 
  80111c:	c7 04 24 9c 2b 80 00 	movl   $0x802b9c,(%esp)
  801123:	e8 a1 f1 ff ff       	call   8002c9 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801128:	83 c4 2c             	add    $0x2c,%esp
  80112b:	5b                   	pop    %ebx
  80112c:	5e                   	pop    %esi
  80112d:	5f                   	pop    %edi
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	05 00 00 00 30       	add    $0x30000000,%eax
  80113b:	c1 e8 0c             	shr    $0xc,%eax
}
  80113e:	5d                   	pop    %ebp
  80113f:	c3                   	ret    

00801140 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80114b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801150:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80115d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801162:	89 c2                	mov    %eax,%edx
  801164:	c1 ea 16             	shr    $0x16,%edx
  801167:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80116e:	f6 c2 01             	test   $0x1,%dl
  801171:	74 11                	je     801184 <fd_alloc+0x2d>
  801173:	89 c2                	mov    %eax,%edx
  801175:	c1 ea 0c             	shr    $0xc,%edx
  801178:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80117f:	f6 c2 01             	test   $0x1,%dl
  801182:	75 09                	jne    80118d <fd_alloc+0x36>
			*fd_store = fd;
  801184:	89 01                	mov    %eax,(%ecx)
			return 0;
  801186:	b8 00 00 00 00       	mov    $0x0,%eax
  80118b:	eb 17                	jmp    8011a4 <fd_alloc+0x4d>
  80118d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801192:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801197:	75 c9                	jne    801162 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801199:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80119f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011ac:	83 f8 1f             	cmp    $0x1f,%eax
  8011af:	77 36                	ja     8011e7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011b1:	c1 e0 0c             	shl    $0xc,%eax
  8011b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011b9:	89 c2                	mov    %eax,%edx
  8011bb:	c1 ea 16             	shr    $0x16,%edx
  8011be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011c5:	f6 c2 01             	test   $0x1,%dl
  8011c8:	74 24                	je     8011ee <fd_lookup+0x48>
  8011ca:	89 c2                	mov    %eax,%edx
  8011cc:	c1 ea 0c             	shr    $0xc,%edx
  8011cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d6:	f6 c2 01             	test   $0x1,%dl
  8011d9:	74 1a                	je     8011f5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011de:	89 02                	mov    %eax,(%edx)
	return 0;
  8011e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e5:	eb 13                	jmp    8011fa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ec:	eb 0c                	jmp    8011fa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f3:	eb 05                	jmp    8011fa <fd_lookup+0x54>
  8011f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 18             	sub    $0x18,%esp
  801202:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801205:	ba 00 00 00 00       	mov    $0x0,%edx
  80120a:	eb 13                	jmp    80121f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80120c:	39 08                	cmp    %ecx,(%eax)
  80120e:	75 0c                	jne    80121c <dev_lookup+0x20>
			*dev = devtab[i];
  801210:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801213:	89 01                	mov    %eax,(%ecx)
			return 0;
  801215:	b8 00 00 00 00       	mov    $0x0,%eax
  80121a:	eb 38                	jmp    801254 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80121c:	83 c2 01             	add    $0x1,%edx
  80121f:	8b 04 95 2c 2c 80 00 	mov    0x802c2c(,%edx,4),%eax
  801226:	85 c0                	test   %eax,%eax
  801228:	75 e2                	jne    80120c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80122a:	a1 08 40 80 00       	mov    0x804008,%eax
  80122f:	8b 40 48             	mov    0x48(%eax),%eax
  801232:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80123a:	c7 04 24 ac 2b 80 00 	movl   $0x802bac,(%esp)
  801241:	e8 7c f1 ff ff       	call   8003c2 <cprintf>
	*dev = 0;
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80124f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801254:	c9                   	leave  
  801255:	c3                   	ret    

00801256 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	56                   	push   %esi
  80125a:	53                   	push   %ebx
  80125b:	83 ec 20             	sub    $0x20,%esp
  80125e:	8b 75 08             	mov    0x8(%ebp),%esi
  801261:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801264:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801267:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80126b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801271:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801274:	89 04 24             	mov    %eax,(%esp)
  801277:	e8 2a ff ff ff       	call   8011a6 <fd_lookup>
  80127c:	85 c0                	test   %eax,%eax
  80127e:	78 05                	js     801285 <fd_close+0x2f>
	    || fd != fd2)
  801280:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801283:	74 0c                	je     801291 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801285:	84 db                	test   %bl,%bl
  801287:	ba 00 00 00 00       	mov    $0x0,%edx
  80128c:	0f 44 c2             	cmove  %edx,%eax
  80128f:	eb 3f                	jmp    8012d0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801291:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801294:	89 44 24 04          	mov    %eax,0x4(%esp)
  801298:	8b 06                	mov    (%esi),%eax
  80129a:	89 04 24             	mov    %eax,(%esp)
  80129d:	e8 5a ff ff ff       	call   8011fc <dev_lookup>
  8012a2:	89 c3                	mov    %eax,%ebx
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	78 16                	js     8012be <fd_close+0x68>
		if (dev->dev_close)
  8012a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012b3:	85 c0                	test   %eax,%eax
  8012b5:	74 07                	je     8012be <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8012b7:	89 34 24             	mov    %esi,(%esp)
  8012ba:	ff d0                	call   *%eax
  8012bc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012c9:	e8 dc fb ff ff       	call   800eaa <sys_page_unmap>
	return r;
  8012ce:	89 d8                	mov    %ebx,%eax
}
  8012d0:	83 c4 20             	add    $0x20,%esp
  8012d3:	5b                   	pop    %ebx
  8012d4:	5e                   	pop    %esi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    

008012d7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e7:	89 04 24             	mov    %eax,(%esp)
  8012ea:	e8 b7 fe ff ff       	call   8011a6 <fd_lookup>
  8012ef:	89 c2                	mov    %eax,%edx
  8012f1:	85 d2                	test   %edx,%edx
  8012f3:	78 13                	js     801308 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012fc:	00 
  8012fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801300:	89 04 24             	mov    %eax,(%esp)
  801303:	e8 4e ff ff ff       	call   801256 <fd_close>
}
  801308:	c9                   	leave  
  801309:	c3                   	ret    

0080130a <close_all>:

void
close_all(void)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	53                   	push   %ebx
  80130e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801311:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801316:	89 1c 24             	mov    %ebx,(%esp)
  801319:	e8 b9 ff ff ff       	call   8012d7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80131e:	83 c3 01             	add    $0x1,%ebx
  801321:	83 fb 20             	cmp    $0x20,%ebx
  801324:	75 f0                	jne    801316 <close_all+0xc>
		close(i);
}
  801326:	83 c4 14             	add    $0x14,%esp
  801329:	5b                   	pop    %ebx
  80132a:	5d                   	pop    %ebp
  80132b:	c3                   	ret    

0080132c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	57                   	push   %edi
  801330:	56                   	push   %esi
  801331:	53                   	push   %ebx
  801332:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801335:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801338:	89 44 24 04          	mov    %eax,0x4(%esp)
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	89 04 24             	mov    %eax,(%esp)
  801342:	e8 5f fe ff ff       	call   8011a6 <fd_lookup>
  801347:	89 c2                	mov    %eax,%edx
  801349:	85 d2                	test   %edx,%edx
  80134b:	0f 88 e1 00 00 00    	js     801432 <dup+0x106>
		return r;
	close(newfdnum);
  801351:	8b 45 0c             	mov    0xc(%ebp),%eax
  801354:	89 04 24             	mov    %eax,(%esp)
  801357:	e8 7b ff ff ff       	call   8012d7 <close>

	newfd = INDEX2FD(newfdnum);
  80135c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80135f:	c1 e3 0c             	shl    $0xc,%ebx
  801362:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801368:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136b:	89 04 24             	mov    %eax,(%esp)
  80136e:	e8 cd fd ff ff       	call   801140 <fd2data>
  801373:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801375:	89 1c 24             	mov    %ebx,(%esp)
  801378:	e8 c3 fd ff ff       	call   801140 <fd2data>
  80137d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80137f:	89 f0                	mov    %esi,%eax
  801381:	c1 e8 16             	shr    $0x16,%eax
  801384:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80138b:	a8 01                	test   $0x1,%al
  80138d:	74 43                	je     8013d2 <dup+0xa6>
  80138f:	89 f0                	mov    %esi,%eax
  801391:	c1 e8 0c             	shr    $0xc,%eax
  801394:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80139b:	f6 c2 01             	test   $0x1,%dl
  80139e:	74 32                	je     8013d2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013b0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013b4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013bb:	00 
  8013bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c7:	e8 8b fa ff ff       	call   800e57 <sys_page_map>
  8013cc:	89 c6                	mov    %eax,%esi
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 3e                	js     801410 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d5:	89 c2                	mov    %eax,%edx
  8013d7:	c1 ea 0c             	shr    $0xc,%edx
  8013da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013e7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013f6:	00 
  8013f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801402:	e8 50 fa ff ff       	call   800e57 <sys_page_map>
  801407:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801409:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80140c:	85 f6                	test   %esi,%esi
  80140e:	79 22                	jns    801432 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801410:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801414:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80141b:	e8 8a fa ff ff       	call   800eaa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801420:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801424:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80142b:	e8 7a fa ff ff       	call   800eaa <sys_page_unmap>
	return r;
  801430:	89 f0                	mov    %esi,%eax
}
  801432:	83 c4 3c             	add    $0x3c,%esp
  801435:	5b                   	pop    %ebx
  801436:	5e                   	pop    %esi
  801437:	5f                   	pop    %edi
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    

0080143a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 24             	sub    $0x24,%esp
  801441:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801444:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801447:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144b:	89 1c 24             	mov    %ebx,(%esp)
  80144e:	e8 53 fd ff ff       	call   8011a6 <fd_lookup>
  801453:	89 c2                	mov    %eax,%edx
  801455:	85 d2                	test   %edx,%edx
  801457:	78 6d                	js     8014c6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801459:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801463:	8b 00                	mov    (%eax),%eax
  801465:	89 04 24             	mov    %eax,(%esp)
  801468:	e8 8f fd ff ff       	call   8011fc <dev_lookup>
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 55                	js     8014c6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801474:	8b 50 08             	mov    0x8(%eax),%edx
  801477:	83 e2 03             	and    $0x3,%edx
  80147a:	83 fa 01             	cmp    $0x1,%edx
  80147d:	75 23                	jne    8014a2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80147f:	a1 08 40 80 00       	mov    0x804008,%eax
  801484:	8b 40 48             	mov    0x48(%eax),%eax
  801487:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80148b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148f:	c7 04 24 f0 2b 80 00 	movl   $0x802bf0,(%esp)
  801496:	e8 27 ef ff ff       	call   8003c2 <cprintf>
		return -E_INVAL;
  80149b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a0:	eb 24                	jmp    8014c6 <read+0x8c>
	}
	if (!dev->dev_read)
  8014a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a5:	8b 52 08             	mov    0x8(%edx),%edx
  8014a8:	85 d2                	test   %edx,%edx
  8014aa:	74 15                	je     8014c1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014ba:	89 04 24             	mov    %eax,(%esp)
  8014bd:	ff d2                	call   *%edx
  8014bf:	eb 05                	jmp    8014c6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014c6:	83 c4 24             	add    $0x24,%esp
  8014c9:	5b                   	pop    %ebx
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	57                   	push   %edi
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
  8014d2:	83 ec 1c             	sub    $0x1c,%esp
  8014d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014e0:	eb 23                	jmp    801505 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014e2:	89 f0                	mov    %esi,%eax
  8014e4:	29 d8                	sub    %ebx,%eax
  8014e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ea:	89 d8                	mov    %ebx,%eax
  8014ec:	03 45 0c             	add    0xc(%ebp),%eax
  8014ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f3:	89 3c 24             	mov    %edi,(%esp)
  8014f6:	e8 3f ff ff ff       	call   80143a <read>
		if (m < 0)
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	78 10                	js     80150f <readn+0x43>
			return m;
		if (m == 0)
  8014ff:	85 c0                	test   %eax,%eax
  801501:	74 0a                	je     80150d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801503:	01 c3                	add    %eax,%ebx
  801505:	39 f3                	cmp    %esi,%ebx
  801507:	72 d9                	jb     8014e2 <readn+0x16>
  801509:	89 d8                	mov    %ebx,%eax
  80150b:	eb 02                	jmp    80150f <readn+0x43>
  80150d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80150f:	83 c4 1c             	add    $0x1c,%esp
  801512:	5b                   	pop    %ebx
  801513:	5e                   	pop    %esi
  801514:	5f                   	pop    %edi
  801515:	5d                   	pop    %ebp
  801516:	c3                   	ret    

00801517 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	53                   	push   %ebx
  80151b:	83 ec 24             	sub    $0x24,%esp
  80151e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801521:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801524:	89 44 24 04          	mov    %eax,0x4(%esp)
  801528:	89 1c 24             	mov    %ebx,(%esp)
  80152b:	e8 76 fc ff ff       	call   8011a6 <fd_lookup>
  801530:	89 c2                	mov    %eax,%edx
  801532:	85 d2                	test   %edx,%edx
  801534:	78 68                	js     80159e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801536:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801539:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801540:	8b 00                	mov    (%eax),%eax
  801542:	89 04 24             	mov    %eax,(%esp)
  801545:	e8 b2 fc ff ff       	call   8011fc <dev_lookup>
  80154a:	85 c0                	test   %eax,%eax
  80154c:	78 50                	js     80159e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801555:	75 23                	jne    80157a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801557:	a1 08 40 80 00       	mov    0x804008,%eax
  80155c:	8b 40 48             	mov    0x48(%eax),%eax
  80155f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801563:	89 44 24 04          	mov    %eax,0x4(%esp)
  801567:	c7 04 24 0c 2c 80 00 	movl   $0x802c0c,(%esp)
  80156e:	e8 4f ee ff ff       	call   8003c2 <cprintf>
		return -E_INVAL;
  801573:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801578:	eb 24                	jmp    80159e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80157a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157d:	8b 52 0c             	mov    0xc(%edx),%edx
  801580:	85 d2                	test   %edx,%edx
  801582:	74 15                	je     801599 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801584:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801587:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80158b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80158e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801592:	89 04 24             	mov    %eax,(%esp)
  801595:	ff d2                	call   *%edx
  801597:	eb 05                	jmp    80159e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801599:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80159e:	83 c4 24             	add    $0x24,%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5d                   	pop    %ebp
  8015a3:	c3                   	ret    

008015a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015aa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	e8 ea fb ff ff       	call   8011a6 <fd_lookup>
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 0e                	js     8015ce <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ce:	c9                   	leave  
  8015cf:	c3                   	ret    

008015d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 24             	sub    $0x24,%esp
  8015d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e1:	89 1c 24             	mov    %ebx,(%esp)
  8015e4:	e8 bd fb ff ff       	call   8011a6 <fd_lookup>
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	85 d2                	test   %edx,%edx
  8015ed:	78 61                	js     801650 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f9:	8b 00                	mov    (%eax),%eax
  8015fb:	89 04 24             	mov    %eax,(%esp)
  8015fe:	e8 f9 fb ff ff       	call   8011fc <dev_lookup>
  801603:	85 c0                	test   %eax,%eax
  801605:	78 49                	js     801650 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80160e:	75 23                	jne    801633 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801610:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801615:	8b 40 48             	mov    0x48(%eax),%eax
  801618:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80161c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801620:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  801627:	e8 96 ed ff ff       	call   8003c2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80162c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801631:	eb 1d                	jmp    801650 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801636:	8b 52 18             	mov    0x18(%edx),%edx
  801639:	85 d2                	test   %edx,%edx
  80163b:	74 0e                	je     80164b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80163d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801640:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801644:	89 04 24             	mov    %eax,(%esp)
  801647:	ff d2                	call   *%edx
  801649:	eb 05                	jmp    801650 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80164b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801650:	83 c4 24             	add    $0x24,%esp
  801653:	5b                   	pop    %ebx
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    

00801656 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	53                   	push   %ebx
  80165a:	83 ec 24             	sub    $0x24,%esp
  80165d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801660:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801663:	89 44 24 04          	mov    %eax,0x4(%esp)
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 04 24             	mov    %eax,(%esp)
  80166d:	e8 34 fb ff ff       	call   8011a6 <fd_lookup>
  801672:	89 c2                	mov    %eax,%edx
  801674:	85 d2                	test   %edx,%edx
  801676:	78 52                	js     8016ca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801678:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801682:	8b 00                	mov    (%eax),%eax
  801684:	89 04 24             	mov    %eax,(%esp)
  801687:	e8 70 fb ff ff       	call   8011fc <dev_lookup>
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 3a                	js     8016ca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801693:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801697:	74 2c                	je     8016c5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801699:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80169c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016a3:	00 00 00 
	stat->st_isdir = 0;
  8016a6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016ad:	00 00 00 
	stat->st_dev = dev;
  8016b0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016bd:	89 14 24             	mov    %edx,(%esp)
  8016c0:	ff 50 14             	call   *0x14(%eax)
  8016c3:	eb 05                	jmp    8016ca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016ca:	83 c4 24             	add    $0x24,%esp
  8016cd:	5b                   	pop    %ebx
  8016ce:	5d                   	pop    %ebp
  8016cf:	c3                   	ret    

008016d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	56                   	push   %esi
  8016d4:	53                   	push   %ebx
  8016d5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016df:	00 
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	89 04 24             	mov    %eax,(%esp)
  8016e6:	e8 28 02 00 00       	call   801913 <open>
  8016eb:	89 c3                	mov    %eax,%ebx
  8016ed:	85 db                	test   %ebx,%ebx
  8016ef:	78 1b                	js     80170c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f8:	89 1c 24             	mov    %ebx,(%esp)
  8016fb:	e8 56 ff ff ff       	call   801656 <fstat>
  801700:	89 c6                	mov    %eax,%esi
	close(fd);
  801702:	89 1c 24             	mov    %ebx,(%esp)
  801705:	e8 cd fb ff ff       	call   8012d7 <close>
	return r;
  80170a:	89 f0                	mov    %esi,%eax
}
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	5b                   	pop    %ebx
  801710:	5e                   	pop    %esi
  801711:	5d                   	pop    %ebp
  801712:	c3                   	ret    

00801713 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	56                   	push   %esi
  801717:	53                   	push   %ebx
  801718:	83 ec 10             	sub    $0x10,%esp
  80171b:	89 c6                	mov    %eax,%esi
  80171d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80171f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801726:	75 11                	jne    801739 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801728:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80172f:	e8 7a 0d 00 00       	call   8024ae <ipc_find_env>
  801734:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801739:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801740:	00 
  801741:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801748:	00 
  801749:	89 74 24 04          	mov    %esi,0x4(%esp)
  80174d:	a1 00 40 80 00       	mov    0x804000,%eax
  801752:	89 04 24             	mov    %eax,(%esp)
  801755:	e8 f6 0c 00 00       	call   802450 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80175a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801761:	00 
  801762:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801766:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80176d:	e8 74 0c 00 00       	call   8023e6 <ipc_recv>
}
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5d                   	pop    %ebp
  801778:	c3                   	ret    

00801779 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801779:	55                   	push   %ebp
  80177a:	89 e5                	mov    %esp,%ebp
  80177c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80177f:	8b 45 08             	mov    0x8(%ebp),%eax
  801782:	8b 40 0c             	mov    0xc(%eax),%eax
  801785:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80178a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801792:	ba 00 00 00 00       	mov    $0x0,%edx
  801797:	b8 02 00 00 00       	mov    $0x2,%eax
  80179c:	e8 72 ff ff ff       	call   801713 <fsipc>
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8017af:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017be:	e8 50 ff ff ff       	call   801713 <fsipc>
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	53                   	push   %ebx
  8017c9:	83 ec 14             	sub    $0x14,%esp
  8017cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017d5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017da:	ba 00 00 00 00       	mov    $0x0,%edx
  8017df:	b8 05 00 00 00       	mov    $0x5,%eax
  8017e4:	e8 2a ff ff ff       	call   801713 <fsipc>
  8017e9:	89 c2                	mov    %eax,%edx
  8017eb:	85 d2                	test   %edx,%edx
  8017ed:	78 2b                	js     80181a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ef:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017f6:	00 
  8017f7:	89 1c 24             	mov    %ebx,(%esp)
  8017fa:	e8 e8 f1 ff ff       	call   8009e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017ff:	a1 80 50 80 00       	mov    0x805080,%eax
  801804:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80180a:	a1 84 50 80 00       	mov    0x805084,%eax
  80180f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181a:	83 c4 14             	add    $0x14,%esp
  80181d:	5b                   	pop    %ebx
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 18             	sub    $0x18,%esp
  801826:	8b 45 10             	mov    0x10(%ebp),%eax
  801829:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80182e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801833:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801836:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80183b:	8b 55 08             	mov    0x8(%ebp),%edx
  80183e:	8b 52 0c             	mov    0xc(%edx),%edx
  801841:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801847:	89 44 24 08          	mov    %eax,0x8(%esp)
  80184b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801852:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  801859:	e8 26 f3 ff ff       	call   800b84 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	b8 04 00 00 00       	mov    $0x4,%eax
  801868:	e8 a6 fe ff ff       	call   801713 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	56                   	push   %esi
  801873:	53                   	push   %ebx
  801874:	83 ec 10             	sub    $0x10,%esp
  801877:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	8b 40 0c             	mov    0xc(%eax),%eax
  801880:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801885:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80188b:	ba 00 00 00 00       	mov    $0x0,%edx
  801890:	b8 03 00 00 00       	mov    $0x3,%eax
  801895:	e8 79 fe ff ff       	call   801713 <fsipc>
  80189a:	89 c3                	mov    %eax,%ebx
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 6a                	js     80190a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018a0:	39 c6                	cmp    %eax,%esi
  8018a2:	73 24                	jae    8018c8 <devfile_read+0x59>
  8018a4:	c7 44 24 0c 40 2c 80 	movl   $0x802c40,0xc(%esp)
  8018ab:	00 
  8018ac:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  8018b3:	00 
  8018b4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018bb:	00 
  8018bc:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  8018c3:	e8 01 ea ff ff       	call   8002c9 <_panic>
	assert(r <= PGSIZE);
  8018c8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018cd:	7e 24                	jle    8018f3 <devfile_read+0x84>
  8018cf:	c7 44 24 0c 67 2c 80 	movl   $0x802c67,0xc(%esp)
  8018d6:	00 
  8018d7:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  8018de:	00 
  8018df:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8018e6:	00 
  8018e7:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  8018ee:	e8 d6 e9 ff ff       	call   8002c9 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f7:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018fe:	00 
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	89 04 24             	mov    %eax,(%esp)
  801905:	e8 7a f2 ff ff       	call   800b84 <memmove>
	return r;
}
  80190a:	89 d8                	mov    %ebx,%eax
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    

00801913 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	53                   	push   %ebx
  801917:	83 ec 24             	sub    $0x24,%esp
  80191a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80191d:	89 1c 24             	mov    %ebx,(%esp)
  801920:	e8 8b f0 ff ff       	call   8009b0 <strlen>
  801925:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80192a:	7f 60                	jg     80198c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80192c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192f:	89 04 24             	mov    %eax,(%esp)
  801932:	e8 20 f8 ff ff       	call   801157 <fd_alloc>
  801937:	89 c2                	mov    %eax,%edx
  801939:	85 d2                	test   %edx,%edx
  80193b:	78 54                	js     801991 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80193d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801941:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801948:	e8 9a f0 ff ff       	call   8009e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80194d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801950:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801955:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801958:	b8 01 00 00 00       	mov    $0x1,%eax
  80195d:	e8 b1 fd ff ff       	call   801713 <fsipc>
  801962:	89 c3                	mov    %eax,%ebx
  801964:	85 c0                	test   %eax,%eax
  801966:	79 17                	jns    80197f <open+0x6c>
		fd_close(fd, 0);
  801968:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80196f:	00 
  801970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801973:	89 04 24             	mov    %eax,(%esp)
  801976:	e8 db f8 ff ff       	call   801256 <fd_close>
		return r;
  80197b:	89 d8                	mov    %ebx,%eax
  80197d:	eb 12                	jmp    801991 <open+0x7e>
	}

	return fd2num(fd);
  80197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801982:	89 04 24             	mov    %eax,(%esp)
  801985:	e8 a6 f7 ff ff       	call   801130 <fd2num>
  80198a:	eb 05                	jmp    801991 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80198c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801991:	83 c4 24             	add    $0x24,%esp
  801994:	5b                   	pop    %ebx
  801995:	5d                   	pop    %ebp
  801996:	c3                   	ret    

00801997 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80199d:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a2:	b8 08 00 00 00       	mov    $0x8,%eax
  8019a7:	e8 67 fd ff ff       	call   801713 <fsipc>
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    
  8019ae:	66 90                	xchg   %ax,%ax

008019b0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8019b6:	c7 44 24 04 73 2c 80 	movl   $0x802c73,0x4(%esp)
  8019bd:	00 
  8019be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c1:	89 04 24             	mov    %eax,(%esp)
  8019c4:	e8 1e f0 ff ff       	call   8009e7 <strcpy>
	return 0;
}
  8019c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	53                   	push   %ebx
  8019d4:	83 ec 14             	sub    $0x14,%esp
  8019d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8019da:	89 1c 24             	mov    %ebx,(%esp)
  8019dd:	e8 04 0b 00 00       	call   8024e6 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8019e2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8019e7:	83 f8 01             	cmp    $0x1,%eax
  8019ea:	75 0d                	jne    8019f9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8019ec:	8b 43 0c             	mov    0xc(%ebx),%eax
  8019ef:	89 04 24             	mov    %eax,(%esp)
  8019f2:	e8 29 03 00 00       	call   801d20 <nsipc_close>
  8019f7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8019f9:	89 d0                	mov    %edx,%eax
  8019fb:	83 c4 14             	add    $0x14,%esp
  8019fe:	5b                   	pop    %ebx
  8019ff:	5d                   	pop    %ebp
  801a00:	c3                   	ret    

00801a01 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a07:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a0e:	00 
  801a0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a12:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	8b 40 0c             	mov    0xc(%eax),%eax
  801a23:	89 04 24             	mov    %eax,(%esp)
  801a26:	e8 f0 03 00 00       	call   801e1b <nsipc_send>
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a33:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a3a:	00 
  801a3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4f:	89 04 24             	mov    %eax,(%esp)
  801a52:	e8 44 03 00 00       	call   801d9b <nsipc_recv>
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a5f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a62:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a66:	89 04 24             	mov    %eax,(%esp)
  801a69:	e8 38 f7 ff ff       	call   8011a6 <fd_lookup>
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 17                	js     801a89 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a75:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a7b:	39 08                	cmp    %ecx,(%eax)
  801a7d:	75 05                	jne    801a84 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a82:	eb 05                	jmp    801a89 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a84:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 20             	sub    $0x20,%esp
  801a93:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a98:	89 04 24             	mov    %eax,(%esp)
  801a9b:	e8 b7 f6 ff ff       	call   801157 <fd_alloc>
  801aa0:	89 c3                	mov    %eax,%ebx
  801aa2:	85 c0                	test   %eax,%eax
  801aa4:	78 21                	js     801ac7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801aa6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801aad:	00 
  801aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abc:	e8 42 f3 ff ff       	call   800e03 <sys_page_alloc>
  801ac1:	89 c3                	mov    %eax,%ebx
  801ac3:	85 c0                	test   %eax,%eax
  801ac5:	79 0c                	jns    801ad3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801ac7:	89 34 24             	mov    %esi,(%esp)
  801aca:	e8 51 02 00 00       	call   801d20 <nsipc_close>
		return r;
  801acf:	89 d8                	mov    %ebx,%eax
  801ad1:	eb 20                	jmp    801af3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ad3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ae1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801ae8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801aeb:	89 14 24             	mov    %edx,(%esp)
  801aee:	e8 3d f6 ff ff       	call   801130 <fd2num>
}
  801af3:	83 c4 20             	add    $0x20,%esp
  801af6:	5b                   	pop    %ebx
  801af7:	5e                   	pop    %esi
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    

00801afa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801afa:	55                   	push   %ebp
  801afb:	89 e5                	mov    %esp,%ebp
  801afd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	e8 51 ff ff ff       	call   801a59 <fd2sockid>
		return r;
  801b08:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	78 23                	js     801b31 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b0e:	8b 55 10             	mov    0x10(%ebp),%edx
  801b11:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b18:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b1c:	89 04 24             	mov    %eax,(%esp)
  801b1f:	e8 45 01 00 00       	call   801c69 <nsipc_accept>
		return r;
  801b24:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b26:	85 c0                	test   %eax,%eax
  801b28:	78 07                	js     801b31 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801b2a:	e8 5c ff ff ff       	call   801a8b <alloc_sockfd>
  801b2f:	89 c1                	mov    %eax,%ecx
}
  801b31:	89 c8                	mov    %ecx,%eax
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	e8 16 ff ff ff       	call   801a59 <fd2sockid>
  801b43:	89 c2                	mov    %eax,%edx
  801b45:	85 d2                	test   %edx,%edx
  801b47:	78 16                	js     801b5f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801b49:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b57:	89 14 24             	mov    %edx,(%esp)
  801b5a:	e8 60 01 00 00       	call   801cbf <nsipc_bind>
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <shutdown>:

int
shutdown(int s, int how)
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	e8 ea fe ff ff       	call   801a59 <fd2sockid>
  801b6f:	89 c2                	mov    %eax,%edx
  801b71:	85 d2                	test   %edx,%edx
  801b73:	78 0f                	js     801b84 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7c:	89 14 24             	mov    %edx,(%esp)
  801b7f:	e8 7a 01 00 00       	call   801cfe <nsipc_shutdown>
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	e8 c5 fe ff ff       	call   801a59 <fd2sockid>
  801b94:	89 c2                	mov    %eax,%edx
  801b96:	85 d2                	test   %edx,%edx
  801b98:	78 16                	js     801bb0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba8:	89 14 24             	mov    %edx,(%esp)
  801bab:	e8 8a 01 00 00       	call   801d3a <nsipc_connect>
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <listen>:

int
listen(int s, int backlog)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	e8 99 fe ff ff       	call   801a59 <fd2sockid>
  801bc0:	89 c2                	mov    %eax,%edx
  801bc2:	85 d2                	test   %edx,%edx
  801bc4:	78 0f                	js     801bd5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcd:	89 14 24             	mov    %edx,(%esp)
  801bd0:	e8 a4 01 00 00       	call   801d79 <nsipc_listen>
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801bdd:	8b 45 10             	mov    0x10(%ebp),%eax
  801be0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	89 04 24             	mov    %eax,(%esp)
  801bf1:	e8 98 02 00 00       	call   801e8e <nsipc_socket>
  801bf6:	89 c2                	mov    %eax,%edx
  801bf8:	85 d2                	test   %edx,%edx
  801bfa:	78 05                	js     801c01 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801bfc:	e8 8a fe ff ff       	call   801a8b <alloc_sockfd>
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	53                   	push   %ebx
  801c07:	83 ec 14             	sub    $0x14,%esp
  801c0a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c0c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c13:	75 11                	jne    801c26 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c15:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801c1c:	e8 8d 08 00 00       	call   8024ae <ipc_find_env>
  801c21:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c26:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c2d:	00 
  801c2e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c35:	00 
  801c36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c3a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c3f:	89 04 24             	mov    %eax,(%esp)
  801c42:	e8 09 08 00 00       	call   802450 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c4e:	00 
  801c4f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c56:	00 
  801c57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c5e:	e8 83 07 00 00       	call   8023e6 <ipc_recv>
}
  801c63:	83 c4 14             	add    $0x14,%esp
  801c66:	5b                   	pop    %ebx
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    

00801c69 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	56                   	push   %esi
  801c6d:	53                   	push   %ebx
  801c6e:	83 ec 10             	sub    $0x10,%esp
  801c71:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c7c:	8b 06                	mov    (%esi),%eax
  801c7e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c83:	b8 01 00 00 00       	mov    $0x1,%eax
  801c88:	e8 76 ff ff ff       	call   801c03 <nsipc>
  801c8d:	89 c3                	mov    %eax,%ebx
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	78 23                	js     801cb6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c93:	a1 10 60 80 00       	mov    0x806010,%eax
  801c98:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c9c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ca3:	00 
  801ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca7:	89 04 24             	mov    %eax,(%esp)
  801caa:	e8 d5 ee ff ff       	call   800b84 <memmove>
		*addrlen = ret->ret_addrlen;
  801caf:	a1 10 60 80 00       	mov    0x806010,%eax
  801cb4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801cb6:	89 d8                	mov    %ebx,%eax
  801cb8:	83 c4 10             	add    $0x10,%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5e                   	pop    %esi
  801cbd:	5d                   	pop    %ebp
  801cbe:	c3                   	ret    

00801cbf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	53                   	push   %ebx
  801cc3:	83 ec 14             	sub    $0x14,%esp
  801cc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801cd1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801ce3:	e8 9c ee ff ff       	call   800b84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ce8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801cee:	b8 02 00 00 00       	mov    $0x2,%eax
  801cf3:	e8 0b ff ff ff       	call   801c03 <nsipc>
}
  801cf8:	83 c4 14             	add    $0x14,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5d                   	pop    %ebp
  801cfd:	c3                   	ret    

00801cfe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d14:	b8 03 00 00 00       	mov    $0x3,%eax
  801d19:	e8 e5 fe ff ff       	call   801c03 <nsipc>
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <nsipc_close>:

int
nsipc_close(int s)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d2e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d33:	e8 cb fe ff ff       	call   801c03 <nsipc>
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	53                   	push   %ebx
  801d3e:	83 ec 14             	sub    $0x14,%esp
  801d41:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d44:	8b 45 08             	mov    0x8(%ebp),%eax
  801d47:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d4c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d57:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d5e:	e8 21 ee ff ff       	call   800b84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d63:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d69:	b8 05 00 00 00       	mov    $0x5,%eax
  801d6e:	e8 90 fe ff ff       	call   801c03 <nsipc>
}
  801d73:	83 c4 14             	add    $0x14,%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5d                   	pop    %ebp
  801d78:	c3                   	ret    

00801d79 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d8f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d94:	e8 6a fe ff ff       	call   801c03 <nsipc>
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	56                   	push   %esi
  801d9f:	53                   	push   %ebx
  801da0:	83 ec 10             	sub    $0x10,%esp
  801da3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801dae:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801db4:	8b 45 14             	mov    0x14(%ebp),%eax
  801db7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801dbc:	b8 07 00 00 00       	mov    $0x7,%eax
  801dc1:	e8 3d fe ff ff       	call   801c03 <nsipc>
  801dc6:	89 c3                	mov    %eax,%ebx
  801dc8:	85 c0                	test   %eax,%eax
  801dca:	78 46                	js     801e12 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801dcc:	39 f0                	cmp    %esi,%eax
  801dce:	7f 07                	jg     801dd7 <nsipc_recv+0x3c>
  801dd0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801dd5:	7e 24                	jle    801dfb <nsipc_recv+0x60>
  801dd7:	c7 44 24 0c 7f 2c 80 	movl   $0x802c7f,0xc(%esp)
  801dde:	00 
  801ddf:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  801de6:	00 
  801de7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801dee:	00 
  801def:	c7 04 24 94 2c 80 00 	movl   $0x802c94,(%esp)
  801df6:	e8 ce e4 ff ff       	call   8002c9 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dfb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dff:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e06:	00 
  801e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0a:	89 04 24             	mov    %eax,(%esp)
  801e0d:	e8 72 ed ff ff       	call   800b84 <memmove>
	}

	return r;
}
  801e12:	89 d8                	mov    %ebx,%eax
  801e14:	83 c4 10             	add    $0x10,%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5d                   	pop    %ebp
  801e1a:	c3                   	ret    

00801e1b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	53                   	push   %ebx
  801e1f:	83 ec 14             	sub    $0x14,%esp
  801e22:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e2d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e33:	7e 24                	jle    801e59 <nsipc_send+0x3e>
  801e35:	c7 44 24 0c a0 2c 80 	movl   $0x802ca0,0xc(%esp)
  801e3c:	00 
  801e3d:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  801e44:	00 
  801e45:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801e4c:	00 
  801e4d:	c7 04 24 94 2c 80 00 	movl   $0x802c94,(%esp)
  801e54:	e8 70 e4 ff ff       	call   8002c9 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e64:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e6b:	e8 14 ed ff ff       	call   800b84 <memmove>
	nsipcbuf.send.req_size = size;
  801e70:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e76:	8b 45 14             	mov    0x14(%ebp),%eax
  801e79:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e7e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e83:	e8 7b fd ff ff       	call   801c03 <nsipc>
}
  801e88:	83 c4 14             	add    $0x14,%esp
  801e8b:	5b                   	pop    %ebx
  801e8c:	5d                   	pop    %ebp
  801e8d:	c3                   	ret    

00801e8e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801eac:	b8 09 00 00 00       	mov    $0x9,%eax
  801eb1:	e8 4d fd ff ff       	call   801c03 <nsipc>
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	56                   	push   %esi
  801ebc:	53                   	push   %ebx
  801ebd:	83 ec 10             	sub    $0x10,%esp
  801ec0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	89 04 24             	mov    %eax,(%esp)
  801ec9:	e8 72 f2 ff ff       	call   801140 <fd2data>
  801ece:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ed0:	c7 44 24 04 ac 2c 80 	movl   $0x802cac,0x4(%esp)
  801ed7:	00 
  801ed8:	89 1c 24             	mov    %ebx,(%esp)
  801edb:	e8 07 eb ff ff       	call   8009e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ee0:	8b 46 04             	mov    0x4(%esi),%eax
  801ee3:	2b 06                	sub    (%esi),%eax
  801ee5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801eeb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ef2:	00 00 00 
	stat->st_dev = &devpipe;
  801ef5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801efc:	30 80 00 
	return 0;
}
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5d                   	pop    %ebp
  801f0a:	c3                   	ret    

00801f0b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	53                   	push   %ebx
  801f0f:	83 ec 14             	sub    $0x14,%esp
  801f12:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f15:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f20:	e8 85 ef ff ff       	call   800eaa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f25:	89 1c 24             	mov    %ebx,(%esp)
  801f28:	e8 13 f2 ff ff       	call   801140 <fd2data>
  801f2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f38:	e8 6d ef ff ff       	call   800eaa <sys_page_unmap>
}
  801f3d:	83 c4 14             	add    $0x14,%esp
  801f40:	5b                   	pop    %ebx
  801f41:	5d                   	pop    %ebp
  801f42:	c3                   	ret    

00801f43 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	57                   	push   %edi
  801f47:	56                   	push   %esi
  801f48:	53                   	push   %ebx
  801f49:	83 ec 2c             	sub    $0x2c,%esp
  801f4c:	89 c6                	mov    %eax,%esi
  801f4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f51:	a1 08 40 80 00       	mov    0x804008,%eax
  801f56:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f59:	89 34 24             	mov    %esi,(%esp)
  801f5c:	e8 85 05 00 00       	call   8024e6 <pageref>
  801f61:	89 c7                	mov    %eax,%edi
  801f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f66:	89 04 24             	mov    %eax,(%esp)
  801f69:	e8 78 05 00 00       	call   8024e6 <pageref>
  801f6e:	39 c7                	cmp    %eax,%edi
  801f70:	0f 94 c2             	sete   %dl
  801f73:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f76:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801f7c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f7f:	39 fb                	cmp    %edi,%ebx
  801f81:	74 21                	je     801fa4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f83:	84 d2                	test   %dl,%dl
  801f85:	74 ca                	je     801f51 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f87:	8b 51 58             	mov    0x58(%ecx),%edx
  801f8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f8e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f92:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f96:	c7 04 24 b3 2c 80 00 	movl   $0x802cb3,(%esp)
  801f9d:	e8 20 e4 ff ff       	call   8003c2 <cprintf>
  801fa2:	eb ad                	jmp    801f51 <_pipeisclosed+0xe>
	}
}
  801fa4:	83 c4 2c             	add    $0x2c,%esp
  801fa7:	5b                   	pop    %ebx
  801fa8:	5e                   	pop    %esi
  801fa9:	5f                   	pop    %edi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	57                   	push   %edi
  801fb0:	56                   	push   %esi
  801fb1:	53                   	push   %ebx
  801fb2:	83 ec 1c             	sub    $0x1c,%esp
  801fb5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fb8:	89 34 24             	mov    %esi,(%esp)
  801fbb:	e8 80 f1 ff ff       	call   801140 <fd2data>
  801fc0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fc2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fc7:	eb 45                	jmp    80200e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fc9:	89 da                	mov    %ebx,%edx
  801fcb:	89 f0                	mov    %esi,%eax
  801fcd:	e8 71 ff ff ff       	call   801f43 <_pipeisclosed>
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	75 41                	jne    802017 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801fd6:	e8 09 ee ff ff       	call   800de4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801fdb:	8b 43 04             	mov    0x4(%ebx),%eax
  801fde:	8b 0b                	mov    (%ebx),%ecx
  801fe0:	8d 51 20             	lea    0x20(%ecx),%edx
  801fe3:	39 d0                	cmp    %edx,%eax
  801fe5:	73 e2                	jae    801fc9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801fe7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801fee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ff1:	99                   	cltd   
  801ff2:	c1 ea 1b             	shr    $0x1b,%edx
  801ff5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ff8:	83 e1 1f             	and    $0x1f,%ecx
  801ffb:	29 d1                	sub    %edx,%ecx
  801ffd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802001:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802005:	83 c0 01             	add    $0x1,%eax
  802008:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80200b:	83 c7 01             	add    $0x1,%edi
  80200e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802011:	75 c8                	jne    801fdb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802013:	89 f8                	mov    %edi,%eax
  802015:	eb 05                	jmp    80201c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80201c:	83 c4 1c             	add    $0x1c,%esp
  80201f:	5b                   	pop    %ebx
  802020:	5e                   	pop    %esi
  802021:	5f                   	pop    %edi
  802022:	5d                   	pop    %ebp
  802023:	c3                   	ret    

00802024 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	57                   	push   %edi
  802028:	56                   	push   %esi
  802029:	53                   	push   %ebx
  80202a:	83 ec 1c             	sub    $0x1c,%esp
  80202d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802030:	89 3c 24             	mov    %edi,(%esp)
  802033:	e8 08 f1 ff ff       	call   801140 <fd2data>
  802038:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80203a:	be 00 00 00 00       	mov    $0x0,%esi
  80203f:	eb 3d                	jmp    80207e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802041:	85 f6                	test   %esi,%esi
  802043:	74 04                	je     802049 <devpipe_read+0x25>
				return i;
  802045:	89 f0                	mov    %esi,%eax
  802047:	eb 43                	jmp    80208c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802049:	89 da                	mov    %ebx,%edx
  80204b:	89 f8                	mov    %edi,%eax
  80204d:	e8 f1 fe ff ff       	call   801f43 <_pipeisclosed>
  802052:	85 c0                	test   %eax,%eax
  802054:	75 31                	jne    802087 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802056:	e8 89 ed ff ff       	call   800de4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80205b:	8b 03                	mov    (%ebx),%eax
  80205d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802060:	74 df                	je     802041 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802062:	99                   	cltd   
  802063:	c1 ea 1b             	shr    $0x1b,%edx
  802066:	01 d0                	add    %edx,%eax
  802068:	83 e0 1f             	and    $0x1f,%eax
  80206b:	29 d0                	sub    %edx,%eax
  80206d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802072:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802075:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802078:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80207b:	83 c6 01             	add    $0x1,%esi
  80207e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802081:	75 d8                	jne    80205b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802083:	89 f0                	mov    %esi,%eax
  802085:	eb 05                	jmp    80208c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80208c:	83 c4 1c             	add    $0x1c,%esp
  80208f:	5b                   	pop    %ebx
  802090:	5e                   	pop    %esi
  802091:	5f                   	pop    %edi
  802092:	5d                   	pop    %ebp
  802093:	c3                   	ret    

00802094 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	56                   	push   %esi
  802098:	53                   	push   %ebx
  802099:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80209c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209f:	89 04 24             	mov    %eax,(%esp)
  8020a2:	e8 b0 f0 ff ff       	call   801157 <fd_alloc>
  8020a7:	89 c2                	mov    %eax,%edx
  8020a9:	85 d2                	test   %edx,%edx
  8020ab:	0f 88 4d 01 00 00    	js     8021fe <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020b1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020b8:	00 
  8020b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c7:	e8 37 ed ff ff       	call   800e03 <sys_page_alloc>
  8020cc:	89 c2                	mov    %eax,%edx
  8020ce:	85 d2                	test   %edx,%edx
  8020d0:	0f 88 28 01 00 00    	js     8021fe <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8020d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020d9:	89 04 24             	mov    %eax,(%esp)
  8020dc:	e8 76 f0 ff ff       	call   801157 <fd_alloc>
  8020e1:	89 c3                	mov    %eax,%ebx
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	0f 88 fe 00 00 00    	js     8021e9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020eb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020f2:	00 
  8020f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802101:	e8 fd ec ff ff       	call   800e03 <sys_page_alloc>
  802106:	89 c3                	mov    %eax,%ebx
  802108:	85 c0                	test   %eax,%eax
  80210a:	0f 88 d9 00 00 00    	js     8021e9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802113:	89 04 24             	mov    %eax,(%esp)
  802116:	e8 25 f0 ff ff       	call   801140 <fd2data>
  80211b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80211d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802124:	00 
  802125:	89 44 24 04          	mov    %eax,0x4(%esp)
  802129:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802130:	e8 ce ec ff ff       	call   800e03 <sys_page_alloc>
  802135:	89 c3                	mov    %eax,%ebx
  802137:	85 c0                	test   %eax,%eax
  802139:	0f 88 97 00 00 00    	js     8021d6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80213f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802142:	89 04 24             	mov    %eax,(%esp)
  802145:	e8 f6 ef ff ff       	call   801140 <fd2data>
  80214a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802151:	00 
  802152:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802156:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80215d:	00 
  80215e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802162:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802169:	e8 e9 ec ff ff       	call   800e57 <sys_page_map>
  80216e:	89 c3                	mov    %eax,%ebx
  802170:	85 c0                	test   %eax,%eax
  802172:	78 52                	js     8021c6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802174:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802189:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80218f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802192:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802197:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80219e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a1:	89 04 24             	mov    %eax,(%esp)
  8021a4:	e8 87 ef ff ff       	call   801130 <fd2num>
  8021a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021ac:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b1:	89 04 24             	mov    %eax,(%esp)
  8021b4:	e8 77 ef ff ff       	call   801130 <fd2num>
  8021b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021bc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c4:	eb 38                	jmp    8021fe <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8021c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d1:	e8 d4 ec ff ff       	call   800eaa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8021d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e4:	e8 c1 ec ff ff       	call   800eaa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f7:	e8 ae ec ff ff       	call   800eaa <sys_page_unmap>
  8021fc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8021fe:	83 c4 30             	add    $0x30,%esp
  802201:	5b                   	pop    %ebx
  802202:	5e                   	pop    %esi
  802203:	5d                   	pop    %ebp
  802204:	c3                   	ret    

00802205 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80220b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80220e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	89 04 24             	mov    %eax,(%esp)
  802218:	e8 89 ef ff ff       	call   8011a6 <fd_lookup>
  80221d:	89 c2                	mov    %eax,%edx
  80221f:	85 d2                	test   %edx,%edx
  802221:	78 15                	js     802238 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802226:	89 04 24             	mov    %eax,(%esp)
  802229:	e8 12 ef ff ff       	call   801140 <fd2data>
	return _pipeisclosed(fd, p);
  80222e:	89 c2                	mov    %eax,%edx
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	e8 0b fd ff ff       	call   801f43 <_pipeisclosed>
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	66 90                	xchg   %ax,%ax
  80223e:	66 90                	xchg   %ax,%ax

00802240 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802243:	b8 00 00 00 00       	mov    $0x0,%eax
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    

0080224a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
  80224d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802250:	c7 44 24 04 cb 2c 80 	movl   $0x802ccb,0x4(%esp)
  802257:	00 
  802258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225b:	89 04 24             	mov    %eax,(%esp)
  80225e:	e8 84 e7 ff ff       	call   8009e7 <strcpy>
	return 0;
}
  802263:	b8 00 00 00 00       	mov    $0x0,%eax
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	57                   	push   %edi
  80226e:	56                   	push   %esi
  80226f:	53                   	push   %ebx
  802270:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802276:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80227b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802281:	eb 31                	jmp    8022b4 <devcons_write+0x4a>
		m = n - tot;
  802283:	8b 75 10             	mov    0x10(%ebp),%esi
  802286:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802288:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80228b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802290:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802293:	89 74 24 08          	mov    %esi,0x8(%esp)
  802297:	03 45 0c             	add    0xc(%ebp),%eax
  80229a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229e:	89 3c 24             	mov    %edi,(%esp)
  8022a1:	e8 de e8 ff ff       	call   800b84 <memmove>
		sys_cputs(buf, m);
  8022a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022aa:	89 3c 24             	mov    %edi,(%esp)
  8022ad:	e8 84 ea ff ff       	call   800d36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022b2:	01 f3                	add    %esi,%ebx
  8022b4:	89 d8                	mov    %ebx,%eax
  8022b6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8022b9:	72 c8                	jb     802283 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8022bb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8022c1:	5b                   	pop    %ebx
  8022c2:	5e                   	pop    %esi
  8022c3:	5f                   	pop    %edi
  8022c4:	5d                   	pop    %ebp
  8022c5:	c3                   	ret    

008022c6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8022d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022d5:	75 07                	jne    8022de <devcons_read+0x18>
  8022d7:	eb 2a                	jmp    802303 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8022d9:	e8 06 eb ff ff       	call   800de4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8022de:	66 90                	xchg   %ax,%ax
  8022e0:	e8 6f ea ff ff       	call   800d54 <sys_cgetc>
  8022e5:	85 c0                	test   %eax,%eax
  8022e7:	74 f0                	je     8022d9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8022e9:	85 c0                	test   %eax,%eax
  8022eb:	78 16                	js     802303 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8022ed:	83 f8 04             	cmp    $0x4,%eax
  8022f0:	74 0c                	je     8022fe <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8022f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f5:	88 02                	mov    %al,(%edx)
	return 1;
  8022f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fc:	eb 05                	jmp    802303 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802311:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802318:	00 
  802319:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80231c:	89 04 24             	mov    %eax,(%esp)
  80231f:	e8 12 ea ff ff       	call   800d36 <sys_cputs>
}
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <getchar>:

int
getchar(void)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80232c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802333:	00 
  802334:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802337:	89 44 24 04          	mov    %eax,0x4(%esp)
  80233b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802342:	e8 f3 f0 ff ff       	call   80143a <read>
	if (r < 0)
  802347:	85 c0                	test   %eax,%eax
  802349:	78 0f                	js     80235a <getchar+0x34>
		return r;
	if (r < 1)
  80234b:	85 c0                	test   %eax,%eax
  80234d:	7e 06                	jle    802355 <getchar+0x2f>
		return -E_EOF;
	return c;
  80234f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802353:	eb 05                	jmp    80235a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802355:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802362:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802365:	89 44 24 04          	mov    %eax,0x4(%esp)
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	89 04 24             	mov    %eax,(%esp)
  80236f:	e8 32 ee ff ff       	call   8011a6 <fd_lookup>
  802374:	85 c0                	test   %eax,%eax
  802376:	78 11                	js     802389 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802381:	39 10                	cmp    %edx,(%eax)
  802383:	0f 94 c0             	sete   %al
  802386:	0f b6 c0             	movzbl %al,%eax
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <opencons>:

int
opencons(void)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802391:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802394:	89 04 24             	mov    %eax,(%esp)
  802397:	e8 bb ed ff ff       	call   801157 <fd_alloc>
		return r;
  80239c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	78 40                	js     8023e2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023a9:	00 
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b8:	e8 46 ea ff ff       	call   800e03 <sys_page_alloc>
		return r;
  8023bd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023bf:	85 c0                	test   %eax,%eax
  8023c1:	78 1f                	js     8023e2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8023c3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023d8:	89 04 24             	mov    %eax,(%esp)
  8023db:	e8 50 ed ff ff       	call   801130 <fd2num>
  8023e0:	89 c2                	mov    %eax,%edx
}
  8023e2:	89 d0                	mov    %edx,%eax
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	56                   	push   %esi
  8023ea:	53                   	push   %ebx
  8023eb:	83 ec 10             	sub    $0x10,%esp
  8023ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8023f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8023f7:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8023f9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8023fe:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802401:	89 04 24             	mov    %eax,(%esp)
  802404:	e8 10 ec ff ff       	call   801019 <sys_ipc_recv>
  802409:	85 c0                	test   %eax,%eax
  80240b:	75 1e                	jne    80242b <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80240d:	85 db                	test   %ebx,%ebx
  80240f:	74 0a                	je     80241b <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802411:	a1 08 40 80 00       	mov    0x804008,%eax
  802416:	8b 40 74             	mov    0x74(%eax),%eax
  802419:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80241b:	85 f6                	test   %esi,%esi
  80241d:	74 22                	je     802441 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80241f:	a1 08 40 80 00       	mov    0x804008,%eax
  802424:	8b 40 78             	mov    0x78(%eax),%eax
  802427:	89 06                	mov    %eax,(%esi)
  802429:	eb 16                	jmp    802441 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80242b:	85 f6                	test   %esi,%esi
  80242d:	74 06                	je     802435 <ipc_recv+0x4f>
				*perm_store = 0;
  80242f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802435:	85 db                	test   %ebx,%ebx
  802437:	74 10                	je     802449 <ipc_recv+0x63>
				*from_env_store=0;
  802439:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80243f:	eb 08                	jmp    802449 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802441:	a1 08 40 80 00       	mov    0x804008,%eax
  802446:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802449:	83 c4 10             	add    $0x10,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5d                   	pop    %ebp
  80244f:	c3                   	ret    

00802450 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	57                   	push   %edi
  802454:	56                   	push   %esi
  802455:	53                   	push   %ebx
  802456:	83 ec 1c             	sub    $0x1c,%esp
  802459:	8b 75 0c             	mov    0xc(%ebp),%esi
  80245c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80245f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802462:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802464:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802469:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80246c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802470:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802474:	89 74 24 04          	mov    %esi,0x4(%esp)
  802478:	8b 45 08             	mov    0x8(%ebp),%eax
  80247b:	89 04 24             	mov    %eax,(%esp)
  80247e:	e8 73 eb ff ff       	call   800ff6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802483:	eb 1c                	jmp    8024a1 <ipc_send+0x51>
	{
		sys_yield();
  802485:	e8 5a e9 ff ff       	call   800de4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80248a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802492:	89 74 24 04          	mov    %esi,0x4(%esp)
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	89 04 24             	mov    %eax,(%esp)
  80249c:	e8 55 eb ff ff       	call   800ff6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8024a1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024a4:	74 df                	je     802485 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8024a6:	83 c4 1c             	add    $0x1c,%esp
  8024a9:	5b                   	pop    %ebx
  8024aa:	5e                   	pop    %esi
  8024ab:	5f                   	pop    %edi
  8024ac:	5d                   	pop    %ebp
  8024ad:	c3                   	ret    

008024ae <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024b9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8024bc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024c2:	8b 52 50             	mov    0x50(%edx),%edx
  8024c5:	39 ca                	cmp    %ecx,%edx
  8024c7:	75 0d                	jne    8024d6 <ipc_find_env+0x28>
			return envs[i].env_id;
  8024c9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8024cc:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8024d1:	8b 40 40             	mov    0x40(%eax),%eax
  8024d4:	eb 0e                	jmp    8024e4 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024d6:	83 c0 01             	add    $0x1,%eax
  8024d9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024de:	75 d9                	jne    8024b9 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024e0:	66 b8 00 00          	mov    $0x0,%ax
}
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    

008024e6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024e6:	55                   	push   %ebp
  8024e7:	89 e5                	mov    %esp,%ebp
  8024e9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024ec:	89 d0                	mov    %edx,%eax
  8024ee:	c1 e8 16             	shr    $0x16,%eax
  8024f1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024fd:	f6 c1 01             	test   $0x1,%cl
  802500:	74 1d                	je     80251f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802502:	c1 ea 0c             	shr    $0xc,%edx
  802505:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80250c:	f6 c2 01             	test   $0x1,%dl
  80250f:	74 0e                	je     80251f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802511:	c1 ea 0c             	shr    $0xc,%edx
  802514:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80251b:	ef 
  80251c:	0f b7 c0             	movzwl %ax,%eax
}
  80251f:	5d                   	pop    %ebp
  802520:	c3                   	ret    
  802521:	66 90                	xchg   %ax,%ax
  802523:	66 90                	xchg   %ax,%ax
  802525:	66 90                	xchg   %ax,%ax
  802527:	66 90                	xchg   %ax,%ax
  802529:	66 90                	xchg   %ax,%ax
  80252b:	66 90                	xchg   %ax,%ax
  80252d:	66 90                	xchg   %ax,%ax
  80252f:	90                   	nop

00802530 <__udivdi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	83 ec 0c             	sub    $0xc,%esp
  802536:	8b 44 24 28          	mov    0x28(%esp),%eax
  80253a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80253e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802542:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802546:	85 c0                	test   %eax,%eax
  802548:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80254c:	89 ea                	mov    %ebp,%edx
  80254e:	89 0c 24             	mov    %ecx,(%esp)
  802551:	75 2d                	jne    802580 <__udivdi3+0x50>
  802553:	39 e9                	cmp    %ebp,%ecx
  802555:	77 61                	ja     8025b8 <__udivdi3+0x88>
  802557:	85 c9                	test   %ecx,%ecx
  802559:	89 ce                	mov    %ecx,%esi
  80255b:	75 0b                	jne    802568 <__udivdi3+0x38>
  80255d:	b8 01 00 00 00       	mov    $0x1,%eax
  802562:	31 d2                	xor    %edx,%edx
  802564:	f7 f1                	div    %ecx
  802566:	89 c6                	mov    %eax,%esi
  802568:	31 d2                	xor    %edx,%edx
  80256a:	89 e8                	mov    %ebp,%eax
  80256c:	f7 f6                	div    %esi
  80256e:	89 c5                	mov    %eax,%ebp
  802570:	89 f8                	mov    %edi,%eax
  802572:	f7 f6                	div    %esi
  802574:	89 ea                	mov    %ebp,%edx
  802576:	83 c4 0c             	add    $0xc,%esp
  802579:	5e                   	pop    %esi
  80257a:	5f                   	pop    %edi
  80257b:	5d                   	pop    %ebp
  80257c:	c3                   	ret    
  80257d:	8d 76 00             	lea    0x0(%esi),%esi
  802580:	39 e8                	cmp    %ebp,%eax
  802582:	77 24                	ja     8025a8 <__udivdi3+0x78>
  802584:	0f bd e8             	bsr    %eax,%ebp
  802587:	83 f5 1f             	xor    $0x1f,%ebp
  80258a:	75 3c                	jne    8025c8 <__udivdi3+0x98>
  80258c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802590:	39 34 24             	cmp    %esi,(%esp)
  802593:	0f 86 9f 00 00 00    	jbe    802638 <__udivdi3+0x108>
  802599:	39 d0                	cmp    %edx,%eax
  80259b:	0f 82 97 00 00 00    	jb     802638 <__udivdi3+0x108>
  8025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	31 d2                	xor    %edx,%edx
  8025aa:	31 c0                	xor    %eax,%eax
  8025ac:	83 c4 0c             	add    $0xc,%esp
  8025af:	5e                   	pop    %esi
  8025b0:	5f                   	pop    %edi
  8025b1:	5d                   	pop    %ebp
  8025b2:	c3                   	ret    
  8025b3:	90                   	nop
  8025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	89 f8                	mov    %edi,%eax
  8025ba:	f7 f1                	div    %ecx
  8025bc:	31 d2                	xor    %edx,%edx
  8025be:	83 c4 0c             	add    $0xc,%esp
  8025c1:	5e                   	pop    %esi
  8025c2:	5f                   	pop    %edi
  8025c3:	5d                   	pop    %ebp
  8025c4:	c3                   	ret    
  8025c5:	8d 76 00             	lea    0x0(%esi),%esi
  8025c8:	89 e9                	mov    %ebp,%ecx
  8025ca:	8b 3c 24             	mov    (%esp),%edi
  8025cd:	d3 e0                	shl    %cl,%eax
  8025cf:	89 c6                	mov    %eax,%esi
  8025d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8025d6:	29 e8                	sub    %ebp,%eax
  8025d8:	89 c1                	mov    %eax,%ecx
  8025da:	d3 ef                	shr    %cl,%edi
  8025dc:	89 e9                	mov    %ebp,%ecx
  8025de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025e2:	8b 3c 24             	mov    (%esp),%edi
  8025e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025e9:	89 d6                	mov    %edx,%esi
  8025eb:	d3 e7                	shl    %cl,%edi
  8025ed:	89 c1                	mov    %eax,%ecx
  8025ef:	89 3c 24             	mov    %edi,(%esp)
  8025f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025f6:	d3 ee                	shr    %cl,%esi
  8025f8:	89 e9                	mov    %ebp,%ecx
  8025fa:	d3 e2                	shl    %cl,%edx
  8025fc:	89 c1                	mov    %eax,%ecx
  8025fe:	d3 ef                	shr    %cl,%edi
  802600:	09 d7                	or     %edx,%edi
  802602:	89 f2                	mov    %esi,%edx
  802604:	89 f8                	mov    %edi,%eax
  802606:	f7 74 24 08          	divl   0x8(%esp)
  80260a:	89 d6                	mov    %edx,%esi
  80260c:	89 c7                	mov    %eax,%edi
  80260e:	f7 24 24             	mull   (%esp)
  802611:	39 d6                	cmp    %edx,%esi
  802613:	89 14 24             	mov    %edx,(%esp)
  802616:	72 30                	jb     802648 <__udivdi3+0x118>
  802618:	8b 54 24 04          	mov    0x4(%esp),%edx
  80261c:	89 e9                	mov    %ebp,%ecx
  80261e:	d3 e2                	shl    %cl,%edx
  802620:	39 c2                	cmp    %eax,%edx
  802622:	73 05                	jae    802629 <__udivdi3+0xf9>
  802624:	3b 34 24             	cmp    (%esp),%esi
  802627:	74 1f                	je     802648 <__udivdi3+0x118>
  802629:	89 f8                	mov    %edi,%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	e9 7a ff ff ff       	jmp    8025ac <__udivdi3+0x7c>
  802632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802638:	31 d2                	xor    %edx,%edx
  80263a:	b8 01 00 00 00       	mov    $0x1,%eax
  80263f:	e9 68 ff ff ff       	jmp    8025ac <__udivdi3+0x7c>
  802644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802648:	8d 47 ff             	lea    -0x1(%edi),%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	83 c4 0c             	add    $0xc,%esp
  802650:	5e                   	pop    %esi
  802651:	5f                   	pop    %edi
  802652:	5d                   	pop    %ebp
  802653:	c3                   	ret    
  802654:	66 90                	xchg   %ax,%ax
  802656:	66 90                	xchg   %ax,%ax
  802658:	66 90                	xchg   %ax,%ax
  80265a:	66 90                	xchg   %ax,%ax
  80265c:	66 90                	xchg   %ax,%ax
  80265e:	66 90                	xchg   %ax,%ax

00802660 <__umoddi3>:
  802660:	55                   	push   %ebp
  802661:	57                   	push   %edi
  802662:	56                   	push   %esi
  802663:	83 ec 14             	sub    $0x14,%esp
  802666:	8b 44 24 28          	mov    0x28(%esp),%eax
  80266a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80266e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802672:	89 c7                	mov    %eax,%edi
  802674:	89 44 24 04          	mov    %eax,0x4(%esp)
  802678:	8b 44 24 30          	mov    0x30(%esp),%eax
  80267c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802680:	89 34 24             	mov    %esi,(%esp)
  802683:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802687:	85 c0                	test   %eax,%eax
  802689:	89 c2                	mov    %eax,%edx
  80268b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80268f:	75 17                	jne    8026a8 <__umoddi3+0x48>
  802691:	39 fe                	cmp    %edi,%esi
  802693:	76 4b                	jbe    8026e0 <__umoddi3+0x80>
  802695:	89 c8                	mov    %ecx,%eax
  802697:	89 fa                	mov    %edi,%edx
  802699:	f7 f6                	div    %esi
  80269b:	89 d0                	mov    %edx,%eax
  80269d:	31 d2                	xor    %edx,%edx
  80269f:	83 c4 14             	add    $0x14,%esp
  8026a2:	5e                   	pop    %esi
  8026a3:	5f                   	pop    %edi
  8026a4:	5d                   	pop    %ebp
  8026a5:	c3                   	ret    
  8026a6:	66 90                	xchg   %ax,%ax
  8026a8:	39 f8                	cmp    %edi,%eax
  8026aa:	77 54                	ja     802700 <__umoddi3+0xa0>
  8026ac:	0f bd e8             	bsr    %eax,%ebp
  8026af:	83 f5 1f             	xor    $0x1f,%ebp
  8026b2:	75 5c                	jne    802710 <__umoddi3+0xb0>
  8026b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8026b8:	39 3c 24             	cmp    %edi,(%esp)
  8026bb:	0f 87 e7 00 00 00    	ja     8027a8 <__umoddi3+0x148>
  8026c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026c5:	29 f1                	sub    %esi,%ecx
  8026c7:	19 c7                	sbb    %eax,%edi
  8026c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8026d9:	83 c4 14             	add    $0x14,%esp
  8026dc:	5e                   	pop    %esi
  8026dd:	5f                   	pop    %edi
  8026de:	5d                   	pop    %ebp
  8026df:	c3                   	ret    
  8026e0:	85 f6                	test   %esi,%esi
  8026e2:	89 f5                	mov    %esi,%ebp
  8026e4:	75 0b                	jne    8026f1 <__umoddi3+0x91>
  8026e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026eb:	31 d2                	xor    %edx,%edx
  8026ed:	f7 f6                	div    %esi
  8026ef:	89 c5                	mov    %eax,%ebp
  8026f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026f5:	31 d2                	xor    %edx,%edx
  8026f7:	f7 f5                	div    %ebp
  8026f9:	89 c8                	mov    %ecx,%eax
  8026fb:	f7 f5                	div    %ebp
  8026fd:	eb 9c                	jmp    80269b <__umoddi3+0x3b>
  8026ff:	90                   	nop
  802700:	89 c8                	mov    %ecx,%eax
  802702:	89 fa                	mov    %edi,%edx
  802704:	83 c4 14             	add    $0x14,%esp
  802707:	5e                   	pop    %esi
  802708:	5f                   	pop    %edi
  802709:	5d                   	pop    %ebp
  80270a:	c3                   	ret    
  80270b:	90                   	nop
  80270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802710:	8b 04 24             	mov    (%esp),%eax
  802713:	be 20 00 00 00       	mov    $0x20,%esi
  802718:	89 e9                	mov    %ebp,%ecx
  80271a:	29 ee                	sub    %ebp,%esi
  80271c:	d3 e2                	shl    %cl,%edx
  80271e:	89 f1                	mov    %esi,%ecx
  802720:	d3 e8                	shr    %cl,%eax
  802722:	89 e9                	mov    %ebp,%ecx
  802724:	89 44 24 04          	mov    %eax,0x4(%esp)
  802728:	8b 04 24             	mov    (%esp),%eax
  80272b:	09 54 24 04          	or     %edx,0x4(%esp)
  80272f:	89 fa                	mov    %edi,%edx
  802731:	d3 e0                	shl    %cl,%eax
  802733:	89 f1                	mov    %esi,%ecx
  802735:	89 44 24 08          	mov    %eax,0x8(%esp)
  802739:	8b 44 24 10          	mov    0x10(%esp),%eax
  80273d:	d3 ea                	shr    %cl,%edx
  80273f:	89 e9                	mov    %ebp,%ecx
  802741:	d3 e7                	shl    %cl,%edi
  802743:	89 f1                	mov    %esi,%ecx
  802745:	d3 e8                	shr    %cl,%eax
  802747:	89 e9                	mov    %ebp,%ecx
  802749:	09 f8                	or     %edi,%eax
  80274b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80274f:	f7 74 24 04          	divl   0x4(%esp)
  802753:	d3 e7                	shl    %cl,%edi
  802755:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802759:	89 d7                	mov    %edx,%edi
  80275b:	f7 64 24 08          	mull   0x8(%esp)
  80275f:	39 d7                	cmp    %edx,%edi
  802761:	89 c1                	mov    %eax,%ecx
  802763:	89 14 24             	mov    %edx,(%esp)
  802766:	72 2c                	jb     802794 <__umoddi3+0x134>
  802768:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80276c:	72 22                	jb     802790 <__umoddi3+0x130>
  80276e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802772:	29 c8                	sub    %ecx,%eax
  802774:	19 d7                	sbb    %edx,%edi
  802776:	89 e9                	mov    %ebp,%ecx
  802778:	89 fa                	mov    %edi,%edx
  80277a:	d3 e8                	shr    %cl,%eax
  80277c:	89 f1                	mov    %esi,%ecx
  80277e:	d3 e2                	shl    %cl,%edx
  802780:	89 e9                	mov    %ebp,%ecx
  802782:	d3 ef                	shr    %cl,%edi
  802784:	09 d0                	or     %edx,%eax
  802786:	89 fa                	mov    %edi,%edx
  802788:	83 c4 14             	add    $0x14,%esp
  80278b:	5e                   	pop    %esi
  80278c:	5f                   	pop    %edi
  80278d:	5d                   	pop    %ebp
  80278e:	c3                   	ret    
  80278f:	90                   	nop
  802790:	39 d7                	cmp    %edx,%edi
  802792:	75 da                	jne    80276e <__umoddi3+0x10e>
  802794:	8b 14 24             	mov    (%esp),%edx
  802797:	89 c1                	mov    %eax,%ecx
  802799:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80279d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8027a1:	eb cb                	jmp    80276e <__umoddi3+0x10e>
  8027a3:	90                   	nop
  8027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8027ac:	0f 82 0f ff ff ff    	jb     8026c1 <__umoddi3+0x61>
  8027b2:	e9 1a ff ff ff       	jmp    8026d1 <__umoddi3+0x71>
