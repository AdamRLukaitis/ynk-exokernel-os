
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 95 01 00 00       	call   8001c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 30             	sub    $0x30,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	e9 84 00 00 00       	jmp    8000ca <num+0x97>
		if (bol) {
  800046:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  80004d:	74 27                	je     800076 <num+0x43>
			printf("%5d ", ++line);
  80004f:	a1 00 40 80 00       	mov    0x804000,%eax
  800054:	83 c0 01             	add    $0x1,%eax
  800057:	a3 00 40 80 00       	mov    %eax,0x804000
  80005c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800060:	c7 04 24 80 28 80 00 	movl   $0x802880,(%esp)
  800067:	e8 c7 19 00 00       	call   801a33 <printf>
			bol = 0;
  80006c:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800073:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  800076:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80007d:	00 
  80007e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800082:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800089:	e8 f9 13 00 00       	call   801487 <write>
  80008e:	83 f8 01             	cmp    $0x1,%eax
  800091:	74 27                	je     8000ba <num+0x87>
			panic("write error copying %s: %e", s, r);
  800093:	89 44 24 10          	mov    %eax,0x10(%esp)
  800097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80009a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80009e:	c7 44 24 08 85 28 80 	movl   $0x802885,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000ad:	00 
  8000ae:	c7 04 24 a0 28 80 00 	movl   $0x8028a0,(%esp)
  8000b5:	e8 77 01 00 00       	call   800231 <_panic>
		if (c == '\n')
  8000ba:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  8000be:	75 0a                	jne    8000ca <num+0x97>
			bol = 1;
  8000c0:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c7:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000ca:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d1:	00 
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	89 34 24             	mov    %esi,(%esp)
  8000d9:	e8 cc 12 00 00       	call   8013aa <read>
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 8f 60 ff ff ff    	jg     800046 <num+0x13>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	79 27                	jns    800111 <num+0xde>
		panic("error reading %s: %e", s, n);
  8000ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f5:	c7 44 24 08 ab 28 80 	movl   $0x8028ab,0x8(%esp)
  8000fc:	00 
  8000fd:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800104:	00 
  800105:	c7 04 24 a0 28 80 00 	movl   $0x8028a0,(%esp)
  80010c:	e8 20 01 00 00       	call   800231 <_panic>
}
  800111:	83 c4 30             	add    $0x30,%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5d                   	pop    %ebp
  800117:	c3                   	ret    

00800118 <umain>:

void
umain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 2c             	sub    $0x2c,%esp
	int f, i;

	binaryname = "num";
  800121:	c7 05 04 30 80 00 c0 	movl   $0x8028c0,0x803004
  800128:	28 80 00 
	if (argc == 1)
  80012b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80012f:	74 0d                	je     80013e <umain+0x26>
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8d 58 04             	lea    0x4(%eax),%ebx
  800137:	bf 01 00 00 00       	mov    $0x1,%edi
  80013c:	eb 76                	jmp    8001b4 <umain+0x9c>
		num(0, "<stdin>");
  80013e:	c7 44 24 04 c4 28 80 	movl   $0x8028c4,0x4(%esp)
  800145:	00 
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 e1 fe ff ff       	call   800033 <num>
  800152:	eb 65                	jmp    8001b9 <umain+0xa1>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800154:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800157:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80015e:	00 
  80015f:	8b 03                	mov    (%ebx),%eax
  800161:	89 04 24             	mov    %eax,(%esp)
  800164:	e8 1a 17 00 00       	call   801883 <open>
  800169:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80016b:	85 c0                	test   %eax,%eax
  80016d:	79 29                	jns    800198 <umain+0x80>
				panic("can't open %s: %e", argv[i], f);
  80016f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800176:	8b 00                	mov    (%eax),%eax
  800178:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80017c:	c7 44 24 08 cc 28 80 	movl   $0x8028cc,0x8(%esp)
  800183:	00 
  800184:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80018b:	00 
  80018c:	c7 04 24 a0 28 80 00 	movl   $0x8028a0,(%esp)
  800193:	e8 99 00 00 00       	call   800231 <_panic>
			else {
				num(f, argv[i]);
  800198:	8b 03                	mov    (%ebx),%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	89 34 24             	mov    %esi,(%esp)
  8001a1:	e8 8d fe ff ff       	call   800033 <num>
				close(f);
  8001a6:	89 34 24             	mov    %esi,(%esp)
  8001a9:	e8 99 10 00 00       	call   801247 <close>

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001ae:	83 c7 01             	add    $0x1,%edi
  8001b1:	83 c3 04             	add    $0x4,%ebx
  8001b4:	3b 7d 08             	cmp    0x8(%ebp),%edi
  8001b7:	7c 9b                	jl     800154 <umain+0x3c>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001b9:	e8 5a 00 00 00       	call   800218 <exit>
}
  8001be:	83 c4 2c             	add    $0x2c,%esp
  8001c1:	5b                   	pop    %ebx
  8001c2:	5e                   	pop    %esi
  8001c3:	5f                   	pop    %edi
  8001c4:	5d                   	pop    %ebp
  8001c5:	c3                   	ret    

008001c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 10             	sub    $0x10,%esp
  8001ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001d4:	c7 05 0c 40 80 00 00 	movl   $0x0,0x80400c
  8001db:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8001de:	e8 52 0b 00 00       	call   800d35 <sys_getenvid>
  8001e3:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8001e8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f0:	a3 0c 40 80 00       	mov    %eax,0x80400c


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f5:	85 db                	test   %ebx,%ebx
  8001f7:	7e 07                	jle    800200 <libmain+0x3a>
		binaryname = argv[0];
  8001f9:	8b 06                	mov    (%esi),%eax
  8001fb:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  800200:	89 74 24 04          	mov    %esi,0x4(%esp)
  800204:	89 1c 24             	mov    %ebx,(%esp)
  800207:	e8 0c ff ff ff       	call   800118 <umain>

	// exit gracefully
	exit();
  80020c:	e8 07 00 00 00       	call   800218 <exit>
}
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80021e:	e8 57 10 00 00       	call   80127a <close_all>
	sys_env_destroy(0);
  800223:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80022a:	e8 b4 0a 00 00       	call   800ce3 <sys_env_destroy>
}
  80022f:	c9                   	leave  
  800230:	c3                   	ret    

00800231 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800231:	55                   	push   %ebp
  800232:	89 e5                	mov    %esp,%ebp
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800239:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80023c:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800242:	e8 ee 0a 00 00       	call   800d35 <sys_getenvid>
  800247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80024e:	8b 55 08             	mov    0x8(%ebp),%edx
  800251:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800255:	89 74 24 08          	mov    %esi,0x8(%esp)
  800259:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025d:	c7 04 24 e8 28 80 00 	movl   $0x8028e8,(%esp)
  800264:	e8 c1 00 00 00       	call   80032a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800269:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	89 04 24             	mov    %eax,(%esp)
  800273:	e8 51 00 00 00       	call   8002c9 <vcprintf>
	cprintf("\n");
  800278:	c7 04 24 44 2d 80 00 	movl   $0x802d44,(%esp)
  80027f:	e8 a6 00 00 00       	call   80032a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800284:	cc                   	int3   
  800285:	eb fd                	jmp    800284 <_panic+0x53>

00800287 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	53                   	push   %ebx
  80028b:	83 ec 14             	sub    $0x14,%esp
  80028e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800291:	8b 13                	mov    (%ebx),%edx
  800293:	8d 42 01             	lea    0x1(%edx),%eax
  800296:	89 03                	mov    %eax,(%ebx)
  800298:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80029b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80029f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002a4:	75 19                	jne    8002bf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002a6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002ad:	00 
  8002ae:	8d 43 08             	lea    0x8(%ebx),%eax
  8002b1:	89 04 24             	mov    %eax,(%esp)
  8002b4:	e8 ed 09 00 00       	call   800ca6 <sys_cputs>
		b->idx = 0;
  8002b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002bf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002c3:	83 c4 14             	add    $0x14,%esp
  8002c6:	5b                   	pop    %ebx
  8002c7:	5d                   	pop    %ebp
  8002c8:	c3                   	ret    

008002c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002d9:	00 00 00 
	b.cnt = 0;
  8002dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002e3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002fe:	c7 04 24 87 02 80 00 	movl   $0x800287,(%esp)
  800305:	e8 b4 01 00 00       	call   8004be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80030a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800310:	89 44 24 04          	mov    %eax,0x4(%esp)
  800314:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80031a:	89 04 24             	mov    %eax,(%esp)
  80031d:	e8 84 09 00 00       	call   800ca6 <sys_cputs>

	return b.cnt;
}
  800322:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800328:	c9                   	leave  
  800329:	c3                   	ret    

0080032a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80032a:	55                   	push   %ebp
  80032b:	89 e5                	mov    %esp,%ebp
  80032d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800330:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800333:	89 44 24 04          	mov    %eax,0x4(%esp)
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	89 04 24             	mov    %eax,(%esp)
  80033d:	e8 87 ff ff ff       	call   8002c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800342:	c9                   	leave  
  800343:	c3                   	ret    
  800344:	66 90                	xchg   %ax,%ax
  800346:	66 90                	xchg   %ax,%ax
  800348:	66 90                	xchg   %ax,%ax
  80034a:	66 90                	xchg   %ax,%ax
  80034c:	66 90                	xchg   %ax,%ax
  80034e:	66 90                	xchg   %ax,%ax

00800350 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	57                   	push   %edi
  800354:	56                   	push   %esi
  800355:	53                   	push   %ebx
  800356:	83 ec 3c             	sub    $0x3c,%esp
  800359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035c:	89 d7                	mov    %edx,%edi
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800364:	8b 45 0c             	mov    0xc(%ebp),%eax
  800367:	89 c3                	mov    %eax,%ebx
  800369:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80036c:	8b 45 10             	mov    0x10(%ebp),%eax
  80036f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800372:	b9 00 00 00 00       	mov    $0x0,%ecx
  800377:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80037a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80037d:	39 d9                	cmp    %ebx,%ecx
  80037f:	72 05                	jb     800386 <printnum+0x36>
  800381:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800384:	77 69                	ja     8003ef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800386:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800389:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80038d:	83 ee 01             	sub    $0x1,%esi
  800390:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800394:	89 44 24 08          	mov    %eax,0x8(%esp)
  800398:	8b 44 24 08          	mov    0x8(%esp),%eax
  80039c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003a0:	89 c3                	mov    %eax,%ebx
  8003a2:	89 d6                	mov    %edx,%esi
  8003a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003ae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b5:	89 04 24             	mov    %eax,(%esp)
  8003b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003bf:	e8 1c 22 00 00       	call   8025e0 <__udivdi3>
  8003c4:	89 d9                	mov    %ebx,%ecx
  8003c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003ce:	89 04 24             	mov    %eax,(%esp)
  8003d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003d5:	89 fa                	mov    %edi,%edx
  8003d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003da:	e8 71 ff ff ff       	call   800350 <printnum>
  8003df:	eb 1b                	jmp    8003fc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003e8:	89 04 24             	mov    %eax,(%esp)
  8003eb:	ff d3                	call   *%ebx
  8003ed:	eb 03                	jmp    8003f2 <printnum+0xa2>
  8003ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003f2:	83 ee 01             	sub    $0x1,%esi
  8003f5:	85 f6                	test   %esi,%esi
  8003f7:	7f e8                	jg     8003e1 <printnum+0x91>
  8003f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800400:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800404:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800407:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80040a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80040e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800412:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800415:	89 04 24             	mov    %eax,(%esp)
  800418:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80041b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041f:	e8 ec 22 00 00       	call   802710 <__umoddi3>
  800424:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800428:	0f be 80 0b 29 80 00 	movsbl 0x80290b(%eax),%eax
  80042f:	89 04 24             	mov    %eax,(%esp)
  800432:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800435:	ff d0                	call   *%eax
}
  800437:	83 c4 3c             	add    $0x3c,%esp
  80043a:	5b                   	pop    %ebx
  80043b:	5e                   	pop    %esi
  80043c:	5f                   	pop    %edi
  80043d:	5d                   	pop    %ebp
  80043e:	c3                   	ret    

0080043f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800442:	83 fa 01             	cmp    $0x1,%edx
  800445:	7e 0e                	jle    800455 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800447:	8b 10                	mov    (%eax),%edx
  800449:	8d 4a 08             	lea    0x8(%edx),%ecx
  80044c:	89 08                	mov    %ecx,(%eax)
  80044e:	8b 02                	mov    (%edx),%eax
  800450:	8b 52 04             	mov    0x4(%edx),%edx
  800453:	eb 22                	jmp    800477 <getuint+0x38>
	else if (lflag)
  800455:	85 d2                	test   %edx,%edx
  800457:	74 10                	je     800469 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800459:	8b 10                	mov    (%eax),%edx
  80045b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80045e:	89 08                	mov    %ecx,(%eax)
  800460:	8b 02                	mov    (%edx),%eax
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
  800467:	eb 0e                	jmp    800477 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800469:	8b 10                	mov    (%eax),%edx
  80046b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80046e:	89 08                	mov    %ecx,(%eax)
  800470:	8b 02                	mov    (%edx),%eax
  800472:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800477:	5d                   	pop    %ebp
  800478:	c3                   	ret    

00800479 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80047f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800483:	8b 10                	mov    (%eax),%edx
  800485:	3b 50 04             	cmp    0x4(%eax),%edx
  800488:	73 0a                	jae    800494 <sprintputch+0x1b>
		*b->buf++ = ch;
  80048a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80048d:	89 08                	mov    %ecx,(%eax)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	88 02                	mov    %al,(%edx)
}
  800494:	5d                   	pop    %ebp
  800495:	c3                   	ret    

00800496 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80049c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80049f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	89 04 24             	mov    %eax,(%esp)
  8004b7:	e8 02 00 00 00       	call   8004be <vprintfmt>
	va_end(ap);
}
  8004bc:	c9                   	leave  
  8004bd:	c3                   	ret    

008004be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	57                   	push   %edi
  8004c2:	56                   	push   %esi
  8004c3:	53                   	push   %ebx
  8004c4:	83 ec 3c             	sub    $0x3c,%esp
  8004c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004cd:	eb 14                	jmp    8004e3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004cf:	85 c0                	test   %eax,%eax
  8004d1:	0f 84 b3 03 00 00    	je     80088a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004db:	89 04 24             	mov    %eax,(%esp)
  8004de:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e1:	89 f3                	mov    %esi,%ebx
  8004e3:	8d 73 01             	lea    0x1(%ebx),%esi
  8004e6:	0f b6 03             	movzbl (%ebx),%eax
  8004e9:	83 f8 25             	cmp    $0x25,%eax
  8004ec:	75 e1                	jne    8004cf <vprintfmt+0x11>
  8004ee:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800500:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800507:	ba 00 00 00 00       	mov    $0x0,%edx
  80050c:	eb 1d                	jmp    80052b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800510:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800514:	eb 15                	jmp    80052b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800516:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800518:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80051c:	eb 0d                	jmp    80052b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80051e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800524:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80052e:	0f b6 0e             	movzbl (%esi),%ecx
  800531:	0f b6 c1             	movzbl %cl,%eax
  800534:	83 e9 23             	sub    $0x23,%ecx
  800537:	80 f9 55             	cmp    $0x55,%cl
  80053a:	0f 87 2a 03 00 00    	ja     80086a <vprintfmt+0x3ac>
  800540:	0f b6 c9             	movzbl %cl,%ecx
  800543:	ff 24 8d 40 2a 80 00 	jmp    *0x802a40(,%ecx,4)
  80054a:	89 de                	mov    %ebx,%esi
  80054c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800551:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800554:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800558:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80055b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80055e:	83 fb 09             	cmp    $0x9,%ebx
  800561:	77 36                	ja     800599 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800563:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800566:	eb e9                	jmp    800551 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 48 04             	lea    0x4(%eax),%ecx
  80056e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800571:	8b 00                	mov    (%eax),%eax
  800573:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800576:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800578:	eb 22                	jmp    80059c <vprintfmt+0xde>
  80057a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80057d:	85 c9                	test   %ecx,%ecx
  80057f:	b8 00 00 00 00       	mov    $0x0,%eax
  800584:	0f 49 c1             	cmovns %ecx,%eax
  800587:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	89 de                	mov    %ebx,%esi
  80058c:	eb 9d                	jmp    80052b <vprintfmt+0x6d>
  80058e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800590:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800597:	eb 92                	jmp    80052b <vprintfmt+0x6d>
  800599:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80059c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005a0:	79 89                	jns    80052b <vprintfmt+0x6d>
  8005a2:	e9 77 ff ff ff       	jmp    80051e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005a7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005ac:	e9 7a ff ff ff       	jmp    80052b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8d 50 04             	lea    0x4(%eax),%edx
  8005b7:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005be:	8b 00                	mov    (%eax),%eax
  8005c0:	89 04 24             	mov    %eax,(%esp)
  8005c3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005c6:	e9 18 ff ff ff       	jmp    8004e3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ce:	8d 50 04             	lea    0x4(%eax),%edx
  8005d1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d4:	8b 00                	mov    (%eax),%eax
  8005d6:	99                   	cltd   
  8005d7:	31 d0                	xor    %edx,%eax
  8005d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005db:	83 f8 0f             	cmp    $0xf,%eax
  8005de:	7f 0b                	jg     8005eb <vprintfmt+0x12d>
  8005e0:	8b 14 85 a0 2b 80 00 	mov    0x802ba0(,%eax,4),%edx
  8005e7:	85 d2                	test   %edx,%edx
  8005e9:	75 20                	jne    80060b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8005eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ef:	c7 44 24 08 23 29 80 	movl   $0x802923,0x8(%esp)
  8005f6:	00 
  8005f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	e8 90 fe ff ff       	call   800496 <printfmt>
  800606:	e9 d8 fe ff ff       	jmp    8004e3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80060b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80060f:	c7 44 24 08 d9 2c 80 	movl   $0x802cd9,0x8(%esp)
  800616:	00 
  800617:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	89 04 24             	mov    %eax,(%esp)
  800621:	e8 70 fe ff ff       	call   800496 <printfmt>
  800626:	e9 b8 fe ff ff       	jmp    8004e3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80062e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800631:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8d 50 04             	lea    0x4(%eax),%edx
  80063a:	89 55 14             	mov    %edx,0x14(%ebp)
  80063d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80063f:	85 f6                	test   %esi,%esi
  800641:	b8 1c 29 80 00       	mov    $0x80291c,%eax
  800646:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800649:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80064d:	0f 84 97 00 00 00    	je     8006ea <vprintfmt+0x22c>
  800653:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800657:	0f 8e 9b 00 00 00    	jle    8006f8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80065d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800661:	89 34 24             	mov    %esi,(%esp)
  800664:	e8 cf 02 00 00       	call   800938 <strnlen>
  800669:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80066c:	29 c2                	sub    %eax,%edx
  80066e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800671:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800675:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800678:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80067b:	8b 75 08             	mov    0x8(%ebp),%esi
  80067e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800681:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800683:	eb 0f                	jmp    800694 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800685:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80068c:	89 04 24             	mov    %eax,(%esp)
  80068f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800691:	83 eb 01             	sub    $0x1,%ebx
  800694:	85 db                	test   %ebx,%ebx
  800696:	7f ed                	jg     800685 <vprintfmt+0x1c7>
  800698:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80069b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80069e:	85 d2                	test   %edx,%edx
  8006a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006a5:	0f 49 c2             	cmovns %edx,%eax
  8006a8:	29 c2                	sub    %eax,%edx
  8006aa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006ad:	89 d7                	mov    %edx,%edi
  8006af:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006b2:	eb 50                	jmp    800704 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b8:	74 1e                	je     8006d8 <vprintfmt+0x21a>
  8006ba:	0f be d2             	movsbl %dl,%edx
  8006bd:	83 ea 20             	sub    $0x20,%edx
  8006c0:	83 fa 5e             	cmp    $0x5e,%edx
  8006c3:	76 13                	jbe    8006d8 <vprintfmt+0x21a>
					putch('?', putdat);
  8006c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006cc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006d3:	ff 55 08             	call   *0x8(%ebp)
  8006d6:	eb 0d                	jmp    8006e5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006df:	89 04 24             	mov    %eax,(%esp)
  8006e2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e5:	83 ef 01             	sub    $0x1,%edi
  8006e8:	eb 1a                	jmp    800704 <vprintfmt+0x246>
  8006ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006ed:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006f0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006f3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006f6:	eb 0c                	jmp    800704 <vprintfmt+0x246>
  8006f8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006fb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800701:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800704:	83 c6 01             	add    $0x1,%esi
  800707:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80070b:	0f be c2             	movsbl %dl,%eax
  80070e:	85 c0                	test   %eax,%eax
  800710:	74 27                	je     800739 <vprintfmt+0x27b>
  800712:	85 db                	test   %ebx,%ebx
  800714:	78 9e                	js     8006b4 <vprintfmt+0x1f6>
  800716:	83 eb 01             	sub    $0x1,%ebx
  800719:	79 99                	jns    8006b4 <vprintfmt+0x1f6>
  80071b:	89 f8                	mov    %edi,%eax
  80071d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800720:	8b 75 08             	mov    0x8(%ebp),%esi
  800723:	89 c3                	mov    %eax,%ebx
  800725:	eb 1a                	jmp    800741 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800727:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800732:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800734:	83 eb 01             	sub    $0x1,%ebx
  800737:	eb 08                	jmp    800741 <vprintfmt+0x283>
  800739:	89 fb                	mov    %edi,%ebx
  80073b:	8b 75 08             	mov    0x8(%ebp),%esi
  80073e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800741:	85 db                	test   %ebx,%ebx
  800743:	7f e2                	jg     800727 <vprintfmt+0x269>
  800745:	89 75 08             	mov    %esi,0x8(%ebp)
  800748:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80074b:	e9 93 fd ff ff       	jmp    8004e3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800750:	83 fa 01             	cmp    $0x1,%edx
  800753:	7e 16                	jle    80076b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8d 50 08             	lea    0x8(%eax),%edx
  80075b:	89 55 14             	mov    %edx,0x14(%ebp)
  80075e:	8b 50 04             	mov    0x4(%eax),%edx
  800761:	8b 00                	mov    (%eax),%eax
  800763:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800766:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800769:	eb 32                	jmp    80079d <vprintfmt+0x2df>
	else if (lflag)
  80076b:	85 d2                	test   %edx,%edx
  80076d:	74 18                	je     800787 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8d 50 04             	lea    0x4(%eax),%edx
  800775:	89 55 14             	mov    %edx,0x14(%ebp)
  800778:	8b 30                	mov    (%eax),%esi
  80077a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80077d:	89 f0                	mov    %esi,%eax
  80077f:	c1 f8 1f             	sar    $0x1f,%eax
  800782:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800785:	eb 16                	jmp    80079d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 50 04             	lea    0x4(%eax),%edx
  80078d:	89 55 14             	mov    %edx,0x14(%ebp)
  800790:	8b 30                	mov    (%eax),%esi
  800792:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800795:	89 f0                	mov    %esi,%eax
  800797:	c1 f8 1f             	sar    $0x1f,%eax
  80079a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80079d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ac:	0f 89 80 00 00 00    	jns    800832 <vprintfmt+0x374>
				putch('-', putdat);
  8007b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007bd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007c6:	f7 d8                	neg    %eax
  8007c8:	83 d2 00             	adc    $0x0,%edx
  8007cb:	f7 da                	neg    %edx
			}
			base = 10;
  8007cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007d2:	eb 5e                	jmp    800832 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d7:	e8 63 fc ff ff       	call   80043f <getuint>
			base = 10;
  8007dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007e1:	eb 4f                	jmp    800832 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  8007e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e6:	e8 54 fc ff ff       	call   80043f <getuint>
			base =8;
  8007eb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007f0:	eb 40                	jmp    800832 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  8007f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007fd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800800:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800804:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80080b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80080e:	8b 45 14             	mov    0x14(%ebp),%eax
  800811:	8d 50 04             	lea    0x4(%eax),%edx
  800814:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800817:	8b 00                	mov    (%eax),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80081e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800823:	eb 0d                	jmp    800832 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800825:	8d 45 14             	lea    0x14(%ebp),%eax
  800828:	e8 12 fc ff ff       	call   80043f <getuint>
			base = 16;
  80082d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800832:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800836:	89 74 24 10          	mov    %esi,0x10(%esp)
  80083a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80083d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800841:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800845:	89 04 24             	mov    %eax,(%esp)
  800848:	89 54 24 04          	mov    %edx,0x4(%esp)
  80084c:	89 fa                	mov    %edi,%edx
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	e8 fa fa ff ff       	call   800350 <printnum>
			break;
  800856:	e9 88 fc ff ff       	jmp    8004e3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80085f:	89 04 24             	mov    %eax,(%esp)
  800862:	ff 55 08             	call   *0x8(%ebp)
			break;
  800865:	e9 79 fc ff ff       	jmp    8004e3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80086a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80086e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800875:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800878:	89 f3                	mov    %esi,%ebx
  80087a:	eb 03                	jmp    80087f <vprintfmt+0x3c1>
  80087c:	83 eb 01             	sub    $0x1,%ebx
  80087f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800883:	75 f7                	jne    80087c <vprintfmt+0x3be>
  800885:	e9 59 fc ff ff       	jmp    8004e3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80088a:	83 c4 3c             	add    $0x3c,%esp
  80088d:	5b                   	pop    %ebx
  80088e:	5e                   	pop    %esi
  80088f:	5f                   	pop    %edi
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	83 ec 28             	sub    $0x28,%esp
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80089e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008a5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	74 30                	je     8008e3 <vsnprintf+0x51>
  8008b3:	85 d2                	test   %edx,%edx
  8008b5:	7e 2c                	jle    8008e3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008be:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cc:	c7 04 24 79 04 80 00 	movl   $0x800479,(%esp)
  8008d3:	e8 e6 fb ff ff       	call   8004be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e1:	eb 05                	jmp    8008e8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008e8:	c9                   	leave  
  8008e9:	c3                   	ret    

008008ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008f0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800901:	89 44 24 04          	mov    %eax,0x4(%esp)
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	89 04 24             	mov    %eax,(%esp)
  80090b:	e8 82 ff ff ff       	call   800892 <vsnprintf>
	va_end(ap);

	return rc;
}
  800910:	c9                   	leave  
  800911:	c3                   	ret    
  800912:	66 90                	xchg   %ax,%ax
  800914:	66 90                	xchg   %ax,%ax
  800916:	66 90                	xchg   %ax,%ax
  800918:	66 90                	xchg   %ax,%ax
  80091a:	66 90                	xchg   %ax,%ax
  80091c:	66 90                	xchg   %ax,%ax
  80091e:	66 90                	xchg   %ax,%ax

00800920 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800926:	b8 00 00 00 00       	mov    $0x0,%eax
  80092b:	eb 03                	jmp    800930 <strlen+0x10>
		n++;
  80092d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800930:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800934:	75 f7                	jne    80092d <strlen+0xd>
		n++;
	return n;
}
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
  800946:	eb 03                	jmp    80094b <strnlen+0x13>
		n++;
  800948:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80094b:	39 d0                	cmp    %edx,%eax
  80094d:	74 06                	je     800955 <strnlen+0x1d>
  80094f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800953:	75 f3                	jne    800948 <strnlen+0x10>
		n++;
	return n;
}
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800961:	89 c2                	mov    %eax,%edx
  800963:	83 c2 01             	add    $0x1,%edx
  800966:	83 c1 01             	add    $0x1,%ecx
  800969:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80096d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800970:	84 db                	test   %bl,%bl
  800972:	75 ef                	jne    800963 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800974:	5b                   	pop    %ebx
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	83 ec 08             	sub    $0x8,%esp
  80097e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800981:	89 1c 24             	mov    %ebx,(%esp)
  800984:	e8 97 ff ff ff       	call   800920 <strlen>
	strcpy(dst + len, src);
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800990:	01 d8                	add    %ebx,%eax
  800992:	89 04 24             	mov    %eax,(%esp)
  800995:	e8 bd ff ff ff       	call   800957 <strcpy>
	return dst;
}
  80099a:	89 d8                	mov    %ebx,%eax
  80099c:	83 c4 08             	add    $0x8,%esp
  80099f:	5b                   	pop    %ebx
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	56                   	push   %esi
  8009a6:	53                   	push   %ebx
  8009a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ad:	89 f3                	mov    %esi,%ebx
  8009af:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b2:	89 f2                	mov    %esi,%edx
  8009b4:	eb 0f                	jmp    8009c5 <strncpy+0x23>
		*dst++ = *src;
  8009b6:	83 c2 01             	add    $0x1,%edx
  8009b9:	0f b6 01             	movzbl (%ecx),%eax
  8009bc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009bf:	80 39 01             	cmpb   $0x1,(%ecx)
  8009c2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c5:	39 da                	cmp    %ebx,%edx
  8009c7:	75 ed                	jne    8009b6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009c9:	89 f0                	mov    %esi,%eax
  8009cb:	5b                   	pop    %ebx
  8009cc:	5e                   	pop    %esi
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	56                   	push   %esi
  8009d3:	53                   	push   %ebx
  8009d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009dd:	89 f0                	mov    %esi,%eax
  8009df:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e3:	85 c9                	test   %ecx,%ecx
  8009e5:	75 0b                	jne    8009f2 <strlcpy+0x23>
  8009e7:	eb 1d                	jmp    800a06 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009e9:	83 c0 01             	add    $0x1,%eax
  8009ec:	83 c2 01             	add    $0x1,%edx
  8009ef:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f2:	39 d8                	cmp    %ebx,%eax
  8009f4:	74 0b                	je     800a01 <strlcpy+0x32>
  8009f6:	0f b6 0a             	movzbl (%edx),%ecx
  8009f9:	84 c9                	test   %cl,%cl
  8009fb:	75 ec                	jne    8009e9 <strlcpy+0x1a>
  8009fd:	89 c2                	mov    %eax,%edx
  8009ff:	eb 02                	jmp    800a03 <strlcpy+0x34>
  800a01:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a03:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a06:	29 f0                	sub    %esi,%eax
}
  800a08:	5b                   	pop    %ebx
  800a09:	5e                   	pop    %esi
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a15:	eb 06                	jmp    800a1d <strcmp+0x11>
		p++, q++;
  800a17:	83 c1 01             	add    $0x1,%ecx
  800a1a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a1d:	0f b6 01             	movzbl (%ecx),%eax
  800a20:	84 c0                	test   %al,%al
  800a22:	74 04                	je     800a28 <strcmp+0x1c>
  800a24:	3a 02                	cmp    (%edx),%al
  800a26:	74 ef                	je     800a17 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a28:	0f b6 c0             	movzbl %al,%eax
  800a2b:	0f b6 12             	movzbl (%edx),%edx
  800a2e:	29 d0                	sub    %edx,%eax
}
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	53                   	push   %ebx
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3c:	89 c3                	mov    %eax,%ebx
  800a3e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a41:	eb 06                	jmp    800a49 <strncmp+0x17>
		n--, p++, q++;
  800a43:	83 c0 01             	add    $0x1,%eax
  800a46:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a49:	39 d8                	cmp    %ebx,%eax
  800a4b:	74 15                	je     800a62 <strncmp+0x30>
  800a4d:	0f b6 08             	movzbl (%eax),%ecx
  800a50:	84 c9                	test   %cl,%cl
  800a52:	74 04                	je     800a58 <strncmp+0x26>
  800a54:	3a 0a                	cmp    (%edx),%cl
  800a56:	74 eb                	je     800a43 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a58:	0f b6 00             	movzbl (%eax),%eax
  800a5b:	0f b6 12             	movzbl (%edx),%edx
  800a5e:	29 d0                	sub    %edx,%eax
  800a60:	eb 05                	jmp    800a67 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a62:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a67:	5b                   	pop    %ebx
  800a68:	5d                   	pop    %ebp
  800a69:	c3                   	ret    

00800a6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a74:	eb 07                	jmp    800a7d <strchr+0x13>
		if (*s == c)
  800a76:	38 ca                	cmp    %cl,%dl
  800a78:	74 0f                	je     800a89 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a7a:	83 c0 01             	add    $0x1,%eax
  800a7d:	0f b6 10             	movzbl (%eax),%edx
  800a80:	84 d2                	test   %dl,%dl
  800a82:	75 f2                	jne    800a76 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a95:	eb 07                	jmp    800a9e <strfind+0x13>
		if (*s == c)
  800a97:	38 ca                	cmp    %cl,%dl
  800a99:	74 0a                	je     800aa5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a9b:	83 c0 01             	add    $0x1,%eax
  800a9e:	0f b6 10             	movzbl (%eax),%edx
  800aa1:	84 d2                	test   %dl,%dl
  800aa3:	75 f2                	jne    800a97 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	57                   	push   %edi
  800aab:	56                   	push   %esi
  800aac:	53                   	push   %ebx
  800aad:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ab0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ab3:	85 c9                	test   %ecx,%ecx
  800ab5:	74 36                	je     800aed <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ab7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800abd:	75 28                	jne    800ae7 <memset+0x40>
  800abf:	f6 c1 03             	test   $0x3,%cl
  800ac2:	75 23                	jne    800ae7 <memset+0x40>
		c &= 0xFF;
  800ac4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ac8:	89 d3                	mov    %edx,%ebx
  800aca:	c1 e3 08             	shl    $0x8,%ebx
  800acd:	89 d6                	mov    %edx,%esi
  800acf:	c1 e6 18             	shl    $0x18,%esi
  800ad2:	89 d0                	mov    %edx,%eax
  800ad4:	c1 e0 10             	shl    $0x10,%eax
  800ad7:	09 f0                	or     %esi,%eax
  800ad9:	09 c2                	or     %eax,%edx
  800adb:	89 d0                	mov    %edx,%eax
  800add:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800adf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ae2:	fc                   	cld    
  800ae3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ae5:	eb 06                	jmp    800aed <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	fc                   	cld    
  800aeb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800aed:	89 f8                	mov    %edi,%eax
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b02:	39 c6                	cmp    %eax,%esi
  800b04:	73 35                	jae    800b3b <memmove+0x47>
  800b06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b09:	39 d0                	cmp    %edx,%eax
  800b0b:	73 2e                	jae    800b3b <memmove+0x47>
		s += n;
		d += n;
  800b0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b10:	89 d6                	mov    %edx,%esi
  800b12:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b1a:	75 13                	jne    800b2f <memmove+0x3b>
  800b1c:	f6 c1 03             	test   $0x3,%cl
  800b1f:	75 0e                	jne    800b2f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b21:	83 ef 04             	sub    $0x4,%edi
  800b24:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b27:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b2a:	fd                   	std    
  800b2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2d:	eb 09                	jmp    800b38 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b2f:	83 ef 01             	sub    $0x1,%edi
  800b32:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b35:	fd                   	std    
  800b36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b38:	fc                   	cld    
  800b39:	eb 1d                	jmp    800b58 <memmove+0x64>
  800b3b:	89 f2                	mov    %esi,%edx
  800b3d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3f:	f6 c2 03             	test   $0x3,%dl
  800b42:	75 0f                	jne    800b53 <memmove+0x5f>
  800b44:	f6 c1 03             	test   $0x3,%cl
  800b47:	75 0a                	jne    800b53 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b49:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b4c:	89 c7                	mov    %eax,%edi
  800b4e:	fc                   	cld    
  800b4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b51:	eb 05                	jmp    800b58 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b53:	89 c7                	mov    %eax,%edi
  800b55:	fc                   	cld    
  800b56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 04 24             	mov    %eax,(%esp)
  800b76:	e8 79 ff ff ff       	call   800af4 <memmove>
}
  800b7b:	c9                   	leave  
  800b7c:	c3                   	ret    

00800b7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
  800b82:	8b 55 08             	mov    0x8(%ebp),%edx
  800b85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b88:	89 d6                	mov    %edx,%esi
  800b8a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b8d:	eb 1a                	jmp    800ba9 <memcmp+0x2c>
		if (*s1 != *s2)
  800b8f:	0f b6 02             	movzbl (%edx),%eax
  800b92:	0f b6 19             	movzbl (%ecx),%ebx
  800b95:	38 d8                	cmp    %bl,%al
  800b97:	74 0a                	je     800ba3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b99:	0f b6 c0             	movzbl %al,%eax
  800b9c:	0f b6 db             	movzbl %bl,%ebx
  800b9f:	29 d8                	sub    %ebx,%eax
  800ba1:	eb 0f                	jmp    800bb2 <memcmp+0x35>
		s1++, s2++;
  800ba3:	83 c2 01             	add    $0x1,%edx
  800ba6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ba9:	39 f2                	cmp    %esi,%edx
  800bab:	75 e2                	jne    800b8f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bb2:	5b                   	pop    %ebx
  800bb3:	5e                   	pop    %esi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bbf:	89 c2                	mov    %eax,%edx
  800bc1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc4:	eb 07                	jmp    800bcd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc6:	38 08                	cmp    %cl,(%eax)
  800bc8:	74 07                	je     800bd1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bca:	83 c0 01             	add    $0x1,%eax
  800bcd:	39 d0                	cmp    %edx,%eax
  800bcf:	72 f5                	jb     800bc6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bdf:	eb 03                	jmp    800be4 <strtol+0x11>
		s++;
  800be1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800be4:	0f b6 0a             	movzbl (%edx),%ecx
  800be7:	80 f9 09             	cmp    $0x9,%cl
  800bea:	74 f5                	je     800be1 <strtol+0xe>
  800bec:	80 f9 20             	cmp    $0x20,%cl
  800bef:	74 f0                	je     800be1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bf1:	80 f9 2b             	cmp    $0x2b,%cl
  800bf4:	75 0a                	jne    800c00 <strtol+0x2d>
		s++;
  800bf6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bf9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfe:	eb 11                	jmp    800c11 <strtol+0x3e>
  800c00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c05:	80 f9 2d             	cmp    $0x2d,%cl
  800c08:	75 07                	jne    800c11 <strtol+0x3e>
		s++, neg = 1;
  800c0a:	8d 52 01             	lea    0x1(%edx),%edx
  800c0d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c11:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c16:	75 15                	jne    800c2d <strtol+0x5a>
  800c18:	80 3a 30             	cmpb   $0x30,(%edx)
  800c1b:	75 10                	jne    800c2d <strtol+0x5a>
  800c1d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c21:	75 0a                	jne    800c2d <strtol+0x5a>
		s += 2, base = 16;
  800c23:	83 c2 02             	add    $0x2,%edx
  800c26:	b8 10 00 00 00       	mov    $0x10,%eax
  800c2b:	eb 10                	jmp    800c3d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c2d:	85 c0                	test   %eax,%eax
  800c2f:	75 0c                	jne    800c3d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c31:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c33:	80 3a 30             	cmpb   $0x30,(%edx)
  800c36:	75 05                	jne    800c3d <strtol+0x6a>
		s++, base = 8;
  800c38:	83 c2 01             	add    $0x1,%edx
  800c3b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c42:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c45:	0f b6 0a             	movzbl (%edx),%ecx
  800c48:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c4b:	89 f0                	mov    %esi,%eax
  800c4d:	3c 09                	cmp    $0x9,%al
  800c4f:	77 08                	ja     800c59 <strtol+0x86>
			dig = *s - '0';
  800c51:	0f be c9             	movsbl %cl,%ecx
  800c54:	83 e9 30             	sub    $0x30,%ecx
  800c57:	eb 20                	jmp    800c79 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c59:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c5c:	89 f0                	mov    %esi,%eax
  800c5e:	3c 19                	cmp    $0x19,%al
  800c60:	77 08                	ja     800c6a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c62:	0f be c9             	movsbl %cl,%ecx
  800c65:	83 e9 57             	sub    $0x57,%ecx
  800c68:	eb 0f                	jmp    800c79 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c6a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c6d:	89 f0                	mov    %esi,%eax
  800c6f:	3c 19                	cmp    $0x19,%al
  800c71:	77 16                	ja     800c89 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c73:	0f be c9             	movsbl %cl,%ecx
  800c76:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c79:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c7c:	7d 0f                	jge    800c8d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c7e:	83 c2 01             	add    $0x1,%edx
  800c81:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c85:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c87:	eb bc                	jmp    800c45 <strtol+0x72>
  800c89:	89 d8                	mov    %ebx,%eax
  800c8b:	eb 02                	jmp    800c8f <strtol+0xbc>
  800c8d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c93:	74 05                	je     800c9a <strtol+0xc7>
		*endptr = (char *) s;
  800c95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c98:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c9a:	f7 d8                	neg    %eax
  800c9c:	85 ff                	test   %edi,%edi
  800c9e:	0f 44 c3             	cmove  %ebx,%eax
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5f                   	pop    %edi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	57                   	push   %edi
  800caa:	56                   	push   %esi
  800cab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cac:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	89 c3                	mov    %eax,%ebx
  800cb9:	89 c7                	mov    %eax,%edi
  800cbb:	89 c6                	mov    %eax,%esi
  800cbd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd4:	89 d1                	mov    %edx,%ecx
  800cd6:	89 d3                	mov    %edx,%ebx
  800cd8:	89 d7                	mov    %edx,%edi
  800cda:	89 d6                	mov    %edx,%esi
  800cdc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	89 cb                	mov    %ecx,%ebx
  800cfb:	89 cf                	mov    %ecx,%edi
  800cfd:	89 ce                	mov    %ecx,%esi
  800cff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7e 28                	jle    800d2d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d05:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d09:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d10:	00 
  800d11:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800d18:	00 
  800d19:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d20:	00 
  800d21:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800d28:	e8 04 f5 ff ff       	call   800231 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d2d:	83 c4 2c             	add    $0x2c,%esp
  800d30:	5b                   	pop    %ebx
  800d31:	5e                   	pop    %esi
  800d32:	5f                   	pop    %edi
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
  800d38:	57                   	push   %edi
  800d39:	56                   	push   %esi
  800d3a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d40:	b8 02 00 00 00       	mov    $0x2,%eax
  800d45:	89 d1                	mov    %edx,%ecx
  800d47:	89 d3                	mov    %edx,%ebx
  800d49:	89 d7                	mov    %edx,%edi
  800d4b:	89 d6                	mov    %edx,%esi
  800d4d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <sys_yield>:

void
sys_yield(void)
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
  800d5f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d64:	89 d1                	mov    %edx,%ecx
  800d66:	89 d3                	mov    %edx,%ebx
  800d68:	89 d7                	mov    %edx,%edi
  800d6a:	89 d6                	mov    %edx,%esi
  800d6c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800d7c:	be 00 00 00 00       	mov    $0x0,%esi
  800d81:	b8 04 00 00 00       	mov    $0x4,%eax
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8f:	89 f7                	mov    %esi,%edi
  800d91:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d93:	85 c0                	test   %eax,%eax
  800d95:	7e 28                	jle    800dbf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d97:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d9b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800da2:	00 
  800da3:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800daa:	00 
  800dab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db2:	00 
  800db3:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800dba:	e8 72 f4 ff ff       	call   800231 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dbf:	83 c4 2c             	add    $0x2c,%esp
  800dc2:	5b                   	pop    %ebx
  800dc3:	5e                   	pop    %esi
  800dc4:	5f                   	pop    %edi
  800dc5:	5d                   	pop    %ebp
  800dc6:	c3                   	ret    

00800dc7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	57                   	push   %edi
  800dcb:	56                   	push   %esi
  800dcc:	53                   	push   %ebx
  800dcd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd0:	b8 05 00 00 00       	mov    $0x5,%eax
  800dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dde:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de1:	8b 75 18             	mov    0x18(%ebp),%esi
  800de4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de6:	85 c0                	test   %eax,%eax
  800de8:	7e 28                	jle    800e12 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dea:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dee:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800df5:	00 
  800df6:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800dfd:	00 
  800dfe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e05:	00 
  800e06:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800e0d:	e8 1f f4 ff ff       	call   800231 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e12:	83 c4 2c             	add    $0x2c,%esp
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    

00800e1a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e28:	b8 06 00 00 00       	mov    $0x6,%eax
  800e2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e30:	8b 55 08             	mov    0x8(%ebp),%edx
  800e33:	89 df                	mov    %ebx,%edi
  800e35:	89 de                	mov    %ebx,%esi
  800e37:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	7e 28                	jle    800e65 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e41:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e48:	00 
  800e49:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800e50:	00 
  800e51:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e58:	00 
  800e59:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800e60:	e8 cc f3 ff ff       	call   800231 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e65:	83 c4 2c             	add    $0x2c,%esp
  800e68:	5b                   	pop    %ebx
  800e69:	5e                   	pop    %esi
  800e6a:	5f                   	pop    %edi
  800e6b:	5d                   	pop    %ebp
  800e6c:	c3                   	ret    

00800e6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	57                   	push   %edi
  800e71:	56                   	push   %esi
  800e72:	53                   	push   %ebx
  800e73:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	89 df                	mov    %ebx,%edi
  800e88:	89 de                	mov    %ebx,%esi
  800e8a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e8c:	85 c0                	test   %eax,%eax
  800e8e:	7e 28                	jle    800eb8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e90:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e94:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e9b:	00 
  800e9c:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800ea3:	00 
  800ea4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eab:	00 
  800eac:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800eb3:	e8 79 f3 ff ff       	call   800231 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800eb8:	83 c4 2c             	add    $0x2c,%esp
  800ebb:	5b                   	pop    %ebx
  800ebc:	5e                   	pop    %esi
  800ebd:	5f                   	pop    %edi
  800ebe:	5d                   	pop    %ebp
  800ebf:	c3                   	ret    

00800ec0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	57                   	push   %edi
  800ec4:	56                   	push   %esi
  800ec5:	53                   	push   %ebx
  800ec6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ece:	b8 09 00 00 00       	mov    $0x9,%eax
  800ed3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	89 df                	mov    %ebx,%edi
  800edb:	89 de                	mov    %ebx,%esi
  800edd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	7e 28                	jle    800f0b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800eee:	00 
  800eef:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800ef6:	00 
  800ef7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efe:	00 
  800eff:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800f06:	e8 26 f3 ff ff       	call   800231 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f0b:	83 c4 2c             	add    $0x2c,%esp
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	89 df                	mov    %ebx,%edi
  800f2e:	89 de                	mov    %ebx,%esi
  800f30:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f32:	85 c0                	test   %eax,%eax
  800f34:	7e 28                	jle    800f5e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f36:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f41:	00 
  800f42:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800f49:	00 
  800f4a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f51:	00 
  800f52:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800f59:	e8 d3 f2 ff ff       	call   800231 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f5e:	83 c4 2c             	add    $0x2c,%esp
  800f61:	5b                   	pop    %ebx
  800f62:	5e                   	pop    %esi
  800f63:	5f                   	pop    %edi
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6c:	be 00 00 00 00       	mov    $0x0,%esi
  800f71:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f82:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	57                   	push   %edi
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f97:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9f:	89 cb                	mov    %ecx,%ebx
  800fa1:	89 cf                	mov    %ecx,%edi
  800fa3:	89 ce                	mov    %ecx,%esi
  800fa5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	7e 28                	jle    800fd3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fab:	89 44 24 10          	mov    %eax,0x10(%esp)
  800faf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fb6:	00 
  800fb7:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  800fbe:	00 
  800fbf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc6:	00 
  800fc7:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  800fce:	e8 5e f2 ff ff       	call   800231 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fd3:	83 c4 2c             	add    $0x2c,%esp
  800fd6:	5b                   	pop    %ebx
  800fd7:	5e                   	pop    %esi
  800fd8:	5f                   	pop    %edi
  800fd9:	5d                   	pop    %ebp
  800fda:	c3                   	ret    

00800fdb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	57                   	push   %edi
  800fdf:	56                   	push   %esi
  800fe0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800feb:	89 d1                	mov    %edx,%ecx
  800fed:	89 d3                	mov    %edx,%ebx
  800fef:	89 d7                	mov    %edx,%edi
  800ff1:	89 d6                	mov    %edx,%esi
  800ff3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	57                   	push   %edi
  800ffe:	56                   	push   %esi
  800fff:	53                   	push   %ebx
  801000:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801003:	bb 00 00 00 00       	mov    $0x0,%ebx
  801008:	b8 0f 00 00 00       	mov    $0xf,%eax
  80100d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801010:	8b 55 08             	mov    0x8(%ebp),%edx
  801013:	89 df                	mov    %ebx,%edi
  801015:	89 de                	mov    %ebx,%esi
  801017:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801019:	85 c0                	test   %eax,%eax
  80101b:	7e 28                	jle    801045 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801021:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801028:	00 
  801029:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  801030:	00 
  801031:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801038:	00 
  801039:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  801040:	e8 ec f1 ff ff       	call   800231 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801045:	83 c4 2c             	add    $0x2c,%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801056:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105b:	b8 10 00 00 00       	mov    $0x10,%eax
  801060:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801063:	8b 55 08             	mov    0x8(%ebp),%edx
  801066:	89 df                	mov    %ebx,%edi
  801068:	89 de                	mov    %ebx,%esi
  80106a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80106c:	85 c0                	test   %eax,%eax
  80106e:	7e 28                	jle    801098 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801070:	89 44 24 10          	mov    %eax,0x10(%esp)
  801074:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80107b:	00 
  80107c:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  801083:	00 
  801084:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80108b:	00 
  80108c:	c7 04 24 1c 2c 80 00 	movl   $0x802c1c,(%esp)
  801093:	e8 99 f1 ff ff       	call   800231 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801098:	83 c4 2c             	add    $0x2c,%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5f                   	pop    %edi
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    

008010a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	c1 ea 16             	shr    $0x16,%edx
  8010d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010de:	f6 c2 01             	test   $0x1,%dl
  8010e1:	74 11                	je     8010f4 <fd_alloc+0x2d>
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 ea 0c             	shr    $0xc,%edx
  8010e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ef:	f6 c2 01             	test   $0x1,%dl
  8010f2:	75 09                	jne    8010fd <fd_alloc+0x36>
			*fd_store = fd;
  8010f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010fb:	eb 17                	jmp    801114 <fd_alloc+0x4d>
  8010fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801102:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801107:	75 c9                	jne    8010d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801109:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80110f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    

00801116 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80111c:	83 f8 1f             	cmp    $0x1f,%eax
  80111f:	77 36                	ja     801157 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801121:	c1 e0 0c             	shl    $0xc,%eax
  801124:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801129:	89 c2                	mov    %eax,%edx
  80112b:	c1 ea 16             	shr    $0x16,%edx
  80112e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801135:	f6 c2 01             	test   $0x1,%dl
  801138:	74 24                	je     80115e <fd_lookup+0x48>
  80113a:	89 c2                	mov    %eax,%edx
  80113c:	c1 ea 0c             	shr    $0xc,%edx
  80113f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801146:	f6 c2 01             	test   $0x1,%dl
  801149:	74 1a                	je     801165 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80114b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80114e:	89 02                	mov    %eax,(%edx)
	return 0;
  801150:	b8 00 00 00 00       	mov    $0x0,%eax
  801155:	eb 13                	jmp    80116a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801157:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80115c:	eb 0c                	jmp    80116a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80115e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801163:	eb 05                	jmp    80116a <fd_lookup+0x54>
  801165:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 18             	sub    $0x18,%esp
  801172:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801175:	ba 00 00 00 00       	mov    $0x0,%edx
  80117a:	eb 13                	jmp    80118f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80117c:	39 08                	cmp    %ecx,(%eax)
  80117e:	75 0c                	jne    80118c <dev_lookup+0x20>
			*dev = devtab[i];
  801180:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801183:	89 01                	mov    %eax,(%ecx)
			return 0;
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
  80118a:	eb 38                	jmp    8011c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80118c:	83 c2 01             	add    $0x1,%edx
  80118f:	8b 04 95 ac 2c 80 00 	mov    0x802cac(,%edx,4),%eax
  801196:	85 c0                	test   %eax,%eax
  801198:	75 e2                	jne    80117c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80119a:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80119f:	8b 40 48             	mov    0x48(%eax),%eax
  8011a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011aa:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  8011b1:	e8 74 f1 ff ff       	call   80032a <cprintf>
	*dev = 0;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	56                   	push   %esi
  8011ca:	53                   	push   %ebx
  8011cb:	83 ec 20             	sub    $0x20,%esp
  8011ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e4:	89 04 24             	mov    %eax,(%esp)
  8011e7:	e8 2a ff ff ff       	call   801116 <fd_lookup>
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	78 05                	js     8011f5 <fd_close+0x2f>
	    || fd != fd2)
  8011f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011f3:	74 0c                	je     801201 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011f5:	84 db                	test   %bl,%bl
  8011f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fc:	0f 44 c2             	cmove  %edx,%eax
  8011ff:	eb 3f                	jmp    801240 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801201:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801204:	89 44 24 04          	mov    %eax,0x4(%esp)
  801208:	8b 06                	mov    (%esi),%eax
  80120a:	89 04 24             	mov    %eax,(%esp)
  80120d:	e8 5a ff ff ff       	call   80116c <dev_lookup>
  801212:	89 c3                	mov    %eax,%ebx
  801214:	85 c0                	test   %eax,%eax
  801216:	78 16                	js     80122e <fd_close+0x68>
		if (dev->dev_close)
  801218:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80121b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80121e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801223:	85 c0                	test   %eax,%eax
  801225:	74 07                	je     80122e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801227:	89 34 24             	mov    %esi,(%esp)
  80122a:	ff d0                	call   *%eax
  80122c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80122e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801232:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801239:	e8 dc fb ff ff       	call   800e1a <sys_page_unmap>
	return r;
  80123e:	89 d8                	mov    %ebx,%eax
}
  801240:	83 c4 20             	add    $0x20,%esp
  801243:	5b                   	pop    %ebx
  801244:	5e                   	pop    %esi
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
  80124a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80124d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801250:	89 44 24 04          	mov    %eax,0x4(%esp)
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	89 04 24             	mov    %eax,(%esp)
  80125a:	e8 b7 fe ff ff       	call   801116 <fd_lookup>
  80125f:	89 c2                	mov    %eax,%edx
  801261:	85 d2                	test   %edx,%edx
  801263:	78 13                	js     801278 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801265:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80126c:	00 
  80126d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801270:	89 04 24             	mov    %eax,(%esp)
  801273:	e8 4e ff ff ff       	call   8011c6 <fd_close>
}
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <close_all>:

void
close_all(void)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	53                   	push   %ebx
  80127e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801281:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801286:	89 1c 24             	mov    %ebx,(%esp)
  801289:	e8 b9 ff ff ff       	call   801247 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80128e:	83 c3 01             	add    $0x1,%ebx
  801291:	83 fb 20             	cmp    $0x20,%ebx
  801294:	75 f0                	jne    801286 <close_all+0xc>
		close(i);
}
  801296:	83 c4 14             	add    $0x14,%esp
  801299:	5b                   	pop    %ebx
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 04 24             	mov    %eax,(%esp)
  8012b2:	e8 5f fe ff ff       	call   801116 <fd_lookup>
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	85 d2                	test   %edx,%edx
  8012bb:	0f 88 e1 00 00 00    	js     8013a2 <dup+0x106>
		return r;
	close(newfdnum);
  8012c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c4:	89 04 24             	mov    %eax,(%esp)
  8012c7:	e8 7b ff ff ff       	call   801247 <close>

	newfd = INDEX2FD(newfdnum);
  8012cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012cf:	c1 e3 0c             	shl    $0xc,%ebx
  8012d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012db:	89 04 24             	mov    %eax,(%esp)
  8012de:	e8 cd fd ff ff       	call   8010b0 <fd2data>
  8012e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012e5:	89 1c 24             	mov    %ebx,(%esp)
  8012e8:	e8 c3 fd ff ff       	call   8010b0 <fd2data>
  8012ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ef:	89 f0                	mov    %esi,%eax
  8012f1:	c1 e8 16             	shr    $0x16,%eax
  8012f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012fb:	a8 01                	test   $0x1,%al
  8012fd:	74 43                	je     801342 <dup+0xa6>
  8012ff:	89 f0                	mov    %esi,%eax
  801301:	c1 e8 0c             	shr    $0xc,%eax
  801304:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80130b:	f6 c2 01             	test   $0x1,%dl
  80130e:	74 32                	je     801342 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801310:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801317:	25 07 0e 00 00       	and    $0xe07,%eax
  80131c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801320:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801324:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80132b:	00 
  80132c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801330:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801337:	e8 8b fa ff ff       	call   800dc7 <sys_page_map>
  80133c:	89 c6                	mov    %eax,%esi
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 3e                	js     801380 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801345:	89 c2                	mov    %eax,%edx
  801347:	c1 ea 0c             	shr    $0xc,%edx
  80134a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801351:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801357:	89 54 24 10          	mov    %edx,0x10(%esp)
  80135b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80135f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801366:	00 
  801367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801372:	e8 50 fa ff ff       	call   800dc7 <sys_page_map>
  801377:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801379:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80137c:	85 f6                	test   %esi,%esi
  80137e:	79 22                	jns    8013a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801380:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801384:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80138b:	e8 8a fa ff ff       	call   800e1a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801390:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801394:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80139b:	e8 7a fa ff ff       	call   800e1a <sys_page_unmap>
	return r;
  8013a0:	89 f0                	mov    %esi,%eax
}
  8013a2:	83 c4 3c             	add    $0x3c,%esp
  8013a5:	5b                   	pop    %ebx
  8013a6:	5e                   	pop    %esi
  8013a7:	5f                   	pop    %edi
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    

008013aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 24             	sub    $0x24,%esp
  8013b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bb:	89 1c 24             	mov    %ebx,(%esp)
  8013be:	e8 53 fd ff ff       	call   801116 <fd_lookup>
  8013c3:	89 c2                	mov    %eax,%edx
  8013c5:	85 d2                	test   %edx,%edx
  8013c7:	78 6d                	js     801436 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	89 04 24             	mov    %eax,(%esp)
  8013d8:	e8 8f fd ff ff       	call   80116c <dev_lookup>
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	78 55                	js     801436 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e4:	8b 50 08             	mov    0x8(%eax),%edx
  8013e7:	83 e2 03             	and    $0x3,%edx
  8013ea:	83 fa 01             	cmp    $0x1,%edx
  8013ed:	75 23                	jne    801412 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ef:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8013f4:	8b 40 48             	mov    0x48(%eax),%eax
  8013f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ff:	c7 04 24 70 2c 80 00 	movl   $0x802c70,(%esp)
  801406:	e8 1f ef ff ff       	call   80032a <cprintf>
		return -E_INVAL;
  80140b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801410:	eb 24                	jmp    801436 <read+0x8c>
	}
	if (!dev->dev_read)
  801412:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801415:	8b 52 08             	mov    0x8(%edx),%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	74 15                	je     801431 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80141c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80141f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801423:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801426:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80142a:	89 04 24             	mov    %eax,(%esp)
  80142d:	ff d2                	call   *%edx
  80142f:	eb 05                	jmp    801436 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801431:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801436:	83 c4 24             	add    $0x24,%esp
  801439:	5b                   	pop    %ebx
  80143a:	5d                   	pop    %ebp
  80143b:	c3                   	ret    

0080143c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	57                   	push   %edi
  801440:	56                   	push   %esi
  801441:	53                   	push   %ebx
  801442:	83 ec 1c             	sub    $0x1c,%esp
  801445:	8b 7d 08             	mov    0x8(%ebp),%edi
  801448:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80144b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801450:	eb 23                	jmp    801475 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801452:	89 f0                	mov    %esi,%eax
  801454:	29 d8                	sub    %ebx,%eax
  801456:	89 44 24 08          	mov    %eax,0x8(%esp)
  80145a:	89 d8                	mov    %ebx,%eax
  80145c:	03 45 0c             	add    0xc(%ebp),%eax
  80145f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801463:	89 3c 24             	mov    %edi,(%esp)
  801466:	e8 3f ff ff ff       	call   8013aa <read>
		if (m < 0)
  80146b:	85 c0                	test   %eax,%eax
  80146d:	78 10                	js     80147f <readn+0x43>
			return m;
		if (m == 0)
  80146f:	85 c0                	test   %eax,%eax
  801471:	74 0a                	je     80147d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801473:	01 c3                	add    %eax,%ebx
  801475:	39 f3                	cmp    %esi,%ebx
  801477:	72 d9                	jb     801452 <readn+0x16>
  801479:	89 d8                	mov    %ebx,%eax
  80147b:	eb 02                	jmp    80147f <readn+0x43>
  80147d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80147f:	83 c4 1c             	add    $0x1c,%esp
  801482:	5b                   	pop    %ebx
  801483:	5e                   	pop    %esi
  801484:	5f                   	pop    %edi
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    

00801487 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	53                   	push   %ebx
  80148b:	83 ec 24             	sub    $0x24,%esp
  80148e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801491:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801494:	89 44 24 04          	mov    %eax,0x4(%esp)
  801498:	89 1c 24             	mov    %ebx,(%esp)
  80149b:	e8 76 fc ff ff       	call   801116 <fd_lookup>
  8014a0:	89 c2                	mov    %eax,%edx
  8014a2:	85 d2                	test   %edx,%edx
  8014a4:	78 68                	js     80150e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b0:	8b 00                	mov    (%eax),%eax
  8014b2:	89 04 24             	mov    %eax,(%esp)
  8014b5:	e8 b2 fc ff ff       	call   80116c <dev_lookup>
  8014ba:	85 c0                	test   %eax,%eax
  8014bc:	78 50                	js     80150e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014c5:	75 23                	jne    8014ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014c7:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014cc:	8b 40 48             	mov    0x48(%eax),%eax
  8014cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d7:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  8014de:	e8 47 ee ff ff       	call   80032a <cprintf>
		return -E_INVAL;
  8014e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e8:	eb 24                	jmp    80150e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8014f0:	85 d2                	test   %edx,%edx
  8014f2:	74 15                	je     801509 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801502:	89 04 24             	mov    %eax,(%esp)
  801505:	ff d2                	call   *%edx
  801507:	eb 05                	jmp    80150e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801509:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80150e:	83 c4 24             	add    $0x24,%esp
  801511:	5b                   	pop    %ebx
  801512:	5d                   	pop    %ebp
  801513:	c3                   	ret    

00801514 <seek>:

int
seek(int fdnum, off_t offset)
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80151a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80151d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	89 04 24             	mov    %eax,(%esp)
  801527:	e8 ea fb ff ff       	call   801116 <fd_lookup>
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 0e                	js     80153e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801530:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801533:	8b 55 0c             	mov    0xc(%ebp),%edx
  801536:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	53                   	push   %ebx
  801544:	83 ec 24             	sub    $0x24,%esp
  801547:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801551:	89 1c 24             	mov    %ebx,(%esp)
  801554:	e8 bd fb ff ff       	call   801116 <fd_lookup>
  801559:	89 c2                	mov    %eax,%edx
  80155b:	85 d2                	test   %edx,%edx
  80155d:	78 61                	js     8015c0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801562:	89 44 24 04          	mov    %eax,0x4(%esp)
  801566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801569:	8b 00                	mov    (%eax),%eax
  80156b:	89 04 24             	mov    %eax,(%esp)
  80156e:	e8 f9 fb ff ff       	call   80116c <dev_lookup>
  801573:	85 c0                	test   %eax,%eax
  801575:	78 49                	js     8015c0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80157e:	75 23                	jne    8015a3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801580:	a1 0c 40 80 00       	mov    0x80400c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801585:	8b 40 48             	mov    0x48(%eax),%eax
  801588:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80158c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801590:	c7 04 24 4c 2c 80 00 	movl   $0x802c4c,(%esp)
  801597:	e8 8e ed ff ff       	call   80032a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80159c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a1:	eb 1d                	jmp    8015c0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a6:	8b 52 18             	mov    0x18(%edx),%edx
  8015a9:	85 d2                	test   %edx,%edx
  8015ab:	74 0e                	je     8015bb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	ff d2                	call   *%edx
  8015b9:	eb 05                	jmp    8015c0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015c0:	83 c4 24             	add    $0x24,%esp
  8015c3:	5b                   	pop    %ebx
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	53                   	push   %ebx
  8015ca:	83 ec 24             	sub    $0x24,%esp
  8015cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	89 04 24             	mov    %eax,(%esp)
  8015dd:	e8 34 fb ff ff       	call   801116 <fd_lookup>
  8015e2:	89 c2                	mov    %eax,%edx
  8015e4:	85 d2                	test   %edx,%edx
  8015e6:	78 52                	js     80163a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f2:	8b 00                	mov    (%eax),%eax
  8015f4:	89 04 24             	mov    %eax,(%esp)
  8015f7:	e8 70 fb ff ff       	call   80116c <dev_lookup>
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 3a                	js     80163a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801603:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801607:	74 2c                	je     801635 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801609:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80160c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801613:	00 00 00 
	stat->st_isdir = 0;
  801616:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80161d:	00 00 00 
	stat->st_dev = dev;
  801620:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801626:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80162a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80162d:	89 14 24             	mov    %edx,(%esp)
  801630:	ff 50 14             	call   *0x14(%eax)
  801633:	eb 05                	jmp    80163a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801635:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80163a:	83 c4 24             	add    $0x24,%esp
  80163d:	5b                   	pop    %ebx
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
  801645:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80164f:	00 
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	89 04 24             	mov    %eax,(%esp)
  801656:	e8 28 02 00 00       	call   801883 <open>
  80165b:	89 c3                	mov    %eax,%ebx
  80165d:	85 db                	test   %ebx,%ebx
  80165f:	78 1b                	js     80167c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 44 24 04          	mov    %eax,0x4(%esp)
  801668:	89 1c 24             	mov    %ebx,(%esp)
  80166b:	e8 56 ff ff ff       	call   8015c6 <fstat>
  801670:	89 c6                	mov    %eax,%esi
	close(fd);
  801672:	89 1c 24             	mov    %ebx,(%esp)
  801675:	e8 cd fb ff ff       	call   801247 <close>
	return r;
  80167a:	89 f0                	mov    %esi,%eax
}
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	5b                   	pop    %ebx
  801680:	5e                   	pop    %esi
  801681:	5d                   	pop    %ebp
  801682:	c3                   	ret    

00801683 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
  801686:	56                   	push   %esi
  801687:	53                   	push   %ebx
  801688:	83 ec 10             	sub    $0x10,%esp
  80168b:	89 c6                	mov    %eax,%esi
  80168d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80168f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801696:	75 11                	jne    8016a9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801698:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80169f:	e8 ba 0e 00 00       	call   80255e <ipc_find_env>
  8016a4:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016a9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016b0:	00 
  8016b1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8016b8:	00 
  8016b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016bd:	a1 04 40 80 00       	mov    0x804004,%eax
  8016c2:	89 04 24             	mov    %eax,(%esp)
  8016c5:	e8 36 0e 00 00       	call   802500 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016d1:	00 
  8016d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016dd:	e8 b4 0d 00 00       	call   802496 <ipc_recv>
}
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016fd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801702:	ba 00 00 00 00       	mov    $0x0,%edx
  801707:	b8 02 00 00 00       	mov    $0x2,%eax
  80170c:	e8 72 ff ff ff       	call   801683 <fsipc>
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	8b 40 0c             	mov    0xc(%eax),%eax
  80171f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801724:	ba 00 00 00 00       	mov    $0x0,%edx
  801729:	b8 06 00 00 00       	mov    $0x6,%eax
  80172e:	e8 50 ff ff ff       	call   801683 <fsipc>
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	53                   	push   %ebx
  801739:	83 ec 14             	sub    $0x14,%esp
  80173c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8b 40 0c             	mov    0xc(%eax),%eax
  801745:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80174a:	ba 00 00 00 00       	mov    $0x0,%edx
  80174f:	b8 05 00 00 00       	mov    $0x5,%eax
  801754:	e8 2a ff ff ff       	call   801683 <fsipc>
  801759:	89 c2                	mov    %eax,%edx
  80175b:	85 d2                	test   %edx,%edx
  80175d:	78 2b                	js     80178a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80175f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801766:	00 
  801767:	89 1c 24             	mov    %ebx,(%esp)
  80176a:	e8 e8 f1 ff ff       	call   800957 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80176f:	a1 80 50 80 00       	mov    0x805080,%eax
  801774:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80177a:	a1 84 50 80 00       	mov    0x805084,%eax
  80177f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801785:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178a:	83 c4 14             	add    $0x14,%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 18             	sub    $0x18,%esp
  801796:	8b 45 10             	mov    0x10(%ebp),%eax
  801799:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80179e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8017a3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  8017a6:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ae:	8b 52 0c             	mov    0xc(%edx),%edx
  8017b1:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  8017b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c2:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8017c9:	e8 26 f3 ff ff       	call   800af4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  8017ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d3:	b8 04 00 00 00       	mov    $0x4,%eax
  8017d8:	e8 a6 fe ff ff       	call   801683 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	56                   	push   %esi
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 10             	sub    $0x10,%esp
  8017e7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017f5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801800:	b8 03 00 00 00       	mov    $0x3,%eax
  801805:	e8 79 fe ff ff       	call   801683 <fsipc>
  80180a:	89 c3                	mov    %eax,%ebx
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 6a                	js     80187a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801810:	39 c6                	cmp    %eax,%esi
  801812:	73 24                	jae    801838 <devfile_read+0x59>
  801814:	c7 44 24 0c c0 2c 80 	movl   $0x802cc0,0xc(%esp)
  80181b:	00 
  80181c:	c7 44 24 08 c7 2c 80 	movl   $0x802cc7,0x8(%esp)
  801823:	00 
  801824:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80182b:	00 
  80182c:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  801833:	e8 f9 e9 ff ff       	call   800231 <_panic>
	assert(r <= PGSIZE);
  801838:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80183d:	7e 24                	jle    801863 <devfile_read+0x84>
  80183f:	c7 44 24 0c e7 2c 80 	movl   $0x802ce7,0xc(%esp)
  801846:	00 
  801847:	c7 44 24 08 c7 2c 80 	movl   $0x802cc7,0x8(%esp)
  80184e:	00 
  80184f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801856:	00 
  801857:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  80185e:	e8 ce e9 ff ff       	call   800231 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801863:	89 44 24 08          	mov    %eax,0x8(%esp)
  801867:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80186e:	00 
  80186f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801872:	89 04 24             	mov    %eax,(%esp)
  801875:	e8 7a f2 ff ff       	call   800af4 <memmove>
	return r;
}
  80187a:	89 d8                	mov    %ebx,%eax
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	5b                   	pop    %ebx
  801880:	5e                   	pop    %esi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	53                   	push   %ebx
  801887:	83 ec 24             	sub    $0x24,%esp
  80188a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80188d:	89 1c 24             	mov    %ebx,(%esp)
  801890:	e8 8b f0 ff ff       	call   800920 <strlen>
  801895:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80189a:	7f 60                	jg     8018fc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80189c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189f:	89 04 24             	mov    %eax,(%esp)
  8018a2:	e8 20 f8 ff ff       	call   8010c7 <fd_alloc>
  8018a7:	89 c2                	mov    %eax,%edx
  8018a9:	85 d2                	test   %edx,%edx
  8018ab:	78 54                	js     801901 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018b1:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018b8:	e8 9a f0 ff ff       	call   800957 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8018cd:	e8 b1 fd ff ff       	call   801683 <fsipc>
  8018d2:	89 c3                	mov    %eax,%ebx
  8018d4:	85 c0                	test   %eax,%eax
  8018d6:	79 17                	jns    8018ef <open+0x6c>
		fd_close(fd, 0);
  8018d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018df:	00 
  8018e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e3:	89 04 24             	mov    %eax,(%esp)
  8018e6:	e8 db f8 ff ff       	call   8011c6 <fd_close>
		return r;
  8018eb:	89 d8                	mov    %ebx,%eax
  8018ed:	eb 12                	jmp    801901 <open+0x7e>
	}

	return fd2num(fd);
  8018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f2:	89 04 24             	mov    %eax,(%esp)
  8018f5:	e8 a6 f7 ff ff       	call   8010a0 <fd2num>
  8018fa:	eb 05                	jmp    801901 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018fc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801901:	83 c4 24             	add    $0x24,%esp
  801904:	5b                   	pop    %ebx
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    

00801907 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80190d:	ba 00 00 00 00       	mov    $0x0,%edx
  801912:	b8 08 00 00 00       	mov    $0x8,%eax
  801917:	e8 67 fd ff ff       	call   801683 <fsipc>
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	53                   	push   %ebx
  801922:	83 ec 14             	sub    $0x14,%esp
  801925:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801927:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80192b:	7e 31                	jle    80195e <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80192d:	8b 40 04             	mov    0x4(%eax),%eax
  801930:	89 44 24 08          	mov    %eax,0x8(%esp)
  801934:	8d 43 10             	lea    0x10(%ebx),%eax
  801937:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193b:	8b 03                	mov    (%ebx),%eax
  80193d:	89 04 24             	mov    %eax,(%esp)
  801940:	e8 42 fb ff ff       	call   801487 <write>
		if (result > 0)
  801945:	85 c0                	test   %eax,%eax
  801947:	7e 03                	jle    80194c <writebuf+0x2e>
			b->result += result;
  801949:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80194c:	39 43 04             	cmp    %eax,0x4(%ebx)
  80194f:	74 0d                	je     80195e <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801951:	85 c0                	test   %eax,%eax
  801953:	ba 00 00 00 00       	mov    $0x0,%edx
  801958:	0f 4f c2             	cmovg  %edx,%eax
  80195b:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80195e:	83 c4 14             	add    $0x14,%esp
  801961:	5b                   	pop    %ebx
  801962:	5d                   	pop    %ebp
  801963:	c3                   	ret    

00801964 <putch>:

static void
putch(int ch, void *thunk)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	53                   	push   %ebx
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80196e:	8b 53 04             	mov    0x4(%ebx),%edx
  801971:	8d 42 01             	lea    0x1(%edx),%eax
  801974:	89 43 04             	mov    %eax,0x4(%ebx)
  801977:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80197a:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80197e:	3d 00 01 00 00       	cmp    $0x100,%eax
  801983:	75 0e                	jne    801993 <putch+0x2f>
		writebuf(b);
  801985:	89 d8                	mov    %ebx,%eax
  801987:	e8 92 ff ff ff       	call   80191e <writebuf>
		b->idx = 0;
  80198c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801993:	83 c4 04             	add    $0x4,%esp
  801996:	5b                   	pop    %ebx
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    

00801999 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019ab:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019b2:	00 00 00 
	b.result = 0;
  8019b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019bc:	00 00 00 
	b.error = 1;
  8019bf:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8019c6:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8019c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019d7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e1:	c7 04 24 64 19 80 00 	movl   $0x801964,(%esp)
  8019e8:	e8 d1 ea ff ff       	call   8004be <vprintfmt>
	if (b.idx > 0)
  8019ed:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8019f4:	7e 0b                	jle    801a01 <vfprintf+0x68>
		writebuf(&b);
  8019f6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019fc:	e8 1d ff ff ff       	call   80191e <writebuf>

	return (b.result ? b.result : b.error);
  801a01:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a07:	85 c0                	test   %eax,%eax
  801a09:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a18:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	89 04 24             	mov    %eax,(%esp)
  801a2c:	e8 68 ff ff ff       	call   801999 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <printf>:

int
printf(const char *fmt, ...)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a39:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a4e:	e8 46 ff ff ff       	call   801999 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    
  801a55:	66 90                	xchg   %ax,%ax
  801a57:	66 90                	xchg   %ax,%ax
  801a59:	66 90                	xchg   %ax,%ax
  801a5b:	66 90                	xchg   %ax,%ax
  801a5d:	66 90                	xchg   %ax,%ax
  801a5f:	90                   	nop

00801a60 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
  801a63:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801a66:	c7 44 24 04 f3 2c 80 	movl   $0x802cf3,0x4(%esp)
  801a6d:	00 
  801a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a71:	89 04 24             	mov    %eax,(%esp)
  801a74:	e8 de ee ff ff       	call   800957 <strcpy>
	return 0;
}
  801a79:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	53                   	push   %ebx
  801a84:	83 ec 14             	sub    $0x14,%esp
  801a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a8a:	89 1c 24             	mov    %ebx,(%esp)
  801a8d:	e8 04 0b 00 00       	call   802596 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801a92:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801a97:	83 f8 01             	cmp    $0x1,%eax
  801a9a:	75 0d                	jne    801aa9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801a9c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801a9f:	89 04 24             	mov    %eax,(%esp)
  801aa2:	e8 29 03 00 00       	call   801dd0 <nsipc_close>
  801aa7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801aa9:	89 d0                	mov    %edx,%eax
  801aab:	83 c4 14             	add    $0x14,%esp
  801aae:	5b                   	pop    %ebx
  801aaf:	5d                   	pop    %ebp
  801ab0:	c3                   	ret    

00801ab1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
  801ab4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ab7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801abe:	00 
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad3:	89 04 24             	mov    %eax,(%esp)
  801ad6:	e8 f0 03 00 00       	call   801ecb <nsipc_send>
}
  801adb:	c9                   	leave  
  801adc:	c3                   	ret    

00801add <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ae3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801aea:	00 
  801aeb:	8b 45 10             	mov    0x10(%ebp),%eax
  801aee:	89 44 24 08          	mov    %eax,0x8(%esp)
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	8b 40 0c             	mov    0xc(%eax),%eax
  801aff:	89 04 24             	mov    %eax,(%esp)
  801b02:	e8 44 03 00 00       	call   801e4b <nsipc_recv>
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b0f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b12:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b16:	89 04 24             	mov    %eax,(%esp)
  801b19:	e8 f8 f5 ff ff       	call   801116 <fd_lookup>
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	78 17                	js     801b39 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b25:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801b2b:	39 08                	cmp    %ecx,(%eax)
  801b2d:	75 05                	jne    801b34 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801b2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b32:	eb 05                	jmp    801b39 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801b34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	56                   	push   %esi
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 20             	sub    $0x20,%esp
  801b43:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801b45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b48:	89 04 24             	mov    %eax,(%esp)
  801b4b:	e8 77 f5 ff ff       	call   8010c7 <fd_alloc>
  801b50:	89 c3                	mov    %eax,%ebx
  801b52:	85 c0                	test   %eax,%eax
  801b54:	78 21                	js     801b77 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b56:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b5d:	00 
  801b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b6c:	e8 02 f2 ff ff       	call   800d73 <sys_page_alloc>
  801b71:	89 c3                	mov    %eax,%ebx
  801b73:	85 c0                	test   %eax,%eax
  801b75:	79 0c                	jns    801b83 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801b77:	89 34 24             	mov    %esi,(%esp)
  801b7a:	e8 51 02 00 00       	call   801dd0 <nsipc_close>
		return r;
  801b7f:	89 d8                	mov    %ebx,%eax
  801b81:	eb 20                	jmp    801ba3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b83:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b91:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801b98:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801b9b:	89 14 24             	mov    %edx,(%esp)
  801b9e:	e8 fd f4 ff ff       	call   8010a0 <fd2num>
}
  801ba3:	83 c4 20             	add    $0x20,%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5e                   	pop    %esi
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    

00801baa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	e8 51 ff ff ff       	call   801b09 <fd2sockid>
		return r;
  801bb8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	78 23                	js     801be1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bbe:	8b 55 10             	mov    0x10(%ebp),%edx
  801bc1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bcc:	89 04 24             	mov    %eax,(%esp)
  801bcf:	e8 45 01 00 00       	call   801d19 <nsipc_accept>
		return r;
  801bd4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	78 07                	js     801be1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801bda:	e8 5c ff ff ff       	call   801b3b <alloc_sockfd>
  801bdf:	89 c1                	mov    %eax,%ecx
}
  801be1:	89 c8                	mov    %ecx,%eax
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	e8 16 ff ff ff       	call   801b09 <fd2sockid>
  801bf3:	89 c2                	mov    %eax,%edx
  801bf5:	85 d2                	test   %edx,%edx
  801bf7:	78 16                	js     801c0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801bf9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c07:	89 14 24             	mov    %edx,(%esp)
  801c0a:	e8 60 01 00 00       	call   801d6f <nsipc_bind>
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <shutdown>:

int
shutdown(int s, int how)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	e8 ea fe ff ff       	call   801b09 <fd2sockid>
  801c1f:	89 c2                	mov    %eax,%edx
  801c21:	85 d2                	test   %edx,%edx
  801c23:	78 0f                	js     801c34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2c:	89 14 24             	mov    %edx,(%esp)
  801c2f:	e8 7a 01 00 00       	call   801dae <nsipc_shutdown>
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	e8 c5 fe ff ff       	call   801b09 <fd2sockid>
  801c44:	89 c2                	mov    %eax,%edx
  801c46:	85 d2                	test   %edx,%edx
  801c48:	78 16                	js     801c60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c58:	89 14 24             	mov    %edx,(%esp)
  801c5b:	e8 8a 01 00 00       	call   801dea <nsipc_connect>
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <listen>:

int
listen(int s, int backlog)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	e8 99 fe ff ff       	call   801b09 <fd2sockid>
  801c70:	89 c2                	mov    %eax,%edx
  801c72:	85 d2                	test   %edx,%edx
  801c74:	78 0f                	js     801c85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7d:	89 14 24             	mov    %edx,(%esp)
  801c80:	e8 a4 01 00 00       	call   801e29 <nsipc_listen>
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	89 04 24             	mov    %eax,(%esp)
  801ca1:	e8 98 02 00 00       	call   801f3e <nsipc_socket>
  801ca6:	89 c2                	mov    %eax,%edx
  801ca8:	85 d2                	test   %edx,%edx
  801caa:	78 05                	js     801cb1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801cac:	e8 8a fe ff ff       	call   801b3b <alloc_sockfd>
}
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	53                   	push   %ebx
  801cb7:	83 ec 14             	sub    $0x14,%esp
  801cba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801cbc:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801cc3:	75 11                	jne    801cd6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cc5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801ccc:	e8 8d 08 00 00       	call   80255e <ipc_find_env>
  801cd1:	a3 08 40 80 00       	mov    %eax,0x804008
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801cd6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801cdd:	00 
  801cde:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ce5:	00 
  801ce6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cea:	a1 08 40 80 00       	mov    0x804008,%eax
  801cef:	89 04 24             	mov    %eax,(%esp)
  801cf2:	e8 09 08 00 00       	call   802500 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801cf7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cfe:	00 
  801cff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d06:	00 
  801d07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d0e:	e8 83 07 00 00       	call   802496 <ipc_recv>
}
  801d13:	83 c4 14             	add    $0x14,%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    

00801d19 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	56                   	push   %esi
  801d1d:	53                   	push   %ebx
  801d1e:	83 ec 10             	sub    $0x10,%esp
  801d21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d24:	8b 45 08             	mov    0x8(%ebp),%eax
  801d27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d2c:	8b 06                	mov    (%esi),%eax
  801d2e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d33:	b8 01 00 00 00       	mov    $0x1,%eax
  801d38:	e8 76 ff ff ff       	call   801cb3 <nsipc>
  801d3d:	89 c3                	mov    %eax,%ebx
  801d3f:	85 c0                	test   %eax,%eax
  801d41:	78 23                	js     801d66 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d43:	a1 10 60 80 00       	mov    0x806010,%eax
  801d48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d4c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d53:	00 
  801d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d57:	89 04 24             	mov    %eax,(%esp)
  801d5a:	e8 95 ed ff ff       	call   800af4 <memmove>
		*addrlen = ret->ret_addrlen;
  801d5f:	a1 10 60 80 00       	mov    0x806010,%eax
  801d64:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801d66:	89 d8                	mov    %ebx,%eax
  801d68:	83 c4 10             	add    $0x10,%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5e                   	pop    %esi
  801d6d:	5d                   	pop    %ebp
  801d6e:	c3                   	ret    

00801d6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	53                   	push   %ebx
  801d73:	83 ec 14             	sub    $0x14,%esp
  801d76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d93:	e8 5c ed ff ff       	call   800af4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d98:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801da3:	e8 0b ff ff ff       	call   801cb3 <nsipc>
}
  801da8:	83 c4 14             	add    $0x14,%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5d                   	pop    %ebp
  801dad:	c3                   	ret    

00801dae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801dc4:	b8 03 00 00 00       	mov    $0x3,%eax
  801dc9:	e8 e5 fe ff ff       	call   801cb3 <nsipc>
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <nsipc_close>:

int
nsipc_close(int s)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801dde:	b8 04 00 00 00       	mov    $0x4,%eax
  801de3:	e8 cb fe ff ff       	call   801cb3 <nsipc>
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	53                   	push   %ebx
  801dee:	83 ec 14             	sub    $0x14,%esp
  801df1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801dfc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e07:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801e0e:	e8 e1 ec ff ff       	call   800af4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e13:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e19:	b8 05 00 00 00       	mov    $0x5,%eax
  801e1e:	e8 90 fe ff ff       	call   801cb3 <nsipc>
}
  801e23:	83 c4 14             	add    $0x14,%esp
  801e26:	5b                   	pop    %ebx
  801e27:	5d                   	pop    %ebp
  801e28:	c3                   	ret    

00801e29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801e3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801e44:	e8 6a fe ff ff       	call   801cb3 <nsipc>
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	56                   	push   %esi
  801e4f:	53                   	push   %ebx
  801e50:	83 ec 10             	sub    $0x10,%esp
  801e53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e56:	8b 45 08             	mov    0x8(%ebp),%eax
  801e59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e5e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e64:	8b 45 14             	mov    0x14(%ebp),%eax
  801e67:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e6c:	b8 07 00 00 00       	mov    $0x7,%eax
  801e71:	e8 3d fe ff ff       	call   801cb3 <nsipc>
  801e76:	89 c3                	mov    %eax,%ebx
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	78 46                	js     801ec2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801e7c:	39 f0                	cmp    %esi,%eax
  801e7e:	7f 07                	jg     801e87 <nsipc_recv+0x3c>
  801e80:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e85:	7e 24                	jle    801eab <nsipc_recv+0x60>
  801e87:	c7 44 24 0c ff 2c 80 	movl   $0x802cff,0xc(%esp)
  801e8e:	00 
  801e8f:	c7 44 24 08 c7 2c 80 	movl   $0x802cc7,0x8(%esp)
  801e96:	00 
  801e97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801e9e:	00 
  801e9f:	c7 04 24 14 2d 80 00 	movl   $0x802d14,(%esp)
  801ea6:	e8 86 e3 ff ff       	call   800231 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801eab:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eaf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801eb6:	00 
  801eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eba:	89 04 24             	mov    %eax,(%esp)
  801ebd:	e8 32 ec ff ff       	call   800af4 <memmove>
	}

	return r;
}
  801ec2:	89 d8                	mov    %ebx,%eax
  801ec4:	83 c4 10             	add    $0x10,%esp
  801ec7:	5b                   	pop    %ebx
  801ec8:	5e                   	pop    %esi
  801ec9:	5d                   	pop    %ebp
  801eca:	c3                   	ret    

00801ecb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	53                   	push   %ebx
  801ecf:	83 ec 14             	sub    $0x14,%esp
  801ed2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801edd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ee3:	7e 24                	jle    801f09 <nsipc_send+0x3e>
  801ee5:	c7 44 24 0c 20 2d 80 	movl   $0x802d20,0xc(%esp)
  801eec:	00 
  801eed:	c7 44 24 08 c7 2c 80 	movl   $0x802cc7,0x8(%esp)
  801ef4:	00 
  801ef5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801efc:	00 
  801efd:	c7 04 24 14 2d 80 00 	movl   $0x802d14,(%esp)
  801f04:	e8 28 e3 ff ff       	call   800231 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f14:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801f1b:	e8 d4 eb ff ff       	call   800af4 <memmove>
	nsipcbuf.send.req_size = size;
  801f20:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f26:	8b 45 14             	mov    0x14(%ebp),%eax
  801f29:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f2e:	b8 08 00 00 00       	mov    $0x8,%eax
  801f33:	e8 7b fd ff ff       	call   801cb3 <nsipc>
}
  801f38:	83 c4 14             	add    $0x14,%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5d                   	pop    %ebp
  801f3d:	c3                   	ret    

00801f3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f54:	8b 45 10             	mov    0x10(%ebp),%eax
  801f57:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f5c:	b8 09 00 00 00       	mov    $0x9,%eax
  801f61:	e8 4d fd ff ff       	call   801cb3 <nsipc>
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
  801f6b:	56                   	push   %esi
  801f6c:	53                   	push   %ebx
  801f6d:	83 ec 10             	sub    $0x10,%esp
  801f70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	89 04 24             	mov    %eax,(%esp)
  801f79:	e8 32 f1 ff ff       	call   8010b0 <fd2data>
  801f7e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f80:	c7 44 24 04 2c 2d 80 	movl   $0x802d2c,0x4(%esp)
  801f87:	00 
  801f88:	89 1c 24             	mov    %ebx,(%esp)
  801f8b:	e8 c7 e9 ff ff       	call   800957 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f90:	8b 46 04             	mov    0x4(%esi),%eax
  801f93:	2b 06                	sub    (%esi),%eax
  801f95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fa2:	00 00 00 
	stat->st_dev = &devpipe;
  801fa5:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  801fac:	30 80 00 
	return 0;
}
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	83 c4 10             	add    $0x10,%esp
  801fb7:	5b                   	pop    %ebx
  801fb8:	5e                   	pop    %esi
  801fb9:	5d                   	pop    %ebp
  801fba:	c3                   	ret    

00801fbb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	53                   	push   %ebx
  801fbf:	83 ec 14             	sub    $0x14,%esp
  801fc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fc5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd0:	e8 45 ee ff ff       	call   800e1a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fd5:	89 1c 24             	mov    %ebx,(%esp)
  801fd8:	e8 d3 f0 ff ff       	call   8010b0 <fd2data>
  801fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe8:	e8 2d ee ff ff       	call   800e1a <sys_page_unmap>
}
  801fed:	83 c4 14             	add    $0x14,%esp
  801ff0:	5b                   	pop    %ebx
  801ff1:	5d                   	pop    %ebp
  801ff2:	c3                   	ret    

00801ff3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	57                   	push   %edi
  801ff7:	56                   	push   %esi
  801ff8:	53                   	push   %ebx
  801ff9:	83 ec 2c             	sub    $0x2c,%esp
  801ffc:	89 c6                	mov    %eax,%esi
  801ffe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802001:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802006:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802009:	89 34 24             	mov    %esi,(%esp)
  80200c:	e8 85 05 00 00       	call   802596 <pageref>
  802011:	89 c7                	mov    %eax,%edi
  802013:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802016:	89 04 24             	mov    %eax,(%esp)
  802019:	e8 78 05 00 00       	call   802596 <pageref>
  80201e:	39 c7                	cmp    %eax,%edi
  802020:	0f 94 c2             	sete   %dl
  802023:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802026:	8b 0d 0c 40 80 00    	mov    0x80400c,%ecx
  80202c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80202f:	39 fb                	cmp    %edi,%ebx
  802031:	74 21                	je     802054 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802033:	84 d2                	test   %dl,%dl
  802035:	74 ca                	je     802001 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802037:	8b 51 58             	mov    0x58(%ecx),%edx
  80203a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80203e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802042:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802046:	c7 04 24 33 2d 80 00 	movl   $0x802d33,(%esp)
  80204d:	e8 d8 e2 ff ff       	call   80032a <cprintf>
  802052:	eb ad                	jmp    802001 <_pipeisclosed+0xe>
	}
}
  802054:	83 c4 2c             	add    $0x2c,%esp
  802057:	5b                   	pop    %ebx
  802058:	5e                   	pop    %esi
  802059:	5f                   	pop    %edi
  80205a:	5d                   	pop    %ebp
  80205b:	c3                   	ret    

0080205c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	57                   	push   %edi
  802060:	56                   	push   %esi
  802061:	53                   	push   %ebx
  802062:	83 ec 1c             	sub    $0x1c,%esp
  802065:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802068:	89 34 24             	mov    %esi,(%esp)
  80206b:	e8 40 f0 ff ff       	call   8010b0 <fd2data>
  802070:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802072:	bf 00 00 00 00       	mov    $0x0,%edi
  802077:	eb 45                	jmp    8020be <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802079:	89 da                	mov    %ebx,%edx
  80207b:	89 f0                	mov    %esi,%eax
  80207d:	e8 71 ff ff ff       	call   801ff3 <_pipeisclosed>
  802082:	85 c0                	test   %eax,%eax
  802084:	75 41                	jne    8020c7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802086:	e8 c9 ec ff ff       	call   800d54 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80208b:	8b 43 04             	mov    0x4(%ebx),%eax
  80208e:	8b 0b                	mov    (%ebx),%ecx
  802090:	8d 51 20             	lea    0x20(%ecx),%edx
  802093:	39 d0                	cmp    %edx,%eax
  802095:	73 e2                	jae    802079 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802097:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80209a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80209e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020a1:	99                   	cltd   
  8020a2:	c1 ea 1b             	shr    $0x1b,%edx
  8020a5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8020a8:	83 e1 1f             	and    $0x1f,%ecx
  8020ab:	29 d1                	sub    %edx,%ecx
  8020ad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8020b1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8020b5:	83 c0 01             	add    $0x1,%eax
  8020b8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020bb:	83 c7 01             	add    $0x1,%edi
  8020be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020c1:	75 c8                	jne    80208b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8020c3:	89 f8                	mov    %edi,%eax
  8020c5:	eb 05                	jmp    8020cc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8020cc:	83 c4 1c             	add    $0x1c,%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    

008020d4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	57                   	push   %edi
  8020d8:	56                   	push   %esi
  8020d9:	53                   	push   %ebx
  8020da:	83 ec 1c             	sub    $0x1c,%esp
  8020dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8020e0:	89 3c 24             	mov    %edi,(%esp)
  8020e3:	e8 c8 ef ff ff       	call   8010b0 <fd2data>
  8020e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020ea:	be 00 00 00 00       	mov    $0x0,%esi
  8020ef:	eb 3d                	jmp    80212e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020f1:	85 f6                	test   %esi,%esi
  8020f3:	74 04                	je     8020f9 <devpipe_read+0x25>
				return i;
  8020f5:	89 f0                	mov    %esi,%eax
  8020f7:	eb 43                	jmp    80213c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8020f9:	89 da                	mov    %ebx,%edx
  8020fb:	89 f8                	mov    %edi,%eax
  8020fd:	e8 f1 fe ff ff       	call   801ff3 <_pipeisclosed>
  802102:	85 c0                	test   %eax,%eax
  802104:	75 31                	jne    802137 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802106:	e8 49 ec ff ff       	call   800d54 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80210b:	8b 03                	mov    (%ebx),%eax
  80210d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802110:	74 df                	je     8020f1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802112:	99                   	cltd   
  802113:	c1 ea 1b             	shr    $0x1b,%edx
  802116:	01 d0                	add    %edx,%eax
  802118:	83 e0 1f             	and    $0x1f,%eax
  80211b:	29 d0                	sub    %edx,%eax
  80211d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802122:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802125:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802128:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80212b:	83 c6 01             	add    $0x1,%esi
  80212e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802131:	75 d8                	jne    80210b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802133:	89 f0                	mov    %esi,%eax
  802135:	eb 05                	jmp    80213c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80213c:	83 c4 1c             	add    $0x1c,%esp
  80213f:	5b                   	pop    %ebx
  802140:	5e                   	pop    %esi
  802141:	5f                   	pop    %edi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    

00802144 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
  802149:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80214c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214f:	89 04 24             	mov    %eax,(%esp)
  802152:	e8 70 ef ff ff       	call   8010c7 <fd_alloc>
  802157:	89 c2                	mov    %eax,%edx
  802159:	85 d2                	test   %edx,%edx
  80215b:	0f 88 4d 01 00 00    	js     8022ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802161:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802168:	00 
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802170:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802177:	e8 f7 eb ff ff       	call   800d73 <sys_page_alloc>
  80217c:	89 c2                	mov    %eax,%edx
  80217e:	85 d2                	test   %edx,%edx
  802180:	0f 88 28 01 00 00    	js     8022ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802186:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802189:	89 04 24             	mov    %eax,(%esp)
  80218c:	e8 36 ef ff ff       	call   8010c7 <fd_alloc>
  802191:	89 c3                	mov    %eax,%ebx
  802193:	85 c0                	test   %eax,%eax
  802195:	0f 88 fe 00 00 00    	js     802299 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80219b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021a2:	00 
  8021a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b1:	e8 bd eb ff ff       	call   800d73 <sys_page_alloc>
  8021b6:	89 c3                	mov    %eax,%ebx
  8021b8:	85 c0                	test   %eax,%eax
  8021ba:	0f 88 d9 00 00 00    	js     802299 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	89 04 24             	mov    %eax,(%esp)
  8021c6:	e8 e5 ee ff ff       	call   8010b0 <fd2data>
  8021cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021d4:	00 
  8021d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e0:	e8 8e eb ff ff       	call   800d73 <sys_page_alloc>
  8021e5:	89 c3                	mov    %eax,%ebx
  8021e7:	85 c0                	test   %eax,%eax
  8021e9:	0f 88 97 00 00 00    	js     802286 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f2:	89 04 24             	mov    %eax,(%esp)
  8021f5:	e8 b6 ee ff ff       	call   8010b0 <fd2data>
  8021fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802201:	00 
  802202:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802206:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80220d:	00 
  80220e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802212:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802219:	e8 a9 eb ff ff       	call   800dc7 <sys_page_map>
  80221e:	89 c3                	mov    %eax,%ebx
  802220:	85 c0                	test   %eax,%eax
  802222:	78 52                	js     802276 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802224:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802239:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80223f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802242:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802247:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	89 04 24             	mov    %eax,(%esp)
  802254:	e8 47 ee ff ff       	call   8010a0 <fd2num>
  802259:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80225e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802261:	89 04 24             	mov    %eax,(%esp)
  802264:	e8 37 ee ff ff       	call   8010a0 <fd2num>
  802269:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80226c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80226f:	b8 00 00 00 00       	mov    $0x0,%eax
  802274:	eb 38                	jmp    8022ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802276:	89 74 24 04          	mov    %esi,0x4(%esp)
  80227a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802281:	e8 94 eb ff ff       	call   800e1a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802294:	e8 81 eb ff ff       	call   800e1a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a7:	e8 6e eb ff ff       	call   800e1a <sys_page_unmap>
  8022ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8022ae:	83 c4 30             	add    $0x30,%esp
  8022b1:	5b                   	pop    %ebx
  8022b2:	5e                   	pop    %esi
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    

008022b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	89 04 24             	mov    %eax,(%esp)
  8022c8:	e8 49 ee ff ff       	call   801116 <fd_lookup>
  8022cd:	89 c2                	mov    %eax,%edx
  8022cf:	85 d2                	test   %edx,%edx
  8022d1:	78 15                	js     8022e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	89 04 24             	mov    %eax,(%esp)
  8022d9:	e8 d2 ed ff ff       	call   8010b0 <fd2data>
	return _pipeisclosed(fd, p);
  8022de:	89 c2                	mov    %eax,%edx
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	e8 0b fd ff ff       	call   801ff3 <_pipeisclosed>
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    
  8022ea:	66 90                	xchg   %ax,%ax
  8022ec:	66 90                	xchg   %ax,%ax
  8022ee:	66 90                	xchg   %ax,%ax

008022f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f8:	5d                   	pop    %ebp
  8022f9:	c3                   	ret    

008022fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
  8022fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802300:	c7 44 24 04 4b 2d 80 	movl   $0x802d4b,0x4(%esp)
  802307:	00 
  802308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80230b:	89 04 24             	mov    %eax,(%esp)
  80230e:	e8 44 e6 ff ff       	call   800957 <strcpy>
	return 0;
}
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	57                   	push   %edi
  80231e:	56                   	push   %esi
  80231f:	53                   	push   %ebx
  802320:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802326:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80232b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802331:	eb 31                	jmp    802364 <devcons_write+0x4a>
		m = n - tot;
  802333:	8b 75 10             	mov    0x10(%ebp),%esi
  802336:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802338:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80233b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802340:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802343:	89 74 24 08          	mov    %esi,0x8(%esp)
  802347:	03 45 0c             	add    0xc(%ebp),%eax
  80234a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234e:	89 3c 24             	mov    %edi,(%esp)
  802351:	e8 9e e7 ff ff       	call   800af4 <memmove>
		sys_cputs(buf, m);
  802356:	89 74 24 04          	mov    %esi,0x4(%esp)
  80235a:	89 3c 24             	mov    %edi,(%esp)
  80235d:	e8 44 e9 ff ff       	call   800ca6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802362:	01 f3                	add    %esi,%ebx
  802364:	89 d8                	mov    %ebx,%eax
  802366:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802369:	72 c8                	jb     802333 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80236b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802371:	5b                   	pop    %ebx
  802372:	5e                   	pop    %esi
  802373:	5f                   	pop    %edi
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    

00802376 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80237c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802381:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802385:	75 07                	jne    80238e <devcons_read+0x18>
  802387:	eb 2a                	jmp    8023b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802389:	e8 c6 e9 ff ff       	call   800d54 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80238e:	66 90                	xchg   %ax,%ax
  802390:	e8 2f e9 ff ff       	call   800cc4 <sys_cgetc>
  802395:	85 c0                	test   %eax,%eax
  802397:	74 f0                	je     802389 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802399:	85 c0                	test   %eax,%eax
  80239b:	78 16                	js     8023b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80239d:	83 f8 04             	cmp    $0x4,%eax
  8023a0:	74 0c                	je     8023ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8023a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a5:	88 02                	mov    %al,(%edx)
	return 1;
  8023a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ac:	eb 05                	jmp    8023b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8023ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8023c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8023c8:	00 
  8023c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023cc:	89 04 24             	mov    %eax,(%esp)
  8023cf:	e8 d2 e8 ff ff       	call   800ca6 <sys_cputs>
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <getchar>:

int
getchar(void)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8023dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8023e3:	00 
  8023e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f2:	e8 b3 ef ff ff       	call   8013aa <read>
	if (r < 0)
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	78 0f                	js     80240a <getchar+0x34>
		return r;
	if (r < 1)
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	7e 06                	jle    802405 <getchar+0x2f>
		return -E_EOF;
	return c;
  8023ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802403:	eb 05                	jmp    80240a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802405:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802412:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802415:	89 44 24 04          	mov    %eax,0x4(%esp)
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	89 04 24             	mov    %eax,(%esp)
  80241f:	e8 f2 ec ff ff       	call   801116 <fd_lookup>
  802424:	85 c0                	test   %eax,%eax
  802426:	78 11                	js     802439 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242b:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802431:	39 10                	cmp    %edx,(%eax)
  802433:	0f 94 c0             	sete   %al
  802436:	0f b6 c0             	movzbl %al,%eax
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <opencons>:

int
opencons(void)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802441:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802444:	89 04 24             	mov    %eax,(%esp)
  802447:	e8 7b ec ff ff       	call   8010c7 <fd_alloc>
		return r;
  80244c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80244e:	85 c0                	test   %eax,%eax
  802450:	78 40                	js     802492 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802452:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802459:	00 
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802461:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802468:	e8 06 e9 ff ff       	call   800d73 <sys_page_alloc>
		return r;
  80246d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80246f:	85 c0                	test   %eax,%eax
  802471:	78 1f                	js     802492 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802473:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802488:	89 04 24             	mov    %eax,(%esp)
  80248b:	e8 10 ec ff ff       	call   8010a0 <fd2num>
  802490:	89 c2                	mov    %eax,%edx
}
  802492:	89 d0                	mov    %edx,%eax
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	56                   	push   %esi
  80249a:	53                   	push   %ebx
  80249b:	83 ec 10             	sub    $0x10,%esp
  80249e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8024a7:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8024a9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8024ae:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8024b1:	89 04 24             	mov    %eax,(%esp)
  8024b4:	e8 d0 ea ff ff       	call   800f89 <sys_ipc_recv>
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	75 1e                	jne    8024db <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8024bd:	85 db                	test   %ebx,%ebx
  8024bf:	74 0a                	je     8024cb <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8024c1:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8024c6:	8b 40 74             	mov    0x74(%eax),%eax
  8024c9:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8024cb:	85 f6                	test   %esi,%esi
  8024cd:	74 22                	je     8024f1 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8024cf:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8024d4:	8b 40 78             	mov    0x78(%eax),%eax
  8024d7:	89 06                	mov    %eax,(%esi)
  8024d9:	eb 16                	jmp    8024f1 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8024db:	85 f6                	test   %esi,%esi
  8024dd:	74 06                	je     8024e5 <ipc_recv+0x4f>
				*perm_store = 0;
  8024df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8024e5:	85 db                	test   %ebx,%ebx
  8024e7:	74 10                	je     8024f9 <ipc_recv+0x63>
				*from_env_store=0;
  8024e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8024ef:	eb 08                	jmp    8024f9 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8024f1:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8024f6:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8024f9:	83 c4 10             	add    $0x10,%esp
  8024fc:	5b                   	pop    %ebx
  8024fd:	5e                   	pop    %esi
  8024fe:	5d                   	pop    %ebp
  8024ff:	c3                   	ret    

00802500 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	57                   	push   %edi
  802504:	56                   	push   %esi
  802505:	53                   	push   %ebx
  802506:	83 ec 1c             	sub    $0x1c,%esp
  802509:	8b 75 0c             	mov    0xc(%ebp),%esi
  80250c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80250f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802512:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802514:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802519:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80251c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802520:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802524:	89 74 24 04          	mov    %esi,0x4(%esp)
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	89 04 24             	mov    %eax,(%esp)
  80252e:	e8 33 ea ff ff       	call   800f66 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802533:	eb 1c                	jmp    802551 <ipc_send+0x51>
	{
		sys_yield();
  802535:	e8 1a e8 ff ff       	call   800d54 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80253a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80253e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802542:	89 74 24 04          	mov    %esi,0x4(%esp)
  802546:	8b 45 08             	mov    0x8(%ebp),%eax
  802549:	89 04 24             	mov    %eax,(%esp)
  80254c:	e8 15 ea ff ff       	call   800f66 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802551:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802554:	74 df                	je     802535 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802556:	83 c4 1c             	add    $0x1c,%esp
  802559:	5b                   	pop    %ebx
  80255a:	5e                   	pop    %esi
  80255b:	5f                   	pop    %edi
  80255c:	5d                   	pop    %ebp
  80255d:	c3                   	ret    

0080255e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802569:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80256c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802572:	8b 52 50             	mov    0x50(%edx),%edx
  802575:	39 ca                	cmp    %ecx,%edx
  802577:	75 0d                	jne    802586 <ipc_find_env+0x28>
			return envs[i].env_id;
  802579:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80257c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802581:	8b 40 40             	mov    0x40(%eax),%eax
  802584:	eb 0e                	jmp    802594 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802586:	83 c0 01             	add    $0x1,%eax
  802589:	3d 00 04 00 00       	cmp    $0x400,%eax
  80258e:	75 d9                	jne    802569 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802590:	66 b8 00 00          	mov    $0x0,%ax
}
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    

00802596 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80259c:	89 d0                	mov    %edx,%eax
  80259e:	c1 e8 16             	shr    $0x16,%eax
  8025a1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025ad:	f6 c1 01             	test   $0x1,%cl
  8025b0:	74 1d                	je     8025cf <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8025b2:	c1 ea 0c             	shr    $0xc,%edx
  8025b5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025bc:	f6 c2 01             	test   $0x1,%dl
  8025bf:	74 0e                	je     8025cf <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025c1:	c1 ea 0c             	shr    $0xc,%edx
  8025c4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025cb:	ef 
  8025cc:	0f b7 c0             	movzwl %ax,%eax
}
  8025cf:	5d                   	pop    %ebp
  8025d0:	c3                   	ret    
  8025d1:	66 90                	xchg   %ax,%ax
  8025d3:	66 90                	xchg   %ax,%ax
  8025d5:	66 90                	xchg   %ax,%ax
  8025d7:	66 90                	xchg   %ax,%ax
  8025d9:	66 90                	xchg   %ax,%ax
  8025db:	66 90                	xchg   %ax,%ax
  8025dd:	66 90                	xchg   %ax,%ax
  8025df:	90                   	nop

008025e0 <__udivdi3>:
  8025e0:	55                   	push   %ebp
  8025e1:	57                   	push   %edi
  8025e2:	56                   	push   %esi
  8025e3:	83 ec 0c             	sub    $0xc,%esp
  8025e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025ea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8025ee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8025f2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025fc:	89 ea                	mov    %ebp,%edx
  8025fe:	89 0c 24             	mov    %ecx,(%esp)
  802601:	75 2d                	jne    802630 <__udivdi3+0x50>
  802603:	39 e9                	cmp    %ebp,%ecx
  802605:	77 61                	ja     802668 <__udivdi3+0x88>
  802607:	85 c9                	test   %ecx,%ecx
  802609:	89 ce                	mov    %ecx,%esi
  80260b:	75 0b                	jne    802618 <__udivdi3+0x38>
  80260d:	b8 01 00 00 00       	mov    $0x1,%eax
  802612:	31 d2                	xor    %edx,%edx
  802614:	f7 f1                	div    %ecx
  802616:	89 c6                	mov    %eax,%esi
  802618:	31 d2                	xor    %edx,%edx
  80261a:	89 e8                	mov    %ebp,%eax
  80261c:	f7 f6                	div    %esi
  80261e:	89 c5                	mov    %eax,%ebp
  802620:	89 f8                	mov    %edi,%eax
  802622:	f7 f6                	div    %esi
  802624:	89 ea                	mov    %ebp,%edx
  802626:	83 c4 0c             	add    $0xc,%esp
  802629:	5e                   	pop    %esi
  80262a:	5f                   	pop    %edi
  80262b:	5d                   	pop    %ebp
  80262c:	c3                   	ret    
  80262d:	8d 76 00             	lea    0x0(%esi),%esi
  802630:	39 e8                	cmp    %ebp,%eax
  802632:	77 24                	ja     802658 <__udivdi3+0x78>
  802634:	0f bd e8             	bsr    %eax,%ebp
  802637:	83 f5 1f             	xor    $0x1f,%ebp
  80263a:	75 3c                	jne    802678 <__udivdi3+0x98>
  80263c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802640:	39 34 24             	cmp    %esi,(%esp)
  802643:	0f 86 9f 00 00 00    	jbe    8026e8 <__udivdi3+0x108>
  802649:	39 d0                	cmp    %edx,%eax
  80264b:	0f 82 97 00 00 00    	jb     8026e8 <__udivdi3+0x108>
  802651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802658:	31 d2                	xor    %edx,%edx
  80265a:	31 c0                	xor    %eax,%eax
  80265c:	83 c4 0c             	add    $0xc,%esp
  80265f:	5e                   	pop    %esi
  802660:	5f                   	pop    %edi
  802661:	5d                   	pop    %ebp
  802662:	c3                   	ret    
  802663:	90                   	nop
  802664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802668:	89 f8                	mov    %edi,%eax
  80266a:	f7 f1                	div    %ecx
  80266c:	31 d2                	xor    %edx,%edx
  80266e:	83 c4 0c             	add    $0xc,%esp
  802671:	5e                   	pop    %esi
  802672:	5f                   	pop    %edi
  802673:	5d                   	pop    %ebp
  802674:	c3                   	ret    
  802675:	8d 76 00             	lea    0x0(%esi),%esi
  802678:	89 e9                	mov    %ebp,%ecx
  80267a:	8b 3c 24             	mov    (%esp),%edi
  80267d:	d3 e0                	shl    %cl,%eax
  80267f:	89 c6                	mov    %eax,%esi
  802681:	b8 20 00 00 00       	mov    $0x20,%eax
  802686:	29 e8                	sub    %ebp,%eax
  802688:	89 c1                	mov    %eax,%ecx
  80268a:	d3 ef                	shr    %cl,%edi
  80268c:	89 e9                	mov    %ebp,%ecx
  80268e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802692:	8b 3c 24             	mov    (%esp),%edi
  802695:	09 74 24 08          	or     %esi,0x8(%esp)
  802699:	89 d6                	mov    %edx,%esi
  80269b:	d3 e7                	shl    %cl,%edi
  80269d:	89 c1                	mov    %eax,%ecx
  80269f:	89 3c 24             	mov    %edi,(%esp)
  8026a2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026a6:	d3 ee                	shr    %cl,%esi
  8026a8:	89 e9                	mov    %ebp,%ecx
  8026aa:	d3 e2                	shl    %cl,%edx
  8026ac:	89 c1                	mov    %eax,%ecx
  8026ae:	d3 ef                	shr    %cl,%edi
  8026b0:	09 d7                	or     %edx,%edi
  8026b2:	89 f2                	mov    %esi,%edx
  8026b4:	89 f8                	mov    %edi,%eax
  8026b6:	f7 74 24 08          	divl   0x8(%esp)
  8026ba:	89 d6                	mov    %edx,%esi
  8026bc:	89 c7                	mov    %eax,%edi
  8026be:	f7 24 24             	mull   (%esp)
  8026c1:	39 d6                	cmp    %edx,%esi
  8026c3:	89 14 24             	mov    %edx,(%esp)
  8026c6:	72 30                	jb     8026f8 <__udivdi3+0x118>
  8026c8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026cc:	89 e9                	mov    %ebp,%ecx
  8026ce:	d3 e2                	shl    %cl,%edx
  8026d0:	39 c2                	cmp    %eax,%edx
  8026d2:	73 05                	jae    8026d9 <__udivdi3+0xf9>
  8026d4:	3b 34 24             	cmp    (%esp),%esi
  8026d7:	74 1f                	je     8026f8 <__udivdi3+0x118>
  8026d9:	89 f8                	mov    %edi,%eax
  8026db:	31 d2                	xor    %edx,%edx
  8026dd:	e9 7a ff ff ff       	jmp    80265c <__udivdi3+0x7c>
  8026e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026e8:	31 d2                	xor    %edx,%edx
  8026ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8026ef:	e9 68 ff ff ff       	jmp    80265c <__udivdi3+0x7c>
  8026f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8026fb:	31 d2                	xor    %edx,%edx
  8026fd:	83 c4 0c             	add    $0xc,%esp
  802700:	5e                   	pop    %esi
  802701:	5f                   	pop    %edi
  802702:	5d                   	pop    %ebp
  802703:	c3                   	ret    
  802704:	66 90                	xchg   %ax,%ax
  802706:	66 90                	xchg   %ax,%ax
  802708:	66 90                	xchg   %ax,%ax
  80270a:	66 90                	xchg   %ax,%ax
  80270c:	66 90                	xchg   %ax,%ax
  80270e:	66 90                	xchg   %ax,%ax

00802710 <__umoddi3>:
  802710:	55                   	push   %ebp
  802711:	57                   	push   %edi
  802712:	56                   	push   %esi
  802713:	83 ec 14             	sub    $0x14,%esp
  802716:	8b 44 24 28          	mov    0x28(%esp),%eax
  80271a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80271e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802722:	89 c7                	mov    %eax,%edi
  802724:	89 44 24 04          	mov    %eax,0x4(%esp)
  802728:	8b 44 24 30          	mov    0x30(%esp),%eax
  80272c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802730:	89 34 24             	mov    %esi,(%esp)
  802733:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802737:	85 c0                	test   %eax,%eax
  802739:	89 c2                	mov    %eax,%edx
  80273b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80273f:	75 17                	jne    802758 <__umoddi3+0x48>
  802741:	39 fe                	cmp    %edi,%esi
  802743:	76 4b                	jbe    802790 <__umoddi3+0x80>
  802745:	89 c8                	mov    %ecx,%eax
  802747:	89 fa                	mov    %edi,%edx
  802749:	f7 f6                	div    %esi
  80274b:	89 d0                	mov    %edx,%eax
  80274d:	31 d2                	xor    %edx,%edx
  80274f:	83 c4 14             	add    $0x14,%esp
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    
  802756:	66 90                	xchg   %ax,%ax
  802758:	39 f8                	cmp    %edi,%eax
  80275a:	77 54                	ja     8027b0 <__umoddi3+0xa0>
  80275c:	0f bd e8             	bsr    %eax,%ebp
  80275f:	83 f5 1f             	xor    $0x1f,%ebp
  802762:	75 5c                	jne    8027c0 <__umoddi3+0xb0>
  802764:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802768:	39 3c 24             	cmp    %edi,(%esp)
  80276b:	0f 87 e7 00 00 00    	ja     802858 <__umoddi3+0x148>
  802771:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802775:	29 f1                	sub    %esi,%ecx
  802777:	19 c7                	sbb    %eax,%edi
  802779:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80277d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802781:	8b 44 24 08          	mov    0x8(%esp),%eax
  802785:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802789:	83 c4 14             	add    $0x14,%esp
  80278c:	5e                   	pop    %esi
  80278d:	5f                   	pop    %edi
  80278e:	5d                   	pop    %ebp
  80278f:	c3                   	ret    
  802790:	85 f6                	test   %esi,%esi
  802792:	89 f5                	mov    %esi,%ebp
  802794:	75 0b                	jne    8027a1 <__umoddi3+0x91>
  802796:	b8 01 00 00 00       	mov    $0x1,%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	f7 f6                	div    %esi
  80279f:	89 c5                	mov    %eax,%ebp
  8027a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027a5:	31 d2                	xor    %edx,%edx
  8027a7:	f7 f5                	div    %ebp
  8027a9:	89 c8                	mov    %ecx,%eax
  8027ab:	f7 f5                	div    %ebp
  8027ad:	eb 9c                	jmp    80274b <__umoddi3+0x3b>
  8027af:	90                   	nop
  8027b0:	89 c8                	mov    %ecx,%eax
  8027b2:	89 fa                	mov    %edi,%edx
  8027b4:	83 c4 14             	add    $0x14,%esp
  8027b7:	5e                   	pop    %esi
  8027b8:	5f                   	pop    %edi
  8027b9:	5d                   	pop    %ebp
  8027ba:	c3                   	ret    
  8027bb:	90                   	nop
  8027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027c0:	8b 04 24             	mov    (%esp),%eax
  8027c3:	be 20 00 00 00       	mov    $0x20,%esi
  8027c8:	89 e9                	mov    %ebp,%ecx
  8027ca:	29 ee                	sub    %ebp,%esi
  8027cc:	d3 e2                	shl    %cl,%edx
  8027ce:	89 f1                	mov    %esi,%ecx
  8027d0:	d3 e8                	shr    %cl,%eax
  8027d2:	89 e9                	mov    %ebp,%ecx
  8027d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d8:	8b 04 24             	mov    (%esp),%eax
  8027db:	09 54 24 04          	or     %edx,0x4(%esp)
  8027df:	89 fa                	mov    %edi,%edx
  8027e1:	d3 e0                	shl    %cl,%eax
  8027e3:	89 f1                	mov    %esi,%ecx
  8027e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8027ed:	d3 ea                	shr    %cl,%edx
  8027ef:	89 e9                	mov    %ebp,%ecx
  8027f1:	d3 e7                	shl    %cl,%edi
  8027f3:	89 f1                	mov    %esi,%ecx
  8027f5:	d3 e8                	shr    %cl,%eax
  8027f7:	89 e9                	mov    %ebp,%ecx
  8027f9:	09 f8                	or     %edi,%eax
  8027fb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8027ff:	f7 74 24 04          	divl   0x4(%esp)
  802803:	d3 e7                	shl    %cl,%edi
  802805:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802809:	89 d7                	mov    %edx,%edi
  80280b:	f7 64 24 08          	mull   0x8(%esp)
  80280f:	39 d7                	cmp    %edx,%edi
  802811:	89 c1                	mov    %eax,%ecx
  802813:	89 14 24             	mov    %edx,(%esp)
  802816:	72 2c                	jb     802844 <__umoddi3+0x134>
  802818:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80281c:	72 22                	jb     802840 <__umoddi3+0x130>
  80281e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802822:	29 c8                	sub    %ecx,%eax
  802824:	19 d7                	sbb    %edx,%edi
  802826:	89 e9                	mov    %ebp,%ecx
  802828:	89 fa                	mov    %edi,%edx
  80282a:	d3 e8                	shr    %cl,%eax
  80282c:	89 f1                	mov    %esi,%ecx
  80282e:	d3 e2                	shl    %cl,%edx
  802830:	89 e9                	mov    %ebp,%ecx
  802832:	d3 ef                	shr    %cl,%edi
  802834:	09 d0                	or     %edx,%eax
  802836:	89 fa                	mov    %edi,%edx
  802838:	83 c4 14             	add    $0x14,%esp
  80283b:	5e                   	pop    %esi
  80283c:	5f                   	pop    %edi
  80283d:	5d                   	pop    %ebp
  80283e:	c3                   	ret    
  80283f:	90                   	nop
  802840:	39 d7                	cmp    %edx,%edi
  802842:	75 da                	jne    80281e <__umoddi3+0x10e>
  802844:	8b 14 24             	mov    (%esp),%edx
  802847:	89 c1                	mov    %eax,%ecx
  802849:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80284d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802851:	eb cb                	jmp    80281e <__umoddi3+0x10e>
  802853:	90                   	nop
  802854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802858:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80285c:	0f 82 0f ff ff ff    	jb     802771 <__umoddi3+0x61>
  802862:	e9 1a ff ff ff       	jmp    802781 <__umoddi3+0x71>
