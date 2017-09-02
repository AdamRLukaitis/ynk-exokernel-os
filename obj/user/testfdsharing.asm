
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 e8 01 00 00       	call   800219 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800043:	00 
  800044:	c7 04 24 e0 2b 80 00 	movl   $0x802be0,(%esp)
  80004b:	e8 e3 1b 00 00       	call   801c33 <open>
  800050:	89 c3                	mov    %eax,%ebx
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("open motd: %e", fd);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 e5 2b 80 	movl   $0x802be5,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 f3 2b 80 00 	movl   $0x802bf3,(%esp)
  800071:	e8 0e 02 00 00       	call   800284 <_panic>
	seek(fd, 0);
  800076:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007d:	00 
  80007e:	89 04 24             	mov    %eax,(%esp)
  800081:	e8 3e 18 00 00       	call   8018c4 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800086:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 20 52 80 	movl   $0x805220,0x4(%esp)
  800095:	00 
  800096:	89 1c 24             	mov    %ebx,(%esp)
  800099:	e8 4e 17 00 00       	call   8017ec <readn>
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	7f 20                	jg     8000c4 <umain+0x91>
		panic("readn: %e", n);
  8000a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a8:	c7 44 24 08 08 2c 80 	movl   $0x802c08,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b7:	00 
  8000b8:	c7 04 24 f3 2b 80 00 	movl   $0x802bf3,(%esp)
  8000bf:	e8 c0 01 00 00       	call   800284 <_panic>

	if ((r = fork()) < 0)
  8000c4:	e8 2d 11 00 00       	call   8011f6 <fork>
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	85 c0                	test   %eax,%eax
  8000cd:	79 20                	jns    8000ef <umain+0xbc>
		panic("fork: %e", r);
  8000cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d3:	c7 44 24 08 12 2c 80 	movl   $0x802c12,0x8(%esp)
  8000da:	00 
  8000db:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e2:	00 
  8000e3:	c7 04 24 f3 2b 80 00 	movl   $0x802bf3,(%esp)
  8000ea:	e8 95 01 00 00       	call   800284 <_panic>
	if (r == 0) {
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	0f 85 bd 00 00 00    	jne    8001b4 <umain+0x181>
		seek(fd, 0);
  8000f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fe:	00 
  8000ff:	89 1c 24             	mov    %ebx,(%esp)
  800102:	e8 bd 17 00 00       	call   8018c4 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800107:	c7 04 24 50 2c 80 00 	movl   $0x802c50,(%esp)
  80010e:	e8 6a 02 00 00       	call   80037d <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800113:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011a:	00 
  80011b:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  800122:	00 
  800123:	89 1c 24             	mov    %ebx,(%esp)
  800126:	e8 c1 16 00 00       	call   8017ec <readn>
  80012b:	39 f8                	cmp    %edi,%eax
  80012d:	74 24                	je     800153 <umain+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  80012f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800133:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800137:	c7 44 24 08 94 2c 80 	movl   $0x802c94,0x8(%esp)
  80013e:	00 
  80013f:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800146:	00 
  800147:	c7 04 24 f3 2b 80 00 	movl   $0x802bf3,(%esp)
  80014e:	e8 31 01 00 00       	call   800284 <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800153:	89 44 24 08          	mov    %eax,0x8(%esp)
  800157:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  80015e:	00 
  80015f:	c7 04 24 20 52 80 00 	movl   $0x805220,(%esp)
  800166:	e8 62 0a 00 00       	call   800bcd <memcmp>
  80016b:	85 c0                	test   %eax,%eax
  80016d:	74 1c                	je     80018b <umain+0x158>
			panic("read in parent got different bytes from read in child");
  80016f:	c7 44 24 08 c0 2c 80 	movl   $0x802cc0,0x8(%esp)
  800176:	00 
  800177:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017e:	00 
  80017f:	c7 04 24 f3 2b 80 00 	movl   $0x802bf3,(%esp)
  800186:	e8 f9 00 00 00       	call   800284 <_panic>
		cprintf("read in child succeeded\n");
  80018b:	c7 04 24 1b 2c 80 00 	movl   $0x802c1b,(%esp)
  800192:	e8 e6 01 00 00       	call   80037d <cprintf>
		seek(fd, 0);
  800197:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019e:	00 
  80019f:	89 1c 24             	mov    %ebx,(%esp)
  8001a2:	e8 1d 17 00 00       	call   8018c4 <seek>
		close(fd);
  8001a7:	89 1c 24             	mov    %ebx,(%esp)
  8001aa:	e8 48 14 00 00       	call   8015f7 <close>
		exit();
  8001af:	e8 b7 00 00 00       	call   80026b <exit>
	}
	wait(r);
  8001b4:	89 34 24             	mov    %esi,(%esp)
  8001b7:	e8 9e 23 00 00       	call   80255a <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c3:	00 
  8001c4:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  8001cb:	00 
  8001cc:	89 1c 24             	mov    %ebx,(%esp)
  8001cf:	e8 18 16 00 00       	call   8017ec <readn>
  8001d4:	39 f8                	cmp    %edi,%eax
  8001d6:	74 24                	je     8001fc <umain+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e0:	c7 44 24 08 f8 2c 80 	movl   $0x802cf8,0x8(%esp)
  8001e7:	00 
  8001e8:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001ef:	00 
  8001f0:	c7 04 24 f3 2b 80 00 	movl   $0x802bf3,(%esp)
  8001f7:	e8 88 00 00 00       	call   800284 <_panic>
	cprintf("read in parent succeeded\n");
  8001fc:	c7 04 24 34 2c 80 00 	movl   $0x802c34,(%esp)
  800203:	e8 75 01 00 00       	call   80037d <cprintf>
	close(fd);
  800208:	89 1c 24             	mov    %ebx,(%esp)
  80020b:	e8 e7 13 00 00       	call   8015f7 <close>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800210:	cc                   	int3   

	breakpoint();
}
  800211:	83 c4 2c             	add    $0x2c,%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5f                   	pop    %edi
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    

00800219 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 10             	sub    $0x10,%esp
  800221:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800224:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800227:	c7 05 20 54 80 00 00 	movl   $0x0,0x805420
  80022e:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800231:	e8 4f 0b 00 00       	call   800d85 <sys_getenvid>
  800236:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80023b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80023e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800243:	a3 20 54 80 00       	mov    %eax,0x805420


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800248:	85 db                	test   %ebx,%ebx
  80024a:	7e 07                	jle    800253 <libmain+0x3a>
		binaryname = argv[0];
  80024c:	8b 06                	mov    (%esi),%eax
  80024e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800253:	89 74 24 04          	mov    %esi,0x4(%esp)
  800257:	89 1c 24             	mov    %ebx,(%esp)
  80025a:	e8 d4 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80025f:	e8 07 00 00 00       	call   80026b <exit>
}
  800264:	83 c4 10             	add    $0x10,%esp
  800267:	5b                   	pop    %ebx
  800268:	5e                   	pop    %esi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    

0080026b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800271:	e8 b4 13 00 00       	call   80162a <close_all>
	sys_env_destroy(0);
  800276:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80027d:	e8 b1 0a 00 00       	call   800d33 <sys_env_destroy>
}
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	56                   	push   %esi
  800288:	53                   	push   %ebx
  800289:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80028c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80028f:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800295:	e8 eb 0a 00 00       	call   800d85 <sys_getenvid>
  80029a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80029d:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a8:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b0:	c7 04 24 28 2d 80 00 	movl   $0x802d28,(%esp)
  8002b7:	e8 c1 00 00 00       	call   80037d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002bc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c3:	89 04 24             	mov    %eax,(%esp)
  8002c6:	e8 51 00 00 00       	call   80031c <vcprintf>
	cprintf("\n");
  8002cb:	c7 04 24 32 2c 80 00 	movl   $0x802c32,(%esp)
  8002d2:	e8 a6 00 00 00       	call   80037d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002d7:	cc                   	int3   
  8002d8:	eb fd                	jmp    8002d7 <_panic+0x53>

008002da <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 14             	sub    $0x14,%esp
  8002e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002e4:	8b 13                	mov    (%ebx),%edx
  8002e6:	8d 42 01             	lea    0x1(%edx),%eax
  8002e9:	89 03                	mov    %eax,(%ebx)
  8002eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002ee:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002f2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002f7:	75 19                	jne    800312 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002f9:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800300:	00 
  800301:	8d 43 08             	lea    0x8(%ebx),%eax
  800304:	89 04 24             	mov    %eax,(%esp)
  800307:	e8 ea 09 00 00       	call   800cf6 <sys_cputs>
		b->idx = 0;
  80030c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800312:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800316:	83 c4 14             	add    $0x14,%esp
  800319:	5b                   	pop    %ebx
  80031a:	5d                   	pop    %ebp
  80031b:	c3                   	ret    

0080031c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800325:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032c:	00 00 00 
	b.cnt = 0;
  80032f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800336:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800340:	8b 45 08             	mov    0x8(%ebp),%eax
  800343:	89 44 24 08          	mov    %eax,0x8(%esp)
  800347:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800351:	c7 04 24 da 02 80 00 	movl   $0x8002da,(%esp)
  800358:	e8 b1 01 00 00       	call   80050e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80035d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800363:	89 44 24 04          	mov    %eax,0x4(%esp)
  800367:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80036d:	89 04 24             	mov    %eax,(%esp)
  800370:	e8 81 09 00 00       	call   800cf6 <sys_cputs>

	return b.cnt;
}
  800375:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80037b:	c9                   	leave  
  80037c:	c3                   	ret    

0080037d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800383:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800386:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	89 04 24             	mov    %eax,(%esp)
  800390:	e8 87 ff ff ff       	call   80031c <vcprintf>
	va_end(ap);

	return cnt;
}
  800395:	c9                   	leave  
  800396:	c3                   	ret    
  800397:	66 90                	xchg   %ax,%ax
  800399:	66 90                	xchg   %ax,%ax
  80039b:	66 90                	xchg   %ax,%ax
  80039d:	66 90                	xchg   %ax,%ax
  80039f:	90                   	nop

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 3c             	sub    $0x3c,%esp
  8003a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ac:	89 d7                	mov    %edx,%edi
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	89 c3                	mov    %eax,%ebx
  8003b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003cd:	39 d9                	cmp    %ebx,%ecx
  8003cf:	72 05                	jb     8003d6 <printnum+0x36>
  8003d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003d4:	77 69                	ja     80043f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003dd:	83 ee 01             	sub    $0x1,%esi
  8003e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003f0:	89 c3                	mov    %eax,%ebx
  8003f2:	89 d6                	mov    %edx,%esi
  8003f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80040b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040f:	e8 2c 25 00 00       	call   802940 <__udivdi3>
  800414:	89 d9                	mov    %ebx,%ecx
  800416:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80041a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80041e:	89 04 24             	mov    %eax,(%esp)
  800421:	89 54 24 04          	mov    %edx,0x4(%esp)
  800425:	89 fa                	mov    %edi,%edx
  800427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80042a:	e8 71 ff ff ff       	call   8003a0 <printnum>
  80042f:	eb 1b                	jmp    80044c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800431:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800435:	8b 45 18             	mov    0x18(%ebp),%eax
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	ff d3                	call   *%ebx
  80043d:	eb 03                	jmp    800442 <printnum+0xa2>
  80043f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800442:	83 ee 01             	sub    $0x1,%esi
  800445:	85 f6                	test   %esi,%esi
  800447:	7f e8                	jg     800431 <printnum+0x91>
  800449:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80044c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800450:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800454:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800457:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80045a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80045e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800465:	89 04 24             	mov    %eax,(%esp)
  800468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046f:	e8 fc 25 00 00       	call   802a70 <__umoddi3>
  800474:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800478:	0f be 80 4b 2d 80 00 	movsbl 0x802d4b(%eax),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800485:	ff d0                	call   *%eax
}
  800487:	83 c4 3c             	add    $0x3c,%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 fa 01             	cmp    $0x1,%edx
  800495:	7e 0e                	jle    8004a5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800497:	8b 10                	mov    (%eax),%edx
  800499:	8d 4a 08             	lea    0x8(%edx),%ecx
  80049c:	89 08                	mov    %ecx,(%eax)
  80049e:	8b 02                	mov    (%edx),%eax
  8004a0:	8b 52 04             	mov    0x4(%edx),%edx
  8004a3:	eb 22                	jmp    8004c7 <getuint+0x38>
	else if (lflag)
  8004a5:	85 d2                	test   %edx,%edx
  8004a7:	74 10                	je     8004b9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004a9:	8b 10                	mov    (%eax),%edx
  8004ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ae:	89 08                	mov    %ecx,(%eax)
  8004b0:	8b 02                	mov    (%edx),%eax
  8004b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b7:	eb 0e                	jmp    8004c7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004b9:	8b 10                	mov    (%eax),%edx
  8004bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004be:	89 08                	mov    %ecx,(%eax)
  8004c0:	8b 02                	mov    (%edx),%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c7:	5d                   	pop    %ebp
  8004c8:	c3                   	ret    

008004c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d3:	8b 10                	mov    (%eax),%edx
  8004d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d8:	73 0a                	jae    8004e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004dd:	89 08                	mov    %ecx,(%eax)
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	88 02                	mov    %al,(%edx)
}
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	89 04 24             	mov    %eax,(%esp)
  800507:	e8 02 00 00 00       	call   80050e <vprintfmt>
	va_end(ap);
}
  80050c:	c9                   	leave  
  80050d:	c3                   	ret    

0080050e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	57                   	push   %edi
  800512:	56                   	push   %esi
  800513:	53                   	push   %ebx
  800514:	83 ec 3c             	sub    $0x3c,%esp
  800517:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80051a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80051d:	eb 14                	jmp    800533 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80051f:	85 c0                	test   %eax,%eax
  800521:	0f 84 b3 03 00 00    	je     8008da <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	89 04 24             	mov    %eax,(%esp)
  80052e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800531:	89 f3                	mov    %esi,%ebx
  800533:	8d 73 01             	lea    0x1(%ebx),%esi
  800536:	0f b6 03             	movzbl (%ebx),%eax
  800539:	83 f8 25             	cmp    $0x25,%eax
  80053c:	75 e1                	jne    80051f <vprintfmt+0x11>
  80053e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800542:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800549:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800550:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800557:	ba 00 00 00 00       	mov    $0x0,%edx
  80055c:	eb 1d                	jmp    80057b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800560:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800564:	eb 15                	jmp    80057b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800566:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800568:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80056c:	eb 0d                	jmp    80057b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80056e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800571:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800574:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80057e:	0f b6 0e             	movzbl (%esi),%ecx
  800581:	0f b6 c1             	movzbl %cl,%eax
  800584:	83 e9 23             	sub    $0x23,%ecx
  800587:	80 f9 55             	cmp    $0x55,%cl
  80058a:	0f 87 2a 03 00 00    	ja     8008ba <vprintfmt+0x3ac>
  800590:	0f b6 c9             	movzbl %cl,%ecx
  800593:	ff 24 8d 80 2e 80 00 	jmp    *0x802e80(,%ecx,4)
  80059a:	89 de                	mov    %ebx,%esi
  80059c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005a1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8005a8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005ae:	83 fb 09             	cmp    $0x9,%ebx
  8005b1:	77 36                	ja     8005e9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005b6:	eb e9                	jmp    8005a1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 48 04             	lea    0x4(%eax),%ecx
  8005be:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005c8:	eb 22                	jmp    8005ec <vprintfmt+0xde>
  8005ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005cd:	85 c9                	test   %ecx,%ecx
  8005cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d4:	0f 49 c1             	cmovns %ecx,%eax
  8005d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	89 de                	mov    %ebx,%esi
  8005dc:	eb 9d                	jmp    80057b <vprintfmt+0x6d>
  8005de:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005e0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8005e7:	eb 92                	jmp    80057b <vprintfmt+0x6d>
  8005e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8005ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f0:	79 89                	jns    80057b <vprintfmt+0x6d>
  8005f2:	e9 77 ff ff ff       	jmp    80056e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005f7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005fc:	e9 7a ff ff ff       	jmp    80057b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 50 04             	lea    0x4(%eax),%edx
  800607:	89 55 14             	mov    %edx,0x14(%ebp)
  80060a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	89 04 24             	mov    %eax,(%esp)
  800613:	ff 55 08             	call   *0x8(%ebp)
			break;
  800616:	e9 18 ff ff ff       	jmp    800533 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8d 50 04             	lea    0x4(%eax),%edx
  800621:	89 55 14             	mov    %edx,0x14(%ebp)
  800624:	8b 00                	mov    (%eax),%eax
  800626:	99                   	cltd   
  800627:	31 d0                	xor    %edx,%eax
  800629:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80062b:	83 f8 0f             	cmp    $0xf,%eax
  80062e:	7f 0b                	jg     80063b <vprintfmt+0x12d>
  800630:	8b 14 85 e0 2f 80 00 	mov    0x802fe0(,%eax,4),%edx
  800637:	85 d2                	test   %edx,%edx
  800639:	75 20                	jne    80065b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80063b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80063f:	c7 44 24 08 63 2d 80 	movl   $0x802d63,0x8(%esp)
  800646:	00 
  800647:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	89 04 24             	mov    %eax,(%esp)
  800651:	e8 90 fe ff ff       	call   8004e6 <printfmt>
  800656:	e9 d8 fe ff ff       	jmp    800533 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80065b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80065f:	c7 44 24 08 a5 32 80 	movl   $0x8032a5,0x8(%esp)
  800666:	00 
  800667:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	89 04 24             	mov    %eax,(%esp)
  800671:	e8 70 fe ff ff       	call   8004e6 <printfmt>
  800676:	e9 b8 fe ff ff       	jmp    800533 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80067e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800681:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	89 55 14             	mov    %edx,0x14(%ebp)
  80068d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80068f:	85 f6                	test   %esi,%esi
  800691:	b8 5c 2d 80 00       	mov    $0x802d5c,%eax
  800696:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800699:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80069d:	0f 84 97 00 00 00    	je     80073a <vprintfmt+0x22c>
  8006a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006a7:	0f 8e 9b 00 00 00    	jle    800748 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006b1:	89 34 24             	mov    %esi,(%esp)
  8006b4:	e8 cf 02 00 00       	call   800988 <strnlen>
  8006b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006bc:	29 c2                	sub    %eax,%edx
  8006be:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8006c1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006d1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d3:	eb 0f                	jmp    8006e4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8006d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006dc:	89 04 24             	mov    %eax,(%esp)
  8006df:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e1:	83 eb 01             	sub    $0x1,%ebx
  8006e4:	85 db                	test   %ebx,%ebx
  8006e6:	7f ed                	jg     8006d5 <vprintfmt+0x1c7>
  8006e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006ee:	85 d2                	test   %edx,%edx
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 49 c2             	cmovns %edx,%eax
  8006f8:	29 c2                	sub    %eax,%edx
  8006fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006fd:	89 d7                	mov    %edx,%edi
  8006ff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800702:	eb 50                	jmp    800754 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800704:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800708:	74 1e                	je     800728 <vprintfmt+0x21a>
  80070a:	0f be d2             	movsbl %dl,%edx
  80070d:	83 ea 20             	sub    $0x20,%edx
  800710:	83 fa 5e             	cmp    $0x5e,%edx
  800713:	76 13                	jbe    800728 <vprintfmt+0x21a>
					putch('?', putdat);
  800715:	8b 45 0c             	mov    0xc(%ebp),%eax
  800718:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800723:	ff 55 08             	call   *0x8(%ebp)
  800726:	eb 0d                	jmp    800735 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800735:	83 ef 01             	sub    $0x1,%edi
  800738:	eb 1a                	jmp    800754 <vprintfmt+0x246>
  80073a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80073d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800740:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800743:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800746:	eb 0c                	jmp    800754 <vprintfmt+0x246>
  800748:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80074b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80074e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800751:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800754:	83 c6 01             	add    $0x1,%esi
  800757:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80075b:	0f be c2             	movsbl %dl,%eax
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 27                	je     800789 <vprintfmt+0x27b>
  800762:	85 db                	test   %ebx,%ebx
  800764:	78 9e                	js     800704 <vprintfmt+0x1f6>
  800766:	83 eb 01             	sub    $0x1,%ebx
  800769:	79 99                	jns    800704 <vprintfmt+0x1f6>
  80076b:	89 f8                	mov    %edi,%eax
  80076d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800770:	8b 75 08             	mov    0x8(%ebp),%esi
  800773:	89 c3                	mov    %eax,%ebx
  800775:	eb 1a                	jmp    800791 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800777:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800782:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800784:	83 eb 01             	sub    $0x1,%ebx
  800787:	eb 08                	jmp    800791 <vprintfmt+0x283>
  800789:	89 fb                	mov    %edi,%ebx
  80078b:	8b 75 08             	mov    0x8(%ebp),%esi
  80078e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800791:	85 db                	test   %ebx,%ebx
  800793:	7f e2                	jg     800777 <vprintfmt+0x269>
  800795:	89 75 08             	mov    %esi,0x8(%ebp)
  800798:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80079b:	e9 93 fd ff ff       	jmp    800533 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007a0:	83 fa 01             	cmp    $0x1,%edx
  8007a3:	7e 16                	jle    8007bb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8d 50 08             	lea    0x8(%eax),%edx
  8007ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ae:	8b 50 04             	mov    0x4(%eax),%edx
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007b9:	eb 32                	jmp    8007ed <vprintfmt+0x2df>
	else if (lflag)
  8007bb:	85 d2                	test   %edx,%edx
  8007bd:	74 18                	je     8007d7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 50 04             	lea    0x4(%eax),%edx
  8007c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c8:	8b 30                	mov    (%eax),%esi
  8007ca:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007cd:	89 f0                	mov    %esi,%eax
  8007cf:	c1 f8 1f             	sar    $0x1f,%eax
  8007d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d5:	eb 16                	jmp    8007ed <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 50 04             	lea    0x4(%eax),%edx
  8007dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e0:	8b 30                	mov    (%eax),%esi
  8007e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007e5:	89 f0                	mov    %esi,%eax
  8007e7:	c1 f8 1f             	sar    $0x1f,%eax
  8007ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fc:	0f 89 80 00 00 00    	jns    800882 <vprintfmt+0x374>
				putch('-', putdat);
  800802:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800806:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80080d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800816:	f7 d8                	neg    %eax
  800818:	83 d2 00             	adc    $0x0,%edx
  80081b:	f7 da                	neg    %edx
			}
			base = 10;
  80081d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800822:	eb 5e                	jmp    800882 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
  800827:	e8 63 fc ff ff       	call   80048f <getuint>
			base = 10;
  80082c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800831:	eb 4f                	jmp    800882 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800833:	8d 45 14             	lea    0x14(%ebp),%eax
  800836:	e8 54 fc ff ff       	call   80048f <getuint>
			base =8;
  80083b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800840:	eb 40                	jmp    800882 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800842:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800846:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80084d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800850:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800854:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80085b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8d 50 04             	lea    0x4(%eax),%edx
  800864:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800867:	8b 00                	mov    (%eax),%eax
  800869:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80086e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800873:	eb 0d                	jmp    800882 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800875:	8d 45 14             	lea    0x14(%ebp),%eax
  800878:	e8 12 fc ff ff       	call   80048f <getuint>
			base = 16;
  80087d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800882:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800886:	89 74 24 10          	mov    %esi,0x10(%esp)
  80088a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80088d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800891:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800895:	89 04 24             	mov    %eax,(%esp)
  800898:	89 54 24 04          	mov    %edx,0x4(%esp)
  80089c:	89 fa                	mov    %edi,%edx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	e8 fa fa ff ff       	call   8003a0 <printnum>
			break;
  8008a6:	e9 88 fc ff ff       	jmp    800533 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008af:	89 04 24             	mov    %eax,(%esp)
  8008b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008b5:	e9 79 fc ff ff       	jmp    800533 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008be:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008c5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c8:	89 f3                	mov    %esi,%ebx
  8008ca:	eb 03                	jmp    8008cf <vprintfmt+0x3c1>
  8008cc:	83 eb 01             	sub    $0x1,%ebx
  8008cf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008d3:	75 f7                	jne    8008cc <vprintfmt+0x3be>
  8008d5:	e9 59 fc ff ff       	jmp    800533 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008da:	83 c4 3c             	add    $0x3c,%esp
  8008dd:	5b                   	pop    %ebx
  8008de:	5e                   	pop    %esi
  8008df:	5f                   	pop    %edi
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 28             	sub    $0x28,%esp
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ff:	85 c0                	test   %eax,%eax
  800901:	74 30                	je     800933 <vsnprintf+0x51>
  800903:	85 d2                	test   %edx,%edx
  800905:	7e 2c                	jle    800933 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80090e:	8b 45 10             	mov    0x10(%ebp),%eax
  800911:	89 44 24 08          	mov    %eax,0x8(%esp)
  800915:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800918:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091c:	c7 04 24 c9 04 80 00 	movl   $0x8004c9,(%esp)
  800923:	e8 e6 fb ff ff       	call   80050e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800931:	eb 05                	jmp    800938 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800933:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800938:	c9                   	leave  
  800939:	c3                   	ret    

0080093a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800940:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800943:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800947:	8b 45 10             	mov    0x10(%ebp),%eax
  80094a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	89 44 24 04          	mov    %eax,0x4(%esp)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	89 04 24             	mov    %eax,(%esp)
  80095b:	e8 82 ff ff ff       	call   8008e2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800960:	c9                   	leave  
  800961:	c3                   	ret    
  800962:	66 90                	xchg   %ax,%ax
  800964:	66 90                	xchg   %ax,%ax
  800966:	66 90                	xchg   %ax,%ax
  800968:	66 90                	xchg   %ax,%ax
  80096a:	66 90                	xchg   %ax,%ax
  80096c:	66 90                	xchg   %ax,%ax
  80096e:	66 90                	xchg   %ax,%ax

00800970 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
  80097b:	eb 03                	jmp    800980 <strlen+0x10>
		n++;
  80097d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800980:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800984:	75 f7                	jne    80097d <strlen+0xd>
		n++;
	return n;
}
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800991:	b8 00 00 00 00       	mov    $0x0,%eax
  800996:	eb 03                	jmp    80099b <strnlen+0x13>
		n++;
  800998:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80099b:	39 d0                	cmp    %edx,%eax
  80099d:	74 06                	je     8009a5 <strnlen+0x1d>
  80099f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009a3:	75 f3                	jne    800998 <strnlen+0x10>
		n++;
	return n;
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	53                   	push   %ebx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b1:	89 c2                	mov    %eax,%edx
  8009b3:	83 c2 01             	add    $0x1,%edx
  8009b6:	83 c1 01             	add    $0x1,%ecx
  8009b9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009bd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c0:	84 db                	test   %bl,%bl
  8009c2:	75 ef                	jne    8009b3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009c4:	5b                   	pop    %ebx
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	53                   	push   %ebx
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d1:	89 1c 24             	mov    %ebx,(%esp)
  8009d4:	e8 97 ff ff ff       	call   800970 <strlen>
	strcpy(dst + len, src);
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009e0:	01 d8                	add    %ebx,%eax
  8009e2:	89 04 24             	mov    %eax,(%esp)
  8009e5:	e8 bd ff ff ff       	call   8009a7 <strcpy>
	return dst;
}
  8009ea:	89 d8                	mov    %ebx,%eax
  8009ec:	83 c4 08             	add    $0x8,%esp
  8009ef:	5b                   	pop    %ebx
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fd:	89 f3                	mov    %esi,%ebx
  8009ff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a02:	89 f2                	mov    %esi,%edx
  800a04:	eb 0f                	jmp    800a15 <strncpy+0x23>
		*dst++ = *src;
  800a06:	83 c2 01             	add    $0x1,%edx
  800a09:	0f b6 01             	movzbl (%ecx),%eax
  800a0c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a0f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a12:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a15:	39 da                	cmp    %ebx,%edx
  800a17:	75 ed                	jne    800a06 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a19:	89 f0                	mov    %esi,%eax
  800a1b:	5b                   	pop    %ebx
  800a1c:	5e                   	pop    %esi
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	56                   	push   %esi
  800a23:	53                   	push   %ebx
  800a24:	8b 75 08             	mov    0x8(%ebp),%esi
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a2d:	89 f0                	mov    %esi,%eax
  800a2f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	75 0b                	jne    800a42 <strlcpy+0x23>
  800a37:	eb 1d                	jmp    800a56 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a42:	39 d8                	cmp    %ebx,%eax
  800a44:	74 0b                	je     800a51 <strlcpy+0x32>
  800a46:	0f b6 0a             	movzbl (%edx),%ecx
  800a49:	84 c9                	test   %cl,%cl
  800a4b:	75 ec                	jne    800a39 <strlcpy+0x1a>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	eb 02                	jmp    800a53 <strlcpy+0x34>
  800a51:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a53:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a56:	29 f0                	sub    %esi,%eax
}
  800a58:	5b                   	pop    %ebx
  800a59:	5e                   	pop    %esi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a65:	eb 06                	jmp    800a6d <strcmp+0x11>
		p++, q++;
  800a67:	83 c1 01             	add    $0x1,%ecx
  800a6a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a6d:	0f b6 01             	movzbl (%ecx),%eax
  800a70:	84 c0                	test   %al,%al
  800a72:	74 04                	je     800a78 <strcmp+0x1c>
  800a74:	3a 02                	cmp    (%edx),%al
  800a76:	74 ef                	je     800a67 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a78:	0f b6 c0             	movzbl %al,%eax
  800a7b:	0f b6 12             	movzbl (%edx),%edx
  800a7e:	29 d0                	sub    %edx,%eax
}
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	53                   	push   %ebx
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8c:	89 c3                	mov    %eax,%ebx
  800a8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a91:	eb 06                	jmp    800a99 <strncmp+0x17>
		n--, p++, q++;
  800a93:	83 c0 01             	add    $0x1,%eax
  800a96:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a99:	39 d8                	cmp    %ebx,%eax
  800a9b:	74 15                	je     800ab2 <strncmp+0x30>
  800a9d:	0f b6 08             	movzbl (%eax),%ecx
  800aa0:	84 c9                	test   %cl,%cl
  800aa2:	74 04                	je     800aa8 <strncmp+0x26>
  800aa4:	3a 0a                	cmp    (%edx),%cl
  800aa6:	74 eb                	je     800a93 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa8:	0f b6 00             	movzbl (%eax),%eax
  800aab:	0f b6 12             	movzbl (%edx),%edx
  800aae:	29 d0                	sub    %edx,%eax
  800ab0:	eb 05                	jmp    800ab7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ab7:	5b                   	pop    %ebx
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac4:	eb 07                	jmp    800acd <strchr+0x13>
		if (*s == c)
  800ac6:	38 ca                	cmp    %cl,%dl
  800ac8:	74 0f                	je     800ad9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	0f b6 10             	movzbl (%eax),%edx
  800ad0:	84 d2                	test   %dl,%dl
  800ad2:	75 f2                	jne    800ac6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae5:	eb 07                	jmp    800aee <strfind+0x13>
		if (*s == c)
  800ae7:	38 ca                	cmp    %cl,%dl
  800ae9:	74 0a                	je     800af5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	0f b6 10             	movzbl (%eax),%edx
  800af1:	84 d2                	test   %dl,%dl
  800af3:	75 f2                	jne    800ae7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	57                   	push   %edi
  800afb:	56                   	push   %esi
  800afc:	53                   	push   %ebx
  800afd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b03:	85 c9                	test   %ecx,%ecx
  800b05:	74 36                	je     800b3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0d:	75 28                	jne    800b37 <memset+0x40>
  800b0f:	f6 c1 03             	test   $0x3,%cl
  800b12:	75 23                	jne    800b37 <memset+0x40>
		c &= 0xFF;
  800b14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b18:	89 d3                	mov    %edx,%ebx
  800b1a:	c1 e3 08             	shl    $0x8,%ebx
  800b1d:	89 d6                	mov    %edx,%esi
  800b1f:	c1 e6 18             	shl    $0x18,%esi
  800b22:	89 d0                	mov    %edx,%eax
  800b24:	c1 e0 10             	shl    $0x10,%eax
  800b27:	09 f0                	or     %esi,%eax
  800b29:	09 c2                	or     %eax,%edx
  800b2b:	89 d0                	mov    %edx,%eax
  800b2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b2f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b32:	fc                   	cld    
  800b33:	f3 ab                	rep stos %eax,%es:(%edi)
  800b35:	eb 06                	jmp    800b3d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	fc                   	cld    
  800b3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b3d:	89 f8                	mov    %edi,%eax
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b52:	39 c6                	cmp    %eax,%esi
  800b54:	73 35                	jae    800b8b <memmove+0x47>
  800b56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b59:	39 d0                	cmp    %edx,%eax
  800b5b:	73 2e                	jae    800b8b <memmove+0x47>
		s += n;
		d += n;
  800b5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b60:	89 d6                	mov    %edx,%esi
  800b62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b6a:	75 13                	jne    800b7f <memmove+0x3b>
  800b6c:	f6 c1 03             	test   $0x3,%cl
  800b6f:	75 0e                	jne    800b7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b71:	83 ef 04             	sub    $0x4,%edi
  800b74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b7a:	fd                   	std    
  800b7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7d:	eb 09                	jmp    800b88 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b7f:	83 ef 01             	sub    $0x1,%edi
  800b82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b85:	fd                   	std    
  800b86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b88:	fc                   	cld    
  800b89:	eb 1d                	jmp    800ba8 <memmove+0x64>
  800b8b:	89 f2                	mov    %esi,%edx
  800b8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8f:	f6 c2 03             	test   $0x3,%dl
  800b92:	75 0f                	jne    800ba3 <memmove+0x5f>
  800b94:	f6 c1 03             	test   $0x3,%cl
  800b97:	75 0a                	jne    800ba3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b99:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b9c:	89 c7                	mov    %eax,%edi
  800b9e:	fc                   	cld    
  800b9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba1:	eb 05                	jmp    800ba8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ba3:	89 c7                	mov    %eax,%edi
  800ba5:	fc                   	cld    
  800ba6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 04 24             	mov    %eax,(%esp)
  800bc6:	e8 79 ff ff ff       	call   800b44 <memmove>
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd8:	89 d6                	mov    %edx,%esi
  800bda:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdd:	eb 1a                	jmp    800bf9 <memcmp+0x2c>
		if (*s1 != *s2)
  800bdf:	0f b6 02             	movzbl (%edx),%eax
  800be2:	0f b6 19             	movzbl (%ecx),%ebx
  800be5:	38 d8                	cmp    %bl,%al
  800be7:	74 0a                	je     800bf3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800be9:	0f b6 c0             	movzbl %al,%eax
  800bec:	0f b6 db             	movzbl %bl,%ebx
  800bef:	29 d8                	sub    %ebx,%eax
  800bf1:	eb 0f                	jmp    800c02 <memcmp+0x35>
		s1++, s2++;
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf9:	39 f2                	cmp    %esi,%edx
  800bfb:	75 e2                	jne    800bdf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c0f:	89 c2                	mov    %eax,%edx
  800c11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c14:	eb 07                	jmp    800c1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c16:	38 08                	cmp    %cl,(%eax)
  800c18:	74 07                	je     800c21 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	39 d0                	cmp    %edx,%eax
  800c1f:	72 f5                	jb     800c16 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2f:	eb 03                	jmp    800c34 <strtol+0x11>
		s++;
  800c31:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c34:	0f b6 0a             	movzbl (%edx),%ecx
  800c37:	80 f9 09             	cmp    $0x9,%cl
  800c3a:	74 f5                	je     800c31 <strtol+0xe>
  800c3c:	80 f9 20             	cmp    $0x20,%cl
  800c3f:	74 f0                	je     800c31 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c41:	80 f9 2b             	cmp    $0x2b,%cl
  800c44:	75 0a                	jne    800c50 <strtol+0x2d>
		s++;
  800c46:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c49:	bf 00 00 00 00       	mov    $0x0,%edi
  800c4e:	eb 11                	jmp    800c61 <strtol+0x3e>
  800c50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c55:	80 f9 2d             	cmp    $0x2d,%cl
  800c58:	75 07                	jne    800c61 <strtol+0x3e>
		s++, neg = 1;
  800c5a:	8d 52 01             	lea    0x1(%edx),%edx
  800c5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c66:	75 15                	jne    800c7d <strtol+0x5a>
  800c68:	80 3a 30             	cmpb   $0x30,(%edx)
  800c6b:	75 10                	jne    800c7d <strtol+0x5a>
  800c6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c71:	75 0a                	jne    800c7d <strtol+0x5a>
		s += 2, base = 16;
  800c73:	83 c2 02             	add    $0x2,%edx
  800c76:	b8 10 00 00 00       	mov    $0x10,%eax
  800c7b:	eb 10                	jmp    800c8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c7d:	85 c0                	test   %eax,%eax
  800c7f:	75 0c                	jne    800c8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c81:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c83:	80 3a 30             	cmpb   $0x30,(%edx)
  800c86:	75 05                	jne    800c8d <strtol+0x6a>
		s++, base = 8;
  800c88:	83 c2 01             	add    $0x1,%edx
  800c8b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c95:	0f b6 0a             	movzbl (%edx),%ecx
  800c98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c9b:	89 f0                	mov    %esi,%eax
  800c9d:	3c 09                	cmp    $0x9,%al
  800c9f:	77 08                	ja     800ca9 <strtol+0x86>
			dig = *s - '0';
  800ca1:	0f be c9             	movsbl %cl,%ecx
  800ca4:	83 e9 30             	sub    $0x30,%ecx
  800ca7:	eb 20                	jmp    800cc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ca9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cac:	89 f0                	mov    %esi,%eax
  800cae:	3c 19                	cmp    $0x19,%al
  800cb0:	77 08                	ja     800cba <strtol+0x97>
			dig = *s - 'a' + 10;
  800cb2:	0f be c9             	movsbl %cl,%ecx
  800cb5:	83 e9 57             	sub    $0x57,%ecx
  800cb8:	eb 0f                	jmp    800cc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800cba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cbd:	89 f0                	mov    %esi,%eax
  800cbf:	3c 19                	cmp    $0x19,%al
  800cc1:	77 16                	ja     800cd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800cc3:	0f be c9             	movsbl %cl,%ecx
  800cc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ccc:	7d 0f                	jge    800cdd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800cd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800cd7:	eb bc                	jmp    800c95 <strtol+0x72>
  800cd9:	89 d8                	mov    %ebx,%eax
  800cdb:	eb 02                	jmp    800cdf <strtol+0xbc>
  800cdd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 05                	je     800cea <strtol+0xc7>
		*endptr = (char *) s;
  800ce5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cea:	f7 d8                	neg    %eax
  800cec:	85 ff                	test   %edi,%edi
  800cee:	0f 44 c3             	cmove  %ebx,%eax
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	89 c3                	mov    %eax,%ebx
  800d09:	89 c7                	mov    %eax,%edi
  800d0b:	89 c6                	mov    %eax,%esi
  800d0d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d24:	89 d1                	mov    %edx,%ecx
  800d26:	89 d3                	mov    %edx,%ebx
  800d28:	89 d7                	mov    %edx,%edi
  800d2a:	89 d6                	mov    %edx,%esi
  800d2c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d41:	b8 03 00 00 00       	mov    $0x3,%eax
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	89 cb                	mov    %ecx,%ebx
  800d4b:	89 cf                	mov    %ecx,%edi
  800d4d:	89 ce                	mov    %ecx,%esi
  800d4f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7e 28                	jle    800d7d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d59:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d60:	00 
  800d61:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800d68:	00 
  800d69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d70:	00 
  800d71:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800d78:	e8 07 f5 ff ff       	call   800284 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7d:	83 c4 2c             	add    $0x2c,%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d90:	b8 02 00 00 00       	mov    $0x2,%eax
  800d95:	89 d1                	mov    %edx,%ecx
  800d97:	89 d3                	mov    %edx,%ebx
  800d99:	89 d7                	mov    %edx,%edi
  800d9b:	89 d6                	mov    %edx,%esi
  800d9d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <sys_yield>:

void
sys_yield(void)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db4:	89 d1                	mov    %edx,%ecx
  800db6:	89 d3                	mov    %edx,%ebx
  800db8:	89 d7                	mov    %edx,%edi
  800dba:	89 d6                	mov    %edx,%esi
  800dbc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcc:	be 00 00 00 00       	mov    $0x0,%esi
  800dd1:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddf:	89 f7                	mov    %esi,%edi
  800de1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7e 28                	jle    800e0f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800deb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800df2:	00 
  800df3:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800dfa:	00 
  800dfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e02:	00 
  800e03:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800e0a:	e8 75 f4 ff ff       	call   800284 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e0f:	83 c4 2c             	add    $0x2c,%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e20:	b8 05 00 00 00       	mov    $0x5,%eax
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e31:	8b 75 18             	mov    0x18(%ebp),%esi
  800e34:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	7e 28                	jle    800e62 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e45:	00 
  800e46:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800e4d:	00 
  800e4e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e55:	00 
  800e56:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800e5d:	e8 22 f4 ff ff       	call   800284 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e62:	83 c4 2c             	add    $0x2c,%esp
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
  800e70:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e78:	b8 06 00 00 00       	mov    $0x6,%eax
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	89 df                	mov    %ebx,%edi
  800e85:	89 de                	mov    %ebx,%esi
  800e87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	7e 28                	jle    800eb5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e91:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e98:	00 
  800e99:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800ea0:	00 
  800ea1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea8:	00 
  800ea9:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800eb0:	e8 cf f3 ff ff       	call   800284 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eb5:	83 c4 2c             	add    $0x2c,%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	57                   	push   %edi
  800ec1:	56                   	push   %esi
  800ec2:	53                   	push   %ebx
  800ec3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	89 df                	mov    %ebx,%edi
  800ed8:	89 de                	mov    %ebx,%esi
  800eda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	7e 28                	jle    800f08 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800eeb:	00 
  800eec:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efb:	00 
  800efc:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800f03:	e8 7c f3 ff ff       	call   800284 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f08:	83 c4 2c             	add    $0x2c,%esp
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
  800f16:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	89 df                	mov    %ebx,%edi
  800f2b:	89 de                	mov    %ebx,%esi
  800f2d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	7e 28                	jle    800f5b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f37:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800f46:	00 
  800f47:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4e:	00 
  800f4f:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800f56:	e8 29 f3 ff ff       	call   800284 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f5b:	83 c4 2c             	add    $0x2c,%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	89 df                	mov    %ebx,%edi
  800f7e:	89 de                	mov    %ebx,%esi
  800f80:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f82:	85 c0                	test   %eax,%eax
  800f84:	7e 28                	jle    800fae <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f86:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f91:	00 
  800f92:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800f99:	00 
  800f9a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa1:	00 
  800fa2:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800fa9:	e8 d6 f2 ff ff       	call   800284 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fae:	83 c4 2c             	add    $0x2c,%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbc:	be 00 00 00 00       	mov    $0x0,%esi
  800fc1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fcf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fd4:	5b                   	pop    %ebx
  800fd5:	5e                   	pop    %esi
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	89 cb                	mov    %ecx,%ebx
  800ff1:	89 cf                	mov    %ecx,%edi
  800ff3:	89 ce                	mov    %ecx,%esi
  800ff5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	7e 28                	jle    801023 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801006:	00 
  801007:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  80100e:	00 
  80100f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801016:	00 
  801017:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  80101e:	e8 61 f2 ff ff       	call   800284 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801023:	83 c4 2c             	add    $0x2c,%esp
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5f                   	pop    %edi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801031:	ba 00 00 00 00       	mov    $0x0,%edx
  801036:	b8 0e 00 00 00       	mov    $0xe,%eax
  80103b:	89 d1                	mov    %edx,%ecx
  80103d:	89 d3                	mov    %edx,%ebx
  80103f:	89 d7                	mov    %edx,%edi
  801041:	89 d6                	mov    %edx,%esi
  801043:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
  801050:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801053:	bb 00 00 00 00       	mov    $0x0,%ebx
  801058:	b8 0f 00 00 00       	mov    $0xf,%eax
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	89 df                	mov    %ebx,%edi
  801065:	89 de                	mov    %ebx,%esi
  801067:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801069:	85 c0                	test   %eax,%eax
  80106b:	7e 28                	jle    801095 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801071:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801078:	00 
  801079:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  801080:	00 
  801081:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801088:	00 
  801089:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801090:	e8 ef f1 ff ff       	call   800284 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801095:	83 c4 2c             	add    $0x2c,%esp
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	89 df                	mov    %ebx,%edi
  8010b8:	89 de                	mov    %ebx,%esi
  8010ba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	7e 28                	jle    8010e8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  8010d3:	00 
  8010d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010db:	00 
  8010dc:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  8010e3:	e8 9c f1 ff ff       	call   800284 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8010e8:	83 c4 2c             	add    $0x2c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	53                   	push   %ebx
  8010f4:	83 ec 24             	sub    $0x24,%esp
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  8010fa:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  8010fc:	89 d3                	mov    %edx,%ebx
  8010fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  801104:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801108:	74 1a                	je     801124 <pgfault+0x34>
  80110a:	c1 ea 0c             	shr    $0xc,%edx
  80110d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801114:	a8 01                	test   $0x1,%al
  801116:	74 0c                	je     801124 <pgfault+0x34>
  801118:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80111f:	f6 c4 08             	test   $0x8,%ah
  801122:	75 1c                	jne    801140 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  801124:	c7 44 24 08 6c 30 80 	movl   $0x80306c,0x8(%esp)
  80112b:	00 
  80112c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801133:	00 
  801134:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  80113b:	e8 44 f1 ff ff       	call   800284 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801140:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801147:	00 
  801148:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80114f:	00 
  801150:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801157:	e8 67 fc ff ff       	call   800dc3 <sys_page_alloc>
  80115c:	85 c0                	test   %eax,%eax
  80115e:	79 1c                	jns    80117c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801160:	c7 44 24 08 b0 30 80 	movl   $0x8030b0,0x8(%esp)
  801167:	00 
  801168:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80116f:	00 
  801170:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  801177:	e8 08 f1 ff ff       	call   800284 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  80117c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801183:	00 
  801184:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801188:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80118f:	e8 18 fa ff ff       	call   800bac <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801194:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80119b:	00 
  80119c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011a7:	00 
  8011a8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011af:	00 
  8011b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011b7:	e8 5b fc ff ff       	call   800e17 <sys_page_map>
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 1c                	je     8011dc <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  8011c0:	c7 44 24 08 c6 31 80 	movl   $0x8031c6,0x8(%esp)
  8011c7:	00 
  8011c8:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8011cf:	00 
  8011d0:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  8011d7:	e8 a8 f0 ff ff       	call   800284 <_panic>
    sys_page_unmap(0,PFTEMP);
  8011dc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011e3:	00 
  8011e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011eb:	e8 7a fc ff ff       	call   800e6a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  8011f0:	83 c4 24             	add    $0x24,%esp
  8011f3:	5b                   	pop    %ebx
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    

008011f6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	57                   	push   %edi
  8011fa:	56                   	push   %esi
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  8011ff:	c7 04 24 f0 10 80 00 	movl   $0x8010f0,(%esp)
  801206:	e8 5b 15 00 00       	call   802766 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80120b:	b8 07 00 00 00       	mov    $0x7,%eax
  801210:	cd 30                	int    $0x30
  801212:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801215:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801217:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121c:	85 c0                	test   %eax,%eax
  80121e:	75 21                	jne    801241 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801220:	e8 60 fb ff ff       	call   800d85 <sys_getenvid>
  801225:	25 ff 03 00 00       	and    $0x3ff,%eax
  80122a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80122d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801232:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  801237:	b8 00 00 00 00       	mov    $0x0,%eax
  80123c:	e9 de 01 00 00       	jmp    80141f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801241:	89 d8                	mov    %ebx,%eax
  801243:	c1 e8 16             	shr    $0x16,%eax
  801246:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80124d:	a8 01                	test   $0x1,%al
  80124f:	0f 84 58 01 00 00    	je     8013ad <fork+0x1b7>
  801255:	89 de                	mov    %ebx,%esi
  801257:	c1 ee 0c             	shr    $0xc,%esi
  80125a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801261:	83 e0 05             	and    $0x5,%eax
  801264:	83 f8 05             	cmp    $0x5,%eax
  801267:	0f 85 40 01 00 00    	jne    8013ad <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80126d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801274:	f6 c4 04             	test   $0x4,%ah
  801277:	74 4f                	je     8012c8 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801279:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801280:	c1 e6 0c             	shl    $0xc,%esi
  801283:	25 07 0e 00 00       	and    $0xe07,%eax
  801288:	89 44 24 10          	mov    %eax,0x10(%esp)
  80128c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801290:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801294:	89 74 24 04          	mov    %esi,0x4(%esp)
  801298:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80129f:	e8 73 fb ff ff       	call   800e17 <sys_page_map>
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	0f 89 01 01 00 00    	jns    8013ad <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  8012ac:	c7 44 24 08 d0 30 80 	movl   $0x8030d0,0x8(%esp)
  8012b3:	00 
  8012b4:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8012bb:	00 
  8012bc:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  8012c3:	e8 bc ef ff ff       	call   800284 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  8012c8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012cf:	a8 02                	test   $0x2,%al
  8012d1:	75 10                	jne    8012e3 <fork+0xed>
  8012d3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012da:	f6 c4 08             	test   $0x8,%ah
  8012dd:	0f 84 87 00 00 00    	je     80136a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  8012e3:	c1 e6 0c             	shl    $0xc,%esi
  8012e6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012ed:	00 
  8012ee:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012f2:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801301:	e8 11 fb ff ff       	call   800e17 <sys_page_map>
  801306:	85 c0                	test   %eax,%eax
  801308:	79 1c                	jns    801326 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80130a:	c7 44 24 08 08 31 80 	movl   $0x803108,0x8(%esp)
  801311:	00 
  801312:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801319:	00 
  80131a:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  801321:	e8 5e ef ff ff       	call   800284 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801326:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80132d:	00 
  80132e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801332:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801339:	00 
  80133a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80133e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801345:	e8 cd fa ff ff       	call   800e17 <sys_page_map>
  80134a:	85 c0                	test   %eax,%eax
  80134c:	79 5f                	jns    8013ad <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  80134e:	c7 44 24 08 40 31 80 	movl   $0x803140,0x8(%esp)
  801355:	00 
  801356:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  80135d:	00 
  80135e:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  801365:	e8 1a ef ff ff       	call   800284 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80136a:	c1 e6 0c             	shl    $0xc,%esi
  80136d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801374:	00 
  801375:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801379:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80137d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801381:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801388:	e8 8a fa ff ff       	call   800e17 <sys_page_map>
  80138d:	85 c0                	test   %eax,%eax
  80138f:	74 1c                	je     8013ad <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801391:	c7 44 24 08 68 31 80 	movl   $0x803168,0x8(%esp)
  801398:	00 
  801399:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8013a0:	00 
  8013a1:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  8013a8:	e8 d7 ee ff ff       	call   800284 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  8013ad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013b3:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8013b9:	0f 85 82 fe ff ff    	jne    801241 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  8013bf:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013c6:	00 
  8013c7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013ce:	ee 
  8013cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d2:	89 04 24             	mov    %eax,(%esp)
  8013d5:	e8 e9 f9 ff ff       	call   800dc3 <sys_page_alloc>
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	79 1c                	jns    8013fa <fork+0x204>
      panic("sys_page_alloc failure in fork");
  8013de:	c7 44 24 08 9c 31 80 	movl   $0x80319c,0x8(%esp)
  8013e5:	00 
  8013e6:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  8013ed:	00 
  8013ee:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  8013f5:	e8 8a ee ff ff       	call   800284 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  8013fa:	c7 44 24 04 d7 27 80 	movl   $0x8027d7,0x4(%esp)
  801401:	00 
  801402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801405:	89 3c 24             	mov    %edi,(%esp)
  801408:	e8 56 fb ff ff       	call   800f63 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80140d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801414:	00 
  801415:	89 3c 24             	mov    %edi,(%esp)
  801418:	e8 a0 fa ff ff       	call   800ebd <sys_env_set_status>
		return child;
  80141d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80141f:	83 c4 2c             	add    $0x2c,%esp
  801422:	5b                   	pop    %ebx
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <sfork>:

// Challenge!
int
sfork(void)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80142d:	c7 44 24 08 e4 31 80 	movl   $0x8031e4,0x8(%esp)
  801434:	00 
  801435:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80143c:	00 
  80143d:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  801444:	e8 3b ee ff ff       	call   800284 <_panic>
  801449:	66 90                	xchg   %ax,%ax
  80144b:	66 90                	xchg   %ax,%ax
  80144d:	66 90                	xchg   %ax,%ax
  80144f:	90                   	nop

00801450 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	05 00 00 00 30       	add    $0x30000000,%eax
  80145b:	c1 e8 0c             	shr    $0xc,%eax
}
  80145e:	5d                   	pop    %ebp
  80145f:	c3                   	ret    

00801460 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80146b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801470:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801475:	5d                   	pop    %ebp
  801476:	c3                   	ret    

00801477 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80147d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801482:	89 c2                	mov    %eax,%edx
  801484:	c1 ea 16             	shr    $0x16,%edx
  801487:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80148e:	f6 c2 01             	test   $0x1,%dl
  801491:	74 11                	je     8014a4 <fd_alloc+0x2d>
  801493:	89 c2                	mov    %eax,%edx
  801495:	c1 ea 0c             	shr    $0xc,%edx
  801498:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80149f:	f6 c2 01             	test   $0x1,%dl
  8014a2:	75 09                	jne    8014ad <fd_alloc+0x36>
			*fd_store = fd;
  8014a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ab:	eb 17                	jmp    8014c4 <fd_alloc+0x4d>
  8014ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014b7:	75 c9                	jne    801482 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8014bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014cc:	83 f8 1f             	cmp    $0x1f,%eax
  8014cf:	77 36                	ja     801507 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014d1:	c1 e0 0c             	shl    $0xc,%eax
  8014d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014d9:	89 c2                	mov    %eax,%edx
  8014db:	c1 ea 16             	shr    $0x16,%edx
  8014de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014e5:	f6 c2 01             	test   $0x1,%dl
  8014e8:	74 24                	je     80150e <fd_lookup+0x48>
  8014ea:	89 c2                	mov    %eax,%edx
  8014ec:	c1 ea 0c             	shr    $0xc,%edx
  8014ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014f6:	f6 c2 01             	test   $0x1,%dl
  8014f9:	74 1a                	je     801515 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
  801505:	eb 13                	jmp    80151a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801507:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150c:	eb 0c                	jmp    80151a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80150e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801513:	eb 05                	jmp    80151a <fd_lookup+0x54>
  801515:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80151a:	5d                   	pop    %ebp
  80151b:	c3                   	ret    

0080151c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	83 ec 18             	sub    $0x18,%esp
  801522:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801525:	ba 00 00 00 00       	mov    $0x0,%edx
  80152a:	eb 13                	jmp    80153f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80152c:	39 08                	cmp    %ecx,(%eax)
  80152e:	75 0c                	jne    80153c <dev_lookup+0x20>
			*dev = devtab[i];
  801530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801533:	89 01                	mov    %eax,(%ecx)
			return 0;
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	eb 38                	jmp    801574 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80153c:	83 c2 01             	add    $0x1,%edx
  80153f:	8b 04 95 78 32 80 00 	mov    0x803278(,%edx,4),%eax
  801546:	85 c0                	test   %eax,%eax
  801548:	75 e2                	jne    80152c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80154a:	a1 20 54 80 00       	mov    0x805420,%eax
  80154f:	8b 40 48             	mov    0x48(%eax),%eax
  801552:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155a:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  801561:	e8 17 ee ff ff       	call   80037d <cprintf>
	*dev = 0;
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80156f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801574:	c9                   	leave  
  801575:	c3                   	ret    

00801576 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	56                   	push   %esi
  80157a:	53                   	push   %ebx
  80157b:	83 ec 20             	sub    $0x20,%esp
  80157e:	8b 75 08             	mov    0x8(%ebp),%esi
  801581:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801584:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801587:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80158b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801591:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801594:	89 04 24             	mov    %eax,(%esp)
  801597:	e8 2a ff ff ff       	call   8014c6 <fd_lookup>
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 05                	js     8015a5 <fd_close+0x2f>
	    || fd != fd2)
  8015a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015a3:	74 0c                	je     8015b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015a5:	84 db                	test   %bl,%bl
  8015a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ac:	0f 44 c2             	cmove  %edx,%eax
  8015af:	eb 3f                	jmp    8015f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b8:	8b 06                	mov    (%esi),%eax
  8015ba:	89 04 24             	mov    %eax,(%esp)
  8015bd:	e8 5a ff ff ff       	call   80151c <dev_lookup>
  8015c2:	89 c3                	mov    %eax,%ebx
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	78 16                	js     8015de <fd_close+0x68>
		if (dev->dev_close)
  8015c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015d3:	85 c0                	test   %eax,%eax
  8015d5:	74 07                	je     8015de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8015d7:	89 34 24             	mov    %esi,(%esp)
  8015da:	ff d0                	call   *%eax
  8015dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e9:	e8 7c f8 ff ff       	call   800e6a <sys_page_unmap>
	return r;
  8015ee:	89 d8                	mov    %ebx,%eax
}
  8015f0:	83 c4 20             	add    $0x20,%esp
  8015f3:	5b                   	pop    %ebx
  8015f4:	5e                   	pop    %esi
  8015f5:	5d                   	pop    %ebp
  8015f6:	c3                   	ret    

008015f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801600:	89 44 24 04          	mov    %eax,0x4(%esp)
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	89 04 24             	mov    %eax,(%esp)
  80160a:	e8 b7 fe ff ff       	call   8014c6 <fd_lookup>
  80160f:	89 c2                	mov    %eax,%edx
  801611:	85 d2                	test   %edx,%edx
  801613:	78 13                	js     801628 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801615:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80161c:	00 
  80161d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801620:	89 04 24             	mov    %eax,(%esp)
  801623:	e8 4e ff ff ff       	call   801576 <fd_close>
}
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <close_all>:

void
close_all(void)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	53                   	push   %ebx
  80162e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801631:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801636:	89 1c 24             	mov    %ebx,(%esp)
  801639:	e8 b9 ff ff ff       	call   8015f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80163e:	83 c3 01             	add    $0x1,%ebx
  801641:	83 fb 20             	cmp    $0x20,%ebx
  801644:	75 f0                	jne    801636 <close_all+0xc>
		close(i);
}
  801646:	83 c4 14             	add    $0x14,%esp
  801649:	5b                   	pop    %ebx
  80164a:	5d                   	pop    %ebp
  80164b:	c3                   	ret    

0080164c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	57                   	push   %edi
  801650:	56                   	push   %esi
  801651:	53                   	push   %ebx
  801652:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801655:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801658:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	89 04 24             	mov    %eax,(%esp)
  801662:	e8 5f fe ff ff       	call   8014c6 <fd_lookup>
  801667:	89 c2                	mov    %eax,%edx
  801669:	85 d2                	test   %edx,%edx
  80166b:	0f 88 e1 00 00 00    	js     801752 <dup+0x106>
		return r;
	close(newfdnum);
  801671:	8b 45 0c             	mov    0xc(%ebp),%eax
  801674:	89 04 24             	mov    %eax,(%esp)
  801677:	e8 7b ff ff ff       	call   8015f7 <close>

	newfd = INDEX2FD(newfdnum);
  80167c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80167f:	c1 e3 0c             	shl    $0xc,%ebx
  801682:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80168b:	89 04 24             	mov    %eax,(%esp)
  80168e:	e8 cd fd ff ff       	call   801460 <fd2data>
  801693:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801695:	89 1c 24             	mov    %ebx,(%esp)
  801698:	e8 c3 fd ff ff       	call   801460 <fd2data>
  80169d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80169f:	89 f0                	mov    %esi,%eax
  8016a1:	c1 e8 16             	shr    $0x16,%eax
  8016a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016ab:	a8 01                	test   $0x1,%al
  8016ad:	74 43                	je     8016f2 <dup+0xa6>
  8016af:	89 f0                	mov    %esi,%eax
  8016b1:	c1 e8 0c             	shr    $0xc,%eax
  8016b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016bb:	f6 c2 01             	test   $0x1,%dl
  8016be:	74 32                	je     8016f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8016cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016db:	00 
  8016dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e7:	e8 2b f7 ff ff       	call   800e17 <sys_page_map>
  8016ec:	89 c6                	mov    %eax,%esi
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 3e                	js     801730 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016f5:	89 c2                	mov    %eax,%edx
  8016f7:	c1 ea 0c             	shr    $0xc,%edx
  8016fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801701:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801707:	89 54 24 10          	mov    %edx,0x10(%esp)
  80170b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80170f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801716:	00 
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801722:	e8 f0 f6 ff ff       	call   800e17 <sys_page_map>
  801727:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801729:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80172c:	85 f6                	test   %esi,%esi
  80172e:	79 22                	jns    801752 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801730:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801734:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80173b:	e8 2a f7 ff ff       	call   800e6a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801740:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801744:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174b:	e8 1a f7 ff ff       	call   800e6a <sys_page_unmap>
	return r;
  801750:	89 f0                	mov    %esi,%eax
}
  801752:	83 c4 3c             	add    $0x3c,%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5f                   	pop    %edi
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    

0080175a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	53                   	push   %ebx
  80175e:	83 ec 24             	sub    $0x24,%esp
  801761:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801764:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801767:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176b:	89 1c 24             	mov    %ebx,(%esp)
  80176e:	e8 53 fd ff ff       	call   8014c6 <fd_lookup>
  801773:	89 c2                	mov    %eax,%edx
  801775:	85 d2                	test   %edx,%edx
  801777:	78 6d                	js     8017e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801779:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801783:	8b 00                	mov    (%eax),%eax
  801785:	89 04 24             	mov    %eax,(%esp)
  801788:	e8 8f fd ff ff       	call   80151c <dev_lookup>
  80178d:	85 c0                	test   %eax,%eax
  80178f:	78 55                	js     8017e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801794:	8b 50 08             	mov    0x8(%eax),%edx
  801797:	83 e2 03             	and    $0x3,%edx
  80179a:	83 fa 01             	cmp    $0x1,%edx
  80179d:	75 23                	jne    8017c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80179f:	a1 20 54 80 00       	mov    0x805420,%eax
  8017a4:	8b 40 48             	mov    0x48(%eax),%eax
  8017a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017af:	c7 04 24 3d 32 80 00 	movl   $0x80323d,(%esp)
  8017b6:	e8 c2 eb ff ff       	call   80037d <cprintf>
		return -E_INVAL;
  8017bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c0:	eb 24                	jmp    8017e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8017c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c5:	8b 52 08             	mov    0x8(%edx),%edx
  8017c8:	85 d2                	test   %edx,%edx
  8017ca:	74 15                	je     8017e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017da:	89 04 24             	mov    %eax,(%esp)
  8017dd:	ff d2                	call   *%edx
  8017df:	eb 05                	jmp    8017e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8017e6:	83 c4 24             	add    $0x24,%esp
  8017e9:	5b                   	pop    %ebx
  8017ea:	5d                   	pop    %ebp
  8017eb:	c3                   	ret    

008017ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	57                   	push   %edi
  8017f0:	56                   	push   %esi
  8017f1:	53                   	push   %ebx
  8017f2:	83 ec 1c             	sub    $0x1c,%esp
  8017f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801800:	eb 23                	jmp    801825 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801802:	89 f0                	mov    %esi,%eax
  801804:	29 d8                	sub    %ebx,%eax
  801806:	89 44 24 08          	mov    %eax,0x8(%esp)
  80180a:	89 d8                	mov    %ebx,%eax
  80180c:	03 45 0c             	add    0xc(%ebp),%eax
  80180f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801813:	89 3c 24             	mov    %edi,(%esp)
  801816:	e8 3f ff ff ff       	call   80175a <read>
		if (m < 0)
  80181b:	85 c0                	test   %eax,%eax
  80181d:	78 10                	js     80182f <readn+0x43>
			return m;
		if (m == 0)
  80181f:	85 c0                	test   %eax,%eax
  801821:	74 0a                	je     80182d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801823:	01 c3                	add    %eax,%ebx
  801825:	39 f3                	cmp    %esi,%ebx
  801827:	72 d9                	jb     801802 <readn+0x16>
  801829:	89 d8                	mov    %ebx,%eax
  80182b:	eb 02                	jmp    80182f <readn+0x43>
  80182d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80182f:	83 c4 1c             	add    $0x1c,%esp
  801832:	5b                   	pop    %ebx
  801833:	5e                   	pop    %esi
  801834:	5f                   	pop    %edi
  801835:	5d                   	pop    %ebp
  801836:	c3                   	ret    

00801837 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
  80183a:	53                   	push   %ebx
  80183b:	83 ec 24             	sub    $0x24,%esp
  80183e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801841:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801844:	89 44 24 04          	mov    %eax,0x4(%esp)
  801848:	89 1c 24             	mov    %ebx,(%esp)
  80184b:	e8 76 fc ff ff       	call   8014c6 <fd_lookup>
  801850:	89 c2                	mov    %eax,%edx
  801852:	85 d2                	test   %edx,%edx
  801854:	78 68                	js     8018be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801856:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801859:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801860:	8b 00                	mov    (%eax),%eax
  801862:	89 04 24             	mov    %eax,(%esp)
  801865:	e8 b2 fc ff ff       	call   80151c <dev_lookup>
  80186a:	85 c0                	test   %eax,%eax
  80186c:	78 50                	js     8018be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80186e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801871:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801875:	75 23                	jne    80189a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801877:	a1 20 54 80 00       	mov    0x805420,%eax
  80187c:	8b 40 48             	mov    0x48(%eax),%eax
  80187f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801883:	89 44 24 04          	mov    %eax,0x4(%esp)
  801887:	c7 04 24 59 32 80 00 	movl   $0x803259,(%esp)
  80188e:	e8 ea ea ff ff       	call   80037d <cprintf>
		return -E_INVAL;
  801893:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801898:	eb 24                	jmp    8018be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80189a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189d:	8b 52 0c             	mov    0xc(%edx),%edx
  8018a0:	85 d2                	test   %edx,%edx
  8018a2:	74 15                	je     8018b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018b2:	89 04 24             	mov    %eax,(%esp)
  8018b5:	ff d2                	call   *%edx
  8018b7:	eb 05                	jmp    8018be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018be:	83 c4 24             	add    $0x24,%esp
  8018c1:	5b                   	pop    %ebx
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    

008018c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d4:	89 04 24             	mov    %eax,(%esp)
  8018d7:	e8 ea fb ff ff       	call   8014c6 <fd_lookup>
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 0e                	js     8018ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 24             	sub    $0x24,%esp
  8018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801901:	89 1c 24             	mov    %ebx,(%esp)
  801904:	e8 bd fb ff ff       	call   8014c6 <fd_lookup>
  801909:	89 c2                	mov    %eax,%edx
  80190b:	85 d2                	test   %edx,%edx
  80190d:	78 61                	js     801970 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80190f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801912:	89 44 24 04          	mov    %eax,0x4(%esp)
  801916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801919:	8b 00                	mov    (%eax),%eax
  80191b:	89 04 24             	mov    %eax,(%esp)
  80191e:	e8 f9 fb ff ff       	call   80151c <dev_lookup>
  801923:	85 c0                	test   %eax,%eax
  801925:	78 49                	js     801970 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80192e:	75 23                	jne    801953 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801930:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801935:	8b 40 48             	mov    0x48(%eax),%eax
  801938:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80193c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801940:	c7 04 24 1c 32 80 00 	movl   $0x80321c,(%esp)
  801947:	e8 31 ea ff ff       	call   80037d <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80194c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801951:	eb 1d                	jmp    801970 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801953:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801956:	8b 52 18             	mov    0x18(%edx),%edx
  801959:	85 d2                	test   %edx,%edx
  80195b:	74 0e                	je     80196b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80195d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801960:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801964:	89 04 24             	mov    %eax,(%esp)
  801967:	ff d2                	call   *%edx
  801969:	eb 05                	jmp    801970 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80196b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801970:	83 c4 24             	add    $0x24,%esp
  801973:	5b                   	pop    %ebx
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    

00801976 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	53                   	push   %ebx
  80197a:	83 ec 24             	sub    $0x24,%esp
  80197d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801980:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801983:	89 44 24 04          	mov    %eax,0x4(%esp)
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	89 04 24             	mov    %eax,(%esp)
  80198d:	e8 34 fb ff ff       	call   8014c6 <fd_lookup>
  801992:	89 c2                	mov    %eax,%edx
  801994:	85 d2                	test   %edx,%edx
  801996:	78 52                	js     8019ea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801998:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a2:	8b 00                	mov    (%eax),%eax
  8019a4:	89 04 24             	mov    %eax,(%esp)
  8019a7:	e8 70 fb ff ff       	call   80151c <dev_lookup>
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	78 3a                	js     8019ea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8019b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019b7:	74 2c                	je     8019e5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019b9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019bc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019c3:	00 00 00 
	stat->st_isdir = 0;
  8019c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019cd:	00 00 00 
	stat->st_dev = dev;
  8019d0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019dd:	89 14 24             	mov    %edx,(%esp)
  8019e0:	ff 50 14             	call   *0x14(%eax)
  8019e3:	eb 05                	jmp    8019ea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8019e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8019ea:	83 c4 24             	add    $0x24,%esp
  8019ed:	5b                   	pop    %ebx
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    

008019f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	56                   	push   %esi
  8019f4:	53                   	push   %ebx
  8019f5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019ff:	00 
  801a00:	8b 45 08             	mov    0x8(%ebp),%eax
  801a03:	89 04 24             	mov    %eax,(%esp)
  801a06:	e8 28 02 00 00       	call   801c33 <open>
  801a0b:	89 c3                	mov    %eax,%ebx
  801a0d:	85 db                	test   %ebx,%ebx
  801a0f:	78 1b                	js     801a2c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a18:	89 1c 24             	mov    %ebx,(%esp)
  801a1b:	e8 56 ff ff ff       	call   801976 <fstat>
  801a20:	89 c6                	mov    %eax,%esi
	close(fd);
  801a22:	89 1c 24             	mov    %ebx,(%esp)
  801a25:	e8 cd fb ff ff       	call   8015f7 <close>
	return r;
  801a2a:	89 f0                	mov    %esi,%eax
}
  801a2c:	83 c4 10             	add    $0x10,%esp
  801a2f:	5b                   	pop    %ebx
  801a30:	5e                   	pop    %esi
  801a31:	5d                   	pop    %ebp
  801a32:	c3                   	ret    

00801a33 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	56                   	push   %esi
  801a37:	53                   	push   %ebx
  801a38:	83 ec 10             	sub    $0x10,%esp
  801a3b:	89 c6                	mov    %eax,%esi
  801a3d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a3f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a46:	75 11                	jne    801a59 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a4f:	e8 72 0e 00 00       	call   8028c6 <ipc_find_env>
  801a54:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a59:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a60:	00 
  801a61:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a68:	00 
  801a69:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a6d:	a1 00 50 80 00       	mov    0x805000,%eax
  801a72:	89 04 24             	mov    %eax,(%esp)
  801a75:	e8 ee 0d 00 00       	call   802868 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a81:	00 
  801a82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8d:	e8 6c 0d 00 00       	call   8027fe <ipc_recv>
}
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	5b                   	pop    %ebx
  801a96:	5e                   	pop    %esi
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    

00801a99 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aad:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ab2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab7:	b8 02 00 00 00       	mov    $0x2,%eax
  801abc:	e8 72 ff ff ff       	call   801a33 <fsipc>
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	8b 40 0c             	mov    0xc(%eax),%eax
  801acf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801ad4:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad9:	b8 06 00 00 00       	mov    $0x6,%eax
  801ade:	e8 50 ff ff ff       	call   801a33 <fsipc>
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	53                   	push   %ebx
  801ae9:	83 ec 14             	sub    $0x14,%esp
  801aec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	8b 40 0c             	mov    0xc(%eax),%eax
  801af5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801afa:	ba 00 00 00 00       	mov    $0x0,%edx
  801aff:	b8 05 00 00 00       	mov    $0x5,%eax
  801b04:	e8 2a ff ff ff       	call   801a33 <fsipc>
  801b09:	89 c2                	mov    %eax,%edx
  801b0b:	85 d2                	test   %edx,%edx
  801b0d:	78 2b                	js     801b3a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b16:	00 
  801b17:	89 1c 24             	mov    %ebx,(%esp)
  801b1a:	e8 88 ee ff ff       	call   8009a7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b1f:	a1 80 60 80 00       	mov    0x806080,%eax
  801b24:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b2a:	a1 84 60 80 00       	mov    0x806084,%eax
  801b2f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b3a:	83 c4 14             	add    $0x14,%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    

00801b40 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 18             	sub    $0x18,%esp
  801b46:	8b 45 10             	mov    0x10(%ebp),%eax
  801b49:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b4e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801b53:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801b56:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b5b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b5e:	8b 52 0c             	mov    0xc(%edx),%edx
  801b61:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801b67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b72:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b79:	e8 c6 ef ff ff       	call   800b44 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801b7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b83:	b8 04 00 00 00       	mov    $0x4,%eax
  801b88:	e8 a6 fe ff ff       	call   801a33 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	56                   	push   %esi
  801b93:	53                   	push   %ebx
  801b94:	83 ec 10             	sub    $0x10,%esp
  801b97:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ba5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bab:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb0:	b8 03 00 00 00       	mov    $0x3,%eax
  801bb5:	e8 79 fe ff ff       	call   801a33 <fsipc>
  801bba:	89 c3                	mov    %eax,%ebx
  801bbc:	85 c0                	test   %eax,%eax
  801bbe:	78 6a                	js     801c2a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801bc0:	39 c6                	cmp    %eax,%esi
  801bc2:	73 24                	jae    801be8 <devfile_read+0x59>
  801bc4:	c7 44 24 0c 8c 32 80 	movl   $0x80328c,0xc(%esp)
  801bcb:	00 
  801bcc:	c7 44 24 08 93 32 80 	movl   $0x803293,0x8(%esp)
  801bd3:	00 
  801bd4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801bdb:	00 
  801bdc:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  801be3:	e8 9c e6 ff ff       	call   800284 <_panic>
	assert(r <= PGSIZE);
  801be8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bed:	7e 24                	jle    801c13 <devfile_read+0x84>
  801bef:	c7 44 24 0c b3 32 80 	movl   $0x8032b3,0xc(%esp)
  801bf6:	00 
  801bf7:	c7 44 24 08 93 32 80 	movl   $0x803293,0x8(%esp)
  801bfe:	00 
  801bff:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c06:	00 
  801c07:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  801c0e:	e8 71 e6 ff ff       	call   800284 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c13:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c17:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c1e:	00 
  801c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c22:	89 04 24             	mov    %eax,(%esp)
  801c25:	e8 1a ef ff ff       	call   800b44 <memmove>
	return r;
}
  801c2a:	89 d8                	mov    %ebx,%eax
  801c2c:	83 c4 10             	add    $0x10,%esp
  801c2f:	5b                   	pop    %ebx
  801c30:	5e                   	pop    %esi
  801c31:	5d                   	pop    %ebp
  801c32:	c3                   	ret    

00801c33 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	53                   	push   %ebx
  801c37:	83 ec 24             	sub    $0x24,%esp
  801c3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c3d:	89 1c 24             	mov    %ebx,(%esp)
  801c40:	e8 2b ed ff ff       	call   800970 <strlen>
  801c45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c4a:	7f 60                	jg     801cac <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c4f:	89 04 24             	mov    %eax,(%esp)
  801c52:	e8 20 f8 ff ff       	call   801477 <fd_alloc>
  801c57:	89 c2                	mov    %eax,%edx
  801c59:	85 d2                	test   %edx,%edx
  801c5b:	78 54                	js     801cb1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c5d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c61:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c68:	e8 3a ed ff ff       	call   8009a7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c70:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c78:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7d:	e8 b1 fd ff ff       	call   801a33 <fsipc>
  801c82:	89 c3                	mov    %eax,%ebx
  801c84:	85 c0                	test   %eax,%eax
  801c86:	79 17                	jns    801c9f <open+0x6c>
		fd_close(fd, 0);
  801c88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c8f:	00 
  801c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c93:	89 04 24             	mov    %eax,(%esp)
  801c96:	e8 db f8 ff ff       	call   801576 <fd_close>
		return r;
  801c9b:	89 d8                	mov    %ebx,%eax
  801c9d:	eb 12                	jmp    801cb1 <open+0x7e>
	}

	return fd2num(fd);
  801c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca2:	89 04 24             	mov    %eax,(%esp)
  801ca5:	e8 a6 f7 ff ff       	call   801450 <fd2num>
  801caa:	eb 05                	jmp    801cb1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801cac:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801cb1:	83 c4 24             	add    $0x24,%esp
  801cb4:	5b                   	pop    %ebx
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    

00801cb7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc2:	b8 08 00 00 00       	mov    $0x8,%eax
  801cc7:	e8 67 fd ff ff       	call   801a33 <fsipc>
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    
  801cce:	66 90                	xchg   %ax,%ax

00801cd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801cd6:	c7 44 24 04 bf 32 80 	movl   $0x8032bf,0x4(%esp)
  801cdd:	00 
  801cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce1:	89 04 24             	mov    %eax,(%esp)
  801ce4:	e8 be ec ff ff       	call   8009a7 <strcpy>
	return 0;
}
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	53                   	push   %ebx
  801cf4:	83 ec 14             	sub    $0x14,%esp
  801cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cfa:	89 1c 24             	mov    %ebx,(%esp)
  801cfd:	e8 fc 0b 00 00       	call   8028fe <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d02:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d07:	83 f8 01             	cmp    $0x1,%eax
  801d0a:	75 0d                	jne    801d19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d0c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d0f:	89 04 24             	mov    %eax,(%esp)
  801d12:	e8 29 03 00 00       	call   802040 <nsipc_close>
  801d17:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d19:	89 d0                	mov    %edx,%eax
  801d1b:	83 c4 14             	add    $0x14,%esp
  801d1e:	5b                   	pop    %ebx
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    

00801d21 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d2e:	00 
  801d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	8b 40 0c             	mov    0xc(%eax),%eax
  801d43:	89 04 24             	mov    %eax,(%esp)
  801d46:	e8 f0 03 00 00       	call   80213b <nsipc_send>
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d5a:	00 
  801d5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d69:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d6f:	89 04 24             	mov    %eax,(%esp)
  801d72:	e8 44 03 00 00       	call   8020bb <nsipc_recv>
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d7f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d82:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d86:	89 04 24             	mov    %eax,(%esp)
  801d89:	e8 38 f7 ff ff       	call   8014c6 <fd_lookup>
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	78 17                	js     801da9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d95:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d9b:	39 08                	cmp    %ecx,(%eax)
  801d9d:	75 05                	jne    801da4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801da2:	eb 05                	jmp    801da9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801da4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 20             	sub    $0x20,%esp
  801db3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801db5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801db8:	89 04 24             	mov    %eax,(%esp)
  801dbb:	e8 b7 f6 ff ff       	call   801477 <fd_alloc>
  801dc0:	89 c3                	mov    %eax,%ebx
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	78 21                	js     801de7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dc6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801dcd:	00 
  801dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ddc:	e8 e2 ef ff ff       	call   800dc3 <sys_page_alloc>
  801de1:	89 c3                	mov    %eax,%ebx
  801de3:	85 c0                	test   %eax,%eax
  801de5:	79 0c                	jns    801df3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801de7:	89 34 24             	mov    %esi,(%esp)
  801dea:	e8 51 02 00 00       	call   802040 <nsipc_close>
		return r;
  801def:	89 d8                	mov    %ebx,%eax
  801df1:	eb 20                	jmp    801e13 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801df3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e01:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e08:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e0b:	89 14 24             	mov    %edx,(%esp)
  801e0e:	e8 3d f6 ff ff       	call   801450 <fd2num>
}
  801e13:	83 c4 20             	add    $0x20,%esp
  801e16:	5b                   	pop    %ebx
  801e17:	5e                   	pop    %esi
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    

00801e1a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	e8 51 ff ff ff       	call   801d79 <fd2sockid>
		return r;
  801e28:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e2a:	85 c0                	test   %eax,%eax
  801e2c:	78 23                	js     801e51 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e2e:	8b 55 10             	mov    0x10(%ebp),%edx
  801e31:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e38:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e3c:	89 04 24             	mov    %eax,(%esp)
  801e3f:	e8 45 01 00 00       	call   801f89 <nsipc_accept>
		return r;
  801e44:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e46:	85 c0                	test   %eax,%eax
  801e48:	78 07                	js     801e51 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e4a:	e8 5c ff ff ff       	call   801dab <alloc_sockfd>
  801e4f:	89 c1                	mov    %eax,%ecx
}
  801e51:	89 c8                	mov    %ecx,%eax
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	e8 16 ff ff ff       	call   801d79 <fd2sockid>
  801e63:	89 c2                	mov    %eax,%edx
  801e65:	85 d2                	test   %edx,%edx
  801e67:	78 16                	js     801e7f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801e69:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e77:	89 14 24             	mov    %edx,(%esp)
  801e7a:	e8 60 01 00 00       	call   801fdf <nsipc_bind>
}
  801e7f:	c9                   	leave  
  801e80:	c3                   	ret    

00801e81 <shutdown>:

int
shutdown(int s, int how)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e87:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8a:	e8 ea fe ff ff       	call   801d79 <fd2sockid>
  801e8f:	89 c2                	mov    %eax,%edx
  801e91:	85 d2                	test   %edx,%edx
  801e93:	78 0f                	js     801ea4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9c:	89 14 24             	mov    %edx,(%esp)
  801e9f:	e8 7a 01 00 00       	call   80201e <nsipc_shutdown>
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eac:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaf:	e8 c5 fe ff ff       	call   801d79 <fd2sockid>
  801eb4:	89 c2                	mov    %eax,%edx
  801eb6:	85 d2                	test   %edx,%edx
  801eb8:	78 16                	js     801ed0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801eba:	8b 45 10             	mov    0x10(%ebp),%eax
  801ebd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec8:	89 14 24             	mov    %edx,(%esp)
  801ecb:	e8 8a 01 00 00       	call   80205a <nsipc_connect>
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <listen>:

int
listen(int s, int backlog)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	e8 99 fe ff ff       	call   801d79 <fd2sockid>
  801ee0:	89 c2                	mov    %eax,%edx
  801ee2:	85 d2                	test   %edx,%edx
  801ee4:	78 0f                	js     801ef5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eed:	89 14 24             	mov    %edx,(%esp)
  801ef0:	e8 a4 01 00 00       	call   802099 <nsipc_listen>
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801efd:	8b 45 10             	mov    0x10(%ebp),%eax
  801f00:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	89 04 24             	mov    %eax,(%esp)
  801f11:	e8 98 02 00 00       	call   8021ae <nsipc_socket>
  801f16:	89 c2                	mov    %eax,%edx
  801f18:	85 d2                	test   %edx,%edx
  801f1a:	78 05                	js     801f21 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f1c:	e8 8a fe ff ff       	call   801dab <alloc_sockfd>
}
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	53                   	push   %ebx
  801f27:	83 ec 14             	sub    $0x14,%esp
  801f2a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f2c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f33:	75 11                	jne    801f46 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f3c:	e8 85 09 00 00       	call   8028c6 <ipc_find_env>
  801f41:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f46:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f4d:	00 
  801f4e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801f55:	00 
  801f56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f5a:	a1 04 50 80 00       	mov    0x805004,%eax
  801f5f:	89 04 24             	mov    %eax,(%esp)
  801f62:	e8 01 09 00 00       	call   802868 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f6e:	00 
  801f6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f76:	00 
  801f77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f7e:	e8 7b 08 00 00       	call   8027fe <ipc_recv>
}
  801f83:	83 c4 14             	add    $0x14,%esp
  801f86:	5b                   	pop    %ebx
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    

00801f89 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	56                   	push   %esi
  801f8d:	53                   	push   %ebx
  801f8e:	83 ec 10             	sub    $0x10,%esp
  801f91:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f9c:	8b 06                	mov    (%esi),%eax
  801f9e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fa3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa8:	e8 76 ff ff ff       	call   801f23 <nsipc>
  801fad:	89 c3                	mov    %eax,%ebx
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	78 23                	js     801fd6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fb3:	a1 10 70 80 00       	mov    0x807010,%eax
  801fb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fbc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801fc3:	00 
  801fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc7:	89 04 24             	mov    %eax,(%esp)
  801fca:	e8 75 eb ff ff       	call   800b44 <memmove>
		*addrlen = ret->ret_addrlen;
  801fcf:	a1 10 70 80 00       	mov    0x807010,%eax
  801fd4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801fd6:	89 d8                	mov    %ebx,%eax
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	5b                   	pop    %ebx
  801fdc:	5e                   	pop    %esi
  801fdd:	5d                   	pop    %ebp
  801fde:	c3                   	ret    

00801fdf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
  801fe2:	53                   	push   %ebx
  801fe3:	83 ec 14             	sub    $0x14,%esp
  801fe6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ff1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ffc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802003:	e8 3c eb ff ff       	call   800b44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802008:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80200e:	b8 02 00 00 00       	mov    $0x2,%eax
  802013:	e8 0b ff ff ff       	call   801f23 <nsipc>
}
  802018:	83 c4 14             	add    $0x14,%esp
  80201b:	5b                   	pop    %ebx
  80201c:	5d                   	pop    %ebp
  80201d:	c3                   	ret    

0080201e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80202c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802034:	b8 03 00 00 00       	mov    $0x3,%eax
  802039:	e8 e5 fe ff ff       	call   801f23 <nsipc>
}
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <nsipc_close>:

int
nsipc_close(int s)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80204e:	b8 04 00 00 00       	mov    $0x4,%eax
  802053:	e8 cb fe ff ff       	call   801f23 <nsipc>
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	53                   	push   %ebx
  80205e:	83 ec 14             	sub    $0x14,%esp
  802061:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80206c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802070:	8b 45 0c             	mov    0xc(%ebp),%eax
  802073:	89 44 24 04          	mov    %eax,0x4(%esp)
  802077:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80207e:	e8 c1 ea ff ff       	call   800b44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802083:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802089:	b8 05 00 00 00       	mov    $0x5,%eax
  80208e:	e8 90 fe ff ff       	call   801f23 <nsipc>
}
  802093:	83 c4 14             	add    $0x14,%esp
  802096:	5b                   	pop    %ebx
  802097:	5d                   	pop    %ebp
  802098:	c3                   	ret    

00802099 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020af:	b8 06 00 00 00       	mov    $0x6,%eax
  8020b4:	e8 6a fe ff ff       	call   801f23 <nsipc>
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	56                   	push   %esi
  8020bf:	53                   	push   %ebx
  8020c0:	83 ec 10             	sub    $0x10,%esp
  8020c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020ce:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020d7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8020e1:	e8 3d fe ff ff       	call   801f23 <nsipc>
  8020e6:	89 c3                	mov    %eax,%ebx
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	78 46                	js     802132 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8020ec:	39 f0                	cmp    %esi,%eax
  8020ee:	7f 07                	jg     8020f7 <nsipc_recv+0x3c>
  8020f0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020f5:	7e 24                	jle    80211b <nsipc_recv+0x60>
  8020f7:	c7 44 24 0c cb 32 80 	movl   $0x8032cb,0xc(%esp)
  8020fe:	00 
  8020ff:	c7 44 24 08 93 32 80 	movl   $0x803293,0x8(%esp)
  802106:	00 
  802107:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80210e:	00 
  80210f:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  802116:	e8 69 e1 ff ff       	call   800284 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80211b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80211f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802126:	00 
  802127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212a:	89 04 24             	mov    %eax,(%esp)
  80212d:	e8 12 ea ff ff       	call   800b44 <memmove>
	}

	return r;
}
  802132:	89 d8                	mov    %ebx,%eax
  802134:	83 c4 10             	add    $0x10,%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5d                   	pop    %ebp
  80213a:	c3                   	ret    

0080213b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	53                   	push   %ebx
  80213f:	83 ec 14             	sub    $0x14,%esp
  802142:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80214d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802153:	7e 24                	jle    802179 <nsipc_send+0x3e>
  802155:	c7 44 24 0c ec 32 80 	movl   $0x8032ec,0xc(%esp)
  80215c:	00 
  80215d:	c7 44 24 08 93 32 80 	movl   $0x803293,0x8(%esp)
  802164:	00 
  802165:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80216c:	00 
  80216d:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  802174:	e8 0b e1 ff ff       	call   800284 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802179:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80217d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802180:	89 44 24 04          	mov    %eax,0x4(%esp)
  802184:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80218b:	e8 b4 e9 ff ff       	call   800b44 <memmove>
	nsipcbuf.send.req_size = size;
  802190:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802196:	8b 45 14             	mov    0x14(%ebp),%eax
  802199:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80219e:	b8 08 00 00 00       	mov    $0x8,%eax
  8021a3:	e8 7b fd ff ff       	call   801f23 <nsipc>
}
  8021a8:	83 c4 14             	add    $0x14,%esp
  8021ab:	5b                   	pop    %ebx
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    

008021ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8021d1:	e8 4d fd ff ff       	call   801f23 <nsipc>
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	56                   	push   %esi
  8021dc:	53                   	push   %ebx
  8021dd:	83 ec 10             	sub    $0x10,%esp
  8021e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	89 04 24             	mov    %eax,(%esp)
  8021e9:	e8 72 f2 ff ff       	call   801460 <fd2data>
  8021ee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021f0:	c7 44 24 04 f8 32 80 	movl   $0x8032f8,0x4(%esp)
  8021f7:	00 
  8021f8:	89 1c 24             	mov    %ebx,(%esp)
  8021fb:	e8 a7 e7 ff ff       	call   8009a7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802200:	8b 46 04             	mov    0x4(%esi),%eax
  802203:	2b 06                	sub    (%esi),%eax
  802205:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80220b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802212:	00 00 00 
	stat->st_dev = &devpipe;
  802215:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80221c:	40 80 00 
	return 0;
}
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
  802224:	83 c4 10             	add    $0x10,%esp
  802227:	5b                   	pop    %ebx
  802228:	5e                   	pop    %esi
  802229:	5d                   	pop    %ebp
  80222a:	c3                   	ret    

0080222b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	53                   	push   %ebx
  80222f:	83 ec 14             	sub    $0x14,%esp
  802232:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802235:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802239:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802240:	e8 25 ec ff ff       	call   800e6a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802245:	89 1c 24             	mov    %ebx,(%esp)
  802248:	e8 13 f2 ff ff       	call   801460 <fd2data>
  80224d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802258:	e8 0d ec ff ff       	call   800e6a <sys_page_unmap>
}
  80225d:	83 c4 14             	add    $0x14,%esp
  802260:	5b                   	pop    %ebx
  802261:	5d                   	pop    %ebp
  802262:	c3                   	ret    

00802263 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	57                   	push   %edi
  802267:	56                   	push   %esi
  802268:	53                   	push   %ebx
  802269:	83 ec 2c             	sub    $0x2c,%esp
  80226c:	89 c6                	mov    %eax,%esi
  80226e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802271:	a1 20 54 80 00       	mov    0x805420,%eax
  802276:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802279:	89 34 24             	mov    %esi,(%esp)
  80227c:	e8 7d 06 00 00       	call   8028fe <pageref>
  802281:	89 c7                	mov    %eax,%edi
  802283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802286:	89 04 24             	mov    %eax,(%esp)
  802289:	e8 70 06 00 00       	call   8028fe <pageref>
  80228e:	39 c7                	cmp    %eax,%edi
  802290:	0f 94 c2             	sete   %dl
  802293:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802296:	8b 0d 20 54 80 00    	mov    0x805420,%ecx
  80229c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80229f:	39 fb                	cmp    %edi,%ebx
  8022a1:	74 21                	je     8022c4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8022a3:	84 d2                	test   %dl,%dl
  8022a5:	74 ca                	je     802271 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022a7:	8b 51 58             	mov    0x58(%ecx),%edx
  8022aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022b6:	c7 04 24 ff 32 80 00 	movl   $0x8032ff,(%esp)
  8022bd:	e8 bb e0 ff ff       	call   80037d <cprintf>
  8022c2:	eb ad                	jmp    802271 <_pipeisclosed+0xe>
	}
}
  8022c4:	83 c4 2c             	add    $0x2c,%esp
  8022c7:	5b                   	pop    %ebx
  8022c8:	5e                   	pop    %esi
  8022c9:	5f                   	pop    %edi
  8022ca:	5d                   	pop    %ebp
  8022cb:	c3                   	ret    

008022cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	57                   	push   %edi
  8022d0:	56                   	push   %esi
  8022d1:	53                   	push   %ebx
  8022d2:	83 ec 1c             	sub    $0x1c,%esp
  8022d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022d8:	89 34 24             	mov    %esi,(%esp)
  8022db:	e8 80 f1 ff ff       	call   801460 <fd2data>
  8022e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022e7:	eb 45                	jmp    80232e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022e9:	89 da                	mov    %ebx,%edx
  8022eb:	89 f0                	mov    %esi,%eax
  8022ed:	e8 71 ff ff ff       	call   802263 <_pipeisclosed>
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	75 41                	jne    802337 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022f6:	e8 a9 ea ff ff       	call   800da4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8022fe:	8b 0b                	mov    (%ebx),%ecx
  802300:	8d 51 20             	lea    0x20(%ecx),%edx
  802303:	39 d0                	cmp    %edx,%eax
  802305:	73 e2                	jae    8022e9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802307:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80230a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80230e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802311:	99                   	cltd   
  802312:	c1 ea 1b             	shr    $0x1b,%edx
  802315:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802318:	83 e1 1f             	and    $0x1f,%ecx
  80231b:	29 d1                	sub    %edx,%ecx
  80231d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802321:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802325:	83 c0 01             	add    $0x1,%eax
  802328:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80232b:	83 c7 01             	add    $0x1,%edi
  80232e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802331:	75 c8                	jne    8022fb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802333:	89 f8                	mov    %edi,%eax
  802335:	eb 05                	jmp    80233c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80233c:	83 c4 1c             	add    $0x1c,%esp
  80233f:	5b                   	pop    %ebx
  802340:	5e                   	pop    %esi
  802341:	5f                   	pop    %edi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    

00802344 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	57                   	push   %edi
  802348:	56                   	push   %esi
  802349:	53                   	push   %ebx
  80234a:	83 ec 1c             	sub    $0x1c,%esp
  80234d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802350:	89 3c 24             	mov    %edi,(%esp)
  802353:	e8 08 f1 ff ff       	call   801460 <fd2data>
  802358:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80235a:	be 00 00 00 00       	mov    $0x0,%esi
  80235f:	eb 3d                	jmp    80239e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802361:	85 f6                	test   %esi,%esi
  802363:	74 04                	je     802369 <devpipe_read+0x25>
				return i;
  802365:	89 f0                	mov    %esi,%eax
  802367:	eb 43                	jmp    8023ac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802369:	89 da                	mov    %ebx,%edx
  80236b:	89 f8                	mov    %edi,%eax
  80236d:	e8 f1 fe ff ff       	call   802263 <_pipeisclosed>
  802372:	85 c0                	test   %eax,%eax
  802374:	75 31                	jne    8023a7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802376:	e8 29 ea ff ff       	call   800da4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80237b:	8b 03                	mov    (%ebx),%eax
  80237d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802380:	74 df                	je     802361 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802382:	99                   	cltd   
  802383:	c1 ea 1b             	shr    $0x1b,%edx
  802386:	01 d0                	add    %edx,%eax
  802388:	83 e0 1f             	and    $0x1f,%eax
  80238b:	29 d0                	sub    %edx,%eax
  80238d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802392:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802395:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802398:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80239b:	83 c6 01             	add    $0x1,%esi
  80239e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023a1:	75 d8                	jne    80237b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023a3:	89 f0                	mov    %esi,%eax
  8023a5:	eb 05                	jmp    8023ac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8023ac:	83 c4 1c             	add    $0x1c,%esp
  8023af:	5b                   	pop    %ebx
  8023b0:	5e                   	pop    %esi
  8023b1:	5f                   	pop    %edi
  8023b2:	5d                   	pop    %ebp
  8023b3:	c3                   	ret    

008023b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	56                   	push   %esi
  8023b8:	53                   	push   %ebx
  8023b9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023bf:	89 04 24             	mov    %eax,(%esp)
  8023c2:	e8 b0 f0 ff ff       	call   801477 <fd_alloc>
  8023c7:	89 c2                	mov    %eax,%edx
  8023c9:	85 d2                	test   %edx,%edx
  8023cb:	0f 88 4d 01 00 00    	js     80251e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023d1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023d8:	00 
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e7:	e8 d7 e9 ff ff       	call   800dc3 <sys_page_alloc>
  8023ec:	89 c2                	mov    %eax,%edx
  8023ee:	85 d2                	test   %edx,%edx
  8023f0:	0f 88 28 01 00 00    	js     80251e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023f9:	89 04 24             	mov    %eax,(%esp)
  8023fc:	e8 76 f0 ff ff       	call   801477 <fd_alloc>
  802401:	89 c3                	mov    %eax,%ebx
  802403:	85 c0                	test   %eax,%eax
  802405:	0f 88 fe 00 00 00    	js     802509 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802412:	00 
  802413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802416:	89 44 24 04          	mov    %eax,0x4(%esp)
  80241a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802421:	e8 9d e9 ff ff       	call   800dc3 <sys_page_alloc>
  802426:	89 c3                	mov    %eax,%ebx
  802428:	85 c0                	test   %eax,%eax
  80242a:	0f 88 d9 00 00 00    	js     802509 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	89 04 24             	mov    %eax,(%esp)
  802436:	e8 25 f0 ff ff       	call   801460 <fd2data>
  80243b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802444:	00 
  802445:	89 44 24 04          	mov    %eax,0x4(%esp)
  802449:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802450:	e8 6e e9 ff ff       	call   800dc3 <sys_page_alloc>
  802455:	89 c3                	mov    %eax,%ebx
  802457:	85 c0                	test   %eax,%eax
  802459:	0f 88 97 00 00 00    	js     8024f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802462:	89 04 24             	mov    %eax,(%esp)
  802465:	e8 f6 ef ff ff       	call   801460 <fd2data>
  80246a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802471:	00 
  802472:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802476:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80247d:	00 
  80247e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802482:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802489:	e8 89 e9 ff ff       	call   800e17 <sys_page_map>
  80248e:	89 c3                	mov    %eax,%ebx
  802490:	85 c0                	test   %eax,%eax
  802492:	78 52                	js     8024e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802494:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8024a9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	89 04 24             	mov    %eax,(%esp)
  8024c4:	e8 87 ef ff ff       	call   801450 <fd2num>
  8024c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d1:	89 04 24             	mov    %eax,(%esp)
  8024d4:	e8 77 ef ff ff       	call   801450 <fd2num>
  8024d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024df:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e4:	eb 38                	jmp    80251e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8024e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024f1:	e8 74 e9 ff ff       	call   800e6a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802504:	e8 61 e9 ff ff       	call   800e6a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802510:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802517:	e8 4e e9 ff ff       	call   800e6a <sys_page_unmap>
  80251c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80251e:	83 c4 30             	add    $0x30,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5d                   	pop    %ebp
  802524:	c3                   	ret    

00802525 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
  802528:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80252b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802532:	8b 45 08             	mov    0x8(%ebp),%eax
  802535:	89 04 24             	mov    %eax,(%esp)
  802538:	e8 89 ef ff ff       	call   8014c6 <fd_lookup>
  80253d:	89 c2                	mov    %eax,%edx
  80253f:	85 d2                	test   %edx,%edx
  802541:	78 15                	js     802558 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	89 04 24             	mov    %eax,(%esp)
  802549:	e8 12 ef ff ff       	call   801460 <fd2data>
	return _pipeisclosed(fd, p);
  80254e:	89 c2                	mov    %eax,%edx
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	e8 0b fd ff ff       	call   802263 <_pipeisclosed>
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	56                   	push   %esi
  80255e:	53                   	push   %ebx
  80255f:	83 ec 10             	sub    $0x10,%esp
  802562:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802565:	85 f6                	test   %esi,%esi
  802567:	75 24                	jne    80258d <wait+0x33>
  802569:	c7 44 24 0c 17 33 80 	movl   $0x803317,0xc(%esp)
  802570:	00 
  802571:	c7 44 24 08 93 32 80 	movl   $0x803293,0x8(%esp)
  802578:	00 
  802579:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802580:	00 
  802581:	c7 04 24 22 33 80 00 	movl   $0x803322,(%esp)
  802588:	e8 f7 dc ff ff       	call   800284 <_panic>
	e = &envs[ENVX(envid)];
  80258d:	89 f3                	mov    %esi,%ebx
  80258f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802595:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802598:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80259e:	eb 05                	jmp    8025a5 <wait+0x4b>
		sys_yield();
  8025a0:	e8 ff e7 ff ff       	call   800da4 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8025a5:	8b 43 48             	mov    0x48(%ebx),%eax
  8025a8:	39 f0                	cmp    %esi,%eax
  8025aa:	75 07                	jne    8025b3 <wait+0x59>
  8025ac:	8b 43 54             	mov    0x54(%ebx),%eax
  8025af:	85 c0                	test   %eax,%eax
  8025b1:	75 ed                	jne    8025a0 <wait+0x46>
		sys_yield();
}
  8025b3:	83 c4 10             	add    $0x10,%esp
  8025b6:	5b                   	pop    %ebx
  8025b7:	5e                   	pop    %esi
  8025b8:	5d                   	pop    %ebp
  8025b9:	c3                   	ret    
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8025c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    

008025ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025ca:	55                   	push   %ebp
  8025cb:	89 e5                	mov    %esp,%ebp
  8025cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8025d0:	c7 44 24 04 2d 33 80 	movl   $0x80332d,0x4(%esp)
  8025d7:	00 
  8025d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025db:	89 04 24             	mov    %eax,(%esp)
  8025de:	e8 c4 e3 ff ff       	call   8009a7 <strcpy>
	return 0;
}
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	57                   	push   %edi
  8025ee:	56                   	push   %esi
  8025ef:	53                   	push   %ebx
  8025f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802601:	eb 31                	jmp    802634 <devcons_write+0x4a>
		m = n - tot;
  802603:	8b 75 10             	mov    0x10(%ebp),%esi
  802606:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802608:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80260b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802610:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802613:	89 74 24 08          	mov    %esi,0x8(%esp)
  802617:	03 45 0c             	add    0xc(%ebp),%eax
  80261a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80261e:	89 3c 24             	mov    %edi,(%esp)
  802621:	e8 1e e5 ff ff       	call   800b44 <memmove>
		sys_cputs(buf, m);
  802626:	89 74 24 04          	mov    %esi,0x4(%esp)
  80262a:	89 3c 24             	mov    %edi,(%esp)
  80262d:	e8 c4 e6 ff ff       	call   800cf6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802632:	01 f3                	add    %esi,%ebx
  802634:	89 d8                	mov    %ebx,%eax
  802636:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802639:	72 c8                	jb     802603 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80263b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802641:	5b                   	pop    %ebx
  802642:	5e                   	pop    %esi
  802643:	5f                   	pop    %edi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    

00802646 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80264c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802651:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802655:	75 07                	jne    80265e <devcons_read+0x18>
  802657:	eb 2a                	jmp    802683 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802659:	e8 46 e7 ff ff       	call   800da4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80265e:	66 90                	xchg   %ax,%ax
  802660:	e8 af e6 ff ff       	call   800d14 <sys_cgetc>
  802665:	85 c0                	test   %eax,%eax
  802667:	74 f0                	je     802659 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802669:	85 c0                	test   %eax,%eax
  80266b:	78 16                	js     802683 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80266d:	83 f8 04             	cmp    $0x4,%eax
  802670:	74 0c                	je     80267e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802672:	8b 55 0c             	mov    0xc(%ebp),%edx
  802675:	88 02                	mov    %al,(%edx)
	return 1;
  802677:	b8 01 00 00 00       	mov    $0x1,%eax
  80267c:	eb 05                	jmp    802683 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80267e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
  802688:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80268b:	8b 45 08             	mov    0x8(%ebp),%eax
  80268e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802691:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802698:	00 
  802699:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80269c:	89 04 24             	mov    %eax,(%esp)
  80269f:	e8 52 e6 ff ff       	call   800cf6 <sys_cputs>
}
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <getchar>:

int
getchar(void)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026b3:	00 
  8026b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c2:	e8 93 f0 ff ff       	call   80175a <read>
	if (r < 0)
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	78 0f                	js     8026da <getchar+0x34>
		return r;
	if (r < 1)
  8026cb:	85 c0                	test   %eax,%eax
  8026cd:	7e 06                	jle    8026d5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8026cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8026d3:	eb 05                	jmp    8026da <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8026d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ec:	89 04 24             	mov    %eax,(%esp)
  8026ef:	e8 d2 ed ff ff       	call   8014c6 <fd_lookup>
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	78 11                	js     802709 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802701:	39 10                	cmp    %edx,(%eax)
  802703:	0f 94 c0             	sete   %al
  802706:	0f b6 c0             	movzbl %al,%eax
}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <opencons>:

int
opencons(void)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
  80270e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802711:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802714:	89 04 24             	mov    %eax,(%esp)
  802717:	e8 5b ed ff ff       	call   801477 <fd_alloc>
		return r;
  80271c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80271e:	85 c0                	test   %eax,%eax
  802720:	78 40                	js     802762 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802722:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802729:	00 
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802731:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802738:	e8 86 e6 ff ff       	call   800dc3 <sys_page_alloc>
		return r;
  80273d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80273f:	85 c0                	test   %eax,%eax
  802741:	78 1f                	js     802762 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802743:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802758:	89 04 24             	mov    %eax,(%esp)
  80275b:	e8 f0 ec ff ff       	call   801450 <fd2num>
  802760:	89 c2                	mov    %eax,%edx
}
  802762:	89 d0                	mov    %edx,%eax
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80276c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802773:	75 58                	jne    8027cd <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802775:	a1 20 54 80 00       	mov    0x805420,%eax
  80277a:	8b 40 48             	mov    0x48(%eax),%eax
  80277d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802784:	00 
  802785:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80278c:	ee 
  80278d:	89 04 24             	mov    %eax,(%esp)
  802790:	e8 2e e6 ff ff       	call   800dc3 <sys_page_alloc>
		if(return_code!=0)
  802795:	85 c0                	test   %eax,%eax
  802797:	74 1c                	je     8027b5 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802799:	c7 44 24 08 3c 33 80 	movl   $0x80333c,0x8(%esp)
  8027a0:	00 
  8027a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8027a8:	00 
  8027a9:	c7 04 24 98 33 80 00 	movl   $0x803398,(%esp)
  8027b0:	e8 cf da ff ff       	call   800284 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  8027b5:	a1 20 54 80 00       	mov    0x805420,%eax
  8027ba:	8b 40 48             	mov    0x48(%eax),%eax
  8027bd:	c7 44 24 04 d7 27 80 	movl   $0x8027d7,0x4(%esp)
  8027c4:	00 
  8027c5:	89 04 24             	mov    %eax,(%esp)
  8027c8:	e8 96 e7 ff ff       	call   800f63 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027d5:	c9                   	leave  
  8027d6:	c3                   	ret    

008027d7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027d7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027d8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027dd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027df:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  8027e2:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  8027e4:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  8027e8:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  8027ec:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  8027ed:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  8027ef:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  8027f1:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  8027f5:	58                   	pop    %eax
	popl %eax;
  8027f6:	58                   	pop    %eax
	popal;
  8027f7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  8027f8:	83 c4 04             	add    $0x4,%esp
	popfl;
  8027fb:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8027fc:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  8027fd:	c3                   	ret    

008027fe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	56                   	push   %esi
  802802:	53                   	push   %ebx
  802803:	83 ec 10             	sub    $0x10,%esp
  802806:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802809:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80280f:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802811:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802816:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802819:	89 04 24             	mov    %eax,(%esp)
  80281c:	e8 b8 e7 ff ff       	call   800fd9 <sys_ipc_recv>
  802821:	85 c0                	test   %eax,%eax
  802823:	75 1e                	jne    802843 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802825:	85 db                	test   %ebx,%ebx
  802827:	74 0a                	je     802833 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802829:	a1 20 54 80 00       	mov    0x805420,%eax
  80282e:	8b 40 74             	mov    0x74(%eax),%eax
  802831:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802833:	85 f6                	test   %esi,%esi
  802835:	74 22                	je     802859 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802837:	a1 20 54 80 00       	mov    0x805420,%eax
  80283c:	8b 40 78             	mov    0x78(%eax),%eax
  80283f:	89 06                	mov    %eax,(%esi)
  802841:	eb 16                	jmp    802859 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802843:	85 f6                	test   %esi,%esi
  802845:	74 06                	je     80284d <ipc_recv+0x4f>
				*perm_store = 0;
  802847:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  80284d:	85 db                	test   %ebx,%ebx
  80284f:	74 10                	je     802861 <ipc_recv+0x63>
				*from_env_store=0;
  802851:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802857:	eb 08                	jmp    802861 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802859:	a1 20 54 80 00       	mov    0x805420,%eax
  80285e:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802861:	83 c4 10             	add    $0x10,%esp
  802864:	5b                   	pop    %ebx
  802865:	5e                   	pop    %esi
  802866:	5d                   	pop    %ebp
  802867:	c3                   	ret    

00802868 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802868:	55                   	push   %ebp
  802869:	89 e5                	mov    %esp,%ebp
  80286b:	57                   	push   %edi
  80286c:	56                   	push   %esi
  80286d:	53                   	push   %ebx
  80286e:	83 ec 1c             	sub    $0x1c,%esp
  802871:	8b 75 0c             	mov    0xc(%ebp),%esi
  802874:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802877:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  80287a:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  80287c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802881:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802884:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802888:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80288c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	89 04 24             	mov    %eax,(%esp)
  802896:	e8 1b e7 ff ff       	call   800fb6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  80289b:	eb 1c                	jmp    8028b9 <ipc_send+0x51>
	{
		sys_yield();
  80289d:	e8 02 e5 ff ff       	call   800da4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8028a2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028a6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028aa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	89 04 24             	mov    %eax,(%esp)
  8028b4:	e8 fd e6 ff ff       	call   800fb6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8028b9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028bc:	74 df                	je     80289d <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8028be:	83 c4 1c             	add    $0x1c,%esp
  8028c1:	5b                   	pop    %ebx
  8028c2:	5e                   	pop    %esi
  8028c3:	5f                   	pop    %edi
  8028c4:	5d                   	pop    %ebp
  8028c5:	c3                   	ret    

008028c6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
  8028c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028cc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028d1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8028d4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028da:	8b 52 50             	mov    0x50(%edx),%edx
  8028dd:	39 ca                	cmp    %ecx,%edx
  8028df:	75 0d                	jne    8028ee <ipc_find_env+0x28>
			return envs[i].env_id;
  8028e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8028e4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8028e9:	8b 40 40             	mov    0x40(%eax),%eax
  8028ec:	eb 0e                	jmp    8028fc <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8028ee:	83 c0 01             	add    $0x1,%eax
  8028f1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028f6:	75 d9                	jne    8028d1 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8028f8:	66 b8 00 00          	mov    $0x0,%ax
}
  8028fc:	5d                   	pop    %ebp
  8028fd:	c3                   	ret    

008028fe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028fe:	55                   	push   %ebp
  8028ff:	89 e5                	mov    %esp,%ebp
  802901:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802904:	89 d0                	mov    %edx,%eax
  802906:	c1 e8 16             	shr    $0x16,%eax
  802909:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802910:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802915:	f6 c1 01             	test   $0x1,%cl
  802918:	74 1d                	je     802937 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80291a:	c1 ea 0c             	shr    $0xc,%edx
  80291d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802924:	f6 c2 01             	test   $0x1,%dl
  802927:	74 0e                	je     802937 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802929:	c1 ea 0c             	shr    $0xc,%edx
  80292c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802933:	ef 
  802934:	0f b7 c0             	movzwl %ax,%eax
}
  802937:	5d                   	pop    %ebp
  802938:	c3                   	ret    
  802939:	66 90                	xchg   %ax,%ax
  80293b:	66 90                	xchg   %ax,%ax
  80293d:	66 90                	xchg   %ax,%ax
  80293f:	90                   	nop

00802940 <__udivdi3>:
  802940:	55                   	push   %ebp
  802941:	57                   	push   %edi
  802942:	56                   	push   %esi
  802943:	83 ec 0c             	sub    $0xc,%esp
  802946:	8b 44 24 28          	mov    0x28(%esp),%eax
  80294a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80294e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802952:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802956:	85 c0                	test   %eax,%eax
  802958:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80295c:	89 ea                	mov    %ebp,%edx
  80295e:	89 0c 24             	mov    %ecx,(%esp)
  802961:	75 2d                	jne    802990 <__udivdi3+0x50>
  802963:	39 e9                	cmp    %ebp,%ecx
  802965:	77 61                	ja     8029c8 <__udivdi3+0x88>
  802967:	85 c9                	test   %ecx,%ecx
  802969:	89 ce                	mov    %ecx,%esi
  80296b:	75 0b                	jne    802978 <__udivdi3+0x38>
  80296d:	b8 01 00 00 00       	mov    $0x1,%eax
  802972:	31 d2                	xor    %edx,%edx
  802974:	f7 f1                	div    %ecx
  802976:	89 c6                	mov    %eax,%esi
  802978:	31 d2                	xor    %edx,%edx
  80297a:	89 e8                	mov    %ebp,%eax
  80297c:	f7 f6                	div    %esi
  80297e:	89 c5                	mov    %eax,%ebp
  802980:	89 f8                	mov    %edi,%eax
  802982:	f7 f6                	div    %esi
  802984:	89 ea                	mov    %ebp,%edx
  802986:	83 c4 0c             	add    $0xc,%esp
  802989:	5e                   	pop    %esi
  80298a:	5f                   	pop    %edi
  80298b:	5d                   	pop    %ebp
  80298c:	c3                   	ret    
  80298d:	8d 76 00             	lea    0x0(%esi),%esi
  802990:	39 e8                	cmp    %ebp,%eax
  802992:	77 24                	ja     8029b8 <__udivdi3+0x78>
  802994:	0f bd e8             	bsr    %eax,%ebp
  802997:	83 f5 1f             	xor    $0x1f,%ebp
  80299a:	75 3c                	jne    8029d8 <__udivdi3+0x98>
  80299c:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029a0:	39 34 24             	cmp    %esi,(%esp)
  8029a3:	0f 86 9f 00 00 00    	jbe    802a48 <__udivdi3+0x108>
  8029a9:	39 d0                	cmp    %edx,%eax
  8029ab:	0f 82 97 00 00 00    	jb     802a48 <__udivdi3+0x108>
  8029b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	31 d2                	xor    %edx,%edx
  8029ba:	31 c0                	xor    %eax,%eax
  8029bc:	83 c4 0c             	add    $0xc,%esp
  8029bf:	5e                   	pop    %esi
  8029c0:	5f                   	pop    %edi
  8029c1:	5d                   	pop    %ebp
  8029c2:	c3                   	ret    
  8029c3:	90                   	nop
  8029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	89 f8                	mov    %edi,%eax
  8029ca:	f7 f1                	div    %ecx
  8029cc:	31 d2                	xor    %edx,%edx
  8029ce:	83 c4 0c             	add    $0xc,%esp
  8029d1:	5e                   	pop    %esi
  8029d2:	5f                   	pop    %edi
  8029d3:	5d                   	pop    %ebp
  8029d4:	c3                   	ret    
  8029d5:	8d 76 00             	lea    0x0(%esi),%esi
  8029d8:	89 e9                	mov    %ebp,%ecx
  8029da:	8b 3c 24             	mov    (%esp),%edi
  8029dd:	d3 e0                	shl    %cl,%eax
  8029df:	89 c6                	mov    %eax,%esi
  8029e1:	b8 20 00 00 00       	mov    $0x20,%eax
  8029e6:	29 e8                	sub    %ebp,%eax
  8029e8:	89 c1                	mov    %eax,%ecx
  8029ea:	d3 ef                	shr    %cl,%edi
  8029ec:	89 e9                	mov    %ebp,%ecx
  8029ee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029f2:	8b 3c 24             	mov    (%esp),%edi
  8029f5:	09 74 24 08          	or     %esi,0x8(%esp)
  8029f9:	89 d6                	mov    %edx,%esi
  8029fb:	d3 e7                	shl    %cl,%edi
  8029fd:	89 c1                	mov    %eax,%ecx
  8029ff:	89 3c 24             	mov    %edi,(%esp)
  802a02:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a06:	d3 ee                	shr    %cl,%esi
  802a08:	89 e9                	mov    %ebp,%ecx
  802a0a:	d3 e2                	shl    %cl,%edx
  802a0c:	89 c1                	mov    %eax,%ecx
  802a0e:	d3 ef                	shr    %cl,%edi
  802a10:	09 d7                	or     %edx,%edi
  802a12:	89 f2                	mov    %esi,%edx
  802a14:	89 f8                	mov    %edi,%eax
  802a16:	f7 74 24 08          	divl   0x8(%esp)
  802a1a:	89 d6                	mov    %edx,%esi
  802a1c:	89 c7                	mov    %eax,%edi
  802a1e:	f7 24 24             	mull   (%esp)
  802a21:	39 d6                	cmp    %edx,%esi
  802a23:	89 14 24             	mov    %edx,(%esp)
  802a26:	72 30                	jb     802a58 <__udivdi3+0x118>
  802a28:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a2c:	89 e9                	mov    %ebp,%ecx
  802a2e:	d3 e2                	shl    %cl,%edx
  802a30:	39 c2                	cmp    %eax,%edx
  802a32:	73 05                	jae    802a39 <__udivdi3+0xf9>
  802a34:	3b 34 24             	cmp    (%esp),%esi
  802a37:	74 1f                	je     802a58 <__udivdi3+0x118>
  802a39:	89 f8                	mov    %edi,%eax
  802a3b:	31 d2                	xor    %edx,%edx
  802a3d:	e9 7a ff ff ff       	jmp    8029bc <__udivdi3+0x7c>
  802a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a48:	31 d2                	xor    %edx,%edx
  802a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a4f:	e9 68 ff ff ff       	jmp    8029bc <__udivdi3+0x7c>
  802a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a58:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a5b:	31 d2                	xor    %edx,%edx
  802a5d:	83 c4 0c             	add    $0xc,%esp
  802a60:	5e                   	pop    %esi
  802a61:	5f                   	pop    %edi
  802a62:	5d                   	pop    %ebp
  802a63:	c3                   	ret    
  802a64:	66 90                	xchg   %ax,%ax
  802a66:	66 90                	xchg   %ax,%ax
  802a68:	66 90                	xchg   %ax,%ax
  802a6a:	66 90                	xchg   %ax,%ax
  802a6c:	66 90                	xchg   %ax,%ax
  802a6e:	66 90                	xchg   %ax,%ax

00802a70 <__umoddi3>:
  802a70:	55                   	push   %ebp
  802a71:	57                   	push   %edi
  802a72:	56                   	push   %esi
  802a73:	83 ec 14             	sub    $0x14,%esp
  802a76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a7a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a7e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a82:	89 c7                	mov    %eax,%edi
  802a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a88:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a8c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a90:	89 34 24             	mov    %esi,(%esp)
  802a93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a97:	85 c0                	test   %eax,%eax
  802a99:	89 c2                	mov    %eax,%edx
  802a9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a9f:	75 17                	jne    802ab8 <__umoddi3+0x48>
  802aa1:	39 fe                	cmp    %edi,%esi
  802aa3:	76 4b                	jbe    802af0 <__umoddi3+0x80>
  802aa5:	89 c8                	mov    %ecx,%eax
  802aa7:	89 fa                	mov    %edi,%edx
  802aa9:	f7 f6                	div    %esi
  802aab:	89 d0                	mov    %edx,%eax
  802aad:	31 d2                	xor    %edx,%edx
  802aaf:	83 c4 14             	add    $0x14,%esp
  802ab2:	5e                   	pop    %esi
  802ab3:	5f                   	pop    %edi
  802ab4:	5d                   	pop    %ebp
  802ab5:	c3                   	ret    
  802ab6:	66 90                	xchg   %ax,%ax
  802ab8:	39 f8                	cmp    %edi,%eax
  802aba:	77 54                	ja     802b10 <__umoddi3+0xa0>
  802abc:	0f bd e8             	bsr    %eax,%ebp
  802abf:	83 f5 1f             	xor    $0x1f,%ebp
  802ac2:	75 5c                	jne    802b20 <__umoddi3+0xb0>
  802ac4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ac8:	39 3c 24             	cmp    %edi,(%esp)
  802acb:	0f 87 e7 00 00 00    	ja     802bb8 <__umoddi3+0x148>
  802ad1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ad5:	29 f1                	sub    %esi,%ecx
  802ad7:	19 c7                	sbb    %eax,%edi
  802ad9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802add:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ae1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ae5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ae9:	83 c4 14             	add    $0x14,%esp
  802aec:	5e                   	pop    %esi
  802aed:	5f                   	pop    %edi
  802aee:	5d                   	pop    %ebp
  802aef:	c3                   	ret    
  802af0:	85 f6                	test   %esi,%esi
  802af2:	89 f5                	mov    %esi,%ebp
  802af4:	75 0b                	jne    802b01 <__umoddi3+0x91>
  802af6:	b8 01 00 00 00       	mov    $0x1,%eax
  802afb:	31 d2                	xor    %edx,%edx
  802afd:	f7 f6                	div    %esi
  802aff:	89 c5                	mov    %eax,%ebp
  802b01:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b05:	31 d2                	xor    %edx,%edx
  802b07:	f7 f5                	div    %ebp
  802b09:	89 c8                	mov    %ecx,%eax
  802b0b:	f7 f5                	div    %ebp
  802b0d:	eb 9c                	jmp    802aab <__umoddi3+0x3b>
  802b0f:	90                   	nop
  802b10:	89 c8                	mov    %ecx,%eax
  802b12:	89 fa                	mov    %edi,%edx
  802b14:	83 c4 14             	add    $0x14,%esp
  802b17:	5e                   	pop    %esi
  802b18:	5f                   	pop    %edi
  802b19:	5d                   	pop    %ebp
  802b1a:	c3                   	ret    
  802b1b:	90                   	nop
  802b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b20:	8b 04 24             	mov    (%esp),%eax
  802b23:	be 20 00 00 00       	mov    $0x20,%esi
  802b28:	89 e9                	mov    %ebp,%ecx
  802b2a:	29 ee                	sub    %ebp,%esi
  802b2c:	d3 e2                	shl    %cl,%edx
  802b2e:	89 f1                	mov    %esi,%ecx
  802b30:	d3 e8                	shr    %cl,%eax
  802b32:	89 e9                	mov    %ebp,%ecx
  802b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b38:	8b 04 24             	mov    (%esp),%eax
  802b3b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b3f:	89 fa                	mov    %edi,%edx
  802b41:	d3 e0                	shl    %cl,%eax
  802b43:	89 f1                	mov    %esi,%ecx
  802b45:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b49:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b4d:	d3 ea                	shr    %cl,%edx
  802b4f:	89 e9                	mov    %ebp,%ecx
  802b51:	d3 e7                	shl    %cl,%edi
  802b53:	89 f1                	mov    %esi,%ecx
  802b55:	d3 e8                	shr    %cl,%eax
  802b57:	89 e9                	mov    %ebp,%ecx
  802b59:	09 f8                	or     %edi,%eax
  802b5b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b5f:	f7 74 24 04          	divl   0x4(%esp)
  802b63:	d3 e7                	shl    %cl,%edi
  802b65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b69:	89 d7                	mov    %edx,%edi
  802b6b:	f7 64 24 08          	mull   0x8(%esp)
  802b6f:	39 d7                	cmp    %edx,%edi
  802b71:	89 c1                	mov    %eax,%ecx
  802b73:	89 14 24             	mov    %edx,(%esp)
  802b76:	72 2c                	jb     802ba4 <__umoddi3+0x134>
  802b78:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b7c:	72 22                	jb     802ba0 <__umoddi3+0x130>
  802b7e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b82:	29 c8                	sub    %ecx,%eax
  802b84:	19 d7                	sbb    %edx,%edi
  802b86:	89 e9                	mov    %ebp,%ecx
  802b88:	89 fa                	mov    %edi,%edx
  802b8a:	d3 e8                	shr    %cl,%eax
  802b8c:	89 f1                	mov    %esi,%ecx
  802b8e:	d3 e2                	shl    %cl,%edx
  802b90:	89 e9                	mov    %ebp,%ecx
  802b92:	d3 ef                	shr    %cl,%edi
  802b94:	09 d0                	or     %edx,%eax
  802b96:	89 fa                	mov    %edi,%edx
  802b98:	83 c4 14             	add    $0x14,%esp
  802b9b:	5e                   	pop    %esi
  802b9c:	5f                   	pop    %edi
  802b9d:	5d                   	pop    %ebp
  802b9e:	c3                   	ret    
  802b9f:	90                   	nop
  802ba0:	39 d7                	cmp    %edx,%edi
  802ba2:	75 da                	jne    802b7e <__umoddi3+0x10e>
  802ba4:	8b 14 24             	mov    (%esp),%edx
  802ba7:	89 c1                	mov    %eax,%ecx
  802ba9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802bad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802bb1:	eb cb                	jmp    802b7e <__umoddi3+0x10e>
  802bb3:	90                   	nop
  802bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bb8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802bbc:	0f 82 0f ff ff ff    	jb     802ad1 <__umoddi3+0x61>
  802bc2:	e9 1a ff ff ff       	jmp    802ae1 <__umoddi3+0x71>
