
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 8e 00 00 00       	call   8000bf <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800047:	c7 04 24 20 2a 80 00 	movl   $0x802a20,(%esp)
  80004e:	e8 7a 01 00 00       	call   8001cd <cprintf>
	if ((env = fork()) == 0) {
  800053:	e8 ee 0f 00 00       	call   801046 <fork>
  800058:	89 c3                	mov    %eax,%ebx
  80005a:	85 c0                	test   %eax,%eax
  80005c:	75 0e                	jne    80006c <umain+0x2c>
		cprintf("I am the child.  Spinning...\n");
  80005e:	c7 04 24 98 2a 80 00 	movl   $0x802a98,(%esp)
  800065:	e8 63 01 00 00       	call   8001cd <cprintf>
  80006a:	eb fe                	jmp    80006a <umain+0x2a>
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  80006c:	c7 04 24 48 2a 80 00 	movl   $0x802a48,(%esp)
  800073:	e8 55 01 00 00       	call   8001cd <cprintf>
	sys_yield();
  800078:	e8 77 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  80007d:	e8 72 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  800082:	e8 6d 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  800087:	e8 68 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  80008c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800090:	e8 5f 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  800095:	e8 5a 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  80009a:	e8 55 0b 00 00       	call   800bf4 <sys_yield>
	sys_yield();
  80009f:	90                   	nop
  8000a0:	e8 4f 0b 00 00       	call   800bf4 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  8000a5:	c7 04 24 70 2a 80 00 	movl   $0x802a70,(%esp)
  8000ac:	e8 1c 01 00 00       	call   8001cd <cprintf>
	sys_env_destroy(env);
  8000b1:	89 1c 24             	mov    %ebx,(%esp)
  8000b4:	e8 ca 0a 00 00       	call   800b83 <sys_env_destroy>
}
  8000b9:	83 c4 14             	add    $0x14,%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5d                   	pop    %ebp
  8000be:	c3                   	ret    

008000bf <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 10             	sub    $0x10,%esp
  8000c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ca:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000cd:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8000d4:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8000d7:	e8 f9 0a 00 00       	call   800bd5 <sys_getenvid>
  8000dc:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8000e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000e4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e9:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ee:	85 db                	test   %ebx,%ebx
  8000f0:	7e 07                	jle    8000f9 <libmain+0x3a>
		binaryname = argv[0];
  8000f2:	8b 06                	mov    (%esi),%eax
  8000f4:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000fd:	89 1c 24             	mov    %ebx,(%esp)
  800100:	e8 3b ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800105:	e8 07 00 00 00       	call   800111 <exit>
}
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	5b                   	pop    %ebx
  80010e:	5e                   	pop    %esi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800117:	e8 5e 13 00 00       	call   80147a <close_all>
	sys_env_destroy(0);
  80011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800123:	e8 5b 0a 00 00       	call   800b83 <sys_env_destroy>
}
  800128:	c9                   	leave  
  800129:	c3                   	ret    

0080012a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	53                   	push   %ebx
  80012e:	83 ec 14             	sub    $0x14,%esp
  800131:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800134:	8b 13                	mov    (%ebx),%edx
  800136:	8d 42 01             	lea    0x1(%edx),%eax
  800139:	89 03                	mov    %eax,(%ebx)
  80013b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80013e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800142:	3d ff 00 00 00       	cmp    $0xff,%eax
  800147:	75 19                	jne    800162 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800149:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800150:	00 
  800151:	8d 43 08             	lea    0x8(%ebx),%eax
  800154:	89 04 24             	mov    %eax,(%esp)
  800157:	e8 ea 09 00 00       	call   800b46 <sys_cputs>
		b->idx = 0;
  80015c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800162:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800166:	83 c4 14             	add    $0x14,%esp
  800169:	5b                   	pop    %ebx
  80016a:	5d                   	pop    %ebp
  80016b:	c3                   	ret    

0080016c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800175:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80017c:	00 00 00 
	b.cnt = 0;
  80017f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800186:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800190:	8b 45 08             	mov    0x8(%ebp),%eax
  800193:	89 44 24 08          	mov    %eax,0x8(%esp)
  800197:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80019d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a1:	c7 04 24 2a 01 80 00 	movl   $0x80012a,(%esp)
  8001a8:	e8 b1 01 00 00       	call   80035e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001ad:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001bd:	89 04 24             	mov    %eax,(%esp)
  8001c0:	e8 81 09 00 00       	call   800b46 <sys_cputs>

	return b.cnt;
}
  8001c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001cb:	c9                   	leave  
  8001cc:	c3                   	ret    

008001cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001d3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001da:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dd:	89 04 24             	mov    %eax,(%esp)
  8001e0:	e8 87 ff ff ff       	call   80016c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001e5:	c9                   	leave  
  8001e6:	c3                   	ret    
  8001e7:	66 90                	xchg   %ax,%ax
  8001e9:	66 90                	xchg   %ax,%ax
  8001eb:	66 90                	xchg   %ax,%ax
  8001ed:	66 90                	xchg   %ax,%ax
  8001ef:	90                   	nop

008001f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 3c             	sub    $0x3c,%esp
  8001f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001fc:	89 d7                	mov    %edx,%edi
  8001fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800201:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800204:	8b 45 0c             	mov    0xc(%ebp),%eax
  800207:	89 c3                	mov    %eax,%ebx
  800209:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80020c:	8b 45 10             	mov    0x10(%ebp),%eax
  80020f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800212:	b9 00 00 00 00       	mov    $0x0,%ecx
  800217:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80021a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80021d:	39 d9                	cmp    %ebx,%ecx
  80021f:	72 05                	jb     800226 <printnum+0x36>
  800221:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800224:	77 69                	ja     80028f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800226:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800229:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80022d:	83 ee 01             	sub    $0x1,%esi
  800230:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800234:	89 44 24 08          	mov    %eax,0x8(%esp)
  800238:	8b 44 24 08          	mov    0x8(%esp),%eax
  80023c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800240:	89 c3                	mov    %eax,%ebx
  800242:	89 d6                	mov    %edx,%esi
  800244:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800247:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80024a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80024e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025f:	e8 1c 25 00 00       	call   802780 <__udivdi3>
  800264:	89 d9                	mov    %ebx,%ecx
  800266:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80026a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80026e:	89 04 24             	mov    %eax,(%esp)
  800271:	89 54 24 04          	mov    %edx,0x4(%esp)
  800275:	89 fa                	mov    %edi,%edx
  800277:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027a:	e8 71 ff ff ff       	call   8001f0 <printnum>
  80027f:	eb 1b                	jmp    80029c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800281:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800285:	8b 45 18             	mov    0x18(%ebp),%eax
  800288:	89 04 24             	mov    %eax,(%esp)
  80028b:	ff d3                	call   *%ebx
  80028d:	eb 03                	jmp    800292 <printnum+0xa2>
  80028f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800292:	83 ee 01             	sub    $0x1,%esi
  800295:	85 f6                	test   %esi,%esi
  800297:	7f e8                	jg     800281 <printnum+0x91>
  800299:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80029c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002a0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b5:	89 04 24             	mov    %eax,(%esp)
  8002b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bf:	e8 ec 25 00 00       	call   8028b0 <__umoddi3>
  8002c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002c8:	0f be 80 c0 2a 80 00 	movsbl 0x802ac0(%eax),%eax
  8002cf:	89 04 24             	mov    %eax,(%esp)
  8002d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002d5:	ff d0                	call   *%eax
}
  8002d7:	83 c4 3c             	add    $0x3c,%esp
  8002da:	5b                   	pop    %ebx
  8002db:	5e                   	pop    %esi
  8002dc:	5f                   	pop    %edi
  8002dd:	5d                   	pop    %ebp
  8002de:	c3                   	ret    

008002df <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002e2:	83 fa 01             	cmp    $0x1,%edx
  8002e5:	7e 0e                	jle    8002f5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002e7:	8b 10                	mov    (%eax),%edx
  8002e9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002ec:	89 08                	mov    %ecx,(%eax)
  8002ee:	8b 02                	mov    (%edx),%eax
  8002f0:	8b 52 04             	mov    0x4(%edx),%edx
  8002f3:	eb 22                	jmp    800317 <getuint+0x38>
	else if (lflag)
  8002f5:	85 d2                	test   %edx,%edx
  8002f7:	74 10                	je     800309 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002f9:	8b 10                	mov    (%eax),%edx
  8002fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002fe:	89 08                	mov    %ecx,(%eax)
  800300:	8b 02                	mov    (%edx),%eax
  800302:	ba 00 00 00 00       	mov    $0x0,%edx
  800307:	eb 0e                	jmp    800317 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800309:	8b 10                	mov    (%eax),%edx
  80030b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80030e:	89 08                	mov    %ecx,(%eax)
  800310:	8b 02                	mov    (%edx),%eax
  800312:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800317:	5d                   	pop    %ebp
  800318:	c3                   	ret    

00800319 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80031f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800323:	8b 10                	mov    (%eax),%edx
  800325:	3b 50 04             	cmp    0x4(%eax),%edx
  800328:	73 0a                	jae    800334 <sprintputch+0x1b>
		*b->buf++ = ch;
  80032a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80032d:	89 08                	mov    %ecx,(%eax)
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	88 02                	mov    %al,(%edx)
}
  800334:	5d                   	pop    %ebp
  800335:	c3                   	ret    

00800336 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800336:	55                   	push   %ebp
  800337:	89 e5                	mov    %esp,%ebp
  800339:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80033c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80033f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800343:	8b 45 10             	mov    0x10(%ebp),%eax
  800346:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800351:	8b 45 08             	mov    0x8(%ebp),%eax
  800354:	89 04 24             	mov    %eax,(%esp)
  800357:	e8 02 00 00 00       	call   80035e <vprintfmt>
	va_end(ap);
}
  80035c:	c9                   	leave  
  80035d:	c3                   	ret    

0080035e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80035e:	55                   	push   %ebp
  80035f:	89 e5                	mov    %esp,%ebp
  800361:	57                   	push   %edi
  800362:	56                   	push   %esi
  800363:	53                   	push   %ebx
  800364:	83 ec 3c             	sub    $0x3c,%esp
  800367:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80036a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80036d:	eb 14                	jmp    800383 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80036f:	85 c0                	test   %eax,%eax
  800371:	0f 84 b3 03 00 00    	je     80072a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800377:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80037b:	89 04 24             	mov    %eax,(%esp)
  80037e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800381:	89 f3                	mov    %esi,%ebx
  800383:	8d 73 01             	lea    0x1(%ebx),%esi
  800386:	0f b6 03             	movzbl (%ebx),%eax
  800389:	83 f8 25             	cmp    $0x25,%eax
  80038c:	75 e1                	jne    80036f <vprintfmt+0x11>
  80038e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800392:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800399:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003a0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8003a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ac:	eb 1d                	jmp    8003cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ae:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003b0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003b4:	eb 15                	jmp    8003cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003b8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003bc:	eb 0d                	jmp    8003cb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003c4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003cb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003ce:	0f b6 0e             	movzbl (%esi),%ecx
  8003d1:	0f b6 c1             	movzbl %cl,%eax
  8003d4:	83 e9 23             	sub    $0x23,%ecx
  8003d7:	80 f9 55             	cmp    $0x55,%cl
  8003da:	0f 87 2a 03 00 00    	ja     80070a <vprintfmt+0x3ac>
  8003e0:	0f b6 c9             	movzbl %cl,%ecx
  8003e3:	ff 24 8d 00 2c 80 00 	jmp    *0x802c00(,%ecx,4)
  8003ea:	89 de                	mov    %ebx,%esi
  8003ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003f1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003f4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003f8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003fb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003fe:	83 fb 09             	cmp    $0x9,%ebx
  800401:	77 36                	ja     800439 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800403:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800406:	eb e9                	jmp    8003f1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800408:	8b 45 14             	mov    0x14(%ebp),%eax
  80040b:	8d 48 04             	lea    0x4(%eax),%ecx
  80040e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800416:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800418:	eb 22                	jmp    80043c <vprintfmt+0xde>
  80041a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80041d:	85 c9                	test   %ecx,%ecx
  80041f:	b8 00 00 00 00       	mov    $0x0,%eax
  800424:	0f 49 c1             	cmovns %ecx,%eax
  800427:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	89 de                	mov    %ebx,%esi
  80042c:	eb 9d                	jmp    8003cb <vprintfmt+0x6d>
  80042e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800430:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800437:	eb 92                	jmp    8003cb <vprintfmt+0x6d>
  800439:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80043c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800440:	79 89                	jns    8003cb <vprintfmt+0x6d>
  800442:	e9 77 ff ff ff       	jmp    8003be <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800447:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80044c:	e9 7a ff ff ff       	jmp    8003cb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800451:	8b 45 14             	mov    0x14(%ebp),%eax
  800454:	8d 50 04             	lea    0x4(%eax),%edx
  800457:	89 55 14             	mov    %edx,0x14(%ebp)
  80045a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80045e:	8b 00                	mov    (%eax),%eax
  800460:	89 04 24             	mov    %eax,(%esp)
  800463:	ff 55 08             	call   *0x8(%ebp)
			break;
  800466:	e9 18 ff ff ff       	jmp    800383 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80046b:	8b 45 14             	mov    0x14(%ebp),%eax
  80046e:	8d 50 04             	lea    0x4(%eax),%edx
  800471:	89 55 14             	mov    %edx,0x14(%ebp)
  800474:	8b 00                	mov    (%eax),%eax
  800476:	99                   	cltd   
  800477:	31 d0                	xor    %edx,%eax
  800479:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80047b:	83 f8 0f             	cmp    $0xf,%eax
  80047e:	7f 0b                	jg     80048b <vprintfmt+0x12d>
  800480:	8b 14 85 60 2d 80 00 	mov    0x802d60(,%eax,4),%edx
  800487:	85 d2                	test   %edx,%edx
  800489:	75 20                	jne    8004ab <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80048b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80048f:	c7 44 24 08 d8 2a 80 	movl   $0x802ad8,0x8(%esp)
  800496:	00 
  800497:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	89 04 24             	mov    %eax,(%esp)
  8004a1:	e8 90 fe ff ff       	call   800336 <printfmt>
  8004a6:	e9 d8 fe ff ff       	jmp    800383 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004af:	c7 44 24 08 25 30 80 	movl   $0x803025,0x8(%esp)
  8004b6:	00 
  8004b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	e8 70 fe ff ff       	call   800336 <printfmt>
  8004c6:	e9 b8 fe ff ff       	jmp    800383 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004cb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d7:	8d 50 04             	lea    0x4(%eax),%edx
  8004da:	89 55 14             	mov    %edx,0x14(%ebp)
  8004dd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004df:	85 f6                	test   %esi,%esi
  8004e1:	b8 d1 2a 80 00       	mov    $0x802ad1,%eax
  8004e6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8004e9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004ed:	0f 84 97 00 00 00    	je     80058a <vprintfmt+0x22c>
  8004f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004f7:	0f 8e 9b 00 00 00    	jle    800598 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004fd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800501:	89 34 24             	mov    %esi,(%esp)
  800504:	e8 cf 02 00 00       	call   8007d8 <strnlen>
  800509:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050c:	29 c2                	sub    %eax,%edx
  80050e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800511:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800515:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800518:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80051b:	8b 75 08             	mov    0x8(%ebp),%esi
  80051e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800521:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800523:	eb 0f                	jmp    800534 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800525:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800529:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80052c:	89 04 24             	mov    %eax,(%esp)
  80052f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800531:	83 eb 01             	sub    $0x1,%ebx
  800534:	85 db                	test   %ebx,%ebx
  800536:	7f ed                	jg     800525 <vprintfmt+0x1c7>
  800538:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80053b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80053e:	85 d2                	test   %edx,%edx
  800540:	b8 00 00 00 00       	mov    $0x0,%eax
  800545:	0f 49 c2             	cmovns %edx,%eax
  800548:	29 c2                	sub    %eax,%edx
  80054a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80054d:	89 d7                	mov    %edx,%edi
  80054f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800552:	eb 50                	jmp    8005a4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800554:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800558:	74 1e                	je     800578 <vprintfmt+0x21a>
  80055a:	0f be d2             	movsbl %dl,%edx
  80055d:	83 ea 20             	sub    $0x20,%edx
  800560:	83 fa 5e             	cmp    $0x5e,%edx
  800563:	76 13                	jbe    800578 <vprintfmt+0x21a>
					putch('?', putdat);
  800565:	8b 45 0c             	mov    0xc(%ebp),%eax
  800568:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800573:	ff 55 08             	call   *0x8(%ebp)
  800576:	eb 0d                	jmp    800585 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800578:	8b 55 0c             	mov    0xc(%ebp),%edx
  80057b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800585:	83 ef 01             	sub    $0x1,%edi
  800588:	eb 1a                	jmp    8005a4 <vprintfmt+0x246>
  80058a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80058d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800590:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800593:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800596:	eb 0c                	jmp    8005a4 <vprintfmt+0x246>
  800598:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80059b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80059e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005a1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005a4:	83 c6 01             	add    $0x1,%esi
  8005a7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005ab:	0f be c2             	movsbl %dl,%eax
  8005ae:	85 c0                	test   %eax,%eax
  8005b0:	74 27                	je     8005d9 <vprintfmt+0x27b>
  8005b2:	85 db                	test   %ebx,%ebx
  8005b4:	78 9e                	js     800554 <vprintfmt+0x1f6>
  8005b6:	83 eb 01             	sub    $0x1,%ebx
  8005b9:	79 99                	jns    800554 <vprintfmt+0x1f6>
  8005bb:	89 f8                	mov    %edi,%eax
  8005bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005c3:	89 c3                	mov    %eax,%ebx
  8005c5:	eb 1a                	jmp    8005e1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005d2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d4:	83 eb 01             	sub    $0x1,%ebx
  8005d7:	eb 08                	jmp    8005e1 <vprintfmt+0x283>
  8005d9:	89 fb                	mov    %edi,%ebx
  8005db:	8b 75 08             	mov    0x8(%ebp),%esi
  8005de:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005e1:	85 db                	test   %ebx,%ebx
  8005e3:	7f e2                	jg     8005c7 <vprintfmt+0x269>
  8005e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005eb:	e9 93 fd ff ff       	jmp    800383 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005f0:	83 fa 01             	cmp    $0x1,%edx
  8005f3:	7e 16                	jle    80060b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 50 08             	lea    0x8(%eax),%edx
  8005fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005fe:	8b 50 04             	mov    0x4(%eax),%edx
  800601:	8b 00                	mov    (%eax),%eax
  800603:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800606:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800609:	eb 32                	jmp    80063d <vprintfmt+0x2df>
	else if (lflag)
  80060b:	85 d2                	test   %edx,%edx
  80060d:	74 18                	je     800627 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80060f:	8b 45 14             	mov    0x14(%ebp),%eax
  800612:	8d 50 04             	lea    0x4(%eax),%edx
  800615:	89 55 14             	mov    %edx,0x14(%ebp)
  800618:	8b 30                	mov    (%eax),%esi
  80061a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80061d:	89 f0                	mov    %esi,%eax
  80061f:	c1 f8 1f             	sar    $0x1f,%eax
  800622:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800625:	eb 16                	jmp    80063d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 50 04             	lea    0x4(%eax),%edx
  80062d:	89 55 14             	mov    %edx,0x14(%ebp)
  800630:	8b 30                	mov    (%eax),%esi
  800632:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800635:	89 f0                	mov    %esi,%eax
  800637:	c1 f8 1f             	sar    $0x1f,%eax
  80063a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80063d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800640:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800643:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064c:	0f 89 80 00 00 00    	jns    8006d2 <vprintfmt+0x374>
				putch('-', putdat);
  800652:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800656:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80065d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800660:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800663:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800666:	f7 d8                	neg    %eax
  800668:	83 d2 00             	adc    $0x0,%edx
  80066b:	f7 da                	neg    %edx
			}
			base = 10;
  80066d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800672:	eb 5e                	jmp    8006d2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800674:	8d 45 14             	lea    0x14(%ebp),%eax
  800677:	e8 63 fc ff ff       	call   8002df <getuint>
			base = 10;
  80067c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800681:	eb 4f                	jmp    8006d2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800683:	8d 45 14             	lea    0x14(%ebp),%eax
  800686:	e8 54 fc ff ff       	call   8002df <getuint>
			base =8;
  80068b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800690:	eb 40                	jmp    8006d2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800692:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800696:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80069d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006ab:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 50 04             	lea    0x4(%eax),%edx
  8006b4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006be:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006c3:	eb 0d                	jmp    8006d2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c8:	e8 12 fc ff ff       	call   8002df <getuint>
			base = 16;
  8006cd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006d2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8006d6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006da:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8006dd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006e5:	89 04 24             	mov    %eax,(%esp)
  8006e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006ec:	89 fa                	mov    %edi,%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	e8 fa fa ff ff       	call   8001f0 <printnum>
			break;
  8006f6:	e9 88 fc ff ff       	jmp    800383 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	ff 55 08             	call   *0x8(%ebp)
			break;
  800705:	e9 79 fc ff ff       	jmp    800383 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80070a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800715:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800718:	89 f3                	mov    %esi,%ebx
  80071a:	eb 03                	jmp    80071f <vprintfmt+0x3c1>
  80071c:	83 eb 01             	sub    $0x1,%ebx
  80071f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800723:	75 f7                	jne    80071c <vprintfmt+0x3be>
  800725:	e9 59 fc ff ff       	jmp    800383 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80072a:	83 c4 3c             	add    $0x3c,%esp
  80072d:	5b                   	pop    %ebx
  80072e:	5e                   	pop    %esi
  80072f:	5f                   	pop    %edi
  800730:	5d                   	pop    %ebp
  800731:	c3                   	ret    

00800732 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
  800735:	83 ec 28             	sub    $0x28,%esp
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80073e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800741:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800745:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800748:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80074f:	85 c0                	test   %eax,%eax
  800751:	74 30                	je     800783 <vsnprintf+0x51>
  800753:	85 d2                	test   %edx,%edx
  800755:	7e 2c                	jle    800783 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80075e:	8b 45 10             	mov    0x10(%ebp),%eax
  800761:	89 44 24 08          	mov    %eax,0x8(%esp)
  800765:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80076c:	c7 04 24 19 03 80 00 	movl   $0x800319,(%esp)
  800773:	e8 e6 fb ff ff       	call   80035e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80077e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800781:	eb 05                	jmp    800788 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800783:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800790:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800793:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800797:	8b 45 10             	mov    0x10(%ebp),%eax
  80079a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	89 04 24             	mov    %eax,(%esp)
  8007ab:	e8 82 ff ff ff       	call   800732 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b0:	c9                   	leave  
  8007b1:	c3                   	ret    
  8007b2:	66 90                	xchg   %ax,%ax
  8007b4:	66 90                	xchg   %ax,%ax
  8007b6:	66 90                	xchg   %ax,%ax
  8007b8:	66 90                	xchg   %ax,%ax
  8007ba:	66 90                	xchg   %ax,%ax
  8007bc:	66 90                	xchg   %ax,%ax
  8007be:	66 90                	xchg   %ax,%ax

008007c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007c0:	55                   	push   %ebp
  8007c1:	89 e5                	mov    %esp,%ebp
  8007c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007cb:	eb 03                	jmp    8007d0 <strlen+0x10>
		n++;
  8007cd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007d4:	75 f7                	jne    8007cd <strlen+0xd>
		n++;
	return n;
}
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007de:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e6:	eb 03                	jmp    8007eb <strnlen+0x13>
		n++;
  8007e8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007eb:	39 d0                	cmp    %edx,%eax
  8007ed:	74 06                	je     8007f5 <strnlen+0x1d>
  8007ef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007f3:	75 f3                	jne    8007e8 <strnlen+0x10>
		n++;
	return n;
}
  8007f5:	5d                   	pop    %ebp
  8007f6:	c3                   	ret    

008007f7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	53                   	push   %ebx
  8007fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800801:	89 c2                	mov    %eax,%edx
  800803:	83 c2 01             	add    $0x1,%edx
  800806:	83 c1 01             	add    $0x1,%ecx
  800809:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80080d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800810:	84 db                	test   %bl,%bl
  800812:	75 ef                	jne    800803 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800814:	5b                   	pop    %ebx
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800821:	89 1c 24             	mov    %ebx,(%esp)
  800824:	e8 97 ff ff ff       	call   8007c0 <strlen>
	strcpy(dst + len, src);
  800829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800830:	01 d8                	add    %ebx,%eax
  800832:	89 04 24             	mov    %eax,(%esp)
  800835:	e8 bd ff ff ff       	call   8007f7 <strcpy>
	return dst;
}
  80083a:	89 d8                	mov    %ebx,%eax
  80083c:	83 c4 08             	add    $0x8,%esp
  80083f:	5b                   	pop    %ebx
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	56                   	push   %esi
  800846:	53                   	push   %ebx
  800847:	8b 75 08             	mov    0x8(%ebp),%esi
  80084a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084d:	89 f3                	mov    %esi,%ebx
  80084f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800852:	89 f2                	mov    %esi,%edx
  800854:	eb 0f                	jmp    800865 <strncpy+0x23>
		*dst++ = *src;
  800856:	83 c2 01             	add    $0x1,%edx
  800859:	0f b6 01             	movzbl (%ecx),%eax
  80085c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80085f:	80 39 01             	cmpb   $0x1,(%ecx)
  800862:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800865:	39 da                	cmp    %ebx,%edx
  800867:	75 ed                	jne    800856 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800869:	89 f0                	mov    %esi,%eax
  80086b:	5b                   	pop    %ebx
  80086c:	5e                   	pop    %esi
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	56                   	push   %esi
  800873:	53                   	push   %ebx
  800874:	8b 75 08             	mov    0x8(%ebp),%esi
  800877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80087d:	89 f0                	mov    %esi,%eax
  80087f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800883:	85 c9                	test   %ecx,%ecx
  800885:	75 0b                	jne    800892 <strlcpy+0x23>
  800887:	eb 1d                	jmp    8008a6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800889:	83 c0 01             	add    $0x1,%eax
  80088c:	83 c2 01             	add    $0x1,%edx
  80088f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800892:	39 d8                	cmp    %ebx,%eax
  800894:	74 0b                	je     8008a1 <strlcpy+0x32>
  800896:	0f b6 0a             	movzbl (%edx),%ecx
  800899:	84 c9                	test   %cl,%cl
  80089b:	75 ec                	jne    800889 <strlcpy+0x1a>
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	eb 02                	jmp    8008a3 <strlcpy+0x34>
  8008a1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008a3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008a6:	29 f0                	sub    %esi,%eax
}
  8008a8:	5b                   	pop    %ebx
  8008a9:	5e                   	pop    %esi
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008b5:	eb 06                	jmp    8008bd <strcmp+0x11>
		p++, q++;
  8008b7:	83 c1 01             	add    $0x1,%ecx
  8008ba:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008bd:	0f b6 01             	movzbl (%ecx),%eax
  8008c0:	84 c0                	test   %al,%al
  8008c2:	74 04                	je     8008c8 <strcmp+0x1c>
  8008c4:	3a 02                	cmp    (%edx),%al
  8008c6:	74 ef                	je     8008b7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c8:	0f b6 c0             	movzbl %al,%eax
  8008cb:	0f b6 12             	movzbl (%edx),%edx
  8008ce:	29 d0                	sub    %edx,%eax
}
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	53                   	push   %ebx
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	89 c3                	mov    %eax,%ebx
  8008de:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008e1:	eb 06                	jmp    8008e9 <strncmp+0x17>
		n--, p++, q++;
  8008e3:	83 c0 01             	add    $0x1,%eax
  8008e6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008e9:	39 d8                	cmp    %ebx,%eax
  8008eb:	74 15                	je     800902 <strncmp+0x30>
  8008ed:	0f b6 08             	movzbl (%eax),%ecx
  8008f0:	84 c9                	test   %cl,%cl
  8008f2:	74 04                	je     8008f8 <strncmp+0x26>
  8008f4:	3a 0a                	cmp    (%edx),%cl
  8008f6:	74 eb                	je     8008e3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f8:	0f b6 00             	movzbl (%eax),%eax
  8008fb:	0f b6 12             	movzbl (%edx),%edx
  8008fe:	29 d0                	sub    %edx,%eax
  800900:	eb 05                	jmp    800907 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800902:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800907:	5b                   	pop    %ebx
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800914:	eb 07                	jmp    80091d <strchr+0x13>
		if (*s == c)
  800916:	38 ca                	cmp    %cl,%dl
  800918:	74 0f                	je     800929 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80091a:	83 c0 01             	add    $0x1,%eax
  80091d:	0f b6 10             	movzbl (%eax),%edx
  800920:	84 d2                	test   %dl,%dl
  800922:	75 f2                	jne    800916 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800924:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800935:	eb 07                	jmp    80093e <strfind+0x13>
		if (*s == c)
  800937:	38 ca                	cmp    %cl,%dl
  800939:	74 0a                	je     800945 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80093b:	83 c0 01             	add    $0x1,%eax
  80093e:	0f b6 10             	movzbl (%eax),%edx
  800941:	84 d2                	test   %dl,%dl
  800943:	75 f2                	jne    800937 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	57                   	push   %edi
  80094b:	56                   	push   %esi
  80094c:	53                   	push   %ebx
  80094d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800950:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800953:	85 c9                	test   %ecx,%ecx
  800955:	74 36                	je     80098d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800957:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80095d:	75 28                	jne    800987 <memset+0x40>
  80095f:	f6 c1 03             	test   $0x3,%cl
  800962:	75 23                	jne    800987 <memset+0x40>
		c &= 0xFF;
  800964:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800968:	89 d3                	mov    %edx,%ebx
  80096a:	c1 e3 08             	shl    $0x8,%ebx
  80096d:	89 d6                	mov    %edx,%esi
  80096f:	c1 e6 18             	shl    $0x18,%esi
  800972:	89 d0                	mov    %edx,%eax
  800974:	c1 e0 10             	shl    $0x10,%eax
  800977:	09 f0                	or     %esi,%eax
  800979:	09 c2                	or     %eax,%edx
  80097b:	89 d0                	mov    %edx,%eax
  80097d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80097f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800982:	fc                   	cld    
  800983:	f3 ab                	rep stos %eax,%es:(%edi)
  800985:	eb 06                	jmp    80098d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	fc                   	cld    
  80098b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80098d:	89 f8                	mov    %edi,%eax
  80098f:	5b                   	pop    %ebx
  800990:	5e                   	pop    %esi
  800991:	5f                   	pop    %edi
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	57                   	push   %edi
  800998:	56                   	push   %esi
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80099f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009a2:	39 c6                	cmp    %eax,%esi
  8009a4:	73 35                	jae    8009db <memmove+0x47>
  8009a6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009a9:	39 d0                	cmp    %edx,%eax
  8009ab:	73 2e                	jae    8009db <memmove+0x47>
		s += n;
		d += n;
  8009ad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009b0:	89 d6                	mov    %edx,%esi
  8009b2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009b4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ba:	75 13                	jne    8009cf <memmove+0x3b>
  8009bc:	f6 c1 03             	test   $0x3,%cl
  8009bf:	75 0e                	jne    8009cf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009c1:	83 ef 04             	sub    $0x4,%edi
  8009c4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009c7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009ca:	fd                   	std    
  8009cb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009cd:	eb 09                	jmp    8009d8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009cf:	83 ef 01             	sub    $0x1,%edi
  8009d2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009d5:	fd                   	std    
  8009d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009d8:	fc                   	cld    
  8009d9:	eb 1d                	jmp    8009f8 <memmove+0x64>
  8009db:	89 f2                	mov    %esi,%edx
  8009dd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009df:	f6 c2 03             	test   $0x3,%dl
  8009e2:	75 0f                	jne    8009f3 <memmove+0x5f>
  8009e4:	f6 c1 03             	test   $0x3,%cl
  8009e7:	75 0a                	jne    8009f3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009e9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009ec:	89 c7                	mov    %eax,%edi
  8009ee:	fc                   	cld    
  8009ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009f1:	eb 05                	jmp    8009f8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009f3:	89 c7                	mov    %eax,%edi
  8009f5:	fc                   	cld    
  8009f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009f8:	5e                   	pop    %esi
  8009f9:	5f                   	pop    %edi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	89 04 24             	mov    %eax,(%esp)
  800a16:	e8 79 ff ff ff       	call   800994 <memmove>
}
  800a1b:	c9                   	leave  
  800a1c:	c3                   	ret    

00800a1d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a1d:	55                   	push   %ebp
  800a1e:	89 e5                	mov    %esp,%ebp
  800a20:	56                   	push   %esi
  800a21:	53                   	push   %ebx
  800a22:	8b 55 08             	mov    0x8(%ebp),%edx
  800a25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a28:	89 d6                	mov    %edx,%esi
  800a2a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a2d:	eb 1a                	jmp    800a49 <memcmp+0x2c>
		if (*s1 != *s2)
  800a2f:	0f b6 02             	movzbl (%edx),%eax
  800a32:	0f b6 19             	movzbl (%ecx),%ebx
  800a35:	38 d8                	cmp    %bl,%al
  800a37:	74 0a                	je     800a43 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a39:	0f b6 c0             	movzbl %al,%eax
  800a3c:	0f b6 db             	movzbl %bl,%ebx
  800a3f:	29 d8                	sub    %ebx,%eax
  800a41:	eb 0f                	jmp    800a52 <memcmp+0x35>
		s1++, s2++;
  800a43:	83 c2 01             	add    $0x1,%edx
  800a46:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a49:	39 f2                	cmp    %esi,%edx
  800a4b:	75 e2                	jne    800a2f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a52:	5b                   	pop    %ebx
  800a53:	5e                   	pop    %esi
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a5f:	89 c2                	mov    %eax,%edx
  800a61:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a64:	eb 07                	jmp    800a6d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a66:	38 08                	cmp    %cl,(%eax)
  800a68:	74 07                	je     800a71 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a6a:	83 c0 01             	add    $0x1,%eax
  800a6d:	39 d0                	cmp    %edx,%eax
  800a6f:	72 f5                	jb     800a66 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	57                   	push   %edi
  800a77:	56                   	push   %esi
  800a78:	53                   	push   %ebx
  800a79:	8b 55 08             	mov    0x8(%ebp),%edx
  800a7c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a7f:	eb 03                	jmp    800a84 <strtol+0x11>
		s++;
  800a81:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a84:	0f b6 0a             	movzbl (%edx),%ecx
  800a87:	80 f9 09             	cmp    $0x9,%cl
  800a8a:	74 f5                	je     800a81 <strtol+0xe>
  800a8c:	80 f9 20             	cmp    $0x20,%cl
  800a8f:	74 f0                	je     800a81 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a91:	80 f9 2b             	cmp    $0x2b,%cl
  800a94:	75 0a                	jne    800aa0 <strtol+0x2d>
		s++;
  800a96:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a99:	bf 00 00 00 00       	mov    $0x0,%edi
  800a9e:	eb 11                	jmp    800ab1 <strtol+0x3e>
  800aa0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800aa5:	80 f9 2d             	cmp    $0x2d,%cl
  800aa8:	75 07                	jne    800ab1 <strtol+0x3e>
		s++, neg = 1;
  800aaa:	8d 52 01             	lea    0x1(%edx),%edx
  800aad:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ab6:	75 15                	jne    800acd <strtol+0x5a>
  800ab8:	80 3a 30             	cmpb   $0x30,(%edx)
  800abb:	75 10                	jne    800acd <strtol+0x5a>
  800abd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ac1:	75 0a                	jne    800acd <strtol+0x5a>
		s += 2, base = 16;
  800ac3:	83 c2 02             	add    $0x2,%edx
  800ac6:	b8 10 00 00 00       	mov    $0x10,%eax
  800acb:	eb 10                	jmp    800add <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800acd:	85 c0                	test   %eax,%eax
  800acf:	75 0c                	jne    800add <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ad1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ad3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ad6:	75 05                	jne    800add <strtol+0x6a>
		s++, base = 8;
  800ad8:	83 c2 01             	add    $0x1,%edx
  800adb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800add:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ae2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ae5:	0f b6 0a             	movzbl (%edx),%ecx
  800ae8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800aeb:	89 f0                	mov    %esi,%eax
  800aed:	3c 09                	cmp    $0x9,%al
  800aef:	77 08                	ja     800af9 <strtol+0x86>
			dig = *s - '0';
  800af1:	0f be c9             	movsbl %cl,%ecx
  800af4:	83 e9 30             	sub    $0x30,%ecx
  800af7:	eb 20                	jmp    800b19 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800af9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800afc:	89 f0                	mov    %esi,%eax
  800afe:	3c 19                	cmp    $0x19,%al
  800b00:	77 08                	ja     800b0a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b02:	0f be c9             	movsbl %cl,%ecx
  800b05:	83 e9 57             	sub    $0x57,%ecx
  800b08:	eb 0f                	jmp    800b19 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b0a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b0d:	89 f0                	mov    %esi,%eax
  800b0f:	3c 19                	cmp    $0x19,%al
  800b11:	77 16                	ja     800b29 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b13:	0f be c9             	movsbl %cl,%ecx
  800b16:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b19:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b1c:	7d 0f                	jge    800b2d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b1e:	83 c2 01             	add    $0x1,%edx
  800b21:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b25:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b27:	eb bc                	jmp    800ae5 <strtol+0x72>
  800b29:	89 d8                	mov    %ebx,%eax
  800b2b:	eb 02                	jmp    800b2f <strtol+0xbc>
  800b2d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b33:	74 05                	je     800b3a <strtol+0xc7>
		*endptr = (char *) s;
  800b35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b38:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b3a:	f7 d8                	neg    %eax
  800b3c:	85 ff                	test   %edi,%edi
  800b3e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b41:	5b                   	pop    %ebx
  800b42:	5e                   	pop    %esi
  800b43:	5f                   	pop    %edi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	57                   	push   %edi
  800b4a:	56                   	push   %esi
  800b4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b54:	8b 55 08             	mov    0x8(%ebp),%edx
  800b57:	89 c3                	mov    %eax,%ebx
  800b59:	89 c7                	mov    %eax,%edi
  800b5b:	89 c6                	mov    %eax,%esi
  800b5d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5f                   	pop    %edi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    

00800b64 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	57                   	push   %edi
  800b68:	56                   	push   %esi
  800b69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b74:	89 d1                	mov    %edx,%ecx
  800b76:	89 d3                	mov    %edx,%ebx
  800b78:	89 d7                	mov    %edx,%edi
  800b7a:	89 d6                	mov    %edx,%esi
  800b7c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b7e:	5b                   	pop    %ebx
  800b7f:	5e                   	pop    %esi
  800b80:	5f                   	pop    %edi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b91:	b8 03 00 00 00       	mov    $0x3,%eax
  800b96:	8b 55 08             	mov    0x8(%ebp),%edx
  800b99:	89 cb                	mov    %ecx,%ebx
  800b9b:	89 cf                	mov    %ecx,%edi
  800b9d:	89 ce                	mov    %ecx,%esi
  800b9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	7e 28                	jle    800bcd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ba9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800bb0:	00 
  800bb1:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800bb8:	00 
  800bb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bc0:	00 
  800bc1:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800bc8:	e8 89 19 00 00       	call   802556 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bcd:	83 c4 2c             	add    $0x2c,%esp
  800bd0:	5b                   	pop    %ebx
  800bd1:	5e                   	pop    %esi
  800bd2:	5f                   	pop    %edi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	57                   	push   %edi
  800bd9:	56                   	push   %esi
  800bda:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800be0:	b8 02 00 00 00       	mov    $0x2,%eax
  800be5:	89 d1                	mov    %edx,%ecx
  800be7:	89 d3                	mov    %edx,%ebx
  800be9:	89 d7                	mov    %edx,%edi
  800beb:	89 d6                	mov    %edx,%esi
  800bed:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bef:	5b                   	pop    %ebx
  800bf0:	5e                   	pop    %esi
  800bf1:	5f                   	pop    %edi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <sys_yield>:

void
sys_yield(void)
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
  800bff:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c04:	89 d1                	mov    %edx,%ecx
  800c06:	89 d3                	mov    %edx,%ebx
  800c08:	89 d7                	mov    %edx,%edi
  800c0a:	89 d6                	mov    %edx,%esi
  800c0c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c0e:	5b                   	pop    %ebx
  800c0f:	5e                   	pop    %esi
  800c10:	5f                   	pop    %edi
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800c1c:	be 00 00 00 00       	mov    $0x0,%esi
  800c21:	b8 04 00 00 00       	mov    $0x4,%eax
  800c26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c29:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c2f:	89 f7                	mov    %esi,%edi
  800c31:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c33:	85 c0                	test   %eax,%eax
  800c35:	7e 28                	jle    800c5f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c37:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c3b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c42:	00 
  800c43:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800c4a:	00 
  800c4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c52:	00 
  800c53:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800c5a:	e8 f7 18 00 00       	call   802556 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c5f:	83 c4 2c             	add    $0x2c,%esp
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	57                   	push   %edi
  800c6b:	56                   	push   %esi
  800c6c:	53                   	push   %ebx
  800c6d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c70:	b8 05 00 00 00       	mov    $0x5,%eax
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c7e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c81:	8b 75 18             	mov    0x18(%ebp),%esi
  800c84:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c86:	85 c0                	test   %eax,%eax
  800c88:	7e 28                	jle    800cb2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c8a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c8e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c95:	00 
  800c96:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800c9d:	00 
  800c9e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca5:	00 
  800ca6:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800cad:	e8 a4 18 00 00       	call   802556 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb2:	83 c4 2c             	add    $0x2c,%esp
  800cb5:	5b                   	pop    %ebx
  800cb6:	5e                   	pop    %esi
  800cb7:	5f                   	pop    %edi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	57                   	push   %edi
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
  800cc0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ccd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd3:	89 df                	mov    %ebx,%edi
  800cd5:	89 de                	mov    %ebx,%esi
  800cd7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	7e 28                	jle    800d05 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ce1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ce8:	00 
  800ce9:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800cf0:	00 
  800cf1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf8:	00 
  800cf9:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800d00:	e8 51 18 00 00       	call   802556 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d05:	83 c4 2c             	add    $0x2c,%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    

00800d0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d0d:	55                   	push   %ebp
  800d0e:	89 e5                	mov    %esp,%ebp
  800d10:	57                   	push   %edi
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	89 df                	mov    %ebx,%edi
  800d28:	89 de                	mov    %ebx,%esi
  800d2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d2c:	85 c0                	test   %eax,%eax
  800d2e:	7e 28                	jle    800d58 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d34:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d3b:	00 
  800d3c:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800d43:	00 
  800d44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d4b:	00 
  800d4c:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800d53:	e8 fe 17 00 00       	call   802556 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d58:	83 c4 2c             	add    $0x2c,%esp
  800d5b:	5b                   	pop    %ebx
  800d5c:	5e                   	pop    %esi
  800d5d:	5f                   	pop    %edi
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	57                   	push   %edi
  800d64:	56                   	push   %esi
  800d65:	53                   	push   %ebx
  800d66:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	89 df                	mov    %ebx,%edi
  800d7b:	89 de                	mov    %ebx,%esi
  800d7d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	7e 28                	jle    800dab <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d83:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d87:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d8e:	00 
  800d8f:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800d96:	00 
  800d97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d9e:	00 
  800d9f:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800da6:	e8 ab 17 00 00       	call   802556 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dab:	83 c4 2c             	add    $0x2c,%esp
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	89 df                	mov    %ebx,%edi
  800dce:	89 de                	mov    %ebx,%esi
  800dd0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	7e 28                	jle    800dfe <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dda:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800de1:	00 
  800de2:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800de9:	00 
  800dea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df1:	00 
  800df2:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800df9:	e8 58 17 00 00       	call   802556 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dfe:	83 c4 2c             	add    $0x2c,%esp
  800e01:	5b                   	pop    %ebx
  800e02:	5e                   	pop    %esi
  800e03:	5f                   	pop    %edi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	57                   	push   %edi
  800e0a:	56                   	push   %esi
  800e0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0c:	be 00 00 00 00       	mov    $0x0,%esi
  800e11:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e22:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	57                   	push   %edi
  800e2d:	56                   	push   %esi
  800e2e:	53                   	push   %ebx
  800e2f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e37:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3f:	89 cb                	mov    %ecx,%ebx
  800e41:	89 cf                	mov    %ecx,%edi
  800e43:	89 ce                	mov    %ecx,%esi
  800e45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e47:	85 c0                	test   %eax,%eax
  800e49:	7e 28                	jle    800e73 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e56:	00 
  800e57:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e66:	00 
  800e67:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800e6e:	e8 e3 16 00 00       	call   802556 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e73:	83 c4 2c             	add    $0x2c,%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e81:	ba 00 00 00 00       	mov    $0x0,%edx
  800e86:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e8b:	89 d1                	mov    %edx,%ecx
  800e8d:	89 d3                	mov    %edx,%ebx
  800e8f:	89 d7                	mov    %edx,%edi
  800e91:	89 d6                	mov    %edx,%esi
  800e93:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	89 de                	mov    %ebx,%esi
  800eb7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7e 28                	jle    800ee5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ec8:	00 
  800ec9:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800ed0:	00 
  800ed1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed8:	00 
  800ed9:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800ee0:	e8 71 16 00 00       	call   802556 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800ee5:	83 c4 2c             	add    $0x2c,%esp
  800ee8:	5b                   	pop    %ebx
  800ee9:	5e                   	pop    %esi
  800eea:	5f                   	pop    %edi
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    

00800eed <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efb:	b8 10 00 00 00       	mov    $0x10,%eax
  800f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	89 df                	mov    %ebx,%edi
  800f08:	89 de                	mov    %ebx,%esi
  800f0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	7e 28                	jle    800f38 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f14:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800f1b:	00 
  800f1c:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800f23:	00 
  800f24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f2b:	00 
  800f2c:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800f33:	e8 1e 16 00 00       	call   802556 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  800f38:	83 c4 2c             	add    $0x2c,%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	53                   	push   %ebx
  800f44:	83 ec 24             	sub    $0x24,%esp
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  800f4a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  800f4c:	89 d3                	mov    %edx,%ebx
  800f4e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800f54:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f58:	74 1a                	je     800f74 <pgfault+0x34>
  800f5a:	c1 ea 0c             	shr    $0xc,%edx
  800f5d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800f64:	a8 01                	test   $0x1,%al
  800f66:	74 0c                	je     800f74 <pgfault+0x34>
  800f68:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800f6f:	f6 c4 08             	test   $0x8,%ah
  800f72:	75 1c                	jne    800f90 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  800f74:	c7 44 24 08 ec 2d 80 	movl   $0x802dec,0x8(%esp)
  800f7b:	00 
  800f7c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  800f83:	00 
  800f84:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  800f8b:	e8 c6 15 00 00       	call   802556 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  800f90:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800f97:	00 
  800f98:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800f9f:	00 
  800fa0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fa7:	e8 67 fc ff ff       	call   800c13 <sys_page_alloc>
  800fac:	85 c0                	test   %eax,%eax
  800fae:	79 1c                	jns    800fcc <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  800fb0:	c7 44 24 08 30 2e 80 	movl   $0x802e30,0x8(%esp)
  800fb7:	00 
  800fb8:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800fbf:	00 
  800fc0:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  800fc7:	e8 8a 15 00 00       	call   802556 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  800fcc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800fd3:	00 
  800fd4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800fd8:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  800fdf:	e8 18 fa ff ff       	call   8009fc <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  800fe4:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  800feb:	00 
  800fec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800ff0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800ff7:	00 
  800ff8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800fff:	00 
  801000:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801007:	e8 5b fc ff ff       	call   800c67 <sys_page_map>
  80100c:	85 c0                	test   %eax,%eax
  80100e:	74 1c                	je     80102c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  801010:	c7 44 24 08 46 2f 80 	movl   $0x802f46,0x8(%esp)
  801017:	00 
  801018:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80101f:	00 
  801020:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  801027:	e8 2a 15 00 00       	call   802556 <_panic>
    sys_page_unmap(0,PFTEMP);
  80102c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801033:	00 
  801034:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80103b:	e8 7a fc ff ff       	call   800cba <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801040:	83 c4 24             	add    $0x24,%esp
  801043:	5b                   	pop    %ebx
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	57                   	push   %edi
  80104a:	56                   	push   %esi
  80104b:	53                   	push   %ebx
  80104c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80104f:	c7 04 24 40 0f 80 00 	movl   $0x800f40,(%esp)
  801056:	e8 51 15 00 00       	call   8025ac <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80105b:	b8 07 00 00 00       	mov    $0x7,%eax
  801060:	cd 30                	int    $0x30
  801062:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801065:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801067:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106c:	85 c0                	test   %eax,%eax
  80106e:	75 21                	jne    801091 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801070:	e8 60 fb ff ff       	call   800bd5 <sys_getenvid>
  801075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80107a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80107d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801082:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801087:	b8 00 00 00 00       	mov    $0x0,%eax
  80108c:	e9 de 01 00 00       	jmp    80126f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801091:	89 d8                	mov    %ebx,%eax
  801093:	c1 e8 16             	shr    $0x16,%eax
  801096:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80109d:	a8 01                	test   $0x1,%al
  80109f:	0f 84 58 01 00 00    	je     8011fd <fork+0x1b7>
  8010a5:	89 de                	mov    %ebx,%esi
  8010a7:	c1 ee 0c             	shr    $0xc,%esi
  8010aa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010b1:	83 e0 05             	and    $0x5,%eax
  8010b4:	83 f8 05             	cmp    $0x5,%eax
  8010b7:	0f 85 40 01 00 00    	jne    8011fd <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  8010bd:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010c4:	f6 c4 04             	test   $0x4,%ah
  8010c7:	74 4f                	je     801118 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  8010c9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010d0:	c1 e6 0c             	shl    $0xc,%esi
  8010d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8010d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010dc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8010e0:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8010e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010ef:	e8 73 fb ff ff       	call   800c67 <sys_page_map>
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	0f 89 01 01 00 00    	jns    8011fd <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  8010fc:	c7 44 24 08 50 2e 80 	movl   $0x802e50,0x8(%esp)
  801103:	00 
  801104:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  80110b:	00 
  80110c:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  801113:	e8 3e 14 00 00       	call   802556 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  801118:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80111f:	a8 02                	test   $0x2,%al
  801121:	75 10                	jne    801133 <fork+0xed>
  801123:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80112a:	f6 c4 08             	test   $0x8,%ah
  80112d:	0f 84 87 00 00 00    	je     8011ba <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801133:	c1 e6 0c             	shl    $0xc,%esi
  801136:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80113d:	00 
  80113e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801142:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801146:	89 74 24 04          	mov    %esi,0x4(%esp)
  80114a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801151:	e8 11 fb ff ff       	call   800c67 <sys_page_map>
  801156:	85 c0                	test   %eax,%eax
  801158:	79 1c                	jns    801176 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80115a:	c7 44 24 08 88 2e 80 	movl   $0x802e88,0x8(%esp)
  801161:	00 
  801162:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801169:	00 
  80116a:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  801171:	e8 e0 13 00 00       	call   802556 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801176:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80117d:	00 
  80117e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801182:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801189:	00 
  80118a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80118e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801195:	e8 cd fa ff ff       	call   800c67 <sys_page_map>
  80119a:	85 c0                	test   %eax,%eax
  80119c:	79 5f                	jns    8011fd <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  80119e:	c7 44 24 08 c0 2e 80 	movl   $0x802ec0,0x8(%esp)
  8011a5:	00 
  8011a6:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8011ad:	00 
  8011ae:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  8011b5:	e8 9c 13 00 00       	call   802556 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  8011ba:	c1 e6 0c             	shl    $0xc,%esi
  8011bd:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8011c4:	00 
  8011c5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011c9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d8:	e8 8a fa ff ff       	call   800c67 <sys_page_map>
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	74 1c                	je     8011fd <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  8011e1:	c7 44 24 08 e8 2e 80 	movl   $0x802ee8,0x8(%esp)
  8011e8:	00 
  8011e9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8011f0:	00 
  8011f1:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  8011f8:	e8 59 13 00 00       	call   802556 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  8011fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801203:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801209:	0f 85 82 fe ff ff    	jne    801091 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  80120f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801216:	00 
  801217:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80121e:	ee 
  80121f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801222:	89 04 24             	mov    %eax,(%esp)
  801225:	e8 e9 f9 ff ff       	call   800c13 <sys_page_alloc>
  80122a:	85 c0                	test   %eax,%eax
  80122c:	79 1c                	jns    80124a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  80122e:	c7 44 24 08 1c 2f 80 	movl   $0x802f1c,0x8(%esp)
  801235:	00 
  801236:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  80123d:	00 
  80123e:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  801245:	e8 0c 13 00 00       	call   802556 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  80124a:	c7 44 24 04 1d 26 80 	movl   $0x80261d,0x4(%esp)
  801251:	00 
  801252:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801255:	89 3c 24             	mov    %edi,(%esp)
  801258:	e8 56 fb ff ff       	call   800db3 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80125d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801264:	00 
  801265:	89 3c 24             	mov    %edi,(%esp)
  801268:	e8 a0 fa ff ff       	call   800d0d <sys_env_set_status>
		return child;
  80126d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80126f:	83 c4 2c             	add    $0x2c,%esp
  801272:	5b                   	pop    %ebx
  801273:	5e                   	pop    %esi
  801274:	5f                   	pop    %edi
  801275:	5d                   	pop    %ebp
  801276:	c3                   	ret    

00801277 <sfork>:

// Challenge!
int
sfork(void)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80127d:	c7 44 24 08 64 2f 80 	movl   $0x802f64,0x8(%esp)
  801284:	00 
  801285:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80128c:	00 
  80128d:	c7 04 24 3b 2f 80 00 	movl   $0x802f3b,(%esp)
  801294:	e8 bd 12 00 00       	call   802556 <_panic>
  801299:	66 90                	xchg   %ax,%ax
  80129b:	66 90                	xchg   %ax,%ax
  80129d:	66 90                	xchg   %ax,%ax
  80129f:	90                   	nop

008012a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8012bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    

008012c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012d2:	89 c2                	mov    %eax,%edx
  8012d4:	c1 ea 16             	shr    $0x16,%edx
  8012d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012de:	f6 c2 01             	test   $0x1,%dl
  8012e1:	74 11                	je     8012f4 <fd_alloc+0x2d>
  8012e3:	89 c2                	mov    %eax,%edx
  8012e5:	c1 ea 0c             	shr    $0xc,%edx
  8012e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ef:	f6 c2 01             	test   $0x1,%dl
  8012f2:	75 09                	jne    8012fd <fd_alloc+0x36>
			*fd_store = fd;
  8012f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fb:	eb 17                	jmp    801314 <fd_alloc+0x4d>
  8012fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801302:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801307:	75 c9                	jne    8012d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801309:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80130f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    

00801316 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80131c:	83 f8 1f             	cmp    $0x1f,%eax
  80131f:	77 36                	ja     801357 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801321:	c1 e0 0c             	shl    $0xc,%eax
  801324:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801329:	89 c2                	mov    %eax,%edx
  80132b:	c1 ea 16             	shr    $0x16,%edx
  80132e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801335:	f6 c2 01             	test   $0x1,%dl
  801338:	74 24                	je     80135e <fd_lookup+0x48>
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	c1 ea 0c             	shr    $0xc,%edx
  80133f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801346:	f6 c2 01             	test   $0x1,%dl
  801349:	74 1a                	je     801365 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80134b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134e:	89 02                	mov    %eax,(%edx)
	return 0;
  801350:	b8 00 00 00 00       	mov    $0x0,%eax
  801355:	eb 13                	jmp    80136a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801357:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135c:	eb 0c                	jmp    80136a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80135e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801363:	eb 05                	jmp    80136a <fd_lookup+0x54>
  801365:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    

0080136c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 18             	sub    $0x18,%esp
  801372:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801375:	ba 00 00 00 00       	mov    $0x0,%edx
  80137a:	eb 13                	jmp    80138f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80137c:	39 08                	cmp    %ecx,(%eax)
  80137e:	75 0c                	jne    80138c <dev_lookup+0x20>
			*dev = devtab[i];
  801380:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801383:	89 01                	mov    %eax,(%ecx)
			return 0;
  801385:	b8 00 00 00 00       	mov    $0x0,%eax
  80138a:	eb 38                	jmp    8013c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80138c:	83 c2 01             	add    $0x1,%edx
  80138f:	8b 04 95 f8 2f 80 00 	mov    0x802ff8(,%edx,4),%eax
  801396:	85 c0                	test   %eax,%eax
  801398:	75 e2                	jne    80137c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80139a:	a1 08 50 80 00       	mov    0x805008,%eax
  80139f:	8b 40 48             	mov    0x48(%eax),%eax
  8013a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013aa:	c7 04 24 7c 2f 80 00 	movl   $0x802f7c,(%esp)
  8013b1:	e8 17 ee ff ff       	call   8001cd <cprintf>
	*dev = 0;
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	56                   	push   %esi
  8013ca:	53                   	push   %ebx
  8013cb:	83 ec 20             	sub    $0x20,%esp
  8013ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8013d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e4:	89 04 24             	mov    %eax,(%esp)
  8013e7:	e8 2a ff ff ff       	call   801316 <fd_lookup>
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 05                	js     8013f5 <fd_close+0x2f>
	    || fd != fd2)
  8013f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8013f3:	74 0c                	je     801401 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8013f5:	84 db                	test   %bl,%bl
  8013f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fc:	0f 44 c2             	cmove  %edx,%eax
  8013ff:	eb 3f                	jmp    801440 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801401:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801404:	89 44 24 04          	mov    %eax,0x4(%esp)
  801408:	8b 06                	mov    (%esi),%eax
  80140a:	89 04 24             	mov    %eax,(%esp)
  80140d:	e8 5a ff ff ff       	call   80136c <dev_lookup>
  801412:	89 c3                	mov    %eax,%ebx
  801414:	85 c0                	test   %eax,%eax
  801416:	78 16                	js     80142e <fd_close+0x68>
		if (dev->dev_close)
  801418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80141e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801423:	85 c0                	test   %eax,%eax
  801425:	74 07                	je     80142e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801427:	89 34 24             	mov    %esi,(%esp)
  80142a:	ff d0                	call   *%eax
  80142c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80142e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801432:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801439:	e8 7c f8 ff ff       	call   800cba <sys_page_unmap>
	return r;
  80143e:	89 d8                	mov    %ebx,%eax
}
  801440:	83 c4 20             	add    $0x20,%esp
  801443:	5b                   	pop    %ebx
  801444:	5e                   	pop    %esi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801450:	89 44 24 04          	mov    %eax,0x4(%esp)
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	89 04 24             	mov    %eax,(%esp)
  80145a:	e8 b7 fe ff ff       	call   801316 <fd_lookup>
  80145f:	89 c2                	mov    %eax,%edx
  801461:	85 d2                	test   %edx,%edx
  801463:	78 13                	js     801478 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801465:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80146c:	00 
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	89 04 24             	mov    %eax,(%esp)
  801473:	e8 4e ff ff ff       	call   8013c6 <fd_close>
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <close_all>:

void
close_all(void)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	53                   	push   %ebx
  80147e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801481:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801486:	89 1c 24             	mov    %ebx,(%esp)
  801489:	e8 b9 ff ff ff       	call   801447 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80148e:	83 c3 01             	add    $0x1,%ebx
  801491:	83 fb 20             	cmp    $0x20,%ebx
  801494:	75 f0                	jne    801486 <close_all+0xc>
		close(i);
}
  801496:	83 c4 14             	add    $0x14,%esp
  801499:	5b                   	pop    %ebx
  80149a:	5d                   	pop    %ebp
  80149b:	c3                   	ret    

0080149c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	57                   	push   %edi
  8014a0:	56                   	push   %esi
  8014a1:	53                   	push   %ebx
  8014a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	89 04 24             	mov    %eax,(%esp)
  8014b2:	e8 5f fe ff ff       	call   801316 <fd_lookup>
  8014b7:	89 c2                	mov    %eax,%edx
  8014b9:	85 d2                	test   %edx,%edx
  8014bb:	0f 88 e1 00 00 00    	js     8015a2 <dup+0x106>
		return r;
	close(newfdnum);
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	89 04 24             	mov    %eax,(%esp)
  8014c7:	e8 7b ff ff ff       	call   801447 <close>

	newfd = INDEX2FD(newfdnum);
  8014cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014cf:	c1 e3 0c             	shl    $0xc,%ebx
  8014d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8014d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014db:	89 04 24             	mov    %eax,(%esp)
  8014de:	e8 cd fd ff ff       	call   8012b0 <fd2data>
  8014e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8014e5:	89 1c 24             	mov    %ebx,(%esp)
  8014e8:	e8 c3 fd ff ff       	call   8012b0 <fd2data>
  8014ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014ef:	89 f0                	mov    %esi,%eax
  8014f1:	c1 e8 16             	shr    $0x16,%eax
  8014f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014fb:	a8 01                	test   $0x1,%al
  8014fd:	74 43                	je     801542 <dup+0xa6>
  8014ff:	89 f0                	mov    %esi,%eax
  801501:	c1 e8 0c             	shr    $0xc,%eax
  801504:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80150b:	f6 c2 01             	test   $0x1,%dl
  80150e:	74 32                	je     801542 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801510:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801517:	25 07 0e 00 00       	and    $0xe07,%eax
  80151c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801520:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801524:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80152b:	00 
  80152c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801530:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801537:	e8 2b f7 ff ff       	call   800c67 <sys_page_map>
  80153c:	89 c6                	mov    %eax,%esi
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 3e                	js     801580 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801545:	89 c2                	mov    %eax,%edx
  801547:	c1 ea 0c             	shr    $0xc,%edx
  80154a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801551:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801557:	89 54 24 10          	mov    %edx,0x10(%esp)
  80155b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80155f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801566:	00 
  801567:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801572:	e8 f0 f6 ff ff       	call   800c67 <sys_page_map>
  801577:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80157c:	85 f6                	test   %esi,%esi
  80157e:	79 22                	jns    8015a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801580:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80158b:	e8 2a f7 ff ff       	call   800cba <sys_page_unmap>
	sys_page_unmap(0, nva);
  801590:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801594:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80159b:	e8 1a f7 ff ff       	call   800cba <sys_page_unmap>
	return r;
  8015a0:	89 f0                	mov    %esi,%eax
}
  8015a2:	83 c4 3c             	add    $0x3c,%esp
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 24             	sub    $0x24,%esp
  8015b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bb:	89 1c 24             	mov    %ebx,(%esp)
  8015be:	e8 53 fd ff ff       	call   801316 <fd_lookup>
  8015c3:	89 c2                	mov    %eax,%edx
  8015c5:	85 d2                	test   %edx,%edx
  8015c7:	78 6d                	js     801636 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d3:	8b 00                	mov    (%eax),%eax
  8015d5:	89 04 24             	mov    %eax,(%esp)
  8015d8:	e8 8f fd ff ff       	call   80136c <dev_lookup>
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	78 55                	js     801636 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e4:	8b 50 08             	mov    0x8(%eax),%edx
  8015e7:	83 e2 03             	and    $0x3,%edx
  8015ea:	83 fa 01             	cmp    $0x1,%edx
  8015ed:	75 23                	jne    801612 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ef:	a1 08 50 80 00       	mov    0x805008,%eax
  8015f4:	8b 40 48             	mov    0x48(%eax),%eax
  8015f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ff:	c7 04 24 bd 2f 80 00 	movl   $0x802fbd,(%esp)
  801606:	e8 c2 eb ff ff       	call   8001cd <cprintf>
		return -E_INVAL;
  80160b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801610:	eb 24                	jmp    801636 <read+0x8c>
	}
	if (!dev->dev_read)
  801612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801615:	8b 52 08             	mov    0x8(%edx),%edx
  801618:	85 d2                	test   %edx,%edx
  80161a:	74 15                	je     801631 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80161c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80161f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801623:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801626:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80162a:	89 04 24             	mov    %eax,(%esp)
  80162d:	ff d2                	call   *%edx
  80162f:	eb 05                	jmp    801636 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801631:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801636:	83 c4 24             	add    $0x24,%esp
  801639:	5b                   	pop    %ebx
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	57                   	push   %edi
  801640:	56                   	push   %esi
  801641:	53                   	push   %ebx
  801642:	83 ec 1c             	sub    $0x1c,%esp
  801645:	8b 7d 08             	mov    0x8(%ebp),%edi
  801648:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80164b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801650:	eb 23                	jmp    801675 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801652:	89 f0                	mov    %esi,%eax
  801654:	29 d8                	sub    %ebx,%eax
  801656:	89 44 24 08          	mov    %eax,0x8(%esp)
  80165a:	89 d8                	mov    %ebx,%eax
  80165c:	03 45 0c             	add    0xc(%ebp),%eax
  80165f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801663:	89 3c 24             	mov    %edi,(%esp)
  801666:	e8 3f ff ff ff       	call   8015aa <read>
		if (m < 0)
  80166b:	85 c0                	test   %eax,%eax
  80166d:	78 10                	js     80167f <readn+0x43>
			return m;
		if (m == 0)
  80166f:	85 c0                	test   %eax,%eax
  801671:	74 0a                	je     80167d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801673:	01 c3                	add    %eax,%ebx
  801675:	39 f3                	cmp    %esi,%ebx
  801677:	72 d9                	jb     801652 <readn+0x16>
  801679:	89 d8                	mov    %ebx,%eax
  80167b:	eb 02                	jmp    80167f <readn+0x43>
  80167d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80167f:	83 c4 1c             	add    $0x1c,%esp
  801682:	5b                   	pop    %ebx
  801683:	5e                   	pop    %esi
  801684:	5f                   	pop    %edi
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	53                   	push   %ebx
  80168b:	83 ec 24             	sub    $0x24,%esp
  80168e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801691:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801694:	89 44 24 04          	mov    %eax,0x4(%esp)
  801698:	89 1c 24             	mov    %ebx,(%esp)
  80169b:	e8 76 fc ff ff       	call   801316 <fd_lookup>
  8016a0:	89 c2                	mov    %eax,%edx
  8016a2:	85 d2                	test   %edx,%edx
  8016a4:	78 68                	js     80170e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	8b 00                	mov    (%eax),%eax
  8016b2:	89 04 24             	mov    %eax,(%esp)
  8016b5:	e8 b2 fc ff ff       	call   80136c <dev_lookup>
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	78 50                	js     80170e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016c5:	75 23                	jne    8016ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c7:	a1 08 50 80 00       	mov    0x805008,%eax
  8016cc:	8b 40 48             	mov    0x48(%eax),%eax
  8016cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d7:	c7 04 24 d9 2f 80 00 	movl   $0x802fd9,(%esp)
  8016de:	e8 ea ea ff ff       	call   8001cd <cprintf>
		return -E_INVAL;
  8016e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e8:	eb 24                	jmp    80170e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8016f0:	85 d2                	test   %edx,%edx
  8016f2:	74 15                	je     801709 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801702:	89 04 24             	mov    %eax,(%esp)
  801705:	ff d2                	call   *%edx
  801707:	eb 05                	jmp    80170e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801709:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80170e:	83 c4 24             	add    $0x24,%esp
  801711:	5b                   	pop    %ebx
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    

00801714 <seek>:

int
seek(int fdnum, off_t offset)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80171d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	89 04 24             	mov    %eax,(%esp)
  801727:	e8 ea fb ff ff       	call   801316 <fd_lookup>
  80172c:	85 c0                	test   %eax,%eax
  80172e:	78 0e                	js     80173e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801730:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801733:	8b 55 0c             	mov    0xc(%ebp),%edx
  801736:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801739:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	53                   	push   %ebx
  801744:	83 ec 24             	sub    $0x24,%esp
  801747:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80174d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801751:	89 1c 24             	mov    %ebx,(%esp)
  801754:	e8 bd fb ff ff       	call   801316 <fd_lookup>
  801759:	89 c2                	mov    %eax,%edx
  80175b:	85 d2                	test   %edx,%edx
  80175d:	78 61                	js     8017c0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80175f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801762:	89 44 24 04          	mov    %eax,0x4(%esp)
  801766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801769:	8b 00                	mov    (%eax),%eax
  80176b:	89 04 24             	mov    %eax,(%esp)
  80176e:	e8 f9 fb ff ff       	call   80136c <dev_lookup>
  801773:	85 c0                	test   %eax,%eax
  801775:	78 49                	js     8017c0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80177e:	75 23                	jne    8017a3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801780:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801785:	8b 40 48             	mov    0x48(%eax),%eax
  801788:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80178c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801790:	c7 04 24 9c 2f 80 00 	movl   $0x802f9c,(%esp)
  801797:	e8 31 ea ff ff       	call   8001cd <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80179c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a1:	eb 1d                	jmp    8017c0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 52 18             	mov    0x18(%edx),%edx
  8017a9:	85 d2                	test   %edx,%edx
  8017ab:	74 0e                	je     8017bb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017b4:	89 04 24             	mov    %eax,(%esp)
  8017b7:	ff d2                	call   *%edx
  8017b9:	eb 05                	jmp    8017c0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8017bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8017c0:	83 c4 24             	add    $0x24,%esp
  8017c3:	5b                   	pop    %ebx
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	53                   	push   %ebx
  8017ca:	83 ec 24             	sub    $0x24,%esp
  8017cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	89 04 24             	mov    %eax,(%esp)
  8017dd:	e8 34 fb ff ff       	call   801316 <fd_lookup>
  8017e2:	89 c2                	mov    %eax,%edx
  8017e4:	85 d2                	test   %edx,%edx
  8017e6:	78 52                	js     80183a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f2:	8b 00                	mov    (%eax),%eax
  8017f4:	89 04 24             	mov    %eax,(%esp)
  8017f7:	e8 70 fb ff ff       	call   80136c <dev_lookup>
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 3a                	js     80183a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801803:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801807:	74 2c                	je     801835 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801809:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80180c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801813:	00 00 00 
	stat->st_isdir = 0;
  801816:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80181d:	00 00 00 
	stat->st_dev = dev;
  801820:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801826:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80182a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182d:	89 14 24             	mov    %edx,(%esp)
  801830:	ff 50 14             	call   *0x14(%eax)
  801833:	eb 05                	jmp    80183a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801835:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80183a:	83 c4 24             	add    $0x24,%esp
  80183d:	5b                   	pop    %ebx
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	56                   	push   %esi
  801844:	53                   	push   %ebx
  801845:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801848:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80184f:	00 
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	89 04 24             	mov    %eax,(%esp)
  801856:	e8 28 02 00 00       	call   801a83 <open>
  80185b:	89 c3                	mov    %eax,%ebx
  80185d:	85 db                	test   %ebx,%ebx
  80185f:	78 1b                	js     80187c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801861:	8b 45 0c             	mov    0xc(%ebp),%eax
  801864:	89 44 24 04          	mov    %eax,0x4(%esp)
  801868:	89 1c 24             	mov    %ebx,(%esp)
  80186b:	e8 56 ff ff ff       	call   8017c6 <fstat>
  801870:	89 c6                	mov    %eax,%esi
	close(fd);
  801872:	89 1c 24             	mov    %ebx,(%esp)
  801875:	e8 cd fb ff ff       	call   801447 <close>
	return r;
  80187a:	89 f0                	mov    %esi,%eax
}
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	5b                   	pop    %ebx
  801880:	5e                   	pop    %esi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
  801888:	83 ec 10             	sub    $0x10,%esp
  80188b:	89 c6                	mov    %eax,%esi
  80188d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80188f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801896:	75 11                	jne    8018a9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801898:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80189f:	e8 68 0e 00 00       	call   80270c <ipc_find_env>
  8018a4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018a9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8018b0:	00 
  8018b1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8018b8:	00 
  8018b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018bd:	a1 00 50 80 00       	mov    0x805000,%eax
  8018c2:	89 04 24             	mov    %eax,(%esp)
  8018c5:	e8 e4 0d 00 00       	call   8026ae <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018d1:	00 
  8018d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018dd:	e8 62 0d 00 00       	call   802644 <ipc_recv>
}
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	5b                   	pop    %ebx
  8018e6:	5e                   	pop    %esi
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    

008018e9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8018fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801902:	ba 00 00 00 00       	mov    $0x0,%edx
  801907:	b8 02 00 00 00       	mov    $0x2,%eax
  80190c:	e8 72 ff ff ff       	call   801883 <fsipc>
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8b 40 0c             	mov    0xc(%eax),%eax
  80191f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801924:	ba 00 00 00 00       	mov    $0x0,%edx
  801929:	b8 06 00 00 00       	mov    $0x6,%eax
  80192e:	e8 50 ff ff ff       	call   801883 <fsipc>
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	53                   	push   %ebx
  801939:	83 ec 14             	sub    $0x14,%esp
  80193c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8b 40 0c             	mov    0xc(%eax),%eax
  801945:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80194a:	ba 00 00 00 00       	mov    $0x0,%edx
  80194f:	b8 05 00 00 00       	mov    $0x5,%eax
  801954:	e8 2a ff ff ff       	call   801883 <fsipc>
  801959:	89 c2                	mov    %eax,%edx
  80195b:	85 d2                	test   %edx,%edx
  80195d:	78 2b                	js     80198a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80195f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801966:	00 
  801967:	89 1c 24             	mov    %ebx,(%esp)
  80196a:	e8 88 ee ff ff       	call   8007f7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80196f:	a1 80 60 80 00       	mov    0x806080,%eax
  801974:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80197a:	a1 84 60 80 00       	mov    0x806084,%eax
  80197f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198a:	83 c4 14             	add    $0x14,%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    

00801990 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	83 ec 18             	sub    $0x18,%esp
  801996:	8b 45 10             	mov    0x10(%ebp),%eax
  801999:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80199e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019a3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  8019a6:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ae:	8b 52 0c             	mov    0xc(%edx),%edx
  8019b1:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  8019b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c2:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8019c9:	e8 c6 ef ff ff       	call   800994 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  8019ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d3:	b8 04 00 00 00       	mov    $0x4,%eax
  8019d8:	e8 a6 fe ff ff       	call   801883 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	56                   	push   %esi
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 10             	sub    $0x10,%esp
  8019e7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8019f5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801a00:	b8 03 00 00 00       	mov    $0x3,%eax
  801a05:	e8 79 fe ff ff       	call   801883 <fsipc>
  801a0a:	89 c3                	mov    %eax,%ebx
  801a0c:	85 c0                	test   %eax,%eax
  801a0e:	78 6a                	js     801a7a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801a10:	39 c6                	cmp    %eax,%esi
  801a12:	73 24                	jae    801a38 <devfile_read+0x59>
  801a14:	c7 44 24 0c 0c 30 80 	movl   $0x80300c,0xc(%esp)
  801a1b:	00 
  801a1c:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  801a23:	00 
  801a24:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801a2b:	00 
  801a2c:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  801a33:	e8 1e 0b 00 00       	call   802556 <_panic>
	assert(r <= PGSIZE);
  801a38:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a3d:	7e 24                	jle    801a63 <devfile_read+0x84>
  801a3f:	c7 44 24 0c 33 30 80 	movl   $0x803033,0xc(%esp)
  801a46:	00 
  801a47:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  801a4e:	00 
  801a4f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801a56:	00 
  801a57:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  801a5e:	e8 f3 0a 00 00       	call   802556 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a67:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a6e:	00 
  801a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a72:	89 04 24             	mov    %eax,(%esp)
  801a75:	e8 1a ef ff ff       	call   800994 <memmove>
	return r;
}
  801a7a:	89 d8                	mov    %ebx,%eax
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	53                   	push   %ebx
  801a87:	83 ec 24             	sub    $0x24,%esp
  801a8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a8d:	89 1c 24             	mov    %ebx,(%esp)
  801a90:	e8 2b ed ff ff       	call   8007c0 <strlen>
  801a95:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a9a:	7f 60                	jg     801afc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9f:	89 04 24             	mov    %eax,(%esp)
  801aa2:	e8 20 f8 ff ff       	call   8012c7 <fd_alloc>
  801aa7:	89 c2                	mov    %eax,%edx
  801aa9:	85 d2                	test   %edx,%edx
  801aab:	78 54                	js     801b01 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801aad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ab1:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801ab8:	e8 3a ed ff ff       	call   8007f7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac0:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ac5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac8:	b8 01 00 00 00       	mov    $0x1,%eax
  801acd:	e8 b1 fd ff ff       	call   801883 <fsipc>
  801ad2:	89 c3                	mov    %eax,%ebx
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	79 17                	jns    801aef <open+0x6c>
		fd_close(fd, 0);
  801ad8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801adf:	00 
  801ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae3:	89 04 24             	mov    %eax,(%esp)
  801ae6:	e8 db f8 ff ff       	call   8013c6 <fd_close>
		return r;
  801aeb:	89 d8                	mov    %ebx,%eax
  801aed:	eb 12                	jmp    801b01 <open+0x7e>
	}

	return fd2num(fd);
  801aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af2:	89 04 24             	mov    %eax,(%esp)
  801af5:	e8 a6 f7 ff ff       	call   8012a0 <fd2num>
  801afa:	eb 05                	jmp    801b01 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801afc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801b01:	83 c4 24             	add    $0x24,%esp
  801b04:	5b                   	pop    %ebx
  801b05:	5d                   	pop    %ebp
  801b06:	c3                   	ret    

00801b07 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b12:	b8 08 00 00 00       	mov    $0x8,%eax
  801b17:	e8 67 fd ff ff       	call   801883 <fsipc>
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    
  801b1e:	66 90                	xchg   %ax,%ax

00801b20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801b26:	c7 44 24 04 3f 30 80 	movl   $0x80303f,0x4(%esp)
  801b2d:	00 
  801b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b31:	89 04 24             	mov    %eax,(%esp)
  801b34:	e8 be ec ff ff       	call   8007f7 <strcpy>
	return 0;
}
  801b39:	b8 00 00 00 00       	mov    $0x0,%eax
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	53                   	push   %ebx
  801b44:	83 ec 14             	sub    $0x14,%esp
  801b47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b4a:	89 1c 24             	mov    %ebx,(%esp)
  801b4d:	e8 f2 0b 00 00       	call   802744 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801b52:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801b57:	83 f8 01             	cmp    $0x1,%eax
  801b5a:	75 0d                	jne    801b69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801b5c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801b5f:	89 04 24             	mov    %eax,(%esp)
  801b62:	e8 29 03 00 00       	call   801e90 <nsipc_close>
  801b67:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801b69:	89 d0                	mov    %edx,%eax
  801b6b:	83 c4 14             	add    $0x14,%esp
  801b6e:	5b                   	pop    %ebx
  801b6f:	5d                   	pop    %ebp
  801b70:	c3                   	ret    

00801b71 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b77:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b7e:	00 
  801b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	8b 40 0c             	mov    0xc(%eax),%eax
  801b93:	89 04 24             	mov    %eax,(%esp)
  801b96:	e8 f0 03 00 00       	call   801f8b <nsipc_send>
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ba3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801baa:	00 
  801bab:	8b 45 10             	mov    0x10(%ebp),%eax
  801bae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bbf:	89 04 24             	mov    %eax,(%esp)
  801bc2:	e8 44 03 00 00       	call   801f0b <nsipc_recv>
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bcf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bd2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bd6:	89 04 24             	mov    %eax,(%esp)
  801bd9:	e8 38 f7 ff ff       	call   801316 <fd_lookup>
  801bde:	85 c0                	test   %eax,%eax
  801be0:	78 17                	js     801bf9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801beb:	39 08                	cmp    %ecx,(%eax)
  801bed:	75 05                	jne    801bf4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801bef:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf2:	eb 05                	jmp    801bf9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801bf4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	56                   	push   %esi
  801bff:	53                   	push   %ebx
  801c00:	83 ec 20             	sub    $0x20,%esp
  801c03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c08:	89 04 24             	mov    %eax,(%esp)
  801c0b:	e8 b7 f6 ff ff       	call   8012c7 <fd_alloc>
  801c10:	89 c3                	mov    %eax,%ebx
  801c12:	85 c0                	test   %eax,%eax
  801c14:	78 21                	js     801c37 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c1d:	00 
  801c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c2c:	e8 e2 ef ff ff       	call   800c13 <sys_page_alloc>
  801c31:	89 c3                	mov    %eax,%ebx
  801c33:	85 c0                	test   %eax,%eax
  801c35:	79 0c                	jns    801c43 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801c37:	89 34 24             	mov    %esi,(%esp)
  801c3a:	e8 51 02 00 00       	call   801e90 <nsipc_close>
		return r;
  801c3f:	89 d8                	mov    %ebx,%eax
  801c41:	eb 20                	jmp    801c63 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801c43:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c51:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801c58:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801c5b:	89 14 24             	mov    %edx,(%esp)
  801c5e:	e8 3d f6 ff ff       	call   8012a0 <fd2num>
}
  801c63:	83 c4 20             	add    $0x20,%esp
  801c66:	5b                   	pop    %ebx
  801c67:	5e                   	pop    %esi
  801c68:	5d                   	pop    %ebp
  801c69:	c3                   	ret    

00801c6a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	e8 51 ff ff ff       	call   801bc9 <fd2sockid>
		return r;
  801c78:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	78 23                	js     801ca1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c7e:	8b 55 10             	mov    0x10(%ebp),%edx
  801c81:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c88:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c8c:	89 04 24             	mov    %eax,(%esp)
  801c8f:	e8 45 01 00 00       	call   801dd9 <nsipc_accept>
		return r;
  801c94:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c96:	85 c0                	test   %eax,%eax
  801c98:	78 07                	js     801ca1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801c9a:	e8 5c ff ff ff       	call   801bfb <alloc_sockfd>
  801c9f:	89 c1                	mov    %eax,%ecx
}
  801ca1:	89 c8                	mov    %ecx,%eax
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	e8 16 ff ff ff       	call   801bc9 <fd2sockid>
  801cb3:	89 c2                	mov    %eax,%edx
  801cb5:	85 d2                	test   %edx,%edx
  801cb7:	78 16                	js     801ccf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801cb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc7:	89 14 24             	mov    %edx,(%esp)
  801cca:	e8 60 01 00 00       	call   801e2f <nsipc_bind>
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <shutdown>:

int
shutdown(int s, int how)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	e8 ea fe ff ff       	call   801bc9 <fd2sockid>
  801cdf:	89 c2                	mov    %eax,%edx
  801ce1:	85 d2                	test   %edx,%edx
  801ce3:	78 0f                	js     801cf4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cec:	89 14 24             	mov    %edx,(%esp)
  801cef:	e8 7a 01 00 00       	call   801e6e <nsipc_shutdown>
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cff:	e8 c5 fe ff ff       	call   801bc9 <fd2sockid>
  801d04:	89 c2                	mov    %eax,%edx
  801d06:	85 d2                	test   %edx,%edx
  801d08:	78 16                	js     801d20 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801d0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d0d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d18:	89 14 24             	mov    %edx,(%esp)
  801d1b:	e8 8a 01 00 00       	call   801eaa <nsipc_connect>
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <listen>:

int
listen(int s, int backlog)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	e8 99 fe ff ff       	call   801bc9 <fd2sockid>
  801d30:	89 c2                	mov    %eax,%edx
  801d32:	85 d2                	test   %edx,%edx
  801d34:	78 0f                	js     801d45 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3d:	89 14 24             	mov    %edx,(%esp)
  801d40:	e8 a4 01 00 00       	call   801ee9 <nsipc_listen>
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d50:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	89 04 24             	mov    %eax,(%esp)
  801d61:	e8 98 02 00 00       	call   801ffe <nsipc_socket>
  801d66:	89 c2                	mov    %eax,%edx
  801d68:	85 d2                	test   %edx,%edx
  801d6a:	78 05                	js     801d71 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801d6c:	e8 8a fe ff ff       	call   801bfb <alloc_sockfd>
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	53                   	push   %ebx
  801d77:	83 ec 14             	sub    $0x14,%esp
  801d7a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d7c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801d83:	75 11                	jne    801d96 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d85:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801d8c:	e8 7b 09 00 00       	call   80270c <ipc_find_env>
  801d91:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d96:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d9d:	00 
  801d9e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801da5:	00 
  801da6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801daa:	a1 04 50 80 00       	mov    0x805004,%eax
  801daf:	89 04 24             	mov    %eax,(%esp)
  801db2:	e8 f7 08 00 00       	call   8026ae <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801db7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dbe:	00 
  801dbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dc6:	00 
  801dc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dce:	e8 71 08 00 00       	call   802644 <ipc_recv>
}
  801dd3:	83 c4 14             	add    $0x14,%esp
  801dd6:	5b                   	pop    %ebx
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    

00801dd9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	56                   	push   %esi
  801ddd:	53                   	push   %ebx
  801dde:	83 ec 10             	sub    $0x10,%esp
  801de1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801de4:	8b 45 08             	mov    0x8(%ebp),%eax
  801de7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801dec:	8b 06                	mov    (%esi),%eax
  801dee:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801df3:	b8 01 00 00 00       	mov    $0x1,%eax
  801df8:	e8 76 ff ff ff       	call   801d73 <nsipc>
  801dfd:	89 c3                	mov    %eax,%ebx
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 23                	js     801e26 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e03:	a1 10 70 80 00       	mov    0x807010,%eax
  801e08:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e0c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801e13:	00 
  801e14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e17:	89 04 24             	mov    %eax,(%esp)
  801e1a:	e8 75 eb ff ff       	call   800994 <memmove>
		*addrlen = ret->ret_addrlen;
  801e1f:	a1 10 70 80 00       	mov    0x807010,%eax
  801e24:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801e26:	89 d8                	mov    %ebx,%eax
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	5b                   	pop    %ebx
  801e2c:	5e                   	pop    %esi
  801e2d:	5d                   	pop    %ebp
  801e2e:	c3                   	ret    

00801e2f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
  801e32:	53                   	push   %ebx
  801e33:	83 ec 14             	sub    $0x14,%esp
  801e36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e41:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801e53:	e8 3c eb ff ff       	call   800994 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e58:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801e5e:	b8 02 00 00 00       	mov    $0x2,%eax
  801e63:	e8 0b ff ff ff       	call   801d73 <nsipc>
}
  801e68:	83 c4 14             	add    $0x14,%esp
  801e6b:	5b                   	pop    %ebx
  801e6c:	5d                   	pop    %ebp
  801e6d:	c3                   	ret    

00801e6e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801e84:	b8 03 00 00 00       	mov    $0x3,%eax
  801e89:	e8 e5 fe ff ff       	call   801d73 <nsipc>
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <nsipc_close>:

int
nsipc_close(int s)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801e9e:	b8 04 00 00 00       	mov    $0x4,%eax
  801ea3:	e8 cb fe ff ff       	call   801d73 <nsipc>
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
  801ead:	53                   	push   %ebx
  801eae:	83 ec 14             	sub    $0x14,%esp
  801eb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ebc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801ece:	e8 c1 ea ff ff       	call   800994 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ed3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801ed9:	b8 05 00 00 00       	mov    $0x5,%eax
  801ede:	e8 90 fe ff ff       	call   801d73 <nsipc>
}
  801ee3:	83 c4 14             	add    $0x14,%esp
  801ee6:	5b                   	pop    %ebx
  801ee7:	5d                   	pop    %ebp
  801ee8:	c3                   	ret    

00801ee9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801eff:	b8 06 00 00 00       	mov    $0x6,%eax
  801f04:	e8 6a fe ff ff       	call   801d73 <nsipc>
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
  801f0e:	56                   	push   %esi
  801f0f:	53                   	push   %ebx
  801f10:	83 ec 10             	sub    $0x10,%esp
  801f13:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801f1e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801f24:	8b 45 14             	mov    0x14(%ebp),%eax
  801f27:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f2c:	b8 07 00 00 00       	mov    $0x7,%eax
  801f31:	e8 3d fe ff ff       	call   801d73 <nsipc>
  801f36:	89 c3                	mov    %eax,%ebx
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	78 46                	js     801f82 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801f3c:	39 f0                	cmp    %esi,%eax
  801f3e:	7f 07                	jg     801f47 <nsipc_recv+0x3c>
  801f40:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f45:	7e 24                	jle    801f6b <nsipc_recv+0x60>
  801f47:	c7 44 24 0c 4b 30 80 	movl   $0x80304b,0xc(%esp)
  801f4e:	00 
  801f4f:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  801f56:	00 
  801f57:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801f5e:	00 
  801f5f:	c7 04 24 60 30 80 00 	movl   $0x803060,(%esp)
  801f66:	e8 eb 05 00 00       	call   802556 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f6f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801f76:	00 
  801f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f7a:	89 04 24             	mov    %eax,(%esp)
  801f7d:	e8 12 ea ff ff       	call   800994 <memmove>
	}

	return r;
}
  801f82:	89 d8                	mov    %ebx,%eax
  801f84:	83 c4 10             	add    $0x10,%esp
  801f87:	5b                   	pop    %ebx
  801f88:	5e                   	pop    %esi
  801f89:	5d                   	pop    %ebp
  801f8a:	c3                   	ret    

00801f8b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	53                   	push   %ebx
  801f8f:	83 ec 14             	sub    $0x14,%esp
  801f92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f95:	8b 45 08             	mov    0x8(%ebp),%eax
  801f98:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801f9d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fa3:	7e 24                	jle    801fc9 <nsipc_send+0x3e>
  801fa5:	c7 44 24 0c 6c 30 80 	movl   $0x80306c,0xc(%esp)
  801fac:	00 
  801fad:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  801fb4:	00 
  801fb5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801fbc:	00 
  801fbd:	c7 04 24 60 30 80 00 	movl   $0x803060,(%esp)
  801fc4:	e8 8d 05 00 00       	call   802556 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fc9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  801fdb:	e8 b4 e9 ff ff       	call   800994 <memmove>
	nsipcbuf.send.req_size = size;
  801fe0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  801fe6:	8b 45 14             	mov    0x14(%ebp),%eax
  801fe9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  801fee:	b8 08 00 00 00       	mov    $0x8,%eax
  801ff3:	e8 7b fd ff ff       	call   801d73 <nsipc>
}
  801ff8:	83 c4 14             	add    $0x14,%esp
  801ffb:	5b                   	pop    %ebx
  801ffc:	5d                   	pop    %ebp
  801ffd:	c3                   	ret    

00801ffe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80200c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802014:	8b 45 10             	mov    0x10(%ebp),%eax
  802017:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80201c:	b8 09 00 00 00       	mov    $0x9,%eax
  802021:	e8 4d fd ff ff       	call   801d73 <nsipc>
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	56                   	push   %esi
  80202c:	53                   	push   %ebx
  80202d:	83 ec 10             	sub    $0x10,%esp
  802030:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	89 04 24             	mov    %eax,(%esp)
  802039:	e8 72 f2 ff ff       	call   8012b0 <fd2data>
  80203e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802040:	c7 44 24 04 78 30 80 	movl   $0x803078,0x4(%esp)
  802047:	00 
  802048:	89 1c 24             	mov    %ebx,(%esp)
  80204b:	e8 a7 e7 ff ff       	call   8007f7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802050:	8b 46 04             	mov    0x4(%esi),%eax
  802053:	2b 06                	sub    (%esi),%eax
  802055:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80205b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802062:	00 00 00 
	stat->st_dev = &devpipe;
  802065:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80206c:	40 80 00 
	return 0;
}
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	83 c4 10             	add    $0x10,%esp
  802077:	5b                   	pop    %ebx
  802078:	5e                   	pop    %esi
  802079:	5d                   	pop    %ebp
  80207a:	c3                   	ret    

0080207b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
  80207e:	53                   	push   %ebx
  80207f:	83 ec 14             	sub    $0x14,%esp
  802082:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802085:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802089:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802090:	e8 25 ec ff ff       	call   800cba <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802095:	89 1c 24             	mov    %ebx,(%esp)
  802098:	e8 13 f2 ff ff       	call   8012b0 <fd2data>
  80209d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a8:	e8 0d ec ff ff       	call   800cba <sys_page_unmap>
}
  8020ad:	83 c4 14             	add    $0x14,%esp
  8020b0:	5b                   	pop    %ebx
  8020b1:	5d                   	pop    %ebp
  8020b2:	c3                   	ret    

008020b3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	57                   	push   %edi
  8020b7:	56                   	push   %esi
  8020b8:	53                   	push   %ebx
  8020b9:	83 ec 2c             	sub    $0x2c,%esp
  8020bc:	89 c6                	mov    %eax,%esi
  8020be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020c1:	a1 08 50 80 00       	mov    0x805008,%eax
  8020c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020c9:	89 34 24             	mov    %esi,(%esp)
  8020cc:	e8 73 06 00 00       	call   802744 <pageref>
  8020d1:	89 c7                	mov    %eax,%edi
  8020d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020d6:	89 04 24             	mov    %eax,(%esp)
  8020d9:	e8 66 06 00 00       	call   802744 <pageref>
  8020de:	39 c7                	cmp    %eax,%edi
  8020e0:	0f 94 c2             	sete   %dl
  8020e3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8020e6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8020ec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8020ef:	39 fb                	cmp    %edi,%ebx
  8020f1:	74 21                	je     802114 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8020f3:	84 d2                	test   %dl,%dl
  8020f5:	74 ca                	je     8020c1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020f7:	8b 51 58             	mov    0x58(%ecx),%edx
  8020fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802102:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802106:	c7 04 24 7f 30 80 00 	movl   $0x80307f,(%esp)
  80210d:	e8 bb e0 ff ff       	call   8001cd <cprintf>
  802112:	eb ad                	jmp    8020c1 <_pipeisclosed+0xe>
	}
}
  802114:	83 c4 2c             	add    $0x2c,%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5f                   	pop    %edi
  80211a:	5d                   	pop    %ebp
  80211b:	c3                   	ret    

0080211c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	57                   	push   %edi
  802120:	56                   	push   %esi
  802121:	53                   	push   %ebx
  802122:	83 ec 1c             	sub    $0x1c,%esp
  802125:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802128:	89 34 24             	mov    %esi,(%esp)
  80212b:	e8 80 f1 ff ff       	call   8012b0 <fd2data>
  802130:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802132:	bf 00 00 00 00       	mov    $0x0,%edi
  802137:	eb 45                	jmp    80217e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802139:	89 da                	mov    %ebx,%edx
  80213b:	89 f0                	mov    %esi,%eax
  80213d:	e8 71 ff ff ff       	call   8020b3 <_pipeisclosed>
  802142:	85 c0                	test   %eax,%eax
  802144:	75 41                	jne    802187 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802146:	e8 a9 ea ff ff       	call   800bf4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80214b:	8b 43 04             	mov    0x4(%ebx),%eax
  80214e:	8b 0b                	mov    (%ebx),%ecx
  802150:	8d 51 20             	lea    0x20(%ecx),%edx
  802153:	39 d0                	cmp    %edx,%eax
  802155:	73 e2                	jae    802139 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80215a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80215e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802161:	99                   	cltd   
  802162:	c1 ea 1b             	shr    $0x1b,%edx
  802165:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802168:	83 e1 1f             	and    $0x1f,%ecx
  80216b:	29 d1                	sub    %edx,%ecx
  80216d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802171:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802175:	83 c0 01             	add    $0x1,%eax
  802178:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80217b:	83 c7 01             	add    $0x1,%edi
  80217e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802181:	75 c8                	jne    80214b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802183:	89 f8                	mov    %edi,%eax
  802185:	eb 05                	jmp    80218c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80218c:	83 c4 1c             	add    $0x1c,%esp
  80218f:	5b                   	pop    %ebx
  802190:	5e                   	pop    %esi
  802191:	5f                   	pop    %edi
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    

00802194 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	57                   	push   %edi
  802198:	56                   	push   %esi
  802199:	53                   	push   %ebx
  80219a:	83 ec 1c             	sub    $0x1c,%esp
  80219d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021a0:	89 3c 24             	mov    %edi,(%esp)
  8021a3:	e8 08 f1 ff ff       	call   8012b0 <fd2data>
  8021a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021aa:	be 00 00 00 00       	mov    $0x0,%esi
  8021af:	eb 3d                	jmp    8021ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021b1:	85 f6                	test   %esi,%esi
  8021b3:	74 04                	je     8021b9 <devpipe_read+0x25>
				return i;
  8021b5:	89 f0                	mov    %esi,%eax
  8021b7:	eb 43                	jmp    8021fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021b9:	89 da                	mov    %ebx,%edx
  8021bb:	89 f8                	mov    %edi,%eax
  8021bd:	e8 f1 fe ff ff       	call   8020b3 <_pipeisclosed>
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	75 31                	jne    8021f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021c6:	e8 29 ea ff ff       	call   800bf4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8021cb:	8b 03                	mov    (%ebx),%eax
  8021cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021d0:	74 df                	je     8021b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021d2:	99                   	cltd   
  8021d3:	c1 ea 1b             	shr    $0x1b,%edx
  8021d6:	01 d0                	add    %edx,%eax
  8021d8:	83 e0 1f             	and    $0x1f,%eax
  8021db:	29 d0                	sub    %edx,%eax
  8021dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021eb:	83 c6 01             	add    $0x1,%esi
  8021ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021f1:	75 d8                	jne    8021cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8021f3:	89 f0                	mov    %esi,%eax
  8021f5:	eb 05                	jmp    8021fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8021fc:	83 c4 1c             	add    $0x1c,%esp
  8021ff:	5b                   	pop    %ebx
  802200:	5e                   	pop    %esi
  802201:	5f                   	pop    %edi
  802202:	5d                   	pop    %ebp
  802203:	c3                   	ret    

00802204 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	56                   	push   %esi
  802208:	53                   	push   %ebx
  802209:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80220c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80220f:	89 04 24             	mov    %eax,(%esp)
  802212:	e8 b0 f0 ff ff       	call   8012c7 <fd_alloc>
  802217:	89 c2                	mov    %eax,%edx
  802219:	85 d2                	test   %edx,%edx
  80221b:	0f 88 4d 01 00 00    	js     80236e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802221:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802228:	00 
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802230:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802237:	e8 d7 e9 ff ff       	call   800c13 <sys_page_alloc>
  80223c:	89 c2                	mov    %eax,%edx
  80223e:	85 d2                	test   %edx,%edx
  802240:	0f 88 28 01 00 00    	js     80236e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802246:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802249:	89 04 24             	mov    %eax,(%esp)
  80224c:	e8 76 f0 ff ff       	call   8012c7 <fd_alloc>
  802251:	89 c3                	mov    %eax,%ebx
  802253:	85 c0                	test   %eax,%eax
  802255:	0f 88 fe 00 00 00    	js     802359 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80225b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802262:	00 
  802263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802266:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802271:	e8 9d e9 ff ff       	call   800c13 <sys_page_alloc>
  802276:	89 c3                	mov    %eax,%ebx
  802278:	85 c0                	test   %eax,%eax
  80227a:	0f 88 d9 00 00 00    	js     802359 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	89 04 24             	mov    %eax,(%esp)
  802286:	e8 25 f0 ff ff       	call   8012b0 <fd2data>
  80228b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80228d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802294:	00 
  802295:	89 44 24 04          	mov    %eax,0x4(%esp)
  802299:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a0:	e8 6e e9 ff ff       	call   800c13 <sys_page_alloc>
  8022a5:	89 c3                	mov    %eax,%ebx
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	0f 88 97 00 00 00    	js     802346 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	89 04 24             	mov    %eax,(%esp)
  8022b5:	e8 f6 ef ff ff       	call   8012b0 <fd2data>
  8022ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8022c1:	00 
  8022c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022cd:	00 
  8022ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d9:	e8 89 e9 ff ff       	call   800c67 <sys_page_map>
  8022de:	89 c3                	mov    %eax,%ebx
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	78 52                	js     802336 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8022e4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8022f9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8022ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802302:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802307:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	89 04 24             	mov    %eax,(%esp)
  802314:	e8 87 ef ff ff       	call   8012a0 <fd2num>
  802319:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80231c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80231e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802321:	89 04 24             	mov    %eax,(%esp)
  802324:	e8 77 ef ff ff       	call   8012a0 <fd2num>
  802329:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80232c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
  802334:	eb 38                	jmp    80236e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802336:	89 74 24 04          	mov    %esi,0x4(%esp)
  80233a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802341:	e8 74 e9 ff ff       	call   800cba <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802346:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802349:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802354:	e8 61 e9 ff ff       	call   800cba <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802360:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802367:	e8 4e e9 ff ff       	call   800cba <sys_page_unmap>
  80236c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80236e:	83 c4 30             	add    $0x30,%esp
  802371:	5b                   	pop    %ebx
  802372:	5e                   	pop    %esi
  802373:	5d                   	pop    %ebp
  802374:	c3                   	ret    

00802375 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80237b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80237e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	89 04 24             	mov    %eax,(%esp)
  802388:	e8 89 ef ff ff       	call   801316 <fd_lookup>
  80238d:	89 c2                	mov    %eax,%edx
  80238f:	85 d2                	test   %edx,%edx
  802391:	78 15                	js     8023a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	89 04 24             	mov    %eax,(%esp)
  802399:	e8 12 ef ff ff       	call   8012b0 <fd2data>
	return _pipeisclosed(fd, p);
  80239e:	89 c2                	mov    %eax,%edx
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	e8 0b fd ff ff       	call   8020b3 <_pipeisclosed>
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8023b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b8:	5d                   	pop    %ebp
  8023b9:	c3                   	ret    

008023ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8023c0:	c7 44 24 04 97 30 80 	movl   $0x803097,0x4(%esp)
  8023c7:	00 
  8023c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cb:	89 04 24             	mov    %eax,(%esp)
  8023ce:	e8 24 e4 ff ff       	call   8007f7 <strcpy>
	return 0;
}
  8023d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    

008023da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	57                   	push   %edi
  8023de:	56                   	push   %esi
  8023df:	53                   	push   %ebx
  8023e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023f1:	eb 31                	jmp    802424 <devcons_write+0x4a>
		m = n - tot;
  8023f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8023f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8023f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8023fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802400:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802403:	89 74 24 08          	mov    %esi,0x8(%esp)
  802407:	03 45 0c             	add    0xc(%ebp),%eax
  80240a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240e:	89 3c 24             	mov    %edi,(%esp)
  802411:	e8 7e e5 ff ff       	call   800994 <memmove>
		sys_cputs(buf, m);
  802416:	89 74 24 04          	mov    %esi,0x4(%esp)
  80241a:	89 3c 24             	mov    %edi,(%esp)
  80241d:	e8 24 e7 ff ff       	call   800b46 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802422:	01 f3                	add    %esi,%ebx
  802424:	89 d8                	mov    %ebx,%eax
  802426:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802429:	72 c8                	jb     8023f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80242b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    

00802436 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80243c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802441:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802445:	75 07                	jne    80244e <devcons_read+0x18>
  802447:	eb 2a                	jmp    802473 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802449:	e8 a6 e7 ff ff       	call   800bf4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80244e:	66 90                	xchg   %ax,%ax
  802450:	e8 0f e7 ff ff       	call   800b64 <sys_cgetc>
  802455:	85 c0                	test   %eax,%eax
  802457:	74 f0                	je     802449 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802459:	85 c0                	test   %eax,%eax
  80245b:	78 16                	js     802473 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80245d:	83 f8 04             	cmp    $0x4,%eax
  802460:	74 0c                	je     80246e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802462:	8b 55 0c             	mov    0xc(%ebp),%edx
  802465:	88 02                	mov    %al,(%edx)
	return 1;
  802467:	b8 01 00 00 00       	mov    $0x1,%eax
  80246c:	eb 05                	jmp    802473 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80246e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802473:	c9                   	leave  
  802474:	c3                   	ret    

00802475 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802475:	55                   	push   %ebp
  802476:	89 e5                	mov    %esp,%ebp
  802478:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802481:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802488:	00 
  802489:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80248c:	89 04 24             	mov    %eax,(%esp)
  80248f:	e8 b2 e6 ff ff       	call   800b46 <sys_cputs>
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <getchar>:

int
getchar(void)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80249c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8024a3:	00 
  8024a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b2:	e8 f3 f0 ff ff       	call   8015aa <read>
	if (r < 0)
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	78 0f                	js     8024ca <getchar+0x34>
		return r;
	if (r < 1)
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	7e 06                	jle    8024c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8024bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8024c3:	eb 05                	jmp    8024ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8024c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8024ca:	c9                   	leave  
  8024cb:	c3                   	ret    

008024cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	89 04 24             	mov    %eax,(%esp)
  8024df:	e8 32 ee ff ff       	call   801316 <fd_lookup>
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	78 11                	js     8024f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8024f1:	39 10                	cmp    %edx,(%eax)
  8024f3:	0f 94 c0             	sete   %al
  8024f6:	0f b6 c0             	movzbl %al,%eax
}
  8024f9:	c9                   	leave  
  8024fa:	c3                   	ret    

008024fb <opencons>:

int
opencons(void)
{
  8024fb:	55                   	push   %ebp
  8024fc:	89 e5                	mov    %esp,%ebp
  8024fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802501:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802504:	89 04 24             	mov    %eax,(%esp)
  802507:	e8 bb ed ff ff       	call   8012c7 <fd_alloc>
		return r;
  80250c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80250e:	85 c0                	test   %eax,%eax
  802510:	78 40                	js     802552 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802512:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802519:	00 
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802521:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802528:	e8 e6 e6 ff ff       	call   800c13 <sys_page_alloc>
		return r;
  80252d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80252f:	85 c0                	test   %eax,%eax
  802531:	78 1f                	js     802552 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802533:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802548:	89 04 24             	mov    %eax,(%esp)
  80254b:	e8 50 ed ff ff       	call   8012a0 <fd2num>
  802550:	89 c2                	mov    %eax,%edx
}
  802552:	89 d0                	mov    %edx,%eax
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	56                   	push   %esi
  80255a:	53                   	push   %ebx
  80255b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80255e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802561:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802567:	e8 69 e6 ff ff       	call   800bd5 <sys_getenvid>
  80256c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80256f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802573:	8b 55 08             	mov    0x8(%ebp),%edx
  802576:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80257a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80257e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802582:	c7 04 24 a4 30 80 00 	movl   $0x8030a4,(%esp)
  802589:	e8 3f dc ff ff       	call   8001cd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80258e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802592:	8b 45 10             	mov    0x10(%ebp),%eax
  802595:	89 04 24             	mov    %eax,(%esp)
  802598:	e8 cf db ff ff       	call   80016c <vcprintf>
	cprintf("\n");
  80259d:	c7 04 24 b4 2a 80 00 	movl   $0x802ab4,(%esp)
  8025a4:	e8 24 dc ff ff       	call   8001cd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025a9:	cc                   	int3   
  8025aa:	eb fd                	jmp    8025a9 <_panic+0x53>

008025ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8025b2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8025b9:	75 58                	jne    802613 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  8025bb:	a1 08 50 80 00       	mov    0x805008,%eax
  8025c0:	8b 40 48             	mov    0x48(%eax),%eax
  8025c3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8025ca:	00 
  8025cb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8025d2:	ee 
  8025d3:	89 04 24             	mov    %eax,(%esp)
  8025d6:	e8 38 e6 ff ff       	call   800c13 <sys_page_alloc>
		if(return_code!=0)
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	74 1c                	je     8025fb <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  8025df:	c7 44 24 08 c8 30 80 	movl   $0x8030c8,0x8(%esp)
  8025e6:	00 
  8025e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8025ee:	00 
  8025ef:	c7 04 24 24 31 80 00 	movl   $0x803124,(%esp)
  8025f6:	e8 5b ff ff ff       	call   802556 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  8025fb:	a1 08 50 80 00       	mov    0x805008,%eax
  802600:	8b 40 48             	mov    0x48(%eax),%eax
  802603:	c7 44 24 04 1d 26 80 	movl   $0x80261d,0x4(%esp)
  80260a:	00 
  80260b:	89 04 24             	mov    %eax,(%esp)
  80260e:	e8 a0 e7 ff ff       	call   800db3 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802613:	8b 45 08             	mov    0x8(%ebp),%eax
  802616:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80261b:	c9                   	leave  
  80261c:	c3                   	ret    

0080261d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80261d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80261e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802623:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802625:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802628:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  80262a:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  80262e:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  802632:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  802633:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  802635:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802637:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  80263b:	58                   	pop    %eax
	popl %eax;
  80263c:	58                   	pop    %eax
	popal;
  80263d:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  80263e:	83 c4 04             	add    $0x4,%esp
	popfl;
  802641:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802642:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  802643:	c3                   	ret    

00802644 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	56                   	push   %esi
  802648:	53                   	push   %ebx
  802649:	83 ec 10             	sub    $0x10,%esp
  80264c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80264f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802652:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802655:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802657:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80265c:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  80265f:	89 04 24             	mov    %eax,(%esp)
  802662:	e8 c2 e7 ff ff       	call   800e29 <sys_ipc_recv>
  802667:	85 c0                	test   %eax,%eax
  802669:	75 1e                	jne    802689 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80266b:	85 db                	test   %ebx,%ebx
  80266d:	74 0a                	je     802679 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80266f:	a1 08 50 80 00       	mov    0x805008,%eax
  802674:	8b 40 74             	mov    0x74(%eax),%eax
  802677:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802679:	85 f6                	test   %esi,%esi
  80267b:	74 22                	je     80269f <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80267d:	a1 08 50 80 00       	mov    0x805008,%eax
  802682:	8b 40 78             	mov    0x78(%eax),%eax
  802685:	89 06                	mov    %eax,(%esi)
  802687:	eb 16                	jmp    80269f <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802689:	85 f6                	test   %esi,%esi
  80268b:	74 06                	je     802693 <ipc_recv+0x4f>
				*perm_store = 0;
  80268d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802693:	85 db                	test   %ebx,%ebx
  802695:	74 10                	je     8026a7 <ipc_recv+0x63>
				*from_env_store=0;
  802697:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80269d:	eb 08                	jmp    8026a7 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  80269f:	a1 08 50 80 00       	mov    0x805008,%eax
  8026a4:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8026a7:	83 c4 10             	add    $0x10,%esp
  8026aa:	5b                   	pop    %ebx
  8026ab:	5e                   	pop    %esi
  8026ac:	5d                   	pop    %ebp
  8026ad:	c3                   	ret    

008026ae <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
  8026b1:	57                   	push   %edi
  8026b2:	56                   	push   %esi
  8026b3:	53                   	push   %ebx
  8026b4:	83 ec 1c             	sub    $0x1c,%esp
  8026b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026bd:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8026c0:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8026c2:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8026c7:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8026ca:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d9:	89 04 24             	mov    %eax,(%esp)
  8026dc:	e8 25 e7 ff ff       	call   800e06 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8026e1:	eb 1c                	jmp    8026ff <ipc_send+0x51>
	{
		sys_yield();
  8026e3:	e8 0c e5 ff ff       	call   800bf4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8026e8:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f7:	89 04 24             	mov    %eax,(%esp)
  8026fa:	e8 07 e7 ff ff       	call   800e06 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8026ff:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802702:	74 df                	je     8026e3 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802704:	83 c4 1c             	add    $0x1c,%esp
  802707:	5b                   	pop    %ebx
  802708:	5e                   	pop    %esi
  802709:	5f                   	pop    %edi
  80270a:	5d                   	pop    %ebp
  80270b:	c3                   	ret    

0080270c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
  80270f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802712:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802717:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80271a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802720:	8b 52 50             	mov    0x50(%edx),%edx
  802723:	39 ca                	cmp    %ecx,%edx
  802725:	75 0d                	jne    802734 <ipc_find_env+0x28>
			return envs[i].env_id;
  802727:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80272a:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80272f:	8b 40 40             	mov    0x40(%eax),%eax
  802732:	eb 0e                	jmp    802742 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802734:	83 c0 01             	add    $0x1,%eax
  802737:	3d 00 04 00 00       	cmp    $0x400,%eax
  80273c:	75 d9                	jne    802717 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80273e:	66 b8 00 00          	mov    $0x0,%ax
}
  802742:	5d                   	pop    %ebp
  802743:	c3                   	ret    

00802744 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802744:	55                   	push   %ebp
  802745:	89 e5                	mov    %esp,%ebp
  802747:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80274a:	89 d0                	mov    %edx,%eax
  80274c:	c1 e8 16             	shr    $0x16,%eax
  80274f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80275b:	f6 c1 01             	test   $0x1,%cl
  80275e:	74 1d                	je     80277d <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802760:	c1 ea 0c             	shr    $0xc,%edx
  802763:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80276a:	f6 c2 01             	test   $0x1,%dl
  80276d:	74 0e                	je     80277d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80276f:	c1 ea 0c             	shr    $0xc,%edx
  802772:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802779:	ef 
  80277a:	0f b7 c0             	movzwl %ax,%eax
}
  80277d:	5d                   	pop    %ebp
  80277e:	c3                   	ret    
  80277f:	90                   	nop

00802780 <__udivdi3>:
  802780:	55                   	push   %ebp
  802781:	57                   	push   %edi
  802782:	56                   	push   %esi
  802783:	83 ec 0c             	sub    $0xc,%esp
  802786:	8b 44 24 28          	mov    0x28(%esp),%eax
  80278a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80278e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802792:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802796:	85 c0                	test   %eax,%eax
  802798:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80279c:	89 ea                	mov    %ebp,%edx
  80279e:	89 0c 24             	mov    %ecx,(%esp)
  8027a1:	75 2d                	jne    8027d0 <__udivdi3+0x50>
  8027a3:	39 e9                	cmp    %ebp,%ecx
  8027a5:	77 61                	ja     802808 <__udivdi3+0x88>
  8027a7:	85 c9                	test   %ecx,%ecx
  8027a9:	89 ce                	mov    %ecx,%esi
  8027ab:	75 0b                	jne    8027b8 <__udivdi3+0x38>
  8027ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b2:	31 d2                	xor    %edx,%edx
  8027b4:	f7 f1                	div    %ecx
  8027b6:	89 c6                	mov    %eax,%esi
  8027b8:	31 d2                	xor    %edx,%edx
  8027ba:	89 e8                	mov    %ebp,%eax
  8027bc:	f7 f6                	div    %esi
  8027be:	89 c5                	mov    %eax,%ebp
  8027c0:	89 f8                	mov    %edi,%eax
  8027c2:	f7 f6                	div    %esi
  8027c4:	89 ea                	mov    %ebp,%edx
  8027c6:	83 c4 0c             	add    $0xc,%esp
  8027c9:	5e                   	pop    %esi
  8027ca:	5f                   	pop    %edi
  8027cb:	5d                   	pop    %ebp
  8027cc:	c3                   	ret    
  8027cd:	8d 76 00             	lea    0x0(%esi),%esi
  8027d0:	39 e8                	cmp    %ebp,%eax
  8027d2:	77 24                	ja     8027f8 <__udivdi3+0x78>
  8027d4:	0f bd e8             	bsr    %eax,%ebp
  8027d7:	83 f5 1f             	xor    $0x1f,%ebp
  8027da:	75 3c                	jne    802818 <__udivdi3+0x98>
  8027dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8027e0:	39 34 24             	cmp    %esi,(%esp)
  8027e3:	0f 86 9f 00 00 00    	jbe    802888 <__udivdi3+0x108>
  8027e9:	39 d0                	cmp    %edx,%eax
  8027eb:	0f 82 97 00 00 00    	jb     802888 <__udivdi3+0x108>
  8027f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027f8:	31 d2                	xor    %edx,%edx
  8027fa:	31 c0                	xor    %eax,%eax
  8027fc:	83 c4 0c             	add    $0xc,%esp
  8027ff:	5e                   	pop    %esi
  802800:	5f                   	pop    %edi
  802801:	5d                   	pop    %ebp
  802802:	c3                   	ret    
  802803:	90                   	nop
  802804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802808:	89 f8                	mov    %edi,%eax
  80280a:	f7 f1                	div    %ecx
  80280c:	31 d2                	xor    %edx,%edx
  80280e:	83 c4 0c             	add    $0xc,%esp
  802811:	5e                   	pop    %esi
  802812:	5f                   	pop    %edi
  802813:	5d                   	pop    %ebp
  802814:	c3                   	ret    
  802815:	8d 76 00             	lea    0x0(%esi),%esi
  802818:	89 e9                	mov    %ebp,%ecx
  80281a:	8b 3c 24             	mov    (%esp),%edi
  80281d:	d3 e0                	shl    %cl,%eax
  80281f:	89 c6                	mov    %eax,%esi
  802821:	b8 20 00 00 00       	mov    $0x20,%eax
  802826:	29 e8                	sub    %ebp,%eax
  802828:	89 c1                	mov    %eax,%ecx
  80282a:	d3 ef                	shr    %cl,%edi
  80282c:	89 e9                	mov    %ebp,%ecx
  80282e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802832:	8b 3c 24             	mov    (%esp),%edi
  802835:	09 74 24 08          	or     %esi,0x8(%esp)
  802839:	89 d6                	mov    %edx,%esi
  80283b:	d3 e7                	shl    %cl,%edi
  80283d:	89 c1                	mov    %eax,%ecx
  80283f:	89 3c 24             	mov    %edi,(%esp)
  802842:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802846:	d3 ee                	shr    %cl,%esi
  802848:	89 e9                	mov    %ebp,%ecx
  80284a:	d3 e2                	shl    %cl,%edx
  80284c:	89 c1                	mov    %eax,%ecx
  80284e:	d3 ef                	shr    %cl,%edi
  802850:	09 d7                	or     %edx,%edi
  802852:	89 f2                	mov    %esi,%edx
  802854:	89 f8                	mov    %edi,%eax
  802856:	f7 74 24 08          	divl   0x8(%esp)
  80285a:	89 d6                	mov    %edx,%esi
  80285c:	89 c7                	mov    %eax,%edi
  80285e:	f7 24 24             	mull   (%esp)
  802861:	39 d6                	cmp    %edx,%esi
  802863:	89 14 24             	mov    %edx,(%esp)
  802866:	72 30                	jb     802898 <__udivdi3+0x118>
  802868:	8b 54 24 04          	mov    0x4(%esp),%edx
  80286c:	89 e9                	mov    %ebp,%ecx
  80286e:	d3 e2                	shl    %cl,%edx
  802870:	39 c2                	cmp    %eax,%edx
  802872:	73 05                	jae    802879 <__udivdi3+0xf9>
  802874:	3b 34 24             	cmp    (%esp),%esi
  802877:	74 1f                	je     802898 <__udivdi3+0x118>
  802879:	89 f8                	mov    %edi,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	e9 7a ff ff ff       	jmp    8027fc <__udivdi3+0x7c>
  802882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802888:	31 d2                	xor    %edx,%edx
  80288a:	b8 01 00 00 00       	mov    $0x1,%eax
  80288f:	e9 68 ff ff ff       	jmp    8027fc <__udivdi3+0x7c>
  802894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802898:	8d 47 ff             	lea    -0x1(%edi),%eax
  80289b:	31 d2                	xor    %edx,%edx
  80289d:	83 c4 0c             	add    $0xc,%esp
  8028a0:	5e                   	pop    %esi
  8028a1:	5f                   	pop    %edi
  8028a2:	5d                   	pop    %ebp
  8028a3:	c3                   	ret    
  8028a4:	66 90                	xchg   %ax,%ax
  8028a6:	66 90                	xchg   %ax,%ax
  8028a8:	66 90                	xchg   %ax,%ax
  8028aa:	66 90                	xchg   %ax,%ax
  8028ac:	66 90                	xchg   %ax,%ax
  8028ae:	66 90                	xchg   %ax,%ax

008028b0 <__umoddi3>:
  8028b0:	55                   	push   %ebp
  8028b1:	57                   	push   %edi
  8028b2:	56                   	push   %esi
  8028b3:	83 ec 14             	sub    $0x14,%esp
  8028b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028ba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028be:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8028c2:	89 c7                	mov    %eax,%edi
  8028c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8028cc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8028d0:	89 34 24             	mov    %esi,(%esp)
  8028d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	89 c2                	mov    %eax,%edx
  8028db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028df:	75 17                	jne    8028f8 <__umoddi3+0x48>
  8028e1:	39 fe                	cmp    %edi,%esi
  8028e3:	76 4b                	jbe    802930 <__umoddi3+0x80>
  8028e5:	89 c8                	mov    %ecx,%eax
  8028e7:	89 fa                	mov    %edi,%edx
  8028e9:	f7 f6                	div    %esi
  8028eb:	89 d0                	mov    %edx,%eax
  8028ed:	31 d2                	xor    %edx,%edx
  8028ef:	83 c4 14             	add    $0x14,%esp
  8028f2:	5e                   	pop    %esi
  8028f3:	5f                   	pop    %edi
  8028f4:	5d                   	pop    %ebp
  8028f5:	c3                   	ret    
  8028f6:	66 90                	xchg   %ax,%ax
  8028f8:	39 f8                	cmp    %edi,%eax
  8028fa:	77 54                	ja     802950 <__umoddi3+0xa0>
  8028fc:	0f bd e8             	bsr    %eax,%ebp
  8028ff:	83 f5 1f             	xor    $0x1f,%ebp
  802902:	75 5c                	jne    802960 <__umoddi3+0xb0>
  802904:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802908:	39 3c 24             	cmp    %edi,(%esp)
  80290b:	0f 87 e7 00 00 00    	ja     8029f8 <__umoddi3+0x148>
  802911:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802915:	29 f1                	sub    %esi,%ecx
  802917:	19 c7                	sbb    %eax,%edi
  802919:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80291d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802921:	8b 44 24 08          	mov    0x8(%esp),%eax
  802925:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802929:	83 c4 14             	add    $0x14,%esp
  80292c:	5e                   	pop    %esi
  80292d:	5f                   	pop    %edi
  80292e:	5d                   	pop    %ebp
  80292f:	c3                   	ret    
  802930:	85 f6                	test   %esi,%esi
  802932:	89 f5                	mov    %esi,%ebp
  802934:	75 0b                	jne    802941 <__umoddi3+0x91>
  802936:	b8 01 00 00 00       	mov    $0x1,%eax
  80293b:	31 d2                	xor    %edx,%edx
  80293d:	f7 f6                	div    %esi
  80293f:	89 c5                	mov    %eax,%ebp
  802941:	8b 44 24 04          	mov    0x4(%esp),%eax
  802945:	31 d2                	xor    %edx,%edx
  802947:	f7 f5                	div    %ebp
  802949:	89 c8                	mov    %ecx,%eax
  80294b:	f7 f5                	div    %ebp
  80294d:	eb 9c                	jmp    8028eb <__umoddi3+0x3b>
  80294f:	90                   	nop
  802950:	89 c8                	mov    %ecx,%eax
  802952:	89 fa                	mov    %edi,%edx
  802954:	83 c4 14             	add    $0x14,%esp
  802957:	5e                   	pop    %esi
  802958:	5f                   	pop    %edi
  802959:	5d                   	pop    %ebp
  80295a:	c3                   	ret    
  80295b:	90                   	nop
  80295c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802960:	8b 04 24             	mov    (%esp),%eax
  802963:	be 20 00 00 00       	mov    $0x20,%esi
  802968:	89 e9                	mov    %ebp,%ecx
  80296a:	29 ee                	sub    %ebp,%esi
  80296c:	d3 e2                	shl    %cl,%edx
  80296e:	89 f1                	mov    %esi,%ecx
  802970:	d3 e8                	shr    %cl,%eax
  802972:	89 e9                	mov    %ebp,%ecx
  802974:	89 44 24 04          	mov    %eax,0x4(%esp)
  802978:	8b 04 24             	mov    (%esp),%eax
  80297b:	09 54 24 04          	or     %edx,0x4(%esp)
  80297f:	89 fa                	mov    %edi,%edx
  802981:	d3 e0                	shl    %cl,%eax
  802983:	89 f1                	mov    %esi,%ecx
  802985:	89 44 24 08          	mov    %eax,0x8(%esp)
  802989:	8b 44 24 10          	mov    0x10(%esp),%eax
  80298d:	d3 ea                	shr    %cl,%edx
  80298f:	89 e9                	mov    %ebp,%ecx
  802991:	d3 e7                	shl    %cl,%edi
  802993:	89 f1                	mov    %esi,%ecx
  802995:	d3 e8                	shr    %cl,%eax
  802997:	89 e9                	mov    %ebp,%ecx
  802999:	09 f8                	or     %edi,%eax
  80299b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80299f:	f7 74 24 04          	divl   0x4(%esp)
  8029a3:	d3 e7                	shl    %cl,%edi
  8029a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029a9:	89 d7                	mov    %edx,%edi
  8029ab:	f7 64 24 08          	mull   0x8(%esp)
  8029af:	39 d7                	cmp    %edx,%edi
  8029b1:	89 c1                	mov    %eax,%ecx
  8029b3:	89 14 24             	mov    %edx,(%esp)
  8029b6:	72 2c                	jb     8029e4 <__umoddi3+0x134>
  8029b8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8029bc:	72 22                	jb     8029e0 <__umoddi3+0x130>
  8029be:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8029c2:	29 c8                	sub    %ecx,%eax
  8029c4:	19 d7                	sbb    %edx,%edi
  8029c6:	89 e9                	mov    %ebp,%ecx
  8029c8:	89 fa                	mov    %edi,%edx
  8029ca:	d3 e8                	shr    %cl,%eax
  8029cc:	89 f1                	mov    %esi,%ecx
  8029ce:	d3 e2                	shl    %cl,%edx
  8029d0:	89 e9                	mov    %ebp,%ecx
  8029d2:	d3 ef                	shr    %cl,%edi
  8029d4:	09 d0                	or     %edx,%eax
  8029d6:	89 fa                	mov    %edi,%edx
  8029d8:	83 c4 14             	add    $0x14,%esp
  8029db:	5e                   	pop    %esi
  8029dc:	5f                   	pop    %edi
  8029dd:	5d                   	pop    %ebp
  8029de:	c3                   	ret    
  8029df:	90                   	nop
  8029e0:	39 d7                	cmp    %edx,%edi
  8029e2:	75 da                	jne    8029be <__umoddi3+0x10e>
  8029e4:	8b 14 24             	mov    (%esp),%edx
  8029e7:	89 c1                	mov    %eax,%ecx
  8029e9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8029ed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8029f1:	eb cb                	jmp    8029be <__umoddi3+0x10e>
  8029f3:	90                   	nop
  8029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8029fc:	0f 82 0f ff ff ff    	jb     802911 <__umoddi3+0x61>
  802a02:	e9 1a ff ff ff       	jmp    802921 <__umoddi3+0x71>
