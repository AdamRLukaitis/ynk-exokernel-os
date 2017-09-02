
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 34 01 00 00       	call   800165 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 20             	sub    $0x20,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003e:	eb 43                	jmp    800083 <cat+0x50>
		if ((r = write(1, buf, n)) != n)
  800040:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800044:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  80004b:	00 
  80004c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800053:	e8 cf 13 00 00       	call   801427 <write>
  800058:	39 d8                	cmp    %ebx,%eax
  80005a:	74 27                	je     800083 <cat+0x50>
			panic("write error copying %s: %e", s, r);
  80005c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800060:	8b 45 0c             	mov    0xc(%ebp),%eax
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 20 28 80 	movl   $0x802820,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 3b 28 80 00 	movl   $0x80283b,(%esp)
  80007e:	e8 4d 01 00 00       	call   8001d0 <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800083:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  80008a:	00 
  80008b:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800092:	00 
  800093:	89 34 24             	mov    %esi,(%esp)
  800096:	e8 af 12 00 00       	call   80134a <read>
  80009b:	89 c3                	mov    %eax,%ebx
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f 9f                	jg     800040 <cat+0xd>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	79 27                	jns    8000cc <cat+0x99>
		panic("error reading %s: %e", s, n);
  8000a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	c7 44 24 08 46 28 80 	movl   $0x802846,0x8(%esp)
  8000b7:	00 
  8000b8:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 3b 28 80 00 	movl   $0x80283b,(%esp)
  8000c7:	e8 04 01 00 00       	call   8001d0 <_panic>
}
  8000cc:	83 c4 20             	add    $0x20,%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 1c             	sub    $0x1c,%esp
  8000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000df:	c7 05 00 30 80 00 5b 	movl   $0x80285b,0x803000
  8000e6:	28 80 00 
	if (argc == 1)
  8000e9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ed:	74 07                	je     8000f6 <umain+0x23>
  8000ef:	bb 01 00 00 00       	mov    $0x1,%ebx
  8000f4:	eb 62                	jmp    800158 <umain+0x85>
		cat(0, "<stdin>");
  8000f6:	c7 44 24 04 5f 28 80 	movl   $0x80285f,0x4(%esp)
  8000fd:	00 
  8000fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800105:	e8 29 ff ff ff       	call   800033 <cat>
  80010a:	eb 51                	jmp    80015d <umain+0x8a>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  80010c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800113:	00 
  800114:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800117:	89 04 24             	mov    %eax,(%esp)
  80011a:	e8 04 17 00 00       	call   801823 <open>
  80011f:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800121:	85 c0                	test   %eax,%eax
  800123:	79 19                	jns    80013e <umain+0x6b>
				printf("can't open %s: %e\n", argv[i], f);
  800125:	89 44 24 08          	mov    %eax,0x8(%esp)
  800129:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800130:	c7 04 24 67 28 80 00 	movl   $0x802867,(%esp)
  800137:	e8 97 18 00 00       	call   8019d3 <printf>
  80013c:	eb 17                	jmp    800155 <umain+0x82>
			else {
				cat(f, argv[i]);
  80013e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800141:	89 44 24 04          	mov    %eax,0x4(%esp)
  800145:	89 34 24             	mov    %esi,(%esp)
  800148:	e8 e6 fe ff ff       	call   800033 <cat>
				close(f);
  80014d:	89 34 24             	mov    %esi,(%esp)
  800150:	e8 92 10 00 00       	call   8011e7 <close>

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800155:	83 c3 01             	add    $0x1,%ebx
  800158:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  80015b:	7c af                	jl     80010c <umain+0x39>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  80015d:	83 c4 1c             	add    $0x1c,%esp
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
  80016a:	83 ec 10             	sub    $0x10,%esp
  80016d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800170:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800173:	c7 05 20 60 80 00 00 	movl   $0x0,0x806020
  80017a:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  80017d:	e8 53 0b 00 00       	call   800cd5 <sys_getenvid>
  800182:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800187:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80018a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80018f:	a3 20 60 80 00       	mov    %eax,0x806020


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800194:	85 db                	test   %ebx,%ebx
  800196:	7e 07                	jle    80019f <libmain+0x3a>
		binaryname = argv[0];
  800198:	8b 06                	mov    (%esi),%eax
  80019a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80019f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001a3:	89 1c 24             	mov    %ebx,(%esp)
  8001a6:	e8 28 ff ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  8001ab:	e8 07 00 00 00       	call   8001b7 <exit>
}
  8001b0:	83 c4 10             	add    $0x10,%esp
  8001b3:	5b                   	pop    %ebx
  8001b4:	5e                   	pop    %esi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001bd:	e8 58 10 00 00       	call   80121a <close_all>
	sys_env_destroy(0);
  8001c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001c9:	e8 b5 0a 00 00       	call   800c83 <sys_env_destroy>
}
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	56                   	push   %esi
  8001d4:	53                   	push   %ebx
  8001d5:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001d8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001db:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001e1:	e8 ef 0a 00 00       	call   800cd5 <sys_getenvid>
  8001e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001f4:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fc:	c7 04 24 84 28 80 00 	movl   $0x802884,(%esp)
  800203:	e8 c1 00 00 00       	call   8002c9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800208:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80020c:	8b 45 10             	mov    0x10(%ebp),%eax
  80020f:	89 04 24             	mov    %eax,(%esp)
  800212:	e8 51 00 00 00       	call   800268 <vcprintf>
	cprintf("\n");
  800217:	c7 04 24 e4 2c 80 00 	movl   $0x802ce4,(%esp)
  80021e:	e8 a6 00 00 00       	call   8002c9 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800223:	cc                   	int3   
  800224:	eb fd                	jmp    800223 <_panic+0x53>

00800226 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800226:	55                   	push   %ebp
  800227:	89 e5                	mov    %esp,%ebp
  800229:	53                   	push   %ebx
  80022a:	83 ec 14             	sub    $0x14,%esp
  80022d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800230:	8b 13                	mov    (%ebx),%edx
  800232:	8d 42 01             	lea    0x1(%edx),%eax
  800235:	89 03                	mov    %eax,(%ebx)
  800237:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80023a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80023e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800243:	75 19                	jne    80025e <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800245:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80024c:	00 
  80024d:	8d 43 08             	lea    0x8(%ebx),%eax
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	e8 ee 09 00 00       	call   800c46 <sys_cputs>
		b->idx = 0;
  800258:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80025e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800262:	83 c4 14             	add    $0x14,%esp
  800265:	5b                   	pop    %ebx
  800266:	5d                   	pop    %ebp
  800267:	c3                   	ret    

00800268 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800271:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800278:	00 00 00 
	b.cnt = 0;
  80027b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800282:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80028c:	8b 45 08             	mov    0x8(%ebp),%eax
  80028f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800293:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029d:	c7 04 24 26 02 80 00 	movl   $0x800226,(%esp)
  8002a4:	e8 b5 01 00 00       	call   80045e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b9:	89 04 24             	mov    %eax,(%esp)
  8002bc:	e8 85 09 00 00       	call   800c46 <sys_cputs>

	return b.cnt;
}
  8002c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 87 ff ff ff       	call   800268 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    
  8002e3:	66 90                	xchg   %ax,%ax
  8002e5:	66 90                	xchg   %ax,%ax
  8002e7:	66 90                	xchg   %ax,%ax
  8002e9:	66 90                	xchg   %ax,%ax
  8002eb:	66 90                	xchg   %ax,%ax
  8002ed:	66 90                	xchg   %ax,%ax
  8002ef:	90                   	nop

008002f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	83 ec 3c             	sub    $0x3c,%esp
  8002f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002fc:	89 d7                	mov    %edx,%edi
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800304:	8b 45 0c             	mov    0xc(%ebp),%eax
  800307:	89 c3                	mov    %eax,%ebx
  800309:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80030c:	8b 45 10             	mov    0x10(%ebp),%eax
  80030f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800312:	b9 00 00 00 00       	mov    $0x0,%ecx
  800317:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80031a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80031d:	39 d9                	cmp    %ebx,%ecx
  80031f:	72 05                	jb     800326 <printnum+0x36>
  800321:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800324:	77 69                	ja     80038f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800326:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800329:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80032d:	83 ee 01             	sub    $0x1,%esi
  800330:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800334:	89 44 24 08          	mov    %eax,0x8(%esp)
  800338:	8b 44 24 08          	mov    0x8(%esp),%eax
  80033c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800340:	89 c3                	mov    %eax,%ebx
  800342:	89 d6                	mov    %edx,%esi
  800344:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800347:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80034a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80034e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	89 04 24             	mov    %eax,(%esp)
  800358:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035f:	e8 1c 22 00 00       	call   802580 <__udivdi3>
  800364:	89 d9                	mov    %ebx,%ecx
  800366:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80036a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80036e:	89 04 24             	mov    %eax,(%esp)
  800371:	89 54 24 04          	mov    %edx,0x4(%esp)
  800375:	89 fa                	mov    %edi,%edx
  800377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037a:	e8 71 ff ff ff       	call   8002f0 <printnum>
  80037f:	eb 1b                	jmp    80039c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800381:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	89 04 24             	mov    %eax,(%esp)
  80038b:	ff d3                	call   *%ebx
  80038d:	eb 03                	jmp    800392 <printnum+0xa2>
  80038f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800392:	83 ee 01             	sub    $0x1,%esi
  800395:	85 f6                	test   %esi,%esi
  800397:	7f e8                	jg     800381 <printnum+0x91>
  800399:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80039c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b5:	89 04 24             	mov    %eax,(%esp)
  8003b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003bf:	e8 ec 22 00 00       	call   8026b0 <__umoddi3>
  8003c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003c8:	0f be 80 a7 28 80 00 	movsbl 0x8028a7(%eax),%eax
  8003cf:	89 04 24             	mov    %eax,(%esp)
  8003d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d5:	ff d0                	call   *%eax
}
  8003d7:	83 c4 3c             	add    $0x3c,%esp
  8003da:	5b                   	pop    %ebx
  8003db:	5e                   	pop    %esi
  8003dc:	5f                   	pop    %edi
  8003dd:	5d                   	pop    %ebp
  8003de:	c3                   	ret    

008003df <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003df:	55                   	push   %ebp
  8003e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e2:	83 fa 01             	cmp    $0x1,%edx
  8003e5:	7e 0e                	jle    8003f5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003ec:	89 08                	mov    %ecx,(%eax)
  8003ee:	8b 02                	mov    (%edx),%eax
  8003f0:	8b 52 04             	mov    0x4(%edx),%edx
  8003f3:	eb 22                	jmp    800417 <getuint+0x38>
	else if (lflag)
  8003f5:	85 d2                	test   %edx,%edx
  8003f7:	74 10                	je     800409 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003f9:	8b 10                	mov    (%eax),%edx
  8003fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003fe:	89 08                	mov    %ecx,(%eax)
  800400:	8b 02                	mov    (%edx),%eax
  800402:	ba 00 00 00 00       	mov    $0x0,%edx
  800407:	eb 0e                	jmp    800417 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800409:	8b 10                	mov    (%eax),%edx
  80040b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80040e:	89 08                	mov    %ecx,(%eax)
  800410:	8b 02                	mov    (%edx),%eax
  800412:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800417:	5d                   	pop    %ebp
  800418:	c3                   	ret    

00800419 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80041f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800423:	8b 10                	mov    (%eax),%edx
  800425:	3b 50 04             	cmp    0x4(%eax),%edx
  800428:	73 0a                	jae    800434 <sprintputch+0x1b>
		*b->buf++ = ch;
  80042a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80042d:	89 08                	mov    %ecx,(%eax)
  80042f:	8b 45 08             	mov    0x8(%ebp),%eax
  800432:	88 02                	mov    %al,(%edx)
}
  800434:	5d                   	pop    %ebp
  800435:	c3                   	ret    

00800436 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800436:	55                   	push   %ebp
  800437:	89 e5                	mov    %esp,%ebp
  800439:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80043c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80043f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800443:	8b 45 10             	mov    0x10(%ebp),%eax
  800446:	89 44 24 08          	mov    %eax,0x8(%esp)
  80044a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80044d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	89 04 24             	mov    %eax,(%esp)
  800457:	e8 02 00 00 00       	call   80045e <vprintfmt>
	va_end(ap);
}
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	57                   	push   %edi
  800462:	56                   	push   %esi
  800463:	53                   	push   %ebx
  800464:	83 ec 3c             	sub    $0x3c,%esp
  800467:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80046a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80046d:	eb 14                	jmp    800483 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80046f:	85 c0                	test   %eax,%eax
  800471:	0f 84 b3 03 00 00    	je     80082a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800477:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047b:	89 04 24             	mov    %eax,(%esp)
  80047e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800481:	89 f3                	mov    %esi,%ebx
  800483:	8d 73 01             	lea    0x1(%ebx),%esi
  800486:	0f b6 03             	movzbl (%ebx),%eax
  800489:	83 f8 25             	cmp    $0x25,%eax
  80048c:	75 e1                	jne    80046f <vprintfmt+0x11>
  80048e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800492:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800499:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004a0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8004a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ac:	eb 1d                	jmp    8004cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ae:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004b0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004b4:	eb 15                	jmp    8004cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004b8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004bc:	eb 0d                	jmp    8004cb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004c4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004cb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004ce:	0f b6 0e             	movzbl (%esi),%ecx
  8004d1:	0f b6 c1             	movzbl %cl,%eax
  8004d4:	83 e9 23             	sub    $0x23,%ecx
  8004d7:	80 f9 55             	cmp    $0x55,%cl
  8004da:	0f 87 2a 03 00 00    	ja     80080a <vprintfmt+0x3ac>
  8004e0:	0f b6 c9             	movzbl %cl,%ecx
  8004e3:	ff 24 8d e0 29 80 00 	jmp    *0x8029e0(,%ecx,4)
  8004ea:	89 de                	mov    %ebx,%esi
  8004ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004f1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004f4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004f8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004fb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004fe:	83 fb 09             	cmp    $0x9,%ebx
  800501:	77 36                	ja     800539 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800503:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800506:	eb e9                	jmp    8004f1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8d 48 04             	lea    0x4(%eax),%ecx
  80050e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800511:	8b 00                	mov    (%eax),%eax
  800513:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800516:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800518:	eb 22                	jmp    80053c <vprintfmt+0xde>
  80051a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80051d:	85 c9                	test   %ecx,%ecx
  80051f:	b8 00 00 00 00       	mov    $0x0,%eax
  800524:	0f 49 c1             	cmovns %ecx,%eax
  800527:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	89 de                	mov    %ebx,%esi
  80052c:	eb 9d                	jmp    8004cb <vprintfmt+0x6d>
  80052e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800530:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800537:	eb 92                	jmp    8004cb <vprintfmt+0x6d>
  800539:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80053c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800540:	79 89                	jns    8004cb <vprintfmt+0x6d>
  800542:	e9 77 ff ff ff       	jmp    8004be <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800547:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80054c:	e9 7a ff ff ff       	jmp    8004cb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800551:	8b 45 14             	mov    0x14(%ebp),%eax
  800554:	8d 50 04             	lea    0x4(%eax),%edx
  800557:	89 55 14             	mov    %edx,0x14(%ebp)
  80055a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055e:	8b 00                	mov    (%eax),%eax
  800560:	89 04 24             	mov    %eax,(%esp)
  800563:	ff 55 08             	call   *0x8(%ebp)
			break;
  800566:	e9 18 ff ff ff       	jmp    800483 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	8d 50 04             	lea    0x4(%eax),%edx
  800571:	89 55 14             	mov    %edx,0x14(%ebp)
  800574:	8b 00                	mov    (%eax),%eax
  800576:	99                   	cltd   
  800577:	31 d0                	xor    %edx,%eax
  800579:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80057b:	83 f8 0f             	cmp    $0xf,%eax
  80057e:	7f 0b                	jg     80058b <vprintfmt+0x12d>
  800580:	8b 14 85 40 2b 80 00 	mov    0x802b40(,%eax,4),%edx
  800587:	85 d2                	test   %edx,%edx
  800589:	75 20                	jne    8005ab <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80058b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80058f:	c7 44 24 08 bf 28 80 	movl   $0x8028bf,0x8(%esp)
  800596:	00 
  800597:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	89 04 24             	mov    %eax,(%esp)
  8005a1:	e8 90 fe ff ff       	call   800436 <printfmt>
  8005a6:	e9 d8 fe ff ff       	jmp    800483 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005af:	c7 44 24 08 79 2c 80 	movl   $0x802c79,0x8(%esp)
  8005b6:	00 
  8005b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	89 04 24             	mov    %eax,(%esp)
  8005c1:	e8 70 fe ff ff       	call   800436 <printfmt>
  8005c6:	e9 b8 fe ff ff       	jmp    800483 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005cb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	8d 50 04             	lea    0x4(%eax),%edx
  8005da:	89 55 14             	mov    %edx,0x14(%ebp)
  8005dd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005df:	85 f6                	test   %esi,%esi
  8005e1:	b8 b8 28 80 00       	mov    $0x8028b8,%eax
  8005e6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005e9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005ed:	0f 84 97 00 00 00    	je     80068a <vprintfmt+0x22c>
  8005f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005f7:	0f 8e 9b 00 00 00    	jle    800698 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005fd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800601:	89 34 24             	mov    %esi,(%esp)
  800604:	e8 cf 02 00 00       	call   8008d8 <strnlen>
  800609:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80060c:	29 c2                	sub    %eax,%edx
  80060e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800611:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800615:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800618:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80061b:	8b 75 08             	mov    0x8(%ebp),%esi
  80061e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800621:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800623:	eb 0f                	jmp    800634 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800625:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800629:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80062c:	89 04 24             	mov    %eax,(%esp)
  80062f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800631:	83 eb 01             	sub    $0x1,%ebx
  800634:	85 db                	test   %ebx,%ebx
  800636:	7f ed                	jg     800625 <vprintfmt+0x1c7>
  800638:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80063b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80063e:	85 d2                	test   %edx,%edx
  800640:	b8 00 00 00 00       	mov    $0x0,%eax
  800645:	0f 49 c2             	cmovns %edx,%eax
  800648:	29 c2                	sub    %eax,%edx
  80064a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80064d:	89 d7                	mov    %edx,%edi
  80064f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800652:	eb 50                	jmp    8006a4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800654:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800658:	74 1e                	je     800678 <vprintfmt+0x21a>
  80065a:	0f be d2             	movsbl %dl,%edx
  80065d:	83 ea 20             	sub    $0x20,%edx
  800660:	83 fa 5e             	cmp    $0x5e,%edx
  800663:	76 13                	jbe    800678 <vprintfmt+0x21a>
					putch('?', putdat);
  800665:	8b 45 0c             	mov    0xc(%ebp),%eax
  800668:	89 44 24 04          	mov    %eax,0x4(%esp)
  80066c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800673:	ff 55 08             	call   *0x8(%ebp)
  800676:	eb 0d                	jmp    800685 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80067f:	89 04 24             	mov    %eax,(%esp)
  800682:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800685:	83 ef 01             	sub    $0x1,%edi
  800688:	eb 1a                	jmp    8006a4 <vprintfmt+0x246>
  80068a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80068d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800690:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800693:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800696:	eb 0c                	jmp    8006a4 <vprintfmt+0x246>
  800698:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80069b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80069e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006a1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006a4:	83 c6 01             	add    $0x1,%esi
  8006a7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006ab:	0f be c2             	movsbl %dl,%eax
  8006ae:	85 c0                	test   %eax,%eax
  8006b0:	74 27                	je     8006d9 <vprintfmt+0x27b>
  8006b2:	85 db                	test   %ebx,%ebx
  8006b4:	78 9e                	js     800654 <vprintfmt+0x1f6>
  8006b6:	83 eb 01             	sub    $0x1,%ebx
  8006b9:	79 99                	jns    800654 <vprintfmt+0x1f6>
  8006bb:	89 f8                	mov    %edi,%eax
  8006bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006c3:	89 c3                	mov    %eax,%ebx
  8006c5:	eb 1a                	jmp    8006e1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006d2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d4:	83 eb 01             	sub    $0x1,%ebx
  8006d7:	eb 08                	jmp    8006e1 <vprintfmt+0x283>
  8006d9:	89 fb                	mov    %edi,%ebx
  8006db:	8b 75 08             	mov    0x8(%ebp),%esi
  8006de:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006e1:	85 db                	test   %ebx,%ebx
  8006e3:	7f e2                	jg     8006c7 <vprintfmt+0x269>
  8006e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006eb:	e9 93 fd ff ff       	jmp    800483 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006f0:	83 fa 01             	cmp    $0x1,%edx
  8006f3:	7e 16                	jle    80070b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8d 50 08             	lea    0x8(%eax),%edx
  8006fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006fe:	8b 50 04             	mov    0x4(%eax),%edx
  800701:	8b 00                	mov    (%eax),%eax
  800703:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800706:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800709:	eb 32                	jmp    80073d <vprintfmt+0x2df>
	else if (lflag)
  80070b:	85 d2                	test   %edx,%edx
  80070d:	74 18                	je     800727 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8d 50 04             	lea    0x4(%eax),%edx
  800715:	89 55 14             	mov    %edx,0x14(%ebp)
  800718:	8b 30                	mov    (%eax),%esi
  80071a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80071d:	89 f0                	mov    %esi,%eax
  80071f:	c1 f8 1f             	sar    $0x1f,%eax
  800722:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800725:	eb 16                	jmp    80073d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 50 04             	lea    0x4(%eax),%edx
  80072d:	89 55 14             	mov    %edx,0x14(%ebp)
  800730:	8b 30                	mov    (%eax),%esi
  800732:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800735:	89 f0                	mov    %esi,%eax
  800737:	c1 f8 1f             	sar    $0x1f,%eax
  80073a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80073d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800740:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800743:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800748:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80074c:	0f 89 80 00 00 00    	jns    8007d2 <vprintfmt+0x374>
				putch('-', putdat);
  800752:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800756:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80075d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800760:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800763:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800766:	f7 d8                	neg    %eax
  800768:	83 d2 00             	adc    $0x0,%edx
  80076b:	f7 da                	neg    %edx
			}
			base = 10;
  80076d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800772:	eb 5e                	jmp    8007d2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800774:	8d 45 14             	lea    0x14(%ebp),%eax
  800777:	e8 63 fc ff ff       	call   8003df <getuint>
			base = 10;
  80077c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800781:	eb 4f                	jmp    8007d2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800783:	8d 45 14             	lea    0x14(%ebp),%eax
  800786:	e8 54 fc ff ff       	call   8003df <getuint>
			base =8;
  80078b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800790:	eb 40                	jmp    8007d2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800792:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800796:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80079d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007ab:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b1:	8d 50 04             	lea    0x4(%eax),%edx
  8007b4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007b7:	8b 00                	mov    (%eax),%eax
  8007b9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007be:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007c3:	eb 0d                	jmp    8007d2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c8:	e8 12 fc ff ff       	call   8003df <getuint>
			base = 16;
  8007cd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007d2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007d6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007da:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007dd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007e5:	89 04 24             	mov    %eax,(%esp)
  8007e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007ec:	89 fa                	mov    %edi,%edx
  8007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f1:	e8 fa fa ff ff       	call   8002f0 <printnum>
			break;
  8007f6:	e9 88 fc ff ff       	jmp    800483 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ff:	89 04 24             	mov    %eax,(%esp)
  800802:	ff 55 08             	call   *0x8(%ebp)
			break;
  800805:	e9 79 fc ff ff       	jmp    800483 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80080a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80080e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800815:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800818:	89 f3                	mov    %esi,%ebx
  80081a:	eb 03                	jmp    80081f <vprintfmt+0x3c1>
  80081c:	83 eb 01             	sub    $0x1,%ebx
  80081f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800823:	75 f7                	jne    80081c <vprintfmt+0x3be>
  800825:	e9 59 fc ff ff       	jmp    800483 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80082a:	83 c4 3c             	add    $0x3c,%esp
  80082d:	5b                   	pop    %ebx
  80082e:	5e                   	pop    %esi
  80082f:	5f                   	pop    %edi
  800830:	5d                   	pop    %ebp
  800831:	c3                   	ret    

00800832 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	83 ec 28             	sub    $0x28,%esp
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80083e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800841:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800845:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800848:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80084f:	85 c0                	test   %eax,%eax
  800851:	74 30                	je     800883 <vsnprintf+0x51>
  800853:	85 d2                	test   %edx,%edx
  800855:	7e 2c                	jle    800883 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80085e:	8b 45 10             	mov    0x10(%ebp),%eax
  800861:	89 44 24 08          	mov    %eax,0x8(%esp)
  800865:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800868:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086c:	c7 04 24 19 04 80 00 	movl   $0x800419,(%esp)
  800873:	e8 e6 fb ff ff       	call   80045e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800878:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80087b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80087e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800881:	eb 05                	jmp    800888 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800883:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800888:	c9                   	leave  
  800889:	c3                   	ret    

0080088a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800893:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800897:	8b 45 10             	mov    0x10(%ebp),%eax
  80089a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80089e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	89 04 24             	mov    %eax,(%esp)
  8008ab:	e8 82 ff ff ff       	call   800832 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008b0:	c9                   	leave  
  8008b1:	c3                   	ret    
  8008b2:	66 90                	xchg   %ax,%ax
  8008b4:	66 90                	xchg   %ax,%ax
  8008b6:	66 90                	xchg   %ax,%ax
  8008b8:	66 90                	xchg   %ax,%ax
  8008ba:	66 90                	xchg   %ax,%ax
  8008bc:	66 90                	xchg   %ax,%ax
  8008be:	66 90                	xchg   %ax,%ax

008008c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008cb:	eb 03                	jmp    8008d0 <strlen+0x10>
		n++;
  8008cd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008d4:	75 f7                	jne    8008cd <strlen+0xd>
		n++;
	return n;
}
  8008d6:	5d                   	pop    %ebp
  8008d7:	c3                   	ret    

008008d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d8:	55                   	push   %ebp
  8008d9:	89 e5                	mov    %esp,%ebp
  8008db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008de:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e6:	eb 03                	jmp    8008eb <strnlen+0x13>
		n++;
  8008e8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008eb:	39 d0                	cmp    %edx,%eax
  8008ed:	74 06                	je     8008f5 <strnlen+0x1d>
  8008ef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008f3:	75 f3                	jne    8008e8 <strnlen+0x10>
		n++;
	return n;
}
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	53                   	push   %ebx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800901:	89 c2                	mov    %eax,%edx
  800903:	83 c2 01             	add    $0x1,%edx
  800906:	83 c1 01             	add    $0x1,%ecx
  800909:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80090d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800910:	84 db                	test   %bl,%bl
  800912:	75 ef                	jne    800903 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800914:	5b                   	pop    %ebx
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	53                   	push   %ebx
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800921:	89 1c 24             	mov    %ebx,(%esp)
  800924:	e8 97 ff ff ff       	call   8008c0 <strlen>
	strcpy(dst + len, src);
  800929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800930:	01 d8                	add    %ebx,%eax
  800932:	89 04 24             	mov    %eax,(%esp)
  800935:	e8 bd ff ff ff       	call   8008f7 <strcpy>
	return dst;
}
  80093a:	89 d8                	mov    %ebx,%eax
  80093c:	83 c4 08             	add    $0x8,%esp
  80093f:	5b                   	pop    %ebx
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	56                   	push   %esi
  800946:	53                   	push   %ebx
  800947:	8b 75 08             	mov    0x8(%ebp),%esi
  80094a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094d:	89 f3                	mov    %esi,%ebx
  80094f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800952:	89 f2                	mov    %esi,%edx
  800954:	eb 0f                	jmp    800965 <strncpy+0x23>
		*dst++ = *src;
  800956:	83 c2 01             	add    $0x1,%edx
  800959:	0f b6 01             	movzbl (%ecx),%eax
  80095c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80095f:	80 39 01             	cmpb   $0x1,(%ecx)
  800962:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800965:	39 da                	cmp    %ebx,%edx
  800967:	75 ed                	jne    800956 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800969:	89 f0                	mov    %esi,%eax
  80096b:	5b                   	pop    %ebx
  80096c:	5e                   	pop    %esi
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	56                   	push   %esi
  800973:	53                   	push   %ebx
  800974:	8b 75 08             	mov    0x8(%ebp),%esi
  800977:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80097d:	89 f0                	mov    %esi,%eax
  80097f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800983:	85 c9                	test   %ecx,%ecx
  800985:	75 0b                	jne    800992 <strlcpy+0x23>
  800987:	eb 1d                	jmp    8009a6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800989:	83 c0 01             	add    $0x1,%eax
  80098c:	83 c2 01             	add    $0x1,%edx
  80098f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800992:	39 d8                	cmp    %ebx,%eax
  800994:	74 0b                	je     8009a1 <strlcpy+0x32>
  800996:	0f b6 0a             	movzbl (%edx),%ecx
  800999:	84 c9                	test   %cl,%cl
  80099b:	75 ec                	jne    800989 <strlcpy+0x1a>
  80099d:	89 c2                	mov    %eax,%edx
  80099f:	eb 02                	jmp    8009a3 <strlcpy+0x34>
  8009a1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009a3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009a6:	29 f0                	sub    %esi,%eax
}
  8009a8:	5b                   	pop    %ebx
  8009a9:	5e                   	pop    %esi
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009b5:	eb 06                	jmp    8009bd <strcmp+0x11>
		p++, q++;
  8009b7:	83 c1 01             	add    $0x1,%ecx
  8009ba:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009bd:	0f b6 01             	movzbl (%ecx),%eax
  8009c0:	84 c0                	test   %al,%al
  8009c2:	74 04                	je     8009c8 <strcmp+0x1c>
  8009c4:	3a 02                	cmp    (%edx),%al
  8009c6:	74 ef                	je     8009b7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c8:	0f b6 c0             	movzbl %al,%eax
  8009cb:	0f b6 12             	movzbl (%edx),%edx
  8009ce:	29 d0                	sub    %edx,%eax
}
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	53                   	push   %ebx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 c3                	mov    %eax,%ebx
  8009de:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009e1:	eb 06                	jmp    8009e9 <strncmp+0x17>
		n--, p++, q++;
  8009e3:	83 c0 01             	add    $0x1,%eax
  8009e6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009e9:	39 d8                	cmp    %ebx,%eax
  8009eb:	74 15                	je     800a02 <strncmp+0x30>
  8009ed:	0f b6 08             	movzbl (%eax),%ecx
  8009f0:	84 c9                	test   %cl,%cl
  8009f2:	74 04                	je     8009f8 <strncmp+0x26>
  8009f4:	3a 0a                	cmp    (%edx),%cl
  8009f6:	74 eb                	je     8009e3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f8:	0f b6 00             	movzbl (%eax),%eax
  8009fb:	0f b6 12             	movzbl (%edx),%edx
  8009fe:	29 d0                	sub    %edx,%eax
  800a00:	eb 05                	jmp    800a07 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a02:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a07:	5b                   	pop    %ebx
  800a08:	5d                   	pop    %ebp
  800a09:	c3                   	ret    

00800a0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a14:	eb 07                	jmp    800a1d <strchr+0x13>
		if (*s == c)
  800a16:	38 ca                	cmp    %cl,%dl
  800a18:	74 0f                	je     800a29 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a1a:	83 c0 01             	add    $0x1,%eax
  800a1d:	0f b6 10             	movzbl (%eax),%edx
  800a20:	84 d2                	test   %dl,%dl
  800a22:	75 f2                	jne    800a16 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a29:	5d                   	pop    %ebp
  800a2a:	c3                   	ret    

00800a2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a35:	eb 07                	jmp    800a3e <strfind+0x13>
		if (*s == c)
  800a37:	38 ca                	cmp    %cl,%dl
  800a39:	74 0a                	je     800a45 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a3b:	83 c0 01             	add    $0x1,%eax
  800a3e:	0f b6 10             	movzbl (%eax),%edx
  800a41:	84 d2                	test   %dl,%dl
  800a43:	75 f2                	jne    800a37 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	57                   	push   %edi
  800a4b:	56                   	push   %esi
  800a4c:	53                   	push   %ebx
  800a4d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a53:	85 c9                	test   %ecx,%ecx
  800a55:	74 36                	je     800a8d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a57:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a5d:	75 28                	jne    800a87 <memset+0x40>
  800a5f:	f6 c1 03             	test   $0x3,%cl
  800a62:	75 23                	jne    800a87 <memset+0x40>
		c &= 0xFF;
  800a64:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a68:	89 d3                	mov    %edx,%ebx
  800a6a:	c1 e3 08             	shl    $0x8,%ebx
  800a6d:	89 d6                	mov    %edx,%esi
  800a6f:	c1 e6 18             	shl    $0x18,%esi
  800a72:	89 d0                	mov    %edx,%eax
  800a74:	c1 e0 10             	shl    $0x10,%eax
  800a77:	09 f0                	or     %esi,%eax
  800a79:	09 c2                	or     %eax,%edx
  800a7b:	89 d0                	mov    %edx,%eax
  800a7d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a7f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a82:	fc                   	cld    
  800a83:	f3 ab                	rep stos %eax,%es:(%edi)
  800a85:	eb 06                	jmp    800a8d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8a:	fc                   	cld    
  800a8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a8d:	89 f8                	mov    %edi,%eax
  800a8f:	5b                   	pop    %ebx
  800a90:	5e                   	pop    %esi
  800a91:	5f                   	pop    %edi
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	57                   	push   %edi
  800a98:	56                   	push   %esi
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aa2:	39 c6                	cmp    %eax,%esi
  800aa4:	73 35                	jae    800adb <memmove+0x47>
  800aa6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aa9:	39 d0                	cmp    %edx,%eax
  800aab:	73 2e                	jae    800adb <memmove+0x47>
		s += n;
		d += n;
  800aad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ab0:	89 d6                	mov    %edx,%esi
  800ab2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aba:	75 13                	jne    800acf <memmove+0x3b>
  800abc:	f6 c1 03             	test   $0x3,%cl
  800abf:	75 0e                	jne    800acf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ac1:	83 ef 04             	sub    $0x4,%edi
  800ac4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ac7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aca:	fd                   	std    
  800acb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acd:	eb 09                	jmp    800ad8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800acf:	83 ef 01             	sub    $0x1,%edi
  800ad2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ad5:	fd                   	std    
  800ad6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ad8:	fc                   	cld    
  800ad9:	eb 1d                	jmp    800af8 <memmove+0x64>
  800adb:	89 f2                	mov    %esi,%edx
  800add:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800adf:	f6 c2 03             	test   $0x3,%dl
  800ae2:	75 0f                	jne    800af3 <memmove+0x5f>
  800ae4:	f6 c1 03             	test   $0x3,%cl
  800ae7:	75 0a                	jne    800af3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ae9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800aec:	89 c7                	mov    %eax,%edi
  800aee:	fc                   	cld    
  800aef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af1:	eb 05                	jmp    800af8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800af3:	89 c7                	mov    %eax,%edi
  800af5:	fc                   	cld    
  800af6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800af8:	5e                   	pop    %esi
  800af9:	5f                   	pop    %edi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b02:	8b 45 10             	mov    0x10(%ebp),%eax
  800b05:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	89 04 24             	mov    %eax,(%esp)
  800b16:	e8 79 ff ff ff       	call   800a94 <memmove>
}
  800b1b:	c9                   	leave  
  800b1c:	c3                   	ret    

00800b1d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	56                   	push   %esi
  800b21:	53                   	push   %ebx
  800b22:	8b 55 08             	mov    0x8(%ebp),%edx
  800b25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b28:	89 d6                	mov    %edx,%esi
  800b2a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b2d:	eb 1a                	jmp    800b49 <memcmp+0x2c>
		if (*s1 != *s2)
  800b2f:	0f b6 02             	movzbl (%edx),%eax
  800b32:	0f b6 19             	movzbl (%ecx),%ebx
  800b35:	38 d8                	cmp    %bl,%al
  800b37:	74 0a                	je     800b43 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b39:	0f b6 c0             	movzbl %al,%eax
  800b3c:	0f b6 db             	movzbl %bl,%ebx
  800b3f:	29 d8                	sub    %ebx,%eax
  800b41:	eb 0f                	jmp    800b52 <memcmp+0x35>
		s1++, s2++;
  800b43:	83 c2 01             	add    $0x1,%edx
  800b46:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b49:	39 f2                	cmp    %esi,%edx
  800b4b:	75 e2                	jne    800b2f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b52:	5b                   	pop    %ebx
  800b53:	5e                   	pop    %esi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b5f:	89 c2                	mov    %eax,%edx
  800b61:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b64:	eb 07                	jmp    800b6d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b66:	38 08                	cmp    %cl,(%eax)
  800b68:	74 07                	je     800b71 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b6a:	83 c0 01             	add    $0x1,%eax
  800b6d:	39 d0                	cmp    %edx,%eax
  800b6f:	72 f5                	jb     800b66 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	57                   	push   %edi
  800b77:	56                   	push   %esi
  800b78:	53                   	push   %ebx
  800b79:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b7f:	eb 03                	jmp    800b84 <strtol+0x11>
		s++;
  800b81:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b84:	0f b6 0a             	movzbl (%edx),%ecx
  800b87:	80 f9 09             	cmp    $0x9,%cl
  800b8a:	74 f5                	je     800b81 <strtol+0xe>
  800b8c:	80 f9 20             	cmp    $0x20,%cl
  800b8f:	74 f0                	je     800b81 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b91:	80 f9 2b             	cmp    $0x2b,%cl
  800b94:	75 0a                	jne    800ba0 <strtol+0x2d>
		s++;
  800b96:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b99:	bf 00 00 00 00       	mov    $0x0,%edi
  800b9e:	eb 11                	jmp    800bb1 <strtol+0x3e>
  800ba0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ba5:	80 f9 2d             	cmp    $0x2d,%cl
  800ba8:	75 07                	jne    800bb1 <strtol+0x3e>
		s++, neg = 1;
  800baa:	8d 52 01             	lea    0x1(%edx),%edx
  800bad:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bb6:	75 15                	jne    800bcd <strtol+0x5a>
  800bb8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bbb:	75 10                	jne    800bcd <strtol+0x5a>
  800bbd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bc1:	75 0a                	jne    800bcd <strtol+0x5a>
		s += 2, base = 16;
  800bc3:	83 c2 02             	add    $0x2,%edx
  800bc6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bcb:	eb 10                	jmp    800bdd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bcd:	85 c0                	test   %eax,%eax
  800bcf:	75 0c                	jne    800bdd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bd1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bd3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bd6:	75 05                	jne    800bdd <strtol+0x6a>
		s++, base = 8;
  800bd8:	83 c2 01             	add    $0x1,%edx
  800bdb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800be2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800be5:	0f b6 0a             	movzbl (%edx),%ecx
  800be8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800beb:	89 f0                	mov    %esi,%eax
  800bed:	3c 09                	cmp    $0x9,%al
  800bef:	77 08                	ja     800bf9 <strtol+0x86>
			dig = *s - '0';
  800bf1:	0f be c9             	movsbl %cl,%ecx
  800bf4:	83 e9 30             	sub    $0x30,%ecx
  800bf7:	eb 20                	jmp    800c19 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bf9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bfc:	89 f0                	mov    %esi,%eax
  800bfe:	3c 19                	cmp    $0x19,%al
  800c00:	77 08                	ja     800c0a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c02:	0f be c9             	movsbl %cl,%ecx
  800c05:	83 e9 57             	sub    $0x57,%ecx
  800c08:	eb 0f                	jmp    800c19 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c0a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c0d:	89 f0                	mov    %esi,%eax
  800c0f:	3c 19                	cmp    $0x19,%al
  800c11:	77 16                	ja     800c29 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c13:	0f be c9             	movsbl %cl,%ecx
  800c16:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c19:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c1c:	7d 0f                	jge    800c2d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c1e:	83 c2 01             	add    $0x1,%edx
  800c21:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c25:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c27:	eb bc                	jmp    800be5 <strtol+0x72>
  800c29:	89 d8                	mov    %ebx,%eax
  800c2b:	eb 02                	jmp    800c2f <strtol+0xbc>
  800c2d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c33:	74 05                	je     800c3a <strtol+0xc7>
		*endptr = (char *) s;
  800c35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c38:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c3a:	f7 d8                	neg    %eax
  800c3c:	85 ff                	test   %edi,%edi
  800c3e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c41:	5b                   	pop    %ebx
  800c42:	5e                   	pop    %esi
  800c43:	5f                   	pop    %edi
  800c44:	5d                   	pop    %ebp
  800c45:	c3                   	ret    

00800c46 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	57                   	push   %edi
  800c4a:	56                   	push   %esi
  800c4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c54:	8b 55 08             	mov    0x8(%ebp),%edx
  800c57:	89 c3                	mov    %eax,%ebx
  800c59:	89 c7                	mov    %eax,%edi
  800c5b:	89 c6                	mov    %eax,%esi
  800c5d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <sys_cgetc>:

int
sys_cgetc(void)
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
  800c6f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c74:	89 d1                	mov    %edx,%ecx
  800c76:	89 d3                	mov    %edx,%ebx
  800c78:	89 d7                	mov    %edx,%edi
  800c7a:	89 d6                	mov    %edx,%esi
  800c7c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800c8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c91:	b8 03 00 00 00       	mov    $0x3,%eax
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	89 cb                	mov    %ecx,%ebx
  800c9b:	89 cf                	mov    %ecx,%edi
  800c9d:	89 ce                	mov    %ecx,%esi
  800c9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca1:	85 c0                	test   %eax,%eax
  800ca3:	7e 28                	jle    800ccd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ca9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cb0:	00 
  800cb1:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800cb8:	00 
  800cb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc0:	00 
  800cc1:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800cc8:	e8 03 f5 ff ff       	call   8001d0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ccd:	83 c4 2c             	add    $0x2c,%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	57                   	push   %edi
  800cd9:	56                   	push   %esi
  800cda:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ce5:	89 d1                	mov    %edx,%ecx
  800ce7:	89 d3                	mov    %edx,%ebx
  800ce9:	89 d7                	mov    %edx,%edi
  800ceb:	89 d6                	mov    %edx,%esi
  800ced:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    

00800cf4 <sys_yield>:

void
sys_yield(void)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	57                   	push   %edi
  800cf8:	56                   	push   %esi
  800cf9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfa:	ba 00 00 00 00       	mov    $0x0,%edx
  800cff:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d04:	89 d1                	mov    %edx,%ecx
  800d06:	89 d3                	mov    %edx,%ebx
  800d08:	89 d7                	mov    %edx,%edi
  800d0a:	89 d6                	mov    %edx,%esi
  800d0c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d0e:	5b                   	pop    %ebx
  800d0f:	5e                   	pop    %esi
  800d10:	5f                   	pop    %edi
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1c:	be 00 00 00 00       	mov    $0x0,%esi
  800d21:	b8 04 00 00 00       	mov    $0x4,%eax
  800d26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d29:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2f:	89 f7                	mov    %esi,%edi
  800d31:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	7e 28                	jle    800d5f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d37:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d3b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d42:	00 
  800d43:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800d4a:	00 
  800d4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d52:	00 
  800d53:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800d5a:	e8 71 f4 ff ff       	call   8001d0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d5f:	83 c4 2c             	add    $0x2c,%esp
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
  800d6d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d70:	b8 05 00 00 00       	mov    $0x5,%eax
  800d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d78:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d81:	8b 75 18             	mov    0x18(%ebp),%esi
  800d84:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d86:	85 c0                	test   %eax,%eax
  800d88:	7e 28                	jle    800db2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d8e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d95:	00 
  800d96:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800d9d:	00 
  800d9e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da5:	00 
  800da6:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800dad:	e8 1e f4 ff ff       	call   8001d0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800db2:	83 c4 2c             	add    $0x2c,%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
  800dc0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	89 df                	mov    %ebx,%edi
  800dd5:	89 de                	mov    %ebx,%esi
  800dd7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dd9:	85 c0                	test   %eax,%eax
  800ddb:	7e 28                	jle    800e05 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800de8:	00 
  800de9:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800df0:	00 
  800df1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df8:	00 
  800df9:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800e00:	e8 cb f3 ff ff       	call   8001d0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e05:	83 c4 2c             	add    $0x2c,%esp
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
  800e13:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e16:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e23:	8b 55 08             	mov    0x8(%ebp),%edx
  800e26:	89 df                	mov    %ebx,%edi
  800e28:	89 de                	mov    %ebx,%esi
  800e2a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e2c:	85 c0                	test   %eax,%eax
  800e2e:	7e 28                	jle    800e58 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e30:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e34:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e3b:	00 
  800e3c:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800e43:	00 
  800e44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e4b:	00 
  800e4c:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800e53:	e8 78 f3 ff ff       	call   8001d0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e58:	83 c4 2c             	add    $0x2c,%esp
  800e5b:	5b                   	pop    %ebx
  800e5c:	5e                   	pop    %esi
  800e5d:	5f                   	pop    %edi
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	57                   	push   %edi
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
  800e66:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e76:	8b 55 08             	mov    0x8(%ebp),%edx
  800e79:	89 df                	mov    %ebx,%edi
  800e7b:	89 de                	mov    %ebx,%esi
  800e7d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	7e 28                	jle    800eab <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e83:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e87:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e8e:	00 
  800e8f:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800e96:	00 
  800e97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e9e:	00 
  800e9f:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800ea6:	e8 25 f3 ff ff       	call   8001d0 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eab:	83 c4 2c             	add    $0x2c,%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	57                   	push   %edi
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
  800eb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	89 df                	mov    %ebx,%edi
  800ece:	89 de                	mov    %ebx,%esi
  800ed0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	7e 28                	jle    800efe <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eda:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ee1:	00 
  800ee2:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800ee9:	00 
  800eea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef1:	00 
  800ef2:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800ef9:	e8 d2 f2 ff ff       	call   8001d0 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800efe:	83 c4 2c             	add    $0x2c,%esp
  800f01:	5b                   	pop    %ebx
  800f02:	5e                   	pop    %esi
  800f03:	5f                   	pop    %edi
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	57                   	push   %edi
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0c:	be 00 00 00 00       	mov    $0x0,%esi
  800f11:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f22:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f32:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f37:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	89 cb                	mov    %ecx,%ebx
  800f41:	89 cf                	mov    %ecx,%edi
  800f43:	89 ce                	mov    %ecx,%esi
  800f45:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f47:	85 c0                	test   %eax,%eax
  800f49:	7e 28                	jle    800f73 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f4f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f56:	00 
  800f57:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800f5e:	00 
  800f5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f66:	00 
  800f67:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800f6e:	e8 5d f2 ff ff       	call   8001d0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f73:	83 c4 2c             	add    $0x2c,%esp
  800f76:	5b                   	pop    %ebx
  800f77:	5e                   	pop    %esi
  800f78:	5f                   	pop    %edi
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	57                   	push   %edi
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f81:	ba 00 00 00 00       	mov    $0x0,%edx
  800f86:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f8b:	89 d1                	mov    %edx,%ecx
  800f8d:	89 d3                	mov    %edx,%ebx
  800f8f:	89 d7                	mov    %edx,%edi
  800f91:	89 d6                	mov    %edx,%esi
  800f93:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f95:	5b                   	pop    %ebx
  800f96:	5e                   	pop    %esi
  800f97:	5f                   	pop    %edi
  800f98:	5d                   	pop    %ebp
  800f99:	c3                   	ret    

00800f9a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	57                   	push   %edi
  800f9e:	56                   	push   %esi
  800f9f:	53                   	push   %ebx
  800fa0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb3:	89 df                	mov    %ebx,%edi
  800fb5:	89 de                	mov    %ebx,%esi
  800fb7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fb9:	85 c0                	test   %eax,%eax
  800fbb:	7e 28                	jle    800fe5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800fc8:	00 
  800fc9:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  800fd0:	00 
  800fd1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd8:	00 
  800fd9:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  800fe0:	e8 eb f1 ff ff       	call   8001d0 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800fe5:	83 c4 2c             	add    $0x2c,%esp
  800fe8:	5b                   	pop    %ebx
  800fe9:	5e                   	pop    %esi
  800fea:	5f                   	pop    %edi
  800feb:	5d                   	pop    %ebp
  800fec:	c3                   	ret    

00800fed <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	57                   	push   %edi
  800ff1:	56                   	push   %esi
  800ff2:	53                   	push   %ebx
  800ff3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ffb:	b8 10 00 00 00       	mov    $0x10,%eax
  801000:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801003:	8b 55 08             	mov    0x8(%ebp),%edx
  801006:	89 df                	mov    %ebx,%edi
  801008:	89 de                	mov    %ebx,%esi
  80100a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80100c:	85 c0                	test   %eax,%eax
  80100e:	7e 28                	jle    801038 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801010:	89 44 24 10          	mov    %eax,0x10(%esp)
  801014:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80101b:	00 
  80101c:	c7 44 24 08 9f 2b 80 	movl   $0x802b9f,0x8(%esp)
  801023:	00 
  801024:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80102b:	00 
  80102c:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  801033:	e8 98 f1 ff ff       	call   8001d0 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801038:	83 c4 2c             	add    $0x2c,%esp
  80103b:	5b                   	pop    %ebx
  80103c:	5e                   	pop    %esi
  80103d:	5f                   	pop    %edi
  80103e:	5d                   	pop    %ebp
  80103f:	c3                   	ret    

00801040 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	05 00 00 00 30       	add    $0x30000000,%eax
  80104b:	c1 e8 0c             	shr    $0xc,%eax
}
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80105b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801060:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    

00801067 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801072:	89 c2                	mov    %eax,%edx
  801074:	c1 ea 16             	shr    $0x16,%edx
  801077:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80107e:	f6 c2 01             	test   $0x1,%dl
  801081:	74 11                	je     801094 <fd_alloc+0x2d>
  801083:	89 c2                	mov    %eax,%edx
  801085:	c1 ea 0c             	shr    $0xc,%edx
  801088:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80108f:	f6 c2 01             	test   $0x1,%dl
  801092:	75 09                	jne    80109d <fd_alloc+0x36>
			*fd_store = fd;
  801094:	89 01                	mov    %eax,(%ecx)
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 17                	jmp    8010b4 <fd_alloc+0x4d>
  80109d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010a7:	75 c9                	jne    801072 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010bc:	83 f8 1f             	cmp    $0x1f,%eax
  8010bf:	77 36                	ja     8010f7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010c1:	c1 e0 0c             	shl    $0xc,%eax
  8010c4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010c9:	89 c2                	mov    %eax,%edx
  8010cb:	c1 ea 16             	shr    $0x16,%edx
  8010ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010d5:	f6 c2 01             	test   $0x1,%dl
  8010d8:	74 24                	je     8010fe <fd_lookup+0x48>
  8010da:	89 c2                	mov    %eax,%edx
  8010dc:	c1 ea 0c             	shr    $0xc,%edx
  8010df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010e6:	f6 c2 01             	test   $0x1,%dl
  8010e9:	74 1a                	je     801105 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ee:	89 02                	mov    %eax,(%edx)
	return 0;
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f5:	eb 13                	jmp    80110a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fc:	eb 0c                	jmp    80110a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801103:	eb 05                	jmp    80110a <fd_lookup+0x54>
  801105:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 18             	sub    $0x18,%esp
  801112:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801115:	ba 00 00 00 00       	mov    $0x0,%edx
  80111a:	eb 13                	jmp    80112f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80111c:	39 08                	cmp    %ecx,(%eax)
  80111e:	75 0c                	jne    80112c <dev_lookup+0x20>
			*dev = devtab[i];
  801120:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801123:	89 01                	mov    %eax,(%ecx)
			return 0;
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
  80112a:	eb 38                	jmp    801164 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80112c:	83 c2 01             	add    $0x1,%edx
  80112f:	8b 04 95 4c 2c 80 00 	mov    0x802c4c(,%edx,4),%eax
  801136:	85 c0                	test   %eax,%eax
  801138:	75 e2                	jne    80111c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80113a:	a1 20 60 80 00       	mov    0x806020,%eax
  80113f:	8b 40 48             	mov    0x48(%eax),%eax
  801142:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801146:	89 44 24 04          	mov    %eax,0x4(%esp)
  80114a:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  801151:	e8 73 f1 ff ff       	call   8002c9 <cprintf>
	*dev = 0;
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80115f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
  80116b:	83 ec 20             	sub    $0x20,%esp
  80116e:	8b 75 08             	mov    0x8(%ebp),%esi
  801171:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801174:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801177:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80117b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801181:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801184:	89 04 24             	mov    %eax,(%esp)
  801187:	e8 2a ff ff ff       	call   8010b6 <fd_lookup>
  80118c:	85 c0                	test   %eax,%eax
  80118e:	78 05                	js     801195 <fd_close+0x2f>
	    || fd != fd2)
  801190:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801193:	74 0c                	je     8011a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801195:	84 db                	test   %bl,%bl
  801197:	ba 00 00 00 00       	mov    $0x0,%edx
  80119c:	0f 44 c2             	cmove  %edx,%eax
  80119f:	eb 3f                	jmp    8011e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a8:	8b 06                	mov    (%esi),%eax
  8011aa:	89 04 24             	mov    %eax,(%esp)
  8011ad:	e8 5a ff ff ff       	call   80110c <dev_lookup>
  8011b2:	89 c3                	mov    %eax,%ebx
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	78 16                	js     8011ce <fd_close+0x68>
		if (dev->dev_close)
  8011b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	74 07                	je     8011ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011c7:	89 34 24             	mov    %esi,(%esp)
  8011ca:	ff d0                	call   *%eax
  8011cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d9:	e8 dc fb ff ff       	call   800dba <sys_page_unmap>
	return r;
  8011de:	89 d8                	mov    %ebx,%eax
}
  8011e0:	83 c4 20             	add    $0x20,%esp
  8011e3:	5b                   	pop    %ebx
  8011e4:	5e                   	pop    %esi
  8011e5:	5d                   	pop    %ebp
  8011e6:	c3                   	ret    

008011e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	89 04 24             	mov    %eax,(%esp)
  8011fa:	e8 b7 fe ff ff       	call   8010b6 <fd_lookup>
  8011ff:	89 c2                	mov    %eax,%edx
  801201:	85 d2                	test   %edx,%edx
  801203:	78 13                	js     801218 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801205:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80120c:	00 
  80120d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801210:	89 04 24             	mov    %eax,(%esp)
  801213:	e8 4e ff ff ff       	call   801166 <fd_close>
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <close_all>:

void
close_all(void)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	53                   	push   %ebx
  80121e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801221:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801226:	89 1c 24             	mov    %ebx,(%esp)
  801229:	e8 b9 ff ff ff       	call   8011e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80122e:	83 c3 01             	add    $0x1,%ebx
  801231:	83 fb 20             	cmp    $0x20,%ebx
  801234:	75 f0                	jne    801226 <close_all+0xc>
		close(i);
}
  801236:	83 c4 14             	add    $0x14,%esp
  801239:	5b                   	pop    %ebx
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    

0080123c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801245:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	89 04 24             	mov    %eax,(%esp)
  801252:	e8 5f fe ff ff       	call   8010b6 <fd_lookup>
  801257:	89 c2                	mov    %eax,%edx
  801259:	85 d2                	test   %edx,%edx
  80125b:	0f 88 e1 00 00 00    	js     801342 <dup+0x106>
		return r;
	close(newfdnum);
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	89 04 24             	mov    %eax,(%esp)
  801267:	e8 7b ff ff ff       	call   8011e7 <close>

	newfd = INDEX2FD(newfdnum);
  80126c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80126f:	c1 e3 0c             	shl    $0xc,%ebx
  801272:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80127b:	89 04 24             	mov    %eax,(%esp)
  80127e:	e8 cd fd ff ff       	call   801050 <fd2data>
  801283:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801285:	89 1c 24             	mov    %ebx,(%esp)
  801288:	e8 c3 fd ff ff       	call   801050 <fd2data>
  80128d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80128f:	89 f0                	mov    %esi,%eax
  801291:	c1 e8 16             	shr    $0x16,%eax
  801294:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80129b:	a8 01                	test   $0x1,%al
  80129d:	74 43                	je     8012e2 <dup+0xa6>
  80129f:	89 f0                	mov    %esi,%eax
  8012a1:	c1 e8 0c             	shr    $0xc,%eax
  8012a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ab:	f6 c2 01             	test   $0x1,%dl
  8012ae:	74 32                	je     8012e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012cb:	00 
  8012cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d7:	e8 8b fa ff ff       	call   800d67 <sys_page_map>
  8012dc:	89 c6                	mov    %eax,%esi
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	78 3e                	js     801320 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	c1 ea 0c             	shr    $0xc,%edx
  8012ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801306:	00 
  801307:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801312:	e8 50 fa ff ff       	call   800d67 <sys_page_map>
  801317:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80131c:	85 f6                	test   %esi,%esi
  80131e:	79 22                	jns    801342 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801320:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80132b:	e8 8a fa ff ff       	call   800dba <sys_page_unmap>
	sys_page_unmap(0, nva);
  801330:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801334:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133b:	e8 7a fa ff ff       	call   800dba <sys_page_unmap>
	return r;
  801340:	89 f0                	mov    %esi,%eax
}
  801342:	83 c4 3c             	add    $0x3c,%esp
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5f                   	pop    %edi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    

0080134a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	53                   	push   %ebx
  80134e:	83 ec 24             	sub    $0x24,%esp
  801351:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801354:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135b:	89 1c 24             	mov    %ebx,(%esp)
  80135e:	e8 53 fd ff ff       	call   8010b6 <fd_lookup>
  801363:	89 c2                	mov    %eax,%edx
  801365:	85 d2                	test   %edx,%edx
  801367:	78 6d                	js     8013d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	89 04 24             	mov    %eax,(%esp)
  801378:	e8 8f fd ff ff       	call   80110c <dev_lookup>
  80137d:	85 c0                	test   %eax,%eax
  80137f:	78 55                	js     8013d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801384:	8b 50 08             	mov    0x8(%eax),%edx
  801387:	83 e2 03             	and    $0x3,%edx
  80138a:	83 fa 01             	cmp    $0x1,%edx
  80138d:	75 23                	jne    8013b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80138f:	a1 20 60 80 00       	mov    0x806020,%eax
  801394:	8b 40 48             	mov    0x48(%eax),%eax
  801397:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80139b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139f:	c7 04 24 10 2c 80 00 	movl   $0x802c10,(%esp)
  8013a6:	e8 1e ef ff ff       	call   8002c9 <cprintf>
		return -E_INVAL;
  8013ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b0:	eb 24                	jmp    8013d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 52 08             	mov    0x8(%edx),%edx
  8013b8:	85 d2                	test   %edx,%edx
  8013ba:	74 15                	je     8013d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013ca:	89 04 24             	mov    %eax,(%esp)
  8013cd:	ff d2                	call   *%edx
  8013cf:	eb 05                	jmp    8013d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013d6:	83 c4 24             	add    $0x24,%esp
  8013d9:	5b                   	pop    %ebx
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	57                   	push   %edi
  8013e0:	56                   	push   %esi
  8013e1:	53                   	push   %ebx
  8013e2:	83 ec 1c             	sub    $0x1c,%esp
  8013e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f0:	eb 23                	jmp    801415 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f2:	89 f0                	mov    %esi,%eax
  8013f4:	29 d8                	sub    %ebx,%eax
  8013f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013fa:	89 d8                	mov    %ebx,%eax
  8013fc:	03 45 0c             	add    0xc(%ebp),%eax
  8013ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801403:	89 3c 24             	mov    %edi,(%esp)
  801406:	e8 3f ff ff ff       	call   80134a <read>
		if (m < 0)
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 10                	js     80141f <readn+0x43>
			return m;
		if (m == 0)
  80140f:	85 c0                	test   %eax,%eax
  801411:	74 0a                	je     80141d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801413:	01 c3                	add    %eax,%ebx
  801415:	39 f3                	cmp    %esi,%ebx
  801417:	72 d9                	jb     8013f2 <readn+0x16>
  801419:	89 d8                	mov    %ebx,%eax
  80141b:	eb 02                	jmp    80141f <readn+0x43>
  80141d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80141f:	83 c4 1c             	add    $0x1c,%esp
  801422:	5b                   	pop    %ebx
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	53                   	push   %ebx
  80142b:	83 ec 24             	sub    $0x24,%esp
  80142e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801431:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801434:	89 44 24 04          	mov    %eax,0x4(%esp)
  801438:	89 1c 24             	mov    %ebx,(%esp)
  80143b:	e8 76 fc ff ff       	call   8010b6 <fd_lookup>
  801440:	89 c2                	mov    %eax,%edx
  801442:	85 d2                	test   %edx,%edx
  801444:	78 68                	js     8014ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801446:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801449:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801450:	8b 00                	mov    (%eax),%eax
  801452:	89 04 24             	mov    %eax,(%esp)
  801455:	e8 b2 fc ff ff       	call   80110c <dev_lookup>
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 50                	js     8014ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80145e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801461:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801465:	75 23                	jne    80148a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801467:	a1 20 60 80 00       	mov    0x806020,%eax
  80146c:	8b 40 48             	mov    0x48(%eax),%eax
  80146f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801473:	89 44 24 04          	mov    %eax,0x4(%esp)
  801477:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  80147e:	e8 46 ee ff ff       	call   8002c9 <cprintf>
		return -E_INVAL;
  801483:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801488:	eb 24                	jmp    8014ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80148a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80148d:	8b 52 0c             	mov    0xc(%edx),%edx
  801490:	85 d2                	test   %edx,%edx
  801492:	74 15                	je     8014a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801494:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801497:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80149b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80149e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014a2:	89 04 24             	mov    %eax,(%esp)
  8014a5:	ff d2                	call   *%edx
  8014a7:	eb 05                	jmp    8014ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014ae:	83 c4 24             	add    $0x24,%esp
  8014b1:	5b                   	pop    %ebx
  8014b2:	5d                   	pop    %ebp
  8014b3:	c3                   	ret    

008014b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 04 24             	mov    %eax,(%esp)
  8014c7:	e8 ea fb ff ff       	call   8010b6 <fd_lookup>
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 0e                	js     8014de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 24             	sub    $0x24,%esp
  8014e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f1:	89 1c 24             	mov    %ebx,(%esp)
  8014f4:	e8 bd fb ff ff       	call   8010b6 <fd_lookup>
  8014f9:	89 c2                	mov    %eax,%edx
  8014fb:	85 d2                	test   %edx,%edx
  8014fd:	78 61                	js     801560 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801502:	89 44 24 04          	mov    %eax,0x4(%esp)
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	8b 00                	mov    (%eax),%eax
  80150b:	89 04 24             	mov    %eax,(%esp)
  80150e:	e8 f9 fb ff ff       	call   80110c <dev_lookup>
  801513:	85 c0                	test   %eax,%eax
  801515:	78 49                	js     801560 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80151e:	75 23                	jne    801543 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801520:	a1 20 60 80 00       	mov    0x806020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801525:	8b 40 48             	mov    0x48(%eax),%eax
  801528:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80152c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801530:	c7 04 24 ec 2b 80 00 	movl   $0x802bec,(%esp)
  801537:	e8 8d ed ff ff       	call   8002c9 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80153c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801541:	eb 1d                	jmp    801560 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801546:	8b 52 18             	mov    0x18(%edx),%edx
  801549:	85 d2                	test   %edx,%edx
  80154b:	74 0e                	je     80155b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80154d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801550:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801554:	89 04 24             	mov    %eax,(%esp)
  801557:	ff d2                	call   *%edx
  801559:	eb 05                	jmp    801560 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80155b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801560:	83 c4 24             	add    $0x24,%esp
  801563:	5b                   	pop    %ebx
  801564:	5d                   	pop    %ebp
  801565:	c3                   	ret    

00801566 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	53                   	push   %ebx
  80156a:	83 ec 24             	sub    $0x24,%esp
  80156d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801570:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801573:	89 44 24 04          	mov    %eax,0x4(%esp)
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	89 04 24             	mov    %eax,(%esp)
  80157d:	e8 34 fb ff ff       	call   8010b6 <fd_lookup>
  801582:	89 c2                	mov    %eax,%edx
  801584:	85 d2                	test   %edx,%edx
  801586:	78 52                	js     8015da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801588:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	89 04 24             	mov    %eax,(%esp)
  801597:	e8 70 fb ff ff       	call   80110c <dev_lookup>
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 3a                	js     8015da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015a7:	74 2c                	je     8015d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015b3:	00 00 00 
	stat->st_isdir = 0;
  8015b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015bd:	00 00 00 
	stat->st_dev = dev;
  8015c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cd:	89 14 24             	mov    %edx,(%esp)
  8015d0:	ff 50 14             	call   *0x14(%eax)
  8015d3:	eb 05                	jmp    8015da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015da:	83 c4 24             	add    $0x24,%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	56                   	push   %esi
  8015e4:	53                   	push   %ebx
  8015e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015ef:	00 
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	89 04 24             	mov    %eax,(%esp)
  8015f6:	e8 28 02 00 00       	call   801823 <open>
  8015fb:	89 c3                	mov    %eax,%ebx
  8015fd:	85 db                	test   %ebx,%ebx
  8015ff:	78 1b                	js     80161c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	89 44 24 04          	mov    %eax,0x4(%esp)
  801608:	89 1c 24             	mov    %ebx,(%esp)
  80160b:	e8 56 ff ff ff       	call   801566 <fstat>
  801610:	89 c6                	mov    %eax,%esi
	close(fd);
  801612:	89 1c 24             	mov    %ebx,(%esp)
  801615:	e8 cd fb ff ff       	call   8011e7 <close>
	return r;
  80161a:	89 f0                	mov    %esi,%eax
}
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	5b                   	pop    %ebx
  801620:	5e                   	pop    %esi
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    

00801623 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
  801628:	83 ec 10             	sub    $0x10,%esp
  80162b:	89 c6                	mov    %eax,%esi
  80162d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80162f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801636:	75 11                	jne    801649 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801638:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80163f:	e8 ba 0e 00 00       	call   8024fe <ipc_find_env>
  801644:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801649:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801650:	00 
  801651:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801658:	00 
  801659:	89 74 24 04          	mov    %esi,0x4(%esp)
  80165d:	a1 00 40 80 00       	mov    0x804000,%eax
  801662:	89 04 24             	mov    %eax,(%esp)
  801665:	e8 36 0e 00 00       	call   8024a0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80166a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801671:	00 
  801672:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801676:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80167d:	e8 b4 0d 00 00       	call   802436 <ipc_recv>
}
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	5b                   	pop    %ebx
  801686:	5e                   	pop    %esi
  801687:	5d                   	pop    %ebp
  801688:	c3                   	ret    

00801689 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8b 40 0c             	mov    0xc(%eax),%eax
  801695:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80169a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169d:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ac:	e8 72 ff ff ff       	call   801623 <fsipc>
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bf:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8016c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ce:	e8 50 ff ff ff       	call   801623 <fsipc>
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	53                   	push   %ebx
  8016d9:	83 ec 14             	sub    $0x14,%esp
  8016dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e5:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f4:	e8 2a ff ff ff       	call   801623 <fsipc>
  8016f9:	89 c2                	mov    %eax,%edx
  8016fb:	85 d2                	test   %edx,%edx
  8016fd:	78 2b                	js     80172a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016ff:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801706:	00 
  801707:	89 1c 24             	mov    %ebx,(%esp)
  80170a:	e8 e8 f1 ff ff       	call   8008f7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80170f:	a1 80 70 80 00       	mov    0x807080,%eax
  801714:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80171a:	a1 84 70 80 00       	mov    0x807084,%eax
  80171f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172a:	83 c4 14             	add    $0x14,%esp
  80172d:	5b                   	pop    %ebx
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 18             	sub    $0x18,%esp
  801736:	8b 45 10             	mov    0x10(%ebp),%eax
  801739:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80173e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801743:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801746:	a3 04 70 80 00       	mov    %eax,0x807004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	8b 52 0c             	mov    0xc(%edx),%edx
  801751:	89 15 00 70 80 00    	mov    %edx,0x807000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801757:	89 44 24 08          	mov    %eax,0x8(%esp)
  80175b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801762:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  801769:	e8 26 f3 ff ff       	call   800a94 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80176e:	ba 00 00 00 00       	mov    $0x0,%edx
  801773:	b8 04 00 00 00       	mov    $0x4,%eax
  801778:	e8 a6 fe ff ff       	call   801623 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	56                   	push   %esi
  801783:	53                   	push   %ebx
  801784:	83 ec 10             	sub    $0x10,%esp
  801787:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	8b 40 0c             	mov    0xc(%eax),%eax
  801790:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801795:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80179b:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a0:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a5:	e8 79 fe ff ff       	call   801623 <fsipc>
  8017aa:	89 c3                	mov    %eax,%ebx
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	78 6a                	js     80181a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017b0:	39 c6                	cmp    %eax,%esi
  8017b2:	73 24                	jae    8017d8 <devfile_read+0x59>
  8017b4:	c7 44 24 0c 60 2c 80 	movl   $0x802c60,0xc(%esp)
  8017bb:	00 
  8017bc:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  8017c3:	00 
  8017c4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8017cb:	00 
  8017cc:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  8017d3:	e8 f8 e9 ff ff       	call   8001d0 <_panic>
	assert(r <= PGSIZE);
  8017d8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017dd:	7e 24                	jle    801803 <devfile_read+0x84>
  8017df:	c7 44 24 0c 87 2c 80 	movl   $0x802c87,0xc(%esp)
  8017e6:	00 
  8017e7:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  8017ee:	00 
  8017ef:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8017f6:	00 
  8017f7:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  8017fe:	e8 cd e9 ff ff       	call   8001d0 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801803:	89 44 24 08          	mov    %eax,0x8(%esp)
  801807:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80180e:	00 
  80180f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801812:	89 04 24             	mov    %eax,(%esp)
  801815:	e8 7a f2 ff ff       	call   800a94 <memmove>
	return r;
}
  80181a:	89 d8                	mov    %ebx,%eax
  80181c:	83 c4 10             	add    $0x10,%esp
  80181f:	5b                   	pop    %ebx
  801820:	5e                   	pop    %esi
  801821:	5d                   	pop    %ebp
  801822:	c3                   	ret    

00801823 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	53                   	push   %ebx
  801827:	83 ec 24             	sub    $0x24,%esp
  80182a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80182d:	89 1c 24             	mov    %ebx,(%esp)
  801830:	e8 8b f0 ff ff       	call   8008c0 <strlen>
  801835:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80183a:	7f 60                	jg     80189c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80183c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183f:	89 04 24             	mov    %eax,(%esp)
  801842:	e8 20 f8 ff ff       	call   801067 <fd_alloc>
  801847:	89 c2                	mov    %eax,%edx
  801849:	85 d2                	test   %edx,%edx
  80184b:	78 54                	js     8018a1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80184d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801851:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  801858:	e8 9a f0 ff ff       	call   8008f7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80185d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801860:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801865:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801868:	b8 01 00 00 00       	mov    $0x1,%eax
  80186d:	e8 b1 fd ff ff       	call   801623 <fsipc>
  801872:	89 c3                	mov    %eax,%ebx
  801874:	85 c0                	test   %eax,%eax
  801876:	79 17                	jns    80188f <open+0x6c>
		fd_close(fd, 0);
  801878:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80187f:	00 
  801880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801883:	89 04 24             	mov    %eax,(%esp)
  801886:	e8 db f8 ff ff       	call   801166 <fd_close>
		return r;
  80188b:	89 d8                	mov    %ebx,%eax
  80188d:	eb 12                	jmp    8018a1 <open+0x7e>
	}

	return fd2num(fd);
  80188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801892:	89 04 24             	mov    %eax,(%esp)
  801895:	e8 a6 f7 ff ff       	call   801040 <fd2num>
  80189a:	eb 05                	jmp    8018a1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80189c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018a1:	83 c4 24             	add    $0x24,%esp
  8018a4:	5b                   	pop    %ebx
  8018a5:	5d                   	pop    %ebp
  8018a6:	c3                   	ret    

008018a7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b2:	b8 08 00 00 00       	mov    $0x8,%eax
  8018b7:	e8 67 fd ff ff       	call   801623 <fsipc>
}
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 14             	sub    $0x14,%esp
  8018c5:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8018c7:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8018cb:	7e 31                	jle    8018fe <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8018cd:	8b 40 04             	mov    0x4(%eax),%eax
  8018d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018d4:	8d 43 10             	lea    0x10(%ebx),%eax
  8018d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018db:	8b 03                	mov    (%ebx),%eax
  8018dd:	89 04 24             	mov    %eax,(%esp)
  8018e0:	e8 42 fb ff ff       	call   801427 <write>
		if (result > 0)
  8018e5:	85 c0                	test   %eax,%eax
  8018e7:	7e 03                	jle    8018ec <writebuf+0x2e>
			b->result += result;
  8018e9:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8018ec:	39 43 04             	cmp    %eax,0x4(%ebx)
  8018ef:	74 0d                	je     8018fe <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f8:	0f 4f c2             	cmovg  %edx,%eax
  8018fb:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8018fe:	83 c4 14             	add    $0x14,%esp
  801901:	5b                   	pop    %ebx
  801902:	5d                   	pop    %ebp
  801903:	c3                   	ret    

00801904 <putch>:

static void
putch(int ch, void *thunk)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
  801907:	53                   	push   %ebx
  801908:	83 ec 04             	sub    $0x4,%esp
  80190b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80190e:	8b 53 04             	mov    0x4(%ebx),%edx
  801911:	8d 42 01             	lea    0x1(%edx),%eax
  801914:	89 43 04             	mov    %eax,0x4(%ebx)
  801917:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80191a:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80191e:	3d 00 01 00 00       	cmp    $0x100,%eax
  801923:	75 0e                	jne    801933 <putch+0x2f>
		writebuf(b);
  801925:	89 d8                	mov    %ebx,%eax
  801927:	e8 92 ff ff ff       	call   8018be <writebuf>
		b->idx = 0;
  80192c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801933:	83 c4 04             	add    $0x4,%esp
  801936:	5b                   	pop    %ebx
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    

00801939 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80194b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801952:	00 00 00 
	b.result = 0;
  801955:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80195c:	00 00 00 
	b.error = 1;
  80195f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801966:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801969:	8b 45 10             	mov    0x10(%ebp),%eax
  80196c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801970:	8b 45 0c             	mov    0xc(%ebp),%eax
  801973:	89 44 24 08          	mov    %eax,0x8(%esp)
  801977:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80197d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801981:	c7 04 24 04 19 80 00 	movl   $0x801904,(%esp)
  801988:	e8 d1 ea ff ff       	call   80045e <vprintfmt>
	if (b.idx > 0)
  80198d:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801994:	7e 0b                	jle    8019a1 <vfprintf+0x68>
		writebuf(&b);
  801996:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80199c:	e8 1d ff ff ff       	call   8018be <writebuf>

	return (b.result ? b.result : b.error);
  8019a1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019a7:	85 c0                	test   %eax,%eax
  8019a9:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019b8:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  8019bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	89 04 24             	mov    %eax,(%esp)
  8019cc:	e8 68 ff ff ff       	call   801939 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019d1:	c9                   	leave  
  8019d2:	c3                   	ret    

008019d3 <printf>:

int
printf(const char *fmt, ...)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8019d9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8019dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019ee:	e8 46 ff ff ff       	call   801939 <vfprintf>
	va_end(ap);

	return cnt;
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    
  8019f5:	66 90                	xchg   %ax,%ax
  8019f7:	66 90                	xchg   %ax,%ax
  8019f9:	66 90                	xchg   %ax,%ax
  8019fb:	66 90                	xchg   %ax,%ax
  8019fd:	66 90                	xchg   %ax,%ax
  8019ff:	90                   	nop

00801a00 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801a06:	c7 44 24 04 93 2c 80 	movl   $0x802c93,0x4(%esp)
  801a0d:	00 
  801a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a11:	89 04 24             	mov    %eax,(%esp)
  801a14:	e8 de ee ff ff       	call   8008f7 <strcpy>
	return 0;
}
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	53                   	push   %ebx
  801a24:	83 ec 14             	sub    $0x14,%esp
  801a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a2a:	89 1c 24             	mov    %ebx,(%esp)
  801a2d:	e8 04 0b 00 00       	call   802536 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801a32:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801a37:	83 f8 01             	cmp    $0x1,%eax
  801a3a:	75 0d                	jne    801a49 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801a3c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801a3f:	89 04 24             	mov    %eax,(%esp)
  801a42:	e8 29 03 00 00       	call   801d70 <nsipc_close>
  801a47:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801a49:	89 d0                	mov    %edx,%eax
  801a4b:	83 c4 14             	add    $0x14,%esp
  801a4e:	5b                   	pop    %ebx
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a57:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a5e:	00 
  801a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	8b 40 0c             	mov    0xc(%eax),%eax
  801a73:	89 04 24             	mov    %eax,(%esp)
  801a76:	e8 f0 03 00 00       	call   801e6b <nsipc_send>
}
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a83:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a8a:	00 
  801a8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9f:	89 04 24             	mov    %eax,(%esp)
  801aa2:	e8 44 03 00 00       	call   801deb <nsipc_recv>
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801aaf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ab2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ab6:	89 04 24             	mov    %eax,(%esp)
  801ab9:	e8 f8 f5 ff ff       	call   8010b6 <fd_lookup>
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	78 17                	js     801ad9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801acb:	39 08                	cmp    %ecx,(%eax)
  801acd:	75 05                	jne    801ad4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801acf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad2:	eb 05                	jmp    801ad9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ad4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 20             	sub    $0x20,%esp
  801ae3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ae5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae8:	89 04 24             	mov    %eax,(%esp)
  801aeb:	e8 77 f5 ff ff       	call   801067 <fd_alloc>
  801af0:	89 c3                	mov    %eax,%ebx
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 21                	js     801b17 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801af6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801afd:	00 
  801afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b0c:	e8 02 f2 ff ff       	call   800d13 <sys_page_alloc>
  801b11:	89 c3                	mov    %eax,%ebx
  801b13:	85 c0                	test   %eax,%eax
  801b15:	79 0c                	jns    801b23 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801b17:	89 34 24             	mov    %esi,(%esp)
  801b1a:	e8 51 02 00 00       	call   801d70 <nsipc_close>
		return r;
  801b1f:	89 d8                	mov    %ebx,%eax
  801b21:	eb 20                	jmp    801b43 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b23:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b31:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801b38:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801b3b:	89 14 24             	mov    %edx,(%esp)
  801b3e:	e8 fd f4 ff ff       	call   801040 <fd2num>
}
  801b43:	83 c4 20             	add    $0x20,%esp
  801b46:	5b                   	pop    %ebx
  801b47:	5e                   	pop    %esi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    

00801b4a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	e8 51 ff ff ff       	call   801aa9 <fd2sockid>
		return r;
  801b58:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	78 23                	js     801b81 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b5e:	8b 55 10             	mov    0x10(%ebp),%edx
  801b61:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b6c:	89 04 24             	mov    %eax,(%esp)
  801b6f:	e8 45 01 00 00       	call   801cb9 <nsipc_accept>
		return r;
  801b74:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b76:	85 c0                	test   %eax,%eax
  801b78:	78 07                	js     801b81 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801b7a:	e8 5c ff ff ff       	call   801adb <alloc_sockfd>
  801b7f:	89 c1                	mov    %eax,%ecx
}
  801b81:	89 c8                	mov    %ecx,%eax
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	e8 16 ff ff ff       	call   801aa9 <fd2sockid>
  801b93:	89 c2                	mov    %eax,%edx
  801b95:	85 d2                	test   %edx,%edx
  801b97:	78 16                	js     801baf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801b99:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba7:	89 14 24             	mov    %edx,(%esp)
  801baa:	e8 60 01 00 00       	call   801d0f <nsipc_bind>
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <shutdown>:

int
shutdown(int s, int how)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	e8 ea fe ff ff       	call   801aa9 <fd2sockid>
  801bbf:	89 c2                	mov    %eax,%edx
  801bc1:	85 d2                	test   %edx,%edx
  801bc3:	78 0f                	js     801bd4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcc:	89 14 24             	mov    %edx,(%esp)
  801bcf:	e8 7a 01 00 00       	call   801d4e <nsipc_shutdown>
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	e8 c5 fe ff ff       	call   801aa9 <fd2sockid>
  801be4:	89 c2                	mov    %eax,%edx
  801be6:	85 d2                	test   %edx,%edx
  801be8:	78 16                	js     801c00 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801bea:	8b 45 10             	mov    0x10(%ebp),%eax
  801bed:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf8:	89 14 24             	mov    %edx,(%esp)
  801bfb:	e8 8a 01 00 00       	call   801d8a <nsipc_connect>
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <listen>:

int
listen(int s, int backlog)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	e8 99 fe ff ff       	call   801aa9 <fd2sockid>
  801c10:	89 c2                	mov    %eax,%edx
  801c12:	85 d2                	test   %edx,%edx
  801c14:	78 0f                	js     801c25 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801c16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1d:	89 14 24             	mov    %edx,(%esp)
  801c20:	e8 a4 01 00 00       	call   801dc9 <nsipc_listen>
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c30:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	89 04 24             	mov    %eax,(%esp)
  801c41:	e8 98 02 00 00       	call   801ede <nsipc_socket>
  801c46:	89 c2                	mov    %eax,%edx
  801c48:	85 d2                	test   %edx,%edx
  801c4a:	78 05                	js     801c51 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801c4c:	e8 8a fe ff ff       	call   801adb <alloc_sockfd>
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	53                   	push   %ebx
  801c57:	83 ec 14             	sub    $0x14,%esp
  801c5a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c5c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c63:	75 11                	jne    801c76 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c65:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801c6c:	e8 8d 08 00 00       	call   8024fe <ipc_find_env>
  801c71:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c76:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c7d:	00 
  801c7e:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  801c85:	00 
  801c86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c8a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c8f:	89 04 24             	mov    %eax,(%esp)
  801c92:	e8 09 08 00 00       	call   8024a0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c9e:	00 
  801c9f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ca6:	00 
  801ca7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cae:	e8 83 07 00 00       	call   802436 <ipc_recv>
}
  801cb3:	83 c4 14             	add    $0x14,%esp
  801cb6:	5b                   	pop    %ebx
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    

00801cb9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	56                   	push   %esi
  801cbd:	53                   	push   %ebx
  801cbe:	83 ec 10             	sub    $0x10,%esp
  801cc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ccc:	8b 06                	mov    (%esi),%eax
  801cce:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd8:	e8 76 ff ff ff       	call   801c53 <nsipc>
  801cdd:	89 c3                	mov    %eax,%ebx
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	78 23                	js     801d06 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ce3:	a1 10 80 80 00       	mov    0x808010,%eax
  801ce8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cec:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801cf3:	00 
  801cf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf7:	89 04 24             	mov    %eax,(%esp)
  801cfa:	e8 95 ed ff ff       	call   800a94 <memmove>
		*addrlen = ret->ret_addrlen;
  801cff:	a1 10 80 80 00       	mov    0x808010,%eax
  801d04:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801d06:	89 d8                	mov    %ebx,%eax
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5d                   	pop    %ebp
  801d0e:	c3                   	ret    

00801d0f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	53                   	push   %ebx
  801d13:	83 ec 14             	sub    $0x14,%esp
  801d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d21:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  801d33:	e8 5c ed ff ff       	call   800a94 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d38:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801d3e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d43:	e8 0b ff ff ff       	call   801c53 <nsipc>
}
  801d48:	83 c4 14             	add    $0x14,%esp
  801d4b:	5b                   	pop    %ebx
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    

00801d4e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801d64:	b8 03 00 00 00       	mov    $0x3,%eax
  801d69:	e8 e5 fe ff ff       	call   801c53 <nsipc>
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <nsipc_close>:

int
nsipc_close(int s)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d76:	8b 45 08             	mov    0x8(%ebp),%eax
  801d79:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801d7e:	b8 04 00 00 00       	mov    $0x4,%eax
  801d83:	e8 cb fe ff ff       	call   801c53 <nsipc>
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	53                   	push   %ebx
  801d8e:	83 ec 14             	sub    $0x14,%esp
  801d91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801d9c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da7:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  801dae:	e8 e1 ec ff ff       	call   800a94 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801db3:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801db9:	b8 05 00 00 00       	mov    $0x5,%eax
  801dbe:	e8 90 fe ff ff       	call   801c53 <nsipc>
}
  801dc3:	83 c4 14             	add    $0x14,%esp
  801dc6:	5b                   	pop    %ebx
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    

00801dc9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dda:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801ddf:	b8 06 00 00 00       	mov    $0x6,%eax
  801de4:	e8 6a fe ff ff       	call   801c53 <nsipc>
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
  801dee:	56                   	push   %esi
  801def:	53                   	push   %ebx
  801df0:	83 ec 10             	sub    $0x10,%esp
  801df3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801dfe:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801e04:	8b 45 14             	mov    0x14(%ebp),%eax
  801e07:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e0c:	b8 07 00 00 00       	mov    $0x7,%eax
  801e11:	e8 3d fe ff ff       	call   801c53 <nsipc>
  801e16:	89 c3                	mov    %eax,%ebx
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	78 46                	js     801e62 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801e1c:	39 f0                	cmp    %esi,%eax
  801e1e:	7f 07                	jg     801e27 <nsipc_recv+0x3c>
  801e20:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e25:	7e 24                	jle    801e4b <nsipc_recv+0x60>
  801e27:	c7 44 24 0c 9f 2c 80 	movl   $0x802c9f,0xc(%esp)
  801e2e:	00 
  801e2f:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  801e36:	00 
  801e37:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801e3e:	00 
  801e3f:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  801e46:	e8 85 e3 ff ff       	call   8001d0 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e4b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e4f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801e56:	00 
  801e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5a:	89 04 24             	mov    %eax,(%esp)
  801e5d:	e8 32 ec ff ff       	call   800a94 <memmove>
	}

	return r;
}
  801e62:	89 d8                	mov    %ebx,%eax
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5d                   	pop    %ebp
  801e6a:	c3                   	ret    

00801e6b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	53                   	push   %ebx
  801e6f:	83 ec 14             	sub    $0x14,%esp
  801e72:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801e7d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e83:	7e 24                	jle    801ea9 <nsipc_send+0x3e>
  801e85:	c7 44 24 0c c0 2c 80 	movl   $0x802cc0,0xc(%esp)
  801e8c:	00 
  801e8d:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  801e94:	00 
  801e95:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801e9c:	00 
  801e9d:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  801ea4:	e8 27 e3 ff ff       	call   8001d0 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ea9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ead:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb4:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  801ebb:	e8 d4 eb ff ff       	call   800a94 <memmove>
	nsipcbuf.send.req_size = size;
  801ec0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801ec6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801ece:	b8 08 00 00 00       	mov    $0x8,%eax
  801ed3:	e8 7b fd ff ff       	call   801c53 <nsipc>
}
  801ed8:	83 c4 14             	add    $0x14,%esp
  801edb:	5b                   	pop    %ebx
  801edc:	5d                   	pop    %ebp
  801edd:	c3                   	ret    

00801ede <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eef:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801efc:	b8 09 00 00 00       	mov    $0x9,%eax
  801f01:	e8 4d fd ff ff       	call   801c53 <nsipc>
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
  801f0b:	56                   	push   %esi
  801f0c:	53                   	push   %ebx
  801f0d:	83 ec 10             	sub    $0x10,%esp
  801f10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f13:	8b 45 08             	mov    0x8(%ebp),%eax
  801f16:	89 04 24             	mov    %eax,(%esp)
  801f19:	e8 32 f1 ff ff       	call   801050 <fd2data>
  801f1e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f20:	c7 44 24 04 cc 2c 80 	movl   $0x802ccc,0x4(%esp)
  801f27:	00 
  801f28:	89 1c 24             	mov    %ebx,(%esp)
  801f2b:	e8 c7 e9 ff ff       	call   8008f7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f30:	8b 46 04             	mov    0x4(%esi),%eax
  801f33:	2b 06                	sub    (%esi),%eax
  801f35:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f3b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f42:	00 00 00 
	stat->st_dev = &devpipe;
  801f45:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f4c:	30 80 00 
	return 0;
}
  801f4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5d                   	pop    %ebp
  801f5a:	c3                   	ret    

00801f5b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	53                   	push   %ebx
  801f5f:	83 ec 14             	sub    $0x14,%esp
  801f62:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f65:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f70:	e8 45 ee ff ff       	call   800dba <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f75:	89 1c 24             	mov    %ebx,(%esp)
  801f78:	e8 d3 f0 ff ff       	call   801050 <fd2data>
  801f7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f88:	e8 2d ee ff ff       	call   800dba <sys_page_unmap>
}
  801f8d:	83 c4 14             	add    $0x14,%esp
  801f90:	5b                   	pop    %ebx
  801f91:	5d                   	pop    %ebp
  801f92:	c3                   	ret    

00801f93 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	57                   	push   %edi
  801f97:	56                   	push   %esi
  801f98:	53                   	push   %ebx
  801f99:	83 ec 2c             	sub    $0x2c,%esp
  801f9c:	89 c6                	mov    %eax,%esi
  801f9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801fa1:	a1 20 60 80 00       	mov    0x806020,%eax
  801fa6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fa9:	89 34 24             	mov    %esi,(%esp)
  801fac:	e8 85 05 00 00       	call   802536 <pageref>
  801fb1:	89 c7                	mov    %eax,%edi
  801fb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fb6:	89 04 24             	mov    %eax,(%esp)
  801fb9:	e8 78 05 00 00       	call   802536 <pageref>
  801fbe:	39 c7                	cmp    %eax,%edi
  801fc0:	0f 94 c2             	sete   %dl
  801fc3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801fc6:	8b 0d 20 60 80 00    	mov    0x806020,%ecx
  801fcc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801fcf:	39 fb                	cmp    %edi,%ebx
  801fd1:	74 21                	je     801ff4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801fd3:	84 d2                	test   %dl,%dl
  801fd5:	74 ca                	je     801fa1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801fd7:	8b 51 58             	mov    0x58(%ecx),%edx
  801fda:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fde:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fe2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fe6:	c7 04 24 d3 2c 80 00 	movl   $0x802cd3,(%esp)
  801fed:	e8 d7 e2 ff ff       	call   8002c9 <cprintf>
  801ff2:	eb ad                	jmp    801fa1 <_pipeisclosed+0xe>
	}
}
  801ff4:	83 c4 2c             	add    $0x2c,%esp
  801ff7:	5b                   	pop    %ebx
  801ff8:	5e                   	pop    %esi
  801ff9:	5f                   	pop    %edi
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    

00801ffc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	57                   	push   %edi
  802000:	56                   	push   %esi
  802001:	53                   	push   %ebx
  802002:	83 ec 1c             	sub    $0x1c,%esp
  802005:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802008:	89 34 24             	mov    %esi,(%esp)
  80200b:	e8 40 f0 ff ff       	call   801050 <fd2data>
  802010:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802012:	bf 00 00 00 00       	mov    $0x0,%edi
  802017:	eb 45                	jmp    80205e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802019:	89 da                	mov    %ebx,%edx
  80201b:	89 f0                	mov    %esi,%eax
  80201d:	e8 71 ff ff ff       	call   801f93 <_pipeisclosed>
  802022:	85 c0                	test   %eax,%eax
  802024:	75 41                	jne    802067 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802026:	e8 c9 ec ff ff       	call   800cf4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80202b:	8b 43 04             	mov    0x4(%ebx),%eax
  80202e:	8b 0b                	mov    (%ebx),%ecx
  802030:	8d 51 20             	lea    0x20(%ecx),%edx
  802033:	39 d0                	cmp    %edx,%eax
  802035:	73 e2                	jae    802019 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802037:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80203a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80203e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802041:	99                   	cltd   
  802042:	c1 ea 1b             	shr    $0x1b,%edx
  802045:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802048:	83 e1 1f             	and    $0x1f,%ecx
  80204b:	29 d1                	sub    %edx,%ecx
  80204d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802051:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802055:	83 c0 01             	add    $0x1,%eax
  802058:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80205b:	83 c7 01             	add    $0x1,%edi
  80205e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802061:	75 c8                	jne    80202b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802063:	89 f8                	mov    %edi,%eax
  802065:	eb 05                	jmp    80206c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80206c:	83 c4 1c             	add    $0x1c,%esp
  80206f:	5b                   	pop    %ebx
  802070:	5e                   	pop    %esi
  802071:	5f                   	pop    %edi
  802072:	5d                   	pop    %ebp
  802073:	c3                   	ret    

00802074 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
  802077:	57                   	push   %edi
  802078:	56                   	push   %esi
  802079:	53                   	push   %ebx
  80207a:	83 ec 1c             	sub    $0x1c,%esp
  80207d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802080:	89 3c 24             	mov    %edi,(%esp)
  802083:	e8 c8 ef ff ff       	call   801050 <fd2data>
  802088:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80208a:	be 00 00 00 00       	mov    $0x0,%esi
  80208f:	eb 3d                	jmp    8020ce <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802091:	85 f6                	test   %esi,%esi
  802093:	74 04                	je     802099 <devpipe_read+0x25>
				return i;
  802095:	89 f0                	mov    %esi,%eax
  802097:	eb 43                	jmp    8020dc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802099:	89 da                	mov    %ebx,%edx
  80209b:	89 f8                	mov    %edi,%eax
  80209d:	e8 f1 fe ff ff       	call   801f93 <_pipeisclosed>
  8020a2:	85 c0                	test   %eax,%eax
  8020a4:	75 31                	jne    8020d7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8020a6:	e8 49 ec ff ff       	call   800cf4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8020ab:	8b 03                	mov    (%ebx),%eax
  8020ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020b0:	74 df                	je     802091 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020b2:	99                   	cltd   
  8020b3:	c1 ea 1b             	shr    $0x1b,%edx
  8020b6:	01 d0                	add    %edx,%eax
  8020b8:	83 e0 1f             	and    $0x1f,%eax
  8020bb:	29 d0                	sub    %edx,%eax
  8020bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020c8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020cb:	83 c6 01             	add    $0x1,%esi
  8020ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020d1:	75 d8                	jne    8020ab <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020d3:	89 f0                	mov    %esi,%eax
  8020d5:	eb 05                	jmp    8020dc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020d7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020dc:	83 c4 1c             	add    $0x1c,%esp
  8020df:	5b                   	pop    %ebx
  8020e0:	5e                   	pop    %esi
  8020e1:	5f                   	pop    %edi
  8020e2:	5d                   	pop    %ebp
  8020e3:	c3                   	ret    

008020e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	56                   	push   %esi
  8020e8:	53                   	push   %ebx
  8020e9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8020ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ef:	89 04 24             	mov    %eax,(%esp)
  8020f2:	e8 70 ef ff ff       	call   801067 <fd_alloc>
  8020f7:	89 c2                	mov    %eax,%edx
  8020f9:	85 d2                	test   %edx,%edx
  8020fb:	0f 88 4d 01 00 00    	js     80224e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802101:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802108:	00 
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802117:	e8 f7 eb ff ff       	call   800d13 <sys_page_alloc>
  80211c:	89 c2                	mov    %eax,%edx
  80211e:	85 d2                	test   %edx,%edx
  802120:	0f 88 28 01 00 00    	js     80224e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802126:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802129:	89 04 24             	mov    %eax,(%esp)
  80212c:	e8 36 ef ff ff       	call   801067 <fd_alloc>
  802131:	89 c3                	mov    %eax,%ebx
  802133:	85 c0                	test   %eax,%eax
  802135:	0f 88 fe 00 00 00    	js     802239 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80213b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802142:	00 
  802143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802146:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802151:	e8 bd eb ff ff       	call   800d13 <sys_page_alloc>
  802156:	89 c3                	mov    %eax,%ebx
  802158:	85 c0                	test   %eax,%eax
  80215a:	0f 88 d9 00 00 00    	js     802239 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802163:	89 04 24             	mov    %eax,(%esp)
  802166:	e8 e5 ee ff ff       	call   801050 <fd2data>
  80216b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80216d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802174:	00 
  802175:	89 44 24 04          	mov    %eax,0x4(%esp)
  802179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802180:	e8 8e eb ff ff       	call   800d13 <sys_page_alloc>
  802185:	89 c3                	mov    %eax,%ebx
  802187:	85 c0                	test   %eax,%eax
  802189:	0f 88 97 00 00 00    	js     802226 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80218f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802192:	89 04 24             	mov    %eax,(%esp)
  802195:	e8 b6 ee ff ff       	call   801050 <fd2data>
  80219a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8021a1:	00 
  8021a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021ad:	00 
  8021ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b9:	e8 a9 eb ff ff       	call   800d67 <sys_page_map>
  8021be:	89 c3                	mov    %eax,%ebx
  8021c0:	85 c0                	test   %eax,%eax
  8021c2:	78 52                	js     802216 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021c4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021d9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8021e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	89 04 24             	mov    %eax,(%esp)
  8021f4:	e8 47 ee ff ff       	call   801040 <fd2num>
  8021f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021fc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8021fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802201:	89 04 24             	mov    %eax,(%esp)
  802204:	e8 37 ee ff ff       	call   801040 <fd2num>
  802209:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80220c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	eb 38                	jmp    80224e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802216:	89 74 24 04          	mov    %esi,0x4(%esp)
  80221a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802221:	e8 94 eb ff ff       	call   800dba <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802229:	89 44 24 04          	mov    %eax,0x4(%esp)
  80222d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802234:	e8 81 eb ff ff       	call   800dba <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802247:	e8 6e eb ff ff       	call   800dba <sys_page_unmap>
  80224c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80224e:	83 c4 30             	add    $0x30,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    

00802255 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80225b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	89 04 24             	mov    %eax,(%esp)
  802268:	e8 49 ee ff ff       	call   8010b6 <fd_lookup>
  80226d:	89 c2                	mov    %eax,%edx
  80226f:	85 d2                	test   %edx,%edx
  802271:	78 15                	js     802288 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	89 04 24             	mov    %eax,(%esp)
  802279:	e8 d2 ed ff ff       	call   801050 <fd2data>
	return _pipeisclosed(fd, p);
  80227e:	89 c2                	mov    %eax,%edx
  802280:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802283:	e8 0b fd ff ff       	call   801f93 <_pipeisclosed>
}
  802288:	c9                   	leave  
  802289:	c3                   	ret    
  80228a:	66 90                	xchg   %ax,%ax
  80228c:	66 90                	xchg   %ax,%ax
  80228e:	66 90                	xchg   %ax,%ax

00802290 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802293:	b8 00 00 00 00       	mov    $0x0,%eax
  802298:	5d                   	pop    %ebp
  802299:	c3                   	ret    

0080229a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022a0:	c7 44 24 04 eb 2c 80 	movl   $0x802ceb,0x4(%esp)
  8022a7:	00 
  8022a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ab:	89 04 24             	mov    %eax,(%esp)
  8022ae:	e8 44 e6 ff ff       	call   8008f7 <strcpy>
	return 0;
}
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	57                   	push   %edi
  8022be:	56                   	push   %esi
  8022bf:	53                   	push   %ebx
  8022c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022cb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022d1:	eb 31                	jmp    802304 <devcons_write+0x4a>
		m = n - tot;
  8022d3:	8b 75 10             	mov    0x10(%ebp),%esi
  8022d6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8022d8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022db:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8022e0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022e3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022e7:	03 45 0c             	add    0xc(%ebp),%eax
  8022ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ee:	89 3c 24             	mov    %edi,(%esp)
  8022f1:	e8 9e e7 ff ff       	call   800a94 <memmove>
		sys_cputs(buf, m);
  8022f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022fa:	89 3c 24             	mov    %edi,(%esp)
  8022fd:	e8 44 e9 ff ff       	call   800c46 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802302:	01 f3                	add    %esi,%ebx
  802304:	89 d8                	mov    %ebx,%eax
  802306:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802309:	72 c8                	jb     8022d3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80230b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802311:	5b                   	pop    %ebx
  802312:	5e                   	pop    %esi
  802313:	5f                   	pop    %edi
  802314:	5d                   	pop    %ebp
  802315:	c3                   	ret    

00802316 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80231c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802321:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802325:	75 07                	jne    80232e <devcons_read+0x18>
  802327:	eb 2a                	jmp    802353 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802329:	e8 c6 e9 ff ff       	call   800cf4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80232e:	66 90                	xchg   %ax,%ax
  802330:	e8 2f e9 ff ff       	call   800c64 <sys_cgetc>
  802335:	85 c0                	test   %eax,%eax
  802337:	74 f0                	je     802329 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802339:	85 c0                	test   %eax,%eax
  80233b:	78 16                	js     802353 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80233d:	83 f8 04             	cmp    $0x4,%eax
  802340:	74 0c                	je     80234e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802342:	8b 55 0c             	mov    0xc(%ebp),%edx
  802345:	88 02                	mov    %al,(%edx)
	return 1;
  802347:	b8 01 00 00 00       	mov    $0x1,%eax
  80234c:	eb 05                	jmp    802353 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80234e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802361:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802368:	00 
  802369:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80236c:	89 04 24             	mov    %eax,(%esp)
  80236f:	e8 d2 e8 ff ff       	call   800c46 <sys_cputs>
}
  802374:	c9                   	leave  
  802375:	c3                   	ret    

00802376 <getchar>:

int
getchar(void)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80237c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802383:	00 
  802384:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802387:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802392:	e8 b3 ef ff ff       	call   80134a <read>
	if (r < 0)
  802397:	85 c0                	test   %eax,%eax
  802399:	78 0f                	js     8023aa <getchar+0x34>
		return r;
	if (r < 1)
  80239b:	85 c0                	test   %eax,%eax
  80239d:	7e 06                	jle    8023a5 <getchar+0x2f>
		return -E_EOF;
	return c;
  80239f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8023a3:	eb 05                	jmp    8023aa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8023a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8023aa:	c9                   	leave  
  8023ab:	c3                   	ret    

008023ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	89 04 24             	mov    %eax,(%esp)
  8023bf:	e8 f2 ec ff ff       	call   8010b6 <fd_lookup>
  8023c4:	85 c0                	test   %eax,%eax
  8023c6:	78 11                	js     8023d9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023d1:	39 10                	cmp    %edx,(%eax)
  8023d3:	0f 94 c0             	sete   %al
  8023d6:	0f b6 c0             	movzbl %al,%eax
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <opencons>:

int
opencons(void)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023e4:	89 04 24             	mov    %eax,(%esp)
  8023e7:	e8 7b ec ff ff       	call   801067 <fd_alloc>
		return r;
  8023ec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023ee:	85 c0                	test   %eax,%eax
  8023f0:	78 40                	js     802432 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023f9:	00 
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802401:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802408:	e8 06 e9 ff ff       	call   800d13 <sys_page_alloc>
		return r;
  80240d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80240f:	85 c0                	test   %eax,%eax
  802411:	78 1f                	js     802432 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802413:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802428:	89 04 24             	mov    %eax,(%esp)
  80242b:	e8 10 ec ff ff       	call   801040 <fd2num>
  802430:	89 c2                	mov    %eax,%edx
}
  802432:	89 d0                	mov    %edx,%eax
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	56                   	push   %esi
  80243a:	53                   	push   %ebx
  80243b:	83 ec 10             	sub    $0x10,%esp
  80243e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802441:	8b 45 0c             	mov    0xc(%ebp),%eax
  802444:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802447:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802449:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80244e:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802451:	89 04 24             	mov    %eax,(%esp)
  802454:	e8 d0 ea ff ff       	call   800f29 <sys_ipc_recv>
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 1e                	jne    80247b <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80245d:	85 db                	test   %ebx,%ebx
  80245f:	74 0a                	je     80246b <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802461:	a1 20 60 80 00       	mov    0x806020,%eax
  802466:	8b 40 74             	mov    0x74(%eax),%eax
  802469:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80246b:	85 f6                	test   %esi,%esi
  80246d:	74 22                	je     802491 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80246f:	a1 20 60 80 00       	mov    0x806020,%eax
  802474:	8b 40 78             	mov    0x78(%eax),%eax
  802477:	89 06                	mov    %eax,(%esi)
  802479:	eb 16                	jmp    802491 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80247b:	85 f6                	test   %esi,%esi
  80247d:	74 06                	je     802485 <ipc_recv+0x4f>
				*perm_store = 0;
  80247f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802485:	85 db                	test   %ebx,%ebx
  802487:	74 10                	je     802499 <ipc_recv+0x63>
				*from_env_store=0;
  802489:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80248f:	eb 08                	jmp    802499 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802491:	a1 20 60 80 00       	mov    0x806020,%eax
  802496:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802499:	83 c4 10             	add    $0x10,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5e                   	pop    %esi
  80249e:	5d                   	pop    %ebp
  80249f:	c3                   	ret    

008024a0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
  8024a3:	57                   	push   %edi
  8024a4:	56                   	push   %esi
  8024a5:	53                   	push   %ebx
  8024a6:	83 ec 1c             	sub    $0x1c,%esp
  8024a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024af:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8024b2:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8024b4:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8024b9:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8024bc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024c0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cb:	89 04 24             	mov    %eax,(%esp)
  8024ce:	e8 33 ea ff ff       	call   800f06 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8024d3:	eb 1c                	jmp    8024f1 <ipc_send+0x51>
	{
		sys_yield();
  8024d5:	e8 1a e8 ff ff       	call   800cf4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8024da:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e9:	89 04 24             	mov    %eax,(%esp)
  8024ec:	e8 15 ea ff ff       	call   800f06 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8024f1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024f4:	74 df                	je     8024d5 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8024f6:	83 c4 1c             	add    $0x1c,%esp
  8024f9:	5b                   	pop    %ebx
  8024fa:	5e                   	pop    %esi
  8024fb:	5f                   	pop    %edi
  8024fc:	5d                   	pop    %ebp
  8024fd:	c3                   	ret    

008024fe <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802504:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802509:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80250c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802512:	8b 52 50             	mov    0x50(%edx),%edx
  802515:	39 ca                	cmp    %ecx,%edx
  802517:	75 0d                	jne    802526 <ipc_find_env+0x28>
			return envs[i].env_id;
  802519:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80251c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802521:	8b 40 40             	mov    0x40(%eax),%eax
  802524:	eb 0e                	jmp    802534 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802526:	83 c0 01             	add    $0x1,%eax
  802529:	3d 00 04 00 00       	cmp    $0x400,%eax
  80252e:	75 d9                	jne    802509 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802530:	66 b8 00 00          	mov    $0x0,%ax
}
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    

00802536 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80253c:	89 d0                	mov    %edx,%eax
  80253e:	c1 e8 16             	shr    $0x16,%eax
  802541:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802548:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80254d:	f6 c1 01             	test   $0x1,%cl
  802550:	74 1d                	je     80256f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802552:	c1 ea 0c             	shr    $0xc,%edx
  802555:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80255c:	f6 c2 01             	test   $0x1,%dl
  80255f:	74 0e                	je     80256f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802561:	c1 ea 0c             	shr    $0xc,%edx
  802564:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80256b:	ef 
  80256c:	0f b7 c0             	movzwl %ax,%eax
}
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    
  802571:	66 90                	xchg   %ax,%ax
  802573:	66 90                	xchg   %ax,%ax
  802575:	66 90                	xchg   %ax,%ax
  802577:	66 90                	xchg   %ax,%ax
  802579:	66 90                	xchg   %ax,%ax
  80257b:	66 90                	xchg   %ax,%ax
  80257d:	66 90                	xchg   %ax,%ax
  80257f:	90                   	nop

00802580 <__udivdi3>:
  802580:	55                   	push   %ebp
  802581:	57                   	push   %edi
  802582:	56                   	push   %esi
  802583:	83 ec 0c             	sub    $0xc,%esp
  802586:	8b 44 24 28          	mov    0x28(%esp),%eax
  80258a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80258e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802592:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802596:	85 c0                	test   %eax,%eax
  802598:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80259c:	89 ea                	mov    %ebp,%edx
  80259e:	89 0c 24             	mov    %ecx,(%esp)
  8025a1:	75 2d                	jne    8025d0 <__udivdi3+0x50>
  8025a3:	39 e9                	cmp    %ebp,%ecx
  8025a5:	77 61                	ja     802608 <__udivdi3+0x88>
  8025a7:	85 c9                	test   %ecx,%ecx
  8025a9:	89 ce                	mov    %ecx,%esi
  8025ab:	75 0b                	jne    8025b8 <__udivdi3+0x38>
  8025ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b2:	31 d2                	xor    %edx,%edx
  8025b4:	f7 f1                	div    %ecx
  8025b6:	89 c6                	mov    %eax,%esi
  8025b8:	31 d2                	xor    %edx,%edx
  8025ba:	89 e8                	mov    %ebp,%eax
  8025bc:	f7 f6                	div    %esi
  8025be:	89 c5                	mov    %eax,%ebp
  8025c0:	89 f8                	mov    %edi,%eax
  8025c2:	f7 f6                	div    %esi
  8025c4:	89 ea                	mov    %ebp,%edx
  8025c6:	83 c4 0c             	add    $0xc,%esp
  8025c9:	5e                   	pop    %esi
  8025ca:	5f                   	pop    %edi
  8025cb:	5d                   	pop    %ebp
  8025cc:	c3                   	ret    
  8025cd:	8d 76 00             	lea    0x0(%esi),%esi
  8025d0:	39 e8                	cmp    %ebp,%eax
  8025d2:	77 24                	ja     8025f8 <__udivdi3+0x78>
  8025d4:	0f bd e8             	bsr    %eax,%ebp
  8025d7:	83 f5 1f             	xor    $0x1f,%ebp
  8025da:	75 3c                	jne    802618 <__udivdi3+0x98>
  8025dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8025e0:	39 34 24             	cmp    %esi,(%esp)
  8025e3:	0f 86 9f 00 00 00    	jbe    802688 <__udivdi3+0x108>
  8025e9:	39 d0                	cmp    %edx,%eax
  8025eb:	0f 82 97 00 00 00    	jb     802688 <__udivdi3+0x108>
  8025f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025f8:	31 d2                	xor    %edx,%edx
  8025fa:	31 c0                	xor    %eax,%eax
  8025fc:	83 c4 0c             	add    $0xc,%esp
  8025ff:	5e                   	pop    %esi
  802600:	5f                   	pop    %edi
  802601:	5d                   	pop    %ebp
  802602:	c3                   	ret    
  802603:	90                   	nop
  802604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802608:	89 f8                	mov    %edi,%eax
  80260a:	f7 f1                	div    %ecx
  80260c:	31 d2                	xor    %edx,%edx
  80260e:	83 c4 0c             	add    $0xc,%esp
  802611:	5e                   	pop    %esi
  802612:	5f                   	pop    %edi
  802613:	5d                   	pop    %ebp
  802614:	c3                   	ret    
  802615:	8d 76 00             	lea    0x0(%esi),%esi
  802618:	89 e9                	mov    %ebp,%ecx
  80261a:	8b 3c 24             	mov    (%esp),%edi
  80261d:	d3 e0                	shl    %cl,%eax
  80261f:	89 c6                	mov    %eax,%esi
  802621:	b8 20 00 00 00       	mov    $0x20,%eax
  802626:	29 e8                	sub    %ebp,%eax
  802628:	89 c1                	mov    %eax,%ecx
  80262a:	d3 ef                	shr    %cl,%edi
  80262c:	89 e9                	mov    %ebp,%ecx
  80262e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802632:	8b 3c 24             	mov    (%esp),%edi
  802635:	09 74 24 08          	or     %esi,0x8(%esp)
  802639:	89 d6                	mov    %edx,%esi
  80263b:	d3 e7                	shl    %cl,%edi
  80263d:	89 c1                	mov    %eax,%ecx
  80263f:	89 3c 24             	mov    %edi,(%esp)
  802642:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802646:	d3 ee                	shr    %cl,%esi
  802648:	89 e9                	mov    %ebp,%ecx
  80264a:	d3 e2                	shl    %cl,%edx
  80264c:	89 c1                	mov    %eax,%ecx
  80264e:	d3 ef                	shr    %cl,%edi
  802650:	09 d7                	or     %edx,%edi
  802652:	89 f2                	mov    %esi,%edx
  802654:	89 f8                	mov    %edi,%eax
  802656:	f7 74 24 08          	divl   0x8(%esp)
  80265a:	89 d6                	mov    %edx,%esi
  80265c:	89 c7                	mov    %eax,%edi
  80265e:	f7 24 24             	mull   (%esp)
  802661:	39 d6                	cmp    %edx,%esi
  802663:	89 14 24             	mov    %edx,(%esp)
  802666:	72 30                	jb     802698 <__udivdi3+0x118>
  802668:	8b 54 24 04          	mov    0x4(%esp),%edx
  80266c:	89 e9                	mov    %ebp,%ecx
  80266e:	d3 e2                	shl    %cl,%edx
  802670:	39 c2                	cmp    %eax,%edx
  802672:	73 05                	jae    802679 <__udivdi3+0xf9>
  802674:	3b 34 24             	cmp    (%esp),%esi
  802677:	74 1f                	je     802698 <__udivdi3+0x118>
  802679:	89 f8                	mov    %edi,%eax
  80267b:	31 d2                	xor    %edx,%edx
  80267d:	e9 7a ff ff ff       	jmp    8025fc <__udivdi3+0x7c>
  802682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802688:	31 d2                	xor    %edx,%edx
  80268a:	b8 01 00 00 00       	mov    $0x1,%eax
  80268f:	e9 68 ff ff ff       	jmp    8025fc <__udivdi3+0x7c>
  802694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802698:	8d 47 ff             	lea    -0x1(%edi),%eax
  80269b:	31 d2                	xor    %edx,%edx
  80269d:	83 c4 0c             	add    $0xc,%esp
  8026a0:	5e                   	pop    %esi
  8026a1:	5f                   	pop    %edi
  8026a2:	5d                   	pop    %ebp
  8026a3:	c3                   	ret    
  8026a4:	66 90                	xchg   %ax,%ax
  8026a6:	66 90                	xchg   %ax,%ax
  8026a8:	66 90                	xchg   %ax,%ax
  8026aa:	66 90                	xchg   %ax,%ax
  8026ac:	66 90                	xchg   %ax,%ax
  8026ae:	66 90                	xchg   %ax,%ax

008026b0 <__umoddi3>:
  8026b0:	55                   	push   %ebp
  8026b1:	57                   	push   %edi
  8026b2:	56                   	push   %esi
  8026b3:	83 ec 14             	sub    $0x14,%esp
  8026b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026ba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026be:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8026c2:	89 c7                	mov    %eax,%edi
  8026c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8026cc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8026d0:	89 34 24             	mov    %esi,(%esp)
  8026d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	89 c2                	mov    %eax,%edx
  8026db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026df:	75 17                	jne    8026f8 <__umoddi3+0x48>
  8026e1:	39 fe                	cmp    %edi,%esi
  8026e3:	76 4b                	jbe    802730 <__umoddi3+0x80>
  8026e5:	89 c8                	mov    %ecx,%eax
  8026e7:	89 fa                	mov    %edi,%edx
  8026e9:	f7 f6                	div    %esi
  8026eb:	89 d0                	mov    %edx,%eax
  8026ed:	31 d2                	xor    %edx,%edx
  8026ef:	83 c4 14             	add    $0x14,%esp
  8026f2:	5e                   	pop    %esi
  8026f3:	5f                   	pop    %edi
  8026f4:	5d                   	pop    %ebp
  8026f5:	c3                   	ret    
  8026f6:	66 90                	xchg   %ax,%ax
  8026f8:	39 f8                	cmp    %edi,%eax
  8026fa:	77 54                	ja     802750 <__umoddi3+0xa0>
  8026fc:	0f bd e8             	bsr    %eax,%ebp
  8026ff:	83 f5 1f             	xor    $0x1f,%ebp
  802702:	75 5c                	jne    802760 <__umoddi3+0xb0>
  802704:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802708:	39 3c 24             	cmp    %edi,(%esp)
  80270b:	0f 87 e7 00 00 00    	ja     8027f8 <__umoddi3+0x148>
  802711:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802715:	29 f1                	sub    %esi,%ecx
  802717:	19 c7                	sbb    %eax,%edi
  802719:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80271d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802721:	8b 44 24 08          	mov    0x8(%esp),%eax
  802725:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802729:	83 c4 14             	add    $0x14,%esp
  80272c:	5e                   	pop    %esi
  80272d:	5f                   	pop    %edi
  80272e:	5d                   	pop    %ebp
  80272f:	c3                   	ret    
  802730:	85 f6                	test   %esi,%esi
  802732:	89 f5                	mov    %esi,%ebp
  802734:	75 0b                	jne    802741 <__umoddi3+0x91>
  802736:	b8 01 00 00 00       	mov    $0x1,%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	f7 f6                	div    %esi
  80273f:	89 c5                	mov    %eax,%ebp
  802741:	8b 44 24 04          	mov    0x4(%esp),%eax
  802745:	31 d2                	xor    %edx,%edx
  802747:	f7 f5                	div    %ebp
  802749:	89 c8                	mov    %ecx,%eax
  80274b:	f7 f5                	div    %ebp
  80274d:	eb 9c                	jmp    8026eb <__umoddi3+0x3b>
  80274f:	90                   	nop
  802750:	89 c8                	mov    %ecx,%eax
  802752:	89 fa                	mov    %edi,%edx
  802754:	83 c4 14             	add    $0x14,%esp
  802757:	5e                   	pop    %esi
  802758:	5f                   	pop    %edi
  802759:	5d                   	pop    %ebp
  80275a:	c3                   	ret    
  80275b:	90                   	nop
  80275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802760:	8b 04 24             	mov    (%esp),%eax
  802763:	be 20 00 00 00       	mov    $0x20,%esi
  802768:	89 e9                	mov    %ebp,%ecx
  80276a:	29 ee                	sub    %ebp,%esi
  80276c:	d3 e2                	shl    %cl,%edx
  80276e:	89 f1                	mov    %esi,%ecx
  802770:	d3 e8                	shr    %cl,%eax
  802772:	89 e9                	mov    %ebp,%ecx
  802774:	89 44 24 04          	mov    %eax,0x4(%esp)
  802778:	8b 04 24             	mov    (%esp),%eax
  80277b:	09 54 24 04          	or     %edx,0x4(%esp)
  80277f:	89 fa                	mov    %edi,%edx
  802781:	d3 e0                	shl    %cl,%eax
  802783:	89 f1                	mov    %esi,%ecx
  802785:	89 44 24 08          	mov    %eax,0x8(%esp)
  802789:	8b 44 24 10          	mov    0x10(%esp),%eax
  80278d:	d3 ea                	shr    %cl,%edx
  80278f:	89 e9                	mov    %ebp,%ecx
  802791:	d3 e7                	shl    %cl,%edi
  802793:	89 f1                	mov    %esi,%ecx
  802795:	d3 e8                	shr    %cl,%eax
  802797:	89 e9                	mov    %ebp,%ecx
  802799:	09 f8                	or     %edi,%eax
  80279b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80279f:	f7 74 24 04          	divl   0x4(%esp)
  8027a3:	d3 e7                	shl    %cl,%edi
  8027a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027a9:	89 d7                	mov    %edx,%edi
  8027ab:	f7 64 24 08          	mull   0x8(%esp)
  8027af:	39 d7                	cmp    %edx,%edi
  8027b1:	89 c1                	mov    %eax,%ecx
  8027b3:	89 14 24             	mov    %edx,(%esp)
  8027b6:	72 2c                	jb     8027e4 <__umoddi3+0x134>
  8027b8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8027bc:	72 22                	jb     8027e0 <__umoddi3+0x130>
  8027be:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8027c2:	29 c8                	sub    %ecx,%eax
  8027c4:	19 d7                	sbb    %edx,%edi
  8027c6:	89 e9                	mov    %ebp,%ecx
  8027c8:	89 fa                	mov    %edi,%edx
  8027ca:	d3 e8                	shr    %cl,%eax
  8027cc:	89 f1                	mov    %esi,%ecx
  8027ce:	d3 e2                	shl    %cl,%edx
  8027d0:	89 e9                	mov    %ebp,%ecx
  8027d2:	d3 ef                	shr    %cl,%edi
  8027d4:	09 d0                	or     %edx,%eax
  8027d6:	89 fa                	mov    %edi,%edx
  8027d8:	83 c4 14             	add    $0x14,%esp
  8027db:	5e                   	pop    %esi
  8027dc:	5f                   	pop    %edi
  8027dd:	5d                   	pop    %ebp
  8027de:	c3                   	ret    
  8027df:	90                   	nop
  8027e0:	39 d7                	cmp    %edx,%edi
  8027e2:	75 da                	jne    8027be <__umoddi3+0x10e>
  8027e4:	8b 14 24             	mov    (%esp),%edx
  8027e7:	89 c1                	mov    %eax,%ecx
  8027e9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8027ed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8027f1:	eb cb                	jmp    8027be <__umoddi3+0x10e>
  8027f3:	90                   	nop
  8027f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027f8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8027fc:	0f 82 0f ff ff ff    	jb     802711 <__umoddi3+0x61>
  802802:	e9 1a ff ff ff       	jmp    802721 <__umoddi3+0x71>
