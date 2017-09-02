
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 c7 01 00 00       	call   8001f8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 28             	sub    $0x28,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 38 11 00 00       	call   801176 <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 c9 00 00 00    	jne    800112 <umain+0xdf>
		// Child


		cprintf("In Child\n");
  800049:	c7 04 24 40 2b 80 00 	movl   $0x802b40,(%esp)
  800050:	e8 b1 02 00 00       	call   800306 <cprintf>

		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800055:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80005c:	00 
  80005d:	c7 44 24 04 00 00 b0 	movl   $0xb00000,0x4(%esp)
  800064:	00 
  800065:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800068:	89 04 24             	mov    %eax,(%esp)
  80006b:	e8 59 13 00 00       	call   8013c9 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800070:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  800077:	00 
  800078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80007b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80007f:	c7 04 24 4a 2b 80 00 	movl   $0x802b4a,(%esp)
  800086:	e8 7b 02 00 00       	call   800306 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  80008b:	a1 04 40 80 00       	mov    0x804004,%eax
  800090:	89 04 24             	mov    %eax,(%esp)
  800093:	e8 58 08 00 00       	call   8008f0 <strlen>
  800098:	89 44 24 08          	mov    %eax,0x8(%esp)
  80009c:	a1 04 40 80 00       	mov    0x804004,%eax
  8000a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000a5:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000ac:	e8 51 09 00 00       	call   800a02 <strncmp>
  8000b1:	85 c0                	test   %eax,%eax
  8000b3:	75 0c                	jne    8000c1 <umain+0x8e>
			cprintf("child received correct message\n");
  8000b5:	c7 04 24 6c 2b 80 00 	movl   $0x802b6c,(%esp)
  8000bc:	e8 45 02 00 00       	call   800306 <cprintf>

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  8000c1:	a1 00 40 80 00       	mov    0x804000,%eax
  8000c6:	89 04 24             	mov    %eax,(%esp)
  8000c9:	e8 22 08 00 00       	call   8008f0 <strlen>
  8000ce:	83 c0 01             	add    $0x1,%eax
  8000d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000d5:	a1 00 40 80 00       	mov    0x804000,%eax
  8000da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000de:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000e5:	e8 42 0a 00 00       	call   800b2c <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000ea:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8000f1:	00 
  8000f2:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  8000f9:	00 
  8000fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800101:	00 
  800102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800105:	89 04 24             	mov    %eax,(%esp)
  800108:	e8 26 13 00 00       	call   801433 <ipc_send>
		return;
  80010d:	e9 e4 00 00 00       	jmp    8001f6 <umain+0x1c3>
	}

	// Parent

	cprintf("In Parent\n");
  800112:	c7 04 24 5e 2b 80 00 	movl   $0x802b5e,(%esp)
  800119:	e8 e8 01 00 00       	call   800306 <cprintf>


	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80011e:	a1 08 50 80 00       	mov    0x805008,%eax
  800123:	8b 40 48             	mov    0x48(%eax),%eax
  800126:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80012d:	00 
  80012e:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  800135:	00 
  800136:	89 04 24             	mov    %eax,(%esp)
  800139:	e8 05 0c 00 00       	call   800d43 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  80013e:	a1 04 40 80 00       	mov    0x804004,%eax
  800143:	89 04 24             	mov    %eax,(%esp)
  800146:	e8 a5 07 00 00       	call   8008f0 <strlen>
  80014b:	83 c0 01             	add    $0x1,%eax
  80014e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800152:	a1 04 40 80 00       	mov    0x804004,%eax
  800157:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015b:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  800162:	e8 c5 09 00 00       	call   800b2c <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800167:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80016e:	00 
  80016f:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  800176:	00 
  800177:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80017e:	00 
  80017f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800182:	89 04 24             	mov    %eax,(%esp)
  800185:	e8 a9 12 00 00       	call   801433 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  80018a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800191:	00 
  800192:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  800199:	00 
  80019a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80019d:	89 04 24             	mov    %eax,(%esp)
  8001a0:	e8 24 12 00 00       	call   8013c9 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  8001a5:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  8001ac:	00 
  8001ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b4:	c7 04 24 4a 2b 80 00 	movl   $0x802b4a,(%esp)
  8001bb:	e8 46 01 00 00       	call   800306 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8001c0:	a1 00 40 80 00       	mov    0x804000,%eax
  8001c5:	89 04 24             	mov    %eax,(%esp)
  8001c8:	e8 23 07 00 00       	call   8008f0 <strlen>
  8001cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d1:	a1 00 40 80 00       	mov    0x804000,%eax
  8001d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001da:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  8001e1:	e8 1c 08 00 00       	call   800a02 <strncmp>
  8001e6:	85 c0                	test   %eax,%eax
  8001e8:	75 0c                	jne    8001f6 <umain+0x1c3>
		cprintf("parent received correct message\n");
  8001ea:	c7 04 24 8c 2b 80 00 	movl   $0x802b8c,(%esp)
  8001f1:	e8 10 01 00 00       	call   800306 <cprintf>
	return;
}
  8001f6:	c9                   	leave  
  8001f7:	c3                   	ret    

008001f8 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001f8:	55                   	push   %ebp
  8001f9:	89 e5                	mov    %esp,%ebp
  8001fb:	56                   	push   %esi
  8001fc:	53                   	push   %ebx
  8001fd:	83 ec 10             	sub    $0x10,%esp
  800200:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800203:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800206:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80020d:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800210:	e8 f0 0a 00 00       	call   800d05 <sys_getenvid>
  800215:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80021a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80021d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800222:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800227:	85 db                	test   %ebx,%ebx
  800229:	7e 07                	jle    800232 <libmain+0x3a>
		binaryname = argv[0];
  80022b:	8b 06                	mov    (%esi),%eax
  80022d:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  800232:	89 74 24 04          	mov    %esi,0x4(%esp)
  800236:	89 1c 24             	mov    %ebx,(%esp)
  800239:	e8 f5 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80023e:	e8 07 00 00 00       	call   80024a <exit>
}
  800243:	83 c4 10             	add    $0x10,%esp
  800246:	5b                   	pop    %ebx
  800247:	5e                   	pop    %esi
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800250:	e8 55 14 00 00       	call   8016aa <close_all>
	sys_env_destroy(0);
  800255:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80025c:	e8 52 0a 00 00       	call   800cb3 <sys_env_destroy>
}
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	53                   	push   %ebx
  800267:	83 ec 14             	sub    $0x14,%esp
  80026a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80026d:	8b 13                	mov    (%ebx),%edx
  80026f:	8d 42 01             	lea    0x1(%edx),%eax
  800272:	89 03                	mov    %eax,(%ebx)
  800274:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800277:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80027b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800280:	75 19                	jne    80029b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800282:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800289:	00 
  80028a:	8d 43 08             	lea    0x8(%ebx),%eax
  80028d:	89 04 24             	mov    %eax,(%esp)
  800290:	e8 e1 09 00 00       	call   800c76 <sys_cputs>
		b->idx = 0;
  800295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80029b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80029f:	83 c4 14             	add    $0x14,%esp
  8002a2:	5b                   	pop    %ebx
  8002a3:	5d                   	pop    %ebp
  8002a4:	c3                   	ret    

008002a5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002ae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b5:	00 00 00 
	b.cnt = 0;
  8002b8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002bf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002da:	c7 04 24 63 02 80 00 	movl   $0x800263,(%esp)
  8002e1:	e8 a8 01 00 00       	call   80048e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f6:	89 04 24             	mov    %eax,(%esp)
  8002f9:	e8 78 09 00 00       	call   800c76 <sys_cputs>

	return b.cnt;
}
  8002fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800304:	c9                   	leave  
  800305:	c3                   	ret    

00800306 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80030c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80030f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	89 04 24             	mov    %eax,(%esp)
  800319:	e8 87 ff ff ff       	call   8002a5 <vcprintf>
	va_end(ap);

	return cnt;
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 3c             	sub    $0x3c,%esp
  800329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80032c:	89 d7                	mov    %edx,%edi
  80032e:	8b 45 08             	mov    0x8(%ebp),%eax
  800331:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800334:	8b 45 0c             	mov    0xc(%ebp),%eax
  800337:	89 c3                	mov    %eax,%ebx
  800339:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80033c:	8b 45 10             	mov    0x10(%ebp),%eax
  80033f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800342:	b9 00 00 00 00       	mov    $0x0,%ecx
  800347:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80034d:	39 d9                	cmp    %ebx,%ecx
  80034f:	72 05                	jb     800356 <printnum+0x36>
  800351:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800354:	77 69                	ja     8003bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800356:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800359:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80035d:	83 ee 01             	sub    $0x1,%esi
  800360:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800364:	89 44 24 08          	mov    %eax,0x8(%esp)
  800368:	8b 44 24 08          	mov    0x8(%esp),%eax
  80036c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800370:	89 c3                	mov    %eax,%ebx
  800372:	89 d6                	mov    %edx,%esi
  800374:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800377:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80037a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80037e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800385:	89 04 24             	mov    %eax,(%esp)
  800388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038f:	e8 1c 25 00 00       	call   8028b0 <__udivdi3>
  800394:	89 d9                	mov    %ebx,%ecx
  800396:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80039a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80039e:	89 04 24             	mov    %eax,(%esp)
  8003a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003a5:	89 fa                	mov    %edi,%edx
  8003a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003aa:	e8 71 ff ff ff       	call   800320 <printnum>
  8003af:	eb 1b                	jmp    8003cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003b8:	89 04 24             	mov    %eax,(%esp)
  8003bb:	ff d3                	call   *%ebx
  8003bd:	eb 03                	jmp    8003c2 <printnum+0xa2>
  8003bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c2:	83 ee 01             	sub    $0x1,%esi
  8003c5:	85 f6                	test   %esi,%esi
  8003c7:	7f e8                	jg     8003b1 <printnum+0x91>
  8003c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e5:	89 04 24             	mov    %eax,(%esp)
  8003e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ef:	e8 ec 25 00 00       	call   8029e0 <__umoddi3>
  8003f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003f8:	0f be 80 04 2c 80 00 	movsbl 0x802c04(%eax),%eax
  8003ff:	89 04 24             	mov    %eax,(%esp)
  800402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800405:	ff d0                	call   *%eax
}
  800407:	83 c4 3c             	add    $0x3c,%esp
  80040a:	5b                   	pop    %ebx
  80040b:	5e                   	pop    %esi
  80040c:	5f                   	pop    %edi
  80040d:	5d                   	pop    %ebp
  80040e:	c3                   	ret    

0080040f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800412:	83 fa 01             	cmp    $0x1,%edx
  800415:	7e 0e                	jle    800425 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800417:	8b 10                	mov    (%eax),%edx
  800419:	8d 4a 08             	lea    0x8(%edx),%ecx
  80041c:	89 08                	mov    %ecx,(%eax)
  80041e:	8b 02                	mov    (%edx),%eax
  800420:	8b 52 04             	mov    0x4(%edx),%edx
  800423:	eb 22                	jmp    800447 <getuint+0x38>
	else if (lflag)
  800425:	85 d2                	test   %edx,%edx
  800427:	74 10                	je     800439 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800429:	8b 10                	mov    (%eax),%edx
  80042b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80042e:	89 08                	mov    %ecx,(%eax)
  800430:	8b 02                	mov    (%edx),%eax
  800432:	ba 00 00 00 00       	mov    $0x0,%edx
  800437:	eb 0e                	jmp    800447 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800439:	8b 10                	mov    (%eax),%edx
  80043b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80043e:	89 08                	mov    %ecx,(%eax)
  800440:	8b 02                	mov    (%edx),%eax
  800442:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800447:	5d                   	pop    %ebp
  800448:	c3                   	ret    

00800449 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80044f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800453:	8b 10                	mov    (%eax),%edx
  800455:	3b 50 04             	cmp    0x4(%eax),%edx
  800458:	73 0a                	jae    800464 <sprintputch+0x1b>
		*b->buf++ = ch;
  80045a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80045d:	89 08                	mov    %ecx,(%eax)
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	88 02                	mov    %al,(%edx)
}
  800464:	5d                   	pop    %ebp
  800465:	c3                   	ret    

00800466 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80046c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80046f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800473:	8b 45 10             	mov    0x10(%ebp),%eax
  800476:	89 44 24 08          	mov    %eax,0x8(%esp)
  80047a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	89 04 24             	mov    %eax,(%esp)
  800487:	e8 02 00 00 00       	call   80048e <vprintfmt>
	va_end(ap);
}
  80048c:	c9                   	leave  
  80048d:	c3                   	ret    

0080048e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80048e:	55                   	push   %ebp
  80048f:	89 e5                	mov    %esp,%ebp
  800491:	57                   	push   %edi
  800492:	56                   	push   %esi
  800493:	53                   	push   %ebx
  800494:	83 ec 3c             	sub    $0x3c,%esp
  800497:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80049a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80049d:	eb 14                	jmp    8004b3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80049f:	85 c0                	test   %eax,%eax
  8004a1:	0f 84 b3 03 00 00    	je     80085a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ab:	89 04 24             	mov    %eax,(%esp)
  8004ae:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b1:	89 f3                	mov    %esi,%ebx
  8004b3:	8d 73 01             	lea    0x1(%ebx),%esi
  8004b6:	0f b6 03             	movzbl (%ebx),%eax
  8004b9:	83 f8 25             	cmp    $0x25,%eax
  8004bc:	75 e1                	jne    80049f <vprintfmt+0x11>
  8004be:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004c9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004d0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8004d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004dc:	eb 1d                	jmp    8004fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004de:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004e0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004e4:	eb 15                	jmp    8004fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004e8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004ec:	eb 0d                	jmp    8004fb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004f4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004fe:	0f b6 0e             	movzbl (%esi),%ecx
  800501:	0f b6 c1             	movzbl %cl,%eax
  800504:	83 e9 23             	sub    $0x23,%ecx
  800507:	80 f9 55             	cmp    $0x55,%cl
  80050a:	0f 87 2a 03 00 00    	ja     80083a <vprintfmt+0x3ac>
  800510:	0f b6 c9             	movzbl %cl,%ecx
  800513:	ff 24 8d 40 2d 80 00 	jmp    *0x802d40(,%ecx,4)
  80051a:	89 de                	mov    %ebx,%esi
  80051c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800521:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800524:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800528:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80052b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80052e:	83 fb 09             	cmp    $0x9,%ebx
  800531:	77 36                	ja     800569 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800533:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800536:	eb e9                	jmp    800521 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800538:	8b 45 14             	mov    0x14(%ebp),%eax
  80053b:	8d 48 04             	lea    0x4(%eax),%ecx
  80053e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800541:	8b 00                	mov    (%eax),%eax
  800543:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800546:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800548:	eb 22                	jmp    80056c <vprintfmt+0xde>
  80054a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80054d:	85 c9                	test   %ecx,%ecx
  80054f:	b8 00 00 00 00       	mov    $0x0,%eax
  800554:	0f 49 c1             	cmovns %ecx,%eax
  800557:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055a:	89 de                	mov    %ebx,%esi
  80055c:	eb 9d                	jmp    8004fb <vprintfmt+0x6d>
  80055e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800560:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800567:	eb 92                	jmp    8004fb <vprintfmt+0x6d>
  800569:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80056c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800570:	79 89                	jns    8004fb <vprintfmt+0x6d>
  800572:	e9 77 ff ff ff       	jmp    8004ee <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800577:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80057c:	e9 7a ff ff ff       	jmp    8004fb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8d 50 04             	lea    0x4(%eax),%edx
  800587:	89 55 14             	mov    %edx,0x14(%ebp)
  80058a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	89 04 24             	mov    %eax,(%esp)
  800593:	ff 55 08             	call   *0x8(%ebp)
			break;
  800596:	e9 18 ff ff ff       	jmp    8004b3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	99                   	cltd   
  8005a7:	31 d0                	xor    %edx,%eax
  8005a9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005ab:	83 f8 0f             	cmp    $0xf,%eax
  8005ae:	7f 0b                	jg     8005bb <vprintfmt+0x12d>
  8005b0:	8b 14 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%edx
  8005b7:	85 d2                	test   %edx,%edx
  8005b9:	75 20                	jne    8005db <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8005bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005bf:	c7 44 24 08 1c 2c 80 	movl   $0x802c1c,0x8(%esp)
  8005c6:	00 
  8005c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ce:	89 04 24             	mov    %eax,(%esp)
  8005d1:	e8 90 fe ff ff       	call   800466 <printfmt>
  8005d6:	e9 d8 fe ff ff       	jmp    8004b3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005df:	c7 44 24 08 65 31 80 	movl   $0x803165,0x8(%esp)
  8005e6:	00 
  8005e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	89 04 24             	mov    %eax,(%esp)
  8005f1:	e8 70 fe ff ff       	call   800466 <printfmt>
  8005f6:	e9 b8 fe ff ff       	jmp    8004b3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800601:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8d 50 04             	lea    0x4(%eax),%edx
  80060a:	89 55 14             	mov    %edx,0x14(%ebp)
  80060d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80060f:	85 f6                	test   %esi,%esi
  800611:	b8 15 2c 80 00       	mov    $0x802c15,%eax
  800616:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800619:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80061d:	0f 84 97 00 00 00    	je     8006ba <vprintfmt+0x22c>
  800623:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800627:	0f 8e 9b 00 00 00    	jle    8006c8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80062d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800631:	89 34 24             	mov    %esi,(%esp)
  800634:	e8 cf 02 00 00       	call   800908 <strnlen>
  800639:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80063c:	29 c2                	sub    %eax,%edx
  80063e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800641:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800645:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800648:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80064b:	8b 75 08             	mov    0x8(%ebp),%esi
  80064e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800651:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800653:	eb 0f                	jmp    800664 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800655:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800659:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80065c:	89 04 24             	mov    %eax,(%esp)
  80065f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800661:	83 eb 01             	sub    $0x1,%ebx
  800664:	85 db                	test   %ebx,%ebx
  800666:	7f ed                	jg     800655 <vprintfmt+0x1c7>
  800668:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80066b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80066e:	85 d2                	test   %edx,%edx
  800670:	b8 00 00 00 00       	mov    $0x0,%eax
  800675:	0f 49 c2             	cmovns %edx,%eax
  800678:	29 c2                	sub    %eax,%edx
  80067a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80067d:	89 d7                	mov    %edx,%edi
  80067f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800682:	eb 50                	jmp    8006d4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800684:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800688:	74 1e                	je     8006a8 <vprintfmt+0x21a>
  80068a:	0f be d2             	movsbl %dl,%edx
  80068d:	83 ea 20             	sub    $0x20,%edx
  800690:	83 fa 5e             	cmp    $0x5e,%edx
  800693:	76 13                	jbe    8006a8 <vprintfmt+0x21a>
					putch('?', putdat);
  800695:	8b 45 0c             	mov    0xc(%ebp),%eax
  800698:	89 44 24 04          	mov    %eax,0x4(%esp)
  80069c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006a3:	ff 55 08             	call   *0x8(%ebp)
  8006a6:	eb 0d                	jmp    8006b5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006af:	89 04 24             	mov    %eax,(%esp)
  8006b2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b5:	83 ef 01             	sub    $0x1,%edi
  8006b8:	eb 1a                	jmp    8006d4 <vprintfmt+0x246>
  8006ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006bd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006c0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006c3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006c6:	eb 0c                	jmp    8006d4 <vprintfmt+0x246>
  8006c8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006cb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006d1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006d4:	83 c6 01             	add    $0x1,%esi
  8006d7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006db:	0f be c2             	movsbl %dl,%eax
  8006de:	85 c0                	test   %eax,%eax
  8006e0:	74 27                	je     800709 <vprintfmt+0x27b>
  8006e2:	85 db                	test   %ebx,%ebx
  8006e4:	78 9e                	js     800684 <vprintfmt+0x1f6>
  8006e6:	83 eb 01             	sub    $0x1,%ebx
  8006e9:	79 99                	jns    800684 <vprintfmt+0x1f6>
  8006eb:	89 f8                	mov    %edi,%eax
  8006ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006f3:	89 c3                	mov    %eax,%ebx
  8006f5:	eb 1a                	jmp    800711 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006fb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800702:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800704:	83 eb 01             	sub    $0x1,%ebx
  800707:	eb 08                	jmp    800711 <vprintfmt+0x283>
  800709:	89 fb                	mov    %edi,%ebx
  80070b:	8b 75 08             	mov    0x8(%ebp),%esi
  80070e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800711:	85 db                	test   %ebx,%ebx
  800713:	7f e2                	jg     8006f7 <vprintfmt+0x269>
  800715:	89 75 08             	mov    %esi,0x8(%ebp)
  800718:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80071b:	e9 93 fd ff ff       	jmp    8004b3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800720:	83 fa 01             	cmp    $0x1,%edx
  800723:	7e 16                	jle    80073b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8d 50 08             	lea    0x8(%eax),%edx
  80072b:	89 55 14             	mov    %edx,0x14(%ebp)
  80072e:	8b 50 04             	mov    0x4(%eax),%edx
  800731:	8b 00                	mov    (%eax),%eax
  800733:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800736:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800739:	eb 32                	jmp    80076d <vprintfmt+0x2df>
	else if (lflag)
  80073b:	85 d2                	test   %edx,%edx
  80073d:	74 18                	je     800757 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8d 50 04             	lea    0x4(%eax),%edx
  800745:	89 55 14             	mov    %edx,0x14(%ebp)
  800748:	8b 30                	mov    (%eax),%esi
  80074a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80074d:	89 f0                	mov    %esi,%eax
  80074f:	c1 f8 1f             	sar    $0x1f,%eax
  800752:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800755:	eb 16                	jmp    80076d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8d 50 04             	lea    0x4(%eax),%edx
  80075d:	89 55 14             	mov    %edx,0x14(%ebp)
  800760:	8b 30                	mov    (%eax),%esi
  800762:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800765:	89 f0                	mov    %esi,%eax
  800767:	c1 f8 1f             	sar    $0x1f,%eax
  80076a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80076d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800770:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800773:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800778:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80077c:	0f 89 80 00 00 00    	jns    800802 <vprintfmt+0x374>
				putch('-', putdat);
  800782:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800786:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80078d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800793:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800796:	f7 d8                	neg    %eax
  800798:	83 d2 00             	adc    $0x0,%edx
  80079b:	f7 da                	neg    %edx
			}
			base = 10;
  80079d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007a2:	eb 5e                	jmp    800802 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a7:	e8 63 fc ff ff       	call   80040f <getuint>
			base = 10;
  8007ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007b1:	eb 4f                	jmp    800802 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  8007b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b6:	e8 54 fc ff ff       	call   80040f <getuint>
			base =8;
  8007bb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007c0:	eb 40                	jmp    800802 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  8007c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007cd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007db:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007de:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e1:	8d 50 04             	lea    0x4(%eax),%edx
  8007e4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007e7:	8b 00                	mov    (%eax),%eax
  8007e9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007ee:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007f3:	eb 0d                	jmp    800802 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f8:	e8 12 fc ff ff       	call   80040f <getuint>
			base = 16;
  8007fd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800802:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800806:	89 74 24 10          	mov    %esi,0x10(%esp)
  80080a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80080d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800811:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800815:	89 04 24             	mov    %eax,(%esp)
  800818:	89 54 24 04          	mov    %edx,0x4(%esp)
  80081c:	89 fa                	mov    %edi,%edx
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	e8 fa fa ff ff       	call   800320 <printnum>
			break;
  800826:	e9 88 fc ff ff       	jmp    8004b3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80082b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80082f:	89 04 24             	mov    %eax,(%esp)
  800832:	ff 55 08             	call   *0x8(%ebp)
			break;
  800835:	e9 79 fc ff ff       	jmp    8004b3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80083a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80083e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800845:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800848:	89 f3                	mov    %esi,%ebx
  80084a:	eb 03                	jmp    80084f <vprintfmt+0x3c1>
  80084c:	83 eb 01             	sub    $0x1,%ebx
  80084f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800853:	75 f7                	jne    80084c <vprintfmt+0x3be>
  800855:	e9 59 fc ff ff       	jmp    8004b3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80085a:	83 c4 3c             	add    $0x3c,%esp
  80085d:	5b                   	pop    %ebx
  80085e:	5e                   	pop    %esi
  80085f:	5f                   	pop    %edi
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	83 ec 28             	sub    $0x28,%esp
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80086e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800871:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800875:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800878:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80087f:	85 c0                	test   %eax,%eax
  800881:	74 30                	je     8008b3 <vsnprintf+0x51>
  800883:	85 d2                	test   %edx,%edx
  800885:	7e 2c                	jle    8008b3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80088e:	8b 45 10             	mov    0x10(%ebp),%eax
  800891:	89 44 24 08          	mov    %eax,0x8(%esp)
  800895:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800898:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089c:	c7 04 24 49 04 80 00 	movl   $0x800449,(%esp)
  8008a3:	e8 e6 fb ff ff       	call   80048e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008b1:	eb 05                	jmp    8008b8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
  8008bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008c0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d8:	89 04 24             	mov    %eax,(%esp)
  8008db:	e8 82 ff ff ff       	call   800862 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    
  8008e2:	66 90                	xchg   %ax,%ax
  8008e4:	66 90                	xchg   %ax,%ax
  8008e6:	66 90                	xchg   %ax,%ax
  8008e8:	66 90                	xchg   %ax,%ax
  8008ea:	66 90                	xchg   %ax,%ax
  8008ec:	66 90                	xchg   %ax,%ax
  8008ee:	66 90                	xchg   %ax,%ax

008008f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008f0:	55                   	push   %ebp
  8008f1:	89 e5                	mov    %esp,%ebp
  8008f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008fb:	eb 03                	jmp    800900 <strlen+0x10>
		n++;
  8008fd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800900:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800904:	75 f7                	jne    8008fd <strlen+0xd>
		n++;
	return n;
}
  800906:	5d                   	pop    %ebp
  800907:	c3                   	ret    

00800908 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800908:	55                   	push   %ebp
  800909:	89 e5                	mov    %esp,%ebp
  80090b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80090e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800911:	b8 00 00 00 00       	mov    $0x0,%eax
  800916:	eb 03                	jmp    80091b <strnlen+0x13>
		n++;
  800918:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80091b:	39 d0                	cmp    %edx,%eax
  80091d:	74 06                	je     800925 <strnlen+0x1d>
  80091f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800923:	75 f3                	jne    800918 <strnlen+0x10>
		n++;
	return n;
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	53                   	push   %ebx
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800931:	89 c2                	mov    %eax,%edx
  800933:	83 c2 01             	add    $0x1,%edx
  800936:	83 c1 01             	add    $0x1,%ecx
  800939:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80093d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800940:	84 db                	test   %bl,%bl
  800942:	75 ef                	jne    800933 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800944:	5b                   	pop    %ebx
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	53                   	push   %ebx
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800951:	89 1c 24             	mov    %ebx,(%esp)
  800954:	e8 97 ff ff ff       	call   8008f0 <strlen>
	strcpy(dst + len, src);
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800960:	01 d8                	add    %ebx,%eax
  800962:	89 04 24             	mov    %eax,(%esp)
  800965:	e8 bd ff ff ff       	call   800927 <strcpy>
	return dst;
}
  80096a:	89 d8                	mov    %ebx,%eax
  80096c:	83 c4 08             	add    $0x8,%esp
  80096f:	5b                   	pop    %ebx
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	56                   	push   %esi
  800976:	53                   	push   %ebx
  800977:	8b 75 08             	mov    0x8(%ebp),%esi
  80097a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097d:	89 f3                	mov    %esi,%ebx
  80097f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800982:	89 f2                	mov    %esi,%edx
  800984:	eb 0f                	jmp    800995 <strncpy+0x23>
		*dst++ = *src;
  800986:	83 c2 01             	add    $0x1,%edx
  800989:	0f b6 01             	movzbl (%ecx),%eax
  80098c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80098f:	80 39 01             	cmpb   $0x1,(%ecx)
  800992:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800995:	39 da                	cmp    %ebx,%edx
  800997:	75 ed                	jne    800986 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800999:	89 f0                	mov    %esi,%eax
  80099b:	5b                   	pop    %ebx
  80099c:	5e                   	pop    %esi
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	56                   	push   %esi
  8009a3:	53                   	push   %ebx
  8009a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009ad:	89 f0                	mov    %esi,%eax
  8009af:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b3:	85 c9                	test   %ecx,%ecx
  8009b5:	75 0b                	jne    8009c2 <strlcpy+0x23>
  8009b7:	eb 1d                	jmp    8009d6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009b9:	83 c0 01             	add    $0x1,%eax
  8009bc:	83 c2 01             	add    $0x1,%edx
  8009bf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009c2:	39 d8                	cmp    %ebx,%eax
  8009c4:	74 0b                	je     8009d1 <strlcpy+0x32>
  8009c6:	0f b6 0a             	movzbl (%edx),%ecx
  8009c9:	84 c9                	test   %cl,%cl
  8009cb:	75 ec                	jne    8009b9 <strlcpy+0x1a>
  8009cd:	89 c2                	mov    %eax,%edx
  8009cf:	eb 02                	jmp    8009d3 <strlcpy+0x34>
  8009d1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009d3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009d6:	29 f0                	sub    %esi,%eax
}
  8009d8:	5b                   	pop    %ebx
  8009d9:	5e                   	pop    %esi
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009e5:	eb 06                	jmp    8009ed <strcmp+0x11>
		p++, q++;
  8009e7:	83 c1 01             	add    $0x1,%ecx
  8009ea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ed:	0f b6 01             	movzbl (%ecx),%eax
  8009f0:	84 c0                	test   %al,%al
  8009f2:	74 04                	je     8009f8 <strcmp+0x1c>
  8009f4:	3a 02                	cmp    (%edx),%al
  8009f6:	74 ef                	je     8009e7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009f8:	0f b6 c0             	movzbl %al,%eax
  8009fb:	0f b6 12             	movzbl (%edx),%edx
  8009fe:	29 d0                	sub    %edx,%eax
}
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0c:	89 c3                	mov    %eax,%ebx
  800a0e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a11:	eb 06                	jmp    800a19 <strncmp+0x17>
		n--, p++, q++;
  800a13:	83 c0 01             	add    $0x1,%eax
  800a16:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a19:	39 d8                	cmp    %ebx,%eax
  800a1b:	74 15                	je     800a32 <strncmp+0x30>
  800a1d:	0f b6 08             	movzbl (%eax),%ecx
  800a20:	84 c9                	test   %cl,%cl
  800a22:	74 04                	je     800a28 <strncmp+0x26>
  800a24:	3a 0a                	cmp    (%edx),%cl
  800a26:	74 eb                	je     800a13 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a28:	0f b6 00             	movzbl (%eax),%eax
  800a2b:	0f b6 12             	movzbl (%edx),%edx
  800a2e:	29 d0                	sub    %edx,%eax
  800a30:	eb 05                	jmp    800a37 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a37:	5b                   	pop    %ebx
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a44:	eb 07                	jmp    800a4d <strchr+0x13>
		if (*s == c)
  800a46:	38 ca                	cmp    %cl,%dl
  800a48:	74 0f                	je     800a59 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	0f b6 10             	movzbl (%eax),%edx
  800a50:	84 d2                	test   %dl,%dl
  800a52:	75 f2                	jne    800a46 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a65:	eb 07                	jmp    800a6e <strfind+0x13>
		if (*s == c)
  800a67:	38 ca                	cmp    %cl,%dl
  800a69:	74 0a                	je     800a75 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a6b:	83 c0 01             	add    $0x1,%eax
  800a6e:	0f b6 10             	movzbl (%eax),%edx
  800a71:	84 d2                	test   %dl,%dl
  800a73:	75 f2                	jne    800a67 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a75:	5d                   	pop    %ebp
  800a76:	c3                   	ret    

00800a77 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a77:	55                   	push   %ebp
  800a78:	89 e5                	mov    %esp,%ebp
  800a7a:	57                   	push   %edi
  800a7b:	56                   	push   %esi
  800a7c:	53                   	push   %ebx
  800a7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a83:	85 c9                	test   %ecx,%ecx
  800a85:	74 36                	je     800abd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a87:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a8d:	75 28                	jne    800ab7 <memset+0x40>
  800a8f:	f6 c1 03             	test   $0x3,%cl
  800a92:	75 23                	jne    800ab7 <memset+0x40>
		c &= 0xFF;
  800a94:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a98:	89 d3                	mov    %edx,%ebx
  800a9a:	c1 e3 08             	shl    $0x8,%ebx
  800a9d:	89 d6                	mov    %edx,%esi
  800a9f:	c1 e6 18             	shl    $0x18,%esi
  800aa2:	89 d0                	mov    %edx,%eax
  800aa4:	c1 e0 10             	shl    $0x10,%eax
  800aa7:	09 f0                	or     %esi,%eax
  800aa9:	09 c2                	or     %eax,%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aaf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ab2:	fc                   	cld    
  800ab3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab5:	eb 06                	jmp    800abd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aba:	fc                   	cld    
  800abb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800abd:	89 f8                	mov    %edi,%eax
  800abf:	5b                   	pop    %ebx
  800ac0:	5e                   	pop    %esi
  800ac1:	5f                   	pop    %edi
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    

00800ac4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac4:	55                   	push   %ebp
  800ac5:	89 e5                	mov    %esp,%ebp
  800ac7:	57                   	push   %edi
  800ac8:	56                   	push   %esi
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad2:	39 c6                	cmp    %eax,%esi
  800ad4:	73 35                	jae    800b0b <memmove+0x47>
  800ad6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad9:	39 d0                	cmp    %edx,%eax
  800adb:	73 2e                	jae    800b0b <memmove+0x47>
		s += n;
		d += n;
  800add:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ae0:	89 d6                	mov    %edx,%esi
  800ae2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aea:	75 13                	jne    800aff <memmove+0x3b>
  800aec:	f6 c1 03             	test   $0x3,%cl
  800aef:	75 0e                	jne    800aff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af1:	83 ef 04             	sub    $0x4,%edi
  800af4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800afa:	fd                   	std    
  800afb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800afd:	eb 09                	jmp    800b08 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aff:	83 ef 01             	sub    $0x1,%edi
  800b02:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b05:	fd                   	std    
  800b06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b08:	fc                   	cld    
  800b09:	eb 1d                	jmp    800b28 <memmove+0x64>
  800b0b:	89 f2                	mov    %esi,%edx
  800b0d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0f:	f6 c2 03             	test   $0x3,%dl
  800b12:	75 0f                	jne    800b23 <memmove+0x5f>
  800b14:	f6 c1 03             	test   $0x3,%cl
  800b17:	75 0a                	jne    800b23 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b19:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b1c:	89 c7                	mov    %eax,%edi
  800b1e:	fc                   	cld    
  800b1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b21:	eb 05                	jmp    800b28 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b23:	89 c7                	mov    %eax,%edi
  800b25:	fc                   	cld    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b28:	5e                   	pop    %esi
  800b29:	5f                   	pop    %edi
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b32:	8b 45 10             	mov    0x10(%ebp),%eax
  800b35:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	89 04 24             	mov    %eax,(%esp)
  800b46:	e8 79 ff ff ff       	call   800ac4 <memmove>
}
  800b4b:	c9                   	leave  
  800b4c:	c3                   	ret    

00800b4d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	56                   	push   %esi
  800b51:	53                   	push   %ebx
  800b52:	8b 55 08             	mov    0x8(%ebp),%edx
  800b55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b58:	89 d6                	mov    %edx,%esi
  800b5a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b5d:	eb 1a                	jmp    800b79 <memcmp+0x2c>
		if (*s1 != *s2)
  800b5f:	0f b6 02             	movzbl (%edx),%eax
  800b62:	0f b6 19             	movzbl (%ecx),%ebx
  800b65:	38 d8                	cmp    %bl,%al
  800b67:	74 0a                	je     800b73 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b69:	0f b6 c0             	movzbl %al,%eax
  800b6c:	0f b6 db             	movzbl %bl,%ebx
  800b6f:	29 d8                	sub    %ebx,%eax
  800b71:	eb 0f                	jmp    800b82 <memcmp+0x35>
		s1++, s2++;
  800b73:	83 c2 01             	add    $0x1,%edx
  800b76:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b79:	39 f2                	cmp    %esi,%edx
  800b7b:	75 e2                	jne    800b5f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b8f:	89 c2                	mov    %eax,%edx
  800b91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b94:	eb 07                	jmp    800b9d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b96:	38 08                	cmp    %cl,(%eax)
  800b98:	74 07                	je     800ba1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b9a:	83 c0 01             	add    $0x1,%eax
  800b9d:	39 d0                	cmp    %edx,%eax
  800b9f:	72 f5                	jb     800b96 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800baf:	eb 03                	jmp    800bb4 <strtol+0x11>
		s++;
  800bb1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb4:	0f b6 0a             	movzbl (%edx),%ecx
  800bb7:	80 f9 09             	cmp    $0x9,%cl
  800bba:	74 f5                	je     800bb1 <strtol+0xe>
  800bbc:	80 f9 20             	cmp    $0x20,%cl
  800bbf:	74 f0                	je     800bb1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bc1:	80 f9 2b             	cmp    $0x2b,%cl
  800bc4:	75 0a                	jne    800bd0 <strtol+0x2d>
		s++;
  800bc6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bc9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bce:	eb 11                	jmp    800be1 <strtol+0x3e>
  800bd0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bd5:	80 f9 2d             	cmp    $0x2d,%cl
  800bd8:	75 07                	jne    800be1 <strtol+0x3e>
		s++, neg = 1;
  800bda:	8d 52 01             	lea    0x1(%edx),%edx
  800bdd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800be1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800be6:	75 15                	jne    800bfd <strtol+0x5a>
  800be8:	80 3a 30             	cmpb   $0x30,(%edx)
  800beb:	75 10                	jne    800bfd <strtol+0x5a>
  800bed:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bf1:	75 0a                	jne    800bfd <strtol+0x5a>
		s += 2, base = 16;
  800bf3:	83 c2 02             	add    $0x2,%edx
  800bf6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bfb:	eb 10                	jmp    800c0d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	75 0c                	jne    800c0d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c01:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c03:	80 3a 30             	cmpb   $0x30,(%edx)
  800c06:	75 05                	jne    800c0d <strtol+0x6a>
		s++, base = 8;
  800c08:	83 c2 01             	add    $0x1,%edx
  800c0b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c12:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c15:	0f b6 0a             	movzbl (%edx),%ecx
  800c18:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c1b:	89 f0                	mov    %esi,%eax
  800c1d:	3c 09                	cmp    $0x9,%al
  800c1f:	77 08                	ja     800c29 <strtol+0x86>
			dig = *s - '0';
  800c21:	0f be c9             	movsbl %cl,%ecx
  800c24:	83 e9 30             	sub    $0x30,%ecx
  800c27:	eb 20                	jmp    800c49 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c29:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c2c:	89 f0                	mov    %esi,%eax
  800c2e:	3c 19                	cmp    $0x19,%al
  800c30:	77 08                	ja     800c3a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c32:	0f be c9             	movsbl %cl,%ecx
  800c35:	83 e9 57             	sub    $0x57,%ecx
  800c38:	eb 0f                	jmp    800c49 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c3a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c3d:	89 f0                	mov    %esi,%eax
  800c3f:	3c 19                	cmp    $0x19,%al
  800c41:	77 16                	ja     800c59 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c43:	0f be c9             	movsbl %cl,%ecx
  800c46:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c49:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c4c:	7d 0f                	jge    800c5d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c4e:	83 c2 01             	add    $0x1,%edx
  800c51:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c55:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c57:	eb bc                	jmp    800c15 <strtol+0x72>
  800c59:	89 d8                	mov    %ebx,%eax
  800c5b:	eb 02                	jmp    800c5f <strtol+0xbc>
  800c5d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c63:	74 05                	je     800c6a <strtol+0xc7>
		*endptr = (char *) s;
  800c65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c68:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c6a:	f7 d8                	neg    %eax
  800c6c:	85 ff                	test   %edi,%edi
  800c6e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c71:	5b                   	pop    %ebx
  800c72:	5e                   	pop    %esi
  800c73:	5f                   	pop    %edi
  800c74:	5d                   	pop    %ebp
  800c75:	c3                   	ret    

00800c76 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	57                   	push   %edi
  800c7a:	56                   	push   %esi
  800c7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c84:	8b 55 08             	mov    0x8(%ebp),%edx
  800c87:	89 c3                	mov    %eax,%ebx
  800c89:	89 c7                	mov    %eax,%edi
  800c8b:	89 c6                	mov    %eax,%esi
  800c8d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9f:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca4:	89 d1                	mov    %edx,%ecx
  800ca6:	89 d3                	mov    %edx,%ebx
  800ca8:	89 d7                	mov    %edx,%edi
  800caa:	89 d6                	mov    %edx,%esi
  800cac:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cae:	5b                   	pop    %ebx
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	89 cb                	mov    %ecx,%ebx
  800ccb:	89 cf                	mov    %ecx,%edi
  800ccd:	89 ce                	mov    %ecx,%esi
  800ccf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd1:	85 c0                	test   %eax,%eax
  800cd3:	7e 28                	jle    800cfd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cd9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ce0:	00 
  800ce1:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800ce8:	00 
  800ce9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf0:	00 
  800cf1:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800cf8:	e8 89 1a 00 00       	call   802786 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cfd:	83 c4 2c             	add    $0x2c,%esp
  800d00:	5b                   	pop    %ebx
  800d01:	5e                   	pop    %esi
  800d02:	5f                   	pop    %edi
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	57                   	push   %edi
  800d09:	56                   	push   %esi
  800d0a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	b8 02 00 00 00       	mov    $0x2,%eax
  800d15:	89 d1                	mov    %edx,%ecx
  800d17:	89 d3                	mov    %edx,%ebx
  800d19:	89 d7                	mov    %edx,%edi
  800d1b:	89 d6                	mov    %edx,%esi
  800d1d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <sys_yield>:

void
sys_yield(void)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d34:	89 d1                	mov    %edx,%ecx
  800d36:	89 d3                	mov    %edx,%ebx
  800d38:	89 d7                	mov    %edx,%edi
  800d3a:	89 d6                	mov    %edx,%esi
  800d3c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4c:	be 00 00 00 00       	mov    $0x0,%esi
  800d51:	b8 04 00 00 00       	mov    $0x4,%eax
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5f:	89 f7                	mov    %esi,%edi
  800d61:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d63:	85 c0                	test   %eax,%eax
  800d65:	7e 28                	jle    800d8f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d67:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d6b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d72:	00 
  800d73:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800d7a:	00 
  800d7b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d82:	00 
  800d83:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800d8a:	e8 f7 19 00 00       	call   802786 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d8f:	83 c4 2c             	add    $0x2c,%esp
  800d92:	5b                   	pop    %ebx
  800d93:	5e                   	pop    %esi
  800d94:	5f                   	pop    %edi
  800d95:	5d                   	pop    %ebp
  800d96:	c3                   	ret    

00800d97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	57                   	push   %edi
  800d9b:	56                   	push   %esi
  800d9c:	53                   	push   %ebx
  800d9d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da0:	b8 05 00 00 00       	mov    $0x5,%eax
  800da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db1:	8b 75 18             	mov    0x18(%ebp),%esi
  800db4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db6:	85 c0                	test   %eax,%eax
  800db8:	7e 28                	jle    800de2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dba:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dbe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dc5:	00 
  800dc6:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800dcd:	00 
  800dce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd5:	00 
  800dd6:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800ddd:	e8 a4 19 00 00       	call   802786 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800de2:	83 c4 2c             	add    $0x2c,%esp
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	57                   	push   %edi
  800dee:	56                   	push   %esi
  800def:	53                   	push   %ebx
  800df0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e00:	8b 55 08             	mov    0x8(%ebp),%edx
  800e03:	89 df                	mov    %ebx,%edi
  800e05:	89 de                	mov    %ebx,%esi
  800e07:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	7e 28                	jle    800e35 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e11:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e18:	00 
  800e19:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800e20:	00 
  800e21:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e28:	00 
  800e29:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800e30:	e8 51 19 00 00       	call   802786 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e35:	83 c4 2c             	add    $0x2c,%esp
  800e38:	5b                   	pop    %ebx
  800e39:	5e                   	pop    %esi
  800e3a:	5f                   	pop    %edi
  800e3b:	5d                   	pop    %ebp
  800e3c:	c3                   	ret    

00800e3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	57                   	push   %edi
  800e41:	56                   	push   %esi
  800e42:	53                   	push   %ebx
  800e43:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e53:	8b 55 08             	mov    0x8(%ebp),%edx
  800e56:	89 df                	mov    %ebx,%edi
  800e58:	89 de                	mov    %ebx,%esi
  800e5a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5c:	85 c0                	test   %eax,%eax
  800e5e:	7e 28                	jle    800e88 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e60:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e64:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e6b:	00 
  800e6c:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800e73:	00 
  800e74:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7b:	00 
  800e7c:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800e83:	e8 fe 18 00 00       	call   802786 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e88:	83 c4 2c             	add    $0x2c,%esp
  800e8b:	5b                   	pop    %ebx
  800e8c:	5e                   	pop    %esi
  800e8d:	5f                   	pop    %edi
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    

00800e90 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	57                   	push   %edi
  800e94:	56                   	push   %esi
  800e95:	53                   	push   %ebx
  800e96:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea9:	89 df                	mov    %ebx,%edi
  800eab:	89 de                	mov    %ebx,%esi
  800ead:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	7e 28                	jle    800edb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ebe:	00 
  800ebf:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800ec6:	00 
  800ec7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ece:	00 
  800ecf:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800ed6:	e8 ab 18 00 00       	call   802786 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800edb:	83 c4 2c             	add    $0x2c,%esp
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
  800ee9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	89 df                	mov    %ebx,%edi
  800efe:	89 de                	mov    %ebx,%esi
  800f00:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f02:	85 c0                	test   %eax,%eax
  800f04:	7e 28                	jle    800f2e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f06:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f11:	00 
  800f12:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800f19:	00 
  800f1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f21:	00 
  800f22:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800f29:	e8 58 18 00 00       	call   802786 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f2e:	83 c4 2c             	add    $0x2c,%esp
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3c:	be 00 00 00 00       	mov    $0x0,%esi
  800f41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f52:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	57                   	push   %edi
  800f5d:	56                   	push   %esi
  800f5e:	53                   	push   %ebx
  800f5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f67:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	89 cb                	mov    %ecx,%ebx
  800f71:	89 cf                	mov    %ecx,%edi
  800f73:	89 ce                	mov    %ecx,%esi
  800f75:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f77:	85 c0                	test   %eax,%eax
  800f79:	7e 28                	jle    800fa3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f86:	00 
  800f87:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  800f8e:	00 
  800f8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f96:	00 
  800f97:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  800f9e:	e8 e3 17 00 00       	call   802786 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa3:	83 c4 2c             	add    $0x2c,%esp
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5f                   	pop    %edi
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	57                   	push   %edi
  800faf:	56                   	push   %esi
  800fb0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fbb:	89 d1                	mov    %edx,%ecx
  800fbd:	89 d3                	mov    %edx,%ebx
  800fbf:	89 d7                	mov    %edx,%edi
  800fc1:	89 d6                	mov    %edx,%esi
  800fc3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fc5:	5b                   	pop    %ebx
  800fc6:	5e                   	pop    %esi
  800fc7:	5f                   	pop    %edi
  800fc8:	5d                   	pop    %ebp
  800fc9:	c3                   	ret    

00800fca <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	57                   	push   %edi
  800fce:	56                   	push   %esi
  800fcf:	53                   	push   %ebx
  800fd0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe3:	89 df                	mov    %ebx,%edi
  800fe5:	89 de                	mov    %ebx,%esi
  800fe7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	7e 28                	jle    801015 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fed:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ff8:	00 
  800ff9:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  801000:	00 
  801001:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801008:	00 
  801009:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  801010:	e8 71 17 00 00       	call   802786 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801015:	83 c4 2c             	add    $0x2c,%esp
  801018:	5b                   	pop    %ebx
  801019:	5e                   	pop    %esi
  80101a:	5f                   	pop    %edi
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	57                   	push   %edi
  801021:	56                   	push   %esi
  801022:	53                   	push   %ebx
  801023:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801026:	bb 00 00 00 00       	mov    $0x0,%ebx
  80102b:	b8 10 00 00 00       	mov    $0x10,%eax
  801030:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	89 df                	mov    %ebx,%edi
  801038:	89 de                	mov    %ebx,%esi
  80103a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80103c:	85 c0                	test   %eax,%eax
  80103e:	7e 28                	jle    801068 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801040:	89 44 24 10          	mov    %eax,0x10(%esp)
  801044:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80104b:	00 
  80104c:	c7 44 24 08 ff 2e 80 	movl   $0x802eff,0x8(%esp)
  801053:	00 
  801054:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105b:	00 
  80105c:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  801063:	e8 1e 17 00 00       	call   802786 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801068:	83 c4 2c             	add    $0x2c,%esp
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    

00801070 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
  801073:	53                   	push   %ebx
  801074:	83 ec 24             	sub    $0x24,%esp
  801077:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  80107a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  80107c:	89 d3                	mov    %edx,%ebx
  80107e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  801084:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801088:	74 1a                	je     8010a4 <pgfault+0x34>
  80108a:	c1 ea 0c             	shr    $0xc,%edx
  80108d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801094:	a8 01                	test   $0x1,%al
  801096:	74 0c                	je     8010a4 <pgfault+0x34>
  801098:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80109f:	f6 c4 08             	test   $0x8,%ah
  8010a2:	75 1c                	jne    8010c0 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  8010a4:	c7 44 24 08 2c 2f 80 	movl   $0x802f2c,0x8(%esp)
  8010ab:	00 
  8010ac:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8010b3:	00 
  8010b4:	c7 04 24 7b 30 80 00 	movl   $0x80307b,(%esp)
  8010bb:	e8 c6 16 00 00       	call   802786 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  8010c0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010c7:	00 
  8010c8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010cf:	00 
  8010d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010d7:	e8 67 fc ff ff       	call   800d43 <sys_page_alloc>
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	79 1c                	jns    8010fc <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  8010e0:	c7 44 24 08 70 2f 80 	movl   $0x802f70,0x8(%esp)
  8010e7:	00 
  8010e8:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  8010ef:	00 
  8010f0:	c7 04 24 7b 30 80 00 	movl   $0x80307b,(%esp)
  8010f7:	e8 8a 16 00 00       	call   802786 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  8010fc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801103:	00 
  801104:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801108:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80110f:	e8 18 fa ff ff       	call   800b2c <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801114:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80111b:	00 
  80111c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801120:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801127:	00 
  801128:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80112f:	00 
  801130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801137:	e8 5b fc ff ff       	call   800d97 <sys_page_map>
  80113c:	85 c0                	test   %eax,%eax
  80113e:	74 1c                	je     80115c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  801140:	c7 44 24 08 86 30 80 	movl   $0x803086,0x8(%esp)
  801147:	00 
  801148:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80114f:	00 
  801150:	c7 04 24 7b 30 80 00 	movl   $0x80307b,(%esp)
  801157:	e8 2a 16 00 00       	call   802786 <_panic>
    sys_page_unmap(0,PFTEMP);
  80115c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801163:	00 
  801164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80116b:	e8 7a fc ff ff       	call   800dea <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801170:	83 c4 24             	add    $0x24,%esp
  801173:	5b                   	pop    %ebx
  801174:	5d                   	pop    %ebp
  801175:	c3                   	ret    

00801176 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	57                   	push   %edi
  80117a:	56                   	push   %esi
  80117b:	53                   	push   %ebx
  80117c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80117f:	c7 04 24 70 10 80 00 	movl   $0x801070,(%esp)
  801186:	e8 51 16 00 00       	call   8027dc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80118b:	b8 07 00 00 00       	mov    $0x7,%eax
  801190:	cd 30                	int    $0x30
  801192:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801195:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801197:	bb 00 00 00 00       	mov    $0x0,%ebx
  80119c:	85 c0                	test   %eax,%eax
  80119e:	75 21                	jne    8011c1 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8011a0:	e8 60 fb ff ff       	call   800d05 <sys_getenvid>
  8011a5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011aa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011b2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8011b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bc:	e9 de 01 00 00       	jmp    80139f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  8011c1:	89 d8                	mov    %ebx,%eax
  8011c3:	c1 e8 16             	shr    $0x16,%eax
  8011c6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011cd:	a8 01                	test   $0x1,%al
  8011cf:	0f 84 58 01 00 00    	je     80132d <fork+0x1b7>
  8011d5:	89 de                	mov    %ebx,%esi
  8011d7:	c1 ee 0c             	shr    $0xc,%esi
  8011da:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011e1:	83 e0 05             	and    $0x5,%eax
  8011e4:	83 f8 05             	cmp    $0x5,%eax
  8011e7:	0f 85 40 01 00 00    	jne    80132d <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  8011ed:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011f4:	f6 c4 04             	test   $0x4,%ah
  8011f7:	74 4f                	je     801248 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  8011f9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801200:	c1 e6 0c             	shl    $0xc,%esi
  801203:	25 07 0e 00 00       	and    $0xe07,%eax
  801208:	89 44 24 10          	mov    %eax,0x10(%esp)
  80120c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801210:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801214:	89 74 24 04          	mov    %esi,0x4(%esp)
  801218:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80121f:	e8 73 fb ff ff       	call   800d97 <sys_page_map>
  801224:	85 c0                	test   %eax,%eax
  801226:	0f 89 01 01 00 00    	jns    80132d <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  80122c:	c7 44 24 08 90 2f 80 	movl   $0x802f90,0x8(%esp)
  801233:	00 
  801234:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  80123b:	00 
  80123c:	c7 04 24 7b 30 80 00 	movl   $0x80307b,(%esp)
  801243:	e8 3e 15 00 00       	call   802786 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  801248:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80124f:	a8 02                	test   $0x2,%al
  801251:	75 10                	jne    801263 <fork+0xed>
  801253:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80125a:	f6 c4 08             	test   $0x8,%ah
  80125d:	0f 84 87 00 00 00    	je     8012ea <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801263:	c1 e6 0c             	shl    $0xc,%esi
  801266:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80126d:	00 
  80126e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801272:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801276:	89 74 24 04          	mov    %esi,0x4(%esp)
  80127a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801281:	e8 11 fb ff ff       	call   800d97 <sys_page_map>
  801286:	85 c0                	test   %eax,%eax
  801288:	79 1c                	jns    8012a6 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80128a:	c7 44 24 08 c8 2f 80 	movl   $0x802fc8,0x8(%esp)
  801291:	00 
  801292:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801299:	00 
  80129a:	c7 04 24 7b 30 80 00 	movl   $0x80307b,(%esp)
  8012a1:	e8 e0 14 00 00       	call   802786 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  8012a6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012ad:	00 
  8012ae:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012b2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012b9:	00 
  8012ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012c5:	e8 cd fa ff ff       	call   800d97 <sys_page_map>
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	79 5f                	jns    80132d <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  8012ce:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  8012d5:	00 
  8012d6:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8012dd:	00 
  8012de:	c7 04 24 7b 30 80 00 	movl   $0x80307b,(%esp)
  8012e5:	e8 9c 14 00 00       	call   802786 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  8012ea:	c1 e6 0c             	shl    $0xc,%esi
  8012ed:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8012f4:	00 
  8012f5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012f9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  801301:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801308:	e8 8a fa ff ff       	call   800d97 <sys_page_map>
  80130d:	85 c0                	test   %eax,%eax
  80130f:	74 1c                	je     80132d <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801311:	c7 44 24 08 28 30 80 	movl   $0x803028,0x8(%esp)
  801318:	00 
  801319:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801320:	00 
  801321:	c7 04 24 7b 30 80 00 	movl   $0x80307b,(%esp)
  801328:	e8 59 14 00 00       	call   802786 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  80132d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801333:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801339:	0f 85 82 fe ff ff    	jne    8011c1 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  80133f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801346:	00 
  801347:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80134e:	ee 
  80134f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801352:	89 04 24             	mov    %eax,(%esp)
  801355:	e8 e9 f9 ff ff       	call   800d43 <sys_page_alloc>
  80135a:	85 c0                	test   %eax,%eax
  80135c:	79 1c                	jns    80137a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  80135e:	c7 44 24 08 5c 30 80 	movl   $0x80305c,0x8(%esp)
  801365:	00 
  801366:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  80136d:	00 
  80136e:	c7 04 24 7b 30 80 00 	movl   $0x80307b,(%esp)
  801375:	e8 0c 14 00 00       	call   802786 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  80137a:	c7 44 24 04 4d 28 80 	movl   $0x80284d,0x4(%esp)
  801381:	00 
  801382:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801385:	89 3c 24             	mov    %edi,(%esp)
  801388:	e8 56 fb ff ff       	call   800ee3 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80138d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801394:	00 
  801395:	89 3c 24             	mov    %edi,(%esp)
  801398:	e8 a0 fa ff ff       	call   800e3d <sys_env_set_status>
		return child;
  80139d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80139f:	83 c4 2c             	add    $0x2c,%esp
  8013a2:	5b                   	pop    %ebx
  8013a3:	5e                   	pop    %esi
  8013a4:	5f                   	pop    %edi
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <sfork>:

// Challenge!
int
sfork(void)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8013ad:	c7 44 24 08 a4 30 80 	movl   $0x8030a4,0x8(%esp)
  8013b4:	00 
  8013b5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8013bc:	00 
  8013bd:	c7 04 24 7b 30 80 00 	movl   $0x80307b,(%esp)
  8013c4:	e8 bd 13 00 00       	call   802786 <_panic>

008013c9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	56                   	push   %esi
  8013cd:	53                   	push   %ebx
  8013ce:	83 ec 10             	sub    $0x10,%esp
  8013d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8013d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8013da:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8013dc:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8013e1:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8013e4:	89 04 24             	mov    %eax,(%esp)
  8013e7:	e8 6d fb ff ff       	call   800f59 <sys_ipc_recv>
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	75 1e                	jne    80140e <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8013f0:	85 db                	test   %ebx,%ebx
  8013f2:	74 0a                	je     8013fe <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8013f4:	a1 08 50 80 00       	mov    0x805008,%eax
  8013f9:	8b 40 74             	mov    0x74(%eax),%eax
  8013fc:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8013fe:	85 f6                	test   %esi,%esi
  801400:	74 22                	je     801424 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  801402:	a1 08 50 80 00       	mov    0x805008,%eax
  801407:	8b 40 78             	mov    0x78(%eax),%eax
  80140a:	89 06                	mov    %eax,(%esi)
  80140c:	eb 16                	jmp    801424 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80140e:	85 f6                	test   %esi,%esi
  801410:	74 06                	je     801418 <ipc_recv+0x4f>
				*perm_store = 0;
  801412:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  801418:	85 db                	test   %ebx,%ebx
  80141a:	74 10                	je     80142c <ipc_recv+0x63>
				*from_env_store=0;
  80141c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801422:	eb 08                	jmp    80142c <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  801424:	a1 08 50 80 00       	mov    0x805008,%eax
  801429:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  80142c:	83 c4 10             	add    $0x10,%esp
  80142f:	5b                   	pop    %ebx
  801430:	5e                   	pop    %esi
  801431:	5d                   	pop    %ebp
  801432:	c3                   	ret    

00801433 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	57                   	push   %edi
  801437:	56                   	push   %esi
  801438:	53                   	push   %ebx
  801439:	83 ec 1c             	sub    $0x1c,%esp
  80143c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80143f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801442:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  801445:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  801447:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  80144c:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80144f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801453:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801457:	89 74 24 04          	mov    %esi,0x4(%esp)
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	89 04 24             	mov    %eax,(%esp)
  801461:	e8 d0 fa ff ff       	call   800f36 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  801466:	eb 1c                	jmp    801484 <ipc_send+0x51>
	{
		sys_yield();
  801468:	e8 b7 f8 ff ff       	call   800d24 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80146d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801471:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801475:	89 74 24 04          	mov    %esi,0x4(%esp)
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	89 04 24             	mov    %eax,(%esp)
  80147f:	e8 b2 fa ff ff       	call   800f36 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  801484:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801487:	74 df                	je     801468 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  801489:	83 c4 1c             	add    $0x1c,%esp
  80148c:	5b                   	pop    %ebx
  80148d:	5e                   	pop    %esi
  80148e:	5f                   	pop    %edi
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    

00801491 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801497:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80149c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80149f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8014a5:	8b 52 50             	mov    0x50(%edx),%edx
  8014a8:	39 ca                	cmp    %ecx,%edx
  8014aa:	75 0d                	jne    8014b9 <ipc_find_env+0x28>
			return envs[i].env_id;
  8014ac:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8014af:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8014b4:	8b 40 40             	mov    0x40(%eax),%eax
  8014b7:	eb 0e                	jmp    8014c7 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8014b9:	83 c0 01             	add    $0x1,%eax
  8014bc:	3d 00 04 00 00       	cmp    $0x400,%eax
  8014c1:	75 d9                	jne    80149c <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8014c3:	66 b8 00 00          	mov    $0x0,%ax
}
  8014c7:	5d                   	pop    %ebp
  8014c8:	c3                   	ret    
  8014c9:	66 90                	xchg   %ax,%ax
  8014cb:	66 90                	xchg   %ax,%ax
  8014cd:	66 90                	xchg   %ax,%ax
  8014cf:	90                   	nop

008014d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014db:	c1 e8 0c             	shr    $0xc,%eax
}
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    

008014e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8014eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801502:	89 c2                	mov    %eax,%edx
  801504:	c1 ea 16             	shr    $0x16,%edx
  801507:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80150e:	f6 c2 01             	test   $0x1,%dl
  801511:	74 11                	je     801524 <fd_alloc+0x2d>
  801513:	89 c2                	mov    %eax,%edx
  801515:	c1 ea 0c             	shr    $0xc,%edx
  801518:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80151f:	f6 c2 01             	test   $0x1,%dl
  801522:	75 09                	jne    80152d <fd_alloc+0x36>
			*fd_store = fd;
  801524:	89 01                	mov    %eax,(%ecx)
			return 0;
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
  80152b:	eb 17                	jmp    801544 <fd_alloc+0x4d>
  80152d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801532:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801537:	75 c9                	jne    801502 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801539:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80153f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801544:	5d                   	pop    %ebp
  801545:	c3                   	ret    

00801546 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80154c:	83 f8 1f             	cmp    $0x1f,%eax
  80154f:	77 36                	ja     801587 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801551:	c1 e0 0c             	shl    $0xc,%eax
  801554:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801559:	89 c2                	mov    %eax,%edx
  80155b:	c1 ea 16             	shr    $0x16,%edx
  80155e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801565:	f6 c2 01             	test   $0x1,%dl
  801568:	74 24                	je     80158e <fd_lookup+0x48>
  80156a:	89 c2                	mov    %eax,%edx
  80156c:	c1 ea 0c             	shr    $0xc,%edx
  80156f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801576:	f6 c2 01             	test   $0x1,%dl
  801579:	74 1a                	je     801595 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	89 02                	mov    %eax,(%edx)
	return 0;
  801580:	b8 00 00 00 00       	mov    $0x0,%eax
  801585:	eb 13                	jmp    80159a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801587:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80158c:	eb 0c                	jmp    80159a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80158e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801593:	eb 05                	jmp    80159a <fd_lookup+0x54>
  801595:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 18             	sub    $0x18,%esp
  8015a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8015a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015aa:	eb 13                	jmp    8015bf <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8015ac:	39 08                	cmp    %ecx,(%eax)
  8015ae:	75 0c                	jne    8015bc <dev_lookup+0x20>
			*dev = devtab[i];
  8015b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ba:	eb 38                	jmp    8015f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8015bc:	83 c2 01             	add    $0x1,%edx
  8015bf:	8b 04 95 38 31 80 00 	mov    0x803138(,%edx,4),%eax
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	75 e2                	jne    8015ac <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8015cf:	8b 40 48             	mov    0x48(%eax),%eax
  8015d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015da:	c7 04 24 bc 30 80 00 	movl   $0x8030bc,(%esp)
  8015e1:	e8 20 ed ff ff       	call   800306 <cprintf>
	*dev = 0;
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	56                   	push   %esi
  8015fa:	53                   	push   %ebx
  8015fb:	83 ec 20             	sub    $0x20,%esp
  8015fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801601:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801604:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801607:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80160b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801611:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801614:	89 04 24             	mov    %eax,(%esp)
  801617:	e8 2a ff ff ff       	call   801546 <fd_lookup>
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 05                	js     801625 <fd_close+0x2f>
	    || fd != fd2)
  801620:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801623:	74 0c                	je     801631 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801625:	84 db                	test   %bl,%bl
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	0f 44 c2             	cmove  %edx,%eax
  80162f:	eb 3f                	jmp    801670 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801631:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801634:	89 44 24 04          	mov    %eax,0x4(%esp)
  801638:	8b 06                	mov    (%esi),%eax
  80163a:	89 04 24             	mov    %eax,(%esp)
  80163d:	e8 5a ff ff ff       	call   80159c <dev_lookup>
  801642:	89 c3                	mov    %eax,%ebx
  801644:	85 c0                	test   %eax,%eax
  801646:	78 16                	js     80165e <fd_close+0x68>
		if (dev->dev_close)
  801648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80164e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801653:	85 c0                	test   %eax,%eax
  801655:	74 07                	je     80165e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801657:	89 34 24             	mov    %esi,(%esp)
  80165a:	ff d0                	call   *%eax
  80165c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80165e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801662:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801669:	e8 7c f7 ff ff       	call   800dea <sys_page_unmap>
	return r;
  80166e:	89 d8                	mov    %ebx,%eax
}
  801670:	83 c4 20             	add    $0x20,%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80167d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801680:	89 44 24 04          	mov    %eax,0x4(%esp)
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	89 04 24             	mov    %eax,(%esp)
  80168a:	e8 b7 fe ff ff       	call   801546 <fd_lookup>
  80168f:	89 c2                	mov    %eax,%edx
  801691:	85 d2                	test   %edx,%edx
  801693:	78 13                	js     8016a8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801695:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80169c:	00 
  80169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a0:	89 04 24             	mov    %eax,(%esp)
  8016a3:	e8 4e ff ff ff       	call   8015f6 <fd_close>
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <close_all>:

void
close_all(void)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	53                   	push   %ebx
  8016ae:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016b6:	89 1c 24             	mov    %ebx,(%esp)
  8016b9:	e8 b9 ff ff ff       	call   801677 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016be:	83 c3 01             	add    $0x1,%ebx
  8016c1:	83 fb 20             	cmp    $0x20,%ebx
  8016c4:	75 f0                	jne    8016b6 <close_all+0xc>
		close(i);
}
  8016c6:	83 c4 14             	add    $0x14,%esp
  8016c9:	5b                   	pop    %ebx
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    

008016cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	57                   	push   %edi
  8016d0:	56                   	push   %esi
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	89 04 24             	mov    %eax,(%esp)
  8016e2:	e8 5f fe ff ff       	call   801546 <fd_lookup>
  8016e7:	89 c2                	mov    %eax,%edx
  8016e9:	85 d2                	test   %edx,%edx
  8016eb:	0f 88 e1 00 00 00    	js     8017d2 <dup+0x106>
		return r;
	close(newfdnum);
  8016f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f4:	89 04 24             	mov    %eax,(%esp)
  8016f7:	e8 7b ff ff ff       	call   801677 <close>

	newfd = INDEX2FD(newfdnum);
  8016fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016ff:	c1 e3 0c             	shl    $0xc,%ebx
  801702:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170b:	89 04 24             	mov    %eax,(%esp)
  80170e:	e8 cd fd ff ff       	call   8014e0 <fd2data>
  801713:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801715:	89 1c 24             	mov    %ebx,(%esp)
  801718:	e8 c3 fd ff ff       	call   8014e0 <fd2data>
  80171d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80171f:	89 f0                	mov    %esi,%eax
  801721:	c1 e8 16             	shr    $0x16,%eax
  801724:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80172b:	a8 01                	test   $0x1,%al
  80172d:	74 43                	je     801772 <dup+0xa6>
  80172f:	89 f0                	mov    %esi,%eax
  801731:	c1 e8 0c             	shr    $0xc,%eax
  801734:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80173b:	f6 c2 01             	test   $0x1,%dl
  80173e:	74 32                	je     801772 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801740:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801747:	25 07 0e 00 00       	and    $0xe07,%eax
  80174c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801750:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801754:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80175b:	00 
  80175c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801760:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801767:	e8 2b f6 ff ff       	call   800d97 <sys_page_map>
  80176c:	89 c6                	mov    %eax,%esi
  80176e:	85 c0                	test   %eax,%eax
  801770:	78 3e                	js     8017b0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801775:	89 c2                	mov    %eax,%edx
  801777:	c1 ea 0c             	shr    $0xc,%edx
  80177a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801781:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801787:	89 54 24 10          	mov    %edx,0x10(%esp)
  80178b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80178f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801796:	00 
  801797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a2:	e8 f0 f5 ff ff       	call   800d97 <sys_page_map>
  8017a7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8017a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017ac:	85 f6                	test   %esi,%esi
  8017ae:	79 22                	jns    8017d2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017bb:	e8 2a f6 ff ff       	call   800dea <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017cb:	e8 1a f6 ff ff       	call   800dea <sys_page_unmap>
	return r;
  8017d0:	89 f0                	mov    %esi,%eax
}
  8017d2:	83 c4 3c             	add    $0x3c,%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5e                   	pop    %esi
  8017d7:	5f                   	pop    %edi
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    

008017da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	53                   	push   %ebx
  8017de:	83 ec 24             	sub    $0x24,%esp
  8017e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017eb:	89 1c 24             	mov    %ebx,(%esp)
  8017ee:	e8 53 fd ff ff       	call   801546 <fd_lookup>
  8017f3:	89 c2                	mov    %eax,%edx
  8017f5:	85 d2                	test   %edx,%edx
  8017f7:	78 6d                	js     801866 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801803:	8b 00                	mov    (%eax),%eax
  801805:	89 04 24             	mov    %eax,(%esp)
  801808:	e8 8f fd ff ff       	call   80159c <dev_lookup>
  80180d:	85 c0                	test   %eax,%eax
  80180f:	78 55                	js     801866 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801814:	8b 50 08             	mov    0x8(%eax),%edx
  801817:	83 e2 03             	and    $0x3,%edx
  80181a:	83 fa 01             	cmp    $0x1,%edx
  80181d:	75 23                	jne    801842 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80181f:	a1 08 50 80 00       	mov    0x805008,%eax
  801824:	8b 40 48             	mov    0x48(%eax),%eax
  801827:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80182b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182f:	c7 04 24 fd 30 80 00 	movl   $0x8030fd,(%esp)
  801836:	e8 cb ea ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  80183b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801840:	eb 24                	jmp    801866 <read+0x8c>
	}
	if (!dev->dev_read)
  801842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801845:	8b 52 08             	mov    0x8(%edx),%edx
  801848:	85 d2                	test   %edx,%edx
  80184a:	74 15                	je     801861 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80184c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801853:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801856:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80185a:	89 04 24             	mov    %eax,(%esp)
  80185d:	ff d2                	call   *%edx
  80185f:	eb 05                	jmp    801866 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801861:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801866:	83 c4 24             	add    $0x24,%esp
  801869:	5b                   	pop    %ebx
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    

0080186c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	57                   	push   %edi
  801870:	56                   	push   %esi
  801871:	53                   	push   %ebx
  801872:	83 ec 1c             	sub    $0x1c,%esp
  801875:	8b 7d 08             	mov    0x8(%ebp),%edi
  801878:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80187b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801880:	eb 23                	jmp    8018a5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801882:	89 f0                	mov    %esi,%eax
  801884:	29 d8                	sub    %ebx,%eax
  801886:	89 44 24 08          	mov    %eax,0x8(%esp)
  80188a:	89 d8                	mov    %ebx,%eax
  80188c:	03 45 0c             	add    0xc(%ebp),%eax
  80188f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801893:	89 3c 24             	mov    %edi,(%esp)
  801896:	e8 3f ff ff ff       	call   8017da <read>
		if (m < 0)
  80189b:	85 c0                	test   %eax,%eax
  80189d:	78 10                	js     8018af <readn+0x43>
			return m;
		if (m == 0)
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	74 0a                	je     8018ad <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018a3:	01 c3                	add    %eax,%ebx
  8018a5:	39 f3                	cmp    %esi,%ebx
  8018a7:	72 d9                	jb     801882 <readn+0x16>
  8018a9:	89 d8                	mov    %ebx,%eax
  8018ab:	eb 02                	jmp    8018af <readn+0x43>
  8018ad:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018af:	83 c4 1c             	add    $0x1c,%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5f                   	pop    %edi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 24             	sub    $0x24,%esp
  8018be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c8:	89 1c 24             	mov    %ebx,(%esp)
  8018cb:	e8 76 fc ff ff       	call   801546 <fd_lookup>
  8018d0:	89 c2                	mov    %eax,%edx
  8018d2:	85 d2                	test   %edx,%edx
  8018d4:	78 68                	js     80193e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e0:	8b 00                	mov    (%eax),%eax
  8018e2:	89 04 24             	mov    %eax,(%esp)
  8018e5:	e8 b2 fc ff ff       	call   80159c <dev_lookup>
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 50                	js     80193e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018f5:	75 23                	jne    80191a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018f7:	a1 08 50 80 00       	mov    0x805008,%eax
  8018fc:	8b 40 48             	mov    0x48(%eax),%eax
  8018ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801903:	89 44 24 04          	mov    %eax,0x4(%esp)
  801907:	c7 04 24 19 31 80 00 	movl   $0x803119,(%esp)
  80190e:	e8 f3 e9 ff ff       	call   800306 <cprintf>
		return -E_INVAL;
  801913:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801918:	eb 24                	jmp    80193e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80191a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80191d:	8b 52 0c             	mov    0xc(%edx),%edx
  801920:	85 d2                	test   %edx,%edx
  801922:	74 15                	je     801939 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801924:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801927:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80192b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80192e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801932:	89 04 24             	mov    %eax,(%esp)
  801935:	ff d2                	call   *%edx
  801937:	eb 05                	jmp    80193e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801939:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80193e:	83 c4 24             	add    $0x24,%esp
  801941:	5b                   	pop    %ebx
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <seek>:

int
seek(int fdnum, off_t offset)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80194d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	89 04 24             	mov    %eax,(%esp)
  801957:	e8 ea fb ff ff       	call   801546 <fd_lookup>
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 0e                	js     80196e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801963:	8b 55 0c             	mov    0xc(%ebp),%edx
  801966:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	53                   	push   %ebx
  801974:	83 ec 24             	sub    $0x24,%esp
  801977:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80197a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801981:	89 1c 24             	mov    %ebx,(%esp)
  801984:	e8 bd fb ff ff       	call   801546 <fd_lookup>
  801989:	89 c2                	mov    %eax,%edx
  80198b:	85 d2                	test   %edx,%edx
  80198d:	78 61                	js     8019f0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801992:	89 44 24 04          	mov    %eax,0x4(%esp)
  801996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801999:	8b 00                	mov    (%eax),%eax
  80199b:	89 04 24             	mov    %eax,(%esp)
  80199e:	e8 f9 fb ff ff       	call   80159c <dev_lookup>
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 49                	js     8019f0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019ae:	75 23                	jne    8019d3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019b0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019b5:	8b 40 48             	mov    0x48(%eax),%eax
  8019b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c0:	c7 04 24 dc 30 80 00 	movl   $0x8030dc,(%esp)
  8019c7:	e8 3a e9 ff ff       	call   800306 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8019cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d1:	eb 1d                	jmp    8019f0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8019d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d6:	8b 52 18             	mov    0x18(%edx),%edx
  8019d9:	85 d2                	test   %edx,%edx
  8019db:	74 0e                	je     8019eb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019e4:	89 04 24             	mov    %eax,(%esp)
  8019e7:	ff d2                	call   *%edx
  8019e9:	eb 05                	jmp    8019f0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8019eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8019f0:	83 c4 24             	add    $0x24,%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    

008019f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	53                   	push   %ebx
  8019fa:	83 ec 24             	sub    $0x24,%esp
  8019fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	89 04 24             	mov    %eax,(%esp)
  801a0d:	e8 34 fb ff ff       	call   801546 <fd_lookup>
  801a12:	89 c2                	mov    %eax,%edx
  801a14:	85 d2                	test   %edx,%edx
  801a16:	78 52                	js     801a6a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a22:	8b 00                	mov    (%eax),%eax
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	e8 70 fb ff ff       	call   80159c <dev_lookup>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 3a                	js     801a6a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a33:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a37:	74 2c                	je     801a65 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a39:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a3c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a43:	00 00 00 
	stat->st_isdir = 0;
  801a46:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a4d:	00 00 00 
	stat->st_dev = dev;
  801a50:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a5d:	89 14 24             	mov    %edx,(%esp)
  801a60:	ff 50 14             	call   *0x14(%eax)
  801a63:	eb 05                	jmp    801a6a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a65:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a6a:	83 c4 24             	add    $0x24,%esp
  801a6d:	5b                   	pop    %ebx
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    

00801a70 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	56                   	push   %esi
  801a74:	53                   	push   %ebx
  801a75:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a7f:	00 
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	89 04 24             	mov    %eax,(%esp)
  801a86:	e8 28 02 00 00       	call   801cb3 <open>
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	85 db                	test   %ebx,%ebx
  801a8f:	78 1b                	js     801aac <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a98:	89 1c 24             	mov    %ebx,(%esp)
  801a9b:	e8 56 ff ff ff       	call   8019f6 <fstat>
  801aa0:	89 c6                	mov    %eax,%esi
	close(fd);
  801aa2:	89 1c 24             	mov    %ebx,(%esp)
  801aa5:	e8 cd fb ff ff       	call   801677 <close>
	return r;
  801aaa:	89 f0                	mov    %esi,%eax
}
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    

00801ab3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	56                   	push   %esi
  801ab7:	53                   	push   %ebx
  801ab8:	83 ec 10             	sub    $0x10,%esp
  801abb:	89 c6                	mov    %eax,%esi
  801abd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801abf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ac6:	75 11                	jne    801ad9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ac8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801acf:	e8 bd f9 ff ff       	call   801491 <ipc_find_env>
  801ad4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ad9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ae0:	00 
  801ae1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ae8:	00 
  801ae9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aed:	a1 00 50 80 00       	mov    0x805000,%eax
  801af2:	89 04 24             	mov    %eax,(%esp)
  801af5:	e8 39 f9 ff ff       	call   801433 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801afa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b01:	00 
  801b02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b0d:	e8 b7 f8 ff ff       	call   8013c9 <ipc_recv>
}
  801b12:	83 c4 10             	add    $0x10,%esp
  801b15:	5b                   	pop    %ebx
  801b16:	5e                   	pop    %esi
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    

00801b19 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	8b 40 0c             	mov    0xc(%eax),%eax
  801b25:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b32:	ba 00 00 00 00       	mov    $0x0,%edx
  801b37:	b8 02 00 00 00       	mov    $0x2,%eax
  801b3c:	e8 72 ff ff ff       	call   801ab3 <fsipc>
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b54:	ba 00 00 00 00       	mov    $0x0,%edx
  801b59:	b8 06 00 00 00       	mov    $0x6,%eax
  801b5e:	e8 50 ff ff ff       	call   801ab3 <fsipc>
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	53                   	push   %ebx
  801b69:	83 ec 14             	sub    $0x14,%esp
  801b6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	8b 40 0c             	mov    0xc(%eax),%eax
  801b75:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b84:	e8 2a ff ff ff       	call   801ab3 <fsipc>
  801b89:	89 c2                	mov    %eax,%edx
  801b8b:	85 d2                	test   %edx,%edx
  801b8d:	78 2b                	js     801bba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b8f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b96:	00 
  801b97:	89 1c 24             	mov    %ebx,(%esp)
  801b9a:	e8 88 ed ff ff       	call   800927 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b9f:	a1 80 60 80 00       	mov    0x806080,%eax
  801ba4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801baa:	a1 84 60 80 00       	mov    0x806084,%eax
  801baf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bba:	83 c4 14             	add    $0x14,%esp
  801bbd:	5b                   	pop    %ebx
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    

00801bc0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 18             	sub    $0x18,%esp
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801bce:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801bd3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801bd6:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bdb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bde:	8b 52 0c             	mov    0xc(%edx),%edx
  801be1:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801be7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf2:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801bf9:	e8 c6 ee ff ff       	call   800ac4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  801c03:	b8 04 00 00 00       	mov    $0x4,%eax
  801c08:	e8 a6 fe ff ff       	call   801ab3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	56                   	push   %esi
  801c13:	53                   	push   %ebx
  801c14:	83 ec 10             	sub    $0x10,%esp
  801c17:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c20:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c25:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c30:	b8 03 00 00 00       	mov    $0x3,%eax
  801c35:	e8 79 fe ff ff       	call   801ab3 <fsipc>
  801c3a:	89 c3                	mov    %eax,%ebx
  801c3c:	85 c0                	test   %eax,%eax
  801c3e:	78 6a                	js     801caa <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c40:	39 c6                	cmp    %eax,%esi
  801c42:	73 24                	jae    801c68 <devfile_read+0x59>
  801c44:	c7 44 24 0c 4c 31 80 	movl   $0x80314c,0xc(%esp)
  801c4b:	00 
  801c4c:	c7 44 24 08 53 31 80 	movl   $0x803153,0x8(%esp)
  801c53:	00 
  801c54:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c5b:	00 
  801c5c:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  801c63:	e8 1e 0b 00 00       	call   802786 <_panic>
	assert(r <= PGSIZE);
  801c68:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c6d:	7e 24                	jle    801c93 <devfile_read+0x84>
  801c6f:	c7 44 24 0c 73 31 80 	movl   $0x803173,0xc(%esp)
  801c76:	00 
  801c77:	c7 44 24 08 53 31 80 	movl   $0x803153,0x8(%esp)
  801c7e:	00 
  801c7f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c86:	00 
  801c87:	c7 04 24 68 31 80 00 	movl   $0x803168,(%esp)
  801c8e:	e8 f3 0a 00 00       	call   802786 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c93:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c97:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c9e:	00 
  801c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca2:	89 04 24             	mov    %eax,(%esp)
  801ca5:	e8 1a ee ff ff       	call   800ac4 <memmove>
	return r;
}
  801caa:	89 d8                	mov    %ebx,%eax
  801cac:	83 c4 10             	add    $0x10,%esp
  801caf:	5b                   	pop    %ebx
  801cb0:	5e                   	pop    %esi
  801cb1:	5d                   	pop    %ebp
  801cb2:	c3                   	ret    

00801cb3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	53                   	push   %ebx
  801cb7:	83 ec 24             	sub    $0x24,%esp
  801cba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cbd:	89 1c 24             	mov    %ebx,(%esp)
  801cc0:	e8 2b ec ff ff       	call   8008f0 <strlen>
  801cc5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cca:	7f 60                	jg     801d2c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ccf:	89 04 24             	mov    %eax,(%esp)
  801cd2:	e8 20 f8 ff ff       	call   8014f7 <fd_alloc>
  801cd7:	89 c2                	mov    %eax,%edx
  801cd9:	85 d2                	test   %edx,%edx
  801cdb:	78 54                	js     801d31 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801cdd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ce1:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801ce8:	e8 3a ec ff ff       	call   800927 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf0:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfd:	e8 b1 fd ff ff       	call   801ab3 <fsipc>
  801d02:	89 c3                	mov    %eax,%ebx
  801d04:	85 c0                	test   %eax,%eax
  801d06:	79 17                	jns    801d1f <open+0x6c>
		fd_close(fd, 0);
  801d08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d0f:	00 
  801d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d13:	89 04 24             	mov    %eax,(%esp)
  801d16:	e8 db f8 ff ff       	call   8015f6 <fd_close>
		return r;
  801d1b:	89 d8                	mov    %ebx,%eax
  801d1d:	eb 12                	jmp    801d31 <open+0x7e>
	}

	return fd2num(fd);
  801d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d22:	89 04 24             	mov    %eax,(%esp)
  801d25:	e8 a6 f7 ff ff       	call   8014d0 <fd2num>
  801d2a:	eb 05                	jmp    801d31 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d2c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801d31:	83 c4 24             	add    $0x24,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5d                   	pop    %ebp
  801d36:	c3                   	ret    

00801d37 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d42:	b8 08 00 00 00       	mov    $0x8,%eax
  801d47:	e8 67 fd ff ff       	call   801ab3 <fsipc>
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    
  801d4e:	66 90                	xchg   %ax,%ax

00801d50 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d56:	c7 44 24 04 7f 31 80 	movl   $0x80317f,0x4(%esp)
  801d5d:	00 
  801d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d61:	89 04 24             	mov    %eax,(%esp)
  801d64:	e8 be eb ff ff       	call   800927 <strcpy>
	return 0;
}
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	53                   	push   %ebx
  801d74:	83 ec 14             	sub    $0x14,%esp
  801d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d7a:	89 1c 24             	mov    %ebx,(%esp)
  801d7d:	e8 f2 0a 00 00       	call   802874 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d82:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d87:	83 f8 01             	cmp    $0x1,%eax
  801d8a:	75 0d                	jne    801d99 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d8c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d8f:	89 04 24             	mov    %eax,(%esp)
  801d92:	e8 29 03 00 00       	call   8020c0 <nsipc_close>
  801d97:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d99:	89 d0                	mov    %edx,%eax
  801d9b:	83 c4 14             	add    $0x14,%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    

00801da1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801da7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dae:	00 
  801daf:	8b 45 10             	mov    0x10(%ebp),%eax
  801db2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc3:	89 04 24             	mov    %eax,(%esp)
  801dc6:	e8 f0 03 00 00       	call   8021bb <nsipc_send>
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
  801dd0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801dd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dda:	00 
  801ddb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dde:	89 44 24 08          	mov    %eax,0x8(%esp)
  801de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	8b 40 0c             	mov    0xc(%eax),%eax
  801def:	89 04 24             	mov    %eax,(%esp)
  801df2:	e8 44 03 00 00       	call   80213b <nsipc_recv>
}
  801df7:	c9                   	leave  
  801df8:	c3                   	ret    

00801df9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e02:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e06:	89 04 24             	mov    %eax,(%esp)
  801e09:	e8 38 f7 ff ff       	call   801546 <fd_lookup>
  801e0e:	85 c0                	test   %eax,%eax
  801e10:	78 17                	js     801e29 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e15:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  801e1b:	39 08                	cmp    %ecx,(%eax)
  801e1d:	75 05                	jne    801e24 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e22:	eb 05                	jmp    801e29 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801e24:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	56                   	push   %esi
  801e2f:	53                   	push   %ebx
  801e30:	83 ec 20             	sub    $0x20,%esp
  801e33:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e38:	89 04 24             	mov    %eax,(%esp)
  801e3b:	e8 b7 f6 ff ff       	call   8014f7 <fd_alloc>
  801e40:	89 c3                	mov    %eax,%ebx
  801e42:	85 c0                	test   %eax,%eax
  801e44:	78 21                	js     801e67 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e4d:	00 
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e5c:	e8 e2 ee ff ff       	call   800d43 <sys_page_alloc>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	85 c0                	test   %eax,%eax
  801e65:	79 0c                	jns    801e73 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e67:	89 34 24             	mov    %esi,(%esp)
  801e6a:	e8 51 02 00 00       	call   8020c0 <nsipc_close>
		return r;
  801e6f:	89 d8                	mov    %ebx,%eax
  801e71:	eb 20                	jmp    801e93 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e73:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e81:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e88:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e8b:	89 14 24             	mov    %edx,(%esp)
  801e8e:	e8 3d f6 ff ff       	call   8014d0 <fd2num>
}
  801e93:	83 c4 20             	add    $0x20,%esp
  801e96:	5b                   	pop    %ebx
  801e97:	5e                   	pop    %esi
  801e98:	5d                   	pop    %ebp
  801e99:	c3                   	ret    

00801e9a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	e8 51 ff ff ff       	call   801df9 <fd2sockid>
		return r;
  801ea8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	78 23                	js     801ed1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801eae:	8b 55 10             	mov    0x10(%ebp),%edx
  801eb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ebc:	89 04 24             	mov    %eax,(%esp)
  801ebf:	e8 45 01 00 00       	call   802009 <nsipc_accept>
		return r;
  801ec4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	78 07                	js     801ed1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801eca:	e8 5c ff ff ff       	call   801e2b <alloc_sockfd>
  801ecf:	89 c1                	mov    %eax,%ecx
}
  801ed1:	89 c8                	mov    %ecx,%eax
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	e8 16 ff ff ff       	call   801df9 <fd2sockid>
  801ee3:	89 c2                	mov    %eax,%edx
  801ee5:	85 d2                	test   %edx,%edx
  801ee7:	78 16                	js     801eff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  801eec:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef7:	89 14 24             	mov    %edx,(%esp)
  801efa:	e8 60 01 00 00       	call   80205f <nsipc_bind>
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <shutdown>:

int
shutdown(int s, int how)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	e8 ea fe ff ff       	call   801df9 <fd2sockid>
  801f0f:	89 c2                	mov    %eax,%edx
  801f11:	85 d2                	test   %edx,%edx
  801f13:	78 0f                	js     801f24 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1c:	89 14 24             	mov    %edx,(%esp)
  801f1f:	e8 7a 01 00 00       	call   80209e <nsipc_shutdown>
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	e8 c5 fe ff ff       	call   801df9 <fd2sockid>
  801f34:	89 c2                	mov    %eax,%edx
  801f36:	85 d2                	test   %edx,%edx
  801f38:	78 16                	js     801f50 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f48:	89 14 24             	mov    %edx,(%esp)
  801f4b:	e8 8a 01 00 00       	call   8020da <nsipc_connect>
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <listen>:

int
listen(int s, int backlog)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f58:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5b:	e8 99 fe ff ff       	call   801df9 <fd2sockid>
  801f60:	89 c2                	mov    %eax,%edx
  801f62:	85 d2                	test   %edx,%edx
  801f64:	78 0f                	js     801f75 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6d:	89 14 24             	mov    %edx,(%esp)
  801f70:	e8 a4 01 00 00       	call   802119 <nsipc_listen>
}
  801f75:	c9                   	leave  
  801f76:	c3                   	ret    

00801f77 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f77:	55                   	push   %ebp
  801f78:	89 e5                	mov    %esp,%ebp
  801f7a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f80:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8e:	89 04 24             	mov    %eax,(%esp)
  801f91:	e8 98 02 00 00       	call   80222e <nsipc_socket>
  801f96:	89 c2                	mov    %eax,%edx
  801f98:	85 d2                	test   %edx,%edx
  801f9a:	78 05                	js     801fa1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f9c:	e8 8a fe ff ff       	call   801e2b <alloc_sockfd>
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
  801fa6:	53                   	push   %ebx
  801fa7:	83 ec 14             	sub    $0x14,%esp
  801faa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fac:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fb3:	75 11                	jne    801fc6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fb5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801fbc:	e8 d0 f4 ff ff       	call   801491 <ipc_find_env>
  801fc1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fc6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801fcd:	00 
  801fce:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801fd5:	00 
  801fd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fda:	a1 04 50 80 00       	mov    0x805004,%eax
  801fdf:	89 04 24             	mov    %eax,(%esp)
  801fe2:	e8 4c f4 ff ff       	call   801433 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801fe7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fee:	00 
  801fef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ff6:	00 
  801ff7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ffe:	e8 c6 f3 ff ff       	call   8013c9 <ipc_recv>
}
  802003:	83 c4 14             	add    $0x14,%esp
  802006:	5b                   	pop    %ebx
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    

00802009 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	56                   	push   %esi
  80200d:	53                   	push   %ebx
  80200e:	83 ec 10             	sub    $0x10,%esp
  802011:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80201c:	8b 06                	mov    (%esi),%eax
  80201e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802023:	b8 01 00 00 00       	mov    $0x1,%eax
  802028:	e8 76 ff ff ff       	call   801fa3 <nsipc>
  80202d:	89 c3                	mov    %eax,%ebx
  80202f:	85 c0                	test   %eax,%eax
  802031:	78 23                	js     802056 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802033:	a1 10 70 80 00       	mov    0x807010,%eax
  802038:	89 44 24 08          	mov    %eax,0x8(%esp)
  80203c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802043:	00 
  802044:	8b 45 0c             	mov    0xc(%ebp),%eax
  802047:	89 04 24             	mov    %eax,(%esp)
  80204a:	e8 75 ea ff ff       	call   800ac4 <memmove>
		*addrlen = ret->ret_addrlen;
  80204f:	a1 10 70 80 00       	mov    0x807010,%eax
  802054:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802056:	89 d8                	mov    %ebx,%eax
  802058:	83 c4 10             	add    $0x10,%esp
  80205b:	5b                   	pop    %ebx
  80205c:	5e                   	pop    %esi
  80205d:	5d                   	pop    %ebp
  80205e:	c3                   	ret    

0080205f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	53                   	push   %ebx
  802063:	83 ec 14             	sub    $0x14,%esp
  802066:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802071:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802075:	8b 45 0c             	mov    0xc(%ebp),%eax
  802078:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802083:	e8 3c ea ff ff       	call   800ac4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802088:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80208e:	b8 02 00 00 00       	mov    $0x2,%eax
  802093:	e8 0b ff ff ff       	call   801fa3 <nsipc>
}
  802098:	83 c4 14             	add    $0x14,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5d                   	pop    %ebp
  80209d:	c3                   	ret    

0080209e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020af:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020b9:	e8 e5 fe ff ff       	call   801fa3 <nsipc>
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020ce:	b8 04 00 00 00       	mov    $0x4,%eax
  8020d3:	e8 cb fe ff ff       	call   801fa3 <nsipc>
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	53                   	push   %ebx
  8020de:	83 ec 14             	sub    $0x14,%esp
  8020e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020fe:	e8 c1 e9 ff ff       	call   800ac4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802103:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802109:	b8 05 00 00 00       	mov    $0x5,%eax
  80210e:	e8 90 fe ff ff       	call   801fa3 <nsipc>
}
  802113:	83 c4 14             	add    $0x14,%esp
  802116:	5b                   	pop    %ebx
  802117:	5d                   	pop    %ebp
  802118:	c3                   	ret    

00802119 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80212f:	b8 06 00 00 00       	mov    $0x6,%eax
  802134:	e8 6a fe ff ff       	call   801fa3 <nsipc>
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	56                   	push   %esi
  80213f:	53                   	push   %ebx
  802140:	83 ec 10             	sub    $0x10,%esp
  802143:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80214e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802154:	8b 45 14             	mov    0x14(%ebp),%eax
  802157:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80215c:	b8 07 00 00 00       	mov    $0x7,%eax
  802161:	e8 3d fe ff ff       	call   801fa3 <nsipc>
  802166:	89 c3                	mov    %eax,%ebx
  802168:	85 c0                	test   %eax,%eax
  80216a:	78 46                	js     8021b2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80216c:	39 f0                	cmp    %esi,%eax
  80216e:	7f 07                	jg     802177 <nsipc_recv+0x3c>
  802170:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802175:	7e 24                	jle    80219b <nsipc_recv+0x60>
  802177:	c7 44 24 0c 8b 31 80 	movl   $0x80318b,0xc(%esp)
  80217e:	00 
  80217f:	c7 44 24 08 53 31 80 	movl   $0x803153,0x8(%esp)
  802186:	00 
  802187:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80218e:	00 
  80218f:	c7 04 24 a0 31 80 00 	movl   $0x8031a0,(%esp)
  802196:	e8 eb 05 00 00       	call   802786 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80219b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80219f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021a6:	00 
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	89 04 24             	mov    %eax,(%esp)
  8021ad:	e8 12 e9 ff ff       	call   800ac4 <memmove>
	}

	return r;
}
  8021b2:	89 d8                	mov    %ebx,%eax
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5d                   	pop    %ebp
  8021ba:	c3                   	ret    

008021bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	53                   	push   %ebx
  8021bf:	83 ec 14             	sub    $0x14,%esp
  8021c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021d3:	7e 24                	jle    8021f9 <nsipc_send+0x3e>
  8021d5:	c7 44 24 0c ac 31 80 	movl   $0x8031ac,0xc(%esp)
  8021dc:	00 
  8021dd:	c7 44 24 08 53 31 80 	movl   $0x803153,0x8(%esp)
  8021e4:	00 
  8021e5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8021ec:	00 
  8021ed:	c7 04 24 a0 31 80 00 	movl   $0x8031a0,(%esp)
  8021f4:	e8 8d 05 00 00       	call   802786 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802200:	89 44 24 04          	mov    %eax,0x4(%esp)
  802204:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80220b:	e8 b4 e8 ff ff       	call   800ac4 <memmove>
	nsipcbuf.send.req_size = size;
  802210:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802216:	8b 45 14             	mov    0x14(%ebp),%eax
  802219:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80221e:	b8 08 00 00 00       	mov    $0x8,%eax
  802223:	e8 7b fd ff ff       	call   801fa3 <nsipc>
}
  802228:	83 c4 14             	add    $0x14,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    

0080222e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80223c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802244:	8b 45 10             	mov    0x10(%ebp),%eax
  802247:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80224c:	b8 09 00 00 00       	mov    $0x9,%eax
  802251:	e8 4d fd ff ff       	call   801fa3 <nsipc>
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
  80225b:	56                   	push   %esi
  80225c:	53                   	push   %ebx
  80225d:	83 ec 10             	sub    $0x10,%esp
  802260:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	89 04 24             	mov    %eax,(%esp)
  802269:	e8 72 f2 ff ff       	call   8014e0 <fd2data>
  80226e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802270:	c7 44 24 04 b8 31 80 	movl   $0x8031b8,0x4(%esp)
  802277:	00 
  802278:	89 1c 24             	mov    %ebx,(%esp)
  80227b:	e8 a7 e6 ff ff       	call   800927 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802280:	8b 46 04             	mov    0x4(%esi),%eax
  802283:	2b 06                	sub    (%esi),%eax
  802285:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80228b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802292:	00 00 00 
	stat->st_dev = &devpipe;
  802295:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  80229c:	40 80 00 
	return 0;
}
  80229f:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a4:	83 c4 10             	add    $0x10,%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5d                   	pop    %ebp
  8022aa:	c3                   	ret    

008022ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	53                   	push   %ebx
  8022af:	83 ec 14             	sub    $0x14,%esp
  8022b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c0:	e8 25 eb ff ff       	call   800dea <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022c5:	89 1c 24             	mov    %ebx,(%esp)
  8022c8:	e8 13 f2 ff ff       	call   8014e0 <fd2data>
  8022cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d8:	e8 0d eb ff ff       	call   800dea <sys_page_unmap>
}
  8022dd:	83 c4 14             	add    $0x14,%esp
  8022e0:	5b                   	pop    %ebx
  8022e1:	5d                   	pop    %ebp
  8022e2:	c3                   	ret    

008022e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
  8022e6:	57                   	push   %edi
  8022e7:	56                   	push   %esi
  8022e8:	53                   	push   %ebx
  8022e9:	83 ec 2c             	sub    $0x2c,%esp
  8022ec:	89 c6                	mov    %eax,%esi
  8022ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8022f1:	a1 08 50 80 00       	mov    0x805008,%eax
  8022f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022f9:	89 34 24             	mov    %esi,(%esp)
  8022fc:	e8 73 05 00 00       	call   802874 <pageref>
  802301:	89 c7                	mov    %eax,%edi
  802303:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802306:	89 04 24             	mov    %eax,(%esp)
  802309:	e8 66 05 00 00       	call   802874 <pageref>
  80230e:	39 c7                	cmp    %eax,%edi
  802310:	0f 94 c2             	sete   %dl
  802313:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802316:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80231c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80231f:	39 fb                	cmp    %edi,%ebx
  802321:	74 21                	je     802344 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802323:	84 d2                	test   %dl,%dl
  802325:	74 ca                	je     8022f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802327:	8b 51 58             	mov    0x58(%ecx),%edx
  80232a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80232e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802332:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802336:	c7 04 24 bf 31 80 00 	movl   $0x8031bf,(%esp)
  80233d:	e8 c4 df ff ff       	call   800306 <cprintf>
  802342:	eb ad                	jmp    8022f1 <_pipeisclosed+0xe>
	}
}
  802344:	83 c4 2c             	add    $0x2c,%esp
  802347:	5b                   	pop    %ebx
  802348:	5e                   	pop    %esi
  802349:	5f                   	pop    %edi
  80234a:	5d                   	pop    %ebp
  80234b:	c3                   	ret    

0080234c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
  80234f:	57                   	push   %edi
  802350:	56                   	push   %esi
  802351:	53                   	push   %ebx
  802352:	83 ec 1c             	sub    $0x1c,%esp
  802355:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802358:	89 34 24             	mov    %esi,(%esp)
  80235b:	e8 80 f1 ff ff       	call   8014e0 <fd2data>
  802360:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802362:	bf 00 00 00 00       	mov    $0x0,%edi
  802367:	eb 45                	jmp    8023ae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802369:	89 da                	mov    %ebx,%edx
  80236b:	89 f0                	mov    %esi,%eax
  80236d:	e8 71 ff ff ff       	call   8022e3 <_pipeisclosed>
  802372:	85 c0                	test   %eax,%eax
  802374:	75 41                	jne    8023b7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802376:	e8 a9 e9 ff ff       	call   800d24 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80237b:	8b 43 04             	mov    0x4(%ebx),%eax
  80237e:	8b 0b                	mov    (%ebx),%ecx
  802380:	8d 51 20             	lea    0x20(%ecx),%edx
  802383:	39 d0                	cmp    %edx,%eax
  802385:	73 e2                	jae    802369 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80238a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80238e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802391:	99                   	cltd   
  802392:	c1 ea 1b             	shr    $0x1b,%edx
  802395:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802398:	83 e1 1f             	and    $0x1f,%ecx
  80239b:	29 d1                	sub    %edx,%ecx
  80239d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8023a1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8023a5:	83 c0 01             	add    $0x1,%eax
  8023a8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023ab:	83 c7 01             	add    $0x1,%edi
  8023ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023b1:	75 c8                	jne    80237b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023b3:	89 f8                	mov    %edi,%eax
  8023b5:	eb 05                	jmp    8023bc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8023bc:	83 c4 1c             	add    $0x1c,%esp
  8023bf:	5b                   	pop    %ebx
  8023c0:	5e                   	pop    %esi
  8023c1:	5f                   	pop    %edi
  8023c2:	5d                   	pop    %ebp
  8023c3:	c3                   	ret    

008023c4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	57                   	push   %edi
  8023c8:	56                   	push   %esi
  8023c9:	53                   	push   %ebx
  8023ca:	83 ec 1c             	sub    $0x1c,%esp
  8023cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023d0:	89 3c 24             	mov    %edi,(%esp)
  8023d3:	e8 08 f1 ff ff       	call   8014e0 <fd2data>
  8023d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023da:	be 00 00 00 00       	mov    $0x0,%esi
  8023df:	eb 3d                	jmp    80241e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8023e1:	85 f6                	test   %esi,%esi
  8023e3:	74 04                	je     8023e9 <devpipe_read+0x25>
				return i;
  8023e5:	89 f0                	mov    %esi,%eax
  8023e7:	eb 43                	jmp    80242c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8023e9:	89 da                	mov    %ebx,%edx
  8023eb:	89 f8                	mov    %edi,%eax
  8023ed:	e8 f1 fe ff ff       	call   8022e3 <_pipeisclosed>
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	75 31                	jne    802427 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8023f6:	e8 29 e9 ff ff       	call   800d24 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8023fb:	8b 03                	mov    (%ebx),%eax
  8023fd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802400:	74 df                	je     8023e1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802402:	99                   	cltd   
  802403:	c1 ea 1b             	shr    $0x1b,%edx
  802406:	01 d0                	add    %edx,%eax
  802408:	83 e0 1f             	and    $0x1f,%eax
  80240b:	29 d0                	sub    %edx,%eax
  80240d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802412:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802415:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802418:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80241b:	83 c6 01             	add    $0x1,%esi
  80241e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802421:	75 d8                	jne    8023fb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802423:	89 f0                	mov    %esi,%eax
  802425:	eb 05                	jmp    80242c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802427:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80242c:	83 c4 1c             	add    $0x1c,%esp
  80242f:	5b                   	pop    %ebx
  802430:	5e                   	pop    %esi
  802431:	5f                   	pop    %edi
  802432:	5d                   	pop    %ebp
  802433:	c3                   	ret    

00802434 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
  802437:	56                   	push   %esi
  802438:	53                   	push   %ebx
  802439:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80243c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80243f:	89 04 24             	mov    %eax,(%esp)
  802442:	e8 b0 f0 ff ff       	call   8014f7 <fd_alloc>
  802447:	89 c2                	mov    %eax,%edx
  802449:	85 d2                	test   %edx,%edx
  80244b:	0f 88 4d 01 00 00    	js     80259e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802451:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802458:	00 
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802460:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802467:	e8 d7 e8 ff ff       	call   800d43 <sys_page_alloc>
  80246c:	89 c2                	mov    %eax,%edx
  80246e:	85 d2                	test   %edx,%edx
  802470:	0f 88 28 01 00 00    	js     80259e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802476:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802479:	89 04 24             	mov    %eax,(%esp)
  80247c:	e8 76 f0 ff ff       	call   8014f7 <fd_alloc>
  802481:	89 c3                	mov    %eax,%ebx
  802483:	85 c0                	test   %eax,%eax
  802485:	0f 88 fe 00 00 00    	js     802589 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802492:	00 
  802493:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80249a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a1:	e8 9d e8 ff ff       	call   800d43 <sys_page_alloc>
  8024a6:	89 c3                	mov    %eax,%ebx
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	0f 88 d9 00 00 00    	js     802589 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	89 04 24             	mov    %eax,(%esp)
  8024b6:	e8 25 f0 ff ff       	call   8014e0 <fd2data>
  8024bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024c4:	00 
  8024c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d0:	e8 6e e8 ff ff       	call   800d43 <sys_page_alloc>
  8024d5:	89 c3                	mov    %eax,%ebx
  8024d7:	85 c0                	test   %eax,%eax
  8024d9:	0f 88 97 00 00 00    	js     802576 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	89 04 24             	mov    %eax,(%esp)
  8024e5:	e8 f6 ef ff ff       	call   8014e0 <fd2data>
  8024ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024f1:	00 
  8024f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024fd:	00 
  8024fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802502:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802509:	e8 89 e8 ff ff       	call   800d97 <sys_page_map>
  80250e:	89 c3                	mov    %eax,%ebx
  802510:	85 c0                	test   %eax,%eax
  802512:	78 52                	js     802566 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802514:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802529:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80252f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802532:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802537:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	89 04 24             	mov    %eax,(%esp)
  802544:	e8 87 ef ff ff       	call   8014d0 <fd2num>
  802549:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80254c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80254e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802551:	89 04 24             	mov    %eax,(%esp)
  802554:	e8 77 ef ff ff       	call   8014d0 <fd2num>
  802559:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80255c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80255f:	b8 00 00 00 00       	mov    $0x0,%eax
  802564:	eb 38                	jmp    80259e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802566:	89 74 24 04          	mov    %esi,0x4(%esp)
  80256a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802571:	e8 74 e8 ff ff       	call   800dea <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80257d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802584:	e8 61 e8 ff ff       	call   800dea <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802590:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802597:	e8 4e e8 ff ff       	call   800dea <sys_page_unmap>
  80259c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80259e:	83 c4 30             	add    $0x30,%esp
  8025a1:	5b                   	pop    %ebx
  8025a2:	5e                   	pop    %esi
  8025a3:	5d                   	pop    %ebp
  8025a4:	c3                   	ret    

008025a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	89 04 24             	mov    %eax,(%esp)
  8025b8:	e8 89 ef ff ff       	call   801546 <fd_lookup>
  8025bd:	89 c2                	mov    %eax,%edx
  8025bf:	85 d2                	test   %edx,%edx
  8025c1:	78 15                	js     8025d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	89 04 24             	mov    %eax,(%esp)
  8025c9:	e8 12 ef ff ff       	call   8014e0 <fd2data>
	return _pipeisclosed(fd, p);
  8025ce:	89 c2                	mov    %eax,%edx
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	e8 0b fd ff ff       	call   8022e3 <_pipeisclosed>
}
  8025d8:	c9                   	leave  
  8025d9:	c3                   	ret    
  8025da:	66 90                	xchg   %ax,%ax
  8025dc:	66 90                	xchg   %ax,%ax
  8025de:	66 90                	xchg   %ax,%ax

008025e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e8:	5d                   	pop    %ebp
  8025e9:	c3                   	ret    

008025ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8025f0:	c7 44 24 04 d7 31 80 	movl   $0x8031d7,0x4(%esp)
  8025f7:	00 
  8025f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025fb:	89 04 24             	mov    %eax,(%esp)
  8025fe:	e8 24 e3 ff ff       	call   800927 <strcpy>
	return 0;
}
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	57                   	push   %edi
  80260e:	56                   	push   %esi
  80260f:	53                   	push   %ebx
  802610:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802616:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80261b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802621:	eb 31                	jmp    802654 <devcons_write+0x4a>
		m = n - tot;
  802623:	8b 75 10             	mov    0x10(%ebp),%esi
  802626:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802628:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80262b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802630:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802633:	89 74 24 08          	mov    %esi,0x8(%esp)
  802637:	03 45 0c             	add    0xc(%ebp),%eax
  80263a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263e:	89 3c 24             	mov    %edi,(%esp)
  802641:	e8 7e e4 ff ff       	call   800ac4 <memmove>
		sys_cputs(buf, m);
  802646:	89 74 24 04          	mov    %esi,0x4(%esp)
  80264a:	89 3c 24             	mov    %edi,(%esp)
  80264d:	e8 24 e6 ff ff       	call   800c76 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802652:	01 f3                	add    %esi,%ebx
  802654:	89 d8                	mov    %ebx,%eax
  802656:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802659:	72 c8                	jb     802623 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80265b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5f                   	pop    %edi
  802664:	5d                   	pop    %ebp
  802665:	c3                   	ret    

00802666 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802671:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802675:	75 07                	jne    80267e <devcons_read+0x18>
  802677:	eb 2a                	jmp    8026a3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802679:	e8 a6 e6 ff ff       	call   800d24 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80267e:	66 90                	xchg   %ax,%ax
  802680:	e8 0f e6 ff ff       	call   800c94 <sys_cgetc>
  802685:	85 c0                	test   %eax,%eax
  802687:	74 f0                	je     802679 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802689:	85 c0                	test   %eax,%eax
  80268b:	78 16                	js     8026a3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80268d:	83 f8 04             	cmp    $0x4,%eax
  802690:	74 0c                	je     80269e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802692:	8b 55 0c             	mov    0xc(%ebp),%edx
  802695:	88 02                	mov    %al,(%edx)
	return 1;
  802697:	b8 01 00 00 00       	mov    $0x1,%eax
  80269c:	eb 05                	jmp    8026a3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80269e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
  8026a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8026b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8026b8:	00 
  8026b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026bc:	89 04 24             	mov    %eax,(%esp)
  8026bf:	e8 b2 e5 ff ff       	call   800c76 <sys_cputs>
}
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    

008026c6 <getchar>:

int
getchar(void)
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026d3:	00 
  8026d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e2:	e8 f3 f0 ff ff       	call   8017da <read>
	if (r < 0)
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	78 0f                	js     8026fa <getchar+0x34>
		return r;
	if (r < 1)
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	7e 06                	jle    8026f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8026ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8026f3:	eb 05                	jmp    8026fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8026f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8026fa:	c9                   	leave  
  8026fb:	c3                   	ret    

008026fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802702:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802705:	89 44 24 04          	mov    %eax,0x4(%esp)
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	89 04 24             	mov    %eax,(%esp)
  80270f:	e8 32 ee ff ff       	call   801546 <fd_lookup>
  802714:	85 c0                	test   %eax,%eax
  802716:	78 11                	js     802729 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802721:	39 10                	cmp    %edx,(%eax)
  802723:	0f 94 c0             	sete   %al
  802726:	0f b6 c0             	movzbl %al,%eax
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <opencons>:

int
opencons(void)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
  80272e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802731:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802734:	89 04 24             	mov    %eax,(%esp)
  802737:	e8 bb ed ff ff       	call   8014f7 <fd_alloc>
		return r;
  80273c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80273e:	85 c0                	test   %eax,%eax
  802740:	78 40                	js     802782 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802742:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802749:	00 
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802751:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802758:	e8 e6 e5 ff ff       	call   800d43 <sys_page_alloc>
		return r;
  80275d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80275f:	85 c0                	test   %eax,%eax
  802761:	78 1f                	js     802782 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802763:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802778:	89 04 24             	mov    %eax,(%esp)
  80277b:	e8 50 ed ff ff       	call   8014d0 <fd2num>
  802780:	89 c2                	mov    %eax,%edx
}
  802782:	89 d0                	mov    %edx,%eax
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	56                   	push   %esi
  80278a:	53                   	push   %ebx
  80278b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80278e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802791:	8b 35 08 40 80 00    	mov    0x804008,%esi
  802797:	e8 69 e5 ff ff       	call   800d05 <sys_getenvid>
  80279c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80279f:	89 54 24 10          	mov    %edx,0x10(%esp)
  8027a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8027aa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b2:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  8027b9:	e8 48 db ff ff       	call   800306 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8027be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c5:	89 04 24             	mov    %eax,(%esp)
  8027c8:	e8 d8 da ff ff       	call   8002a5 <vcprintf>
	cprintf("\n");
  8027cd:	c7 04 24 d0 31 80 00 	movl   $0x8031d0,(%esp)
  8027d4:	e8 2d db ff ff       	call   800306 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8027d9:	cc                   	int3   
  8027da:	eb fd                	jmp    8027d9 <_panic+0x53>

008027dc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027e2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027e9:	75 58                	jne    802843 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  8027eb:	a1 08 50 80 00       	mov    0x805008,%eax
  8027f0:	8b 40 48             	mov    0x48(%eax),%eax
  8027f3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8027fa:	00 
  8027fb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802802:	ee 
  802803:	89 04 24             	mov    %eax,(%esp)
  802806:	e8 38 e5 ff ff       	call   800d43 <sys_page_alloc>
		if(return_code!=0)
  80280b:	85 c0                	test   %eax,%eax
  80280d:	74 1c                	je     80282b <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  80280f:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  802816:	00 
  802817:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80281e:	00 
  80281f:	c7 04 24 64 32 80 00 	movl   $0x803264,(%esp)
  802826:	e8 5b ff ff ff       	call   802786 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  80282b:	a1 08 50 80 00       	mov    0x805008,%eax
  802830:	8b 40 48             	mov    0x48(%eax),%eax
  802833:	c7 44 24 04 4d 28 80 	movl   $0x80284d,0x4(%esp)
  80283a:	00 
  80283b:	89 04 24             	mov    %eax,(%esp)
  80283e:	e8 a0 e6 ff ff       	call   800ee3 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80284b:	c9                   	leave  
  80284c:	c3                   	ret    

0080284d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80284d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80284e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802853:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802855:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802858:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  80285a:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  80285e:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  802862:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  802863:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  802865:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802867:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  80286b:	58                   	pop    %eax
	popl %eax;
  80286c:	58                   	pop    %eax
	popal;
  80286d:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  80286e:	83 c4 04             	add    $0x4,%esp
	popfl;
  802871:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802872:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  802873:	c3                   	ret    

00802874 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802874:	55                   	push   %ebp
  802875:	89 e5                	mov    %esp,%ebp
  802877:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80287a:	89 d0                	mov    %edx,%eax
  80287c:	c1 e8 16             	shr    $0x16,%eax
  80287f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802886:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80288b:	f6 c1 01             	test   $0x1,%cl
  80288e:	74 1d                	je     8028ad <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802890:	c1 ea 0c             	shr    $0xc,%edx
  802893:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80289a:	f6 c2 01             	test   $0x1,%dl
  80289d:	74 0e                	je     8028ad <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80289f:	c1 ea 0c             	shr    $0xc,%edx
  8028a2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028a9:	ef 
  8028aa:	0f b7 c0             	movzwl %ax,%eax
}
  8028ad:	5d                   	pop    %ebp
  8028ae:	c3                   	ret    
  8028af:	90                   	nop

008028b0 <__udivdi3>:
  8028b0:	55                   	push   %ebp
  8028b1:	57                   	push   %edi
  8028b2:	56                   	push   %esi
  8028b3:	83 ec 0c             	sub    $0xc,%esp
  8028b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8028be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8028c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8028cc:	89 ea                	mov    %ebp,%edx
  8028ce:	89 0c 24             	mov    %ecx,(%esp)
  8028d1:	75 2d                	jne    802900 <__udivdi3+0x50>
  8028d3:	39 e9                	cmp    %ebp,%ecx
  8028d5:	77 61                	ja     802938 <__udivdi3+0x88>
  8028d7:	85 c9                	test   %ecx,%ecx
  8028d9:	89 ce                	mov    %ecx,%esi
  8028db:	75 0b                	jne    8028e8 <__udivdi3+0x38>
  8028dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e2:	31 d2                	xor    %edx,%edx
  8028e4:	f7 f1                	div    %ecx
  8028e6:	89 c6                	mov    %eax,%esi
  8028e8:	31 d2                	xor    %edx,%edx
  8028ea:	89 e8                	mov    %ebp,%eax
  8028ec:	f7 f6                	div    %esi
  8028ee:	89 c5                	mov    %eax,%ebp
  8028f0:	89 f8                	mov    %edi,%eax
  8028f2:	f7 f6                	div    %esi
  8028f4:	89 ea                	mov    %ebp,%edx
  8028f6:	83 c4 0c             	add    $0xc,%esp
  8028f9:	5e                   	pop    %esi
  8028fa:	5f                   	pop    %edi
  8028fb:	5d                   	pop    %ebp
  8028fc:	c3                   	ret    
  8028fd:	8d 76 00             	lea    0x0(%esi),%esi
  802900:	39 e8                	cmp    %ebp,%eax
  802902:	77 24                	ja     802928 <__udivdi3+0x78>
  802904:	0f bd e8             	bsr    %eax,%ebp
  802907:	83 f5 1f             	xor    $0x1f,%ebp
  80290a:	75 3c                	jne    802948 <__udivdi3+0x98>
  80290c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802910:	39 34 24             	cmp    %esi,(%esp)
  802913:	0f 86 9f 00 00 00    	jbe    8029b8 <__udivdi3+0x108>
  802919:	39 d0                	cmp    %edx,%eax
  80291b:	0f 82 97 00 00 00    	jb     8029b8 <__udivdi3+0x108>
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	31 d2                	xor    %edx,%edx
  80292a:	31 c0                	xor    %eax,%eax
  80292c:	83 c4 0c             	add    $0xc,%esp
  80292f:	5e                   	pop    %esi
  802930:	5f                   	pop    %edi
  802931:	5d                   	pop    %ebp
  802932:	c3                   	ret    
  802933:	90                   	nop
  802934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802938:	89 f8                	mov    %edi,%eax
  80293a:	f7 f1                	div    %ecx
  80293c:	31 d2                	xor    %edx,%edx
  80293e:	83 c4 0c             	add    $0xc,%esp
  802941:	5e                   	pop    %esi
  802942:	5f                   	pop    %edi
  802943:	5d                   	pop    %ebp
  802944:	c3                   	ret    
  802945:	8d 76 00             	lea    0x0(%esi),%esi
  802948:	89 e9                	mov    %ebp,%ecx
  80294a:	8b 3c 24             	mov    (%esp),%edi
  80294d:	d3 e0                	shl    %cl,%eax
  80294f:	89 c6                	mov    %eax,%esi
  802951:	b8 20 00 00 00       	mov    $0x20,%eax
  802956:	29 e8                	sub    %ebp,%eax
  802958:	89 c1                	mov    %eax,%ecx
  80295a:	d3 ef                	shr    %cl,%edi
  80295c:	89 e9                	mov    %ebp,%ecx
  80295e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802962:	8b 3c 24             	mov    (%esp),%edi
  802965:	09 74 24 08          	or     %esi,0x8(%esp)
  802969:	89 d6                	mov    %edx,%esi
  80296b:	d3 e7                	shl    %cl,%edi
  80296d:	89 c1                	mov    %eax,%ecx
  80296f:	89 3c 24             	mov    %edi,(%esp)
  802972:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802976:	d3 ee                	shr    %cl,%esi
  802978:	89 e9                	mov    %ebp,%ecx
  80297a:	d3 e2                	shl    %cl,%edx
  80297c:	89 c1                	mov    %eax,%ecx
  80297e:	d3 ef                	shr    %cl,%edi
  802980:	09 d7                	or     %edx,%edi
  802982:	89 f2                	mov    %esi,%edx
  802984:	89 f8                	mov    %edi,%eax
  802986:	f7 74 24 08          	divl   0x8(%esp)
  80298a:	89 d6                	mov    %edx,%esi
  80298c:	89 c7                	mov    %eax,%edi
  80298e:	f7 24 24             	mull   (%esp)
  802991:	39 d6                	cmp    %edx,%esi
  802993:	89 14 24             	mov    %edx,(%esp)
  802996:	72 30                	jb     8029c8 <__udivdi3+0x118>
  802998:	8b 54 24 04          	mov    0x4(%esp),%edx
  80299c:	89 e9                	mov    %ebp,%ecx
  80299e:	d3 e2                	shl    %cl,%edx
  8029a0:	39 c2                	cmp    %eax,%edx
  8029a2:	73 05                	jae    8029a9 <__udivdi3+0xf9>
  8029a4:	3b 34 24             	cmp    (%esp),%esi
  8029a7:	74 1f                	je     8029c8 <__udivdi3+0x118>
  8029a9:	89 f8                	mov    %edi,%eax
  8029ab:	31 d2                	xor    %edx,%edx
  8029ad:	e9 7a ff ff ff       	jmp    80292c <__udivdi3+0x7c>
  8029b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029b8:	31 d2                	xor    %edx,%edx
  8029ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bf:	e9 68 ff ff ff       	jmp    80292c <__udivdi3+0x7c>
  8029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8029cb:	31 d2                	xor    %edx,%edx
  8029cd:	83 c4 0c             	add    $0xc,%esp
  8029d0:	5e                   	pop    %esi
  8029d1:	5f                   	pop    %edi
  8029d2:	5d                   	pop    %ebp
  8029d3:	c3                   	ret    
  8029d4:	66 90                	xchg   %ax,%ax
  8029d6:	66 90                	xchg   %ax,%ax
  8029d8:	66 90                	xchg   %ax,%ax
  8029da:	66 90                	xchg   %ax,%ax
  8029dc:	66 90                	xchg   %ax,%ax
  8029de:	66 90                	xchg   %ax,%ax

008029e0 <__umoddi3>:
  8029e0:	55                   	push   %ebp
  8029e1:	57                   	push   %edi
  8029e2:	56                   	push   %esi
  8029e3:	83 ec 14             	sub    $0x14,%esp
  8029e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8029ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8029f2:	89 c7                	mov    %eax,%edi
  8029f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8029fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a00:	89 34 24             	mov    %esi,(%esp)
  802a03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a07:	85 c0                	test   %eax,%eax
  802a09:	89 c2                	mov    %eax,%edx
  802a0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a0f:	75 17                	jne    802a28 <__umoddi3+0x48>
  802a11:	39 fe                	cmp    %edi,%esi
  802a13:	76 4b                	jbe    802a60 <__umoddi3+0x80>
  802a15:	89 c8                	mov    %ecx,%eax
  802a17:	89 fa                	mov    %edi,%edx
  802a19:	f7 f6                	div    %esi
  802a1b:	89 d0                	mov    %edx,%eax
  802a1d:	31 d2                	xor    %edx,%edx
  802a1f:	83 c4 14             	add    $0x14,%esp
  802a22:	5e                   	pop    %esi
  802a23:	5f                   	pop    %edi
  802a24:	5d                   	pop    %ebp
  802a25:	c3                   	ret    
  802a26:	66 90                	xchg   %ax,%ax
  802a28:	39 f8                	cmp    %edi,%eax
  802a2a:	77 54                	ja     802a80 <__umoddi3+0xa0>
  802a2c:	0f bd e8             	bsr    %eax,%ebp
  802a2f:	83 f5 1f             	xor    $0x1f,%ebp
  802a32:	75 5c                	jne    802a90 <__umoddi3+0xb0>
  802a34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a38:	39 3c 24             	cmp    %edi,(%esp)
  802a3b:	0f 87 e7 00 00 00    	ja     802b28 <__umoddi3+0x148>
  802a41:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a45:	29 f1                	sub    %esi,%ecx
  802a47:	19 c7                	sbb    %eax,%edi
  802a49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a51:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a55:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802a59:	83 c4 14             	add    $0x14,%esp
  802a5c:	5e                   	pop    %esi
  802a5d:	5f                   	pop    %edi
  802a5e:	5d                   	pop    %ebp
  802a5f:	c3                   	ret    
  802a60:	85 f6                	test   %esi,%esi
  802a62:	89 f5                	mov    %esi,%ebp
  802a64:	75 0b                	jne    802a71 <__umoddi3+0x91>
  802a66:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6b:	31 d2                	xor    %edx,%edx
  802a6d:	f7 f6                	div    %esi
  802a6f:	89 c5                	mov    %eax,%ebp
  802a71:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a75:	31 d2                	xor    %edx,%edx
  802a77:	f7 f5                	div    %ebp
  802a79:	89 c8                	mov    %ecx,%eax
  802a7b:	f7 f5                	div    %ebp
  802a7d:	eb 9c                	jmp    802a1b <__umoddi3+0x3b>
  802a7f:	90                   	nop
  802a80:	89 c8                	mov    %ecx,%eax
  802a82:	89 fa                	mov    %edi,%edx
  802a84:	83 c4 14             	add    $0x14,%esp
  802a87:	5e                   	pop    %esi
  802a88:	5f                   	pop    %edi
  802a89:	5d                   	pop    %ebp
  802a8a:	c3                   	ret    
  802a8b:	90                   	nop
  802a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a90:	8b 04 24             	mov    (%esp),%eax
  802a93:	be 20 00 00 00       	mov    $0x20,%esi
  802a98:	89 e9                	mov    %ebp,%ecx
  802a9a:	29 ee                	sub    %ebp,%esi
  802a9c:	d3 e2                	shl    %cl,%edx
  802a9e:	89 f1                	mov    %esi,%ecx
  802aa0:	d3 e8                	shr    %cl,%eax
  802aa2:	89 e9                	mov    %ebp,%ecx
  802aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa8:	8b 04 24             	mov    (%esp),%eax
  802aab:	09 54 24 04          	or     %edx,0x4(%esp)
  802aaf:	89 fa                	mov    %edi,%edx
  802ab1:	d3 e0                	shl    %cl,%eax
  802ab3:	89 f1                	mov    %esi,%ecx
  802ab5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ab9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802abd:	d3 ea                	shr    %cl,%edx
  802abf:	89 e9                	mov    %ebp,%ecx
  802ac1:	d3 e7                	shl    %cl,%edi
  802ac3:	89 f1                	mov    %esi,%ecx
  802ac5:	d3 e8                	shr    %cl,%eax
  802ac7:	89 e9                	mov    %ebp,%ecx
  802ac9:	09 f8                	or     %edi,%eax
  802acb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802acf:	f7 74 24 04          	divl   0x4(%esp)
  802ad3:	d3 e7                	shl    %cl,%edi
  802ad5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ad9:	89 d7                	mov    %edx,%edi
  802adb:	f7 64 24 08          	mull   0x8(%esp)
  802adf:	39 d7                	cmp    %edx,%edi
  802ae1:	89 c1                	mov    %eax,%ecx
  802ae3:	89 14 24             	mov    %edx,(%esp)
  802ae6:	72 2c                	jb     802b14 <__umoddi3+0x134>
  802ae8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802aec:	72 22                	jb     802b10 <__umoddi3+0x130>
  802aee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802af2:	29 c8                	sub    %ecx,%eax
  802af4:	19 d7                	sbb    %edx,%edi
  802af6:	89 e9                	mov    %ebp,%ecx
  802af8:	89 fa                	mov    %edi,%edx
  802afa:	d3 e8                	shr    %cl,%eax
  802afc:	89 f1                	mov    %esi,%ecx
  802afe:	d3 e2                	shl    %cl,%edx
  802b00:	89 e9                	mov    %ebp,%ecx
  802b02:	d3 ef                	shr    %cl,%edi
  802b04:	09 d0                	or     %edx,%eax
  802b06:	89 fa                	mov    %edi,%edx
  802b08:	83 c4 14             	add    $0x14,%esp
  802b0b:	5e                   	pop    %esi
  802b0c:	5f                   	pop    %edi
  802b0d:	5d                   	pop    %ebp
  802b0e:	c3                   	ret    
  802b0f:	90                   	nop
  802b10:	39 d7                	cmp    %edx,%edi
  802b12:	75 da                	jne    802aee <__umoddi3+0x10e>
  802b14:	8b 14 24             	mov    (%esp),%edx
  802b17:	89 c1                	mov    %eax,%ecx
  802b19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b21:	eb cb                	jmp    802aee <__umoddi3+0x10e>
  802b23:	90                   	nop
  802b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b2c:	0f 82 0f ff ff ff    	jb     802a41 <__umoddi3+0x61>
  802b32:	e9 1a ff ff ff       	jmp    802a51 <__umoddi3+0x71>
