
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 af 00 00 00       	call   8000e0 <libmain>
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
  800043:	c7 04 24 e0 26 80 00 	movl   $0x8026e0,(%esp)
  80004a:	e8 f5 01 00 00       	call   800244 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 15 0c 00 00       	call   800c83 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 00 27 80 	movl   $0x802700,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 ea 26 80 00 	movl   $0x8026ea,(%esp)
  800091:	e8 b5 00 00 00       	call   80014b <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 2c 27 80 	movl   $0x80272c,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 48 07 00 00       	call   8007fa <snprintf>
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
  8000c5:	e8 e6 0e 00 00       	call   800fb0 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ca:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000d1:	00 
  8000d2:	c7 04 24 ef be ad de 	movl   $0xdeadbeef,(%esp)
  8000d9:	e8 d8 0a 00 00       	call   800bb6 <sys_cputs>
}
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 10             	sub    $0x10,%esp
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000ee:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000f5:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8000f8:	e8 48 0b 00 00       	call   800c45 <sys_getenvid>
  8000fd:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800102:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800105:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010a:	a3 08 40 80 00       	mov    %eax,0x804008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010f:	85 db                	test   %ebx,%ebx
  800111:	7e 07                	jle    80011a <libmain+0x3a>
		binaryname = argv[0];
  800113:	8b 06                	mov    (%esi),%eax
  800115:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80011a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80011e:	89 1c 24             	mov    %ebx,(%esp)
  800121:	e8 92 ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  800126:	e8 07 00 00 00       	call   800132 <exit>
}
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	5b                   	pop    %ebx
  80012f:	5e                   	pop    %esi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800138:	e8 ed 10 00 00       	call   80122a <close_all>
	sys_env_destroy(0);
  80013d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800144:	e8 aa 0a 00 00       	call   800bf3 <sys_env_destroy>
}
  800149:	c9                   	leave  
  80014a:	c3                   	ret    

0080014b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800153:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800156:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80015c:	e8 e4 0a 00 00       	call   800c45 <sys_getenvid>
  800161:	8b 55 0c             	mov    0xc(%ebp),%edx
  800164:	89 54 24 10          	mov    %edx,0x10(%esp)
  800168:	8b 55 08             	mov    0x8(%ebp),%edx
  80016b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80016f:	89 74 24 08          	mov    %esi,0x8(%esp)
  800173:	89 44 24 04          	mov    %eax,0x4(%esp)
  800177:	c7 04 24 58 27 80 00 	movl   $0x802758,(%esp)
  80017e:	e8 c1 00 00 00       	call   800244 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800183:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800187:	8b 45 10             	mov    0x10(%ebp),%eax
  80018a:	89 04 24             	mov    %eax,(%esp)
  80018d:	e8 51 00 00 00       	call   8001e3 <vcprintf>
	cprintf("\n");
  800192:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  800199:	e8 a6 00 00 00       	call   800244 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80019e:	cc                   	int3   
  80019f:	eb fd                	jmp    80019e <_panic+0x53>

008001a1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a1:	55                   	push   %ebp
  8001a2:	89 e5                	mov    %esp,%ebp
  8001a4:	53                   	push   %ebx
  8001a5:	83 ec 14             	sub    $0x14,%esp
  8001a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001ab:	8b 13                	mov    (%ebx),%edx
  8001ad:	8d 42 01             	lea    0x1(%edx),%eax
  8001b0:	89 03                	mov    %eax,(%ebx)
  8001b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001be:	75 19                	jne    8001d9 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001c0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001c7:	00 
  8001c8:	8d 43 08             	lea    0x8(%ebx),%eax
  8001cb:	89 04 24             	mov    %eax,(%esp)
  8001ce:	e8 e3 09 00 00       	call   800bb6 <sys_cputs>
		b->idx = 0;
  8001d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001d9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001dd:	83 c4 14             	add    $0x14,%esp
  8001e0:	5b                   	pop    %ebx
  8001e1:	5d                   	pop    %ebp
  8001e2:	c3                   	ret    

008001e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e3:	55                   	push   %ebp
  8001e4:	89 e5                	mov    %esp,%ebp
  8001e6:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f3:	00 00 00 
	b.cnt = 0;
  8001f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800200:	8b 45 0c             	mov    0xc(%ebp),%eax
  800203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80020e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800214:	89 44 24 04          	mov    %eax,0x4(%esp)
  800218:	c7 04 24 a1 01 80 00 	movl   $0x8001a1,(%esp)
  80021f:	e8 aa 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800224:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80022a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800234:	89 04 24             	mov    %eax,(%esp)
  800237:	e8 7a 09 00 00       	call   800bb6 <sys_cputs>

	return b.cnt;
}
  80023c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800242:	c9                   	leave  
  800243:	c3                   	ret    

00800244 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80024a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80024d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800251:	8b 45 08             	mov    0x8(%ebp),%eax
  800254:	89 04 24             	mov    %eax,(%esp)
  800257:	e8 87 ff ff ff       	call   8001e3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    
  80025e:	66 90                	xchg   %ax,%ax

00800260 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	83 ec 3c             	sub    $0x3c,%esp
  800269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80026c:	89 d7                	mov    %edx,%edi
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800274:	8b 45 0c             	mov    0xc(%ebp),%eax
  800277:	89 c3                	mov    %eax,%ebx
  800279:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80027c:	8b 45 10             	mov    0x10(%ebp),%eax
  80027f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
  800287:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80028a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80028d:	39 d9                	cmp    %ebx,%ecx
  80028f:	72 05                	jb     800296 <printnum+0x36>
  800291:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800294:	77 69                	ja     8002ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800296:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800299:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80029d:	83 ee 01             	sub    $0x1,%esi
  8002a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002ac:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002b0:	89 c3                	mov    %eax,%ebx
  8002b2:	89 d6                	mov    %edx,%esi
  8002b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c5:	89 04 24             	mov    %eax,(%esp)
  8002c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	e8 7c 21 00 00       	call   802450 <__udivdi3>
  8002d4:	89 d9                	mov    %ebx,%ecx
  8002d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002de:	89 04 24             	mov    %eax,(%esp)
  8002e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e5:	89 fa                	mov    %edi,%edx
  8002e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ea:	e8 71 ff ff ff       	call   800260 <printnum>
  8002ef:	eb 1b                	jmp    80030c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f8:	89 04 24             	mov    %eax,(%esp)
  8002fb:	ff d3                	call   *%ebx
  8002fd:	eb 03                	jmp    800302 <printnum+0xa2>
  8002ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800302:	83 ee 01             	sub    $0x1,%esi
  800305:	85 f6                	test   %esi,%esi
  800307:	7f e8                	jg     8002f1 <printnum+0x91>
  800309:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80030c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800310:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800314:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800317:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80031a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	e8 4c 22 00 00       	call   802580 <__umoddi3>
  800334:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800338:	0f be 80 7b 27 80 00 	movsbl 0x80277b(%eax),%eax
  80033f:	89 04 24             	mov    %eax,(%esp)
  800342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800345:	ff d0                	call   *%eax
}
  800347:	83 c4 3c             	add    $0x3c,%esp
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5f                   	pop    %edi
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800352:	83 fa 01             	cmp    $0x1,%edx
  800355:	7e 0e                	jle    800365 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800357:	8b 10                	mov    (%eax),%edx
  800359:	8d 4a 08             	lea    0x8(%edx),%ecx
  80035c:	89 08                	mov    %ecx,(%eax)
  80035e:	8b 02                	mov    (%edx),%eax
  800360:	8b 52 04             	mov    0x4(%edx),%edx
  800363:	eb 22                	jmp    800387 <getuint+0x38>
	else if (lflag)
  800365:	85 d2                	test   %edx,%edx
  800367:	74 10                	je     800379 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800369:	8b 10                	mov    (%eax),%edx
  80036b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80036e:	89 08                	mov    %ecx,(%eax)
  800370:	8b 02                	mov    (%edx),%eax
  800372:	ba 00 00 00 00       	mov    $0x0,%edx
  800377:	eb 0e                	jmp    800387 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 02                	mov    (%edx),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800387:	5d                   	pop    %ebp
  800388:	c3                   	ret    

00800389 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800393:	8b 10                	mov    (%eax),%edx
  800395:	3b 50 04             	cmp    0x4(%eax),%edx
  800398:	73 0a                	jae    8003a4 <sprintputch+0x1b>
		*b->buf++ = ch;
  80039a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80039d:	89 08                	mov    %ecx,(%eax)
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	88 02                	mov    %al,(%edx)
}
  8003a4:	5d                   	pop    %ebp
  8003a5:	c3                   	ret    

008003a6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	89 04 24             	mov    %eax,(%esp)
  8003c7:	e8 02 00 00 00       	call   8003ce <vprintfmt>
	va_end(ap);
}
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	56                   	push   %esi
  8003d3:	53                   	push   %ebx
  8003d4:	83 ec 3c             	sub    $0x3c,%esp
  8003d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003dd:	eb 14                	jmp    8003f3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	0f 84 b3 03 00 00    	je     80079a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003eb:	89 04 24             	mov    %eax,(%esp)
  8003ee:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003f1:	89 f3                	mov    %esi,%ebx
  8003f3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003f6:	0f b6 03             	movzbl (%ebx),%eax
  8003f9:	83 f8 25             	cmp    $0x25,%eax
  8003fc:	75 e1                	jne    8003df <vprintfmt+0x11>
  8003fe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800410:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800417:	ba 00 00 00 00       	mov    $0x0,%edx
  80041c:	eb 1d                	jmp    80043b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800420:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800424:	eb 15                	jmp    80043b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800426:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800428:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80042c:	eb 0d                	jmp    80043b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80042e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800431:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800434:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80043e:	0f b6 0e             	movzbl (%esi),%ecx
  800441:	0f b6 c1             	movzbl %cl,%eax
  800444:	83 e9 23             	sub    $0x23,%ecx
  800447:	80 f9 55             	cmp    $0x55,%cl
  80044a:	0f 87 2a 03 00 00    	ja     80077a <vprintfmt+0x3ac>
  800450:	0f b6 c9             	movzbl %cl,%ecx
  800453:	ff 24 8d c0 28 80 00 	jmp    *0x8028c0(,%ecx,4)
  80045a:	89 de                	mov    %ebx,%esi
  80045c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800461:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800464:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800468:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80046b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80046e:	83 fb 09             	cmp    $0x9,%ebx
  800471:	77 36                	ja     8004a9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800473:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800476:	eb e9                	jmp    800461 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8d 48 04             	lea    0x4(%eax),%ecx
  80047e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800486:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800488:	eb 22                	jmp    8004ac <vprintfmt+0xde>
  80048a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80048d:	85 c9                	test   %ecx,%ecx
  80048f:	b8 00 00 00 00       	mov    $0x0,%eax
  800494:	0f 49 c1             	cmovns %ecx,%eax
  800497:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	89 de                	mov    %ebx,%esi
  80049c:	eb 9d                	jmp    80043b <vprintfmt+0x6d>
  80049e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004a0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004a7:	eb 92                	jmp    80043b <vprintfmt+0x6d>
  8004a9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004b0:	79 89                	jns    80043b <vprintfmt+0x6d>
  8004b2:	e9 77 ff ff ff       	jmp    80042e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004b7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004bc:	e9 7a ff ff ff       	jmp    80043b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8d 50 04             	lea    0x4(%eax),%edx
  8004c7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	89 04 24             	mov    %eax,(%esp)
  8004d3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004d6:	e9 18 ff ff ff       	jmp    8003f3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	99                   	cltd   
  8004e7:	31 d0                	xor    %edx,%eax
  8004e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004eb:	83 f8 0f             	cmp    $0xf,%eax
  8004ee:	7f 0b                	jg     8004fb <vprintfmt+0x12d>
  8004f0:	8b 14 85 20 2a 80 00 	mov    0x802a20(,%eax,4),%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	75 20                	jne    80051b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ff:	c7 44 24 08 93 27 80 	movl   $0x802793,0x8(%esp)
  800506:	00 
  800507:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	89 04 24             	mov    %eax,(%esp)
  800511:	e8 90 fe ff ff       	call   8003a6 <printfmt>
  800516:	e9 d8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80051b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80051f:	c7 44 24 08 c1 2b 80 	movl   $0x802bc1,0x8(%esp)
  800526:	00 
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	e8 70 fe ff ff       	call   8003a6 <printfmt>
  800536:	e9 b8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80053e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800541:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 50 04             	lea    0x4(%eax),%edx
  80054a:	89 55 14             	mov    %edx,0x14(%ebp)
  80054d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80054f:	85 f6                	test   %esi,%esi
  800551:	b8 8c 27 80 00       	mov    $0x80278c,%eax
  800556:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800559:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80055d:	0f 84 97 00 00 00    	je     8005fa <vprintfmt+0x22c>
  800563:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800567:	0f 8e 9b 00 00 00    	jle    800608 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800571:	89 34 24             	mov    %esi,(%esp)
  800574:	e8 cf 02 00 00       	call   800848 <strnlen>
  800579:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80057c:	29 c2                	sub    %eax,%edx
  80057e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800581:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800585:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800588:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80058b:	8b 75 08             	mov    0x8(%ebp),%esi
  80058e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800591:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	eb 0f                	jmp    8005a4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800595:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800599:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80059c:	89 04 24             	mov    %eax,(%esp)
  80059f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a1:	83 eb 01             	sub    $0x1,%ebx
  8005a4:	85 db                	test   %ebx,%ebx
  8005a6:	7f ed                	jg     800595 <vprintfmt+0x1c7>
  8005a8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005ab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ae:	85 d2                	test   %edx,%edx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	0f 49 c2             	cmovns %edx,%eax
  8005b8:	29 c2                	sub    %eax,%edx
  8005ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005bd:	89 d7                	mov    %edx,%edi
  8005bf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c2:	eb 50                	jmp    800614 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c8:	74 1e                	je     8005e8 <vprintfmt+0x21a>
  8005ca:	0f be d2             	movsbl %dl,%edx
  8005cd:	83 ea 20             	sub    $0x20,%edx
  8005d0:	83 fa 5e             	cmp    $0x5e,%edx
  8005d3:	76 13                	jbe    8005e8 <vprintfmt+0x21a>
					putch('?', putdat);
  8005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005dc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005e3:	ff 55 08             	call   *0x8(%ebp)
  8005e6:	eb 0d                	jmp    8005f5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ef:	89 04 24             	mov    %eax,(%esp)
  8005f2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f5:	83 ef 01             	sub    $0x1,%edi
  8005f8:	eb 1a                	jmp    800614 <vprintfmt+0x246>
  8005fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005fd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800600:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800603:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800606:	eb 0c                	jmp    800614 <vprintfmt+0x246>
  800608:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80060b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80060e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800611:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800614:	83 c6 01             	add    $0x1,%esi
  800617:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80061b:	0f be c2             	movsbl %dl,%eax
  80061e:	85 c0                	test   %eax,%eax
  800620:	74 27                	je     800649 <vprintfmt+0x27b>
  800622:	85 db                	test   %ebx,%ebx
  800624:	78 9e                	js     8005c4 <vprintfmt+0x1f6>
  800626:	83 eb 01             	sub    $0x1,%ebx
  800629:	79 99                	jns    8005c4 <vprintfmt+0x1f6>
  80062b:	89 f8                	mov    %edi,%eax
  80062d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800630:	8b 75 08             	mov    0x8(%ebp),%esi
  800633:	89 c3                	mov    %eax,%ebx
  800635:	eb 1a                	jmp    800651 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800642:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800644:	83 eb 01             	sub    $0x1,%ebx
  800647:	eb 08                	jmp    800651 <vprintfmt+0x283>
  800649:	89 fb                	mov    %edi,%ebx
  80064b:	8b 75 08             	mov    0x8(%ebp),%esi
  80064e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800651:	85 db                	test   %ebx,%ebx
  800653:	7f e2                	jg     800637 <vprintfmt+0x269>
  800655:	89 75 08             	mov    %esi,0x8(%ebp)
  800658:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80065b:	e9 93 fd ff ff       	jmp    8003f3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800660:	83 fa 01             	cmp    $0x1,%edx
  800663:	7e 16                	jle    80067b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 50 08             	lea    0x8(%eax),%edx
  80066b:	89 55 14             	mov    %edx,0x14(%ebp)
  80066e:	8b 50 04             	mov    0x4(%eax),%edx
  800671:	8b 00                	mov    (%eax),%eax
  800673:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800676:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800679:	eb 32                	jmp    8006ad <vprintfmt+0x2df>
	else if (lflag)
  80067b:	85 d2                	test   %edx,%edx
  80067d:	74 18                	je     800697 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 50 04             	lea    0x4(%eax),%edx
  800685:	89 55 14             	mov    %edx,0x14(%ebp)
  800688:	8b 30                	mov    (%eax),%esi
  80068a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80068d:	89 f0                	mov    %esi,%eax
  80068f:	c1 f8 1f             	sar    $0x1f,%eax
  800692:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800695:	eb 16                	jmp    8006ad <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 50 04             	lea    0x4(%eax),%edx
  80069d:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a0:	8b 30                	mov    (%eax),%esi
  8006a2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006a5:	89 f0                	mov    %esi,%eax
  8006a7:	c1 f8 1f             	sar    $0x1f,%eax
  8006aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bc:	0f 89 80 00 00 00    	jns    800742 <vprintfmt+0x374>
				putch('-', putdat);
  8006c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006cd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006d6:	f7 d8                	neg    %eax
  8006d8:	83 d2 00             	adc    $0x0,%edx
  8006db:	f7 da                	neg    %edx
			}
			base = 10;
  8006dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006e2:	eb 5e                	jmp    800742 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e7:	e8 63 fc ff ff       	call   80034f <getuint>
			base = 10;
  8006ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006f1:	eb 4f                	jmp    800742 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  8006f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f6:	e8 54 fc ff ff       	call   80034f <getuint>
			base =8;
  8006fb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800700:	eb 40                	jmp    800742 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800702:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800706:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80070d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800710:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800714:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80071b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 50 04             	lea    0x4(%eax),%edx
  800724:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800727:	8b 00                	mov    (%eax),%eax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80072e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800733:	eb 0d                	jmp    800742 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800735:	8d 45 14             	lea    0x14(%ebp),%eax
  800738:	e8 12 fc ff ff       	call   80034f <getuint>
			base = 16;
  80073d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800742:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800746:	89 74 24 10          	mov    %esi,0x10(%esp)
  80074a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80074d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800751:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800755:	89 04 24             	mov    %eax,(%esp)
  800758:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075c:	89 fa                	mov    %edi,%edx
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	e8 fa fa ff ff       	call   800260 <printnum>
			break;
  800766:	e9 88 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80076b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076f:	89 04 24             	mov    %eax,(%esp)
  800772:	ff 55 08             	call   *0x8(%ebp)
			break;
  800775:	e9 79 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80077a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800785:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800788:	89 f3                	mov    %esi,%ebx
  80078a:	eb 03                	jmp    80078f <vprintfmt+0x3c1>
  80078c:	83 eb 01             	sub    $0x1,%ebx
  80078f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800793:	75 f7                	jne    80078c <vprintfmt+0x3be>
  800795:	e9 59 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80079a:	83 c4 3c             	add    $0x3c,%esp
  80079d:	5b                   	pop    %ebx
  80079e:	5e                   	pop    %esi
  80079f:	5f                   	pop    %edi
  8007a0:	5d                   	pop    %ebp
  8007a1:	c3                   	ret    

008007a2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 28             	sub    $0x28,%esp
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	74 30                	je     8007f3 <vsnprintf+0x51>
  8007c3:	85 d2                	test   %edx,%edx
  8007c5:	7e 2c                	jle    8007f3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007dc:	c7 04 24 89 03 80 00 	movl   $0x800389,(%esp)
  8007e3:	e8 e6 fb ff ff       	call   8003ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f1:	eb 05                	jmp    8007f8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800803:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800807:	8b 45 10             	mov    0x10(%ebp),%eax
  80080a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800811:	89 44 24 04          	mov    %eax,0x4(%esp)
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 04 24             	mov    %eax,(%esp)
  80081b:	e8 82 ff ff ff       	call   8007a2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800820:	c9                   	leave  
  800821:	c3                   	ret    
  800822:	66 90                	xchg   %ax,%ax
  800824:	66 90                	xchg   %ax,%ax
  800826:	66 90                	xchg   %ax,%ax
  800828:	66 90                	xchg   %ax,%ax
  80082a:	66 90                	xchg   %ax,%ax
  80082c:	66 90                	xchg   %ax,%ax
  80082e:	66 90                	xchg   %ax,%ax

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	eb 03                	jmp    800840 <strlen+0x10>
		n++;
  80083d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800840:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800844:	75 f7                	jne    80083d <strlen+0xd>
		n++;
	return n;
}
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800851:	b8 00 00 00 00       	mov    $0x0,%eax
  800856:	eb 03                	jmp    80085b <strnlen+0x13>
		n++;
  800858:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085b:	39 d0                	cmp    %edx,%eax
  80085d:	74 06                	je     800865 <strnlen+0x1d>
  80085f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800863:	75 f3                	jne    800858 <strnlen+0x10>
		n++;
	return n;
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800871:	89 c2                	mov    %eax,%edx
  800873:	83 c2 01             	add    $0x1,%edx
  800876:	83 c1 01             	add    $0x1,%ecx
  800879:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80087d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800880:	84 db                	test   %bl,%bl
  800882:	75 ef                	jne    800873 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800884:	5b                   	pop    %ebx
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	53                   	push   %ebx
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800891:	89 1c 24             	mov    %ebx,(%esp)
  800894:	e8 97 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  800899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008a0:	01 d8                	add    %ebx,%eax
  8008a2:	89 04 24             	mov    %eax,(%esp)
  8008a5:	e8 bd ff ff ff       	call   800867 <strcpy>
	return dst;
}
  8008aa:	89 d8                	mov    %ebx,%eax
  8008ac:	83 c4 08             	add    $0x8,%esp
  8008af:	5b                   	pop    %ebx
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bd:	89 f3                	mov    %esi,%ebx
  8008bf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c2:	89 f2                	mov    %esi,%edx
  8008c4:	eb 0f                	jmp    8008d5 <strncpy+0x23>
		*dst++ = *src;
  8008c6:	83 c2 01             	add    $0x1,%edx
  8008c9:	0f b6 01             	movzbl (%ecx),%eax
  8008cc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008cf:	80 39 01             	cmpb   $0x1,(%ecx)
  8008d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d5:	39 da                	cmp    %ebx,%edx
  8008d7:	75 ed                	jne    8008c6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008d9:	89 f0                	mov    %esi,%eax
  8008db:	5b                   	pop    %ebx
  8008dc:	5e                   	pop    %esi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	56                   	push   %esi
  8008e3:	53                   	push   %ebx
  8008e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ed:	89 f0                	mov    %esi,%eax
  8008ef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f3:	85 c9                	test   %ecx,%ecx
  8008f5:	75 0b                	jne    800902 <strlcpy+0x23>
  8008f7:	eb 1d                	jmp    800916 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	83 c2 01             	add    $0x1,%edx
  8008ff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800902:	39 d8                	cmp    %ebx,%eax
  800904:	74 0b                	je     800911 <strlcpy+0x32>
  800906:	0f b6 0a             	movzbl (%edx),%ecx
  800909:	84 c9                	test   %cl,%cl
  80090b:	75 ec                	jne    8008f9 <strlcpy+0x1a>
  80090d:	89 c2                	mov    %eax,%edx
  80090f:	eb 02                	jmp    800913 <strlcpy+0x34>
  800911:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800913:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800916:	29 f0                	sub    %esi,%eax
}
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800925:	eb 06                	jmp    80092d <strcmp+0x11>
		p++, q++;
  800927:	83 c1 01             	add    $0x1,%ecx
  80092a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80092d:	0f b6 01             	movzbl (%ecx),%eax
  800930:	84 c0                	test   %al,%al
  800932:	74 04                	je     800938 <strcmp+0x1c>
  800934:	3a 02                	cmp    (%edx),%al
  800936:	74 ef                	je     800927 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	0f b6 12             	movzbl (%edx),%edx
  80093e:	29 d0                	sub    %edx,%eax
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800951:	eb 06                	jmp    800959 <strncmp+0x17>
		n--, p++, q++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800959:	39 d8                	cmp    %ebx,%eax
  80095b:	74 15                	je     800972 <strncmp+0x30>
  80095d:	0f b6 08             	movzbl (%eax),%ecx
  800960:	84 c9                	test   %cl,%cl
  800962:	74 04                	je     800968 <strncmp+0x26>
  800964:	3a 0a                	cmp    (%edx),%cl
  800966:	74 eb                	je     800953 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 00             	movzbl (%eax),%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
  800970:	eb 05                	jmp    800977 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800977:	5b                   	pop    %ebx
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800984:	eb 07                	jmp    80098d <strchr+0x13>
		if (*s == c)
  800986:	38 ca                	cmp    %cl,%dl
  800988:	74 0f                	je     800999 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	0f b6 10             	movzbl (%eax),%edx
  800990:	84 d2                	test   %dl,%dl
  800992:	75 f2                	jne    800986 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a5:	eb 07                	jmp    8009ae <strfind+0x13>
		if (*s == c)
  8009a7:	38 ca                	cmp    %cl,%dl
  8009a9:	74 0a                	je     8009b5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	0f b6 10             	movzbl (%eax),%edx
  8009b1:	84 d2                	test   %dl,%dl
  8009b3:	75 f2                	jne    8009a7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	57                   	push   %edi
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c3:	85 c9                	test   %ecx,%ecx
  8009c5:	74 36                	je     8009fd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009cd:	75 28                	jne    8009f7 <memset+0x40>
  8009cf:	f6 c1 03             	test   $0x3,%cl
  8009d2:	75 23                	jne    8009f7 <memset+0x40>
		c &= 0xFF;
  8009d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d8:	89 d3                	mov    %edx,%ebx
  8009da:	c1 e3 08             	shl    $0x8,%ebx
  8009dd:	89 d6                	mov    %edx,%esi
  8009df:	c1 e6 18             	shl    $0x18,%esi
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	c1 e0 10             	shl    $0x10,%eax
  8009e7:	09 f0                	or     %esi,%eax
  8009e9:	09 c2                	or     %eax,%edx
  8009eb:	89 d0                	mov    %edx,%eax
  8009ed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009f2:	fc                   	cld    
  8009f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f5:	eb 06                	jmp    8009fd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fa:	fc                   	cld    
  8009fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fd:	89 f8                	mov    %edi,%eax
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	57                   	push   %edi
  800a08:	56                   	push   %esi
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a12:	39 c6                	cmp    %eax,%esi
  800a14:	73 35                	jae    800a4b <memmove+0x47>
  800a16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a19:	39 d0                	cmp    %edx,%eax
  800a1b:	73 2e                	jae    800a4b <memmove+0x47>
		s += n;
		d += n;
  800a1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a20:	89 d6                	mov    %edx,%esi
  800a22:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2a:	75 13                	jne    800a3f <memmove+0x3b>
  800a2c:	f6 c1 03             	test   $0x3,%cl
  800a2f:	75 0e                	jne    800a3f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a31:	83 ef 04             	sub    $0x4,%edi
  800a34:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a37:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a3a:	fd                   	std    
  800a3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3d:	eb 09                	jmp    800a48 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3f:	83 ef 01             	sub    $0x1,%edi
  800a42:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a45:	fd                   	std    
  800a46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a48:	fc                   	cld    
  800a49:	eb 1d                	jmp    800a68 <memmove+0x64>
  800a4b:	89 f2                	mov    %esi,%edx
  800a4d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4f:	f6 c2 03             	test   $0x3,%dl
  800a52:	75 0f                	jne    800a63 <memmove+0x5f>
  800a54:	f6 c1 03             	test   $0x3,%cl
  800a57:	75 0a                	jne    800a63 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a59:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a5c:	89 c7                	mov    %eax,%edi
  800a5e:	fc                   	cld    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb 05                	jmp    800a68 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a68:	5e                   	pop    %esi
  800a69:	5f                   	pop    %edi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
  800a75:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 04 24             	mov    %eax,(%esp)
  800a86:	e8 79 ff ff ff       	call   800a04 <memmove>
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	56                   	push   %esi
  800a91:	53                   	push   %ebx
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
  800a95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a98:	89 d6                	mov    %edx,%esi
  800a9a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9d:	eb 1a                	jmp    800ab9 <memcmp+0x2c>
		if (*s1 != *s2)
  800a9f:	0f b6 02             	movzbl (%edx),%eax
  800aa2:	0f b6 19             	movzbl (%ecx),%ebx
  800aa5:	38 d8                	cmp    %bl,%al
  800aa7:	74 0a                	je     800ab3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800aa9:	0f b6 c0             	movzbl %al,%eax
  800aac:	0f b6 db             	movzbl %bl,%ebx
  800aaf:	29 d8                	sub    %ebx,%eax
  800ab1:	eb 0f                	jmp    800ac2 <memcmp+0x35>
		s1++, s2++;
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ab9:	39 f2                	cmp    %esi,%edx
  800abb:	75 e2                	jne    800a9f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800abd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad4:	eb 07                	jmp    800add <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad6:	38 08                	cmp    %cl,(%eax)
  800ad8:	74 07                	je     800ae1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	39 d0                	cmp    %edx,%eax
  800adf:	72 f5                	jb     800ad6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	57                   	push   %edi
  800ae7:	56                   	push   %esi
  800ae8:	53                   	push   %ebx
  800ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aef:	eb 03                	jmp    800af4 <strtol+0x11>
		s++;
  800af1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af4:	0f b6 0a             	movzbl (%edx),%ecx
  800af7:	80 f9 09             	cmp    $0x9,%cl
  800afa:	74 f5                	je     800af1 <strtol+0xe>
  800afc:	80 f9 20             	cmp    $0x20,%cl
  800aff:	74 f0                	je     800af1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b01:	80 f9 2b             	cmp    $0x2b,%cl
  800b04:	75 0a                	jne    800b10 <strtol+0x2d>
		s++;
  800b06:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b09:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0e:	eb 11                	jmp    800b21 <strtol+0x3e>
  800b10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b15:	80 f9 2d             	cmp    $0x2d,%cl
  800b18:	75 07                	jne    800b21 <strtol+0x3e>
		s++, neg = 1;
  800b1a:	8d 52 01             	lea    0x1(%edx),%edx
  800b1d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b21:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b26:	75 15                	jne    800b3d <strtol+0x5a>
  800b28:	80 3a 30             	cmpb   $0x30,(%edx)
  800b2b:	75 10                	jne    800b3d <strtol+0x5a>
  800b2d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b31:	75 0a                	jne    800b3d <strtol+0x5a>
		s += 2, base = 16;
  800b33:	83 c2 02             	add    $0x2,%edx
  800b36:	b8 10 00 00 00       	mov    $0x10,%eax
  800b3b:	eb 10                	jmp    800b4d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b3d:	85 c0                	test   %eax,%eax
  800b3f:	75 0c                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b41:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b43:	80 3a 30             	cmpb   $0x30,(%edx)
  800b46:	75 05                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
  800b48:	83 c2 01             	add    $0x1,%edx
  800b4b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b52:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b55:	0f b6 0a             	movzbl (%edx),%ecx
  800b58:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b5b:	89 f0                	mov    %esi,%eax
  800b5d:	3c 09                	cmp    $0x9,%al
  800b5f:	77 08                	ja     800b69 <strtol+0x86>
			dig = *s - '0';
  800b61:	0f be c9             	movsbl %cl,%ecx
  800b64:	83 e9 30             	sub    $0x30,%ecx
  800b67:	eb 20                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b69:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b6c:	89 f0                	mov    %esi,%eax
  800b6e:	3c 19                	cmp    $0x19,%al
  800b70:	77 08                	ja     800b7a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b72:	0f be c9             	movsbl %cl,%ecx
  800b75:	83 e9 57             	sub    $0x57,%ecx
  800b78:	eb 0f                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b7a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	3c 19                	cmp    $0x19,%al
  800b81:	77 16                	ja     800b99 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b83:	0f be c9             	movsbl %cl,%ecx
  800b86:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b89:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b8c:	7d 0f                	jge    800b9d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b95:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b97:	eb bc                	jmp    800b55 <strtol+0x72>
  800b99:	89 d8                	mov    %ebx,%eax
  800b9b:	eb 02                	jmp    800b9f <strtol+0xbc>
  800b9d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba3:	74 05                	je     800baa <strtol+0xc7>
		*endptr = (char *) s;
  800ba5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800baa:	f7 d8                	neg    %eax
  800bac:	85 ff                	test   %edi,%edi
  800bae:	0f 44 c3             	cmove  %ebx,%eax
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bda:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdf:	b8 01 00 00 00       	mov    $0x1,%eax
  800be4:	89 d1                	mov    %edx,%ecx
  800be6:	89 d3                	mov    %edx,%ebx
  800be8:	89 d7                	mov    %edx,%edi
  800bea:	89 d6                	mov    %edx,%esi
  800bec:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c01:	b8 03 00 00 00       	mov    $0x3,%eax
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	89 cb                	mov    %ecx,%ebx
  800c0b:	89 cf                	mov    %ecx,%edi
  800c0d:	89 ce                	mov    %ecx,%esi
  800c0f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	7e 28                	jle    800c3d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c19:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c20:	00 
  800c21:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800c28:	00 
  800c29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c30:	00 
  800c31:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800c38:	e8 0e f5 ff ff       	call   80014b <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3d:	83 c4 2c             	add    $0x2c,%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	57                   	push   %edi
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c50:	b8 02 00 00 00       	mov    $0x2,%eax
  800c55:	89 d1                	mov    %edx,%ecx
  800c57:	89 d3                	mov    %edx,%ebx
  800c59:	89 d7                	mov    %edx,%edi
  800c5b:	89 d6                	mov    %edx,%esi
  800c5d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <sys_yield>:

void
sys_yield(void)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	57                   	push   %edi
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c74:	89 d1                	mov    %edx,%ecx
  800c76:	89 d3                	mov    %edx,%ebx
  800c78:	89 d7                	mov    %edx,%edi
  800c7a:	89 d6                	mov    %edx,%esi
  800c7c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8c:	be 00 00 00 00       	mov    $0x0,%esi
  800c91:	b8 04 00 00 00       	mov    $0x4,%eax
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9f:	89 f7                	mov    %esi,%edi
  800ca1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	7e 28                	jle    800ccf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cab:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cb2:	00 
  800cb3:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800cba:	00 
  800cbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc2:	00 
  800cc3:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800cca:	e8 7c f4 ff ff       	call   80014b <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ccf:	83 c4 2c             	add    $0x2c,%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf1:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7e 28                	jle    800d22 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cfe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d05:	00 
  800d06:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800d0d:	00 
  800d0e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d15:	00 
  800d16:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800d1d:	e8 29 f4 ff ff       	call   80014b <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d22:	83 c4 2c             	add    $0x2c,%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7e 28                	jle    800d75 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d51:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d58:	00 
  800d59:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800d60:	00 
  800d61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d68:	00 
  800d69:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800d70:	e8 d6 f3 ff ff       	call   80014b <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d75:	83 c4 2c             	add    $0x2c,%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	89 df                	mov    %ebx,%edi
  800d98:	89 de                	mov    %ebx,%esi
  800d9a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7e 28                	jle    800dc8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dab:	00 
  800dac:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800db3:	00 
  800db4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbb:	00 
  800dbc:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800dc3:	e8 83 f3 ff ff       	call   80014b <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc8:	83 c4 2c             	add    $0x2c,%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dde:	b8 09 00 00 00       	mov    $0x9,%eax
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7e 28                	jle    800e1b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dfe:	00 
  800dff:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800e06:	00 
  800e07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0e:	00 
  800e0f:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800e16:	e8 30 f3 ff ff       	call   80014b <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e1b:	83 c4 2c             	add    $0x2c,%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	89 df                	mov    %ebx,%edi
  800e3e:	89 de                	mov    %ebx,%esi
  800e40:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e42:	85 c0                	test   %eax,%eax
  800e44:	7e 28                	jle    800e6e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e46:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e51:	00 
  800e52:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800e59:	00 
  800e5a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e61:	00 
  800e62:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800e69:	e8 dd f2 ff ff       	call   80014b <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e6e:	83 c4 2c             	add    $0x2c,%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7c:	be 00 00 00 00       	mov    $0x0,%esi
  800e81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e92:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	89 cb                	mov    %ecx,%ebx
  800eb1:	89 cf                	mov    %ecx,%edi
  800eb3:	89 ce                	mov    %ecx,%esi
  800eb5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7e 28                	jle    800ee3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ebf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ec6:	00 
  800ec7:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800ece:	00 
  800ecf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed6:	00 
  800ed7:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800ede:	e8 68 f2 ff ff       	call   80014b <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ee3:	83 c4 2c             	add    $0x2c,%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800efb:	89 d1                	mov    %edx,%ecx
  800efd:	89 d3                	mov    %edx,%ebx
  800eff:	89 d7                	mov    %edx,%edi
  800f01:	89 d6                	mov    %edx,%esi
  800f03:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f18:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	89 df                	mov    %ebx,%edi
  800f25:	89 de                	mov    %ebx,%esi
  800f27:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7e 28                	jle    800f55 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800f50:	e8 f6 f1 ff ff       	call   80014b <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800f55:	83 c4 2c             	add    $0x2c,%esp
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
  800f63:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	89 df                	mov    %ebx,%edi
  800f78:	89 de                	mov    %ebx,%esi
  800f7a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	7e 28                	jle    800fa8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f84:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 08 7f 2a 80 	movl   $0x802a7f,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 9c 2a 80 00 	movl   $0x802a9c,(%esp)
  800fa3:	e8 a3 f1 ff ff       	call   80014b <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  800fa8:	83 c4 2c             	add    $0x2c,%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  800fb6:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800fbd:	75 58                	jne    801017 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  800fbf:	a1 08 40 80 00       	mov    0x804008,%eax
  800fc4:	8b 40 48             	mov    0x48(%eax),%eax
  800fc7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fce:	00 
  800fcf:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800fd6:	ee 
  800fd7:	89 04 24             	mov    %eax,(%esp)
  800fda:	e8 a4 fc ff ff       	call   800c83 <sys_page_alloc>
		if(return_code!=0)
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	74 1c                	je     800fff <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  800fe3:	c7 44 24 08 ac 2a 80 	movl   $0x802aac,0x8(%esp)
  800fea:	00 
  800feb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff2:	00 
  800ff3:	c7 04 24 05 2b 80 00 	movl   $0x802b05,(%esp)
  800ffa:	e8 4c f1 ff ff       	call   80014b <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  800fff:	a1 08 40 80 00       	mov    0x804008,%eax
  801004:	8b 40 48             	mov    0x48(%eax),%eax
  801007:	c7 44 24 04 21 10 80 	movl   $0x801021,0x4(%esp)
  80100e:	00 
  80100f:	89 04 24             	mov    %eax,(%esp)
  801012:	e8 0c fe ff ff       	call   800e23 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  80101f:	c9                   	leave  
  801020:	c3                   	ret    

00801021 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801021:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801022:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801027:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801029:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  80102c:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  80102e:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  801032:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  801036:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  801037:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  801039:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  80103b:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  80103f:	58                   	pop    %eax
	popl %eax;
  801040:	58                   	pop    %eax
	popal;
  801041:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  801042:	83 c4 04             	add    $0x4,%esp
	popfl;
  801045:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  801046:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  801047:	c3                   	ret    
  801048:	66 90                	xchg   %ax,%ax
  80104a:	66 90                	xchg   %ax,%ax
  80104c:	66 90                	xchg   %ax,%ax
  80104e:	66 90                	xchg   %ax,%ax

00801050 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	05 00 00 00 30       	add    $0x30000000,%eax
  80105b:	c1 e8 0c             	shr    $0xc,%eax
}
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80106b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801070:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801082:	89 c2                	mov    %eax,%edx
  801084:	c1 ea 16             	shr    $0x16,%edx
  801087:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80108e:	f6 c2 01             	test   $0x1,%dl
  801091:	74 11                	je     8010a4 <fd_alloc+0x2d>
  801093:	89 c2                	mov    %eax,%edx
  801095:	c1 ea 0c             	shr    $0xc,%edx
  801098:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80109f:	f6 c2 01             	test   $0x1,%dl
  8010a2:	75 09                	jne    8010ad <fd_alloc+0x36>
			*fd_store = fd;
  8010a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ab:	eb 17                	jmp    8010c4 <fd_alloc+0x4d>
  8010ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010b7:	75 c9                	jne    801082 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010cc:	83 f8 1f             	cmp    $0x1f,%eax
  8010cf:	77 36                	ja     801107 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010d1:	c1 e0 0c             	shl    $0xc,%eax
  8010d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010d9:	89 c2                	mov    %eax,%edx
  8010db:	c1 ea 16             	shr    $0x16,%edx
  8010de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010e5:	f6 c2 01             	test   $0x1,%dl
  8010e8:	74 24                	je     80110e <fd_lookup+0x48>
  8010ea:	89 c2                	mov    %eax,%edx
  8010ec:	c1 ea 0c             	shr    $0xc,%edx
  8010ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f6:	f6 c2 01             	test   $0x1,%dl
  8010f9:	74 1a                	je     801115 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
  801105:	eb 13                	jmp    80111a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801107:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110c:	eb 0c                	jmp    80111a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80110e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801113:	eb 05                	jmp    80111a <fd_lookup+0x54>
  801115:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 18             	sub    $0x18,%esp
  801122:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801125:	ba 00 00 00 00       	mov    $0x0,%edx
  80112a:	eb 13                	jmp    80113f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80112c:	39 08                	cmp    %ecx,(%eax)
  80112e:	75 0c                	jne    80113c <dev_lookup+0x20>
			*dev = devtab[i];
  801130:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801133:	89 01                	mov    %eax,(%ecx)
			return 0;
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
  80113a:	eb 38                	jmp    801174 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80113c:	83 c2 01             	add    $0x1,%edx
  80113f:	8b 04 95 94 2b 80 00 	mov    0x802b94(,%edx,4),%eax
  801146:	85 c0                	test   %eax,%eax
  801148:	75 e2                	jne    80112c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80114a:	a1 08 40 80 00       	mov    0x804008,%eax
  80114f:	8b 40 48             	mov    0x48(%eax),%eax
  801152:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801156:	89 44 24 04          	mov    %eax,0x4(%esp)
  80115a:	c7 04 24 14 2b 80 00 	movl   $0x802b14,(%esp)
  801161:	e8 de f0 ff ff       	call   800244 <cprintf>
	*dev = 0;
  801166:	8b 45 0c             	mov    0xc(%ebp),%eax
  801169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80116f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	56                   	push   %esi
  80117a:	53                   	push   %ebx
  80117b:	83 ec 20             	sub    $0x20,%esp
  80117e:	8b 75 08             	mov    0x8(%ebp),%esi
  801181:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801184:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801187:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801191:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801194:	89 04 24             	mov    %eax,(%esp)
  801197:	e8 2a ff ff ff       	call   8010c6 <fd_lookup>
  80119c:	85 c0                	test   %eax,%eax
  80119e:	78 05                	js     8011a5 <fd_close+0x2f>
	    || fd != fd2)
  8011a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011a3:	74 0c                	je     8011b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011a5:	84 db                	test   %bl,%bl
  8011a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ac:	0f 44 c2             	cmove  %edx,%eax
  8011af:	eb 3f                	jmp    8011f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011b8:	8b 06                	mov    (%esi),%eax
  8011ba:	89 04 24             	mov    %eax,(%esp)
  8011bd:	e8 5a ff ff ff       	call   80111c <dev_lookup>
  8011c2:	89 c3                	mov    %eax,%ebx
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	78 16                	js     8011de <fd_close+0x68>
		if (dev->dev_close)
  8011c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	74 07                	je     8011de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011d7:	89 34 24             	mov    %esi,(%esp)
  8011da:	ff d0                	call   *%eax
  8011dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011e9:	e8 3c fb ff ff       	call   800d2a <sys_page_unmap>
	return r;
  8011ee:	89 d8                	mov    %ebx,%eax
}
  8011f0:	83 c4 20             	add    $0x20,%esp
  8011f3:	5b                   	pop    %ebx
  8011f4:	5e                   	pop    %esi
  8011f5:	5d                   	pop    %ebp
  8011f6:	c3                   	ret    

008011f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801200:	89 44 24 04          	mov    %eax,0x4(%esp)
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	89 04 24             	mov    %eax,(%esp)
  80120a:	e8 b7 fe ff ff       	call   8010c6 <fd_lookup>
  80120f:	89 c2                	mov    %eax,%edx
  801211:	85 d2                	test   %edx,%edx
  801213:	78 13                	js     801228 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801215:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80121c:	00 
  80121d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801220:	89 04 24             	mov    %eax,(%esp)
  801223:	e8 4e ff ff ff       	call   801176 <fd_close>
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <close_all>:

void
close_all(void)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	53                   	push   %ebx
  80122e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801231:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801236:	89 1c 24             	mov    %ebx,(%esp)
  801239:	e8 b9 ff ff ff       	call   8011f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80123e:	83 c3 01             	add    $0x1,%ebx
  801241:	83 fb 20             	cmp    $0x20,%ebx
  801244:	75 f0                	jne    801236 <close_all+0xc>
		close(i);
}
  801246:	83 c4 14             	add    $0x14,%esp
  801249:	5b                   	pop    %ebx
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	57                   	push   %edi
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
  801252:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801255:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 04 24             	mov    %eax,(%esp)
  801262:	e8 5f fe ff ff       	call   8010c6 <fd_lookup>
  801267:	89 c2                	mov    %eax,%edx
  801269:	85 d2                	test   %edx,%edx
  80126b:	0f 88 e1 00 00 00    	js     801352 <dup+0x106>
		return r;
	close(newfdnum);
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	89 04 24             	mov    %eax,(%esp)
  801277:	e8 7b ff ff ff       	call   8011f7 <close>

	newfd = INDEX2FD(newfdnum);
  80127c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80127f:	c1 e3 0c             	shl    $0xc,%ebx
  801282:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128b:	89 04 24             	mov    %eax,(%esp)
  80128e:	e8 cd fd ff ff       	call   801060 <fd2data>
  801293:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801295:	89 1c 24             	mov    %ebx,(%esp)
  801298:	e8 c3 fd ff ff       	call   801060 <fd2data>
  80129d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80129f:	89 f0                	mov    %esi,%eax
  8012a1:	c1 e8 16             	shr    $0x16,%eax
  8012a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ab:	a8 01                	test   $0x1,%al
  8012ad:	74 43                	je     8012f2 <dup+0xa6>
  8012af:	89 f0                	mov    %esi,%eax
  8012b1:	c1 e8 0c             	shr    $0xc,%eax
  8012b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012bb:	f6 c2 01             	test   $0x1,%dl
  8012be:	74 32                	je     8012f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012db:	00 
  8012dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e7:	e8 eb f9 ff ff       	call   800cd7 <sys_page_map>
  8012ec:	89 c6                	mov    %eax,%esi
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 3e                	js     801330 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f5:	89 c2                	mov    %eax,%edx
  8012f7:	c1 ea 0c             	shr    $0xc,%edx
  8012fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801301:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801307:	89 54 24 10          	mov    %edx,0x10(%esp)
  80130b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80130f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801316:	00 
  801317:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801322:	e8 b0 f9 ff ff       	call   800cd7 <sys_page_map>
  801327:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801329:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80132c:	85 f6                	test   %esi,%esi
  80132e:	79 22                	jns    801352 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801330:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801334:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133b:	e8 ea f9 ff ff       	call   800d2a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801340:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134b:	e8 da f9 ff ff       	call   800d2a <sys_page_unmap>
	return r;
  801350:	89 f0                	mov    %esi,%eax
}
  801352:	83 c4 3c             	add    $0x3c,%esp
  801355:	5b                   	pop    %ebx
  801356:	5e                   	pop    %esi
  801357:	5f                   	pop    %edi
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	53                   	push   %ebx
  80135e:	83 ec 24             	sub    $0x24,%esp
  801361:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801364:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136b:	89 1c 24             	mov    %ebx,(%esp)
  80136e:	e8 53 fd ff ff       	call   8010c6 <fd_lookup>
  801373:	89 c2                	mov    %eax,%edx
  801375:	85 d2                	test   %edx,%edx
  801377:	78 6d                	js     8013e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801379:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	89 04 24             	mov    %eax,(%esp)
  801388:	e8 8f fd ff ff       	call   80111c <dev_lookup>
  80138d:	85 c0                	test   %eax,%eax
  80138f:	78 55                	js     8013e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801394:	8b 50 08             	mov    0x8(%eax),%edx
  801397:	83 e2 03             	and    $0x3,%edx
  80139a:	83 fa 01             	cmp    $0x1,%edx
  80139d:	75 23                	jne    8013c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80139f:	a1 08 40 80 00       	mov    0x804008,%eax
  8013a4:	8b 40 48             	mov    0x48(%eax),%eax
  8013a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013af:	c7 04 24 58 2b 80 00 	movl   $0x802b58,(%esp)
  8013b6:	e8 89 ee ff ff       	call   800244 <cprintf>
		return -E_INVAL;
  8013bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c0:	eb 24                	jmp    8013e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8013c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c5:	8b 52 08             	mov    0x8(%edx),%edx
  8013c8:	85 d2                	test   %edx,%edx
  8013ca:	74 15                	je     8013e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013da:	89 04 24             	mov    %eax,(%esp)
  8013dd:	ff d2                	call   *%edx
  8013df:	eb 05                	jmp    8013e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013e6:	83 c4 24             	add    $0x24,%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5d                   	pop    %ebp
  8013eb:	c3                   	ret    

008013ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	57                   	push   %edi
  8013f0:	56                   	push   %esi
  8013f1:	53                   	push   %ebx
  8013f2:	83 ec 1c             	sub    $0x1c,%esp
  8013f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801400:	eb 23                	jmp    801425 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801402:	89 f0                	mov    %esi,%eax
  801404:	29 d8                	sub    %ebx,%eax
  801406:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140a:	89 d8                	mov    %ebx,%eax
  80140c:	03 45 0c             	add    0xc(%ebp),%eax
  80140f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801413:	89 3c 24             	mov    %edi,(%esp)
  801416:	e8 3f ff ff ff       	call   80135a <read>
		if (m < 0)
  80141b:	85 c0                	test   %eax,%eax
  80141d:	78 10                	js     80142f <readn+0x43>
			return m;
		if (m == 0)
  80141f:	85 c0                	test   %eax,%eax
  801421:	74 0a                	je     80142d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801423:	01 c3                	add    %eax,%ebx
  801425:	39 f3                	cmp    %esi,%ebx
  801427:	72 d9                	jb     801402 <readn+0x16>
  801429:	89 d8                	mov    %ebx,%eax
  80142b:	eb 02                	jmp    80142f <readn+0x43>
  80142d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80142f:	83 c4 1c             	add    $0x1c,%esp
  801432:	5b                   	pop    %ebx
  801433:	5e                   	pop    %esi
  801434:	5f                   	pop    %edi
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    

00801437 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	53                   	push   %ebx
  80143b:	83 ec 24             	sub    $0x24,%esp
  80143e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801441:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801444:	89 44 24 04          	mov    %eax,0x4(%esp)
  801448:	89 1c 24             	mov    %ebx,(%esp)
  80144b:	e8 76 fc ff ff       	call   8010c6 <fd_lookup>
  801450:	89 c2                	mov    %eax,%edx
  801452:	85 d2                	test   %edx,%edx
  801454:	78 68                	js     8014be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801456:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801460:	8b 00                	mov    (%eax),%eax
  801462:	89 04 24             	mov    %eax,(%esp)
  801465:	e8 b2 fc ff ff       	call   80111c <dev_lookup>
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 50                	js     8014be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801471:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801475:	75 23                	jne    80149a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801477:	a1 08 40 80 00       	mov    0x804008,%eax
  80147c:	8b 40 48             	mov    0x48(%eax),%eax
  80147f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801483:	89 44 24 04          	mov    %eax,0x4(%esp)
  801487:	c7 04 24 74 2b 80 00 	movl   $0x802b74,(%esp)
  80148e:	e8 b1 ed ff ff       	call   800244 <cprintf>
		return -E_INVAL;
  801493:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801498:	eb 24                	jmp    8014be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80149a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149d:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a0:	85 d2                	test   %edx,%edx
  8014a2:	74 15                	je     8014b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014b2:	89 04 24             	mov    %eax,(%esp)
  8014b5:	ff d2                	call   *%edx
  8014b7:	eb 05                	jmp    8014be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014be:	83 c4 24             	add    $0x24,%esp
  8014c1:	5b                   	pop    %ebx
  8014c2:	5d                   	pop    %ebp
  8014c3:	c3                   	ret    

008014c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	89 04 24             	mov    %eax,(%esp)
  8014d7:	e8 ea fb ff ff       	call   8010c6 <fd_lookup>
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 0e                	js     8014ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	53                   	push   %ebx
  8014f4:	83 ec 24             	sub    $0x24,%esp
  8014f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801501:	89 1c 24             	mov    %ebx,(%esp)
  801504:	e8 bd fb ff ff       	call   8010c6 <fd_lookup>
  801509:	89 c2                	mov    %eax,%edx
  80150b:	85 d2                	test   %edx,%edx
  80150d:	78 61                	js     801570 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801512:	89 44 24 04          	mov    %eax,0x4(%esp)
  801516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	89 04 24             	mov    %eax,(%esp)
  80151e:	e8 f9 fb ff ff       	call   80111c <dev_lookup>
  801523:	85 c0                	test   %eax,%eax
  801525:	78 49                	js     801570 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80152e:	75 23                	jne    801553 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801530:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801535:	8b 40 48             	mov    0x48(%eax),%eax
  801538:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80153c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801540:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  801547:	e8 f8 ec ff ff       	call   800244 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80154c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801551:	eb 1d                	jmp    801570 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801556:	8b 52 18             	mov    0x18(%edx),%edx
  801559:	85 d2                	test   %edx,%edx
  80155b:	74 0e                	je     80156b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80155d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801560:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	ff d2                	call   *%edx
  801569:	eb 05                	jmp    801570 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80156b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801570:	83 c4 24             	add    $0x24,%esp
  801573:	5b                   	pop    %ebx
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    

00801576 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	53                   	push   %ebx
  80157a:	83 ec 24             	sub    $0x24,%esp
  80157d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801580:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801583:	89 44 24 04          	mov    %eax,0x4(%esp)
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 04 24             	mov    %eax,(%esp)
  80158d:	e8 34 fb ff ff       	call   8010c6 <fd_lookup>
  801592:	89 c2                	mov    %eax,%edx
  801594:	85 d2                	test   %edx,%edx
  801596:	78 52                	js     8015ea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801598:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a2:	8b 00                	mov    (%eax),%eax
  8015a4:	89 04 24             	mov    %eax,(%esp)
  8015a7:	e8 70 fb ff ff       	call   80111c <dev_lookup>
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 3a                	js     8015ea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015b7:	74 2c                	je     8015e5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015b9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015bc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015c3:	00 00 00 
	stat->st_isdir = 0;
  8015c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015cd:	00 00 00 
	stat->st_dev = dev;
  8015d0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015dd:	89 14 24             	mov    %edx,(%esp)
  8015e0:	ff 50 14             	call   *0x14(%eax)
  8015e3:	eb 05                	jmp    8015ea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015ea:	83 c4 24             	add    $0x24,%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	56                   	push   %esi
  8015f4:	53                   	push   %ebx
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015ff:	00 
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	89 04 24             	mov    %eax,(%esp)
  801606:	e8 28 02 00 00       	call   801833 <open>
  80160b:	89 c3                	mov    %eax,%ebx
  80160d:	85 db                	test   %ebx,%ebx
  80160f:	78 1b                	js     80162c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801611:	8b 45 0c             	mov    0xc(%ebp),%eax
  801614:	89 44 24 04          	mov    %eax,0x4(%esp)
  801618:	89 1c 24             	mov    %ebx,(%esp)
  80161b:	e8 56 ff ff ff       	call   801576 <fstat>
  801620:	89 c6                	mov    %eax,%esi
	close(fd);
  801622:	89 1c 24             	mov    %ebx,(%esp)
  801625:	e8 cd fb ff ff       	call   8011f7 <close>
	return r;
  80162a:	89 f0                	mov    %esi,%eax
}
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	5b                   	pop    %ebx
  801630:	5e                   	pop    %esi
  801631:	5d                   	pop    %ebp
  801632:	c3                   	ret    

00801633 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	56                   	push   %esi
  801637:	53                   	push   %ebx
  801638:	83 ec 10             	sub    $0x10,%esp
  80163b:	89 c6                	mov    %eax,%esi
  80163d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80163f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801646:	75 11                	jne    801659 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801648:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80164f:	e8 7a 0d 00 00       	call   8023ce <ipc_find_env>
  801654:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801659:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801660:	00 
  801661:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801668:	00 
  801669:	89 74 24 04          	mov    %esi,0x4(%esp)
  80166d:	a1 00 40 80 00       	mov    0x804000,%eax
  801672:	89 04 24             	mov    %eax,(%esp)
  801675:	e8 f6 0c 00 00       	call   802370 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80167a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801681:	00 
  801682:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801686:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168d:	e8 74 0c 00 00       	call   802306 <ipc_recv>
}
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    

00801699 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016bc:	e8 72 ff ff ff       	call   801633 <fsipc>
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016cf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016de:	e8 50 ff ff ff       	call   801633 <fsipc>
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 14             	sub    $0x14,%esp
  8016ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801704:	e8 2a ff ff ff       	call   801633 <fsipc>
  801709:	89 c2                	mov    %eax,%edx
  80170b:	85 d2                	test   %edx,%edx
  80170d:	78 2b                	js     80173a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80170f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801716:	00 
  801717:	89 1c 24             	mov    %ebx,(%esp)
  80171a:	e8 48 f1 ff ff       	call   800867 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80171f:	a1 80 50 80 00       	mov    0x805080,%eax
  801724:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80172a:	a1 84 50 80 00       	mov    0x805084,%eax
  80172f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	83 c4 14             	add    $0x14,%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    

00801740 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 18             	sub    $0x18,%esp
  801746:	8b 45 10             	mov    0x10(%ebp),%eax
  801749:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80174e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801753:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801756:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80175b:	8b 55 08             	mov    0x8(%ebp),%edx
  80175e:	8b 52 0c             	mov    0xc(%edx),%edx
  801761:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801767:	89 44 24 08          	mov    %eax,0x8(%esp)
  80176b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801772:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  801779:	e8 86 f2 ff ff       	call   800a04 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80177e:	ba 00 00 00 00       	mov    $0x0,%edx
  801783:	b8 04 00 00 00       	mov    $0x4,%eax
  801788:	e8 a6 fe ff ff       	call   801633 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	56                   	push   %esi
  801793:	53                   	push   %ebx
  801794:	83 ec 10             	sub    $0x10,%esp
  801797:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8b 40 0c             	mov    0xc(%eax),%eax
  8017a0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017a5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b0:	b8 03 00 00 00       	mov    $0x3,%eax
  8017b5:	e8 79 fe ff ff       	call   801633 <fsipc>
  8017ba:	89 c3                	mov    %eax,%ebx
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	78 6a                	js     80182a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017c0:	39 c6                	cmp    %eax,%esi
  8017c2:	73 24                	jae    8017e8 <devfile_read+0x59>
  8017c4:	c7 44 24 0c a8 2b 80 	movl   $0x802ba8,0xc(%esp)
  8017cb:	00 
  8017cc:	c7 44 24 08 af 2b 80 	movl   $0x802baf,0x8(%esp)
  8017d3:	00 
  8017d4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8017db:	00 
  8017dc:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  8017e3:	e8 63 e9 ff ff       	call   80014b <_panic>
	assert(r <= PGSIZE);
  8017e8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017ed:	7e 24                	jle    801813 <devfile_read+0x84>
  8017ef:	c7 44 24 0c cf 2b 80 	movl   $0x802bcf,0xc(%esp)
  8017f6:	00 
  8017f7:	c7 44 24 08 af 2b 80 	movl   $0x802baf,0x8(%esp)
  8017fe:	00 
  8017ff:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801806:	00 
  801807:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  80180e:	e8 38 e9 ff ff       	call   80014b <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801813:	89 44 24 08          	mov    %eax,0x8(%esp)
  801817:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80181e:	00 
  80181f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801822:	89 04 24             	mov    %eax,(%esp)
  801825:	e8 da f1 ff ff       	call   800a04 <memmove>
	return r;
}
  80182a:	89 d8                	mov    %ebx,%eax
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	5b                   	pop    %ebx
  801830:	5e                   	pop    %esi
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    

00801833 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	53                   	push   %ebx
  801837:	83 ec 24             	sub    $0x24,%esp
  80183a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80183d:	89 1c 24             	mov    %ebx,(%esp)
  801840:	e8 eb ef ff ff       	call   800830 <strlen>
  801845:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80184a:	7f 60                	jg     8018ac <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80184c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80184f:	89 04 24             	mov    %eax,(%esp)
  801852:	e8 20 f8 ff ff       	call   801077 <fd_alloc>
  801857:	89 c2                	mov    %eax,%edx
  801859:	85 d2                	test   %edx,%edx
  80185b:	78 54                	js     8018b1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80185d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801861:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801868:	e8 fa ef ff ff       	call   800867 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80186d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801870:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801875:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801878:	b8 01 00 00 00       	mov    $0x1,%eax
  80187d:	e8 b1 fd ff ff       	call   801633 <fsipc>
  801882:	89 c3                	mov    %eax,%ebx
  801884:	85 c0                	test   %eax,%eax
  801886:	79 17                	jns    80189f <open+0x6c>
		fd_close(fd, 0);
  801888:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80188f:	00 
  801890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801893:	89 04 24             	mov    %eax,(%esp)
  801896:	e8 db f8 ff ff       	call   801176 <fd_close>
		return r;
  80189b:	89 d8                	mov    %ebx,%eax
  80189d:	eb 12                	jmp    8018b1 <open+0x7e>
	}

	return fd2num(fd);
  80189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a2:	89 04 24             	mov    %eax,(%esp)
  8018a5:	e8 a6 f7 ff ff       	call   801050 <fd2num>
  8018aa:	eb 05                	jmp    8018b1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018ac:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018b1:	83 c4 24             	add    $0x24,%esp
  8018b4:	5b                   	pop    %ebx
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018c2:	b8 08 00 00 00       	mov    $0x8,%eax
  8018c7:	e8 67 fd ff ff       	call   801633 <fsipc>
}
  8018cc:	c9                   	leave  
  8018cd:	c3                   	ret    
  8018ce:	66 90                	xchg   %ax,%ax

008018d0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8018d6:	c7 44 24 04 db 2b 80 	movl   $0x802bdb,0x4(%esp)
  8018dd:	00 
  8018de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e1:	89 04 24             	mov    %eax,(%esp)
  8018e4:	e8 7e ef ff ff       	call   800867 <strcpy>
	return 0;
}
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 14             	sub    $0x14,%esp
  8018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018fa:	89 1c 24             	mov    %ebx,(%esp)
  8018fd:	e8 04 0b 00 00       	call   802406 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801902:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801907:	83 f8 01             	cmp    $0x1,%eax
  80190a:	75 0d                	jne    801919 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80190c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80190f:	89 04 24             	mov    %eax,(%esp)
  801912:	e8 29 03 00 00       	call   801c40 <nsipc_close>
  801917:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801919:	89 d0                	mov    %edx,%eax
  80191b:	83 c4 14             	add    $0x14,%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    

00801921 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801927:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80192e:	00 
  80192f:	8b 45 10             	mov    0x10(%ebp),%eax
  801932:	89 44 24 08          	mov    %eax,0x8(%esp)
  801936:	8b 45 0c             	mov    0xc(%ebp),%eax
  801939:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	8b 40 0c             	mov    0xc(%eax),%eax
  801943:	89 04 24             	mov    %eax,(%esp)
  801946:	e8 f0 03 00 00       	call   801d3b <nsipc_send>
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801953:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80195a:	00 
  80195b:	8b 45 10             	mov    0x10(%ebp),%eax
  80195e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801962:	8b 45 0c             	mov    0xc(%ebp),%eax
  801965:	89 44 24 04          	mov    %eax,0x4(%esp)
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	8b 40 0c             	mov    0xc(%eax),%eax
  80196f:	89 04 24             	mov    %eax,(%esp)
  801972:	e8 44 03 00 00       	call   801cbb <nsipc_recv>
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80197f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801982:	89 54 24 04          	mov    %edx,0x4(%esp)
  801986:	89 04 24             	mov    %eax,(%esp)
  801989:	e8 38 f7 ff ff       	call   8010c6 <fd_lookup>
  80198e:	85 c0                	test   %eax,%eax
  801990:	78 17                	js     8019a9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801995:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80199b:	39 08                	cmp    %ecx,(%eax)
  80199d:	75 05                	jne    8019a4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80199f:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a2:	eb 05                	jmp    8019a9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8019a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	56                   	push   %esi
  8019af:	53                   	push   %ebx
  8019b0:	83 ec 20             	sub    $0x20,%esp
  8019b3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8019b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b8:	89 04 24             	mov    %eax,(%esp)
  8019bb:	e8 b7 f6 ff ff       	call   801077 <fd_alloc>
  8019c0:	89 c3                	mov    %eax,%ebx
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 21                	js     8019e7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019c6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019cd:	00 
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019dc:	e8 a2 f2 ff ff       	call   800c83 <sys_page_alloc>
  8019e1:	89 c3                	mov    %eax,%ebx
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	79 0c                	jns    8019f3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8019e7:	89 34 24             	mov    %esi,(%esp)
  8019ea:	e8 51 02 00 00       	call   801c40 <nsipc_close>
		return r;
  8019ef:	89 d8                	mov    %ebx,%eax
  8019f1:	eb 20                	jmp    801a13 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8019f3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a01:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801a08:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801a0b:	89 14 24             	mov    %edx,(%esp)
  801a0e:	e8 3d f6 ff ff       	call   801050 <fd2num>
}
  801a13:	83 c4 20             	add    $0x20,%esp
  801a16:	5b                   	pop    %ebx
  801a17:	5e                   	pop    %esi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    

00801a1a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	e8 51 ff ff ff       	call   801979 <fd2sockid>
		return r;
  801a28:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a2a:	85 c0                	test   %eax,%eax
  801a2c:	78 23                	js     801a51 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a2e:	8b 55 10             	mov    0x10(%ebp),%edx
  801a31:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a38:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a3c:	89 04 24             	mov    %eax,(%esp)
  801a3f:	e8 45 01 00 00       	call   801b89 <nsipc_accept>
		return r;
  801a44:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a46:	85 c0                	test   %eax,%eax
  801a48:	78 07                	js     801a51 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801a4a:	e8 5c ff ff ff       	call   8019ab <alloc_sockfd>
  801a4f:	89 c1                	mov    %eax,%ecx
}
  801a51:	89 c8                	mov    %ecx,%eax
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5e:	e8 16 ff ff ff       	call   801979 <fd2sockid>
  801a63:	89 c2                	mov    %eax,%edx
  801a65:	85 d2                	test   %edx,%edx
  801a67:	78 16                	js     801a7f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801a69:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a77:	89 14 24             	mov    %edx,(%esp)
  801a7a:	e8 60 01 00 00       	call   801bdf <nsipc_bind>
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <shutdown>:

int
shutdown(int s, int how)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	e8 ea fe ff ff       	call   801979 <fd2sockid>
  801a8f:	89 c2                	mov    %eax,%edx
  801a91:	85 d2                	test   %edx,%edx
  801a93:	78 0f                	js     801aa4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9c:	89 14 24             	mov    %edx,(%esp)
  801a9f:	e8 7a 01 00 00       	call   801c1e <nsipc_shutdown>
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	e8 c5 fe ff ff       	call   801979 <fd2sockid>
  801ab4:	89 c2                	mov    %eax,%edx
  801ab6:	85 d2                	test   %edx,%edx
  801ab8:	78 16                	js     801ad0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801aba:	8b 45 10             	mov    0x10(%ebp),%eax
  801abd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac8:	89 14 24             	mov    %edx,(%esp)
  801acb:	e8 8a 01 00 00       	call   801c5a <nsipc_connect>
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <listen>:

int
listen(int s, int backlog)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
  801ad5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	e8 99 fe ff ff       	call   801979 <fd2sockid>
  801ae0:	89 c2                	mov    %eax,%edx
  801ae2:	85 d2                	test   %edx,%edx
  801ae4:	78 0f                	js     801af5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aed:	89 14 24             	mov    %edx,(%esp)
  801af0:	e8 a4 01 00 00       	call   801c99 <nsipc_listen>
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801afd:	8b 45 10             	mov    0x10(%ebp),%eax
  801b00:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	89 04 24             	mov    %eax,(%esp)
  801b11:	e8 98 02 00 00       	call   801dae <nsipc_socket>
  801b16:	89 c2                	mov    %eax,%edx
  801b18:	85 d2                	test   %edx,%edx
  801b1a:	78 05                	js     801b21 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801b1c:	e8 8a fe ff ff       	call   8019ab <alloc_sockfd>
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	53                   	push   %ebx
  801b27:	83 ec 14             	sub    $0x14,%esp
  801b2a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b2c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b33:	75 11                	jne    801b46 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801b3c:	e8 8d 08 00 00       	call   8023ce <ipc_find_env>
  801b41:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b46:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b4d:	00 
  801b4e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b55:	00 
  801b56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b5a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b5f:	89 04 24             	mov    %eax,(%esp)
  801b62:	e8 09 08 00 00       	call   802370 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b6e:	00 
  801b6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b76:	00 
  801b77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b7e:	e8 83 07 00 00       	call   802306 <ipc_recv>
}
  801b83:	83 c4 14             	add    $0x14,%esp
  801b86:	5b                   	pop    %ebx
  801b87:	5d                   	pop    %ebp
  801b88:	c3                   	ret    

00801b89 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	56                   	push   %esi
  801b8d:	53                   	push   %ebx
  801b8e:	83 ec 10             	sub    $0x10,%esp
  801b91:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b9c:	8b 06                	mov    (%esi),%eax
  801b9e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ba3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba8:	e8 76 ff ff ff       	call   801b23 <nsipc>
  801bad:	89 c3                	mov    %eax,%ebx
  801baf:	85 c0                	test   %eax,%eax
  801bb1:	78 23                	js     801bd6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bb3:	a1 10 60 80 00       	mov    0x806010,%eax
  801bb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bbc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bc3:	00 
  801bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc7:	89 04 24             	mov    %eax,(%esp)
  801bca:	e8 35 ee ff ff       	call   800a04 <memmove>
		*addrlen = ret->ret_addrlen;
  801bcf:	a1 10 60 80 00       	mov    0x806010,%eax
  801bd4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801bd6:	89 d8                	mov    %ebx,%eax
  801bd8:	83 c4 10             	add    $0x10,%esp
  801bdb:	5b                   	pop    %ebx
  801bdc:	5e                   	pop    %esi
  801bdd:	5d                   	pop    %ebp
  801bde:	c3                   	ret    

00801bdf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	53                   	push   %ebx
  801be3:	83 ec 14             	sub    $0x14,%esp
  801be6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bf1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c03:	e8 fc ed ff ff       	call   800a04 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c08:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c0e:	b8 02 00 00 00       	mov    $0x2,%eax
  801c13:	e8 0b ff ff ff       	call   801b23 <nsipc>
}
  801c18:	83 c4 14             	add    $0x14,%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    

00801c1e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c34:	b8 03 00 00 00       	mov    $0x3,%eax
  801c39:	e8 e5 fe ff ff       	call   801b23 <nsipc>
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <nsipc_close>:

int
nsipc_close(int s)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c4e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c53:	e8 cb fe ff ff       	call   801b23 <nsipc>
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	53                   	push   %ebx
  801c5e:	83 ec 14             	sub    $0x14,%esp
  801c61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c77:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c7e:	e8 81 ed ff ff       	call   800a04 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c83:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c89:	b8 05 00 00 00       	mov    $0x5,%eax
  801c8e:	e8 90 fe ff ff       	call   801b23 <nsipc>
}
  801c93:	83 c4 14             	add    $0x14,%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5d                   	pop    %ebp
  801c98:	c3                   	ret    

00801c99 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ca7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801caa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801caf:	b8 06 00 00 00       	mov    $0x6,%eax
  801cb4:	e8 6a fe ff ff       	call   801b23 <nsipc>
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	56                   	push   %esi
  801cbf:	53                   	push   %ebx
  801cc0:	83 ec 10             	sub    $0x10,%esp
  801cc3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cce:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cdc:	b8 07 00 00 00       	mov    $0x7,%eax
  801ce1:	e8 3d fe ff ff       	call   801b23 <nsipc>
  801ce6:	89 c3                	mov    %eax,%ebx
  801ce8:	85 c0                	test   %eax,%eax
  801cea:	78 46                	js     801d32 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801cec:	39 f0                	cmp    %esi,%eax
  801cee:	7f 07                	jg     801cf7 <nsipc_recv+0x3c>
  801cf0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cf5:	7e 24                	jle    801d1b <nsipc_recv+0x60>
  801cf7:	c7 44 24 0c e7 2b 80 	movl   $0x802be7,0xc(%esp)
  801cfe:	00 
  801cff:	c7 44 24 08 af 2b 80 	movl   $0x802baf,0x8(%esp)
  801d06:	00 
  801d07:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d0e:	00 
  801d0f:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  801d16:	e8 30 e4 ff ff       	call   80014b <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d26:	00 
  801d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2a:	89 04 24             	mov    %eax,(%esp)
  801d2d:	e8 d2 ec ff ff       	call   800a04 <memmove>
	}

	return r;
}
  801d32:	89 d8                	mov    %ebx,%eax
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    

00801d3b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	53                   	push   %ebx
  801d3f:	83 ec 14             	sub    $0x14,%esp
  801d42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d4d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d53:	7e 24                	jle    801d79 <nsipc_send+0x3e>
  801d55:	c7 44 24 0c 08 2c 80 	movl   $0x802c08,0xc(%esp)
  801d5c:	00 
  801d5d:	c7 44 24 08 af 2b 80 	movl   $0x802baf,0x8(%esp)
  801d64:	00 
  801d65:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801d6c:	00 
  801d6d:	c7 04 24 fc 2b 80 00 	movl   $0x802bfc,(%esp)
  801d74:	e8 d2 e3 ff ff       	call   80014b <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d79:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d84:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d8b:	e8 74 ec ff ff       	call   800a04 <memmove>
	nsipcbuf.send.req_size = size;
  801d90:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d96:	8b 45 14             	mov    0x14(%ebp),%eax
  801d99:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d9e:	b8 08 00 00 00       	mov    $0x8,%eax
  801da3:	e8 7b fd ff ff       	call   801b23 <nsipc>
}
  801da8:	83 c4 14             	add    $0x14,%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5d                   	pop    %ebp
  801dad:	c3                   	ret    

00801dae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801dcc:	b8 09 00 00 00       	mov    $0x9,%eax
  801dd1:	e8 4d fd ff ff       	call   801b23 <nsipc>
}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	56                   	push   %esi
  801ddc:	53                   	push   %ebx
  801ddd:	83 ec 10             	sub    $0x10,%esp
  801de0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801de3:	8b 45 08             	mov    0x8(%ebp),%eax
  801de6:	89 04 24             	mov    %eax,(%esp)
  801de9:	e8 72 f2 ff ff       	call   801060 <fd2data>
  801dee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801df0:	c7 44 24 04 14 2c 80 	movl   $0x802c14,0x4(%esp)
  801df7:	00 
  801df8:	89 1c 24             	mov    %ebx,(%esp)
  801dfb:	e8 67 ea ff ff       	call   800867 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e00:	8b 46 04             	mov    0x4(%esi),%eax
  801e03:	2b 06                	sub    (%esi),%eax
  801e05:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e0b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e12:	00 00 00 
	stat->st_dev = &devpipe;
  801e15:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e1c:	30 80 00 
	return 0;
}
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e24:	83 c4 10             	add    $0x10,%esp
  801e27:	5b                   	pop    %ebx
  801e28:	5e                   	pop    %esi
  801e29:	5d                   	pop    %ebp
  801e2a:	c3                   	ret    

00801e2b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	53                   	push   %ebx
  801e2f:	83 ec 14             	sub    $0x14,%esp
  801e32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e35:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e40:	e8 e5 ee ff ff       	call   800d2a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e45:	89 1c 24             	mov    %ebx,(%esp)
  801e48:	e8 13 f2 ff ff       	call   801060 <fd2data>
  801e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e58:	e8 cd ee ff ff       	call   800d2a <sys_page_unmap>
}
  801e5d:	83 c4 14             	add    $0x14,%esp
  801e60:	5b                   	pop    %ebx
  801e61:	5d                   	pop    %ebp
  801e62:	c3                   	ret    

00801e63 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	57                   	push   %edi
  801e67:	56                   	push   %esi
  801e68:	53                   	push   %ebx
  801e69:	83 ec 2c             	sub    $0x2c,%esp
  801e6c:	89 c6                	mov    %eax,%esi
  801e6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e71:	a1 08 40 80 00       	mov    0x804008,%eax
  801e76:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e79:	89 34 24             	mov    %esi,(%esp)
  801e7c:	e8 85 05 00 00       	call   802406 <pageref>
  801e81:	89 c7                	mov    %eax,%edi
  801e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e86:	89 04 24             	mov    %eax,(%esp)
  801e89:	e8 78 05 00 00       	call   802406 <pageref>
  801e8e:	39 c7                	cmp    %eax,%edi
  801e90:	0f 94 c2             	sete   %dl
  801e93:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e96:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801e9c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e9f:	39 fb                	cmp    %edi,%ebx
  801ea1:	74 21                	je     801ec4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801ea3:	84 d2                	test   %dl,%dl
  801ea5:	74 ca                	je     801e71 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ea7:	8b 51 58             	mov    0x58(%ecx),%edx
  801eaa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801eae:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eb2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eb6:	c7 04 24 1b 2c 80 00 	movl   $0x802c1b,(%esp)
  801ebd:	e8 82 e3 ff ff       	call   800244 <cprintf>
  801ec2:	eb ad                	jmp    801e71 <_pipeisclosed+0xe>
	}
}
  801ec4:	83 c4 2c             	add    $0x2c,%esp
  801ec7:	5b                   	pop    %ebx
  801ec8:	5e                   	pop    %esi
  801ec9:	5f                   	pop    %edi
  801eca:	5d                   	pop    %ebp
  801ecb:	c3                   	ret    

00801ecc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	57                   	push   %edi
  801ed0:	56                   	push   %esi
  801ed1:	53                   	push   %ebx
  801ed2:	83 ec 1c             	sub    $0x1c,%esp
  801ed5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ed8:	89 34 24             	mov    %esi,(%esp)
  801edb:	e8 80 f1 ff ff       	call   801060 <fd2data>
  801ee0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ee2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ee7:	eb 45                	jmp    801f2e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ee9:	89 da                	mov    %ebx,%edx
  801eeb:	89 f0                	mov    %esi,%eax
  801eed:	e8 71 ff ff ff       	call   801e63 <_pipeisclosed>
  801ef2:	85 c0                	test   %eax,%eax
  801ef4:	75 41                	jne    801f37 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ef6:	e8 69 ed ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801efb:	8b 43 04             	mov    0x4(%ebx),%eax
  801efe:	8b 0b                	mov    (%ebx),%ecx
  801f00:	8d 51 20             	lea    0x20(%ecx),%edx
  801f03:	39 d0                	cmp    %edx,%eax
  801f05:	73 e2                	jae    801ee9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f0a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f0e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f11:	99                   	cltd   
  801f12:	c1 ea 1b             	shr    $0x1b,%edx
  801f15:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f18:	83 e1 1f             	and    $0x1f,%ecx
  801f1b:	29 d1                	sub    %edx,%ecx
  801f1d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f21:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f25:	83 c0 01             	add    $0x1,%eax
  801f28:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f2b:	83 c7 01             	add    $0x1,%edi
  801f2e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f31:	75 c8                	jne    801efb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f33:	89 f8                	mov    %edi,%eax
  801f35:	eb 05                	jmp    801f3c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f3c:	83 c4 1c             	add    $0x1c,%esp
  801f3f:	5b                   	pop    %ebx
  801f40:	5e                   	pop    %esi
  801f41:	5f                   	pop    %edi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	57                   	push   %edi
  801f48:	56                   	push   %esi
  801f49:	53                   	push   %ebx
  801f4a:	83 ec 1c             	sub    $0x1c,%esp
  801f4d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f50:	89 3c 24             	mov    %edi,(%esp)
  801f53:	e8 08 f1 ff ff       	call   801060 <fd2data>
  801f58:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f5a:	be 00 00 00 00       	mov    $0x0,%esi
  801f5f:	eb 3d                	jmp    801f9e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f61:	85 f6                	test   %esi,%esi
  801f63:	74 04                	je     801f69 <devpipe_read+0x25>
				return i;
  801f65:	89 f0                	mov    %esi,%eax
  801f67:	eb 43                	jmp    801fac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f69:	89 da                	mov    %ebx,%edx
  801f6b:	89 f8                	mov    %edi,%eax
  801f6d:	e8 f1 fe ff ff       	call   801e63 <_pipeisclosed>
  801f72:	85 c0                	test   %eax,%eax
  801f74:	75 31                	jne    801fa7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f76:	e8 e9 ec ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f7b:	8b 03                	mov    (%ebx),%eax
  801f7d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f80:	74 df                	je     801f61 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f82:	99                   	cltd   
  801f83:	c1 ea 1b             	shr    $0x1b,%edx
  801f86:	01 d0                	add    %edx,%eax
  801f88:	83 e0 1f             	and    $0x1f,%eax
  801f8b:	29 d0                	sub    %edx,%eax
  801f8d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f95:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f98:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f9b:	83 c6 01             	add    $0x1,%esi
  801f9e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fa1:	75 d8                	jne    801f7b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801fa3:	89 f0                	mov    %esi,%eax
  801fa5:	eb 05                	jmp    801fac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801fac:	83 c4 1c             	add    $0x1c,%esp
  801faf:	5b                   	pop    %ebx
  801fb0:	5e                   	pop    %esi
  801fb1:	5f                   	pop    %edi
  801fb2:	5d                   	pop    %ebp
  801fb3:	c3                   	ret    

00801fb4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	56                   	push   %esi
  801fb8:	53                   	push   %ebx
  801fb9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fbf:	89 04 24             	mov    %eax,(%esp)
  801fc2:	e8 b0 f0 ff ff       	call   801077 <fd_alloc>
  801fc7:	89 c2                	mov    %eax,%edx
  801fc9:	85 d2                	test   %edx,%edx
  801fcb:	0f 88 4d 01 00 00    	js     80211e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fd8:	00 
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe7:	e8 97 ec ff ff       	call   800c83 <sys_page_alloc>
  801fec:	89 c2                	mov    %eax,%edx
  801fee:	85 d2                	test   %edx,%edx
  801ff0:	0f 88 28 01 00 00    	js     80211e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ff6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ff9:	89 04 24             	mov    %eax,(%esp)
  801ffc:	e8 76 f0 ff ff       	call   801077 <fd_alloc>
  802001:	89 c3                	mov    %eax,%ebx
  802003:	85 c0                	test   %eax,%eax
  802005:	0f 88 fe 00 00 00    	js     802109 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802012:	00 
  802013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802016:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802021:	e8 5d ec ff ff       	call   800c83 <sys_page_alloc>
  802026:	89 c3                	mov    %eax,%ebx
  802028:	85 c0                	test   %eax,%eax
  80202a:	0f 88 d9 00 00 00    	js     802109 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	89 04 24             	mov    %eax,(%esp)
  802036:	e8 25 f0 ff ff       	call   801060 <fd2data>
  80203b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802044:	00 
  802045:	89 44 24 04          	mov    %eax,0x4(%esp)
  802049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802050:	e8 2e ec ff ff       	call   800c83 <sys_page_alloc>
  802055:	89 c3                	mov    %eax,%ebx
  802057:	85 c0                	test   %eax,%eax
  802059:	0f 88 97 00 00 00    	js     8020f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80205f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802062:	89 04 24             	mov    %eax,(%esp)
  802065:	e8 f6 ef ff ff       	call   801060 <fd2data>
  80206a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802071:	00 
  802072:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80207d:	00 
  80207e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802082:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802089:	e8 49 ec ff ff       	call   800cd7 <sys_page_map>
  80208e:	89 c3                	mov    %eax,%ebx
  802090:	85 c0                	test   %eax,%eax
  802092:	78 52                	js     8020e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802094:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80209f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8020a9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8020be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c1:	89 04 24             	mov    %eax,(%esp)
  8020c4:	e8 87 ef ff ff       	call   801050 <fd2num>
  8020c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d1:	89 04 24             	mov    %eax,(%esp)
  8020d4:	e8 77 ef ff ff       	call   801050 <fd2num>
  8020d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e4:	eb 38                	jmp    80211e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8020e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f1:	e8 34 ec ff ff       	call   800d2a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802104:	e8 21 ec ff ff       	call   800d2a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802117:	e8 0e ec ff ff       	call   800d2a <sys_page_unmap>
  80211c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80211e:	83 c4 30             	add    $0x30,%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    

00802125 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80212b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80212e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	89 04 24             	mov    %eax,(%esp)
  802138:	e8 89 ef ff ff       	call   8010c6 <fd_lookup>
  80213d:	89 c2                	mov    %eax,%edx
  80213f:	85 d2                	test   %edx,%edx
  802141:	78 15                	js     802158 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	89 04 24             	mov    %eax,(%esp)
  802149:	e8 12 ef ff ff       	call   801060 <fd2data>
	return _pipeisclosed(fd, p);
  80214e:	89 c2                	mov    %eax,%edx
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802153:	e8 0b fd ff ff       	call   801e63 <_pipeisclosed>
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    
  80215a:	66 90                	xchg   %ax,%ax
  80215c:	66 90                	xchg   %ax,%ax
  80215e:	66 90                	xchg   %ax,%ax

00802160 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    

0080216a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802170:	c7 44 24 04 33 2c 80 	movl   $0x802c33,0x4(%esp)
  802177:	00 
  802178:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217b:	89 04 24             	mov    %eax,(%esp)
  80217e:	e8 e4 e6 ff ff       	call   800867 <strcpy>
	return 0;
}
  802183:	b8 00 00 00 00       	mov    $0x0,%eax
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	57                   	push   %edi
  80218e:	56                   	push   %esi
  80218f:	53                   	push   %ebx
  802190:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802196:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80219b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021a1:	eb 31                	jmp    8021d4 <devcons_write+0x4a>
		m = n - tot;
  8021a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8021a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8021a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8021ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8021b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8021b7:	03 45 0c             	add    0xc(%ebp),%eax
  8021ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021be:	89 3c 24             	mov    %edi,(%esp)
  8021c1:	e8 3e e8 ff ff       	call   800a04 <memmove>
		sys_cputs(buf, m);
  8021c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ca:	89 3c 24             	mov    %edi,(%esp)
  8021cd:	e8 e4 e9 ff ff       	call   800bb6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021d2:	01 f3                	add    %esi,%ebx
  8021d4:	89 d8                	mov    %ebx,%eax
  8021d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8021d9:	72 c8                	jb     8021a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8021db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8021e1:	5b                   	pop    %ebx
  8021e2:	5e                   	pop    %esi
  8021e3:	5f                   	pop    %edi
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    

008021e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8021ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8021f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021f5:	75 07                	jne    8021fe <devcons_read+0x18>
  8021f7:	eb 2a                	jmp    802223 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021f9:	e8 66 ea ff ff       	call   800c64 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021fe:	66 90                	xchg   %ax,%ax
  802200:	e8 cf e9 ff ff       	call   800bd4 <sys_cgetc>
  802205:	85 c0                	test   %eax,%eax
  802207:	74 f0                	je     8021f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802209:	85 c0                	test   %eax,%eax
  80220b:	78 16                	js     802223 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80220d:	83 f8 04             	cmp    $0x4,%eax
  802210:	74 0c                	je     80221e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802212:	8b 55 0c             	mov    0xc(%ebp),%edx
  802215:	88 02                	mov    %al,(%edx)
	return 1;
  802217:	b8 01 00 00 00       	mov    $0x1,%eax
  80221c:	eb 05                	jmp    802223 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80221e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802231:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802238:	00 
  802239:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80223c:	89 04 24             	mov    %eax,(%esp)
  80223f:	e8 72 e9 ff ff       	call   800bb6 <sys_cputs>
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <getchar>:

int
getchar(void)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80224c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802253:	00 
  802254:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802262:	e8 f3 f0 ff ff       	call   80135a <read>
	if (r < 0)
  802267:	85 c0                	test   %eax,%eax
  802269:	78 0f                	js     80227a <getchar+0x34>
		return r;
	if (r < 1)
  80226b:	85 c0                	test   %eax,%eax
  80226d:	7e 06                	jle    802275 <getchar+0x2f>
		return -E_EOF;
	return c;
  80226f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802273:	eb 05                	jmp    80227a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802275:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802282:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802285:	89 44 24 04          	mov    %eax,0x4(%esp)
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	89 04 24             	mov    %eax,(%esp)
  80228f:	e8 32 ee ff ff       	call   8010c6 <fd_lookup>
  802294:	85 c0                	test   %eax,%eax
  802296:	78 11                	js     8022a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022a1:	39 10                	cmp    %edx,(%eax)
  8022a3:	0f 94 c0             	sete   %al
  8022a6:	0f b6 c0             	movzbl %al,%eax
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <opencons>:

int
opencons(void)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022b4:	89 04 24             	mov    %eax,(%esp)
  8022b7:	e8 bb ed ff ff       	call   801077 <fd_alloc>
		return r;
  8022bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	78 40                	js     802302 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022c9:	00 
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d8:	e8 a6 e9 ff ff       	call   800c83 <sys_page_alloc>
		return r;
  8022dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	78 1f                	js     802302 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8022e3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022f8:	89 04 24             	mov    %eax,(%esp)
  8022fb:	e8 50 ed ff ff       	call   801050 <fd2num>
  802300:	89 c2                	mov    %eax,%edx
}
  802302:	89 d0                	mov    %edx,%eax
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	56                   	push   %esi
  80230a:	53                   	push   %ebx
  80230b:	83 ec 10             	sub    $0x10,%esp
  80230e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802311:	8b 45 0c             	mov    0xc(%ebp),%eax
  802314:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802317:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802319:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80231e:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802321:	89 04 24             	mov    %eax,(%esp)
  802324:	e8 70 eb ff ff       	call   800e99 <sys_ipc_recv>
  802329:	85 c0                	test   %eax,%eax
  80232b:	75 1e                	jne    80234b <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80232d:	85 db                	test   %ebx,%ebx
  80232f:	74 0a                	je     80233b <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802331:	a1 08 40 80 00       	mov    0x804008,%eax
  802336:	8b 40 74             	mov    0x74(%eax),%eax
  802339:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80233b:	85 f6                	test   %esi,%esi
  80233d:	74 22                	je     802361 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80233f:	a1 08 40 80 00       	mov    0x804008,%eax
  802344:	8b 40 78             	mov    0x78(%eax),%eax
  802347:	89 06                	mov    %eax,(%esi)
  802349:	eb 16                	jmp    802361 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80234b:	85 f6                	test   %esi,%esi
  80234d:	74 06                	je     802355 <ipc_recv+0x4f>
				*perm_store = 0;
  80234f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802355:	85 db                	test   %ebx,%ebx
  802357:	74 10                	je     802369 <ipc_recv+0x63>
				*from_env_store=0;
  802359:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80235f:	eb 08                	jmp    802369 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802361:	a1 08 40 80 00       	mov    0x804008,%eax
  802366:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802369:	83 c4 10             	add    $0x10,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5d                   	pop    %ebp
  80236f:	c3                   	ret    

00802370 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	57                   	push   %edi
  802374:	56                   	push   %esi
  802375:	53                   	push   %ebx
  802376:	83 ec 1c             	sub    $0x1c,%esp
  802379:	8b 75 0c             	mov    0xc(%ebp),%esi
  80237c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80237f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802382:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802384:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802389:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80238c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802390:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802394:	89 74 24 04          	mov    %esi,0x4(%esp)
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	89 04 24             	mov    %eax,(%esp)
  80239e:	e8 d3 ea ff ff       	call   800e76 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8023a3:	eb 1c                	jmp    8023c1 <ipc_send+0x51>
	{
		sys_yield();
  8023a5:	e8 ba e8 ff ff       	call   800c64 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8023aa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	89 04 24             	mov    %eax,(%esp)
  8023bc:	e8 b5 ea ff ff       	call   800e76 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8023c1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023c4:	74 df                	je     8023a5 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8023c6:	83 c4 1c             	add    $0x1c,%esp
  8023c9:	5b                   	pop    %ebx
  8023ca:	5e                   	pop    %esi
  8023cb:	5f                   	pop    %edi
  8023cc:	5d                   	pop    %ebp
  8023cd:	c3                   	ret    

008023ce <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8023d4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023d9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023dc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023e2:	8b 52 50             	mov    0x50(%edx),%edx
  8023e5:	39 ca                	cmp    %ecx,%edx
  8023e7:	75 0d                	jne    8023f6 <ipc_find_env+0x28>
			return envs[i].env_id;
  8023e9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023ec:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023f1:	8b 40 40             	mov    0x40(%eax),%eax
  8023f4:	eb 0e                	jmp    802404 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023f6:	83 c0 01             	add    $0x1,%eax
  8023f9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023fe:	75 d9                	jne    8023d9 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802400:	66 b8 00 00          	mov    $0x0,%ax
}
  802404:	5d                   	pop    %ebp
  802405:	c3                   	ret    

00802406 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80240c:	89 d0                	mov    %edx,%eax
  80240e:	c1 e8 16             	shr    $0x16,%eax
  802411:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802418:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80241d:	f6 c1 01             	test   $0x1,%cl
  802420:	74 1d                	je     80243f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802422:	c1 ea 0c             	shr    $0xc,%edx
  802425:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80242c:	f6 c2 01             	test   $0x1,%dl
  80242f:	74 0e                	je     80243f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802431:	c1 ea 0c             	shr    $0xc,%edx
  802434:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80243b:	ef 
  80243c:	0f b7 c0             	movzwl %ax,%eax
}
  80243f:	5d                   	pop    %ebp
  802440:	c3                   	ret    
  802441:	66 90                	xchg   %ax,%ax
  802443:	66 90                	xchg   %ax,%ax
  802445:	66 90                	xchg   %ax,%ax
  802447:	66 90                	xchg   %ax,%ax
  802449:	66 90                	xchg   %ax,%ax
  80244b:	66 90                	xchg   %ax,%ax
  80244d:	66 90                	xchg   %ax,%ax
  80244f:	90                   	nop

00802450 <__udivdi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	8b 44 24 28          	mov    0x28(%esp),%eax
  80245a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80245e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802462:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802466:	85 c0                	test   %eax,%eax
  802468:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80246c:	89 ea                	mov    %ebp,%edx
  80246e:	89 0c 24             	mov    %ecx,(%esp)
  802471:	75 2d                	jne    8024a0 <__udivdi3+0x50>
  802473:	39 e9                	cmp    %ebp,%ecx
  802475:	77 61                	ja     8024d8 <__udivdi3+0x88>
  802477:	85 c9                	test   %ecx,%ecx
  802479:	89 ce                	mov    %ecx,%esi
  80247b:	75 0b                	jne    802488 <__udivdi3+0x38>
  80247d:	b8 01 00 00 00       	mov    $0x1,%eax
  802482:	31 d2                	xor    %edx,%edx
  802484:	f7 f1                	div    %ecx
  802486:	89 c6                	mov    %eax,%esi
  802488:	31 d2                	xor    %edx,%edx
  80248a:	89 e8                	mov    %ebp,%eax
  80248c:	f7 f6                	div    %esi
  80248e:	89 c5                	mov    %eax,%ebp
  802490:	89 f8                	mov    %edi,%eax
  802492:	f7 f6                	div    %esi
  802494:	89 ea                	mov    %ebp,%edx
  802496:	83 c4 0c             	add    $0xc,%esp
  802499:	5e                   	pop    %esi
  80249a:	5f                   	pop    %edi
  80249b:	5d                   	pop    %ebp
  80249c:	c3                   	ret    
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	39 e8                	cmp    %ebp,%eax
  8024a2:	77 24                	ja     8024c8 <__udivdi3+0x78>
  8024a4:	0f bd e8             	bsr    %eax,%ebp
  8024a7:	83 f5 1f             	xor    $0x1f,%ebp
  8024aa:	75 3c                	jne    8024e8 <__udivdi3+0x98>
  8024ac:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024b0:	39 34 24             	cmp    %esi,(%esp)
  8024b3:	0f 86 9f 00 00 00    	jbe    802558 <__udivdi3+0x108>
  8024b9:	39 d0                	cmp    %edx,%eax
  8024bb:	0f 82 97 00 00 00    	jb     802558 <__udivdi3+0x108>
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	31 c0                	xor    %eax,%eax
  8024cc:	83 c4 0c             	add    $0xc,%esp
  8024cf:	5e                   	pop    %esi
  8024d0:	5f                   	pop    %edi
  8024d1:	5d                   	pop    %ebp
  8024d2:	c3                   	ret    
  8024d3:	90                   	nop
  8024d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	89 f8                	mov    %edi,%eax
  8024da:	f7 f1                	div    %ecx
  8024dc:	31 d2                	xor    %edx,%edx
  8024de:	83 c4 0c             	add    $0xc,%esp
  8024e1:	5e                   	pop    %esi
  8024e2:	5f                   	pop    %edi
  8024e3:	5d                   	pop    %ebp
  8024e4:	c3                   	ret    
  8024e5:	8d 76 00             	lea    0x0(%esi),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	8b 3c 24             	mov    (%esp),%edi
  8024ed:	d3 e0                	shl    %cl,%eax
  8024ef:	89 c6                	mov    %eax,%esi
  8024f1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024f6:	29 e8                	sub    %ebp,%eax
  8024f8:	89 c1                	mov    %eax,%ecx
  8024fa:	d3 ef                	shr    %cl,%edi
  8024fc:	89 e9                	mov    %ebp,%ecx
  8024fe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802502:	8b 3c 24             	mov    (%esp),%edi
  802505:	09 74 24 08          	or     %esi,0x8(%esp)
  802509:	89 d6                	mov    %edx,%esi
  80250b:	d3 e7                	shl    %cl,%edi
  80250d:	89 c1                	mov    %eax,%ecx
  80250f:	89 3c 24             	mov    %edi,(%esp)
  802512:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802516:	d3 ee                	shr    %cl,%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	d3 e2                	shl    %cl,%edx
  80251c:	89 c1                	mov    %eax,%ecx
  80251e:	d3 ef                	shr    %cl,%edi
  802520:	09 d7                	or     %edx,%edi
  802522:	89 f2                	mov    %esi,%edx
  802524:	89 f8                	mov    %edi,%eax
  802526:	f7 74 24 08          	divl   0x8(%esp)
  80252a:	89 d6                	mov    %edx,%esi
  80252c:	89 c7                	mov    %eax,%edi
  80252e:	f7 24 24             	mull   (%esp)
  802531:	39 d6                	cmp    %edx,%esi
  802533:	89 14 24             	mov    %edx,(%esp)
  802536:	72 30                	jb     802568 <__udivdi3+0x118>
  802538:	8b 54 24 04          	mov    0x4(%esp),%edx
  80253c:	89 e9                	mov    %ebp,%ecx
  80253e:	d3 e2                	shl    %cl,%edx
  802540:	39 c2                	cmp    %eax,%edx
  802542:	73 05                	jae    802549 <__udivdi3+0xf9>
  802544:	3b 34 24             	cmp    (%esp),%esi
  802547:	74 1f                	je     802568 <__udivdi3+0x118>
  802549:	89 f8                	mov    %edi,%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	e9 7a ff ff ff       	jmp    8024cc <__udivdi3+0x7c>
  802552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802558:	31 d2                	xor    %edx,%edx
  80255a:	b8 01 00 00 00       	mov    $0x1,%eax
  80255f:	e9 68 ff ff ff       	jmp    8024cc <__udivdi3+0x7c>
  802564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802568:	8d 47 ff             	lea    -0x1(%edi),%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	83 c4 0c             	add    $0xc,%esp
  802570:	5e                   	pop    %esi
  802571:	5f                   	pop    %edi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    
  802574:	66 90                	xchg   %ax,%ax
  802576:	66 90                	xchg   %ax,%ax
  802578:	66 90                	xchg   %ax,%ax
  80257a:	66 90                	xchg   %ax,%ax
  80257c:	66 90                	xchg   %ax,%ax
  80257e:	66 90                	xchg   %ax,%ax

00802580 <__umoddi3>:
  802580:	55                   	push   %ebp
  802581:	57                   	push   %edi
  802582:	56                   	push   %esi
  802583:	83 ec 14             	sub    $0x14,%esp
  802586:	8b 44 24 28          	mov    0x28(%esp),%eax
  80258a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80258e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802592:	89 c7                	mov    %eax,%edi
  802594:	89 44 24 04          	mov    %eax,0x4(%esp)
  802598:	8b 44 24 30          	mov    0x30(%esp),%eax
  80259c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025a0:	89 34 24             	mov    %esi,(%esp)
  8025a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	89 c2                	mov    %eax,%edx
  8025ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025af:	75 17                	jne    8025c8 <__umoddi3+0x48>
  8025b1:	39 fe                	cmp    %edi,%esi
  8025b3:	76 4b                	jbe    802600 <__umoddi3+0x80>
  8025b5:	89 c8                	mov    %ecx,%eax
  8025b7:	89 fa                	mov    %edi,%edx
  8025b9:	f7 f6                	div    %esi
  8025bb:	89 d0                	mov    %edx,%eax
  8025bd:	31 d2                	xor    %edx,%edx
  8025bf:	83 c4 14             	add    $0x14,%esp
  8025c2:	5e                   	pop    %esi
  8025c3:	5f                   	pop    %edi
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	39 f8                	cmp    %edi,%eax
  8025ca:	77 54                	ja     802620 <__umoddi3+0xa0>
  8025cc:	0f bd e8             	bsr    %eax,%ebp
  8025cf:	83 f5 1f             	xor    $0x1f,%ebp
  8025d2:	75 5c                	jne    802630 <__umoddi3+0xb0>
  8025d4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025d8:	39 3c 24             	cmp    %edi,(%esp)
  8025db:	0f 87 e7 00 00 00    	ja     8026c8 <__umoddi3+0x148>
  8025e1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025e5:	29 f1                	sub    %esi,%ecx
  8025e7:	19 c7                	sbb    %eax,%edi
  8025e9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025f1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025f5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025f9:	83 c4 14             	add    $0x14,%esp
  8025fc:	5e                   	pop    %esi
  8025fd:	5f                   	pop    %edi
  8025fe:	5d                   	pop    %ebp
  8025ff:	c3                   	ret    
  802600:	85 f6                	test   %esi,%esi
  802602:	89 f5                	mov    %esi,%ebp
  802604:	75 0b                	jne    802611 <__umoddi3+0x91>
  802606:	b8 01 00 00 00       	mov    $0x1,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	f7 f6                	div    %esi
  80260f:	89 c5                	mov    %eax,%ebp
  802611:	8b 44 24 04          	mov    0x4(%esp),%eax
  802615:	31 d2                	xor    %edx,%edx
  802617:	f7 f5                	div    %ebp
  802619:	89 c8                	mov    %ecx,%eax
  80261b:	f7 f5                	div    %ebp
  80261d:	eb 9c                	jmp    8025bb <__umoddi3+0x3b>
  80261f:	90                   	nop
  802620:	89 c8                	mov    %ecx,%eax
  802622:	89 fa                	mov    %edi,%edx
  802624:	83 c4 14             	add    $0x14,%esp
  802627:	5e                   	pop    %esi
  802628:	5f                   	pop    %edi
  802629:	5d                   	pop    %ebp
  80262a:	c3                   	ret    
  80262b:	90                   	nop
  80262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802630:	8b 04 24             	mov    (%esp),%eax
  802633:	be 20 00 00 00       	mov    $0x20,%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	29 ee                	sub    %ebp,%esi
  80263c:	d3 e2                	shl    %cl,%edx
  80263e:	89 f1                	mov    %esi,%ecx
  802640:	d3 e8                	shr    %cl,%eax
  802642:	89 e9                	mov    %ebp,%ecx
  802644:	89 44 24 04          	mov    %eax,0x4(%esp)
  802648:	8b 04 24             	mov    (%esp),%eax
  80264b:	09 54 24 04          	or     %edx,0x4(%esp)
  80264f:	89 fa                	mov    %edi,%edx
  802651:	d3 e0                	shl    %cl,%eax
  802653:	89 f1                	mov    %esi,%ecx
  802655:	89 44 24 08          	mov    %eax,0x8(%esp)
  802659:	8b 44 24 10          	mov    0x10(%esp),%eax
  80265d:	d3 ea                	shr    %cl,%edx
  80265f:	89 e9                	mov    %ebp,%ecx
  802661:	d3 e7                	shl    %cl,%edi
  802663:	89 f1                	mov    %esi,%ecx
  802665:	d3 e8                	shr    %cl,%eax
  802667:	89 e9                	mov    %ebp,%ecx
  802669:	09 f8                	or     %edi,%eax
  80266b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80266f:	f7 74 24 04          	divl   0x4(%esp)
  802673:	d3 e7                	shl    %cl,%edi
  802675:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802679:	89 d7                	mov    %edx,%edi
  80267b:	f7 64 24 08          	mull   0x8(%esp)
  80267f:	39 d7                	cmp    %edx,%edi
  802681:	89 c1                	mov    %eax,%ecx
  802683:	89 14 24             	mov    %edx,(%esp)
  802686:	72 2c                	jb     8026b4 <__umoddi3+0x134>
  802688:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80268c:	72 22                	jb     8026b0 <__umoddi3+0x130>
  80268e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802692:	29 c8                	sub    %ecx,%eax
  802694:	19 d7                	sbb    %edx,%edi
  802696:	89 e9                	mov    %ebp,%ecx
  802698:	89 fa                	mov    %edi,%edx
  80269a:	d3 e8                	shr    %cl,%eax
  80269c:	89 f1                	mov    %esi,%ecx
  80269e:	d3 e2                	shl    %cl,%edx
  8026a0:	89 e9                	mov    %ebp,%ecx
  8026a2:	d3 ef                	shr    %cl,%edi
  8026a4:	09 d0                	or     %edx,%eax
  8026a6:	89 fa                	mov    %edi,%edx
  8026a8:	83 c4 14             	add    $0x14,%esp
  8026ab:	5e                   	pop    %esi
  8026ac:	5f                   	pop    %edi
  8026ad:	5d                   	pop    %ebp
  8026ae:	c3                   	ret    
  8026af:	90                   	nop
  8026b0:	39 d7                	cmp    %edx,%edi
  8026b2:	75 da                	jne    80268e <__umoddi3+0x10e>
  8026b4:	8b 14 24             	mov    (%esp),%edx
  8026b7:	89 c1                	mov    %eax,%ecx
  8026b9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026bd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026c1:	eb cb                	jmp    80268e <__umoddi3+0x10e>
  8026c3:	90                   	nop
  8026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026cc:	0f 82 0f ff ff ff    	jb     8025e1 <__umoddi3+0x61>
  8026d2:	e9 1a ff ff ff       	jmp    8025f1 <__umoddi3+0x71>
