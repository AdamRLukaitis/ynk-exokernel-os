
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 01 01 00 00       	call   800132 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	c7 04 24 40 29 80 00 	movl   $0x802940,(%esp)
  800040:	e8 fb 01 00 00       	call   800240 <cprintf>
	exit();
  800045:	e8 3a 01 00 00       	call   800184 <exit>
}
  80004a:	c9                   	leave  
  80004b:	c3                   	ret    

0080004c <umain>:

void
umain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	57                   	push   %edi
  800050:	56                   	push   %esi
  800051:	53                   	push   %ebx
  800052:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800058:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800062:	8b 45 0c             	mov    0xc(%ebp),%eax
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	8d 45 08             	lea    0x8(%ebp),%eax
  80006c:	89 04 24             	mov    %eax,(%esp)
  80006f:	e8 3c 0f 00 00       	call   800fb0 <argstart>
}

void
umain(int argc, char **argv)
{
	int i, usefprint = 0;
  800074:	be 00 00 00 00       	mov    $0x0,%esi
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800079:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
  80007f:	eb 11                	jmp    800092 <umain+0x46>
		if (i == '1')
  800081:	83 f8 31             	cmp    $0x31,%eax
  800084:	75 07                	jne    80008d <umain+0x41>
			usefprint = 1;
  800086:	be 01 00 00 00       	mov    $0x1,%esi
  80008b:	eb 05                	jmp    800092 <umain+0x46>
		else
			usage();
  80008d:	e8 a1 ff ff ff       	call   800033 <usage>
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800092:	89 1c 24             	mov    %ebx,(%esp)
  800095:	e8 4e 0f 00 00       	call   800fe8 <argnext>
  80009a:	85 c0                	test   %eax,%eax
  80009c:	79 e3                	jns    800081 <umain+0x35>
  80009e:	bb 00 00 00 00       	mov    $0x0,%ebx
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000a3:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000ad:	89 1c 24             	mov    %ebx,(%esp)
  8000b0:	e8 81 15 00 00       	call   801636 <fstat>
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	78 66                	js     80011f <umain+0xd3>
			if (usefprint)
  8000b9:	85 f6                	test   %esi,%esi
  8000bb:	74 36                	je     8000f3 <umain+0xa7>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c0:	8b 40 04             	mov    0x4(%eax),%eax
  8000c3:	89 44 24 18          	mov    %eax,0x18(%esp)
  8000c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000ca:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000dd:	c7 44 24 04 54 29 80 	movl   $0x802954,0x4(%esp)
  8000e4:	00 
  8000e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ec:	e8 91 19 00 00       	call   801a82 <fprintf>
  8000f1:	eb 2c                	jmp    80011f <umain+0xd3>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f6:	8b 40 04             	mov    0x4(%eax),%eax
  8000f9:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800100:	89 44 24 10          	mov    %eax,0x10(%esp)
  800104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800107:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80010b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80010f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800113:	c7 04 24 54 29 80 00 	movl   $0x802954,(%esp)
  80011a:	e8 21 01 00 00       	call   800240 <cprintf>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  80011f:	83 c3 01             	add    $0x1,%ebx
  800122:	83 fb 20             	cmp    $0x20,%ebx
  800125:	75 82                	jne    8000a9 <umain+0x5d>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800127:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	56                   	push   %esi
  800136:	53                   	push   %ebx
  800137:	83 ec 10             	sub    $0x10,%esp
  80013a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800140:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800147:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  80014a:	e8 f6 0a 00 00       	call   800c45 <sys_getenvid>
  80014f:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800154:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800157:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015c:	a3 08 40 80 00       	mov    %eax,0x804008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800161:	85 db                	test   %ebx,%ebx
  800163:	7e 07                	jle    80016c <libmain+0x3a>
		binaryname = argv[0];
  800165:	8b 06                	mov    (%esi),%eax
  800167:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80016c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800170:	89 1c 24             	mov    %ebx,(%esp)
  800173:	e8 d4 fe ff ff       	call   80004c <umain>

	// exit gracefully
	exit();
  800178:	e8 07 00 00 00       	call   800184 <exit>
}
  80017d:	83 c4 10             	add    $0x10,%esp
  800180:	5b                   	pop    %ebx
  800181:	5e                   	pop    %esi
  800182:	5d                   	pop    %ebp
  800183:	c3                   	ret    

00800184 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800184:	55                   	push   %ebp
  800185:	89 e5                	mov    %esp,%ebp
  800187:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80018a:	e8 5b 11 00 00       	call   8012ea <close_all>
	sys_env_destroy(0);
  80018f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800196:	e8 58 0a 00 00       	call   800bf3 <sys_env_destroy>
}
  80019b:	c9                   	leave  
  80019c:	c3                   	ret    

0080019d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80019d:	55                   	push   %ebp
  80019e:	89 e5                	mov    %esp,%ebp
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 14             	sub    $0x14,%esp
  8001a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a7:	8b 13                	mov    (%ebx),%edx
  8001a9:	8d 42 01             	lea    0x1(%edx),%eax
  8001ac:	89 03                	mov    %eax,(%ebx)
  8001ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ba:	75 19                	jne    8001d5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001bc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001c3:	00 
  8001c4:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c7:	89 04 24             	mov    %eax,(%esp)
  8001ca:	e8 e7 09 00 00       	call   800bb6 <sys_cputs>
		b->idx = 0;
  8001cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001d5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d9:	83 c4 14             	add    $0x14,%esp
  8001dc:	5b                   	pop    %ebx
  8001dd:	5d                   	pop    %ebp
  8001de:	c3                   	ret    

008001df <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001e8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ef:	00 00 00 
	b.cnt = 0;
  8001f2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800203:	8b 45 08             	mov    0x8(%ebp),%eax
  800206:	89 44 24 08          	mov    %eax,0x8(%esp)
  80020a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800210:	89 44 24 04          	mov    %eax,0x4(%esp)
  800214:	c7 04 24 9d 01 80 00 	movl   $0x80019d,(%esp)
  80021b:	e8 ae 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800220:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800226:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800230:	89 04 24             	mov    %eax,(%esp)
  800233:	e8 7e 09 00 00       	call   800bb6 <sys_cputs>

	return b.cnt;
}
  800238:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
  800243:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800246:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800249:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024d:	8b 45 08             	mov    0x8(%ebp),%eax
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	e8 87 ff ff ff       	call   8001df <vcprintf>
	va_end(ap);

	return cnt;
}
  800258:	c9                   	leave  
  800259:	c3                   	ret    
  80025a:	66 90                	xchg   %ax,%ax
  80025c:	66 90                	xchg   %ax,%ax
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
  8002cf:	e8 cc 23 00 00       	call   8026a0 <__udivdi3>
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
  80032f:	e8 9c 24 00 00       	call   8027d0 <__umoddi3>
  800334:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800338:	0f be 80 86 29 80 00 	movsbl 0x802986(%eax),%eax
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
  800453:	ff 24 8d c0 2a 80 00 	jmp    *0x802ac0(,%ecx,4)
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
  8004f0:	8b 14 85 20 2c 80 00 	mov    0x802c20(,%eax,4),%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	75 20                	jne    80051b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ff:	c7 44 24 08 9e 29 80 	movl   $0x80299e,0x8(%esp)
  800506:	00 
  800507:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	89 04 24             	mov    %eax,(%esp)
  800511:	e8 90 fe ff ff       	call   8003a6 <printfmt>
  800516:	e9 d8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80051b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80051f:	c7 44 24 08 55 2d 80 	movl   $0x802d55,0x8(%esp)
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
  800551:	b8 97 29 80 00       	mov    $0x802997,%eax
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
  800c21:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800c28:	00 
  800c29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c30:	00 
  800c31:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800c38:	e8 c9 18 00 00       	call   802506 <_panic>

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
  800cb3:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800cba:	00 
  800cbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc2:	00 
  800cc3:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800cca:	e8 37 18 00 00       	call   802506 <_panic>

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
  800d06:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800d0d:	00 
  800d0e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d15:	00 
  800d16:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800d1d:	e8 e4 17 00 00       	call   802506 <_panic>

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
  800d59:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800d60:	00 
  800d61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d68:	00 
  800d69:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800d70:	e8 91 17 00 00       	call   802506 <_panic>

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
  800dac:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800db3:	00 
  800db4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbb:	00 
  800dbc:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800dc3:	e8 3e 17 00 00       	call   802506 <_panic>

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
  800dff:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800e06:	00 
  800e07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0e:	00 
  800e0f:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800e16:	e8 eb 16 00 00       	call   802506 <_panic>
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
  800e52:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800e59:	00 
  800e5a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e61:	00 
  800e62:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800e69:	e8 98 16 00 00       	call   802506 <_panic>
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
  800ec7:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800ece:	00 
  800ecf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed6:	00 
  800ed7:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800ede:	e8 23 16 00 00       	call   802506 <_panic>

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
  800f39:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800f50:	e8 b1 15 00 00       	call   802506 <_panic>

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
  800f8c:	c7 44 24 08 7f 2c 80 	movl   $0x802c7f,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  800fa3:	e8 5e 15 00 00       	call   802506 <_panic>

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

00800fb0 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	53                   	push   %ebx
  800fb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fba:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800fbd:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  800fbf:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc7:	83 39 01             	cmpl   $0x1,(%ecx)
  800fca:	7e 0f                	jle    800fdb <argstart+0x2b>
  800fcc:	85 d2                	test   %edx,%edx
  800fce:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd3:	bb 51 29 80 00       	mov    $0x802951,%ebx
  800fd8:	0f 44 da             	cmove  %edx,%ebx
  800fdb:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  800fde:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800fe5:	5b                   	pop    %ebx
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <argnext>:

int
argnext(struct Argstate *args)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	53                   	push   %ebx
  800fec:	83 ec 14             	sub    $0x14,%esp
  800fef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800ff2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800ff9:	8b 43 08             	mov    0x8(%ebx),%eax
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	74 71                	je     801071 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801000:	80 38 00             	cmpb   $0x0,(%eax)
  801003:	75 50                	jne    801055 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801005:	8b 0b                	mov    (%ebx),%ecx
  801007:	83 39 01             	cmpl   $0x1,(%ecx)
  80100a:	74 57                	je     801063 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  80100c:	8b 53 04             	mov    0x4(%ebx),%edx
  80100f:	8b 42 04             	mov    0x4(%edx),%eax
  801012:	80 38 2d             	cmpb   $0x2d,(%eax)
  801015:	75 4c                	jne    801063 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801017:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80101b:	74 46                	je     801063 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80101d:	83 c0 01             	add    $0x1,%eax
  801020:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801023:	8b 01                	mov    (%ecx),%eax
  801025:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80102c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801030:	8d 42 08             	lea    0x8(%edx),%eax
  801033:	89 44 24 04          	mov    %eax,0x4(%esp)
  801037:	83 c2 04             	add    $0x4,%edx
  80103a:	89 14 24             	mov    %edx,(%esp)
  80103d:	e8 c2 f9 ff ff       	call   800a04 <memmove>
		(*args->argc)--;
  801042:	8b 03                	mov    (%ebx),%eax
  801044:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801047:	8b 43 08             	mov    0x8(%ebx),%eax
  80104a:	80 38 2d             	cmpb   $0x2d,(%eax)
  80104d:	75 06                	jne    801055 <argnext+0x6d>
  80104f:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801053:	74 0e                	je     801063 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801055:	8b 53 08             	mov    0x8(%ebx),%edx
  801058:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80105b:	83 c2 01             	add    $0x1,%edx
  80105e:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801061:	eb 13                	jmp    801076 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  801063:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80106a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80106f:	eb 05                	jmp    801076 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801076:	83 c4 14             	add    $0x14,%esp
  801079:	5b                   	pop    %ebx
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    

0080107c <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	53                   	push   %ebx
  801080:	83 ec 14             	sub    $0x14,%esp
  801083:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801086:	8b 43 08             	mov    0x8(%ebx),%eax
  801089:	85 c0                	test   %eax,%eax
  80108b:	74 5a                	je     8010e7 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  80108d:	80 38 00             	cmpb   $0x0,(%eax)
  801090:	74 0c                	je     80109e <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801092:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801095:	c7 43 08 51 29 80 00 	movl   $0x802951,0x8(%ebx)
  80109c:	eb 44                	jmp    8010e2 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  80109e:	8b 03                	mov    (%ebx),%eax
  8010a0:	83 38 01             	cmpl   $0x1,(%eax)
  8010a3:	7e 2f                	jle    8010d4 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  8010a5:	8b 53 04             	mov    0x4(%ebx),%edx
  8010a8:	8b 4a 04             	mov    0x4(%edx),%ecx
  8010ab:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8010b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010bb:	8d 42 08             	lea    0x8(%edx),%eax
  8010be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010c2:	83 c2 04             	add    $0x4,%edx
  8010c5:	89 14 24             	mov    %edx,(%esp)
  8010c8:	e8 37 f9 ff ff       	call   800a04 <memmove>
		(*args->argc)--;
  8010cd:	8b 03                	mov    (%ebx),%eax
  8010cf:	83 28 01             	subl   $0x1,(%eax)
  8010d2:	eb 0e                	jmp    8010e2 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  8010d4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8010db:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  8010e2:	8b 43 0c             	mov    0xc(%ebx),%eax
  8010e5:	eb 05                	jmp    8010ec <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  8010e7:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  8010ec:	83 c4 14             	add    $0x14,%esp
  8010ef:	5b                   	pop    %ebx
  8010f0:	5d                   	pop    %ebp
  8010f1:	c3                   	ret    

008010f2 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  8010f2:	55                   	push   %ebp
  8010f3:	89 e5                	mov    %esp,%ebp
  8010f5:	83 ec 18             	sub    $0x18,%esp
  8010f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8010fb:	8b 51 0c             	mov    0xc(%ecx),%edx
  8010fe:	89 d0                	mov    %edx,%eax
  801100:	85 d2                	test   %edx,%edx
  801102:	75 08                	jne    80110c <argvalue+0x1a>
  801104:	89 0c 24             	mov    %ecx,(%esp)
  801107:	e8 70 ff ff ff       	call   80107c <argnextvalue>
}
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    
  80110e:	66 90                	xchg   %ax,%ax

00801110 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	05 00 00 00 30       	add    $0x30000000,%eax
  80111b:	c1 e8 0c             	shr    $0xc,%eax
}
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80112b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801130:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801142:	89 c2                	mov    %eax,%edx
  801144:	c1 ea 16             	shr    $0x16,%edx
  801147:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80114e:	f6 c2 01             	test   $0x1,%dl
  801151:	74 11                	je     801164 <fd_alloc+0x2d>
  801153:	89 c2                	mov    %eax,%edx
  801155:	c1 ea 0c             	shr    $0xc,%edx
  801158:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80115f:	f6 c2 01             	test   $0x1,%dl
  801162:	75 09                	jne    80116d <fd_alloc+0x36>
			*fd_store = fd;
  801164:	89 01                	mov    %eax,(%ecx)
			return 0;
  801166:	b8 00 00 00 00       	mov    $0x0,%eax
  80116b:	eb 17                	jmp    801184 <fd_alloc+0x4d>
  80116d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801172:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801177:	75 c9                	jne    801142 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801179:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80117f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    

00801186 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80118c:	83 f8 1f             	cmp    $0x1f,%eax
  80118f:	77 36                	ja     8011c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801191:	c1 e0 0c             	shl    $0xc,%eax
  801194:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801199:	89 c2                	mov    %eax,%edx
  80119b:	c1 ea 16             	shr    $0x16,%edx
  80119e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011a5:	f6 c2 01             	test   $0x1,%dl
  8011a8:	74 24                	je     8011ce <fd_lookup+0x48>
  8011aa:	89 c2                	mov    %eax,%edx
  8011ac:	c1 ea 0c             	shr    $0xc,%edx
  8011af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011b6:	f6 c2 01             	test   $0x1,%dl
  8011b9:	74 1a                	je     8011d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011be:	89 02                	mov    %eax,(%edx)
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c5:	eb 13                	jmp    8011da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cc:	eb 0c                	jmp    8011da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d3:	eb 05                	jmp    8011da <fd_lookup+0x54>
  8011d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 18             	sub    $0x18,%esp
  8011e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8011e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ea:	eb 13                	jmp    8011ff <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8011ec:	39 08                	cmp    %ecx,(%eax)
  8011ee:	75 0c                	jne    8011fc <dev_lookup+0x20>
			*dev = devtab[i];
  8011f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fa:	eb 38                	jmp    801234 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8011fc:	83 c2 01             	add    $0x1,%edx
  8011ff:	8b 04 95 28 2d 80 00 	mov    0x802d28(,%edx,4),%eax
  801206:	85 c0                	test   %eax,%eax
  801208:	75 e2                	jne    8011ec <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80120a:	a1 08 40 80 00       	mov    0x804008,%eax
  80120f:	8b 40 48             	mov    0x48(%eax),%eax
  801212:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121a:	c7 04 24 ac 2c 80 00 	movl   $0x802cac,(%esp)
  801221:	e8 1a f0 ff ff       	call   800240 <cprintf>
	*dev = 0;
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80122f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
  80123b:	83 ec 20             	sub    $0x20,%esp
  80123e:	8b 75 08             	mov    0x8(%ebp),%esi
  801241:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801247:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801251:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801254:	89 04 24             	mov    %eax,(%esp)
  801257:	e8 2a ff ff ff       	call   801186 <fd_lookup>
  80125c:	85 c0                	test   %eax,%eax
  80125e:	78 05                	js     801265 <fd_close+0x2f>
	    || fd != fd2)
  801260:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801263:	74 0c                	je     801271 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801265:	84 db                	test   %bl,%bl
  801267:	ba 00 00 00 00       	mov    $0x0,%edx
  80126c:	0f 44 c2             	cmove  %edx,%eax
  80126f:	eb 3f                	jmp    8012b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801271:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801274:	89 44 24 04          	mov    %eax,0x4(%esp)
  801278:	8b 06                	mov    (%esi),%eax
  80127a:	89 04 24             	mov    %eax,(%esp)
  80127d:	e8 5a ff ff ff       	call   8011dc <dev_lookup>
  801282:	89 c3                	mov    %eax,%ebx
  801284:	85 c0                	test   %eax,%eax
  801286:	78 16                	js     80129e <fd_close+0x68>
		if (dev->dev_close)
  801288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80128e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801293:	85 c0                	test   %eax,%eax
  801295:	74 07                	je     80129e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801297:	89 34 24             	mov    %esi,(%esp)
  80129a:	ff d0                	call   *%eax
  80129c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80129e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a9:	e8 7c fa ff ff       	call   800d2a <sys_page_unmap>
	return r;
  8012ae:	89 d8                	mov    %ebx,%eax
}
  8012b0:	83 c4 20             	add    $0x20,%esp
  8012b3:	5b                   	pop    %ebx
  8012b4:	5e                   	pop    %esi
  8012b5:	5d                   	pop    %ebp
  8012b6:	c3                   	ret    

008012b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	89 04 24             	mov    %eax,(%esp)
  8012ca:	e8 b7 fe ff ff       	call   801186 <fd_lookup>
  8012cf:	89 c2                	mov    %eax,%edx
  8012d1:	85 d2                	test   %edx,%edx
  8012d3:	78 13                	js     8012e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012dc:	00 
  8012dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e0:	89 04 24             	mov    %eax,(%esp)
  8012e3:	e8 4e ff ff ff       	call   801236 <fd_close>
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <close_all>:

void
close_all(void)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012f6:	89 1c 24             	mov    %ebx,(%esp)
  8012f9:	e8 b9 ff ff ff       	call   8012b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012fe:	83 c3 01             	add    $0x1,%ebx
  801301:	83 fb 20             	cmp    $0x20,%ebx
  801304:	75 f0                	jne    8012f6 <close_all+0xc>
		close(i);
}
  801306:	83 c4 14             	add    $0x14,%esp
  801309:	5b                   	pop    %ebx
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	57                   	push   %edi
  801310:	56                   	push   %esi
  801311:	53                   	push   %ebx
  801312:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801315:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 04 24             	mov    %eax,(%esp)
  801322:	e8 5f fe ff ff       	call   801186 <fd_lookup>
  801327:	89 c2                	mov    %eax,%edx
  801329:	85 d2                	test   %edx,%edx
  80132b:	0f 88 e1 00 00 00    	js     801412 <dup+0x106>
		return r;
	close(newfdnum);
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 04 24             	mov    %eax,(%esp)
  801337:	e8 7b ff ff ff       	call   8012b7 <close>

	newfd = INDEX2FD(newfdnum);
  80133c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80133f:	c1 e3 0c             	shl    $0xc,%ebx
  801342:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80134b:	89 04 24             	mov    %eax,(%esp)
  80134e:	e8 cd fd ff ff       	call   801120 <fd2data>
  801353:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801355:	89 1c 24             	mov    %ebx,(%esp)
  801358:	e8 c3 fd ff ff       	call   801120 <fd2data>
  80135d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80135f:	89 f0                	mov    %esi,%eax
  801361:	c1 e8 16             	shr    $0x16,%eax
  801364:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80136b:	a8 01                	test   $0x1,%al
  80136d:	74 43                	je     8013b2 <dup+0xa6>
  80136f:	89 f0                	mov    %esi,%eax
  801371:	c1 e8 0c             	shr    $0xc,%eax
  801374:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80137b:	f6 c2 01             	test   $0x1,%dl
  80137e:	74 32                	je     8013b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801380:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801387:	25 07 0e 00 00       	and    $0xe07,%eax
  80138c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801390:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801394:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80139b:	00 
  80139c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a7:	e8 2b f9 ff ff       	call   800cd7 <sys_page_map>
  8013ac:	89 c6                	mov    %eax,%esi
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 3e                	js     8013f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b5:	89 c2                	mov    %eax,%edx
  8013b7:	c1 ea 0c             	shr    $0xc,%edx
  8013ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013d6:	00 
  8013d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e2:	e8 f0 f8 ff ff       	call   800cd7 <sys_page_map>
  8013e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ec:	85 f6                	test   %esi,%esi
  8013ee:	79 22                	jns    801412 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fb:	e8 2a f9 ff ff       	call   800d2a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801400:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801404:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80140b:	e8 1a f9 ff ff       	call   800d2a <sys_page_unmap>
	return r;
  801410:	89 f0                	mov    %esi,%eax
}
  801412:	83 c4 3c             	add    $0x3c,%esp
  801415:	5b                   	pop    %ebx
  801416:	5e                   	pop    %esi
  801417:	5f                   	pop    %edi
  801418:	5d                   	pop    %ebp
  801419:	c3                   	ret    

0080141a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	53                   	push   %ebx
  80141e:	83 ec 24             	sub    $0x24,%esp
  801421:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801424:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801427:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142b:	89 1c 24             	mov    %ebx,(%esp)
  80142e:	e8 53 fd ff ff       	call   801186 <fd_lookup>
  801433:	89 c2                	mov    %eax,%edx
  801435:	85 d2                	test   %edx,%edx
  801437:	78 6d                	js     8014a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801439:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801443:	8b 00                	mov    (%eax),%eax
  801445:	89 04 24             	mov    %eax,(%esp)
  801448:	e8 8f fd ff ff       	call   8011dc <dev_lookup>
  80144d:	85 c0                	test   %eax,%eax
  80144f:	78 55                	js     8014a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801454:	8b 50 08             	mov    0x8(%eax),%edx
  801457:	83 e2 03             	and    $0x3,%edx
  80145a:	83 fa 01             	cmp    $0x1,%edx
  80145d:	75 23                	jne    801482 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80145f:	a1 08 40 80 00       	mov    0x804008,%eax
  801464:	8b 40 48             	mov    0x48(%eax),%eax
  801467:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80146b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146f:	c7 04 24 ed 2c 80 00 	movl   $0x802ced,(%esp)
  801476:	e8 c5 ed ff ff       	call   800240 <cprintf>
		return -E_INVAL;
  80147b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801480:	eb 24                	jmp    8014a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801485:	8b 52 08             	mov    0x8(%edx),%edx
  801488:	85 d2                	test   %edx,%edx
  80148a:	74 15                	je     8014a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80148c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80148f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801493:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801496:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80149a:	89 04 24             	mov    %eax,(%esp)
  80149d:	ff d2                	call   *%edx
  80149f:	eb 05                	jmp    8014a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014a6:	83 c4 24             	add    $0x24,%esp
  8014a9:	5b                   	pop    %ebx
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    

008014ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	57                   	push   %edi
  8014b0:	56                   	push   %esi
  8014b1:	53                   	push   %ebx
  8014b2:	83 ec 1c             	sub    $0x1c,%esp
  8014b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c0:	eb 23                	jmp    8014e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c2:	89 f0                	mov    %esi,%eax
  8014c4:	29 d8                	sub    %ebx,%eax
  8014c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ca:	89 d8                	mov    %ebx,%eax
  8014cc:	03 45 0c             	add    0xc(%ebp),%eax
  8014cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d3:	89 3c 24             	mov    %edi,(%esp)
  8014d6:	e8 3f ff ff ff       	call   80141a <read>
		if (m < 0)
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 10                	js     8014ef <readn+0x43>
			return m;
		if (m == 0)
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	74 0a                	je     8014ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014e3:	01 c3                	add    %eax,%ebx
  8014e5:	39 f3                	cmp    %esi,%ebx
  8014e7:	72 d9                	jb     8014c2 <readn+0x16>
  8014e9:	89 d8                	mov    %ebx,%eax
  8014eb:	eb 02                	jmp    8014ef <readn+0x43>
  8014ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014ef:	83 c4 1c             	add    $0x1c,%esp
  8014f2:	5b                   	pop    %ebx
  8014f3:	5e                   	pop    %esi
  8014f4:	5f                   	pop    %edi
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	53                   	push   %ebx
  8014fb:	83 ec 24             	sub    $0x24,%esp
  8014fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801501:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801504:	89 44 24 04          	mov    %eax,0x4(%esp)
  801508:	89 1c 24             	mov    %ebx,(%esp)
  80150b:	e8 76 fc ff ff       	call   801186 <fd_lookup>
  801510:	89 c2                	mov    %eax,%edx
  801512:	85 d2                	test   %edx,%edx
  801514:	78 68                	js     80157e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801516:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801519:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801520:	8b 00                	mov    (%eax),%eax
  801522:	89 04 24             	mov    %eax,(%esp)
  801525:	e8 b2 fc ff ff       	call   8011dc <dev_lookup>
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 50                	js     80157e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801535:	75 23                	jne    80155a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801537:	a1 08 40 80 00       	mov    0x804008,%eax
  80153c:	8b 40 48             	mov    0x48(%eax),%eax
  80153f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801543:	89 44 24 04          	mov    %eax,0x4(%esp)
  801547:	c7 04 24 09 2d 80 00 	movl   $0x802d09,(%esp)
  80154e:	e8 ed ec ff ff       	call   800240 <cprintf>
		return -E_INVAL;
  801553:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801558:	eb 24                	jmp    80157e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80155a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155d:	8b 52 0c             	mov    0xc(%edx),%edx
  801560:	85 d2                	test   %edx,%edx
  801562:	74 15                	je     801579 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801564:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801567:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80156b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80156e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801572:	89 04 24             	mov    %eax,(%esp)
  801575:	ff d2                	call   *%edx
  801577:	eb 05                	jmp    80157e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801579:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80157e:	83 c4 24             	add    $0x24,%esp
  801581:	5b                   	pop    %ebx
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    

00801584 <seek>:

int
seek(int fdnum, off_t offset)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80158d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	89 04 24             	mov    %eax,(%esp)
  801597:	e8 ea fb ff ff       	call   801186 <fd_lookup>
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 0e                	js     8015ae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	53                   	push   %ebx
  8015b4:	83 ec 24             	sub    $0x24,%esp
  8015b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c1:	89 1c 24             	mov    %ebx,(%esp)
  8015c4:	e8 bd fb ff ff       	call   801186 <fd_lookup>
  8015c9:	89 c2                	mov    %eax,%edx
  8015cb:	85 d2                	test   %edx,%edx
  8015cd:	78 61                	js     801630 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d9:	8b 00                	mov    (%eax),%eax
  8015db:	89 04 24             	mov    %eax,(%esp)
  8015de:	e8 f9 fb ff ff       	call   8011dc <dev_lookup>
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	78 49                	js     801630 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ee:	75 23                	jne    801613 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015f0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f5:	8b 40 48             	mov    0x48(%eax),%eax
  8015f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801600:	c7 04 24 cc 2c 80 00 	movl   $0x802ccc,(%esp)
  801607:	e8 34 ec ff ff       	call   800240 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80160c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801611:	eb 1d                	jmp    801630 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801616:	8b 52 18             	mov    0x18(%edx),%edx
  801619:	85 d2                	test   %edx,%edx
  80161b:	74 0e                	je     80162b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80161d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801620:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	ff d2                	call   *%edx
  801629:	eb 05                	jmp    801630 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80162b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801630:	83 c4 24             	add    $0x24,%esp
  801633:	5b                   	pop    %ebx
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    

00801636 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	53                   	push   %ebx
  80163a:	83 ec 24             	sub    $0x24,%esp
  80163d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801643:	89 44 24 04          	mov    %eax,0x4(%esp)
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	89 04 24             	mov    %eax,(%esp)
  80164d:	e8 34 fb ff ff       	call   801186 <fd_lookup>
  801652:	89 c2                	mov    %eax,%edx
  801654:	85 d2                	test   %edx,%edx
  801656:	78 52                	js     8016aa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801658:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	89 04 24             	mov    %eax,(%esp)
  801667:	e8 70 fb ff ff       	call   8011dc <dev_lookup>
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 3a                	js     8016aa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801673:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801677:	74 2c                	je     8016a5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801679:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80167c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801683:	00 00 00 
	stat->st_isdir = 0;
  801686:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80168d:	00 00 00 
	stat->st_dev = dev;
  801690:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801696:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80169a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80169d:	89 14 24             	mov    %edx,(%esp)
  8016a0:	ff 50 14             	call   *0x14(%eax)
  8016a3:	eb 05                	jmp    8016aa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016aa:	83 c4 24             	add    $0x24,%esp
  8016ad:	5b                   	pop    %ebx
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
  8016b5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016bf:	00 
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	89 04 24             	mov    %eax,(%esp)
  8016c6:	e8 28 02 00 00       	call   8018f3 <open>
  8016cb:	89 c3                	mov    %eax,%ebx
  8016cd:	85 db                	test   %ebx,%ebx
  8016cf:	78 1b                	js     8016ec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d8:	89 1c 24             	mov    %ebx,(%esp)
  8016db:	e8 56 ff ff ff       	call   801636 <fstat>
  8016e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016e2:	89 1c 24             	mov    %ebx,(%esp)
  8016e5:	e8 cd fb ff ff       	call   8012b7 <close>
	return r;
  8016ea:	89 f0                	mov    %esi,%eax
}
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5e                   	pop    %esi
  8016f1:	5d                   	pop    %ebp
  8016f2:	c3                   	ret    

008016f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	56                   	push   %esi
  8016f7:	53                   	push   %ebx
  8016f8:	83 ec 10             	sub    $0x10,%esp
  8016fb:	89 c6                	mov    %eax,%esi
  8016fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ff:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801706:	75 11                	jne    801719 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801708:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80170f:	e8 10 0f 00 00       	call   802624 <ipc_find_env>
  801714:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801719:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801720:	00 
  801721:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801728:	00 
  801729:	89 74 24 04          	mov    %esi,0x4(%esp)
  80172d:	a1 00 40 80 00       	mov    0x804000,%eax
  801732:	89 04 24             	mov    %eax,(%esp)
  801735:	e8 8c 0e 00 00       	call   8025c6 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801741:	00 
  801742:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801746:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174d:	e8 0a 0e 00 00       	call   80255c <ipc_recv>
}
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8b 40 0c             	mov    0xc(%eax),%eax
  801765:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80176a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
  801777:	b8 02 00 00 00       	mov    $0x2,%eax
  80177c:	e8 72 ff ff ff       	call   8016f3 <fsipc>
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	8b 40 0c             	mov    0xc(%eax),%eax
  80178f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801794:	ba 00 00 00 00       	mov    $0x0,%edx
  801799:	b8 06 00 00 00       	mov    $0x6,%eax
  80179e:	e8 50 ff ff ff       	call   8016f3 <fsipc>
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 14             	sub    $0x14,%esp
  8017ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c4:	e8 2a ff ff ff       	call   8016f3 <fsipc>
  8017c9:	89 c2                	mov    %eax,%edx
  8017cb:	85 d2                	test   %edx,%edx
  8017cd:	78 2b                	js     8017fa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017cf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017d6:	00 
  8017d7:	89 1c 24             	mov    %ebx,(%esp)
  8017da:	e8 88 f0 ff ff       	call   800867 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017df:	a1 80 50 80 00       	mov    0x805080,%eax
  8017e4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ea:	a1 84 50 80 00       	mov    0x805084,%eax
  8017ef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fa:	83 c4 14             	add    $0x14,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 18             	sub    $0x18,%esp
  801806:	8b 45 10             	mov    0x10(%ebp),%eax
  801809:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80180e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801813:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801816:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80181b:	8b 55 08             	mov    0x8(%ebp),%edx
  80181e:	8b 52 0c             	mov    0xc(%edx),%edx
  801821:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801827:	89 44 24 08          	mov    %eax,0x8(%esp)
  80182b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801832:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  801839:	e8 c6 f1 ff ff       	call   800a04 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80183e:	ba 00 00 00 00       	mov    $0x0,%edx
  801843:	b8 04 00 00 00       	mov    $0x4,%eax
  801848:	e8 a6 fe ff ff       	call   8016f3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	56                   	push   %esi
  801853:	53                   	push   %ebx
  801854:	83 ec 10             	sub    $0x10,%esp
  801857:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	8b 40 0c             	mov    0xc(%eax),%eax
  801860:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801865:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80186b:	ba 00 00 00 00       	mov    $0x0,%edx
  801870:	b8 03 00 00 00       	mov    $0x3,%eax
  801875:	e8 79 fe ff ff       	call   8016f3 <fsipc>
  80187a:	89 c3                	mov    %eax,%ebx
  80187c:	85 c0                	test   %eax,%eax
  80187e:	78 6a                	js     8018ea <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801880:	39 c6                	cmp    %eax,%esi
  801882:	73 24                	jae    8018a8 <devfile_read+0x59>
  801884:	c7 44 24 0c 3c 2d 80 	movl   $0x802d3c,0xc(%esp)
  80188b:	00 
  80188c:	c7 44 24 08 43 2d 80 	movl   $0x802d43,0x8(%esp)
  801893:	00 
  801894:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80189b:	00 
  80189c:	c7 04 24 58 2d 80 00 	movl   $0x802d58,(%esp)
  8018a3:	e8 5e 0c 00 00       	call   802506 <_panic>
	assert(r <= PGSIZE);
  8018a8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018ad:	7e 24                	jle    8018d3 <devfile_read+0x84>
  8018af:	c7 44 24 0c 63 2d 80 	movl   $0x802d63,0xc(%esp)
  8018b6:	00 
  8018b7:	c7 44 24 08 43 2d 80 	movl   $0x802d43,0x8(%esp)
  8018be:	00 
  8018bf:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8018c6:	00 
  8018c7:	c7 04 24 58 2d 80 00 	movl   $0x802d58,(%esp)
  8018ce:	e8 33 0c 00 00       	call   802506 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018d7:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018de:	00 
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	89 04 24             	mov    %eax,(%esp)
  8018e5:	e8 1a f1 ff ff       	call   800a04 <memmove>
	return r;
}
  8018ea:	89 d8                	mov    %ebx,%eax
  8018ec:	83 c4 10             	add    $0x10,%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5e                   	pop    %esi
  8018f1:	5d                   	pop    %ebp
  8018f2:	c3                   	ret    

008018f3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
  8018f6:	53                   	push   %ebx
  8018f7:	83 ec 24             	sub    $0x24,%esp
  8018fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018fd:	89 1c 24             	mov    %ebx,(%esp)
  801900:	e8 2b ef ff ff       	call   800830 <strlen>
  801905:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80190a:	7f 60                	jg     80196c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80190c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190f:	89 04 24             	mov    %eax,(%esp)
  801912:	e8 20 f8 ff ff       	call   801137 <fd_alloc>
  801917:	89 c2                	mov    %eax,%edx
  801919:	85 d2                	test   %edx,%edx
  80191b:	78 54                	js     801971 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80191d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801921:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801928:	e8 3a ef ff ff       	call   800867 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80192d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801930:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801935:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801938:	b8 01 00 00 00       	mov    $0x1,%eax
  80193d:	e8 b1 fd ff ff       	call   8016f3 <fsipc>
  801942:	89 c3                	mov    %eax,%ebx
  801944:	85 c0                	test   %eax,%eax
  801946:	79 17                	jns    80195f <open+0x6c>
		fd_close(fd, 0);
  801948:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80194f:	00 
  801950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801953:	89 04 24             	mov    %eax,(%esp)
  801956:	e8 db f8 ff ff       	call   801236 <fd_close>
		return r;
  80195b:	89 d8                	mov    %ebx,%eax
  80195d:	eb 12                	jmp    801971 <open+0x7e>
	}

	return fd2num(fd);
  80195f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801962:	89 04 24             	mov    %eax,(%esp)
  801965:	e8 a6 f7 ff ff       	call   801110 <fd2num>
  80196a:	eb 05                	jmp    801971 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80196c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801971:	83 c4 24             	add    $0x24,%esp
  801974:	5b                   	pop    %ebx
  801975:	5d                   	pop    %ebp
  801976:	c3                   	ret    

00801977 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80197d:	ba 00 00 00 00       	mov    $0x0,%edx
  801982:	b8 08 00 00 00       	mov    $0x8,%eax
  801987:	e8 67 fd ff ff       	call   8016f3 <fsipc>
}
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	53                   	push   %ebx
  801992:	83 ec 14             	sub    $0x14,%esp
  801995:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801997:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80199b:	7e 31                	jle    8019ce <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80199d:	8b 40 04             	mov    0x4(%eax),%eax
  8019a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019a4:	8d 43 10             	lea    0x10(%ebx),%eax
  8019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ab:	8b 03                	mov    (%ebx),%eax
  8019ad:	89 04 24             	mov    %eax,(%esp)
  8019b0:	e8 42 fb ff ff       	call   8014f7 <write>
		if (result > 0)
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	7e 03                	jle    8019bc <writebuf+0x2e>
			b->result += result;
  8019b9:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019bc:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019bf:	74 0d                	je     8019ce <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c8:	0f 4f c2             	cmovg  %edx,%eax
  8019cb:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019ce:	83 c4 14             	add    $0x14,%esp
  8019d1:	5b                   	pop    %ebx
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <putch>:

static void
putch(int ch, void *thunk)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	53                   	push   %ebx
  8019d8:	83 ec 04             	sub    $0x4,%esp
  8019db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019de:	8b 53 04             	mov    0x4(%ebx),%edx
  8019e1:	8d 42 01             	lea    0x1(%edx),%eax
  8019e4:	89 43 04             	mov    %eax,0x4(%ebx)
  8019e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ea:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019ee:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019f3:	75 0e                	jne    801a03 <putch+0x2f>
		writebuf(b);
  8019f5:	89 d8                	mov    %ebx,%eax
  8019f7:	e8 92 ff ff ff       	call   80198e <writebuf>
		b->idx = 0;
  8019fc:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801a03:	83 c4 04             	add    $0x4,%esp
  801a06:	5b                   	pop    %ebx
  801a07:	5d                   	pop    %ebp
  801a08:	c3                   	ret    

00801a09 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801a12:	8b 45 08             	mov    0x8(%ebp),%eax
  801a15:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a1b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a22:	00 00 00 
	b.result = 0;
  801a25:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a2c:	00 00 00 
	b.error = 1;
  801a2f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a36:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a39:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a43:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a47:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a51:	c7 04 24 d4 19 80 00 	movl   $0x8019d4,(%esp)
  801a58:	e8 71 e9 ff ff       	call   8003ce <vprintfmt>
	if (b.idx > 0)
  801a5d:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a64:	7e 0b                	jle    801a71 <vfprintf+0x68>
		writebuf(&b);
  801a66:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a6c:	e8 1d ff ff ff       	call   80198e <writebuf>

	return (b.result ? b.result : b.error);
  801a71:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a77:	85 c0                	test   %eax,%eax
  801a79:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
  801a85:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a88:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	89 04 24             	mov    %eax,(%esp)
  801a9c:	e8 68 ff ff ff       	call   801a09 <vfprintf>
	va_end(ap);

	return cnt;
}
  801aa1:	c9                   	leave  
  801aa2:	c3                   	ret    

00801aa3 <printf>:

int
printf(const char *fmt, ...)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801aa9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801aac:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801abe:	e8 46 ff ff ff       	call   801a09 <vfprintf>
	va_end(ap);

	return cnt;
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    
  801ac5:	66 90                	xchg   %ax,%ax
  801ac7:	66 90                	xchg   %ax,%ax
  801ac9:	66 90                	xchg   %ax,%ax
  801acb:	66 90                	xchg   %ax,%ax
  801acd:	66 90                	xchg   %ax,%ax
  801acf:	90                   	nop

00801ad0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ad6:	c7 44 24 04 6f 2d 80 	movl   $0x802d6f,0x4(%esp)
  801add:	00 
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	89 04 24             	mov    %eax,(%esp)
  801ae4:	e8 7e ed ff ff       	call   800867 <strcpy>
	return 0;
}
  801ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	53                   	push   %ebx
  801af4:	83 ec 14             	sub    $0x14,%esp
  801af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801afa:	89 1c 24             	mov    %ebx,(%esp)
  801afd:	e8 5a 0b 00 00       	call   80265c <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801b07:	83 f8 01             	cmp    $0x1,%eax
  801b0a:	75 0d                	jne    801b19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801b0c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801b0f:	89 04 24             	mov    %eax,(%esp)
  801b12:	e8 29 03 00 00       	call   801e40 <nsipc_close>
  801b17:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801b19:	89 d0                	mov    %edx,%eax
  801b1b:	83 c4 14             	add    $0x14,%esp
  801b1e:	5b                   	pop    %ebx
  801b1f:	5d                   	pop    %ebp
  801b20:	c3                   	ret    

00801b21 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b2e:	00 
  801b2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	8b 40 0c             	mov    0xc(%eax),%eax
  801b43:	89 04 24             	mov    %eax,(%esp)
  801b46:	e8 f0 03 00 00       	call   801f3b <nsipc_send>
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b5a:	00 
  801b5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6f:	89 04 24             	mov    %eax,(%esp)
  801b72:	e8 44 03 00 00       	call   801ebb <nsipc_recv>
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b7f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b82:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b86:	89 04 24             	mov    %eax,(%esp)
  801b89:	e8 f8 f5 ff ff       	call   801186 <fd_lookup>
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 17                	js     801ba9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b95:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b9b:	39 08                	cmp    %ecx,(%eax)
  801b9d:	75 05                	jne    801ba4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba2:	eb 05                	jmp    801ba9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ba4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	56                   	push   %esi
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 20             	sub    $0x20,%esp
  801bb3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801bb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb8:	89 04 24             	mov    %eax,(%esp)
  801bbb:	e8 77 f5 ff ff       	call   801137 <fd_alloc>
  801bc0:	89 c3                	mov    %eax,%ebx
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	78 21                	js     801be7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bc6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bcd:	00 
  801bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdc:	e8 a2 f0 ff ff       	call   800c83 <sys_page_alloc>
  801be1:	89 c3                	mov    %eax,%ebx
  801be3:	85 c0                	test   %eax,%eax
  801be5:	79 0c                	jns    801bf3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801be7:	89 34 24             	mov    %esi,(%esp)
  801bea:	e8 51 02 00 00       	call   801e40 <nsipc_close>
		return r;
  801bef:	89 d8                	mov    %ebx,%eax
  801bf1:	eb 20                	jmp    801c13 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801bf3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c01:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801c08:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801c0b:	89 14 24             	mov    %edx,(%esp)
  801c0e:	e8 fd f4 ff ff       	call   801110 <fd2num>
}
  801c13:	83 c4 20             	add    $0x20,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5d                   	pop    %ebp
  801c19:	c3                   	ret    

00801c1a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	e8 51 ff ff ff       	call   801b79 <fd2sockid>
		return r;
  801c28:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	78 23                	js     801c51 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c2e:	8b 55 10             	mov    0x10(%ebp),%edx
  801c31:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c38:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c3c:	89 04 24             	mov    %eax,(%esp)
  801c3f:	e8 45 01 00 00       	call   801d89 <nsipc_accept>
		return r;
  801c44:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c46:	85 c0                	test   %eax,%eax
  801c48:	78 07                	js     801c51 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801c4a:	e8 5c ff ff ff       	call   801bab <alloc_sockfd>
  801c4f:	89 c1                	mov    %eax,%ecx
}
  801c51:	89 c8                	mov    %ecx,%eax
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	e8 16 ff ff ff       	call   801b79 <fd2sockid>
  801c63:	89 c2                	mov    %eax,%edx
  801c65:	85 d2                	test   %edx,%edx
  801c67:	78 16                	js     801c7f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801c69:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c77:	89 14 24             	mov    %edx,(%esp)
  801c7a:	e8 60 01 00 00       	call   801ddf <nsipc_bind>
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <shutdown>:

int
shutdown(int s, int how)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	e8 ea fe ff ff       	call   801b79 <fd2sockid>
  801c8f:	89 c2                	mov    %eax,%edx
  801c91:	85 d2                	test   %edx,%edx
  801c93:	78 0f                	js     801ca4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9c:	89 14 24             	mov    %edx,(%esp)
  801c9f:	e8 7a 01 00 00       	call   801e1e <nsipc_shutdown>
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	e8 c5 fe ff ff       	call   801b79 <fd2sockid>
  801cb4:	89 c2                	mov    %eax,%edx
  801cb6:	85 d2                	test   %edx,%edx
  801cb8:	78 16                	js     801cd0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801cba:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc8:	89 14 24             	mov    %edx,(%esp)
  801ccb:	e8 8a 01 00 00       	call   801e5a <nsipc_connect>
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <listen>:

int
listen(int s, int backlog)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	e8 99 fe ff ff       	call   801b79 <fd2sockid>
  801ce0:	89 c2                	mov    %eax,%edx
  801ce2:	85 d2                	test   %edx,%edx
  801ce4:	78 0f                	js     801cf5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ced:	89 14 24             	mov    %edx,(%esp)
  801cf0:	e8 a4 01 00 00       	call   801e99 <nsipc_listen>
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  801d00:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	89 04 24             	mov    %eax,(%esp)
  801d11:	e8 98 02 00 00       	call   801fae <nsipc_socket>
  801d16:	89 c2                	mov    %eax,%edx
  801d18:	85 d2                	test   %edx,%edx
  801d1a:	78 05                	js     801d21 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801d1c:	e8 8a fe ff ff       	call   801bab <alloc_sockfd>
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	53                   	push   %ebx
  801d27:	83 ec 14             	sub    $0x14,%esp
  801d2a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d2c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d33:	75 11                	jne    801d46 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801d3c:	e8 e3 08 00 00       	call   802624 <ipc_find_env>
  801d41:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d46:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d4d:	00 
  801d4e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d55:	00 
  801d56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d5a:	a1 04 40 80 00       	mov    0x804004,%eax
  801d5f:	89 04 24             	mov    %eax,(%esp)
  801d62:	e8 5f 08 00 00       	call   8025c6 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d6e:	00 
  801d6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d76:	00 
  801d77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d7e:	e8 d9 07 00 00       	call   80255c <ipc_recv>
}
  801d83:	83 c4 14             	add    $0x14,%esp
  801d86:	5b                   	pop    %ebx
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    

00801d89 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	56                   	push   %esi
  801d8d:	53                   	push   %ebx
  801d8e:	83 ec 10             	sub    $0x10,%esp
  801d91:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d9c:	8b 06                	mov    (%esi),%eax
  801d9e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801da3:	b8 01 00 00 00       	mov    $0x1,%eax
  801da8:	e8 76 ff ff ff       	call   801d23 <nsipc>
  801dad:	89 c3                	mov    %eax,%ebx
  801daf:	85 c0                	test   %eax,%eax
  801db1:	78 23                	js     801dd6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801db3:	a1 10 60 80 00       	mov    0x806010,%eax
  801db8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dbc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dc3:	00 
  801dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc7:	89 04 24             	mov    %eax,(%esp)
  801dca:	e8 35 ec ff ff       	call   800a04 <memmove>
		*addrlen = ret->ret_addrlen;
  801dcf:	a1 10 60 80 00       	mov    0x806010,%eax
  801dd4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801dd6:	89 d8                	mov    %ebx,%eax
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5d                   	pop    %ebp
  801dde:	c3                   	ret    

00801ddf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	53                   	push   %ebx
  801de3:	83 ec 14             	sub    $0x14,%esp
  801de6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801df1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801e03:	e8 fc eb ff ff       	call   800a04 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e08:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e0e:	b8 02 00 00 00       	mov    $0x2,%eax
  801e13:	e8 0b ff ff ff       	call   801d23 <nsipc>
}
  801e18:	83 c4 14             	add    $0x14,%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5d                   	pop    %ebp
  801e1d:	c3                   	ret    

00801e1e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e34:	b8 03 00 00 00       	mov    $0x3,%eax
  801e39:	e8 e5 fe ff ff       	call   801d23 <nsipc>
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <nsipc_close>:

int
nsipc_close(int s)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e4e:	b8 04 00 00 00       	mov    $0x4,%eax
  801e53:	e8 cb fe ff ff       	call   801d23 <nsipc>
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	53                   	push   %ebx
  801e5e:	83 ec 14             	sub    $0x14,%esp
  801e61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e77:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801e7e:	e8 81 eb ff ff       	call   800a04 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e83:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e89:	b8 05 00 00 00       	mov    $0x5,%eax
  801e8e:	e8 90 fe ff ff       	call   801d23 <nsipc>
}
  801e93:	83 c4 14             	add    $0x14,%esp
  801e96:	5b                   	pop    %ebx
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    

00801e99 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eaa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801eaf:	b8 06 00 00 00       	mov    $0x6,%eax
  801eb4:	e8 6a fe ff ff       	call   801d23 <nsipc>
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	56                   	push   %esi
  801ebf:	53                   	push   %ebx
  801ec0:	83 ec 10             	sub    $0x10,%esp
  801ec3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ece:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801edc:	b8 07 00 00 00       	mov    $0x7,%eax
  801ee1:	e8 3d fe ff ff       	call   801d23 <nsipc>
  801ee6:	89 c3                	mov    %eax,%ebx
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	78 46                	js     801f32 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801eec:	39 f0                	cmp    %esi,%eax
  801eee:	7f 07                	jg     801ef7 <nsipc_recv+0x3c>
  801ef0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ef5:	7e 24                	jle    801f1b <nsipc_recv+0x60>
  801ef7:	c7 44 24 0c 7b 2d 80 	movl   $0x802d7b,0xc(%esp)
  801efe:	00 
  801eff:	c7 44 24 08 43 2d 80 	movl   $0x802d43,0x8(%esp)
  801f06:	00 
  801f07:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801f0e:	00 
  801f0f:	c7 04 24 90 2d 80 00 	movl   $0x802d90,(%esp)
  801f16:	e8 eb 05 00 00       	call   802506 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f26:	00 
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	89 04 24             	mov    %eax,(%esp)
  801f2d:	e8 d2 ea ff ff       	call   800a04 <memmove>
	}

	return r;
}
  801f32:	89 d8                	mov    %ebx,%eax
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    

00801f3b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	53                   	push   %ebx
  801f3f:	83 ec 14             	sub    $0x14,%esp
  801f42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f4d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f53:	7e 24                	jle    801f79 <nsipc_send+0x3e>
  801f55:	c7 44 24 0c 9c 2d 80 	movl   $0x802d9c,0xc(%esp)
  801f5c:	00 
  801f5d:	c7 44 24 08 43 2d 80 	movl   $0x802d43,0x8(%esp)
  801f64:	00 
  801f65:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801f6c:	00 
  801f6d:	c7 04 24 90 2d 80 00 	movl   $0x802d90,(%esp)
  801f74:	e8 8d 05 00 00       	call   802506 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f79:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f84:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801f8b:	e8 74 ea ff ff       	call   800a04 <memmove>
	nsipcbuf.send.req_size = size;
  801f90:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f96:	8b 45 14             	mov    0x14(%ebp),%eax
  801f99:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f9e:	b8 08 00 00 00       	mov    $0x8,%eax
  801fa3:	e8 7b fd ff ff       	call   801d23 <nsipc>
}
  801fa8:	83 c4 14             	add    $0x14,%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5d                   	pop    %ebp
  801fad:	c3                   	ret    

00801fae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801fcc:	b8 09 00 00 00       	mov    $0x9,%eax
  801fd1:	e8 4d fd ff ff       	call   801d23 <nsipc>
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	56                   	push   %esi
  801fdc:	53                   	push   %ebx
  801fdd:	83 ec 10             	sub    $0x10,%esp
  801fe0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	89 04 24             	mov    %eax,(%esp)
  801fe9:	e8 32 f1 ff ff       	call   801120 <fd2data>
  801fee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ff0:	c7 44 24 04 a8 2d 80 	movl   $0x802da8,0x4(%esp)
  801ff7:	00 
  801ff8:	89 1c 24             	mov    %ebx,(%esp)
  801ffb:	e8 67 e8 ff ff       	call   800867 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802000:	8b 46 04             	mov    0x4(%esi),%eax
  802003:	2b 06                	sub    (%esi),%eax
  802005:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80200b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802012:	00 00 00 
	stat->st_dev = &devpipe;
  802015:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80201c:	30 80 00 
	return 0;
}
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	5b                   	pop    %ebx
  802028:	5e                   	pop    %esi
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    

0080202b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	53                   	push   %ebx
  80202f:	83 ec 14             	sub    $0x14,%esp
  802032:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802035:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802039:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802040:	e8 e5 ec ff ff       	call   800d2a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802045:	89 1c 24             	mov    %ebx,(%esp)
  802048:	e8 d3 f0 ff ff       	call   801120 <fd2data>
  80204d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802051:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802058:	e8 cd ec ff ff       	call   800d2a <sys_page_unmap>
}
  80205d:	83 c4 14             	add    $0x14,%esp
  802060:	5b                   	pop    %ebx
  802061:	5d                   	pop    %ebp
  802062:	c3                   	ret    

00802063 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	57                   	push   %edi
  802067:	56                   	push   %esi
  802068:	53                   	push   %ebx
  802069:	83 ec 2c             	sub    $0x2c,%esp
  80206c:	89 c6                	mov    %eax,%esi
  80206e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802071:	a1 08 40 80 00       	mov    0x804008,%eax
  802076:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802079:	89 34 24             	mov    %esi,(%esp)
  80207c:	e8 db 05 00 00       	call   80265c <pageref>
  802081:	89 c7                	mov    %eax,%edi
  802083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802086:	89 04 24             	mov    %eax,(%esp)
  802089:	e8 ce 05 00 00       	call   80265c <pageref>
  80208e:	39 c7                	cmp    %eax,%edi
  802090:	0f 94 c2             	sete   %dl
  802093:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802096:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80209c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80209f:	39 fb                	cmp    %edi,%ebx
  8020a1:	74 21                	je     8020c4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8020a3:	84 d2                	test   %dl,%dl
  8020a5:	74 ca                	je     802071 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020a7:	8b 51 58             	mov    0x58(%ecx),%edx
  8020aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020b6:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  8020bd:	e8 7e e1 ff ff       	call   800240 <cprintf>
  8020c2:	eb ad                	jmp    802071 <_pipeisclosed+0xe>
	}
}
  8020c4:	83 c4 2c             	add    $0x2c,%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    

008020cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	57                   	push   %edi
  8020d0:	56                   	push   %esi
  8020d1:	53                   	push   %ebx
  8020d2:	83 ec 1c             	sub    $0x1c,%esp
  8020d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8020d8:	89 34 24             	mov    %esi,(%esp)
  8020db:	e8 40 f0 ff ff       	call   801120 <fd2data>
  8020e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e7:	eb 45                	jmp    80212e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8020e9:	89 da                	mov    %ebx,%edx
  8020eb:	89 f0                	mov    %esi,%eax
  8020ed:	e8 71 ff ff ff       	call   802063 <_pipeisclosed>
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	75 41                	jne    802137 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8020f6:	e8 69 eb ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8020fe:	8b 0b                	mov    (%ebx),%ecx
  802100:	8d 51 20             	lea    0x20(%ecx),%edx
  802103:	39 d0                	cmp    %edx,%eax
  802105:	73 e2                	jae    8020e9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80210a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80210e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802111:	99                   	cltd   
  802112:	c1 ea 1b             	shr    $0x1b,%edx
  802115:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802118:	83 e1 1f             	and    $0x1f,%ecx
  80211b:	29 d1                	sub    %edx,%ecx
  80211d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802121:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802125:	83 c0 01             	add    $0x1,%eax
  802128:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80212b:	83 c7 01             	add    $0x1,%edi
  80212e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802131:	75 c8                	jne    8020fb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802133:	89 f8                	mov    %edi,%eax
  802135:	eb 05                	jmp    80213c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80213c:	83 c4 1c             	add    $0x1c,%esp
  80213f:	5b                   	pop    %ebx
  802140:	5e                   	pop    %esi
  802141:	5f                   	pop    %edi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    

00802144 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	57                   	push   %edi
  802148:	56                   	push   %esi
  802149:	53                   	push   %ebx
  80214a:	83 ec 1c             	sub    $0x1c,%esp
  80214d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802150:	89 3c 24             	mov    %edi,(%esp)
  802153:	e8 c8 ef ff ff       	call   801120 <fd2data>
  802158:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80215a:	be 00 00 00 00       	mov    $0x0,%esi
  80215f:	eb 3d                	jmp    80219e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802161:	85 f6                	test   %esi,%esi
  802163:	74 04                	je     802169 <devpipe_read+0x25>
				return i;
  802165:	89 f0                	mov    %esi,%eax
  802167:	eb 43                	jmp    8021ac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802169:	89 da                	mov    %ebx,%edx
  80216b:	89 f8                	mov    %edi,%eax
  80216d:	e8 f1 fe ff ff       	call   802063 <_pipeisclosed>
  802172:	85 c0                	test   %eax,%eax
  802174:	75 31                	jne    8021a7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802176:	e8 e9 ea ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80217b:	8b 03                	mov    (%ebx),%eax
  80217d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802180:	74 df                	je     802161 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802182:	99                   	cltd   
  802183:	c1 ea 1b             	shr    $0x1b,%edx
  802186:	01 d0                	add    %edx,%eax
  802188:	83 e0 1f             	and    $0x1f,%eax
  80218b:	29 d0                	sub    %edx,%eax
  80218d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802192:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802195:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802198:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80219b:	83 c6 01             	add    $0x1,%esi
  80219e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a1:	75 d8                	jne    80217b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8021a3:	89 f0                	mov    %esi,%eax
  8021a5:	eb 05                	jmp    8021ac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8021ac:	83 c4 1c             	add    $0x1c,%esp
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5f                   	pop    %edi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    

008021b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	56                   	push   %esi
  8021b8:	53                   	push   %ebx
  8021b9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021bf:	89 04 24             	mov    %eax,(%esp)
  8021c2:	e8 70 ef ff ff       	call   801137 <fd_alloc>
  8021c7:	89 c2                	mov    %eax,%edx
  8021c9:	85 d2                	test   %edx,%edx
  8021cb:	0f 88 4d 01 00 00    	js     80231e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021d1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021d8:	00 
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e7:	e8 97 ea ff ff       	call   800c83 <sys_page_alloc>
  8021ec:	89 c2                	mov    %eax,%edx
  8021ee:	85 d2                	test   %edx,%edx
  8021f0:	0f 88 28 01 00 00    	js     80231e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8021f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021f9:	89 04 24             	mov    %eax,(%esp)
  8021fc:	e8 36 ef ff ff       	call   801137 <fd_alloc>
  802201:	89 c3                	mov    %eax,%ebx
  802203:	85 c0                	test   %eax,%eax
  802205:	0f 88 fe 00 00 00    	js     802309 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80220b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802212:	00 
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802221:	e8 5d ea ff ff       	call   800c83 <sys_page_alloc>
  802226:	89 c3                	mov    %eax,%ebx
  802228:	85 c0                	test   %eax,%eax
  80222a:	0f 88 d9 00 00 00    	js     802309 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	89 04 24             	mov    %eax,(%esp)
  802236:	e8 e5 ee ff ff       	call   801120 <fd2data>
  80223b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80223d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802244:	00 
  802245:	89 44 24 04          	mov    %eax,0x4(%esp)
  802249:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802250:	e8 2e ea ff ff       	call   800c83 <sys_page_alloc>
  802255:	89 c3                	mov    %eax,%ebx
  802257:	85 c0                	test   %eax,%eax
  802259:	0f 88 97 00 00 00    	js     8022f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80225f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802262:	89 04 24             	mov    %eax,(%esp)
  802265:	e8 b6 ee ff ff       	call   801120 <fd2data>
  80226a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802271:	00 
  802272:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802276:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80227d:	00 
  80227e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802282:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802289:	e8 49 ea ff ff       	call   800cd7 <sys_page_map>
  80228e:	89 c3                	mov    %eax,%ebx
  802290:	85 c0                	test   %eax,%eax
  802292:	78 52                	js     8022e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802294:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8022a9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	89 04 24             	mov    %eax,(%esp)
  8022c4:	e8 47 ee ff ff       	call   801110 <fd2num>
  8022c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d1:	89 04 24             	mov    %eax,(%esp)
  8022d4:	e8 37 ee ff ff       	call   801110 <fd2num>
  8022d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022df:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e4:	eb 38                	jmp    80231e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8022e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f1:	e8 34 ea ff ff       	call   800d2a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802304:	e8 21 ea ff ff       	call   800d2a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802310:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802317:	e8 0e ea ff ff       	call   800d2a <sys_page_unmap>
  80231c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80231e:	83 c4 30             	add    $0x30,%esp
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5d                   	pop    %ebp
  802324:	c3                   	ret    

00802325 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80232b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	89 04 24             	mov    %eax,(%esp)
  802338:	e8 49 ee ff ff       	call   801186 <fd_lookup>
  80233d:	89 c2                	mov    %eax,%edx
  80233f:	85 d2                	test   %edx,%edx
  802341:	78 15                	js     802358 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	89 04 24             	mov    %eax,(%esp)
  802349:	e8 d2 ed ff ff       	call   801120 <fd2data>
	return _pipeisclosed(fd, p);
  80234e:	89 c2                	mov    %eax,%edx
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	e8 0b fd ff ff       	call   802063 <_pipeisclosed>
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    
  80235a:	66 90                	xchg   %ax,%ax
  80235c:	66 90                	xchg   %ax,%ax
  80235e:	66 90                	xchg   %ax,%ax

00802360 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    

0080236a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802370:	c7 44 24 04 c7 2d 80 	movl   $0x802dc7,0x4(%esp)
  802377:	00 
  802378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237b:	89 04 24             	mov    %eax,(%esp)
  80237e:	e8 e4 e4 ff ff       	call   800867 <strcpy>
	return 0;
}
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	57                   	push   %edi
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802396:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80239b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023a1:	eb 31                	jmp    8023d4 <devcons_write+0x4a>
		m = n - tot;
  8023a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8023a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8023a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8023ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8023b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023b7:	03 45 0c             	add    0xc(%ebp),%eax
  8023ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023be:	89 3c 24             	mov    %edi,(%esp)
  8023c1:	e8 3e e6 ff ff       	call   800a04 <memmove>
		sys_cputs(buf, m);
  8023c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023ca:	89 3c 24             	mov    %edi,(%esp)
  8023cd:	e8 e4 e7 ff ff       	call   800bb6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023d2:	01 f3                	add    %esi,%ebx
  8023d4:	89 d8                	mov    %ebx,%eax
  8023d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8023d9:	72 c8                	jb     8023a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8023db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    

008023e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8023f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023f5:	75 07                	jne    8023fe <devcons_read+0x18>
  8023f7:	eb 2a                	jmp    802423 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8023f9:	e8 66 e8 ff ff       	call   800c64 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8023fe:	66 90                	xchg   %ax,%ax
  802400:	e8 cf e7 ff ff       	call   800bd4 <sys_cgetc>
  802405:	85 c0                	test   %eax,%eax
  802407:	74 f0                	je     8023f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802409:	85 c0                	test   %eax,%eax
  80240b:	78 16                	js     802423 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80240d:	83 f8 04             	cmp    $0x4,%eax
  802410:	74 0c                	je     80241e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802412:	8b 55 0c             	mov    0xc(%ebp),%edx
  802415:	88 02                	mov    %al,(%edx)
	return 1;
  802417:	b8 01 00 00 00       	mov    $0x1,%eax
  80241c:	eb 05                	jmp    802423 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80241e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
  802428:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802431:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802438:	00 
  802439:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80243c:	89 04 24             	mov    %eax,(%esp)
  80243f:	e8 72 e7 ff ff       	call   800bb6 <sys_cputs>
}
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <getchar>:

int
getchar(void)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
  802449:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80244c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802453:	00 
  802454:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802462:	e8 b3 ef ff ff       	call   80141a <read>
	if (r < 0)
  802467:	85 c0                	test   %eax,%eax
  802469:	78 0f                	js     80247a <getchar+0x34>
		return r;
	if (r < 1)
  80246b:	85 c0                	test   %eax,%eax
  80246d:	7e 06                	jle    802475 <getchar+0x2f>
		return -E_EOF;
	return c;
  80246f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802473:	eb 05                	jmp    80247a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802475:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802485:	89 44 24 04          	mov    %eax,0x4(%esp)
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	89 04 24             	mov    %eax,(%esp)
  80248f:	e8 f2 ec ff ff       	call   801186 <fd_lookup>
  802494:	85 c0                	test   %eax,%eax
  802496:	78 11                	js     8024a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024a1:	39 10                	cmp    %edx,(%eax)
  8024a3:	0f 94 c0             	sete   %al
  8024a6:	0f b6 c0             	movzbl %al,%eax
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <opencons>:

int
opencons(void)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b4:	89 04 24             	mov    %eax,(%esp)
  8024b7:	e8 7b ec ff ff       	call   801137 <fd_alloc>
		return r;
  8024bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	78 40                	js     802502 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024c9:	00 
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d8:	e8 a6 e7 ff ff       	call   800c83 <sys_page_alloc>
		return r;
  8024dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	78 1f                	js     802502 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8024e3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024f8:	89 04 24             	mov    %eax,(%esp)
  8024fb:	e8 10 ec ff ff       	call   801110 <fd2num>
  802500:	89 c2                	mov    %eax,%edx
}
  802502:	89 d0                	mov    %edx,%eax
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	56                   	push   %esi
  80250a:	53                   	push   %ebx
  80250b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80250e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802511:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802517:	e8 29 e7 ff ff       	call   800c45 <sys_getenvid>
  80251c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80251f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802523:	8b 55 08             	mov    0x8(%ebp),%edx
  802526:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80252a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80252e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802532:	c7 04 24 d4 2d 80 00 	movl   $0x802dd4,(%esp)
  802539:	e8 02 dd ff ff       	call   800240 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80253e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802542:	8b 45 10             	mov    0x10(%ebp),%eax
  802545:	89 04 24             	mov    %eax,(%esp)
  802548:	e8 92 dc ff ff       	call   8001df <vcprintf>
	cprintf("\n");
  80254d:	c7 04 24 50 29 80 00 	movl   $0x802950,(%esp)
  802554:	e8 e7 dc ff ff       	call   800240 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802559:	cc                   	int3   
  80255a:	eb fd                	jmp    802559 <_panic+0x53>

0080255c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80255c:	55                   	push   %ebp
  80255d:	89 e5                	mov    %esp,%ebp
  80255f:	56                   	push   %esi
  802560:	53                   	push   %ebx
  802561:	83 ec 10             	sub    $0x10,%esp
  802564:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256a:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80256d:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  80256f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802574:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802577:	89 04 24             	mov    %eax,(%esp)
  80257a:	e8 1a e9 ff ff       	call   800e99 <sys_ipc_recv>
  80257f:	85 c0                	test   %eax,%eax
  802581:	75 1e                	jne    8025a1 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802583:	85 db                	test   %ebx,%ebx
  802585:	74 0a                	je     802591 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802587:	a1 08 40 80 00       	mov    0x804008,%eax
  80258c:	8b 40 74             	mov    0x74(%eax),%eax
  80258f:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802591:	85 f6                	test   %esi,%esi
  802593:	74 22                	je     8025b7 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802595:	a1 08 40 80 00       	mov    0x804008,%eax
  80259a:	8b 40 78             	mov    0x78(%eax),%eax
  80259d:	89 06                	mov    %eax,(%esi)
  80259f:	eb 16                	jmp    8025b7 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8025a1:	85 f6                	test   %esi,%esi
  8025a3:	74 06                	je     8025ab <ipc_recv+0x4f>
				*perm_store = 0;
  8025a5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8025ab:	85 db                	test   %ebx,%ebx
  8025ad:	74 10                	je     8025bf <ipc_recv+0x63>
				*from_env_store=0;
  8025af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8025b5:	eb 08                	jmp    8025bf <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8025b7:	a1 08 40 80 00       	mov    0x804008,%eax
  8025bc:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8025bf:	83 c4 10             	add    $0x10,%esp
  8025c2:	5b                   	pop    %ebx
  8025c3:	5e                   	pop    %esi
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    

008025c6 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
  8025c9:	57                   	push   %edi
  8025ca:	56                   	push   %esi
  8025cb:	53                   	push   %ebx
  8025cc:	83 ec 1c             	sub    $0x1c,%esp
  8025cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  8025d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025d5:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8025d8:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8025da:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8025df:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8025e2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025e6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	89 04 24             	mov    %eax,(%esp)
  8025f4:	e8 7d e8 ff ff       	call   800e76 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8025f9:	eb 1c                	jmp    802617 <ipc_send+0x51>
	{
		sys_yield();
  8025fb:	e8 64 e6 ff ff       	call   800c64 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802600:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802604:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802608:	89 74 24 04          	mov    %esi,0x4(%esp)
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	89 04 24             	mov    %eax,(%esp)
  802612:	e8 5f e8 ff ff       	call   800e76 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802617:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80261a:	74 df                	je     8025fb <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  80261c:	83 c4 1c             	add    $0x1c,%esp
  80261f:	5b                   	pop    %ebx
  802620:	5e                   	pop    %esi
  802621:	5f                   	pop    %edi
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    

00802624 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80262a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80262f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802632:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802638:	8b 52 50             	mov    0x50(%edx),%edx
  80263b:	39 ca                	cmp    %ecx,%edx
  80263d:	75 0d                	jne    80264c <ipc_find_env+0x28>
			return envs[i].env_id;
  80263f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802642:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802647:	8b 40 40             	mov    0x40(%eax),%eax
  80264a:	eb 0e                	jmp    80265a <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80264c:	83 c0 01             	add    $0x1,%eax
  80264f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802654:	75 d9                	jne    80262f <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802656:	66 b8 00 00          	mov    $0x0,%ax
}
  80265a:	5d                   	pop    %ebp
  80265b:	c3                   	ret    

0080265c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802662:	89 d0                	mov    %edx,%eax
  802664:	c1 e8 16             	shr    $0x16,%eax
  802667:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802673:	f6 c1 01             	test   $0x1,%cl
  802676:	74 1d                	je     802695 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802678:	c1 ea 0c             	shr    $0xc,%edx
  80267b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802682:	f6 c2 01             	test   $0x1,%dl
  802685:	74 0e                	je     802695 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802687:	c1 ea 0c             	shr    $0xc,%edx
  80268a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802691:	ef 
  802692:	0f b7 c0             	movzwl %ax,%eax
}
  802695:	5d                   	pop    %ebp
  802696:	c3                   	ret    
  802697:	66 90                	xchg   %ax,%ax
  802699:	66 90                	xchg   %ax,%ax
  80269b:	66 90                	xchg   %ax,%ax
  80269d:	66 90                	xchg   %ax,%ax
  80269f:	90                   	nop

008026a0 <__udivdi3>:
  8026a0:	55                   	push   %ebp
  8026a1:	57                   	push   %edi
  8026a2:	56                   	push   %esi
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026aa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8026ae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8026b2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8026bc:	89 ea                	mov    %ebp,%edx
  8026be:	89 0c 24             	mov    %ecx,(%esp)
  8026c1:	75 2d                	jne    8026f0 <__udivdi3+0x50>
  8026c3:	39 e9                	cmp    %ebp,%ecx
  8026c5:	77 61                	ja     802728 <__udivdi3+0x88>
  8026c7:	85 c9                	test   %ecx,%ecx
  8026c9:	89 ce                	mov    %ecx,%esi
  8026cb:	75 0b                	jne    8026d8 <__udivdi3+0x38>
  8026cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d2:	31 d2                	xor    %edx,%edx
  8026d4:	f7 f1                	div    %ecx
  8026d6:	89 c6                	mov    %eax,%esi
  8026d8:	31 d2                	xor    %edx,%edx
  8026da:	89 e8                	mov    %ebp,%eax
  8026dc:	f7 f6                	div    %esi
  8026de:	89 c5                	mov    %eax,%ebp
  8026e0:	89 f8                	mov    %edi,%eax
  8026e2:	f7 f6                	div    %esi
  8026e4:	89 ea                	mov    %ebp,%edx
  8026e6:	83 c4 0c             	add    $0xc,%esp
  8026e9:	5e                   	pop    %esi
  8026ea:	5f                   	pop    %edi
  8026eb:	5d                   	pop    %ebp
  8026ec:	c3                   	ret    
  8026ed:	8d 76 00             	lea    0x0(%esi),%esi
  8026f0:	39 e8                	cmp    %ebp,%eax
  8026f2:	77 24                	ja     802718 <__udivdi3+0x78>
  8026f4:	0f bd e8             	bsr    %eax,%ebp
  8026f7:	83 f5 1f             	xor    $0x1f,%ebp
  8026fa:	75 3c                	jne    802738 <__udivdi3+0x98>
  8026fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802700:	39 34 24             	cmp    %esi,(%esp)
  802703:	0f 86 9f 00 00 00    	jbe    8027a8 <__udivdi3+0x108>
  802709:	39 d0                	cmp    %edx,%eax
  80270b:	0f 82 97 00 00 00    	jb     8027a8 <__udivdi3+0x108>
  802711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802718:	31 d2                	xor    %edx,%edx
  80271a:	31 c0                	xor    %eax,%eax
  80271c:	83 c4 0c             	add    $0xc,%esp
  80271f:	5e                   	pop    %esi
  802720:	5f                   	pop    %edi
  802721:	5d                   	pop    %ebp
  802722:	c3                   	ret    
  802723:	90                   	nop
  802724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802728:	89 f8                	mov    %edi,%eax
  80272a:	f7 f1                	div    %ecx
  80272c:	31 d2                	xor    %edx,%edx
  80272e:	83 c4 0c             	add    $0xc,%esp
  802731:	5e                   	pop    %esi
  802732:	5f                   	pop    %edi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    
  802735:	8d 76 00             	lea    0x0(%esi),%esi
  802738:	89 e9                	mov    %ebp,%ecx
  80273a:	8b 3c 24             	mov    (%esp),%edi
  80273d:	d3 e0                	shl    %cl,%eax
  80273f:	89 c6                	mov    %eax,%esi
  802741:	b8 20 00 00 00       	mov    $0x20,%eax
  802746:	29 e8                	sub    %ebp,%eax
  802748:	89 c1                	mov    %eax,%ecx
  80274a:	d3 ef                	shr    %cl,%edi
  80274c:	89 e9                	mov    %ebp,%ecx
  80274e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802752:	8b 3c 24             	mov    (%esp),%edi
  802755:	09 74 24 08          	or     %esi,0x8(%esp)
  802759:	89 d6                	mov    %edx,%esi
  80275b:	d3 e7                	shl    %cl,%edi
  80275d:	89 c1                	mov    %eax,%ecx
  80275f:	89 3c 24             	mov    %edi,(%esp)
  802762:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802766:	d3 ee                	shr    %cl,%esi
  802768:	89 e9                	mov    %ebp,%ecx
  80276a:	d3 e2                	shl    %cl,%edx
  80276c:	89 c1                	mov    %eax,%ecx
  80276e:	d3 ef                	shr    %cl,%edi
  802770:	09 d7                	or     %edx,%edi
  802772:	89 f2                	mov    %esi,%edx
  802774:	89 f8                	mov    %edi,%eax
  802776:	f7 74 24 08          	divl   0x8(%esp)
  80277a:	89 d6                	mov    %edx,%esi
  80277c:	89 c7                	mov    %eax,%edi
  80277e:	f7 24 24             	mull   (%esp)
  802781:	39 d6                	cmp    %edx,%esi
  802783:	89 14 24             	mov    %edx,(%esp)
  802786:	72 30                	jb     8027b8 <__udivdi3+0x118>
  802788:	8b 54 24 04          	mov    0x4(%esp),%edx
  80278c:	89 e9                	mov    %ebp,%ecx
  80278e:	d3 e2                	shl    %cl,%edx
  802790:	39 c2                	cmp    %eax,%edx
  802792:	73 05                	jae    802799 <__udivdi3+0xf9>
  802794:	3b 34 24             	cmp    (%esp),%esi
  802797:	74 1f                	je     8027b8 <__udivdi3+0x118>
  802799:	89 f8                	mov    %edi,%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	e9 7a ff ff ff       	jmp    80271c <__udivdi3+0x7c>
  8027a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027a8:	31 d2                	xor    %edx,%edx
  8027aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8027af:	e9 68 ff ff ff       	jmp    80271c <__udivdi3+0x7c>
  8027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027b8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8027bb:	31 d2                	xor    %edx,%edx
  8027bd:	83 c4 0c             	add    $0xc,%esp
  8027c0:	5e                   	pop    %esi
  8027c1:	5f                   	pop    %edi
  8027c2:	5d                   	pop    %ebp
  8027c3:	c3                   	ret    
  8027c4:	66 90                	xchg   %ax,%ax
  8027c6:	66 90                	xchg   %ax,%ax
  8027c8:	66 90                	xchg   %ax,%ax
  8027ca:	66 90                	xchg   %ax,%ax
  8027cc:	66 90                	xchg   %ax,%ax
  8027ce:	66 90                	xchg   %ax,%ax

008027d0 <__umoddi3>:
  8027d0:	55                   	push   %ebp
  8027d1:	57                   	push   %edi
  8027d2:	56                   	push   %esi
  8027d3:	83 ec 14             	sub    $0x14,%esp
  8027d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027da:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027de:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8027e2:	89 c7                	mov    %eax,%edi
  8027e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8027ec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8027f0:	89 34 24             	mov    %esi,(%esp)
  8027f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	89 c2                	mov    %eax,%edx
  8027fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027ff:	75 17                	jne    802818 <__umoddi3+0x48>
  802801:	39 fe                	cmp    %edi,%esi
  802803:	76 4b                	jbe    802850 <__umoddi3+0x80>
  802805:	89 c8                	mov    %ecx,%eax
  802807:	89 fa                	mov    %edi,%edx
  802809:	f7 f6                	div    %esi
  80280b:	89 d0                	mov    %edx,%eax
  80280d:	31 d2                	xor    %edx,%edx
  80280f:	83 c4 14             	add    $0x14,%esp
  802812:	5e                   	pop    %esi
  802813:	5f                   	pop    %edi
  802814:	5d                   	pop    %ebp
  802815:	c3                   	ret    
  802816:	66 90                	xchg   %ax,%ax
  802818:	39 f8                	cmp    %edi,%eax
  80281a:	77 54                	ja     802870 <__umoddi3+0xa0>
  80281c:	0f bd e8             	bsr    %eax,%ebp
  80281f:	83 f5 1f             	xor    $0x1f,%ebp
  802822:	75 5c                	jne    802880 <__umoddi3+0xb0>
  802824:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802828:	39 3c 24             	cmp    %edi,(%esp)
  80282b:	0f 87 e7 00 00 00    	ja     802918 <__umoddi3+0x148>
  802831:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802835:	29 f1                	sub    %esi,%ecx
  802837:	19 c7                	sbb    %eax,%edi
  802839:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80283d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802841:	8b 44 24 08          	mov    0x8(%esp),%eax
  802845:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802849:	83 c4 14             	add    $0x14,%esp
  80284c:	5e                   	pop    %esi
  80284d:	5f                   	pop    %edi
  80284e:	5d                   	pop    %ebp
  80284f:	c3                   	ret    
  802850:	85 f6                	test   %esi,%esi
  802852:	89 f5                	mov    %esi,%ebp
  802854:	75 0b                	jne    802861 <__umoddi3+0x91>
  802856:	b8 01 00 00 00       	mov    $0x1,%eax
  80285b:	31 d2                	xor    %edx,%edx
  80285d:	f7 f6                	div    %esi
  80285f:	89 c5                	mov    %eax,%ebp
  802861:	8b 44 24 04          	mov    0x4(%esp),%eax
  802865:	31 d2                	xor    %edx,%edx
  802867:	f7 f5                	div    %ebp
  802869:	89 c8                	mov    %ecx,%eax
  80286b:	f7 f5                	div    %ebp
  80286d:	eb 9c                	jmp    80280b <__umoddi3+0x3b>
  80286f:	90                   	nop
  802870:	89 c8                	mov    %ecx,%eax
  802872:	89 fa                	mov    %edi,%edx
  802874:	83 c4 14             	add    $0x14,%esp
  802877:	5e                   	pop    %esi
  802878:	5f                   	pop    %edi
  802879:	5d                   	pop    %ebp
  80287a:	c3                   	ret    
  80287b:	90                   	nop
  80287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802880:	8b 04 24             	mov    (%esp),%eax
  802883:	be 20 00 00 00       	mov    $0x20,%esi
  802888:	89 e9                	mov    %ebp,%ecx
  80288a:	29 ee                	sub    %ebp,%esi
  80288c:	d3 e2                	shl    %cl,%edx
  80288e:	89 f1                	mov    %esi,%ecx
  802890:	d3 e8                	shr    %cl,%eax
  802892:	89 e9                	mov    %ebp,%ecx
  802894:	89 44 24 04          	mov    %eax,0x4(%esp)
  802898:	8b 04 24             	mov    (%esp),%eax
  80289b:	09 54 24 04          	or     %edx,0x4(%esp)
  80289f:	89 fa                	mov    %edi,%edx
  8028a1:	d3 e0                	shl    %cl,%eax
  8028a3:	89 f1                	mov    %esi,%ecx
  8028a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028a9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8028ad:	d3 ea                	shr    %cl,%edx
  8028af:	89 e9                	mov    %ebp,%ecx
  8028b1:	d3 e7                	shl    %cl,%edi
  8028b3:	89 f1                	mov    %esi,%ecx
  8028b5:	d3 e8                	shr    %cl,%eax
  8028b7:	89 e9                	mov    %ebp,%ecx
  8028b9:	09 f8                	or     %edi,%eax
  8028bb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8028bf:	f7 74 24 04          	divl   0x4(%esp)
  8028c3:	d3 e7                	shl    %cl,%edi
  8028c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028c9:	89 d7                	mov    %edx,%edi
  8028cb:	f7 64 24 08          	mull   0x8(%esp)
  8028cf:	39 d7                	cmp    %edx,%edi
  8028d1:	89 c1                	mov    %eax,%ecx
  8028d3:	89 14 24             	mov    %edx,(%esp)
  8028d6:	72 2c                	jb     802904 <__umoddi3+0x134>
  8028d8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8028dc:	72 22                	jb     802900 <__umoddi3+0x130>
  8028de:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8028e2:	29 c8                	sub    %ecx,%eax
  8028e4:	19 d7                	sbb    %edx,%edi
  8028e6:	89 e9                	mov    %ebp,%ecx
  8028e8:	89 fa                	mov    %edi,%edx
  8028ea:	d3 e8                	shr    %cl,%eax
  8028ec:	89 f1                	mov    %esi,%ecx
  8028ee:	d3 e2                	shl    %cl,%edx
  8028f0:	89 e9                	mov    %ebp,%ecx
  8028f2:	d3 ef                	shr    %cl,%edi
  8028f4:	09 d0                	or     %edx,%eax
  8028f6:	89 fa                	mov    %edi,%edx
  8028f8:	83 c4 14             	add    $0x14,%esp
  8028fb:	5e                   	pop    %esi
  8028fc:	5f                   	pop    %edi
  8028fd:	5d                   	pop    %ebp
  8028fe:	c3                   	ret    
  8028ff:	90                   	nop
  802900:	39 d7                	cmp    %edx,%edi
  802902:	75 da                	jne    8028de <__umoddi3+0x10e>
  802904:	8b 14 24             	mov    (%esp),%edx
  802907:	89 c1                	mov    %eax,%ecx
  802909:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80290d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802911:	eb cb                	jmp    8028de <__umoddi3+0x10e>
  802913:	90                   	nop
  802914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802918:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80291c:	0f 82 0f ff ff ff    	jb     802831 <__umoddi3+0x61>
  802922:	e9 1a ff ff ff       	jmp    802841 <__umoddi3+0x71>
