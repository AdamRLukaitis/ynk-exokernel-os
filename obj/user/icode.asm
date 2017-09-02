
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 27 01 00 00       	call   800158 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 40 80 00 e0 	movl   $0x802ce0,0x804000
  800045:	2c 80 00 

	cprintf("icode startup\n");
  800048:	c7 04 24 e6 2c 80 00 	movl   $0x802ce6,(%esp)
  80004f:	e8 68 02 00 00       	call   8002bc <cprintf>

	cprintf("icode: open /motd\n");
  800054:	c7 04 24 f5 2c 80 00 	movl   $0x802cf5,(%esp)
  80005b:	e8 5c 02 00 00       	call   8002bc <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800060:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800067:	00 
  800068:	c7 04 24 08 2d 80 00 	movl   $0x802d08,(%esp)
  80006f:	e8 9f 17 00 00       	call   801813 <open>
  800074:	89 c6                	mov    %eax,%esi
  800076:	85 c0                	test   %eax,%eax
  800078:	79 20                	jns    80009a <umain+0x67>
		panic("icode: open /motd: %e", fd);
  80007a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007e:	c7 44 24 08 0e 2d 80 	movl   $0x802d0e,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800095:	e8 29 01 00 00       	call   8001c3 <_panic>

	cprintf("icode: read /motd\n");
  80009a:	c7 04 24 31 2d 80 00 	movl   $0x802d31,(%esp)
  8000a1:	e8 16 02 00 00       	call   8002bc <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a6:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ac:	eb 0c                	jmp    8000ba <umain+0x87>
		sys_cputs(buf, n);
  8000ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b2:	89 1c 24             	mov    %ebx,(%esp)
  8000b5:	e8 7c 0b 00 00       	call   800c36 <sys_cputs>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ba:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c1:	00 
  8000c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c6:	89 34 24             	mov    %esi,(%esp)
  8000c9:	e8 6c 12 00 00       	call   80133a <read>
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f dc                	jg     8000ae <umain+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d2:	c7 04 24 44 2d 80 00 	movl   $0x802d44,(%esp)
  8000d9:	e8 de 01 00 00       	call   8002bc <cprintf>
	close(fd);
  8000de:	89 34 24             	mov    %esi,(%esp)
  8000e1:	e8 f1 10 00 00       	call   8011d7 <close>

	cprintf("icode: spawn /init\n");
  8000e6:	c7 04 24 58 2d 80 00 	movl   $0x802d58,(%esp)
  8000ed:	e8 ca 01 00 00       	call   8002bc <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000f9:	00 
  8000fa:	c7 44 24 0c 6c 2d 80 	movl   $0x802d6c,0xc(%esp)
  800101:	00 
  800102:	c7 44 24 08 75 2d 80 	movl   $0x802d75,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 7f 2d 80 	movl   $0x802d7f,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 7e 2d 80 00 	movl   $0x802d7e,(%esp)
  800119:	e8 3a 1d 00 00       	call   801e58 <spawnl>
  80011e:	85 c0                	test   %eax,%eax
  800120:	79 20                	jns    800142 <umain+0x10f>
		panic("icode: spawn /init: %e", r);
  800122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800126:	c7 44 24 08 84 2d 80 	movl   $0x802d84,0x8(%esp)
  80012d:	00 
  80012e:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800135:	00 
  800136:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  80013d:	e8 81 00 00 00       	call   8001c3 <_panic>

	cprintf("icode: exiting\n");
  800142:	c7 04 24 9b 2d 80 00 	movl   $0x802d9b,(%esp)
  800149:	e8 6e 01 00 00       	call   8002bc <cprintf>
}
  80014e:	81 c4 30 02 00 00    	add    $0x230,%esp
  800154:	5b                   	pop    %ebx
  800155:	5e                   	pop    %esi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 10             	sub    $0x10,%esp
  800160:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800163:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800166:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80016d:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800170:	e8 50 0b 00 00       	call   800cc5 <sys_getenvid>
  800175:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80017a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80017d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800182:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800187:	85 db                	test   %ebx,%ebx
  800189:	7e 07                	jle    800192 <libmain+0x3a>
		binaryname = argv[0];
  80018b:	8b 06                	mov    (%esi),%eax
  80018d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800192:	89 74 24 04          	mov    %esi,0x4(%esp)
  800196:	89 1c 24             	mov    %ebx,(%esp)
  800199:	e8 95 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80019e:	e8 07 00 00 00       	call   8001aa <exit>
}
  8001a3:	83 c4 10             	add    $0x10,%esp
  8001a6:	5b                   	pop    %ebx
  8001a7:	5e                   	pop    %esi
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    

008001aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b0:	e8 55 10 00 00       	call   80120a <close_all>
	sys_env_destroy(0);
  8001b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001bc:	e8 b2 0a 00 00       	call   800c73 <sys_env_destroy>
}
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	56                   	push   %esi
  8001c7:	53                   	push   %ebx
  8001c8:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001cb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001ce:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001d4:	e8 ec 0a 00 00       	call   800cc5 <sys_getenvid>
  8001d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001dc:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001e7:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ef:	c7 04 24 b8 2d 80 00 	movl   $0x802db8,(%esp)
  8001f6:	e8 c1 00 00 00       	call   8002bc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001fb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001ff:	8b 45 10             	mov    0x10(%ebp),%eax
  800202:	89 04 24             	mov    %eax,(%esp)
  800205:	e8 51 00 00 00       	call   80025b <vcprintf>
	cprintf("\n");
  80020a:	c7 04 24 bd 32 80 00 	movl   $0x8032bd,(%esp)
  800211:	e8 a6 00 00 00       	call   8002bc <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800216:	cc                   	int3   
  800217:	eb fd                	jmp    800216 <_panic+0x53>

00800219 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	53                   	push   %ebx
  80021d:	83 ec 14             	sub    $0x14,%esp
  800220:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800223:	8b 13                	mov    (%ebx),%edx
  800225:	8d 42 01             	lea    0x1(%edx),%eax
  800228:	89 03                	mov    %eax,(%ebx)
  80022a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80022d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800231:	3d ff 00 00 00       	cmp    $0xff,%eax
  800236:	75 19                	jne    800251 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800238:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80023f:	00 
  800240:	8d 43 08             	lea    0x8(%ebx),%eax
  800243:	89 04 24             	mov    %eax,(%esp)
  800246:	e8 eb 09 00 00       	call   800c36 <sys_cputs>
		b->idx = 0;
  80024b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800251:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800255:	83 c4 14             	add    $0x14,%esp
  800258:	5b                   	pop    %ebx
  800259:	5d                   	pop    %ebp
  80025a:	c3                   	ret    

0080025b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800264:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026b:	00 00 00 
	b.cnt = 0;
  80026e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800275:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80027f:	8b 45 08             	mov    0x8(%ebp),%eax
  800282:	89 44 24 08          	mov    %eax,0x8(%esp)
  800286:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800290:	c7 04 24 19 02 80 00 	movl   $0x800219,(%esp)
  800297:	e8 b2 01 00 00       	call   80044e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80029c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002ac:	89 04 24             	mov    %eax,(%esp)
  8002af:	e8 82 09 00 00       	call   800c36 <sys_cputs>

	return b.cnt;
}
  8002b4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cc:	89 04 24             	mov    %eax,(%esp)
  8002cf:	e8 87 ff ff ff       	call   80025b <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    
  8002d6:	66 90                	xchg   %ax,%ax
  8002d8:	66 90                	xchg   %ax,%ax
  8002da:	66 90                	xchg   %ax,%ax
  8002dc:	66 90                	xchg   %ax,%ax
  8002de:	66 90                	xchg   %ax,%ax

008002e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 3c             	sub    $0x3c,%esp
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	89 d7                	mov    %edx,%edi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f7:	89 c3                	mov    %eax,%ebx
  8002f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800302:	b9 00 00 00 00       	mov    $0x0,%ecx
  800307:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80030d:	39 d9                	cmp    %ebx,%ecx
  80030f:	72 05                	jb     800316 <printnum+0x36>
  800311:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800314:	77 69                	ja     80037f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800316:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800319:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80031d:	83 ee 01             	sub    $0x1,%esi
  800320:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800324:	89 44 24 08          	mov    %eax,0x8(%esp)
  800328:	8b 44 24 08          	mov    0x8(%esp),%eax
  80032c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800330:	89 c3                	mov    %eax,%ebx
  800332:	89 d6                	mov    %edx,%esi
  800334:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800337:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80033a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80033e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034f:	e8 fc 26 00 00       	call   802a50 <__udivdi3>
  800354:	89 d9                	mov    %ebx,%ecx
  800356:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80035a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80035e:	89 04 24             	mov    %eax,(%esp)
  800361:	89 54 24 04          	mov    %edx,0x4(%esp)
  800365:	89 fa                	mov    %edi,%edx
  800367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80036a:	e8 71 ff ff ff       	call   8002e0 <printnum>
  80036f:	eb 1b                	jmp    80038c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800371:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800375:	8b 45 18             	mov    0x18(%ebp),%eax
  800378:	89 04 24             	mov    %eax,(%esp)
  80037b:	ff d3                	call   *%ebx
  80037d:	eb 03                	jmp    800382 <printnum+0xa2>
  80037f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800382:	83 ee 01             	sub    $0x1,%esi
  800385:	85 f6                	test   %esi,%esi
  800387:	7f e8                	jg     800371 <printnum+0x91>
  800389:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800390:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800394:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800397:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80039a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80039e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003af:	e8 cc 27 00 00       	call   802b80 <__umoddi3>
  8003b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b8:	0f be 80 db 2d 80 00 	movsbl 0x802ddb(%eax),%eax
  8003bf:	89 04 24             	mov    %eax,(%esp)
  8003c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003c5:	ff d0                	call   *%eax
}
  8003c7:	83 c4 3c             	add    $0x3c,%esp
  8003ca:	5b                   	pop    %ebx
  8003cb:	5e                   	pop    %esi
  8003cc:	5f                   	pop    %edi
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d2:	83 fa 01             	cmp    $0x1,%edx
  8003d5:	7e 0e                	jle    8003e5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003d7:	8b 10                	mov    (%eax),%edx
  8003d9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003dc:	89 08                	mov    %ecx,(%eax)
  8003de:	8b 02                	mov    (%edx),%eax
  8003e0:	8b 52 04             	mov    0x4(%edx),%edx
  8003e3:	eb 22                	jmp    800407 <getuint+0x38>
	else if (lflag)
  8003e5:	85 d2                	test   %edx,%edx
  8003e7:	74 10                	je     8003f9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ee:	89 08                	mov    %ecx,(%eax)
  8003f0:	8b 02                	mov    (%edx),%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f7:	eb 0e                	jmp    800407 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003f9:	8b 10                	mov    (%eax),%edx
  8003fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003fe:	89 08                	mov    %ecx,(%eax)
  800400:	8b 02                	mov    (%edx),%eax
  800402:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800407:	5d                   	pop    %ebp
  800408:	c3                   	ret    

00800409 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80040f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800413:	8b 10                	mov    (%eax),%edx
  800415:	3b 50 04             	cmp    0x4(%eax),%edx
  800418:	73 0a                	jae    800424 <sprintputch+0x1b>
		*b->buf++ = ch;
  80041a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80041d:	89 08                	mov    %ecx,(%eax)
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	88 02                	mov    %al,(%edx)
}
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80042c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80042f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800433:	8b 45 10             	mov    0x10(%ebp),%eax
  800436:	89 44 24 08          	mov    %eax,0x8(%esp)
  80043a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	89 04 24             	mov    %eax,(%esp)
  800447:	e8 02 00 00 00       	call   80044e <vprintfmt>
	va_end(ap);
}
  80044c:	c9                   	leave  
  80044d:	c3                   	ret    

0080044e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	57                   	push   %edi
  800452:	56                   	push   %esi
  800453:	53                   	push   %ebx
  800454:	83 ec 3c             	sub    $0x3c,%esp
  800457:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80045a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80045d:	eb 14                	jmp    800473 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80045f:	85 c0                	test   %eax,%eax
  800461:	0f 84 b3 03 00 00    	je     80081a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800467:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046b:	89 04 24             	mov    %eax,(%esp)
  80046e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800471:	89 f3                	mov    %esi,%ebx
  800473:	8d 73 01             	lea    0x1(%ebx),%esi
  800476:	0f b6 03             	movzbl (%ebx),%eax
  800479:	83 f8 25             	cmp    $0x25,%eax
  80047c:	75 e1                	jne    80045f <vprintfmt+0x11>
  80047e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800482:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800489:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800490:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800497:	ba 00 00 00 00       	mov    $0x0,%edx
  80049c:	eb 1d                	jmp    8004bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004a0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004a4:	eb 15                	jmp    8004bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004a8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004ac:	eb 0d                	jmp    8004bb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004be:	0f b6 0e             	movzbl (%esi),%ecx
  8004c1:	0f b6 c1             	movzbl %cl,%eax
  8004c4:	83 e9 23             	sub    $0x23,%ecx
  8004c7:	80 f9 55             	cmp    $0x55,%cl
  8004ca:	0f 87 2a 03 00 00    	ja     8007fa <vprintfmt+0x3ac>
  8004d0:	0f b6 c9             	movzbl %cl,%ecx
  8004d3:	ff 24 8d 20 2f 80 00 	jmp    *0x802f20(,%ecx,4)
  8004da:	89 de                	mov    %ebx,%esi
  8004dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004e1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004e4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004e8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004eb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004ee:	83 fb 09             	cmp    $0x9,%ebx
  8004f1:	77 36                	ja     800529 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004f6:	eb e9                	jmp    8004e1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8d 48 04             	lea    0x4(%eax),%ecx
  8004fe:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800501:	8b 00                	mov    (%eax),%eax
  800503:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800506:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800508:	eb 22                	jmp    80052c <vprintfmt+0xde>
  80050a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80050d:	85 c9                	test   %ecx,%ecx
  80050f:	b8 00 00 00 00       	mov    $0x0,%eax
  800514:	0f 49 c1             	cmovns %ecx,%eax
  800517:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	89 de                	mov    %ebx,%esi
  80051c:	eb 9d                	jmp    8004bb <vprintfmt+0x6d>
  80051e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800520:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800527:	eb 92                	jmp    8004bb <vprintfmt+0x6d>
  800529:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80052c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800530:	79 89                	jns    8004bb <vprintfmt+0x6d>
  800532:	e9 77 ff ff ff       	jmp    8004ae <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800537:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80053c:	e9 7a ff ff ff       	jmp    8004bb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8d 50 04             	lea    0x4(%eax),%edx
  800547:	89 55 14             	mov    %edx,0x14(%ebp)
  80054a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	89 04 24             	mov    %eax,(%esp)
  800553:	ff 55 08             	call   *0x8(%ebp)
			break;
  800556:	e9 18 ff ff ff       	jmp    800473 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8d 50 04             	lea    0x4(%eax),%edx
  800561:	89 55 14             	mov    %edx,0x14(%ebp)
  800564:	8b 00                	mov    (%eax),%eax
  800566:	99                   	cltd   
  800567:	31 d0                	xor    %edx,%eax
  800569:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80056b:	83 f8 0f             	cmp    $0xf,%eax
  80056e:	7f 0b                	jg     80057b <vprintfmt+0x12d>
  800570:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  800577:	85 d2                	test   %edx,%edx
  800579:	75 20                	jne    80059b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80057b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80057f:	c7 44 24 08 f3 2d 80 	movl   $0x802df3,0x8(%esp)
  800586:	00 
  800587:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	89 04 24             	mov    %eax,(%esp)
  800591:	e8 90 fe ff ff       	call   800426 <printfmt>
  800596:	e9 d8 fe ff ff       	jmp    800473 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80059b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80059f:	c7 44 24 08 b5 31 80 	movl   $0x8031b5,0x8(%esp)
  8005a6:	00 
  8005a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	89 04 24             	mov    %eax,(%esp)
  8005b1:	e8 70 fe ff ff       	call   800426 <printfmt>
  8005b6:	e9 b8 fe ff ff       	jmp    800473 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8005cd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005cf:	85 f6                	test   %esi,%esi
  8005d1:	b8 ec 2d 80 00       	mov    $0x802dec,%eax
  8005d6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005d9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005dd:	0f 84 97 00 00 00    	je     80067a <vprintfmt+0x22c>
  8005e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005e7:	0f 8e 9b 00 00 00    	jle    800688 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005f1:	89 34 24             	mov    %esi,(%esp)
  8005f4:	e8 cf 02 00 00       	call   8008c8 <strnlen>
  8005f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005fc:	29 c2                	sub    %eax,%edx
  8005fe:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800601:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800605:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800608:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800611:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800613:	eb 0f                	jmp    800624 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800615:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800619:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80061c:	89 04 24             	mov    %eax,(%esp)
  80061f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800621:	83 eb 01             	sub    $0x1,%ebx
  800624:	85 db                	test   %ebx,%ebx
  800626:	7f ed                	jg     800615 <vprintfmt+0x1c7>
  800628:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80062b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80062e:	85 d2                	test   %edx,%edx
  800630:	b8 00 00 00 00       	mov    $0x0,%eax
  800635:	0f 49 c2             	cmovns %edx,%eax
  800638:	29 c2                	sub    %eax,%edx
  80063a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80063d:	89 d7                	mov    %edx,%edi
  80063f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800642:	eb 50                	jmp    800694 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800644:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800648:	74 1e                	je     800668 <vprintfmt+0x21a>
  80064a:	0f be d2             	movsbl %dl,%edx
  80064d:	83 ea 20             	sub    $0x20,%edx
  800650:	83 fa 5e             	cmp    $0x5e,%edx
  800653:	76 13                	jbe    800668 <vprintfmt+0x21a>
					putch('?', putdat);
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800663:	ff 55 08             	call   *0x8(%ebp)
  800666:	eb 0d                	jmp    800675 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80066f:	89 04 24             	mov    %eax,(%esp)
  800672:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800675:	83 ef 01             	sub    $0x1,%edi
  800678:	eb 1a                	jmp    800694 <vprintfmt+0x246>
  80067a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80067d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800680:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800683:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800686:	eb 0c                	jmp    800694 <vprintfmt+0x246>
  800688:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80068b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80068e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800691:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800694:	83 c6 01             	add    $0x1,%esi
  800697:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80069b:	0f be c2             	movsbl %dl,%eax
  80069e:	85 c0                	test   %eax,%eax
  8006a0:	74 27                	je     8006c9 <vprintfmt+0x27b>
  8006a2:	85 db                	test   %ebx,%ebx
  8006a4:	78 9e                	js     800644 <vprintfmt+0x1f6>
  8006a6:	83 eb 01             	sub    $0x1,%ebx
  8006a9:	79 99                	jns    800644 <vprintfmt+0x1f6>
  8006ab:	89 f8                	mov    %edi,%eax
  8006ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b3:	89 c3                	mov    %eax,%ebx
  8006b5:	eb 1a                	jmp    8006d1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006c2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c4:	83 eb 01             	sub    $0x1,%ebx
  8006c7:	eb 08                	jmp    8006d1 <vprintfmt+0x283>
  8006c9:	89 fb                	mov    %edi,%ebx
  8006cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006d1:	85 db                	test   %ebx,%ebx
  8006d3:	7f e2                	jg     8006b7 <vprintfmt+0x269>
  8006d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006db:	e9 93 fd ff ff       	jmp    800473 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006e0:	83 fa 01             	cmp    $0x1,%edx
  8006e3:	7e 16                	jle    8006fb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 50 08             	lea    0x8(%eax),%edx
  8006eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006f9:	eb 32                	jmp    80072d <vprintfmt+0x2df>
	else if (lflag)
  8006fb:	85 d2                	test   %edx,%edx
  8006fd:	74 18                	je     800717 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 50 04             	lea    0x4(%eax),%edx
  800705:	89 55 14             	mov    %edx,0x14(%ebp)
  800708:	8b 30                	mov    (%eax),%esi
  80070a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80070d:	89 f0                	mov    %esi,%eax
  80070f:	c1 f8 1f             	sar    $0x1f,%eax
  800712:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800715:	eb 16                	jmp    80072d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	89 55 14             	mov    %edx,0x14(%ebp)
  800720:	8b 30                	mov    (%eax),%esi
  800722:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800725:	89 f0                	mov    %esi,%eax
  800727:	c1 f8 1f             	sar    $0x1f,%eax
  80072a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800730:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800733:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800738:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073c:	0f 89 80 00 00 00    	jns    8007c2 <vprintfmt+0x374>
				putch('-', putdat);
  800742:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800746:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80074d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800753:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800756:	f7 d8                	neg    %eax
  800758:	83 d2 00             	adc    $0x0,%edx
  80075b:	f7 da                	neg    %edx
			}
			base = 10;
  80075d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800762:	eb 5e                	jmp    8007c2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800764:	8d 45 14             	lea    0x14(%ebp),%eax
  800767:	e8 63 fc ff ff       	call   8003cf <getuint>
			base = 10;
  80076c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800771:	eb 4f                	jmp    8007c2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800773:	8d 45 14             	lea    0x14(%ebp),%eax
  800776:	e8 54 fc ff ff       	call   8003cf <getuint>
			base =8;
  80077b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800780:	eb 40                	jmp    8007c2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800782:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800786:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80078d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800790:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800794:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80079b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 50 04             	lea    0x4(%eax),%edx
  8007a4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007ae:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007b3:	eb 0d                	jmp    8007c2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b8:	e8 12 fc ff ff       	call   8003cf <getuint>
			base = 16;
  8007bd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007c2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007c6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007ca:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007cd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007d5:	89 04 24             	mov    %eax,(%esp)
  8007d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007dc:	89 fa                	mov    %edi,%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	e8 fa fa ff ff       	call   8002e0 <printnum>
			break;
  8007e6:	e9 88 fc ff ff       	jmp    800473 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ef:	89 04 24             	mov    %eax,(%esp)
  8007f2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007f5:	e9 79 fc ff ff       	jmp    800473 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007fe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800805:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800808:	89 f3                	mov    %esi,%ebx
  80080a:	eb 03                	jmp    80080f <vprintfmt+0x3c1>
  80080c:	83 eb 01             	sub    $0x1,%ebx
  80080f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800813:	75 f7                	jne    80080c <vprintfmt+0x3be>
  800815:	e9 59 fc ff ff       	jmp    800473 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80081a:	83 c4 3c             	add    $0x3c,%esp
  80081d:	5b                   	pop    %ebx
  80081e:	5e                   	pop    %esi
  80081f:	5f                   	pop    %edi
  800820:	5d                   	pop    %ebp
  800821:	c3                   	ret    

00800822 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	83 ec 28             	sub    $0x28,%esp
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80082e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800831:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800835:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800838:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083f:	85 c0                	test   %eax,%eax
  800841:	74 30                	je     800873 <vsnprintf+0x51>
  800843:	85 d2                	test   %edx,%edx
  800845:	7e 2c                	jle    800873 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80084e:	8b 45 10             	mov    0x10(%ebp),%eax
  800851:	89 44 24 08          	mov    %eax,0x8(%esp)
  800855:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085c:	c7 04 24 09 04 80 00 	movl   $0x800409,(%esp)
  800863:	e8 e6 fb ff ff       	call   80044e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800871:	eb 05                	jmp    800878 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800873:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800880:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800883:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800887:	8b 45 10             	mov    0x10(%ebp),%eax
  80088a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80088e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800891:	89 44 24 04          	mov    %eax,0x4(%esp)
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	89 04 24             	mov    %eax,(%esp)
  80089b:	e8 82 ff ff ff       	call   800822 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a0:	c9                   	leave  
  8008a1:	c3                   	ret    
  8008a2:	66 90                	xchg   %ax,%ax
  8008a4:	66 90                	xchg   %ax,%ax
  8008a6:	66 90                	xchg   %ax,%ax
  8008a8:	66 90                	xchg   %ax,%ax
  8008aa:	66 90                	xchg   %ax,%ax
  8008ac:	66 90                	xchg   %ax,%ax
  8008ae:	66 90                	xchg   %ax,%ax

008008b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	eb 03                	jmp    8008c0 <strlen+0x10>
		n++;
  8008bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c4:	75 f7                	jne    8008bd <strlen+0xd>
		n++;
	return n;
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	eb 03                	jmp    8008db <strnlen+0x13>
		n++;
  8008d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	39 d0                	cmp    %edx,%eax
  8008dd:	74 06                	je     8008e5 <strnlen+0x1d>
  8008df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e3:	75 f3                	jne    8008d8 <strnlen+0x10>
		n++;
	return n;
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	83 c2 01             	add    $0x1,%edx
  8008f6:	83 c1 01             	add    $0x1,%ecx
  8008f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800900:	84 db                	test   %bl,%bl
  800902:	75 ef                	jne    8008f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800904:	5b                   	pop    %ebx
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	53                   	push   %ebx
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800911:	89 1c 24             	mov    %ebx,(%esp)
  800914:	e8 97 ff ff ff       	call   8008b0 <strlen>
	strcpy(dst + len, src);
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800920:	01 d8                	add    %ebx,%eax
  800922:	89 04 24             	mov    %eax,(%esp)
  800925:	e8 bd ff ff ff       	call   8008e7 <strcpy>
	return dst;
}
  80092a:	89 d8                	mov    %ebx,%eax
  80092c:	83 c4 08             	add    $0x8,%esp
  80092f:	5b                   	pop    %ebx
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	8b 75 08             	mov    0x8(%ebp),%esi
  80093a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093d:	89 f3                	mov    %esi,%ebx
  80093f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800942:	89 f2                	mov    %esi,%edx
  800944:	eb 0f                	jmp    800955 <strncpy+0x23>
		*dst++ = *src;
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	0f b6 01             	movzbl (%ecx),%eax
  80094c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094f:	80 39 01             	cmpb   $0x1,(%ecx)
  800952:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800955:	39 da                	cmp    %ebx,%edx
  800957:	75 ed                	jne    800946 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800959:	89 f0                	mov    %esi,%eax
  80095b:	5b                   	pop    %ebx
  80095c:	5e                   	pop    %esi
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	56                   	push   %esi
  800963:	53                   	push   %ebx
  800964:	8b 75 08             	mov    0x8(%ebp),%esi
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80096d:	89 f0                	mov    %esi,%eax
  80096f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800973:	85 c9                	test   %ecx,%ecx
  800975:	75 0b                	jne    800982 <strlcpy+0x23>
  800977:	eb 1d                	jmp    800996 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	83 c2 01             	add    $0x1,%edx
  80097f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800982:	39 d8                	cmp    %ebx,%eax
  800984:	74 0b                	je     800991 <strlcpy+0x32>
  800986:	0f b6 0a             	movzbl (%edx),%ecx
  800989:	84 c9                	test   %cl,%cl
  80098b:	75 ec                	jne    800979 <strlcpy+0x1a>
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	eb 02                	jmp    800993 <strlcpy+0x34>
  800991:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800993:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800996:	29 f0                	sub    %esi,%eax
}
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a5:	eb 06                	jmp    8009ad <strcmp+0x11>
		p++, q++;
  8009a7:	83 c1 01             	add    $0x1,%ecx
  8009aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 04                	je     8009b8 <strcmp+0x1c>
  8009b4:	3a 02                	cmp    (%edx),%al
  8009b6:	74 ef                	je     8009a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b8:	0f b6 c0             	movzbl %al,%eax
  8009bb:	0f b6 12             	movzbl (%edx),%edx
  8009be:	29 d0                	sub    %edx,%eax
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	53                   	push   %ebx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	89 c3                	mov    %eax,%ebx
  8009ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d1:	eb 06                	jmp    8009d9 <strncmp+0x17>
		n--, p++, q++;
  8009d3:	83 c0 01             	add    $0x1,%eax
  8009d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009d9:	39 d8                	cmp    %ebx,%eax
  8009db:	74 15                	je     8009f2 <strncmp+0x30>
  8009dd:	0f b6 08             	movzbl (%eax),%ecx
  8009e0:	84 c9                	test   %cl,%cl
  8009e2:	74 04                	je     8009e8 <strncmp+0x26>
  8009e4:	3a 0a                	cmp    (%edx),%cl
  8009e6:	74 eb                	je     8009d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e8:	0f b6 00             	movzbl (%eax),%eax
  8009eb:	0f b6 12             	movzbl (%edx),%edx
  8009ee:	29 d0                	sub    %edx,%eax
  8009f0:	eb 05                	jmp    8009f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a04:	eb 07                	jmp    800a0d <strchr+0x13>
		if (*s == c)
  800a06:	38 ca                	cmp    %cl,%dl
  800a08:	74 0f                	je     800a19 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	0f b6 10             	movzbl (%eax),%edx
  800a10:	84 d2                	test   %dl,%dl
  800a12:	75 f2                	jne    800a06 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a25:	eb 07                	jmp    800a2e <strfind+0x13>
		if (*s == c)
  800a27:	38 ca                	cmp    %cl,%dl
  800a29:	74 0a                	je     800a35 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	0f b6 10             	movzbl (%eax),%edx
  800a31:	84 d2                	test   %dl,%dl
  800a33:	75 f2                	jne    800a27 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	57                   	push   %edi
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a43:	85 c9                	test   %ecx,%ecx
  800a45:	74 36                	je     800a7d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a47:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4d:	75 28                	jne    800a77 <memset+0x40>
  800a4f:	f6 c1 03             	test   $0x3,%cl
  800a52:	75 23                	jne    800a77 <memset+0x40>
		c &= 0xFF;
  800a54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a58:	89 d3                	mov    %edx,%ebx
  800a5a:	c1 e3 08             	shl    $0x8,%ebx
  800a5d:	89 d6                	mov    %edx,%esi
  800a5f:	c1 e6 18             	shl    $0x18,%esi
  800a62:	89 d0                	mov    %edx,%eax
  800a64:	c1 e0 10             	shl    $0x10,%eax
  800a67:	09 f0                	or     %esi,%eax
  800a69:	09 c2                	or     %eax,%edx
  800a6b:	89 d0                	mov    %edx,%eax
  800a6d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a6f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a72:	fc                   	cld    
  800a73:	f3 ab                	rep stos %eax,%es:(%edi)
  800a75:	eb 06                	jmp    800a7d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	fc                   	cld    
  800a7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7d:	89 f8                	mov    %edi,%eax
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5f                   	pop    %edi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	57                   	push   %edi
  800a88:	56                   	push   %esi
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a92:	39 c6                	cmp    %eax,%esi
  800a94:	73 35                	jae    800acb <memmove+0x47>
  800a96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a99:	39 d0                	cmp    %edx,%eax
  800a9b:	73 2e                	jae    800acb <memmove+0x47>
		s += n;
		d += n;
  800a9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800aa0:	89 d6                	mov    %edx,%esi
  800aa2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaa:	75 13                	jne    800abf <memmove+0x3b>
  800aac:	f6 c1 03             	test   $0x3,%cl
  800aaf:	75 0e                	jne    800abf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb 09                	jmp    800ac8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abf:	83 ef 01             	sub    $0x1,%edi
  800ac2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac8:	fc                   	cld    
  800ac9:	eb 1d                	jmp    800ae8 <memmove+0x64>
  800acb:	89 f2                	mov    %esi,%edx
  800acd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acf:	f6 c2 03             	test   $0x3,%dl
  800ad2:	75 0f                	jne    800ae3 <memmove+0x5f>
  800ad4:	f6 c1 03             	test   $0x3,%cl
  800ad7:	75 0a                	jne    800ae3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800adc:	89 c7                	mov    %eax,%edi
  800ade:	fc                   	cld    
  800adf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae1:	eb 05                	jmp    800ae8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae3:	89 c7                	mov    %eax,%edi
  800ae5:	fc                   	cld    
  800ae6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 04 24             	mov    %eax,(%esp)
  800b06:	e8 79 ff ff ff       	call   800a84 <memmove>
}
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b18:	89 d6                	mov    %edx,%esi
  800b1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1d:	eb 1a                	jmp    800b39 <memcmp+0x2c>
		if (*s1 != *s2)
  800b1f:	0f b6 02             	movzbl (%edx),%eax
  800b22:	0f b6 19             	movzbl (%ecx),%ebx
  800b25:	38 d8                	cmp    %bl,%al
  800b27:	74 0a                	je     800b33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b29:	0f b6 c0             	movzbl %al,%eax
  800b2c:	0f b6 db             	movzbl %bl,%ebx
  800b2f:	29 d8                	sub    %ebx,%eax
  800b31:	eb 0f                	jmp    800b42 <memcmp+0x35>
		s1++, s2++;
  800b33:	83 c2 01             	add    $0x1,%edx
  800b36:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b39:	39 f2                	cmp    %esi,%edx
  800b3b:	75 e2                	jne    800b1f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b4f:	89 c2                	mov    %eax,%edx
  800b51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b54:	eb 07                	jmp    800b5d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b56:	38 08                	cmp    %cl,(%eax)
  800b58:	74 07                	je     800b61 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	39 d0                	cmp    %edx,%eax
  800b5f:	72 f5                	jb     800b56 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6f:	eb 03                	jmp    800b74 <strtol+0x11>
		s++;
  800b71:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b74:	0f b6 0a             	movzbl (%edx),%ecx
  800b77:	80 f9 09             	cmp    $0x9,%cl
  800b7a:	74 f5                	je     800b71 <strtol+0xe>
  800b7c:	80 f9 20             	cmp    $0x20,%cl
  800b7f:	74 f0                	je     800b71 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b81:	80 f9 2b             	cmp    $0x2b,%cl
  800b84:	75 0a                	jne    800b90 <strtol+0x2d>
		s++;
  800b86:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b89:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8e:	eb 11                	jmp    800ba1 <strtol+0x3e>
  800b90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b95:	80 f9 2d             	cmp    $0x2d,%cl
  800b98:	75 07                	jne    800ba1 <strtol+0x3e>
		s++, neg = 1;
  800b9a:	8d 52 01             	lea    0x1(%edx),%edx
  800b9d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ba6:	75 15                	jne    800bbd <strtol+0x5a>
  800ba8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bab:	75 10                	jne    800bbd <strtol+0x5a>
  800bad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bb1:	75 0a                	jne    800bbd <strtol+0x5a>
		s += 2, base = 16;
  800bb3:	83 c2 02             	add    $0x2,%edx
  800bb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bbb:	eb 10                	jmp    800bcd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	75 0c                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc6:	75 05                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
  800bc8:	83 c2 01             	add    $0x1,%edx
  800bcb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bd5:	0f b6 0a             	movzbl (%edx),%ecx
  800bd8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bdb:	89 f0                	mov    %esi,%eax
  800bdd:	3c 09                	cmp    $0x9,%al
  800bdf:	77 08                	ja     800be9 <strtol+0x86>
			dig = *s - '0';
  800be1:	0f be c9             	movsbl %cl,%ecx
  800be4:	83 e9 30             	sub    $0x30,%ecx
  800be7:	eb 20                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800be9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bec:	89 f0                	mov    %esi,%eax
  800bee:	3c 19                	cmp    $0x19,%al
  800bf0:	77 08                	ja     800bfa <strtol+0x97>
			dig = *s - 'a' + 10;
  800bf2:	0f be c9             	movsbl %cl,%ecx
  800bf5:	83 e9 57             	sub    $0x57,%ecx
  800bf8:	eb 0f                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bfa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bfd:	89 f0                	mov    %esi,%eax
  800bff:	3c 19                	cmp    $0x19,%al
  800c01:	77 16                	ja     800c19 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c03:	0f be c9             	movsbl %cl,%ecx
  800c06:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c09:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c0c:	7d 0f                	jge    800c1d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c0e:	83 c2 01             	add    $0x1,%edx
  800c11:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c15:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c17:	eb bc                	jmp    800bd5 <strtol+0x72>
  800c19:	89 d8                	mov    %ebx,%eax
  800c1b:	eb 02                	jmp    800c1f <strtol+0xbc>
  800c1d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c23:	74 05                	je     800c2a <strtol+0xc7>
		*endptr = (char *) s;
  800c25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c28:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c2a:	f7 d8                	neg    %eax
  800c2c:	85 ff                	test   %edi,%edi
  800c2e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	89 c3                	mov    %eax,%ebx
  800c49:	89 c7                	mov    %eax,%edi
  800c4b:	89 c6                	mov    %eax,%esi
  800c4d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	89 d3                	mov    %edx,%ebx
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	89 d6                	mov    %edx,%esi
  800c6c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c81:	b8 03 00 00 00       	mov    $0x3,%eax
  800c86:	8b 55 08             	mov    0x8(%ebp),%edx
  800c89:	89 cb                	mov    %ecx,%ebx
  800c8b:	89 cf                	mov    %ecx,%edi
  800c8d:	89 ce                	mov    %ecx,%esi
  800c8f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7e 28                	jle    800cbd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c99:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ca0:	00 
  800ca1:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800ca8:	00 
  800ca9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb0:	00 
  800cb1:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800cb8:	e8 06 f5 ff ff       	call   8001c3 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbd:	83 c4 2c             	add    $0x2c,%esp
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_yield>:

void
sys_yield(void)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cea:	ba 00 00 00 00       	mov    $0x0,%edx
  800cef:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf4:	89 d1                	mov    %edx,%ecx
  800cf6:	89 d3                	mov    %edx,%ebx
  800cf8:	89 d7                	mov    %edx,%edi
  800cfa:	89 d6                	mov    %edx,%esi
  800cfc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0c:	be 00 00 00 00       	mov    $0x0,%esi
  800d11:	b8 04 00 00 00       	mov    $0x4,%eax
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1f:	89 f7                	mov    %esi,%edi
  800d21:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7e 28                	jle    800d4f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d32:	00 
  800d33:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800d3a:	00 
  800d3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d42:	00 
  800d43:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800d4a:	e8 74 f4 ff ff       	call   8001c3 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4f:	83 c4 2c             	add    $0x2c,%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d60:	b8 05 00 00 00       	mov    $0x5,%eax
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d71:	8b 75 18             	mov    0x18(%ebp),%esi
  800d74:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d76:	85 c0                	test   %eax,%eax
  800d78:	7e 28                	jle    800da2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d85:	00 
  800d86:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800d8d:	00 
  800d8e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d95:	00 
  800d96:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800d9d:	e8 21 f4 ff ff       	call   8001c3 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da2:	83 c4 2c             	add    $0x2c,%esp
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7e 28                	jle    800df5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dd8:	00 
  800dd9:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800de0:	00 
  800de1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de8:	00 
  800de9:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800df0:	e8 ce f3 ff ff       	call   8001c3 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800df5:	83 c4 2c             	add    $0x2c,%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	57                   	push   %edi
  800e01:	56                   	push   %esi
  800e02:	53                   	push   %ebx
  800e03:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	89 df                	mov    %ebx,%edi
  800e18:	89 de                	mov    %ebx,%esi
  800e1a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	7e 28                	jle    800e48 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e24:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e2b:	00 
  800e2c:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800e33:	00 
  800e34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3b:	00 
  800e3c:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800e43:	e8 7b f3 ff ff       	call   8001c3 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e48:	83 c4 2c             	add    $0x2c,%esp
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
  800e56:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	89 df                	mov    %ebx,%edi
  800e6b:	89 de                	mov    %ebx,%esi
  800e6d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7e 28                	jle    800e9b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e73:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e77:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e7e:	00 
  800e7f:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800e86:	00 
  800e87:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8e:	00 
  800e8f:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800e96:	e8 28 f3 ff ff       	call   8001c3 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e9b:	83 c4 2c             	add    $0x2c,%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
  800ea9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	89 df                	mov    %ebx,%edi
  800ebe:	89 de                	mov    %ebx,%esi
  800ec0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	7e 28                	jle    800eee <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ed1:	00 
  800ed2:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800ed9:	00 
  800eda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee1:	00 
  800ee2:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800ee9:	e8 d5 f2 ff ff       	call   8001c3 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eee:	83 c4 2c             	add    $0x2c,%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efc:	be 00 00 00 00       	mov    $0x0,%esi
  800f01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f12:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f27:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	89 cb                	mov    %ecx,%ebx
  800f31:	89 cf                	mov    %ecx,%edi
  800f33:	89 ce                	mov    %ecx,%esi
  800f35:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	7e 28                	jle    800f63 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f46:	00 
  800f47:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800f4e:	00 
  800f4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f56:	00 
  800f57:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800f5e:	e8 60 f2 ff ff       	call   8001c3 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f63:	83 c4 2c             	add    $0x2c,%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f71:	ba 00 00 00 00       	mov    $0x0,%edx
  800f76:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f7b:	89 d1                	mov    %edx,%ecx
  800f7d:	89 d3                	mov    %edx,%ebx
  800f7f:	89 d7                	mov    %edx,%edi
  800f81:	89 d6                	mov    %edx,%esi
  800f83:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f98:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	89 df                	mov    %ebx,%edi
  800fa5:	89 de                	mov    %ebx,%esi
  800fa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	7e 28                	jle    800fd5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800fb8:	00 
  800fb9:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800fc0:	00 
  800fc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc8:	00 
  800fc9:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800fd0:	e8 ee f1 ff ff       	call   8001c3 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800fd5:	83 c4 2c             	add    $0x2c,%esp
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	57                   	push   %edi
  800fe1:	56                   	push   %esi
  800fe2:	53                   	push   %ebx
  800fe3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800feb:	b8 10 00 00 00       	mov    $0x10,%eax
  800ff0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff6:	89 df                	mov    %ebx,%edi
  800ff8:	89 de                	mov    %ebx,%esi
  800ffa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	7e 28                	jle    801028 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801000:	89 44 24 10          	mov    %eax,0x10(%esp)
  801004:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80100b:	00 
  80100c:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  801013:	00 
  801014:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80101b:	00 
  80101c:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  801023:	e8 9b f1 ff ff       	call   8001c3 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801028:	83 c4 2c             	add    $0x2c,%esp
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5f                   	pop    %edi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	05 00 00 00 30       	add    $0x30000000,%eax
  80103b:	c1 e8 0c             	shr    $0xc,%eax
}
  80103e:	5d                   	pop    %ebp
  80103f:	c3                   	ret    

00801040 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80104b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801050:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80105d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801062:	89 c2                	mov    %eax,%edx
  801064:	c1 ea 16             	shr    $0x16,%edx
  801067:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80106e:	f6 c2 01             	test   $0x1,%dl
  801071:	74 11                	je     801084 <fd_alloc+0x2d>
  801073:	89 c2                	mov    %eax,%edx
  801075:	c1 ea 0c             	shr    $0xc,%edx
  801078:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107f:	f6 c2 01             	test   $0x1,%dl
  801082:	75 09                	jne    80108d <fd_alloc+0x36>
			*fd_store = fd;
  801084:	89 01                	mov    %eax,(%ecx)
			return 0;
  801086:	b8 00 00 00 00       	mov    $0x0,%eax
  80108b:	eb 17                	jmp    8010a4 <fd_alloc+0x4d>
  80108d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801092:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801097:	75 c9                	jne    801062 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801099:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80109f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ac:	83 f8 1f             	cmp    $0x1f,%eax
  8010af:	77 36                	ja     8010e7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010b1:	c1 e0 0c             	shl    $0xc,%eax
  8010b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b9:	89 c2                	mov    %eax,%edx
  8010bb:	c1 ea 16             	shr    $0x16,%edx
  8010be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010c5:	f6 c2 01             	test   $0x1,%dl
  8010c8:	74 24                	je     8010ee <fd_lookup+0x48>
  8010ca:	89 c2                	mov    %eax,%edx
  8010cc:	c1 ea 0c             	shr    $0xc,%edx
  8010cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d6:	f6 c2 01             	test   $0x1,%dl
  8010d9:	74 1a                	je     8010f5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010de:	89 02                	mov    %eax,(%edx)
	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e5:	eb 13                	jmp    8010fa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ec:	eb 0c                	jmp    8010fa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f3:	eb 05                	jmp    8010fa <fd_lookup+0x54>
  8010f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 18             	sub    $0x18,%esp
  801102:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801105:	ba 00 00 00 00       	mov    $0x0,%edx
  80110a:	eb 13                	jmp    80111f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80110c:	39 08                	cmp    %ecx,(%eax)
  80110e:	75 0c                	jne    80111c <dev_lookup+0x20>
			*dev = devtab[i];
  801110:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801113:	89 01                	mov    %eax,(%ecx)
			return 0;
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
  80111a:	eb 38                	jmp    801154 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80111c:	83 c2 01             	add    $0x1,%edx
  80111f:	8b 04 95 88 31 80 00 	mov    0x803188(,%edx,4),%eax
  801126:	85 c0                	test   %eax,%eax
  801128:	75 e2                	jne    80110c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80112a:	a1 08 50 80 00       	mov    0x805008,%eax
  80112f:	8b 40 48             	mov    0x48(%eax),%eax
  801132:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801136:	89 44 24 04          	mov    %eax,0x4(%esp)
  80113a:	c7 04 24 0c 31 80 00 	movl   $0x80310c,(%esp)
  801141:	e8 76 f1 ff ff       	call   8002bc <cprintf>
	*dev = 0;
  801146:	8b 45 0c             	mov    0xc(%ebp),%eax
  801149:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80114f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	56                   	push   %esi
  80115a:	53                   	push   %ebx
  80115b:	83 ec 20             	sub    $0x20,%esp
  80115e:	8b 75 08             	mov    0x8(%ebp),%esi
  801161:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801164:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801167:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80116b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801171:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801174:	89 04 24             	mov    %eax,(%esp)
  801177:	e8 2a ff ff ff       	call   8010a6 <fd_lookup>
  80117c:	85 c0                	test   %eax,%eax
  80117e:	78 05                	js     801185 <fd_close+0x2f>
	    || fd != fd2)
  801180:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801183:	74 0c                	je     801191 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801185:	84 db                	test   %bl,%bl
  801187:	ba 00 00 00 00       	mov    $0x0,%edx
  80118c:	0f 44 c2             	cmove  %edx,%eax
  80118f:	eb 3f                	jmp    8011d0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801191:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801194:	89 44 24 04          	mov    %eax,0x4(%esp)
  801198:	8b 06                	mov    (%esi),%eax
  80119a:	89 04 24             	mov    %eax,(%esp)
  80119d:	e8 5a ff ff ff       	call   8010fc <dev_lookup>
  8011a2:	89 c3                	mov    %eax,%ebx
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	78 16                	js     8011be <fd_close+0x68>
		if (dev->dev_close)
  8011a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	74 07                	je     8011be <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011b7:	89 34 24             	mov    %esi,(%esp)
  8011ba:	ff d0                	call   *%eax
  8011bc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011c9:	e8 dc fb ff ff       	call   800daa <sys_page_unmap>
	return r;
  8011ce:	89 d8                	mov    %ebx,%eax
}
  8011d0:	83 c4 20             	add    $0x20,%esp
  8011d3:	5b                   	pop    %ebx
  8011d4:	5e                   	pop    %esi
  8011d5:	5d                   	pop    %ebp
  8011d6:	c3                   	ret    

008011d7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e7:	89 04 24             	mov    %eax,(%esp)
  8011ea:	e8 b7 fe ff ff       	call   8010a6 <fd_lookup>
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	85 d2                	test   %edx,%edx
  8011f3:	78 13                	js     801208 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8011f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011fc:	00 
  8011fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801200:	89 04 24             	mov    %eax,(%esp)
  801203:	e8 4e ff ff ff       	call   801156 <fd_close>
}
  801208:	c9                   	leave  
  801209:	c3                   	ret    

0080120a <close_all>:

void
close_all(void)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	53                   	push   %ebx
  80120e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801211:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801216:	89 1c 24             	mov    %ebx,(%esp)
  801219:	e8 b9 ff ff ff       	call   8011d7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80121e:	83 c3 01             	add    $0x1,%ebx
  801221:	83 fb 20             	cmp    $0x20,%ebx
  801224:	75 f0                	jne    801216 <close_all+0xc>
		close(i);
}
  801226:	83 c4 14             	add    $0x14,%esp
  801229:	5b                   	pop    %ebx
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
  801232:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801235:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801238:	89 44 24 04          	mov    %eax,0x4(%esp)
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	89 04 24             	mov    %eax,(%esp)
  801242:	e8 5f fe ff ff       	call   8010a6 <fd_lookup>
  801247:	89 c2                	mov    %eax,%edx
  801249:	85 d2                	test   %edx,%edx
  80124b:	0f 88 e1 00 00 00    	js     801332 <dup+0x106>
		return r;
	close(newfdnum);
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	89 04 24             	mov    %eax,(%esp)
  801257:	e8 7b ff ff ff       	call   8011d7 <close>

	newfd = INDEX2FD(newfdnum);
  80125c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80125f:	c1 e3 0c             	shl    $0xc,%ebx
  801262:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801268:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80126b:	89 04 24             	mov    %eax,(%esp)
  80126e:	e8 cd fd ff ff       	call   801040 <fd2data>
  801273:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801275:	89 1c 24             	mov    %ebx,(%esp)
  801278:	e8 c3 fd ff ff       	call   801040 <fd2data>
  80127d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80127f:	89 f0                	mov    %esi,%eax
  801281:	c1 e8 16             	shr    $0x16,%eax
  801284:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80128b:	a8 01                	test   $0x1,%al
  80128d:	74 43                	je     8012d2 <dup+0xa6>
  80128f:	89 f0                	mov    %esi,%eax
  801291:	c1 e8 0c             	shr    $0xc,%eax
  801294:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80129b:	f6 c2 01             	test   $0x1,%dl
  80129e:	74 32                	je     8012d2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012b4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012bb:	00 
  8012bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012c7:	e8 8b fa ff ff       	call   800d57 <sys_page_map>
  8012cc:	89 c6                	mov    %eax,%esi
  8012ce:	85 c0                	test   %eax,%eax
  8012d0:	78 3e                	js     801310 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d5:	89 c2                	mov    %eax,%edx
  8012d7:	c1 ea 0c             	shr    $0xc,%edx
  8012da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012e7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012f6:	00 
  8012f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801302:	e8 50 fa ff ff       	call   800d57 <sys_page_map>
  801307:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801309:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80130c:	85 f6                	test   %esi,%esi
  80130e:	79 22                	jns    801332 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801310:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801314:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80131b:	e8 8a fa ff ff       	call   800daa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801320:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80132b:	e8 7a fa ff ff       	call   800daa <sys_page_unmap>
	return r;
  801330:	89 f0                	mov    %esi,%eax
}
  801332:	83 c4 3c             	add    $0x3c,%esp
  801335:	5b                   	pop    %ebx
  801336:	5e                   	pop    %esi
  801337:	5f                   	pop    %edi
  801338:	5d                   	pop    %ebp
  801339:	c3                   	ret    

0080133a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	53                   	push   %ebx
  80133e:	83 ec 24             	sub    $0x24,%esp
  801341:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801344:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134b:	89 1c 24             	mov    %ebx,(%esp)
  80134e:	e8 53 fd ff ff       	call   8010a6 <fd_lookup>
  801353:	89 c2                	mov    %eax,%edx
  801355:	85 d2                	test   %edx,%edx
  801357:	78 6d                	js     8013c6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801359:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801360:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801363:	8b 00                	mov    (%eax),%eax
  801365:	89 04 24             	mov    %eax,(%esp)
  801368:	e8 8f fd ff ff       	call   8010fc <dev_lookup>
  80136d:	85 c0                	test   %eax,%eax
  80136f:	78 55                	js     8013c6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801371:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801374:	8b 50 08             	mov    0x8(%eax),%edx
  801377:	83 e2 03             	and    $0x3,%edx
  80137a:	83 fa 01             	cmp    $0x1,%edx
  80137d:	75 23                	jne    8013a2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80137f:	a1 08 50 80 00       	mov    0x805008,%eax
  801384:	8b 40 48             	mov    0x48(%eax),%eax
  801387:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80138b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138f:	c7 04 24 4d 31 80 00 	movl   $0x80314d,(%esp)
  801396:	e8 21 ef ff ff       	call   8002bc <cprintf>
		return -E_INVAL;
  80139b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a0:	eb 24                	jmp    8013c6 <read+0x8c>
	}
	if (!dev->dev_read)
  8013a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a5:	8b 52 08             	mov    0x8(%edx),%edx
  8013a8:	85 d2                	test   %edx,%edx
  8013aa:	74 15                	je     8013c1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013ba:	89 04 24             	mov    %eax,(%esp)
  8013bd:	ff d2                	call   *%edx
  8013bf:	eb 05                	jmp    8013c6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013c6:	83 c4 24             	add    $0x24,%esp
  8013c9:	5b                   	pop    %ebx
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    

008013cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	57                   	push   %edi
  8013d0:	56                   	push   %esi
  8013d1:	53                   	push   %ebx
  8013d2:	83 ec 1c             	sub    $0x1c,%esp
  8013d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e0:	eb 23                	jmp    801405 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013e2:	89 f0                	mov    %esi,%eax
  8013e4:	29 d8                	sub    %ebx,%eax
  8013e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013ea:	89 d8                	mov    %ebx,%eax
  8013ec:	03 45 0c             	add    0xc(%ebp),%eax
  8013ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f3:	89 3c 24             	mov    %edi,(%esp)
  8013f6:	e8 3f ff ff ff       	call   80133a <read>
		if (m < 0)
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 10                	js     80140f <readn+0x43>
			return m;
		if (m == 0)
  8013ff:	85 c0                	test   %eax,%eax
  801401:	74 0a                	je     80140d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801403:	01 c3                	add    %eax,%ebx
  801405:	39 f3                	cmp    %esi,%ebx
  801407:	72 d9                	jb     8013e2 <readn+0x16>
  801409:	89 d8                	mov    %ebx,%eax
  80140b:	eb 02                	jmp    80140f <readn+0x43>
  80140d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80140f:	83 c4 1c             	add    $0x1c,%esp
  801412:	5b                   	pop    %ebx
  801413:	5e                   	pop    %esi
  801414:	5f                   	pop    %edi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    

00801417 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	53                   	push   %ebx
  80141b:	83 ec 24             	sub    $0x24,%esp
  80141e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801421:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801424:	89 44 24 04          	mov    %eax,0x4(%esp)
  801428:	89 1c 24             	mov    %ebx,(%esp)
  80142b:	e8 76 fc ff ff       	call   8010a6 <fd_lookup>
  801430:	89 c2                	mov    %eax,%edx
  801432:	85 d2                	test   %edx,%edx
  801434:	78 68                	js     80149e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801436:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801439:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801440:	8b 00                	mov    (%eax),%eax
  801442:	89 04 24             	mov    %eax,(%esp)
  801445:	e8 b2 fc ff ff       	call   8010fc <dev_lookup>
  80144a:	85 c0                	test   %eax,%eax
  80144c:	78 50                	js     80149e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80144e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801451:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801455:	75 23                	jne    80147a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801457:	a1 08 50 80 00       	mov    0x805008,%eax
  80145c:	8b 40 48             	mov    0x48(%eax),%eax
  80145f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801463:	89 44 24 04          	mov    %eax,0x4(%esp)
  801467:	c7 04 24 69 31 80 00 	movl   $0x803169,(%esp)
  80146e:	e8 49 ee ff ff       	call   8002bc <cprintf>
		return -E_INVAL;
  801473:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801478:	eb 24                	jmp    80149e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80147a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147d:	8b 52 0c             	mov    0xc(%edx),%edx
  801480:	85 d2                	test   %edx,%edx
  801482:	74 15                	je     801499 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801484:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801487:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80148b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80148e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801492:	89 04 24             	mov    %eax,(%esp)
  801495:	ff d2                	call   *%edx
  801497:	eb 05                	jmp    80149e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801499:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80149e:	83 c4 24             	add    $0x24,%esp
  8014a1:	5b                   	pop    %ebx
  8014a2:	5d                   	pop    %ebp
  8014a3:	c3                   	ret    

008014a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014aa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	89 04 24             	mov    %eax,(%esp)
  8014b7:	e8 ea fb ff ff       	call   8010a6 <fd_lookup>
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	78 0e                	js     8014ce <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 24             	sub    $0x24,%esp
  8014d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e1:	89 1c 24             	mov    %ebx,(%esp)
  8014e4:	e8 bd fb ff ff       	call   8010a6 <fd_lookup>
  8014e9:	89 c2                	mov    %eax,%edx
  8014eb:	85 d2                	test   %edx,%edx
  8014ed:	78 61                	js     801550 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	89 04 24             	mov    %eax,(%esp)
  8014fe:	e8 f9 fb ff ff       	call   8010fc <dev_lookup>
  801503:	85 c0                	test   %eax,%eax
  801505:	78 49                	js     801550 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80150e:	75 23                	jne    801533 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801510:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801515:	8b 40 48             	mov    0x48(%eax),%eax
  801518:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80151c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801520:	c7 04 24 2c 31 80 00 	movl   $0x80312c,(%esp)
  801527:	e8 90 ed ff ff       	call   8002bc <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80152c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801531:	eb 1d                	jmp    801550 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801533:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801536:	8b 52 18             	mov    0x18(%edx),%edx
  801539:	85 d2                	test   %edx,%edx
  80153b:	74 0e                	je     80154b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80153d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801540:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801544:	89 04 24             	mov    %eax,(%esp)
  801547:	ff d2                	call   *%edx
  801549:	eb 05                	jmp    801550 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80154b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801550:	83 c4 24             	add    $0x24,%esp
  801553:	5b                   	pop    %ebx
  801554:	5d                   	pop    %ebp
  801555:	c3                   	ret    

00801556 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801556:	55                   	push   %ebp
  801557:	89 e5                	mov    %esp,%ebp
  801559:	53                   	push   %ebx
  80155a:	83 ec 24             	sub    $0x24,%esp
  80155d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801560:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801563:	89 44 24 04          	mov    %eax,0x4(%esp)
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	89 04 24             	mov    %eax,(%esp)
  80156d:	e8 34 fb ff ff       	call   8010a6 <fd_lookup>
  801572:	89 c2                	mov    %eax,%edx
  801574:	85 d2                	test   %edx,%edx
  801576:	78 52                	js     8015ca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801578:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801582:	8b 00                	mov    (%eax),%eax
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	e8 70 fb ff ff       	call   8010fc <dev_lookup>
  80158c:	85 c0                	test   %eax,%eax
  80158e:	78 3a                	js     8015ca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801597:	74 2c                	je     8015c5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801599:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80159c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015a3:	00 00 00 
	stat->st_isdir = 0;
  8015a6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015ad:	00 00 00 
	stat->st_dev = dev;
  8015b0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015bd:	89 14 24             	mov    %edx,(%esp)
  8015c0:	ff 50 14             	call   *0x14(%eax)
  8015c3:	eb 05                	jmp    8015ca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015ca:	83 c4 24             	add    $0x24,%esp
  8015cd:	5b                   	pop    %ebx
  8015ce:	5d                   	pop    %ebp
  8015cf:	c3                   	ret    

008015d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	56                   	push   %esi
  8015d4:	53                   	push   %ebx
  8015d5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015df:	00 
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	89 04 24             	mov    %eax,(%esp)
  8015e6:	e8 28 02 00 00       	call   801813 <open>
  8015eb:	89 c3                	mov    %eax,%ebx
  8015ed:	85 db                	test   %ebx,%ebx
  8015ef:	78 1b                	js     80160c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8015f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f8:	89 1c 24             	mov    %ebx,(%esp)
  8015fb:	e8 56 ff ff ff       	call   801556 <fstat>
  801600:	89 c6                	mov    %eax,%esi
	close(fd);
  801602:	89 1c 24             	mov    %ebx,(%esp)
  801605:	e8 cd fb ff ff       	call   8011d7 <close>
	return r;
  80160a:	89 f0                	mov    %esi,%eax
}
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	5b                   	pop    %ebx
  801610:	5e                   	pop    %esi
  801611:	5d                   	pop    %ebp
  801612:	c3                   	ret    

00801613 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
  801616:	56                   	push   %esi
  801617:	53                   	push   %ebx
  801618:	83 ec 10             	sub    $0x10,%esp
  80161b:	89 c6                	mov    %eax,%esi
  80161d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80161f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801626:	75 11                	jne    801639 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801628:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80162f:	e8 9a 13 00 00       	call   8029ce <ipc_find_env>
  801634:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801639:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801640:	00 
  801641:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801648:	00 
  801649:	89 74 24 04          	mov    %esi,0x4(%esp)
  80164d:	a1 00 50 80 00       	mov    0x805000,%eax
  801652:	89 04 24             	mov    %eax,(%esp)
  801655:	e8 16 13 00 00       	call   802970 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80165a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801661:	00 
  801662:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801666:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80166d:	e8 94 12 00 00       	call   802906 <ipc_recv>
}
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5d                   	pop    %ebp
  801678:	c3                   	ret    

00801679 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
  80167c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8b 40 0c             	mov    0xc(%eax),%eax
  801685:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80168a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801692:	ba 00 00 00 00       	mov    $0x0,%edx
  801697:	b8 02 00 00 00       	mov    $0x2,%eax
  80169c:	e8 72 ff ff ff       	call   801613 <fsipc>
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8016af:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016be:	e8 50 ff ff ff       	call   801613 <fsipc>
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	53                   	push   %ebx
  8016c9:	83 ec 14             	sub    $0x14,%esp
  8016cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016da:	ba 00 00 00 00       	mov    $0x0,%edx
  8016df:	b8 05 00 00 00       	mov    $0x5,%eax
  8016e4:	e8 2a ff ff ff       	call   801613 <fsipc>
  8016e9:	89 c2                	mov    %eax,%edx
  8016eb:	85 d2                	test   %edx,%edx
  8016ed:	78 2b                	js     80171a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016ef:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8016f6:	00 
  8016f7:	89 1c 24             	mov    %ebx,(%esp)
  8016fa:	e8 e8 f1 ff ff       	call   8008e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016ff:	a1 80 60 80 00       	mov    0x806080,%eax
  801704:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80170a:	a1 84 60 80 00       	mov    0x806084,%eax
  80170f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171a:	83 c4 14             	add    $0x14,%esp
  80171d:	5b                   	pop    %ebx
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    

00801720 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 18             	sub    $0x18,%esp
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80172e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801733:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801736:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80173b:	8b 55 08             	mov    0x8(%ebp),%edx
  80173e:	8b 52 0c             	mov    0xc(%edx),%edx
  801741:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801747:	89 44 24 08          	mov    %eax,0x8(%esp)
  80174b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801752:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801759:	e8 26 f3 ff ff       	call   800a84 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80175e:	ba 00 00 00 00       	mov    $0x0,%edx
  801763:	b8 04 00 00 00       	mov    $0x4,%eax
  801768:	e8 a6 fe ff ff       	call   801613 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	56                   	push   %esi
  801773:	53                   	push   %ebx
  801774:	83 ec 10             	sub    $0x10,%esp
  801777:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	8b 40 0c             	mov    0xc(%eax),%eax
  801780:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801785:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80178b:	ba 00 00 00 00       	mov    $0x0,%edx
  801790:	b8 03 00 00 00       	mov    $0x3,%eax
  801795:	e8 79 fe ff ff       	call   801613 <fsipc>
  80179a:	89 c3                	mov    %eax,%ebx
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 6a                	js     80180a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017a0:	39 c6                	cmp    %eax,%esi
  8017a2:	73 24                	jae    8017c8 <devfile_read+0x59>
  8017a4:	c7 44 24 0c 9c 31 80 	movl   $0x80319c,0xc(%esp)
  8017ab:	00 
  8017ac:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  8017b3:	00 
  8017b4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8017bb:	00 
  8017bc:	c7 04 24 b8 31 80 00 	movl   $0x8031b8,(%esp)
  8017c3:	e8 fb e9 ff ff       	call   8001c3 <_panic>
	assert(r <= PGSIZE);
  8017c8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017cd:	7e 24                	jle    8017f3 <devfile_read+0x84>
  8017cf:	c7 44 24 0c c3 31 80 	movl   $0x8031c3,0xc(%esp)
  8017d6:	00 
  8017d7:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  8017de:	00 
  8017df:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8017e6:	00 
  8017e7:	c7 04 24 b8 31 80 00 	movl   $0x8031b8,(%esp)
  8017ee:	e8 d0 e9 ff ff       	call   8001c3 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017f7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8017fe:	00 
  8017ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801802:	89 04 24             	mov    %eax,(%esp)
  801805:	e8 7a f2 ff ff       	call   800a84 <memmove>
	return r;
}
  80180a:	89 d8                	mov    %ebx,%eax
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	5b                   	pop    %ebx
  801810:	5e                   	pop    %esi
  801811:	5d                   	pop    %ebp
  801812:	c3                   	ret    

00801813 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	53                   	push   %ebx
  801817:	83 ec 24             	sub    $0x24,%esp
  80181a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80181d:	89 1c 24             	mov    %ebx,(%esp)
  801820:	e8 8b f0 ff ff       	call   8008b0 <strlen>
  801825:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80182a:	7f 60                	jg     80188c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80182c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182f:	89 04 24             	mov    %eax,(%esp)
  801832:	e8 20 f8 ff ff       	call   801057 <fd_alloc>
  801837:	89 c2                	mov    %eax,%edx
  801839:	85 d2                	test   %edx,%edx
  80183b:	78 54                	js     801891 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80183d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801841:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801848:	e8 9a f0 ff ff       	call   8008e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80184d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801850:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801858:	b8 01 00 00 00       	mov    $0x1,%eax
  80185d:	e8 b1 fd ff ff       	call   801613 <fsipc>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	85 c0                	test   %eax,%eax
  801866:	79 17                	jns    80187f <open+0x6c>
		fd_close(fd, 0);
  801868:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80186f:	00 
  801870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801873:	89 04 24             	mov    %eax,(%esp)
  801876:	e8 db f8 ff ff       	call   801156 <fd_close>
		return r;
  80187b:	89 d8                	mov    %ebx,%eax
  80187d:	eb 12                	jmp    801891 <open+0x7e>
	}

	return fd2num(fd);
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	89 04 24             	mov    %eax,(%esp)
  801885:	e8 a6 f7 ff ff       	call   801030 <fd2num>
  80188a:	eb 05                	jmp    801891 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80188c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801891:	83 c4 24             	add    $0x24,%esp
  801894:	5b                   	pop    %ebx
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    

00801897 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80189d:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a2:	b8 08 00 00 00       	mov    $0x8,%eax
  8018a7:	e8 67 fd ff ff       	call   801613 <fsipc>
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    
  8018ae:	66 90                	xchg   %ax,%ax

008018b0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	57                   	push   %edi
  8018b4:	56                   	push   %esi
  8018b5:	53                   	push   %ebx
  8018b6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8018bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018c3:	00 
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	89 04 24             	mov    %eax,(%esp)
  8018ca:	e8 44 ff ff ff       	call   801813 <open>
  8018cf:	89 c2                	mov    %eax,%edx
  8018d1:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	0f 88 0f 05 00 00    	js     801dee <spawn+0x53e>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8018df:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8018e6:	00 
  8018e7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8018ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f1:	89 14 24             	mov    %edx,(%esp)
  8018f4:	e8 d3 fa ff ff       	call   8013cc <readn>
  8018f9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8018fe:	75 0c                	jne    80190c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801900:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801907:	45 4c 46 
  80190a:	74 36                	je     801942 <spawn+0x92>
		close(fd);
  80190c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801912:	89 04 24             	mov    %eax,(%esp)
  801915:	e8 bd f8 ff ff       	call   8011d7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80191a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801921:	46 
  801922:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801928:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192c:	c7 04 24 cf 31 80 00 	movl   $0x8031cf,(%esp)
  801933:	e8 84 e9 ff ff       	call   8002bc <cprintf>
		return -E_NOT_EXEC;
  801938:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80193d:	e9 0b 05 00 00       	jmp    801e4d <spawn+0x59d>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801942:	b8 07 00 00 00       	mov    $0x7,%eax
  801947:	cd 30                	int    $0x30
  801949:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80194f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801955:	85 c0                	test   %eax,%eax
  801957:	0f 88 99 04 00 00    	js     801df6 <spawn+0x546>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80195d:	89 c6                	mov    %eax,%esi
  80195f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801965:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801968:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80196e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801974:	b9 11 00 00 00       	mov    $0x11,%ecx
  801979:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80197b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801981:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801987:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  80198c:	be 00 00 00 00       	mov    $0x0,%esi
  801991:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801994:	eb 0f                	jmp    8019a5 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801996:	89 04 24             	mov    %eax,(%esp)
  801999:	e8 12 ef ff ff       	call   8008b0 <strlen>
  80199e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8019a2:	83 c3 01             	add    $0x1,%ebx
  8019a5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8019ac:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	75 e3                	jne    801996 <spawn+0xe6>
  8019b3:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  8019b9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8019bf:	bf 00 10 40 00       	mov    $0x401000,%edi
  8019c4:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8019c6:	89 fa                	mov    %edi,%edx
  8019c8:	83 e2 fc             	and    $0xfffffffc,%edx
  8019cb:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8019d2:	29 c2                	sub    %eax,%edx
  8019d4:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8019da:	8d 42 f8             	lea    -0x8(%edx),%eax
  8019dd:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8019e2:	0f 86 1e 04 00 00    	jbe    801e06 <spawn+0x556>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8019e8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8019ef:	00 
  8019f0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8019f7:	00 
  8019f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ff:	e8 ff f2 ff ff       	call   800d03 <sys_page_alloc>
  801a04:	85 c0                	test   %eax,%eax
  801a06:	0f 88 41 04 00 00    	js     801e4d <spawn+0x59d>
  801a0c:	be 00 00 00 00       	mov    $0x0,%esi
  801a11:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801a17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a1a:	eb 30                	jmp    801a4c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801a1c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801a22:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801a28:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801a2b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a32:	89 3c 24             	mov    %edi,(%esp)
  801a35:	e8 ad ee ff ff       	call   8008e7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801a3a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801a3d:	89 04 24             	mov    %eax,(%esp)
  801a40:	e8 6b ee ff ff       	call   8008b0 <strlen>
  801a45:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801a49:	83 c6 01             	add    $0x1,%esi
  801a4c:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801a52:	7f c8                	jg     801a1c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801a54:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801a5a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801a60:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801a67:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801a6d:	74 24                	je     801a93 <spawn+0x1e3>
  801a6f:	c7 44 24 0c 44 32 80 	movl   $0x803244,0xc(%esp)
  801a76:	00 
  801a77:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  801a7e:	00 
  801a7f:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  801a86:	00 
  801a87:	c7 04 24 e9 31 80 00 	movl   $0x8031e9,(%esp)
  801a8e:	e8 30 e7 ff ff       	call   8001c3 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801a93:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801a99:	89 c8                	mov    %ecx,%eax
  801a9b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801aa0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801aa3:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801aa9:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801aac:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801ab2:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801ab8:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801abf:	00 
  801ac0:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801ac7:	ee 
  801ac8:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801ace:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ad2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ad9:	00 
  801ada:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae1:	e8 71 f2 ff ff       	call   800d57 <sys_page_map>
  801ae6:	89 c3                	mov    %eax,%ebx
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	0f 88 47 03 00 00    	js     801e37 <spawn+0x587>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801af0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801af7:	00 
  801af8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aff:	e8 a6 f2 ff ff       	call   800daa <sys_page_unmap>
  801b04:	89 c3                	mov    %eax,%ebx
  801b06:	85 c0                	test   %eax,%eax
  801b08:	0f 88 29 03 00 00    	js     801e37 <spawn+0x587>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801b0e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801b14:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801b1b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801b21:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801b28:	00 00 00 
  801b2b:	e9 b6 01 00 00       	jmp    801ce6 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801b30:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801b36:	83 38 01             	cmpl   $0x1,(%eax)
  801b39:	0f 85 99 01 00 00    	jne    801cd8 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801b3f:	89 c2                	mov    %eax,%edx
  801b41:	8b 40 18             	mov    0x18(%eax),%eax
  801b44:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801b47:	83 f8 01             	cmp    $0x1,%eax
  801b4a:	19 c0                	sbb    %eax,%eax
  801b4c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801b52:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801b59:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801b60:	89 d0                	mov    %edx,%eax
  801b62:	8b 7a 04             	mov    0x4(%edx),%edi
  801b65:	89 bd 80 fd ff ff    	mov    %edi,-0x280(%ebp)
  801b6b:	8b 52 10             	mov    0x10(%edx),%edx
  801b6e:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801b74:	8b 78 14             	mov    0x14(%eax),%edi
  801b77:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  801b7d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801b80:	89 f0                	mov    %esi,%eax
  801b82:	25 ff 0f 00 00       	and    $0xfff,%eax
  801b87:	74 14                	je     801b9d <spawn+0x2ed>
		va -= i;
  801b89:	29 c6                	sub    %eax,%esi
		memsz += i;
  801b8b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801b91:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801b97:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801b9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ba2:	e9 23 01 00 00       	jmp    801cca <spawn+0x41a>
		if (i >= filesz) {
  801ba7:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801bad:	77 2b                	ja     801bda <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801baf:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bbd:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801bc3:	89 04 24             	mov    %eax,(%esp)
  801bc6:	e8 38 f1 ff ff       	call   800d03 <sys_page_alloc>
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	0f 89 eb 00 00 00    	jns    801cbe <spawn+0x40e>
  801bd3:	89 c3                	mov    %eax,%ebx
  801bd5:	e9 3d 02 00 00       	jmp    801e17 <spawn+0x567>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801bda:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801be1:	00 
  801be2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801be9:	00 
  801bea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf1:	e8 0d f1 ff ff       	call   800d03 <sys_page_alloc>
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	0f 88 0f 02 00 00    	js     801e0d <spawn+0x55d>
  801bfe:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c04:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c10:	89 04 24             	mov    %eax,(%esp)
  801c13:	e8 8c f8 ff ff       	call   8014a4 <seek>
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	0f 88 f1 01 00 00    	js     801e11 <spawn+0x561>
  801c20:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801c26:	29 f9                	sub    %edi,%ecx
  801c28:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c2a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801c30:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c35:	0f 47 c1             	cmova  %ecx,%eax
  801c38:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c3c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c43:	00 
  801c44:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c4a:	89 04 24             	mov    %eax,(%esp)
  801c4d:	e8 7a f7 ff ff       	call   8013cc <readn>
  801c52:	85 c0                	test   %eax,%eax
  801c54:	0f 88 bb 01 00 00    	js     801e15 <spawn+0x565>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c5a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801c60:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c64:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c68:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c72:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c79:	00 
  801c7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c81:	e8 d1 f0 ff ff       	call   800d57 <sys_page_map>
  801c86:	85 c0                	test   %eax,%eax
  801c88:	79 20                	jns    801caa <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  801c8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c8e:	c7 44 24 08 f5 31 80 	movl   $0x8031f5,0x8(%esp)
  801c95:	00 
  801c96:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  801c9d:	00 
  801c9e:	c7 04 24 e9 31 80 00 	movl   $0x8031e9,(%esp)
  801ca5:	e8 19 e5 ff ff       	call   8001c3 <_panic>
			sys_page_unmap(0, UTEMP);
  801caa:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cb1:	00 
  801cb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb9:	e8 ec f0 ff ff       	call   800daa <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801cbe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cc4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801cca:	89 df                	mov    %ebx,%edi
  801ccc:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801cd2:	0f 87 cf fe ff ff    	ja     801ba7 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801cd8:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801cdf:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801ce6:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801ced:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801cf3:	0f 8c 37 fe ff ff    	jl     801b30 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801cf9:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801cff:	89 04 24             	mov    %eax,(%esp)
  801d02:	e8 d0 f4 ff ff       	call   8011d7 <close>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  801d07:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d0c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	{
		if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U))&&((uvpt[i/PGSIZE]&(PTE_SHARE))==PTE_SHARE))
  801d12:	89 d8                	mov    %ebx,%eax
  801d14:	c1 e8 16             	shr    $0x16,%eax
  801d17:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d1e:	a8 01                	test   $0x1,%al
  801d20:	74 48                	je     801d6a <spawn+0x4ba>
  801d22:	89 d8                	mov    %ebx,%eax
  801d24:	c1 e8 0c             	shr    $0xc,%eax
  801d27:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801d2e:	83 e2 05             	and    $0x5,%edx
  801d31:	83 fa 05             	cmp    $0x5,%edx
  801d34:	75 34                	jne    801d6a <spawn+0x4ba>
  801d36:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801d3d:	f6 c6 04             	test   $0x4,%dh
  801d40:	74 28                	je     801d6a <spawn+0x4ba>
		{
			//cprintf("in copy_shared_pages\n");
			//cprintf("%08x\n",PDX(i));
			sys_page_map(0,(void*)i,child,(void*)i,uvpt[i/PGSIZE]&PTE_SYSCALL);
  801d42:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d49:	25 07 0e 00 00       	and    $0xe07,%eax
  801d4e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d52:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d56:	89 74 24 08          	mov    %esi,0x8(%esp)
  801d5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d65:	e8 ed ef ff ff       	call   800d57 <sys_page_map>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  801d6a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801d70:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801d76:	75 9a                	jne    801d12 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801d78:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d82:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d88:	89 04 24             	mov    %eax,(%esp)
  801d8b:	e8 c0 f0 ff ff       	call   800e50 <sys_env_set_trapframe>
  801d90:	85 c0                	test   %eax,%eax
  801d92:	79 20                	jns    801db4 <spawn+0x504>
		panic("sys_env_set_trapframe: %e", r);
  801d94:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d98:	c7 44 24 08 12 32 80 	movl   $0x803212,0x8(%esp)
  801d9f:	00 
  801da0:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801da7:	00 
  801da8:	c7 04 24 e9 31 80 00 	movl   $0x8031e9,(%esp)
  801daf:	e8 0f e4 ff ff       	call   8001c3 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801db4:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801dbb:	00 
  801dbc:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dc2:	89 04 24             	mov    %eax,(%esp)
  801dc5:	e8 33 f0 ff ff       	call   800dfd <sys_env_set_status>
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	79 30                	jns    801dfe <spawn+0x54e>
		panic("sys_env_set_status: %e", r);
  801dce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dd2:	c7 44 24 08 2c 32 80 	movl   $0x80322c,0x8(%esp)
  801dd9:	00 
  801dda:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  801de1:	00 
  801de2:	c7 04 24 e9 31 80 00 	movl   $0x8031e9,(%esp)
  801de9:	e8 d5 e3 ff ff       	call   8001c3 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801dee:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801df4:	eb 57                	jmp    801e4d <spawn+0x59d>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801df6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801dfc:	eb 4f                	jmp    801e4d <spawn+0x59d>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801dfe:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e04:	eb 47                	jmp    801e4d <spawn+0x59d>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801e06:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801e0b:	eb 40                	jmp    801e4d <spawn+0x59d>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e0d:	89 c3                	mov    %eax,%ebx
  801e0f:	eb 06                	jmp    801e17 <spawn+0x567>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e11:	89 c3                	mov    %eax,%ebx
  801e13:	eb 02                	jmp    801e17 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801e15:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  801e17:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e1d:	89 04 24             	mov    %eax,(%esp)
  801e20:	e8 4e ee ff ff       	call   800c73 <sys_env_destroy>
	close(fd);
  801e25:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e2b:	89 04 24             	mov    %eax,(%esp)
  801e2e:	e8 a4 f3 ff ff       	call   8011d7 <close>
	return r;
  801e33:	89 d8                	mov    %ebx,%eax
  801e35:	eb 16                	jmp    801e4d <spawn+0x59d>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801e37:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e3e:	00 
  801e3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e46:	e8 5f ef ff ff       	call   800daa <sys_page_unmap>
  801e4b:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801e4d:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    

00801e58 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	56                   	push   %esi
  801e5c:	53                   	push   %ebx
  801e5d:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e60:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801e63:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e68:	eb 03                	jmp    801e6d <spawnl+0x15>
		argc++;
  801e6a:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e6d:	83 c0 04             	add    $0x4,%eax
  801e70:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801e74:	75 f4                	jne    801e6a <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801e76:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  801e7d:	83 e0 f0             	and    $0xfffffff0,%eax
  801e80:	29 c4                	sub    %eax,%esp
  801e82:	8d 44 24 0b          	lea    0xb(%esp),%eax
  801e86:	c1 e8 02             	shr    $0x2,%eax
  801e89:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  801e90:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e95:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  801e9c:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  801ea3:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801ea4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea9:	eb 0a                	jmp    801eb5 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  801eab:	83 c0 01             	add    $0x1,%eax
  801eae:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801eb2:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801eb5:	39 d0                	cmp    %edx,%eax
  801eb7:	75 f2                	jne    801eab <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801eb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	89 04 24             	mov    %eax,(%esp)
  801ec3:	e8 e8 f9 ff ff       	call   8018b0 <spawn>
}
  801ec8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5e                   	pop    %esi
  801ecd:	5d                   	pop    %ebp
  801ece:	c3                   	ret    
  801ecf:	90                   	nop

00801ed0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ed6:	c7 44 24 04 6c 32 80 	movl   $0x80326c,0x4(%esp)
  801edd:	00 
  801ede:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee1:	89 04 24             	mov    %eax,(%esp)
  801ee4:	e8 fe e9 ff ff       	call   8008e7 <strcpy>
	return 0;
}
  801ee9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	53                   	push   %ebx
  801ef4:	83 ec 14             	sub    $0x14,%esp
  801ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801efa:	89 1c 24             	mov    %ebx,(%esp)
  801efd:	e8 04 0b 00 00       	call   802a06 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801f02:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801f07:	83 f8 01             	cmp    $0x1,%eax
  801f0a:	75 0d                	jne    801f19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f0c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f0f:	89 04 24             	mov    %eax,(%esp)
  801f12:	e8 29 03 00 00       	call   802240 <nsipc_close>
  801f17:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f19:	89 d0                	mov    %edx,%eax
  801f1b:	83 c4 14             	add    $0x14,%esp
  801f1e:	5b                   	pop    %ebx
  801f1f:	5d                   	pop    %ebp
  801f20:	c3                   	ret    

00801f21 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f2e:	00 
  801f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f40:	8b 40 0c             	mov    0xc(%eax),%eax
  801f43:	89 04 24             	mov    %eax,(%esp)
  801f46:	e8 f0 03 00 00       	call   80233b <nsipc_send>
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f5a:	00 
  801f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6f:	89 04 24             	mov    %eax,(%esp)
  801f72:	e8 44 03 00 00       	call   8022bb <nsipc_recv>
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f7f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f82:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f86:	89 04 24             	mov    %eax,(%esp)
  801f89:	e8 18 f1 ff ff       	call   8010a6 <fd_lookup>
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 17                	js     801fa9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f9b:	39 08                	cmp    %ecx,(%eax)
  801f9d:	75 05                	jne    801fa4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa2:	eb 05                	jmp    801fa9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801fa4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	56                   	push   %esi
  801faf:	53                   	push   %ebx
  801fb0:	83 ec 20             	sub    $0x20,%esp
  801fb3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb8:	89 04 24             	mov    %eax,(%esp)
  801fbb:	e8 97 f0 ff ff       	call   801057 <fd_alloc>
  801fc0:	89 c3                	mov    %eax,%ebx
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	78 21                	js     801fe7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fc6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fcd:	00 
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fdc:	e8 22 ed ff ff       	call   800d03 <sys_page_alloc>
  801fe1:	89 c3                	mov    %eax,%ebx
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	79 0c                	jns    801ff3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801fe7:	89 34 24             	mov    %esi,(%esp)
  801fea:	e8 51 02 00 00       	call   802240 <nsipc_close>
		return r;
  801fef:	89 d8                	mov    %ebx,%eax
  801ff1:	eb 20                	jmp    802013 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ff3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ffe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802001:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802008:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80200b:	89 14 24             	mov    %edx,(%esp)
  80200e:	e8 1d f0 ff ff       	call   801030 <fd2num>
}
  802013:	83 c4 20             	add    $0x20,%esp
  802016:	5b                   	pop    %ebx
  802017:	5e                   	pop    %esi
  802018:	5d                   	pop    %ebp
  802019:	c3                   	ret    

0080201a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
  80201d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802020:	8b 45 08             	mov    0x8(%ebp),%eax
  802023:	e8 51 ff ff ff       	call   801f79 <fd2sockid>
		return r;
  802028:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80202a:	85 c0                	test   %eax,%eax
  80202c:	78 23                	js     802051 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80202e:	8b 55 10             	mov    0x10(%ebp),%edx
  802031:	89 54 24 08          	mov    %edx,0x8(%esp)
  802035:	8b 55 0c             	mov    0xc(%ebp),%edx
  802038:	89 54 24 04          	mov    %edx,0x4(%esp)
  80203c:	89 04 24             	mov    %eax,(%esp)
  80203f:	e8 45 01 00 00       	call   802189 <nsipc_accept>
		return r;
  802044:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802046:	85 c0                	test   %eax,%eax
  802048:	78 07                	js     802051 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80204a:	e8 5c ff ff ff       	call   801fab <alloc_sockfd>
  80204f:	89 c1                	mov    %eax,%ecx
}
  802051:	89 c8                	mov    %ecx,%eax
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80205b:	8b 45 08             	mov    0x8(%ebp),%eax
  80205e:	e8 16 ff ff ff       	call   801f79 <fd2sockid>
  802063:	89 c2                	mov    %eax,%edx
  802065:	85 d2                	test   %edx,%edx
  802067:	78 16                	js     80207f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802069:	8b 45 10             	mov    0x10(%ebp),%eax
  80206c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802070:	8b 45 0c             	mov    0xc(%ebp),%eax
  802073:	89 44 24 04          	mov    %eax,0x4(%esp)
  802077:	89 14 24             	mov    %edx,(%esp)
  80207a:	e8 60 01 00 00       	call   8021df <nsipc_bind>
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <shutdown>:

int
shutdown(int s, int how)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	e8 ea fe ff ff       	call   801f79 <fd2sockid>
  80208f:	89 c2                	mov    %eax,%edx
  802091:	85 d2                	test   %edx,%edx
  802093:	78 0f                	js     8020a4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802095:	8b 45 0c             	mov    0xc(%ebp),%eax
  802098:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209c:	89 14 24             	mov    %edx,(%esp)
  80209f:	e8 7a 01 00 00       	call   80221e <nsipc_shutdown>
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	e8 c5 fe ff ff       	call   801f79 <fd2sockid>
  8020b4:	89 c2                	mov    %eax,%edx
  8020b6:	85 d2                	test   %edx,%edx
  8020b8:	78 16                	js     8020d0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8020ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8020bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c8:	89 14 24             	mov    %edx,(%esp)
  8020cb:	e8 8a 01 00 00       	call   80225a <nsipc_connect>
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <listen>:

int
listen(int s, int backlog)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	e8 99 fe ff ff       	call   801f79 <fd2sockid>
  8020e0:	89 c2                	mov    %eax,%edx
  8020e2:	85 d2                	test   %edx,%edx
  8020e4:	78 0f                	js     8020f5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8020e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ed:	89 14 24             	mov    %edx,(%esp)
  8020f0:	e8 a4 01 00 00       	call   802299 <nsipc_listen>
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802100:	89 44 24 08          	mov    %eax,0x8(%esp)
  802104:	8b 45 0c             	mov    0xc(%ebp),%eax
  802107:	89 44 24 04          	mov    %eax,0x4(%esp)
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	89 04 24             	mov    %eax,(%esp)
  802111:	e8 98 02 00 00       	call   8023ae <nsipc_socket>
  802116:	89 c2                	mov    %eax,%edx
  802118:	85 d2                	test   %edx,%edx
  80211a:	78 05                	js     802121 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80211c:	e8 8a fe ff ff       	call   801fab <alloc_sockfd>
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
  802126:	53                   	push   %ebx
  802127:	83 ec 14             	sub    $0x14,%esp
  80212a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80212c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802133:	75 11                	jne    802146 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802135:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80213c:	e8 8d 08 00 00       	call   8029ce <ipc_find_env>
  802141:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802146:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80214d:	00 
  80214e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802155:	00 
  802156:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80215a:	a1 04 50 80 00       	mov    0x805004,%eax
  80215f:	89 04 24             	mov    %eax,(%esp)
  802162:	e8 09 08 00 00       	call   802970 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802167:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80216e:	00 
  80216f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802176:	00 
  802177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80217e:	e8 83 07 00 00       	call   802906 <ipc_recv>
}
  802183:	83 c4 14             	add    $0x14,%esp
  802186:	5b                   	pop    %ebx
  802187:	5d                   	pop    %ebp
  802188:	c3                   	ret    

00802189 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	56                   	push   %esi
  80218d:	53                   	push   %ebx
  80218e:	83 ec 10             	sub    $0x10,%esp
  802191:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80219c:	8b 06                	mov    (%esi),%eax
  80219e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a8:	e8 76 ff ff ff       	call   802123 <nsipc>
  8021ad:	89 c3                	mov    %eax,%ebx
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	78 23                	js     8021d6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021b3:	a1 10 70 80 00       	mov    0x807010,%eax
  8021b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021bc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021c3:	00 
  8021c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c7:	89 04 24             	mov    %eax,(%esp)
  8021ca:	e8 b5 e8 ff ff       	call   800a84 <memmove>
		*addrlen = ret->ret_addrlen;
  8021cf:	a1 10 70 80 00       	mov    0x807010,%eax
  8021d4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8021d6:	89 d8                	mov    %ebx,%eax
  8021d8:	83 c4 10             	add    $0x10,%esp
  8021db:	5b                   	pop    %ebx
  8021dc:	5e                   	pop    %esi
  8021dd:	5d                   	pop    %ebp
  8021de:	c3                   	ret    

008021df <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
  8021e2:	53                   	push   %ebx
  8021e3:	83 ec 14             	sub    $0x14,%esp
  8021e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021fc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802203:	e8 7c e8 ff ff       	call   800a84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802208:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80220e:	b8 02 00 00 00       	mov    $0x2,%eax
  802213:	e8 0b ff ff ff       	call   802123 <nsipc>
}
  802218:	83 c4 14             	add    $0x14,%esp
  80221b:	5b                   	pop    %ebx
  80221c:	5d                   	pop    %ebp
  80221d:	c3                   	ret    

0080221e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80222c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802234:	b8 03 00 00 00       	mov    $0x3,%eax
  802239:	e8 e5 fe ff ff       	call   802123 <nsipc>
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <nsipc_close>:

int
nsipc_close(int s)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
  802243:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80224e:	b8 04 00 00 00       	mov    $0x4,%eax
  802253:	e8 cb fe ff ff       	call   802123 <nsipc>
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
  80225d:	53                   	push   %ebx
  80225e:	83 ec 14             	sub    $0x14,%esp
  802261:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80226c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802270:	8b 45 0c             	mov    0xc(%ebp),%eax
  802273:	89 44 24 04          	mov    %eax,0x4(%esp)
  802277:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80227e:	e8 01 e8 ff ff       	call   800a84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802283:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802289:	b8 05 00 00 00       	mov    $0x5,%eax
  80228e:	e8 90 fe ff ff       	call   802123 <nsipc>
}
  802293:	83 c4 14             	add    $0x14,%esp
  802296:	5b                   	pop    %ebx
  802297:	5d                   	pop    %ebp
  802298:	c3                   	ret    

00802299 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022aa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022af:	b8 06 00 00 00       	mov    $0x6,%eax
  8022b4:	e8 6a fe ff ff       	call   802123 <nsipc>
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	56                   	push   %esi
  8022bf:	53                   	push   %ebx
  8022c0:	83 ec 10             	sub    $0x10,%esp
  8022c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022ce:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8022e1:	e8 3d fe ff ff       	call   802123 <nsipc>
  8022e6:	89 c3                	mov    %eax,%ebx
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	78 46                	js     802332 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022ec:	39 f0                	cmp    %esi,%eax
  8022ee:	7f 07                	jg     8022f7 <nsipc_recv+0x3c>
  8022f0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022f5:	7e 24                	jle    80231b <nsipc_recv+0x60>
  8022f7:	c7 44 24 0c 78 32 80 	movl   $0x803278,0xc(%esp)
  8022fe:	00 
  8022ff:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  802306:	00 
  802307:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80230e:	00 
  80230f:	c7 04 24 8d 32 80 00 	movl   $0x80328d,(%esp)
  802316:	e8 a8 de ff ff       	call   8001c3 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80231b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80231f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802326:	00 
  802327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232a:	89 04 24             	mov    %eax,(%esp)
  80232d:	e8 52 e7 ff ff       	call   800a84 <memmove>
	}

	return r;
}
  802332:	89 d8                	mov    %ebx,%eax
  802334:	83 c4 10             	add    $0x10,%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5d                   	pop    %ebp
  80233a:	c3                   	ret    

0080233b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	53                   	push   %ebx
  80233f:	83 ec 14             	sub    $0x14,%esp
  802342:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802345:	8b 45 08             	mov    0x8(%ebp),%eax
  802348:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80234d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802353:	7e 24                	jle    802379 <nsipc_send+0x3e>
  802355:	c7 44 24 0c 99 32 80 	movl   $0x803299,0xc(%esp)
  80235c:	00 
  80235d:	c7 44 24 08 a3 31 80 	movl   $0x8031a3,0x8(%esp)
  802364:	00 
  802365:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80236c:	00 
  80236d:	c7 04 24 8d 32 80 00 	movl   $0x80328d,(%esp)
  802374:	e8 4a de ff ff       	call   8001c3 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802379:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80237d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802380:	89 44 24 04          	mov    %eax,0x4(%esp)
  802384:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80238b:	e8 f4 e6 ff ff       	call   800a84 <memmove>
	nsipcbuf.send.req_size = size;
  802390:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802396:	8b 45 14             	mov    0x14(%ebp),%eax
  802399:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80239e:	b8 08 00 00 00       	mov    $0x8,%eax
  8023a3:	e8 7b fd ff ff       	call   802123 <nsipc>
}
  8023a8:	83 c4 14             	add    $0x14,%esp
  8023ab:	5b                   	pop    %ebx
  8023ac:	5d                   	pop    %ebp
  8023ad:	c3                   	ret    

008023ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8023d1:	e8 4d fd ff ff       	call   802123 <nsipc>
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
  8023db:	56                   	push   %esi
  8023dc:	53                   	push   %ebx
  8023dd:	83 ec 10             	sub    $0x10,%esp
  8023e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	89 04 24             	mov    %eax,(%esp)
  8023e9:	e8 52 ec ff ff       	call   801040 <fd2data>
  8023ee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023f0:	c7 44 24 04 a5 32 80 	movl   $0x8032a5,0x4(%esp)
  8023f7:	00 
  8023f8:	89 1c 24             	mov    %ebx,(%esp)
  8023fb:	e8 e7 e4 ff ff       	call   8008e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802400:	8b 46 04             	mov    0x4(%esi),%eax
  802403:	2b 06                	sub    (%esi),%eax
  802405:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80240b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802412:	00 00 00 
	stat->st_dev = &devpipe;
  802415:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80241c:	40 80 00 
	return 0;
}
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
  802424:	83 c4 10             	add    $0x10,%esp
  802427:	5b                   	pop    %ebx
  802428:	5e                   	pop    %esi
  802429:	5d                   	pop    %ebp
  80242a:	c3                   	ret    

0080242b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	53                   	push   %ebx
  80242f:	83 ec 14             	sub    $0x14,%esp
  802432:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802435:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802439:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802440:	e8 65 e9 ff ff       	call   800daa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802445:	89 1c 24             	mov    %ebx,(%esp)
  802448:	e8 f3 eb ff ff       	call   801040 <fd2data>
  80244d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802451:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802458:	e8 4d e9 ff ff       	call   800daa <sys_page_unmap>
}
  80245d:	83 c4 14             	add    $0x14,%esp
  802460:	5b                   	pop    %ebx
  802461:	5d                   	pop    %ebp
  802462:	c3                   	ret    

00802463 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	57                   	push   %edi
  802467:	56                   	push   %esi
  802468:	53                   	push   %ebx
  802469:	83 ec 2c             	sub    $0x2c,%esp
  80246c:	89 c6                	mov    %eax,%esi
  80246e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802471:	a1 08 50 80 00       	mov    0x805008,%eax
  802476:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802479:	89 34 24             	mov    %esi,(%esp)
  80247c:	e8 85 05 00 00       	call   802a06 <pageref>
  802481:	89 c7                	mov    %eax,%edi
  802483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802486:	89 04 24             	mov    %eax,(%esp)
  802489:	e8 78 05 00 00       	call   802a06 <pageref>
  80248e:	39 c7                	cmp    %eax,%edi
  802490:	0f 94 c2             	sete   %dl
  802493:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802496:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80249c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80249f:	39 fb                	cmp    %edi,%ebx
  8024a1:	74 21                	je     8024c4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8024a3:	84 d2                	test   %dl,%dl
  8024a5:	74 ca                	je     802471 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024a7:	8b 51 58             	mov    0x58(%ecx),%edx
  8024aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024b6:	c7 04 24 ac 32 80 00 	movl   $0x8032ac,(%esp)
  8024bd:	e8 fa dd ff ff       	call   8002bc <cprintf>
  8024c2:	eb ad                	jmp    802471 <_pipeisclosed+0xe>
	}
}
  8024c4:	83 c4 2c             	add    $0x2c,%esp
  8024c7:	5b                   	pop    %ebx
  8024c8:	5e                   	pop    %esi
  8024c9:	5f                   	pop    %edi
  8024ca:	5d                   	pop    %ebp
  8024cb:	c3                   	ret    

008024cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	57                   	push   %edi
  8024d0:	56                   	push   %esi
  8024d1:	53                   	push   %ebx
  8024d2:	83 ec 1c             	sub    $0x1c,%esp
  8024d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024d8:	89 34 24             	mov    %esi,(%esp)
  8024db:	e8 60 eb ff ff       	call   801040 <fd2data>
  8024e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024e7:	eb 45                	jmp    80252e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024e9:	89 da                	mov    %ebx,%edx
  8024eb:	89 f0                	mov    %esi,%eax
  8024ed:	e8 71 ff ff ff       	call   802463 <_pipeisclosed>
  8024f2:	85 c0                	test   %eax,%eax
  8024f4:	75 41                	jne    802537 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024f6:	e8 e9 e7 ff ff       	call   800ce4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8024fe:	8b 0b                	mov    (%ebx),%ecx
  802500:	8d 51 20             	lea    0x20(%ecx),%edx
  802503:	39 d0                	cmp    %edx,%eax
  802505:	73 e2                	jae    8024e9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80250a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80250e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802511:	99                   	cltd   
  802512:	c1 ea 1b             	shr    $0x1b,%edx
  802515:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802518:	83 e1 1f             	and    $0x1f,%ecx
  80251b:	29 d1                	sub    %edx,%ecx
  80251d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802521:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802525:	83 c0 01             	add    $0x1,%eax
  802528:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80252b:	83 c7 01             	add    $0x1,%edi
  80252e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802531:	75 c8                	jne    8024fb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802533:	89 f8                	mov    %edi,%eax
  802535:	eb 05                	jmp    80253c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802537:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80253c:	83 c4 1c             	add    $0x1c,%esp
  80253f:	5b                   	pop    %ebx
  802540:	5e                   	pop    %esi
  802541:	5f                   	pop    %edi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    

00802544 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	57                   	push   %edi
  802548:	56                   	push   %esi
  802549:	53                   	push   %ebx
  80254a:	83 ec 1c             	sub    $0x1c,%esp
  80254d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802550:	89 3c 24             	mov    %edi,(%esp)
  802553:	e8 e8 ea ff ff       	call   801040 <fd2data>
  802558:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80255a:	be 00 00 00 00       	mov    $0x0,%esi
  80255f:	eb 3d                	jmp    80259e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802561:	85 f6                	test   %esi,%esi
  802563:	74 04                	je     802569 <devpipe_read+0x25>
				return i;
  802565:	89 f0                	mov    %esi,%eax
  802567:	eb 43                	jmp    8025ac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802569:	89 da                	mov    %ebx,%edx
  80256b:	89 f8                	mov    %edi,%eax
  80256d:	e8 f1 fe ff ff       	call   802463 <_pipeisclosed>
  802572:	85 c0                	test   %eax,%eax
  802574:	75 31                	jne    8025a7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802576:	e8 69 e7 ff ff       	call   800ce4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80257b:	8b 03                	mov    (%ebx),%eax
  80257d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802580:	74 df                	je     802561 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802582:	99                   	cltd   
  802583:	c1 ea 1b             	shr    $0x1b,%edx
  802586:	01 d0                	add    %edx,%eax
  802588:	83 e0 1f             	and    $0x1f,%eax
  80258b:	29 d0                	sub    %edx,%eax
  80258d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802592:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802595:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802598:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80259b:	83 c6 01             	add    $0x1,%esi
  80259e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025a1:	75 d8                	jne    80257b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025a3:	89 f0                	mov    %esi,%eax
  8025a5:	eb 05                	jmp    8025ac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025a7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8025ac:	83 c4 1c             	add    $0x1c,%esp
  8025af:	5b                   	pop    %ebx
  8025b0:	5e                   	pop    %esi
  8025b1:	5f                   	pop    %edi
  8025b2:	5d                   	pop    %ebp
  8025b3:	c3                   	ret    

008025b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
  8025b7:	56                   	push   %esi
  8025b8:	53                   	push   %ebx
  8025b9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025bf:	89 04 24             	mov    %eax,(%esp)
  8025c2:	e8 90 ea ff ff       	call   801057 <fd_alloc>
  8025c7:	89 c2                	mov    %eax,%edx
  8025c9:	85 d2                	test   %edx,%edx
  8025cb:	0f 88 4d 01 00 00    	js     80271e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025d1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025d8:	00 
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e7:	e8 17 e7 ff ff       	call   800d03 <sys_page_alloc>
  8025ec:	89 c2                	mov    %eax,%edx
  8025ee:	85 d2                	test   %edx,%edx
  8025f0:	0f 88 28 01 00 00    	js     80271e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025f9:	89 04 24             	mov    %eax,(%esp)
  8025fc:	e8 56 ea ff ff       	call   801057 <fd_alloc>
  802601:	89 c3                	mov    %eax,%ebx
  802603:	85 c0                	test   %eax,%eax
  802605:	0f 88 fe 00 00 00    	js     802709 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80260b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802612:	00 
  802613:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802616:	89 44 24 04          	mov    %eax,0x4(%esp)
  80261a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802621:	e8 dd e6 ff ff       	call   800d03 <sys_page_alloc>
  802626:	89 c3                	mov    %eax,%ebx
  802628:	85 c0                	test   %eax,%eax
  80262a:	0f 88 d9 00 00 00    	js     802709 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	89 04 24             	mov    %eax,(%esp)
  802636:	e8 05 ea ff ff       	call   801040 <fd2data>
  80263b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80263d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802644:	00 
  802645:	89 44 24 04          	mov    %eax,0x4(%esp)
  802649:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802650:	e8 ae e6 ff ff       	call   800d03 <sys_page_alloc>
  802655:	89 c3                	mov    %eax,%ebx
  802657:	85 c0                	test   %eax,%eax
  802659:	0f 88 97 00 00 00    	js     8026f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	89 04 24             	mov    %eax,(%esp)
  802665:	e8 d6 e9 ff ff       	call   801040 <fd2data>
  80266a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802671:	00 
  802672:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802676:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80267d:	00 
  80267e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802682:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802689:	e8 c9 e6 ff ff       	call   800d57 <sys_page_map>
  80268e:	89 c3                	mov    %eax,%ebx
  802690:	85 c0                	test   %eax,%eax
  802692:	78 52                	js     8026e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802694:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8026a9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8026af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	89 04 24             	mov    %eax,(%esp)
  8026c4:	e8 67 e9 ff ff       	call   801030 <fd2num>
  8026c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d1:	89 04 24             	mov    %eax,(%esp)
  8026d4:	e8 57 e9 ff ff       	call   801030 <fd2num>
  8026d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	eb 38                	jmp    80271e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8026e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f1:	e8 b4 e6 ff ff       	call   800daa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802704:	e8 a1 e6 ff ff       	call   800daa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802710:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802717:	e8 8e e6 ff ff       	call   800daa <sys_page_unmap>
  80271c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80271e:	83 c4 30             	add    $0x30,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5d                   	pop    %ebp
  802724:	c3                   	ret    

00802725 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802725:	55                   	push   %ebp
  802726:	89 e5                	mov    %esp,%ebp
  802728:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80272b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80272e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	89 04 24             	mov    %eax,(%esp)
  802738:	e8 69 e9 ff ff       	call   8010a6 <fd_lookup>
  80273d:	89 c2                	mov    %eax,%edx
  80273f:	85 d2                	test   %edx,%edx
  802741:	78 15                	js     802758 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802746:	89 04 24             	mov    %eax,(%esp)
  802749:	e8 f2 e8 ff ff       	call   801040 <fd2data>
	return _pipeisclosed(fd, p);
  80274e:	89 c2                	mov    %eax,%edx
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	e8 0b fd ff ff       	call   802463 <_pipeisclosed>
}
  802758:	c9                   	leave  
  802759:	c3                   	ret    
  80275a:	66 90                	xchg   %ax,%ax
  80275c:	66 90                	xchg   %ax,%ax
  80275e:	66 90                	xchg   %ax,%ax

00802760 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802763:	b8 00 00 00 00       	mov    $0x0,%eax
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    

0080276a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802770:	c7 44 24 04 c4 32 80 	movl   $0x8032c4,0x4(%esp)
  802777:	00 
  802778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277b:	89 04 24             	mov    %eax,(%esp)
  80277e:	e8 64 e1 ff ff       	call   8008e7 <strcpy>
	return 0;
}
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	57                   	push   %edi
  80278e:	56                   	push   %esi
  80278f:	53                   	push   %ebx
  802790:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802796:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80279b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027a1:	eb 31                	jmp    8027d4 <devcons_write+0x4a>
		m = n - tot;
  8027a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8027a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8027a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8027ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8027b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027b7:	03 45 0c             	add    0xc(%ebp),%eax
  8027ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027be:	89 3c 24             	mov    %edi,(%esp)
  8027c1:	e8 be e2 ff ff       	call   800a84 <memmove>
		sys_cputs(buf, m);
  8027c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027ca:	89 3c 24             	mov    %edi,(%esp)
  8027cd:	e8 64 e4 ff ff       	call   800c36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027d2:	01 f3                	add    %esi,%ebx
  8027d4:	89 d8                	mov    %ebx,%eax
  8027d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8027d9:	72 c8                	jb     8027a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027e1:	5b                   	pop    %ebx
  8027e2:	5e                   	pop    %esi
  8027e3:	5f                   	pop    %edi
  8027e4:	5d                   	pop    %ebp
  8027e5:	c3                   	ret    

008027e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027e6:	55                   	push   %ebp
  8027e7:	89 e5                	mov    %esp,%ebp
  8027e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8027ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8027f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027f5:	75 07                	jne    8027fe <devcons_read+0x18>
  8027f7:	eb 2a                	jmp    802823 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027f9:	e8 e6 e4 ff ff       	call   800ce4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027fe:	66 90                	xchg   %ax,%ax
  802800:	e8 4f e4 ff ff       	call   800c54 <sys_cgetc>
  802805:	85 c0                	test   %eax,%eax
  802807:	74 f0                	je     8027f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802809:	85 c0                	test   %eax,%eax
  80280b:	78 16                	js     802823 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80280d:	83 f8 04             	cmp    $0x4,%eax
  802810:	74 0c                	je     80281e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802812:	8b 55 0c             	mov    0xc(%ebp),%edx
  802815:	88 02                	mov    %al,(%edx)
	return 1;
  802817:	b8 01 00 00 00       	mov    $0x1,%eax
  80281c:	eb 05                	jmp    802823 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80282b:	8b 45 08             	mov    0x8(%ebp),%eax
  80282e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802831:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802838:	00 
  802839:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80283c:	89 04 24             	mov    %eax,(%esp)
  80283f:	e8 f2 e3 ff ff       	call   800c36 <sys_cputs>
}
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <getchar>:

int
getchar(void)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80284c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802853:	00 
  802854:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802857:	89 44 24 04          	mov    %eax,0x4(%esp)
  80285b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802862:	e8 d3 ea ff ff       	call   80133a <read>
	if (r < 0)
  802867:	85 c0                	test   %eax,%eax
  802869:	78 0f                	js     80287a <getchar+0x34>
		return r;
	if (r < 1)
  80286b:	85 c0                	test   %eax,%eax
  80286d:	7e 06                	jle    802875 <getchar+0x2f>
		return -E_EOF;
	return c;
  80286f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802873:	eb 05                	jmp    80287a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802875:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80287a:	c9                   	leave  
  80287b:	c3                   	ret    

0080287c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802882:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802885:	89 44 24 04          	mov    %eax,0x4(%esp)
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	89 04 24             	mov    %eax,(%esp)
  80288f:	e8 12 e8 ff ff       	call   8010a6 <fd_lookup>
  802894:	85 c0                	test   %eax,%eax
  802896:	78 11                	js     8028a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028a1:	39 10                	cmp    %edx,(%eax)
  8028a3:	0f 94 c0             	sete   %al
  8028a6:	0f b6 c0             	movzbl %al,%eax
}
  8028a9:	c9                   	leave  
  8028aa:	c3                   	ret    

008028ab <opencons>:

int
opencons(void)
{
  8028ab:	55                   	push   %ebp
  8028ac:	89 e5                	mov    %esp,%ebp
  8028ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028b4:	89 04 24             	mov    %eax,(%esp)
  8028b7:	e8 9b e7 ff ff       	call   801057 <fd_alloc>
		return r;
  8028bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	78 40                	js     802902 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028c9:	00 
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d8:	e8 26 e4 ff ff       	call   800d03 <sys_page_alloc>
		return r;
  8028dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028df:	85 c0                	test   %eax,%eax
  8028e1:	78 1f                	js     802902 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028e3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028f8:	89 04 24             	mov    %eax,(%esp)
  8028fb:	e8 30 e7 ff ff       	call   801030 <fd2num>
  802900:	89 c2                	mov    %eax,%edx
}
  802902:	89 d0                	mov    %edx,%eax
  802904:	c9                   	leave  
  802905:	c3                   	ret    

00802906 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
  802909:	56                   	push   %esi
  80290a:	53                   	push   %ebx
  80290b:	83 ec 10             	sub    $0x10,%esp
  80290e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802911:	8b 45 0c             	mov    0xc(%ebp),%eax
  802914:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802917:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802919:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80291e:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802921:	89 04 24             	mov    %eax,(%esp)
  802924:	e8 f0 e5 ff ff       	call   800f19 <sys_ipc_recv>
  802929:	85 c0                	test   %eax,%eax
  80292b:	75 1e                	jne    80294b <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80292d:	85 db                	test   %ebx,%ebx
  80292f:	74 0a                	je     80293b <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802931:	a1 08 50 80 00       	mov    0x805008,%eax
  802936:	8b 40 74             	mov    0x74(%eax),%eax
  802939:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80293b:	85 f6                	test   %esi,%esi
  80293d:	74 22                	je     802961 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80293f:	a1 08 50 80 00       	mov    0x805008,%eax
  802944:	8b 40 78             	mov    0x78(%eax),%eax
  802947:	89 06                	mov    %eax,(%esi)
  802949:	eb 16                	jmp    802961 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80294b:	85 f6                	test   %esi,%esi
  80294d:	74 06                	je     802955 <ipc_recv+0x4f>
				*perm_store = 0;
  80294f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802955:	85 db                	test   %ebx,%ebx
  802957:	74 10                	je     802969 <ipc_recv+0x63>
				*from_env_store=0;
  802959:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80295f:	eb 08                	jmp    802969 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802961:	a1 08 50 80 00       	mov    0x805008,%eax
  802966:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802969:	83 c4 10             	add    $0x10,%esp
  80296c:	5b                   	pop    %ebx
  80296d:	5e                   	pop    %esi
  80296e:	5d                   	pop    %ebp
  80296f:	c3                   	ret    

00802970 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	57                   	push   %edi
  802974:	56                   	push   %esi
  802975:	53                   	push   %ebx
  802976:	83 ec 1c             	sub    $0x1c,%esp
  802979:	8b 75 0c             	mov    0xc(%ebp),%esi
  80297c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80297f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802982:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802984:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802989:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80298c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802990:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802994:	89 74 24 04          	mov    %esi,0x4(%esp)
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	89 04 24             	mov    %eax,(%esp)
  80299e:	e8 53 e5 ff ff       	call   800ef6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8029a3:	eb 1c                	jmp    8029c1 <ipc_send+0x51>
	{
		sys_yield();
  8029a5:	e8 3a e3 ff ff       	call   800ce4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8029aa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	89 04 24             	mov    %eax,(%esp)
  8029bc:	e8 35 e5 ff ff       	call   800ef6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8029c1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029c4:	74 df                	je     8029a5 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8029c6:	83 c4 1c             	add    $0x1c,%esp
  8029c9:	5b                   	pop    %ebx
  8029ca:	5e                   	pop    %esi
  8029cb:	5f                   	pop    %edi
  8029cc:	5d                   	pop    %ebp
  8029cd:	c3                   	ret    

008029ce <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
  8029d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029d4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029d9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8029dc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029e2:	8b 52 50             	mov    0x50(%edx),%edx
  8029e5:	39 ca                	cmp    %ecx,%edx
  8029e7:	75 0d                	jne    8029f6 <ipc_find_env+0x28>
			return envs[i].env_id;
  8029e9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8029ec:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8029f1:	8b 40 40             	mov    0x40(%eax),%eax
  8029f4:	eb 0e                	jmp    802a04 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8029f6:	83 c0 01             	add    $0x1,%eax
  8029f9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029fe:	75 d9                	jne    8029d9 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802a00:	66 b8 00 00          	mov    $0x0,%ax
}
  802a04:	5d                   	pop    %ebp
  802a05:	c3                   	ret    

00802a06 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a06:	55                   	push   %ebp
  802a07:	89 e5                	mov    %esp,%ebp
  802a09:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a0c:	89 d0                	mov    %edx,%eax
  802a0e:	c1 e8 16             	shr    $0x16,%eax
  802a11:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a18:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a1d:	f6 c1 01             	test   $0x1,%cl
  802a20:	74 1d                	je     802a3f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a22:	c1 ea 0c             	shr    $0xc,%edx
  802a25:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a2c:	f6 c2 01             	test   $0x1,%dl
  802a2f:	74 0e                	je     802a3f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a31:	c1 ea 0c             	shr    $0xc,%edx
  802a34:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a3b:	ef 
  802a3c:	0f b7 c0             	movzwl %ax,%eax
}
  802a3f:	5d                   	pop    %ebp
  802a40:	c3                   	ret    
  802a41:	66 90                	xchg   %ax,%ax
  802a43:	66 90                	xchg   %ax,%ax
  802a45:	66 90                	xchg   %ax,%ax
  802a47:	66 90                	xchg   %ax,%ax
  802a49:	66 90                	xchg   %ax,%ax
  802a4b:	66 90                	xchg   %ax,%ax
  802a4d:	66 90                	xchg   %ax,%ax
  802a4f:	90                   	nop

00802a50 <__udivdi3>:
  802a50:	55                   	push   %ebp
  802a51:	57                   	push   %edi
  802a52:	56                   	push   %esi
  802a53:	83 ec 0c             	sub    $0xc,%esp
  802a56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a5a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a5e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a62:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a66:	85 c0                	test   %eax,%eax
  802a68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a6c:	89 ea                	mov    %ebp,%edx
  802a6e:	89 0c 24             	mov    %ecx,(%esp)
  802a71:	75 2d                	jne    802aa0 <__udivdi3+0x50>
  802a73:	39 e9                	cmp    %ebp,%ecx
  802a75:	77 61                	ja     802ad8 <__udivdi3+0x88>
  802a77:	85 c9                	test   %ecx,%ecx
  802a79:	89 ce                	mov    %ecx,%esi
  802a7b:	75 0b                	jne    802a88 <__udivdi3+0x38>
  802a7d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a82:	31 d2                	xor    %edx,%edx
  802a84:	f7 f1                	div    %ecx
  802a86:	89 c6                	mov    %eax,%esi
  802a88:	31 d2                	xor    %edx,%edx
  802a8a:	89 e8                	mov    %ebp,%eax
  802a8c:	f7 f6                	div    %esi
  802a8e:	89 c5                	mov    %eax,%ebp
  802a90:	89 f8                	mov    %edi,%eax
  802a92:	f7 f6                	div    %esi
  802a94:	89 ea                	mov    %ebp,%edx
  802a96:	83 c4 0c             	add    $0xc,%esp
  802a99:	5e                   	pop    %esi
  802a9a:	5f                   	pop    %edi
  802a9b:	5d                   	pop    %ebp
  802a9c:	c3                   	ret    
  802a9d:	8d 76 00             	lea    0x0(%esi),%esi
  802aa0:	39 e8                	cmp    %ebp,%eax
  802aa2:	77 24                	ja     802ac8 <__udivdi3+0x78>
  802aa4:	0f bd e8             	bsr    %eax,%ebp
  802aa7:	83 f5 1f             	xor    $0x1f,%ebp
  802aaa:	75 3c                	jne    802ae8 <__udivdi3+0x98>
  802aac:	8b 74 24 04          	mov    0x4(%esp),%esi
  802ab0:	39 34 24             	cmp    %esi,(%esp)
  802ab3:	0f 86 9f 00 00 00    	jbe    802b58 <__udivdi3+0x108>
  802ab9:	39 d0                	cmp    %edx,%eax
  802abb:	0f 82 97 00 00 00    	jb     802b58 <__udivdi3+0x108>
  802ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	31 d2                	xor    %edx,%edx
  802aca:	31 c0                	xor    %eax,%eax
  802acc:	83 c4 0c             	add    $0xc,%esp
  802acf:	5e                   	pop    %esi
  802ad0:	5f                   	pop    %edi
  802ad1:	5d                   	pop    %ebp
  802ad2:	c3                   	ret    
  802ad3:	90                   	nop
  802ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	89 f8                	mov    %edi,%eax
  802ada:	f7 f1                	div    %ecx
  802adc:	31 d2                	xor    %edx,%edx
  802ade:	83 c4 0c             	add    $0xc,%esp
  802ae1:	5e                   	pop    %esi
  802ae2:	5f                   	pop    %edi
  802ae3:	5d                   	pop    %ebp
  802ae4:	c3                   	ret    
  802ae5:	8d 76 00             	lea    0x0(%esi),%esi
  802ae8:	89 e9                	mov    %ebp,%ecx
  802aea:	8b 3c 24             	mov    (%esp),%edi
  802aed:	d3 e0                	shl    %cl,%eax
  802aef:	89 c6                	mov    %eax,%esi
  802af1:	b8 20 00 00 00       	mov    $0x20,%eax
  802af6:	29 e8                	sub    %ebp,%eax
  802af8:	89 c1                	mov    %eax,%ecx
  802afa:	d3 ef                	shr    %cl,%edi
  802afc:	89 e9                	mov    %ebp,%ecx
  802afe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b02:	8b 3c 24             	mov    (%esp),%edi
  802b05:	09 74 24 08          	or     %esi,0x8(%esp)
  802b09:	89 d6                	mov    %edx,%esi
  802b0b:	d3 e7                	shl    %cl,%edi
  802b0d:	89 c1                	mov    %eax,%ecx
  802b0f:	89 3c 24             	mov    %edi,(%esp)
  802b12:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b16:	d3 ee                	shr    %cl,%esi
  802b18:	89 e9                	mov    %ebp,%ecx
  802b1a:	d3 e2                	shl    %cl,%edx
  802b1c:	89 c1                	mov    %eax,%ecx
  802b1e:	d3 ef                	shr    %cl,%edi
  802b20:	09 d7                	or     %edx,%edi
  802b22:	89 f2                	mov    %esi,%edx
  802b24:	89 f8                	mov    %edi,%eax
  802b26:	f7 74 24 08          	divl   0x8(%esp)
  802b2a:	89 d6                	mov    %edx,%esi
  802b2c:	89 c7                	mov    %eax,%edi
  802b2e:	f7 24 24             	mull   (%esp)
  802b31:	39 d6                	cmp    %edx,%esi
  802b33:	89 14 24             	mov    %edx,(%esp)
  802b36:	72 30                	jb     802b68 <__udivdi3+0x118>
  802b38:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b3c:	89 e9                	mov    %ebp,%ecx
  802b3e:	d3 e2                	shl    %cl,%edx
  802b40:	39 c2                	cmp    %eax,%edx
  802b42:	73 05                	jae    802b49 <__udivdi3+0xf9>
  802b44:	3b 34 24             	cmp    (%esp),%esi
  802b47:	74 1f                	je     802b68 <__udivdi3+0x118>
  802b49:	89 f8                	mov    %edi,%eax
  802b4b:	31 d2                	xor    %edx,%edx
  802b4d:	e9 7a ff ff ff       	jmp    802acc <__udivdi3+0x7c>
  802b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b58:	31 d2                	xor    %edx,%edx
  802b5a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b5f:	e9 68 ff ff ff       	jmp    802acc <__udivdi3+0x7c>
  802b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b68:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b6b:	31 d2                	xor    %edx,%edx
  802b6d:	83 c4 0c             	add    $0xc,%esp
  802b70:	5e                   	pop    %esi
  802b71:	5f                   	pop    %edi
  802b72:	5d                   	pop    %ebp
  802b73:	c3                   	ret    
  802b74:	66 90                	xchg   %ax,%ax
  802b76:	66 90                	xchg   %ax,%ax
  802b78:	66 90                	xchg   %ax,%ax
  802b7a:	66 90                	xchg   %ax,%ax
  802b7c:	66 90                	xchg   %ax,%ax
  802b7e:	66 90                	xchg   %ax,%ax

00802b80 <__umoddi3>:
  802b80:	55                   	push   %ebp
  802b81:	57                   	push   %edi
  802b82:	56                   	push   %esi
  802b83:	83 ec 14             	sub    $0x14,%esp
  802b86:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b8a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b8e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802b92:	89 c7                	mov    %eax,%edi
  802b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b98:	8b 44 24 30          	mov    0x30(%esp),%eax
  802b9c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ba0:	89 34 24             	mov    %esi,(%esp)
  802ba3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	89 c2                	mov    %eax,%edx
  802bab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802baf:	75 17                	jne    802bc8 <__umoddi3+0x48>
  802bb1:	39 fe                	cmp    %edi,%esi
  802bb3:	76 4b                	jbe    802c00 <__umoddi3+0x80>
  802bb5:	89 c8                	mov    %ecx,%eax
  802bb7:	89 fa                	mov    %edi,%edx
  802bb9:	f7 f6                	div    %esi
  802bbb:	89 d0                	mov    %edx,%eax
  802bbd:	31 d2                	xor    %edx,%edx
  802bbf:	83 c4 14             	add    $0x14,%esp
  802bc2:	5e                   	pop    %esi
  802bc3:	5f                   	pop    %edi
  802bc4:	5d                   	pop    %ebp
  802bc5:	c3                   	ret    
  802bc6:	66 90                	xchg   %ax,%ax
  802bc8:	39 f8                	cmp    %edi,%eax
  802bca:	77 54                	ja     802c20 <__umoddi3+0xa0>
  802bcc:	0f bd e8             	bsr    %eax,%ebp
  802bcf:	83 f5 1f             	xor    $0x1f,%ebp
  802bd2:	75 5c                	jne    802c30 <__umoddi3+0xb0>
  802bd4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802bd8:	39 3c 24             	cmp    %edi,(%esp)
  802bdb:	0f 87 e7 00 00 00    	ja     802cc8 <__umoddi3+0x148>
  802be1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802be5:	29 f1                	sub    %esi,%ecx
  802be7:	19 c7                	sbb    %eax,%edi
  802be9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bf1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bf5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802bf9:	83 c4 14             	add    $0x14,%esp
  802bfc:	5e                   	pop    %esi
  802bfd:	5f                   	pop    %edi
  802bfe:	5d                   	pop    %ebp
  802bff:	c3                   	ret    
  802c00:	85 f6                	test   %esi,%esi
  802c02:	89 f5                	mov    %esi,%ebp
  802c04:	75 0b                	jne    802c11 <__umoddi3+0x91>
  802c06:	b8 01 00 00 00       	mov    $0x1,%eax
  802c0b:	31 d2                	xor    %edx,%edx
  802c0d:	f7 f6                	div    %esi
  802c0f:	89 c5                	mov    %eax,%ebp
  802c11:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c15:	31 d2                	xor    %edx,%edx
  802c17:	f7 f5                	div    %ebp
  802c19:	89 c8                	mov    %ecx,%eax
  802c1b:	f7 f5                	div    %ebp
  802c1d:	eb 9c                	jmp    802bbb <__umoddi3+0x3b>
  802c1f:	90                   	nop
  802c20:	89 c8                	mov    %ecx,%eax
  802c22:	89 fa                	mov    %edi,%edx
  802c24:	83 c4 14             	add    $0x14,%esp
  802c27:	5e                   	pop    %esi
  802c28:	5f                   	pop    %edi
  802c29:	5d                   	pop    %ebp
  802c2a:	c3                   	ret    
  802c2b:	90                   	nop
  802c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c30:	8b 04 24             	mov    (%esp),%eax
  802c33:	be 20 00 00 00       	mov    $0x20,%esi
  802c38:	89 e9                	mov    %ebp,%ecx
  802c3a:	29 ee                	sub    %ebp,%esi
  802c3c:	d3 e2                	shl    %cl,%edx
  802c3e:	89 f1                	mov    %esi,%ecx
  802c40:	d3 e8                	shr    %cl,%eax
  802c42:	89 e9                	mov    %ebp,%ecx
  802c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c48:	8b 04 24             	mov    (%esp),%eax
  802c4b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c4f:	89 fa                	mov    %edi,%edx
  802c51:	d3 e0                	shl    %cl,%eax
  802c53:	89 f1                	mov    %esi,%ecx
  802c55:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c59:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c5d:	d3 ea                	shr    %cl,%edx
  802c5f:	89 e9                	mov    %ebp,%ecx
  802c61:	d3 e7                	shl    %cl,%edi
  802c63:	89 f1                	mov    %esi,%ecx
  802c65:	d3 e8                	shr    %cl,%eax
  802c67:	89 e9                	mov    %ebp,%ecx
  802c69:	09 f8                	or     %edi,%eax
  802c6b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c6f:	f7 74 24 04          	divl   0x4(%esp)
  802c73:	d3 e7                	shl    %cl,%edi
  802c75:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c79:	89 d7                	mov    %edx,%edi
  802c7b:	f7 64 24 08          	mull   0x8(%esp)
  802c7f:	39 d7                	cmp    %edx,%edi
  802c81:	89 c1                	mov    %eax,%ecx
  802c83:	89 14 24             	mov    %edx,(%esp)
  802c86:	72 2c                	jb     802cb4 <__umoddi3+0x134>
  802c88:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c8c:	72 22                	jb     802cb0 <__umoddi3+0x130>
  802c8e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802c92:	29 c8                	sub    %ecx,%eax
  802c94:	19 d7                	sbb    %edx,%edi
  802c96:	89 e9                	mov    %ebp,%ecx
  802c98:	89 fa                	mov    %edi,%edx
  802c9a:	d3 e8                	shr    %cl,%eax
  802c9c:	89 f1                	mov    %esi,%ecx
  802c9e:	d3 e2                	shl    %cl,%edx
  802ca0:	89 e9                	mov    %ebp,%ecx
  802ca2:	d3 ef                	shr    %cl,%edi
  802ca4:	09 d0                	or     %edx,%eax
  802ca6:	89 fa                	mov    %edi,%edx
  802ca8:	83 c4 14             	add    $0x14,%esp
  802cab:	5e                   	pop    %esi
  802cac:	5f                   	pop    %edi
  802cad:	5d                   	pop    %ebp
  802cae:	c3                   	ret    
  802caf:	90                   	nop
  802cb0:	39 d7                	cmp    %edx,%edi
  802cb2:	75 da                	jne    802c8e <__umoddi3+0x10e>
  802cb4:	8b 14 24             	mov    (%esp),%edx
  802cb7:	89 c1                	mov    %eax,%ecx
  802cb9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802cbd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802cc1:	eb cb                	jmp    802c8e <__umoddi3+0x10e>
  802cc3:	90                   	nop
  802cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cc8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802ccc:	0f 82 0f ff ff ff    	jb     802be1 <__umoddi3+0x61>
  802cd2:	e9 1a ff ff ff       	jmp    802bf1 <__umoddi3+0x71>
