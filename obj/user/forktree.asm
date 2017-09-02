
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 c2 00 00 00       	call   8000f3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 c3 0b 00 00       	call   800c05 <sys_getenvid>
  800042:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 40 2a 80 00 	movl   $0x802a40,(%esp)
  800051:	e8 ab 01 00 00       	call   800201 <cprintf>

	forkchild(cur, '0');
  800056:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80005d:	00 
  80005e:	89 1c 24             	mov    %ebx,(%esp)
  800061:	e8 16 00 00 00       	call   80007c <forkchild>
	forkchild(cur, '1');
  800066:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  80006d:	00 
  80006e:	89 1c 24             	mov    %ebx,(%esp)
  800071:	e8 06 00 00 00       	call   80007c <forkchild>
}
  800076:	83 c4 14             	add    $0x14,%esp
  800079:	5b                   	pop    %ebx
  80007a:	5d                   	pop    %ebp
  80007b:	c3                   	ret    

0080007c <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  80007c:	55                   	push   %ebp
  80007d:	89 e5                	mov    %esp,%ebp
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	83 ec 30             	sub    $0x30,%esp
  800084:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800087:	8b 75 0c             	mov    0xc(%ebp),%esi
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  80008a:	89 1c 24             	mov    %ebx,(%esp)
  80008d:	e8 5e 07 00 00       	call   8007f0 <strlen>
  800092:	83 f8 02             	cmp    $0x2,%eax
  800095:	7f 41                	jg     8000d8 <forkchild+0x5c>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800097:	89 f0                	mov    %esi,%eax
  800099:	0f be f0             	movsbl %al,%esi
  80009c:	89 74 24 10          	mov    %esi,0x10(%esp)
  8000a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000a4:	c7 44 24 08 51 2a 80 	movl   $0x802a51,0x8(%esp)
  8000ab:	00 
  8000ac:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000b3:	00 
  8000b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000b7:	89 04 24             	mov    %eax,(%esp)
  8000ba:	e8 fb 06 00 00       	call   8007ba <snprintf>
	if (fork() == 0) {
  8000bf:	e8 b2 0f 00 00       	call   801076 <fork>
  8000c4:	85 c0                	test   %eax,%eax
  8000c6:	75 10                	jne    8000d8 <forkchild+0x5c>
		forktree(nxt);
  8000c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000cb:	89 04 24             	mov    %eax,(%esp)
  8000ce:	e8 60 ff ff ff       	call   800033 <forktree>
		exit();
  8000d3:	e8 6d 00 00 00       	call   800145 <exit>
	}
}
  8000d8:	83 c4 30             	add    $0x30,%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <umain>:
	forkchild(cur, '1');
}

void
umain(int argc, char **argv)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	83 ec 18             	sub    $0x18,%esp
	forktree("");
  8000e5:	c7 04 24 50 2a 80 00 	movl   $0x802a50,(%esp)
  8000ec:	e8 42 ff ff ff       	call   800033 <forktree>
}
  8000f1:	c9                   	leave  
  8000f2:	c3                   	ret    

008000f3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 10             	sub    $0x10,%esp
  8000fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800101:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  800108:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  80010b:	e8 f5 0a 00 00       	call   800c05 <sys_getenvid>
  800110:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800115:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800118:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011d:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800122:	85 db                	test   %ebx,%ebx
  800124:	7e 07                	jle    80012d <libmain+0x3a>
		binaryname = argv[0];
  800126:	8b 06                	mov    (%esi),%eax
  800128:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80012d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800131:	89 1c 24             	mov    %ebx,(%esp)
  800134:	e8 a6 ff ff ff       	call   8000df <umain>

	// exit gracefully
	exit();
  800139:	e8 07 00 00 00       	call   800145 <exit>
}
  80013e:	83 c4 10             	add    $0x10,%esp
  800141:	5b                   	pop    %ebx
  800142:	5e                   	pop    %esi
  800143:	5d                   	pop    %ebp
  800144:	c3                   	ret    

00800145 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80014b:	e8 5a 13 00 00       	call   8014aa <close_all>
	sys_env_destroy(0);
  800150:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800157:	e8 57 0a 00 00       	call   800bb3 <sys_env_destroy>
}
  80015c:	c9                   	leave  
  80015d:	c3                   	ret    

0080015e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	53                   	push   %ebx
  800162:	83 ec 14             	sub    $0x14,%esp
  800165:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800168:	8b 13                	mov    (%ebx),%edx
  80016a:	8d 42 01             	lea    0x1(%edx),%eax
  80016d:	89 03                	mov    %eax,(%ebx)
  80016f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800172:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800176:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017b:	75 19                	jne    800196 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80017d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800184:	00 
  800185:	8d 43 08             	lea    0x8(%ebx),%eax
  800188:	89 04 24             	mov    %eax,(%esp)
  80018b:	e8 e6 09 00 00       	call   800b76 <sys_cputs>
		b->idx = 0;
  800190:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800196:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80019a:	83 c4 14             	add    $0x14,%esp
  80019d:	5b                   	pop    %ebx
  80019e:	5d                   	pop    %ebp
  80019f:	c3                   	ret    

008001a0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b0:	00 00 00 
	b.cnt = 0;
  8001b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d5:	c7 04 24 5e 01 80 00 	movl   $0x80015e,(%esp)
  8001dc:	e8 ad 01 00 00       	call   80038e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001eb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f1:	89 04 24             	mov    %eax,(%esp)
  8001f4:	e8 7d 09 00 00       	call   800b76 <sys_cputs>

	return b.cnt;
}
  8001f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    

00800201 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800207:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80020a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020e:	8b 45 08             	mov    0x8(%ebp),%eax
  800211:	89 04 24             	mov    %eax,(%esp)
  800214:	e8 87 ff ff ff       	call   8001a0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800219:	c9                   	leave  
  80021a:	c3                   	ret    
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
  80028f:	e8 1c 25 00 00       	call   8027b0 <__udivdi3>
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
  8002ef:	e8 ec 25 00 00       	call   8028e0 <__umoddi3>
  8002f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f8:	0f be 80 60 2a 80 00 	movsbl 0x802a60(%eax),%eax
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
  800413:	ff 24 8d a0 2b 80 00 	jmp    *0x802ba0(,%ecx,4)
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
  8004b0:	8b 14 85 00 2d 80 00 	mov    0x802d00(,%eax,4),%edx
  8004b7:	85 d2                	test   %edx,%edx
  8004b9:	75 20                	jne    8004db <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004bf:	c7 44 24 08 78 2a 80 	movl   $0x802a78,0x8(%esp)
  8004c6:	00 
  8004c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	89 04 24             	mov    %eax,(%esp)
  8004d1:	e8 90 fe ff ff       	call   800366 <printfmt>
  8004d6:	e9 d8 fe ff ff       	jmp    8003b3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004df:	c7 44 24 08 c5 2f 80 	movl   $0x802fc5,0x8(%esp)
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
  800511:	b8 71 2a 80 00       	mov    $0x802a71,%eax
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
  800be1:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800be8:	00 
  800be9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bf0:	00 
  800bf1:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800bf8:	e8 89 19 00 00       	call   802586 <_panic>

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
  800c73:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800c7a:	00 
  800c7b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c82:	00 
  800c83:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800c8a:	e8 f7 18 00 00       	call   802586 <_panic>

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
  800cc6:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800ccd:	00 
  800cce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd5:	00 
  800cd6:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800cdd:	e8 a4 18 00 00       	call   802586 <_panic>

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
  800d19:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800d20:	00 
  800d21:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d28:	00 
  800d29:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800d30:	e8 51 18 00 00       	call   802586 <_panic>

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
  800d6c:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800d73:	00 
  800d74:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d7b:	00 
  800d7c:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800d83:	e8 fe 17 00 00       	call   802586 <_panic>

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
  800dbf:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800dc6:	00 
  800dc7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dce:	00 
  800dcf:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800dd6:	e8 ab 17 00 00       	call   802586 <_panic>
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
  800e12:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800e19:	00 
  800e1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e21:	00 
  800e22:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800e29:	e8 58 17 00 00       	call   802586 <_panic>
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
  800e87:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800e8e:	00 
  800e8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e96:	00 
  800e97:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800e9e:	e8 e3 16 00 00       	call   802586 <_panic>

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
  800ef9:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800f00:	00 
  800f01:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f08:	00 
  800f09:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800f10:	e8 71 16 00 00       	call   802586 <_panic>

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
  800f4c:	c7 44 24 08 5f 2d 80 	movl   $0x802d5f,0x8(%esp)
  800f53:	00 
  800f54:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f5b:	00 
  800f5c:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  800f63:	e8 1e 16 00 00       	call   802586 <_panic>

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

00800f70 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	53                   	push   %ebx
  800f74:	83 ec 24             	sub    $0x24,%esp
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  800f7a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  800f7c:	89 d3                	mov    %edx,%ebx
  800f7e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800f84:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f88:	74 1a                	je     800fa4 <pgfault+0x34>
  800f8a:	c1 ea 0c             	shr    $0xc,%edx
  800f8d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800f94:	a8 01                	test   $0x1,%al
  800f96:	74 0c                	je     800fa4 <pgfault+0x34>
  800f98:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800f9f:	f6 c4 08             	test   $0x8,%ah
  800fa2:	75 1c                	jne    800fc0 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  800fa4:	c7 44 24 08 8c 2d 80 	movl   $0x802d8c,0x8(%esp)
  800fab:	00 
  800fac:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  800fb3:	00 
  800fb4:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  800fbb:	e8 c6 15 00 00       	call   802586 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  800fc0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fc7:	00 
  800fc8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800fcf:	00 
  800fd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fd7:	e8 67 fc ff ff       	call   800c43 <sys_page_alloc>
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	79 1c                	jns    800ffc <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  800fe0:	c7 44 24 08 d0 2d 80 	movl   $0x802dd0,0x8(%esp)
  800fe7:	00 
  800fe8:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800fef:	00 
  800ff0:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  800ff7:	e8 8a 15 00 00       	call   802586 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  800ffc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801003:	00 
  801004:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801008:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80100f:	e8 18 fa ff ff       	call   800a2c <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801014:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80101b:	00 
  80101c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801020:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801027:	00 
  801028:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80102f:	00 
  801030:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801037:	e8 5b fc ff ff       	call   800c97 <sys_page_map>
  80103c:	85 c0                	test   %eax,%eax
  80103e:	74 1c                	je     80105c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  801040:	c7 44 24 08 e6 2e 80 	movl   $0x802ee6,0x8(%esp)
  801047:	00 
  801048:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80104f:	00 
  801050:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  801057:	e8 2a 15 00 00       	call   802586 <_panic>
    sys_page_unmap(0,PFTEMP);
  80105c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801063:	00 
  801064:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80106b:	e8 7a fc ff ff       	call   800cea <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801070:	83 c4 24             	add    $0x24,%esp
  801073:	5b                   	pop    %ebx
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
  80107c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80107f:	c7 04 24 70 0f 80 00 	movl   $0x800f70,(%esp)
  801086:	e8 51 15 00 00       	call   8025dc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80108b:	b8 07 00 00 00       	mov    $0x7,%eax
  801090:	cd 30                	int    $0x30
  801092:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801095:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801097:	bb 00 00 00 00       	mov    $0x0,%ebx
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 21                	jne    8010c1 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8010a0:	e8 60 fb ff ff       	call   800c05 <sys_getenvid>
  8010a5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010aa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010b2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8010b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010bc:	e9 de 01 00 00       	jmp    80129f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  8010c1:	89 d8                	mov    %ebx,%eax
  8010c3:	c1 e8 16             	shr    $0x16,%eax
  8010c6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010cd:	a8 01                	test   $0x1,%al
  8010cf:	0f 84 58 01 00 00    	je     80122d <fork+0x1b7>
  8010d5:	89 de                	mov    %ebx,%esi
  8010d7:	c1 ee 0c             	shr    $0xc,%esi
  8010da:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010e1:	83 e0 05             	and    $0x5,%eax
  8010e4:	83 f8 05             	cmp    $0x5,%eax
  8010e7:	0f 85 40 01 00 00    	jne    80122d <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  8010ed:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010f4:	f6 c4 04             	test   $0x4,%ah
  8010f7:	74 4f                	je     801148 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  8010f9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801100:	c1 e6 0c             	shl    $0xc,%esi
  801103:	25 07 0e 00 00       	and    $0xe07,%eax
  801108:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801110:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801114:	89 74 24 04          	mov    %esi,0x4(%esp)
  801118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80111f:	e8 73 fb ff ff       	call   800c97 <sys_page_map>
  801124:	85 c0                	test   %eax,%eax
  801126:	0f 89 01 01 00 00    	jns    80122d <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  80112c:	c7 44 24 08 f0 2d 80 	movl   $0x802df0,0x8(%esp)
  801133:	00 
  801134:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  80113b:	00 
  80113c:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  801143:	e8 3e 14 00 00       	call   802586 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  801148:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80114f:	a8 02                	test   $0x2,%al
  801151:	75 10                	jne    801163 <fork+0xed>
  801153:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80115a:	f6 c4 08             	test   $0x8,%ah
  80115d:	0f 84 87 00 00 00    	je     8011ea <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801163:	c1 e6 0c             	shl    $0xc,%esi
  801166:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80116d:	00 
  80116e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801172:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801176:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801181:	e8 11 fb ff ff       	call   800c97 <sys_page_map>
  801186:	85 c0                	test   %eax,%eax
  801188:	79 1c                	jns    8011a6 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80118a:	c7 44 24 08 28 2e 80 	movl   $0x802e28,0x8(%esp)
  801191:	00 
  801192:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801199:	00 
  80119a:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  8011a1:	e8 e0 13 00 00       	call   802586 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  8011a6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8011ad:	00 
  8011ae:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011b2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011b9:	00 
  8011ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011c5:	e8 cd fa ff ff       	call   800c97 <sys_page_map>
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	79 5f                	jns    80122d <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  8011ce:	c7 44 24 08 60 2e 80 	movl   $0x802e60,0x8(%esp)
  8011d5:	00 
  8011d6:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8011dd:	00 
  8011de:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  8011e5:	e8 9c 13 00 00       	call   802586 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  8011ea:	c1 e6 0c             	shl    $0xc,%esi
  8011ed:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8011f4:	00 
  8011f5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011f9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  801201:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801208:	e8 8a fa ff ff       	call   800c97 <sys_page_map>
  80120d:	85 c0                	test   %eax,%eax
  80120f:	74 1c                	je     80122d <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801211:	c7 44 24 08 88 2e 80 	movl   $0x802e88,0x8(%esp)
  801218:	00 
  801219:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801220:	00 
  801221:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  801228:	e8 59 13 00 00       	call   802586 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  80122d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801233:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801239:	0f 85 82 fe ff ff    	jne    8010c1 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  80123f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801246:	00 
  801247:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80124e:	ee 
  80124f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801252:	89 04 24             	mov    %eax,(%esp)
  801255:	e8 e9 f9 ff ff       	call   800c43 <sys_page_alloc>
  80125a:	85 c0                	test   %eax,%eax
  80125c:	79 1c                	jns    80127a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  80125e:	c7 44 24 08 bc 2e 80 	movl   $0x802ebc,0x8(%esp)
  801265:	00 
  801266:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  80126d:	00 
  80126e:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  801275:	e8 0c 13 00 00       	call   802586 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  80127a:	c7 44 24 04 4d 26 80 	movl   $0x80264d,0x4(%esp)
  801281:	00 
  801282:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801285:	89 3c 24             	mov    %edi,(%esp)
  801288:	e8 56 fb ff ff       	call   800de3 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80128d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801294:	00 
  801295:	89 3c 24             	mov    %edi,(%esp)
  801298:	e8 a0 fa ff ff       	call   800d3d <sys_env_set_status>
		return child;
  80129d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80129f:	83 c4 2c             	add    $0x2c,%esp
  8012a2:	5b                   	pop    %ebx
  8012a3:	5e                   	pop    %esi
  8012a4:	5f                   	pop    %edi
  8012a5:	5d                   	pop    %ebp
  8012a6:	c3                   	ret    

008012a7 <sfork>:

// Challenge!
int
sfork(void)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8012ad:	c7 44 24 08 04 2f 80 	movl   $0x802f04,0x8(%esp)
  8012b4:	00 
  8012b5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8012bc:	00 
  8012bd:	c7 04 24 db 2e 80 00 	movl   $0x802edb,(%esp)
  8012c4:	e8 bd 12 00 00       	call   802586 <_panic>
  8012c9:	66 90                	xchg   %ax,%ax
  8012cb:	66 90                	xchg   %ax,%ax
  8012cd:	66 90                	xchg   %ax,%ax
  8012cf:	90                   	nop

008012d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012db:	c1 e8 0c             	shr    $0xc,%eax
}
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8012eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012f5:	5d                   	pop    %ebp
  8012f6:	c3                   	ret    

008012f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801302:	89 c2                	mov    %eax,%edx
  801304:	c1 ea 16             	shr    $0x16,%edx
  801307:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80130e:	f6 c2 01             	test   $0x1,%dl
  801311:	74 11                	je     801324 <fd_alloc+0x2d>
  801313:	89 c2                	mov    %eax,%edx
  801315:	c1 ea 0c             	shr    $0xc,%edx
  801318:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80131f:	f6 c2 01             	test   $0x1,%dl
  801322:	75 09                	jne    80132d <fd_alloc+0x36>
			*fd_store = fd;
  801324:	89 01                	mov    %eax,(%ecx)
			return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
  80132b:	eb 17                	jmp    801344 <fd_alloc+0x4d>
  80132d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801332:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801337:	75 c9                	jne    801302 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801339:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80133f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    

00801346 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80134c:	83 f8 1f             	cmp    $0x1f,%eax
  80134f:	77 36                	ja     801387 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801351:	c1 e0 0c             	shl    $0xc,%eax
  801354:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801359:	89 c2                	mov    %eax,%edx
  80135b:	c1 ea 16             	shr    $0x16,%edx
  80135e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801365:	f6 c2 01             	test   $0x1,%dl
  801368:	74 24                	je     80138e <fd_lookup+0x48>
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	c1 ea 0c             	shr    $0xc,%edx
  80136f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801376:	f6 c2 01             	test   $0x1,%dl
  801379:	74 1a                	je     801395 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80137b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137e:	89 02                	mov    %eax,(%edx)
	return 0;
  801380:	b8 00 00 00 00       	mov    $0x0,%eax
  801385:	eb 13                	jmp    80139a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801387:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138c:	eb 0c                	jmp    80139a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80138e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801393:	eb 05                	jmp    80139a <fd_lookup+0x54>
  801395:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    

0080139c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	83 ec 18             	sub    $0x18,%esp
  8013a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8013a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013aa:	eb 13                	jmp    8013bf <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8013ac:	39 08                	cmp    %ecx,(%eax)
  8013ae:	75 0c                	jne    8013bc <dev_lookup+0x20>
			*dev = devtab[i];
  8013b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ba:	eb 38                	jmp    8013f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8013bc:	83 c2 01             	add    $0x1,%edx
  8013bf:	8b 04 95 98 2f 80 00 	mov    0x802f98(,%edx,4),%eax
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	75 e2                	jne    8013ac <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8013cf:	8b 40 48             	mov    0x48(%eax),%eax
  8013d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013da:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  8013e1:	e8 1b ee ff ff       	call   800201 <cprintf>
	*dev = 0;
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013f4:	c9                   	leave  
  8013f5:	c3                   	ret    

008013f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8013f6:	55                   	push   %ebp
  8013f7:	89 e5                	mov    %esp,%ebp
  8013f9:	56                   	push   %esi
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 20             	sub    $0x20,%esp
  8013fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801401:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801404:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801407:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80140b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801411:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801414:	89 04 24             	mov    %eax,(%esp)
  801417:	e8 2a ff ff ff       	call   801346 <fd_lookup>
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 05                	js     801425 <fd_close+0x2f>
	    || fd != fd2)
  801420:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801423:	74 0c                	je     801431 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801425:	84 db                	test   %bl,%bl
  801427:	ba 00 00 00 00       	mov    $0x0,%edx
  80142c:	0f 44 c2             	cmove  %edx,%eax
  80142f:	eb 3f                	jmp    801470 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801431:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801434:	89 44 24 04          	mov    %eax,0x4(%esp)
  801438:	8b 06                	mov    (%esi),%eax
  80143a:	89 04 24             	mov    %eax,(%esp)
  80143d:	e8 5a ff ff ff       	call   80139c <dev_lookup>
  801442:	89 c3                	mov    %eax,%ebx
  801444:	85 c0                	test   %eax,%eax
  801446:	78 16                	js     80145e <fd_close+0x68>
		if (dev->dev_close)
  801448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80144e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801453:	85 c0                	test   %eax,%eax
  801455:	74 07                	je     80145e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801457:	89 34 24             	mov    %esi,(%esp)
  80145a:	ff d0                	call   *%eax
  80145c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80145e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801462:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801469:	e8 7c f8 ff ff       	call   800cea <sys_page_unmap>
	return r;
  80146e:	89 d8                	mov    %ebx,%eax
}
  801470:	83 c4 20             	add    $0x20,%esp
  801473:	5b                   	pop    %ebx
  801474:	5e                   	pop    %esi
  801475:	5d                   	pop    %ebp
  801476:	c3                   	ret    

00801477 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80147d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801480:	89 44 24 04          	mov    %eax,0x4(%esp)
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	89 04 24             	mov    %eax,(%esp)
  80148a:	e8 b7 fe ff ff       	call   801346 <fd_lookup>
  80148f:	89 c2                	mov    %eax,%edx
  801491:	85 d2                	test   %edx,%edx
  801493:	78 13                	js     8014a8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801495:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80149c:	00 
  80149d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a0:	89 04 24             	mov    %eax,(%esp)
  8014a3:	e8 4e ff ff ff       	call   8013f6 <fd_close>
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <close_all>:

void
close_all(void)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	53                   	push   %ebx
  8014ae:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014b6:	89 1c 24             	mov    %ebx,(%esp)
  8014b9:	e8 b9 ff ff ff       	call   801477 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8014be:	83 c3 01             	add    $0x1,%ebx
  8014c1:	83 fb 20             	cmp    $0x20,%ebx
  8014c4:	75 f0                	jne    8014b6 <close_all+0xc>
		close(i);
}
  8014c6:	83 c4 14             	add    $0x14,%esp
  8014c9:	5b                   	pop    %ebx
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	57                   	push   %edi
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
  8014d2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	89 04 24             	mov    %eax,(%esp)
  8014e2:	e8 5f fe ff ff       	call   801346 <fd_lookup>
  8014e7:	89 c2                	mov    %eax,%edx
  8014e9:	85 d2                	test   %edx,%edx
  8014eb:	0f 88 e1 00 00 00    	js     8015d2 <dup+0x106>
		return r;
	close(newfdnum);
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 04 24             	mov    %eax,(%esp)
  8014f7:	e8 7b ff ff ff       	call   801477 <close>

	newfd = INDEX2FD(newfdnum);
  8014fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014ff:	c1 e3 0c             	shl    $0xc,%ebx
  801502:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80150b:	89 04 24             	mov    %eax,(%esp)
  80150e:	e8 cd fd ff ff       	call   8012e0 <fd2data>
  801513:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801515:	89 1c 24             	mov    %ebx,(%esp)
  801518:	e8 c3 fd ff ff       	call   8012e0 <fd2data>
  80151d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80151f:	89 f0                	mov    %esi,%eax
  801521:	c1 e8 16             	shr    $0x16,%eax
  801524:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80152b:	a8 01                	test   $0x1,%al
  80152d:	74 43                	je     801572 <dup+0xa6>
  80152f:	89 f0                	mov    %esi,%eax
  801531:	c1 e8 0c             	shr    $0xc,%eax
  801534:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80153b:	f6 c2 01             	test   $0x1,%dl
  80153e:	74 32                	je     801572 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801540:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801547:	25 07 0e 00 00       	and    $0xe07,%eax
  80154c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801550:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801554:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80155b:	00 
  80155c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801560:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801567:	e8 2b f7 ff ff       	call   800c97 <sys_page_map>
  80156c:	89 c6                	mov    %eax,%esi
  80156e:	85 c0                	test   %eax,%eax
  801570:	78 3e                	js     8015b0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801575:	89 c2                	mov    %eax,%edx
  801577:	c1 ea 0c             	shr    $0xc,%edx
  80157a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801581:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801587:	89 54 24 10          	mov    %edx,0x10(%esp)
  80158b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80158f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801596:	00 
  801597:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a2:	e8 f0 f6 ff ff       	call   800c97 <sys_page_map>
  8015a7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015ac:	85 f6                	test   %esi,%esi
  8015ae:	79 22                	jns    8015d2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015bb:	e8 2a f7 ff ff       	call   800cea <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015cb:	e8 1a f7 ff ff       	call   800cea <sys_page_unmap>
	return r;
  8015d0:	89 f0                	mov    %esi,%eax
}
  8015d2:	83 c4 3c             	add    $0x3c,%esp
  8015d5:	5b                   	pop    %ebx
  8015d6:	5e                   	pop    %esi
  8015d7:	5f                   	pop    %edi
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	53                   	push   %ebx
  8015de:	83 ec 24             	sub    $0x24,%esp
  8015e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015eb:	89 1c 24             	mov    %ebx,(%esp)
  8015ee:	e8 53 fd ff ff       	call   801346 <fd_lookup>
  8015f3:	89 c2                	mov    %eax,%edx
  8015f5:	85 d2                	test   %edx,%edx
  8015f7:	78 6d                	js     801666 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801603:	8b 00                	mov    (%eax),%eax
  801605:	89 04 24             	mov    %eax,(%esp)
  801608:	e8 8f fd ff ff       	call   80139c <dev_lookup>
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 55                	js     801666 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801614:	8b 50 08             	mov    0x8(%eax),%edx
  801617:	83 e2 03             	and    $0x3,%edx
  80161a:	83 fa 01             	cmp    $0x1,%edx
  80161d:	75 23                	jne    801642 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80161f:	a1 08 50 80 00       	mov    0x805008,%eax
  801624:	8b 40 48             	mov    0x48(%eax),%eax
  801627:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80162b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162f:	c7 04 24 5d 2f 80 00 	movl   $0x802f5d,(%esp)
  801636:	e8 c6 eb ff ff       	call   800201 <cprintf>
		return -E_INVAL;
  80163b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801640:	eb 24                	jmp    801666 <read+0x8c>
	}
	if (!dev->dev_read)
  801642:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801645:	8b 52 08             	mov    0x8(%edx),%edx
  801648:	85 d2                	test   %edx,%edx
  80164a:	74 15                	je     801661 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80164c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80164f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801653:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801656:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80165a:	89 04 24             	mov    %eax,(%esp)
  80165d:	ff d2                	call   *%edx
  80165f:	eb 05                	jmp    801666 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801661:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801666:	83 c4 24             	add    $0x24,%esp
  801669:	5b                   	pop    %ebx
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	57                   	push   %edi
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
  801672:	83 ec 1c             	sub    $0x1c,%esp
  801675:	8b 7d 08             	mov    0x8(%ebp),%edi
  801678:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80167b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801680:	eb 23                	jmp    8016a5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801682:	89 f0                	mov    %esi,%eax
  801684:	29 d8                	sub    %ebx,%eax
  801686:	89 44 24 08          	mov    %eax,0x8(%esp)
  80168a:	89 d8                	mov    %ebx,%eax
  80168c:	03 45 0c             	add    0xc(%ebp),%eax
  80168f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801693:	89 3c 24             	mov    %edi,(%esp)
  801696:	e8 3f ff ff ff       	call   8015da <read>
		if (m < 0)
  80169b:	85 c0                	test   %eax,%eax
  80169d:	78 10                	js     8016af <readn+0x43>
			return m;
		if (m == 0)
  80169f:	85 c0                	test   %eax,%eax
  8016a1:	74 0a                	je     8016ad <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016a3:	01 c3                	add    %eax,%ebx
  8016a5:	39 f3                	cmp    %esi,%ebx
  8016a7:	72 d9                	jb     801682 <readn+0x16>
  8016a9:	89 d8                	mov    %ebx,%eax
  8016ab:	eb 02                	jmp    8016af <readn+0x43>
  8016ad:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016af:	83 c4 1c             	add    $0x1c,%esp
  8016b2:	5b                   	pop    %ebx
  8016b3:	5e                   	pop    %esi
  8016b4:	5f                   	pop    %edi
  8016b5:	5d                   	pop    %ebp
  8016b6:	c3                   	ret    

008016b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	53                   	push   %ebx
  8016bb:	83 ec 24             	sub    $0x24,%esp
  8016be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c8:	89 1c 24             	mov    %ebx,(%esp)
  8016cb:	e8 76 fc ff ff       	call   801346 <fd_lookup>
  8016d0:	89 c2                	mov    %eax,%edx
  8016d2:	85 d2                	test   %edx,%edx
  8016d4:	78 68                	js     80173e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e0:	8b 00                	mov    (%eax),%eax
  8016e2:	89 04 24             	mov    %eax,(%esp)
  8016e5:	e8 b2 fc ff ff       	call   80139c <dev_lookup>
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	78 50                	js     80173e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016f5:	75 23                	jne    80171a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016f7:	a1 08 50 80 00       	mov    0x805008,%eax
  8016fc:	8b 40 48             	mov    0x48(%eax),%eax
  8016ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801703:	89 44 24 04          	mov    %eax,0x4(%esp)
  801707:	c7 04 24 79 2f 80 00 	movl   $0x802f79,(%esp)
  80170e:	e8 ee ea ff ff       	call   800201 <cprintf>
		return -E_INVAL;
  801713:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801718:	eb 24                	jmp    80173e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80171a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80171d:	8b 52 0c             	mov    0xc(%edx),%edx
  801720:	85 d2                	test   %edx,%edx
  801722:	74 15                	je     801739 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801724:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801727:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80172b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80172e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801732:	89 04 24             	mov    %eax,(%esp)
  801735:	ff d2                	call   *%edx
  801737:	eb 05                	jmp    80173e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801739:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80173e:	83 c4 24             	add    $0x24,%esp
  801741:	5b                   	pop    %ebx
  801742:	5d                   	pop    %ebp
  801743:	c3                   	ret    

00801744 <seek>:

int
seek(int fdnum, off_t offset)
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80174a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80174d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801751:	8b 45 08             	mov    0x8(%ebp),%eax
  801754:	89 04 24             	mov    %eax,(%esp)
  801757:	e8 ea fb ff ff       	call   801346 <fd_lookup>
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 0e                	js     80176e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801760:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801763:	8b 55 0c             	mov    0xc(%ebp),%edx
  801766:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801769:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	53                   	push   %ebx
  801774:	83 ec 24             	sub    $0x24,%esp
  801777:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801781:	89 1c 24             	mov    %ebx,(%esp)
  801784:	e8 bd fb ff ff       	call   801346 <fd_lookup>
  801789:	89 c2                	mov    %eax,%edx
  80178b:	85 d2                	test   %edx,%edx
  80178d:	78 61                	js     8017f0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801792:	89 44 24 04          	mov    %eax,0x4(%esp)
  801796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801799:	8b 00                	mov    (%eax),%eax
  80179b:	89 04 24             	mov    %eax,(%esp)
  80179e:	e8 f9 fb ff ff       	call   80139c <dev_lookup>
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 49                	js     8017f0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ae:	75 23                	jne    8017d3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017b0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017b5:	8b 40 48             	mov    0x48(%eax),%eax
  8017b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c0:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  8017c7:	e8 35 ea ff ff       	call   800201 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d1:	eb 1d                	jmp    8017f0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8017d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d6:	8b 52 18             	mov    0x18(%edx),%edx
  8017d9:	85 d2                	test   %edx,%edx
  8017db:	74 0e                	je     8017eb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017e4:	89 04 24             	mov    %eax,(%esp)
  8017e7:	ff d2                	call   *%edx
  8017e9:	eb 05                	jmp    8017f0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8017eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8017f0:	83 c4 24             	add    $0x24,%esp
  8017f3:	5b                   	pop    %ebx
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 24             	sub    $0x24,%esp
  8017fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801800:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801803:	89 44 24 04          	mov    %eax,0x4(%esp)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	89 04 24             	mov    %eax,(%esp)
  80180d:	e8 34 fb ff ff       	call   801346 <fd_lookup>
  801812:	89 c2                	mov    %eax,%edx
  801814:	85 d2                	test   %edx,%edx
  801816:	78 52                	js     80186a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801818:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801822:	8b 00                	mov    (%eax),%eax
  801824:	89 04 24             	mov    %eax,(%esp)
  801827:	e8 70 fb ff ff       	call   80139c <dev_lookup>
  80182c:	85 c0                	test   %eax,%eax
  80182e:	78 3a                	js     80186a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801833:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801837:	74 2c                	je     801865 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801839:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80183c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801843:	00 00 00 
	stat->st_isdir = 0;
  801846:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80184d:	00 00 00 
	stat->st_dev = dev;
  801850:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801856:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80185a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80185d:	89 14 24             	mov    %edx,(%esp)
  801860:	ff 50 14             	call   *0x14(%eax)
  801863:	eb 05                	jmp    80186a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801865:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80186a:	83 c4 24             	add    $0x24,%esp
  80186d:	5b                   	pop    %ebx
  80186e:	5d                   	pop    %ebp
  80186f:	c3                   	ret    

00801870 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
  801875:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801878:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80187f:	00 
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	89 04 24             	mov    %eax,(%esp)
  801886:	e8 28 02 00 00       	call   801ab3 <open>
  80188b:	89 c3                	mov    %eax,%ebx
  80188d:	85 db                	test   %ebx,%ebx
  80188f:	78 1b                	js     8018ac <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801891:	8b 45 0c             	mov    0xc(%ebp),%eax
  801894:	89 44 24 04          	mov    %eax,0x4(%esp)
  801898:	89 1c 24             	mov    %ebx,(%esp)
  80189b:	e8 56 ff ff ff       	call   8017f6 <fstat>
  8018a0:	89 c6                	mov    %eax,%esi
	close(fd);
  8018a2:	89 1c 24             	mov    %ebx,(%esp)
  8018a5:	e8 cd fb ff ff       	call   801477 <close>
	return r;
  8018aa:	89 f0                	mov    %esi,%eax
}
  8018ac:	83 c4 10             	add    $0x10,%esp
  8018af:	5b                   	pop    %ebx
  8018b0:	5e                   	pop    %esi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    

008018b3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	56                   	push   %esi
  8018b7:	53                   	push   %ebx
  8018b8:	83 ec 10             	sub    $0x10,%esp
  8018bb:	89 c6                	mov    %eax,%esi
  8018bd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018bf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8018c6:	75 11                	jne    8018d9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8018cf:	e8 68 0e 00 00       	call   80273c <ipc_find_env>
  8018d4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018d9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8018e0:	00 
  8018e1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8018e8:	00 
  8018e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018ed:	a1 00 50 80 00       	mov    0x805000,%eax
  8018f2:	89 04 24             	mov    %eax,(%esp)
  8018f5:	e8 e4 0d 00 00       	call   8026de <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018fa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801901:	00 
  801902:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801906:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80190d:	e8 62 0d 00 00       	call   802674 <ipc_recv>
}
  801912:	83 c4 10             	add    $0x10,%esp
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    

00801919 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	8b 40 0c             	mov    0xc(%eax),%eax
  801925:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80192a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801932:	ba 00 00 00 00       	mov    $0x0,%edx
  801937:	b8 02 00 00 00       	mov    $0x2,%eax
  80193c:	e8 72 ff ff ff       	call   8018b3 <fsipc>
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	8b 40 0c             	mov    0xc(%eax),%eax
  80194f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801954:	ba 00 00 00 00       	mov    $0x0,%edx
  801959:	b8 06 00 00 00       	mov    $0x6,%eax
  80195e:	e8 50 ff ff ff       	call   8018b3 <fsipc>
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	53                   	push   %ebx
  801969:	83 ec 14             	sub    $0x14,%esp
  80196c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	8b 40 0c             	mov    0xc(%eax),%eax
  801975:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80197a:	ba 00 00 00 00       	mov    $0x0,%edx
  80197f:	b8 05 00 00 00       	mov    $0x5,%eax
  801984:	e8 2a ff ff ff       	call   8018b3 <fsipc>
  801989:	89 c2                	mov    %eax,%edx
  80198b:	85 d2                	test   %edx,%edx
  80198d:	78 2b                	js     8019ba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80198f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801996:	00 
  801997:	89 1c 24             	mov    %ebx,(%esp)
  80199a:	e8 88 ee ff ff       	call   800827 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80199f:	a1 80 60 80 00       	mov    0x806080,%eax
  8019a4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019aa:	a1 84 60 80 00       	mov    0x806084,%eax
  8019af:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ba:	83 c4 14             	add    $0x14,%esp
  8019bd:	5b                   	pop    %ebx
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    

008019c0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 18             	sub    $0x18,%esp
  8019c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019ce:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019d3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  8019d6:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019db:	8b 55 08             	mov    0x8(%ebp),%edx
  8019de:	8b 52 0c             	mov    0xc(%edx),%edx
  8019e1:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  8019e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f2:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8019f9:	e8 c6 ef ff ff       	call   8009c4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  8019fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801a03:	b8 04 00 00 00       	mov    $0x4,%eax
  801a08:	e8 a6 fe ff ff       	call   8018b3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	56                   	push   %esi
  801a13:	53                   	push   %ebx
  801a14:	83 ec 10             	sub    $0x10,%esp
  801a17:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a20:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a25:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a30:	b8 03 00 00 00       	mov    $0x3,%eax
  801a35:	e8 79 fe ff ff       	call   8018b3 <fsipc>
  801a3a:	89 c3                	mov    %eax,%ebx
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 6a                	js     801aaa <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801a40:	39 c6                	cmp    %eax,%esi
  801a42:	73 24                	jae    801a68 <devfile_read+0x59>
  801a44:	c7 44 24 0c ac 2f 80 	movl   $0x802fac,0xc(%esp)
  801a4b:	00 
  801a4c:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  801a53:	00 
  801a54:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801a5b:	00 
  801a5c:	c7 04 24 c8 2f 80 00 	movl   $0x802fc8,(%esp)
  801a63:	e8 1e 0b 00 00       	call   802586 <_panic>
	assert(r <= PGSIZE);
  801a68:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a6d:	7e 24                	jle    801a93 <devfile_read+0x84>
  801a6f:	c7 44 24 0c d3 2f 80 	movl   $0x802fd3,0xc(%esp)
  801a76:	00 
  801a77:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  801a7e:	00 
  801a7f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801a86:	00 
  801a87:	c7 04 24 c8 2f 80 00 	movl   $0x802fc8,(%esp)
  801a8e:	e8 f3 0a 00 00       	call   802586 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a93:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a97:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a9e:	00 
  801a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa2:	89 04 24             	mov    %eax,(%esp)
  801aa5:	e8 1a ef ff ff       	call   8009c4 <memmove>
	return r;
}
  801aaa:	89 d8                	mov    %ebx,%eax
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    

00801ab3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	53                   	push   %ebx
  801ab7:	83 ec 24             	sub    $0x24,%esp
  801aba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801abd:	89 1c 24             	mov    %ebx,(%esp)
  801ac0:	e8 2b ed ff ff       	call   8007f0 <strlen>
  801ac5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aca:	7f 60                	jg     801b2c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801acf:	89 04 24             	mov    %eax,(%esp)
  801ad2:	e8 20 f8 ff ff       	call   8012f7 <fd_alloc>
  801ad7:	89 c2                	mov    %eax,%edx
  801ad9:	85 d2                	test   %edx,%edx
  801adb:	78 54                	js     801b31 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801add:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ae1:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801ae8:	e8 3a ed ff ff       	call   800827 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af0:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801af5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af8:	b8 01 00 00 00       	mov    $0x1,%eax
  801afd:	e8 b1 fd ff ff       	call   8018b3 <fsipc>
  801b02:	89 c3                	mov    %eax,%ebx
  801b04:	85 c0                	test   %eax,%eax
  801b06:	79 17                	jns    801b1f <open+0x6c>
		fd_close(fd, 0);
  801b08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b0f:	00 
  801b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b13:	89 04 24             	mov    %eax,(%esp)
  801b16:	e8 db f8 ff ff       	call   8013f6 <fd_close>
		return r;
  801b1b:	89 d8                	mov    %ebx,%eax
  801b1d:	eb 12                	jmp    801b31 <open+0x7e>
	}

	return fd2num(fd);
  801b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b22:	89 04 24             	mov    %eax,(%esp)
  801b25:	e8 a6 f7 ff ff       	call   8012d0 <fd2num>
  801b2a:	eb 05                	jmp    801b31 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b2c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801b31:	83 c4 24             	add    $0x24,%esp
  801b34:	5b                   	pop    %ebx
  801b35:	5d                   	pop    %ebp
  801b36:	c3                   	ret    

00801b37 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b42:	b8 08 00 00 00       	mov    $0x8,%eax
  801b47:	e8 67 fd ff ff       	call   8018b3 <fsipc>
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    
  801b4e:	66 90                	xchg   %ax,%ax

00801b50 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801b56:	c7 44 24 04 df 2f 80 	movl   $0x802fdf,0x4(%esp)
  801b5d:	00 
  801b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b61:	89 04 24             	mov    %eax,(%esp)
  801b64:	e8 be ec ff ff       	call   800827 <strcpy>
	return 0;
}
  801b69:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	53                   	push   %ebx
  801b74:	83 ec 14             	sub    $0x14,%esp
  801b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b7a:	89 1c 24             	mov    %ebx,(%esp)
  801b7d:	e8 f2 0b 00 00       	call   802774 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801b82:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801b87:	83 f8 01             	cmp    $0x1,%eax
  801b8a:	75 0d                	jne    801b99 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801b8c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801b8f:	89 04 24             	mov    %eax,(%esp)
  801b92:	e8 29 03 00 00       	call   801ec0 <nsipc_close>
  801b97:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801b99:	89 d0                	mov    %edx,%eax
  801b9b:	83 c4 14             	add    $0x14,%esp
  801b9e:	5b                   	pop    %ebx
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    

00801ba1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ba7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801bae:	00 
  801baf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc3:	89 04 24             	mov    %eax,(%esp)
  801bc6:	e8 f0 03 00 00       	call   801fbb <nsipc_send>
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801bda:	00 
  801bdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bde:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	8b 40 0c             	mov    0xc(%eax),%eax
  801bef:	89 04 24             	mov    %eax,(%esp)
  801bf2:	e8 44 03 00 00       	call   801f3b <nsipc_recv>
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c02:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c06:	89 04 24             	mov    %eax,(%esp)
  801c09:	e8 38 f7 ff ff       	call   801346 <fd_lookup>
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	78 17                	js     801c29 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c15:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801c1b:	39 08                	cmp    %ecx,(%eax)
  801c1d:	75 05                	jne    801c24 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c22:	eb 05                	jmp    801c29 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801c24:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801c29:	c9                   	leave  
  801c2a:	c3                   	ret    

00801c2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	56                   	push   %esi
  801c2f:	53                   	push   %ebx
  801c30:	83 ec 20             	sub    $0x20,%esp
  801c33:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c38:	89 04 24             	mov    %eax,(%esp)
  801c3b:	e8 b7 f6 ff ff       	call   8012f7 <fd_alloc>
  801c40:	89 c3                	mov    %eax,%ebx
  801c42:	85 c0                	test   %eax,%eax
  801c44:	78 21                	js     801c67 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c4d:	00 
  801c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c5c:	e8 e2 ef ff ff       	call   800c43 <sys_page_alloc>
  801c61:	89 c3                	mov    %eax,%ebx
  801c63:	85 c0                	test   %eax,%eax
  801c65:	79 0c                	jns    801c73 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801c67:	89 34 24             	mov    %esi,(%esp)
  801c6a:	e8 51 02 00 00       	call   801ec0 <nsipc_close>
		return r;
  801c6f:	89 d8                	mov    %ebx,%eax
  801c71:	eb 20                	jmp    801c93 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801c73:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c81:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801c88:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801c8b:	89 14 24             	mov    %edx,(%esp)
  801c8e:	e8 3d f6 ff ff       	call   8012d0 <fd2num>
}
  801c93:	83 c4 20             	add    $0x20,%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    

00801c9a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	e8 51 ff ff ff       	call   801bf9 <fd2sockid>
		return r;
  801ca8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801caa:	85 c0                	test   %eax,%eax
  801cac:	78 23                	js     801cd1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cae:	8b 55 10             	mov    0x10(%ebp),%edx
  801cb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cbc:	89 04 24             	mov    %eax,(%esp)
  801cbf:	e8 45 01 00 00       	call   801e09 <nsipc_accept>
		return r;
  801cc4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801cc6:	85 c0                	test   %eax,%eax
  801cc8:	78 07                	js     801cd1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801cca:	e8 5c ff ff ff       	call   801c2b <alloc_sockfd>
  801ccf:	89 c1                	mov    %eax,%ecx
}
  801cd1:	89 c8                	mov    %ecx,%eax
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cde:	e8 16 ff ff ff       	call   801bf9 <fd2sockid>
  801ce3:	89 c2                	mov    %eax,%edx
  801ce5:	85 d2                	test   %edx,%edx
  801ce7:	78 16                	js     801cff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cec:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf7:	89 14 24             	mov    %edx,(%esp)
  801cfa:	e8 60 01 00 00       	call   801e5f <nsipc_bind>
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <shutdown>:

int
shutdown(int s, int how)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	e8 ea fe ff ff       	call   801bf9 <fd2sockid>
  801d0f:	89 c2                	mov    %eax,%edx
  801d11:	85 d2                	test   %edx,%edx
  801d13:	78 0f                	js     801d24 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1c:	89 14 24             	mov    %edx,(%esp)
  801d1f:	e8 7a 01 00 00       	call   801e9e <nsipc_shutdown>
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	e8 c5 fe ff ff       	call   801bf9 <fd2sockid>
  801d34:	89 c2                	mov    %eax,%edx
  801d36:	85 d2                	test   %edx,%edx
  801d38:	78 16                	js     801d50 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801d3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d48:	89 14 24             	mov    %edx,(%esp)
  801d4b:	e8 8a 01 00 00       	call   801eda <nsipc_connect>
}
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <listen>:

int
listen(int s, int backlog)
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	e8 99 fe ff ff       	call   801bf9 <fd2sockid>
  801d60:	89 c2                	mov    %eax,%edx
  801d62:	85 d2                	test   %edx,%edx
  801d64:	78 0f                	js     801d75 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6d:	89 14 24             	mov    %edx,(%esp)
  801d70:	e8 a4 01 00 00       	call   801f19 <nsipc_listen>
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d80:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	89 04 24             	mov    %eax,(%esp)
  801d91:	e8 98 02 00 00       	call   80202e <nsipc_socket>
  801d96:	89 c2                	mov    %eax,%edx
  801d98:	85 d2                	test   %edx,%edx
  801d9a:	78 05                	js     801da1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801d9c:	e8 8a fe ff ff       	call   801c2b <alloc_sockfd>
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	53                   	push   %ebx
  801da7:	83 ec 14             	sub    $0x14,%esp
  801daa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801dac:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801db3:	75 11                	jne    801dc6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801db5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801dbc:	e8 7b 09 00 00       	call   80273c <ipc_find_env>
  801dc1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801dc6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801dcd:	00 
  801dce:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801dd5:	00 
  801dd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dda:	a1 04 50 80 00       	mov    0x805004,%eax
  801ddf:	89 04 24             	mov    %eax,(%esp)
  801de2:	e8 f7 08 00 00       	call   8026de <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801de7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dee:	00 
  801def:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801df6:	00 
  801df7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dfe:	e8 71 08 00 00       	call   802674 <ipc_recv>
}
  801e03:	83 c4 14             	add    $0x14,%esp
  801e06:	5b                   	pop    %ebx
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    

00801e09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	56                   	push   %esi
  801e0d:	53                   	push   %ebx
  801e0e:	83 ec 10             	sub    $0x10,%esp
  801e11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e14:	8b 45 08             	mov    0x8(%ebp),%eax
  801e17:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e1c:	8b 06                	mov    (%esi),%eax
  801e1e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e23:	b8 01 00 00 00       	mov    $0x1,%eax
  801e28:	e8 76 ff ff ff       	call   801da3 <nsipc>
  801e2d:	89 c3                	mov    %eax,%ebx
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 23                	js     801e56 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e33:	a1 10 70 80 00       	mov    0x807010,%eax
  801e38:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e3c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801e43:	00 
  801e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e47:	89 04 24             	mov    %eax,(%esp)
  801e4a:	e8 75 eb ff ff       	call   8009c4 <memmove>
		*addrlen = ret->ret_addrlen;
  801e4f:	a1 10 70 80 00       	mov    0x807010,%eax
  801e54:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801e56:	89 d8                	mov    %ebx,%eax
  801e58:	83 c4 10             	add    $0x10,%esp
  801e5b:	5b                   	pop    %ebx
  801e5c:	5e                   	pop    %esi
  801e5d:	5d                   	pop    %ebp
  801e5e:	c3                   	ret    

00801e5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
  801e62:	53                   	push   %ebx
  801e63:	83 ec 14             	sub    $0x14,%esp
  801e66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801e83:	e8 3c eb ff ff       	call   8009c4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e88:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801e8e:	b8 02 00 00 00       	mov    $0x2,%eax
  801e93:	e8 0b ff ff ff       	call   801da3 <nsipc>
}
  801e98:	83 c4 14             	add    $0x14,%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5d                   	pop    %ebp
  801e9d:	c3                   	ret    

00801e9e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eaf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801eb4:	b8 03 00 00 00       	mov    $0x3,%eax
  801eb9:	e8 e5 fe ff ff       	call   801da3 <nsipc>
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <nsipc_close>:

int
nsipc_close(int s)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801ece:	b8 04 00 00 00       	mov    $0x4,%eax
  801ed3:	e8 cb fe ff ff       	call   801da3 <nsipc>
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	53                   	push   %ebx
  801ede:	83 ec 14             	sub    $0x14,%esp
  801ee1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801eec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801efe:	e8 c1 ea ff ff       	call   8009c4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f03:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801f09:	b8 05 00 00 00       	mov    $0x5,%eax
  801f0e:	e8 90 fe ff ff       	call   801da3 <nsipc>
}
  801f13:	83 c4 14             	add    $0x14,%esp
  801f16:	5b                   	pop    %ebx
  801f17:	5d                   	pop    %ebp
  801f18:	c3                   	ret    

00801f19 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801f2f:	b8 06 00 00 00       	mov    $0x6,%eax
  801f34:	e8 6a fe ff ff       	call   801da3 <nsipc>
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	56                   	push   %esi
  801f3f:	53                   	push   %ebx
  801f40:	83 ec 10             	sub    $0x10,%esp
  801f43:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801f4e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801f54:	8b 45 14             	mov    0x14(%ebp),%eax
  801f57:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f5c:	b8 07 00 00 00       	mov    $0x7,%eax
  801f61:	e8 3d fe ff ff       	call   801da3 <nsipc>
  801f66:	89 c3                	mov    %eax,%ebx
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	78 46                	js     801fb2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801f6c:	39 f0                	cmp    %esi,%eax
  801f6e:	7f 07                	jg     801f77 <nsipc_recv+0x3c>
  801f70:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f75:	7e 24                	jle    801f9b <nsipc_recv+0x60>
  801f77:	c7 44 24 0c eb 2f 80 	movl   $0x802feb,0xc(%esp)
  801f7e:	00 
  801f7f:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  801f86:	00 
  801f87:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801f8e:	00 
  801f8f:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801f96:	e8 eb 05 00 00       	call   802586 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f9b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f9f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801fa6:	00 
  801fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801faa:	89 04 24             	mov    %eax,(%esp)
  801fad:	e8 12 ea ff ff       	call   8009c4 <memmove>
	}

	return r;
}
  801fb2:	89 d8                	mov    %ebx,%eax
  801fb4:	83 c4 10             	add    $0x10,%esp
  801fb7:	5b                   	pop    %ebx
  801fb8:	5e                   	pop    %esi
  801fb9:	5d                   	pop    %ebp
  801fba:	c3                   	ret    

00801fbb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	53                   	push   %ebx
  801fbf:	83 ec 14             	sub    $0x14,%esp
  801fc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  801fcd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fd3:	7e 24                	jle    801ff9 <nsipc_send+0x3e>
  801fd5:	c7 44 24 0c 0c 30 80 	movl   $0x80300c,0xc(%esp)
  801fdc:	00 
  801fdd:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  801fe4:	00 
  801fe5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801fec:	00 
  801fed:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801ff4:	e8 8d 05 00 00       	call   802586 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ff9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802000:	89 44 24 04          	mov    %eax,0x4(%esp)
  802004:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80200b:	e8 b4 e9 ff ff       	call   8009c4 <memmove>
	nsipcbuf.send.req_size = size;
  802010:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802016:	8b 45 14             	mov    0x14(%ebp),%eax
  802019:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80201e:	b8 08 00 00 00       	mov    $0x8,%eax
  802023:	e8 7b fd ff ff       	call   801da3 <nsipc>
}
  802028:	83 c4 14             	add    $0x14,%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5d                   	pop    %ebp
  80202d:	c3                   	ret    

0080202e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80203c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802044:	8b 45 10             	mov    0x10(%ebp),%eax
  802047:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80204c:	b8 09 00 00 00       	mov    $0x9,%eax
  802051:	e8 4d fd ff ff       	call   801da3 <nsipc>
}
  802056:	c9                   	leave  
  802057:	c3                   	ret    

00802058 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802058:	55                   	push   %ebp
  802059:	89 e5                	mov    %esp,%ebp
  80205b:	56                   	push   %esi
  80205c:	53                   	push   %ebx
  80205d:	83 ec 10             	sub    $0x10,%esp
  802060:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802063:	8b 45 08             	mov    0x8(%ebp),%eax
  802066:	89 04 24             	mov    %eax,(%esp)
  802069:	e8 72 f2 ff ff       	call   8012e0 <fd2data>
  80206e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802070:	c7 44 24 04 18 30 80 	movl   $0x803018,0x4(%esp)
  802077:	00 
  802078:	89 1c 24             	mov    %ebx,(%esp)
  80207b:	e8 a7 e7 ff ff       	call   800827 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802080:	8b 46 04             	mov    0x4(%esi),%eax
  802083:	2b 06                	sub    (%esi),%eax
  802085:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80208b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802092:	00 00 00 
	stat->st_dev = &devpipe;
  802095:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80209c:	40 80 00 
	return 0;
}
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	5b                   	pop    %ebx
  8020a8:	5e                   	pop    %esi
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    

008020ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	53                   	push   %ebx
  8020af:	83 ec 14             	sub    $0x14,%esp
  8020b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8020b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c0:	e8 25 ec ff ff       	call   800cea <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020c5:	89 1c 24             	mov    %ebx,(%esp)
  8020c8:	e8 13 f2 ff ff       	call   8012e0 <fd2data>
  8020cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d8:	e8 0d ec ff ff       	call   800cea <sys_page_unmap>
}
  8020dd:	83 c4 14             	add    $0x14,%esp
  8020e0:	5b                   	pop    %ebx
  8020e1:	5d                   	pop    %ebp
  8020e2:	c3                   	ret    

008020e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	57                   	push   %edi
  8020e7:	56                   	push   %esi
  8020e8:	53                   	push   %ebx
  8020e9:	83 ec 2c             	sub    $0x2c,%esp
  8020ec:	89 c6                	mov    %eax,%esi
  8020ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020f1:	a1 08 50 80 00       	mov    0x805008,%eax
  8020f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020f9:	89 34 24             	mov    %esi,(%esp)
  8020fc:	e8 73 06 00 00       	call   802774 <pageref>
  802101:	89 c7                	mov    %eax,%edi
  802103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802106:	89 04 24             	mov    %eax,(%esp)
  802109:	e8 66 06 00 00       	call   802774 <pageref>
  80210e:	39 c7                	cmp    %eax,%edi
  802110:	0f 94 c2             	sete   %dl
  802113:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802116:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80211c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80211f:	39 fb                	cmp    %edi,%ebx
  802121:	74 21                	je     802144 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802123:	84 d2                	test   %dl,%dl
  802125:	74 ca                	je     8020f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802127:	8b 51 58             	mov    0x58(%ecx),%edx
  80212a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80212e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802132:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802136:	c7 04 24 1f 30 80 00 	movl   $0x80301f,(%esp)
  80213d:	e8 bf e0 ff ff       	call   800201 <cprintf>
  802142:	eb ad                	jmp    8020f1 <_pipeisclosed+0xe>
	}
}
  802144:	83 c4 2c             	add    $0x2c,%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5f                   	pop    %edi
  80214a:	5d                   	pop    %ebp
  80214b:	c3                   	ret    

0080214c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	57                   	push   %edi
  802150:	56                   	push   %esi
  802151:	53                   	push   %ebx
  802152:	83 ec 1c             	sub    $0x1c,%esp
  802155:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802158:	89 34 24             	mov    %esi,(%esp)
  80215b:	e8 80 f1 ff ff       	call   8012e0 <fd2data>
  802160:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802162:	bf 00 00 00 00       	mov    $0x0,%edi
  802167:	eb 45                	jmp    8021ae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802169:	89 da                	mov    %ebx,%edx
  80216b:	89 f0                	mov    %esi,%eax
  80216d:	e8 71 ff ff ff       	call   8020e3 <_pipeisclosed>
  802172:	85 c0                	test   %eax,%eax
  802174:	75 41                	jne    8021b7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802176:	e8 a9 ea ff ff       	call   800c24 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80217b:	8b 43 04             	mov    0x4(%ebx),%eax
  80217e:	8b 0b                	mov    (%ebx),%ecx
  802180:	8d 51 20             	lea    0x20(%ecx),%edx
  802183:	39 d0                	cmp    %edx,%eax
  802185:	73 e2                	jae    802169 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80218a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80218e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802191:	99                   	cltd   
  802192:	c1 ea 1b             	shr    $0x1b,%edx
  802195:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802198:	83 e1 1f             	and    $0x1f,%ecx
  80219b:	29 d1                	sub    %edx,%ecx
  80219d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8021a1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8021a5:	83 c0 01             	add    $0x1,%eax
  8021a8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021ab:	83 c7 01             	add    $0x1,%edi
  8021ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8021b1:	75 c8                	jne    80217b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8021b3:	89 f8                	mov    %edi,%eax
  8021b5:	eb 05                	jmp    8021bc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021b7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8021bc:	83 c4 1c             	add    $0x1c,%esp
  8021bf:	5b                   	pop    %ebx
  8021c0:	5e                   	pop    %esi
  8021c1:	5f                   	pop    %edi
  8021c2:	5d                   	pop    %ebp
  8021c3:	c3                   	ret    

008021c4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021c4:	55                   	push   %ebp
  8021c5:	89 e5                	mov    %esp,%ebp
  8021c7:	57                   	push   %edi
  8021c8:	56                   	push   %esi
  8021c9:	53                   	push   %ebx
  8021ca:	83 ec 1c             	sub    $0x1c,%esp
  8021cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021d0:	89 3c 24             	mov    %edi,(%esp)
  8021d3:	e8 08 f1 ff ff       	call   8012e0 <fd2data>
  8021d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021da:	be 00 00 00 00       	mov    $0x0,%esi
  8021df:	eb 3d                	jmp    80221e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021e1:	85 f6                	test   %esi,%esi
  8021e3:	74 04                	je     8021e9 <devpipe_read+0x25>
				return i;
  8021e5:	89 f0                	mov    %esi,%eax
  8021e7:	eb 43                	jmp    80222c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021e9:	89 da                	mov    %ebx,%edx
  8021eb:	89 f8                	mov    %edi,%eax
  8021ed:	e8 f1 fe ff ff       	call   8020e3 <_pipeisclosed>
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	75 31                	jne    802227 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021f6:	e8 29 ea ff ff       	call   800c24 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8021fb:	8b 03                	mov    (%ebx),%eax
  8021fd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802200:	74 df                	je     8021e1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802202:	99                   	cltd   
  802203:	c1 ea 1b             	shr    $0x1b,%edx
  802206:	01 d0                	add    %edx,%eax
  802208:	83 e0 1f             	and    $0x1f,%eax
  80220b:	29 d0                	sub    %edx,%eax
  80220d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802212:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802215:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802218:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80221b:	83 c6 01             	add    $0x1,%esi
  80221e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802221:	75 d8                	jne    8021fb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802223:	89 f0                	mov    %esi,%eax
  802225:	eb 05                	jmp    80222c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80222c:	83 c4 1c             	add    $0x1c,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    

00802234 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	56                   	push   %esi
  802238:	53                   	push   %ebx
  802239:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80223c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80223f:	89 04 24             	mov    %eax,(%esp)
  802242:	e8 b0 f0 ff ff       	call   8012f7 <fd_alloc>
  802247:	89 c2                	mov    %eax,%edx
  802249:	85 d2                	test   %edx,%edx
  80224b:	0f 88 4d 01 00 00    	js     80239e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802251:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802258:	00 
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802260:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802267:	e8 d7 e9 ff ff       	call   800c43 <sys_page_alloc>
  80226c:	89 c2                	mov    %eax,%edx
  80226e:	85 d2                	test   %edx,%edx
  802270:	0f 88 28 01 00 00    	js     80239e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802276:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802279:	89 04 24             	mov    %eax,(%esp)
  80227c:	e8 76 f0 ff ff       	call   8012f7 <fd_alloc>
  802281:	89 c3                	mov    %eax,%ebx
  802283:	85 c0                	test   %eax,%eax
  802285:	0f 88 fe 00 00 00    	js     802389 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80228b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802292:	00 
  802293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802296:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a1:	e8 9d e9 ff ff       	call   800c43 <sys_page_alloc>
  8022a6:	89 c3                	mov    %eax,%ebx
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	0f 88 d9 00 00 00    	js     802389 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	89 04 24             	mov    %eax,(%esp)
  8022b6:	e8 25 f0 ff ff       	call   8012e0 <fd2data>
  8022bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022c4:	00 
  8022c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d0:	e8 6e e9 ff ff       	call   800c43 <sys_page_alloc>
  8022d5:	89 c3                	mov    %eax,%ebx
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	0f 88 97 00 00 00    	js     802376 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e2:	89 04 24             	mov    %eax,(%esp)
  8022e5:	e8 f6 ef ff ff       	call   8012e0 <fd2data>
  8022ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8022f1:	00 
  8022f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022fd:	00 
  8022fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802302:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802309:	e8 89 e9 ff ff       	call   800c97 <sys_page_map>
  80230e:	89 c3                	mov    %eax,%ebx
  802310:	85 c0                	test   %eax,%eax
  802312:	78 52                	js     802366 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802314:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80231f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802322:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802329:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80232f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802332:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802334:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802337:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	89 04 24             	mov    %eax,(%esp)
  802344:	e8 87 ef ff ff       	call   8012d0 <fd2num>
  802349:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80234c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80234e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802351:	89 04 24             	mov    %eax,(%esp)
  802354:	e8 77 ef ff ff       	call   8012d0 <fd2num>
  802359:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80235c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80235f:	b8 00 00 00 00       	mov    $0x0,%eax
  802364:	eb 38                	jmp    80239e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802366:	89 74 24 04          	mov    %esi,0x4(%esp)
  80236a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802371:	e8 74 e9 ff ff       	call   800cea <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802376:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802379:	89 44 24 04          	mov    %eax,0x4(%esp)
  80237d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802384:	e8 61 e9 ff ff       	call   800cea <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802390:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802397:	e8 4e e9 ff ff       	call   800cea <sys_page_unmap>
  80239c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80239e:	83 c4 30             	add    $0x30,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    

008023a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
  8023a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	89 04 24             	mov    %eax,(%esp)
  8023b8:	e8 89 ef ff ff       	call   801346 <fd_lookup>
  8023bd:	89 c2                	mov    %eax,%edx
  8023bf:	85 d2                	test   %edx,%edx
  8023c1:	78 15                	js     8023d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	89 04 24             	mov    %eax,(%esp)
  8023c9:	e8 12 ef ff ff       	call   8012e0 <fd2data>
	return _pipeisclosed(fd, p);
  8023ce:	89 c2                	mov    %eax,%edx
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	e8 0b fd ff ff       	call   8020e3 <_pipeisclosed>
}
  8023d8:	c9                   	leave  
  8023d9:	c3                   	ret    
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8023e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e8:	5d                   	pop    %ebp
  8023e9:	c3                   	ret    

008023ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8023f0:	c7 44 24 04 37 30 80 	movl   $0x803037,0x4(%esp)
  8023f7:	00 
  8023f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fb:	89 04 24             	mov    %eax,(%esp)
  8023fe:	e8 24 e4 ff ff       	call   800827 <strcpy>
	return 0;
}
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
  80240d:	57                   	push   %edi
  80240e:	56                   	push   %esi
  80240f:	53                   	push   %ebx
  802410:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802416:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80241b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802421:	eb 31                	jmp    802454 <devcons_write+0x4a>
		m = n - tot;
  802423:	8b 75 10             	mov    0x10(%ebp),%esi
  802426:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802428:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80242b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802430:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802433:	89 74 24 08          	mov    %esi,0x8(%esp)
  802437:	03 45 0c             	add    0xc(%ebp),%eax
  80243a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243e:	89 3c 24             	mov    %edi,(%esp)
  802441:	e8 7e e5 ff ff       	call   8009c4 <memmove>
		sys_cputs(buf, m);
  802446:	89 74 24 04          	mov    %esi,0x4(%esp)
  80244a:	89 3c 24             	mov    %edi,(%esp)
  80244d:	e8 24 e7 ff ff       	call   800b76 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802452:	01 f3                	add    %esi,%ebx
  802454:	89 d8                	mov    %ebx,%eax
  802456:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802459:	72 c8                	jb     802423 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80245b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802461:	5b                   	pop    %ebx
  802462:	5e                   	pop    %esi
  802463:	5f                   	pop    %edi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    

00802466 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80246c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802471:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802475:	75 07                	jne    80247e <devcons_read+0x18>
  802477:	eb 2a                	jmp    8024a3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802479:	e8 a6 e7 ff ff       	call   800c24 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80247e:	66 90                	xchg   %ax,%ax
  802480:	e8 0f e7 ff ff       	call   800b94 <sys_cgetc>
  802485:	85 c0                	test   %eax,%eax
  802487:	74 f0                	je     802479 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802489:	85 c0                	test   %eax,%eax
  80248b:	78 16                	js     8024a3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80248d:	83 f8 04             	cmp    $0x4,%eax
  802490:	74 0c                	je     80249e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802492:	8b 55 0c             	mov    0xc(%ebp),%edx
  802495:	88 02                	mov    %al,(%edx)
	return 1;
  802497:	b8 01 00 00 00       	mov    $0x1,%eax
  80249c:	eb 05                	jmp    8024a3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80249e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8024b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8024b8:	00 
  8024b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024bc:	89 04 24             	mov    %eax,(%esp)
  8024bf:	e8 b2 e6 ff ff       	call   800b76 <sys_cputs>
}
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <getchar>:

int
getchar(void)
{
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8024d3:	00 
  8024d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e2:	e8 f3 f0 ff ff       	call   8015da <read>
	if (r < 0)
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	78 0f                	js     8024fa <getchar+0x34>
		return r;
	if (r < 1)
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	7e 06                	jle    8024f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8024ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8024f3:	eb 05                	jmp    8024fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8024f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802502:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802505:	89 44 24 04          	mov    %eax,0x4(%esp)
  802509:	8b 45 08             	mov    0x8(%ebp),%eax
  80250c:	89 04 24             	mov    %eax,(%esp)
  80250f:	e8 32 ee ff ff       	call   801346 <fd_lookup>
  802514:	85 c0                	test   %eax,%eax
  802516:	78 11                	js     802529 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802521:	39 10                	cmp    %edx,(%eax)
  802523:	0f 94 c0             	sete   %al
  802526:	0f b6 c0             	movzbl %al,%eax
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <opencons>:

int
opencons(void)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
  80252e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802531:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802534:	89 04 24             	mov    %eax,(%esp)
  802537:	e8 bb ed ff ff       	call   8012f7 <fd_alloc>
		return r;
  80253c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80253e:	85 c0                	test   %eax,%eax
  802540:	78 40                	js     802582 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802542:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802549:	00 
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802551:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802558:	e8 e6 e6 ff ff       	call   800c43 <sys_page_alloc>
		return r;
  80255d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80255f:	85 c0                	test   %eax,%eax
  802561:	78 1f                	js     802582 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802563:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802578:	89 04 24             	mov    %eax,(%esp)
  80257b:	e8 50 ed ff ff       	call   8012d0 <fd2num>
  802580:	89 c2                	mov    %eax,%edx
}
  802582:	89 d0                	mov    %edx,%eax
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	56                   	push   %esi
  80258a:	53                   	push   %ebx
  80258b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80258e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802591:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802597:	e8 69 e6 ff ff       	call   800c05 <sys_getenvid>
  80259c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259f:	89 54 24 10          	mov    %edx,0x10(%esp)
  8025a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8025aa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8025ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b2:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  8025b9:	e8 43 dc ff ff       	call   800201 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8025be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c5:	89 04 24             	mov    %eax,(%esp)
  8025c8:	e8 d3 db ff ff       	call   8001a0 <vcprintf>
	cprintf("\n");
  8025cd:	c7 04 24 4f 2a 80 00 	movl   $0x802a4f,(%esp)
  8025d4:	e8 28 dc ff ff       	call   800201 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025d9:	cc                   	int3   
  8025da:	eb fd                	jmp    8025d9 <_panic+0x53>

008025dc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8025e2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8025e9:	75 58                	jne    802643 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  8025eb:	a1 08 50 80 00       	mov    0x805008,%eax
  8025f0:	8b 40 48             	mov    0x48(%eax),%eax
  8025f3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8025fa:	00 
  8025fb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802602:	ee 
  802603:	89 04 24             	mov    %eax,(%esp)
  802606:	e8 38 e6 ff ff       	call   800c43 <sys_page_alloc>
		if(return_code!=0)
  80260b:	85 c0                	test   %eax,%eax
  80260d:	74 1c                	je     80262b <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  80260f:	c7 44 24 08 68 30 80 	movl   $0x803068,0x8(%esp)
  802616:	00 
  802617:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80261e:	00 
  80261f:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  802626:	e8 5b ff ff ff       	call   802586 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  80262b:	a1 08 50 80 00       	mov    0x805008,%eax
  802630:	8b 40 48             	mov    0x48(%eax),%eax
  802633:	c7 44 24 04 4d 26 80 	movl   $0x80264d,0x4(%esp)
  80263a:	00 
  80263b:	89 04 24             	mov    %eax,(%esp)
  80263e:	e8 a0 e7 ff ff       	call   800de3 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802643:	8b 45 08             	mov    0x8(%ebp),%eax
  802646:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80264d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80264e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802653:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802655:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802658:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  80265a:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  80265e:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  802662:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  802663:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  802665:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802667:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  80266b:	58                   	pop    %eax
	popl %eax;
  80266c:	58                   	pop    %eax
	popal;
  80266d:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  80266e:	83 c4 04             	add    $0x4,%esp
	popfl;
  802671:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802672:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  802673:	c3                   	ret    

00802674 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802674:	55                   	push   %ebp
  802675:	89 e5                	mov    %esp,%ebp
  802677:	56                   	push   %esi
  802678:	53                   	push   %ebx
  802679:	83 ec 10             	sub    $0x10,%esp
  80267c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80267f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802682:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802685:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802687:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80268c:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  80268f:	89 04 24             	mov    %eax,(%esp)
  802692:	e8 c2 e7 ff ff       	call   800e59 <sys_ipc_recv>
  802697:	85 c0                	test   %eax,%eax
  802699:	75 1e                	jne    8026b9 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80269b:	85 db                	test   %ebx,%ebx
  80269d:	74 0a                	je     8026a9 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  80269f:	a1 08 50 80 00       	mov    0x805008,%eax
  8026a4:	8b 40 74             	mov    0x74(%eax),%eax
  8026a7:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8026a9:	85 f6                	test   %esi,%esi
  8026ab:	74 22                	je     8026cf <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8026ad:	a1 08 50 80 00       	mov    0x805008,%eax
  8026b2:	8b 40 78             	mov    0x78(%eax),%eax
  8026b5:	89 06                	mov    %eax,(%esi)
  8026b7:	eb 16                	jmp    8026cf <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8026b9:	85 f6                	test   %esi,%esi
  8026bb:	74 06                	je     8026c3 <ipc_recv+0x4f>
				*perm_store = 0;
  8026bd:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8026c3:	85 db                	test   %ebx,%ebx
  8026c5:	74 10                	je     8026d7 <ipc_recv+0x63>
				*from_env_store=0;
  8026c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026cd:	eb 08                	jmp    8026d7 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8026cf:	a1 08 50 80 00       	mov    0x805008,%eax
  8026d4:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8026d7:	83 c4 10             	add    $0x10,%esp
  8026da:	5b                   	pop    %ebx
  8026db:	5e                   	pop    %esi
  8026dc:	5d                   	pop    %ebp
  8026dd:	c3                   	ret    

008026de <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	57                   	push   %edi
  8026e2:	56                   	push   %esi
  8026e3:	53                   	push   %ebx
  8026e4:	83 ec 1c             	sub    $0x1c,%esp
  8026e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026ed:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8026f0:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8026f2:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8026f7:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8026fa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802702:	89 74 24 04          	mov    %esi,0x4(%esp)
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	89 04 24             	mov    %eax,(%esp)
  80270c:	e8 25 e7 ff ff       	call   800e36 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802711:	eb 1c                	jmp    80272f <ipc_send+0x51>
	{
		sys_yield();
  802713:	e8 0c e5 ff ff       	call   800c24 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802718:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80271c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802720:	89 74 24 04          	mov    %esi,0x4(%esp)
  802724:	8b 45 08             	mov    0x8(%ebp),%eax
  802727:	89 04 24             	mov    %eax,(%esp)
  80272a:	e8 07 e7 ff ff       	call   800e36 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  80272f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802732:	74 df                	je     802713 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802734:	83 c4 1c             	add    $0x1c,%esp
  802737:	5b                   	pop    %ebx
  802738:	5e                   	pop    %esi
  802739:	5f                   	pop    %edi
  80273a:	5d                   	pop    %ebp
  80273b:	c3                   	ret    

0080273c <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
  80273f:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802742:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802747:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80274a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802750:	8b 52 50             	mov    0x50(%edx),%edx
  802753:	39 ca                	cmp    %ecx,%edx
  802755:	75 0d                	jne    802764 <ipc_find_env+0x28>
			return envs[i].env_id;
  802757:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80275a:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80275f:	8b 40 40             	mov    0x40(%eax),%eax
  802762:	eb 0e                	jmp    802772 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802764:	83 c0 01             	add    $0x1,%eax
  802767:	3d 00 04 00 00       	cmp    $0x400,%eax
  80276c:	75 d9                	jne    802747 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80276e:	66 b8 00 00          	mov    $0x0,%ax
}
  802772:	5d                   	pop    %ebp
  802773:	c3                   	ret    

00802774 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802774:	55                   	push   %ebp
  802775:	89 e5                	mov    %esp,%ebp
  802777:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80277a:	89 d0                	mov    %edx,%eax
  80277c:	c1 e8 16             	shr    $0x16,%eax
  80277f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80278b:	f6 c1 01             	test   $0x1,%cl
  80278e:	74 1d                	je     8027ad <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802790:	c1 ea 0c             	shr    $0xc,%edx
  802793:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80279a:	f6 c2 01             	test   $0x1,%dl
  80279d:	74 0e                	je     8027ad <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80279f:	c1 ea 0c             	shr    $0xc,%edx
  8027a2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027a9:	ef 
  8027aa:	0f b7 c0             	movzwl %ax,%eax
}
  8027ad:	5d                   	pop    %ebp
  8027ae:	c3                   	ret    
  8027af:	90                   	nop

008027b0 <__udivdi3>:
  8027b0:	55                   	push   %ebp
  8027b1:	57                   	push   %edi
  8027b2:	56                   	push   %esi
  8027b3:	83 ec 0c             	sub    $0xc,%esp
  8027b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8027be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8027c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027c6:	85 c0                	test   %eax,%eax
  8027c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8027cc:	89 ea                	mov    %ebp,%edx
  8027ce:	89 0c 24             	mov    %ecx,(%esp)
  8027d1:	75 2d                	jne    802800 <__udivdi3+0x50>
  8027d3:	39 e9                	cmp    %ebp,%ecx
  8027d5:	77 61                	ja     802838 <__udivdi3+0x88>
  8027d7:	85 c9                	test   %ecx,%ecx
  8027d9:	89 ce                	mov    %ecx,%esi
  8027db:	75 0b                	jne    8027e8 <__udivdi3+0x38>
  8027dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e2:	31 d2                	xor    %edx,%edx
  8027e4:	f7 f1                	div    %ecx
  8027e6:	89 c6                	mov    %eax,%esi
  8027e8:	31 d2                	xor    %edx,%edx
  8027ea:	89 e8                	mov    %ebp,%eax
  8027ec:	f7 f6                	div    %esi
  8027ee:	89 c5                	mov    %eax,%ebp
  8027f0:	89 f8                	mov    %edi,%eax
  8027f2:	f7 f6                	div    %esi
  8027f4:	89 ea                	mov    %ebp,%edx
  8027f6:	83 c4 0c             	add    $0xc,%esp
  8027f9:	5e                   	pop    %esi
  8027fa:	5f                   	pop    %edi
  8027fb:	5d                   	pop    %ebp
  8027fc:	c3                   	ret    
  8027fd:	8d 76 00             	lea    0x0(%esi),%esi
  802800:	39 e8                	cmp    %ebp,%eax
  802802:	77 24                	ja     802828 <__udivdi3+0x78>
  802804:	0f bd e8             	bsr    %eax,%ebp
  802807:	83 f5 1f             	xor    $0x1f,%ebp
  80280a:	75 3c                	jne    802848 <__udivdi3+0x98>
  80280c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802810:	39 34 24             	cmp    %esi,(%esp)
  802813:	0f 86 9f 00 00 00    	jbe    8028b8 <__udivdi3+0x108>
  802819:	39 d0                	cmp    %edx,%eax
  80281b:	0f 82 97 00 00 00    	jb     8028b8 <__udivdi3+0x108>
  802821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802828:	31 d2                	xor    %edx,%edx
  80282a:	31 c0                	xor    %eax,%eax
  80282c:	83 c4 0c             	add    $0xc,%esp
  80282f:	5e                   	pop    %esi
  802830:	5f                   	pop    %edi
  802831:	5d                   	pop    %ebp
  802832:	c3                   	ret    
  802833:	90                   	nop
  802834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802838:	89 f8                	mov    %edi,%eax
  80283a:	f7 f1                	div    %ecx
  80283c:	31 d2                	xor    %edx,%edx
  80283e:	83 c4 0c             	add    $0xc,%esp
  802841:	5e                   	pop    %esi
  802842:	5f                   	pop    %edi
  802843:	5d                   	pop    %ebp
  802844:	c3                   	ret    
  802845:	8d 76 00             	lea    0x0(%esi),%esi
  802848:	89 e9                	mov    %ebp,%ecx
  80284a:	8b 3c 24             	mov    (%esp),%edi
  80284d:	d3 e0                	shl    %cl,%eax
  80284f:	89 c6                	mov    %eax,%esi
  802851:	b8 20 00 00 00       	mov    $0x20,%eax
  802856:	29 e8                	sub    %ebp,%eax
  802858:	89 c1                	mov    %eax,%ecx
  80285a:	d3 ef                	shr    %cl,%edi
  80285c:	89 e9                	mov    %ebp,%ecx
  80285e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802862:	8b 3c 24             	mov    (%esp),%edi
  802865:	09 74 24 08          	or     %esi,0x8(%esp)
  802869:	89 d6                	mov    %edx,%esi
  80286b:	d3 e7                	shl    %cl,%edi
  80286d:	89 c1                	mov    %eax,%ecx
  80286f:	89 3c 24             	mov    %edi,(%esp)
  802872:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802876:	d3 ee                	shr    %cl,%esi
  802878:	89 e9                	mov    %ebp,%ecx
  80287a:	d3 e2                	shl    %cl,%edx
  80287c:	89 c1                	mov    %eax,%ecx
  80287e:	d3 ef                	shr    %cl,%edi
  802880:	09 d7                	or     %edx,%edi
  802882:	89 f2                	mov    %esi,%edx
  802884:	89 f8                	mov    %edi,%eax
  802886:	f7 74 24 08          	divl   0x8(%esp)
  80288a:	89 d6                	mov    %edx,%esi
  80288c:	89 c7                	mov    %eax,%edi
  80288e:	f7 24 24             	mull   (%esp)
  802891:	39 d6                	cmp    %edx,%esi
  802893:	89 14 24             	mov    %edx,(%esp)
  802896:	72 30                	jb     8028c8 <__udivdi3+0x118>
  802898:	8b 54 24 04          	mov    0x4(%esp),%edx
  80289c:	89 e9                	mov    %ebp,%ecx
  80289e:	d3 e2                	shl    %cl,%edx
  8028a0:	39 c2                	cmp    %eax,%edx
  8028a2:	73 05                	jae    8028a9 <__udivdi3+0xf9>
  8028a4:	3b 34 24             	cmp    (%esp),%esi
  8028a7:	74 1f                	je     8028c8 <__udivdi3+0x118>
  8028a9:	89 f8                	mov    %edi,%eax
  8028ab:	31 d2                	xor    %edx,%edx
  8028ad:	e9 7a ff ff ff       	jmp    80282c <__udivdi3+0x7c>
  8028b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028b8:	31 d2                	xor    %edx,%edx
  8028ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8028bf:	e9 68 ff ff ff       	jmp    80282c <__udivdi3+0x7c>
  8028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	83 c4 0c             	add    $0xc,%esp
  8028d0:	5e                   	pop    %esi
  8028d1:	5f                   	pop    %edi
  8028d2:	5d                   	pop    %ebp
  8028d3:	c3                   	ret    
  8028d4:	66 90                	xchg   %ax,%ax
  8028d6:	66 90                	xchg   %ax,%ax
  8028d8:	66 90                	xchg   %ax,%ax
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	66 90                	xchg   %ax,%ax
  8028de:	66 90                	xchg   %ax,%ax

008028e0 <__umoddi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	83 ec 14             	sub    $0x14,%esp
  8028e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8028f2:	89 c7                	mov    %eax,%edi
  8028f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8028fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802900:	89 34 24             	mov    %esi,(%esp)
  802903:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802907:	85 c0                	test   %eax,%eax
  802909:	89 c2                	mov    %eax,%edx
  80290b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80290f:	75 17                	jne    802928 <__umoddi3+0x48>
  802911:	39 fe                	cmp    %edi,%esi
  802913:	76 4b                	jbe    802960 <__umoddi3+0x80>
  802915:	89 c8                	mov    %ecx,%eax
  802917:	89 fa                	mov    %edi,%edx
  802919:	f7 f6                	div    %esi
  80291b:	89 d0                	mov    %edx,%eax
  80291d:	31 d2                	xor    %edx,%edx
  80291f:	83 c4 14             	add    $0x14,%esp
  802922:	5e                   	pop    %esi
  802923:	5f                   	pop    %edi
  802924:	5d                   	pop    %ebp
  802925:	c3                   	ret    
  802926:	66 90                	xchg   %ax,%ax
  802928:	39 f8                	cmp    %edi,%eax
  80292a:	77 54                	ja     802980 <__umoddi3+0xa0>
  80292c:	0f bd e8             	bsr    %eax,%ebp
  80292f:	83 f5 1f             	xor    $0x1f,%ebp
  802932:	75 5c                	jne    802990 <__umoddi3+0xb0>
  802934:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802938:	39 3c 24             	cmp    %edi,(%esp)
  80293b:	0f 87 e7 00 00 00    	ja     802a28 <__umoddi3+0x148>
  802941:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802945:	29 f1                	sub    %esi,%ecx
  802947:	19 c7                	sbb    %eax,%edi
  802949:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80294d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802951:	8b 44 24 08          	mov    0x8(%esp),%eax
  802955:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802959:	83 c4 14             	add    $0x14,%esp
  80295c:	5e                   	pop    %esi
  80295d:	5f                   	pop    %edi
  80295e:	5d                   	pop    %ebp
  80295f:	c3                   	ret    
  802960:	85 f6                	test   %esi,%esi
  802962:	89 f5                	mov    %esi,%ebp
  802964:	75 0b                	jne    802971 <__umoddi3+0x91>
  802966:	b8 01 00 00 00       	mov    $0x1,%eax
  80296b:	31 d2                	xor    %edx,%edx
  80296d:	f7 f6                	div    %esi
  80296f:	89 c5                	mov    %eax,%ebp
  802971:	8b 44 24 04          	mov    0x4(%esp),%eax
  802975:	31 d2                	xor    %edx,%edx
  802977:	f7 f5                	div    %ebp
  802979:	89 c8                	mov    %ecx,%eax
  80297b:	f7 f5                	div    %ebp
  80297d:	eb 9c                	jmp    80291b <__umoddi3+0x3b>
  80297f:	90                   	nop
  802980:	89 c8                	mov    %ecx,%eax
  802982:	89 fa                	mov    %edi,%edx
  802984:	83 c4 14             	add    $0x14,%esp
  802987:	5e                   	pop    %esi
  802988:	5f                   	pop    %edi
  802989:	5d                   	pop    %ebp
  80298a:	c3                   	ret    
  80298b:	90                   	nop
  80298c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802990:	8b 04 24             	mov    (%esp),%eax
  802993:	be 20 00 00 00       	mov    $0x20,%esi
  802998:	89 e9                	mov    %ebp,%ecx
  80299a:	29 ee                	sub    %ebp,%esi
  80299c:	d3 e2                	shl    %cl,%edx
  80299e:	89 f1                	mov    %esi,%ecx
  8029a0:	d3 e8                	shr    %cl,%eax
  8029a2:	89 e9                	mov    %ebp,%ecx
  8029a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a8:	8b 04 24             	mov    (%esp),%eax
  8029ab:	09 54 24 04          	or     %edx,0x4(%esp)
  8029af:	89 fa                	mov    %edi,%edx
  8029b1:	d3 e0                	shl    %cl,%eax
  8029b3:	89 f1                	mov    %esi,%ecx
  8029b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029b9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8029bd:	d3 ea                	shr    %cl,%edx
  8029bf:	89 e9                	mov    %ebp,%ecx
  8029c1:	d3 e7                	shl    %cl,%edi
  8029c3:	89 f1                	mov    %esi,%ecx
  8029c5:	d3 e8                	shr    %cl,%eax
  8029c7:	89 e9                	mov    %ebp,%ecx
  8029c9:	09 f8                	or     %edi,%eax
  8029cb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8029cf:	f7 74 24 04          	divl   0x4(%esp)
  8029d3:	d3 e7                	shl    %cl,%edi
  8029d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029d9:	89 d7                	mov    %edx,%edi
  8029db:	f7 64 24 08          	mull   0x8(%esp)
  8029df:	39 d7                	cmp    %edx,%edi
  8029e1:	89 c1                	mov    %eax,%ecx
  8029e3:	89 14 24             	mov    %edx,(%esp)
  8029e6:	72 2c                	jb     802a14 <__umoddi3+0x134>
  8029e8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8029ec:	72 22                	jb     802a10 <__umoddi3+0x130>
  8029ee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8029f2:	29 c8                	sub    %ecx,%eax
  8029f4:	19 d7                	sbb    %edx,%edi
  8029f6:	89 e9                	mov    %ebp,%ecx
  8029f8:	89 fa                	mov    %edi,%edx
  8029fa:	d3 e8                	shr    %cl,%eax
  8029fc:	89 f1                	mov    %esi,%ecx
  8029fe:	d3 e2                	shl    %cl,%edx
  802a00:	89 e9                	mov    %ebp,%ecx
  802a02:	d3 ef                	shr    %cl,%edi
  802a04:	09 d0                	or     %edx,%eax
  802a06:	89 fa                	mov    %edi,%edx
  802a08:	83 c4 14             	add    $0x14,%esp
  802a0b:	5e                   	pop    %esi
  802a0c:	5f                   	pop    %edi
  802a0d:	5d                   	pop    %ebp
  802a0e:	c3                   	ret    
  802a0f:	90                   	nop
  802a10:	39 d7                	cmp    %edx,%edi
  802a12:	75 da                	jne    8029ee <__umoddi3+0x10e>
  802a14:	8b 14 24             	mov    (%esp),%edx
  802a17:	89 c1                	mov    %eax,%ecx
  802a19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802a1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802a21:	eb cb                	jmp    8029ee <__umoddi3+0x10e>
  802a23:	90                   	nop
  802a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802a2c:	0f 82 0f ff ff ff    	jb     802941 <__umoddi3+0x61>
  802a32:	e9 1a ff ff ff       	jmp    802951 <__umoddi3+0x71>
