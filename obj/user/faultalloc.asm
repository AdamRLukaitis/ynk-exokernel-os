
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800043:	c7 04 24 00 27 80 00 	movl   $0x802700,(%esp)
  80004a:	e8 09 02 00 00       	call   800258 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 35 0c 00 00       	call   800ca3 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 20 27 80 	movl   $0x802720,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 0a 27 80 00 	movl   $0x80270a,(%esp)
  800091:	e8 c9 00 00 00       	call   80015f <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 4c 27 80 	movl   $0x80274c,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 68 07 00 00       	call   80081a <snprintf>
}
  8000b2:	83 c4 24             	add    $0x24,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  8000be:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000c5:	e8 06 0f 00 00       	call   800fd0 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000ca:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  8000d1:	de 
  8000d2:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  8000d9:	e8 7a 01 00 00       	call   800258 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000de:	c7 44 24 04 fe bf fe 	movl   $0xcafebffe,0x4(%esp)
  8000e5:	ca 
  8000e6:	c7 04 24 1c 27 80 00 	movl   $0x80271c,(%esp)
  8000ed:	e8 66 01 00 00       	call   800258 <cprintf>
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 10             	sub    $0x10,%esp
  8000fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800102:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800109:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  80010c:	e8 54 0b 00 00       	call   800c65 <sys_getenvid>
  800111:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800116:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800119:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011e:	a3 08 40 80 00       	mov    %eax,0x804008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800123:	85 db                	test   %ebx,%ebx
  800125:	7e 07                	jle    80012e <libmain+0x3a>
		binaryname = argv[0];
  800127:	8b 06                	mov    (%esi),%eax
  800129:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80012e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800132:	89 1c 24             	mov    %ebx,(%esp)
  800135:	e8 7e ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  80013a:	e8 07 00 00 00       	call   800146 <exit>
}
  80013f:	83 c4 10             	add    $0x10,%esp
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5d                   	pop    %ebp
  800145:	c3                   	ret    

00800146 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80014c:	e8 f9 10 00 00       	call   80124a <close_all>
	sys_env_destroy(0);
  800151:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800158:	e8 b6 0a 00 00       	call   800c13 <sys_env_destroy>
}
  80015d:	c9                   	leave  
  80015e:	c3                   	ret    

0080015f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80015f:	55                   	push   %ebp
  800160:	89 e5                	mov    %esp,%ebp
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
  800164:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800167:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80016a:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800170:	e8 f0 0a 00 00       	call   800c65 <sys_getenvid>
  800175:	8b 55 0c             	mov    0xc(%ebp),%edx
  800178:	89 54 24 10          	mov    %edx,0x10(%esp)
  80017c:	8b 55 08             	mov    0x8(%ebp),%edx
  80017f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800183:	89 74 24 08          	mov    %esi,0x8(%esp)
  800187:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018b:	c7 04 24 78 27 80 00 	movl   $0x802778,(%esp)
  800192:	e8 c1 00 00 00       	call   800258 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800197:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80019b:	8b 45 10             	mov    0x10(%ebp),%eax
  80019e:	89 04 24             	mov    %eax,(%esp)
  8001a1:	e8 51 00 00 00       	call   8001f7 <vcprintf>
	cprintf("\n");
  8001a6:	c7 04 24 4c 2c 80 00 	movl   $0x802c4c,(%esp)
  8001ad:	e8 a6 00 00 00       	call   800258 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b2:	cc                   	int3   
  8001b3:	eb fd                	jmp    8001b2 <_panic+0x53>

008001b5 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	53                   	push   %ebx
  8001b9:	83 ec 14             	sub    $0x14,%esp
  8001bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001bf:	8b 13                	mov    (%ebx),%edx
  8001c1:	8d 42 01             	lea    0x1(%edx),%eax
  8001c4:	89 03                	mov    %eax,(%ebx)
  8001c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001c9:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001cd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d2:	75 19                	jne    8001ed <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001d4:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001db:	00 
  8001dc:	8d 43 08             	lea    0x8(%ebx),%eax
  8001df:	89 04 24             	mov    %eax,(%esp)
  8001e2:	e8 ef 09 00 00       	call   800bd6 <sys_cputs>
		b->idx = 0;
  8001e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001ed:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001f1:	83 c4 14             	add    $0x14,%esp
  8001f4:	5b                   	pop    %ebx
  8001f5:	5d                   	pop    %ebp
  8001f6:	c3                   	ret    

008001f7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800200:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800207:	00 00 00 
	b.cnt = 0;
  80020a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800211:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800214:	8b 45 0c             	mov    0xc(%ebp),%eax
  800217:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021b:	8b 45 08             	mov    0x8(%ebp),%eax
  80021e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800222:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800228:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022c:	c7 04 24 b5 01 80 00 	movl   $0x8001b5,(%esp)
  800233:	e8 b6 01 00 00       	call   8003ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800238:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80023e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800242:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800248:	89 04 24             	mov    %eax,(%esp)
  80024b:	e8 86 09 00 00       	call   800bd6 <sys_cputs>

	return b.cnt;
}
  800250:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800256:	c9                   	leave  
  800257:	c3                   	ret    

00800258 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80025e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800261:	89 44 24 04          	mov    %eax,0x4(%esp)
  800265:	8b 45 08             	mov    0x8(%ebp),%eax
  800268:	89 04 24             	mov    %eax,(%esp)
  80026b:	e8 87 ff ff ff       	call   8001f7 <vcprintf>
	va_end(ap);

	return cnt;
}
  800270:	c9                   	leave  
  800271:	c3                   	ret    
  800272:	66 90                	xchg   %ax,%ax
  800274:	66 90                	xchg   %ax,%ax
  800276:	66 90                	xchg   %ax,%ax
  800278:	66 90                	xchg   %ax,%ax
  80027a:	66 90                	xchg   %ax,%ax
  80027c:	66 90                	xchg   %ax,%ax
  80027e:	66 90                	xchg   %ax,%ax

00800280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	57                   	push   %edi
  800284:	56                   	push   %esi
  800285:	53                   	push   %ebx
  800286:	83 ec 3c             	sub    $0x3c,%esp
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028c:	89 d7                	mov    %edx,%edi
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800294:	8b 45 0c             	mov    0xc(%ebp),%eax
  800297:	89 c3                	mov    %eax,%ebx
  800299:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80029c:	8b 45 10             	mov    0x10(%ebp),%eax
  80029f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002ad:	39 d9                	cmp    %ebx,%ecx
  8002af:	72 05                	jb     8002b6 <printnum+0x36>
  8002b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002b4:	77 69                	ja     80031f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002bd:	83 ee 01             	sub    $0x1,%esi
  8002c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002d0:	89 c3                	mov    %eax,%ebx
  8002d2:	89 d6                	mov    %edx,%esi
  8002d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	e8 7c 21 00 00       	call   802470 <__udivdi3>
  8002f4:	89 d9                	mov    %ebx,%ecx
  8002f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002fe:	89 04 24             	mov    %eax,(%esp)
  800301:	89 54 24 04          	mov    %edx,0x4(%esp)
  800305:	89 fa                	mov    %edi,%edx
  800307:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80030a:	e8 71 ff ff ff       	call   800280 <printnum>
  80030f:	eb 1b                	jmp    80032c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800311:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800315:	8b 45 18             	mov    0x18(%ebp),%eax
  800318:	89 04 24             	mov    %eax,(%esp)
  80031b:	ff d3                	call   *%ebx
  80031d:	eb 03                	jmp    800322 <printnum+0xa2>
  80031f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800322:	83 ee 01             	sub    $0x1,%esi
  800325:	85 f6                	test   %esi,%esi
  800327:	7f e8                	jg     800311 <printnum+0x91>
  800329:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80032c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800330:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800334:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800337:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80033a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034f:	e8 4c 22 00 00       	call   8025a0 <__umoddi3>
  800354:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800358:	0f be 80 9b 27 80 00 	movsbl 0x80279b(%eax),%eax
  80035f:	89 04 24             	mov    %eax,(%esp)
  800362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800365:	ff d0                	call   *%eax
}
  800367:	83 c4 3c             	add    $0x3c,%esp
  80036a:	5b                   	pop    %ebx
  80036b:	5e                   	pop    %esi
  80036c:	5f                   	pop    %edi
  80036d:	5d                   	pop    %ebp
  80036e:	c3                   	ret    

0080036f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800372:	83 fa 01             	cmp    $0x1,%edx
  800375:	7e 0e                	jle    800385 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800377:	8b 10                	mov    (%eax),%edx
  800379:	8d 4a 08             	lea    0x8(%edx),%ecx
  80037c:	89 08                	mov    %ecx,(%eax)
  80037e:	8b 02                	mov    (%edx),%eax
  800380:	8b 52 04             	mov    0x4(%edx),%edx
  800383:	eb 22                	jmp    8003a7 <getuint+0x38>
	else if (lflag)
  800385:	85 d2                	test   %edx,%edx
  800387:	74 10                	je     800399 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038e:	89 08                	mov    %ecx,(%eax)
  800390:	8b 02                	mov    (%edx),%eax
  800392:	ba 00 00 00 00       	mov    $0x0,%edx
  800397:	eb 0e                	jmp    8003a7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800399:	8b 10                	mov    (%eax),%edx
  80039b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80039e:	89 08                	mov    %ecx,(%eax)
  8003a0:	8b 02                	mov    (%edx),%eax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003a7:	5d                   	pop    %ebp
  8003a8:	c3                   	ret    

008003a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003af:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003b3:	8b 10                	mov    (%eax),%edx
  8003b5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003b8:	73 0a                	jae    8003c4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003bd:	89 08                	mov    %ecx,(%eax)
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	88 02                	mov    %al,(%edx)
}
  8003c4:	5d                   	pop    %ebp
  8003c5:	c3                   	ret    

008003c6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
  8003c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	89 04 24             	mov    %eax,(%esp)
  8003e7:	e8 02 00 00 00       	call   8003ee <vprintfmt>
	va_end(ap);
}
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	57                   	push   %edi
  8003f2:	56                   	push   %esi
  8003f3:	53                   	push   %ebx
  8003f4:	83 ec 3c             	sub    $0x3c,%esp
  8003f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003fd:	eb 14                	jmp    800413 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ff:	85 c0                	test   %eax,%eax
  800401:	0f 84 b3 03 00 00    	je     8007ba <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800407:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80040b:	89 04 24             	mov    %eax,(%esp)
  80040e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800411:	89 f3                	mov    %esi,%ebx
  800413:	8d 73 01             	lea    0x1(%ebx),%esi
  800416:	0f b6 03             	movzbl (%ebx),%eax
  800419:	83 f8 25             	cmp    $0x25,%eax
  80041c:	75 e1                	jne    8003ff <vprintfmt+0x11>
  80041e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800422:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800429:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800430:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800437:	ba 00 00 00 00       	mov    $0x0,%edx
  80043c:	eb 1d                	jmp    80045b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800440:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800444:	eb 15                	jmp    80045b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800446:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800448:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80044c:	eb 0d                	jmp    80045b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80044e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800451:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800454:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80045e:	0f b6 0e             	movzbl (%esi),%ecx
  800461:	0f b6 c1             	movzbl %cl,%eax
  800464:	83 e9 23             	sub    $0x23,%ecx
  800467:	80 f9 55             	cmp    $0x55,%cl
  80046a:	0f 87 2a 03 00 00    	ja     80079a <vprintfmt+0x3ac>
  800470:	0f b6 c9             	movzbl %cl,%ecx
  800473:	ff 24 8d e0 28 80 00 	jmp    *0x8028e0(,%ecx,4)
  80047a:	89 de                	mov    %ebx,%esi
  80047c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800481:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800484:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800488:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80048b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80048e:	83 fb 09             	cmp    $0x9,%ebx
  800491:	77 36                	ja     8004c9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800493:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800496:	eb e9                	jmp    800481 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800498:	8b 45 14             	mov    0x14(%ebp),%eax
  80049b:	8d 48 04             	lea    0x4(%eax),%ecx
  80049e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004a8:	eb 22                	jmp    8004cc <vprintfmt+0xde>
  8004aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ad:	85 c9                	test   %ecx,%ecx
  8004af:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b4:	0f 49 c1             	cmovns %ecx,%eax
  8004b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	89 de                	mov    %ebx,%esi
  8004bc:	eb 9d                	jmp    80045b <vprintfmt+0x6d>
  8004be:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004c0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004c7:	eb 92                	jmp    80045b <vprintfmt+0x6d>
  8004c9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004d0:	79 89                	jns    80045b <vprintfmt+0x6d>
  8004d2:	e9 77 ff ff ff       	jmp    80044e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004d7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004dc:	e9 7a ff ff ff       	jmp    80045b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e4:	8d 50 04             	lea    0x4(%eax),%edx
  8004e7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	89 04 24             	mov    %eax,(%esp)
  8004f3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004f6:	e9 18 ff ff ff       	jmp    800413 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fe:	8d 50 04             	lea    0x4(%eax),%edx
  800501:	89 55 14             	mov    %edx,0x14(%ebp)
  800504:	8b 00                	mov    (%eax),%eax
  800506:	99                   	cltd   
  800507:	31 d0                	xor    %edx,%eax
  800509:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80050b:	83 f8 0f             	cmp    $0xf,%eax
  80050e:	7f 0b                	jg     80051b <vprintfmt+0x12d>
  800510:	8b 14 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edx
  800517:	85 d2                	test   %edx,%edx
  800519:	75 20                	jne    80053b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80051b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80051f:	c7 44 24 08 b3 27 80 	movl   $0x8027b3,0x8(%esp)
  800526:	00 
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	e8 90 fe ff ff       	call   8003c6 <printfmt>
  800536:	e9 d8 fe ff ff       	jmp    800413 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80053b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80053f:	c7 44 24 08 e1 2b 80 	movl   $0x802be1,0x8(%esp)
  800546:	00 
  800547:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054b:	8b 45 08             	mov    0x8(%ebp),%eax
  80054e:	89 04 24             	mov    %eax,(%esp)
  800551:	e8 70 fe ff ff       	call   8003c6 <printfmt>
  800556:	e9 b8 fe ff ff       	jmp    800413 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80055e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800561:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8d 50 04             	lea    0x4(%eax),%edx
  80056a:	89 55 14             	mov    %edx,0x14(%ebp)
  80056d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80056f:	85 f6                	test   %esi,%esi
  800571:	b8 ac 27 80 00       	mov    $0x8027ac,%eax
  800576:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800579:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80057d:	0f 84 97 00 00 00    	je     80061a <vprintfmt+0x22c>
  800583:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800587:	0f 8e 9b 00 00 00    	jle    800628 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80058d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800591:	89 34 24             	mov    %esi,(%esp)
  800594:	e8 cf 02 00 00       	call   800868 <strnlen>
  800599:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80059c:	29 c2                	sub    %eax,%edx
  80059e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005a1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005b1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b3:	eb 0f                	jmp    8005c4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005bc:	89 04 24             	mov    %eax,(%esp)
  8005bf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c1:	83 eb 01             	sub    $0x1,%ebx
  8005c4:	85 db                	test   %ebx,%ebx
  8005c6:	7f ed                	jg     8005b5 <vprintfmt+0x1c7>
  8005c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ce:	85 d2                	test   %edx,%edx
  8005d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d5:	0f 49 c2             	cmovns %edx,%eax
  8005d8:	29 c2                	sub    %eax,%edx
  8005da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005dd:	89 d7                	mov    %edx,%edi
  8005df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005e2:	eb 50                	jmp    800634 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005e8:	74 1e                	je     800608 <vprintfmt+0x21a>
  8005ea:	0f be d2             	movsbl %dl,%edx
  8005ed:	83 ea 20             	sub    $0x20,%edx
  8005f0:	83 fa 5e             	cmp    $0x5e,%edx
  8005f3:	76 13                	jbe    800608 <vprintfmt+0x21a>
					putch('?', putdat);
  8005f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800603:	ff 55 08             	call   *0x8(%ebp)
  800606:	eb 0d                	jmp    800615 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800608:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80060f:	89 04 24             	mov    %eax,(%esp)
  800612:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800615:	83 ef 01             	sub    $0x1,%edi
  800618:	eb 1a                	jmp    800634 <vprintfmt+0x246>
  80061a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800620:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800623:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800626:	eb 0c                	jmp    800634 <vprintfmt+0x246>
  800628:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80062b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80062e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800631:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800634:	83 c6 01             	add    $0x1,%esi
  800637:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80063b:	0f be c2             	movsbl %dl,%eax
  80063e:	85 c0                	test   %eax,%eax
  800640:	74 27                	je     800669 <vprintfmt+0x27b>
  800642:	85 db                	test   %ebx,%ebx
  800644:	78 9e                	js     8005e4 <vprintfmt+0x1f6>
  800646:	83 eb 01             	sub    $0x1,%ebx
  800649:	79 99                	jns    8005e4 <vprintfmt+0x1f6>
  80064b:	89 f8                	mov    %edi,%eax
  80064d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800650:	8b 75 08             	mov    0x8(%ebp),%esi
  800653:	89 c3                	mov    %eax,%ebx
  800655:	eb 1a                	jmp    800671 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800657:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80065b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800662:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800664:	83 eb 01             	sub    $0x1,%ebx
  800667:	eb 08                	jmp    800671 <vprintfmt+0x283>
  800669:	89 fb                	mov    %edi,%ebx
  80066b:	8b 75 08             	mov    0x8(%ebp),%esi
  80066e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800671:	85 db                	test   %ebx,%ebx
  800673:	7f e2                	jg     800657 <vprintfmt+0x269>
  800675:	89 75 08             	mov    %esi,0x8(%ebp)
  800678:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80067b:	e9 93 fd ff ff       	jmp    800413 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800680:	83 fa 01             	cmp    $0x1,%edx
  800683:	7e 16                	jle    80069b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	89 55 14             	mov    %edx,0x14(%ebp)
  80068e:	8b 50 04             	mov    0x4(%eax),%edx
  800691:	8b 00                	mov    (%eax),%eax
  800693:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800696:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800699:	eb 32                	jmp    8006cd <vprintfmt+0x2df>
	else if (lflag)
  80069b:	85 d2                	test   %edx,%edx
  80069d:	74 18                	je     8006b7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 50 04             	lea    0x4(%eax),%edx
  8006a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a8:	8b 30                	mov    (%eax),%esi
  8006aa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006ad:	89 f0                	mov    %esi,%eax
  8006af:	c1 f8 1f             	sar    $0x1f,%eax
  8006b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b5:	eb 16                	jmp    8006cd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c0:	8b 30                	mov    (%eax),%esi
  8006c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006c5:	89 f0                	mov    %esi,%eax
  8006c7:	c1 f8 1f             	sar    $0x1f,%eax
  8006ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006dc:	0f 89 80 00 00 00    	jns    800762 <vprintfmt+0x374>
				putch('-', putdat);
  8006e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006ed:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006f6:	f7 d8                	neg    %eax
  8006f8:	83 d2 00             	adc    $0x0,%edx
  8006fb:	f7 da                	neg    %edx
			}
			base = 10;
  8006fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800702:	eb 5e                	jmp    800762 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800704:	8d 45 14             	lea    0x14(%ebp),%eax
  800707:	e8 63 fc ff ff       	call   80036f <getuint>
			base = 10;
  80070c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800711:	eb 4f                	jmp    800762 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800713:	8d 45 14             	lea    0x14(%ebp),%eax
  800716:	e8 54 fc ff ff       	call   80036f <getuint>
			base =8;
  80071b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800720:	eb 40                	jmp    800762 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800722:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800726:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80072d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800730:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800734:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80073b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 50 04             	lea    0x4(%eax),%edx
  800744:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800747:	8b 00                	mov    (%eax),%eax
  800749:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80074e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800753:	eb 0d                	jmp    800762 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800755:	8d 45 14             	lea    0x14(%ebp),%eax
  800758:	e8 12 fc ff ff       	call   80036f <getuint>
			base = 16;
  80075d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800762:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800766:	89 74 24 10          	mov    %esi,0x10(%esp)
  80076a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80076d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800771:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800775:	89 04 24             	mov    %eax,(%esp)
  800778:	89 54 24 04          	mov    %edx,0x4(%esp)
  80077c:	89 fa                	mov    %edi,%edx
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	e8 fa fa ff ff       	call   800280 <printnum>
			break;
  800786:	e9 88 fc ff ff       	jmp    800413 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80078b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078f:	89 04 24             	mov    %eax,(%esp)
  800792:	ff 55 08             	call   *0x8(%ebp)
			break;
  800795:	e9 79 fc ff ff       	jmp    800413 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80079a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80079e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007a5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007a8:	89 f3                	mov    %esi,%ebx
  8007aa:	eb 03                	jmp    8007af <vprintfmt+0x3c1>
  8007ac:	83 eb 01             	sub    $0x1,%ebx
  8007af:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007b3:	75 f7                	jne    8007ac <vprintfmt+0x3be>
  8007b5:	e9 59 fc ff ff       	jmp    800413 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007ba:	83 c4 3c             	add    $0x3c,%esp
  8007bd:	5b                   	pop    %ebx
  8007be:	5e                   	pop    %esi
  8007bf:	5f                   	pop    %edi
  8007c0:	5d                   	pop    %ebp
  8007c1:	c3                   	ret    

008007c2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	83 ec 28             	sub    $0x28,%esp
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	74 30                	je     800813 <vsnprintf+0x51>
  8007e3:	85 d2                	test   %edx,%edx
  8007e5:	7e 2c                	jle    800813 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007fc:	c7 04 24 a9 03 80 00 	movl   $0x8003a9,(%esp)
  800803:	e8 e6 fb ff ff       	call   8003ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800808:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80080e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800811:	eb 05                	jmp    800818 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800813:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800818:	c9                   	leave  
  800819:	c3                   	ret    

0080081a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80081a:	55                   	push   %ebp
  80081b:	89 e5                	mov    %esp,%ebp
  80081d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800820:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800823:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800827:	8b 45 10             	mov    0x10(%ebp),%eax
  80082a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80082e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800831:	89 44 24 04          	mov    %eax,0x4(%esp)
  800835:	8b 45 08             	mov    0x8(%ebp),%eax
  800838:	89 04 24             	mov    %eax,(%esp)
  80083b:	e8 82 ff ff ff       	call   8007c2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800840:	c9                   	leave  
  800841:	c3                   	ret    
  800842:	66 90                	xchg   %ax,%ax
  800844:	66 90                	xchg   %ax,%ax
  800846:	66 90                	xchg   %ax,%ax
  800848:	66 90                	xchg   %ax,%ax
  80084a:	66 90                	xchg   %ax,%ax
  80084c:	66 90                	xchg   %ax,%ax
  80084e:	66 90                	xchg   %ax,%ax

00800850 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800856:	b8 00 00 00 00       	mov    $0x0,%eax
  80085b:	eb 03                	jmp    800860 <strlen+0x10>
		n++;
  80085d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800860:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800864:	75 f7                	jne    80085d <strlen+0xd>
		n++;
	return n;
}
  800866:	5d                   	pop    %ebp
  800867:	c3                   	ret    

00800868 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800868:	55                   	push   %ebp
  800869:	89 e5                	mov    %esp,%ebp
  80086b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80086e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800871:	b8 00 00 00 00       	mov    $0x0,%eax
  800876:	eb 03                	jmp    80087b <strnlen+0x13>
		n++;
  800878:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80087b:	39 d0                	cmp    %edx,%eax
  80087d:	74 06                	je     800885 <strnlen+0x1d>
  80087f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800883:	75 f3                	jne    800878 <strnlen+0x10>
		n++;
	return n;
}
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	53                   	push   %ebx
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800891:	89 c2                	mov    %eax,%edx
  800893:	83 c2 01             	add    $0x1,%edx
  800896:	83 c1 01             	add    $0x1,%ecx
  800899:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80089d:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008a0:	84 db                	test   %bl,%bl
  8008a2:	75 ef                	jne    800893 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008a4:	5b                   	pop    %ebx
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	53                   	push   %ebx
  8008ab:	83 ec 08             	sub    $0x8,%esp
  8008ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008b1:	89 1c 24             	mov    %ebx,(%esp)
  8008b4:	e8 97 ff ff ff       	call   800850 <strlen>
	strcpy(dst + len, src);
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008c0:	01 d8                	add    %ebx,%eax
  8008c2:	89 04 24             	mov    %eax,(%esp)
  8008c5:	e8 bd ff ff ff       	call   800887 <strcpy>
	return dst;
}
  8008ca:	89 d8                	mov    %ebx,%eax
  8008cc:	83 c4 08             	add    $0x8,%esp
  8008cf:	5b                   	pop    %ebx
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	56                   	push   %esi
  8008d6:	53                   	push   %ebx
  8008d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008dd:	89 f3                	mov    %esi,%ebx
  8008df:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e2:	89 f2                	mov    %esi,%edx
  8008e4:	eb 0f                	jmp    8008f5 <strncpy+0x23>
		*dst++ = *src;
  8008e6:	83 c2 01             	add    $0x1,%edx
  8008e9:	0f b6 01             	movzbl (%ecx),%eax
  8008ec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ef:	80 39 01             	cmpb   $0x1,(%ecx)
  8008f2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f5:	39 da                	cmp    %ebx,%edx
  8008f7:	75 ed                	jne    8008e6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008f9:	89 f0                	mov    %esi,%eax
  8008fb:	5b                   	pop    %ebx
  8008fc:	5e                   	pop    %esi
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	56                   	push   %esi
  800903:	53                   	push   %ebx
  800904:	8b 75 08             	mov    0x8(%ebp),%esi
  800907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80090d:	89 f0                	mov    %esi,%eax
  80090f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800913:	85 c9                	test   %ecx,%ecx
  800915:	75 0b                	jne    800922 <strlcpy+0x23>
  800917:	eb 1d                	jmp    800936 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800919:	83 c0 01             	add    $0x1,%eax
  80091c:	83 c2 01             	add    $0x1,%edx
  80091f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800922:	39 d8                	cmp    %ebx,%eax
  800924:	74 0b                	je     800931 <strlcpy+0x32>
  800926:	0f b6 0a             	movzbl (%edx),%ecx
  800929:	84 c9                	test   %cl,%cl
  80092b:	75 ec                	jne    800919 <strlcpy+0x1a>
  80092d:	89 c2                	mov    %eax,%edx
  80092f:	eb 02                	jmp    800933 <strlcpy+0x34>
  800931:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800933:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800936:	29 f0                	sub    %esi,%eax
}
  800938:	5b                   	pop    %ebx
  800939:	5e                   	pop    %esi
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800945:	eb 06                	jmp    80094d <strcmp+0x11>
		p++, q++;
  800947:	83 c1 01             	add    $0x1,%ecx
  80094a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80094d:	0f b6 01             	movzbl (%ecx),%eax
  800950:	84 c0                	test   %al,%al
  800952:	74 04                	je     800958 <strcmp+0x1c>
  800954:	3a 02                	cmp    (%edx),%al
  800956:	74 ef                	je     800947 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800958:	0f b6 c0             	movzbl %al,%eax
  80095b:	0f b6 12             	movzbl (%edx),%edx
  80095e:	29 d0                	sub    %edx,%eax
}
  800960:	5d                   	pop    %ebp
  800961:	c3                   	ret    

00800962 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800962:	55                   	push   %ebp
  800963:	89 e5                	mov    %esp,%ebp
  800965:	53                   	push   %ebx
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096c:	89 c3                	mov    %eax,%ebx
  80096e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800971:	eb 06                	jmp    800979 <strncmp+0x17>
		n--, p++, q++;
  800973:	83 c0 01             	add    $0x1,%eax
  800976:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800979:	39 d8                	cmp    %ebx,%eax
  80097b:	74 15                	je     800992 <strncmp+0x30>
  80097d:	0f b6 08             	movzbl (%eax),%ecx
  800980:	84 c9                	test   %cl,%cl
  800982:	74 04                	je     800988 <strncmp+0x26>
  800984:	3a 0a                	cmp    (%edx),%cl
  800986:	74 eb                	je     800973 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800988:	0f b6 00             	movzbl (%eax),%eax
  80098b:	0f b6 12             	movzbl (%edx),%edx
  80098e:	29 d0                	sub    %edx,%eax
  800990:	eb 05                	jmp    800997 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800992:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800997:	5b                   	pop    %ebx
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a4:	eb 07                	jmp    8009ad <strchr+0x13>
		if (*s == c)
  8009a6:	38 ca                	cmp    %cl,%dl
  8009a8:	74 0f                	je     8009b9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009aa:	83 c0 01             	add    $0x1,%eax
  8009ad:	0f b6 10             	movzbl (%eax),%edx
  8009b0:	84 d2                	test   %dl,%dl
  8009b2:	75 f2                	jne    8009a6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c5:	eb 07                	jmp    8009ce <strfind+0x13>
		if (*s == c)
  8009c7:	38 ca                	cmp    %cl,%dl
  8009c9:	74 0a                	je     8009d5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009cb:	83 c0 01             	add    $0x1,%eax
  8009ce:	0f b6 10             	movzbl (%eax),%edx
  8009d1:	84 d2                	test   %dl,%dl
  8009d3:	75 f2                	jne    8009c7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	57                   	push   %edi
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009e3:	85 c9                	test   %ecx,%ecx
  8009e5:	74 36                	je     800a1d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009e7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ed:	75 28                	jne    800a17 <memset+0x40>
  8009ef:	f6 c1 03             	test   $0x3,%cl
  8009f2:	75 23                	jne    800a17 <memset+0x40>
		c &= 0xFF;
  8009f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009f8:	89 d3                	mov    %edx,%ebx
  8009fa:	c1 e3 08             	shl    $0x8,%ebx
  8009fd:	89 d6                	mov    %edx,%esi
  8009ff:	c1 e6 18             	shl    $0x18,%esi
  800a02:	89 d0                	mov    %edx,%eax
  800a04:	c1 e0 10             	shl    $0x10,%eax
  800a07:	09 f0                	or     %esi,%eax
  800a09:	09 c2                	or     %eax,%edx
  800a0b:	89 d0                	mov    %edx,%eax
  800a0d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a0f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a12:	fc                   	cld    
  800a13:	f3 ab                	rep stos %eax,%es:(%edi)
  800a15:	eb 06                	jmp    800a1d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1a:	fc                   	cld    
  800a1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a1d:	89 f8                	mov    %edi,%eax
  800a1f:	5b                   	pop    %ebx
  800a20:	5e                   	pop    %esi
  800a21:	5f                   	pop    %edi
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	57                   	push   %edi
  800a28:	56                   	push   %esi
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a32:	39 c6                	cmp    %eax,%esi
  800a34:	73 35                	jae    800a6b <memmove+0x47>
  800a36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a39:	39 d0                	cmp    %edx,%eax
  800a3b:	73 2e                	jae    800a6b <memmove+0x47>
		s += n;
		d += n;
  800a3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a40:	89 d6                	mov    %edx,%esi
  800a42:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a4a:	75 13                	jne    800a5f <memmove+0x3b>
  800a4c:	f6 c1 03             	test   $0x3,%cl
  800a4f:	75 0e                	jne    800a5f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a51:	83 ef 04             	sub    $0x4,%edi
  800a54:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a57:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a5a:	fd                   	std    
  800a5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a5d:	eb 09                	jmp    800a68 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a5f:	83 ef 01             	sub    $0x1,%edi
  800a62:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a65:	fd                   	std    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a68:	fc                   	cld    
  800a69:	eb 1d                	jmp    800a88 <memmove+0x64>
  800a6b:	89 f2                	mov    %esi,%edx
  800a6d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a6f:	f6 c2 03             	test   $0x3,%dl
  800a72:	75 0f                	jne    800a83 <memmove+0x5f>
  800a74:	f6 c1 03             	test   $0x3,%cl
  800a77:	75 0a                	jne    800a83 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a79:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a7c:	89 c7                	mov    %eax,%edi
  800a7e:	fc                   	cld    
  800a7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a81:	eb 05                	jmp    800a88 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a83:	89 c7                	mov    %eax,%edi
  800a85:	fc                   	cld    
  800a86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a88:	5e                   	pop    %esi
  800a89:	5f                   	pop    %edi
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a92:	8b 45 10             	mov    0x10(%ebp),%eax
  800a95:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	89 04 24             	mov    %eax,(%esp)
  800aa6:	e8 79 ff ff ff       	call   800a24 <memmove>
}
  800aab:	c9                   	leave  
  800aac:	c3                   	ret    

00800aad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aad:	55                   	push   %ebp
  800aae:	89 e5                	mov    %esp,%ebp
  800ab0:	56                   	push   %esi
  800ab1:	53                   	push   %ebx
  800ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ab8:	89 d6                	mov    %edx,%esi
  800aba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800abd:	eb 1a                	jmp    800ad9 <memcmp+0x2c>
		if (*s1 != *s2)
  800abf:	0f b6 02             	movzbl (%edx),%eax
  800ac2:	0f b6 19             	movzbl (%ecx),%ebx
  800ac5:	38 d8                	cmp    %bl,%al
  800ac7:	74 0a                	je     800ad3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ac9:	0f b6 c0             	movzbl %al,%eax
  800acc:	0f b6 db             	movzbl %bl,%ebx
  800acf:	29 d8                	sub    %ebx,%eax
  800ad1:	eb 0f                	jmp    800ae2 <memcmp+0x35>
		s1++, s2++;
  800ad3:	83 c2 01             	add    $0x1,%edx
  800ad6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ad9:	39 f2                	cmp    %esi,%edx
  800adb:	75 e2                	jne    800abf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800add:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ae2:	5b                   	pop    %ebx
  800ae3:	5e                   	pop    %esi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aef:	89 c2                	mov    %eax,%edx
  800af1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af4:	eb 07                	jmp    800afd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800af6:	38 08                	cmp    %cl,(%eax)
  800af8:	74 07                	je     800b01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	39 d0                	cmp    %edx,%eax
  800aff:	72 f5                	jb     800af6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	57                   	push   %edi
  800b07:	56                   	push   %esi
  800b08:	53                   	push   %ebx
  800b09:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b0f:	eb 03                	jmp    800b14 <strtol+0x11>
		s++;
  800b11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b14:	0f b6 0a             	movzbl (%edx),%ecx
  800b17:	80 f9 09             	cmp    $0x9,%cl
  800b1a:	74 f5                	je     800b11 <strtol+0xe>
  800b1c:	80 f9 20             	cmp    $0x20,%cl
  800b1f:	74 f0                	je     800b11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b21:	80 f9 2b             	cmp    $0x2b,%cl
  800b24:	75 0a                	jne    800b30 <strtol+0x2d>
		s++;
  800b26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b29:	bf 00 00 00 00       	mov    $0x0,%edi
  800b2e:	eb 11                	jmp    800b41 <strtol+0x3e>
  800b30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b35:	80 f9 2d             	cmp    $0x2d,%cl
  800b38:	75 07                	jne    800b41 <strtol+0x3e>
		s++, neg = 1;
  800b3a:	8d 52 01             	lea    0x1(%edx),%edx
  800b3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b46:	75 15                	jne    800b5d <strtol+0x5a>
  800b48:	80 3a 30             	cmpb   $0x30,(%edx)
  800b4b:	75 10                	jne    800b5d <strtol+0x5a>
  800b4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b51:	75 0a                	jne    800b5d <strtol+0x5a>
		s += 2, base = 16;
  800b53:	83 c2 02             	add    $0x2,%edx
  800b56:	b8 10 00 00 00       	mov    $0x10,%eax
  800b5b:	eb 10                	jmp    800b6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b5d:	85 c0                	test   %eax,%eax
  800b5f:	75 0c                	jne    800b6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b63:	80 3a 30             	cmpb   $0x30,(%edx)
  800b66:	75 05                	jne    800b6d <strtol+0x6a>
		s++, base = 8;
  800b68:	83 c2 01             	add    $0x1,%edx
  800b6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b75:	0f b6 0a             	movzbl (%edx),%ecx
  800b78:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b7b:	89 f0                	mov    %esi,%eax
  800b7d:	3c 09                	cmp    $0x9,%al
  800b7f:	77 08                	ja     800b89 <strtol+0x86>
			dig = *s - '0';
  800b81:	0f be c9             	movsbl %cl,%ecx
  800b84:	83 e9 30             	sub    $0x30,%ecx
  800b87:	eb 20                	jmp    800ba9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b89:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b8c:	89 f0                	mov    %esi,%eax
  800b8e:	3c 19                	cmp    $0x19,%al
  800b90:	77 08                	ja     800b9a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b92:	0f be c9             	movsbl %cl,%ecx
  800b95:	83 e9 57             	sub    $0x57,%ecx
  800b98:	eb 0f                	jmp    800ba9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b9d:	89 f0                	mov    %esi,%eax
  800b9f:	3c 19                	cmp    $0x19,%al
  800ba1:	77 16                	ja     800bb9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ba3:	0f be c9             	movsbl %cl,%ecx
  800ba6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ba9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bac:	7d 0f                	jge    800bbd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bae:	83 c2 01             	add    $0x1,%edx
  800bb1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bb5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bb7:	eb bc                	jmp    800b75 <strtol+0x72>
  800bb9:	89 d8                	mov    %ebx,%eax
  800bbb:	eb 02                	jmp    800bbf <strtol+0xbc>
  800bbd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bbf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc3:	74 05                	je     800bca <strtol+0xc7>
		*endptr = (char *) s;
  800bc5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bc8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bca:	f7 d8                	neg    %eax
  800bcc:	85 ff                	test   %edi,%edi
  800bce:	0f 44 c3             	cmove  %ebx,%eax
}
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5f                   	pop    %edi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	57                   	push   %edi
  800bda:	56                   	push   %esi
  800bdb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bdc:	b8 00 00 00 00       	mov    $0x0,%eax
  800be1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be4:	8b 55 08             	mov    0x8(%ebp),%edx
  800be7:	89 c3                	mov    %eax,%ebx
  800be9:	89 c7                	mov    %eax,%edi
  800beb:	89 c6                	mov    %eax,%esi
  800bed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	57                   	push   %edi
  800bf8:	56                   	push   %esi
  800bf9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  800bff:	b8 01 00 00 00       	mov    $0x1,%eax
  800c04:	89 d1                	mov    %edx,%ecx
  800c06:	89 d3                	mov    %edx,%ebx
  800c08:	89 d7                	mov    %edx,%edi
  800c0a:	89 d6                	mov    %edx,%esi
  800c0c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5f                   	pop    %edi
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	57                   	push   %edi
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
  800c19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c21:	b8 03 00 00 00       	mov    $0x3,%eax
  800c26:	8b 55 08             	mov    0x8(%ebp),%edx
  800c29:	89 cb                	mov    %ecx,%ebx
  800c2b:	89 cf                	mov    %ecx,%edi
  800c2d:	89 ce                	mov    %ecx,%esi
  800c2f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c31:	85 c0                	test   %eax,%eax
  800c33:	7e 28                	jle    800c5d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c39:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c40:	00 
  800c41:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800c48:	00 
  800c49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c50:	00 
  800c51:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800c58:	e8 02 f5 ff ff       	call   80015f <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c5d:	83 c4 2c             	add    $0x2c,%esp
  800c60:	5b                   	pop    %ebx
  800c61:	5e                   	pop    %esi
  800c62:	5f                   	pop    %edi
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	57                   	push   %edi
  800c69:	56                   	push   %esi
  800c6a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c70:	b8 02 00 00 00       	mov    $0x2,%eax
  800c75:	89 d1                	mov    %edx,%ecx
  800c77:	89 d3                	mov    %edx,%ebx
  800c79:	89 d7                	mov    %edx,%edi
  800c7b:	89 d6                	mov    %edx,%esi
  800c7d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c7f:	5b                   	pop    %ebx
  800c80:	5e                   	pop    %esi
  800c81:	5f                   	pop    %edi
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    

00800c84 <sys_yield>:

void
sys_yield(void)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	57                   	push   %edi
  800c88:	56                   	push   %esi
  800c89:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c94:	89 d1                	mov    %edx,%ecx
  800c96:	89 d3                	mov    %edx,%ebx
  800c98:	89 d7                	mov    %edx,%edi
  800c9a:	89 d6                	mov    %edx,%esi
  800c9c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cac:	be 00 00 00 00       	mov    $0x0,%esi
  800cb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cbf:	89 f7                	mov    %esi,%edi
  800cc1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc3:	85 c0                	test   %eax,%eax
  800cc5:	7e 28                	jle    800cef <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ccb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cd2:	00 
  800cd3:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800cda:	00 
  800cdb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce2:	00 
  800ce3:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800cea:	e8 70 f4 ff ff       	call   80015f <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cef:	83 c4 2c             	add    $0x2c,%esp
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5f                   	pop    %edi
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	57                   	push   %edi
  800cfb:	56                   	push   %esi
  800cfc:	53                   	push   %ebx
  800cfd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d00:	b8 05 00 00 00       	mov    $0x5,%eax
  800d05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d08:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d11:	8b 75 18             	mov    0x18(%ebp),%esi
  800d14:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d16:	85 c0                	test   %eax,%eax
  800d18:	7e 28                	jle    800d42 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d25:	00 
  800d26:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800d2d:	00 
  800d2e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d35:	00 
  800d36:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800d3d:	e8 1d f4 ff ff       	call   80015f <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d42:	83 c4 2c             	add    $0x2c,%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5f                   	pop    %edi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	57                   	push   %edi
  800d4e:	56                   	push   %esi
  800d4f:	53                   	push   %ebx
  800d50:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d58:	b8 06 00 00 00       	mov    $0x6,%eax
  800d5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d60:	8b 55 08             	mov    0x8(%ebp),%edx
  800d63:	89 df                	mov    %ebx,%edi
  800d65:	89 de                	mov    %ebx,%esi
  800d67:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d69:	85 c0                	test   %eax,%eax
  800d6b:	7e 28                	jle    800d95 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d71:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d78:	00 
  800d79:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800d80:	00 
  800d81:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d88:	00 
  800d89:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800d90:	e8 ca f3 ff ff       	call   80015f <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d95:	83 c4 2c             	add    $0x2c,%esp
  800d98:	5b                   	pop    %ebx
  800d99:	5e                   	pop    %esi
  800d9a:	5f                   	pop    %edi
  800d9b:	5d                   	pop    %ebp
  800d9c:	c3                   	ret    

00800d9d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9d:	55                   	push   %ebp
  800d9e:	89 e5                	mov    %esp,%ebp
  800da0:	57                   	push   %edi
  800da1:	56                   	push   %esi
  800da2:	53                   	push   %ebx
  800da3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dab:	b8 08 00 00 00       	mov    $0x8,%eax
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	8b 55 08             	mov    0x8(%ebp),%edx
  800db6:	89 df                	mov    %ebx,%edi
  800db8:	89 de                	mov    %ebx,%esi
  800dba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dbc:	85 c0                	test   %eax,%eax
  800dbe:	7e 28                	jle    800de8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dcb:	00 
  800dcc:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800dd3:	00 
  800dd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ddb:	00 
  800ddc:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800de3:	e8 77 f3 ff ff       	call   80015f <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800de8:	83 c4 2c             	add    $0x2c,%esp
  800deb:	5b                   	pop    %ebx
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	57                   	push   %edi
  800df4:	56                   	push   %esi
  800df5:	53                   	push   %ebx
  800df6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfe:	b8 09 00 00 00       	mov    $0x9,%eax
  800e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e06:	8b 55 08             	mov    0x8(%ebp),%edx
  800e09:	89 df                	mov    %ebx,%edi
  800e0b:	89 de                	mov    %ebx,%esi
  800e0d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	7e 28                	jle    800e3b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e13:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e17:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e1e:	00 
  800e1f:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800e26:	00 
  800e27:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2e:	00 
  800e2f:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800e36:	e8 24 f3 ff ff       	call   80015f <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e3b:	83 c4 2c             	add    $0x2c,%esp
  800e3e:	5b                   	pop    %ebx
  800e3f:	5e                   	pop    %esi
  800e40:	5f                   	pop    %edi
  800e41:	5d                   	pop    %ebp
  800e42:	c3                   	ret    

00800e43 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	89 df                	mov    %ebx,%edi
  800e5e:	89 de                	mov    %ebx,%esi
  800e60:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e62:	85 c0                	test   %eax,%eax
  800e64:	7e 28                	jle    800e8e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e66:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e71:	00 
  800e72:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800e79:	00 
  800e7a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e81:	00 
  800e82:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800e89:	e8 d1 f2 ff ff       	call   80015f <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e8e:	83 c4 2c             	add    $0x2c,%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9c:	be 00 00 00 00       	mov    $0x0,%esi
  800ea1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ea6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eaf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eb2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
  800ebf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ec7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	89 cb                	mov    %ecx,%ebx
  800ed1:	89 cf                	mov    %ecx,%edi
  800ed3:	89 ce                	mov    %ecx,%esi
  800ed5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed7:	85 c0                	test   %eax,%eax
  800ed9:	7e 28                	jle    800f03 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800edb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800edf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ee6:	00 
  800ee7:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800eee:	00 
  800eef:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef6:	00 
  800ef7:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800efe:	e8 5c f2 ff ff       	call   80015f <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f03:	83 c4 2c             	add    $0x2c,%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5f                   	pop    %edi
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	57                   	push   %edi
  800f0f:	56                   	push   %esi
  800f10:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f11:	ba 00 00 00 00       	mov    $0x0,%edx
  800f16:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f1b:	89 d1                	mov    %edx,%ecx
  800f1d:	89 d3                	mov    %edx,%ebx
  800f1f:	89 d7                	mov    %edx,%edi
  800f21:	89 d6                	mov    %edx,%esi
  800f23:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f25:	5b                   	pop    %ebx
  800f26:	5e                   	pop    %esi
  800f27:	5f                   	pop    %edi
  800f28:	5d                   	pop    %ebp
  800f29:	c3                   	ret    

00800f2a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
  800f2d:	57                   	push   %edi
  800f2e:	56                   	push   %esi
  800f2f:	53                   	push   %ebx
  800f30:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f38:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f40:	8b 55 08             	mov    0x8(%ebp),%edx
  800f43:	89 df                	mov    %ebx,%edi
  800f45:	89 de                	mov    %ebx,%esi
  800f47:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f49:	85 c0                	test   %eax,%eax
  800f4b:	7e 28                	jle    800f75 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f51:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f58:	00 
  800f59:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800f60:	00 
  800f61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f68:	00 
  800f69:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800f70:	e8 ea f1 ff ff       	call   80015f <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800f75:	83 c4 2c             	add    $0x2c,%esp
  800f78:	5b                   	pop    %ebx
  800f79:	5e                   	pop    %esi
  800f7a:	5f                   	pop    %edi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	53                   	push   %ebx
  800f83:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f93:	8b 55 08             	mov    0x8(%ebp),%edx
  800f96:	89 df                	mov    %ebx,%edi
  800f98:	89 de                	mov    %ebx,%esi
  800f9a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f9c:	85 c0                	test   %eax,%eax
  800f9e:	7e 28                	jle    800fc8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800fab:	00 
  800fac:	c7 44 24 08 9f 2a 80 	movl   $0x802a9f,0x8(%esp)
  800fb3:	00 
  800fb4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fbb:	00 
  800fbc:	c7 04 24 bc 2a 80 00 	movl   $0x802abc,(%esp)
  800fc3:	e8 97 f1 ff ff       	call   80015f <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  800fc8:	83 c4 2c             	add    $0x2c,%esp
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5f                   	pop    %edi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  800fd6:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800fdd:	75 58                	jne    801037 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  800fdf:	a1 08 40 80 00       	mov    0x804008,%eax
  800fe4:	8b 40 48             	mov    0x48(%eax),%eax
  800fe7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fee:	00 
  800fef:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800ff6:	ee 
  800ff7:	89 04 24             	mov    %eax,(%esp)
  800ffa:	e8 a4 fc ff ff       	call   800ca3 <sys_page_alloc>
		if(return_code!=0)
  800fff:	85 c0                	test   %eax,%eax
  801001:	74 1c                	je     80101f <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  801003:	c7 44 24 08 cc 2a 80 	movl   $0x802acc,0x8(%esp)
  80100a:	00 
  80100b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801012:	00 
  801013:	c7 04 24 25 2b 80 00 	movl   $0x802b25,(%esp)
  80101a:	e8 40 f1 ff ff       	call   80015f <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  80101f:	a1 08 40 80 00       	mov    0x804008,%eax
  801024:	8b 40 48             	mov    0x48(%eax),%eax
  801027:	c7 44 24 04 41 10 80 	movl   $0x801041,0x4(%esp)
  80102e:	00 
  80102f:	89 04 24             	mov    %eax,(%esp)
  801032:	e8 0c fe ff ff       	call   800e43 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    

00801041 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801041:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801042:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801047:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801049:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  80104c:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  80104e:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  801052:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  801056:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  801057:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  801059:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  80105b:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  80105f:	58                   	pop    %eax
	popl %eax;
  801060:	58                   	pop    %eax
	popal;
  801061:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  801062:	83 c4 04             	add    $0x4,%esp
	popfl;
  801065:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  801066:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  801067:	c3                   	ret    
  801068:	66 90                	xchg   %ax,%ax
  80106a:	66 90                	xchg   %ax,%ax
  80106c:	66 90                	xchg   %ax,%ax
  80106e:	66 90                	xchg   %ax,%ax

00801070 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	05 00 00 00 30       	add    $0x30000000,%eax
  80107b:	c1 e8 0c             	shr    $0xc,%eax
}
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    

00801080 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80108b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801090:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	c1 ea 16             	shr    $0x16,%edx
  8010a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ae:	f6 c2 01             	test   $0x1,%dl
  8010b1:	74 11                	je     8010c4 <fd_alloc+0x2d>
  8010b3:	89 c2                	mov    %eax,%edx
  8010b5:	c1 ea 0c             	shr    $0xc,%edx
  8010b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010bf:	f6 c2 01             	test   $0x1,%dl
  8010c2:	75 09                	jne    8010cd <fd_alloc+0x36>
			*fd_store = fd;
  8010c4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010cb:	eb 17                	jmp    8010e4 <fd_alloc+0x4d>
  8010cd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010d2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010d7:	75 c9                	jne    8010a2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010d9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010df:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ec:	83 f8 1f             	cmp    $0x1f,%eax
  8010ef:	77 36                	ja     801127 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010f1:	c1 e0 0c             	shl    $0xc,%eax
  8010f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010f9:	89 c2                	mov    %eax,%edx
  8010fb:	c1 ea 16             	shr    $0x16,%edx
  8010fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801105:	f6 c2 01             	test   $0x1,%dl
  801108:	74 24                	je     80112e <fd_lookup+0x48>
  80110a:	89 c2                	mov    %eax,%edx
  80110c:	c1 ea 0c             	shr    $0xc,%edx
  80110f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801116:	f6 c2 01             	test   $0x1,%dl
  801119:	74 1a                	je     801135 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80111b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111e:	89 02                	mov    %eax,(%edx)
	return 0;
  801120:	b8 00 00 00 00       	mov    $0x0,%eax
  801125:	eb 13                	jmp    80113a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801127:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112c:	eb 0c                	jmp    80113a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80112e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801133:	eb 05                	jmp    80113a <fd_lookup+0x54>
  801135:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 18             	sub    $0x18,%esp
  801142:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801145:	ba 00 00 00 00       	mov    $0x0,%edx
  80114a:	eb 13                	jmp    80115f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80114c:	39 08                	cmp    %ecx,(%eax)
  80114e:	75 0c                	jne    80115c <dev_lookup+0x20>
			*dev = devtab[i];
  801150:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801153:	89 01                	mov    %eax,(%ecx)
			return 0;
  801155:	b8 00 00 00 00       	mov    $0x0,%eax
  80115a:	eb 38                	jmp    801194 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80115c:	83 c2 01             	add    $0x1,%edx
  80115f:	8b 04 95 b4 2b 80 00 	mov    0x802bb4(,%edx,4),%eax
  801166:	85 c0                	test   %eax,%eax
  801168:	75 e2                	jne    80114c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80116a:	a1 08 40 80 00       	mov    0x804008,%eax
  80116f:	8b 40 48             	mov    0x48(%eax),%eax
  801172:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801176:	89 44 24 04          	mov    %eax,0x4(%esp)
  80117a:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  801181:	e8 d2 f0 ff ff       	call   800258 <cprintf>
	*dev = 0;
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80118f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	56                   	push   %esi
  80119a:	53                   	push   %ebx
  80119b:	83 ec 20             	sub    $0x20,%esp
  80119e:	8b 75 08             	mov    0x8(%ebp),%esi
  8011a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011b1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011b4:	89 04 24             	mov    %eax,(%esp)
  8011b7:	e8 2a ff ff ff       	call   8010e6 <fd_lookup>
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	78 05                	js     8011c5 <fd_close+0x2f>
	    || fd != fd2)
  8011c0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011c3:	74 0c                	je     8011d1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011c5:	84 db                	test   %bl,%bl
  8011c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011cc:	0f 44 c2             	cmove  %edx,%eax
  8011cf:	eb 3f                	jmp    801210 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011d8:	8b 06                	mov    (%esi),%eax
  8011da:	89 04 24             	mov    %eax,(%esp)
  8011dd:	e8 5a ff ff ff       	call   80113c <dev_lookup>
  8011e2:	89 c3                	mov    %eax,%ebx
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 16                	js     8011fe <fd_close+0x68>
		if (dev->dev_close)
  8011e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011ee:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	74 07                	je     8011fe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011f7:	89 34 24             	mov    %esi,(%esp)
  8011fa:	ff d0                	call   *%eax
  8011fc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801202:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801209:	e8 3c fb ff ff       	call   800d4a <sys_page_unmap>
	return r;
  80120e:	89 d8                	mov    %ebx,%eax
}
  801210:	83 c4 20             	add    $0x20,%esp
  801213:	5b                   	pop    %ebx
  801214:	5e                   	pop    %esi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80121d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801220:	89 44 24 04          	mov    %eax,0x4(%esp)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	89 04 24             	mov    %eax,(%esp)
  80122a:	e8 b7 fe ff ff       	call   8010e6 <fd_lookup>
  80122f:	89 c2                	mov    %eax,%edx
  801231:	85 d2                	test   %edx,%edx
  801233:	78 13                	js     801248 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801235:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80123c:	00 
  80123d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801240:	89 04 24             	mov    %eax,(%esp)
  801243:	e8 4e ff ff ff       	call   801196 <fd_close>
}
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <close_all>:

void
close_all(void)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	53                   	push   %ebx
  80124e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801251:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801256:	89 1c 24             	mov    %ebx,(%esp)
  801259:	e8 b9 ff ff ff       	call   801217 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80125e:	83 c3 01             	add    $0x1,%ebx
  801261:	83 fb 20             	cmp    $0x20,%ebx
  801264:	75 f0                	jne    801256 <close_all+0xc>
		close(i);
}
  801266:	83 c4 14             	add    $0x14,%esp
  801269:	5b                   	pop    %ebx
  80126a:	5d                   	pop    %ebp
  80126b:	c3                   	ret    

0080126c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	57                   	push   %edi
  801270:	56                   	push   %esi
  801271:	53                   	push   %ebx
  801272:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801275:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	89 04 24             	mov    %eax,(%esp)
  801282:	e8 5f fe ff ff       	call   8010e6 <fd_lookup>
  801287:	89 c2                	mov    %eax,%edx
  801289:	85 d2                	test   %edx,%edx
  80128b:	0f 88 e1 00 00 00    	js     801372 <dup+0x106>
		return r;
	close(newfdnum);
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	89 04 24             	mov    %eax,(%esp)
  801297:	e8 7b ff ff ff       	call   801217 <close>

	newfd = INDEX2FD(newfdnum);
  80129c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80129f:	c1 e3 0c             	shl    $0xc,%ebx
  8012a2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012ab:	89 04 24             	mov    %eax,(%esp)
  8012ae:	e8 cd fd ff ff       	call   801080 <fd2data>
  8012b3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012b5:	89 1c 24             	mov    %ebx,(%esp)
  8012b8:	e8 c3 fd ff ff       	call   801080 <fd2data>
  8012bd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	c1 e8 16             	shr    $0x16,%eax
  8012c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012cb:	a8 01                	test   $0x1,%al
  8012cd:	74 43                	je     801312 <dup+0xa6>
  8012cf:	89 f0                	mov    %esi,%eax
  8012d1:	c1 e8 0c             	shr    $0xc,%eax
  8012d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012db:	f6 c2 01             	test   $0x1,%dl
  8012de:	74 32                	je     801312 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012fb:	00 
  8012fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801300:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801307:	e8 eb f9 ff ff       	call   800cf7 <sys_page_map>
  80130c:	89 c6                	mov    %eax,%esi
  80130e:	85 c0                	test   %eax,%eax
  801310:	78 3e                	js     801350 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801312:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801315:	89 c2                	mov    %eax,%edx
  801317:	c1 ea 0c             	shr    $0xc,%edx
  80131a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801321:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801327:	89 54 24 10          	mov    %edx,0x10(%esp)
  80132b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80132f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801336:	00 
  801337:	89 44 24 04          	mov    %eax,0x4(%esp)
  80133b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801342:	e8 b0 f9 ff ff       	call   800cf7 <sys_page_map>
  801347:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80134c:	85 f6                	test   %esi,%esi
  80134e:	79 22                	jns    801372 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801350:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801354:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80135b:	e8 ea f9 ff ff       	call   800d4a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801360:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801364:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80136b:	e8 da f9 ff ff       	call   800d4a <sys_page_unmap>
	return r;
  801370:	89 f0                	mov    %esi,%eax
}
  801372:	83 c4 3c             	add    $0x3c,%esp
  801375:	5b                   	pop    %ebx
  801376:	5e                   	pop    %esi
  801377:	5f                   	pop    %edi
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	53                   	push   %ebx
  80137e:	83 ec 24             	sub    $0x24,%esp
  801381:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801384:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801387:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138b:	89 1c 24             	mov    %ebx,(%esp)
  80138e:	e8 53 fd ff ff       	call   8010e6 <fd_lookup>
  801393:	89 c2                	mov    %eax,%edx
  801395:	85 d2                	test   %edx,%edx
  801397:	78 6d                	js     801406 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801399:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	89 04 24             	mov    %eax,(%esp)
  8013a8:	e8 8f fd ff ff       	call   80113c <dev_lookup>
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 55                	js     801406 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b4:	8b 50 08             	mov    0x8(%eax),%edx
  8013b7:	83 e2 03             	and    $0x3,%edx
  8013ba:	83 fa 01             	cmp    $0x1,%edx
  8013bd:	75 23                	jne    8013e2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013bf:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c4:	8b 40 48             	mov    0x48(%eax),%eax
  8013c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cf:	c7 04 24 78 2b 80 00 	movl   $0x802b78,(%esp)
  8013d6:	e8 7d ee ff ff       	call   800258 <cprintf>
		return -E_INVAL;
  8013db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e0:	eb 24                	jmp    801406 <read+0x8c>
	}
	if (!dev->dev_read)
  8013e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e5:	8b 52 08             	mov    0x8(%edx),%edx
  8013e8:	85 d2                	test   %edx,%edx
  8013ea:	74 15                	je     801401 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013fa:	89 04 24             	mov    %eax,(%esp)
  8013fd:	ff d2                	call   *%edx
  8013ff:	eb 05                	jmp    801406 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801401:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801406:	83 c4 24             	add    $0x24,%esp
  801409:	5b                   	pop    %ebx
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	57                   	push   %edi
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	83 ec 1c             	sub    $0x1c,%esp
  801415:	8b 7d 08             	mov    0x8(%ebp),%edi
  801418:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80141b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801420:	eb 23                	jmp    801445 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801422:	89 f0                	mov    %esi,%eax
  801424:	29 d8                	sub    %ebx,%eax
  801426:	89 44 24 08          	mov    %eax,0x8(%esp)
  80142a:	89 d8                	mov    %ebx,%eax
  80142c:	03 45 0c             	add    0xc(%ebp),%eax
  80142f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801433:	89 3c 24             	mov    %edi,(%esp)
  801436:	e8 3f ff ff ff       	call   80137a <read>
		if (m < 0)
  80143b:	85 c0                	test   %eax,%eax
  80143d:	78 10                	js     80144f <readn+0x43>
			return m;
		if (m == 0)
  80143f:	85 c0                	test   %eax,%eax
  801441:	74 0a                	je     80144d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801443:	01 c3                	add    %eax,%ebx
  801445:	39 f3                	cmp    %esi,%ebx
  801447:	72 d9                	jb     801422 <readn+0x16>
  801449:	89 d8                	mov    %ebx,%eax
  80144b:	eb 02                	jmp    80144f <readn+0x43>
  80144d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80144f:	83 c4 1c             	add    $0x1c,%esp
  801452:	5b                   	pop    %ebx
  801453:	5e                   	pop    %esi
  801454:	5f                   	pop    %edi
  801455:	5d                   	pop    %ebp
  801456:	c3                   	ret    

00801457 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	53                   	push   %ebx
  80145b:	83 ec 24             	sub    $0x24,%esp
  80145e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801461:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801464:	89 44 24 04          	mov    %eax,0x4(%esp)
  801468:	89 1c 24             	mov    %ebx,(%esp)
  80146b:	e8 76 fc ff ff       	call   8010e6 <fd_lookup>
  801470:	89 c2                	mov    %eax,%edx
  801472:	85 d2                	test   %edx,%edx
  801474:	78 68                	js     8014de <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801476:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	89 04 24             	mov    %eax,(%esp)
  801485:	e8 b2 fc ff ff       	call   80113c <dev_lookup>
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 50                	js     8014de <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801491:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801495:	75 23                	jne    8014ba <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801497:	a1 08 40 80 00       	mov    0x804008,%eax
  80149c:	8b 40 48             	mov    0x48(%eax),%eax
  80149f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a7:	c7 04 24 94 2b 80 00 	movl   $0x802b94,(%esp)
  8014ae:	e8 a5 ed ff ff       	call   800258 <cprintf>
		return -E_INVAL;
  8014b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b8:	eb 24                	jmp    8014de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bd:	8b 52 0c             	mov    0xc(%edx),%edx
  8014c0:	85 d2                	test   %edx,%edx
  8014c2:	74 15                	je     8014d9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014d2:	89 04 24             	mov    %eax,(%esp)
  8014d5:	ff d2                	call   *%edx
  8014d7:	eb 05                	jmp    8014de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014de:	83 c4 24             	add    $0x24,%esp
  8014e1:	5b                   	pop    %ebx
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    

008014e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ea:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	89 04 24             	mov    %eax,(%esp)
  8014f7:	e8 ea fb ff ff       	call   8010e6 <fd_lookup>
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 0e                	js     80150e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801500:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801503:	8b 55 0c             	mov    0xc(%ebp),%edx
  801506:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	53                   	push   %ebx
  801514:	83 ec 24             	sub    $0x24,%esp
  801517:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801521:	89 1c 24             	mov    %ebx,(%esp)
  801524:	e8 bd fb ff ff       	call   8010e6 <fd_lookup>
  801529:	89 c2                	mov    %eax,%edx
  80152b:	85 d2                	test   %edx,%edx
  80152d:	78 61                	js     801590 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801532:	89 44 24 04          	mov    %eax,0x4(%esp)
  801536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801539:	8b 00                	mov    (%eax),%eax
  80153b:	89 04 24             	mov    %eax,(%esp)
  80153e:	e8 f9 fb ff ff       	call   80113c <dev_lookup>
  801543:	85 c0                	test   %eax,%eax
  801545:	78 49                	js     801590 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80154e:	75 23                	jne    801573 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801550:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801555:	8b 40 48             	mov    0x48(%eax),%eax
  801558:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80155c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801560:	c7 04 24 54 2b 80 00 	movl   $0x802b54,(%esp)
  801567:	e8 ec ec ff ff       	call   800258 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80156c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801571:	eb 1d                	jmp    801590 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801573:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801576:	8b 52 18             	mov    0x18(%edx),%edx
  801579:	85 d2                	test   %edx,%edx
  80157b:	74 0e                	je     80158b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80157d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801580:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	ff d2                	call   *%edx
  801589:	eb 05                	jmp    801590 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80158b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801590:	83 c4 24             	add    $0x24,%esp
  801593:	5b                   	pop    %ebx
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    

00801596 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	53                   	push   %ebx
  80159a:	83 ec 24             	sub    $0x24,%esp
  80159d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	89 04 24             	mov    %eax,(%esp)
  8015ad:	e8 34 fb ff ff       	call   8010e6 <fd_lookup>
  8015b2:	89 c2                	mov    %eax,%edx
  8015b4:	85 d2                	test   %edx,%edx
  8015b6:	78 52                	js     80160a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c2:	8b 00                	mov    (%eax),%eax
  8015c4:	89 04 24             	mov    %eax,(%esp)
  8015c7:	e8 70 fb ff ff       	call   80113c <dev_lookup>
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 3a                	js     80160a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015d7:	74 2c                	je     801605 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015d9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015e3:	00 00 00 
	stat->st_isdir = 0;
  8015e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015ed:	00 00 00 
	stat->st_dev = dev;
  8015f0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fd:	89 14 24             	mov    %edx,(%esp)
  801600:	ff 50 14             	call   *0x14(%eax)
  801603:	eb 05                	jmp    80160a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801605:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80160a:	83 c4 24             	add    $0x24,%esp
  80160d:	5b                   	pop    %ebx
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    

00801610 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	56                   	push   %esi
  801614:	53                   	push   %ebx
  801615:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801618:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80161f:	00 
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	89 04 24             	mov    %eax,(%esp)
  801626:	e8 28 02 00 00       	call   801853 <open>
  80162b:	89 c3                	mov    %eax,%ebx
  80162d:	85 db                	test   %ebx,%ebx
  80162f:	78 1b                	js     80164c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801631:	8b 45 0c             	mov    0xc(%ebp),%eax
  801634:	89 44 24 04          	mov    %eax,0x4(%esp)
  801638:	89 1c 24             	mov    %ebx,(%esp)
  80163b:	e8 56 ff ff ff       	call   801596 <fstat>
  801640:	89 c6                	mov    %eax,%esi
	close(fd);
  801642:	89 1c 24             	mov    %ebx,(%esp)
  801645:	e8 cd fb ff ff       	call   801217 <close>
	return r;
  80164a:	89 f0                	mov    %esi,%eax
}
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	5b                   	pop    %ebx
  801650:	5e                   	pop    %esi
  801651:	5d                   	pop    %ebp
  801652:	c3                   	ret    

00801653 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	83 ec 10             	sub    $0x10,%esp
  80165b:	89 c6                	mov    %eax,%esi
  80165d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80165f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801666:	75 11                	jne    801679 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801668:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80166f:	e8 7a 0d 00 00       	call   8023ee <ipc_find_env>
  801674:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801679:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801680:	00 
  801681:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801688:	00 
  801689:	89 74 24 04          	mov    %esi,0x4(%esp)
  80168d:	a1 00 40 80 00       	mov    0x804000,%eax
  801692:	89 04 24             	mov    %eax,(%esp)
  801695:	e8 f6 0c 00 00       	call   802390 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80169a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016a1:	00 
  8016a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016ad:	e8 74 0c 00 00       	call   802326 <ipc_recv>
}
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	5b                   	pop    %ebx
  8016b6:	5e                   	pop    %esi
  8016b7:	5d                   	pop    %ebp
  8016b8:	c3                   	ret    

008016b9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016dc:	e8 72 ff ff ff       	call   801653 <fsipc>
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ef:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016fe:	e8 50 ff ff ff       	call   801653 <fsipc>
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	53                   	push   %ebx
  801709:	83 ec 14             	sub    $0x14,%esp
  80170c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8b 40 0c             	mov    0xc(%eax),%eax
  801715:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80171a:	ba 00 00 00 00       	mov    $0x0,%edx
  80171f:	b8 05 00 00 00       	mov    $0x5,%eax
  801724:	e8 2a ff ff ff       	call   801653 <fsipc>
  801729:	89 c2                	mov    %eax,%edx
  80172b:	85 d2                	test   %edx,%edx
  80172d:	78 2b                	js     80175a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80172f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801736:	00 
  801737:	89 1c 24             	mov    %ebx,(%esp)
  80173a:	e8 48 f1 ff ff       	call   800887 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80173f:	a1 80 50 80 00       	mov    0x805080,%eax
  801744:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80174a:	a1 84 50 80 00       	mov    0x805084,%eax
  80174f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175a:	83 c4 14             	add    $0x14,%esp
  80175d:	5b                   	pop    %ebx
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    

00801760 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 18             	sub    $0x18,%esp
  801766:	8b 45 10             	mov    0x10(%ebp),%eax
  801769:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80176e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801773:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801776:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80177b:	8b 55 08             	mov    0x8(%ebp),%edx
  80177e:	8b 52 0c             	mov    0xc(%edx),%edx
  801781:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801787:	89 44 24 08          	mov    %eax,0x8(%esp)
  80178b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801792:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  801799:	e8 86 f2 ff ff       	call   800a24 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80179e:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8017a8:	e8 a6 fe ff ff       	call   801653 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	56                   	push   %esi
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 10             	sub    $0x10,%esp
  8017b7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017c5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d0:	b8 03 00 00 00       	mov    $0x3,%eax
  8017d5:	e8 79 fe ff ff       	call   801653 <fsipc>
  8017da:	89 c3                	mov    %eax,%ebx
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 6a                	js     80184a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017e0:	39 c6                	cmp    %eax,%esi
  8017e2:	73 24                	jae    801808 <devfile_read+0x59>
  8017e4:	c7 44 24 0c c8 2b 80 	movl   $0x802bc8,0xc(%esp)
  8017eb:	00 
  8017ec:	c7 44 24 08 cf 2b 80 	movl   $0x802bcf,0x8(%esp)
  8017f3:	00 
  8017f4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8017fb:	00 
  8017fc:	c7 04 24 e4 2b 80 00 	movl   $0x802be4,(%esp)
  801803:	e8 57 e9 ff ff       	call   80015f <_panic>
	assert(r <= PGSIZE);
  801808:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80180d:	7e 24                	jle    801833 <devfile_read+0x84>
  80180f:	c7 44 24 0c ef 2b 80 	movl   $0x802bef,0xc(%esp)
  801816:	00 
  801817:	c7 44 24 08 cf 2b 80 	movl   $0x802bcf,0x8(%esp)
  80181e:	00 
  80181f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801826:	00 
  801827:	c7 04 24 e4 2b 80 00 	movl   $0x802be4,(%esp)
  80182e:	e8 2c e9 ff ff       	call   80015f <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801833:	89 44 24 08          	mov    %eax,0x8(%esp)
  801837:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80183e:	00 
  80183f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801842:	89 04 24             	mov    %eax,(%esp)
  801845:	e8 da f1 ff ff       	call   800a24 <memmove>
	return r;
}
  80184a:	89 d8                	mov    %ebx,%eax
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	5b                   	pop    %ebx
  801850:	5e                   	pop    %esi
  801851:	5d                   	pop    %ebp
  801852:	c3                   	ret    

00801853 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	53                   	push   %ebx
  801857:	83 ec 24             	sub    $0x24,%esp
  80185a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80185d:	89 1c 24             	mov    %ebx,(%esp)
  801860:	e8 eb ef ff ff       	call   800850 <strlen>
  801865:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80186a:	7f 60                	jg     8018cc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80186c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80186f:	89 04 24             	mov    %eax,(%esp)
  801872:	e8 20 f8 ff ff       	call   801097 <fd_alloc>
  801877:	89 c2                	mov    %eax,%edx
  801879:	85 d2                	test   %edx,%edx
  80187b:	78 54                	js     8018d1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80187d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801881:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801888:	e8 fa ef ff ff       	call   800887 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80188d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801890:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801898:	b8 01 00 00 00       	mov    $0x1,%eax
  80189d:	e8 b1 fd ff ff       	call   801653 <fsipc>
  8018a2:	89 c3                	mov    %eax,%ebx
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	79 17                	jns    8018bf <open+0x6c>
		fd_close(fd, 0);
  8018a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018af:	00 
  8018b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b3:	89 04 24             	mov    %eax,(%esp)
  8018b6:	e8 db f8 ff ff       	call   801196 <fd_close>
		return r;
  8018bb:	89 d8                	mov    %ebx,%eax
  8018bd:	eb 12                	jmp    8018d1 <open+0x7e>
	}

	return fd2num(fd);
  8018bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c2:	89 04 24             	mov    %eax,(%esp)
  8018c5:	e8 a6 f7 ff ff       	call   801070 <fd2num>
  8018ca:	eb 05                	jmp    8018d1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018cc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018d1:	83 c4 24             	add    $0x24,%esp
  8018d4:	5b                   	pop    %ebx
  8018d5:	5d                   	pop    %ebp
  8018d6:	c3                   	ret    

008018d7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e2:	b8 08 00 00 00       	mov    $0x8,%eax
  8018e7:	e8 67 fd ff ff       	call   801653 <fsipc>
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    
  8018ee:	66 90                	xchg   %ax,%ax

008018f0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8018f6:	c7 44 24 04 fb 2b 80 	movl   $0x802bfb,0x4(%esp)
  8018fd:	00 
  8018fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801901:	89 04 24             	mov    %eax,(%esp)
  801904:	e8 7e ef ff ff       	call   800887 <strcpy>
	return 0;
}
  801909:	b8 00 00 00 00       	mov    $0x0,%eax
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	53                   	push   %ebx
  801914:	83 ec 14             	sub    $0x14,%esp
  801917:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80191a:	89 1c 24             	mov    %ebx,(%esp)
  80191d:	e8 04 0b 00 00       	call   802426 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801922:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801927:	83 f8 01             	cmp    $0x1,%eax
  80192a:	75 0d                	jne    801939 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80192c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80192f:	89 04 24             	mov    %eax,(%esp)
  801932:	e8 29 03 00 00       	call   801c60 <nsipc_close>
  801937:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801939:	89 d0                	mov    %edx,%eax
  80193b:	83 c4 14             	add    $0x14,%esp
  80193e:	5b                   	pop    %ebx
  80193f:	5d                   	pop    %ebp
  801940:	c3                   	ret    

00801941 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801947:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80194e:	00 
  80194f:	8b 45 10             	mov    0x10(%ebp),%eax
  801952:	89 44 24 08          	mov    %eax,0x8(%esp)
  801956:	8b 45 0c             	mov    0xc(%ebp),%eax
  801959:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	8b 40 0c             	mov    0xc(%eax),%eax
  801963:	89 04 24             	mov    %eax,(%esp)
  801966:	e8 f0 03 00 00       	call   801d5b <nsipc_send>
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801973:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80197a:	00 
  80197b:	8b 45 10             	mov    0x10(%ebp),%eax
  80197e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801982:	8b 45 0c             	mov    0xc(%ebp),%eax
  801985:	89 44 24 04          	mov    %eax,0x4(%esp)
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	8b 40 0c             	mov    0xc(%eax),%eax
  80198f:	89 04 24             	mov    %eax,(%esp)
  801992:	e8 44 03 00 00       	call   801cdb <nsipc_recv>
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80199f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019a6:	89 04 24             	mov    %eax,(%esp)
  8019a9:	e8 38 f7 ff ff       	call   8010e6 <fd_lookup>
  8019ae:	85 c0                	test   %eax,%eax
  8019b0:	78 17                	js     8019c9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8019b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019bb:	39 08                	cmp    %ecx,(%eax)
  8019bd:	75 05                	jne    8019c4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8019bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c2:	eb 05                	jmp    8019c9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8019c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	56                   	push   %esi
  8019cf:	53                   	push   %ebx
  8019d0:	83 ec 20             	sub    $0x20,%esp
  8019d3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8019d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d8:	89 04 24             	mov    %eax,(%esp)
  8019db:	e8 b7 f6 ff ff       	call   801097 <fd_alloc>
  8019e0:	89 c3                	mov    %eax,%ebx
  8019e2:	85 c0                	test   %eax,%eax
  8019e4:	78 21                	js     801a07 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019e6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019ed:	00 
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019fc:	e8 a2 f2 ff ff       	call   800ca3 <sys_page_alloc>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	85 c0                	test   %eax,%eax
  801a05:	79 0c                	jns    801a13 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801a07:	89 34 24             	mov    %esi,(%esp)
  801a0a:	e8 51 02 00 00       	call   801c60 <nsipc_close>
		return r;
  801a0f:	89 d8                	mov    %ebx,%eax
  801a11:	eb 20                	jmp    801a33 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a13:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a21:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801a28:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801a2b:	89 14 24             	mov    %edx,(%esp)
  801a2e:	e8 3d f6 ff ff       	call   801070 <fd2num>
}
  801a33:	83 c4 20             	add    $0x20,%esp
  801a36:	5b                   	pop    %ebx
  801a37:	5e                   	pop    %esi
  801a38:	5d                   	pop    %ebp
  801a39:	c3                   	ret    

00801a3a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
  801a3d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	e8 51 ff ff ff       	call   801999 <fd2sockid>
		return r;
  801a48:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 23                	js     801a71 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a4e:	8b 55 10             	mov    0x10(%ebp),%edx
  801a51:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a58:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a5c:	89 04 24             	mov    %eax,(%esp)
  801a5f:	e8 45 01 00 00       	call   801ba9 <nsipc_accept>
		return r;
  801a64:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a66:	85 c0                	test   %eax,%eax
  801a68:	78 07                	js     801a71 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801a6a:	e8 5c ff ff ff       	call   8019cb <alloc_sockfd>
  801a6f:	89 c1                	mov    %eax,%ecx
}
  801a71:	89 c8                	mov    %ecx,%eax
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	e8 16 ff ff ff       	call   801999 <fd2sockid>
  801a83:	89 c2                	mov    %eax,%edx
  801a85:	85 d2                	test   %edx,%edx
  801a87:	78 16                	js     801a9f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a97:	89 14 24             	mov    %edx,(%esp)
  801a9a:	e8 60 01 00 00       	call   801bff <nsipc_bind>
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <shutdown>:

int
shutdown(int s, int how)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	e8 ea fe ff ff       	call   801999 <fd2sockid>
  801aaf:	89 c2                	mov    %eax,%edx
  801ab1:	85 d2                	test   %edx,%edx
  801ab3:	78 0f                	js     801ac4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ab5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abc:	89 14 24             	mov    %edx,(%esp)
  801abf:	e8 7a 01 00 00       	call   801c3e <nsipc_shutdown>
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	e8 c5 fe ff ff       	call   801999 <fd2sockid>
  801ad4:	89 c2                	mov    %eax,%edx
  801ad6:	85 d2                	test   %edx,%edx
  801ad8:	78 16                	js     801af0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801ada:	8b 45 10             	mov    0x10(%ebp),%eax
  801add:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae8:	89 14 24             	mov    %edx,(%esp)
  801aeb:	e8 8a 01 00 00       	call   801c7a <nsipc_connect>
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <listen>:

int
listen(int s, int backlog)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
  801af5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	e8 99 fe ff ff       	call   801999 <fd2sockid>
  801b00:	89 c2                	mov    %eax,%edx
  801b02:	85 d2                	test   %edx,%edx
  801b04:	78 0f                	js     801b15 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0d:	89 14 24             	mov    %edx,(%esp)
  801b10:	e8 a4 01 00 00       	call   801cb9 <nsipc_listen>
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
  801b1a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b20:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	89 04 24             	mov    %eax,(%esp)
  801b31:	e8 98 02 00 00       	call   801dce <nsipc_socket>
  801b36:	89 c2                	mov    %eax,%edx
  801b38:	85 d2                	test   %edx,%edx
  801b3a:	78 05                	js     801b41 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801b3c:	e8 8a fe ff ff       	call   8019cb <alloc_sockfd>
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	53                   	push   %ebx
  801b47:	83 ec 14             	sub    $0x14,%esp
  801b4a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b4c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b53:	75 11                	jne    801b66 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b55:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801b5c:	e8 8d 08 00 00       	call   8023ee <ipc_find_env>
  801b61:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b66:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b6d:	00 
  801b6e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b75:	00 
  801b76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b7a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b7f:	89 04 24             	mov    %eax,(%esp)
  801b82:	e8 09 08 00 00       	call   802390 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b87:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b8e:	00 
  801b8f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b96:	00 
  801b97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b9e:	e8 83 07 00 00       	call   802326 <ipc_recv>
}
  801ba3:	83 c4 14             	add    $0x14,%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    

00801ba9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	56                   	push   %esi
  801bad:	53                   	push   %ebx
  801bae:	83 ec 10             	sub    $0x10,%esp
  801bb1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bbc:	8b 06                	mov    (%esi),%eax
  801bbe:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bc8:	e8 76 ff ff ff       	call   801b43 <nsipc>
  801bcd:	89 c3                	mov    %eax,%ebx
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 23                	js     801bf6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bd3:	a1 10 60 80 00       	mov    0x806010,%eax
  801bd8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bdc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801be3:	00 
  801be4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be7:	89 04 24             	mov    %eax,(%esp)
  801bea:	e8 35 ee ff ff       	call   800a24 <memmove>
		*addrlen = ret->ret_addrlen;
  801bef:	a1 10 60 80 00       	mov    0x806010,%eax
  801bf4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801bf6:	89 d8                	mov    %ebx,%eax
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	5b                   	pop    %ebx
  801bfc:	5e                   	pop    %esi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    

00801bff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	53                   	push   %ebx
  801c03:	83 ec 14             	sub    $0x14,%esp
  801c06:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c11:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c23:	e8 fc ed ff ff       	call   800a24 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c28:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c2e:	b8 02 00 00 00       	mov    $0x2,%eax
  801c33:	e8 0b ff ff ff       	call   801b43 <nsipc>
}
  801c38:	83 c4 14             	add    $0x14,%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5d                   	pop    %ebp
  801c3d:	c3                   	ret    

00801c3e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c54:	b8 03 00 00 00       	mov    $0x3,%eax
  801c59:	e8 e5 fe ff ff       	call   801b43 <nsipc>
}
  801c5e:	c9                   	leave  
  801c5f:	c3                   	ret    

00801c60 <nsipc_close>:

int
nsipc_close(int s)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c6e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c73:	e8 cb fe ff ff       	call   801b43 <nsipc>
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	53                   	push   %ebx
  801c7e:	83 ec 14             	sub    $0x14,%esp
  801c81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c8c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c97:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c9e:	e8 81 ed ff ff       	call   800a24 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ca3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ca9:	b8 05 00 00 00       	mov    $0x5,%eax
  801cae:	e8 90 fe ff ff       	call   801b43 <nsipc>
}
  801cb3:	83 c4 14             	add    $0x14,%esp
  801cb6:	5b                   	pop    %ebx
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    

00801cb9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cca:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ccf:	b8 06 00 00 00       	mov    $0x6,%eax
  801cd4:	e8 6a fe ff ff       	call   801b43 <nsipc>
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	56                   	push   %esi
  801cdf:	53                   	push   %ebx
  801ce0:	83 ec 10             	sub    $0x10,%esp
  801ce3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cee:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cfc:	b8 07 00 00 00       	mov    $0x7,%eax
  801d01:	e8 3d fe ff ff       	call   801b43 <nsipc>
  801d06:	89 c3                	mov    %eax,%ebx
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	78 46                	js     801d52 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d0c:	39 f0                	cmp    %esi,%eax
  801d0e:	7f 07                	jg     801d17 <nsipc_recv+0x3c>
  801d10:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d15:	7e 24                	jle    801d3b <nsipc_recv+0x60>
  801d17:	c7 44 24 0c 07 2c 80 	movl   $0x802c07,0xc(%esp)
  801d1e:	00 
  801d1f:	c7 44 24 08 cf 2b 80 	movl   $0x802bcf,0x8(%esp)
  801d26:	00 
  801d27:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d2e:	00 
  801d2f:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  801d36:	e8 24 e4 ff ff       	call   80015f <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d3b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d3f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d46:	00 
  801d47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4a:	89 04 24             	mov    %eax,(%esp)
  801d4d:	e8 d2 ec ff ff       	call   800a24 <memmove>
	}

	return r;
}
  801d52:	89 d8                	mov    %ebx,%eax
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    

00801d5b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
  801d5e:	53                   	push   %ebx
  801d5f:	83 ec 14             	sub    $0x14,%esp
  801d62:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d65:	8b 45 08             	mov    0x8(%ebp),%eax
  801d68:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d6d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d73:	7e 24                	jle    801d99 <nsipc_send+0x3e>
  801d75:	c7 44 24 0c 28 2c 80 	movl   $0x802c28,0xc(%esp)
  801d7c:	00 
  801d7d:	c7 44 24 08 cf 2b 80 	movl   $0x802bcf,0x8(%esp)
  801d84:	00 
  801d85:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801d8c:	00 
  801d8d:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  801d94:	e8 c6 e3 ff ff       	call   80015f <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d99:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801dab:	e8 74 ec ff ff       	call   800a24 <memmove>
	nsipcbuf.send.req_size = size;
  801db0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801db6:	8b 45 14             	mov    0x14(%ebp),%eax
  801db9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dbe:	b8 08 00 00 00       	mov    $0x8,%eax
  801dc3:	e8 7b fd ff ff       	call   801b43 <nsipc>
}
  801dc8:	83 c4 14             	add    $0x14,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801de4:	8b 45 10             	mov    0x10(%ebp),%eax
  801de7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dec:	b8 09 00 00 00       	mov    $0x9,%eax
  801df1:	e8 4d fd ff ff       	call   801b43 <nsipc>
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	56                   	push   %esi
  801dfc:	53                   	push   %ebx
  801dfd:	83 ec 10             	sub    $0x10,%esp
  801e00:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	89 04 24             	mov    %eax,(%esp)
  801e09:	e8 72 f2 ff ff       	call   801080 <fd2data>
  801e0e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e10:	c7 44 24 04 34 2c 80 	movl   $0x802c34,0x4(%esp)
  801e17:	00 
  801e18:	89 1c 24             	mov    %ebx,(%esp)
  801e1b:	e8 67 ea ff ff       	call   800887 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e20:	8b 46 04             	mov    0x4(%esi),%eax
  801e23:	2b 06                	sub    (%esi),%eax
  801e25:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e2b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e32:	00 00 00 
	stat->st_dev = &devpipe;
  801e35:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e3c:	30 80 00 
	return 0;
}
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	5b                   	pop    %ebx
  801e48:	5e                   	pop    %esi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    

00801e4b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	53                   	push   %ebx
  801e4f:	83 ec 14             	sub    $0x14,%esp
  801e52:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e55:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e60:	e8 e5 ee ff ff       	call   800d4a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e65:	89 1c 24             	mov    %ebx,(%esp)
  801e68:	e8 13 f2 ff ff       	call   801080 <fd2data>
  801e6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e78:	e8 cd ee ff ff       	call   800d4a <sys_page_unmap>
}
  801e7d:	83 c4 14             	add    $0x14,%esp
  801e80:	5b                   	pop    %ebx
  801e81:	5d                   	pop    %ebp
  801e82:	c3                   	ret    

00801e83 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	57                   	push   %edi
  801e87:	56                   	push   %esi
  801e88:	53                   	push   %ebx
  801e89:	83 ec 2c             	sub    $0x2c,%esp
  801e8c:	89 c6                	mov    %eax,%esi
  801e8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e91:	a1 08 40 80 00       	mov    0x804008,%eax
  801e96:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e99:	89 34 24             	mov    %esi,(%esp)
  801e9c:	e8 85 05 00 00       	call   802426 <pageref>
  801ea1:	89 c7                	mov    %eax,%edi
  801ea3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ea6:	89 04 24             	mov    %eax,(%esp)
  801ea9:	e8 78 05 00 00       	call   802426 <pageref>
  801eae:	39 c7                	cmp    %eax,%edi
  801eb0:	0f 94 c2             	sete   %dl
  801eb3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801eb6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801ebc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801ebf:	39 fb                	cmp    %edi,%ebx
  801ec1:	74 21                	je     801ee4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801ec3:	84 d2                	test   %dl,%dl
  801ec5:	74 ca                	je     801e91 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ec7:	8b 51 58             	mov    0x58(%ecx),%edx
  801eca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ece:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ed2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ed6:	c7 04 24 3b 2c 80 00 	movl   $0x802c3b,(%esp)
  801edd:	e8 76 e3 ff ff       	call   800258 <cprintf>
  801ee2:	eb ad                	jmp    801e91 <_pipeisclosed+0xe>
	}
}
  801ee4:	83 c4 2c             	add    $0x2c,%esp
  801ee7:	5b                   	pop    %ebx
  801ee8:	5e                   	pop    %esi
  801ee9:	5f                   	pop    %edi
  801eea:	5d                   	pop    %ebp
  801eeb:	c3                   	ret    

00801eec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	57                   	push   %edi
  801ef0:	56                   	push   %esi
  801ef1:	53                   	push   %ebx
  801ef2:	83 ec 1c             	sub    $0x1c,%esp
  801ef5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ef8:	89 34 24             	mov    %esi,(%esp)
  801efb:	e8 80 f1 ff ff       	call   801080 <fd2data>
  801f00:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f02:	bf 00 00 00 00       	mov    $0x0,%edi
  801f07:	eb 45                	jmp    801f4e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f09:	89 da                	mov    %ebx,%edx
  801f0b:	89 f0                	mov    %esi,%eax
  801f0d:	e8 71 ff ff ff       	call   801e83 <_pipeisclosed>
  801f12:	85 c0                	test   %eax,%eax
  801f14:	75 41                	jne    801f57 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f16:	e8 69 ed ff ff       	call   800c84 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f1b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f1e:	8b 0b                	mov    (%ebx),%ecx
  801f20:	8d 51 20             	lea    0x20(%ecx),%edx
  801f23:	39 d0                	cmp    %edx,%eax
  801f25:	73 e2                	jae    801f09 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f2a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f2e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f31:	99                   	cltd   
  801f32:	c1 ea 1b             	shr    $0x1b,%edx
  801f35:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f38:	83 e1 1f             	and    $0x1f,%ecx
  801f3b:	29 d1                	sub    %edx,%ecx
  801f3d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f41:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f45:	83 c0 01             	add    $0x1,%eax
  801f48:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f4b:	83 c7 01             	add    $0x1,%edi
  801f4e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f51:	75 c8                	jne    801f1b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f53:	89 f8                	mov    %edi,%eax
  801f55:	eb 05                	jmp    801f5c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f5c:	83 c4 1c             	add    $0x1c,%esp
  801f5f:	5b                   	pop    %ebx
  801f60:	5e                   	pop    %esi
  801f61:	5f                   	pop    %edi
  801f62:	5d                   	pop    %ebp
  801f63:	c3                   	ret    

00801f64 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f64:	55                   	push   %ebp
  801f65:	89 e5                	mov    %esp,%ebp
  801f67:	57                   	push   %edi
  801f68:	56                   	push   %esi
  801f69:	53                   	push   %ebx
  801f6a:	83 ec 1c             	sub    $0x1c,%esp
  801f6d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f70:	89 3c 24             	mov    %edi,(%esp)
  801f73:	e8 08 f1 ff ff       	call   801080 <fd2data>
  801f78:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f7a:	be 00 00 00 00       	mov    $0x0,%esi
  801f7f:	eb 3d                	jmp    801fbe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f81:	85 f6                	test   %esi,%esi
  801f83:	74 04                	je     801f89 <devpipe_read+0x25>
				return i;
  801f85:	89 f0                	mov    %esi,%eax
  801f87:	eb 43                	jmp    801fcc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f89:	89 da                	mov    %ebx,%edx
  801f8b:	89 f8                	mov    %edi,%eax
  801f8d:	e8 f1 fe ff ff       	call   801e83 <_pipeisclosed>
  801f92:	85 c0                	test   %eax,%eax
  801f94:	75 31                	jne    801fc7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f96:	e8 e9 ec ff ff       	call   800c84 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f9b:	8b 03                	mov    (%ebx),%eax
  801f9d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801fa0:	74 df                	je     801f81 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801fa2:	99                   	cltd   
  801fa3:	c1 ea 1b             	shr    $0x1b,%edx
  801fa6:	01 d0                	add    %edx,%eax
  801fa8:	83 e0 1f             	and    $0x1f,%eax
  801fab:	29 d0                	sub    %edx,%eax
  801fad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fb5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fb8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fbb:	83 c6 01             	add    $0x1,%esi
  801fbe:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc1:	75 d8                	jne    801f9b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801fc3:	89 f0                	mov    %esi,%eax
  801fc5:	eb 05                	jmp    801fcc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801fcc:	83 c4 1c             	add    $0x1c,%esp
  801fcf:	5b                   	pop    %ebx
  801fd0:	5e                   	pop    %esi
  801fd1:	5f                   	pop    %edi
  801fd2:	5d                   	pop    %ebp
  801fd3:	c3                   	ret    

00801fd4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	56                   	push   %esi
  801fd8:	53                   	push   %ebx
  801fd9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdf:	89 04 24             	mov    %eax,(%esp)
  801fe2:	e8 b0 f0 ff ff       	call   801097 <fd_alloc>
  801fe7:	89 c2                	mov    %eax,%edx
  801fe9:	85 d2                	test   %edx,%edx
  801feb:	0f 88 4d 01 00 00    	js     80213e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ff8:	00 
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802000:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802007:	e8 97 ec ff ff       	call   800ca3 <sys_page_alloc>
  80200c:	89 c2                	mov    %eax,%edx
  80200e:	85 d2                	test   %edx,%edx
  802010:	0f 88 28 01 00 00    	js     80213e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802016:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802019:	89 04 24             	mov    %eax,(%esp)
  80201c:	e8 76 f0 ff ff       	call   801097 <fd_alloc>
  802021:	89 c3                	mov    %eax,%ebx
  802023:	85 c0                	test   %eax,%eax
  802025:	0f 88 fe 00 00 00    	js     802129 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802032:	00 
  802033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802036:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802041:	e8 5d ec ff ff       	call   800ca3 <sys_page_alloc>
  802046:	89 c3                	mov    %eax,%ebx
  802048:	85 c0                	test   %eax,%eax
  80204a:	0f 88 d9 00 00 00    	js     802129 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	89 04 24             	mov    %eax,(%esp)
  802056:	e8 25 f0 ff ff       	call   801080 <fd2data>
  80205b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80205d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802064:	00 
  802065:	89 44 24 04          	mov    %eax,0x4(%esp)
  802069:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802070:	e8 2e ec ff ff       	call   800ca3 <sys_page_alloc>
  802075:	89 c3                	mov    %eax,%ebx
  802077:	85 c0                	test   %eax,%eax
  802079:	0f 88 97 00 00 00    	js     802116 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80207f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802082:	89 04 24             	mov    %eax,(%esp)
  802085:	e8 f6 ef ff ff       	call   801080 <fd2data>
  80208a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802091:	00 
  802092:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802096:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80209d:	00 
  80209e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a9:	e8 49 ec ff ff       	call   800cf7 <sys_page_map>
  8020ae:	89 c3                	mov    %eax,%ebx
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	78 52                	js     802106 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8020b4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8020c9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8020de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e1:	89 04 24             	mov    %eax,(%esp)
  8020e4:	e8 87 ef ff ff       	call   801070 <fd2num>
  8020e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f1:	89 04 24             	mov    %eax,(%esp)
  8020f4:	e8 77 ef ff ff       	call   801070 <fd2num>
  8020f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020fc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802104:	eb 38                	jmp    80213e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802106:	89 74 24 04          	mov    %esi,0x4(%esp)
  80210a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802111:	e8 34 ec ff ff       	call   800d4a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802119:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802124:	e8 21 ec ff ff       	call   800d4a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802137:	e8 0e ec ff ff       	call   800d4a <sys_page_unmap>
  80213c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80213e:	83 c4 30             	add    $0x30,%esp
  802141:	5b                   	pop    %ebx
  802142:	5e                   	pop    %esi
  802143:	5d                   	pop    %ebp
  802144:	c3                   	ret    

00802145 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
  802148:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80214b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	89 04 24             	mov    %eax,(%esp)
  802158:	e8 89 ef ff ff       	call   8010e6 <fd_lookup>
  80215d:	89 c2                	mov    %eax,%edx
  80215f:	85 d2                	test   %edx,%edx
  802161:	78 15                	js     802178 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802166:	89 04 24             	mov    %eax,(%esp)
  802169:	e8 12 ef ff ff       	call   801080 <fd2data>
	return _pipeisclosed(fd, p);
  80216e:	89 c2                	mov    %eax,%edx
  802170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802173:	e8 0b fd ff ff       	call   801e83 <_pipeisclosed>
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    
  80217a:	66 90                	xchg   %ax,%ax
  80217c:	66 90                	xchg   %ax,%ax
  80217e:	66 90                	xchg   %ax,%ax

00802180 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802183:	b8 00 00 00 00       	mov    $0x0,%eax
  802188:	5d                   	pop    %ebp
  802189:	c3                   	ret    

0080218a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802190:	c7 44 24 04 53 2c 80 	movl   $0x802c53,0x4(%esp)
  802197:	00 
  802198:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219b:	89 04 24             	mov    %eax,(%esp)
  80219e:	e8 e4 e6 ff ff       	call   800887 <strcpy>
	return 0;
}
  8021a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	57                   	push   %edi
  8021ae:	56                   	push   %esi
  8021af:	53                   	push   %ebx
  8021b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021c1:	eb 31                	jmp    8021f4 <devcons_write+0x4a>
		m = n - tot;
  8021c3:	8b 75 10             	mov    0x10(%ebp),%esi
  8021c6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8021c8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8021cb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8021d0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8021d7:	03 45 0c             	add    0xc(%ebp),%eax
  8021da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021de:	89 3c 24             	mov    %edi,(%esp)
  8021e1:	e8 3e e8 ff ff       	call   800a24 <memmove>
		sys_cputs(buf, m);
  8021e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ea:	89 3c 24             	mov    %edi,(%esp)
  8021ed:	e8 e4 e9 ff ff       	call   800bd6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021f2:	01 f3                	add    %esi,%ebx
  8021f4:	89 d8                	mov    %ebx,%eax
  8021f6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8021f9:	72 c8                	jb     8021c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8021fb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802201:	5b                   	pop    %ebx
  802202:	5e                   	pop    %esi
  802203:	5f                   	pop    %edi
  802204:	5d                   	pop    %ebp
  802205:	c3                   	ret    

00802206 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80220c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802211:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802215:	75 07                	jne    80221e <devcons_read+0x18>
  802217:	eb 2a                	jmp    802243 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802219:	e8 66 ea ff ff       	call   800c84 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80221e:	66 90                	xchg   %ax,%ax
  802220:	e8 cf e9 ff ff       	call   800bf4 <sys_cgetc>
  802225:	85 c0                	test   %eax,%eax
  802227:	74 f0                	je     802219 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802229:	85 c0                	test   %eax,%eax
  80222b:	78 16                	js     802243 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80222d:	83 f8 04             	cmp    $0x4,%eax
  802230:	74 0c                	je     80223e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802232:	8b 55 0c             	mov    0xc(%ebp),%edx
  802235:	88 02                	mov    %al,(%edx)
	return 1;
  802237:	b8 01 00 00 00       	mov    $0x1,%eax
  80223c:	eb 05                	jmp    802243 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80223e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802251:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802258:	00 
  802259:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80225c:	89 04 24             	mov    %eax,(%esp)
  80225f:	e8 72 e9 ff ff       	call   800bd6 <sys_cputs>
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <getchar>:

int
getchar(void)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80226c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802273:	00 
  802274:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802277:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802282:	e8 f3 f0 ff ff       	call   80137a <read>
	if (r < 0)
  802287:	85 c0                	test   %eax,%eax
  802289:	78 0f                	js     80229a <getchar+0x34>
		return r;
	if (r < 1)
  80228b:	85 c0                	test   %eax,%eax
  80228d:	7e 06                	jle    802295 <getchar+0x2f>
		return -E_EOF;
	return c;
  80228f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802293:	eb 05                	jmp    80229a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802295:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	89 04 24             	mov    %eax,(%esp)
  8022af:	e8 32 ee ff ff       	call   8010e6 <fd_lookup>
  8022b4:	85 c0                	test   %eax,%eax
  8022b6:	78 11                	js     8022c9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022c1:	39 10                	cmp    %edx,(%eax)
  8022c3:	0f 94 c0             	sete   %al
  8022c6:	0f b6 c0             	movzbl %al,%eax
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <opencons>:

int
opencons(void)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022d4:	89 04 24             	mov    %eax,(%esp)
  8022d7:	e8 bb ed ff ff       	call   801097 <fd_alloc>
		return r;
  8022dc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	78 40                	js     802322 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022e9:	00 
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f8:	e8 a6 e9 ff ff       	call   800ca3 <sys_page_alloc>
		return r;
  8022fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022ff:	85 c0                	test   %eax,%eax
  802301:	78 1f                	js     802322 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802303:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802318:	89 04 24             	mov    %eax,(%esp)
  80231b:	e8 50 ed ff ff       	call   801070 <fd2num>
  802320:	89 c2                	mov    %eax,%edx
}
  802322:	89 d0                	mov    %edx,%eax
  802324:	c9                   	leave  
  802325:	c3                   	ret    

00802326 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	56                   	push   %esi
  80232a:	53                   	push   %ebx
  80232b:	83 ec 10             	sub    $0x10,%esp
  80232e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802331:	8b 45 0c             	mov    0xc(%ebp),%eax
  802334:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802337:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802339:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80233e:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802341:	89 04 24             	mov    %eax,(%esp)
  802344:	e8 70 eb ff ff       	call   800eb9 <sys_ipc_recv>
  802349:	85 c0                	test   %eax,%eax
  80234b:	75 1e                	jne    80236b <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80234d:	85 db                	test   %ebx,%ebx
  80234f:	74 0a                	je     80235b <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802351:	a1 08 40 80 00       	mov    0x804008,%eax
  802356:	8b 40 74             	mov    0x74(%eax),%eax
  802359:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80235b:	85 f6                	test   %esi,%esi
  80235d:	74 22                	je     802381 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80235f:	a1 08 40 80 00       	mov    0x804008,%eax
  802364:	8b 40 78             	mov    0x78(%eax),%eax
  802367:	89 06                	mov    %eax,(%esi)
  802369:	eb 16                	jmp    802381 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80236b:	85 f6                	test   %esi,%esi
  80236d:	74 06                	je     802375 <ipc_recv+0x4f>
				*perm_store = 0;
  80236f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802375:	85 db                	test   %ebx,%ebx
  802377:	74 10                	je     802389 <ipc_recv+0x63>
				*from_env_store=0;
  802379:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80237f:	eb 08                	jmp    802389 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802381:	a1 08 40 80 00       	mov    0x804008,%eax
  802386:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802389:	83 c4 10             	add    $0x10,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    

00802390 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	57                   	push   %edi
  802394:	56                   	push   %esi
  802395:	53                   	push   %ebx
  802396:	83 ec 1c             	sub    $0x1c,%esp
  802399:	8b 75 0c             	mov    0xc(%ebp),%esi
  80239c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80239f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8023a2:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8023a4:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8023a9:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8023ac:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023b4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	89 04 24             	mov    %eax,(%esp)
  8023be:	e8 d3 ea ff ff       	call   800e96 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8023c3:	eb 1c                	jmp    8023e1 <ipc_send+0x51>
	{
		sys_yield();
  8023c5:	e8 ba e8 ff ff       	call   800c84 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8023ca:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	89 04 24             	mov    %eax,(%esp)
  8023dc:	e8 b5 ea ff ff       	call   800e96 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8023e1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023e4:	74 df                	je     8023c5 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8023e6:	83 c4 1c             	add    $0x1c,%esp
  8023e9:	5b                   	pop    %ebx
  8023ea:	5e                   	pop    %esi
  8023eb:	5f                   	pop    %edi
  8023ec:	5d                   	pop    %ebp
  8023ed:	c3                   	ret    

008023ee <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
  8023f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023f4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023f9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023fc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802402:	8b 52 50             	mov    0x50(%edx),%edx
  802405:	39 ca                	cmp    %ecx,%edx
  802407:	75 0d                	jne    802416 <ipc_find_env+0x28>
			return envs[i].env_id;
  802409:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80240c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802411:	8b 40 40             	mov    0x40(%eax),%eax
  802414:	eb 0e                	jmp    802424 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802416:	83 c0 01             	add    $0x1,%eax
  802419:	3d 00 04 00 00       	cmp    $0x400,%eax
  80241e:	75 d9                	jne    8023f9 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802420:	66 b8 00 00          	mov    $0x0,%ax
}
  802424:	5d                   	pop    %ebp
  802425:	c3                   	ret    

00802426 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80242c:	89 d0                	mov    %edx,%eax
  80242e:	c1 e8 16             	shr    $0x16,%eax
  802431:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802438:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80243d:	f6 c1 01             	test   $0x1,%cl
  802440:	74 1d                	je     80245f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802442:	c1 ea 0c             	shr    $0xc,%edx
  802445:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80244c:	f6 c2 01             	test   $0x1,%dl
  80244f:	74 0e                	je     80245f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802451:	c1 ea 0c             	shr    $0xc,%edx
  802454:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80245b:	ef 
  80245c:	0f b7 c0             	movzwl %ax,%eax
}
  80245f:	5d                   	pop    %ebp
  802460:	c3                   	ret    
  802461:	66 90                	xchg   %ax,%ax
  802463:	66 90                	xchg   %ax,%ax
  802465:	66 90                	xchg   %ax,%ax
  802467:	66 90                	xchg   %ax,%ax
  802469:	66 90                	xchg   %ax,%ax
  80246b:	66 90                	xchg   %ax,%ax
  80246d:	66 90                	xchg   %ax,%ax
  80246f:	90                   	nop

00802470 <__udivdi3>:
  802470:	55                   	push   %ebp
  802471:	57                   	push   %edi
  802472:	56                   	push   %esi
  802473:	83 ec 0c             	sub    $0xc,%esp
  802476:	8b 44 24 28          	mov    0x28(%esp),%eax
  80247a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80247e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802482:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802486:	85 c0                	test   %eax,%eax
  802488:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80248c:	89 ea                	mov    %ebp,%edx
  80248e:	89 0c 24             	mov    %ecx,(%esp)
  802491:	75 2d                	jne    8024c0 <__udivdi3+0x50>
  802493:	39 e9                	cmp    %ebp,%ecx
  802495:	77 61                	ja     8024f8 <__udivdi3+0x88>
  802497:	85 c9                	test   %ecx,%ecx
  802499:	89 ce                	mov    %ecx,%esi
  80249b:	75 0b                	jne    8024a8 <__udivdi3+0x38>
  80249d:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a2:	31 d2                	xor    %edx,%edx
  8024a4:	f7 f1                	div    %ecx
  8024a6:	89 c6                	mov    %eax,%esi
  8024a8:	31 d2                	xor    %edx,%edx
  8024aa:	89 e8                	mov    %ebp,%eax
  8024ac:	f7 f6                	div    %esi
  8024ae:	89 c5                	mov    %eax,%ebp
  8024b0:	89 f8                	mov    %edi,%eax
  8024b2:	f7 f6                	div    %esi
  8024b4:	89 ea                	mov    %ebp,%edx
  8024b6:	83 c4 0c             	add    $0xc,%esp
  8024b9:	5e                   	pop    %esi
  8024ba:	5f                   	pop    %edi
  8024bb:	5d                   	pop    %ebp
  8024bc:	c3                   	ret    
  8024bd:	8d 76 00             	lea    0x0(%esi),%esi
  8024c0:	39 e8                	cmp    %ebp,%eax
  8024c2:	77 24                	ja     8024e8 <__udivdi3+0x78>
  8024c4:	0f bd e8             	bsr    %eax,%ebp
  8024c7:	83 f5 1f             	xor    $0x1f,%ebp
  8024ca:	75 3c                	jne    802508 <__udivdi3+0x98>
  8024cc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024d0:	39 34 24             	cmp    %esi,(%esp)
  8024d3:	0f 86 9f 00 00 00    	jbe    802578 <__udivdi3+0x108>
  8024d9:	39 d0                	cmp    %edx,%eax
  8024db:	0f 82 97 00 00 00    	jb     802578 <__udivdi3+0x108>
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	31 d2                	xor    %edx,%edx
  8024ea:	31 c0                	xor    %eax,%eax
  8024ec:	83 c4 0c             	add    $0xc,%esp
  8024ef:	5e                   	pop    %esi
  8024f0:	5f                   	pop    %edi
  8024f1:	5d                   	pop    %ebp
  8024f2:	c3                   	ret    
  8024f3:	90                   	nop
  8024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	89 f8                	mov    %edi,%eax
  8024fa:	f7 f1                	div    %ecx
  8024fc:	31 d2                	xor    %edx,%edx
  8024fe:	83 c4 0c             	add    $0xc,%esp
  802501:	5e                   	pop    %esi
  802502:	5f                   	pop    %edi
  802503:	5d                   	pop    %ebp
  802504:	c3                   	ret    
  802505:	8d 76 00             	lea    0x0(%esi),%esi
  802508:	89 e9                	mov    %ebp,%ecx
  80250a:	8b 3c 24             	mov    (%esp),%edi
  80250d:	d3 e0                	shl    %cl,%eax
  80250f:	89 c6                	mov    %eax,%esi
  802511:	b8 20 00 00 00       	mov    $0x20,%eax
  802516:	29 e8                	sub    %ebp,%eax
  802518:	89 c1                	mov    %eax,%ecx
  80251a:	d3 ef                	shr    %cl,%edi
  80251c:	89 e9                	mov    %ebp,%ecx
  80251e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802522:	8b 3c 24             	mov    (%esp),%edi
  802525:	09 74 24 08          	or     %esi,0x8(%esp)
  802529:	89 d6                	mov    %edx,%esi
  80252b:	d3 e7                	shl    %cl,%edi
  80252d:	89 c1                	mov    %eax,%ecx
  80252f:	89 3c 24             	mov    %edi,(%esp)
  802532:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802536:	d3 ee                	shr    %cl,%esi
  802538:	89 e9                	mov    %ebp,%ecx
  80253a:	d3 e2                	shl    %cl,%edx
  80253c:	89 c1                	mov    %eax,%ecx
  80253e:	d3 ef                	shr    %cl,%edi
  802540:	09 d7                	or     %edx,%edi
  802542:	89 f2                	mov    %esi,%edx
  802544:	89 f8                	mov    %edi,%eax
  802546:	f7 74 24 08          	divl   0x8(%esp)
  80254a:	89 d6                	mov    %edx,%esi
  80254c:	89 c7                	mov    %eax,%edi
  80254e:	f7 24 24             	mull   (%esp)
  802551:	39 d6                	cmp    %edx,%esi
  802553:	89 14 24             	mov    %edx,(%esp)
  802556:	72 30                	jb     802588 <__udivdi3+0x118>
  802558:	8b 54 24 04          	mov    0x4(%esp),%edx
  80255c:	89 e9                	mov    %ebp,%ecx
  80255e:	d3 e2                	shl    %cl,%edx
  802560:	39 c2                	cmp    %eax,%edx
  802562:	73 05                	jae    802569 <__udivdi3+0xf9>
  802564:	3b 34 24             	cmp    (%esp),%esi
  802567:	74 1f                	je     802588 <__udivdi3+0x118>
  802569:	89 f8                	mov    %edi,%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	e9 7a ff ff ff       	jmp    8024ec <__udivdi3+0x7c>
  802572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802578:	31 d2                	xor    %edx,%edx
  80257a:	b8 01 00 00 00       	mov    $0x1,%eax
  80257f:	e9 68 ff ff ff       	jmp    8024ec <__udivdi3+0x7c>
  802584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802588:	8d 47 ff             	lea    -0x1(%edi),%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	83 c4 0c             	add    $0xc,%esp
  802590:	5e                   	pop    %esi
  802591:	5f                   	pop    %edi
  802592:	5d                   	pop    %ebp
  802593:	c3                   	ret    
  802594:	66 90                	xchg   %ax,%ax
  802596:	66 90                	xchg   %ax,%ax
  802598:	66 90                	xchg   %ax,%ax
  80259a:	66 90                	xchg   %ax,%ax
  80259c:	66 90                	xchg   %ax,%ax
  80259e:	66 90                	xchg   %ax,%ax

008025a0 <__umoddi3>:
  8025a0:	55                   	push   %ebp
  8025a1:	57                   	push   %edi
  8025a2:	56                   	push   %esi
  8025a3:	83 ec 14             	sub    $0x14,%esp
  8025a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025aa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025ae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025b2:	89 c7                	mov    %eax,%edi
  8025b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025bc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025c0:	89 34 24             	mov    %esi,(%esp)
  8025c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	89 c2                	mov    %eax,%edx
  8025cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025cf:	75 17                	jne    8025e8 <__umoddi3+0x48>
  8025d1:	39 fe                	cmp    %edi,%esi
  8025d3:	76 4b                	jbe    802620 <__umoddi3+0x80>
  8025d5:	89 c8                	mov    %ecx,%eax
  8025d7:	89 fa                	mov    %edi,%edx
  8025d9:	f7 f6                	div    %esi
  8025db:	89 d0                	mov    %edx,%eax
  8025dd:	31 d2                	xor    %edx,%edx
  8025df:	83 c4 14             	add    $0x14,%esp
  8025e2:	5e                   	pop    %esi
  8025e3:	5f                   	pop    %edi
  8025e4:	5d                   	pop    %ebp
  8025e5:	c3                   	ret    
  8025e6:	66 90                	xchg   %ax,%ax
  8025e8:	39 f8                	cmp    %edi,%eax
  8025ea:	77 54                	ja     802640 <__umoddi3+0xa0>
  8025ec:	0f bd e8             	bsr    %eax,%ebp
  8025ef:	83 f5 1f             	xor    $0x1f,%ebp
  8025f2:	75 5c                	jne    802650 <__umoddi3+0xb0>
  8025f4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025f8:	39 3c 24             	cmp    %edi,(%esp)
  8025fb:	0f 87 e7 00 00 00    	ja     8026e8 <__umoddi3+0x148>
  802601:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802605:	29 f1                	sub    %esi,%ecx
  802607:	19 c7                	sbb    %eax,%edi
  802609:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80260d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802611:	8b 44 24 08          	mov    0x8(%esp),%eax
  802615:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802619:	83 c4 14             	add    $0x14,%esp
  80261c:	5e                   	pop    %esi
  80261d:	5f                   	pop    %edi
  80261e:	5d                   	pop    %ebp
  80261f:	c3                   	ret    
  802620:	85 f6                	test   %esi,%esi
  802622:	89 f5                	mov    %esi,%ebp
  802624:	75 0b                	jne    802631 <__umoddi3+0x91>
  802626:	b8 01 00 00 00       	mov    $0x1,%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	f7 f6                	div    %esi
  80262f:	89 c5                	mov    %eax,%ebp
  802631:	8b 44 24 04          	mov    0x4(%esp),%eax
  802635:	31 d2                	xor    %edx,%edx
  802637:	f7 f5                	div    %ebp
  802639:	89 c8                	mov    %ecx,%eax
  80263b:	f7 f5                	div    %ebp
  80263d:	eb 9c                	jmp    8025db <__umoddi3+0x3b>
  80263f:	90                   	nop
  802640:	89 c8                	mov    %ecx,%eax
  802642:	89 fa                	mov    %edi,%edx
  802644:	83 c4 14             	add    $0x14,%esp
  802647:	5e                   	pop    %esi
  802648:	5f                   	pop    %edi
  802649:	5d                   	pop    %ebp
  80264a:	c3                   	ret    
  80264b:	90                   	nop
  80264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802650:	8b 04 24             	mov    (%esp),%eax
  802653:	be 20 00 00 00       	mov    $0x20,%esi
  802658:	89 e9                	mov    %ebp,%ecx
  80265a:	29 ee                	sub    %ebp,%esi
  80265c:	d3 e2                	shl    %cl,%edx
  80265e:	89 f1                	mov    %esi,%ecx
  802660:	d3 e8                	shr    %cl,%eax
  802662:	89 e9                	mov    %ebp,%ecx
  802664:	89 44 24 04          	mov    %eax,0x4(%esp)
  802668:	8b 04 24             	mov    (%esp),%eax
  80266b:	09 54 24 04          	or     %edx,0x4(%esp)
  80266f:	89 fa                	mov    %edi,%edx
  802671:	d3 e0                	shl    %cl,%eax
  802673:	89 f1                	mov    %esi,%ecx
  802675:	89 44 24 08          	mov    %eax,0x8(%esp)
  802679:	8b 44 24 10          	mov    0x10(%esp),%eax
  80267d:	d3 ea                	shr    %cl,%edx
  80267f:	89 e9                	mov    %ebp,%ecx
  802681:	d3 e7                	shl    %cl,%edi
  802683:	89 f1                	mov    %esi,%ecx
  802685:	d3 e8                	shr    %cl,%eax
  802687:	89 e9                	mov    %ebp,%ecx
  802689:	09 f8                	or     %edi,%eax
  80268b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80268f:	f7 74 24 04          	divl   0x4(%esp)
  802693:	d3 e7                	shl    %cl,%edi
  802695:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802699:	89 d7                	mov    %edx,%edi
  80269b:	f7 64 24 08          	mull   0x8(%esp)
  80269f:	39 d7                	cmp    %edx,%edi
  8026a1:	89 c1                	mov    %eax,%ecx
  8026a3:	89 14 24             	mov    %edx,(%esp)
  8026a6:	72 2c                	jb     8026d4 <__umoddi3+0x134>
  8026a8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026ac:	72 22                	jb     8026d0 <__umoddi3+0x130>
  8026ae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026b2:	29 c8                	sub    %ecx,%eax
  8026b4:	19 d7                	sbb    %edx,%edi
  8026b6:	89 e9                	mov    %ebp,%ecx
  8026b8:	89 fa                	mov    %edi,%edx
  8026ba:	d3 e8                	shr    %cl,%eax
  8026bc:	89 f1                	mov    %esi,%ecx
  8026be:	d3 e2                	shl    %cl,%edx
  8026c0:	89 e9                	mov    %ebp,%ecx
  8026c2:	d3 ef                	shr    %cl,%edi
  8026c4:	09 d0                	or     %edx,%eax
  8026c6:	89 fa                	mov    %edi,%edx
  8026c8:	83 c4 14             	add    $0x14,%esp
  8026cb:	5e                   	pop    %esi
  8026cc:	5f                   	pop    %edi
  8026cd:	5d                   	pop    %ebp
  8026ce:	c3                   	ret    
  8026cf:	90                   	nop
  8026d0:	39 d7                	cmp    %edx,%edi
  8026d2:	75 da                	jne    8026ae <__umoddi3+0x10e>
  8026d4:	8b 14 24             	mov    (%esp),%edx
  8026d7:	89 c1                	mov    %eax,%ecx
  8026d9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026dd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026e1:	eb cb                	jmp    8026ae <__umoddi3+0x10e>
  8026e3:	90                   	nop
  8026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026ec:	0f 82 0f ff ff ff    	jb     802601 <__umoddi3+0x61>
  8026f2:	e9 1a ff ff ff       	jmp    802611 <__umoddi3+0x71>
