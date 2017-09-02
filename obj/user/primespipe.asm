
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 8c 02 00 00       	call   8002bd <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 3c             	sub    $0x3c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004c:	00 
  80004d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800051:	89 1c 24             	mov    %ebx,(%esp)
  800054:	e8 33 18 00 00       	call   80188c <readn>
  800059:	83 f8 04             	cmp    $0x4,%eax
  80005c:	74 2e                	je     80008c <primeproc+0x59>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005e:	85 c0                	test   %eax,%eax
  800060:	ba 00 00 00 00       	mov    $0x0,%edx
  800065:	0f 4e d0             	cmovle %eax,%edx
  800068:	89 54 24 10          	mov    %edx,0x10(%esp)
  80006c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800070:	c7 44 24 08 20 2c 80 	movl   $0x802c20,0x8(%esp)
  800077:	00 
  800078:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  80007f:	00 
  800080:	c7 04 24 4f 2c 80 00 	movl   $0x802c4f,(%esp)
  800087:	e8 9c 02 00 00       	call   800328 <_panic>

	cprintf("%d\n", p);
  80008c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80008f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800093:	c7 04 24 61 2c 80 00 	movl   $0x802c61,(%esp)
  80009a:	e8 82 03 00 00       	call   800421 <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  80009f:	89 3c 24             	mov    %edi,(%esp)
  8000a2:	e8 ad 23 00 00       	call   802454 <pipe>
  8000a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 20                	jns    8000ce <primeproc+0x9b>
		panic("pipe: %e", i);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 65 2c 80 	movl   $0x802c65,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 4f 2c 80 00 	movl   $0x802c4f,(%esp)
  8000c9:	e8 5a 02 00 00       	call   800328 <_panic>
	if ((id = fork()) < 0)
  8000ce:	e8 c3 11 00 00       	call   801296 <fork>
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	79 20                	jns    8000f7 <primeproc+0xc4>
		panic("fork: %e", id);
  8000d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000db:	c7 44 24 08 6e 2c 80 	movl   $0x802c6e,0x8(%esp)
  8000e2:	00 
  8000e3:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000ea:	00 
  8000eb:	c7 04 24 4f 2c 80 00 	movl   $0x802c4f,(%esp)
  8000f2:	e8 31 02 00 00       	call   800328 <_panic>
	if (id == 0) {
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	75 1b                	jne    800116 <primeproc+0xe3>
		close(fd);
  8000fb:	89 1c 24             	mov    %ebx,(%esp)
  8000fe:	e8 94 15 00 00       	call   801697 <close>
		close(pfd[1]);
  800103:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800106:	89 04 24             	mov    %eax,(%esp)
  800109:	e8 89 15 00 00       	call   801697 <close>
		fd = pfd[0];
  80010e:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800111:	e9 2f ff ff ff       	jmp    800045 <primeproc+0x12>
	}

	close(pfd[0]);
  800116:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800119:	89 04 24             	mov    %eax,(%esp)
  80011c:	e8 76 15 00 00       	call   801697 <close>
	wfd = pfd[1];
  800121:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800124:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800127:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80012e:	00 
  80012f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800133:	89 1c 24             	mov    %ebx,(%esp)
  800136:	e8 51 17 00 00       	call   80188c <readn>
  80013b:	83 f8 04             	cmp    $0x4,%eax
  80013e:	74 39                	je     800179 <primeproc+0x146>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800140:	85 c0                	test   %eax,%eax
  800142:	ba 00 00 00 00       	mov    $0x0,%edx
  800147:	0f 4e d0             	cmovle %eax,%edx
  80014a:	89 54 24 18          	mov    %edx,0x18(%esp)
  80014e:	89 44 24 14          	mov    %eax,0x14(%esp)
  800152:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800159:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015d:	c7 44 24 08 77 2c 80 	movl   $0x802c77,0x8(%esp)
  800164:	00 
  800165:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  80016c:	00 
  80016d:	c7 04 24 4f 2c 80 00 	movl   $0x802c4f,(%esp)
  800174:	e8 af 01 00 00       	call   800328 <_panic>
		if (i%p)
  800179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017c:	99                   	cltd   
  80017d:	f7 7d e0             	idivl  -0x20(%ebp)
  800180:	85 d2                	test   %edx,%edx
  800182:	74 a3                	je     800127 <primeproc+0xf4>
			if ((r=write(wfd, &i, 4)) != 4)
  800184:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80018b:	00 
  80018c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800190:	89 3c 24             	mov    %edi,(%esp)
  800193:	e8 3f 17 00 00       	call   8018d7 <write>
  800198:	83 f8 04             	cmp    $0x4,%eax
  80019b:	74 8a                	je     800127 <primeproc+0xf4>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80019d:	85 c0                	test   %eax,%eax
  80019f:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a4:	0f 4e d0             	cmovle %eax,%edx
  8001a7:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 93 2c 80 	movl   $0x802c93,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 4f 2c 80 00 	movl   $0x802c4f,(%esp)
  8001cd:	e8 56 01 00 00       	call   800328 <_panic>

008001d2 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  8001d9:	c7 05 00 40 80 00 ad 	movl   $0x802cad,0x804000
  8001e0:	2c 80 00 

	if ((i=pipe(p)) < 0)
  8001e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001e6:	89 04 24             	mov    %eax,(%esp)
  8001e9:	e8 66 22 00 00       	call   802454 <pipe>
  8001ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	79 20                	jns    800215 <umain+0x43>
		panic("pipe: %e", i);
  8001f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f9:	c7 44 24 08 65 2c 80 	movl   $0x802c65,0x8(%esp)
  800200:	00 
  800201:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800208:	00 
  800209:	c7 04 24 4f 2c 80 00 	movl   $0x802c4f,(%esp)
  800210:	e8 13 01 00 00       	call   800328 <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800215:	e8 7c 10 00 00       	call   801296 <fork>
  80021a:	85 c0                	test   %eax,%eax
  80021c:	79 20                	jns    80023e <umain+0x6c>
		panic("fork: %e", id);
  80021e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800222:	c7 44 24 08 6e 2c 80 	movl   $0x802c6e,0x8(%esp)
  800229:	00 
  80022a:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  800231:	00 
  800232:	c7 04 24 4f 2c 80 00 	movl   $0x802c4f,(%esp)
  800239:	e8 ea 00 00 00       	call   800328 <_panic>

	if (id == 0) {
  80023e:	85 c0                	test   %eax,%eax
  800240:	75 16                	jne    800258 <umain+0x86>
		close(p[1]);
  800242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	e8 4a 14 00 00       	call   801697 <close>
		primeproc(p[0]);
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	e8 db fd ff ff       	call   800033 <primeproc>
	}

	close(p[0]);
  800258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 34 14 00 00       	call   801697 <close>

	// feed all the integers through
	for (i=2;; i++)
  800263:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80026a:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80026d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800274:	00 
  800275:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027c:	89 04 24             	mov    %eax,(%esp)
  80027f:	e8 53 16 00 00       	call   8018d7 <write>
  800284:	83 f8 04             	cmp    $0x4,%eax
  800287:	74 2e                	je     8002b7 <umain+0xe5>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800289:	85 c0                	test   %eax,%eax
  80028b:	ba 00 00 00 00       	mov    $0x0,%edx
  800290:	0f 4e d0             	cmovle %eax,%edx
  800293:	89 54 24 10          	mov    %edx,0x10(%esp)
  800297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029b:	c7 44 24 08 b8 2c 80 	movl   $0x802cb8,0x8(%esp)
  8002a2:	00 
  8002a3:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002aa:	00 
  8002ab:	c7 04 24 4f 2c 80 00 	movl   $0x802c4f,(%esp)
  8002b2:	e8 71 00 00 00       	call   800328 <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  8002bb:	eb b0                	jmp    80026d <umain+0x9b>

008002bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 10             	sub    $0x10,%esp
  8002c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002cb:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8002d2:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8002d5:	e8 4b 0b 00 00       	call   800e25 <sys_getenvid>
  8002da:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8002df:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002e2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e7:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002ec:	85 db                	test   %ebx,%ebx
  8002ee:	7e 07                	jle    8002f7 <libmain+0x3a>
		binaryname = argv[0];
  8002f0:	8b 06                	mov    (%esi),%eax
  8002f2:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8002f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002fb:	89 1c 24             	mov    %ebx,(%esp)
  8002fe:	e8 cf fe ff ff       	call   8001d2 <umain>

	// exit gracefully
	exit();
  800303:	e8 07 00 00 00       	call   80030f <exit>
}
  800308:	83 c4 10             	add    $0x10,%esp
  80030b:	5b                   	pop    %ebx
  80030c:	5e                   	pop    %esi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800315:	e8 b0 13 00 00       	call   8016ca <close_all>
	sys_env_destroy(0);
  80031a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800321:	e8 ad 0a 00 00       	call   800dd3 <sys_env_destroy>
}
  800326:	c9                   	leave  
  800327:	c3                   	ret    

00800328 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	56                   	push   %esi
  80032c:	53                   	push   %ebx
  80032d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800330:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800333:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800339:	e8 e7 0a 00 00       	call   800e25 <sys_getenvid>
  80033e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800341:	89 54 24 10          	mov    %edx,0x10(%esp)
  800345:	8b 55 08             	mov    0x8(%ebp),%edx
  800348:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80034c:	89 74 24 08          	mov    %esi,0x8(%esp)
  800350:	89 44 24 04          	mov    %eax,0x4(%esp)
  800354:	c7 04 24 dc 2c 80 00 	movl   $0x802cdc,(%esp)
  80035b:	e8 c1 00 00 00       	call   800421 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800360:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800364:	8b 45 10             	mov    0x10(%ebp),%eax
  800367:	89 04 24             	mov    %eax,(%esp)
  80036a:	e8 51 00 00 00       	call   8003c0 <vcprintf>
	cprintf("\n");
  80036f:	c7 04 24 63 2c 80 00 	movl   $0x802c63,(%esp)
  800376:	e8 a6 00 00 00       	call   800421 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037b:	cc                   	int3   
  80037c:	eb fd                	jmp    80037b <_panic+0x53>

0080037e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	53                   	push   %ebx
  800382:	83 ec 14             	sub    $0x14,%esp
  800385:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800388:	8b 13                	mov    (%ebx),%edx
  80038a:	8d 42 01             	lea    0x1(%edx),%eax
  80038d:	89 03                	mov    %eax,(%ebx)
  80038f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800392:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800396:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039b:	75 19                	jne    8003b6 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80039d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003a4:	00 
  8003a5:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a8:	89 04 24             	mov    %eax,(%esp)
  8003ab:	e8 e6 09 00 00       	call   800d96 <sys_cputs>
		b->idx = 0;
  8003b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003b6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003ba:	83 c4 14             	add    $0x14,%esp
  8003bd:	5b                   	pop    %ebx
  8003be:	5d                   	pop    %ebp
  8003bf:	c3                   	ret    

008003c0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d0:	00 00 00 
	b.cnt = 0;
  8003d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003da:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f5:	c7 04 24 7e 03 80 00 	movl   $0x80037e,(%esp)
  8003fc:	e8 ad 01 00 00       	call   8005ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800401:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800407:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800411:	89 04 24             	mov    %eax,(%esp)
  800414:	e8 7d 09 00 00       	call   800d96 <sys_cputs>

	return b.cnt;
}
  800419:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80041f:	c9                   	leave  
  800420:	c3                   	ret    

00800421 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800421:	55                   	push   %ebp
  800422:	89 e5                	mov    %esp,%ebp
  800424:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800427:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80042a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	89 04 24             	mov    %eax,(%esp)
  800434:	e8 87 ff ff ff       	call   8003c0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800439:	c9                   	leave  
  80043a:	c3                   	ret    
  80043b:	66 90                	xchg   %ax,%ax
  80043d:	66 90                	xchg   %ax,%ax
  80043f:	90                   	nop

00800440 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	57                   	push   %edi
  800444:	56                   	push   %esi
  800445:	53                   	push   %ebx
  800446:	83 ec 3c             	sub    $0x3c,%esp
  800449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044c:	89 d7                	mov    %edx,%edi
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800454:	8b 45 0c             	mov    0xc(%ebp),%eax
  800457:	89 c3                	mov    %eax,%ebx
  800459:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80045c:	8b 45 10             	mov    0x10(%ebp),%eax
  80045f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800462:	b9 00 00 00 00       	mov    $0x0,%ecx
  800467:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80046d:	39 d9                	cmp    %ebx,%ecx
  80046f:	72 05                	jb     800476 <printnum+0x36>
  800471:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800474:	77 69                	ja     8004df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800476:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800479:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80047d:	83 ee 01             	sub    $0x1,%esi
  800480:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800484:	89 44 24 08          	mov    %eax,0x8(%esp)
  800488:	8b 44 24 08          	mov    0x8(%esp),%eax
  80048c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800490:	89 c3                	mov    %eax,%ebx
  800492:	89 d6                	mov    %edx,%esi
  800494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800497:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80049a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80049e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a5:	89 04 24             	mov    %eax,(%esp)
  8004a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004af:	e8 cc 24 00 00       	call   802980 <__udivdi3>
  8004b4:	89 d9                	mov    %ebx,%ecx
  8004b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004c5:	89 fa                	mov    %edi,%edx
  8004c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ca:	e8 71 ff ff ff       	call   800440 <printnum>
  8004cf:	eb 1b                	jmp    8004ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d8:	89 04 24             	mov    %eax,(%esp)
  8004db:	ff d3                	call   *%ebx
  8004dd:	eb 03                	jmp    8004e2 <printnum+0xa2>
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e2:	83 ee 01             	sub    $0x1,%esi
  8004e5:	85 f6                	test   %esi,%esi
  8004e7:	7f e8                	jg     8004d1 <printnum+0x91>
  8004e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8004f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 9c 25 00 00       	call   802ab0 <__umoddi3>
  800514:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800518:	0f be 80 ff 2c 80 00 	movsbl 0x802cff(%eax),%eax
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800525:	ff d0                	call   *%eax
}
  800527:	83 c4 3c             	add    $0x3c,%esp
  80052a:	5b                   	pop    %ebx
  80052b:	5e                   	pop    %esi
  80052c:	5f                   	pop    %edi
  80052d:	5d                   	pop    %ebp
  80052e:	c3                   	ret    

0080052f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800532:	83 fa 01             	cmp    $0x1,%edx
  800535:	7e 0e                	jle    800545 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800537:	8b 10                	mov    (%eax),%edx
  800539:	8d 4a 08             	lea    0x8(%edx),%ecx
  80053c:	89 08                	mov    %ecx,(%eax)
  80053e:	8b 02                	mov    (%edx),%eax
  800540:	8b 52 04             	mov    0x4(%edx),%edx
  800543:	eb 22                	jmp    800567 <getuint+0x38>
	else if (lflag)
  800545:	85 d2                	test   %edx,%edx
  800547:	74 10                	je     800559 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800549:	8b 10                	mov    (%eax),%edx
  80054b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80054e:	89 08                	mov    %ecx,(%eax)
  800550:	8b 02                	mov    (%edx),%eax
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
  800557:	eb 0e                	jmp    800567 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800559:	8b 10                	mov    (%eax),%edx
  80055b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80055e:	89 08                	mov    %ecx,(%eax)
  800560:	8b 02                	mov    (%edx),%eax
  800562:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800567:	5d                   	pop    %ebp
  800568:	c3                   	ret    

00800569 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80056f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800573:	8b 10                	mov    (%eax),%edx
  800575:	3b 50 04             	cmp    0x4(%eax),%edx
  800578:	73 0a                	jae    800584 <sprintputch+0x1b>
		*b->buf++ = ch;
  80057a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80057d:	89 08                	mov    %ecx,(%eax)
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	88 02                	mov    %al,(%edx)
}
  800584:	5d                   	pop    %ebp
  800585:	c3                   	ret    

00800586 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
  800589:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80058c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80058f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800593:	8b 45 10             	mov    0x10(%ebp),%eax
  800596:	89 44 24 08          	mov    %eax,0x8(%esp)
  80059a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 04 24             	mov    %eax,(%esp)
  8005a7:	e8 02 00 00 00       	call   8005ae <vprintfmt>
	va_end(ap);
}
  8005ac:	c9                   	leave  
  8005ad:	c3                   	ret    

008005ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	57                   	push   %edi
  8005b2:	56                   	push   %esi
  8005b3:	53                   	push   %ebx
  8005b4:	83 ec 3c             	sub    $0x3c,%esp
  8005b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005bd:	eb 14                	jmp    8005d3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005bf:	85 c0                	test   %eax,%eax
  8005c1:	0f 84 b3 03 00 00    	je     80097a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8005c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005cb:	89 04 24             	mov    %eax,(%esp)
  8005ce:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d1:	89 f3                	mov    %esi,%ebx
  8005d3:	8d 73 01             	lea    0x1(%ebx),%esi
  8005d6:	0f b6 03             	movzbl (%ebx),%eax
  8005d9:	83 f8 25             	cmp    $0x25,%eax
  8005dc:	75 e1                	jne    8005bf <vprintfmt+0x11>
  8005de:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8005e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005e9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8005f0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8005f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fc:	eb 1d                	jmp    80061b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800600:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800604:	eb 15                	jmp    80061b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800606:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800608:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80060c:	eb 0d                	jmp    80061b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80060e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800611:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800614:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80061e:	0f b6 0e             	movzbl (%esi),%ecx
  800621:	0f b6 c1             	movzbl %cl,%eax
  800624:	83 e9 23             	sub    $0x23,%ecx
  800627:	80 f9 55             	cmp    $0x55,%cl
  80062a:	0f 87 2a 03 00 00    	ja     80095a <vprintfmt+0x3ac>
  800630:	0f b6 c9             	movzbl %cl,%ecx
  800633:	ff 24 8d 40 2e 80 00 	jmp    *0x802e40(,%ecx,4)
  80063a:	89 de                	mov    %ebx,%esi
  80063c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800641:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800644:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800648:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80064b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80064e:	83 fb 09             	cmp    $0x9,%ebx
  800651:	77 36                	ja     800689 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800653:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800656:	eb e9                	jmp    800641 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 48 04             	lea    0x4(%eax),%ecx
  80065e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800661:	8b 00                	mov    (%eax),%eax
  800663:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800666:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800668:	eb 22                	jmp    80068c <vprintfmt+0xde>
  80066a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80066d:	85 c9                	test   %ecx,%ecx
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
  800674:	0f 49 c1             	cmovns %ecx,%eax
  800677:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	89 de                	mov    %ebx,%esi
  80067c:	eb 9d                	jmp    80061b <vprintfmt+0x6d>
  80067e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800680:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800687:	eb 92                	jmp    80061b <vprintfmt+0x6d>
  800689:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80068c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800690:	79 89                	jns    80061b <vprintfmt+0x6d>
  800692:	e9 77 ff ff ff       	jmp    80060e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800697:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80069c:	e9 7a ff ff ff       	jmp    80061b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 50 04             	lea    0x4(%eax),%edx
  8006a7:	89 55 14             	mov    %edx,0x14(%ebp)
  8006aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	89 04 24             	mov    %eax,(%esp)
  8006b3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006b6:	e9 18 ff ff ff       	jmp    8005d3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 50 04             	lea    0x4(%eax),%edx
  8006c1:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	99                   	cltd   
  8006c7:	31 d0                	xor    %edx,%eax
  8006c9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006cb:	83 f8 0f             	cmp    $0xf,%eax
  8006ce:	7f 0b                	jg     8006db <vprintfmt+0x12d>
  8006d0:	8b 14 85 a0 2f 80 00 	mov    0x802fa0(,%eax,4),%edx
  8006d7:	85 d2                	test   %edx,%edx
  8006d9:	75 20                	jne    8006fb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8006db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006df:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  8006e6:	00 
  8006e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	89 04 24             	mov    %eax,(%esp)
  8006f1:	e8 90 fe ff ff       	call   800586 <printfmt>
  8006f6:	e9 d8 fe ff ff       	jmp    8005d3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8006fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006ff:	c7 44 24 08 65 32 80 	movl   $0x803265,0x8(%esp)
  800706:	00 
  800707:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 04 24             	mov    %eax,(%esp)
  800711:	e8 70 fe ff ff       	call   800586 <printfmt>
  800716:	e9 b8 fe ff ff       	jmp    8005d3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80071e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800721:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8d 50 04             	lea    0x4(%eax),%edx
  80072a:	89 55 14             	mov    %edx,0x14(%ebp)
  80072d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80072f:	85 f6                	test   %esi,%esi
  800731:	b8 10 2d 80 00       	mov    $0x802d10,%eax
  800736:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800739:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80073d:	0f 84 97 00 00 00    	je     8007da <vprintfmt+0x22c>
  800743:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800747:	0f 8e 9b 00 00 00    	jle    8007e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80074d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800751:	89 34 24             	mov    %esi,(%esp)
  800754:	e8 cf 02 00 00       	call   800a28 <strnlen>
  800759:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075c:	29 c2                	sub    %eax,%edx
  80075e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800761:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800765:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800768:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80076b:	8b 75 08             	mov    0x8(%ebp),%esi
  80076e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800771:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800773:	eb 0f                	jmp    800784 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800775:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800779:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80077c:	89 04 24             	mov    %eax,(%esp)
  80077f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800781:	83 eb 01             	sub    $0x1,%ebx
  800784:	85 db                	test   %ebx,%ebx
  800786:	7f ed                	jg     800775 <vprintfmt+0x1c7>
  800788:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80078b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80078e:	85 d2                	test   %edx,%edx
  800790:	b8 00 00 00 00       	mov    $0x0,%eax
  800795:	0f 49 c2             	cmovns %edx,%eax
  800798:	29 c2                	sub    %eax,%edx
  80079a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80079d:	89 d7                	mov    %edx,%edi
  80079f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007a2:	eb 50                	jmp    8007f4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a8:	74 1e                	je     8007c8 <vprintfmt+0x21a>
  8007aa:	0f be d2             	movsbl %dl,%edx
  8007ad:	83 ea 20             	sub    $0x20,%edx
  8007b0:	83 fa 5e             	cmp    $0x5e,%edx
  8007b3:	76 13                	jbe    8007c8 <vprintfmt+0x21a>
					putch('?', putdat);
  8007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007c3:	ff 55 08             	call   *0x8(%ebp)
  8007c6:	eb 0d                	jmp    8007d5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8007c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007cf:	89 04 24             	mov    %eax,(%esp)
  8007d2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d5:	83 ef 01             	sub    $0x1,%edi
  8007d8:	eb 1a                	jmp    8007f4 <vprintfmt+0x246>
  8007da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007dd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007e0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007e3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007e6:	eb 0c                	jmp    8007f4 <vprintfmt+0x246>
  8007e8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007f4:	83 c6 01             	add    $0x1,%esi
  8007f7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8007fb:	0f be c2             	movsbl %dl,%eax
  8007fe:	85 c0                	test   %eax,%eax
  800800:	74 27                	je     800829 <vprintfmt+0x27b>
  800802:	85 db                	test   %ebx,%ebx
  800804:	78 9e                	js     8007a4 <vprintfmt+0x1f6>
  800806:	83 eb 01             	sub    $0x1,%ebx
  800809:	79 99                	jns    8007a4 <vprintfmt+0x1f6>
  80080b:	89 f8                	mov    %edi,%eax
  80080d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800810:	8b 75 08             	mov    0x8(%ebp),%esi
  800813:	89 c3                	mov    %eax,%ebx
  800815:	eb 1a                	jmp    800831 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800817:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80081b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800822:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800824:	83 eb 01             	sub    $0x1,%ebx
  800827:	eb 08                	jmp    800831 <vprintfmt+0x283>
  800829:	89 fb                	mov    %edi,%ebx
  80082b:	8b 75 08             	mov    0x8(%ebp),%esi
  80082e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800831:	85 db                	test   %ebx,%ebx
  800833:	7f e2                	jg     800817 <vprintfmt+0x269>
  800835:	89 75 08             	mov    %esi,0x8(%ebp)
  800838:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80083b:	e9 93 fd ff ff       	jmp    8005d3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800840:	83 fa 01             	cmp    $0x1,%edx
  800843:	7e 16                	jle    80085b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8d 50 08             	lea    0x8(%eax),%edx
  80084b:	89 55 14             	mov    %edx,0x14(%ebp)
  80084e:	8b 50 04             	mov    0x4(%eax),%edx
  800851:	8b 00                	mov    (%eax),%eax
  800853:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800856:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800859:	eb 32                	jmp    80088d <vprintfmt+0x2df>
	else if (lflag)
  80085b:	85 d2                	test   %edx,%edx
  80085d:	74 18                	je     800877 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8d 50 04             	lea    0x4(%eax),%edx
  800865:	89 55 14             	mov    %edx,0x14(%ebp)
  800868:	8b 30                	mov    (%eax),%esi
  80086a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80086d:	89 f0                	mov    %esi,%eax
  80086f:	c1 f8 1f             	sar    $0x1f,%eax
  800872:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800875:	eb 16                	jmp    80088d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8d 50 04             	lea    0x4(%eax),%edx
  80087d:	89 55 14             	mov    %edx,0x14(%ebp)
  800880:	8b 30                	mov    (%eax),%esi
  800882:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800885:	89 f0                	mov    %esi,%eax
  800887:	c1 f8 1f             	sar    $0x1f,%eax
  80088a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800890:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800893:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800898:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089c:	0f 89 80 00 00 00    	jns    800922 <vprintfmt+0x374>
				putch('-', putdat);
  8008a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008a6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008ad:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008b6:	f7 d8                	neg    %eax
  8008b8:	83 d2 00             	adc    $0x0,%edx
  8008bb:	f7 da                	neg    %edx
			}
			base = 10;
  8008bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8008c2:	eb 5e                	jmp    800922 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c7:	e8 63 fc ff ff       	call   80052f <getuint>
			base = 10;
  8008cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8008d1:	eb 4f                	jmp    800922 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  8008d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d6:	e8 54 fc ff ff       	call   80052f <getuint>
			base =8;
  8008db:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8008e0:	eb 40                	jmp    800922 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  8008e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8008f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8d 50 04             	lea    0x4(%eax),%edx
  800904:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800907:	8b 00                	mov    (%eax),%eax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80090e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800913:	eb 0d                	jmp    800922 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800915:	8d 45 14             	lea    0x14(%ebp),%eax
  800918:	e8 12 fc ff ff       	call   80052f <getuint>
			base = 16;
  80091d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800922:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800926:	89 74 24 10          	mov    %esi,0x10(%esp)
  80092a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80092d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800931:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800935:	89 04 24             	mov    %eax,(%esp)
  800938:	89 54 24 04          	mov    %edx,0x4(%esp)
  80093c:	89 fa                	mov    %edi,%edx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	e8 fa fa ff ff       	call   800440 <printnum>
			break;
  800946:	e9 88 fc ff ff       	jmp    8005d3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80094b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80094f:	89 04 24             	mov    %eax,(%esp)
  800952:	ff 55 08             	call   *0x8(%ebp)
			break;
  800955:	e9 79 fc ff ff       	jmp    8005d3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80095a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800965:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800968:	89 f3                	mov    %esi,%ebx
  80096a:	eb 03                	jmp    80096f <vprintfmt+0x3c1>
  80096c:	83 eb 01             	sub    $0x1,%ebx
  80096f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800973:	75 f7                	jne    80096c <vprintfmt+0x3be>
  800975:	e9 59 fc ff ff       	jmp    8005d3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80097a:	83 c4 3c             	add    $0x3c,%esp
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5f                   	pop    %edi
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	83 ec 28             	sub    $0x28,%esp
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800991:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800995:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099f:	85 c0                	test   %eax,%eax
  8009a1:	74 30                	je     8009d3 <vsnprintf+0x51>
  8009a3:	85 d2                	test   %edx,%edx
  8009a5:	7e 2c                	jle    8009d3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bc:	c7 04 24 69 05 80 00 	movl   $0x800569,(%esp)
  8009c3:	e8 e6 fb ff ff       	call   8005ae <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d1:	eb 05                	jmp    8009d8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8009d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	89 04 24             	mov    %eax,(%esp)
  8009fb:	e8 82 ff ff ff       	call   800982 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    
  800a02:	66 90                	xchg   %ax,%ax
  800a04:	66 90                	xchg   %ax,%ax
  800a06:	66 90                	xchg   %ax,%ax
  800a08:	66 90                	xchg   %ax,%ax
  800a0a:	66 90                	xchg   %ax,%ax
  800a0c:	66 90                	xchg   %ax,%ax
  800a0e:	66 90                	xchg   %ax,%ax

00800a10 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a16:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1b:	eb 03                	jmp    800a20 <strlen+0x10>
		n++;
  800a1d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a20:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a24:	75 f7                	jne    800a1d <strlen+0xd>
		n++;
	return n;
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a31:	b8 00 00 00 00       	mov    $0x0,%eax
  800a36:	eb 03                	jmp    800a3b <strnlen+0x13>
		n++;
  800a38:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3b:	39 d0                	cmp    %edx,%eax
  800a3d:	74 06                	je     800a45 <strnlen+0x1d>
  800a3f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a43:	75 f3                	jne    800a38 <strnlen+0x10>
		n++;
	return n;
}
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	53                   	push   %ebx
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a51:	89 c2                	mov    %eax,%edx
  800a53:	83 c2 01             	add    $0x1,%edx
  800a56:	83 c1 01             	add    $0x1,%ecx
  800a59:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a5d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a60:	84 db                	test   %bl,%bl
  800a62:	75 ef                	jne    800a53 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a64:	5b                   	pop    %ebx
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	53                   	push   %ebx
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a71:	89 1c 24             	mov    %ebx,(%esp)
  800a74:	e8 97 ff ff ff       	call   800a10 <strlen>
	strcpy(dst + len, src);
  800a79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a80:	01 d8                	add    %ebx,%eax
  800a82:	89 04 24             	mov    %eax,(%esp)
  800a85:	e8 bd ff ff ff       	call   800a47 <strcpy>
	return dst;
}
  800a8a:	89 d8                	mov    %ebx,%eax
  800a8c:	83 c4 08             	add    $0x8,%esp
  800a8f:	5b                   	pop    %ebx
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9d:	89 f3                	mov    %esi,%ebx
  800a9f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa2:	89 f2                	mov    %esi,%edx
  800aa4:	eb 0f                	jmp    800ab5 <strncpy+0x23>
		*dst++ = *src;
  800aa6:	83 c2 01             	add    $0x1,%edx
  800aa9:	0f b6 01             	movzbl (%ecx),%eax
  800aac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aaf:	80 39 01             	cmpb   $0x1,(%ecx)
  800ab2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab5:	39 da                	cmp    %ebx,%edx
  800ab7:	75 ed                	jne    800aa6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ab9:	89 f0                	mov    %esi,%eax
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	56                   	push   %esi
  800ac3:	53                   	push   %ebx
  800ac4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800acd:	89 f0                	mov    %esi,%eax
  800acf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad3:	85 c9                	test   %ecx,%ecx
  800ad5:	75 0b                	jne    800ae2 <strlcpy+0x23>
  800ad7:	eb 1d                	jmp    800af6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad9:	83 c0 01             	add    $0x1,%eax
  800adc:	83 c2 01             	add    $0x1,%edx
  800adf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae2:	39 d8                	cmp    %ebx,%eax
  800ae4:	74 0b                	je     800af1 <strlcpy+0x32>
  800ae6:	0f b6 0a             	movzbl (%edx),%ecx
  800ae9:	84 c9                	test   %cl,%cl
  800aeb:	75 ec                	jne    800ad9 <strlcpy+0x1a>
  800aed:	89 c2                	mov    %eax,%edx
  800aef:	eb 02                	jmp    800af3 <strlcpy+0x34>
  800af1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800af3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800af6:	29 f0                	sub    %esi,%eax
}
  800af8:	5b                   	pop    %ebx
  800af9:	5e                   	pop    %esi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b05:	eb 06                	jmp    800b0d <strcmp+0x11>
		p++, q++;
  800b07:	83 c1 01             	add    $0x1,%ecx
  800b0a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b0d:	0f b6 01             	movzbl (%ecx),%eax
  800b10:	84 c0                	test   %al,%al
  800b12:	74 04                	je     800b18 <strcmp+0x1c>
  800b14:	3a 02                	cmp    (%edx),%al
  800b16:	74 ef                	je     800b07 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b18:	0f b6 c0             	movzbl %al,%eax
  800b1b:	0f b6 12             	movzbl (%edx),%edx
  800b1e:	29 d0                	sub    %edx,%eax
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	53                   	push   %ebx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 c3                	mov    %eax,%ebx
  800b2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b31:	eb 06                	jmp    800b39 <strncmp+0x17>
		n--, p++, q++;
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b39:	39 d8                	cmp    %ebx,%eax
  800b3b:	74 15                	je     800b52 <strncmp+0x30>
  800b3d:	0f b6 08             	movzbl (%eax),%ecx
  800b40:	84 c9                	test   %cl,%cl
  800b42:	74 04                	je     800b48 <strncmp+0x26>
  800b44:	3a 0a                	cmp    (%edx),%cl
  800b46:	74 eb                	je     800b33 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b48:	0f b6 00             	movzbl (%eax),%eax
  800b4b:	0f b6 12             	movzbl (%edx),%edx
  800b4e:	29 d0                	sub    %edx,%eax
  800b50:	eb 05                	jmp    800b57 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b64:	eb 07                	jmp    800b6d <strchr+0x13>
		if (*s == c)
  800b66:	38 ca                	cmp    %cl,%dl
  800b68:	74 0f                	je     800b79 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b6a:	83 c0 01             	add    $0x1,%eax
  800b6d:	0f b6 10             	movzbl (%eax),%edx
  800b70:	84 d2                	test   %dl,%dl
  800b72:	75 f2                	jne    800b66 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b85:	eb 07                	jmp    800b8e <strfind+0x13>
		if (*s == c)
  800b87:	38 ca                	cmp    %cl,%dl
  800b89:	74 0a                	je     800b95 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b8b:	83 c0 01             	add    $0x1,%eax
  800b8e:	0f b6 10             	movzbl (%eax),%edx
  800b91:	84 d2                	test   %dl,%dl
  800b93:	75 f2                	jne    800b87 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
  800b9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba3:	85 c9                	test   %ecx,%ecx
  800ba5:	74 36                	je     800bdd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bad:	75 28                	jne    800bd7 <memset+0x40>
  800baf:	f6 c1 03             	test   $0x3,%cl
  800bb2:	75 23                	jne    800bd7 <memset+0x40>
		c &= 0xFF;
  800bb4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb8:	89 d3                	mov    %edx,%ebx
  800bba:	c1 e3 08             	shl    $0x8,%ebx
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	c1 e6 18             	shl    $0x18,%esi
  800bc2:	89 d0                	mov    %edx,%eax
  800bc4:	c1 e0 10             	shl    $0x10,%eax
  800bc7:	09 f0                	or     %esi,%eax
  800bc9:	09 c2                	or     %eax,%edx
  800bcb:	89 d0                	mov    %edx,%eax
  800bcd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bcf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800bd2:	fc                   	cld    
  800bd3:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd5:	eb 06                	jmp    800bdd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	fc                   	cld    
  800bdb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bdd:	89 f8                	mov    %edi,%eax
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf2:	39 c6                	cmp    %eax,%esi
  800bf4:	73 35                	jae    800c2b <memmove+0x47>
  800bf6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf9:	39 d0                	cmp    %edx,%eax
  800bfb:	73 2e                	jae    800c2b <memmove+0x47>
		s += n;
		d += n;
  800bfd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c00:	89 d6                	mov    %edx,%esi
  800c02:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c0a:	75 13                	jne    800c1f <memmove+0x3b>
  800c0c:	f6 c1 03             	test   $0x3,%cl
  800c0f:	75 0e                	jne    800c1f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c11:	83 ef 04             	sub    $0x4,%edi
  800c14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c1a:	fd                   	std    
  800c1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1d:	eb 09                	jmp    800c28 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c1f:	83 ef 01             	sub    $0x1,%edi
  800c22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c25:	fd                   	std    
  800c26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c28:	fc                   	cld    
  800c29:	eb 1d                	jmp    800c48 <memmove+0x64>
  800c2b:	89 f2                	mov    %esi,%edx
  800c2d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2f:	f6 c2 03             	test   $0x3,%dl
  800c32:	75 0f                	jne    800c43 <memmove+0x5f>
  800c34:	f6 c1 03             	test   $0x3,%cl
  800c37:	75 0a                	jne    800c43 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c39:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c3c:	89 c7                	mov    %eax,%edi
  800c3e:	fc                   	cld    
  800c3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c41:	eb 05                	jmp    800c48 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c43:	89 c7                	mov    %eax,%edi
  800c45:	fc                   	cld    
  800c46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c48:	5e                   	pop    %esi
  800c49:	5f                   	pop    %edi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 04 24             	mov    %eax,(%esp)
  800c66:	e8 79 ff ff ff       	call   800be4 <memmove>
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	89 d6                	mov    %edx,%esi
  800c7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7d:	eb 1a                	jmp    800c99 <memcmp+0x2c>
		if (*s1 != *s2)
  800c7f:	0f b6 02             	movzbl (%edx),%eax
  800c82:	0f b6 19             	movzbl (%ecx),%ebx
  800c85:	38 d8                	cmp    %bl,%al
  800c87:	74 0a                	je     800c93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c89:	0f b6 c0             	movzbl %al,%eax
  800c8c:	0f b6 db             	movzbl %bl,%ebx
  800c8f:	29 d8                	sub    %ebx,%eax
  800c91:	eb 0f                	jmp    800ca2 <memcmp+0x35>
		s1++, s2++;
  800c93:	83 c2 01             	add    $0x1,%edx
  800c96:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c99:	39 f2                	cmp    %esi,%edx
  800c9b:	75 e2                	jne    800c7f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb4:	eb 07                	jmp    800cbd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb6:	38 08                	cmp    %cl,(%eax)
  800cb8:	74 07                	je     800cc1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cba:	83 c0 01             	add    $0x1,%eax
  800cbd:	39 d0                	cmp    %edx,%eax
  800cbf:	72 f5                	jb     800cb6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccf:	eb 03                	jmp    800cd4 <strtol+0x11>
		s++;
  800cd1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd4:	0f b6 0a             	movzbl (%edx),%ecx
  800cd7:	80 f9 09             	cmp    $0x9,%cl
  800cda:	74 f5                	je     800cd1 <strtol+0xe>
  800cdc:	80 f9 20             	cmp    $0x20,%cl
  800cdf:	74 f0                	je     800cd1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ce1:	80 f9 2b             	cmp    $0x2b,%cl
  800ce4:	75 0a                	jne    800cf0 <strtol+0x2d>
		s++;
  800ce6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cee:	eb 11                	jmp    800d01 <strtol+0x3e>
  800cf0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800cf5:	80 f9 2d             	cmp    $0x2d,%cl
  800cf8:	75 07                	jne    800d01 <strtol+0x3e>
		s++, neg = 1;
  800cfa:	8d 52 01             	lea    0x1(%edx),%edx
  800cfd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d01:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d06:	75 15                	jne    800d1d <strtol+0x5a>
  800d08:	80 3a 30             	cmpb   $0x30,(%edx)
  800d0b:	75 10                	jne    800d1d <strtol+0x5a>
  800d0d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d11:	75 0a                	jne    800d1d <strtol+0x5a>
		s += 2, base = 16;
  800d13:	83 c2 02             	add    $0x2,%edx
  800d16:	b8 10 00 00 00       	mov    $0x10,%eax
  800d1b:	eb 10                	jmp    800d2d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	75 0c                	jne    800d2d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d21:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d23:	80 3a 30             	cmpb   $0x30,(%edx)
  800d26:	75 05                	jne    800d2d <strtol+0x6a>
		s++, base = 8;
  800d28:	83 c2 01             	add    $0x1,%edx
  800d2b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d32:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d35:	0f b6 0a             	movzbl (%edx),%ecx
  800d38:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d3b:	89 f0                	mov    %esi,%eax
  800d3d:	3c 09                	cmp    $0x9,%al
  800d3f:	77 08                	ja     800d49 <strtol+0x86>
			dig = *s - '0';
  800d41:	0f be c9             	movsbl %cl,%ecx
  800d44:	83 e9 30             	sub    $0x30,%ecx
  800d47:	eb 20                	jmp    800d69 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800d49:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d4c:	89 f0                	mov    %esi,%eax
  800d4e:	3c 19                	cmp    $0x19,%al
  800d50:	77 08                	ja     800d5a <strtol+0x97>
			dig = *s - 'a' + 10;
  800d52:	0f be c9             	movsbl %cl,%ecx
  800d55:	83 e9 57             	sub    $0x57,%ecx
  800d58:	eb 0f                	jmp    800d69 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800d5a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800d5d:	89 f0                	mov    %esi,%eax
  800d5f:	3c 19                	cmp    $0x19,%al
  800d61:	77 16                	ja     800d79 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800d63:	0f be c9             	movsbl %cl,%ecx
  800d66:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d69:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d6c:	7d 0f                	jge    800d7d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800d6e:	83 c2 01             	add    $0x1,%edx
  800d71:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d75:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d77:	eb bc                	jmp    800d35 <strtol+0x72>
  800d79:	89 d8                	mov    %ebx,%eax
  800d7b:	eb 02                	jmp    800d7f <strtol+0xbc>
  800d7d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d83:	74 05                	je     800d8a <strtol+0xc7>
		*endptr = (char *) s;
  800d85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d88:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d8a:	f7 d8                	neg    %eax
  800d8c:	85 ff                	test   %edi,%edi
  800d8e:	0f 44 c3             	cmove  %ebx,%eax
}
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	89 c3                	mov    %eax,%ebx
  800da9:	89 c7                	mov    %eax,%edi
  800dab:	89 c6                	mov    %eax,%esi
  800dad:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dba:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  800dc4:	89 d1                	mov    %edx,%ecx
  800dc6:	89 d3                	mov    %edx,%ebx
  800dc8:	89 d7                	mov    %edx,%edi
  800dca:	89 d6                	mov    %edx,%esi
  800dcc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de1:	b8 03 00 00 00       	mov    $0x3,%eax
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	89 cb                	mov    %ecx,%ebx
  800deb:	89 cf                	mov    %ecx,%edi
  800ded:	89 ce                	mov    %ecx,%esi
  800def:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7e 28                	jle    800e1d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e00:	00 
  800e01:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  800e08:	00 
  800e09:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e10:	00 
  800e11:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  800e18:	e8 0b f5 ff ff       	call   800328 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e1d:	83 c4 2c             	add    $0x2c,%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    

00800e25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e30:	b8 02 00 00 00       	mov    $0x2,%eax
  800e35:	89 d1                	mov    %edx,%ecx
  800e37:	89 d3                	mov    %edx,%ebx
  800e39:	89 d7                	mov    %edx,%edi
  800e3b:	89 d6                	mov    %edx,%esi
  800e3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    

00800e44 <sys_yield>:

void
sys_yield(void)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	57                   	push   %edi
  800e48:	56                   	push   %esi
  800e49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e54:	89 d1                	mov    %edx,%ecx
  800e56:	89 d3                	mov    %edx,%ebx
  800e58:	89 d7                	mov    %edx,%edi
  800e5a:	89 d6                	mov    %edx,%esi
  800e5c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6c:	be 00 00 00 00       	mov    $0x0,%esi
  800e71:	b8 04 00 00 00       	mov    $0x4,%eax
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7f:	89 f7                	mov    %esi,%edi
  800e81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7e 28                	jle    800eaf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e92:	00 
  800e93:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  800e9a:	00 
  800e9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea2:	00 
  800ea3:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  800eaa:	e8 79 f4 ff ff       	call   800328 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eaf:	83 c4 2c             	add    $0x2c,%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
  800ebd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ece:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed1:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	7e 28                	jle    800f02 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eda:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ede:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ee5:	00 
  800ee6:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  800eed:	00 
  800eee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef5:	00 
  800ef6:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  800efd:	e8 26 f4 ff ff       	call   800328 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f02:	83 c4 2c             	add    $0x2c,%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
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
  800f18:	b8 06 00 00 00       	mov    $0x6,%eax
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
  800f2b:	7e 28                	jle    800f55 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  800f50:	e8 d3 f3 ff ff       	call   800328 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f55:	83 c4 2c             	add    $0x2c,%esp
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
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
  800f6b:	b8 08 00 00 00       	mov    $0x8,%eax
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
  800f7e:	7e 28                	jle    800fa8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f84:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  800fa3:	e8 80 f3 ff ff       	call   800328 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fa8:	83 c4 2c             	add    $0x2c,%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
  800fb6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbe:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	89 df                	mov    %ebx,%edi
  800fcb:	89 de                	mov    %ebx,%esi
  800fcd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	7e 28                	jle    800ffb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fde:	00 
  800fdf:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  800fe6:	00 
  800fe7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fee:	00 
  800fef:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  800ff6:	e8 2d f3 ff ff       	call   800328 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ffb:	83 c4 2c             	add    $0x2c,%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801011:	b8 0a 00 00 00       	mov    $0xa,%eax
  801016:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
  80101c:	89 df                	mov    %ebx,%edi
  80101e:	89 de                	mov    %ebx,%esi
  801020:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801022:	85 c0                	test   %eax,%eax
  801024:	7e 28                	jle    80104e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801026:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801031:	00 
  801032:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  801039:	00 
  80103a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801041:	00 
  801042:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  801049:	e8 da f2 ff ff       	call   800328 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80104e:	83 c4 2c             	add    $0x2c,%esp
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5f                   	pop    %edi
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    

00801056 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	57                   	push   %edi
  80105a:	56                   	push   %esi
  80105b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105c:	be 00 00 00 00       	mov    $0x0,%esi
  801061:	b8 0c 00 00 00       	mov    $0xc,%eax
  801066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801069:	8b 55 08             	mov    0x8(%ebp),%edx
  80106c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80106f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801072:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    

00801079 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	57                   	push   %edi
  80107d:	56                   	push   %esi
  80107e:	53                   	push   %ebx
  80107f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801082:	b9 00 00 00 00       	mov    $0x0,%ecx
  801087:	b8 0d 00 00 00       	mov    $0xd,%eax
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	89 cb                	mov    %ecx,%ebx
  801091:	89 cf                	mov    %ecx,%edi
  801093:	89 ce                	mov    %ecx,%esi
  801095:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801097:	85 c0                	test   %eax,%eax
  801099:	7e 28                	jle    8010c3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80109b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010a6:	00 
  8010a7:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  8010ae:	00 
  8010af:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b6:	00 
  8010b7:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  8010be:	e8 65 f2 ff ff       	call   800328 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010c3:	83 c4 2c             	add    $0x2c,%esp
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010db:	89 d1                	mov    %edx,%ecx
  8010dd:	89 d3                	mov    %edx,%ebx
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	89 d6                	mov    %edx,%esi
  8010e3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
  8010f0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801100:	8b 55 08             	mov    0x8(%ebp),%edx
  801103:	89 df                	mov    %ebx,%edi
  801105:	89 de                	mov    %ebx,%esi
  801107:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801109:	85 c0                	test   %eax,%eax
  80110b:	7e 28                	jle    801135 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80110d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801111:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801118:	00 
  801119:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  801120:	00 
  801121:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801128:	00 
  801129:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  801130:	e8 f3 f1 ff ff       	call   800328 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801135:	83 c4 2c             	add    $0x2c,%esp
  801138:	5b                   	pop    %ebx
  801139:	5e                   	pop    %esi
  80113a:	5f                   	pop    %edi
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	57                   	push   %edi
  801141:	56                   	push   %esi
  801142:	53                   	push   %ebx
  801143:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801146:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114b:	b8 10 00 00 00       	mov    $0x10,%eax
  801150:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801153:	8b 55 08             	mov    0x8(%ebp),%edx
  801156:	89 df                	mov    %ebx,%edi
  801158:	89 de                	mov    %ebx,%esi
  80115a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	7e 28                	jle    801188 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801160:	89 44 24 10          	mov    %eax,0x10(%esp)
  801164:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80116b:	00 
  80116c:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  801173:	00 
  801174:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80117b:	00 
  80117c:	c7 04 24 1c 30 80 00 	movl   $0x80301c,(%esp)
  801183:	e8 a0 f1 ff ff       	call   800328 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801188:	83 c4 2c             	add    $0x2c,%esp
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	53                   	push   %ebx
  801194:	83 ec 24             	sub    $0x24,%esp
  801197:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  80119a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  80119c:	89 d3                	mov    %edx,%ebx
  80119e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  8011a4:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8011a8:	74 1a                	je     8011c4 <pgfault+0x34>
  8011aa:	c1 ea 0c             	shr    $0xc,%edx
  8011ad:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011b4:	a8 01                	test   $0x1,%al
  8011b6:	74 0c                	je     8011c4 <pgfault+0x34>
  8011b8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8011bf:	f6 c4 08             	test   $0x8,%ah
  8011c2:	75 1c                	jne    8011e0 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  8011c4:	c7 44 24 08 2c 30 80 	movl   $0x80302c,0x8(%esp)
  8011cb:	00 
  8011cc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8011d3:	00 
  8011d4:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  8011db:	e8 48 f1 ff ff       	call   800328 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  8011e0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8011e7:	00 
  8011e8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011ef:	00 
  8011f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011f7:	e8 67 fc ff ff       	call   800e63 <sys_page_alloc>
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	79 1c                	jns    80121c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801200:	c7 44 24 08 70 30 80 	movl   $0x803070,0x8(%esp)
  801207:	00 
  801208:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80120f:	00 
  801210:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  801217:	e8 0c f1 ff ff       	call   800328 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  80121c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801223:	00 
  801224:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801228:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80122f:	e8 18 fa ff ff       	call   800c4c <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801234:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80123b:	00 
  80123c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801240:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801247:	00 
  801248:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80124f:	00 
  801250:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801257:	e8 5b fc ff ff       	call   800eb7 <sys_page_map>
  80125c:	85 c0                	test   %eax,%eax
  80125e:	74 1c                	je     80127c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  801260:	c7 44 24 08 86 31 80 	movl   $0x803186,0x8(%esp)
  801267:	00 
  801268:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80126f:	00 
  801270:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  801277:	e8 ac f0 ff ff       	call   800328 <_panic>
    sys_page_unmap(0,PFTEMP);
  80127c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801283:	00 
  801284:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80128b:	e8 7a fc ff ff       	call   800f0a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801290:	83 c4 24             	add    $0x24,%esp
  801293:	5b                   	pop    %ebx
  801294:	5d                   	pop    %ebp
  801295:	c3                   	ret    

00801296 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	57                   	push   %edi
  80129a:	56                   	push   %esi
  80129b:	53                   	push   %ebx
  80129c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80129f:	c7 04 24 90 11 80 00 	movl   $0x801190,(%esp)
  8012a6:	e8 fb 14 00 00       	call   8027a6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8012ab:	b8 07 00 00 00       	mov    $0x7,%eax
  8012b0:	cd 30                	int    $0x30
  8012b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012b5:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  8012b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	75 21                	jne    8012e1 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8012c0:	e8 60 fb ff ff       	call   800e25 <sys_getenvid>
  8012c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012ca:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012d2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8012d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dc:	e9 de 01 00 00       	jmp    8014bf <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  8012e1:	89 d8                	mov    %ebx,%eax
  8012e3:	c1 e8 16             	shr    $0x16,%eax
  8012e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ed:	a8 01                	test   $0x1,%al
  8012ef:	0f 84 58 01 00 00    	je     80144d <fork+0x1b7>
  8012f5:	89 de                	mov    %ebx,%esi
  8012f7:	c1 ee 0c             	shr    $0xc,%esi
  8012fa:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801301:	83 e0 05             	and    $0x5,%eax
  801304:	83 f8 05             	cmp    $0x5,%eax
  801307:	0f 85 40 01 00 00    	jne    80144d <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80130d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801314:	f6 c4 04             	test   $0x4,%ah
  801317:	74 4f                	je     801368 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801319:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801320:	c1 e6 0c             	shl    $0xc,%esi
  801323:	25 07 0e 00 00       	and    $0xe07,%eax
  801328:	89 44 24 10          	mov    %eax,0x10(%esp)
  80132c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801330:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801334:	89 74 24 04          	mov    %esi,0x4(%esp)
  801338:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133f:	e8 73 fb ff ff       	call   800eb7 <sys_page_map>
  801344:	85 c0                	test   %eax,%eax
  801346:	0f 89 01 01 00 00    	jns    80144d <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  80134c:	c7 44 24 08 90 30 80 	movl   $0x803090,0x8(%esp)
  801353:	00 
  801354:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  80135b:	00 
  80135c:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  801363:	e8 c0 ef ff ff       	call   800328 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  801368:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80136f:	a8 02                	test   $0x2,%al
  801371:	75 10                	jne    801383 <fork+0xed>
  801373:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80137a:	f6 c4 08             	test   $0x8,%ah
  80137d:	0f 84 87 00 00 00    	je     80140a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801383:	c1 e6 0c             	shl    $0xc,%esi
  801386:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80138d:	00 
  80138e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801392:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801396:	89 74 24 04          	mov    %esi,0x4(%esp)
  80139a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a1:	e8 11 fb ff ff       	call   800eb7 <sys_page_map>
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	79 1c                	jns    8013c6 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  8013aa:	c7 44 24 08 c8 30 80 	movl   $0x8030c8,0x8(%esp)
  8013b1:	00 
  8013b2:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8013b9:	00 
  8013ba:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  8013c1:	e8 62 ef ff ff       	call   800328 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  8013c6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013cd:	00 
  8013ce:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013d9:	00 
  8013da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e5:	e8 cd fa ff ff       	call   800eb7 <sys_page_map>
  8013ea:	85 c0                	test   %eax,%eax
  8013ec:	79 5f                	jns    80144d <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  8013ee:	c7 44 24 08 00 31 80 	movl   $0x803100,0x8(%esp)
  8013f5:	00 
  8013f6:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8013fd:	00 
  8013fe:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  801405:	e8 1e ef ff ff       	call   800328 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80140a:	c1 e6 0c             	shl    $0xc,%esi
  80140d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801414:	00 
  801415:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801419:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80141d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801421:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801428:	e8 8a fa ff ff       	call   800eb7 <sys_page_map>
  80142d:	85 c0                	test   %eax,%eax
  80142f:	74 1c                	je     80144d <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801431:	c7 44 24 08 28 31 80 	movl   $0x803128,0x8(%esp)
  801438:	00 
  801439:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801440:	00 
  801441:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  801448:	e8 db ee ff ff       	call   800328 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  80144d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801453:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801459:	0f 85 82 fe ff ff    	jne    8012e1 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  80145f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801466:	00 
  801467:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80146e:	ee 
  80146f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801472:	89 04 24             	mov    %eax,(%esp)
  801475:	e8 e9 f9 ff ff       	call   800e63 <sys_page_alloc>
  80147a:	85 c0                	test   %eax,%eax
  80147c:	79 1c                	jns    80149a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  80147e:	c7 44 24 08 5c 31 80 	movl   $0x80315c,0x8(%esp)
  801485:	00 
  801486:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  80148d:	00 
  80148e:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  801495:	e8 8e ee ff ff       	call   800328 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  80149a:	c7 44 24 04 17 28 80 	movl   $0x802817,0x4(%esp)
  8014a1:	00 
  8014a2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8014a5:	89 3c 24             	mov    %edi,(%esp)
  8014a8:	e8 56 fb ff ff       	call   801003 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  8014ad:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8014b4:	00 
  8014b5:	89 3c 24             	mov    %edi,(%esp)
  8014b8:	e8 a0 fa ff ff       	call   800f5d <sys_env_set_status>
		return child;
  8014bd:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  8014bf:	83 c4 2c             	add    $0x2c,%esp
  8014c2:	5b                   	pop    %ebx
  8014c3:	5e                   	pop    %esi
  8014c4:	5f                   	pop    %edi
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    

008014c7 <sfork>:

// Challenge!
int
sfork(void)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8014cd:	c7 44 24 08 a4 31 80 	movl   $0x8031a4,0x8(%esp)
  8014d4:	00 
  8014d5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8014dc:	00 
  8014dd:	c7 04 24 7b 31 80 00 	movl   $0x80317b,(%esp)
  8014e4:	e8 3f ee ff ff       	call   800328 <_panic>
  8014e9:	66 90                	xchg   %ax,%ax
  8014eb:	66 90                	xchg   %ax,%ax
  8014ed:	66 90                	xchg   %ax,%ax
  8014ef:	90                   	nop

008014f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8014fe:	5d                   	pop    %ebp
  8014ff:	c3                   	ret    

00801500 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80150b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801510:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801515:	5d                   	pop    %ebp
  801516:	c3                   	ret    

00801517 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801522:	89 c2                	mov    %eax,%edx
  801524:	c1 ea 16             	shr    $0x16,%edx
  801527:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80152e:	f6 c2 01             	test   $0x1,%dl
  801531:	74 11                	je     801544 <fd_alloc+0x2d>
  801533:	89 c2                	mov    %eax,%edx
  801535:	c1 ea 0c             	shr    $0xc,%edx
  801538:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80153f:	f6 c2 01             	test   $0x1,%dl
  801542:	75 09                	jne    80154d <fd_alloc+0x36>
			*fd_store = fd;
  801544:	89 01                	mov    %eax,(%ecx)
			return 0;
  801546:	b8 00 00 00 00       	mov    $0x0,%eax
  80154b:	eb 17                	jmp    801564 <fd_alloc+0x4d>
  80154d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801552:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801557:	75 c9                	jne    801522 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801559:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80155f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801564:	5d                   	pop    %ebp
  801565:	c3                   	ret    

00801566 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80156c:	83 f8 1f             	cmp    $0x1f,%eax
  80156f:	77 36                	ja     8015a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801571:	c1 e0 0c             	shl    $0xc,%eax
  801574:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801579:	89 c2                	mov    %eax,%edx
  80157b:	c1 ea 16             	shr    $0x16,%edx
  80157e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801585:	f6 c2 01             	test   $0x1,%dl
  801588:	74 24                	je     8015ae <fd_lookup+0x48>
  80158a:	89 c2                	mov    %eax,%edx
  80158c:	c1 ea 0c             	shr    $0xc,%edx
  80158f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801596:	f6 c2 01             	test   $0x1,%dl
  801599:	74 1a                	je     8015b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80159b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159e:	89 02                	mov    %eax,(%edx)
	return 0;
  8015a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a5:	eb 13                	jmp    8015ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015ac:	eb 0c                	jmp    8015ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b3:	eb 05                	jmp    8015ba <fd_lookup+0x54>
  8015b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8015ba:	5d                   	pop    %ebp
  8015bb:	c3                   	ret    

008015bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 18             	sub    $0x18,%esp
  8015c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8015c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ca:	eb 13                	jmp    8015df <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8015cc:	39 08                	cmp    %ecx,(%eax)
  8015ce:	75 0c                	jne    8015dc <dev_lookup+0x20>
			*dev = devtab[i];
  8015d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015da:	eb 38                	jmp    801614 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8015dc:	83 c2 01             	add    $0x1,%edx
  8015df:	8b 04 95 38 32 80 00 	mov    0x803238(,%edx,4),%eax
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	75 e2                	jne    8015cc <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8015ef:	8b 40 48             	mov    0x48(%eax),%eax
  8015f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fa:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801601:	e8 1b ee ff ff       	call   800421 <cprintf>
	*dev = 0;
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80160f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	56                   	push   %esi
  80161a:	53                   	push   %ebx
  80161b:	83 ec 20             	sub    $0x20,%esp
  80161e:	8b 75 08             	mov    0x8(%ebp),%esi
  801621:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801627:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80162b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801631:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801634:	89 04 24             	mov    %eax,(%esp)
  801637:	e8 2a ff ff ff       	call   801566 <fd_lookup>
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 05                	js     801645 <fd_close+0x2f>
	    || fd != fd2)
  801640:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801643:	74 0c                	je     801651 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801645:	84 db                	test   %bl,%bl
  801647:	ba 00 00 00 00       	mov    $0x0,%edx
  80164c:	0f 44 c2             	cmove  %edx,%eax
  80164f:	eb 3f                	jmp    801690 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801651:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801654:	89 44 24 04          	mov    %eax,0x4(%esp)
  801658:	8b 06                	mov    (%esi),%eax
  80165a:	89 04 24             	mov    %eax,(%esp)
  80165d:	e8 5a ff ff ff       	call   8015bc <dev_lookup>
  801662:	89 c3                	mov    %eax,%ebx
  801664:	85 c0                	test   %eax,%eax
  801666:	78 16                	js     80167e <fd_close+0x68>
		if (dev->dev_close)
  801668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80166e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801673:	85 c0                	test   %eax,%eax
  801675:	74 07                	je     80167e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801677:	89 34 24             	mov    %esi,(%esp)
  80167a:	ff d0                	call   *%eax
  80167c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80167e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801682:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801689:	e8 7c f8 ff ff       	call   800f0a <sys_page_unmap>
	return r;
  80168e:	89 d8                	mov    %ebx,%eax
}
  801690:	83 c4 20             	add    $0x20,%esp
  801693:	5b                   	pop    %ebx
  801694:	5e                   	pop    %esi
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80169d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	89 04 24             	mov    %eax,(%esp)
  8016aa:	e8 b7 fe ff ff       	call   801566 <fd_lookup>
  8016af:	89 c2                	mov    %eax,%edx
  8016b1:	85 d2                	test   %edx,%edx
  8016b3:	78 13                	js     8016c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8016b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016bc:	00 
  8016bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c0:	89 04 24             	mov    %eax,(%esp)
  8016c3:	e8 4e ff ff ff       	call   801616 <fd_close>
}
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <close_all>:

void
close_all(void)
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016d6:	89 1c 24             	mov    %ebx,(%esp)
  8016d9:	e8 b9 ff ff ff       	call   801697 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016de:	83 c3 01             	add    $0x1,%ebx
  8016e1:	83 fb 20             	cmp    $0x20,%ebx
  8016e4:	75 f0                	jne    8016d6 <close_all+0xc>
		close(i);
}
  8016e6:	83 c4 14             	add    $0x14,%esp
  8016e9:	5b                   	pop    %ebx
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    

008016ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	57                   	push   %edi
  8016f0:	56                   	push   %esi
  8016f1:	53                   	push   %ebx
  8016f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	89 04 24             	mov    %eax,(%esp)
  801702:	e8 5f fe ff ff       	call   801566 <fd_lookup>
  801707:	89 c2                	mov    %eax,%edx
  801709:	85 d2                	test   %edx,%edx
  80170b:	0f 88 e1 00 00 00    	js     8017f2 <dup+0x106>
		return r;
	close(newfdnum);
  801711:	8b 45 0c             	mov    0xc(%ebp),%eax
  801714:	89 04 24             	mov    %eax,(%esp)
  801717:	e8 7b ff ff ff       	call   801697 <close>

	newfd = INDEX2FD(newfdnum);
  80171c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80171f:	c1 e3 0c             	shl    $0xc,%ebx
  801722:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80172b:	89 04 24             	mov    %eax,(%esp)
  80172e:	e8 cd fd ff ff       	call   801500 <fd2data>
  801733:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801735:	89 1c 24             	mov    %ebx,(%esp)
  801738:	e8 c3 fd ff ff       	call   801500 <fd2data>
  80173d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80173f:	89 f0                	mov    %esi,%eax
  801741:	c1 e8 16             	shr    $0x16,%eax
  801744:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80174b:	a8 01                	test   $0x1,%al
  80174d:	74 43                	je     801792 <dup+0xa6>
  80174f:	89 f0                	mov    %esi,%eax
  801751:	c1 e8 0c             	shr    $0xc,%eax
  801754:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80175b:	f6 c2 01             	test   $0x1,%dl
  80175e:	74 32                	je     801792 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801760:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801767:	25 07 0e 00 00       	and    $0xe07,%eax
  80176c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801770:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801774:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80177b:	00 
  80177c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801780:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801787:	e8 2b f7 ff ff       	call   800eb7 <sys_page_map>
  80178c:	89 c6                	mov    %eax,%esi
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 3e                	js     8017d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801795:	89 c2                	mov    %eax,%edx
  801797:	c1 ea 0c             	shr    $0xc,%edx
  80179a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017b6:	00 
  8017b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c2:	e8 f0 f6 ff ff       	call   800eb7 <sys_page_map>
  8017c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8017c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017cc:	85 f6                	test   %esi,%esi
  8017ce:	79 22                	jns    8017f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017db:	e8 2a f7 ff ff       	call   800f0a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017eb:	e8 1a f7 ff ff       	call   800f0a <sys_page_unmap>
	return r;
  8017f0:	89 f0                	mov    %esi,%eax
}
  8017f2:	83 c4 3c             	add    $0x3c,%esp
  8017f5:	5b                   	pop    %ebx
  8017f6:	5e                   	pop    %esi
  8017f7:	5f                   	pop    %edi
  8017f8:	5d                   	pop    %ebp
  8017f9:	c3                   	ret    

008017fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	53                   	push   %ebx
  8017fe:	83 ec 24             	sub    $0x24,%esp
  801801:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801804:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180b:	89 1c 24             	mov    %ebx,(%esp)
  80180e:	e8 53 fd ff ff       	call   801566 <fd_lookup>
  801813:	89 c2                	mov    %eax,%edx
  801815:	85 d2                	test   %edx,%edx
  801817:	78 6d                	js     801886 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801819:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801823:	8b 00                	mov    (%eax),%eax
  801825:	89 04 24             	mov    %eax,(%esp)
  801828:	e8 8f fd ff ff       	call   8015bc <dev_lookup>
  80182d:	85 c0                	test   %eax,%eax
  80182f:	78 55                	js     801886 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801834:	8b 50 08             	mov    0x8(%eax),%edx
  801837:	83 e2 03             	and    $0x3,%edx
  80183a:	83 fa 01             	cmp    $0x1,%edx
  80183d:	75 23                	jne    801862 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80183f:	a1 08 50 80 00       	mov    0x805008,%eax
  801844:	8b 40 48             	mov    0x48(%eax),%eax
  801847:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80184b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184f:	c7 04 24 fd 31 80 00 	movl   $0x8031fd,(%esp)
  801856:	e8 c6 eb ff ff       	call   800421 <cprintf>
		return -E_INVAL;
  80185b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801860:	eb 24                	jmp    801886 <read+0x8c>
	}
	if (!dev->dev_read)
  801862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801865:	8b 52 08             	mov    0x8(%edx),%edx
  801868:	85 d2                	test   %edx,%edx
  80186a:	74 15                	je     801881 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80186c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801873:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801876:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80187a:	89 04 24             	mov    %eax,(%esp)
  80187d:	ff d2                	call   *%edx
  80187f:	eb 05                	jmp    801886 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801881:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801886:	83 c4 24             	add    $0x24,%esp
  801889:	5b                   	pop    %ebx
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	57                   	push   %edi
  801890:	56                   	push   %esi
  801891:	53                   	push   %ebx
  801892:	83 ec 1c             	sub    $0x1c,%esp
  801895:	8b 7d 08             	mov    0x8(%ebp),%edi
  801898:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80189b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018a0:	eb 23                	jmp    8018c5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018a2:	89 f0                	mov    %esi,%eax
  8018a4:	29 d8                	sub    %ebx,%eax
  8018a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018aa:	89 d8                	mov    %ebx,%eax
  8018ac:	03 45 0c             	add    0xc(%ebp),%eax
  8018af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b3:	89 3c 24             	mov    %edi,(%esp)
  8018b6:	e8 3f ff ff ff       	call   8017fa <read>
		if (m < 0)
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	78 10                	js     8018cf <readn+0x43>
			return m;
		if (m == 0)
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	74 0a                	je     8018cd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018c3:	01 c3                	add    %eax,%ebx
  8018c5:	39 f3                	cmp    %esi,%ebx
  8018c7:	72 d9                	jb     8018a2 <readn+0x16>
  8018c9:	89 d8                	mov    %ebx,%eax
  8018cb:	eb 02                	jmp    8018cf <readn+0x43>
  8018cd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018cf:	83 c4 1c             	add    $0x1c,%esp
  8018d2:	5b                   	pop    %ebx
  8018d3:	5e                   	pop    %esi
  8018d4:	5f                   	pop    %edi
  8018d5:	5d                   	pop    %ebp
  8018d6:	c3                   	ret    

008018d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	53                   	push   %ebx
  8018db:	83 ec 24             	sub    $0x24,%esp
  8018de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e8:	89 1c 24             	mov    %ebx,(%esp)
  8018eb:	e8 76 fc ff ff       	call   801566 <fd_lookup>
  8018f0:	89 c2                	mov    %eax,%edx
  8018f2:	85 d2                	test   %edx,%edx
  8018f4:	78 68                	js     80195e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801900:	8b 00                	mov    (%eax),%eax
  801902:	89 04 24             	mov    %eax,(%esp)
  801905:	e8 b2 fc ff ff       	call   8015bc <dev_lookup>
  80190a:	85 c0                	test   %eax,%eax
  80190c:	78 50                	js     80195e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80190e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801911:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801915:	75 23                	jne    80193a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801917:	a1 08 50 80 00       	mov    0x805008,%eax
  80191c:	8b 40 48             	mov    0x48(%eax),%eax
  80191f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801923:	89 44 24 04          	mov    %eax,0x4(%esp)
  801927:	c7 04 24 19 32 80 00 	movl   $0x803219,(%esp)
  80192e:	e8 ee ea ff ff       	call   800421 <cprintf>
		return -E_INVAL;
  801933:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801938:	eb 24                	jmp    80195e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80193a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193d:	8b 52 0c             	mov    0xc(%edx),%edx
  801940:	85 d2                	test   %edx,%edx
  801942:	74 15                	je     801959 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801944:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801947:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80194b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80194e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801952:	89 04 24             	mov    %eax,(%esp)
  801955:	ff d2                	call   *%edx
  801957:	eb 05                	jmp    80195e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801959:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80195e:	83 c4 24             	add    $0x24,%esp
  801961:	5b                   	pop    %ebx
  801962:	5d                   	pop    %ebp
  801963:	c3                   	ret    

00801964 <seek>:

int
seek(int fdnum, off_t offset)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80196a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80196d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	89 04 24             	mov    %eax,(%esp)
  801977:	e8 ea fb ff ff       	call   801566 <fd_lookup>
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 0e                	js     80198e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801980:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801983:	8b 55 0c             	mov    0xc(%ebp),%edx
  801986:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801989:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	53                   	push   %ebx
  801994:	83 ec 24             	sub    $0x24,%esp
  801997:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80199a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80199d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a1:	89 1c 24             	mov    %ebx,(%esp)
  8019a4:	e8 bd fb ff ff       	call   801566 <fd_lookup>
  8019a9:	89 c2                	mov    %eax,%edx
  8019ab:	85 d2                	test   %edx,%edx
  8019ad:	78 61                	js     801a10 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b9:	8b 00                	mov    (%eax),%eax
  8019bb:	89 04 24             	mov    %eax,(%esp)
  8019be:	e8 f9 fb ff ff       	call   8015bc <dev_lookup>
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	78 49                	js     801a10 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019ce:	75 23                	jne    8019f3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019d0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019d5:	8b 40 48             	mov    0x48(%eax),%eax
  8019d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e0:	c7 04 24 dc 31 80 00 	movl   $0x8031dc,(%esp)
  8019e7:	e8 35 ea ff ff       	call   800421 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8019ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019f1:	eb 1d                	jmp    801a10 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8019f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f6:	8b 52 18             	mov    0x18(%edx),%edx
  8019f9:	85 d2                	test   %edx,%edx
  8019fb:	74 0e                	je     801a0b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a00:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a04:	89 04 24             	mov    %eax,(%esp)
  801a07:	ff d2                	call   *%edx
  801a09:	eb 05                	jmp    801a10 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a10:	83 c4 24             	add    $0x24,%esp
  801a13:	5b                   	pop    %ebx
  801a14:	5d                   	pop    %ebp
  801a15:	c3                   	ret    

00801a16 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	53                   	push   %ebx
  801a1a:	83 ec 24             	sub    $0x24,%esp
  801a1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a20:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	89 04 24             	mov    %eax,(%esp)
  801a2d:	e8 34 fb ff ff       	call   801566 <fd_lookup>
  801a32:	89 c2                	mov    %eax,%edx
  801a34:	85 d2                	test   %edx,%edx
  801a36:	78 52                	js     801a8a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a42:	8b 00                	mov    (%eax),%eax
  801a44:	89 04 24             	mov    %eax,(%esp)
  801a47:	e8 70 fb ff ff       	call   8015bc <dev_lookup>
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 3a                	js     801a8a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a53:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a57:	74 2c                	je     801a85 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a59:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a5c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a63:	00 00 00 
	stat->st_isdir = 0;
  801a66:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a6d:	00 00 00 
	stat->st_dev = dev;
  801a70:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a7d:	89 14 24             	mov    %edx,(%esp)
  801a80:	ff 50 14             	call   *0x14(%eax)
  801a83:	eb 05                	jmp    801a8a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a8a:	83 c4 24             	add    $0x24,%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5d                   	pop    %ebp
  801a8f:	c3                   	ret    

00801a90 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	56                   	push   %esi
  801a94:	53                   	push   %ebx
  801a95:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a9f:	00 
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	89 04 24             	mov    %eax,(%esp)
  801aa6:	e8 28 02 00 00       	call   801cd3 <open>
  801aab:	89 c3                	mov    %eax,%ebx
  801aad:	85 db                	test   %ebx,%ebx
  801aaf:	78 1b                	js     801acc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab8:	89 1c 24             	mov    %ebx,(%esp)
  801abb:	e8 56 ff ff ff       	call   801a16 <fstat>
  801ac0:	89 c6                	mov    %eax,%esi
	close(fd);
  801ac2:	89 1c 24             	mov    %ebx,(%esp)
  801ac5:	e8 cd fb ff ff       	call   801697 <close>
	return r;
  801aca:	89 f0                	mov    %esi,%eax
}
  801acc:	83 c4 10             	add    $0x10,%esp
  801acf:	5b                   	pop    %ebx
  801ad0:	5e                   	pop    %esi
  801ad1:	5d                   	pop    %ebp
  801ad2:	c3                   	ret    

00801ad3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	56                   	push   %esi
  801ad7:	53                   	push   %ebx
  801ad8:	83 ec 10             	sub    $0x10,%esp
  801adb:	89 c6                	mov    %eax,%esi
  801add:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801adf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ae6:	75 11                	jne    801af9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ae8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801aef:	e8 12 0e 00 00       	call   802906 <ipc_find_env>
  801af4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801af9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b00:	00 
  801b01:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b08:	00 
  801b09:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b0d:	a1 00 50 80 00       	mov    0x805000,%eax
  801b12:	89 04 24             	mov    %eax,(%esp)
  801b15:	e8 8e 0d 00 00       	call   8028a8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b21:	00 
  801b22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2d:	e8 0c 0d 00 00       	call   80283e <ipc_recv>
}
  801b32:	83 c4 10             	add    $0x10,%esp
  801b35:	5b                   	pop    %ebx
  801b36:	5e                   	pop    %esi
  801b37:	5d                   	pop    %ebp
  801b38:	c3                   	ret    

00801b39 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	8b 40 0c             	mov    0xc(%eax),%eax
  801b45:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b52:	ba 00 00 00 00       	mov    $0x0,%edx
  801b57:	b8 02 00 00 00       	mov    $0x2,%eax
  801b5c:	e8 72 ff ff ff       	call   801ad3 <fsipc>
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b74:	ba 00 00 00 00       	mov    $0x0,%edx
  801b79:	b8 06 00 00 00       	mov    $0x6,%eax
  801b7e:	e8 50 ff ff ff       	call   801ad3 <fsipc>
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	53                   	push   %ebx
  801b89:	83 ec 14             	sub    $0x14,%esp
  801b8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	8b 40 0c             	mov    0xc(%eax),%eax
  801b95:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9f:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba4:	e8 2a ff ff ff       	call   801ad3 <fsipc>
  801ba9:	89 c2                	mov    %eax,%edx
  801bab:	85 d2                	test   %edx,%edx
  801bad:	78 2b                	js     801bda <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801baf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bb6:	00 
  801bb7:	89 1c 24             	mov    %ebx,(%esp)
  801bba:	e8 88 ee ff ff       	call   800a47 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bbf:	a1 80 60 80 00       	mov    0x806080,%eax
  801bc4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bca:	a1 84 60 80 00       	mov    0x806084,%eax
  801bcf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bda:	83 c4 14             	add    $0x14,%esp
  801bdd:	5b                   	pop    %ebx
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    

00801be0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 18             	sub    $0x18,%esp
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801bee:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801bf3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801bf6:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  801bfe:	8b 52 0c             	mov    0xc(%edx),%edx
  801c01:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801c07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c12:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c19:	e8 c6 ef ff ff       	call   800be4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c23:	b8 04 00 00 00       	mov    $0x4,%eax
  801c28:	e8 a6 fe ff ff       	call   801ad3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	83 ec 10             	sub    $0x10,%esp
  801c37:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c40:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c45:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c50:	b8 03 00 00 00       	mov    $0x3,%eax
  801c55:	e8 79 fe ff ff       	call   801ad3 <fsipc>
  801c5a:	89 c3                	mov    %eax,%ebx
  801c5c:	85 c0                	test   %eax,%eax
  801c5e:	78 6a                	js     801cca <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c60:	39 c6                	cmp    %eax,%esi
  801c62:	73 24                	jae    801c88 <devfile_read+0x59>
  801c64:	c7 44 24 0c 4c 32 80 	movl   $0x80324c,0xc(%esp)
  801c6b:	00 
  801c6c:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  801c73:	00 
  801c74:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c7b:	00 
  801c7c:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  801c83:	e8 a0 e6 ff ff       	call   800328 <_panic>
	assert(r <= PGSIZE);
  801c88:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c8d:	7e 24                	jle    801cb3 <devfile_read+0x84>
  801c8f:	c7 44 24 0c 73 32 80 	movl   $0x803273,0xc(%esp)
  801c96:	00 
  801c97:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  801c9e:	00 
  801c9f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ca6:	00 
  801ca7:	c7 04 24 68 32 80 00 	movl   $0x803268,(%esp)
  801cae:	e8 75 e6 ff ff       	call   800328 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cb7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cbe:	00 
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	89 04 24             	mov    %eax,(%esp)
  801cc5:	e8 1a ef ff ff       	call   800be4 <memmove>
	return r;
}
  801cca:	89 d8                	mov    %ebx,%eax
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	53                   	push   %ebx
  801cd7:	83 ec 24             	sub    $0x24,%esp
  801cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801cdd:	89 1c 24             	mov    %ebx,(%esp)
  801ce0:	e8 2b ed ff ff       	call   800a10 <strlen>
  801ce5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cea:	7f 60                	jg     801d4c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801cec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cef:	89 04 24             	mov    %eax,(%esp)
  801cf2:	e8 20 f8 ff ff       	call   801517 <fd_alloc>
  801cf7:	89 c2                	mov    %eax,%edx
  801cf9:	85 d2                	test   %edx,%edx
  801cfb:	78 54                	js     801d51 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801cfd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d01:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d08:	e8 3a ed ff ff       	call   800a47 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d10:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d18:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1d:	e8 b1 fd ff ff       	call   801ad3 <fsipc>
  801d22:	89 c3                	mov    %eax,%ebx
  801d24:	85 c0                	test   %eax,%eax
  801d26:	79 17                	jns    801d3f <open+0x6c>
		fd_close(fd, 0);
  801d28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d2f:	00 
  801d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d33:	89 04 24             	mov    %eax,(%esp)
  801d36:	e8 db f8 ff ff       	call   801616 <fd_close>
		return r;
  801d3b:	89 d8                	mov    %ebx,%eax
  801d3d:	eb 12                	jmp    801d51 <open+0x7e>
	}

	return fd2num(fd);
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	89 04 24             	mov    %eax,(%esp)
  801d45:	e8 a6 f7 ff ff       	call   8014f0 <fd2num>
  801d4a:	eb 05                	jmp    801d51 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d4c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801d51:	83 c4 24             	add    $0x24,%esp
  801d54:	5b                   	pop    %ebx
  801d55:	5d                   	pop    %ebp
  801d56:	c3                   	ret    

00801d57 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d62:	b8 08 00 00 00       	mov    $0x8,%eax
  801d67:	e8 67 fd ff ff       	call   801ad3 <fsipc>
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    
  801d6e:	66 90                	xchg   %ax,%ax

00801d70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d76:	c7 44 24 04 7f 32 80 	movl   $0x80327f,0x4(%esp)
  801d7d:	00 
  801d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d81:	89 04 24             	mov    %eax,(%esp)
  801d84:	e8 be ec ff ff       	call   800a47 <strcpy>
	return 0;
}
  801d89:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	53                   	push   %ebx
  801d94:	83 ec 14             	sub    $0x14,%esp
  801d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d9a:	89 1c 24             	mov    %ebx,(%esp)
  801d9d:	e8 9c 0b 00 00       	call   80293e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801da2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801da7:	83 f8 01             	cmp    $0x1,%eax
  801daa:	75 0d                	jne    801db9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801dac:	8b 43 0c             	mov    0xc(%ebx),%eax
  801daf:	89 04 24             	mov    %eax,(%esp)
  801db2:	e8 29 03 00 00       	call   8020e0 <nsipc_close>
  801db7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801db9:	89 d0                	mov    %edx,%eax
  801dbb:	83 c4 14             	add    $0x14,%esp
  801dbe:	5b                   	pop    %ebx
  801dbf:	5d                   	pop    %ebp
  801dc0:	c3                   	ret    

00801dc1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801dc7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dce:	00 
  801dcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	8b 40 0c             	mov    0xc(%eax),%eax
  801de3:	89 04 24             	mov    %eax,(%esp)
  801de6:	e8 f0 03 00 00       	call   8021db <nsipc_send>
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801df3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801dfa:	00 
  801dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0f:	89 04 24             	mov    %eax,(%esp)
  801e12:	e8 44 03 00 00       	call   80215b <nsipc_recv>
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e1f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e22:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e26:	89 04 24             	mov    %eax,(%esp)
  801e29:	e8 38 f7 ff ff       	call   801566 <fd_lookup>
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 17                	js     801e49 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e3b:	39 08                	cmp    %ecx,(%eax)
  801e3d:	75 05                	jne    801e44 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e42:	eb 05                	jmp    801e49 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801e44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801e49:	c9                   	leave  
  801e4a:	c3                   	ret    

00801e4b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801e4b:	55                   	push   %ebp
  801e4c:	89 e5                	mov    %esp,%ebp
  801e4e:	56                   	push   %esi
  801e4f:	53                   	push   %ebx
  801e50:	83 ec 20             	sub    $0x20,%esp
  801e53:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e58:	89 04 24             	mov    %eax,(%esp)
  801e5b:	e8 b7 f6 ff ff       	call   801517 <fd_alloc>
  801e60:	89 c3                	mov    %eax,%ebx
  801e62:	85 c0                	test   %eax,%eax
  801e64:	78 21                	js     801e87 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801e66:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801e6d:	00 
  801e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e7c:	e8 e2 ef ff ff       	call   800e63 <sys_page_alloc>
  801e81:	89 c3                	mov    %eax,%ebx
  801e83:	85 c0                	test   %eax,%eax
  801e85:	79 0c                	jns    801e93 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e87:	89 34 24             	mov    %esi,(%esp)
  801e8a:	e8 51 02 00 00       	call   8020e0 <nsipc_close>
		return r;
  801e8f:	89 d8                	mov    %ebx,%eax
  801e91:	eb 20                	jmp    801eb3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e93:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801ea8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801eab:	89 14 24             	mov    %edx,(%esp)
  801eae:	e8 3d f6 ff ff       	call   8014f0 <fd2num>
}
  801eb3:	83 c4 20             	add    $0x20,%esp
  801eb6:	5b                   	pop    %ebx
  801eb7:	5e                   	pop    %esi
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    

00801eba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	e8 51 ff ff ff       	call   801e19 <fd2sockid>
		return r;
  801ec8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	78 23                	js     801ef1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ece:	8b 55 10             	mov    0x10(%ebp),%edx
  801ed1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801edc:	89 04 24             	mov    %eax,(%esp)
  801edf:	e8 45 01 00 00       	call   802029 <nsipc_accept>
		return r;
  801ee4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	78 07                	js     801ef1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801eea:	e8 5c ff ff ff       	call   801e4b <alloc_sockfd>
  801eef:	89 c1                	mov    %eax,%ecx
}
  801ef1:	89 c8                	mov    %ecx,%eax
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	e8 16 ff ff ff       	call   801e19 <fd2sockid>
  801f03:	89 c2                	mov    %eax,%edx
  801f05:	85 d2                	test   %edx,%edx
  801f07:	78 16                	js     801f1f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801f09:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f17:	89 14 24             	mov    %edx,(%esp)
  801f1a:	e8 60 01 00 00       	call   80207f <nsipc_bind>
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <shutdown>:

int
shutdown(int s, int how)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	e8 ea fe ff ff       	call   801e19 <fd2sockid>
  801f2f:	89 c2                	mov    %eax,%edx
  801f31:	85 d2                	test   %edx,%edx
  801f33:	78 0f                	js     801f44 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3c:	89 14 24             	mov    %edx,(%esp)
  801f3f:	e8 7a 01 00 00       	call   8020be <nsipc_shutdown>
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	e8 c5 fe ff ff       	call   801e19 <fd2sockid>
  801f54:	89 c2                	mov    %eax,%edx
  801f56:	85 d2                	test   %edx,%edx
  801f58:	78 16                	js     801f70 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f68:	89 14 24             	mov    %edx,(%esp)
  801f6b:	e8 8a 01 00 00       	call   8020fa <nsipc_connect>
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <listen>:

int
listen(int s, int backlog)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7b:	e8 99 fe ff ff       	call   801e19 <fd2sockid>
  801f80:	89 c2                	mov    %eax,%edx
  801f82:	85 d2                	test   %edx,%edx
  801f84:	78 0f                	js     801f95 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8d:	89 14 24             	mov    %edx,(%esp)
  801f90:	e8 a4 01 00 00       	call   802139 <nsipc_listen>
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801fa0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fab:	8b 45 08             	mov    0x8(%ebp),%eax
  801fae:	89 04 24             	mov    %eax,(%esp)
  801fb1:	e8 98 02 00 00       	call   80224e <nsipc_socket>
  801fb6:	89 c2                	mov    %eax,%edx
  801fb8:	85 d2                	test   %edx,%edx
  801fba:	78 05                	js     801fc1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801fbc:	e8 8a fe ff ff       	call   801e4b <alloc_sockfd>
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
  801fc6:	53                   	push   %ebx
  801fc7:	83 ec 14             	sub    $0x14,%esp
  801fca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801fcc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801fd3:	75 11                	jne    801fe6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801fd5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801fdc:	e8 25 09 00 00       	call   802906 <ipc_find_env>
  801fe1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801fe6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801fed:	00 
  801fee:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801ff5:	00 
  801ff6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ffa:	a1 04 50 80 00       	mov    0x805004,%eax
  801fff:	89 04 24             	mov    %eax,(%esp)
  802002:	e8 a1 08 00 00       	call   8028a8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802007:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80200e:	00 
  80200f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802016:	00 
  802017:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80201e:	e8 1b 08 00 00       	call   80283e <ipc_recv>
}
  802023:	83 c4 14             	add    $0x14,%esp
  802026:	5b                   	pop    %ebx
  802027:	5d                   	pop    %ebp
  802028:	c3                   	ret    

00802029 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	56                   	push   %esi
  80202d:	53                   	push   %ebx
  80202e:	83 ec 10             	sub    $0x10,%esp
  802031:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80203c:	8b 06                	mov    (%esi),%eax
  80203e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802043:	b8 01 00 00 00       	mov    $0x1,%eax
  802048:	e8 76 ff ff ff       	call   801fc3 <nsipc>
  80204d:	89 c3                	mov    %eax,%ebx
  80204f:	85 c0                	test   %eax,%eax
  802051:	78 23                	js     802076 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802053:	a1 10 70 80 00       	mov    0x807010,%eax
  802058:	89 44 24 08          	mov    %eax,0x8(%esp)
  80205c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802063:	00 
  802064:	8b 45 0c             	mov    0xc(%ebp),%eax
  802067:	89 04 24             	mov    %eax,(%esp)
  80206a:	e8 75 eb ff ff       	call   800be4 <memmove>
		*addrlen = ret->ret_addrlen;
  80206f:	a1 10 70 80 00       	mov    0x807010,%eax
  802074:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802076:	89 d8                	mov    %ebx,%eax
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	5b                   	pop    %ebx
  80207c:	5e                   	pop    %esi
  80207d:	5d                   	pop    %ebp
  80207e:	c3                   	ret    

0080207f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	53                   	push   %ebx
  802083:	83 ec 14             	sub    $0x14,%esp
  802086:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802091:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802095:	8b 45 0c             	mov    0xc(%ebp),%eax
  802098:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020a3:	e8 3c eb ff ff       	call   800be4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020a8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8020b3:	e8 0b ff ff ff       	call   801fc3 <nsipc>
}
  8020b8:	83 c4 14             	add    $0x14,%esp
  8020bb:	5b                   	pop    %ebx
  8020bc:	5d                   	pop    %ebp
  8020bd:	c3                   	ret    

008020be <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8020cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020cf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8020d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8020d9:	e8 e5 fe ff ff       	call   801fc3 <nsipc>
}
  8020de:	c9                   	leave  
  8020df:	c3                   	ret    

008020e0 <nsipc_close>:

int
nsipc_close(int s)
{
  8020e0:	55                   	push   %ebp
  8020e1:	89 e5                	mov    %esp,%ebp
  8020e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8020ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8020f3:	e8 cb fe ff ff       	call   801fc3 <nsipc>
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
  8020fd:	53                   	push   %ebx
  8020fe:	83 ec 14             	sub    $0x14,%esp
  802101:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80210c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802110:	8b 45 0c             	mov    0xc(%ebp),%eax
  802113:	89 44 24 04          	mov    %eax,0x4(%esp)
  802117:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80211e:	e8 c1 ea ff ff       	call   800be4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802123:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802129:	b8 05 00 00 00       	mov    $0x5,%eax
  80212e:	e8 90 fe ff ff       	call   801fc3 <nsipc>
}
  802133:	83 c4 14             	add    $0x14,%esp
  802136:	5b                   	pop    %ebx
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    

00802139 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80214f:	b8 06 00 00 00       	mov    $0x6,%eax
  802154:	e8 6a fe ff ff       	call   801fc3 <nsipc>
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	56                   	push   %esi
  80215f:	53                   	push   %ebx
  802160:	83 ec 10             	sub    $0x10,%esp
  802163:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80216e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802174:	8b 45 14             	mov    0x14(%ebp),%eax
  802177:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80217c:	b8 07 00 00 00       	mov    $0x7,%eax
  802181:	e8 3d fe ff ff       	call   801fc3 <nsipc>
  802186:	89 c3                	mov    %eax,%ebx
  802188:	85 c0                	test   %eax,%eax
  80218a:	78 46                	js     8021d2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80218c:	39 f0                	cmp    %esi,%eax
  80218e:	7f 07                	jg     802197 <nsipc_recv+0x3c>
  802190:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802195:	7e 24                	jle    8021bb <nsipc_recv+0x60>
  802197:	c7 44 24 0c 8b 32 80 	movl   $0x80328b,0xc(%esp)
  80219e:	00 
  80219f:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  8021a6:	00 
  8021a7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8021ae:	00 
  8021af:	c7 04 24 a0 32 80 00 	movl   $0x8032a0,(%esp)
  8021b6:	e8 6d e1 ff ff       	call   800328 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021bf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021c6:	00 
  8021c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ca:	89 04 24             	mov    %eax,(%esp)
  8021cd:	e8 12 ea ff ff       	call   800be4 <memmove>
	}

	return r;
}
  8021d2:	89 d8                	mov    %ebx,%eax
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	5b                   	pop    %ebx
  8021d8:	5e                   	pop    %esi
  8021d9:	5d                   	pop    %ebp
  8021da:	c3                   	ret    

008021db <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	53                   	push   %ebx
  8021df:	83 ec 14             	sub    $0x14,%esp
  8021e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8021ed:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021f3:	7e 24                	jle    802219 <nsipc_send+0x3e>
  8021f5:	c7 44 24 0c ac 32 80 	movl   $0x8032ac,0xc(%esp)
  8021fc:	00 
  8021fd:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  802204:	00 
  802205:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80220c:	00 
  80220d:	c7 04 24 a0 32 80 00 	movl   $0x8032a0,(%esp)
  802214:	e8 0f e1 ff ff       	call   800328 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802219:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80221d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802220:	89 44 24 04          	mov    %eax,0x4(%esp)
  802224:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80222b:	e8 b4 e9 ff ff       	call   800be4 <memmove>
	nsipcbuf.send.req_size = size;
  802230:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802236:	8b 45 14             	mov    0x14(%ebp),%eax
  802239:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80223e:	b8 08 00 00 00       	mov    $0x8,%eax
  802243:	e8 7b fd ff ff       	call   801fc3 <nsipc>
}
  802248:	83 c4 14             	add    $0x14,%esp
  80224b:	5b                   	pop    %ebx
  80224c:	5d                   	pop    %ebp
  80224d:	c3                   	ret    

0080224e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80225c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802264:	8b 45 10             	mov    0x10(%ebp),%eax
  802267:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80226c:	b8 09 00 00 00       	mov    $0x9,%eax
  802271:	e8 4d fd ff ff       	call   801fc3 <nsipc>
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	56                   	push   %esi
  80227c:	53                   	push   %ebx
  80227d:	83 ec 10             	sub    $0x10,%esp
  802280:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	89 04 24             	mov    %eax,(%esp)
  802289:	e8 72 f2 ff ff       	call   801500 <fd2data>
  80228e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802290:	c7 44 24 04 b8 32 80 	movl   $0x8032b8,0x4(%esp)
  802297:	00 
  802298:	89 1c 24             	mov    %ebx,(%esp)
  80229b:	e8 a7 e7 ff ff       	call   800a47 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022a0:	8b 46 04             	mov    0x4(%esi),%eax
  8022a3:	2b 06                	sub    (%esi),%eax
  8022a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022b2:	00 00 00 
	stat->st_dev = &devpipe;
  8022b5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022bc:	40 80 00 
	return 0;
}
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	83 c4 10             	add    $0x10,%esp
  8022c7:	5b                   	pop    %ebx
  8022c8:	5e                   	pop    %esi
  8022c9:	5d                   	pop    %ebp
  8022ca:	c3                   	ret    

008022cb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	53                   	push   %ebx
  8022cf:	83 ec 14             	sub    $0x14,%esp
  8022d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8022d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e0:	e8 25 ec ff ff       	call   800f0a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8022e5:	89 1c 24             	mov    %ebx,(%esp)
  8022e8:	e8 13 f2 ff ff       	call   801500 <fd2data>
  8022ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f8:	e8 0d ec ff ff       	call   800f0a <sys_page_unmap>
}
  8022fd:	83 c4 14             	add    $0x14,%esp
  802300:	5b                   	pop    %ebx
  802301:	5d                   	pop    %ebp
  802302:	c3                   	ret    

00802303 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	57                   	push   %edi
  802307:	56                   	push   %esi
  802308:	53                   	push   %ebx
  802309:	83 ec 2c             	sub    $0x2c,%esp
  80230c:	89 c6                	mov    %eax,%esi
  80230e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802311:	a1 08 50 80 00       	mov    0x805008,%eax
  802316:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802319:	89 34 24             	mov    %esi,(%esp)
  80231c:	e8 1d 06 00 00       	call   80293e <pageref>
  802321:	89 c7                	mov    %eax,%edi
  802323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802326:	89 04 24             	mov    %eax,(%esp)
  802329:	e8 10 06 00 00       	call   80293e <pageref>
  80232e:	39 c7                	cmp    %eax,%edi
  802330:	0f 94 c2             	sete   %dl
  802333:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802336:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80233c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80233f:	39 fb                	cmp    %edi,%ebx
  802341:	74 21                	je     802364 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802343:	84 d2                	test   %dl,%dl
  802345:	74 ca                	je     802311 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802347:	8b 51 58             	mov    0x58(%ecx),%edx
  80234a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80234e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802352:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802356:	c7 04 24 bf 32 80 00 	movl   $0x8032bf,(%esp)
  80235d:	e8 bf e0 ff ff       	call   800421 <cprintf>
  802362:	eb ad                	jmp    802311 <_pipeisclosed+0xe>
	}
}
  802364:	83 c4 2c             	add    $0x2c,%esp
  802367:	5b                   	pop    %ebx
  802368:	5e                   	pop    %esi
  802369:	5f                   	pop    %edi
  80236a:	5d                   	pop    %ebp
  80236b:	c3                   	ret    

0080236c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	57                   	push   %edi
  802370:	56                   	push   %esi
  802371:	53                   	push   %ebx
  802372:	83 ec 1c             	sub    $0x1c,%esp
  802375:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802378:	89 34 24             	mov    %esi,(%esp)
  80237b:	e8 80 f1 ff ff       	call   801500 <fd2data>
  802380:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802382:	bf 00 00 00 00       	mov    $0x0,%edi
  802387:	eb 45                	jmp    8023ce <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802389:	89 da                	mov    %ebx,%edx
  80238b:	89 f0                	mov    %esi,%eax
  80238d:	e8 71 ff ff ff       	call   802303 <_pipeisclosed>
  802392:	85 c0                	test   %eax,%eax
  802394:	75 41                	jne    8023d7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802396:	e8 a9 ea ff ff       	call   800e44 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80239b:	8b 43 04             	mov    0x4(%ebx),%eax
  80239e:	8b 0b                	mov    (%ebx),%ecx
  8023a0:	8d 51 20             	lea    0x20(%ecx),%edx
  8023a3:	39 d0                	cmp    %edx,%eax
  8023a5:	73 e2                	jae    802389 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023b1:	99                   	cltd   
  8023b2:	c1 ea 1b             	shr    $0x1b,%edx
  8023b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8023b8:	83 e1 1f             	and    $0x1f,%ecx
  8023bb:	29 d1                	sub    %edx,%ecx
  8023bd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8023c1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8023c5:	83 c0 01             	add    $0x1,%eax
  8023c8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023cb:	83 c7 01             	add    $0x1,%edi
  8023ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8023d1:	75 c8                	jne    80239b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8023d3:	89 f8                	mov    %edi,%eax
  8023d5:	eb 05                	jmp    8023dc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8023dc:	83 c4 1c             	add    $0x1c,%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5f                   	pop    %edi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    

008023e4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	57                   	push   %edi
  8023e8:	56                   	push   %esi
  8023e9:	53                   	push   %ebx
  8023ea:	83 ec 1c             	sub    $0x1c,%esp
  8023ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8023f0:	89 3c 24             	mov    %edi,(%esp)
  8023f3:	e8 08 f1 ff ff       	call   801500 <fd2data>
  8023f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023fa:	be 00 00 00 00       	mov    $0x0,%esi
  8023ff:	eb 3d                	jmp    80243e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802401:	85 f6                	test   %esi,%esi
  802403:	74 04                	je     802409 <devpipe_read+0x25>
				return i;
  802405:	89 f0                	mov    %esi,%eax
  802407:	eb 43                	jmp    80244c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802409:	89 da                	mov    %ebx,%edx
  80240b:	89 f8                	mov    %edi,%eax
  80240d:	e8 f1 fe ff ff       	call   802303 <_pipeisclosed>
  802412:	85 c0                	test   %eax,%eax
  802414:	75 31                	jne    802447 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802416:	e8 29 ea ff ff       	call   800e44 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80241b:	8b 03                	mov    (%ebx),%eax
  80241d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802420:	74 df                	je     802401 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802422:	99                   	cltd   
  802423:	c1 ea 1b             	shr    $0x1b,%edx
  802426:	01 d0                	add    %edx,%eax
  802428:	83 e0 1f             	and    $0x1f,%eax
  80242b:	29 d0                	sub    %edx,%eax
  80242d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802432:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802435:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802438:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80243b:	83 c6 01             	add    $0x1,%esi
  80243e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802441:	75 d8                	jne    80241b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802443:	89 f0                	mov    %esi,%eax
  802445:	eb 05                	jmp    80244c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80244c:	83 c4 1c             	add    $0x1c,%esp
  80244f:	5b                   	pop    %ebx
  802450:	5e                   	pop    %esi
  802451:	5f                   	pop    %edi
  802452:	5d                   	pop    %ebp
  802453:	c3                   	ret    

00802454 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	56                   	push   %esi
  802458:	53                   	push   %ebx
  802459:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80245c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80245f:	89 04 24             	mov    %eax,(%esp)
  802462:	e8 b0 f0 ff ff       	call   801517 <fd_alloc>
  802467:	89 c2                	mov    %eax,%edx
  802469:	85 d2                	test   %edx,%edx
  80246b:	0f 88 4d 01 00 00    	js     8025be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802471:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802478:	00 
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802480:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802487:	e8 d7 e9 ff ff       	call   800e63 <sys_page_alloc>
  80248c:	89 c2                	mov    %eax,%edx
  80248e:	85 d2                	test   %edx,%edx
  802490:	0f 88 28 01 00 00    	js     8025be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802496:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802499:	89 04 24             	mov    %eax,(%esp)
  80249c:	e8 76 f0 ff ff       	call   801517 <fd_alloc>
  8024a1:	89 c3                	mov    %eax,%ebx
  8024a3:	85 c0                	test   %eax,%eax
  8024a5:	0f 88 fe 00 00 00    	js     8025a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024b2:	00 
  8024b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c1:	e8 9d e9 ff ff       	call   800e63 <sys_page_alloc>
  8024c6:	89 c3                	mov    %eax,%ebx
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	0f 88 d9 00 00 00    	js     8025a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	89 04 24             	mov    %eax,(%esp)
  8024d6:	e8 25 f0 ff ff       	call   801500 <fd2data>
  8024db:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024dd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024e4:	00 
  8024e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024f0:	e8 6e e9 ff ff       	call   800e63 <sys_page_alloc>
  8024f5:	89 c3                	mov    %eax,%ebx
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	0f 88 97 00 00 00    	js     802596 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	89 04 24             	mov    %eax,(%esp)
  802505:	e8 f6 ef ff ff       	call   801500 <fd2data>
  80250a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802511:	00 
  802512:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802516:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80251d:	00 
  80251e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802522:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802529:	e8 89 e9 ff ff       	call   800eb7 <sys_page_map>
  80252e:	89 c3                	mov    %eax,%ebx
  802530:	85 c0                	test   %eax,%eax
  802532:	78 52                	js     802586 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802534:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802549:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80254f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802552:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802557:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	89 04 24             	mov    %eax,(%esp)
  802564:	e8 87 ef ff ff       	call   8014f0 <fd2num>
  802569:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80256c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80256e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802571:	89 04 24             	mov    %eax,(%esp)
  802574:	e8 77 ef ff ff       	call   8014f0 <fd2num>
  802579:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80257c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80257f:	b8 00 00 00 00       	mov    $0x0,%eax
  802584:	eb 38                	jmp    8025be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802586:	89 74 24 04          	mov    %esi,0x4(%esp)
  80258a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802591:	e8 74 e9 ff ff       	call   800f0a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80259d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a4:	e8 61 e9 ff ff       	call   800f0a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025b7:	e8 4e e9 ff ff       	call   800f0a <sys_page_unmap>
  8025bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8025be:	83 c4 30             	add    $0x30,%esp
  8025c1:	5b                   	pop    %ebx
  8025c2:	5e                   	pop    %esi
  8025c3:	5d                   	pop    %ebp
  8025c4:	c3                   	ret    

008025c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
  8025c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	89 04 24             	mov    %eax,(%esp)
  8025d8:	e8 89 ef ff ff       	call   801566 <fd_lookup>
  8025dd:	89 c2                	mov    %eax,%edx
  8025df:	85 d2                	test   %edx,%edx
  8025e1:	78 15                	js     8025f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	89 04 24             	mov    %eax,(%esp)
  8025e9:	e8 12 ef ff ff       	call   801500 <fd2data>
	return _pipeisclosed(fd, p);
  8025ee:	89 c2                	mov    %eax,%edx
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	e8 0b fd ff ff       	call   802303 <_pipeisclosed>
}
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    
  8025fa:	66 90                	xchg   %ax,%ax
  8025fc:	66 90                	xchg   %ax,%ax
  8025fe:	66 90                	xchg   %ax,%ax

00802600 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
  802608:	5d                   	pop    %ebp
  802609:	c3                   	ret    

0080260a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802610:	c7 44 24 04 d2 32 80 	movl   $0x8032d2,0x4(%esp)
  802617:	00 
  802618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80261b:	89 04 24             	mov    %eax,(%esp)
  80261e:	e8 24 e4 ff ff       	call   800a47 <strcpy>
	return 0;
}
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
  80262d:	57                   	push   %edi
  80262e:	56                   	push   %esi
  80262f:	53                   	push   %ebx
  802630:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802636:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80263b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802641:	eb 31                	jmp    802674 <devcons_write+0x4a>
		m = n - tot;
  802643:	8b 75 10             	mov    0x10(%ebp),%esi
  802646:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802648:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80264b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802650:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802653:	89 74 24 08          	mov    %esi,0x8(%esp)
  802657:	03 45 0c             	add    0xc(%ebp),%eax
  80265a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80265e:	89 3c 24             	mov    %edi,(%esp)
  802661:	e8 7e e5 ff ff       	call   800be4 <memmove>
		sys_cputs(buf, m);
  802666:	89 74 24 04          	mov    %esi,0x4(%esp)
  80266a:	89 3c 24             	mov    %edi,(%esp)
  80266d:	e8 24 e7 ff ff       	call   800d96 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802672:	01 f3                	add    %esi,%ebx
  802674:	89 d8                	mov    %ebx,%eax
  802676:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802679:	72 c8                	jb     802643 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80267b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802681:	5b                   	pop    %ebx
  802682:	5e                   	pop    %esi
  802683:	5f                   	pop    %edi
  802684:	5d                   	pop    %ebp
  802685:	c3                   	ret    

00802686 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802686:	55                   	push   %ebp
  802687:	89 e5                	mov    %esp,%ebp
  802689:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802691:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802695:	75 07                	jne    80269e <devcons_read+0x18>
  802697:	eb 2a                	jmp    8026c3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802699:	e8 a6 e7 ff ff       	call   800e44 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80269e:	66 90                	xchg   %ax,%ax
  8026a0:	e8 0f e7 ff ff       	call   800db4 <sys_cgetc>
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 f0                	je     802699 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	78 16                	js     8026c3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8026ad:	83 f8 04             	cmp    $0x4,%eax
  8026b0:	74 0c                	je     8026be <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8026b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b5:	88 02                	mov    %al,(%edx)
	return 1;
  8026b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bc:	eb 05                	jmp    8026c3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8026be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8026c3:	c9                   	leave  
  8026c4:	c3                   	ret    

008026c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8026c5:	55                   	push   %ebp
  8026c6:	89 e5                	mov    %esp,%ebp
  8026c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8026d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8026d8:	00 
  8026d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026dc:	89 04 24             	mov    %eax,(%esp)
  8026df:	e8 b2 e6 ff ff       	call   800d96 <sys_cputs>
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <getchar>:

int
getchar(void)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026f3:	00 
  8026f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802702:	e8 f3 f0 ff ff       	call   8017fa <read>
	if (r < 0)
  802707:	85 c0                	test   %eax,%eax
  802709:	78 0f                	js     80271a <getchar+0x34>
		return r;
	if (r < 1)
  80270b:	85 c0                	test   %eax,%eax
  80270d:	7e 06                	jle    802715 <getchar+0x2f>
		return -E_EOF;
	return c;
  80270f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802713:	eb 05                	jmp    80271a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802715:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80271a:	c9                   	leave  
  80271b:	c3                   	ret    

0080271c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802722:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802725:	89 44 24 04          	mov    %eax,0x4(%esp)
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	89 04 24             	mov    %eax,(%esp)
  80272f:	e8 32 ee ff ff       	call   801566 <fd_lookup>
  802734:	85 c0                	test   %eax,%eax
  802736:	78 11                	js     802749 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802741:	39 10                	cmp    %edx,(%eax)
  802743:	0f 94 c0             	sete   %al
  802746:	0f b6 c0             	movzbl %al,%eax
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    

0080274b <opencons>:

int
opencons(void)
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
  80274e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802751:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802754:	89 04 24             	mov    %eax,(%esp)
  802757:	e8 bb ed ff ff       	call   801517 <fd_alloc>
		return r;
  80275c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80275e:	85 c0                	test   %eax,%eax
  802760:	78 40                	js     8027a2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802762:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802769:	00 
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802771:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802778:	e8 e6 e6 ff ff       	call   800e63 <sys_page_alloc>
		return r;
  80277d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80277f:	85 c0                	test   %eax,%eax
  802781:	78 1f                	js     8027a2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802783:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802798:	89 04 24             	mov    %eax,(%esp)
  80279b:	e8 50 ed ff ff       	call   8014f0 <fd2num>
  8027a0:	89 c2                	mov    %eax,%edx
}
  8027a2:	89 d0                	mov    %edx,%eax
  8027a4:	c9                   	leave  
  8027a5:	c3                   	ret    

008027a6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027ac:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027b3:	75 58                	jne    80280d <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  8027b5:	a1 08 50 80 00       	mov    0x805008,%eax
  8027ba:	8b 40 48             	mov    0x48(%eax),%eax
  8027bd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8027c4:	00 
  8027c5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8027cc:	ee 
  8027cd:	89 04 24             	mov    %eax,(%esp)
  8027d0:	e8 8e e6 ff ff       	call   800e63 <sys_page_alloc>
		if(return_code!=0)
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	74 1c                	je     8027f5 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  8027d9:	c7 44 24 08 e0 32 80 	movl   $0x8032e0,0x8(%esp)
  8027e0:	00 
  8027e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8027e8:	00 
  8027e9:	c7 04 24 3c 33 80 00 	movl   $0x80333c,(%esp)
  8027f0:	e8 33 db ff ff       	call   800328 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  8027f5:	a1 08 50 80 00       	mov    0x805008,%eax
  8027fa:	8b 40 48             	mov    0x48(%eax),%eax
  8027fd:	c7 44 24 04 17 28 80 	movl   $0x802817,0x4(%esp)
  802804:	00 
  802805:	89 04 24             	mov    %eax,(%esp)
  802808:	e8 f6 e7 ff ff       	call   801003 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802817:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802818:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80281d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80281f:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802822:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  802824:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  802828:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  80282c:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  80282d:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  80282f:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802831:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  802835:	58                   	pop    %eax
	popl %eax;
  802836:	58                   	pop    %eax
	popal;
  802837:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  802838:	83 c4 04             	add    $0x4,%esp
	popfl;
  80283b:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  80283c:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  80283d:	c3                   	ret    

0080283e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80283e:	55                   	push   %ebp
  80283f:	89 e5                	mov    %esp,%ebp
  802841:	56                   	push   %esi
  802842:	53                   	push   %ebx
  802843:	83 ec 10             	sub    $0x10,%esp
  802846:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80284f:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802851:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802856:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802859:	89 04 24             	mov    %eax,(%esp)
  80285c:	e8 18 e8 ff ff       	call   801079 <sys_ipc_recv>
  802861:	85 c0                	test   %eax,%eax
  802863:	75 1e                	jne    802883 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802865:	85 db                	test   %ebx,%ebx
  802867:	74 0a                	je     802873 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802869:	a1 08 50 80 00       	mov    0x805008,%eax
  80286e:	8b 40 74             	mov    0x74(%eax),%eax
  802871:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802873:	85 f6                	test   %esi,%esi
  802875:	74 22                	je     802899 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802877:	a1 08 50 80 00       	mov    0x805008,%eax
  80287c:	8b 40 78             	mov    0x78(%eax),%eax
  80287f:	89 06                	mov    %eax,(%esi)
  802881:	eb 16                	jmp    802899 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802883:	85 f6                	test   %esi,%esi
  802885:	74 06                	je     80288d <ipc_recv+0x4f>
				*perm_store = 0;
  802887:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  80288d:	85 db                	test   %ebx,%ebx
  80288f:	74 10                	je     8028a1 <ipc_recv+0x63>
				*from_env_store=0;
  802891:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802897:	eb 08                	jmp    8028a1 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802899:	a1 08 50 80 00       	mov    0x805008,%eax
  80289e:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8028a1:	83 c4 10             	add    $0x10,%esp
  8028a4:	5b                   	pop    %ebx
  8028a5:	5e                   	pop    %esi
  8028a6:	5d                   	pop    %ebp
  8028a7:	c3                   	ret    

008028a8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	57                   	push   %edi
  8028ac:	56                   	push   %esi
  8028ad:	53                   	push   %ebx
  8028ae:	83 ec 1c             	sub    $0x1c,%esp
  8028b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028b7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8028ba:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8028bc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8028c1:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8028c4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	89 04 24             	mov    %eax,(%esp)
  8028d6:	e8 7b e7 ff ff       	call   801056 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8028db:	eb 1c                	jmp    8028f9 <ipc_send+0x51>
	{
		sys_yield();
  8028dd:	e8 62 e5 ff ff       	call   800e44 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8028e2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028e6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f1:	89 04 24             	mov    %eax,(%esp)
  8028f4:	e8 5d e7 ff ff       	call   801056 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8028f9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8028fc:	74 df                	je     8028dd <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8028fe:	83 c4 1c             	add    $0x1c,%esp
  802901:	5b                   	pop    %ebx
  802902:	5e                   	pop    %esi
  802903:	5f                   	pop    %edi
  802904:	5d                   	pop    %ebp
  802905:	c3                   	ret    

00802906 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
  802909:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80290c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802911:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802914:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80291a:	8b 52 50             	mov    0x50(%edx),%edx
  80291d:	39 ca                	cmp    %ecx,%edx
  80291f:	75 0d                	jne    80292e <ipc_find_env+0x28>
			return envs[i].env_id;
  802921:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802924:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802929:	8b 40 40             	mov    0x40(%eax),%eax
  80292c:	eb 0e                	jmp    80293c <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80292e:	83 c0 01             	add    $0x1,%eax
  802931:	3d 00 04 00 00       	cmp    $0x400,%eax
  802936:	75 d9                	jne    802911 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802938:	66 b8 00 00          	mov    $0x0,%ax
}
  80293c:	5d                   	pop    %ebp
  80293d:	c3                   	ret    

0080293e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80293e:	55                   	push   %ebp
  80293f:	89 e5                	mov    %esp,%ebp
  802941:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802944:	89 d0                	mov    %edx,%eax
  802946:	c1 e8 16             	shr    $0x16,%eax
  802949:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802950:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802955:	f6 c1 01             	test   $0x1,%cl
  802958:	74 1d                	je     802977 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80295a:	c1 ea 0c             	shr    $0xc,%edx
  80295d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802964:	f6 c2 01             	test   $0x1,%dl
  802967:	74 0e                	je     802977 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802969:	c1 ea 0c             	shr    $0xc,%edx
  80296c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802973:	ef 
  802974:	0f b7 c0             	movzwl %ax,%eax
}
  802977:	5d                   	pop    %ebp
  802978:	c3                   	ret    
  802979:	66 90                	xchg   %ax,%ax
  80297b:	66 90                	xchg   %ax,%ax
  80297d:	66 90                	xchg   %ax,%ax
  80297f:	90                   	nop

00802980 <__udivdi3>:
  802980:	55                   	push   %ebp
  802981:	57                   	push   %edi
  802982:	56                   	push   %esi
  802983:	83 ec 0c             	sub    $0xc,%esp
  802986:	8b 44 24 28          	mov    0x28(%esp),%eax
  80298a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80298e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802992:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802996:	85 c0                	test   %eax,%eax
  802998:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80299c:	89 ea                	mov    %ebp,%edx
  80299e:	89 0c 24             	mov    %ecx,(%esp)
  8029a1:	75 2d                	jne    8029d0 <__udivdi3+0x50>
  8029a3:	39 e9                	cmp    %ebp,%ecx
  8029a5:	77 61                	ja     802a08 <__udivdi3+0x88>
  8029a7:	85 c9                	test   %ecx,%ecx
  8029a9:	89 ce                	mov    %ecx,%esi
  8029ab:	75 0b                	jne    8029b8 <__udivdi3+0x38>
  8029ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8029b2:	31 d2                	xor    %edx,%edx
  8029b4:	f7 f1                	div    %ecx
  8029b6:	89 c6                	mov    %eax,%esi
  8029b8:	31 d2                	xor    %edx,%edx
  8029ba:	89 e8                	mov    %ebp,%eax
  8029bc:	f7 f6                	div    %esi
  8029be:	89 c5                	mov    %eax,%ebp
  8029c0:	89 f8                	mov    %edi,%eax
  8029c2:	f7 f6                	div    %esi
  8029c4:	89 ea                	mov    %ebp,%edx
  8029c6:	83 c4 0c             	add    $0xc,%esp
  8029c9:	5e                   	pop    %esi
  8029ca:	5f                   	pop    %edi
  8029cb:	5d                   	pop    %ebp
  8029cc:	c3                   	ret    
  8029cd:	8d 76 00             	lea    0x0(%esi),%esi
  8029d0:	39 e8                	cmp    %ebp,%eax
  8029d2:	77 24                	ja     8029f8 <__udivdi3+0x78>
  8029d4:	0f bd e8             	bsr    %eax,%ebp
  8029d7:	83 f5 1f             	xor    $0x1f,%ebp
  8029da:	75 3c                	jne    802a18 <__udivdi3+0x98>
  8029dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029e0:	39 34 24             	cmp    %esi,(%esp)
  8029e3:	0f 86 9f 00 00 00    	jbe    802a88 <__udivdi3+0x108>
  8029e9:	39 d0                	cmp    %edx,%eax
  8029eb:	0f 82 97 00 00 00    	jb     802a88 <__udivdi3+0x108>
  8029f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	31 d2                	xor    %edx,%edx
  8029fa:	31 c0                	xor    %eax,%eax
  8029fc:	83 c4 0c             	add    $0xc,%esp
  8029ff:	5e                   	pop    %esi
  802a00:	5f                   	pop    %edi
  802a01:	5d                   	pop    %ebp
  802a02:	c3                   	ret    
  802a03:	90                   	nop
  802a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a08:	89 f8                	mov    %edi,%eax
  802a0a:	f7 f1                	div    %ecx
  802a0c:	31 d2                	xor    %edx,%edx
  802a0e:	83 c4 0c             	add    $0xc,%esp
  802a11:	5e                   	pop    %esi
  802a12:	5f                   	pop    %edi
  802a13:	5d                   	pop    %ebp
  802a14:	c3                   	ret    
  802a15:	8d 76 00             	lea    0x0(%esi),%esi
  802a18:	89 e9                	mov    %ebp,%ecx
  802a1a:	8b 3c 24             	mov    (%esp),%edi
  802a1d:	d3 e0                	shl    %cl,%eax
  802a1f:	89 c6                	mov    %eax,%esi
  802a21:	b8 20 00 00 00       	mov    $0x20,%eax
  802a26:	29 e8                	sub    %ebp,%eax
  802a28:	89 c1                	mov    %eax,%ecx
  802a2a:	d3 ef                	shr    %cl,%edi
  802a2c:	89 e9                	mov    %ebp,%ecx
  802a2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a32:	8b 3c 24             	mov    (%esp),%edi
  802a35:	09 74 24 08          	or     %esi,0x8(%esp)
  802a39:	89 d6                	mov    %edx,%esi
  802a3b:	d3 e7                	shl    %cl,%edi
  802a3d:	89 c1                	mov    %eax,%ecx
  802a3f:	89 3c 24             	mov    %edi,(%esp)
  802a42:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a46:	d3 ee                	shr    %cl,%esi
  802a48:	89 e9                	mov    %ebp,%ecx
  802a4a:	d3 e2                	shl    %cl,%edx
  802a4c:	89 c1                	mov    %eax,%ecx
  802a4e:	d3 ef                	shr    %cl,%edi
  802a50:	09 d7                	or     %edx,%edi
  802a52:	89 f2                	mov    %esi,%edx
  802a54:	89 f8                	mov    %edi,%eax
  802a56:	f7 74 24 08          	divl   0x8(%esp)
  802a5a:	89 d6                	mov    %edx,%esi
  802a5c:	89 c7                	mov    %eax,%edi
  802a5e:	f7 24 24             	mull   (%esp)
  802a61:	39 d6                	cmp    %edx,%esi
  802a63:	89 14 24             	mov    %edx,(%esp)
  802a66:	72 30                	jb     802a98 <__udivdi3+0x118>
  802a68:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a6c:	89 e9                	mov    %ebp,%ecx
  802a6e:	d3 e2                	shl    %cl,%edx
  802a70:	39 c2                	cmp    %eax,%edx
  802a72:	73 05                	jae    802a79 <__udivdi3+0xf9>
  802a74:	3b 34 24             	cmp    (%esp),%esi
  802a77:	74 1f                	je     802a98 <__udivdi3+0x118>
  802a79:	89 f8                	mov    %edi,%eax
  802a7b:	31 d2                	xor    %edx,%edx
  802a7d:	e9 7a ff ff ff       	jmp    8029fc <__udivdi3+0x7c>
  802a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a88:	31 d2                	xor    %edx,%edx
  802a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a8f:	e9 68 ff ff ff       	jmp    8029fc <__udivdi3+0x7c>
  802a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a98:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	83 c4 0c             	add    $0xc,%esp
  802aa0:	5e                   	pop    %esi
  802aa1:	5f                   	pop    %edi
  802aa2:	5d                   	pop    %ebp
  802aa3:	c3                   	ret    
  802aa4:	66 90                	xchg   %ax,%ax
  802aa6:	66 90                	xchg   %ax,%ax
  802aa8:	66 90                	xchg   %ax,%ax
  802aaa:	66 90                	xchg   %ax,%ax
  802aac:	66 90                	xchg   %ax,%ax
  802aae:	66 90                	xchg   %ax,%ax

00802ab0 <__umoddi3>:
  802ab0:	55                   	push   %ebp
  802ab1:	57                   	push   %edi
  802ab2:	56                   	push   %esi
  802ab3:	83 ec 14             	sub    $0x14,%esp
  802ab6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802abe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802ac2:	89 c7                	mov    %eax,%edi
  802ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ac8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802acc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ad0:	89 34 24             	mov    %esi,(%esp)
  802ad3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	89 c2                	mov    %eax,%edx
  802adb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802adf:	75 17                	jne    802af8 <__umoddi3+0x48>
  802ae1:	39 fe                	cmp    %edi,%esi
  802ae3:	76 4b                	jbe    802b30 <__umoddi3+0x80>
  802ae5:	89 c8                	mov    %ecx,%eax
  802ae7:	89 fa                	mov    %edi,%edx
  802ae9:	f7 f6                	div    %esi
  802aeb:	89 d0                	mov    %edx,%eax
  802aed:	31 d2                	xor    %edx,%edx
  802aef:	83 c4 14             	add    $0x14,%esp
  802af2:	5e                   	pop    %esi
  802af3:	5f                   	pop    %edi
  802af4:	5d                   	pop    %ebp
  802af5:	c3                   	ret    
  802af6:	66 90                	xchg   %ax,%ax
  802af8:	39 f8                	cmp    %edi,%eax
  802afa:	77 54                	ja     802b50 <__umoddi3+0xa0>
  802afc:	0f bd e8             	bsr    %eax,%ebp
  802aff:	83 f5 1f             	xor    $0x1f,%ebp
  802b02:	75 5c                	jne    802b60 <__umoddi3+0xb0>
  802b04:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b08:	39 3c 24             	cmp    %edi,(%esp)
  802b0b:	0f 87 e7 00 00 00    	ja     802bf8 <__umoddi3+0x148>
  802b11:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b15:	29 f1                	sub    %esi,%ecx
  802b17:	19 c7                	sbb    %eax,%edi
  802b19:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b1d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b21:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b25:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b29:	83 c4 14             	add    $0x14,%esp
  802b2c:	5e                   	pop    %esi
  802b2d:	5f                   	pop    %edi
  802b2e:	5d                   	pop    %ebp
  802b2f:	c3                   	ret    
  802b30:	85 f6                	test   %esi,%esi
  802b32:	89 f5                	mov    %esi,%ebp
  802b34:	75 0b                	jne    802b41 <__umoddi3+0x91>
  802b36:	b8 01 00 00 00       	mov    $0x1,%eax
  802b3b:	31 d2                	xor    %edx,%edx
  802b3d:	f7 f6                	div    %esi
  802b3f:	89 c5                	mov    %eax,%ebp
  802b41:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b45:	31 d2                	xor    %edx,%edx
  802b47:	f7 f5                	div    %ebp
  802b49:	89 c8                	mov    %ecx,%eax
  802b4b:	f7 f5                	div    %ebp
  802b4d:	eb 9c                	jmp    802aeb <__umoddi3+0x3b>
  802b4f:	90                   	nop
  802b50:	89 c8                	mov    %ecx,%eax
  802b52:	89 fa                	mov    %edi,%edx
  802b54:	83 c4 14             	add    $0x14,%esp
  802b57:	5e                   	pop    %esi
  802b58:	5f                   	pop    %edi
  802b59:	5d                   	pop    %ebp
  802b5a:	c3                   	ret    
  802b5b:	90                   	nop
  802b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b60:	8b 04 24             	mov    (%esp),%eax
  802b63:	be 20 00 00 00       	mov    $0x20,%esi
  802b68:	89 e9                	mov    %ebp,%ecx
  802b6a:	29 ee                	sub    %ebp,%esi
  802b6c:	d3 e2                	shl    %cl,%edx
  802b6e:	89 f1                	mov    %esi,%ecx
  802b70:	d3 e8                	shr    %cl,%eax
  802b72:	89 e9                	mov    %ebp,%ecx
  802b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b78:	8b 04 24             	mov    (%esp),%eax
  802b7b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b7f:	89 fa                	mov    %edi,%edx
  802b81:	d3 e0                	shl    %cl,%eax
  802b83:	89 f1                	mov    %esi,%ecx
  802b85:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b89:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b8d:	d3 ea                	shr    %cl,%edx
  802b8f:	89 e9                	mov    %ebp,%ecx
  802b91:	d3 e7                	shl    %cl,%edi
  802b93:	89 f1                	mov    %esi,%ecx
  802b95:	d3 e8                	shr    %cl,%eax
  802b97:	89 e9                	mov    %ebp,%ecx
  802b99:	09 f8                	or     %edi,%eax
  802b9b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b9f:	f7 74 24 04          	divl   0x4(%esp)
  802ba3:	d3 e7                	shl    %cl,%edi
  802ba5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ba9:	89 d7                	mov    %edx,%edi
  802bab:	f7 64 24 08          	mull   0x8(%esp)
  802baf:	39 d7                	cmp    %edx,%edi
  802bb1:	89 c1                	mov    %eax,%ecx
  802bb3:	89 14 24             	mov    %edx,(%esp)
  802bb6:	72 2c                	jb     802be4 <__umoddi3+0x134>
  802bb8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802bbc:	72 22                	jb     802be0 <__umoddi3+0x130>
  802bbe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802bc2:	29 c8                	sub    %ecx,%eax
  802bc4:	19 d7                	sbb    %edx,%edi
  802bc6:	89 e9                	mov    %ebp,%ecx
  802bc8:	89 fa                	mov    %edi,%edx
  802bca:	d3 e8                	shr    %cl,%eax
  802bcc:	89 f1                	mov    %esi,%ecx
  802bce:	d3 e2                	shl    %cl,%edx
  802bd0:	89 e9                	mov    %ebp,%ecx
  802bd2:	d3 ef                	shr    %cl,%edi
  802bd4:	09 d0                	or     %edx,%eax
  802bd6:	89 fa                	mov    %edi,%edx
  802bd8:	83 c4 14             	add    $0x14,%esp
  802bdb:	5e                   	pop    %esi
  802bdc:	5f                   	pop    %edi
  802bdd:	5d                   	pop    %ebp
  802bde:	c3                   	ret    
  802bdf:	90                   	nop
  802be0:	39 d7                	cmp    %edx,%edi
  802be2:	75 da                	jne    802bbe <__umoddi3+0x10e>
  802be4:	8b 14 24             	mov    (%esp),%edx
  802be7:	89 c1                	mov    %eax,%ecx
  802be9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802bed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802bf1:	eb cb                	jmp    802bbe <__umoddi3+0x10e>
  802bf3:	90                   	nop
  802bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bf8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802bfc:	0f 82 0f ff ff ff    	jb     802b11 <__umoddi3+0x61>
  802c02:	e9 1a ff ff ff       	jmp    802b21 <__umoddi3+0x71>
