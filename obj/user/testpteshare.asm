
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 86 01 00 00       	call   8001b7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  800039:	a1 00 40 80 00       	mov    0x804000,%eax
  80003e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800042:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800049:	e8 f9 08 00 00       	call   800947 <strcpy>
	exit();
  80004e:	e8 b6 01 00 00       	call   800209 <exit>
}
  800053:	c9                   	leave  
  800054:	c3                   	ret    

00800055 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	53                   	push   %ebx
  800059:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800060:	74 05                	je     800067 <umain+0x12>
		childofspawn();
  800062:	e8 cc ff ff ff       	call   800033 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800067:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  800076:	a0 
  800077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007e:	e8 e0 0c 00 00       	call   800d63 <sys_page_alloc>
  800083:	85 c0                	test   %eax,%eax
  800085:	79 20                	jns    8000a7 <umain+0x52>
		panic("sys_page_alloc: %e", r);
  800087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008b:	c7 44 24 08 ac 31 80 	movl   $0x8031ac,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009a:	00 
  80009b:	c7 04 24 bf 31 80 00 	movl   $0x8031bf,(%esp)
  8000a2:	e8 7b 01 00 00       	call   800222 <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a7:	e8 ea 10 00 00       	call   801196 <fork>
  8000ac:	89 c3                	mov    %eax,%ebx
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	79 20                	jns    8000d2 <umain+0x7d>
		panic("fork: %e", r);
  8000b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b6:	c7 44 24 08 d3 31 80 	movl   $0x8031d3,0x8(%esp)
  8000bd:	00 
  8000be:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c5:	00 
  8000c6:	c7 04 24 bf 31 80 00 	movl   $0x8031bf,(%esp)
  8000cd:	e8 50 01 00 00       	call   800222 <_panic>
	if (r == 0) {
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	75 1a                	jne    8000f0 <umain+0x9b>
		strcpy(VA, msg);
  8000d6:	a1 04 40 80 00       	mov    0x804004,%eax
  8000db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000df:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e6:	e8 5c 08 00 00       	call   800947 <strcpy>
		exit();
  8000eb:	e8 19 01 00 00       	call   800209 <exit>
	}
	wait(r);
  8000f0:	89 1c 24             	mov    %ebx,(%esp)
  8000f3:	e8 22 2a 00 00       	call   802b1a <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800108:	e8 ef 08 00 00       	call   8009fc <strcmp>
  80010d:	85 c0                	test   %eax,%eax
  80010f:	b8 a0 31 80 00       	mov    $0x8031a0,%eax
  800114:	ba a6 31 80 00       	mov    $0x8031a6,%edx
  800119:	0f 45 c2             	cmovne %edx,%eax
  80011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800120:	c7 04 24 dc 31 80 00 	movl   $0x8031dc,(%esp)
  800127:	e8 ef 01 00 00       	call   80031b <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 f7 31 80 	movl   $0x8031f7,0x8(%esp)
  80013b:	00 
  80013c:	c7 44 24 04 fc 31 80 	movl   $0x8031fc,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 fb 31 80 00 	movl   $0x8031fb,(%esp)
  80014b:	e8 c8 20 00 00       	call   802218 <spawnl>
  800150:	85 c0                	test   %eax,%eax
  800152:	79 20                	jns    800174 <umain+0x11f>
		panic("spawn: %e", r);
  800154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800158:	c7 44 24 08 09 32 80 	movl   $0x803209,0x8(%esp)
  80015f:	00 
  800160:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800167:	00 
  800168:	c7 04 24 bf 31 80 00 	movl   $0x8031bf,(%esp)
  80016f:	e8 ae 00 00 00       	call   800222 <_panic>
	wait(r);
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 9e 29 00 00       	call   802b1a <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017c:	a1 00 40 80 00       	mov    0x804000,%eax
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018c:	e8 6b 08 00 00       	call   8009fc <strcmp>
  800191:	85 c0                	test   %eax,%eax
  800193:	b8 a0 31 80 00       	mov    $0x8031a0,%eax
  800198:	ba a6 31 80 00       	mov    $0x8031a6,%edx
  80019d:	0f 45 c2             	cmovne %edx,%eax
  8001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a4:	c7 04 24 13 32 80 00 	movl   $0x803213,(%esp)
  8001ab:	e8 6b 01 00 00       	call   80031b <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001b0:	cc                   	int3   

	breakpoint();
}
  8001b1:	83 c4 14             	add    $0x14,%esp
  8001b4:	5b                   	pop    %ebx
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	56                   	push   %esi
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 10             	sub    $0x10,%esp
  8001bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001c2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001c5:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001cc:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8001cf:	e8 51 0b 00 00       	call   800d25 <sys_getenvid>
  8001d4:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8001d9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001dc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e1:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e6:	85 db                	test   %ebx,%ebx
  8001e8:	7e 07                	jle    8001f1 <libmain+0x3a>
		binaryname = argv[0];
  8001ea:	8b 06                	mov    (%esi),%eax
  8001ec:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001f5:	89 1c 24             	mov    %ebx,(%esp)
  8001f8:	e8 58 fe ff ff       	call   800055 <umain>

	// exit gracefully
	exit();
  8001fd:	e8 07 00 00 00       	call   800209 <exit>
}
  800202:	83 c4 10             	add    $0x10,%esp
  800205:	5b                   	pop    %ebx
  800206:	5e                   	pop    %esi
  800207:	5d                   	pop    %ebp
  800208:	c3                   	ret    

00800209 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80020f:	e8 b6 13 00 00       	call   8015ca <close_all>
	sys_env_destroy(0);
  800214:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80021b:	e8 b3 0a 00 00       	call   800cd3 <sys_env_destroy>
}
  800220:	c9                   	leave  
  800221:	c3                   	ret    

00800222 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	56                   	push   %esi
  800226:	53                   	push   %ebx
  800227:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80022a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80022d:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800233:	e8 ed 0a 00 00       	call   800d25 <sys_getenvid>
  800238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023b:	89 54 24 10          	mov    %edx,0x10(%esp)
  80023f:	8b 55 08             	mov    0x8(%ebp),%edx
  800242:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800246:	89 74 24 08          	mov    %esi,0x8(%esp)
  80024a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024e:	c7 04 24 58 32 80 00 	movl   $0x803258,(%esp)
  800255:	e8 c1 00 00 00       	call   80031b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80025e:	8b 45 10             	mov    0x10(%ebp),%eax
  800261:	89 04 24             	mov    %eax,(%esp)
  800264:	e8 51 00 00 00       	call   8002ba <vcprintf>
	cprintf("\n");
  800269:	c7 04 24 eb 38 80 00 	movl   $0x8038eb,(%esp)
  800270:	e8 a6 00 00 00       	call   80031b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800275:	cc                   	int3   
  800276:	eb fd                	jmp    800275 <_panic+0x53>

00800278 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	53                   	push   %ebx
  80027c:	83 ec 14             	sub    $0x14,%esp
  80027f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800282:	8b 13                	mov    (%ebx),%edx
  800284:	8d 42 01             	lea    0x1(%edx),%eax
  800287:	89 03                	mov    %eax,(%ebx)
  800289:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80028c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800290:	3d ff 00 00 00       	cmp    $0xff,%eax
  800295:	75 19                	jne    8002b0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800297:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80029e:	00 
  80029f:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a2:	89 04 24             	mov    %eax,(%esp)
  8002a5:	e8 ec 09 00 00       	call   800c96 <sys_cputs>
		b->idx = 0;
  8002aa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002b0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b4:	83 c4 14             	add    $0x14,%esp
  8002b7:	5b                   	pop    %ebx
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    

008002ba <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ca:	00 00 00 
	b.cnt = 0;
  8002cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	c7 04 24 78 02 80 00 	movl   $0x800278,(%esp)
  8002f6:	e8 b3 01 00 00       	call   8004ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002fb:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800301:	89 44 24 04          	mov    %eax,0x4(%esp)
  800305:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80030b:	89 04 24             	mov    %eax,(%esp)
  80030e:	e8 83 09 00 00       	call   800c96 <sys_cputs>

	return b.cnt;
}
  800313:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800321:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800324:	89 44 24 04          	mov    %eax,0x4(%esp)
  800328:	8b 45 08             	mov    0x8(%ebp),%eax
  80032b:	89 04 24             	mov    %eax,(%esp)
  80032e:	e8 87 ff ff ff       	call   8002ba <vcprintf>
	va_end(ap);

	return cnt;
}
  800333:	c9                   	leave  
  800334:	c3                   	ret    
  800335:	66 90                	xchg   %ax,%ax
  800337:	66 90                	xchg   %ax,%ax
  800339:	66 90                	xchg   %ax,%ax
  80033b:	66 90                	xchg   %ax,%ax
  80033d:	66 90                	xchg   %ax,%ax
  80033f:	90                   	nop

00800340 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	57                   	push   %edi
  800344:	56                   	push   %esi
  800345:	53                   	push   %ebx
  800346:	83 ec 3c             	sub    $0x3c,%esp
  800349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034c:	89 d7                	mov    %edx,%edi
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800354:	8b 45 0c             	mov    0xc(%ebp),%eax
  800357:	89 c3                	mov    %eax,%ebx
  800359:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	b9 00 00 00 00       	mov    $0x0,%ecx
  800367:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80036d:	39 d9                	cmp    %ebx,%ecx
  80036f:	72 05                	jb     800376 <printnum+0x36>
  800371:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800374:	77 69                	ja     8003df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800376:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800379:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80037d:	83 ee 01             	sub    $0x1,%esi
  800380:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800384:	89 44 24 08          	mov    %eax,0x8(%esp)
  800388:	8b 44 24 08          	mov    0x8(%esp),%eax
  80038c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800390:	89 c3                	mov    %eax,%ebx
  800392:	89 d6                	mov    %edx,%esi
  800394:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800397:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80039a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80039e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003af:	e8 4c 2b 00 00       	call   802f00 <__udivdi3>
  8003b4:	89 d9                	mov    %ebx,%ecx
  8003b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003be:	89 04 24             	mov    %eax,(%esp)
  8003c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003c5:	89 fa                	mov    %edi,%edx
  8003c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ca:	e8 71 ff ff ff       	call   800340 <printnum>
  8003cf:	eb 1b                	jmp    8003ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	89 04 24             	mov    %eax,(%esp)
  8003db:	ff d3                	call   *%ebx
  8003dd:	eb 03                	jmp    8003e2 <printnum+0xa2>
  8003df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e2:	83 ee 01             	sub    $0x1,%esi
  8003e5:	85 f6                	test   %esi,%esi
  8003e7:	7f e8                	jg     8003d1 <printnum+0x91>
  8003e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80040b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040f:	e8 1c 2c 00 00       	call   803030 <__umoddi3>
  800414:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800418:	0f be 80 7b 32 80 00 	movsbl 0x80327b(%eax),%eax
  80041f:	89 04 24             	mov    %eax,(%esp)
  800422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800425:	ff d0                	call   *%eax
}
  800427:	83 c4 3c             	add    $0x3c,%esp
  80042a:	5b                   	pop    %ebx
  80042b:	5e                   	pop    %esi
  80042c:	5f                   	pop    %edi
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    

0080042f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800432:	83 fa 01             	cmp    $0x1,%edx
  800435:	7e 0e                	jle    800445 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800437:	8b 10                	mov    (%eax),%edx
  800439:	8d 4a 08             	lea    0x8(%edx),%ecx
  80043c:	89 08                	mov    %ecx,(%eax)
  80043e:	8b 02                	mov    (%edx),%eax
  800440:	8b 52 04             	mov    0x4(%edx),%edx
  800443:	eb 22                	jmp    800467 <getuint+0x38>
	else if (lflag)
  800445:	85 d2                	test   %edx,%edx
  800447:	74 10                	je     800459 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800449:	8b 10                	mov    (%eax),%edx
  80044b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80044e:	89 08                	mov    %ecx,(%eax)
  800450:	8b 02                	mov    (%edx),%eax
  800452:	ba 00 00 00 00       	mov    $0x0,%edx
  800457:	eb 0e                	jmp    800467 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800459:	8b 10                	mov    (%eax),%edx
  80045b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80045e:	89 08                	mov    %ecx,(%eax)
  800460:	8b 02                	mov    (%edx),%eax
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80046f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800473:	8b 10                	mov    (%eax),%edx
  800475:	3b 50 04             	cmp    0x4(%eax),%edx
  800478:	73 0a                	jae    800484 <sprintputch+0x1b>
		*b->buf++ = ch;
  80047a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80047d:	89 08                	mov    %ecx,(%eax)
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	88 02                	mov    %al,(%edx)
}
  800484:	5d                   	pop    %ebp
  800485:	c3                   	ret    

00800486 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80048c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80048f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800493:	8b 45 10             	mov    0x10(%ebp),%eax
  800496:	89 44 24 08          	mov    %eax,0x8(%esp)
  80049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 04 24             	mov    %eax,(%esp)
  8004a7:	e8 02 00 00 00       	call   8004ae <vprintfmt>
	va_end(ap);
}
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	57                   	push   %edi
  8004b2:	56                   	push   %esi
  8004b3:	53                   	push   %ebx
  8004b4:	83 ec 3c             	sub    $0x3c,%esp
  8004b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004bd:	eb 14                	jmp    8004d3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	0f 84 b3 03 00 00    	je     80087a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004cb:	89 04 24             	mov    %eax,(%esp)
  8004ce:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d1:	89 f3                	mov    %esi,%ebx
  8004d3:	8d 73 01             	lea    0x1(%ebx),%esi
  8004d6:	0f b6 03             	movzbl (%ebx),%eax
  8004d9:	83 f8 25             	cmp    $0x25,%eax
  8004dc:	75 e1                	jne    8004bf <vprintfmt+0x11>
  8004de:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004e9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004f0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8004f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fc:	eb 1d                	jmp    80051b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800500:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800504:	eb 15                	jmp    80051b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800506:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800508:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80050c:	eb 0d                	jmp    80051b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80050e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800511:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800514:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80051e:	0f b6 0e             	movzbl (%esi),%ecx
  800521:	0f b6 c1             	movzbl %cl,%eax
  800524:	83 e9 23             	sub    $0x23,%ecx
  800527:	80 f9 55             	cmp    $0x55,%cl
  80052a:	0f 87 2a 03 00 00    	ja     80085a <vprintfmt+0x3ac>
  800530:	0f b6 c9             	movzbl %cl,%ecx
  800533:	ff 24 8d c0 33 80 00 	jmp    *0x8033c0(,%ecx,4)
  80053a:	89 de                	mov    %ebx,%esi
  80053c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800541:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800544:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800548:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80054b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80054e:	83 fb 09             	cmp    $0x9,%ebx
  800551:	77 36                	ja     800589 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800553:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800556:	eb e9                	jmp    800541 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8d 48 04             	lea    0x4(%eax),%ecx
  80055e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800566:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800568:	eb 22                	jmp    80058c <vprintfmt+0xde>
  80056a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80056d:	85 c9                	test   %ecx,%ecx
  80056f:	b8 00 00 00 00       	mov    $0x0,%eax
  800574:	0f 49 c1             	cmovns %ecx,%eax
  800577:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	89 de                	mov    %ebx,%esi
  80057c:	eb 9d                	jmp    80051b <vprintfmt+0x6d>
  80057e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800580:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800587:	eb 92                	jmp    80051b <vprintfmt+0x6d>
  800589:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80058c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800590:	79 89                	jns    80051b <vprintfmt+0x6d>
  800592:	e9 77 ff ff ff       	jmp    80050e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800597:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80059c:	e9 7a ff ff ff       	jmp    80051b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8d 50 04             	lea    0x4(%eax),%edx
  8005a7:	89 55 14             	mov    %edx,0x14(%ebp)
  8005aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	89 04 24             	mov    %eax,(%esp)
  8005b3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005b6:	e9 18 ff ff ff       	jmp    8004d3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8d 50 04             	lea    0x4(%eax),%edx
  8005c1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	99                   	cltd   
  8005c7:	31 d0                	xor    %edx,%eax
  8005c9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005cb:	83 f8 0f             	cmp    $0xf,%eax
  8005ce:	7f 0b                	jg     8005db <vprintfmt+0x12d>
  8005d0:	8b 14 85 20 35 80 00 	mov    0x803520(,%eax,4),%edx
  8005d7:	85 d2                	test   %edx,%edx
  8005d9:	75 20                	jne    8005fb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8005db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005df:	c7 44 24 08 93 32 80 	movl   $0x803293,0x8(%esp)
  8005e6:	00 
  8005e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	89 04 24             	mov    %eax,(%esp)
  8005f1:	e8 90 fe ff ff       	call   800486 <printfmt>
  8005f6:	e9 d8 fe ff ff       	jmp    8004d3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ff:	c7 44 24 08 e5 37 80 	movl   $0x8037e5,0x8(%esp)
  800606:	00 
  800607:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	89 04 24             	mov    %eax,(%esp)
  800611:	e8 70 fe ff ff       	call   800486 <printfmt>
  800616:	e9 b8 fe ff ff       	jmp    8004d3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80061e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800621:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8d 50 04             	lea    0x4(%eax),%edx
  80062a:	89 55 14             	mov    %edx,0x14(%ebp)
  80062d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80062f:	85 f6                	test   %esi,%esi
  800631:	b8 8c 32 80 00       	mov    $0x80328c,%eax
  800636:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800639:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80063d:	0f 84 97 00 00 00    	je     8006da <vprintfmt+0x22c>
  800643:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800647:	0f 8e 9b 00 00 00    	jle    8006e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800651:	89 34 24             	mov    %esi,(%esp)
  800654:	e8 cf 02 00 00       	call   800928 <strnlen>
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	29 c2                	sub    %eax,%edx
  80065e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800661:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800665:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800668:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80066b:	8b 75 08             	mov    0x8(%ebp),%esi
  80066e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800671:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800673:	eb 0f                	jmp    800684 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800675:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800679:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80067c:	89 04 24             	mov    %eax,(%esp)
  80067f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	83 eb 01             	sub    $0x1,%ebx
  800684:	85 db                	test   %ebx,%ebx
  800686:	7f ed                	jg     800675 <vprintfmt+0x1c7>
  800688:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80068b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80068e:	85 d2                	test   %edx,%edx
  800690:	b8 00 00 00 00       	mov    $0x0,%eax
  800695:	0f 49 c2             	cmovns %edx,%eax
  800698:	29 c2                	sub    %eax,%edx
  80069a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80069d:	89 d7                	mov    %edx,%edi
  80069f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006a2:	eb 50                	jmp    8006f4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a8:	74 1e                	je     8006c8 <vprintfmt+0x21a>
  8006aa:	0f be d2             	movsbl %dl,%edx
  8006ad:	83 ea 20             	sub    $0x20,%edx
  8006b0:	83 fa 5e             	cmp    $0x5e,%edx
  8006b3:	76 13                	jbe    8006c8 <vprintfmt+0x21a>
					putch('?', putdat);
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006c3:	ff 55 08             	call   *0x8(%ebp)
  8006c6:	eb 0d                	jmp    8006d5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d5:	83 ef 01             	sub    $0x1,%edi
  8006d8:	eb 1a                	jmp    8006f4 <vprintfmt+0x246>
  8006da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006dd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006e0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006e3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006e6:	eb 0c                	jmp    8006f4 <vprintfmt+0x246>
  8006e8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006f4:	83 c6 01             	add    $0x1,%esi
  8006f7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006fb:	0f be c2             	movsbl %dl,%eax
  8006fe:	85 c0                	test   %eax,%eax
  800700:	74 27                	je     800729 <vprintfmt+0x27b>
  800702:	85 db                	test   %ebx,%ebx
  800704:	78 9e                	js     8006a4 <vprintfmt+0x1f6>
  800706:	83 eb 01             	sub    $0x1,%ebx
  800709:	79 99                	jns    8006a4 <vprintfmt+0x1f6>
  80070b:	89 f8                	mov    %edi,%eax
  80070d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800710:	8b 75 08             	mov    0x8(%ebp),%esi
  800713:	89 c3                	mov    %eax,%ebx
  800715:	eb 1a                	jmp    800731 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800717:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800722:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800724:	83 eb 01             	sub    $0x1,%ebx
  800727:	eb 08                	jmp    800731 <vprintfmt+0x283>
  800729:	89 fb                	mov    %edi,%ebx
  80072b:	8b 75 08             	mov    0x8(%ebp),%esi
  80072e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800731:	85 db                	test   %ebx,%ebx
  800733:	7f e2                	jg     800717 <vprintfmt+0x269>
  800735:	89 75 08             	mov    %esi,0x8(%ebp)
  800738:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80073b:	e9 93 fd ff ff       	jmp    8004d3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800740:	83 fa 01             	cmp    $0x1,%edx
  800743:	7e 16                	jle    80075b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 50 08             	lea    0x8(%eax),%edx
  80074b:	89 55 14             	mov    %edx,0x14(%ebp)
  80074e:	8b 50 04             	mov    0x4(%eax),%edx
  800751:	8b 00                	mov    (%eax),%eax
  800753:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800756:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800759:	eb 32                	jmp    80078d <vprintfmt+0x2df>
	else if (lflag)
  80075b:	85 d2                	test   %edx,%edx
  80075d:	74 18                	je     800777 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	89 55 14             	mov    %edx,0x14(%ebp)
  800768:	8b 30                	mov    (%eax),%esi
  80076a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80076d:	89 f0                	mov    %esi,%eax
  80076f:	c1 f8 1f             	sar    $0x1f,%eax
  800772:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800775:	eb 16                	jmp    80078d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8d 50 04             	lea    0x4(%eax),%edx
  80077d:	89 55 14             	mov    %edx,0x14(%ebp)
  800780:	8b 30                	mov    (%eax),%esi
  800782:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800785:	89 f0                	mov    %esi,%eax
  800787:	c1 f8 1f             	sar    $0x1f,%eax
  80078a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800793:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800798:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80079c:	0f 89 80 00 00 00    	jns    800822 <vprintfmt+0x374>
				putch('-', putdat);
  8007a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007ad:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b6:	f7 d8                	neg    %eax
  8007b8:	83 d2 00             	adc    $0x0,%edx
  8007bb:	f7 da                	neg    %edx
			}
			base = 10;
  8007bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007c2:	eb 5e                	jmp    800822 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c7:	e8 63 fc ff ff       	call   80042f <getuint>
			base = 10;
  8007cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007d1:	eb 4f                	jmp    800822 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  8007d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d6:	e8 54 fc ff ff       	call   80042f <getuint>
			base =8;
  8007db:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007e0:	eb 40                	jmp    800822 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  8007e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8d 50 04             	lea    0x4(%eax),%edx
  800804:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800807:	8b 00                	mov    (%eax),%eax
  800809:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80080e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800813:	eb 0d                	jmp    800822 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800815:	8d 45 14             	lea    0x14(%ebp),%eax
  800818:	e8 12 fc ff ff       	call   80042f <getuint>
			base = 16;
  80081d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800822:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800826:	89 74 24 10          	mov    %esi,0x10(%esp)
  80082a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80082d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800831:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800835:	89 04 24             	mov    %eax,(%esp)
  800838:	89 54 24 04          	mov    %edx,0x4(%esp)
  80083c:	89 fa                	mov    %edi,%edx
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	e8 fa fa ff ff       	call   800340 <printnum>
			break;
  800846:	e9 88 fc ff ff       	jmp    8004d3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80084b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084f:	89 04 24             	mov    %eax,(%esp)
  800852:	ff 55 08             	call   *0x8(%ebp)
			break;
  800855:	e9 79 fc ff ff       	jmp    8004d3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80085a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80085e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800865:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800868:	89 f3                	mov    %esi,%ebx
  80086a:	eb 03                	jmp    80086f <vprintfmt+0x3c1>
  80086c:	83 eb 01             	sub    $0x1,%ebx
  80086f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800873:	75 f7                	jne    80086c <vprintfmt+0x3be>
  800875:	e9 59 fc ff ff       	jmp    8004d3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80087a:	83 c4 3c             	add    $0x3c,%esp
  80087d:	5b                   	pop    %ebx
  80087e:	5e                   	pop    %esi
  80087f:	5f                   	pop    %edi
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	83 ec 28             	sub    $0x28,%esp
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800891:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800895:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800898:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089f:	85 c0                	test   %eax,%eax
  8008a1:	74 30                	je     8008d3 <vsnprintf+0x51>
  8008a3:	85 d2                	test   %edx,%edx
  8008a5:	7e 2c                	jle    8008d3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008bc:	c7 04 24 69 04 80 00 	movl   $0x800469,(%esp)
  8008c3:	e8 e6 fb ff ff       	call   8004ae <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d1:	eb 05                	jmp    8008d8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008d8:	c9                   	leave  
  8008d9:	c3                   	ret    

008008da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	89 04 24             	mov    %eax,(%esp)
  8008fb:	e8 82 ff ff ff       	call   800882 <vsnprintf>
	va_end(ap);

	return rc;
}
  800900:	c9                   	leave  
  800901:	c3                   	ret    
  800902:	66 90                	xchg   %ax,%ax
  800904:	66 90                	xchg   %ax,%ax
  800906:	66 90                	xchg   %ax,%ax
  800908:	66 90                	xchg   %ax,%ax
  80090a:	66 90                	xchg   %ax,%ax
  80090c:	66 90                	xchg   %ax,%ax
  80090e:	66 90                	xchg   %ax,%ax

00800910 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	eb 03                	jmp    800920 <strlen+0x10>
		n++;
  80091d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800920:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800924:	75 f7                	jne    80091d <strlen+0xd>
		n++;
	return n;
}
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800931:	b8 00 00 00 00       	mov    $0x0,%eax
  800936:	eb 03                	jmp    80093b <strnlen+0x13>
		n++;
  800938:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093b:	39 d0                	cmp    %edx,%eax
  80093d:	74 06                	je     800945 <strnlen+0x1d>
  80093f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800943:	75 f3                	jne    800938 <strnlen+0x10>
		n++;
	return n;
}
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	53                   	push   %ebx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800951:	89 c2                	mov    %eax,%edx
  800953:	83 c2 01             	add    $0x1,%edx
  800956:	83 c1 01             	add    $0x1,%ecx
  800959:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80095d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800960:	84 db                	test   %bl,%bl
  800962:	75 ef                	jne    800953 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800964:	5b                   	pop    %ebx
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	53                   	push   %ebx
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800971:	89 1c 24             	mov    %ebx,(%esp)
  800974:	e8 97 ff ff ff       	call   800910 <strlen>
	strcpy(dst + len, src);
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800980:	01 d8                	add    %ebx,%eax
  800982:	89 04 24             	mov    %eax,(%esp)
  800985:	e8 bd ff ff ff       	call   800947 <strcpy>
	return dst;
}
  80098a:	89 d8                	mov    %ebx,%eax
  80098c:	83 c4 08             	add    $0x8,%esp
  80098f:	5b                   	pop    %ebx
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 75 08             	mov    0x8(%ebp),%esi
  80099a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099d:	89 f3                	mov    %esi,%ebx
  80099f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a2:	89 f2                	mov    %esi,%edx
  8009a4:	eb 0f                	jmp    8009b5 <strncpy+0x23>
		*dst++ = *src;
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	0f b6 01             	movzbl (%ecx),%eax
  8009ac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009af:	80 39 01             	cmpb   $0x1,(%ecx)
  8009b2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b5:	39 da                	cmp    %ebx,%edx
  8009b7:	75 ed                	jne    8009a6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009b9:	89 f0                	mov    %esi,%eax
  8009bb:	5b                   	pop    %ebx
  8009bc:	5e                   	pop    %esi
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	56                   	push   %esi
  8009c3:	53                   	push   %ebx
  8009c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d3:	85 c9                	test   %ecx,%ecx
  8009d5:	75 0b                	jne    8009e2 <strlcpy+0x23>
  8009d7:	eb 1d                	jmp    8009f6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	83 c2 01             	add    $0x1,%edx
  8009df:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e2:	39 d8                	cmp    %ebx,%eax
  8009e4:	74 0b                	je     8009f1 <strlcpy+0x32>
  8009e6:	0f b6 0a             	movzbl (%edx),%ecx
  8009e9:	84 c9                	test   %cl,%cl
  8009eb:	75 ec                	jne    8009d9 <strlcpy+0x1a>
  8009ed:	89 c2                	mov    %eax,%edx
  8009ef:	eb 02                	jmp    8009f3 <strlcpy+0x34>
  8009f1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009f3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009f6:	29 f0                	sub    %esi,%eax
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a05:	eb 06                	jmp    800a0d <strcmp+0x11>
		p++, q++;
  800a07:	83 c1 01             	add    $0x1,%ecx
  800a0a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a0d:	0f b6 01             	movzbl (%ecx),%eax
  800a10:	84 c0                	test   %al,%al
  800a12:	74 04                	je     800a18 <strcmp+0x1c>
  800a14:	3a 02                	cmp    (%edx),%al
  800a16:	74 ef                	je     800a07 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a18:	0f b6 c0             	movzbl %al,%eax
  800a1b:	0f b6 12             	movzbl (%edx),%edx
  800a1e:	29 d0                	sub    %edx,%eax
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	53                   	push   %ebx
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2c:	89 c3                	mov    %eax,%ebx
  800a2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a31:	eb 06                	jmp    800a39 <strncmp+0x17>
		n--, p++, q++;
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a39:	39 d8                	cmp    %ebx,%eax
  800a3b:	74 15                	je     800a52 <strncmp+0x30>
  800a3d:	0f b6 08             	movzbl (%eax),%ecx
  800a40:	84 c9                	test   %cl,%cl
  800a42:	74 04                	je     800a48 <strncmp+0x26>
  800a44:	3a 0a                	cmp    (%edx),%cl
  800a46:	74 eb                	je     800a33 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a48:	0f b6 00             	movzbl (%eax),%eax
  800a4b:	0f b6 12             	movzbl (%edx),%edx
  800a4e:	29 d0                	sub    %edx,%eax
  800a50:	eb 05                	jmp    800a57 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a52:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a57:	5b                   	pop    %ebx
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a64:	eb 07                	jmp    800a6d <strchr+0x13>
		if (*s == c)
  800a66:	38 ca                	cmp    %cl,%dl
  800a68:	74 0f                	je     800a79 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a6a:	83 c0 01             	add    $0x1,%eax
  800a6d:	0f b6 10             	movzbl (%eax),%edx
  800a70:	84 d2                	test   %dl,%dl
  800a72:	75 f2                	jne    800a66 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	eb 07                	jmp    800a8e <strfind+0x13>
		if (*s == c)
  800a87:	38 ca                	cmp    %cl,%dl
  800a89:	74 0a                	je     800a95 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a8b:	83 c0 01             	add    $0x1,%eax
  800a8e:	0f b6 10             	movzbl (%eax),%edx
  800a91:	84 d2                	test   %dl,%dl
  800a93:	75 f2                	jne    800a87 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	57                   	push   %edi
  800a9b:	56                   	push   %esi
  800a9c:	53                   	push   %ebx
  800a9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa3:	85 c9                	test   %ecx,%ecx
  800aa5:	74 36                	je     800add <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aad:	75 28                	jne    800ad7 <memset+0x40>
  800aaf:	f6 c1 03             	test   $0x3,%cl
  800ab2:	75 23                	jne    800ad7 <memset+0x40>
		c &= 0xFF;
  800ab4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab8:	89 d3                	mov    %edx,%ebx
  800aba:	c1 e3 08             	shl    $0x8,%ebx
  800abd:	89 d6                	mov    %edx,%esi
  800abf:	c1 e6 18             	shl    $0x18,%esi
  800ac2:	89 d0                	mov    %edx,%eax
  800ac4:	c1 e0 10             	shl    $0x10,%eax
  800ac7:	09 f0                	or     %esi,%eax
  800ac9:	09 c2                	or     %eax,%edx
  800acb:	89 d0                	mov    %edx,%eax
  800acd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800acf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ad2:	fc                   	cld    
  800ad3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad5:	eb 06                	jmp    800add <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ada:	fc                   	cld    
  800adb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800add:	89 f8                	mov    %edi,%eax
  800adf:	5b                   	pop    %ebx
  800ae0:	5e                   	pop    %esi
  800ae1:	5f                   	pop    %edi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	57                   	push   %edi
  800ae8:	56                   	push   %esi
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af2:	39 c6                	cmp    %eax,%esi
  800af4:	73 35                	jae    800b2b <memmove+0x47>
  800af6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af9:	39 d0                	cmp    %edx,%eax
  800afb:	73 2e                	jae    800b2b <memmove+0x47>
		s += n;
		d += n;
  800afd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b00:	89 d6                	mov    %edx,%esi
  800b02:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0a:	75 13                	jne    800b1f <memmove+0x3b>
  800b0c:	f6 c1 03             	test   $0x3,%cl
  800b0f:	75 0e                	jne    800b1f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b11:	83 ef 04             	sub    $0x4,%edi
  800b14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b1a:	fd                   	std    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb 09                	jmp    800b28 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1f:	83 ef 01             	sub    $0x1,%edi
  800b22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b25:	fd                   	std    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b28:	fc                   	cld    
  800b29:	eb 1d                	jmp    800b48 <memmove+0x64>
  800b2b:	89 f2                	mov    %esi,%edx
  800b2d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2f:	f6 c2 03             	test   $0x3,%dl
  800b32:	75 0f                	jne    800b43 <memmove+0x5f>
  800b34:	f6 c1 03             	test   $0x3,%cl
  800b37:	75 0a                	jne    800b43 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b39:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b3c:	89 c7                	mov    %eax,%edi
  800b3e:	fc                   	cld    
  800b3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b41:	eb 05                	jmp    800b48 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b43:	89 c7                	mov    %eax,%edi
  800b45:	fc                   	cld    
  800b46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b52:	8b 45 10             	mov    0x10(%ebp),%eax
  800b55:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	89 04 24             	mov    %eax,(%esp)
  800b66:	e8 79 ff ff ff       	call   800ae4 <memmove>
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b78:	89 d6                	mov    %edx,%esi
  800b7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7d:	eb 1a                	jmp    800b99 <memcmp+0x2c>
		if (*s1 != *s2)
  800b7f:	0f b6 02             	movzbl (%edx),%eax
  800b82:	0f b6 19             	movzbl (%ecx),%ebx
  800b85:	38 d8                	cmp    %bl,%al
  800b87:	74 0a                	je     800b93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b89:	0f b6 c0             	movzbl %al,%eax
  800b8c:	0f b6 db             	movzbl %bl,%ebx
  800b8f:	29 d8                	sub    %ebx,%eax
  800b91:	eb 0f                	jmp    800ba2 <memcmp+0x35>
		s1++, s2++;
  800b93:	83 c2 01             	add    $0x1,%edx
  800b96:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b99:	39 f2                	cmp    %esi,%edx
  800b9b:	75 e2                	jne    800b7f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800baf:	89 c2                	mov    %eax,%edx
  800bb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb4:	eb 07                	jmp    800bbd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb6:	38 08                	cmp    %cl,(%eax)
  800bb8:	74 07                	je     800bc1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	39 d0                	cmp    %edx,%eax
  800bbf:	72 f5                	jb     800bb6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bcf:	eb 03                	jmp    800bd4 <strtol+0x11>
		s++;
  800bd1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd4:	0f b6 0a             	movzbl (%edx),%ecx
  800bd7:	80 f9 09             	cmp    $0x9,%cl
  800bda:	74 f5                	je     800bd1 <strtol+0xe>
  800bdc:	80 f9 20             	cmp    $0x20,%cl
  800bdf:	74 f0                	je     800bd1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800be1:	80 f9 2b             	cmp    $0x2b,%cl
  800be4:	75 0a                	jne    800bf0 <strtol+0x2d>
		s++;
  800be6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800be9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bee:	eb 11                	jmp    800c01 <strtol+0x3e>
  800bf0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bf5:	80 f9 2d             	cmp    $0x2d,%cl
  800bf8:	75 07                	jne    800c01 <strtol+0x3e>
		s++, neg = 1;
  800bfa:	8d 52 01             	lea    0x1(%edx),%edx
  800bfd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c01:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c06:	75 15                	jne    800c1d <strtol+0x5a>
  800c08:	80 3a 30             	cmpb   $0x30,(%edx)
  800c0b:	75 10                	jne    800c1d <strtol+0x5a>
  800c0d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c11:	75 0a                	jne    800c1d <strtol+0x5a>
		s += 2, base = 16;
  800c13:	83 c2 02             	add    $0x2,%edx
  800c16:	b8 10 00 00 00       	mov    $0x10,%eax
  800c1b:	eb 10                	jmp    800c2d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	75 0c                	jne    800c2d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c21:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c23:	80 3a 30             	cmpb   $0x30,(%edx)
  800c26:	75 05                	jne    800c2d <strtol+0x6a>
		s++, base = 8;
  800c28:	83 c2 01             	add    $0x1,%edx
  800c2b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c32:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c35:	0f b6 0a             	movzbl (%edx),%ecx
  800c38:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c3b:	89 f0                	mov    %esi,%eax
  800c3d:	3c 09                	cmp    $0x9,%al
  800c3f:	77 08                	ja     800c49 <strtol+0x86>
			dig = *s - '0';
  800c41:	0f be c9             	movsbl %cl,%ecx
  800c44:	83 e9 30             	sub    $0x30,%ecx
  800c47:	eb 20                	jmp    800c69 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c49:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c4c:	89 f0                	mov    %esi,%eax
  800c4e:	3c 19                	cmp    $0x19,%al
  800c50:	77 08                	ja     800c5a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c52:	0f be c9             	movsbl %cl,%ecx
  800c55:	83 e9 57             	sub    $0x57,%ecx
  800c58:	eb 0f                	jmp    800c69 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c5a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c5d:	89 f0                	mov    %esi,%eax
  800c5f:	3c 19                	cmp    $0x19,%al
  800c61:	77 16                	ja     800c79 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c63:	0f be c9             	movsbl %cl,%ecx
  800c66:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c69:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c6c:	7d 0f                	jge    800c7d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c6e:	83 c2 01             	add    $0x1,%edx
  800c71:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c75:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c77:	eb bc                	jmp    800c35 <strtol+0x72>
  800c79:	89 d8                	mov    %ebx,%eax
  800c7b:	eb 02                	jmp    800c7f <strtol+0xbc>
  800c7d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c83:	74 05                	je     800c8a <strtol+0xc7>
		*endptr = (char *) s;
  800c85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c88:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c8a:	f7 d8                	neg    %eax
  800c8c:	85 ff                	test   %edi,%edi
  800c8e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    

00800c96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	89 c3                	mov    %eax,%ebx
  800ca9:	89 c7                	mov    %eax,%edi
  800cab:	89 c6                	mov    %eax,%esi
  800cad:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce9:	89 cb                	mov    %ecx,%ebx
  800ceb:	89 cf                	mov    %ecx,%edi
  800ced:	89 ce                	mov    %ecx,%esi
  800cef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	7e 28                	jle    800d1d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cf9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d00:	00 
  800d01:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  800d08:	00 
  800d09:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d10:	00 
  800d11:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  800d18:	e8 05 f5 ff ff       	call   800222 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d1d:	83 c4 2c             	add    $0x2c,%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d30:	b8 02 00 00 00       	mov    $0x2,%eax
  800d35:	89 d1                	mov    %edx,%ecx
  800d37:	89 d3                	mov    %edx,%ebx
  800d39:	89 d7                	mov    %edx,%edi
  800d3b:	89 d6                	mov    %edx,%esi
  800d3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <sys_yield>:

void
sys_yield(void)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d54:	89 d1                	mov    %edx,%ecx
  800d56:	89 d3                	mov    %edx,%ebx
  800d58:	89 d7                	mov    %edx,%edi
  800d5a:	89 d6                	mov    %edx,%esi
  800d5c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6c:	be 00 00 00 00       	mov    $0x0,%esi
  800d71:	b8 04 00 00 00       	mov    $0x4,%eax
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7f:	89 f7                	mov    %esi,%edi
  800d81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7e 28                	jle    800daf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d8b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d92:	00 
  800d93:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  800d9a:	00 
  800d9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da2:	00 
  800da3:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  800daa:	e8 73 f4 ff ff       	call   800222 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800daf:	83 c4 2c             	add    $0x2c,%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc0:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dce:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd1:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7e 28                	jle    800e02 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dda:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dde:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800de5:	00 
  800de6:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  800ded:	00 
  800dee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df5:	00 
  800df6:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  800dfd:	e8 20 f4 ff ff       	call   800222 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e02:	83 c4 2c             	add    $0x2c,%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	b8 06 00 00 00       	mov    $0x6,%eax
  800e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e20:	8b 55 08             	mov    0x8(%ebp),%edx
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7e 28                	jle    800e55 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e31:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e38:	00 
  800e39:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  800e40:	00 
  800e41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e48:	00 
  800e49:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  800e50:	e8 cd f3 ff ff       	call   800222 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e55:	83 c4 2c             	add    $0x2c,%esp
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	89 df                	mov    %ebx,%edi
  800e78:	89 de                	mov    %ebx,%esi
  800e7a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	7e 28                	jle    800ea8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e84:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e8b:	00 
  800e8c:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  800e93:	00 
  800e94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e9b:	00 
  800e9c:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  800ea3:	e8 7a f3 ff ff       	call   800222 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ea8:	83 c4 2c             	add    $0x2c,%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	57                   	push   %edi
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebe:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	89 df                	mov    %ebx,%edi
  800ecb:	89 de                	mov    %ebx,%esi
  800ecd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	7e 28                	jle    800efb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ede:	00 
  800edf:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  800ee6:	00 
  800ee7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eee:	00 
  800eef:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  800ef6:	e8 27 f3 ff ff       	call   800222 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800efb:	83 c4 2c             	add    $0x2c,%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f11:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	89 df                	mov    %ebx,%edi
  800f1e:	89 de                	mov    %ebx,%esi
  800f20:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7e 28                	jle    800f4e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f26:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f31:	00 
  800f32:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  800f39:	00 
  800f3a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f41:	00 
  800f42:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  800f49:	e8 d4 f2 ff ff       	call   800222 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f4e:	83 c4 2c             	add    $0x2c,%esp
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    

00800f56 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5c:	be 00 00 00 00       	mov    $0x0,%esi
  800f61:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f72:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
  800f7f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f87:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	89 cb                	mov    %ecx,%ebx
  800f91:	89 cf                	mov    %ecx,%edi
  800f93:	89 ce                	mov    %ecx,%esi
  800f95:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f97:	85 c0                	test   %eax,%eax
  800f99:	7e 28                	jle    800fc3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fa6:	00 
  800fa7:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  800fae:	00 
  800faf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb6:	00 
  800fb7:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  800fbe:	e8 5f f2 ff ff       	call   800222 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc3:	83 c4 2c             	add    $0x2c,%esp
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fdb:	89 d1                	mov    %edx,%ecx
  800fdd:	89 d3                	mov    %edx,%ebx
  800fdf:	89 d7                	mov    %edx,%edi
  800fe1:	89 d6                	mov    %edx,%esi
  800fe3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
  800ff0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ffd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801000:	8b 55 08             	mov    0x8(%ebp),%edx
  801003:	89 df                	mov    %ebx,%edi
  801005:	89 de                	mov    %ebx,%esi
  801007:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801009:	85 c0                	test   %eax,%eax
  80100b:	7e 28                	jle    801035 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80100d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801011:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801018:	00 
  801019:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  801020:	00 
  801021:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801028:	00 
  801029:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801030:	e8 ed f1 ff ff       	call   800222 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801035:	83 c4 2c             	add    $0x2c,%esp
  801038:	5b                   	pop    %ebx
  801039:	5e                   	pop    %esi
  80103a:	5f                   	pop    %edi
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	57                   	push   %edi
  801041:	56                   	push   %esi
  801042:	53                   	push   %ebx
  801043:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801046:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104b:	b8 10 00 00 00       	mov    $0x10,%eax
  801050:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801053:	8b 55 08             	mov    0x8(%ebp),%edx
  801056:	89 df                	mov    %ebx,%edi
  801058:	89 de                	mov    %ebx,%esi
  80105a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	7e 28                	jle    801088 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801060:	89 44 24 10          	mov    %eax,0x10(%esp)
  801064:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80106b:	00 
  80106c:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  801073:	00 
  801074:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80107b:	00 
  80107c:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801083:	e8 9a f1 ff ff       	call   800222 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801088:	83 c4 2c             	add    $0x2c,%esp
  80108b:	5b                   	pop    %ebx
  80108c:	5e                   	pop    %esi
  80108d:	5f                   	pop    %edi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	53                   	push   %ebx
  801094:	83 ec 24             	sub    $0x24,%esp
  801097:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  80109a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  80109c:	89 d3                	mov    %edx,%ebx
  80109e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  8010a4:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010a8:	74 1a                	je     8010c4 <pgfault+0x34>
  8010aa:	c1 ea 0c             	shr    $0xc,%edx
  8010ad:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010b4:	a8 01                	test   $0x1,%al
  8010b6:	74 0c                	je     8010c4 <pgfault+0x34>
  8010b8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010bf:	f6 c4 08             	test   $0x8,%ah
  8010c2:	75 1c                	jne    8010e0 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  8010c4:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8010d3:	00 
  8010d4:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  8010db:	e8 42 f1 ff ff       	call   800222 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  8010e0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010e7:	00 
  8010e8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010ef:	00 
  8010f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010f7:	e8 67 fc ff ff       	call   800d63 <sys_page_alloc>
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	79 1c                	jns    80111c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801100:	c7 44 24 08 f0 35 80 	movl   $0x8035f0,0x8(%esp)
  801107:	00 
  801108:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80110f:	00 
  801110:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  801117:	e8 06 f1 ff ff       	call   800222 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  80111c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801123:	00 
  801124:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801128:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80112f:	e8 18 fa ff ff       	call   800b4c <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801134:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80113b:	00 
  80113c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801140:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801147:	00 
  801148:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80114f:	00 
  801150:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801157:	e8 5b fc ff ff       	call   800db7 <sys_page_map>
  80115c:	85 c0                	test   %eax,%eax
  80115e:	74 1c                	je     80117c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  801160:	c7 44 24 08 06 37 80 	movl   $0x803706,0x8(%esp)
  801167:	00 
  801168:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80116f:	00 
  801170:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  801177:	e8 a6 f0 ff ff       	call   800222 <_panic>
    sys_page_unmap(0,PFTEMP);
  80117c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801183:	00 
  801184:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80118b:	e8 7a fc ff ff       	call   800e0a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801190:	83 c4 24             	add    $0x24,%esp
  801193:	5b                   	pop    %ebx
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    

00801196 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	57                   	push   %edi
  80119a:	56                   	push   %esi
  80119b:	53                   	push   %ebx
  80119c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80119f:	c7 04 24 90 10 80 00 	movl   $0x801090,(%esp)
  8011a6:	e8 7b 1b 00 00       	call   802d26 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011ab:	b8 07 00 00 00       	mov    $0x7,%eax
  8011b0:	cd 30                	int    $0x30
  8011b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011b5:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  8011b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	75 21                	jne    8011e1 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8011c0:	e8 60 fb ff ff       	call   800d25 <sys_getenvid>
  8011c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011d2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8011d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011dc:	e9 de 01 00 00       	jmp    8013bf <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  8011e1:	89 d8                	mov    %ebx,%eax
  8011e3:	c1 e8 16             	shr    $0x16,%eax
  8011e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011ed:	a8 01                	test   $0x1,%al
  8011ef:	0f 84 58 01 00 00    	je     80134d <fork+0x1b7>
  8011f5:	89 de                	mov    %ebx,%esi
  8011f7:	c1 ee 0c             	shr    $0xc,%esi
  8011fa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801201:	83 e0 05             	and    $0x5,%eax
  801204:	83 f8 05             	cmp    $0x5,%eax
  801207:	0f 85 40 01 00 00    	jne    80134d <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80120d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801214:	f6 c4 04             	test   $0x4,%ah
  801217:	74 4f                	je     801268 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801219:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801220:	c1 e6 0c             	shl    $0xc,%esi
  801223:	25 07 0e 00 00       	and    $0xe07,%eax
  801228:	89 44 24 10          	mov    %eax,0x10(%esp)
  80122c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801230:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801234:	89 74 24 04          	mov    %esi,0x4(%esp)
  801238:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80123f:	e8 73 fb ff ff       	call   800db7 <sys_page_map>
  801244:	85 c0                	test   %eax,%eax
  801246:	0f 89 01 01 00 00    	jns    80134d <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  80124c:	c7 44 24 08 10 36 80 	movl   $0x803610,0x8(%esp)
  801253:	00 
  801254:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  80125b:	00 
  80125c:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  801263:	e8 ba ef ff ff       	call   800222 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  801268:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80126f:	a8 02                	test   $0x2,%al
  801271:	75 10                	jne    801283 <fork+0xed>
  801273:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80127a:	f6 c4 08             	test   $0x8,%ah
  80127d:	0f 84 87 00 00 00    	je     80130a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801283:	c1 e6 0c             	shl    $0xc,%esi
  801286:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80128d:	00 
  80128e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801292:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801296:	89 74 24 04          	mov    %esi,0x4(%esp)
  80129a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a1:	e8 11 fb ff ff       	call   800db7 <sys_page_map>
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	79 1c                	jns    8012c6 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  8012aa:	c7 44 24 08 48 36 80 	movl   $0x803648,0x8(%esp)
  8012b1:	00 
  8012b2:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8012b9:	00 
  8012ba:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  8012c1:	e8 5c ef ff ff       	call   800222 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  8012c6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012cd:	00 
  8012ce:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012d9:	00 
  8012da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e5:	e8 cd fa ff ff       	call   800db7 <sys_page_map>
  8012ea:	85 c0                	test   %eax,%eax
  8012ec:	79 5f                	jns    80134d <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  8012ee:	c7 44 24 08 80 36 80 	movl   $0x803680,0x8(%esp)
  8012f5:	00 
  8012f6:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8012fd:	00 
  8012fe:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  801305:	e8 18 ef ff ff       	call   800222 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80130a:	c1 e6 0c             	shl    $0xc,%esi
  80130d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801314:	00 
  801315:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801319:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80131d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801321:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801328:	e8 8a fa ff ff       	call   800db7 <sys_page_map>
  80132d:	85 c0                	test   %eax,%eax
  80132f:	74 1c                	je     80134d <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801331:	c7 44 24 08 a8 36 80 	movl   $0x8036a8,0x8(%esp)
  801338:	00 
  801339:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801340:	00 
  801341:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  801348:	e8 d5 ee ff ff       	call   800222 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  80134d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801353:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801359:	0f 85 82 fe ff ff    	jne    8011e1 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  80135f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801366:	00 
  801367:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80136e:	ee 
  80136f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801372:	89 04 24             	mov    %eax,(%esp)
  801375:	e8 e9 f9 ff ff       	call   800d63 <sys_page_alloc>
  80137a:	85 c0                	test   %eax,%eax
  80137c:	79 1c                	jns    80139a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  80137e:	c7 44 24 08 dc 36 80 	movl   $0x8036dc,0x8(%esp)
  801385:	00 
  801386:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  80138d:	00 
  80138e:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  801395:	e8 88 ee ff ff       	call   800222 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  80139a:	c7 44 24 04 97 2d 80 	movl   $0x802d97,0x4(%esp)
  8013a1:	00 
  8013a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013a5:	89 3c 24             	mov    %edi,(%esp)
  8013a8:	e8 56 fb ff ff       	call   800f03 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  8013ad:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013b4:	00 
  8013b5:	89 3c 24             	mov    %edi,(%esp)
  8013b8:	e8 a0 fa ff ff       	call   800e5d <sys_env_set_status>
		return child;
  8013bd:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  8013bf:	83 c4 2c             	add    $0x2c,%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <sfork>:

// Challenge!
int
sfork(void)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8013cd:	c7 44 24 08 24 37 80 	movl   $0x803724,0x8(%esp)
  8013d4:	00 
  8013d5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8013dc:	00 
  8013dd:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  8013e4:	e8 39 ee ff ff       	call   800222 <_panic>
  8013e9:	66 90                	xchg   %ax,%ax
  8013eb:	66 90                	xchg   %ax,%ax
  8013ed:	66 90                	xchg   %ax,%ax
  8013ef:	90                   	nop

008013f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80140b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801410:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    

00801417 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801422:	89 c2                	mov    %eax,%edx
  801424:	c1 ea 16             	shr    $0x16,%edx
  801427:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80142e:	f6 c2 01             	test   $0x1,%dl
  801431:	74 11                	je     801444 <fd_alloc+0x2d>
  801433:	89 c2                	mov    %eax,%edx
  801435:	c1 ea 0c             	shr    $0xc,%edx
  801438:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80143f:	f6 c2 01             	test   $0x1,%dl
  801442:	75 09                	jne    80144d <fd_alloc+0x36>
			*fd_store = fd;
  801444:	89 01                	mov    %eax,(%ecx)
			return 0;
  801446:	b8 00 00 00 00       	mov    $0x0,%eax
  80144b:	eb 17                	jmp    801464 <fd_alloc+0x4d>
  80144d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801452:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801457:	75 c9                	jne    801422 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801459:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80145f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801464:	5d                   	pop    %ebp
  801465:	c3                   	ret    

00801466 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80146c:	83 f8 1f             	cmp    $0x1f,%eax
  80146f:	77 36                	ja     8014a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801471:	c1 e0 0c             	shl    $0xc,%eax
  801474:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801479:	89 c2                	mov    %eax,%edx
  80147b:	c1 ea 16             	shr    $0x16,%edx
  80147e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801485:	f6 c2 01             	test   $0x1,%dl
  801488:	74 24                	je     8014ae <fd_lookup+0x48>
  80148a:	89 c2                	mov    %eax,%edx
  80148c:	c1 ea 0c             	shr    $0xc,%edx
  80148f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801496:	f6 c2 01             	test   $0x1,%dl
  801499:	74 1a                	je     8014b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80149b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149e:	89 02                	mov    %eax,(%edx)
	return 0;
  8014a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a5:	eb 13                	jmp    8014ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ac:	eb 0c                	jmp    8014ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b3:	eb 05                	jmp    8014ba <fd_lookup+0x54>
  8014b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    

008014bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 18             	sub    $0x18,%esp
  8014c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8014c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ca:	eb 13                	jmp    8014df <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8014cc:	39 08                	cmp    %ecx,(%eax)
  8014ce:	75 0c                	jne    8014dc <dev_lookup+0x20>
			*dev = devtab[i];
  8014d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014da:	eb 38                	jmp    801514 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8014dc:	83 c2 01             	add    $0x1,%edx
  8014df:	8b 04 95 b8 37 80 00 	mov    0x8037b8(,%edx,4),%eax
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	75 e2                	jne    8014cc <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8014ef:	8b 40 48             	mov    0x48(%eax),%eax
  8014f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014fa:	c7 04 24 3c 37 80 00 	movl   $0x80373c,(%esp)
  801501:	e8 15 ee ff ff       	call   80031b <cprintf>
	*dev = 0;
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80150f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	56                   	push   %esi
  80151a:	53                   	push   %ebx
  80151b:	83 ec 20             	sub    $0x20,%esp
  80151e:	8b 75 08             	mov    0x8(%ebp),%esi
  801521:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801527:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80152b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801531:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801534:	89 04 24             	mov    %eax,(%esp)
  801537:	e8 2a ff ff ff       	call   801466 <fd_lookup>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 05                	js     801545 <fd_close+0x2f>
	    || fd != fd2)
  801540:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801543:	74 0c                	je     801551 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801545:	84 db                	test   %bl,%bl
  801547:	ba 00 00 00 00       	mov    $0x0,%edx
  80154c:	0f 44 c2             	cmove  %edx,%eax
  80154f:	eb 3f                	jmp    801590 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801551:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801554:	89 44 24 04          	mov    %eax,0x4(%esp)
  801558:	8b 06                	mov    (%esi),%eax
  80155a:	89 04 24             	mov    %eax,(%esp)
  80155d:	e8 5a ff ff ff       	call   8014bc <dev_lookup>
  801562:	89 c3                	mov    %eax,%ebx
  801564:	85 c0                	test   %eax,%eax
  801566:	78 16                	js     80157e <fd_close+0x68>
		if (dev->dev_close)
  801568:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80156e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801573:	85 c0                	test   %eax,%eax
  801575:	74 07                	je     80157e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801577:	89 34 24             	mov    %esi,(%esp)
  80157a:	ff d0                	call   *%eax
  80157c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80157e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801582:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801589:	e8 7c f8 ff ff       	call   800e0a <sys_page_unmap>
	return r;
  80158e:	89 d8                	mov    %ebx,%eax
}
  801590:	83 c4 20             	add    $0x20,%esp
  801593:	5b                   	pop    %ebx
  801594:	5e                   	pop    %esi
  801595:	5d                   	pop    %ebp
  801596:	c3                   	ret    

00801597 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801597:	55                   	push   %ebp
  801598:	89 e5                	mov    %esp,%ebp
  80159a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80159d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	89 04 24             	mov    %eax,(%esp)
  8015aa:	e8 b7 fe ff ff       	call   801466 <fd_lookup>
  8015af:	89 c2                	mov    %eax,%edx
  8015b1:	85 d2                	test   %edx,%edx
  8015b3:	78 13                	js     8015c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8015b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015bc:	00 
  8015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c0:	89 04 24             	mov    %eax,(%esp)
  8015c3:	e8 4e ff ff ff       	call   801516 <fd_close>
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <close_all>:

void
close_all(void)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015d6:	89 1c 24             	mov    %ebx,(%esp)
  8015d9:	e8 b9 ff ff ff       	call   801597 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015de:	83 c3 01             	add    $0x1,%ebx
  8015e1:	83 fb 20             	cmp    $0x20,%ebx
  8015e4:	75 f0                	jne    8015d6 <close_all+0xc>
		close(i);
}
  8015e6:	83 c4 14             	add    $0x14,%esp
  8015e9:	5b                   	pop    %ebx
  8015ea:	5d                   	pop    %ebp
  8015eb:	c3                   	ret    

008015ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	57                   	push   %edi
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	89 04 24             	mov    %eax,(%esp)
  801602:	e8 5f fe ff ff       	call   801466 <fd_lookup>
  801607:	89 c2                	mov    %eax,%edx
  801609:	85 d2                	test   %edx,%edx
  80160b:	0f 88 e1 00 00 00    	js     8016f2 <dup+0x106>
		return r;
	close(newfdnum);
  801611:	8b 45 0c             	mov    0xc(%ebp),%eax
  801614:	89 04 24             	mov    %eax,(%esp)
  801617:	e8 7b ff ff ff       	call   801597 <close>

	newfd = INDEX2FD(newfdnum);
  80161c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80161f:	c1 e3 0c             	shl    $0xc,%ebx
  801622:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80162b:	89 04 24             	mov    %eax,(%esp)
  80162e:	e8 cd fd ff ff       	call   801400 <fd2data>
  801633:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801635:	89 1c 24             	mov    %ebx,(%esp)
  801638:	e8 c3 fd ff ff       	call   801400 <fd2data>
  80163d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80163f:	89 f0                	mov    %esi,%eax
  801641:	c1 e8 16             	shr    $0x16,%eax
  801644:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80164b:	a8 01                	test   $0x1,%al
  80164d:	74 43                	je     801692 <dup+0xa6>
  80164f:	89 f0                	mov    %esi,%eax
  801651:	c1 e8 0c             	shr    $0xc,%eax
  801654:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80165b:	f6 c2 01             	test   $0x1,%dl
  80165e:	74 32                	je     801692 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801660:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801667:	25 07 0e 00 00       	and    $0xe07,%eax
  80166c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801670:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801674:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80167b:	00 
  80167c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801680:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801687:	e8 2b f7 ff ff       	call   800db7 <sys_page_map>
  80168c:	89 c6                	mov    %eax,%esi
  80168e:	85 c0                	test   %eax,%eax
  801690:	78 3e                	js     8016d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801695:	89 c2                	mov    %eax,%edx
  801697:	c1 ea 0c             	shr    $0xc,%edx
  80169a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016b6:	00 
  8016b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016c2:	e8 f0 f6 ff ff       	call   800db7 <sys_page_map>
  8016c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8016c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016cc:	85 f6                	test   %esi,%esi
  8016ce:	79 22                	jns    8016f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016db:	e8 2a f7 ff ff       	call   800e0a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016eb:	e8 1a f7 ff ff       	call   800e0a <sys_page_unmap>
	return r;
  8016f0:	89 f0                	mov    %esi,%eax
}
  8016f2:	83 c4 3c             	add    $0x3c,%esp
  8016f5:	5b                   	pop    %ebx
  8016f6:	5e                   	pop    %esi
  8016f7:	5f                   	pop    %edi
  8016f8:	5d                   	pop    %ebp
  8016f9:	c3                   	ret    

008016fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	53                   	push   %ebx
  8016fe:	83 ec 24             	sub    $0x24,%esp
  801701:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801704:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801707:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170b:	89 1c 24             	mov    %ebx,(%esp)
  80170e:	e8 53 fd ff ff       	call   801466 <fd_lookup>
  801713:	89 c2                	mov    %eax,%edx
  801715:	85 d2                	test   %edx,%edx
  801717:	78 6d                	js     801786 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801719:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801723:	8b 00                	mov    (%eax),%eax
  801725:	89 04 24             	mov    %eax,(%esp)
  801728:	e8 8f fd ff ff       	call   8014bc <dev_lookup>
  80172d:	85 c0                	test   %eax,%eax
  80172f:	78 55                	js     801786 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801734:	8b 50 08             	mov    0x8(%eax),%edx
  801737:	83 e2 03             	and    $0x3,%edx
  80173a:	83 fa 01             	cmp    $0x1,%edx
  80173d:	75 23                	jne    801762 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80173f:	a1 08 50 80 00       	mov    0x805008,%eax
  801744:	8b 40 48             	mov    0x48(%eax),%eax
  801747:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80174b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174f:	c7 04 24 7d 37 80 00 	movl   $0x80377d,(%esp)
  801756:	e8 c0 eb ff ff       	call   80031b <cprintf>
		return -E_INVAL;
  80175b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801760:	eb 24                	jmp    801786 <read+0x8c>
	}
	if (!dev->dev_read)
  801762:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801765:	8b 52 08             	mov    0x8(%edx),%edx
  801768:	85 d2                	test   %edx,%edx
  80176a:	74 15                	je     801781 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80176c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80176f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801773:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801776:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80177a:	89 04 24             	mov    %eax,(%esp)
  80177d:	ff d2                	call   *%edx
  80177f:	eb 05                	jmp    801786 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801781:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801786:	83 c4 24             	add    $0x24,%esp
  801789:	5b                   	pop    %ebx
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    

0080178c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	57                   	push   %edi
  801790:	56                   	push   %esi
  801791:	53                   	push   %ebx
  801792:	83 ec 1c             	sub    $0x1c,%esp
  801795:	8b 7d 08             	mov    0x8(%ebp),%edi
  801798:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80179b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017a0:	eb 23                	jmp    8017c5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017a2:	89 f0                	mov    %esi,%eax
  8017a4:	29 d8                	sub    %ebx,%eax
  8017a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017aa:	89 d8                	mov    %ebx,%eax
  8017ac:	03 45 0c             	add    0xc(%ebp),%eax
  8017af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b3:	89 3c 24             	mov    %edi,(%esp)
  8017b6:	e8 3f ff ff ff       	call   8016fa <read>
		if (m < 0)
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	78 10                	js     8017cf <readn+0x43>
			return m;
		if (m == 0)
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	74 0a                	je     8017cd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017c3:	01 c3                	add    %eax,%ebx
  8017c5:	39 f3                	cmp    %esi,%ebx
  8017c7:	72 d9                	jb     8017a2 <readn+0x16>
  8017c9:	89 d8                	mov    %ebx,%eax
  8017cb:	eb 02                	jmp    8017cf <readn+0x43>
  8017cd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017cf:	83 c4 1c             	add    $0x1c,%esp
  8017d2:	5b                   	pop    %ebx
  8017d3:	5e                   	pop    %esi
  8017d4:	5f                   	pop    %edi
  8017d5:	5d                   	pop    %ebp
  8017d6:	c3                   	ret    

008017d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	53                   	push   %ebx
  8017db:	83 ec 24             	sub    $0x24,%esp
  8017de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e8:	89 1c 24             	mov    %ebx,(%esp)
  8017eb:	e8 76 fc ff ff       	call   801466 <fd_lookup>
  8017f0:	89 c2                	mov    %eax,%edx
  8017f2:	85 d2                	test   %edx,%edx
  8017f4:	78 68                	js     80185e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801800:	8b 00                	mov    (%eax),%eax
  801802:	89 04 24             	mov    %eax,(%esp)
  801805:	e8 b2 fc ff ff       	call   8014bc <dev_lookup>
  80180a:	85 c0                	test   %eax,%eax
  80180c:	78 50                	js     80185e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80180e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801811:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801815:	75 23                	jne    80183a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801817:	a1 08 50 80 00       	mov    0x805008,%eax
  80181c:	8b 40 48             	mov    0x48(%eax),%eax
  80181f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801823:	89 44 24 04          	mov    %eax,0x4(%esp)
  801827:	c7 04 24 99 37 80 00 	movl   $0x803799,(%esp)
  80182e:	e8 e8 ea ff ff       	call   80031b <cprintf>
		return -E_INVAL;
  801833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801838:	eb 24                	jmp    80185e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80183a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183d:	8b 52 0c             	mov    0xc(%edx),%edx
  801840:	85 d2                	test   %edx,%edx
  801842:	74 15                	je     801859 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801844:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801847:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80184b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80184e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801852:	89 04 24             	mov    %eax,(%esp)
  801855:	ff d2                	call   *%edx
  801857:	eb 05                	jmp    80185e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801859:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80185e:	83 c4 24             	add    $0x24,%esp
  801861:	5b                   	pop    %ebx
  801862:	5d                   	pop    %ebp
  801863:	c3                   	ret    

00801864 <seek>:

int
seek(int fdnum, off_t offset)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80186a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80186d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	89 04 24             	mov    %eax,(%esp)
  801877:	e8 ea fb ff ff       	call   801466 <fd_lookup>
  80187c:	85 c0                	test   %eax,%eax
  80187e:	78 0e                	js     80188e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801880:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801883:	8b 55 0c             	mov    0xc(%ebp),%edx
  801886:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	53                   	push   %ebx
  801894:	83 ec 24             	sub    $0x24,%esp
  801897:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80189a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80189d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a1:	89 1c 24             	mov    %ebx,(%esp)
  8018a4:	e8 bd fb ff ff       	call   801466 <fd_lookup>
  8018a9:	89 c2                	mov    %eax,%edx
  8018ab:	85 d2                	test   %edx,%edx
  8018ad:	78 61                	js     801910 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b9:	8b 00                	mov    (%eax),%eax
  8018bb:	89 04 24             	mov    %eax,(%esp)
  8018be:	e8 f9 fb ff ff       	call   8014bc <dev_lookup>
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	78 49                	js     801910 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018ce:	75 23                	jne    8018f3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018d0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018d5:	8b 40 48             	mov    0x48(%eax),%eax
  8018d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e0:	c7 04 24 5c 37 80 00 	movl   $0x80375c,(%esp)
  8018e7:	e8 2f ea ff ff       	call   80031b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f1:	eb 1d                	jmp    801910 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f6:	8b 52 18             	mov    0x18(%edx),%edx
  8018f9:	85 d2                	test   %edx,%edx
  8018fb:	74 0e                	je     80190b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801900:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801904:	89 04 24             	mov    %eax,(%esp)
  801907:	ff d2                	call   *%edx
  801909:	eb 05                	jmp    801910 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80190b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801910:	83 c4 24             	add    $0x24,%esp
  801913:	5b                   	pop    %ebx
  801914:	5d                   	pop    %ebp
  801915:	c3                   	ret    

00801916 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	53                   	push   %ebx
  80191a:	83 ec 24             	sub    $0x24,%esp
  80191d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801920:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801923:	89 44 24 04          	mov    %eax,0x4(%esp)
  801927:	8b 45 08             	mov    0x8(%ebp),%eax
  80192a:	89 04 24             	mov    %eax,(%esp)
  80192d:	e8 34 fb ff ff       	call   801466 <fd_lookup>
  801932:	89 c2                	mov    %eax,%edx
  801934:	85 d2                	test   %edx,%edx
  801936:	78 52                	js     80198a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801938:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80193b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801942:	8b 00                	mov    (%eax),%eax
  801944:	89 04 24             	mov    %eax,(%esp)
  801947:	e8 70 fb ff ff       	call   8014bc <dev_lookup>
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 3a                	js     80198a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801953:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801957:	74 2c                	je     801985 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801959:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80195c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801963:	00 00 00 
	stat->st_isdir = 0;
  801966:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80196d:	00 00 00 
	stat->st_dev = dev;
  801970:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801976:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80197a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80197d:	89 14 24             	mov    %edx,(%esp)
  801980:	ff 50 14             	call   *0x14(%eax)
  801983:	eb 05                	jmp    80198a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801985:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80198a:	83 c4 24             	add    $0x24,%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    

00801990 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	56                   	push   %esi
  801994:	53                   	push   %ebx
  801995:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801998:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80199f:	00 
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	89 04 24             	mov    %eax,(%esp)
  8019a6:	e8 28 02 00 00       	call   801bd3 <open>
  8019ab:	89 c3                	mov    %eax,%ebx
  8019ad:	85 db                	test   %ebx,%ebx
  8019af:	78 1b                	js     8019cc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8019b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b8:	89 1c 24             	mov    %ebx,(%esp)
  8019bb:	e8 56 ff ff ff       	call   801916 <fstat>
  8019c0:	89 c6                	mov    %eax,%esi
	close(fd);
  8019c2:	89 1c 24             	mov    %ebx,(%esp)
  8019c5:	e8 cd fb ff ff       	call   801597 <close>
	return r;
  8019ca:	89 f0                	mov    %esi,%eax
}
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5e                   	pop    %esi
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    

008019d3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	56                   	push   %esi
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 10             	sub    $0x10,%esp
  8019db:	89 c6                	mov    %eax,%esi
  8019dd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019df:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8019e6:	75 11                	jne    8019f9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019ef:	e8 92 14 00 00       	call   802e86 <ipc_find_env>
  8019f4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019f9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a00:	00 
  801a01:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a08:	00 
  801a09:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a0d:	a1 00 50 80 00       	mov    0x805000,%eax
  801a12:	89 04 24             	mov    %eax,(%esp)
  801a15:	e8 0e 14 00 00       	call   802e28 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a21:	00 
  801a22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a2d:	e8 8c 13 00 00       	call   802dbe <ipc_recv>
}
  801a32:	83 c4 10             	add    $0x10,%esp
  801a35:	5b                   	pop    %ebx
  801a36:	5e                   	pop    %esi
  801a37:	5d                   	pop    %ebp
  801a38:	c3                   	ret    

00801a39 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a42:	8b 40 0c             	mov    0xc(%eax),%eax
  801a45:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a52:	ba 00 00 00 00       	mov    $0x0,%edx
  801a57:	b8 02 00 00 00       	mov    $0x2,%eax
  801a5c:	e8 72 ff ff ff       	call   8019d3 <fsipc>
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a6f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a74:	ba 00 00 00 00       	mov    $0x0,%edx
  801a79:	b8 06 00 00 00       	mov    $0x6,%eax
  801a7e:	e8 50 ff ff ff       	call   8019d3 <fsipc>
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	53                   	push   %ebx
  801a89:	83 ec 14             	sub    $0x14,%esp
  801a8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	8b 40 0c             	mov    0xc(%eax),%eax
  801a95:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9f:	b8 05 00 00 00       	mov    $0x5,%eax
  801aa4:	e8 2a ff ff ff       	call   8019d3 <fsipc>
  801aa9:	89 c2                	mov    %eax,%edx
  801aab:	85 d2                	test   %edx,%edx
  801aad:	78 2b                	js     801ada <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801aaf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ab6:	00 
  801ab7:	89 1c 24             	mov    %ebx,(%esp)
  801aba:	e8 88 ee ff ff       	call   800947 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801abf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ac4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801aca:	a1 84 60 80 00       	mov    0x806084,%eax
  801acf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ad5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ada:	83 c4 14             	add    $0x14,%esp
  801add:	5b                   	pop    %ebx
  801ade:	5d                   	pop    %ebp
  801adf:	c3                   	ret    

00801ae0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 18             	sub    $0x18,%esp
  801ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801aee:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801af3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801af6:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801afb:	8b 55 08             	mov    0x8(%ebp),%edx
  801afe:	8b 52 0c             	mov    0xc(%edx),%edx
  801b01:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801b07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b12:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b19:	e8 c6 ef ff ff       	call   800ae4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b23:	b8 04 00 00 00       	mov    $0x4,%eax
  801b28:	e8 a6 fe ff ff       	call   8019d3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	56                   	push   %esi
  801b33:	53                   	push   %ebx
  801b34:	83 ec 10             	sub    $0x10,%esp
  801b37:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b40:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b45:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b50:	b8 03 00 00 00       	mov    $0x3,%eax
  801b55:	e8 79 fe ff ff       	call   8019d3 <fsipc>
  801b5a:	89 c3                	mov    %eax,%ebx
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	78 6a                	js     801bca <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b60:	39 c6                	cmp    %eax,%esi
  801b62:	73 24                	jae    801b88 <devfile_read+0x59>
  801b64:	c7 44 24 0c cc 37 80 	movl   $0x8037cc,0xc(%esp)
  801b6b:	00 
  801b6c:	c7 44 24 08 d3 37 80 	movl   $0x8037d3,0x8(%esp)
  801b73:	00 
  801b74:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b7b:	00 
  801b7c:	c7 04 24 e8 37 80 00 	movl   $0x8037e8,(%esp)
  801b83:	e8 9a e6 ff ff       	call   800222 <_panic>
	assert(r <= PGSIZE);
  801b88:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b8d:	7e 24                	jle    801bb3 <devfile_read+0x84>
  801b8f:	c7 44 24 0c f3 37 80 	movl   $0x8037f3,0xc(%esp)
  801b96:	00 
  801b97:	c7 44 24 08 d3 37 80 	movl   $0x8037d3,0x8(%esp)
  801b9e:	00 
  801b9f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ba6:	00 
  801ba7:	c7 04 24 e8 37 80 00 	movl   $0x8037e8,(%esp)
  801bae:	e8 6f e6 ff ff       	call   800222 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801bb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bbe:	00 
  801bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc2:	89 04 24             	mov    %eax,(%esp)
  801bc5:	e8 1a ef ff ff       	call   800ae4 <memmove>
	return r;
}
  801bca:	89 d8                	mov    %ebx,%eax
  801bcc:	83 c4 10             	add    $0x10,%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5d                   	pop    %ebp
  801bd2:	c3                   	ret    

00801bd3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	53                   	push   %ebx
  801bd7:	83 ec 24             	sub    $0x24,%esp
  801bda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801bdd:	89 1c 24             	mov    %ebx,(%esp)
  801be0:	e8 2b ed ff ff       	call   800910 <strlen>
  801be5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bea:	7f 60                	jg     801c4c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801bec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bef:	89 04 24             	mov    %eax,(%esp)
  801bf2:	e8 20 f8 ff ff       	call   801417 <fd_alloc>
  801bf7:	89 c2                	mov    %eax,%edx
  801bf9:	85 d2                	test   %edx,%edx
  801bfb:	78 54                	js     801c51 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801bfd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c01:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c08:	e8 3a ed ff ff       	call   800947 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c10:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c18:	b8 01 00 00 00       	mov    $0x1,%eax
  801c1d:	e8 b1 fd ff ff       	call   8019d3 <fsipc>
  801c22:	89 c3                	mov    %eax,%ebx
  801c24:	85 c0                	test   %eax,%eax
  801c26:	79 17                	jns    801c3f <open+0x6c>
		fd_close(fd, 0);
  801c28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c2f:	00 
  801c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c33:	89 04 24             	mov    %eax,(%esp)
  801c36:	e8 db f8 ff ff       	call   801516 <fd_close>
		return r;
  801c3b:	89 d8                	mov    %ebx,%eax
  801c3d:	eb 12                	jmp    801c51 <open+0x7e>
	}

	return fd2num(fd);
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c42:	89 04 24             	mov    %eax,(%esp)
  801c45:	e8 a6 f7 ff ff       	call   8013f0 <fd2num>
  801c4a:	eb 05                	jmp    801c51 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c4c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c51:	83 c4 24             	add    $0x24,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    

00801c57 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c62:	b8 08 00 00 00       	mov    $0x8,%eax
  801c67:	e8 67 fd ff ff       	call   8019d3 <fsipc>
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    
  801c6e:	66 90                	xchg   %ax,%ax

00801c70 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	57                   	push   %edi
  801c74:	56                   	push   %esi
  801c75:	53                   	push   %ebx
  801c76:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801c7c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c83:	00 
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	89 04 24             	mov    %eax,(%esp)
  801c8a:	e8 44 ff ff ff       	call   801bd3 <open>
  801c8f:	89 c2                	mov    %eax,%edx
  801c91:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801c97:	85 c0                	test   %eax,%eax
  801c99:	0f 88 0f 05 00 00    	js     8021ae <spawn+0x53e>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801c9f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801ca6:	00 
  801ca7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb1:	89 14 24             	mov    %edx,(%esp)
  801cb4:	e8 d3 fa ff ff       	call   80178c <readn>
  801cb9:	3d 00 02 00 00       	cmp    $0x200,%eax
  801cbe:	75 0c                	jne    801ccc <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801cc0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801cc7:	45 4c 46 
  801cca:	74 36                	je     801d02 <spawn+0x92>
		close(fd);
  801ccc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801cd2:	89 04 24             	mov    %eax,(%esp)
  801cd5:	e8 bd f8 ff ff       	call   801597 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801cda:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801ce1:	46 
  801ce2:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cec:	c7 04 24 ff 37 80 00 	movl   $0x8037ff,(%esp)
  801cf3:	e8 23 e6 ff ff       	call   80031b <cprintf>
		return -E_NOT_EXEC;
  801cf8:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801cfd:	e9 0b 05 00 00       	jmp    80220d <spawn+0x59d>
  801d02:	b8 07 00 00 00       	mov    $0x7,%eax
  801d07:	cd 30                	int    $0x30
  801d09:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801d0f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801d15:	85 c0                	test   %eax,%eax
  801d17:	0f 88 99 04 00 00    	js     8021b6 <spawn+0x546>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801d1d:	89 c6                	mov    %eax,%esi
  801d1f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801d25:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801d28:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801d2e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801d34:	b9 11 00 00 00       	mov    $0x11,%ecx
  801d39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801d3b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801d41:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d47:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801d4c:	be 00 00 00 00       	mov    $0x0,%esi
  801d51:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d54:	eb 0f                	jmp    801d65 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801d56:	89 04 24             	mov    %eax,(%esp)
  801d59:	e8 b2 eb ff ff       	call   800910 <strlen>
  801d5e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801d62:	83 c3 01             	add    $0x1,%ebx
  801d65:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801d6c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801d6f:	85 c0                	test   %eax,%eax
  801d71:	75 e3                	jne    801d56 <spawn+0xe6>
  801d73:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801d79:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801d7f:	bf 00 10 40 00       	mov    $0x401000,%edi
  801d84:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801d86:	89 fa                	mov    %edi,%edx
  801d88:	83 e2 fc             	and    $0xfffffffc,%edx
  801d8b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801d92:	29 c2                	sub    %eax,%edx
  801d94:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801d9a:	8d 42 f8             	lea    -0x8(%edx),%eax
  801d9d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801da2:	0f 86 1e 04 00 00    	jbe    8021c6 <spawn+0x556>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801da8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801daf:	00 
  801db0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801db7:	00 
  801db8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dbf:	e8 9f ef ff ff       	call   800d63 <sys_page_alloc>
  801dc4:	85 c0                	test   %eax,%eax
  801dc6:	0f 88 41 04 00 00    	js     80220d <spawn+0x59d>
  801dcc:	be 00 00 00 00       	mov    $0x0,%esi
  801dd1:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801dd7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801dda:	eb 30                	jmp    801e0c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801ddc:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801de2:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801de8:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801deb:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801dee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df2:	89 3c 24             	mov    %edi,(%esp)
  801df5:	e8 4d eb ff ff       	call   800947 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801dfa:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801dfd:	89 04 24             	mov    %eax,(%esp)
  801e00:	e8 0b eb ff ff       	call   800910 <strlen>
  801e05:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801e09:	83 c6 01             	add    $0x1,%esi
  801e0c:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801e12:	7f c8                	jg     801ddc <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801e14:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801e1a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801e20:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801e27:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801e2d:	74 24                	je     801e53 <spawn+0x1e3>
  801e2f:	c7 44 24 0c 74 38 80 	movl   $0x803874,0xc(%esp)
  801e36:	00 
  801e37:	c7 44 24 08 d3 37 80 	movl   $0x8037d3,0x8(%esp)
  801e3e:	00 
  801e3f:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  801e46:	00 
  801e47:	c7 04 24 19 38 80 00 	movl   $0x803819,(%esp)
  801e4e:	e8 cf e3 ff ff       	call   800222 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801e53:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801e59:	89 c8                	mov    %ecx,%eax
  801e5b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801e60:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801e63:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801e69:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801e6c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801e72:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801e78:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801e7f:	00 
  801e80:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801e87:	ee 
  801e88:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801e8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e92:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e99:	00 
  801e9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ea1:	e8 11 ef ff ff       	call   800db7 <sys_page_map>
  801ea6:	89 c3                	mov    %eax,%ebx
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	0f 88 47 03 00 00    	js     8021f7 <spawn+0x587>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801eb0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801eb7:	00 
  801eb8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ebf:	e8 46 ef ff ff       	call   800e0a <sys_page_unmap>
  801ec4:	89 c3                	mov    %eax,%ebx
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	0f 88 29 03 00 00    	js     8021f7 <spawn+0x587>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801ece:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801ed4:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801edb:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801ee1:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801ee8:	00 00 00 
  801eeb:	e9 b6 01 00 00       	jmp    8020a6 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801ef0:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801ef6:	83 38 01             	cmpl   $0x1,(%eax)
  801ef9:	0f 85 99 01 00 00    	jne    802098 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801eff:	89 c2                	mov    %eax,%edx
  801f01:	8b 40 18             	mov    0x18(%eax),%eax
  801f04:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801f07:	83 f8 01             	cmp    $0x1,%eax
  801f0a:	19 c0                	sbb    %eax,%eax
  801f0c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801f12:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801f19:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801f20:	89 d0                	mov    %edx,%eax
  801f22:	8b 7a 04             	mov    0x4(%edx),%edi
  801f25:	89 bd 80 fd ff ff    	mov    %edi,-0x280(%ebp)
  801f2b:	8b 52 10             	mov    0x10(%edx),%edx
  801f2e:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801f34:	8b 78 14             	mov    0x14(%eax),%edi
  801f37:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  801f3d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801f40:	89 f0                	mov    %esi,%eax
  801f42:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f47:	74 14                	je     801f5d <spawn+0x2ed>
		va -= i;
  801f49:	29 c6                	sub    %eax,%esi
		memsz += i;
  801f4b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801f51:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801f57:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801f5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f62:	e9 23 01 00 00       	jmp    80208a <spawn+0x41a>
		if (i >= filesz) {
  801f67:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801f6d:	77 2b                	ja     801f9a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801f6f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f75:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f79:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f7d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f83:	89 04 24             	mov    %eax,(%esp)
  801f86:	e8 d8 ed ff ff       	call   800d63 <sys_page_alloc>
  801f8b:	85 c0                	test   %eax,%eax
  801f8d:	0f 89 eb 00 00 00    	jns    80207e <spawn+0x40e>
  801f93:	89 c3                	mov    %eax,%ebx
  801f95:	e9 3d 02 00 00       	jmp    8021d7 <spawn+0x567>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f9a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801fa1:	00 
  801fa2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801fa9:	00 
  801faa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb1:	e8 ad ed ff ff       	call   800d63 <sys_page_alloc>
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	0f 88 0f 02 00 00    	js     8021cd <spawn+0x55d>
  801fbe:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801fc4:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fca:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801fd0:	89 04 24             	mov    %eax,(%esp)
  801fd3:	e8 8c f8 ff ff       	call   801864 <seek>
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	0f 88 f1 01 00 00    	js     8021d1 <spawn+0x561>
  801fe0:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801fe6:	29 f9                	sub    %edi,%ecx
  801fe8:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801fea:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801ff0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ff5:	0f 47 c1             	cmova  %ecx,%eax
  801ff8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ffc:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802003:	00 
  802004:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80200a:	89 04 24             	mov    %eax,(%esp)
  80200d:	e8 7a f7 ff ff       	call   80178c <readn>
  802012:	85 c0                	test   %eax,%eax
  802014:	0f 88 bb 01 00 00    	js     8021d5 <spawn+0x565>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80201a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802020:	89 44 24 10          	mov    %eax,0x10(%esp)
  802024:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802028:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80202e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802032:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802039:	00 
  80203a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802041:	e8 71 ed ff ff       	call   800db7 <sys_page_map>
  802046:	85 c0                	test   %eax,%eax
  802048:	79 20                	jns    80206a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  80204a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80204e:	c7 44 24 08 25 38 80 	movl   $0x803825,0x8(%esp)
  802055:	00 
  802056:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  80205d:	00 
  80205e:	c7 04 24 19 38 80 00 	movl   $0x803819,(%esp)
  802065:	e8 b8 e1 ff ff       	call   800222 <_panic>
			sys_page_unmap(0, UTEMP);
  80206a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802071:	00 
  802072:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802079:	e8 8c ed ff ff       	call   800e0a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80207e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802084:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80208a:	89 df                	mov    %ebx,%edi
  80208c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  802092:	0f 87 cf fe ff ff    	ja     801f67 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802098:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  80209f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  8020a6:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8020ad:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  8020b3:	0f 8c 37 fe ff ff    	jl     801ef0 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8020b9:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020bf:	89 04 24             	mov    %eax,(%esp)
  8020c2:	e8 d0 f4 ff ff       	call   801597 <close>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  8020c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020cc:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	{
		if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U))&&((uvpt[i/PGSIZE]&(PTE_SHARE))==PTE_SHARE))
  8020d2:	89 d8                	mov    %ebx,%eax
  8020d4:	c1 e8 16             	shr    $0x16,%eax
  8020d7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020de:	a8 01                	test   $0x1,%al
  8020e0:	74 48                	je     80212a <spawn+0x4ba>
  8020e2:	89 d8                	mov    %ebx,%eax
  8020e4:	c1 e8 0c             	shr    $0xc,%eax
  8020e7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8020ee:	83 e2 05             	and    $0x5,%edx
  8020f1:	83 fa 05             	cmp    $0x5,%edx
  8020f4:	75 34                	jne    80212a <spawn+0x4ba>
  8020f6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8020fd:	f6 c6 04             	test   $0x4,%dh
  802100:	74 28                	je     80212a <spawn+0x4ba>
		{
			//cprintf("in copy_shared_pages\n");
			//cprintf("%08x\n",PDX(i));
			sys_page_map(0,(void*)i,child,(void*)i,uvpt[i/PGSIZE]&PTE_SYSCALL);
  802102:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802109:	25 07 0e 00 00       	and    $0xe07,%eax
  80210e:	89 44 24 10          	mov    %eax,0x10(%esp)
  802112:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802116:	89 74 24 08          	mov    %esi,0x8(%esp)
  80211a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80211e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802125:	e8 8d ec ff ff       	call   800db7 <sys_page_map>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  80212a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802130:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  802136:	75 9a                	jne    8020d2 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802138:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80213e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802142:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802148:	89 04 24             	mov    %eax,(%esp)
  80214b:	e8 60 ed ff ff       	call   800eb0 <sys_env_set_trapframe>
  802150:	85 c0                	test   %eax,%eax
  802152:	79 20                	jns    802174 <spawn+0x504>
		panic("sys_env_set_trapframe: %e", r);
  802154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802158:	c7 44 24 08 42 38 80 	movl   $0x803842,0x8(%esp)
  80215f:	00 
  802160:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802167:	00 
  802168:	c7 04 24 19 38 80 00 	movl   $0x803819,(%esp)
  80216f:	e8 ae e0 ff ff       	call   800222 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802174:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80217b:	00 
  80217c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802182:	89 04 24             	mov    %eax,(%esp)
  802185:	e8 d3 ec ff ff       	call   800e5d <sys_env_set_status>
  80218a:	85 c0                	test   %eax,%eax
  80218c:	79 30                	jns    8021be <spawn+0x54e>
		panic("sys_env_set_status: %e", r);
  80218e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802192:	c7 44 24 08 5c 38 80 	movl   $0x80385c,0x8(%esp)
  802199:	00 
  80219a:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  8021a1:	00 
  8021a2:	c7 04 24 19 38 80 00 	movl   $0x803819,(%esp)
  8021a9:	e8 74 e0 ff ff       	call   800222 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8021ae:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8021b4:	eb 57                	jmp    80220d <spawn+0x59d>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8021b6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021bc:	eb 4f                	jmp    80220d <spawn+0x59d>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  8021be:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021c4:	eb 47                	jmp    80220d <spawn+0x59d>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8021c6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8021cb:	eb 40                	jmp    80220d <spawn+0x59d>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8021cd:	89 c3                	mov    %eax,%ebx
  8021cf:	eb 06                	jmp    8021d7 <spawn+0x567>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8021d1:	89 c3                	mov    %eax,%ebx
  8021d3:	eb 02                	jmp    8021d7 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8021d5:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8021d7:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8021dd:	89 04 24             	mov    %eax,(%esp)
  8021e0:	e8 ee ea ff ff       	call   800cd3 <sys_env_destroy>
	close(fd);
  8021e5:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8021eb:	89 04 24             	mov    %eax,(%esp)
  8021ee:	e8 a4 f3 ff ff       	call   801597 <close>
	return r;
  8021f3:	89 d8                	mov    %ebx,%eax
  8021f5:	eb 16                	jmp    80220d <spawn+0x59d>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8021f7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021fe:	00 
  8021ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802206:	e8 ff eb ff ff       	call   800e0a <sys_page_unmap>
  80220b:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80220d:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802213:	5b                   	pop    %ebx
  802214:	5e                   	pop    %esi
  802215:	5f                   	pop    %edi
  802216:	5d                   	pop    %ebp
  802217:	c3                   	ret    

00802218 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	56                   	push   %esi
  80221c:	53                   	push   %ebx
  80221d:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802220:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802223:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802228:	eb 03                	jmp    80222d <spawnl+0x15>
		argc++;
  80222a:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80222d:	83 c0 04             	add    $0x4,%eax
  802230:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802234:	75 f4                	jne    80222a <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802236:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  80223d:	83 e0 f0             	and    $0xfffffff0,%eax
  802240:	29 c4                	sub    %eax,%esp
  802242:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802246:	c1 e8 02             	shr    $0x2,%eax
  802249:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  802250:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802252:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802255:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  80225c:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  802263:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802264:	b8 00 00 00 00       	mov    $0x0,%eax
  802269:	eb 0a                	jmp    802275 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  80226b:	83 c0 01             	add    $0x1,%eax
  80226e:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802272:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802275:	39 d0                	cmp    %edx,%eax
  802277:	75 f2                	jne    80226b <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802279:	89 74 24 04          	mov    %esi,0x4(%esp)
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	89 04 24             	mov    %eax,(%esp)
  802283:	e8 e8 f9 ff ff       	call   801c70 <spawn>
}
  802288:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80228b:	5b                   	pop    %ebx
  80228c:	5e                   	pop    %esi
  80228d:	5d                   	pop    %ebp
  80228e:	c3                   	ret    
  80228f:	90                   	nop

00802290 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802296:	c7 44 24 04 9a 38 80 	movl   $0x80389a,0x4(%esp)
  80229d:	00 
  80229e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a1:	89 04 24             	mov    %eax,(%esp)
  8022a4:	e8 9e e6 ff ff       	call   800947 <strcpy>
	return 0;
}
  8022a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ae:	c9                   	leave  
  8022af:	c3                   	ret    

008022b0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 14             	sub    $0x14,%esp
  8022b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8022ba:	89 1c 24             	mov    %ebx,(%esp)
  8022bd:	e8 fc 0b 00 00       	call   802ebe <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8022c2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8022c7:	83 f8 01             	cmp    $0x1,%eax
  8022ca:	75 0d                	jne    8022d9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8022cc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8022cf:	89 04 24             	mov    %eax,(%esp)
  8022d2:	e8 29 03 00 00       	call   802600 <nsipc_close>
  8022d7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8022d9:	89 d0                	mov    %edx,%eax
  8022db:	83 c4 14             	add    $0x14,%esp
  8022de:	5b                   	pop    %ebx
  8022df:	5d                   	pop    %ebp
  8022e0:	c3                   	ret    

008022e1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8022e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022ee:	00 
  8022ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	8b 40 0c             	mov    0xc(%eax),%eax
  802303:	89 04 24             	mov    %eax,(%esp)
  802306:	e8 f0 03 00 00       	call   8026fb <nsipc_send>
}
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802313:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80231a:	00 
  80231b:	8b 45 10             	mov    0x10(%ebp),%eax
  80231e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802322:	8b 45 0c             	mov    0xc(%ebp),%eax
  802325:	89 44 24 04          	mov    %eax,0x4(%esp)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	8b 40 0c             	mov    0xc(%eax),%eax
  80232f:	89 04 24             	mov    %eax,(%esp)
  802332:	e8 44 03 00 00       	call   80267b <nsipc_recv>
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
  80233c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80233f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802342:	89 54 24 04          	mov    %edx,0x4(%esp)
  802346:	89 04 24             	mov    %eax,(%esp)
  802349:	e8 18 f1 ff ff       	call   801466 <fd_lookup>
  80234e:	85 c0                	test   %eax,%eax
  802350:	78 17                	js     802369 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802355:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  80235b:	39 08                	cmp    %ecx,(%eax)
  80235d:	75 05                	jne    802364 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80235f:	8b 40 0c             	mov    0xc(%eax),%eax
  802362:	eb 05                	jmp    802369 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802364:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	56                   	push   %esi
  80236f:	53                   	push   %ebx
  802370:	83 ec 20             	sub    $0x20,%esp
  802373:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802375:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802378:	89 04 24             	mov    %eax,(%esp)
  80237b:	e8 97 f0 ff ff       	call   801417 <fd_alloc>
  802380:	89 c3                	mov    %eax,%ebx
  802382:	85 c0                	test   %eax,%eax
  802384:	78 21                	js     8023a7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802386:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80238d:	00 
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	89 44 24 04          	mov    %eax,0x4(%esp)
  802395:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80239c:	e8 c2 e9 ff ff       	call   800d63 <sys_page_alloc>
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	79 0c                	jns    8023b3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8023a7:	89 34 24             	mov    %esi,(%esp)
  8023aa:	e8 51 02 00 00       	call   802600 <nsipc_close>
		return r;
  8023af:	89 d8                	mov    %ebx,%eax
  8023b1:	eb 20                	jmp    8023d3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8023b3:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8023be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8023c8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8023cb:	89 14 24             	mov    %edx,(%esp)
  8023ce:	e8 1d f0 ff ff       	call   8013f0 <fd2num>
}
  8023d3:	83 c4 20             	add    $0x20,%esp
  8023d6:	5b                   	pop    %ebx
  8023d7:	5e                   	pop    %esi
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    

008023da <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023da:	55                   	push   %ebp
  8023db:	89 e5                	mov    %esp,%ebp
  8023dd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	e8 51 ff ff ff       	call   802339 <fd2sockid>
		return r;
  8023e8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	78 23                	js     802411 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8023ee:	8b 55 10             	mov    0x10(%ebp),%edx
  8023f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023fc:	89 04 24             	mov    %eax,(%esp)
  8023ff:	e8 45 01 00 00       	call   802549 <nsipc_accept>
		return r;
  802404:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802406:	85 c0                	test   %eax,%eax
  802408:	78 07                	js     802411 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80240a:	e8 5c ff ff ff       	call   80236b <alloc_sockfd>
  80240f:	89 c1                	mov    %eax,%ecx
}
  802411:	89 c8                	mov    %ecx,%eax
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	e8 16 ff ff ff       	call   802339 <fd2sockid>
  802423:	89 c2                	mov    %eax,%edx
  802425:	85 d2                	test   %edx,%edx
  802427:	78 16                	js     80243f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802429:	8b 45 10             	mov    0x10(%ebp),%eax
  80242c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802430:	8b 45 0c             	mov    0xc(%ebp),%eax
  802433:	89 44 24 04          	mov    %eax,0x4(%esp)
  802437:	89 14 24             	mov    %edx,(%esp)
  80243a:	e8 60 01 00 00       	call   80259f <nsipc_bind>
}
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <shutdown>:

int
shutdown(int s, int how)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	e8 ea fe ff ff       	call   802339 <fd2sockid>
  80244f:	89 c2                	mov    %eax,%edx
  802451:	85 d2                	test   %edx,%edx
  802453:	78 0f                	js     802464 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802455:	8b 45 0c             	mov    0xc(%ebp),%eax
  802458:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245c:	89 14 24             	mov    %edx,(%esp)
  80245f:	e8 7a 01 00 00       	call   8025de <nsipc_shutdown>
}
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	e8 c5 fe ff ff       	call   802339 <fd2sockid>
  802474:	89 c2                	mov    %eax,%edx
  802476:	85 d2                	test   %edx,%edx
  802478:	78 16                	js     802490 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80247a:	8b 45 10             	mov    0x10(%ebp),%eax
  80247d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802481:	8b 45 0c             	mov    0xc(%ebp),%eax
  802484:	89 44 24 04          	mov    %eax,0x4(%esp)
  802488:	89 14 24             	mov    %edx,(%esp)
  80248b:	e8 8a 01 00 00       	call   80261a <nsipc_connect>
}
  802490:	c9                   	leave  
  802491:	c3                   	ret    

00802492 <listen>:

int
listen(int s, int backlog)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	e8 99 fe ff ff       	call   802339 <fd2sockid>
  8024a0:	89 c2                	mov    %eax,%edx
  8024a2:	85 d2                	test   %edx,%edx
  8024a4:	78 0f                	js     8024b5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8024a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ad:	89 14 24             	mov    %edx,(%esp)
  8024b0:	e8 a4 01 00 00       	call   802659 <nsipc_listen>
}
  8024b5:	c9                   	leave  
  8024b6:	c3                   	ret    

008024b7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8024b7:	55                   	push   %ebp
  8024b8:	89 e5                	mov    %esp,%ebp
  8024ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8024bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	89 04 24             	mov    %eax,(%esp)
  8024d1:	e8 98 02 00 00       	call   80276e <nsipc_socket>
  8024d6:	89 c2                	mov    %eax,%edx
  8024d8:	85 d2                	test   %edx,%edx
  8024da:	78 05                	js     8024e1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8024dc:	e8 8a fe ff ff       	call   80236b <alloc_sockfd>
}
  8024e1:	c9                   	leave  
  8024e2:	c3                   	ret    

008024e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	53                   	push   %ebx
  8024e7:	83 ec 14             	sub    $0x14,%esp
  8024ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8024ec:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8024f3:	75 11                	jne    802506 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8024f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8024fc:	e8 85 09 00 00       	call   802e86 <ipc_find_env>
  802501:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802506:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80250d:	00 
  80250e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802515:	00 
  802516:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80251a:	a1 04 50 80 00       	mov    0x805004,%eax
  80251f:	89 04 24             	mov    %eax,(%esp)
  802522:	e8 01 09 00 00       	call   802e28 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802527:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80252e:	00 
  80252f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802536:	00 
  802537:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80253e:	e8 7b 08 00 00       	call   802dbe <ipc_recv>
}
  802543:	83 c4 14             	add    $0x14,%esp
  802546:	5b                   	pop    %ebx
  802547:	5d                   	pop    %ebp
  802548:	c3                   	ret    

00802549 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
  80254c:	56                   	push   %esi
  80254d:	53                   	push   %ebx
  80254e:	83 ec 10             	sub    $0x10,%esp
  802551:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80255c:	8b 06                	mov    (%esi),%eax
  80255e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802563:	b8 01 00 00 00       	mov    $0x1,%eax
  802568:	e8 76 ff ff ff       	call   8024e3 <nsipc>
  80256d:	89 c3                	mov    %eax,%ebx
  80256f:	85 c0                	test   %eax,%eax
  802571:	78 23                	js     802596 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802573:	a1 10 70 80 00       	mov    0x807010,%eax
  802578:	89 44 24 08          	mov    %eax,0x8(%esp)
  80257c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802583:	00 
  802584:	8b 45 0c             	mov    0xc(%ebp),%eax
  802587:	89 04 24             	mov    %eax,(%esp)
  80258a:	e8 55 e5 ff ff       	call   800ae4 <memmove>
		*addrlen = ret->ret_addrlen;
  80258f:	a1 10 70 80 00       	mov    0x807010,%eax
  802594:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802596:	89 d8                	mov    %ebx,%eax
  802598:	83 c4 10             	add    $0x10,%esp
  80259b:	5b                   	pop    %ebx
  80259c:	5e                   	pop    %esi
  80259d:	5d                   	pop    %ebp
  80259e:	c3                   	ret    

0080259f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	53                   	push   %ebx
  8025a3:	83 ec 14             	sub    $0x14,%esp
  8025a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8025a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ac:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8025b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025bc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8025c3:	e8 1c e5 ff ff       	call   800ae4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8025c8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8025ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8025d3:	e8 0b ff ff ff       	call   8024e3 <nsipc>
}
  8025d8:	83 c4 14             	add    $0x14,%esp
  8025db:	5b                   	pop    %ebx
  8025dc:	5d                   	pop    %ebp
  8025dd:	c3                   	ret    

008025de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
  8025e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8025ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8025f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8025f9:	e8 e5 fe ff ff       	call   8024e3 <nsipc>
}
  8025fe:	c9                   	leave  
  8025ff:	c3                   	ret    

00802600 <nsipc_close>:

int
nsipc_close(int s)
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802606:	8b 45 08             	mov    0x8(%ebp),%eax
  802609:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80260e:	b8 04 00 00 00       	mov    $0x4,%eax
  802613:	e8 cb fe ff ff       	call   8024e3 <nsipc>
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
  80261d:	53                   	push   %ebx
  80261e:	83 ec 14             	sub    $0x14,%esp
  802621:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802624:	8b 45 08             	mov    0x8(%ebp),%eax
  802627:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80262c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802630:	8b 45 0c             	mov    0xc(%ebp),%eax
  802633:	89 44 24 04          	mov    %eax,0x4(%esp)
  802637:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80263e:	e8 a1 e4 ff ff       	call   800ae4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802643:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802649:	b8 05 00 00 00       	mov    $0x5,%eax
  80264e:	e8 90 fe ff ff       	call   8024e3 <nsipc>
}
  802653:	83 c4 14             	add    $0x14,%esp
  802656:	5b                   	pop    %ebx
  802657:	5d                   	pop    %ebp
  802658:	c3                   	ret    

00802659 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802659:	55                   	push   %ebp
  80265a:	89 e5                	mov    %esp,%ebp
  80265c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80265f:	8b 45 08             	mov    0x8(%ebp),%eax
  802662:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802667:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80266f:	b8 06 00 00 00       	mov    $0x6,%eax
  802674:	e8 6a fe ff ff       	call   8024e3 <nsipc>
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	56                   	push   %esi
  80267f:	53                   	push   %ebx
  802680:	83 ec 10             	sub    $0x10,%esp
  802683:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802686:	8b 45 08             	mov    0x8(%ebp),%eax
  802689:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80268e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802694:	8b 45 14             	mov    0x14(%ebp),%eax
  802697:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80269c:	b8 07 00 00 00       	mov    $0x7,%eax
  8026a1:	e8 3d fe ff ff       	call   8024e3 <nsipc>
  8026a6:	89 c3                	mov    %eax,%ebx
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	78 46                	js     8026f2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8026ac:	39 f0                	cmp    %esi,%eax
  8026ae:	7f 07                	jg     8026b7 <nsipc_recv+0x3c>
  8026b0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8026b5:	7e 24                	jle    8026db <nsipc_recv+0x60>
  8026b7:	c7 44 24 0c a6 38 80 	movl   $0x8038a6,0xc(%esp)
  8026be:	00 
  8026bf:	c7 44 24 08 d3 37 80 	movl   $0x8037d3,0x8(%esp)
  8026c6:	00 
  8026c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8026ce:	00 
  8026cf:	c7 04 24 bb 38 80 00 	movl   $0x8038bb,(%esp)
  8026d6:	e8 47 db ff ff       	call   800222 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8026db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026df:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8026e6:	00 
  8026e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ea:	89 04 24             	mov    %eax,(%esp)
  8026ed:	e8 f2 e3 ff ff       	call   800ae4 <memmove>
	}

	return r;
}
  8026f2:	89 d8                	mov    %ebx,%eax
  8026f4:	83 c4 10             	add    $0x10,%esp
  8026f7:	5b                   	pop    %ebx
  8026f8:	5e                   	pop    %esi
  8026f9:	5d                   	pop    %ebp
  8026fa:	c3                   	ret    

008026fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	53                   	push   %ebx
  8026ff:	83 ec 14             	sub    $0x14,%esp
  802702:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802705:	8b 45 08             	mov    0x8(%ebp),%eax
  802708:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80270d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802713:	7e 24                	jle    802739 <nsipc_send+0x3e>
  802715:	c7 44 24 0c c7 38 80 	movl   $0x8038c7,0xc(%esp)
  80271c:	00 
  80271d:	c7 44 24 08 d3 37 80 	movl   $0x8037d3,0x8(%esp)
  802724:	00 
  802725:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80272c:	00 
  80272d:	c7 04 24 bb 38 80 00 	movl   $0x8038bb,(%esp)
  802734:	e8 e9 da ff ff       	call   800222 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802739:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80273d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802740:	89 44 24 04          	mov    %eax,0x4(%esp)
  802744:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80274b:	e8 94 e3 ff ff       	call   800ae4 <memmove>
	nsipcbuf.send.req_size = size;
  802750:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802756:	8b 45 14             	mov    0x14(%ebp),%eax
  802759:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80275e:	b8 08 00 00 00       	mov    $0x8,%eax
  802763:	e8 7b fd ff ff       	call   8024e3 <nsipc>
}
  802768:	83 c4 14             	add    $0x14,%esp
  80276b:	5b                   	pop    %ebx
  80276c:	5d                   	pop    %ebp
  80276d:	c3                   	ret    

0080276e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80277c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802784:	8b 45 10             	mov    0x10(%ebp),%eax
  802787:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80278c:	b8 09 00 00 00       	mov    $0x9,%eax
  802791:	e8 4d fd ff ff       	call   8024e3 <nsipc>
}
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	56                   	push   %esi
  80279c:	53                   	push   %ebx
  80279d:	83 ec 10             	sub    $0x10,%esp
  8027a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	89 04 24             	mov    %eax,(%esp)
  8027a9:	e8 52 ec ff ff       	call   801400 <fd2data>
  8027ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8027b0:	c7 44 24 04 d3 38 80 	movl   $0x8038d3,0x4(%esp)
  8027b7:	00 
  8027b8:	89 1c 24             	mov    %ebx,(%esp)
  8027bb:	e8 87 e1 ff ff       	call   800947 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8027c0:	8b 46 04             	mov    0x4(%esi),%eax
  8027c3:	2b 06                	sub    (%esi),%eax
  8027c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8027cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8027d2:	00 00 00 
	stat->st_dev = &devpipe;
  8027d5:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  8027dc:	40 80 00 
	return 0;
}
  8027df:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e4:	83 c4 10             	add    $0x10,%esp
  8027e7:	5b                   	pop    %ebx
  8027e8:	5e                   	pop    %esi
  8027e9:	5d                   	pop    %ebp
  8027ea:	c3                   	ret    

008027eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
  8027ee:	53                   	push   %ebx
  8027ef:	83 ec 14             	sub    $0x14,%esp
  8027f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8027f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802800:	e8 05 e6 ff ff       	call   800e0a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802805:	89 1c 24             	mov    %ebx,(%esp)
  802808:	e8 f3 eb ff ff       	call   801400 <fd2data>
  80280d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802811:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802818:	e8 ed e5 ff ff       	call   800e0a <sys_page_unmap>
}
  80281d:	83 c4 14             	add    $0x14,%esp
  802820:	5b                   	pop    %ebx
  802821:	5d                   	pop    %ebp
  802822:	c3                   	ret    

00802823 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
  802826:	57                   	push   %edi
  802827:	56                   	push   %esi
  802828:	53                   	push   %ebx
  802829:	83 ec 2c             	sub    $0x2c,%esp
  80282c:	89 c6                	mov    %eax,%esi
  80282e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802831:	a1 08 50 80 00       	mov    0x805008,%eax
  802836:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802839:	89 34 24             	mov    %esi,(%esp)
  80283c:	e8 7d 06 00 00       	call   802ebe <pageref>
  802841:	89 c7                	mov    %eax,%edi
  802843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802846:	89 04 24             	mov    %eax,(%esp)
  802849:	e8 70 06 00 00       	call   802ebe <pageref>
  80284e:	39 c7                	cmp    %eax,%edi
  802850:	0f 94 c2             	sete   %dl
  802853:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802856:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80285c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80285f:	39 fb                	cmp    %edi,%ebx
  802861:	74 21                	je     802884 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802863:	84 d2                	test   %dl,%dl
  802865:	74 ca                	je     802831 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802867:	8b 51 58             	mov    0x58(%ecx),%edx
  80286a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80286e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802872:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802876:	c7 04 24 da 38 80 00 	movl   $0x8038da,(%esp)
  80287d:	e8 99 da ff ff       	call   80031b <cprintf>
  802882:	eb ad                	jmp    802831 <_pipeisclosed+0xe>
	}
}
  802884:	83 c4 2c             	add    $0x2c,%esp
  802887:	5b                   	pop    %ebx
  802888:	5e                   	pop    %esi
  802889:	5f                   	pop    %edi
  80288a:	5d                   	pop    %ebp
  80288b:	c3                   	ret    

0080288c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80288c:	55                   	push   %ebp
  80288d:	89 e5                	mov    %esp,%ebp
  80288f:	57                   	push   %edi
  802890:	56                   	push   %esi
  802891:	53                   	push   %ebx
  802892:	83 ec 1c             	sub    $0x1c,%esp
  802895:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802898:	89 34 24             	mov    %esi,(%esp)
  80289b:	e8 60 eb ff ff       	call   801400 <fd2data>
  8028a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8028a7:	eb 45                	jmp    8028ee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8028a9:	89 da                	mov    %ebx,%edx
  8028ab:	89 f0                	mov    %esi,%eax
  8028ad:	e8 71 ff ff ff       	call   802823 <_pipeisclosed>
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	75 41                	jne    8028f7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8028b6:	e8 89 e4 ff ff       	call   800d44 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8028bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8028be:	8b 0b                	mov    (%ebx),%ecx
  8028c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8028c3:	39 d0                	cmp    %edx,%eax
  8028c5:	73 e2                	jae    8028a9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8028c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8028ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8028d1:	99                   	cltd   
  8028d2:	c1 ea 1b             	shr    $0x1b,%edx
  8028d5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8028d8:	83 e1 1f             	and    $0x1f,%ecx
  8028db:	29 d1                	sub    %edx,%ecx
  8028dd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8028e1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8028e5:	83 c0 01             	add    $0x1,%eax
  8028e8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028eb:	83 c7 01             	add    $0x1,%edi
  8028ee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8028f1:	75 c8                	jne    8028bb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8028f3:	89 f8                	mov    %edi,%eax
  8028f5:	eb 05                	jmp    8028fc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8028f7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8028fc:	83 c4 1c             	add    $0x1c,%esp
  8028ff:	5b                   	pop    %ebx
  802900:	5e                   	pop    %esi
  802901:	5f                   	pop    %edi
  802902:	5d                   	pop    %ebp
  802903:	c3                   	ret    

00802904 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802904:	55                   	push   %ebp
  802905:	89 e5                	mov    %esp,%ebp
  802907:	57                   	push   %edi
  802908:	56                   	push   %esi
  802909:	53                   	push   %ebx
  80290a:	83 ec 1c             	sub    $0x1c,%esp
  80290d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802910:	89 3c 24             	mov    %edi,(%esp)
  802913:	e8 e8 ea ff ff       	call   801400 <fd2data>
  802918:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80291a:	be 00 00 00 00       	mov    $0x0,%esi
  80291f:	eb 3d                	jmp    80295e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802921:	85 f6                	test   %esi,%esi
  802923:	74 04                	je     802929 <devpipe_read+0x25>
				return i;
  802925:	89 f0                	mov    %esi,%eax
  802927:	eb 43                	jmp    80296c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802929:	89 da                	mov    %ebx,%edx
  80292b:	89 f8                	mov    %edi,%eax
  80292d:	e8 f1 fe ff ff       	call   802823 <_pipeisclosed>
  802932:	85 c0                	test   %eax,%eax
  802934:	75 31                	jne    802967 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802936:	e8 09 e4 ff ff       	call   800d44 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80293b:	8b 03                	mov    (%ebx),%eax
  80293d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802940:	74 df                	je     802921 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802942:	99                   	cltd   
  802943:	c1 ea 1b             	shr    $0x1b,%edx
  802946:	01 d0                	add    %edx,%eax
  802948:	83 e0 1f             	and    $0x1f,%eax
  80294b:	29 d0                	sub    %edx,%eax
  80294d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802952:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802955:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802958:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80295b:	83 c6 01             	add    $0x1,%esi
  80295e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802961:	75 d8                	jne    80293b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802963:	89 f0                	mov    %esi,%eax
  802965:	eb 05                	jmp    80296c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80296c:	83 c4 1c             	add    $0x1c,%esp
  80296f:	5b                   	pop    %ebx
  802970:	5e                   	pop    %esi
  802971:	5f                   	pop    %edi
  802972:	5d                   	pop    %ebp
  802973:	c3                   	ret    

00802974 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802974:	55                   	push   %ebp
  802975:	89 e5                	mov    %esp,%ebp
  802977:	56                   	push   %esi
  802978:	53                   	push   %ebx
  802979:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80297c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80297f:	89 04 24             	mov    %eax,(%esp)
  802982:	e8 90 ea ff ff       	call   801417 <fd_alloc>
  802987:	89 c2                	mov    %eax,%edx
  802989:	85 d2                	test   %edx,%edx
  80298b:	0f 88 4d 01 00 00    	js     802ade <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802991:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802998:	00 
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a7:	e8 b7 e3 ff ff       	call   800d63 <sys_page_alloc>
  8029ac:	89 c2                	mov    %eax,%edx
  8029ae:	85 d2                	test   %edx,%edx
  8029b0:	0f 88 28 01 00 00    	js     802ade <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8029b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8029b9:	89 04 24             	mov    %eax,(%esp)
  8029bc:	e8 56 ea ff ff       	call   801417 <fd_alloc>
  8029c1:	89 c3                	mov    %eax,%ebx
  8029c3:	85 c0                	test   %eax,%eax
  8029c5:	0f 88 fe 00 00 00    	js     802ac9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029d2:	00 
  8029d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029e1:	e8 7d e3 ff ff       	call   800d63 <sys_page_alloc>
  8029e6:	89 c3                	mov    %eax,%ebx
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	0f 88 d9 00 00 00    	js     802ac9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	89 04 24             	mov    %eax,(%esp)
  8029f6:	e8 05 ea ff ff       	call   801400 <fd2data>
  8029fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029fd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a04:	00 
  802a05:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a10:	e8 4e e3 ff ff       	call   800d63 <sys_page_alloc>
  802a15:	89 c3                	mov    %eax,%ebx
  802a17:	85 c0                	test   %eax,%eax
  802a19:	0f 88 97 00 00 00    	js     802ab6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	89 04 24             	mov    %eax,(%esp)
  802a25:	e8 d6 e9 ff ff       	call   801400 <fd2data>
  802a2a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802a31:	00 
  802a32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a3d:	00 
  802a3e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a49:	e8 69 e3 ff ff       	call   800db7 <sys_page_map>
  802a4e:	89 c3                	mov    %eax,%ebx
  802a50:	85 c0                	test   %eax,%eax
  802a52:	78 52                	js     802aa6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802a54:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802a69:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a72:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a77:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	89 04 24             	mov    %eax,(%esp)
  802a84:	e8 67 e9 ff ff       	call   8013f0 <fd2num>
  802a89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a8c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a91:	89 04 24             	mov    %eax,(%esp)
  802a94:	e8 57 e9 ff ff       	call   8013f0 <fd2num>
  802a99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a9c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa4:	eb 38                	jmp    802ade <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802aa6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802aaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ab1:	e8 54 e3 ff ff       	call   800e0a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802abd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ac4:	e8 41 e3 ff ff       	call   800e0a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ad7:	e8 2e e3 ff ff       	call   800e0a <sys_page_unmap>
  802adc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802ade:	83 c4 30             	add    $0x30,%esp
  802ae1:	5b                   	pop    %ebx
  802ae2:	5e                   	pop    %esi
  802ae3:	5d                   	pop    %ebp
  802ae4:	c3                   	ret    

00802ae5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802ae5:	55                   	push   %ebp
  802ae6:	89 e5                	mov    %esp,%ebp
  802ae8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802aeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802aee:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	89 04 24             	mov    %eax,(%esp)
  802af8:	e8 69 e9 ff ff       	call   801466 <fd_lookup>
  802afd:	89 c2                	mov    %eax,%edx
  802aff:	85 d2                	test   %edx,%edx
  802b01:	78 15                	js     802b18 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b06:	89 04 24             	mov    %eax,(%esp)
  802b09:	e8 f2 e8 ff ff       	call   801400 <fd2data>
	return _pipeisclosed(fd, p);
  802b0e:	89 c2                	mov    %eax,%edx
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	e8 0b fd ff ff       	call   802823 <_pipeisclosed>
}
  802b18:	c9                   	leave  
  802b19:	c3                   	ret    

00802b1a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802b1a:	55                   	push   %ebp
  802b1b:	89 e5                	mov    %esp,%ebp
  802b1d:	56                   	push   %esi
  802b1e:	53                   	push   %ebx
  802b1f:	83 ec 10             	sub    $0x10,%esp
  802b22:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802b25:	85 f6                	test   %esi,%esi
  802b27:	75 24                	jne    802b4d <wait+0x33>
  802b29:	c7 44 24 0c f2 38 80 	movl   $0x8038f2,0xc(%esp)
  802b30:	00 
  802b31:	c7 44 24 08 d3 37 80 	movl   $0x8037d3,0x8(%esp)
  802b38:	00 
  802b39:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802b40:	00 
  802b41:	c7 04 24 fd 38 80 00 	movl   $0x8038fd,(%esp)
  802b48:	e8 d5 d6 ff ff       	call   800222 <_panic>
	e = &envs[ENVX(envid)];
  802b4d:	89 f3                	mov    %esi,%ebx
  802b4f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802b55:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802b58:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802b5e:	eb 05                	jmp    802b65 <wait+0x4b>
		sys_yield();
  802b60:	e8 df e1 ff ff       	call   800d44 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802b65:	8b 43 48             	mov    0x48(%ebx),%eax
  802b68:	39 f0                	cmp    %esi,%eax
  802b6a:	75 07                	jne    802b73 <wait+0x59>
  802b6c:	8b 43 54             	mov    0x54(%ebx),%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	75 ed                	jne    802b60 <wait+0x46>
		sys_yield();
}
  802b73:	83 c4 10             	add    $0x10,%esp
  802b76:	5b                   	pop    %ebx
  802b77:	5e                   	pop    %esi
  802b78:	5d                   	pop    %ebp
  802b79:	c3                   	ret    
  802b7a:	66 90                	xchg   %ax,%ax
  802b7c:	66 90                	xchg   %ax,%ax
  802b7e:	66 90                	xchg   %ax,%ax

00802b80 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802b80:	55                   	push   %ebp
  802b81:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802b83:	b8 00 00 00 00       	mov    $0x0,%eax
  802b88:	5d                   	pop    %ebp
  802b89:	c3                   	ret    

00802b8a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802b8a:	55                   	push   %ebp
  802b8b:	89 e5                	mov    %esp,%ebp
  802b8d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802b90:	c7 44 24 04 08 39 80 	movl   $0x803908,0x4(%esp)
  802b97:	00 
  802b98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b9b:	89 04 24             	mov    %eax,(%esp)
  802b9e:	e8 a4 dd ff ff       	call   800947 <strcpy>
	return 0;
}
  802ba3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba8:	c9                   	leave  
  802ba9:	c3                   	ret    

00802baa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802baa:	55                   	push   %ebp
  802bab:	89 e5                	mov    %esp,%ebp
  802bad:	57                   	push   %edi
  802bae:	56                   	push   %esi
  802baf:	53                   	push   %ebx
  802bb0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802bb6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802bbb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802bc1:	eb 31                	jmp    802bf4 <devcons_write+0x4a>
		m = n - tot;
  802bc3:	8b 75 10             	mov    0x10(%ebp),%esi
  802bc6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802bc8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802bcb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802bd0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802bd3:	89 74 24 08          	mov    %esi,0x8(%esp)
  802bd7:	03 45 0c             	add    0xc(%ebp),%eax
  802bda:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bde:	89 3c 24             	mov    %edi,(%esp)
  802be1:	e8 fe de ff ff       	call   800ae4 <memmove>
		sys_cputs(buf, m);
  802be6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bea:	89 3c 24             	mov    %edi,(%esp)
  802bed:	e8 a4 e0 ff ff       	call   800c96 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802bf2:	01 f3                	add    %esi,%ebx
  802bf4:	89 d8                	mov    %ebx,%eax
  802bf6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802bf9:	72 c8                	jb     802bc3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802bfb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802c01:	5b                   	pop    %ebx
  802c02:	5e                   	pop    %esi
  802c03:	5f                   	pop    %edi
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    

00802c06 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802c06:	55                   	push   %ebp
  802c07:	89 e5                	mov    %esp,%ebp
  802c09:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802c0c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802c11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802c15:	75 07                	jne    802c1e <devcons_read+0x18>
  802c17:	eb 2a                	jmp    802c43 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802c19:	e8 26 e1 ff ff       	call   800d44 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802c1e:	66 90                	xchg   %ax,%ax
  802c20:	e8 8f e0 ff ff       	call   800cb4 <sys_cgetc>
  802c25:	85 c0                	test   %eax,%eax
  802c27:	74 f0                	je     802c19 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	78 16                	js     802c43 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802c2d:	83 f8 04             	cmp    $0x4,%eax
  802c30:	74 0c                	je     802c3e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c35:	88 02                	mov    %al,(%edx)
	return 1;
  802c37:	b8 01 00 00 00       	mov    $0x1,%eax
  802c3c:	eb 05                	jmp    802c43 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802c3e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802c43:	c9                   	leave  
  802c44:	c3                   	ret    

00802c45 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802c45:	55                   	push   %ebp
  802c46:	89 e5                	mov    %esp,%ebp
  802c48:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802c51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802c58:	00 
  802c59:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802c5c:	89 04 24             	mov    %eax,(%esp)
  802c5f:	e8 32 e0 ff ff       	call   800c96 <sys_cputs>
}
  802c64:	c9                   	leave  
  802c65:	c3                   	ret    

00802c66 <getchar>:

int
getchar(void)
{
  802c66:	55                   	push   %ebp
  802c67:	89 e5                	mov    %esp,%ebp
  802c69:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802c6c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802c73:	00 
  802c74:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c7b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c82:	e8 73 ea ff ff       	call   8016fa <read>
	if (r < 0)
  802c87:	85 c0                	test   %eax,%eax
  802c89:	78 0f                	js     802c9a <getchar+0x34>
		return r;
	if (r < 1)
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	7e 06                	jle    802c95 <getchar+0x2f>
		return -E_EOF;
	return c;
  802c8f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802c93:	eb 05                	jmp    802c9a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802c95:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802c9a:	c9                   	leave  
  802c9b:	c3                   	ret    

00802c9c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802c9c:	55                   	push   %ebp
  802c9d:	89 e5                	mov    %esp,%ebp
  802c9f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ca2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	89 04 24             	mov    %eax,(%esp)
  802caf:	e8 b2 e7 ff ff       	call   801466 <fd_lookup>
  802cb4:	85 c0                	test   %eax,%eax
  802cb6:	78 11                	js     802cc9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802cc1:	39 10                	cmp    %edx,(%eax)
  802cc3:	0f 94 c0             	sete   %al
  802cc6:	0f b6 c0             	movzbl %al,%eax
}
  802cc9:	c9                   	leave  
  802cca:	c3                   	ret    

00802ccb <opencons>:

int
opencons(void)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
  802cce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802cd1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cd4:	89 04 24             	mov    %eax,(%esp)
  802cd7:	e8 3b e7 ff ff       	call   801417 <fd_alloc>
		return r;
  802cdc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802cde:	85 c0                	test   %eax,%eax
  802ce0:	78 40                	js     802d22 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802ce2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ce9:	00 
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cf1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cf8:	e8 66 e0 ff ff       	call   800d63 <sys_page_alloc>
		return r;
  802cfd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802cff:	85 c0                	test   %eax,%eax
  802d01:	78 1f                	js     802d22 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802d03:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802d18:	89 04 24             	mov    %eax,(%esp)
  802d1b:	e8 d0 e6 ff ff       	call   8013f0 <fd2num>
  802d20:	89 c2                	mov    %eax,%edx
}
  802d22:	89 d0                	mov    %edx,%eax
  802d24:	c9                   	leave  
  802d25:	c3                   	ret    

00802d26 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802d26:	55                   	push   %ebp
  802d27:	89 e5                	mov    %esp,%ebp
  802d29:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802d2c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802d33:	75 58                	jne    802d8d <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802d35:	a1 08 50 80 00       	mov    0x805008,%eax
  802d3a:	8b 40 48             	mov    0x48(%eax),%eax
  802d3d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802d44:	00 
  802d45:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802d4c:	ee 
  802d4d:	89 04 24             	mov    %eax,(%esp)
  802d50:	e8 0e e0 ff ff       	call   800d63 <sys_page_alloc>
		if(return_code!=0)
  802d55:	85 c0                	test   %eax,%eax
  802d57:	74 1c                	je     802d75 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802d59:	c7 44 24 08 14 39 80 	movl   $0x803914,0x8(%esp)
  802d60:	00 
  802d61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802d68:	00 
  802d69:	c7 04 24 70 39 80 00 	movl   $0x803970,(%esp)
  802d70:	e8 ad d4 ff ff       	call   800222 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802d75:	a1 08 50 80 00       	mov    0x805008,%eax
  802d7a:	8b 40 48             	mov    0x48(%eax),%eax
  802d7d:	c7 44 24 04 97 2d 80 	movl   $0x802d97,0x4(%esp)
  802d84:	00 
  802d85:	89 04 24             	mov    %eax,(%esp)
  802d88:	e8 76 e1 ff ff       	call   800f03 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802d95:	c9                   	leave  
  802d96:	c3                   	ret    

00802d97 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802d97:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802d98:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802d9d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802d9f:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802da2:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  802da4:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  802da8:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  802dac:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  802dad:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  802daf:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802db1:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  802db5:	58                   	pop    %eax
	popl %eax;
  802db6:	58                   	pop    %eax
	popal;
  802db7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  802db8:	83 c4 04             	add    $0x4,%esp
	popfl;
  802dbb:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802dbc:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  802dbd:	c3                   	ret    

00802dbe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802dbe:	55                   	push   %ebp
  802dbf:	89 e5                	mov    %esp,%ebp
  802dc1:	56                   	push   %esi
  802dc2:	53                   	push   %ebx
  802dc3:	83 ec 10             	sub    $0x10,%esp
  802dc6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dcc:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802dcf:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802dd1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802dd6:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802dd9:	89 04 24             	mov    %eax,(%esp)
  802ddc:	e8 98 e1 ff ff       	call   800f79 <sys_ipc_recv>
  802de1:	85 c0                	test   %eax,%eax
  802de3:	75 1e                	jne    802e03 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802de5:	85 db                	test   %ebx,%ebx
  802de7:	74 0a                	je     802df3 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802de9:	a1 08 50 80 00       	mov    0x805008,%eax
  802dee:	8b 40 74             	mov    0x74(%eax),%eax
  802df1:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802df3:	85 f6                	test   %esi,%esi
  802df5:	74 22                	je     802e19 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802df7:	a1 08 50 80 00       	mov    0x805008,%eax
  802dfc:	8b 40 78             	mov    0x78(%eax),%eax
  802dff:	89 06                	mov    %eax,(%esi)
  802e01:	eb 16                	jmp    802e19 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802e03:	85 f6                	test   %esi,%esi
  802e05:	74 06                	je     802e0d <ipc_recv+0x4f>
				*perm_store = 0;
  802e07:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802e0d:	85 db                	test   %ebx,%ebx
  802e0f:	74 10                	je     802e21 <ipc_recv+0x63>
				*from_env_store=0;
  802e11:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802e17:	eb 08                	jmp    802e21 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802e19:	a1 08 50 80 00       	mov    0x805008,%eax
  802e1e:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802e21:	83 c4 10             	add    $0x10,%esp
  802e24:	5b                   	pop    %ebx
  802e25:	5e                   	pop    %esi
  802e26:	5d                   	pop    %ebp
  802e27:	c3                   	ret    

00802e28 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802e28:	55                   	push   %ebp
  802e29:	89 e5                	mov    %esp,%ebp
  802e2b:	57                   	push   %edi
  802e2c:	56                   	push   %esi
  802e2d:	53                   	push   %ebx
  802e2e:	83 ec 1c             	sub    $0x1c,%esp
  802e31:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e34:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802e37:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802e3a:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802e3c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802e41:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802e44:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e48:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	89 04 24             	mov    %eax,(%esp)
  802e56:	e8 fb e0 ff ff       	call   800f56 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802e5b:	eb 1c                	jmp    802e79 <ipc_send+0x51>
	{
		sys_yield();
  802e5d:	e8 e2 de ff ff       	call   800d44 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802e62:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e66:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e6a:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e71:	89 04 24             	mov    %eax,(%esp)
  802e74:	e8 dd e0 ff ff       	call   800f56 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802e79:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802e7c:	74 df                	je     802e5d <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802e7e:	83 c4 1c             	add    $0x1c,%esp
  802e81:	5b                   	pop    %ebx
  802e82:	5e                   	pop    %esi
  802e83:	5f                   	pop    %edi
  802e84:	5d                   	pop    %ebp
  802e85:	c3                   	ret    

00802e86 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802e86:	55                   	push   %ebp
  802e87:	89 e5                	mov    %esp,%ebp
  802e89:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802e8c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802e91:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802e94:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802e9a:	8b 52 50             	mov    0x50(%edx),%edx
  802e9d:	39 ca                	cmp    %ecx,%edx
  802e9f:	75 0d                	jne    802eae <ipc_find_env+0x28>
			return envs[i].env_id;
  802ea1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802ea4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802ea9:	8b 40 40             	mov    0x40(%eax),%eax
  802eac:	eb 0e                	jmp    802ebc <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802eae:	83 c0 01             	add    $0x1,%eax
  802eb1:	3d 00 04 00 00       	cmp    $0x400,%eax
  802eb6:	75 d9                	jne    802e91 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802eb8:	66 b8 00 00          	mov    $0x0,%ax
}
  802ebc:	5d                   	pop    %ebp
  802ebd:	c3                   	ret    

00802ebe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ebe:	55                   	push   %ebp
  802ebf:	89 e5                	mov    %esp,%ebp
  802ec1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ec4:	89 d0                	mov    %edx,%eax
  802ec6:	c1 e8 16             	shr    $0x16,%eax
  802ec9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ed0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ed5:	f6 c1 01             	test   $0x1,%cl
  802ed8:	74 1d                	je     802ef7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802eda:	c1 ea 0c             	shr    $0xc,%edx
  802edd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802ee4:	f6 c2 01             	test   $0x1,%dl
  802ee7:	74 0e                	je     802ef7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802ee9:	c1 ea 0c             	shr    $0xc,%edx
  802eec:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802ef3:	ef 
  802ef4:	0f b7 c0             	movzwl %ax,%eax
}
  802ef7:	5d                   	pop    %ebp
  802ef8:	c3                   	ret    
  802ef9:	66 90                	xchg   %ax,%ax
  802efb:	66 90                	xchg   %ax,%ax
  802efd:	66 90                	xchg   %ax,%ax
  802eff:	90                   	nop

00802f00 <__udivdi3>:
  802f00:	55                   	push   %ebp
  802f01:	57                   	push   %edi
  802f02:	56                   	push   %esi
  802f03:	83 ec 0c             	sub    $0xc,%esp
  802f06:	8b 44 24 28          	mov    0x28(%esp),%eax
  802f0a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802f0e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802f12:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802f16:	85 c0                	test   %eax,%eax
  802f18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802f1c:	89 ea                	mov    %ebp,%edx
  802f1e:	89 0c 24             	mov    %ecx,(%esp)
  802f21:	75 2d                	jne    802f50 <__udivdi3+0x50>
  802f23:	39 e9                	cmp    %ebp,%ecx
  802f25:	77 61                	ja     802f88 <__udivdi3+0x88>
  802f27:	85 c9                	test   %ecx,%ecx
  802f29:	89 ce                	mov    %ecx,%esi
  802f2b:	75 0b                	jne    802f38 <__udivdi3+0x38>
  802f2d:	b8 01 00 00 00       	mov    $0x1,%eax
  802f32:	31 d2                	xor    %edx,%edx
  802f34:	f7 f1                	div    %ecx
  802f36:	89 c6                	mov    %eax,%esi
  802f38:	31 d2                	xor    %edx,%edx
  802f3a:	89 e8                	mov    %ebp,%eax
  802f3c:	f7 f6                	div    %esi
  802f3e:	89 c5                	mov    %eax,%ebp
  802f40:	89 f8                	mov    %edi,%eax
  802f42:	f7 f6                	div    %esi
  802f44:	89 ea                	mov    %ebp,%edx
  802f46:	83 c4 0c             	add    $0xc,%esp
  802f49:	5e                   	pop    %esi
  802f4a:	5f                   	pop    %edi
  802f4b:	5d                   	pop    %ebp
  802f4c:	c3                   	ret    
  802f4d:	8d 76 00             	lea    0x0(%esi),%esi
  802f50:	39 e8                	cmp    %ebp,%eax
  802f52:	77 24                	ja     802f78 <__udivdi3+0x78>
  802f54:	0f bd e8             	bsr    %eax,%ebp
  802f57:	83 f5 1f             	xor    $0x1f,%ebp
  802f5a:	75 3c                	jne    802f98 <__udivdi3+0x98>
  802f5c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802f60:	39 34 24             	cmp    %esi,(%esp)
  802f63:	0f 86 9f 00 00 00    	jbe    803008 <__udivdi3+0x108>
  802f69:	39 d0                	cmp    %edx,%eax
  802f6b:	0f 82 97 00 00 00    	jb     803008 <__udivdi3+0x108>
  802f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f78:	31 d2                	xor    %edx,%edx
  802f7a:	31 c0                	xor    %eax,%eax
  802f7c:	83 c4 0c             	add    $0xc,%esp
  802f7f:	5e                   	pop    %esi
  802f80:	5f                   	pop    %edi
  802f81:	5d                   	pop    %ebp
  802f82:	c3                   	ret    
  802f83:	90                   	nop
  802f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f88:	89 f8                	mov    %edi,%eax
  802f8a:	f7 f1                	div    %ecx
  802f8c:	31 d2                	xor    %edx,%edx
  802f8e:	83 c4 0c             	add    $0xc,%esp
  802f91:	5e                   	pop    %esi
  802f92:	5f                   	pop    %edi
  802f93:	5d                   	pop    %ebp
  802f94:	c3                   	ret    
  802f95:	8d 76 00             	lea    0x0(%esi),%esi
  802f98:	89 e9                	mov    %ebp,%ecx
  802f9a:	8b 3c 24             	mov    (%esp),%edi
  802f9d:	d3 e0                	shl    %cl,%eax
  802f9f:	89 c6                	mov    %eax,%esi
  802fa1:	b8 20 00 00 00       	mov    $0x20,%eax
  802fa6:	29 e8                	sub    %ebp,%eax
  802fa8:	89 c1                	mov    %eax,%ecx
  802faa:	d3 ef                	shr    %cl,%edi
  802fac:	89 e9                	mov    %ebp,%ecx
  802fae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802fb2:	8b 3c 24             	mov    (%esp),%edi
  802fb5:	09 74 24 08          	or     %esi,0x8(%esp)
  802fb9:	89 d6                	mov    %edx,%esi
  802fbb:	d3 e7                	shl    %cl,%edi
  802fbd:	89 c1                	mov    %eax,%ecx
  802fbf:	89 3c 24             	mov    %edi,(%esp)
  802fc2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802fc6:	d3 ee                	shr    %cl,%esi
  802fc8:	89 e9                	mov    %ebp,%ecx
  802fca:	d3 e2                	shl    %cl,%edx
  802fcc:	89 c1                	mov    %eax,%ecx
  802fce:	d3 ef                	shr    %cl,%edi
  802fd0:	09 d7                	or     %edx,%edi
  802fd2:	89 f2                	mov    %esi,%edx
  802fd4:	89 f8                	mov    %edi,%eax
  802fd6:	f7 74 24 08          	divl   0x8(%esp)
  802fda:	89 d6                	mov    %edx,%esi
  802fdc:	89 c7                	mov    %eax,%edi
  802fde:	f7 24 24             	mull   (%esp)
  802fe1:	39 d6                	cmp    %edx,%esi
  802fe3:	89 14 24             	mov    %edx,(%esp)
  802fe6:	72 30                	jb     803018 <__udivdi3+0x118>
  802fe8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802fec:	89 e9                	mov    %ebp,%ecx
  802fee:	d3 e2                	shl    %cl,%edx
  802ff0:	39 c2                	cmp    %eax,%edx
  802ff2:	73 05                	jae    802ff9 <__udivdi3+0xf9>
  802ff4:	3b 34 24             	cmp    (%esp),%esi
  802ff7:	74 1f                	je     803018 <__udivdi3+0x118>
  802ff9:	89 f8                	mov    %edi,%eax
  802ffb:	31 d2                	xor    %edx,%edx
  802ffd:	e9 7a ff ff ff       	jmp    802f7c <__udivdi3+0x7c>
  803002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803008:	31 d2                	xor    %edx,%edx
  80300a:	b8 01 00 00 00       	mov    $0x1,%eax
  80300f:	e9 68 ff ff ff       	jmp    802f7c <__udivdi3+0x7c>
  803014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803018:	8d 47 ff             	lea    -0x1(%edi),%eax
  80301b:	31 d2                	xor    %edx,%edx
  80301d:	83 c4 0c             	add    $0xc,%esp
  803020:	5e                   	pop    %esi
  803021:	5f                   	pop    %edi
  803022:	5d                   	pop    %ebp
  803023:	c3                   	ret    
  803024:	66 90                	xchg   %ax,%ax
  803026:	66 90                	xchg   %ax,%ax
  803028:	66 90                	xchg   %ax,%ax
  80302a:	66 90                	xchg   %ax,%ax
  80302c:	66 90                	xchg   %ax,%ax
  80302e:	66 90                	xchg   %ax,%ax

00803030 <__umoddi3>:
  803030:	55                   	push   %ebp
  803031:	57                   	push   %edi
  803032:	56                   	push   %esi
  803033:	83 ec 14             	sub    $0x14,%esp
  803036:	8b 44 24 28          	mov    0x28(%esp),%eax
  80303a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80303e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803042:	89 c7                	mov    %eax,%edi
  803044:	89 44 24 04          	mov    %eax,0x4(%esp)
  803048:	8b 44 24 30          	mov    0x30(%esp),%eax
  80304c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803050:	89 34 24             	mov    %esi,(%esp)
  803053:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803057:	85 c0                	test   %eax,%eax
  803059:	89 c2                	mov    %eax,%edx
  80305b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80305f:	75 17                	jne    803078 <__umoddi3+0x48>
  803061:	39 fe                	cmp    %edi,%esi
  803063:	76 4b                	jbe    8030b0 <__umoddi3+0x80>
  803065:	89 c8                	mov    %ecx,%eax
  803067:	89 fa                	mov    %edi,%edx
  803069:	f7 f6                	div    %esi
  80306b:	89 d0                	mov    %edx,%eax
  80306d:	31 d2                	xor    %edx,%edx
  80306f:	83 c4 14             	add    $0x14,%esp
  803072:	5e                   	pop    %esi
  803073:	5f                   	pop    %edi
  803074:	5d                   	pop    %ebp
  803075:	c3                   	ret    
  803076:	66 90                	xchg   %ax,%ax
  803078:	39 f8                	cmp    %edi,%eax
  80307a:	77 54                	ja     8030d0 <__umoddi3+0xa0>
  80307c:	0f bd e8             	bsr    %eax,%ebp
  80307f:	83 f5 1f             	xor    $0x1f,%ebp
  803082:	75 5c                	jne    8030e0 <__umoddi3+0xb0>
  803084:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803088:	39 3c 24             	cmp    %edi,(%esp)
  80308b:	0f 87 e7 00 00 00    	ja     803178 <__umoddi3+0x148>
  803091:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803095:	29 f1                	sub    %esi,%ecx
  803097:	19 c7                	sbb    %eax,%edi
  803099:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80309d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8030a9:	83 c4 14             	add    $0x14,%esp
  8030ac:	5e                   	pop    %esi
  8030ad:	5f                   	pop    %edi
  8030ae:	5d                   	pop    %ebp
  8030af:	c3                   	ret    
  8030b0:	85 f6                	test   %esi,%esi
  8030b2:	89 f5                	mov    %esi,%ebp
  8030b4:	75 0b                	jne    8030c1 <__umoddi3+0x91>
  8030b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030bb:	31 d2                	xor    %edx,%edx
  8030bd:	f7 f6                	div    %esi
  8030bf:	89 c5                	mov    %eax,%ebp
  8030c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8030c5:	31 d2                	xor    %edx,%edx
  8030c7:	f7 f5                	div    %ebp
  8030c9:	89 c8                	mov    %ecx,%eax
  8030cb:	f7 f5                	div    %ebp
  8030cd:	eb 9c                	jmp    80306b <__umoddi3+0x3b>
  8030cf:	90                   	nop
  8030d0:	89 c8                	mov    %ecx,%eax
  8030d2:	89 fa                	mov    %edi,%edx
  8030d4:	83 c4 14             	add    $0x14,%esp
  8030d7:	5e                   	pop    %esi
  8030d8:	5f                   	pop    %edi
  8030d9:	5d                   	pop    %ebp
  8030da:	c3                   	ret    
  8030db:	90                   	nop
  8030dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8030e0:	8b 04 24             	mov    (%esp),%eax
  8030e3:	be 20 00 00 00       	mov    $0x20,%esi
  8030e8:	89 e9                	mov    %ebp,%ecx
  8030ea:	29 ee                	sub    %ebp,%esi
  8030ec:	d3 e2                	shl    %cl,%edx
  8030ee:	89 f1                	mov    %esi,%ecx
  8030f0:	d3 e8                	shr    %cl,%eax
  8030f2:	89 e9                	mov    %ebp,%ecx
  8030f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030f8:	8b 04 24             	mov    (%esp),%eax
  8030fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8030ff:	89 fa                	mov    %edi,%edx
  803101:	d3 e0                	shl    %cl,%eax
  803103:	89 f1                	mov    %esi,%ecx
  803105:	89 44 24 08          	mov    %eax,0x8(%esp)
  803109:	8b 44 24 10          	mov    0x10(%esp),%eax
  80310d:	d3 ea                	shr    %cl,%edx
  80310f:	89 e9                	mov    %ebp,%ecx
  803111:	d3 e7                	shl    %cl,%edi
  803113:	89 f1                	mov    %esi,%ecx
  803115:	d3 e8                	shr    %cl,%eax
  803117:	89 e9                	mov    %ebp,%ecx
  803119:	09 f8                	or     %edi,%eax
  80311b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80311f:	f7 74 24 04          	divl   0x4(%esp)
  803123:	d3 e7                	shl    %cl,%edi
  803125:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803129:	89 d7                	mov    %edx,%edi
  80312b:	f7 64 24 08          	mull   0x8(%esp)
  80312f:	39 d7                	cmp    %edx,%edi
  803131:	89 c1                	mov    %eax,%ecx
  803133:	89 14 24             	mov    %edx,(%esp)
  803136:	72 2c                	jb     803164 <__umoddi3+0x134>
  803138:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80313c:	72 22                	jb     803160 <__umoddi3+0x130>
  80313e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803142:	29 c8                	sub    %ecx,%eax
  803144:	19 d7                	sbb    %edx,%edi
  803146:	89 e9                	mov    %ebp,%ecx
  803148:	89 fa                	mov    %edi,%edx
  80314a:	d3 e8                	shr    %cl,%eax
  80314c:	89 f1                	mov    %esi,%ecx
  80314e:	d3 e2                	shl    %cl,%edx
  803150:	89 e9                	mov    %ebp,%ecx
  803152:	d3 ef                	shr    %cl,%edi
  803154:	09 d0                	or     %edx,%eax
  803156:	89 fa                	mov    %edi,%edx
  803158:	83 c4 14             	add    $0x14,%esp
  80315b:	5e                   	pop    %esi
  80315c:	5f                   	pop    %edi
  80315d:	5d                   	pop    %ebp
  80315e:	c3                   	ret    
  80315f:	90                   	nop
  803160:	39 d7                	cmp    %edx,%edi
  803162:	75 da                	jne    80313e <__umoddi3+0x10e>
  803164:	8b 14 24             	mov    (%esp),%edx
  803167:	89 c1                	mov    %eax,%ecx
  803169:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80316d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803171:	eb cb                	jmp    80313e <__umoddi3+0x10e>
  803173:	90                   	nop
  803174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803178:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80317c:	0f 82 0f ff ff ff    	jb     803091 <__umoddi3+0x61>
  803182:	e9 1a ff ff ff       	jmp    8030a1 <__umoddi3+0x71>
