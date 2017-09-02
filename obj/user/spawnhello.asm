
obj/user/spawnhello.debug:     file format elf32-i386


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
  80002c:	e8 62 00 00 00       	call   800093 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 08 50 80 00       	mov    0x805008,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	89 44 24 04          	mov    %eax,0x4(%esp)
  800045:	c7 04 24 20 2c 80 00 	movl   $0x802c20,(%esp)
  80004c:	e8 a6 01 00 00       	call   8001f7 <cprintf>
	if ((r = spawnl("hello", "hello", 0)) < 0)
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 3e 2c 80 	movl   $0x802c3e,0x4(%esp)
  800060:	00 
  800061:	c7 04 24 3e 2c 80 00 	movl   $0x802c3e,(%esp)
  800068:	e8 2b 1d 00 00       	call   801d98 <spawnl>
  80006d:	85 c0                	test   %eax,%eax
  80006f:	79 20                	jns    800091 <umain+0x5e>
		panic("spawn(hello) failed: %e", r);
  800071:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800075:	c7 44 24 08 44 2c 80 	movl   $0x802c44,0x8(%esp)
  80007c:	00 
  80007d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800084:	00 
  800085:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  80008c:	e8 6d 00 00 00       	call   8000fe <_panic>
}
  800091:	c9                   	leave  
  800092:	c3                   	ret    

00800093 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	83 ec 10             	sub    $0x10,%esp
  80009b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000a1:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8000a8:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8000ab:	e8 55 0b 00 00       	call   800c05 <sys_getenvid>
  8000b0:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8000b5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000bd:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c2:	85 db                	test   %ebx,%ebx
  8000c4:	7e 07                	jle    8000cd <libmain+0x3a>
		binaryname = argv[0];
  8000c6:	8b 06                	mov    (%esi),%eax
  8000c8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000d1:	89 1c 24             	mov    %ebx,(%esp)
  8000d4:	e8 5a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d9:	e8 07 00 00 00       	call   8000e5 <exit>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	5b                   	pop    %ebx
  8000e2:	5e                   	pop    %esi
  8000e3:	5d                   	pop    %ebp
  8000e4:	c3                   	ret    

008000e5 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
  8000e8:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000eb:	e8 5a 10 00 00       	call   80114a <close_all>
	sys_env_destroy(0);
  8000f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f7:	e8 b7 0a 00 00       	call   800bb3 <sys_env_destroy>
}
  8000fc:	c9                   	leave  
  8000fd:	c3                   	ret    

008000fe <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	56                   	push   %esi
  800102:	53                   	push   %ebx
  800103:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800106:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800109:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80010f:	e8 f1 0a 00 00       	call   800c05 <sys_getenvid>
  800114:	8b 55 0c             	mov    0xc(%ebp),%edx
  800117:	89 54 24 10          	mov    %edx,0x10(%esp)
  80011b:	8b 55 08             	mov    0x8(%ebp),%edx
  80011e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800122:	89 74 24 08          	mov    %esi,0x8(%esp)
  800126:	89 44 24 04          	mov    %eax,0x4(%esp)
  80012a:	c7 04 24 78 2c 80 00 	movl   $0x802c78,(%esp)
  800131:	e8 c1 00 00 00       	call   8001f7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800136:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80013a:	8b 45 10             	mov    0x10(%ebp),%eax
  80013d:	89 04 24             	mov    %eax,(%esp)
  800140:	e8 51 00 00 00       	call   800196 <vcprintf>
	cprintf("\n");
  800145:	c7 04 24 7d 31 80 00 	movl   $0x80317d,(%esp)
  80014c:	e8 a6 00 00 00       	call   8001f7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800151:	cc                   	int3   
  800152:	eb fd                	jmp    800151 <_panic+0x53>

00800154 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	53                   	push   %ebx
  800158:	83 ec 14             	sub    $0x14,%esp
  80015b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015e:	8b 13                	mov    (%ebx),%edx
  800160:	8d 42 01             	lea    0x1(%edx),%eax
  800163:	89 03                	mov    %eax,(%ebx)
  800165:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800168:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800171:	75 19                	jne    80018c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800173:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80017a:	00 
  80017b:	8d 43 08             	lea    0x8(%ebx),%eax
  80017e:	89 04 24             	mov    %eax,(%esp)
  800181:	e8 f0 09 00 00       	call   800b76 <sys_cputs>
		b->idx = 0;
  800186:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80018c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800190:	83 c4 14             	add    $0x14,%esp
  800193:	5b                   	pop    %ebx
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    

00800196 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80019f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a6:	00 00 00 
	b.cnt = 0;
  8001a9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cb:	c7 04 24 54 01 80 00 	movl   $0x800154,(%esp)
  8001d2:	e8 b7 01 00 00       	call   80038e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e7:	89 04 24             	mov    %eax,(%esp)
  8001ea:	e8 87 09 00 00       	call   800b76 <sys_cputs>

	return b.cnt;
}
  8001ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800200:	89 44 24 04          	mov    %eax,0x4(%esp)
  800204:	8b 45 08             	mov    0x8(%ebp),%eax
  800207:	89 04 24             	mov    %eax,(%esp)
  80020a:	e8 87 ff ff ff       	call   800196 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020f:	c9                   	leave  
  800210:	c3                   	ret    
  800211:	66 90                	xchg   %ax,%ax
  800213:	66 90                	xchg   %ax,%ax
  800215:	66 90                	xchg   %ax,%ax
  800217:	66 90                	xchg   %ax,%ax
  800219:	66 90                	xchg   %ax,%ax
  80021b:	66 90                	xchg   %ax,%ax
  80021d:	66 90                	xchg   %ax,%ax
  80021f:	90                   	nop

00800220 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	57                   	push   %edi
  800224:	56                   	push   %esi
  800225:	53                   	push   %ebx
  800226:	83 ec 3c             	sub    $0x3c,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80022c:	89 d7                	mov    %edx,%edi
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	89 c3                	mov    %eax,%ebx
  800239:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023c:	8b 45 10             	mov    0x10(%ebp),%eax
  80023f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80024d:	39 d9                	cmp    %ebx,%ecx
  80024f:	72 05                	jb     800256 <printnum+0x36>
  800251:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800254:	77 69                	ja     8002bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800256:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800259:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80025d:	83 ee 01             	sub    $0x1,%esi
  800260:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800264:	89 44 24 08          	mov    %eax,0x8(%esp)
  800268:	8b 44 24 08          	mov    0x8(%esp),%eax
  80026c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800270:	89 c3                	mov    %eax,%ebx
  800272:	89 d6                	mov    %edx,%esi
  800274:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800277:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80027a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	e8 fc 26 00 00       	call   802990 <__udivdi3>
  800294:	89 d9                	mov    %ebx,%ecx
  800296:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80029a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80029e:	89 04 24             	mov    %eax,(%esp)
  8002a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a5:	89 fa                	mov    %edi,%edx
  8002a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002aa:	e8 71 ff ff ff       	call   800220 <printnum>
  8002af:	eb 1b                	jmp    8002cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	ff d3                	call   *%ebx
  8002bd:	eb 03                	jmp    8002c2 <printnum+0xa2>
  8002bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c2:	83 ee 01             	sub    $0x1,%esi
  8002c5:	85 f6                	test   %esi,%esi
  8002c7:	7f e8                	jg     8002b1 <printnum+0x91>
  8002c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	e8 cc 27 00 00       	call   802ac0 <__umoddi3>
  8002f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f8:	0f be 80 9b 2c 80 00 	movsbl 0x802c9b(%eax),%eax
  8002ff:	89 04 24             	mov    %eax,(%esp)
  800302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800305:	ff d0                	call   *%eax
}
  800307:	83 c4 3c             	add    $0x3c,%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5f                   	pop    %edi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800312:	83 fa 01             	cmp    $0x1,%edx
  800315:	7e 0e                	jle    800325 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800317:	8b 10                	mov    (%eax),%edx
  800319:	8d 4a 08             	lea    0x8(%edx),%ecx
  80031c:	89 08                	mov    %ecx,(%eax)
  80031e:	8b 02                	mov    (%edx),%eax
  800320:	8b 52 04             	mov    0x4(%edx),%edx
  800323:	eb 22                	jmp    800347 <getuint+0x38>
	else if (lflag)
  800325:	85 d2                	test   %edx,%edx
  800327:	74 10                	je     800339 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800329:	8b 10                	mov    (%eax),%edx
  80032b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032e:	89 08                	mov    %ecx,(%eax)
  800330:	8b 02                	mov    (%edx),%eax
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
  800337:	eb 0e                	jmp    800347 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800339:	8b 10                	mov    (%eax),%edx
  80033b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80033e:	89 08                	mov    %ecx,(%eax)
  800340:	8b 02                	mov    (%edx),%eax
  800342:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    

00800349 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800353:	8b 10                	mov    (%eax),%edx
  800355:	3b 50 04             	cmp    0x4(%eax),%edx
  800358:	73 0a                	jae    800364 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035d:	89 08                	mov    %ecx,(%eax)
  80035f:	8b 45 08             	mov    0x8(%ebp),%eax
  800362:	88 02                	mov    %al,(%edx)
}
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80036c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80036f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800373:	8b 45 10             	mov    0x10(%ebp),%eax
  800376:	89 44 24 08          	mov    %eax,0x8(%esp)
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	89 04 24             	mov    %eax,(%esp)
  800387:	e8 02 00 00 00       	call   80038e <vprintfmt>
	va_end(ap);
}
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	57                   	push   %edi
  800392:	56                   	push   %esi
  800393:	53                   	push   %ebx
  800394:	83 ec 3c             	sub    $0x3c,%esp
  800397:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80039a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80039d:	eb 14                	jmp    8003b3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80039f:	85 c0                	test   %eax,%eax
  8003a1:	0f 84 b3 03 00 00    	je     80075a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ab:	89 04 24             	mov    %eax,(%esp)
  8003ae:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003b1:	89 f3                	mov    %esi,%ebx
  8003b3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003b6:	0f b6 03             	movzbl (%ebx),%eax
  8003b9:	83 f8 25             	cmp    $0x25,%eax
  8003bc:	75 e1                	jne    80039f <vprintfmt+0x11>
  8003be:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003c9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003d0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8003d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dc:	eb 1d                	jmp    8003fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003de:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003e0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003e4:	eb 15                	jmp    8003fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003e8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003ec:	eb 0d                	jmp    8003fb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003f4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003fe:	0f b6 0e             	movzbl (%esi),%ecx
  800401:	0f b6 c1             	movzbl %cl,%eax
  800404:	83 e9 23             	sub    $0x23,%ecx
  800407:	80 f9 55             	cmp    $0x55,%cl
  80040a:	0f 87 2a 03 00 00    	ja     80073a <vprintfmt+0x3ac>
  800410:	0f b6 c9             	movzbl %cl,%ecx
  800413:	ff 24 8d e0 2d 80 00 	jmp    *0x802de0(,%ecx,4)
  80041a:	89 de                	mov    %ebx,%esi
  80041c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800421:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800424:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800428:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80042b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80042e:	83 fb 09             	cmp    $0x9,%ebx
  800431:	77 36                	ja     800469 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800433:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800436:	eb e9                	jmp    800421 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 48 04             	lea    0x4(%eax),%ecx
  80043e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800446:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800448:	eb 22                	jmp    80046c <vprintfmt+0xde>
  80044a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80044d:	85 c9                	test   %ecx,%ecx
  80044f:	b8 00 00 00 00       	mov    $0x0,%eax
  800454:	0f 49 c1             	cmovns %ecx,%eax
  800457:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	89 de                	mov    %ebx,%esi
  80045c:	eb 9d                	jmp    8003fb <vprintfmt+0x6d>
  80045e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800460:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800467:	eb 92                	jmp    8003fb <vprintfmt+0x6d>
  800469:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80046c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800470:	79 89                	jns    8003fb <vprintfmt+0x6d>
  800472:	e9 77 ff ff ff       	jmp    8003ee <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800477:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80047c:	e9 7a ff ff ff       	jmp    8003fb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800481:	8b 45 14             	mov    0x14(%ebp),%eax
  800484:	8d 50 04             	lea    0x4(%eax),%edx
  800487:	89 55 14             	mov    %edx,0x14(%ebp)
  80048a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	89 04 24             	mov    %eax,(%esp)
  800493:	ff 55 08             	call   *0x8(%ebp)
			break;
  800496:	e9 18 ff ff ff       	jmp    8003b3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80049b:	8b 45 14             	mov    0x14(%ebp),%eax
  80049e:	8d 50 04             	lea    0x4(%eax),%edx
  8004a1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	99                   	cltd   
  8004a7:	31 d0                	xor    %edx,%eax
  8004a9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ab:	83 f8 0f             	cmp    $0xf,%eax
  8004ae:	7f 0b                	jg     8004bb <vprintfmt+0x12d>
  8004b0:	8b 14 85 40 2f 80 00 	mov    0x802f40(,%eax,4),%edx
  8004b7:	85 d2                	test   %edx,%edx
  8004b9:	75 20                	jne    8004db <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004bf:	c7 44 24 08 b3 2c 80 	movl   $0x802cb3,0x8(%esp)
  8004c6:	00 
  8004c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	89 04 24             	mov    %eax,(%esp)
  8004d1:	e8 90 fe ff ff       	call   800366 <printfmt>
  8004d6:	e9 d8 fe ff ff       	jmp    8003b3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004df:	c7 44 24 08 75 30 80 	movl   $0x803075,0x8(%esp)
  8004e6:	00 
  8004e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	89 04 24             	mov    %eax,(%esp)
  8004f1:	e8 70 fe ff ff       	call   800366 <printfmt>
  8004f6:	e9 b8 fe ff ff       	jmp    8003b3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800501:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8d 50 04             	lea    0x4(%eax),%edx
  80050a:	89 55 14             	mov    %edx,0x14(%ebp)
  80050d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80050f:	85 f6                	test   %esi,%esi
  800511:	b8 ac 2c 80 00       	mov    $0x802cac,%eax
  800516:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800519:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80051d:	0f 84 97 00 00 00    	je     8005ba <vprintfmt+0x22c>
  800523:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800527:	0f 8e 9b 00 00 00    	jle    8005c8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800531:	89 34 24             	mov    %esi,(%esp)
  800534:	e8 cf 02 00 00       	call   800808 <strnlen>
  800539:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80053c:	29 c2                	sub    %eax,%edx
  80053e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800541:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800545:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800548:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80054b:	8b 75 08             	mov    0x8(%ebp),%esi
  80054e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800551:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800553:	eb 0f                	jmp    800564 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800555:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800559:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055c:	89 04 24             	mov    %eax,(%esp)
  80055f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800561:	83 eb 01             	sub    $0x1,%ebx
  800564:	85 db                	test   %ebx,%ebx
  800566:	7f ed                	jg     800555 <vprintfmt+0x1c7>
  800568:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80056b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80056e:	85 d2                	test   %edx,%edx
  800570:	b8 00 00 00 00       	mov    $0x0,%eax
  800575:	0f 49 c2             	cmovns %edx,%eax
  800578:	29 c2                	sub    %eax,%edx
  80057a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80057d:	89 d7                	mov    %edx,%edi
  80057f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800582:	eb 50                	jmp    8005d4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800584:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800588:	74 1e                	je     8005a8 <vprintfmt+0x21a>
  80058a:	0f be d2             	movsbl %dl,%edx
  80058d:	83 ea 20             	sub    $0x20,%edx
  800590:	83 fa 5e             	cmp    $0x5e,%edx
  800593:	76 13                	jbe    8005a8 <vprintfmt+0x21a>
					putch('?', putdat);
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005a3:	ff 55 08             	call   *0x8(%ebp)
  8005a6:	eb 0d                	jmp    8005b5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005af:	89 04 24             	mov    %eax,(%esp)
  8005b2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b5:	83 ef 01             	sub    $0x1,%edi
  8005b8:	eb 1a                	jmp    8005d4 <vprintfmt+0x246>
  8005ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005bd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005c0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c6:	eb 0c                	jmp    8005d4 <vprintfmt+0x246>
  8005c8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005cb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005d1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005d4:	83 c6 01             	add    $0x1,%esi
  8005d7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005db:	0f be c2             	movsbl %dl,%eax
  8005de:	85 c0                	test   %eax,%eax
  8005e0:	74 27                	je     800609 <vprintfmt+0x27b>
  8005e2:	85 db                	test   %ebx,%ebx
  8005e4:	78 9e                	js     800584 <vprintfmt+0x1f6>
  8005e6:	83 eb 01             	sub    $0x1,%ebx
  8005e9:	79 99                	jns    800584 <vprintfmt+0x1f6>
  8005eb:	89 f8                	mov    %edi,%eax
  8005ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f3:	89 c3                	mov    %eax,%ebx
  8005f5:	eb 1a                	jmp    800611 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005fb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800602:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800604:	83 eb 01             	sub    $0x1,%ebx
  800607:	eb 08                	jmp    800611 <vprintfmt+0x283>
  800609:	89 fb                	mov    %edi,%ebx
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800611:	85 db                	test   %ebx,%ebx
  800613:	7f e2                	jg     8005f7 <vprintfmt+0x269>
  800615:	89 75 08             	mov    %esi,0x8(%ebp)
  800618:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061b:	e9 93 fd ff ff       	jmp    8003b3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800620:	83 fa 01             	cmp    $0x1,%edx
  800623:	7e 16                	jle    80063b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 50 08             	lea    0x8(%eax),%edx
  80062b:	89 55 14             	mov    %edx,0x14(%ebp)
  80062e:	8b 50 04             	mov    0x4(%eax),%edx
  800631:	8b 00                	mov    (%eax),%eax
  800633:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800636:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800639:	eb 32                	jmp    80066d <vprintfmt+0x2df>
	else if (lflag)
  80063b:	85 d2                	test   %edx,%edx
  80063d:	74 18                	je     800657 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 50 04             	lea    0x4(%eax),%edx
  800645:	89 55 14             	mov    %edx,0x14(%ebp)
  800648:	8b 30                	mov    (%eax),%esi
  80064a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80064d:	89 f0                	mov    %esi,%eax
  80064f:	c1 f8 1f             	sar    $0x1f,%eax
  800652:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800655:	eb 16                	jmp    80066d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 50 04             	lea    0x4(%eax),%edx
  80065d:	89 55 14             	mov    %edx,0x14(%ebp)
  800660:	8b 30                	mov    (%eax),%esi
  800662:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800665:	89 f0                	mov    %esi,%eax
  800667:	c1 f8 1f             	sar    $0x1f,%eax
  80066a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80066d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800670:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800673:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067c:	0f 89 80 00 00 00    	jns    800702 <vprintfmt+0x374>
				putch('-', putdat);
  800682:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800686:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80068d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800696:	f7 d8                	neg    %eax
  800698:	83 d2 00             	adc    $0x0,%edx
  80069b:	f7 da                	neg    %edx
			}
			base = 10;
  80069d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006a2:	eb 5e                	jmp    800702 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a7:	e8 63 fc ff ff       	call   80030f <getuint>
			base = 10;
  8006ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006b1:	eb 4f                	jmp    800702 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  8006b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b6:	e8 54 fc ff ff       	call   80030f <getuint>
			base =8;
  8006bb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006c0:	eb 40                	jmp    800702 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  8006c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006cd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006db:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ee:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006f3:	eb 0d                	jmp    800702 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f8:	e8 12 fc ff ff       	call   80030f <getuint>
			base = 16;
  8006fd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800702:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800706:	89 74 24 10          	mov    %esi,0x10(%esp)
  80070a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80070d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800711:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800715:	89 04 24             	mov    %eax,(%esp)
  800718:	89 54 24 04          	mov    %edx,0x4(%esp)
  80071c:	89 fa                	mov    %edi,%edx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	e8 fa fa ff ff       	call   800220 <printnum>
			break;
  800726:	e9 88 fc ff ff       	jmp    8003b3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80072b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	ff 55 08             	call   *0x8(%ebp)
			break;
  800735:	e9 79 fc ff ff       	jmp    8003b3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80073a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800745:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800748:	89 f3                	mov    %esi,%ebx
  80074a:	eb 03                	jmp    80074f <vprintfmt+0x3c1>
  80074c:	83 eb 01             	sub    $0x1,%ebx
  80074f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800753:	75 f7                	jne    80074c <vprintfmt+0x3be>
  800755:	e9 59 fc ff ff       	jmp    8003b3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80075a:	83 c4 3c             	add    $0x3c,%esp
  80075d:	5b                   	pop    %ebx
  80075e:	5e                   	pop    %esi
  80075f:	5f                   	pop    %edi
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	83 ec 28             	sub    $0x28,%esp
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800771:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800775:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077f:	85 c0                	test   %eax,%eax
  800781:	74 30                	je     8007b3 <vsnprintf+0x51>
  800783:	85 d2                	test   %edx,%edx
  800785:	7e 2c                	jle    8007b3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80078e:	8b 45 10             	mov    0x10(%ebp),%eax
  800791:	89 44 24 08          	mov    %eax,0x8(%esp)
  800795:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800798:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079c:	c7 04 24 49 03 80 00 	movl   $0x800349,(%esp)
  8007a3:	e8 e6 fb ff ff       	call   80038e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b1:	eb 05                	jmp    8007b8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 04 24             	mov    %eax,(%esp)
  8007db:	e8 82 ff ff ff       	call   800762 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    
  8007e2:	66 90                	xchg   %ax,%ax
  8007e4:	66 90                	xchg   %ax,%ax
  8007e6:	66 90                	xchg   %ax,%ax
  8007e8:	66 90                	xchg   %ax,%ax
  8007ea:	66 90                	xchg   %ax,%ax
  8007ec:	66 90                	xchg   %ax,%ax
  8007ee:	66 90                	xchg   %ax,%ax

008007f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fb:	eb 03                	jmp    800800 <strlen+0x10>
		n++;
  8007fd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800800:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800804:	75 f7                	jne    8007fd <strlen+0xd>
		n++;
	return n;
}
  800806:	5d                   	pop    %ebp
  800807:	c3                   	ret    

00800808 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	eb 03                	jmp    80081b <strnlen+0x13>
		n++;
  800818:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081b:	39 d0                	cmp    %edx,%eax
  80081d:	74 06                	je     800825 <strnlen+0x1d>
  80081f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800823:	75 f3                	jne    800818 <strnlen+0x10>
		n++;
	return n;
}
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	53                   	push   %ebx
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800831:	89 c2                	mov    %eax,%edx
  800833:	83 c2 01             	add    $0x1,%edx
  800836:	83 c1 01             	add    $0x1,%ecx
  800839:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80083d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800840:	84 db                	test   %bl,%bl
  800842:	75 ef                	jne    800833 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800844:	5b                   	pop    %ebx
  800845:	5d                   	pop    %ebp
  800846:	c3                   	ret    

00800847 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	53                   	push   %ebx
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800851:	89 1c 24             	mov    %ebx,(%esp)
  800854:	e8 97 ff ff ff       	call   8007f0 <strlen>
	strcpy(dst + len, src);
  800859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800860:	01 d8                	add    %ebx,%eax
  800862:	89 04 24             	mov    %eax,(%esp)
  800865:	e8 bd ff ff ff       	call   800827 <strcpy>
	return dst;
}
  80086a:	89 d8                	mov    %ebx,%eax
  80086c:	83 c4 08             	add    $0x8,%esp
  80086f:	5b                   	pop    %ebx
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	56                   	push   %esi
  800876:	53                   	push   %ebx
  800877:	8b 75 08             	mov    0x8(%ebp),%esi
  80087a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087d:	89 f3                	mov    %esi,%ebx
  80087f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800882:	89 f2                	mov    %esi,%edx
  800884:	eb 0f                	jmp    800895 <strncpy+0x23>
		*dst++ = *src;
  800886:	83 c2 01             	add    $0x1,%edx
  800889:	0f b6 01             	movzbl (%ecx),%eax
  80088c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80088f:	80 39 01             	cmpb   $0x1,(%ecx)
  800892:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800895:	39 da                	cmp    %ebx,%edx
  800897:	75 ed                	jne    800886 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800899:	89 f0                	mov    %esi,%eax
  80089b:	5b                   	pop    %ebx
  80089c:	5e                   	pop    %esi
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    

0080089f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	56                   	push   %esi
  8008a3:	53                   	push   %ebx
  8008a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ad:	89 f0                	mov    %esi,%eax
  8008af:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b3:	85 c9                	test   %ecx,%ecx
  8008b5:	75 0b                	jne    8008c2 <strlcpy+0x23>
  8008b7:	eb 1d                	jmp    8008d6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b9:	83 c0 01             	add    $0x1,%eax
  8008bc:	83 c2 01             	add    $0x1,%edx
  8008bf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008c2:	39 d8                	cmp    %ebx,%eax
  8008c4:	74 0b                	je     8008d1 <strlcpy+0x32>
  8008c6:	0f b6 0a             	movzbl (%edx),%ecx
  8008c9:	84 c9                	test   %cl,%cl
  8008cb:	75 ec                	jne    8008b9 <strlcpy+0x1a>
  8008cd:	89 c2                	mov    %eax,%edx
  8008cf:	eb 02                	jmp    8008d3 <strlcpy+0x34>
  8008d1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008d3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008d6:	29 f0                	sub    %esi,%eax
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5d                   	pop    %ebp
  8008db:	c3                   	ret    

008008dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e5:	eb 06                	jmp    8008ed <strcmp+0x11>
		p++, q++;
  8008e7:	83 c1 01             	add    $0x1,%ecx
  8008ea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008ed:	0f b6 01             	movzbl (%ecx),%eax
  8008f0:	84 c0                	test   %al,%al
  8008f2:	74 04                	je     8008f8 <strcmp+0x1c>
  8008f4:	3a 02                	cmp    (%edx),%al
  8008f6:	74 ef                	je     8008e7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f8:	0f b6 c0             	movzbl %al,%eax
  8008fb:	0f b6 12             	movzbl (%edx),%edx
  8008fe:	29 d0                	sub    %edx,%eax
}
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    

00800902 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	53                   	push   %ebx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090c:	89 c3                	mov    %eax,%ebx
  80090e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800911:	eb 06                	jmp    800919 <strncmp+0x17>
		n--, p++, q++;
  800913:	83 c0 01             	add    $0x1,%eax
  800916:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800919:	39 d8                	cmp    %ebx,%eax
  80091b:	74 15                	je     800932 <strncmp+0x30>
  80091d:	0f b6 08             	movzbl (%eax),%ecx
  800920:	84 c9                	test   %cl,%cl
  800922:	74 04                	je     800928 <strncmp+0x26>
  800924:	3a 0a                	cmp    (%edx),%cl
  800926:	74 eb                	je     800913 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800928:	0f b6 00             	movzbl (%eax),%eax
  80092b:	0f b6 12             	movzbl (%edx),%edx
  80092e:	29 d0                	sub    %edx,%eax
  800930:	eb 05                	jmp    800937 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800932:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800937:	5b                   	pop    %ebx
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800944:	eb 07                	jmp    80094d <strchr+0x13>
		if (*s == c)
  800946:	38 ca                	cmp    %cl,%dl
  800948:	74 0f                	je     800959 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80094a:	83 c0 01             	add    $0x1,%eax
  80094d:	0f b6 10             	movzbl (%eax),%edx
  800950:	84 d2                	test   %dl,%dl
  800952:	75 f2                	jne    800946 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800954:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800965:	eb 07                	jmp    80096e <strfind+0x13>
		if (*s == c)
  800967:	38 ca                	cmp    %cl,%dl
  800969:	74 0a                	je     800975 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	0f b6 10             	movzbl (%eax),%edx
  800971:	84 d2                	test   %dl,%dl
  800973:	75 f2                	jne    800967 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	57                   	push   %edi
  80097b:	56                   	push   %esi
  80097c:	53                   	push   %ebx
  80097d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800980:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800983:	85 c9                	test   %ecx,%ecx
  800985:	74 36                	je     8009bd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800987:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80098d:	75 28                	jne    8009b7 <memset+0x40>
  80098f:	f6 c1 03             	test   $0x3,%cl
  800992:	75 23                	jne    8009b7 <memset+0x40>
		c &= 0xFF;
  800994:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800998:	89 d3                	mov    %edx,%ebx
  80099a:	c1 e3 08             	shl    $0x8,%ebx
  80099d:	89 d6                	mov    %edx,%esi
  80099f:	c1 e6 18             	shl    $0x18,%esi
  8009a2:	89 d0                	mov    %edx,%eax
  8009a4:	c1 e0 10             	shl    $0x10,%eax
  8009a7:	09 f0                	or     %esi,%eax
  8009a9:	09 c2                	or     %eax,%edx
  8009ab:	89 d0                	mov    %edx,%eax
  8009ad:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009af:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009b2:	fc                   	cld    
  8009b3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b5:	eb 06                	jmp    8009bd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009bd:	89 f8                	mov    %edi,%eax
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	57                   	push   %edi
  8009c8:	56                   	push   %esi
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d2:	39 c6                	cmp    %eax,%esi
  8009d4:	73 35                	jae    800a0b <memmove+0x47>
  8009d6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d9:	39 d0                	cmp    %edx,%eax
  8009db:	73 2e                	jae    800a0b <memmove+0x47>
		s += n;
		d += n;
  8009dd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009e0:	89 d6                	mov    %edx,%esi
  8009e2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ea:	75 13                	jne    8009ff <memmove+0x3b>
  8009ec:	f6 c1 03             	test   $0x3,%cl
  8009ef:	75 0e                	jne    8009ff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f1:	83 ef 04             	sub    $0x4,%edi
  8009f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009fa:	fd                   	std    
  8009fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fd:	eb 09                	jmp    800a08 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ff:	83 ef 01             	sub    $0x1,%edi
  800a02:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a05:	fd                   	std    
  800a06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a08:	fc                   	cld    
  800a09:	eb 1d                	jmp    800a28 <memmove+0x64>
  800a0b:	89 f2                	mov    %esi,%edx
  800a0d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0f:	f6 c2 03             	test   $0x3,%dl
  800a12:	75 0f                	jne    800a23 <memmove+0x5f>
  800a14:	f6 c1 03             	test   $0x3,%cl
  800a17:	75 0a                	jne    800a23 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a19:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a1c:	89 c7                	mov    %eax,%edi
  800a1e:	fc                   	cld    
  800a1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a21:	eb 05                	jmp    800a28 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a23:	89 c7                	mov    %eax,%edi
  800a25:	fc                   	cld    
  800a26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a28:	5e                   	pop    %esi
  800a29:	5f                   	pop    %edi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
  800a35:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	89 04 24             	mov    %eax,(%esp)
  800a46:	e8 79 ff ff ff       	call   8009c4 <memmove>
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a58:	89 d6                	mov    %edx,%esi
  800a5a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a5d:	eb 1a                	jmp    800a79 <memcmp+0x2c>
		if (*s1 != *s2)
  800a5f:	0f b6 02             	movzbl (%edx),%eax
  800a62:	0f b6 19             	movzbl (%ecx),%ebx
  800a65:	38 d8                	cmp    %bl,%al
  800a67:	74 0a                	je     800a73 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a69:	0f b6 c0             	movzbl %al,%eax
  800a6c:	0f b6 db             	movzbl %bl,%ebx
  800a6f:	29 d8                	sub    %ebx,%eax
  800a71:	eb 0f                	jmp    800a82 <memcmp+0x35>
		s1++, s2++;
  800a73:	83 c2 01             	add    $0x1,%edx
  800a76:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a79:	39 f2                	cmp    %esi,%edx
  800a7b:	75 e2                	jne    800a5f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a8f:	89 c2                	mov    %eax,%edx
  800a91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a94:	eb 07                	jmp    800a9d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a96:	38 08                	cmp    %cl,(%eax)
  800a98:	74 07                	je     800aa1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	39 d0                	cmp    %edx,%eax
  800a9f:	72 f5                	jb     800a96 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	57                   	push   %edi
  800aa7:	56                   	push   %esi
  800aa8:	53                   	push   %ebx
  800aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aaf:	eb 03                	jmp    800ab4 <strtol+0x11>
		s++;
  800ab1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab4:	0f b6 0a             	movzbl (%edx),%ecx
  800ab7:	80 f9 09             	cmp    $0x9,%cl
  800aba:	74 f5                	je     800ab1 <strtol+0xe>
  800abc:	80 f9 20             	cmp    $0x20,%cl
  800abf:	74 f0                	je     800ab1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ac1:	80 f9 2b             	cmp    $0x2b,%cl
  800ac4:	75 0a                	jne    800ad0 <strtol+0x2d>
		s++;
  800ac6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ace:	eb 11                	jmp    800ae1 <strtol+0x3e>
  800ad0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ad5:	80 f9 2d             	cmp    $0x2d,%cl
  800ad8:	75 07                	jne    800ae1 <strtol+0x3e>
		s++, neg = 1;
  800ada:	8d 52 01             	lea    0x1(%edx),%edx
  800add:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ae6:	75 15                	jne    800afd <strtol+0x5a>
  800ae8:	80 3a 30             	cmpb   $0x30,(%edx)
  800aeb:	75 10                	jne    800afd <strtol+0x5a>
  800aed:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800af1:	75 0a                	jne    800afd <strtol+0x5a>
		s += 2, base = 16;
  800af3:	83 c2 02             	add    $0x2,%edx
  800af6:	b8 10 00 00 00       	mov    $0x10,%eax
  800afb:	eb 10                	jmp    800b0d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800afd:	85 c0                	test   %eax,%eax
  800aff:	75 0c                	jne    800b0d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b01:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b03:	80 3a 30             	cmpb   $0x30,(%edx)
  800b06:	75 05                	jne    800b0d <strtol+0x6a>
		s++, base = 8;
  800b08:	83 c2 01             	add    $0x1,%edx
  800b0b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b12:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b15:	0f b6 0a             	movzbl (%edx),%ecx
  800b18:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b1b:	89 f0                	mov    %esi,%eax
  800b1d:	3c 09                	cmp    $0x9,%al
  800b1f:	77 08                	ja     800b29 <strtol+0x86>
			dig = *s - '0';
  800b21:	0f be c9             	movsbl %cl,%ecx
  800b24:	83 e9 30             	sub    $0x30,%ecx
  800b27:	eb 20                	jmp    800b49 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b29:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b2c:	89 f0                	mov    %esi,%eax
  800b2e:	3c 19                	cmp    $0x19,%al
  800b30:	77 08                	ja     800b3a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b32:	0f be c9             	movsbl %cl,%ecx
  800b35:	83 e9 57             	sub    $0x57,%ecx
  800b38:	eb 0f                	jmp    800b49 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b3a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b3d:	89 f0                	mov    %esi,%eax
  800b3f:	3c 19                	cmp    $0x19,%al
  800b41:	77 16                	ja     800b59 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b43:	0f be c9             	movsbl %cl,%ecx
  800b46:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b49:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b4c:	7d 0f                	jge    800b5d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b4e:	83 c2 01             	add    $0x1,%edx
  800b51:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b55:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b57:	eb bc                	jmp    800b15 <strtol+0x72>
  800b59:	89 d8                	mov    %ebx,%eax
  800b5b:	eb 02                	jmp    800b5f <strtol+0xbc>
  800b5d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b63:	74 05                	je     800b6a <strtol+0xc7>
		*endptr = (char *) s;
  800b65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b68:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b6a:	f7 d8                	neg    %eax
  800b6c:	85 ff                	test   %edi,%edi
  800b6e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b71:	5b                   	pop    %ebx
  800b72:	5e                   	pop    %esi
  800b73:	5f                   	pop    %edi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	57                   	push   %edi
  800b7a:	56                   	push   %esi
  800b7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b84:	8b 55 08             	mov    0x8(%ebp),%edx
  800b87:	89 c3                	mov    %eax,%ebx
  800b89:	89 c7                	mov    %eax,%edi
  800b8b:	89 c6                	mov    %eax,%esi
  800b8d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9f:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba4:	89 d1                	mov    %edx,%ecx
  800ba6:	89 d3                	mov    %edx,%ebx
  800ba8:	89 d7                	mov    %edx,%edi
  800baa:	89 d6                	mov    %edx,%esi
  800bac:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	57                   	push   %edi
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc9:	89 cb                	mov    %ecx,%ebx
  800bcb:	89 cf                	mov    %ecx,%edi
  800bcd:	89 ce                	mov    %ecx,%esi
  800bcf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800bd1:	85 c0                	test   %eax,%eax
  800bd3:	7e 28                	jle    800bfd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bd9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800be0:	00 
  800be1:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800be8:	00 
  800be9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bf0:	00 
  800bf1:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800bf8:	e8 01 f5 ff ff       	call   8000fe <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bfd:	83 c4 2c             	add    $0x2c,%esp
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5f                   	pop    %edi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	57                   	push   %edi
  800c09:	56                   	push   %esi
  800c0a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c10:	b8 02 00 00 00       	mov    $0x2,%eax
  800c15:	89 d1                	mov    %edx,%ecx
  800c17:	89 d3                	mov    %edx,%ebx
  800c19:	89 d7                	mov    %edx,%edi
  800c1b:	89 d6                	mov    %edx,%esi
  800c1d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <sys_yield>:

void
sys_yield(void)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c34:	89 d1                	mov    %edx,%ecx
  800c36:	89 d3                	mov    %edx,%ebx
  800c38:	89 d7                	mov    %edx,%edi
  800c3a:	89 d6                	mov    %edx,%esi
  800c3c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4c:	be 00 00 00 00       	mov    $0x0,%esi
  800c51:	b8 04 00 00 00       	mov    $0x4,%eax
  800c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5f:	89 f7                	mov    %esi,%edi
  800c61:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c63:	85 c0                	test   %eax,%eax
  800c65:	7e 28                	jle    800c8f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c67:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c6b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c72:	00 
  800c73:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800c7a:	00 
  800c7b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c82:	00 
  800c83:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800c8a:	e8 6f f4 ff ff       	call   8000fe <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c8f:	83 c4 2c             	add    $0x2c,%esp
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cb1:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	7e 28                	jle    800ce2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cba:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cbe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800cc5:	00 
  800cc6:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800ccd:	00 
  800cce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd5:	00 
  800cd6:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800cdd:	e8 1c f4 ff ff       	call   8000fe <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce2:	83 c4 2c             	add    $0x2c,%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf8:	b8 06 00 00 00       	mov    $0x6,%eax
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	89 df                	mov    %ebx,%edi
  800d05:	89 de                	mov    %ebx,%esi
  800d07:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	7e 28                	jle    800d35 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d11:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d18:	00 
  800d19:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800d20:	00 
  800d21:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d28:	00 
  800d29:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800d30:	e8 c9 f3 ff ff       	call   8000fe <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d35:	83 c4 2c             	add    $0x2c,%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	89 df                	mov    %ebx,%edi
  800d58:	89 de                	mov    %ebx,%esi
  800d5a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d5c:	85 c0                	test   %eax,%eax
  800d5e:	7e 28                	jle    800d88 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d64:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d6b:	00 
  800d6c:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800d73:	00 
  800d74:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d7b:	00 
  800d7c:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800d83:	e8 76 f3 ff ff       	call   8000fe <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d88:	83 c4 2c             	add    $0x2c,%esp
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	89 df                	mov    %ebx,%edi
  800dab:	89 de                	mov    %ebx,%esi
  800dad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7e 28                	jle    800ddb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dbe:	00 
  800dbf:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800dc6:	00 
  800dc7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dce:	00 
  800dcf:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800dd6:	e8 23 f3 ff ff       	call   8000fe <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ddb:	83 c4 2c             	add    $0x2c,%esp
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	89 df                	mov    %ebx,%edi
  800dfe:	89 de                	mov    %ebx,%esi
  800e00:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7e 28                	jle    800e2e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e06:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e11:	00 
  800e12:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800e19:	00 
  800e1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e21:	00 
  800e22:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800e29:	e8 d0 f2 ff ff       	call   8000fe <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e2e:	83 c4 2c             	add    $0x2c,%esp
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	be 00 00 00 00       	mov    $0x0,%esi
  800e41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e52:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e67:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	89 cb                	mov    %ecx,%ebx
  800e71:	89 cf                	mov    %ecx,%edi
  800e73:	89 ce                	mov    %ecx,%esi
  800e75:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	7e 28                	jle    800ea3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e86:	00 
  800e87:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800e8e:	00 
  800e8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e96:	00 
  800e97:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800e9e:	e8 5b f2 ff ff       	call   8000fe <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea3:	83 c4 2c             	add    $0x2c,%esp
  800ea6:	5b                   	pop    %ebx
  800ea7:	5e                   	pop    %esi
  800ea8:	5f                   	pop    %edi
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ebb:	89 d1                	mov    %edx,%ecx
  800ebd:	89 d3                	mov    %edx,%ebx
  800ebf:	89 d7                	mov    %edx,%edi
  800ec1:	89 d6                	mov    %edx,%esi
  800ec3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    

00800eca <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
  800ed0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee3:	89 df                	mov    %ebx,%edi
  800ee5:	89 de                	mov    %ebx,%esi
  800ee7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee9:	85 c0                	test   %eax,%eax
  800eeb:	7e 28                	jle    800f15 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eed:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ef8:	00 
  800ef9:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800f00:	00 
  800f01:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f08:	00 
  800f09:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800f10:	e8 e9 f1 ff ff       	call   8000fe <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800f15:	83 c4 2c             	add    $0x2c,%esp
  800f18:	5b                   	pop    %ebx
  800f19:	5e                   	pop    %esi
  800f1a:	5f                   	pop    %edi
  800f1b:	5d                   	pop    %ebp
  800f1c:	c3                   	ret    

00800f1d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	57                   	push   %edi
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
  800f23:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f33:	8b 55 08             	mov    0x8(%ebp),%edx
  800f36:	89 df                	mov    %ebx,%edi
  800f38:	89 de                	mov    %ebx,%esi
  800f3a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	7e 28                	jle    800f68 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f40:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f44:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800f4b:	00 
  800f4c:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800f53:	00 
  800f54:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f5b:	00 
  800f5c:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800f63:	e8 96 f1 ff ff       	call   8000fe <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  800f68:	83 c4 2c             	add    $0x2c,%esp
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    

00800f70 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	05 00 00 00 30       	add    $0x30000000,%eax
  800f7b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f90:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f9d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fa2:	89 c2                	mov    %eax,%edx
  800fa4:	c1 ea 16             	shr    $0x16,%edx
  800fa7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fae:	f6 c2 01             	test   $0x1,%dl
  800fb1:	74 11                	je     800fc4 <fd_alloc+0x2d>
  800fb3:	89 c2                	mov    %eax,%edx
  800fb5:	c1 ea 0c             	shr    $0xc,%edx
  800fb8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fbf:	f6 c2 01             	test   $0x1,%dl
  800fc2:	75 09                	jne    800fcd <fd_alloc+0x36>
			*fd_store = fd;
  800fc4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcb:	eb 17                	jmp    800fe4 <fd_alloc+0x4d>
  800fcd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fd2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fd7:	75 c9                	jne    800fa2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fd9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800fdf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fec:	83 f8 1f             	cmp    $0x1f,%eax
  800fef:	77 36                	ja     801027 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ff1:	c1 e0 0c             	shl    $0xc,%eax
  800ff4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ff9:	89 c2                	mov    %eax,%edx
  800ffb:	c1 ea 16             	shr    $0x16,%edx
  800ffe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801005:	f6 c2 01             	test   $0x1,%dl
  801008:	74 24                	je     80102e <fd_lookup+0x48>
  80100a:	89 c2                	mov    %eax,%edx
  80100c:	c1 ea 0c             	shr    $0xc,%edx
  80100f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801016:	f6 c2 01             	test   $0x1,%dl
  801019:	74 1a                	je     801035 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80101b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101e:	89 02                	mov    %eax,(%edx)
	return 0;
  801020:	b8 00 00 00 00       	mov    $0x0,%eax
  801025:	eb 13                	jmp    80103a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801027:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80102c:	eb 0c                	jmp    80103a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80102e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801033:	eb 05                	jmp    80103a <fd_lookup+0x54>
  801035:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 18             	sub    $0x18,%esp
  801042:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801045:	ba 00 00 00 00       	mov    $0x0,%edx
  80104a:	eb 13                	jmp    80105f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80104c:	39 08                	cmp    %ecx,(%eax)
  80104e:	75 0c                	jne    80105c <dev_lookup+0x20>
			*dev = devtab[i];
  801050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801053:	89 01                	mov    %eax,(%ecx)
			return 0;
  801055:	b8 00 00 00 00       	mov    $0x0,%eax
  80105a:	eb 38                	jmp    801094 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80105c:	83 c2 01             	add    $0x1,%edx
  80105f:	8b 04 95 48 30 80 00 	mov    0x803048(,%edx,4),%eax
  801066:	85 c0                	test   %eax,%eax
  801068:	75 e2                	jne    80104c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80106a:	a1 08 50 80 00       	mov    0x805008,%eax
  80106f:	8b 40 48             	mov    0x48(%eax),%eax
  801072:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801076:	89 44 24 04          	mov    %eax,0x4(%esp)
  80107a:	c7 04 24 cc 2f 80 00 	movl   $0x802fcc,(%esp)
  801081:	e8 71 f1 ff ff       	call   8001f7 <cprintf>
	*dev = 0;
  801086:	8b 45 0c             	mov    0xc(%ebp),%eax
  801089:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80108f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801094:	c9                   	leave  
  801095:	c3                   	ret    

00801096 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801096:	55                   	push   %ebp
  801097:	89 e5                	mov    %esp,%ebp
  801099:	56                   	push   %esi
  80109a:	53                   	push   %ebx
  80109b:	83 ec 20             	sub    $0x20,%esp
  80109e:	8b 75 08             	mov    0x8(%ebp),%esi
  8010a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010a7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010ab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010b1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010b4:	89 04 24             	mov    %eax,(%esp)
  8010b7:	e8 2a ff ff ff       	call   800fe6 <fd_lookup>
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	78 05                	js     8010c5 <fd_close+0x2f>
	    || fd != fd2)
  8010c0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8010c3:	74 0c                	je     8010d1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8010c5:	84 db                	test   %bl,%bl
  8010c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cc:	0f 44 c2             	cmove  %edx,%eax
  8010cf:	eb 3f                	jmp    801110 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010d8:	8b 06                	mov    (%esi),%eax
  8010da:	89 04 24             	mov    %eax,(%esp)
  8010dd:	e8 5a ff ff ff       	call   80103c <dev_lookup>
  8010e2:	89 c3                	mov    %eax,%ebx
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	78 16                	js     8010fe <fd_close+0x68>
		if (dev->dev_close)
  8010e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8010ee:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	74 07                	je     8010fe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8010f7:	89 34 24             	mov    %esi,(%esp)
  8010fa:	ff d0                	call   *%eax
  8010fc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801102:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801109:	e8 dc fb ff ff       	call   800cea <sys_page_unmap>
	return r;
  80110e:	89 d8                	mov    %ebx,%eax
}
  801110:	83 c4 20             	add    $0x20,%esp
  801113:	5b                   	pop    %ebx
  801114:	5e                   	pop    %esi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    

00801117 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
  80111a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80111d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801120:	89 44 24 04          	mov    %eax,0x4(%esp)
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	89 04 24             	mov    %eax,(%esp)
  80112a:	e8 b7 fe ff ff       	call   800fe6 <fd_lookup>
  80112f:	89 c2                	mov    %eax,%edx
  801131:	85 d2                	test   %edx,%edx
  801133:	78 13                	js     801148 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801135:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80113c:	00 
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	89 04 24             	mov    %eax,(%esp)
  801143:	e8 4e ff ff ff       	call   801096 <fd_close>
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <close_all>:

void
close_all(void)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	53                   	push   %ebx
  80114e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801151:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801156:	89 1c 24             	mov    %ebx,(%esp)
  801159:	e8 b9 ff ff ff       	call   801117 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80115e:	83 c3 01             	add    $0x1,%ebx
  801161:	83 fb 20             	cmp    $0x20,%ebx
  801164:	75 f0                	jne    801156 <close_all+0xc>
		close(i);
}
  801166:	83 c4 14             	add    $0x14,%esp
  801169:	5b                   	pop    %ebx
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	57                   	push   %edi
  801170:	56                   	push   %esi
  801171:	53                   	push   %ebx
  801172:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801175:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801178:	89 44 24 04          	mov    %eax,0x4(%esp)
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	89 04 24             	mov    %eax,(%esp)
  801182:	e8 5f fe ff ff       	call   800fe6 <fd_lookup>
  801187:	89 c2                	mov    %eax,%edx
  801189:	85 d2                	test   %edx,%edx
  80118b:	0f 88 e1 00 00 00    	js     801272 <dup+0x106>
		return r;
	close(newfdnum);
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	89 04 24             	mov    %eax,(%esp)
  801197:	e8 7b ff ff ff       	call   801117 <close>

	newfd = INDEX2FD(newfdnum);
  80119c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80119f:	c1 e3 0c             	shl    $0xc,%ebx
  8011a2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8011a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011ab:	89 04 24             	mov    %eax,(%esp)
  8011ae:	e8 cd fd ff ff       	call   800f80 <fd2data>
  8011b3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8011b5:	89 1c 24             	mov    %ebx,(%esp)
  8011b8:	e8 c3 fd ff ff       	call   800f80 <fd2data>
  8011bd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011bf:	89 f0                	mov    %esi,%eax
  8011c1:	c1 e8 16             	shr    $0x16,%eax
  8011c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011cb:	a8 01                	test   $0x1,%al
  8011cd:	74 43                	je     801212 <dup+0xa6>
  8011cf:	89 f0                	mov    %esi,%eax
  8011d1:	c1 e8 0c             	shr    $0xc,%eax
  8011d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011db:	f6 c2 01             	test   $0x1,%dl
  8011de:	74 32                	je     801212 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011fb:	00 
  8011fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801200:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801207:	e8 8b fa ff ff       	call   800c97 <sys_page_map>
  80120c:	89 c6                	mov    %eax,%esi
  80120e:	85 c0                	test   %eax,%eax
  801210:	78 3e                	js     801250 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801212:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801215:	89 c2                	mov    %eax,%edx
  801217:	c1 ea 0c             	shr    $0xc,%edx
  80121a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801221:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801227:	89 54 24 10          	mov    %edx,0x10(%esp)
  80122b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80122f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801236:	00 
  801237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80123b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801242:	e8 50 fa ff ff       	call   800c97 <sys_page_map>
  801247:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80124c:	85 f6                	test   %esi,%esi
  80124e:	79 22                	jns    801272 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801250:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801254:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125b:	e8 8a fa ff ff       	call   800cea <sys_page_unmap>
	sys_page_unmap(0, nva);
  801260:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801264:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80126b:	e8 7a fa ff ff       	call   800cea <sys_page_unmap>
	return r;
  801270:	89 f0                	mov    %esi,%eax
}
  801272:	83 c4 3c             	add    $0x3c,%esp
  801275:	5b                   	pop    %ebx
  801276:	5e                   	pop    %esi
  801277:	5f                   	pop    %edi
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    

0080127a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	53                   	push   %ebx
  80127e:	83 ec 24             	sub    $0x24,%esp
  801281:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801284:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128b:	89 1c 24             	mov    %ebx,(%esp)
  80128e:	e8 53 fd ff ff       	call   800fe6 <fd_lookup>
  801293:	89 c2                	mov    %eax,%edx
  801295:	85 d2                	test   %edx,%edx
  801297:	78 6d                	js     801306 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801299:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80129c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a3:	8b 00                	mov    (%eax),%eax
  8012a5:	89 04 24             	mov    %eax,(%esp)
  8012a8:	e8 8f fd ff ff       	call   80103c <dev_lookup>
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	78 55                	js     801306 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b4:	8b 50 08             	mov    0x8(%eax),%edx
  8012b7:	83 e2 03             	and    $0x3,%edx
  8012ba:	83 fa 01             	cmp    $0x1,%edx
  8012bd:	75 23                	jne    8012e2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8012c4:	8b 40 48             	mov    0x48(%eax),%eax
  8012c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cf:	c7 04 24 0d 30 80 00 	movl   $0x80300d,(%esp)
  8012d6:	e8 1c ef ff ff       	call   8001f7 <cprintf>
		return -E_INVAL;
  8012db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012e0:	eb 24                	jmp    801306 <read+0x8c>
	}
	if (!dev->dev_read)
  8012e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012e5:	8b 52 08             	mov    0x8(%edx),%edx
  8012e8:	85 d2                	test   %edx,%edx
  8012ea:	74 15                	je     801301 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8012fa:	89 04 24             	mov    %eax,(%esp)
  8012fd:	ff d2                	call   *%edx
  8012ff:	eb 05                	jmp    801306 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801301:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801306:	83 c4 24             	add    $0x24,%esp
  801309:	5b                   	pop    %ebx
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	57                   	push   %edi
  801310:	56                   	push   %esi
  801311:	53                   	push   %ebx
  801312:	83 ec 1c             	sub    $0x1c,%esp
  801315:	8b 7d 08             	mov    0x8(%ebp),%edi
  801318:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80131b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801320:	eb 23                	jmp    801345 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801322:	89 f0                	mov    %esi,%eax
  801324:	29 d8                	sub    %ebx,%eax
  801326:	89 44 24 08          	mov    %eax,0x8(%esp)
  80132a:	89 d8                	mov    %ebx,%eax
  80132c:	03 45 0c             	add    0xc(%ebp),%eax
  80132f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801333:	89 3c 24             	mov    %edi,(%esp)
  801336:	e8 3f ff ff ff       	call   80127a <read>
		if (m < 0)
  80133b:	85 c0                	test   %eax,%eax
  80133d:	78 10                	js     80134f <readn+0x43>
			return m;
		if (m == 0)
  80133f:	85 c0                	test   %eax,%eax
  801341:	74 0a                	je     80134d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801343:	01 c3                	add    %eax,%ebx
  801345:	39 f3                	cmp    %esi,%ebx
  801347:	72 d9                	jb     801322 <readn+0x16>
  801349:	89 d8                	mov    %ebx,%eax
  80134b:	eb 02                	jmp    80134f <readn+0x43>
  80134d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80134f:	83 c4 1c             	add    $0x1c,%esp
  801352:	5b                   	pop    %ebx
  801353:	5e                   	pop    %esi
  801354:	5f                   	pop    %edi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    

00801357 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	53                   	push   %ebx
  80135b:	83 ec 24             	sub    $0x24,%esp
  80135e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801361:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801364:	89 44 24 04          	mov    %eax,0x4(%esp)
  801368:	89 1c 24             	mov    %ebx,(%esp)
  80136b:	e8 76 fc ff ff       	call   800fe6 <fd_lookup>
  801370:	89 c2                	mov    %eax,%edx
  801372:	85 d2                	test   %edx,%edx
  801374:	78 68                	js     8013de <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801376:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801379:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801380:	8b 00                	mov    (%eax),%eax
  801382:	89 04 24             	mov    %eax,(%esp)
  801385:	e8 b2 fc ff ff       	call   80103c <dev_lookup>
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 50                	js     8013de <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80138e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801391:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801395:	75 23                	jne    8013ba <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801397:	a1 08 50 80 00       	mov    0x805008,%eax
  80139c:	8b 40 48             	mov    0x48(%eax),%eax
  80139f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a7:	c7 04 24 29 30 80 00 	movl   $0x803029,(%esp)
  8013ae:	e8 44 ee ff ff       	call   8001f7 <cprintf>
		return -E_INVAL;
  8013b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b8:	eb 24                	jmp    8013de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013bd:	8b 52 0c             	mov    0xc(%edx),%edx
  8013c0:	85 d2                	test   %edx,%edx
  8013c2:	74 15                	je     8013d9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013d2:	89 04 24             	mov    %eax,(%esp)
  8013d5:	ff d2                	call   *%edx
  8013d7:	eb 05                	jmp    8013de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8013d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8013de:	83 c4 24             	add    $0x24,%esp
  8013e1:	5b                   	pop    %ebx
  8013e2:	5d                   	pop    %ebp
  8013e3:	c3                   	ret    

008013e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ea:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	89 04 24             	mov    %eax,(%esp)
  8013f7:	e8 ea fb ff ff       	call   800fe6 <fd_lookup>
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 0e                	js     80140e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801400:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801403:	8b 55 0c             	mov    0xc(%ebp),%edx
  801406:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801409:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	53                   	push   %ebx
  801414:	83 ec 24             	sub    $0x24,%esp
  801417:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801421:	89 1c 24             	mov    %ebx,(%esp)
  801424:	e8 bd fb ff ff       	call   800fe6 <fd_lookup>
  801429:	89 c2                	mov    %eax,%edx
  80142b:	85 d2                	test   %edx,%edx
  80142d:	78 61                	js     801490 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801432:	89 44 24 04          	mov    %eax,0x4(%esp)
  801436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801439:	8b 00                	mov    (%eax),%eax
  80143b:	89 04 24             	mov    %eax,(%esp)
  80143e:	e8 f9 fb ff ff       	call   80103c <dev_lookup>
  801443:	85 c0                	test   %eax,%eax
  801445:	78 49                	js     801490 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80144e:	75 23                	jne    801473 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801450:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801455:	8b 40 48             	mov    0x48(%eax),%eax
  801458:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80145c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801460:	c7 04 24 ec 2f 80 00 	movl   $0x802fec,(%esp)
  801467:	e8 8b ed ff ff       	call   8001f7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80146c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801471:	eb 1d                	jmp    801490 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801476:	8b 52 18             	mov    0x18(%edx),%edx
  801479:	85 d2                	test   %edx,%edx
  80147b:	74 0e                	je     80148b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80147d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801480:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801484:	89 04 24             	mov    %eax,(%esp)
  801487:	ff d2                	call   *%edx
  801489:	eb 05                	jmp    801490 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80148b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801490:	83 c4 24             	add    $0x24,%esp
  801493:	5b                   	pop    %ebx
  801494:	5d                   	pop    %ebp
  801495:	c3                   	ret    

00801496 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	53                   	push   %ebx
  80149a:	83 ec 24             	sub    $0x24,%esp
  80149d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014aa:	89 04 24             	mov    %eax,(%esp)
  8014ad:	e8 34 fb ff ff       	call   800fe6 <fd_lookup>
  8014b2:	89 c2                	mov    %eax,%edx
  8014b4:	85 d2                	test   %edx,%edx
  8014b6:	78 52                	js     80150a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c2:	8b 00                	mov    (%eax),%eax
  8014c4:	89 04 24             	mov    %eax,(%esp)
  8014c7:	e8 70 fb ff ff       	call   80103c <dev_lookup>
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 3a                	js     80150a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8014d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014d7:	74 2c                	je     801505 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014d9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014e3:	00 00 00 
	stat->st_isdir = 0;
  8014e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014ed:	00 00 00 
	stat->st_dev = dev;
  8014f0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014fd:	89 14 24             	mov    %edx,(%esp)
  801500:	ff 50 14             	call   *0x14(%eax)
  801503:	eb 05                	jmp    80150a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801505:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80150a:	83 c4 24             	add    $0x24,%esp
  80150d:	5b                   	pop    %ebx
  80150e:	5d                   	pop    %ebp
  80150f:	c3                   	ret    

00801510 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	56                   	push   %esi
  801514:	53                   	push   %ebx
  801515:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801518:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80151f:	00 
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	89 04 24             	mov    %eax,(%esp)
  801526:	e8 28 02 00 00       	call   801753 <open>
  80152b:	89 c3                	mov    %eax,%ebx
  80152d:	85 db                	test   %ebx,%ebx
  80152f:	78 1b                	js     80154c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801531:	8b 45 0c             	mov    0xc(%ebp),%eax
  801534:	89 44 24 04          	mov    %eax,0x4(%esp)
  801538:	89 1c 24             	mov    %ebx,(%esp)
  80153b:	e8 56 ff ff ff       	call   801496 <fstat>
  801540:	89 c6                	mov    %eax,%esi
	close(fd);
  801542:	89 1c 24             	mov    %ebx,(%esp)
  801545:	e8 cd fb ff ff       	call   801117 <close>
	return r;
  80154a:	89 f0                	mov    %esi,%eax
}
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	5b                   	pop    %ebx
  801550:	5e                   	pop    %esi
  801551:	5d                   	pop    %ebp
  801552:	c3                   	ret    

00801553 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	56                   	push   %esi
  801557:	53                   	push   %ebx
  801558:	83 ec 10             	sub    $0x10,%esp
  80155b:	89 c6                	mov    %eax,%esi
  80155d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80155f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801566:	75 11                	jne    801579 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801568:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80156f:	e8 9a 13 00 00       	call   80290e <ipc_find_env>
  801574:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801579:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801580:	00 
  801581:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801588:	00 
  801589:	89 74 24 04          	mov    %esi,0x4(%esp)
  80158d:	a1 00 50 80 00       	mov    0x805000,%eax
  801592:	89 04 24             	mov    %eax,(%esp)
  801595:	e8 16 13 00 00       	call   8028b0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80159a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015a1:	00 
  8015a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ad:	e8 94 12 00 00       	call   802846 <ipc_recv>
}
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	5b                   	pop    %ebx
  8015b6:	5e                   	pop    %esi
  8015b7:	5d                   	pop    %ebp
  8015b8:	c3                   	ret    

008015b9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8015ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8015dc:	e8 72 ff ff ff       	call   801553 <fsipc>
}
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ef:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8015f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f9:	b8 06 00 00 00       	mov    $0x6,%eax
  8015fe:	e8 50 ff ff ff       	call   801553 <fsipc>
}
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	53                   	push   %ebx
  801609:	83 ec 14             	sub    $0x14,%esp
  80160c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8b 40 0c             	mov    0xc(%eax),%eax
  801615:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	b8 05 00 00 00       	mov    $0x5,%eax
  801624:	e8 2a ff ff ff       	call   801553 <fsipc>
  801629:	89 c2                	mov    %eax,%edx
  80162b:	85 d2                	test   %edx,%edx
  80162d:	78 2b                	js     80165a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80162f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801636:	00 
  801637:	89 1c 24             	mov    %ebx,(%esp)
  80163a:	e8 e8 f1 ff ff       	call   800827 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80163f:	a1 80 60 80 00       	mov    0x806080,%eax
  801644:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80164a:	a1 84 60 80 00       	mov    0x806084,%eax
  80164f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801655:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80165a:	83 c4 14             	add    $0x14,%esp
  80165d:	5b                   	pop    %ebx
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	83 ec 18             	sub    $0x18,%esp
  801666:	8b 45 10             	mov    0x10(%ebp),%eax
  801669:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80166e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801673:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801676:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80167b:	8b 55 08             	mov    0x8(%ebp),%edx
  80167e:	8b 52 0c             	mov    0xc(%edx),%edx
  801681:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801687:	89 44 24 08          	mov    %eax,0x8(%esp)
  80168b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801692:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801699:	e8 26 f3 ff ff       	call   8009c4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80169e:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8016a8:	e8 a6 fe ff ff       	call   801553 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	56                   	push   %esi
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 10             	sub    $0x10,%esp
  8016b7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8016c5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d0:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d5:	e8 79 fe ff ff       	call   801553 <fsipc>
  8016da:	89 c3                	mov    %eax,%ebx
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 6a                	js     80174a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016e0:	39 c6                	cmp    %eax,%esi
  8016e2:	73 24                	jae    801708 <devfile_read+0x59>
  8016e4:	c7 44 24 0c 5c 30 80 	movl   $0x80305c,0xc(%esp)
  8016eb:	00 
  8016ec:	c7 44 24 08 63 30 80 	movl   $0x803063,0x8(%esp)
  8016f3:	00 
  8016f4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8016fb:	00 
  8016fc:	c7 04 24 78 30 80 00 	movl   $0x803078,(%esp)
  801703:	e8 f6 e9 ff ff       	call   8000fe <_panic>
	assert(r <= PGSIZE);
  801708:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80170d:	7e 24                	jle    801733 <devfile_read+0x84>
  80170f:	c7 44 24 0c 83 30 80 	movl   $0x803083,0xc(%esp)
  801716:	00 
  801717:	c7 44 24 08 63 30 80 	movl   $0x803063,0x8(%esp)
  80171e:	00 
  80171f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801726:	00 
  801727:	c7 04 24 78 30 80 00 	movl   $0x803078,(%esp)
  80172e:	e8 cb e9 ff ff       	call   8000fe <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801733:	89 44 24 08          	mov    %eax,0x8(%esp)
  801737:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80173e:	00 
  80173f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801742:	89 04 24             	mov    %eax,(%esp)
  801745:	e8 7a f2 ff ff       	call   8009c4 <memmove>
	return r;
}
  80174a:	89 d8                	mov    %ebx,%eax
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    

00801753 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801753:	55                   	push   %ebp
  801754:	89 e5                	mov    %esp,%ebp
  801756:	53                   	push   %ebx
  801757:	83 ec 24             	sub    $0x24,%esp
  80175a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80175d:	89 1c 24             	mov    %ebx,(%esp)
  801760:	e8 8b f0 ff ff       	call   8007f0 <strlen>
  801765:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80176a:	7f 60                	jg     8017cc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80176c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176f:	89 04 24             	mov    %eax,(%esp)
  801772:	e8 20 f8 ff ff       	call   800f97 <fd_alloc>
  801777:	89 c2                	mov    %eax,%edx
  801779:	85 d2                	test   %edx,%edx
  80177b:	78 54                	js     8017d1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80177d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801781:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801788:	e8 9a f0 ff ff       	call   800827 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801795:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801798:	b8 01 00 00 00       	mov    $0x1,%eax
  80179d:	e8 b1 fd ff ff       	call   801553 <fsipc>
  8017a2:	89 c3                	mov    %eax,%ebx
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	79 17                	jns    8017bf <open+0x6c>
		fd_close(fd, 0);
  8017a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017af:	00 
  8017b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b3:	89 04 24             	mov    %eax,(%esp)
  8017b6:	e8 db f8 ff ff       	call   801096 <fd_close>
		return r;
  8017bb:	89 d8                	mov    %ebx,%eax
  8017bd:	eb 12                	jmp    8017d1 <open+0x7e>
	}

	return fd2num(fd);
  8017bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c2:	89 04 24             	mov    %eax,(%esp)
  8017c5:	e8 a6 f7 ff ff       	call   800f70 <fd2num>
  8017ca:	eb 05                	jmp    8017d1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8017cc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8017d1:	83 c4 24             	add    $0x24,%esp
  8017d4:	5b                   	pop    %ebx
  8017d5:	5d                   	pop    %ebp
  8017d6:	c3                   	ret    

008017d7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e2:	b8 08 00 00 00       	mov    $0x8,%eax
  8017e7:	e8 67 fd ff ff       	call   801553 <fsipc>
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    
  8017ee:	66 90                	xchg   %ax,%ax

008017f0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	57                   	push   %edi
  8017f4:	56                   	push   %esi
  8017f5:	53                   	push   %ebx
  8017f6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8017fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801803:	00 
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	89 04 24             	mov    %eax,(%esp)
  80180a:	e8 44 ff ff ff       	call   801753 <open>
  80180f:	89 c2                	mov    %eax,%edx
  801811:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801817:	85 c0                	test   %eax,%eax
  801819:	0f 88 0f 05 00 00    	js     801d2e <spawn+0x53e>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80181f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801826:	00 
  801827:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80182d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801831:	89 14 24             	mov    %edx,(%esp)
  801834:	e8 d3 fa ff ff       	call   80130c <readn>
  801839:	3d 00 02 00 00       	cmp    $0x200,%eax
  80183e:	75 0c                	jne    80184c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801840:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801847:	45 4c 46 
  80184a:	74 36                	je     801882 <spawn+0x92>
		close(fd);
  80184c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801852:	89 04 24             	mov    %eax,(%esp)
  801855:	e8 bd f8 ff ff       	call   801117 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80185a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801861:	46 
  801862:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801868:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186c:	c7 04 24 8f 30 80 00 	movl   $0x80308f,(%esp)
  801873:	e8 7f e9 ff ff       	call   8001f7 <cprintf>
		return -E_NOT_EXEC;
  801878:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80187d:	e9 0b 05 00 00       	jmp    801d8d <spawn+0x59d>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801882:	b8 07 00 00 00       	mov    $0x7,%eax
  801887:	cd 30                	int    $0x30
  801889:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80188f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801895:	85 c0                	test   %eax,%eax
  801897:	0f 88 99 04 00 00    	js     801d36 <spawn+0x546>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80189d:	89 c6                	mov    %eax,%esi
  80189f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8018a5:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8018a8:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8018ae:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8018b4:	b9 11 00 00 00       	mov    $0x11,%ecx
  8018b9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8018bb:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8018c1:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8018c7:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8018cc:	be 00 00 00 00       	mov    $0x0,%esi
  8018d1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8018d4:	eb 0f                	jmp    8018e5 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8018d6:	89 04 24             	mov    %eax,(%esp)
  8018d9:	e8 12 ef ff ff       	call   8007f0 <strlen>
  8018de:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8018e2:	83 c3 01             	add    $0x1,%ebx
  8018e5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8018ec:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	75 e3                	jne    8018d6 <spawn+0xe6>
  8018f3:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8018f9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8018ff:	bf 00 10 40 00       	mov    $0x401000,%edi
  801904:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801906:	89 fa                	mov    %edi,%edx
  801908:	83 e2 fc             	and    $0xfffffffc,%edx
  80190b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801912:	29 c2                	sub    %eax,%edx
  801914:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80191a:	8d 42 f8             	lea    -0x8(%edx),%eax
  80191d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801922:	0f 86 1e 04 00 00    	jbe    801d46 <spawn+0x556>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801928:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80192f:	00 
  801930:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801937:	00 
  801938:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80193f:	e8 ff f2 ff ff       	call   800c43 <sys_page_alloc>
  801944:	85 c0                	test   %eax,%eax
  801946:	0f 88 41 04 00 00    	js     801d8d <spawn+0x59d>
  80194c:	be 00 00 00 00       	mov    $0x0,%esi
  801951:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801957:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80195a:	eb 30                	jmp    80198c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80195c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801962:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801968:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80196b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80196e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801972:	89 3c 24             	mov    %edi,(%esp)
  801975:	e8 ad ee ff ff       	call   800827 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80197a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80197d:	89 04 24             	mov    %eax,(%esp)
  801980:	e8 6b ee ff ff       	call   8007f0 <strlen>
  801985:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801989:	83 c6 01             	add    $0x1,%esi
  80198c:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801992:	7f c8                	jg     80195c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801994:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80199a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8019a0:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8019a7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8019ad:	74 24                	je     8019d3 <spawn+0x1e3>
  8019af:	c7 44 24 0c 04 31 80 	movl   $0x803104,0xc(%esp)
  8019b6:	00 
  8019b7:	c7 44 24 08 63 30 80 	movl   $0x803063,0x8(%esp)
  8019be:	00 
  8019bf:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  8019c6:	00 
  8019c7:	c7 04 24 a9 30 80 00 	movl   $0x8030a9,(%esp)
  8019ce:	e8 2b e7 ff ff       	call   8000fe <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8019d3:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8019d9:	89 c8                	mov    %ecx,%eax
  8019db:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8019e0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8019e3:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8019e9:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8019ec:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  8019f2:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8019f8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8019ff:	00 
  801a00:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801a07:	ee 
  801a08:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801a0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a12:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a19:	00 
  801a1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a21:	e8 71 f2 ff ff       	call   800c97 <sys_page_map>
  801a26:	89 c3                	mov    %eax,%ebx
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	0f 88 47 03 00 00    	js     801d77 <spawn+0x587>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801a30:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a37:	00 
  801a38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3f:	e8 a6 f2 ff ff       	call   800cea <sys_page_unmap>
  801a44:	89 c3                	mov    %eax,%ebx
  801a46:	85 c0                	test   %eax,%eax
  801a48:	0f 88 29 03 00 00    	js     801d77 <spawn+0x587>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801a4e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801a54:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801a5b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801a61:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801a68:	00 00 00 
  801a6b:	e9 b6 01 00 00       	jmp    801c26 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801a70:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801a76:	83 38 01             	cmpl   $0x1,(%eax)
  801a79:	0f 85 99 01 00 00    	jne    801c18 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801a7f:	89 c2                	mov    %eax,%edx
  801a81:	8b 40 18             	mov    0x18(%eax),%eax
  801a84:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801a87:	83 f8 01             	cmp    $0x1,%eax
  801a8a:	19 c0                	sbb    %eax,%eax
  801a8c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801a92:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801a99:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801aa0:	89 d0                	mov    %edx,%eax
  801aa2:	8b 7a 04             	mov    0x4(%edx),%edi
  801aa5:	89 bd 80 fd ff ff    	mov    %edi,-0x280(%ebp)
  801aab:	8b 52 10             	mov    0x10(%edx),%edx
  801aae:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801ab4:	8b 78 14             	mov    0x14(%eax),%edi
  801ab7:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  801abd:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801ac0:	89 f0                	mov    %esi,%eax
  801ac2:	25 ff 0f 00 00       	and    $0xfff,%eax
  801ac7:	74 14                	je     801add <spawn+0x2ed>
		va -= i;
  801ac9:	29 c6                	sub    %eax,%esi
		memsz += i;
  801acb:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801ad1:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801ad7:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801add:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae2:	e9 23 01 00 00       	jmp    801c0a <spawn+0x41a>
		if (i >= filesz) {
  801ae7:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801aed:	77 2b                	ja     801b1a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801aef:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801af5:	89 44 24 08          	mov    %eax,0x8(%esp)
  801af9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801afd:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801b03:	89 04 24             	mov    %eax,(%esp)
  801b06:	e8 38 f1 ff ff       	call   800c43 <sys_page_alloc>
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	0f 89 eb 00 00 00    	jns    801bfe <spawn+0x40e>
  801b13:	89 c3                	mov    %eax,%ebx
  801b15:	e9 3d 02 00 00       	jmp    801d57 <spawn+0x567>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b1a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801b21:	00 
  801b22:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b29:	00 
  801b2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b31:	e8 0d f1 ff ff       	call   800c43 <sys_page_alloc>
  801b36:	85 c0                	test   %eax,%eax
  801b38:	0f 88 0f 02 00 00    	js     801d4d <spawn+0x55d>
  801b3e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b44:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801b46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801b50:	89 04 24             	mov    %eax,(%esp)
  801b53:	e8 8c f8 ff ff       	call   8013e4 <seek>
  801b58:	85 c0                	test   %eax,%eax
  801b5a:	0f 88 f1 01 00 00    	js     801d51 <spawn+0x561>
  801b60:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801b66:	29 f9                	sub    %edi,%ecx
  801b68:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801b6a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801b70:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801b75:	0f 47 c1             	cmova  %ecx,%eax
  801b78:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b7c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801b83:	00 
  801b84:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801b8a:	89 04 24             	mov    %eax,(%esp)
  801b8d:	e8 7a f7 ff ff       	call   80130c <readn>
  801b92:	85 c0                	test   %eax,%eax
  801b94:	0f 88 bb 01 00 00    	js     801d55 <spawn+0x565>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801b9a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801ba0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ba4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ba8:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801bae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bb9:	00 
  801bba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bc1:	e8 d1 f0 ff ff       	call   800c97 <sys_page_map>
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	79 20                	jns    801bea <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  801bca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bce:	c7 44 24 08 b5 30 80 	movl   $0x8030b5,0x8(%esp)
  801bd5:	00 
  801bd6:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  801bdd:	00 
  801bde:	c7 04 24 a9 30 80 00 	movl   $0x8030a9,(%esp)
  801be5:	e8 14 e5 ff ff       	call   8000fe <_panic>
			sys_page_unmap(0, UTEMP);
  801bea:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bf1:	00 
  801bf2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf9:	e8 ec f0 ff ff       	call   800cea <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801bfe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801c04:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801c0a:	89 df                	mov    %ebx,%edi
  801c0c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801c12:	0f 87 cf fe ff ff    	ja     801ae7 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c18:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801c1f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801c26:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801c2d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801c33:	0f 8c 37 fe ff ff    	jl     801a70 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801c39:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c3f:	89 04 24             	mov    %eax,(%esp)
  801c42:	e8 d0 f4 ff ff       	call   801117 <close>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  801c47:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c4c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	{
		if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U))&&((uvpt[i/PGSIZE]&(PTE_SHARE))==PTE_SHARE))
  801c52:	89 d8                	mov    %ebx,%eax
  801c54:	c1 e8 16             	shr    $0x16,%eax
  801c57:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c5e:	a8 01                	test   $0x1,%al
  801c60:	74 48                	je     801caa <spawn+0x4ba>
  801c62:	89 d8                	mov    %ebx,%eax
  801c64:	c1 e8 0c             	shr    $0xc,%eax
  801c67:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c6e:	83 e2 05             	and    $0x5,%edx
  801c71:	83 fa 05             	cmp    $0x5,%edx
  801c74:	75 34                	jne    801caa <spawn+0x4ba>
  801c76:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801c7d:	f6 c6 04             	test   $0x4,%dh
  801c80:	74 28                	je     801caa <spawn+0x4ba>
		{
			//cprintf("in copy_shared_pages\n");
			//cprintf("%08x\n",PDX(i));
			sys_page_map(0,(void*)i,child,(void*)i,uvpt[i/PGSIZE]&PTE_SYSCALL);
  801c82:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c89:	25 07 0e 00 00       	and    $0xe07,%eax
  801c8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c92:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801c96:	89 74 24 08          	mov    %esi,0x8(%esp)
  801c9a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ca5:	e8 ed ef ff ff       	call   800c97 <sys_page_map>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  801caa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cb0:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801cb6:	75 9a                	jne    801c52 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801cb8:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801cc8:	89 04 24             	mov    %eax,(%esp)
  801ccb:	e8 c0 f0 ff ff       	call   800d90 <sys_env_set_trapframe>
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	79 20                	jns    801cf4 <spawn+0x504>
		panic("sys_env_set_trapframe: %e", r);
  801cd4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cd8:	c7 44 24 08 d2 30 80 	movl   $0x8030d2,0x8(%esp)
  801cdf:	00 
  801ce0:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801ce7:	00 
  801ce8:	c7 04 24 a9 30 80 00 	movl   $0x8030a9,(%esp)
  801cef:	e8 0a e4 ff ff       	call   8000fe <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801cf4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801cfb:	00 
  801cfc:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d02:	89 04 24             	mov    %eax,(%esp)
  801d05:	e8 33 f0 ff ff       	call   800d3d <sys_env_set_status>
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	79 30                	jns    801d3e <spawn+0x54e>
		panic("sys_env_set_status: %e", r);
  801d0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d12:	c7 44 24 08 ec 30 80 	movl   $0x8030ec,0x8(%esp)
  801d19:	00 
  801d1a:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  801d21:	00 
  801d22:	c7 04 24 a9 30 80 00 	movl   $0x8030a9,(%esp)
  801d29:	e8 d0 e3 ff ff       	call   8000fe <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801d2e:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d34:	eb 57                	jmp    801d8d <spawn+0x59d>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801d36:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d3c:	eb 4f                	jmp    801d8d <spawn+0x59d>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801d3e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d44:	eb 47                	jmp    801d8d <spawn+0x59d>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801d46:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801d4b:	eb 40                	jmp    801d8d <spawn+0x59d>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801d4d:	89 c3                	mov    %eax,%ebx
  801d4f:	eb 06                	jmp    801d57 <spawn+0x567>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801d51:	89 c3                	mov    %eax,%ebx
  801d53:	eb 02                	jmp    801d57 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801d55:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  801d57:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d5d:	89 04 24             	mov    %eax,(%esp)
  801d60:	e8 4e ee ff ff       	call   800bb3 <sys_env_destroy>
	close(fd);
  801d65:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d6b:	89 04 24             	mov    %eax,(%esp)
  801d6e:	e8 a4 f3 ff ff       	call   801117 <close>
	return r;
  801d73:	89 d8                	mov    %ebx,%eax
  801d75:	eb 16                	jmp    801d8d <spawn+0x59d>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801d77:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d7e:	00 
  801d7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d86:	e8 5f ef ff ff       	call   800cea <sys_page_unmap>
  801d8b:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801d8d:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801d93:	5b                   	pop    %ebx
  801d94:	5e                   	pop    %esi
  801d95:	5f                   	pop    %edi
  801d96:	5d                   	pop    %ebp
  801d97:	c3                   	ret    

00801d98 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	56                   	push   %esi
  801d9c:	53                   	push   %ebx
  801d9d:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801da0:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801da3:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801da8:	eb 03                	jmp    801dad <spawnl+0x15>
		argc++;
  801daa:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801dad:	83 c0 04             	add    $0x4,%eax
  801db0:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801db4:	75 f4                	jne    801daa <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801db6:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  801dbd:	83 e0 f0             	and    $0xfffffff0,%eax
  801dc0:	29 c4                	sub    %eax,%esp
  801dc2:	8d 44 24 0b          	lea    0xb(%esp),%eax
  801dc6:	c1 e8 02             	shr    $0x2,%eax
  801dc9:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  801dd0:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801dd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dd5:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  801ddc:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  801de3:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
  801de9:	eb 0a                	jmp    801df5 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  801deb:	83 c0 01             	add    $0x1,%eax
  801dee:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801df2:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801df5:	39 d0                	cmp    %edx,%eax
  801df7:	75 f2                	jne    801deb <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801df9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	89 04 24             	mov    %eax,(%esp)
  801e03:	e8 e8 f9 ff ff       	call   8017f0 <spawn>
}
  801e08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0b:	5b                   	pop    %ebx
  801e0c:	5e                   	pop    %esi
  801e0d:	5d                   	pop    %ebp
  801e0e:	c3                   	ret    
  801e0f:	90                   	nop

00801e10 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e16:	c7 44 24 04 2c 31 80 	movl   $0x80312c,0x4(%esp)
  801e1d:	00 
  801e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e21:	89 04 24             	mov    %eax,(%esp)
  801e24:	e8 fe e9 ff ff       	call   800827 <strcpy>
	return 0;
}
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	53                   	push   %ebx
  801e34:	83 ec 14             	sub    $0x14,%esp
  801e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e3a:	89 1c 24             	mov    %ebx,(%esp)
  801e3d:	e8 04 0b 00 00       	call   802946 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e42:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e47:	83 f8 01             	cmp    $0x1,%eax
  801e4a:	75 0d                	jne    801e59 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e4c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 29 03 00 00       	call   802180 <nsipc_close>
  801e57:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e59:	89 d0                	mov    %edx,%eax
  801e5b:	83 c4 14             	add    $0x14,%esp
  801e5e:	5b                   	pop    %ebx
  801e5f:	5d                   	pop    %ebp
  801e60:	c3                   	ret    

00801e61 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e67:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e6e:	00 
  801e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	8b 40 0c             	mov    0xc(%eax),%eax
  801e83:	89 04 24             	mov    %eax,(%esp)
  801e86:	e8 f0 03 00 00       	call   80227b <nsipc_send>
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e93:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e9a:	00 
  801e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaf:	89 04 24             	mov    %eax,(%esp)
  801eb2:	e8 44 03 00 00       	call   8021fb <nsipc_recv>
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ebf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ec2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ec6:	89 04 24             	mov    %eax,(%esp)
  801ec9:	e8 18 f1 ff ff       	call   800fe6 <fd_lookup>
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 17                	js     801ee9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801edb:	39 08                	cmp    %ecx,(%eax)
  801edd:	75 05                	jne    801ee4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801edf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee2:	eb 05                	jmp    801ee9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ee4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	83 ec 20             	sub    $0x20,%esp
  801ef3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef8:	89 04 24             	mov    %eax,(%esp)
  801efb:	e8 97 f0 ff ff       	call   800f97 <fd_alloc>
  801f00:	89 c3                	mov    %eax,%ebx
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 21                	js     801f27 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f0d:	00 
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1c:	e8 22 ed ff ff       	call   800c43 <sys_page_alloc>
  801f21:	89 c3                	mov    %eax,%ebx
  801f23:	85 c0                	test   %eax,%eax
  801f25:	79 0c                	jns    801f33 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f27:	89 34 24             	mov    %esi,(%esp)
  801f2a:	e8 51 02 00 00       	call   802180 <nsipc_close>
		return r;
  801f2f:	89 d8                	mov    %ebx,%eax
  801f31:	eb 20                	jmp    801f53 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f33:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f41:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f48:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f4b:	89 14 24             	mov    %edx,(%esp)
  801f4e:	e8 1d f0 ff ff       	call   800f70 <fd2num>
}
  801f53:	83 c4 20             	add    $0x20,%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    

00801f5a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	e8 51 ff ff ff       	call   801eb9 <fd2sockid>
		return r;
  801f68:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	78 23                	js     801f91 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f6e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f71:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f78:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f7c:	89 04 24             	mov    %eax,(%esp)
  801f7f:	e8 45 01 00 00       	call   8020c9 <nsipc_accept>
		return r;
  801f84:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f86:	85 c0                	test   %eax,%eax
  801f88:	78 07                	js     801f91 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f8a:	e8 5c ff ff ff       	call   801eeb <alloc_sockfd>
  801f8f:	89 c1                	mov    %eax,%ecx
}
  801f91:	89 c8                	mov    %ecx,%eax
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	e8 16 ff ff ff       	call   801eb9 <fd2sockid>
  801fa3:	89 c2                	mov    %eax,%edx
  801fa5:	85 d2                	test   %edx,%edx
  801fa7:	78 16                	js     801fbf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fac:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb7:	89 14 24             	mov    %edx,(%esp)
  801fba:	e8 60 01 00 00       	call   80211f <nsipc_bind>
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <shutdown>:

int
shutdown(int s, int how)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	e8 ea fe ff ff       	call   801eb9 <fd2sockid>
  801fcf:	89 c2                	mov    %eax,%edx
  801fd1:	85 d2                	test   %edx,%edx
  801fd3:	78 0f                	js     801fe4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fdc:	89 14 24             	mov    %edx,(%esp)
  801fdf:	e8 7a 01 00 00       	call   80215e <nsipc_shutdown>
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	e8 c5 fe ff ff       	call   801eb9 <fd2sockid>
  801ff4:	89 c2                	mov    %eax,%edx
  801ff6:	85 d2                	test   %edx,%edx
  801ff8:	78 16                	js     802010 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802001:	8b 45 0c             	mov    0xc(%ebp),%eax
  802004:	89 44 24 04          	mov    %eax,0x4(%esp)
  802008:	89 14 24             	mov    %edx,(%esp)
  80200b:	e8 8a 01 00 00       	call   80219a <nsipc_connect>
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <listen>:

int
listen(int s, int backlog)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	e8 99 fe ff ff       	call   801eb9 <fd2sockid>
  802020:	89 c2                	mov    %eax,%edx
  802022:	85 d2                	test   %edx,%edx
  802024:	78 0f                	js     802035 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802026:	8b 45 0c             	mov    0xc(%ebp),%eax
  802029:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202d:	89 14 24             	mov    %edx,(%esp)
  802030:	e8 a4 01 00 00       	call   8021d9 <nsipc_listen>
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80203d:	8b 45 10             	mov    0x10(%ebp),%eax
  802040:	89 44 24 08          	mov    %eax,0x8(%esp)
  802044:	8b 45 0c             	mov    0xc(%ebp),%eax
  802047:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	89 04 24             	mov    %eax,(%esp)
  802051:	e8 98 02 00 00       	call   8022ee <nsipc_socket>
  802056:	89 c2                	mov    %eax,%edx
  802058:	85 d2                	test   %edx,%edx
  80205a:	78 05                	js     802061 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80205c:	e8 8a fe ff ff       	call   801eeb <alloc_sockfd>
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	53                   	push   %ebx
  802067:	83 ec 14             	sub    $0x14,%esp
  80206a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80206c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802073:	75 11                	jne    802086 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802075:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80207c:	e8 8d 08 00 00       	call   80290e <ipc_find_env>
  802081:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802086:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80208d:	00 
  80208e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802095:	00 
  802096:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80209a:	a1 04 50 80 00       	mov    0x805004,%eax
  80209f:	89 04 24             	mov    %eax,(%esp)
  8020a2:	e8 09 08 00 00       	call   8028b0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020ae:	00 
  8020af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020b6:	00 
  8020b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020be:	e8 83 07 00 00       	call   802846 <ipc_recv>
}
  8020c3:	83 c4 14             	add    $0x14,%esp
  8020c6:	5b                   	pop    %ebx
  8020c7:	5d                   	pop    %ebp
  8020c8:	c3                   	ret    

008020c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	56                   	push   %esi
  8020cd:	53                   	push   %ebx
  8020ce:	83 ec 10             	sub    $0x10,%esp
  8020d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020dc:	8b 06                	mov    (%esi),%eax
  8020de:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e8:	e8 76 ff ff ff       	call   802063 <nsipc>
  8020ed:	89 c3                	mov    %eax,%ebx
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 23                	js     802116 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020f3:	a1 10 70 80 00       	mov    0x807010,%eax
  8020f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020fc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802103:	00 
  802104:	8b 45 0c             	mov    0xc(%ebp),%eax
  802107:	89 04 24             	mov    %eax,(%esp)
  80210a:	e8 b5 e8 ff ff       	call   8009c4 <memmove>
		*addrlen = ret->ret_addrlen;
  80210f:	a1 10 70 80 00       	mov    0x807010,%eax
  802114:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802116:	89 d8                	mov    %ebx,%eax
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	5b                   	pop    %ebx
  80211c:	5e                   	pop    %esi
  80211d:	5d                   	pop    %ebp
  80211e:	c3                   	ret    

0080211f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	53                   	push   %ebx
  802123:	83 ec 14             	sub    $0x14,%esp
  802126:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802131:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802135:	8b 45 0c             	mov    0xc(%ebp),%eax
  802138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802143:	e8 7c e8 ff ff       	call   8009c4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802148:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80214e:	b8 02 00 00 00       	mov    $0x2,%eax
  802153:	e8 0b ff ff ff       	call   802063 <nsipc>
}
  802158:	83 c4 14             	add    $0x14,%esp
  80215b:	5b                   	pop    %ebx
  80215c:	5d                   	pop    %ebp
  80215d:	c3                   	ret    

0080215e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80216c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802174:	b8 03 00 00 00       	mov    $0x3,%eax
  802179:	e8 e5 fe ff ff       	call   802063 <nsipc>
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <nsipc_close>:

int
nsipc_close(int s)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80218e:	b8 04 00 00 00       	mov    $0x4,%eax
  802193:	e8 cb fe ff ff       	call   802063 <nsipc>
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	53                   	push   %ebx
  80219e:	83 ec 14             	sub    $0x14,%esp
  8021a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021be:	e8 01 e8 ff ff       	call   8009c4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021c3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021ce:	e8 90 fe ff ff       	call   802063 <nsipc>
}
  8021d3:	83 c4 14             	add    $0x14,%esp
  8021d6:	5b                   	pop    %ebx
  8021d7:	5d                   	pop    %ebp
  8021d8:	c3                   	ret    

008021d9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ea:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8021f4:	e8 6a fe ff ff       	call   802063 <nsipc>
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	56                   	push   %esi
  8021ff:	53                   	push   %ebx
  802200:	83 ec 10             	sub    $0x10,%esp
  802203:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80220e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802214:	8b 45 14             	mov    0x14(%ebp),%eax
  802217:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80221c:	b8 07 00 00 00       	mov    $0x7,%eax
  802221:	e8 3d fe ff ff       	call   802063 <nsipc>
  802226:	89 c3                	mov    %eax,%ebx
  802228:	85 c0                	test   %eax,%eax
  80222a:	78 46                	js     802272 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80222c:	39 f0                	cmp    %esi,%eax
  80222e:	7f 07                	jg     802237 <nsipc_recv+0x3c>
  802230:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802235:	7e 24                	jle    80225b <nsipc_recv+0x60>
  802237:	c7 44 24 0c 38 31 80 	movl   $0x803138,0xc(%esp)
  80223e:	00 
  80223f:	c7 44 24 08 63 30 80 	movl   $0x803063,0x8(%esp)
  802246:	00 
  802247:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80224e:	00 
  80224f:	c7 04 24 4d 31 80 00 	movl   $0x80314d,(%esp)
  802256:	e8 a3 de ff ff       	call   8000fe <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80225b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80225f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802266:	00 
  802267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226a:	89 04 24             	mov    %eax,(%esp)
  80226d:	e8 52 e7 ff ff       	call   8009c4 <memmove>
	}

	return r;
}
  802272:	89 d8                	mov    %ebx,%eax
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5d                   	pop    %ebp
  80227a:	c3                   	ret    

0080227b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	53                   	push   %ebx
  80227f:	83 ec 14             	sub    $0x14,%esp
  802282:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80228d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802293:	7e 24                	jle    8022b9 <nsipc_send+0x3e>
  802295:	c7 44 24 0c 59 31 80 	movl   $0x803159,0xc(%esp)
  80229c:	00 
  80229d:	c7 44 24 08 63 30 80 	movl   $0x803063,0x8(%esp)
  8022a4:	00 
  8022a5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8022ac:	00 
  8022ad:	c7 04 24 4d 31 80 00 	movl   $0x80314d,(%esp)
  8022b4:	e8 45 de ff ff       	call   8000fe <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8022cb:	e8 f4 e6 ff ff       	call   8009c4 <memmove>
	nsipcbuf.send.req_size = size;
  8022d0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022de:	b8 08 00 00 00       	mov    $0x8,%eax
  8022e3:	e8 7b fd ff ff       	call   802063 <nsipc>
}
  8022e8:	83 c4 14             	add    $0x14,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    

008022ee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802304:	8b 45 10             	mov    0x10(%ebp),%eax
  802307:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80230c:	b8 09 00 00 00       	mov    $0x9,%eax
  802311:	e8 4d fd ff ff       	call   802063 <nsipc>
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	56                   	push   %esi
  80231c:	53                   	push   %ebx
  80231d:	83 ec 10             	sub    $0x10,%esp
  802320:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	89 04 24             	mov    %eax,(%esp)
  802329:	e8 52 ec ff ff       	call   800f80 <fd2data>
  80232e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802330:	c7 44 24 04 65 31 80 	movl   $0x803165,0x4(%esp)
  802337:	00 
  802338:	89 1c 24             	mov    %ebx,(%esp)
  80233b:	e8 e7 e4 ff ff       	call   800827 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802340:	8b 46 04             	mov    0x4(%esi),%eax
  802343:	2b 06                	sub    (%esi),%eax
  802345:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80234b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802352:	00 00 00 
	stat->st_dev = &devpipe;
  802355:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80235c:	40 80 00 
	return 0;
}
  80235f:	b8 00 00 00 00       	mov    $0x0,%eax
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	5b                   	pop    %ebx
  802368:	5e                   	pop    %esi
  802369:	5d                   	pop    %ebp
  80236a:	c3                   	ret    

0080236b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	53                   	push   %ebx
  80236f:	83 ec 14             	sub    $0x14,%esp
  802372:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802375:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802379:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802380:	e8 65 e9 ff ff       	call   800cea <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802385:	89 1c 24             	mov    %ebx,(%esp)
  802388:	e8 f3 eb ff ff       	call   800f80 <fd2data>
  80238d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802391:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802398:	e8 4d e9 ff ff       	call   800cea <sys_page_unmap>
}
  80239d:	83 c4 14             	add    $0x14,%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5d                   	pop    %ebp
  8023a2:	c3                   	ret    

008023a3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	57                   	push   %edi
  8023a7:	56                   	push   %esi
  8023a8:	53                   	push   %ebx
  8023a9:	83 ec 2c             	sub    $0x2c,%esp
  8023ac:	89 c6                	mov    %eax,%esi
  8023ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8023b6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023b9:	89 34 24             	mov    %esi,(%esp)
  8023bc:	e8 85 05 00 00       	call   802946 <pageref>
  8023c1:	89 c7                	mov    %eax,%edi
  8023c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c6:	89 04 24             	mov    %eax,(%esp)
  8023c9:	e8 78 05 00 00       	call   802946 <pageref>
  8023ce:	39 c7                	cmp    %eax,%edi
  8023d0:	0f 94 c2             	sete   %dl
  8023d3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8023d6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8023dc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8023df:	39 fb                	cmp    %edi,%ebx
  8023e1:	74 21                	je     802404 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8023e3:	84 d2                	test   %dl,%dl
  8023e5:	74 ca                	je     8023b1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023e7:	8b 51 58             	mov    0x58(%ecx),%edx
  8023ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023f6:	c7 04 24 6c 31 80 00 	movl   $0x80316c,(%esp)
  8023fd:	e8 f5 dd ff ff       	call   8001f7 <cprintf>
  802402:	eb ad                	jmp    8023b1 <_pipeisclosed+0xe>
	}
}
  802404:	83 c4 2c             	add    $0x2c,%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5f                   	pop    %edi
  80240a:	5d                   	pop    %ebp
  80240b:	c3                   	ret    

0080240c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	57                   	push   %edi
  802410:	56                   	push   %esi
  802411:	53                   	push   %ebx
  802412:	83 ec 1c             	sub    $0x1c,%esp
  802415:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802418:	89 34 24             	mov    %esi,(%esp)
  80241b:	e8 60 eb ff ff       	call   800f80 <fd2data>
  802420:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802422:	bf 00 00 00 00       	mov    $0x0,%edi
  802427:	eb 45                	jmp    80246e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802429:	89 da                	mov    %ebx,%edx
  80242b:	89 f0                	mov    %esi,%eax
  80242d:	e8 71 ff ff ff       	call   8023a3 <_pipeisclosed>
  802432:	85 c0                	test   %eax,%eax
  802434:	75 41                	jne    802477 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802436:	e8 e9 e7 ff ff       	call   800c24 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80243b:	8b 43 04             	mov    0x4(%ebx),%eax
  80243e:	8b 0b                	mov    (%ebx),%ecx
  802440:	8d 51 20             	lea    0x20(%ecx),%edx
  802443:	39 d0                	cmp    %edx,%eax
  802445:	73 e2                	jae    802429 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802447:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80244a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80244e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802451:	99                   	cltd   
  802452:	c1 ea 1b             	shr    $0x1b,%edx
  802455:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802458:	83 e1 1f             	and    $0x1f,%ecx
  80245b:	29 d1                	sub    %edx,%ecx
  80245d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802461:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802465:	83 c0 01             	add    $0x1,%eax
  802468:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80246b:	83 c7 01             	add    $0x1,%edi
  80246e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802471:	75 c8                	jne    80243b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802473:	89 f8                	mov    %edi,%eax
  802475:	eb 05                	jmp    80247c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80247c:	83 c4 1c             	add    $0x1c,%esp
  80247f:	5b                   	pop    %ebx
  802480:	5e                   	pop    %esi
  802481:	5f                   	pop    %edi
  802482:	5d                   	pop    %ebp
  802483:	c3                   	ret    

00802484 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	57                   	push   %edi
  802488:	56                   	push   %esi
  802489:	53                   	push   %ebx
  80248a:	83 ec 1c             	sub    $0x1c,%esp
  80248d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802490:	89 3c 24             	mov    %edi,(%esp)
  802493:	e8 e8 ea ff ff       	call   800f80 <fd2data>
  802498:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80249a:	be 00 00 00 00       	mov    $0x0,%esi
  80249f:	eb 3d                	jmp    8024de <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8024a1:	85 f6                	test   %esi,%esi
  8024a3:	74 04                	je     8024a9 <devpipe_read+0x25>
				return i;
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	eb 43                	jmp    8024ec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8024a9:	89 da                	mov    %ebx,%edx
  8024ab:	89 f8                	mov    %edi,%eax
  8024ad:	e8 f1 fe ff ff       	call   8023a3 <_pipeisclosed>
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	75 31                	jne    8024e7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024b6:	e8 69 e7 ff ff       	call   800c24 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024bb:	8b 03                	mov    (%ebx),%eax
  8024bd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024c0:	74 df                	je     8024a1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024c2:	99                   	cltd   
  8024c3:	c1 ea 1b             	shr    $0x1b,%edx
  8024c6:	01 d0                	add    %edx,%eax
  8024c8:	83 e0 1f             	and    $0x1f,%eax
  8024cb:	29 d0                	sub    %edx,%eax
  8024cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024d8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024db:	83 c6 01             	add    $0x1,%esi
  8024de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024e1:	75 d8                	jne    8024bb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024e3:	89 f0                	mov    %esi,%eax
  8024e5:	eb 05                	jmp    8024ec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024ec:	83 c4 1c             	add    $0x1c,%esp
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    

008024f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	56                   	push   %esi
  8024f8:	53                   	push   %ebx
  8024f9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ff:	89 04 24             	mov    %eax,(%esp)
  802502:	e8 90 ea ff ff       	call   800f97 <fd_alloc>
  802507:	89 c2                	mov    %eax,%edx
  802509:	85 d2                	test   %edx,%edx
  80250b:	0f 88 4d 01 00 00    	js     80265e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802511:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802518:	00 
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802520:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802527:	e8 17 e7 ff ff       	call   800c43 <sys_page_alloc>
  80252c:	89 c2                	mov    %eax,%edx
  80252e:	85 d2                	test   %edx,%edx
  802530:	0f 88 28 01 00 00    	js     80265e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802536:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802539:	89 04 24             	mov    %eax,(%esp)
  80253c:	e8 56 ea ff ff       	call   800f97 <fd_alloc>
  802541:	89 c3                	mov    %eax,%ebx
  802543:	85 c0                	test   %eax,%eax
  802545:	0f 88 fe 00 00 00    	js     802649 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80254b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802552:	00 
  802553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802561:	e8 dd e6 ff ff       	call   800c43 <sys_page_alloc>
  802566:	89 c3                	mov    %eax,%ebx
  802568:	85 c0                	test   %eax,%eax
  80256a:	0f 88 d9 00 00 00    	js     802649 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	89 04 24             	mov    %eax,(%esp)
  802576:	e8 05 ea ff ff       	call   800f80 <fd2data>
  80257b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802584:	00 
  802585:	89 44 24 04          	mov    %eax,0x4(%esp)
  802589:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802590:	e8 ae e6 ff ff       	call   800c43 <sys_page_alloc>
  802595:	89 c3                	mov    %eax,%ebx
  802597:	85 c0                	test   %eax,%eax
  802599:	0f 88 97 00 00 00    	js     802636 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80259f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a2:	89 04 24             	mov    %eax,(%esp)
  8025a5:	e8 d6 e9 ff ff       	call   800f80 <fd2data>
  8025aa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8025b1:	00 
  8025b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025bd:	00 
  8025be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c9:	e8 c9 e6 ff ff       	call   800c97 <sys_page_map>
  8025ce:	89 c3                	mov    %eax,%ebx
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	78 52                	js     802626 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025d4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025e9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	89 04 24             	mov    %eax,(%esp)
  802604:	e8 67 e9 ff ff       	call   800f70 <fd2num>
  802609:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80260c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80260e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802611:	89 04 24             	mov    %eax,(%esp)
  802614:	e8 57 e9 ff ff       	call   800f70 <fd2num>
  802619:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
  802624:	eb 38                	jmp    80265e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802626:	89 74 24 04          	mov    %esi,0x4(%esp)
  80262a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802631:	e8 b4 e6 ff ff       	call   800cea <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802644:	e8 a1 e6 ff ff       	call   800cea <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802650:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802657:	e8 8e e6 ff ff       	call   800cea <sys_page_unmap>
  80265c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80265e:	83 c4 30             	add    $0x30,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    

00802665 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80266b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80266e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	89 04 24             	mov    %eax,(%esp)
  802678:	e8 69 e9 ff ff       	call   800fe6 <fd_lookup>
  80267d:	89 c2                	mov    %eax,%edx
  80267f:	85 d2                	test   %edx,%edx
  802681:	78 15                	js     802698 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	89 04 24             	mov    %eax,(%esp)
  802689:	e8 f2 e8 ff ff       	call   800f80 <fd2data>
	return _pipeisclosed(fd, p);
  80268e:	89 c2                	mov    %eax,%edx
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	e8 0b fd ff ff       	call   8023a3 <_pipeisclosed>
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    
  80269a:	66 90                	xchg   %ax,%ax
  80269c:	66 90                	xchg   %ax,%ax
  80269e:	66 90                	xchg   %ax,%ax

008026a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	5d                   	pop    %ebp
  8026a9:	c3                   	ret    

008026aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026b0:	c7 44 24 04 84 31 80 	movl   $0x803184,0x4(%esp)
  8026b7:	00 
  8026b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bb:	89 04 24             	mov    %eax,(%esp)
  8026be:	e8 64 e1 ff ff       	call   800827 <strcpy>
	return 0;
}
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	57                   	push   %edi
  8026ce:	56                   	push   %esi
  8026cf:	53                   	push   %ebx
  8026d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026e1:	eb 31                	jmp    802714 <devcons_write+0x4a>
		m = n - tot;
  8026e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8026e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8026e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8026eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8026f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026f7:	03 45 0c             	add    0xc(%ebp),%eax
  8026fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026fe:	89 3c 24             	mov    %edi,(%esp)
  802701:	e8 be e2 ff ff       	call   8009c4 <memmove>
		sys_cputs(buf, m);
  802706:	89 74 24 04          	mov    %esi,0x4(%esp)
  80270a:	89 3c 24             	mov    %edi,(%esp)
  80270d:	e8 64 e4 ff ff       	call   800b76 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802712:	01 f3                	add    %esi,%ebx
  802714:	89 d8                	mov    %ebx,%eax
  802716:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802719:	72 c8                	jb     8026e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80271b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    

00802726 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802731:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802735:	75 07                	jne    80273e <devcons_read+0x18>
  802737:	eb 2a                	jmp    802763 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802739:	e8 e6 e4 ff ff       	call   800c24 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80273e:	66 90                	xchg   %ax,%ax
  802740:	e8 4f e4 ff ff       	call   800b94 <sys_cgetc>
  802745:	85 c0                	test   %eax,%eax
  802747:	74 f0                	je     802739 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802749:	85 c0                	test   %eax,%eax
  80274b:	78 16                	js     802763 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80274d:	83 f8 04             	cmp    $0x4,%eax
  802750:	74 0c                	je     80275e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802752:	8b 55 0c             	mov    0xc(%ebp),%edx
  802755:	88 02                	mov    %al,(%edx)
	return 1;
  802757:	b8 01 00 00 00       	mov    $0x1,%eax
  80275c:	eb 05                	jmp    802763 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80275e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802763:	c9                   	leave  
  802764:	c3                   	ret    

00802765 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
  802768:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802771:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802778:	00 
  802779:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80277c:	89 04 24             	mov    %eax,(%esp)
  80277f:	e8 f2 e3 ff ff       	call   800b76 <sys_cputs>
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <getchar>:

int
getchar(void)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80278c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802793:	00 
  802794:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a2:	e8 d3 ea ff ff       	call   80127a <read>
	if (r < 0)
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	78 0f                	js     8027ba <getchar+0x34>
		return r;
	if (r < 1)
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	7e 06                	jle    8027b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8027af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8027b3:	eb 05                	jmp    8027ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8027b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	89 04 24             	mov    %eax,(%esp)
  8027cf:	e8 12 e8 ff ff       	call   800fe6 <fd_lookup>
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	78 11                	js     8027e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027e1:	39 10                	cmp    %edx,(%eax)
  8027e3:	0f 94 c0             	sete   %al
  8027e6:	0f b6 c0             	movzbl %al,%eax
}
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <opencons>:

int
opencons(void)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
  8027ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f4:	89 04 24             	mov    %eax,(%esp)
  8027f7:	e8 9b e7 ff ff       	call   800f97 <fd_alloc>
		return r;
  8027fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027fe:	85 c0                	test   %eax,%eax
  802800:	78 40                	js     802842 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802802:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802809:	00 
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802811:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802818:	e8 26 e4 ff ff       	call   800c43 <sys_page_alloc>
		return r;
  80281d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80281f:	85 c0                	test   %eax,%eax
  802821:	78 1f                	js     802842 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802823:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802838:	89 04 24             	mov    %eax,(%esp)
  80283b:	e8 30 e7 ff ff       	call   800f70 <fd2num>
  802840:	89 c2                	mov    %eax,%edx
}
  802842:	89 d0                	mov    %edx,%eax
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	56                   	push   %esi
  80284a:	53                   	push   %ebx
  80284b:	83 ec 10             	sub    $0x10,%esp
  80284e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802851:	8b 45 0c             	mov    0xc(%ebp),%eax
  802854:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802857:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802859:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80285e:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802861:	89 04 24             	mov    %eax,(%esp)
  802864:	e8 f0 e5 ff ff       	call   800e59 <sys_ipc_recv>
  802869:	85 c0                	test   %eax,%eax
  80286b:	75 1e                	jne    80288b <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80286d:	85 db                	test   %ebx,%ebx
  80286f:	74 0a                	je     80287b <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802871:	a1 08 50 80 00       	mov    0x805008,%eax
  802876:	8b 40 74             	mov    0x74(%eax),%eax
  802879:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80287b:	85 f6                	test   %esi,%esi
  80287d:	74 22                	je     8028a1 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80287f:	a1 08 50 80 00       	mov    0x805008,%eax
  802884:	8b 40 78             	mov    0x78(%eax),%eax
  802887:	89 06                	mov    %eax,(%esi)
  802889:	eb 16                	jmp    8028a1 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80288b:	85 f6                	test   %esi,%esi
  80288d:	74 06                	je     802895 <ipc_recv+0x4f>
				*perm_store = 0;
  80288f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802895:	85 db                	test   %ebx,%ebx
  802897:	74 10                	je     8028a9 <ipc_recv+0x63>
				*from_env_store=0;
  802899:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80289f:	eb 08                	jmp    8028a9 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8028a1:	a1 08 50 80 00       	mov    0x805008,%eax
  8028a6:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8028a9:	83 c4 10             	add    $0x10,%esp
  8028ac:	5b                   	pop    %ebx
  8028ad:	5e                   	pop    %esi
  8028ae:	5d                   	pop    %ebp
  8028af:	c3                   	ret    

008028b0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028b0:	55                   	push   %ebp
  8028b1:	89 e5                	mov    %esp,%ebp
  8028b3:	57                   	push   %edi
  8028b4:	56                   	push   %esi
  8028b5:	53                   	push   %ebx
  8028b6:	83 ec 1c             	sub    $0x1c,%esp
  8028b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028bf:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8028c2:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8028c4:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8028c9:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8028cc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028d0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028db:	89 04 24             	mov    %eax,(%esp)
  8028de:	e8 53 e5 ff ff       	call   800e36 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8028e3:	eb 1c                	jmp    802901 <ipc_send+0x51>
	{
		sys_yield();
  8028e5:	e8 3a e3 ff ff       	call   800c24 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8028ea:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028ee:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	89 04 24             	mov    %eax,(%esp)
  8028fc:	e8 35 e5 ff ff       	call   800e36 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802901:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802904:	74 df                	je     8028e5 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802906:	83 c4 1c             	add    $0x1c,%esp
  802909:	5b                   	pop    %ebx
  80290a:	5e                   	pop    %esi
  80290b:	5f                   	pop    %edi
  80290c:	5d                   	pop    %ebp
  80290d:	c3                   	ret    

0080290e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80290e:	55                   	push   %ebp
  80290f:	89 e5                	mov    %esp,%ebp
  802911:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802914:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802919:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80291c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802922:	8b 52 50             	mov    0x50(%edx),%edx
  802925:	39 ca                	cmp    %ecx,%edx
  802927:	75 0d                	jne    802936 <ipc_find_env+0x28>
			return envs[i].env_id;
  802929:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80292c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802931:	8b 40 40             	mov    0x40(%eax),%eax
  802934:	eb 0e                	jmp    802944 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802936:	83 c0 01             	add    $0x1,%eax
  802939:	3d 00 04 00 00       	cmp    $0x400,%eax
  80293e:	75 d9                	jne    802919 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802940:	66 b8 00 00          	mov    $0x0,%ax
}
  802944:	5d                   	pop    %ebp
  802945:	c3                   	ret    

00802946 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80294c:	89 d0                	mov    %edx,%eax
  80294e:	c1 e8 16             	shr    $0x16,%eax
  802951:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802958:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80295d:	f6 c1 01             	test   $0x1,%cl
  802960:	74 1d                	je     80297f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802962:	c1 ea 0c             	shr    $0xc,%edx
  802965:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80296c:	f6 c2 01             	test   $0x1,%dl
  80296f:	74 0e                	je     80297f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802971:	c1 ea 0c             	shr    $0xc,%edx
  802974:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80297b:	ef 
  80297c:	0f b7 c0             	movzwl %ax,%eax
}
  80297f:	5d                   	pop    %ebp
  802980:	c3                   	ret    
  802981:	66 90                	xchg   %ax,%ax
  802983:	66 90                	xchg   %ax,%ax
  802985:	66 90                	xchg   %ax,%ax
  802987:	66 90                	xchg   %ax,%ax
  802989:	66 90                	xchg   %ax,%ax
  80298b:	66 90                	xchg   %ax,%ax
  80298d:	66 90                	xchg   %ax,%ax
  80298f:	90                   	nop

00802990 <__udivdi3>:
  802990:	55                   	push   %ebp
  802991:	57                   	push   %edi
  802992:	56                   	push   %esi
  802993:	83 ec 0c             	sub    $0xc,%esp
  802996:	8b 44 24 28          	mov    0x28(%esp),%eax
  80299a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80299e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8029a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8029ac:	89 ea                	mov    %ebp,%edx
  8029ae:	89 0c 24             	mov    %ecx,(%esp)
  8029b1:	75 2d                	jne    8029e0 <__udivdi3+0x50>
  8029b3:	39 e9                	cmp    %ebp,%ecx
  8029b5:	77 61                	ja     802a18 <__udivdi3+0x88>
  8029b7:	85 c9                	test   %ecx,%ecx
  8029b9:	89 ce                	mov    %ecx,%esi
  8029bb:	75 0b                	jne    8029c8 <__udivdi3+0x38>
  8029bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c2:	31 d2                	xor    %edx,%edx
  8029c4:	f7 f1                	div    %ecx
  8029c6:	89 c6                	mov    %eax,%esi
  8029c8:	31 d2                	xor    %edx,%edx
  8029ca:	89 e8                	mov    %ebp,%eax
  8029cc:	f7 f6                	div    %esi
  8029ce:	89 c5                	mov    %eax,%ebp
  8029d0:	89 f8                	mov    %edi,%eax
  8029d2:	f7 f6                	div    %esi
  8029d4:	89 ea                	mov    %ebp,%edx
  8029d6:	83 c4 0c             	add    $0xc,%esp
  8029d9:	5e                   	pop    %esi
  8029da:	5f                   	pop    %edi
  8029db:	5d                   	pop    %ebp
  8029dc:	c3                   	ret    
  8029dd:	8d 76 00             	lea    0x0(%esi),%esi
  8029e0:	39 e8                	cmp    %ebp,%eax
  8029e2:	77 24                	ja     802a08 <__udivdi3+0x78>
  8029e4:	0f bd e8             	bsr    %eax,%ebp
  8029e7:	83 f5 1f             	xor    $0x1f,%ebp
  8029ea:	75 3c                	jne    802a28 <__udivdi3+0x98>
  8029ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029f0:	39 34 24             	cmp    %esi,(%esp)
  8029f3:	0f 86 9f 00 00 00    	jbe    802a98 <__udivdi3+0x108>
  8029f9:	39 d0                	cmp    %edx,%eax
  8029fb:	0f 82 97 00 00 00    	jb     802a98 <__udivdi3+0x108>
  802a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a08:	31 d2                	xor    %edx,%edx
  802a0a:	31 c0                	xor    %eax,%eax
  802a0c:	83 c4 0c             	add    $0xc,%esp
  802a0f:	5e                   	pop    %esi
  802a10:	5f                   	pop    %edi
  802a11:	5d                   	pop    %ebp
  802a12:	c3                   	ret    
  802a13:	90                   	nop
  802a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a18:	89 f8                	mov    %edi,%eax
  802a1a:	f7 f1                	div    %ecx
  802a1c:	31 d2                	xor    %edx,%edx
  802a1e:	83 c4 0c             	add    $0xc,%esp
  802a21:	5e                   	pop    %esi
  802a22:	5f                   	pop    %edi
  802a23:	5d                   	pop    %ebp
  802a24:	c3                   	ret    
  802a25:	8d 76 00             	lea    0x0(%esi),%esi
  802a28:	89 e9                	mov    %ebp,%ecx
  802a2a:	8b 3c 24             	mov    (%esp),%edi
  802a2d:	d3 e0                	shl    %cl,%eax
  802a2f:	89 c6                	mov    %eax,%esi
  802a31:	b8 20 00 00 00       	mov    $0x20,%eax
  802a36:	29 e8                	sub    %ebp,%eax
  802a38:	89 c1                	mov    %eax,%ecx
  802a3a:	d3 ef                	shr    %cl,%edi
  802a3c:	89 e9                	mov    %ebp,%ecx
  802a3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a42:	8b 3c 24             	mov    (%esp),%edi
  802a45:	09 74 24 08          	or     %esi,0x8(%esp)
  802a49:	89 d6                	mov    %edx,%esi
  802a4b:	d3 e7                	shl    %cl,%edi
  802a4d:	89 c1                	mov    %eax,%ecx
  802a4f:	89 3c 24             	mov    %edi,(%esp)
  802a52:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a56:	d3 ee                	shr    %cl,%esi
  802a58:	89 e9                	mov    %ebp,%ecx
  802a5a:	d3 e2                	shl    %cl,%edx
  802a5c:	89 c1                	mov    %eax,%ecx
  802a5e:	d3 ef                	shr    %cl,%edi
  802a60:	09 d7                	or     %edx,%edi
  802a62:	89 f2                	mov    %esi,%edx
  802a64:	89 f8                	mov    %edi,%eax
  802a66:	f7 74 24 08          	divl   0x8(%esp)
  802a6a:	89 d6                	mov    %edx,%esi
  802a6c:	89 c7                	mov    %eax,%edi
  802a6e:	f7 24 24             	mull   (%esp)
  802a71:	39 d6                	cmp    %edx,%esi
  802a73:	89 14 24             	mov    %edx,(%esp)
  802a76:	72 30                	jb     802aa8 <__udivdi3+0x118>
  802a78:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a7c:	89 e9                	mov    %ebp,%ecx
  802a7e:	d3 e2                	shl    %cl,%edx
  802a80:	39 c2                	cmp    %eax,%edx
  802a82:	73 05                	jae    802a89 <__udivdi3+0xf9>
  802a84:	3b 34 24             	cmp    (%esp),%esi
  802a87:	74 1f                	je     802aa8 <__udivdi3+0x118>
  802a89:	89 f8                	mov    %edi,%eax
  802a8b:	31 d2                	xor    %edx,%edx
  802a8d:	e9 7a ff ff ff       	jmp    802a0c <__udivdi3+0x7c>
  802a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a98:	31 d2                	xor    %edx,%edx
  802a9a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a9f:	e9 68 ff ff ff       	jmp    802a0c <__udivdi3+0x7c>
  802aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802aa8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802aab:	31 d2                	xor    %edx,%edx
  802aad:	83 c4 0c             	add    $0xc,%esp
  802ab0:	5e                   	pop    %esi
  802ab1:	5f                   	pop    %edi
  802ab2:	5d                   	pop    %ebp
  802ab3:	c3                   	ret    
  802ab4:	66 90                	xchg   %ax,%ax
  802ab6:	66 90                	xchg   %ax,%ax
  802ab8:	66 90                	xchg   %ax,%ax
  802aba:	66 90                	xchg   %ax,%ax
  802abc:	66 90                	xchg   %ax,%ax
  802abe:	66 90                	xchg   %ax,%ax

00802ac0 <__umoddi3>:
  802ac0:	55                   	push   %ebp
  802ac1:	57                   	push   %edi
  802ac2:	56                   	push   %esi
  802ac3:	83 ec 14             	sub    $0x14,%esp
  802ac6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ace:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ad2:	89 c7                	mov    %eax,%edi
  802ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802adc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ae0:	89 34 24             	mov    %esi,(%esp)
  802ae3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	89 c2                	mov    %eax,%edx
  802aeb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aef:	75 17                	jne    802b08 <__umoddi3+0x48>
  802af1:	39 fe                	cmp    %edi,%esi
  802af3:	76 4b                	jbe    802b40 <__umoddi3+0x80>
  802af5:	89 c8                	mov    %ecx,%eax
  802af7:	89 fa                	mov    %edi,%edx
  802af9:	f7 f6                	div    %esi
  802afb:	89 d0                	mov    %edx,%eax
  802afd:	31 d2                	xor    %edx,%edx
  802aff:	83 c4 14             	add    $0x14,%esp
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    
  802b06:	66 90                	xchg   %ax,%ax
  802b08:	39 f8                	cmp    %edi,%eax
  802b0a:	77 54                	ja     802b60 <__umoddi3+0xa0>
  802b0c:	0f bd e8             	bsr    %eax,%ebp
  802b0f:	83 f5 1f             	xor    $0x1f,%ebp
  802b12:	75 5c                	jne    802b70 <__umoddi3+0xb0>
  802b14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b18:	39 3c 24             	cmp    %edi,(%esp)
  802b1b:	0f 87 e7 00 00 00    	ja     802c08 <__umoddi3+0x148>
  802b21:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b25:	29 f1                	sub    %esi,%ecx
  802b27:	19 c7                	sbb    %eax,%edi
  802b29:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b31:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b35:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b39:	83 c4 14             	add    $0x14,%esp
  802b3c:	5e                   	pop    %esi
  802b3d:	5f                   	pop    %edi
  802b3e:	5d                   	pop    %ebp
  802b3f:	c3                   	ret    
  802b40:	85 f6                	test   %esi,%esi
  802b42:	89 f5                	mov    %esi,%ebp
  802b44:	75 0b                	jne    802b51 <__umoddi3+0x91>
  802b46:	b8 01 00 00 00       	mov    $0x1,%eax
  802b4b:	31 d2                	xor    %edx,%edx
  802b4d:	f7 f6                	div    %esi
  802b4f:	89 c5                	mov    %eax,%ebp
  802b51:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b55:	31 d2                	xor    %edx,%edx
  802b57:	f7 f5                	div    %ebp
  802b59:	89 c8                	mov    %ecx,%eax
  802b5b:	f7 f5                	div    %ebp
  802b5d:	eb 9c                	jmp    802afb <__umoddi3+0x3b>
  802b5f:	90                   	nop
  802b60:	89 c8                	mov    %ecx,%eax
  802b62:	89 fa                	mov    %edi,%edx
  802b64:	83 c4 14             	add    $0x14,%esp
  802b67:	5e                   	pop    %esi
  802b68:	5f                   	pop    %edi
  802b69:	5d                   	pop    %ebp
  802b6a:	c3                   	ret    
  802b6b:	90                   	nop
  802b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b70:	8b 04 24             	mov    (%esp),%eax
  802b73:	be 20 00 00 00       	mov    $0x20,%esi
  802b78:	89 e9                	mov    %ebp,%ecx
  802b7a:	29 ee                	sub    %ebp,%esi
  802b7c:	d3 e2                	shl    %cl,%edx
  802b7e:	89 f1                	mov    %esi,%ecx
  802b80:	d3 e8                	shr    %cl,%eax
  802b82:	89 e9                	mov    %ebp,%ecx
  802b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b88:	8b 04 24             	mov    (%esp),%eax
  802b8b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b8f:	89 fa                	mov    %edi,%edx
  802b91:	d3 e0                	shl    %cl,%eax
  802b93:	89 f1                	mov    %esi,%ecx
  802b95:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b99:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b9d:	d3 ea                	shr    %cl,%edx
  802b9f:	89 e9                	mov    %ebp,%ecx
  802ba1:	d3 e7                	shl    %cl,%edi
  802ba3:	89 f1                	mov    %esi,%ecx
  802ba5:	d3 e8                	shr    %cl,%eax
  802ba7:	89 e9                	mov    %ebp,%ecx
  802ba9:	09 f8                	or     %edi,%eax
  802bab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802baf:	f7 74 24 04          	divl   0x4(%esp)
  802bb3:	d3 e7                	shl    %cl,%edi
  802bb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bb9:	89 d7                	mov    %edx,%edi
  802bbb:	f7 64 24 08          	mull   0x8(%esp)
  802bbf:	39 d7                	cmp    %edx,%edi
  802bc1:	89 c1                	mov    %eax,%ecx
  802bc3:	89 14 24             	mov    %edx,(%esp)
  802bc6:	72 2c                	jb     802bf4 <__umoddi3+0x134>
  802bc8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802bcc:	72 22                	jb     802bf0 <__umoddi3+0x130>
  802bce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802bd2:	29 c8                	sub    %ecx,%eax
  802bd4:	19 d7                	sbb    %edx,%edi
  802bd6:	89 e9                	mov    %ebp,%ecx
  802bd8:	89 fa                	mov    %edi,%edx
  802bda:	d3 e8                	shr    %cl,%eax
  802bdc:	89 f1                	mov    %esi,%ecx
  802bde:	d3 e2                	shl    %cl,%edx
  802be0:	89 e9                	mov    %ebp,%ecx
  802be2:	d3 ef                	shr    %cl,%edi
  802be4:	09 d0                	or     %edx,%eax
  802be6:	89 fa                	mov    %edi,%edx
  802be8:	83 c4 14             	add    $0x14,%esp
  802beb:	5e                   	pop    %esi
  802bec:	5f                   	pop    %edi
  802bed:	5d                   	pop    %ebp
  802bee:	c3                   	ret    
  802bef:	90                   	nop
  802bf0:	39 d7                	cmp    %edx,%edi
  802bf2:	75 da                	jne    802bce <__umoddi3+0x10e>
  802bf4:	8b 14 24             	mov    (%esp),%edx
  802bf7:	89 c1                	mov    %eax,%ecx
  802bf9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802bfd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c01:	eb cb                	jmp    802bce <__umoddi3+0x10e>
  802c03:	90                   	nop
  802c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c08:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c0c:	0f 82 0f ff ff ff    	jb     802b21 <__umoddi3+0x61>
  802c12:	e9 1a ff ff ff       	jmp    802b31 <__umoddi3+0x71>
