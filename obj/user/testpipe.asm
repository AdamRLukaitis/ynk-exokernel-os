
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 e4 02 00 00       	call   800315 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 40 80 00 e0 	movl   $0x802ce0,0x804004
  800042:	2c 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 64 24 00 00       	call   8024b4 <pipe>
  800050:	89 c6                	mov    %eax,%esi
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("pipe: %e", i);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 ec 2c 80 	movl   $0x802cec,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 f5 2c 80 00 	movl   $0x802cf5,(%esp)
  800071:	e8 0a 03 00 00       	call   800380 <_panic>

	if ((pid = fork()) < 0)
  800076:	e8 7b 12 00 00       	call   8012f6 <fork>
  80007b:	89 c3                	mov    %eax,%ebx
  80007d:	85 c0                	test   %eax,%eax
  80007f:	79 20                	jns    8000a1 <umain+0x6e>
		panic("fork: %e", i);
  800081:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800085:	c7 44 24 08 05 2d 80 	movl   $0x802d05,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 f5 2c 80 00 	movl   $0x802cf5,(%esp)
  80009c:	e8 df 02 00 00       	call   800380 <_panic>

	if (pid == 0) {
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 d5 00 00 00    	jne    80017e <umain+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  8000a9:	a1 08 50 80 00       	mov    0x805008,%eax
  8000ae:	8b 40 48             	mov    0x48(%eax),%eax
  8000b1:	8b 55 90             	mov    -0x70(%ebp),%edx
  8000b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bc:	c7 04 24 0e 2d 80 00 	movl   $0x802d0e,(%esp)
  8000c3:	e8 b1 03 00 00       	call   800479 <cprintf>
		close(p[1]);
  8000c8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cb:	89 04 24             	mov    %eax,(%esp)
  8000ce:	e8 24 16 00 00       	call   8016f7 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000d3:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d8:	8b 40 48             	mov    0x48(%eax),%eax
  8000db:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8000de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e6:	c7 04 24 2b 2d 80 00 	movl   $0x802d2b,(%esp)
  8000ed:	e8 87 03 00 00       	call   800479 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000f2:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000f9:	00 
  8000fa:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800104:	89 04 24             	mov    %eax,(%esp)
  800107:	e8 e0 17 00 00       	call   8018ec <readn>
  80010c:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010e:	85 c0                	test   %eax,%eax
  800110:	79 20                	jns    800132 <umain+0xff>
			panic("read: %e", i);
  800112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800116:	c7 44 24 08 48 2d 80 	movl   $0x802d48,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 f5 2c 80 00 	movl   $0x802cf5,(%esp)
  80012d:	e8 4e 02 00 00       	call   800380 <_panic>
		buf[i] = 0;
  800132:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800137:	a1 00 40 80 00       	mov    0x804000,%eax
  80013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800140:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800143:	89 04 24             	mov    %eax,(%esp)
  800146:	e8 11 0a 00 00       	call   800b5c <strcmp>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	75 0e                	jne    80015d <umain+0x12a>
			cprintf("\npipe read closed properly\n");
  80014f:	c7 04 24 51 2d 80 00 	movl   $0x802d51,(%esp)
  800156:	e8 1e 03 00 00       	call   800479 <cprintf>
  80015b:	eb 17                	jmp    800174 <umain+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015d:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800160:	89 44 24 08          	mov    %eax,0x8(%esp)
  800164:	89 74 24 04          	mov    %esi,0x4(%esp)
  800168:	c7 04 24 6d 2d 80 00 	movl   $0x802d6d,(%esp)
  80016f:	e8 05 03 00 00       	call   800479 <cprintf>
		exit();
  800174:	e8 ee 01 00 00       	call   800367 <exit>
  800179:	e9 ac 00 00 00       	jmp    80022a <umain+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80017e:	a1 08 50 80 00       	mov    0x805008,%eax
  800183:	8b 40 48             	mov    0x48(%eax),%eax
  800186:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800189:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800191:	c7 04 24 0e 2d 80 00 	movl   $0x802d0e,(%esp)
  800198:	e8 dc 02 00 00       	call   800479 <cprintf>
		close(p[0]);
  80019d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001a0:	89 04 24             	mov    %eax,(%esp)
  8001a3:	e8 4f 15 00 00       	call   8016f7 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001a8:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ad:	8b 40 48             	mov    0x48(%eax),%eax
  8001b0:	8b 55 90             	mov    -0x70(%ebp),%edx
  8001b3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bb:	c7 04 24 80 2d 80 00 	movl   $0x802d80,(%esp)
  8001c2:	e8 b2 02 00 00       	call   800479 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8001cc:	89 04 24             	mov    %eax,(%esp)
  8001cf:	e8 9c 08 00 00       	call   800a70 <strlen>
  8001d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001e4:	89 04 24             	mov    %eax,(%esp)
  8001e7:	e8 4b 17 00 00       	call   801937 <write>
  8001ec:	89 c6                	mov    %eax,%esi
  8001ee:	a1 00 40 80 00       	mov    0x804000,%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	e8 75 08 00 00       	call   800a70 <strlen>
  8001fb:	39 c6                	cmp    %eax,%esi
  8001fd:	74 20                	je     80021f <umain+0x1ec>
			panic("write: %e", i);
  8001ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800203:	c7 44 24 08 9d 2d 80 	movl   $0x802d9d,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800212:	00 
  800213:	c7 04 24 f5 2c 80 00 	movl   $0x802cf5,(%esp)
  80021a:	e8 61 01 00 00       	call   800380 <_panic>
		close(p[1]);
  80021f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800222:	89 04 24             	mov    %eax,(%esp)
  800225:	e8 cd 14 00 00       	call   8016f7 <close>
	}
	wait(pid);
  80022a:	89 1c 24             	mov    %ebx,(%esp)
  80022d:	e8 28 24 00 00       	call   80265a <wait>

	binaryname = "pipewriteeof";
  800232:	c7 05 04 40 80 00 a7 	movl   $0x802da7,0x804004
  800239:	2d 80 00 
	if ((i = pipe(p)) < 0)
  80023c:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80023f:	89 04 24             	mov    %eax,(%esp)
  800242:	e8 6d 22 00 00       	call   8024b4 <pipe>
  800247:	89 c6                	mov    %eax,%esi
  800249:	85 c0                	test   %eax,%eax
  80024b:	79 20                	jns    80026d <umain+0x23a>
		panic("pipe: %e", i);
  80024d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800251:	c7 44 24 08 ec 2c 80 	movl   $0x802cec,0x8(%esp)
  800258:	00 
  800259:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800260:	00 
  800261:	c7 04 24 f5 2c 80 00 	movl   $0x802cf5,(%esp)
  800268:	e8 13 01 00 00       	call   800380 <_panic>

	if ((pid = fork()) < 0)
  80026d:	e8 84 10 00 00       	call   8012f6 <fork>
  800272:	89 c3                	mov    %eax,%ebx
  800274:	85 c0                	test   %eax,%eax
  800276:	79 20                	jns    800298 <umain+0x265>
		panic("fork: %e", i);
  800278:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027c:	c7 44 24 08 05 2d 80 	movl   $0x802d05,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028b:	00 
  80028c:	c7 04 24 f5 2c 80 00 	movl   $0x802cf5,(%esp)
  800293:	e8 e8 00 00 00       	call   800380 <_panic>

	if (pid == 0) {
  800298:	85 c0                	test   %eax,%eax
  80029a:	75 48                	jne    8002e4 <umain+0x2b1>
		close(p[0]);
  80029c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	e8 50 14 00 00       	call   8016f7 <close>
		while (1) {
			cprintf(".");
  8002a7:	c7 04 24 b4 2d 80 00 	movl   $0x802db4,(%esp)
  8002ae:	e8 c6 01 00 00       	call   800479 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002ba:	00 
  8002bb:	c7 44 24 04 b6 2d 80 	movl   $0x802db6,0x4(%esp)
  8002c2:	00 
  8002c3:	8b 55 90             	mov    -0x70(%ebp),%edx
  8002c6:	89 14 24             	mov    %edx,(%esp)
  8002c9:	e8 69 16 00 00       	call   801937 <write>
  8002ce:	83 f8 01             	cmp    $0x1,%eax
  8002d1:	74 d4                	je     8002a7 <umain+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d3:	c7 04 24 b8 2d 80 00 	movl   $0x802db8,(%esp)
  8002da:	e8 9a 01 00 00       	call   800479 <cprintf>
		exit();
  8002df:	e8 83 00 00 00       	call   800367 <exit>
	}
	close(p[0]);
  8002e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e7:	89 04 24             	mov    %eax,(%esp)
  8002ea:	e8 08 14 00 00       	call   8016f7 <close>
	close(p[1]);
  8002ef:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	e8 fd 13 00 00       	call   8016f7 <close>
	wait(pid);
  8002fa:	89 1c 24             	mov    %ebx,(%esp)
  8002fd:	e8 58 23 00 00       	call   80265a <wait>

	cprintf("pipe tests passed\n");
  800302:	c7 04 24 d5 2d 80 00 	movl   $0x802dd5,(%esp)
  800309:	e8 6b 01 00 00       	call   800479 <cprintf>
}
  80030e:	83 ec 80             	sub    $0xffffff80,%esp
  800311:	5b                   	pop    %ebx
  800312:	5e                   	pop    %esi
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 10             	sub    $0x10,%esp
  80031d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800320:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800323:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80032a:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  80032d:	e8 53 0b 00 00       	call   800e85 <sys_getenvid>
  800332:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800337:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80033a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80033f:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800344:	85 db                	test   %ebx,%ebx
  800346:	7e 07                	jle    80034f <libmain+0x3a>
		binaryname = argv[0];
  800348:	8b 06                	mov    (%esi),%eax
  80034a:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  80034f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800353:	89 1c 24             	mov    %ebx,(%esp)
  800356:	e8 d8 fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80035b:	e8 07 00 00 00       	call   800367 <exit>
}
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	5b                   	pop    %ebx
  800364:	5e                   	pop    %esi
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    

00800367 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80036d:	e8 b8 13 00 00       	call   80172a <close_all>
	sys_env_destroy(0);
  800372:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800379:	e8 b5 0a 00 00       	call   800e33 <sys_env_destroy>
}
  80037e:	c9                   	leave  
  80037f:	c3                   	ret    

00800380 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	56                   	push   %esi
  800384:	53                   	push   %ebx
  800385:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800388:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80038b:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800391:	e8 ef 0a 00 00       	call   800e85 <sys_getenvid>
  800396:	8b 55 0c             	mov    0xc(%ebp),%edx
  800399:	89 54 24 10          	mov    %edx,0x10(%esp)
  80039d:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a4:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ac:	c7 04 24 38 2e 80 00 	movl   $0x802e38,(%esp)
  8003b3:	e8 c1 00 00 00       	call   800479 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bf:	89 04 24             	mov    %eax,(%esp)
  8003c2:	e8 51 00 00 00       	call   800418 <vcprintf>
	cprintf("\n");
  8003c7:	c7 04 24 29 2d 80 00 	movl   $0x802d29,(%esp)
  8003ce:	e8 a6 00 00 00       	call   800479 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003d3:	cc                   	int3   
  8003d4:	eb fd                	jmp    8003d3 <_panic+0x53>

008003d6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	53                   	push   %ebx
  8003da:	83 ec 14             	sub    $0x14,%esp
  8003dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003e0:	8b 13                	mov    (%ebx),%edx
  8003e2:	8d 42 01             	lea    0x1(%edx),%eax
  8003e5:	89 03                	mov    %eax,(%ebx)
  8003e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003ea:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003ee:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003f3:	75 19                	jne    80040e <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003f5:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003fc:	00 
  8003fd:	8d 43 08             	lea    0x8(%ebx),%eax
  800400:	89 04 24             	mov    %eax,(%esp)
  800403:	e8 ee 09 00 00       	call   800df6 <sys_cputs>
		b->idx = 0;
  800408:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80040e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800412:	83 c4 14             	add    $0x14,%esp
  800415:	5b                   	pop    %ebx
  800416:	5d                   	pop    %ebp
  800417:	c3                   	ret    

00800418 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800421:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800428:	00 00 00 
	b.cnt = 0;
  80042b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800432:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800435:	8b 45 0c             	mov    0xc(%ebp),%eax
  800438:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80043c:	8b 45 08             	mov    0x8(%ebp),%eax
  80043f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800443:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800449:	89 44 24 04          	mov    %eax,0x4(%esp)
  80044d:	c7 04 24 d6 03 80 00 	movl   $0x8003d6,(%esp)
  800454:	e8 b5 01 00 00       	call   80060e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800459:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80045f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800463:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800469:	89 04 24             	mov    %eax,(%esp)
  80046c:	e8 85 09 00 00       	call   800df6 <sys_cputs>

	return b.cnt;
}
  800471:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800477:	c9                   	leave  
  800478:	c3                   	ret    

00800479 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80047f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800482:	89 44 24 04          	mov    %eax,0x4(%esp)
  800486:	8b 45 08             	mov    0x8(%ebp),%eax
  800489:	89 04 24             	mov    %eax,(%esp)
  80048c:	e8 87 ff ff ff       	call   800418 <vcprintf>
	va_end(ap);

	return cnt;
}
  800491:	c9                   	leave  
  800492:	c3                   	ret    
  800493:	66 90                	xchg   %ax,%ax
  800495:	66 90                	xchg   %ax,%ax
  800497:	66 90                	xchg   %ax,%ax
  800499:	66 90                	xchg   %ax,%ax
  80049b:	66 90                	xchg   %ax,%ax
  80049d:	66 90                	xchg   %ax,%ax
  80049f:	90                   	nop

008004a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	57                   	push   %edi
  8004a4:	56                   	push   %esi
  8004a5:	53                   	push   %ebx
  8004a6:	83 ec 3c             	sub    $0x3c,%esp
  8004a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004ac:	89 d7                	mov    %edx,%edi
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	89 c3                	mov    %eax,%ebx
  8004b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004cd:	39 d9                	cmp    %ebx,%ecx
  8004cf:	72 05                	jb     8004d6 <printnum+0x36>
  8004d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004d4:	77 69                	ja     80053f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004dd:	83 ee 01             	sub    $0x1,%esi
  8004e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004f0:	89 c3                	mov    %eax,%ebx
  8004f2:	89 d6                	mov    %edx,%esi
  8004f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 2c 25 00 00       	call   802a40 <__udivdi3>
  800514:	89 d9                	mov    %ebx,%ecx
  800516:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80051a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	89 54 24 04          	mov    %edx,0x4(%esp)
  800525:	89 fa                	mov    %edi,%edx
  800527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052a:	e8 71 ff ff ff       	call   8004a0 <printnum>
  80052f:	eb 1b                	jmp    80054c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800531:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800535:	8b 45 18             	mov    0x18(%ebp),%eax
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	ff d3                	call   *%ebx
  80053d:	eb 03                	jmp    800542 <printnum+0xa2>
  80053f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800542:	83 ee 01             	sub    $0x1,%esi
  800545:	85 f6                	test   %esi,%esi
  800547:	7f e8                	jg     800531 <printnum+0x91>
  800549:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80054c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800550:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800554:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800557:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80055a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80055e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800562:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800565:	89 04 24             	mov    %eax,(%esp)
  800568:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80056b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056f:	e8 fc 25 00 00       	call   802b70 <__umoddi3>
  800574:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800578:	0f be 80 5b 2e 80 00 	movsbl 0x802e5b(%eax),%eax
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800585:	ff d0                	call   *%eax
}
  800587:	83 c4 3c             	add    $0x3c,%esp
  80058a:	5b                   	pop    %ebx
  80058b:	5e                   	pop    %esi
  80058c:	5f                   	pop    %edi
  80058d:	5d                   	pop    %ebp
  80058e:	c3                   	ret    

0080058f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800592:	83 fa 01             	cmp    $0x1,%edx
  800595:	7e 0e                	jle    8005a5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800597:	8b 10                	mov    (%eax),%edx
  800599:	8d 4a 08             	lea    0x8(%edx),%ecx
  80059c:	89 08                	mov    %ecx,(%eax)
  80059e:	8b 02                	mov    (%edx),%eax
  8005a0:	8b 52 04             	mov    0x4(%edx),%edx
  8005a3:	eb 22                	jmp    8005c7 <getuint+0x38>
	else if (lflag)
  8005a5:	85 d2                	test   %edx,%edx
  8005a7:	74 10                	je     8005b9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ae:	89 08                	mov    %ecx,(%eax)
  8005b0:	8b 02                	mov    (%edx),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b7:	eb 0e                	jmp    8005c7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005b9:	8b 10                	mov    (%eax),%edx
  8005bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005be:	89 08                	mov    %ecx,(%eax)
  8005c0:	8b 02                	mov    (%edx),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005c7:	5d                   	pop    %ebp
  8005c8:	c3                   	ret    

008005c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005d3:	8b 10                	mov    (%eax),%edx
  8005d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005d8:	73 0a                	jae    8005e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005dd:	89 08                	mov    %ecx,(%eax)
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 02                	mov    %al,(%edx)
}
  8005e4:	5d                   	pop    %ebp
  8005e5:	c3                   	ret    

008005e6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800601:	8b 45 08             	mov    0x8(%ebp),%eax
  800604:	89 04 24             	mov    %eax,(%esp)
  800607:	e8 02 00 00 00       	call   80060e <vprintfmt>
	va_end(ap);
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	57                   	push   %edi
  800612:	56                   	push   %esi
  800613:	53                   	push   %ebx
  800614:	83 ec 3c             	sub    $0x3c,%esp
  800617:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80061a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061d:	eb 14                	jmp    800633 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80061f:	85 c0                	test   %eax,%eax
  800621:	0f 84 b3 03 00 00    	je     8009da <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800627:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80062b:	89 04 24             	mov    %eax,(%esp)
  80062e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800631:	89 f3                	mov    %esi,%ebx
  800633:	8d 73 01             	lea    0x1(%ebx),%esi
  800636:	0f b6 03             	movzbl (%ebx),%eax
  800639:	83 f8 25             	cmp    $0x25,%eax
  80063c:	75 e1                	jne    80061f <vprintfmt+0x11>
  80063e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800642:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800649:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800650:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800657:	ba 00 00 00 00       	mov    $0x0,%edx
  80065c:	eb 1d                	jmp    80067b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800660:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800664:	eb 15                	jmp    80067b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800666:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800668:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80066c:	eb 0d                	jmp    80067b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80066e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800671:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800674:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80067e:	0f b6 0e             	movzbl (%esi),%ecx
  800681:	0f b6 c1             	movzbl %cl,%eax
  800684:	83 e9 23             	sub    $0x23,%ecx
  800687:	80 f9 55             	cmp    $0x55,%cl
  80068a:	0f 87 2a 03 00 00    	ja     8009ba <vprintfmt+0x3ac>
  800690:	0f b6 c9             	movzbl %cl,%ecx
  800693:	ff 24 8d a0 2f 80 00 	jmp    *0x802fa0(,%ecx,4)
  80069a:	89 de                	mov    %ebx,%esi
  80069c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006a1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006a8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006ae:	83 fb 09             	cmp    $0x9,%ebx
  8006b1:	77 36                	ja     8006e9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006b6:	eb e9                	jmp    8006a1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 48 04             	lea    0x4(%eax),%ecx
  8006be:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006c6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006c8:	eb 22                	jmp    8006ec <vprintfmt+0xde>
  8006ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006cd:	85 c9                	test   %ecx,%ecx
  8006cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8006d4:	0f 49 c1             	cmovns %ecx,%eax
  8006d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	89 de                	mov    %ebx,%esi
  8006dc:	eb 9d                	jmp    80067b <vprintfmt+0x6d>
  8006de:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006e0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8006e7:	eb 92                	jmp    80067b <vprintfmt+0x6d>
  8006e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8006ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006f0:	79 89                	jns    80067b <vprintfmt+0x6d>
  8006f2:	e9 77 ff ff ff       	jmp    80066e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006f7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006fa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006fc:	e9 7a ff ff ff       	jmp    80067b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 50 04             	lea    0x4(%eax),%edx
  800707:	89 55 14             	mov    %edx,0x14(%ebp)
  80070a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	89 04 24             	mov    %eax,(%esp)
  800713:	ff 55 08             	call   *0x8(%ebp)
			break;
  800716:	e9 18 ff ff ff       	jmp    800633 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	89 55 14             	mov    %edx,0x14(%ebp)
  800724:	8b 00                	mov    (%eax),%eax
  800726:	99                   	cltd   
  800727:	31 d0                	xor    %edx,%eax
  800729:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80072b:	83 f8 0f             	cmp    $0xf,%eax
  80072e:	7f 0b                	jg     80073b <vprintfmt+0x12d>
  800730:	8b 14 85 00 31 80 00 	mov    0x803100(,%eax,4),%edx
  800737:	85 d2                	test   %edx,%edx
  800739:	75 20                	jne    80075b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80073b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80073f:	c7 44 24 08 73 2e 80 	movl   $0x802e73,0x8(%esp)
  800746:	00 
  800747:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 04 24             	mov    %eax,(%esp)
  800751:	e8 90 fe ff ff       	call   8005e6 <printfmt>
  800756:	e9 d8 fe ff ff       	jmp    800633 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80075b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80075f:	c7 44 24 08 c5 33 80 	movl   $0x8033c5,0x8(%esp)
  800766:	00 
  800767:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	89 04 24             	mov    %eax,(%esp)
  800771:	e8 70 fe ff ff       	call   8005e6 <printfmt>
  800776:	e9 b8 fe ff ff       	jmp    800633 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80077b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80077e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800781:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800784:	8b 45 14             	mov    0x14(%ebp),%eax
  800787:	8d 50 04             	lea    0x4(%eax),%edx
  80078a:	89 55 14             	mov    %edx,0x14(%ebp)
  80078d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80078f:	85 f6                	test   %esi,%esi
  800791:	b8 6c 2e 80 00       	mov    $0x802e6c,%eax
  800796:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800799:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80079d:	0f 84 97 00 00 00    	je     80083a <vprintfmt+0x22c>
  8007a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007a7:	0f 8e 9b 00 00 00    	jle    800848 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007b1:	89 34 24             	mov    %esi,(%esp)
  8007b4:	e8 cf 02 00 00       	call   800a88 <strnlen>
  8007b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007bc:	29 c2                	sub    %eax,%edx
  8007be:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8007c1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007d1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d3:	eb 0f                	jmp    8007e4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8007d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007dc:	89 04 24             	mov    %eax,(%esp)
  8007df:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e1:	83 eb 01             	sub    $0x1,%ebx
  8007e4:	85 db                	test   %ebx,%ebx
  8007e6:	7f ed                	jg     8007d5 <vprintfmt+0x1c7>
  8007e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007ee:	85 d2                	test   %edx,%edx
  8007f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f5:	0f 49 c2             	cmovns %edx,%eax
  8007f8:	29 c2                	sub    %eax,%edx
  8007fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007fd:	89 d7                	mov    %edx,%edi
  8007ff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800802:	eb 50                	jmp    800854 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800804:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800808:	74 1e                	je     800828 <vprintfmt+0x21a>
  80080a:	0f be d2             	movsbl %dl,%edx
  80080d:	83 ea 20             	sub    $0x20,%edx
  800810:	83 fa 5e             	cmp    $0x5e,%edx
  800813:	76 13                	jbe    800828 <vprintfmt+0x21a>
					putch('?', putdat);
  800815:	8b 45 0c             	mov    0xc(%ebp),%eax
  800818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800823:	ff 55 08             	call   *0x8(%ebp)
  800826:	eb 0d                	jmp    800835 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800828:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80082f:	89 04 24             	mov    %eax,(%esp)
  800832:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800835:	83 ef 01             	sub    $0x1,%edi
  800838:	eb 1a                	jmp    800854 <vprintfmt+0x246>
  80083a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80083d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800840:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800843:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800846:	eb 0c                	jmp    800854 <vprintfmt+0x246>
  800848:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80084b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80084e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800851:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800854:	83 c6 01             	add    $0x1,%esi
  800857:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80085b:	0f be c2             	movsbl %dl,%eax
  80085e:	85 c0                	test   %eax,%eax
  800860:	74 27                	je     800889 <vprintfmt+0x27b>
  800862:	85 db                	test   %ebx,%ebx
  800864:	78 9e                	js     800804 <vprintfmt+0x1f6>
  800866:	83 eb 01             	sub    $0x1,%ebx
  800869:	79 99                	jns    800804 <vprintfmt+0x1f6>
  80086b:	89 f8                	mov    %edi,%eax
  80086d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800870:	8b 75 08             	mov    0x8(%ebp),%esi
  800873:	89 c3                	mov    %eax,%ebx
  800875:	eb 1a                	jmp    800891 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800877:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80087b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800882:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800884:	83 eb 01             	sub    $0x1,%ebx
  800887:	eb 08                	jmp    800891 <vprintfmt+0x283>
  800889:	89 fb                	mov    %edi,%ebx
  80088b:	8b 75 08             	mov    0x8(%ebp),%esi
  80088e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800891:	85 db                	test   %ebx,%ebx
  800893:	7f e2                	jg     800877 <vprintfmt+0x269>
  800895:	89 75 08             	mov    %esi,0x8(%ebp)
  800898:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80089b:	e9 93 fd ff ff       	jmp    800633 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008a0:	83 fa 01             	cmp    $0x1,%edx
  8008a3:	7e 16                	jle    8008bb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	8d 50 08             	lea    0x8(%eax),%edx
  8008ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ae:	8b 50 04             	mov    0x4(%eax),%edx
  8008b1:	8b 00                	mov    (%eax),%eax
  8008b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008b9:	eb 32                	jmp    8008ed <vprintfmt+0x2df>
	else if (lflag)
  8008bb:	85 d2                	test   %edx,%edx
  8008bd:	74 18                	je     8008d7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8008bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c2:	8d 50 04             	lea    0x4(%eax),%edx
  8008c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008c8:	8b 30                	mov    (%eax),%esi
  8008ca:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008cd:	89 f0                	mov    %esi,%eax
  8008cf:	c1 f8 1f             	sar    $0x1f,%eax
  8008d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	8d 50 04             	lea    0x4(%eax),%edx
  8008dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e0:	8b 30                	mov    (%eax),%esi
  8008e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008e5:	89 f0                	mov    %esi,%eax
  8008e7:	c1 f8 1f             	sar    $0x1f,%eax
  8008ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fc:	0f 89 80 00 00 00    	jns    800982 <vprintfmt+0x374>
				putch('-', putdat);
  800902:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800906:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80090d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800910:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800913:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800916:	f7 d8                	neg    %eax
  800918:	83 d2 00             	adc    $0x0,%edx
  80091b:	f7 da                	neg    %edx
			}
			base = 10;
  80091d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800922:	eb 5e                	jmp    800982 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800924:	8d 45 14             	lea    0x14(%ebp),%eax
  800927:	e8 63 fc ff ff       	call   80058f <getuint>
			base = 10;
  80092c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800931:	eb 4f                	jmp    800982 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800933:	8d 45 14             	lea    0x14(%ebp),%eax
  800936:	e8 54 fc ff ff       	call   80058f <getuint>
			base =8;
  80093b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800940:	eb 40                	jmp    800982 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800942:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800946:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80094d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800950:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800954:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80095b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	8d 50 04             	lea    0x4(%eax),%edx
  800964:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800967:	8b 00                	mov    (%eax),%eax
  800969:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80096e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800973:	eb 0d                	jmp    800982 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800975:	8d 45 14             	lea    0x14(%ebp),%eax
  800978:	e8 12 fc ff ff       	call   80058f <getuint>
			base = 16;
  80097d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800982:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800986:	89 74 24 10          	mov    %esi,0x10(%esp)
  80098a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80098d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800991:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800995:	89 04 24             	mov    %eax,(%esp)
  800998:	89 54 24 04          	mov    %edx,0x4(%esp)
  80099c:	89 fa                	mov    %edi,%edx
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	e8 fa fa ff ff       	call   8004a0 <printnum>
			break;
  8009a6:	e9 88 fc ff ff       	jmp    800633 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009af:	89 04 24             	mov    %eax,(%esp)
  8009b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009b5:	e9 79 fc ff ff       	jmp    800633 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009be:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009c5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009c8:	89 f3                	mov    %esi,%ebx
  8009ca:	eb 03                	jmp    8009cf <vprintfmt+0x3c1>
  8009cc:	83 eb 01             	sub    $0x1,%ebx
  8009cf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009d3:	75 f7                	jne    8009cc <vprintfmt+0x3be>
  8009d5:	e9 59 fc ff ff       	jmp    800633 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8009da:	83 c4 3c             	add    $0x3c,%esp
  8009dd:	5b                   	pop    %ebx
  8009de:	5e                   	pop    %esi
  8009df:	5f                   	pop    %edi
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	83 ec 28             	sub    $0x28,%esp
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ff:	85 c0                	test   %eax,%eax
  800a01:	74 30                	je     800a33 <vsnprintf+0x51>
  800a03:	85 d2                	test   %edx,%edx
  800a05:	7e 2c                	jle    800a33 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a07:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a11:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a15:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a18:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1c:	c7 04 24 c9 05 80 00 	movl   $0x8005c9,(%esp)
  800a23:	e8 e6 fb ff ff       	call   80060e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a31:	eb 05                	jmp    800a38 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a33:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a40:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a47:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	89 04 24             	mov    %eax,(%esp)
  800a5b:	e8 82 ff ff ff       	call   8009e2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a60:	c9                   	leave  
  800a61:	c3                   	ret    
  800a62:	66 90                	xchg   %ax,%ax
  800a64:	66 90                	xchg   %ax,%ax
  800a66:	66 90                	xchg   %ax,%ax
  800a68:	66 90                	xchg   %ax,%ax
  800a6a:	66 90                	xchg   %ax,%ax
  800a6c:	66 90                	xchg   %ax,%ax
  800a6e:	66 90                	xchg   %ax,%ax

00800a70 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7b:	eb 03                	jmp    800a80 <strlen+0x10>
		n++;
  800a7d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a80:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a84:	75 f7                	jne    800a7d <strlen+0xd>
		n++;
	return n;
}
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a91:	b8 00 00 00 00       	mov    $0x0,%eax
  800a96:	eb 03                	jmp    800a9b <strnlen+0x13>
		n++;
  800a98:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a9b:	39 d0                	cmp    %edx,%eax
  800a9d:	74 06                	je     800aa5 <strnlen+0x1d>
  800a9f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800aa3:	75 f3                	jne    800a98 <strnlen+0x10>
		n++;
	return n;
}
  800aa5:	5d                   	pop    %ebp
  800aa6:	c3                   	ret    

00800aa7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	53                   	push   %ebx
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ab1:	89 c2                	mov    %eax,%edx
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	83 c1 01             	add    $0x1,%ecx
  800ab9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800abd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ac0:	84 db                	test   %bl,%bl
  800ac2:	75 ef                	jne    800ab3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ac4:	5b                   	pop    %ebx
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	53                   	push   %ebx
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ad1:	89 1c 24             	mov    %ebx,(%esp)
  800ad4:	e8 97 ff ff ff       	call   800a70 <strlen>
	strcpy(dst + len, src);
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ae0:	01 d8                	add    %ebx,%eax
  800ae2:	89 04 24             	mov    %eax,(%esp)
  800ae5:	e8 bd ff ff ff       	call   800aa7 <strcpy>
	return dst;
}
  800aea:	89 d8                	mov    %ebx,%eax
  800aec:	83 c4 08             	add    $0x8,%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5d                   	pop    %ebp
  800af1:	c3                   	ret    

00800af2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800af2:	55                   	push   %ebp
  800af3:	89 e5                	mov    %esp,%ebp
  800af5:	56                   	push   %esi
  800af6:	53                   	push   %ebx
  800af7:	8b 75 08             	mov    0x8(%ebp),%esi
  800afa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800afd:	89 f3                	mov    %esi,%ebx
  800aff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b02:	89 f2                	mov    %esi,%edx
  800b04:	eb 0f                	jmp    800b15 <strncpy+0x23>
		*dst++ = *src;
  800b06:	83 c2 01             	add    $0x1,%edx
  800b09:	0f b6 01             	movzbl (%ecx),%eax
  800b0c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b0f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b12:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b15:	39 da                	cmp    %ebx,%edx
  800b17:	75 ed                	jne    800b06 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b19:	89 f0                	mov    %esi,%eax
  800b1b:	5b                   	pop    %ebx
  800b1c:	5e                   	pop    %esi
  800b1d:	5d                   	pop    %ebp
  800b1e:	c3                   	ret    

00800b1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
  800b24:	8b 75 08             	mov    0x8(%ebp),%esi
  800b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b2d:	89 f0                	mov    %esi,%eax
  800b2f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b33:	85 c9                	test   %ecx,%ecx
  800b35:	75 0b                	jne    800b42 <strlcpy+0x23>
  800b37:	eb 1d                	jmp    800b56 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b39:	83 c0 01             	add    $0x1,%eax
  800b3c:	83 c2 01             	add    $0x1,%edx
  800b3f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b42:	39 d8                	cmp    %ebx,%eax
  800b44:	74 0b                	je     800b51 <strlcpy+0x32>
  800b46:	0f b6 0a             	movzbl (%edx),%ecx
  800b49:	84 c9                	test   %cl,%cl
  800b4b:	75 ec                	jne    800b39 <strlcpy+0x1a>
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	eb 02                	jmp    800b53 <strlcpy+0x34>
  800b51:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b53:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b56:	29 f0                	sub    %esi,%eax
}
  800b58:	5b                   	pop    %ebx
  800b59:	5e                   	pop    %esi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b65:	eb 06                	jmp    800b6d <strcmp+0x11>
		p++, q++;
  800b67:	83 c1 01             	add    $0x1,%ecx
  800b6a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b6d:	0f b6 01             	movzbl (%ecx),%eax
  800b70:	84 c0                	test   %al,%al
  800b72:	74 04                	je     800b78 <strcmp+0x1c>
  800b74:	3a 02                	cmp    (%edx),%al
  800b76:	74 ef                	je     800b67 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	0f b6 12             	movzbl (%edx),%edx
  800b7e:	29 d0                	sub    %edx,%eax
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	53                   	push   %ebx
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b8c:	89 c3                	mov    %eax,%ebx
  800b8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b91:	eb 06                	jmp    800b99 <strncmp+0x17>
		n--, p++, q++;
  800b93:	83 c0 01             	add    $0x1,%eax
  800b96:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b99:	39 d8                	cmp    %ebx,%eax
  800b9b:	74 15                	je     800bb2 <strncmp+0x30>
  800b9d:	0f b6 08             	movzbl (%eax),%ecx
  800ba0:	84 c9                	test   %cl,%cl
  800ba2:	74 04                	je     800ba8 <strncmp+0x26>
  800ba4:	3a 0a                	cmp    (%edx),%cl
  800ba6:	74 eb                	je     800b93 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba8:	0f b6 00             	movzbl (%eax),%eax
  800bab:	0f b6 12             	movzbl (%edx),%edx
  800bae:	29 d0                	sub    %edx,%eax
  800bb0:	eb 05                	jmp    800bb7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800bb2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5d                   	pop    %ebp
  800bb9:	c3                   	ret    

00800bba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bba:	55                   	push   %ebp
  800bbb:	89 e5                	mov    %esp,%ebp
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bc4:	eb 07                	jmp    800bcd <strchr+0x13>
		if (*s == c)
  800bc6:	38 ca                	cmp    %cl,%dl
  800bc8:	74 0f                	je     800bd9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bca:	83 c0 01             	add    $0x1,%eax
  800bcd:	0f b6 10             	movzbl (%eax),%edx
  800bd0:	84 d2                	test   %dl,%dl
  800bd2:	75 f2                	jne    800bc6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
  800be1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be5:	eb 07                	jmp    800bee <strfind+0x13>
		if (*s == c)
  800be7:	38 ca                	cmp    %cl,%dl
  800be9:	74 0a                	je     800bf5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800beb:	83 c0 01             	add    $0x1,%eax
  800bee:	0f b6 10             	movzbl (%eax),%edx
  800bf1:	84 d2                	test   %dl,%dl
  800bf3:	75 f2                	jne    800be7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c03:	85 c9                	test   %ecx,%ecx
  800c05:	74 36                	je     800c3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c0d:	75 28                	jne    800c37 <memset+0x40>
  800c0f:	f6 c1 03             	test   $0x3,%cl
  800c12:	75 23                	jne    800c37 <memset+0x40>
		c &= 0xFF;
  800c14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c18:	89 d3                	mov    %edx,%ebx
  800c1a:	c1 e3 08             	shl    $0x8,%ebx
  800c1d:	89 d6                	mov    %edx,%esi
  800c1f:	c1 e6 18             	shl    $0x18,%esi
  800c22:	89 d0                	mov    %edx,%eax
  800c24:	c1 e0 10             	shl    $0x10,%eax
  800c27:	09 f0                	or     %esi,%eax
  800c29:	09 c2                	or     %eax,%edx
  800c2b:	89 d0                	mov    %edx,%eax
  800c2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c2f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c32:	fc                   	cld    
  800c33:	f3 ab                	rep stos %eax,%es:(%edi)
  800c35:	eb 06                	jmp    800c3d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	fc                   	cld    
  800c3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c3d:	89 f8                	mov    %edi,%eax
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c52:	39 c6                	cmp    %eax,%esi
  800c54:	73 35                	jae    800c8b <memmove+0x47>
  800c56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c59:	39 d0                	cmp    %edx,%eax
  800c5b:	73 2e                	jae    800c8b <memmove+0x47>
		s += n;
		d += n;
  800c5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c60:	89 d6                	mov    %edx,%esi
  800c62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c6a:	75 13                	jne    800c7f <memmove+0x3b>
  800c6c:	f6 c1 03             	test   $0x3,%cl
  800c6f:	75 0e                	jne    800c7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c71:	83 ef 04             	sub    $0x4,%edi
  800c74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c7a:	fd                   	std    
  800c7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c7d:	eb 09                	jmp    800c88 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c7f:	83 ef 01             	sub    $0x1,%edi
  800c82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c85:	fd                   	std    
  800c86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c88:	fc                   	cld    
  800c89:	eb 1d                	jmp    800ca8 <memmove+0x64>
  800c8b:	89 f2                	mov    %esi,%edx
  800c8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c8f:	f6 c2 03             	test   $0x3,%dl
  800c92:	75 0f                	jne    800ca3 <memmove+0x5f>
  800c94:	f6 c1 03             	test   $0x3,%cl
  800c97:	75 0a                	jne    800ca3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c99:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c9c:	89 c7                	mov    %eax,%edi
  800c9e:	fc                   	cld    
  800c9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca1:	eb 05                	jmp    800ca8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ca3:	89 c7                	mov    %eax,%edi
  800ca5:	fc                   	cld    
  800ca6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    

00800cac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 04 24             	mov    %eax,(%esp)
  800cc6:	e8 79 ff ff ff       	call   800c44 <memmove>
}
  800ccb:	c9                   	leave  
  800ccc:	c3                   	ret    

00800ccd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	56                   	push   %esi
  800cd1:	53                   	push   %ebx
  800cd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd8:	89 d6                	mov    %edx,%esi
  800cda:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cdd:	eb 1a                	jmp    800cf9 <memcmp+0x2c>
		if (*s1 != *s2)
  800cdf:	0f b6 02             	movzbl (%edx),%eax
  800ce2:	0f b6 19             	movzbl (%ecx),%ebx
  800ce5:	38 d8                	cmp    %bl,%al
  800ce7:	74 0a                	je     800cf3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ce9:	0f b6 c0             	movzbl %al,%eax
  800cec:	0f b6 db             	movzbl %bl,%ebx
  800cef:	29 d8                	sub    %ebx,%eax
  800cf1:	eb 0f                	jmp    800d02 <memcmp+0x35>
		s1++, s2++;
  800cf3:	83 c2 01             	add    $0x1,%edx
  800cf6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cf9:	39 f2                	cmp    %esi,%edx
  800cfb:	75 e2                	jne    800cdf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d0f:	89 c2                	mov    %eax,%edx
  800d11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d14:	eb 07                	jmp    800d1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d16:	38 08                	cmp    %cl,(%eax)
  800d18:	74 07                	je     800d21 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d1a:	83 c0 01             	add    $0x1,%eax
  800d1d:	39 d0                	cmp    %edx,%eax
  800d1f:	72 f5                	jb     800d16 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d2f:	eb 03                	jmp    800d34 <strtol+0x11>
		s++;
  800d31:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d34:	0f b6 0a             	movzbl (%edx),%ecx
  800d37:	80 f9 09             	cmp    $0x9,%cl
  800d3a:	74 f5                	je     800d31 <strtol+0xe>
  800d3c:	80 f9 20             	cmp    $0x20,%cl
  800d3f:	74 f0                	je     800d31 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d41:	80 f9 2b             	cmp    $0x2b,%cl
  800d44:	75 0a                	jne    800d50 <strtol+0x2d>
		s++;
  800d46:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d49:	bf 00 00 00 00       	mov    $0x0,%edi
  800d4e:	eb 11                	jmp    800d61 <strtol+0x3e>
  800d50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d55:	80 f9 2d             	cmp    $0x2d,%cl
  800d58:	75 07                	jne    800d61 <strtol+0x3e>
		s++, neg = 1;
  800d5a:	8d 52 01             	lea    0x1(%edx),%edx
  800d5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d66:	75 15                	jne    800d7d <strtol+0x5a>
  800d68:	80 3a 30             	cmpb   $0x30,(%edx)
  800d6b:	75 10                	jne    800d7d <strtol+0x5a>
  800d6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d71:	75 0a                	jne    800d7d <strtol+0x5a>
		s += 2, base = 16;
  800d73:	83 c2 02             	add    $0x2,%edx
  800d76:	b8 10 00 00 00       	mov    $0x10,%eax
  800d7b:	eb 10                	jmp    800d8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d7d:	85 c0                	test   %eax,%eax
  800d7f:	75 0c                	jne    800d8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d81:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d83:	80 3a 30             	cmpb   $0x30,(%edx)
  800d86:	75 05                	jne    800d8d <strtol+0x6a>
		s++, base = 8;
  800d88:	83 c2 01             	add    $0x1,%edx
  800d8b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d95:	0f b6 0a             	movzbl (%edx),%ecx
  800d98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d9b:	89 f0                	mov    %esi,%eax
  800d9d:	3c 09                	cmp    $0x9,%al
  800d9f:	77 08                	ja     800da9 <strtol+0x86>
			dig = *s - '0';
  800da1:	0f be c9             	movsbl %cl,%ecx
  800da4:	83 e9 30             	sub    $0x30,%ecx
  800da7:	eb 20                	jmp    800dc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800da9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dac:	89 f0                	mov    %esi,%eax
  800dae:	3c 19                	cmp    $0x19,%al
  800db0:	77 08                	ja     800dba <strtol+0x97>
			dig = *s - 'a' + 10;
  800db2:	0f be c9             	movsbl %cl,%ecx
  800db5:	83 e9 57             	sub    $0x57,%ecx
  800db8:	eb 0f                	jmp    800dc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800dba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dbd:	89 f0                	mov    %esi,%eax
  800dbf:	3c 19                	cmp    $0x19,%al
  800dc1:	77 16                	ja     800dd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800dc3:	0f be c9             	movsbl %cl,%ecx
  800dc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800dc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800dcc:	7d 0f                	jge    800ddd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dce:	83 c2 01             	add    $0x1,%edx
  800dd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800dd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800dd7:	eb bc                	jmp    800d95 <strtol+0x72>
  800dd9:	89 d8                	mov    %ebx,%eax
  800ddb:	eb 02                	jmp    800ddf <strtol+0xbc>
  800ddd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ddf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de3:	74 05                	je     800dea <strtol+0xc7>
		*endptr = (char *) s;
  800de5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800de8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dea:	f7 d8                	neg    %eax
  800dec:	85 ff                	test   %edi,%edi
  800dee:	0f 44 c3             	cmove  %ebx,%eax
}
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800e01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	89 c3                	mov    %eax,%ebx
  800e09:	89 c7                	mov    %eax,%edi
  800e0b:	89 c6                	mov    %eax,%esi
  800e0d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e0f:	5b                   	pop    %ebx
  800e10:	5e                   	pop    %esi
  800e11:	5f                   	pop    %edi
  800e12:	5d                   	pop    %ebp
  800e13:	c3                   	ret    

00800e14 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e14:	55                   	push   %ebp
  800e15:	89 e5                	mov    %esp,%ebp
  800e17:	57                   	push   %edi
  800e18:	56                   	push   %esi
  800e19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e24:	89 d1                	mov    %edx,%ecx
  800e26:	89 d3                	mov    %edx,%ebx
  800e28:	89 d7                	mov    %edx,%edi
  800e2a:	89 d6                	mov    %edx,%esi
  800e2c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e41:	b8 03 00 00 00       	mov    $0x3,%eax
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	89 cb                	mov    %ecx,%ebx
  800e4b:	89 cf                	mov    %ecx,%edi
  800e4d:	89 ce                	mov    %ecx,%esi
  800e4f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e51:	85 c0                	test   %eax,%eax
  800e53:	7e 28                	jle    800e7d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e59:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e60:	00 
  800e61:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  800e68:	00 
  800e69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e70:	00 
  800e71:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  800e78:	e8 03 f5 ff ff       	call   800380 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e7d:	83 c4 2c             	add    $0x2c,%esp
  800e80:	5b                   	pop    %ebx
  800e81:	5e                   	pop    %esi
  800e82:	5f                   	pop    %edi
  800e83:	5d                   	pop    %ebp
  800e84:	c3                   	ret    

00800e85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e90:	b8 02 00 00 00       	mov    $0x2,%eax
  800e95:	89 d1                	mov    %edx,%ecx
  800e97:	89 d3                	mov    %edx,%ebx
  800e99:	89 d7                	mov    %edx,%edi
  800e9b:	89 d6                	mov    %edx,%esi
  800e9d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <sys_yield>:

void
sys_yield(void)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	57                   	push   %edi
  800ea8:	56                   	push   %esi
  800ea9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eaa:	ba 00 00 00 00       	mov    $0x0,%edx
  800eaf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800eb4:	89 d1                	mov    %edx,%ecx
  800eb6:	89 d3                	mov    %edx,%ebx
  800eb8:	89 d7                	mov    %edx,%edi
  800eba:	89 d6                	mov    %edx,%esi
  800ebc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	57                   	push   %edi
  800ec7:	56                   	push   %esi
  800ec8:	53                   	push   %ebx
  800ec9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecc:	be 00 00 00 00       	mov    $0x0,%esi
  800ed1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800edf:	89 f7                	mov    %esi,%edi
  800ee1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	7e 28                	jle    800f0f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eeb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ef2:	00 
  800ef3:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  800efa:	00 
  800efb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f02:	00 
  800f03:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  800f0a:	e8 71 f4 ff ff       	call   800380 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f0f:	83 c4 2c             	add    $0x2c,%esp
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	57                   	push   %edi
  800f1b:	56                   	push   %esi
  800f1c:	53                   	push   %ebx
  800f1d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f20:	b8 05 00 00 00       	mov    $0x5,%eax
  800f25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f31:	8b 75 18             	mov    0x18(%ebp),%esi
  800f34:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f36:	85 c0                	test   %eax,%eax
  800f38:	7e 28                	jle    800f62 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f45:	00 
  800f46:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  800f4d:	00 
  800f4e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f55:	00 
  800f56:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  800f5d:	e8 1e f4 ff ff       	call   800380 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f62:	83 c4 2c             	add    $0x2c,%esp
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
  800f70:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f78:	b8 06 00 00 00       	mov    $0x6,%eax
  800f7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	89 df                	mov    %ebx,%edi
  800f85:	89 de                	mov    %ebx,%esi
  800f87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f89:	85 c0                	test   %eax,%eax
  800f8b:	7e 28                	jle    800fb5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f91:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f98:	00 
  800f99:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  800fa0:	00 
  800fa1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa8:	00 
  800fa9:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  800fb0:	e8 cb f3 ff ff       	call   800380 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fb5:	83 c4 2c             	add    $0x2c,%esp
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
  800fc3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	b8 08 00 00 00       	mov    $0x8,%eax
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	7e 28                	jle    801008 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800feb:	00 
  800fec:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ffb:	00 
  800ffc:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  801003:	e8 78 f3 ff ff       	call   800380 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801008:	83 c4 2c             	add    $0x2c,%esp
  80100b:	5b                   	pop    %ebx
  80100c:	5e                   	pop    %esi
  80100d:	5f                   	pop    %edi
  80100e:	5d                   	pop    %ebp
  80100f:	c3                   	ret    

00801010 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
  801013:	57                   	push   %edi
  801014:	56                   	push   %esi
  801015:	53                   	push   %ebx
  801016:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	b8 09 00 00 00       	mov    $0x9,%eax
  801023:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	89 df                	mov    %ebx,%edi
  80102b:	89 de                	mov    %ebx,%esi
  80102d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80102f:	85 c0                	test   %eax,%eax
  801031:	7e 28                	jle    80105b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801033:	89 44 24 10          	mov    %eax,0x10(%esp)
  801037:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80103e:	00 
  80103f:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  801046:	00 
  801047:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104e:	00 
  80104f:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  801056:	e8 25 f3 ff ff       	call   800380 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80105b:	83 c4 2c             	add    $0x2c,%esp
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	57                   	push   %edi
  801067:	56                   	push   %esi
  801068:	53                   	push   %ebx
  801069:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801071:	b8 0a 00 00 00       	mov    $0xa,%eax
  801076:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801079:	8b 55 08             	mov    0x8(%ebp),%edx
  80107c:	89 df                	mov    %ebx,%edi
  80107e:	89 de                	mov    %ebx,%esi
  801080:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801082:	85 c0                	test   %eax,%eax
  801084:	7e 28                	jle    8010ae <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801086:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801091:	00 
  801092:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  801099:	00 
  80109a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a1:	00 
  8010a2:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  8010a9:	e8 d2 f2 ff ff       	call   800380 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010ae:	83 c4 2c             	add    $0x2c,%esp
  8010b1:	5b                   	pop    %ebx
  8010b2:	5e                   	pop    %esi
  8010b3:	5f                   	pop    %edi
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	57                   	push   %edi
  8010ba:	56                   	push   %esi
  8010bb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bc:	be 00 00 00 00       	mov    $0x0,%esi
  8010c1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010cf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010d2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010d4:	5b                   	pop    %ebx
  8010d5:	5e                   	pop    %esi
  8010d6:	5f                   	pop    %edi
  8010d7:	5d                   	pop    %ebp
  8010d8:	c3                   	ret    

008010d9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	57                   	push   %edi
  8010dd:	56                   	push   %esi
  8010de:	53                   	push   %ebx
  8010df:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ef:	89 cb                	mov    %ecx,%ebx
  8010f1:	89 cf                	mov    %ecx,%edi
  8010f3:	89 ce                	mov    %ecx,%esi
  8010f5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010f7:	85 c0                	test   %eax,%eax
  8010f9:	7e 28                	jle    801123 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801106:	00 
  801107:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  80110e:	00 
  80110f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801116:	00 
  801117:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  80111e:	e8 5d f2 ff ff       	call   800380 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801123:	83 c4 2c             	add    $0x2c,%esp
  801126:	5b                   	pop    %ebx
  801127:	5e                   	pop    %esi
  801128:	5f                   	pop    %edi
  801129:	5d                   	pop    %ebp
  80112a:	c3                   	ret    

0080112b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801131:	ba 00 00 00 00       	mov    $0x0,%edx
  801136:	b8 0e 00 00 00       	mov    $0xe,%eax
  80113b:	89 d1                	mov    %edx,%ecx
  80113d:	89 d3                	mov    %edx,%ebx
  80113f:	89 d7                	mov    %edx,%edi
  801141:	89 d6                	mov    %edx,%esi
  801143:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801145:	5b                   	pop    %ebx
  801146:	5e                   	pop    %esi
  801147:	5f                   	pop    %edi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	57                   	push   %edi
  80114e:	56                   	push   %esi
  80114f:	53                   	push   %ebx
  801150:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801153:	bb 00 00 00 00       	mov    $0x0,%ebx
  801158:	b8 0f 00 00 00       	mov    $0xf,%eax
  80115d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801160:	8b 55 08             	mov    0x8(%ebp),%edx
  801163:	89 df                	mov    %ebx,%edi
  801165:	89 de                	mov    %ebx,%esi
  801167:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801169:	85 c0                	test   %eax,%eax
  80116b:	7e 28                	jle    801195 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80116d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801171:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801178:	00 
  801179:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  801180:	00 
  801181:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801188:	00 
  801189:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  801190:	e8 eb f1 ff ff       	call   800380 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801195:	83 c4 2c             	add    $0x2c,%esp
  801198:	5b                   	pop    %ebx
  801199:	5e                   	pop    %esi
  80119a:	5f                   	pop    %edi
  80119b:	5d                   	pop    %ebp
  80119c:	c3                   	ret    

0080119d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80119d:	55                   	push   %ebp
  80119e:	89 e5                	mov    %esp,%ebp
  8011a0:	57                   	push   %edi
  8011a1:	56                   	push   %esi
  8011a2:	53                   	push   %ebx
  8011a3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8011b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b6:	89 df                	mov    %ebx,%edi
  8011b8:	89 de                	mov    %ebx,%esi
  8011ba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	7e 28                	jle    8011e8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8011cb:	00 
  8011cc:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  8011d3:	00 
  8011d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011db:	00 
  8011dc:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  8011e3:	e8 98 f1 ff ff       	call   800380 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8011e8:	83 c4 2c             	add    $0x2c,%esp
  8011eb:	5b                   	pop    %ebx
  8011ec:	5e                   	pop    %esi
  8011ed:	5f                   	pop    %edi
  8011ee:	5d                   	pop    %ebp
  8011ef:	c3                   	ret    

008011f0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	53                   	push   %ebx
  8011f4:	83 ec 24             	sub    $0x24,%esp
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  8011fa:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  8011fc:	89 d3                	mov    %edx,%ebx
  8011fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  801204:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801208:	74 1a                	je     801224 <pgfault+0x34>
  80120a:	c1 ea 0c             	shr    $0xc,%edx
  80120d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801214:	a8 01                	test   $0x1,%al
  801216:	74 0c                	je     801224 <pgfault+0x34>
  801218:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80121f:	f6 c4 08             	test   $0x8,%ah
  801222:	75 1c                	jne    801240 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  801224:	c7 44 24 08 8c 31 80 	movl   $0x80318c,0x8(%esp)
  80122b:	00 
  80122c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801233:	00 
  801234:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  80123b:	e8 40 f1 ff ff       	call   800380 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801240:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801247:	00 
  801248:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80124f:	00 
  801250:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801257:	e8 67 fc ff ff       	call   800ec3 <sys_page_alloc>
  80125c:	85 c0                	test   %eax,%eax
  80125e:	79 1c                	jns    80127c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801260:	c7 44 24 08 d0 31 80 	movl   $0x8031d0,0x8(%esp)
  801267:	00 
  801268:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80126f:	00 
  801270:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  801277:	e8 04 f1 ff ff       	call   800380 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  80127c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801283:	00 
  801284:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801288:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80128f:	e8 18 fa ff ff       	call   800cac <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801294:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80129b:	00 
  80129c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012a7:	00 
  8012a8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012af:	00 
  8012b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b7:	e8 5b fc ff ff       	call   800f17 <sys_page_map>
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	74 1c                	je     8012dc <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  8012c0:	c7 44 24 08 e6 32 80 	movl   $0x8032e6,0x8(%esp)
  8012c7:	00 
  8012c8:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8012cf:	00 
  8012d0:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  8012d7:	e8 a4 f0 ff ff       	call   800380 <_panic>
    sys_page_unmap(0,PFTEMP);
  8012dc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012e3:	00 
  8012e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012eb:	e8 7a fc ff ff       	call   800f6a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  8012f0:	83 c4 24             	add    $0x24,%esp
  8012f3:	5b                   	pop    %ebx
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    

008012f6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	57                   	push   %edi
  8012fa:	56                   	push   %esi
  8012fb:	53                   	push   %ebx
  8012fc:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  8012ff:	c7 04 24 f0 11 80 00 	movl   $0x8011f0,(%esp)
  801306:	e8 5b 15 00 00       	call   802866 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80130b:	b8 07 00 00 00       	mov    $0x7,%eax
  801310:	cd 30                	int    $0x30
  801312:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801315:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801317:	bb 00 00 00 00       	mov    $0x0,%ebx
  80131c:	85 c0                	test   %eax,%eax
  80131e:	75 21                	jne    801341 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801320:	e8 60 fb ff ff       	call   800e85 <sys_getenvid>
  801325:	25 ff 03 00 00       	and    $0x3ff,%eax
  80132a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80132d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801332:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801337:	b8 00 00 00 00       	mov    $0x0,%eax
  80133c:	e9 de 01 00 00       	jmp    80151f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801341:	89 d8                	mov    %ebx,%eax
  801343:	c1 e8 16             	shr    $0x16,%eax
  801346:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80134d:	a8 01                	test   $0x1,%al
  80134f:	0f 84 58 01 00 00    	je     8014ad <fork+0x1b7>
  801355:	89 de                	mov    %ebx,%esi
  801357:	c1 ee 0c             	shr    $0xc,%esi
  80135a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801361:	83 e0 05             	and    $0x5,%eax
  801364:	83 f8 05             	cmp    $0x5,%eax
  801367:	0f 85 40 01 00 00    	jne    8014ad <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80136d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801374:	f6 c4 04             	test   $0x4,%ah
  801377:	74 4f                	je     8013c8 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801379:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801380:	c1 e6 0c             	shl    $0xc,%esi
  801383:	25 07 0e 00 00       	and    $0xe07,%eax
  801388:	89 44 24 10          	mov    %eax,0x10(%esp)
  80138c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801390:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801394:	89 74 24 04          	mov    %esi,0x4(%esp)
  801398:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80139f:	e8 73 fb ff ff       	call   800f17 <sys_page_map>
  8013a4:	85 c0                	test   %eax,%eax
  8013a6:	0f 89 01 01 00 00    	jns    8014ad <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  8013ac:	c7 44 24 08 f0 31 80 	movl   $0x8031f0,0x8(%esp)
  8013b3:	00 
  8013b4:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8013bb:	00 
  8013bc:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  8013c3:	e8 b8 ef ff ff       	call   800380 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  8013c8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013cf:	a8 02                	test   $0x2,%al
  8013d1:	75 10                	jne    8013e3 <fork+0xed>
  8013d3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013da:	f6 c4 08             	test   $0x8,%ah
  8013dd:	0f 84 87 00 00 00    	je     80146a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  8013e3:	c1 e6 0c             	shl    $0xc,%esi
  8013e6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013ed:	00 
  8013ee:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013f2:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801401:	e8 11 fb ff ff       	call   800f17 <sys_page_map>
  801406:	85 c0                	test   %eax,%eax
  801408:	79 1c                	jns    801426 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80140a:	c7 44 24 08 28 32 80 	movl   $0x803228,0x8(%esp)
  801411:	00 
  801412:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801419:	00 
  80141a:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  801421:	e8 5a ef ff ff       	call   800380 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801426:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80142d:	00 
  80142e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801432:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801439:	00 
  80143a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80143e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801445:	e8 cd fa ff ff       	call   800f17 <sys_page_map>
  80144a:	85 c0                	test   %eax,%eax
  80144c:	79 5f                	jns    8014ad <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  80144e:	c7 44 24 08 60 32 80 	movl   $0x803260,0x8(%esp)
  801455:	00 
  801456:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  80145d:	00 
  80145e:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  801465:	e8 16 ef ff ff       	call   800380 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80146a:	c1 e6 0c             	shl    $0xc,%esi
  80146d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801474:	00 
  801475:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801479:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80147d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801481:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801488:	e8 8a fa ff ff       	call   800f17 <sys_page_map>
  80148d:	85 c0                	test   %eax,%eax
  80148f:	74 1c                	je     8014ad <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801491:	c7 44 24 08 88 32 80 	movl   $0x803288,0x8(%esp)
  801498:	00 
  801499:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8014a0:	00 
  8014a1:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  8014a8:	e8 d3 ee ff ff       	call   800380 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  8014ad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014b3:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8014b9:	0f 85 82 fe ff ff    	jne    801341 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  8014bf:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014c6:	00 
  8014c7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014ce:	ee 
  8014cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d2:	89 04 24             	mov    %eax,(%esp)
  8014d5:	e8 e9 f9 ff ff       	call   800ec3 <sys_page_alloc>
  8014da:	85 c0                	test   %eax,%eax
  8014dc:	79 1c                	jns    8014fa <fork+0x204>
      panic("sys_page_alloc failure in fork");
  8014de:	c7 44 24 08 bc 32 80 	movl   $0x8032bc,0x8(%esp)
  8014e5:	00 
  8014e6:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  8014ed:	00 
  8014ee:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  8014f5:	e8 86 ee ff ff       	call   800380 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  8014fa:	c7 44 24 04 d7 28 80 	movl   $0x8028d7,0x4(%esp)
  801501:	00 
  801502:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801505:	89 3c 24             	mov    %edi,(%esp)
  801508:	e8 56 fb ff ff       	call   801063 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80150d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801514:	00 
  801515:	89 3c 24             	mov    %edi,(%esp)
  801518:	e8 a0 fa ff ff       	call   800fbd <sys_env_set_status>
		return child;
  80151d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80151f:	83 c4 2c             	add    $0x2c,%esp
  801522:	5b                   	pop    %ebx
  801523:	5e                   	pop    %esi
  801524:	5f                   	pop    %edi
  801525:	5d                   	pop    %ebp
  801526:	c3                   	ret    

00801527 <sfork>:

// Challenge!
int
sfork(void)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80152d:	c7 44 24 08 04 33 80 	movl   $0x803304,0x8(%esp)
  801534:	00 
  801535:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80153c:	00 
  80153d:	c7 04 24 db 32 80 00 	movl   $0x8032db,(%esp)
  801544:	e8 37 ee ff ff       	call   800380 <_panic>
  801549:	66 90                	xchg   %ax,%ax
  80154b:	66 90                	xchg   %ax,%ax
  80154d:	66 90                	xchg   %ax,%ax
  80154f:	90                   	nop

00801550 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	05 00 00 00 30       	add    $0x30000000,%eax
  80155b:	c1 e8 0c             	shr    $0xc,%eax
}
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80156b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801570:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801582:	89 c2                	mov    %eax,%edx
  801584:	c1 ea 16             	shr    $0x16,%edx
  801587:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80158e:	f6 c2 01             	test   $0x1,%dl
  801591:	74 11                	je     8015a4 <fd_alloc+0x2d>
  801593:	89 c2                	mov    %eax,%edx
  801595:	c1 ea 0c             	shr    $0xc,%edx
  801598:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80159f:	f6 c2 01             	test   $0x1,%dl
  8015a2:	75 09                	jne    8015ad <fd_alloc+0x36>
			*fd_store = fd;
  8015a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ab:	eb 17                	jmp    8015c4 <fd_alloc+0x4d>
  8015ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015b7:	75 c9                	jne    801582 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8015bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015cc:	83 f8 1f             	cmp    $0x1f,%eax
  8015cf:	77 36                	ja     801607 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015d1:	c1 e0 0c             	shl    $0xc,%eax
  8015d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015d9:	89 c2                	mov    %eax,%edx
  8015db:	c1 ea 16             	shr    $0x16,%edx
  8015de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015e5:	f6 c2 01             	test   $0x1,%dl
  8015e8:	74 24                	je     80160e <fd_lookup+0x48>
  8015ea:	89 c2                	mov    %eax,%edx
  8015ec:	c1 ea 0c             	shr    $0xc,%edx
  8015ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015f6:	f6 c2 01             	test   $0x1,%dl
  8015f9:	74 1a                	je     801615 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801600:	b8 00 00 00 00       	mov    $0x0,%eax
  801605:	eb 13                	jmp    80161a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801607:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160c:	eb 0c                	jmp    80161a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80160e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801613:	eb 05                	jmp    80161a <fd_lookup+0x54>
  801615:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 18             	sub    $0x18,%esp
  801622:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801625:	ba 00 00 00 00       	mov    $0x0,%edx
  80162a:	eb 13                	jmp    80163f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80162c:	39 08                	cmp    %ecx,(%eax)
  80162e:	75 0c                	jne    80163c <dev_lookup+0x20>
			*dev = devtab[i];
  801630:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801633:	89 01                	mov    %eax,(%ecx)
			return 0;
  801635:	b8 00 00 00 00       	mov    $0x0,%eax
  80163a:	eb 38                	jmp    801674 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80163c:	83 c2 01             	add    $0x1,%edx
  80163f:	8b 04 95 98 33 80 00 	mov    0x803398(,%edx,4),%eax
  801646:	85 c0                	test   %eax,%eax
  801648:	75 e2                	jne    80162c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80164a:	a1 08 50 80 00       	mov    0x805008,%eax
  80164f:	8b 40 48             	mov    0x48(%eax),%eax
  801652:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801656:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165a:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  801661:	e8 13 ee ff ff       	call   800479 <cprintf>
	*dev = 0;
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80166f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	56                   	push   %esi
  80167a:	53                   	push   %ebx
  80167b:	83 ec 20             	sub    $0x20,%esp
  80167e:	8b 75 08             	mov    0x8(%ebp),%esi
  801681:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801684:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801687:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80168b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801691:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801694:	89 04 24             	mov    %eax,(%esp)
  801697:	e8 2a ff ff ff       	call   8015c6 <fd_lookup>
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 05                	js     8016a5 <fd_close+0x2f>
	    || fd != fd2)
  8016a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016a3:	74 0c                	je     8016b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016a5:	84 db                	test   %bl,%bl
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	0f 44 c2             	cmove  %edx,%eax
  8016af:	eb 3f                	jmp    8016f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b8:	8b 06                	mov    (%esi),%eax
  8016ba:	89 04 24             	mov    %eax,(%esp)
  8016bd:	e8 5a ff ff ff       	call   80161c <dev_lookup>
  8016c2:	89 c3                	mov    %eax,%ebx
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 16                	js     8016de <fd_close+0x68>
		if (dev->dev_close)
  8016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	74 07                	je     8016de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8016d7:	89 34 24             	mov    %esi,(%esp)
  8016da:	ff d0                	call   *%eax
  8016dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e9:	e8 7c f8 ff ff       	call   800f6a <sys_page_unmap>
	return r;
  8016ee:	89 d8                	mov    %ebx,%eax
}
  8016f0:	83 c4 20             	add    $0x20,%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5e                   	pop    %esi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    

008016f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801700:	89 44 24 04          	mov    %eax,0x4(%esp)
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	89 04 24             	mov    %eax,(%esp)
  80170a:	e8 b7 fe ff ff       	call   8015c6 <fd_lookup>
  80170f:	89 c2                	mov    %eax,%edx
  801711:	85 d2                	test   %edx,%edx
  801713:	78 13                	js     801728 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801715:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80171c:	00 
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	89 04 24             	mov    %eax,(%esp)
  801723:	e8 4e ff ff ff       	call   801676 <fd_close>
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <close_all>:

void
close_all(void)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	53                   	push   %ebx
  80172e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801731:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801736:	89 1c 24             	mov    %ebx,(%esp)
  801739:	e8 b9 ff ff ff       	call   8016f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80173e:	83 c3 01             	add    $0x1,%ebx
  801741:	83 fb 20             	cmp    $0x20,%ebx
  801744:	75 f0                	jne    801736 <close_all+0xc>
		close(i);
}
  801746:	83 c4 14             	add    $0x14,%esp
  801749:	5b                   	pop    %ebx
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    

0080174c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	57                   	push   %edi
  801750:	56                   	push   %esi
  801751:	53                   	push   %ebx
  801752:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801755:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801758:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	89 04 24             	mov    %eax,(%esp)
  801762:	e8 5f fe ff ff       	call   8015c6 <fd_lookup>
  801767:	89 c2                	mov    %eax,%edx
  801769:	85 d2                	test   %edx,%edx
  80176b:	0f 88 e1 00 00 00    	js     801852 <dup+0x106>
		return r;
	close(newfdnum);
  801771:	8b 45 0c             	mov    0xc(%ebp),%eax
  801774:	89 04 24             	mov    %eax,(%esp)
  801777:	e8 7b ff ff ff       	call   8016f7 <close>

	newfd = INDEX2FD(newfdnum);
  80177c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80177f:	c1 e3 0c             	shl    $0xc,%ebx
  801782:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80178b:	89 04 24             	mov    %eax,(%esp)
  80178e:	e8 cd fd ff ff       	call   801560 <fd2data>
  801793:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801795:	89 1c 24             	mov    %ebx,(%esp)
  801798:	e8 c3 fd ff ff       	call   801560 <fd2data>
  80179d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80179f:	89 f0                	mov    %esi,%eax
  8017a1:	c1 e8 16             	shr    $0x16,%eax
  8017a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017ab:	a8 01                	test   $0x1,%al
  8017ad:	74 43                	je     8017f2 <dup+0xa6>
  8017af:	89 f0                	mov    %esi,%eax
  8017b1:	c1 e8 0c             	shr    $0xc,%eax
  8017b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017bb:	f6 c2 01             	test   $0x1,%dl
  8017be:	74 32                	je     8017f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017db:	00 
  8017dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e7:	e8 2b f7 ff ff       	call   800f17 <sys_page_map>
  8017ec:	89 c6                	mov    %eax,%esi
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 3e                	js     801830 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f5:	89 c2                	mov    %eax,%edx
  8017f7:	c1 ea 0c             	shr    $0xc,%edx
  8017fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801801:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801807:	89 54 24 10          	mov    %edx,0x10(%esp)
  80180b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80180f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801816:	00 
  801817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801822:	e8 f0 f6 ff ff       	call   800f17 <sys_page_map>
  801827:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801829:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80182c:	85 f6                	test   %esi,%esi
  80182e:	79 22                	jns    801852 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801830:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801834:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80183b:	e8 2a f7 ff ff       	call   800f6a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801840:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801844:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184b:	e8 1a f7 ff ff       	call   800f6a <sys_page_unmap>
	return r;
  801850:	89 f0                	mov    %esi,%eax
}
  801852:	83 c4 3c             	add    $0x3c,%esp
  801855:	5b                   	pop    %ebx
  801856:	5e                   	pop    %esi
  801857:	5f                   	pop    %edi
  801858:	5d                   	pop    %ebp
  801859:	c3                   	ret    

0080185a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	53                   	push   %ebx
  80185e:	83 ec 24             	sub    $0x24,%esp
  801861:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801864:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186b:	89 1c 24             	mov    %ebx,(%esp)
  80186e:	e8 53 fd ff ff       	call   8015c6 <fd_lookup>
  801873:	89 c2                	mov    %eax,%edx
  801875:	85 d2                	test   %edx,%edx
  801877:	78 6d                	js     8018e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801883:	8b 00                	mov    (%eax),%eax
  801885:	89 04 24             	mov    %eax,(%esp)
  801888:	e8 8f fd ff ff       	call   80161c <dev_lookup>
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 55                	js     8018e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801894:	8b 50 08             	mov    0x8(%eax),%edx
  801897:	83 e2 03             	and    $0x3,%edx
  80189a:	83 fa 01             	cmp    $0x1,%edx
  80189d:	75 23                	jne    8018c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80189f:	a1 08 50 80 00       	mov    0x805008,%eax
  8018a4:	8b 40 48             	mov    0x48(%eax),%eax
  8018a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018af:	c7 04 24 5d 33 80 00 	movl   $0x80335d,(%esp)
  8018b6:	e8 be eb ff ff       	call   800479 <cprintf>
		return -E_INVAL;
  8018bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c0:	eb 24                	jmp    8018e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8018c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c5:	8b 52 08             	mov    0x8(%edx),%edx
  8018c8:	85 d2                	test   %edx,%edx
  8018ca:	74 15                	je     8018e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018da:	89 04 24             	mov    %eax,(%esp)
  8018dd:	ff d2                	call   *%edx
  8018df:	eb 05                	jmp    8018e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018e6:	83 c4 24             	add    $0x24,%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    

008018ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	57                   	push   %edi
  8018f0:	56                   	push   %esi
  8018f1:	53                   	push   %ebx
  8018f2:	83 ec 1c             	sub    $0x1c,%esp
  8018f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801900:	eb 23                	jmp    801925 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801902:	89 f0                	mov    %esi,%eax
  801904:	29 d8                	sub    %ebx,%eax
  801906:	89 44 24 08          	mov    %eax,0x8(%esp)
  80190a:	89 d8                	mov    %ebx,%eax
  80190c:	03 45 0c             	add    0xc(%ebp),%eax
  80190f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801913:	89 3c 24             	mov    %edi,(%esp)
  801916:	e8 3f ff ff ff       	call   80185a <read>
		if (m < 0)
  80191b:	85 c0                	test   %eax,%eax
  80191d:	78 10                	js     80192f <readn+0x43>
			return m;
		if (m == 0)
  80191f:	85 c0                	test   %eax,%eax
  801921:	74 0a                	je     80192d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801923:	01 c3                	add    %eax,%ebx
  801925:	39 f3                	cmp    %esi,%ebx
  801927:	72 d9                	jb     801902 <readn+0x16>
  801929:	89 d8                	mov    %ebx,%eax
  80192b:	eb 02                	jmp    80192f <readn+0x43>
  80192d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80192f:	83 c4 1c             	add    $0x1c,%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5f                   	pop    %edi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	53                   	push   %ebx
  80193b:	83 ec 24             	sub    $0x24,%esp
  80193e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801941:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801944:	89 44 24 04          	mov    %eax,0x4(%esp)
  801948:	89 1c 24             	mov    %ebx,(%esp)
  80194b:	e8 76 fc ff ff       	call   8015c6 <fd_lookup>
  801950:	89 c2                	mov    %eax,%edx
  801952:	85 d2                	test   %edx,%edx
  801954:	78 68                	js     8019be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801956:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801959:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801960:	8b 00                	mov    (%eax),%eax
  801962:	89 04 24             	mov    %eax,(%esp)
  801965:	e8 b2 fc ff ff       	call   80161c <dev_lookup>
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 50                	js     8019be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80196e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801971:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801975:	75 23                	jne    80199a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801977:	a1 08 50 80 00       	mov    0x805008,%eax
  80197c:	8b 40 48             	mov    0x48(%eax),%eax
  80197f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801983:	89 44 24 04          	mov    %eax,0x4(%esp)
  801987:	c7 04 24 79 33 80 00 	movl   $0x803379,(%esp)
  80198e:	e8 e6 ea ff ff       	call   800479 <cprintf>
		return -E_INVAL;
  801993:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801998:	eb 24                	jmp    8019be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80199a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199d:	8b 52 0c             	mov    0xc(%edx),%edx
  8019a0:	85 d2                	test   %edx,%edx
  8019a2:	74 15                	je     8019b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019b2:	89 04 24             	mov    %eax,(%esp)
  8019b5:	ff d2                	call   *%edx
  8019b7:	eb 05                	jmp    8019be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8019b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019be:	83 c4 24             	add    $0x24,%esp
  8019c1:	5b                   	pop    %ebx
  8019c2:	5d                   	pop    %ebp
  8019c3:	c3                   	ret    

008019c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	89 04 24             	mov    %eax,(%esp)
  8019d7:	e8 ea fb ff ff       	call   8015c6 <fd_lookup>
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	78 0e                	js     8019ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	53                   	push   %ebx
  8019f4:	83 ec 24             	sub    $0x24,%esp
  8019f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a01:	89 1c 24             	mov    %ebx,(%esp)
  801a04:	e8 bd fb ff ff       	call   8015c6 <fd_lookup>
  801a09:	89 c2                	mov    %eax,%edx
  801a0b:	85 d2                	test   %edx,%edx
  801a0d:	78 61                	js     801a70 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a19:	8b 00                	mov    (%eax),%eax
  801a1b:	89 04 24             	mov    %eax,(%esp)
  801a1e:	e8 f9 fb ff ff       	call   80161c <dev_lookup>
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 49                	js     801a70 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a2e:	75 23                	jne    801a53 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a30:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a35:	8b 40 48             	mov    0x48(%eax),%eax
  801a38:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a40:	c7 04 24 3c 33 80 00 	movl   $0x80333c,(%esp)
  801a47:	e8 2d ea ff ff       	call   800479 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a51:	eb 1d                	jmp    801a70 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a56:	8b 52 18             	mov    0x18(%edx),%edx
  801a59:	85 d2                	test   %edx,%edx
  801a5b:	74 0e                	je     801a6b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a64:	89 04 24             	mov    %eax,(%esp)
  801a67:	ff d2                	call   *%edx
  801a69:	eb 05                	jmp    801a70 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a70:	83 c4 24             	add    $0x24,%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5d                   	pop    %ebp
  801a75:	c3                   	ret    

00801a76 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	53                   	push   %ebx
  801a7a:	83 ec 24             	sub    $0x24,%esp
  801a7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	89 04 24             	mov    %eax,(%esp)
  801a8d:	e8 34 fb ff ff       	call   8015c6 <fd_lookup>
  801a92:	89 c2                	mov    %eax,%edx
  801a94:	85 d2                	test   %edx,%edx
  801a96:	78 52                	js     801aea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa2:	8b 00                	mov    (%eax),%eax
  801aa4:	89 04 24             	mov    %eax,(%esp)
  801aa7:	e8 70 fb ff ff       	call   80161c <dev_lookup>
  801aac:	85 c0                	test   %eax,%eax
  801aae:	78 3a                	js     801aea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ab7:	74 2c                	je     801ae5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ab9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801abc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ac3:	00 00 00 
	stat->st_isdir = 0;
  801ac6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801acd:	00 00 00 
	stat->st_dev = dev;
  801ad0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ad6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ada:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801add:	89 14 24             	mov    %edx,(%esp)
  801ae0:	ff 50 14             	call   *0x14(%eax)
  801ae3:	eb 05                	jmp    801aea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ae5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801aea:	83 c4 24             	add    $0x24,%esp
  801aed:	5b                   	pop    %ebx
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    

00801af0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	56                   	push   %esi
  801af4:	53                   	push   %ebx
  801af5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801af8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801aff:	00 
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	89 04 24             	mov    %eax,(%esp)
  801b06:	e8 28 02 00 00       	call   801d33 <open>
  801b0b:	89 c3                	mov    %eax,%ebx
  801b0d:	85 db                	test   %ebx,%ebx
  801b0f:	78 1b                	js     801b2c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b18:	89 1c 24             	mov    %ebx,(%esp)
  801b1b:	e8 56 ff ff ff       	call   801a76 <fstat>
  801b20:	89 c6                	mov    %eax,%esi
	close(fd);
  801b22:	89 1c 24             	mov    %ebx,(%esp)
  801b25:	e8 cd fb ff ff       	call   8016f7 <close>
	return r;
  801b2a:	89 f0                	mov    %esi,%eax
}
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    

00801b33 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	56                   	push   %esi
  801b37:	53                   	push   %ebx
  801b38:	83 ec 10             	sub    $0x10,%esp
  801b3b:	89 c6                	mov    %eax,%esi
  801b3d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b3f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b46:	75 11                	jne    801b59 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b4f:	e8 72 0e 00 00       	call   8029c6 <ipc_find_env>
  801b54:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b59:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b60:	00 
  801b61:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b68:	00 
  801b69:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b6d:	a1 00 50 80 00       	mov    0x805000,%eax
  801b72:	89 04 24             	mov    %eax,(%esp)
  801b75:	e8 ee 0d 00 00       	call   802968 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b81:	00 
  801b82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b8d:	e8 6c 0d 00 00       	call   8028fe <ipc_recv>
}
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	5b                   	pop    %ebx
  801b96:	5e                   	pop    %esi
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    

00801b99 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bad:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb7:	b8 02 00 00 00       	mov    $0x2,%eax
  801bbc:	e8 72 ff ff ff       	call   801b33 <fsipc>
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bde:	e8 50 ff ff ff       	call   801b33 <fsipc>
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	53                   	push   %ebx
  801be9:	83 ec 14             	sub    $0x14,%esp
  801bec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801bff:	b8 05 00 00 00       	mov    $0x5,%eax
  801c04:	e8 2a ff ff ff       	call   801b33 <fsipc>
  801c09:	89 c2                	mov    %eax,%edx
  801c0b:	85 d2                	test   %edx,%edx
  801c0d:	78 2b                	js     801c3a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c16:	00 
  801c17:	89 1c 24             	mov    %ebx,(%esp)
  801c1a:	e8 88 ee ff ff       	call   800aa7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c1f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c24:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c2a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c2f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3a:	83 c4 14             	add    $0x14,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    

00801c40 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 18             	sub    $0x18,%esp
  801c46:	8b 45 10             	mov    0x10(%ebp),%eax
  801c49:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801c4e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801c53:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801c56:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  801c5e:	8b 52 0c             	mov    0xc(%edx),%edx
  801c61:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801c67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c72:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c79:	e8 c6 ef ff ff       	call   800c44 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c83:	b8 04 00 00 00       	mov    $0x4,%eax
  801c88:	e8 a6 fe ff ff       	call   801b33 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	56                   	push   %esi
  801c93:	53                   	push   %ebx
  801c94:	83 ec 10             	sub    $0x10,%esp
  801c97:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ca5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cab:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb5:	e8 79 fe ff ff       	call   801b33 <fsipc>
  801cba:	89 c3                	mov    %eax,%ebx
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	78 6a                	js     801d2a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801cc0:	39 c6                	cmp    %eax,%esi
  801cc2:	73 24                	jae    801ce8 <devfile_read+0x59>
  801cc4:	c7 44 24 0c ac 33 80 	movl   $0x8033ac,0xc(%esp)
  801ccb:	00 
  801ccc:	c7 44 24 08 b3 33 80 	movl   $0x8033b3,0x8(%esp)
  801cd3:	00 
  801cd4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801cdb:	00 
  801cdc:	c7 04 24 c8 33 80 00 	movl   $0x8033c8,(%esp)
  801ce3:	e8 98 e6 ff ff       	call   800380 <_panic>
	assert(r <= PGSIZE);
  801ce8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ced:	7e 24                	jle    801d13 <devfile_read+0x84>
  801cef:	c7 44 24 0c d3 33 80 	movl   $0x8033d3,0xc(%esp)
  801cf6:	00 
  801cf7:	c7 44 24 08 b3 33 80 	movl   $0x8033b3,0x8(%esp)
  801cfe:	00 
  801cff:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d06:	00 
  801d07:	c7 04 24 c8 33 80 00 	movl   $0x8033c8,(%esp)
  801d0e:	e8 6d e6 ff ff       	call   800380 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d13:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d17:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d1e:	00 
  801d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d22:	89 04 24             	mov    %eax,(%esp)
  801d25:	e8 1a ef ff ff       	call   800c44 <memmove>
	return r;
}
  801d2a:	89 d8                	mov    %ebx,%eax
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	5b                   	pop    %ebx
  801d30:	5e                   	pop    %esi
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    

00801d33 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	53                   	push   %ebx
  801d37:	83 ec 24             	sub    $0x24,%esp
  801d3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d3d:	89 1c 24             	mov    %ebx,(%esp)
  801d40:	e8 2b ed ff ff       	call   800a70 <strlen>
  801d45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d4a:	7f 60                	jg     801dac <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 20 f8 ff ff       	call   801577 <fd_alloc>
  801d57:	89 c2                	mov    %eax,%edx
  801d59:	85 d2                	test   %edx,%edx
  801d5b:	78 54                	js     801db1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d5d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d61:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d68:	e8 3a ed ff ff       	call   800aa7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d70:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d78:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7d:	e8 b1 fd ff ff       	call   801b33 <fsipc>
  801d82:	89 c3                	mov    %eax,%ebx
  801d84:	85 c0                	test   %eax,%eax
  801d86:	79 17                	jns    801d9f <open+0x6c>
		fd_close(fd, 0);
  801d88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d8f:	00 
  801d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d93:	89 04 24             	mov    %eax,(%esp)
  801d96:	e8 db f8 ff ff       	call   801676 <fd_close>
		return r;
  801d9b:	89 d8                	mov    %ebx,%eax
  801d9d:	eb 12                	jmp    801db1 <open+0x7e>
	}

	return fd2num(fd);
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	89 04 24             	mov    %eax,(%esp)
  801da5:	e8 a6 f7 ff ff       	call   801550 <fd2num>
  801daa:	eb 05                	jmp    801db1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801dac:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801db1:	83 c4 24             	add    $0x24,%esp
  801db4:	5b                   	pop    %ebx
  801db5:	5d                   	pop    %ebp
  801db6:	c3                   	ret    

00801db7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc2:	b8 08 00 00 00       	mov    $0x8,%eax
  801dc7:	e8 67 fd ff ff       	call   801b33 <fsipc>
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    
  801dce:	66 90                	xchg   %ax,%ax

00801dd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801dd6:	c7 44 24 04 df 33 80 	movl   $0x8033df,0x4(%esp)
  801ddd:	00 
  801dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de1:	89 04 24             	mov    %eax,(%esp)
  801de4:	e8 be ec ff ff       	call   800aa7 <strcpy>
	return 0;
}
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	53                   	push   %ebx
  801df4:	83 ec 14             	sub    $0x14,%esp
  801df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dfa:	89 1c 24             	mov    %ebx,(%esp)
  801dfd:	e8 fc 0b 00 00       	call   8029fe <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e02:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e07:	83 f8 01             	cmp    $0x1,%eax
  801e0a:	75 0d                	jne    801e19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e0c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e0f:	89 04 24             	mov    %eax,(%esp)
  801e12:	e8 29 03 00 00       	call   802140 <nsipc_close>
  801e17:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e19:	89 d0                	mov    %edx,%eax
  801e1b:	83 c4 14             	add    $0x14,%esp
  801e1e:	5b                   	pop    %ebx
  801e1f:	5d                   	pop    %ebp
  801e20:	c3                   	ret    

00801e21 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e2e:	00 
  801e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	8b 40 0c             	mov    0xc(%eax),%eax
  801e43:	89 04 24             	mov    %eax,(%esp)
  801e46:	e8 f0 03 00 00       	call   80223b <nsipc_send>
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e5a:	00 
  801e5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6f:	89 04 24             	mov    %eax,(%esp)
  801e72:	e8 44 03 00 00       	call   8021bb <nsipc_recv>
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e7f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e82:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e86:	89 04 24             	mov    %eax,(%esp)
  801e89:	e8 38 f7 ff ff       	call   8015c6 <fd_lookup>
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	78 17                	js     801ea9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e95:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801e9b:	39 08                	cmp    %ecx,(%eax)
  801e9d:	75 05                	jne    801ea4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea2:	eb 05                	jmp    801ea9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ea4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	56                   	push   %esi
  801eaf:	53                   	push   %ebx
  801eb0:	83 ec 20             	sub    $0x20,%esp
  801eb3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801eb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb8:	89 04 24             	mov    %eax,(%esp)
  801ebb:	e8 b7 f6 ff ff       	call   801577 <fd_alloc>
  801ec0:	89 c3                	mov    %eax,%ebx
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	78 21                	js     801ee7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ec6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ecd:	00 
  801ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801edc:	e8 e2 ef ff ff       	call   800ec3 <sys_page_alloc>
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	79 0c                	jns    801ef3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801ee7:	89 34 24             	mov    %esi,(%esp)
  801eea:	e8 51 02 00 00       	call   802140 <nsipc_close>
		return r;
  801eef:	89 d8                	mov    %ebx,%eax
  801ef1:	eb 20                	jmp    801f13 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ef3:	8b 15 24 40 80 00    	mov    0x804024,%edx
  801ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801efe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f01:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f08:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f0b:	89 14 24             	mov    %edx,(%esp)
  801f0e:	e8 3d f6 ff ff       	call   801550 <fd2num>
}
  801f13:	83 c4 20             	add    $0x20,%esp
  801f16:	5b                   	pop    %ebx
  801f17:	5e                   	pop    %esi
  801f18:	5d                   	pop    %ebp
  801f19:	c3                   	ret    

00801f1a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f20:	8b 45 08             	mov    0x8(%ebp),%eax
  801f23:	e8 51 ff ff ff       	call   801e79 <fd2sockid>
		return r;
  801f28:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	78 23                	js     801f51 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f2e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f31:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f38:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f3c:	89 04 24             	mov    %eax,(%esp)
  801f3f:	e8 45 01 00 00       	call   802089 <nsipc_accept>
		return r;
  801f44:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f46:	85 c0                	test   %eax,%eax
  801f48:	78 07                	js     801f51 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f4a:	e8 5c ff ff ff       	call   801eab <alloc_sockfd>
  801f4f:	89 c1                	mov    %eax,%ecx
}
  801f51:	89 c8                	mov    %ecx,%eax
  801f53:	c9                   	leave  
  801f54:	c3                   	ret    

00801f55 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	e8 16 ff ff ff       	call   801e79 <fd2sockid>
  801f63:	89 c2                	mov    %eax,%edx
  801f65:	85 d2                	test   %edx,%edx
  801f67:	78 16                	js     801f7f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801f69:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f77:	89 14 24             	mov    %edx,(%esp)
  801f7a:	e8 60 01 00 00       	call   8020df <nsipc_bind>
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <shutdown>:

int
shutdown(int s, int how)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f87:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8a:	e8 ea fe ff ff       	call   801e79 <fd2sockid>
  801f8f:	89 c2                	mov    %eax,%edx
  801f91:	85 d2                	test   %edx,%edx
  801f93:	78 0f                	js     801fa4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9c:	89 14 24             	mov    %edx,(%esp)
  801f9f:	e8 7a 01 00 00       	call   80211e <nsipc_shutdown>
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	e8 c5 fe ff ff       	call   801e79 <fd2sockid>
  801fb4:	89 c2                	mov    %eax,%edx
  801fb6:	85 d2                	test   %edx,%edx
  801fb8:	78 16                	js     801fd0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801fba:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc8:	89 14 24             	mov    %edx,(%esp)
  801fcb:	e8 8a 01 00 00       	call   80215a <nsipc_connect>
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <listen>:

int
listen(int s, int backlog)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	e8 99 fe ff ff       	call   801e79 <fd2sockid>
  801fe0:	89 c2                	mov    %eax,%edx
  801fe2:	85 d2                	test   %edx,%edx
  801fe4:	78 0f                	js     801ff5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fed:	89 14 24             	mov    %edx,(%esp)
  801ff0:	e8 a4 01 00 00       	call   802199 <nsipc_listen>
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ffd:	8b 45 10             	mov    0x10(%ebp),%eax
  802000:	89 44 24 08          	mov    %eax,0x8(%esp)
  802004:	8b 45 0c             	mov    0xc(%ebp),%eax
  802007:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	89 04 24             	mov    %eax,(%esp)
  802011:	e8 98 02 00 00       	call   8022ae <nsipc_socket>
  802016:	89 c2                	mov    %eax,%edx
  802018:	85 d2                	test   %edx,%edx
  80201a:	78 05                	js     802021 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80201c:	e8 8a fe ff ff       	call   801eab <alloc_sockfd>
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	53                   	push   %ebx
  802027:	83 ec 14             	sub    $0x14,%esp
  80202a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80202c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802033:	75 11                	jne    802046 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802035:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80203c:	e8 85 09 00 00       	call   8029c6 <ipc_find_env>
  802041:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802046:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80204d:	00 
  80204e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802055:	00 
  802056:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80205a:	a1 04 50 80 00       	mov    0x805004,%eax
  80205f:	89 04 24             	mov    %eax,(%esp)
  802062:	e8 01 09 00 00       	call   802968 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802067:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80206e:	00 
  80206f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802076:	00 
  802077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80207e:	e8 7b 08 00 00       	call   8028fe <ipc_recv>
}
  802083:	83 c4 14             	add    $0x14,%esp
  802086:	5b                   	pop    %ebx
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    

00802089 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	56                   	push   %esi
  80208d:	53                   	push   %ebx
  80208e:	83 ec 10             	sub    $0x10,%esp
  802091:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80209c:	8b 06                	mov    (%esi),%eax
  80209e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a8:	e8 76 ff ff ff       	call   802023 <nsipc>
  8020ad:	89 c3                	mov    %eax,%ebx
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 23                	js     8020d6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020b3:	a1 10 70 80 00       	mov    0x807010,%eax
  8020b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020bc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020c3:	00 
  8020c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c7:	89 04 24             	mov    %eax,(%esp)
  8020ca:	e8 75 eb ff ff       	call   800c44 <memmove>
		*addrlen = ret->ret_addrlen;
  8020cf:	a1 10 70 80 00       	mov    0x807010,%eax
  8020d4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8020d6:	89 d8                	mov    %ebx,%eax
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	5b                   	pop    %ebx
  8020dc:	5e                   	pop    %esi
  8020dd:	5d                   	pop    %ebp
  8020de:	c3                   	ret    

008020df <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
  8020e2:	53                   	push   %ebx
  8020e3:	83 ec 14             	sub    $0x14,%esp
  8020e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802103:	e8 3c eb ff ff       	call   800c44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802108:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80210e:	b8 02 00 00 00       	mov    $0x2,%eax
  802113:	e8 0b ff ff ff       	call   802023 <nsipc>
}
  802118:	83 c4 14             	add    $0x14,%esp
  80211b:	5b                   	pop    %ebx
  80211c:	5d                   	pop    %ebp
  80211d:	c3                   	ret    

0080211e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80212c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802134:	b8 03 00 00 00       	mov    $0x3,%eax
  802139:	e8 e5 fe ff ff       	call   802023 <nsipc>
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <nsipc_close>:

int
nsipc_close(int s)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80214e:	b8 04 00 00 00       	mov    $0x4,%eax
  802153:	e8 cb fe ff ff       	call   802023 <nsipc>
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	53                   	push   %ebx
  80215e:	83 ec 14             	sub    $0x14,%esp
  802161:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80216c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802170:	8b 45 0c             	mov    0xc(%ebp),%eax
  802173:	89 44 24 04          	mov    %eax,0x4(%esp)
  802177:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80217e:	e8 c1 ea ff ff       	call   800c44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802183:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802189:	b8 05 00 00 00       	mov    $0x5,%eax
  80218e:	e8 90 fe ff ff       	call   802023 <nsipc>
}
  802193:	83 c4 14             	add    $0x14,%esp
  802196:	5b                   	pop    %ebx
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    

00802199 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021af:	b8 06 00 00 00       	mov    $0x6,%eax
  8021b4:	e8 6a fe ff ff       	call   802023 <nsipc>
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	56                   	push   %esi
  8021bf:	53                   	push   %ebx
  8021c0:	83 ec 10             	sub    $0x10,%esp
  8021c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021ce:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8021e1:	e8 3d fe ff ff       	call   802023 <nsipc>
  8021e6:	89 c3                	mov    %eax,%ebx
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	78 46                	js     802232 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8021ec:	39 f0                	cmp    %esi,%eax
  8021ee:	7f 07                	jg     8021f7 <nsipc_recv+0x3c>
  8021f0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021f5:	7e 24                	jle    80221b <nsipc_recv+0x60>
  8021f7:	c7 44 24 0c eb 33 80 	movl   $0x8033eb,0xc(%esp)
  8021fe:	00 
  8021ff:	c7 44 24 08 b3 33 80 	movl   $0x8033b3,0x8(%esp)
  802206:	00 
  802207:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80220e:	00 
  80220f:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  802216:	e8 65 e1 ff ff       	call   800380 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80221b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80221f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802226:	00 
  802227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222a:	89 04 24             	mov    %eax,(%esp)
  80222d:	e8 12 ea ff ff       	call   800c44 <memmove>
	}

	return r;
}
  802232:	89 d8                	mov    %ebx,%eax
  802234:	83 c4 10             	add    $0x10,%esp
  802237:	5b                   	pop    %ebx
  802238:	5e                   	pop    %esi
  802239:	5d                   	pop    %ebp
  80223a:	c3                   	ret    

0080223b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	53                   	push   %ebx
  80223f:	83 ec 14             	sub    $0x14,%esp
  802242:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80224d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802253:	7e 24                	jle    802279 <nsipc_send+0x3e>
  802255:	c7 44 24 0c 0c 34 80 	movl   $0x80340c,0xc(%esp)
  80225c:	00 
  80225d:	c7 44 24 08 b3 33 80 	movl   $0x8033b3,0x8(%esp)
  802264:	00 
  802265:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80226c:	00 
  80226d:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  802274:	e8 07 e1 ff ff       	call   800380 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802279:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80227d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802280:	89 44 24 04          	mov    %eax,0x4(%esp)
  802284:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80228b:	e8 b4 e9 ff ff       	call   800c44 <memmove>
	nsipcbuf.send.req_size = size;
  802290:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802296:	8b 45 14             	mov    0x14(%ebp),%eax
  802299:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80229e:	b8 08 00 00 00       	mov    $0x8,%eax
  8022a3:	e8 7b fd ff ff       	call   802023 <nsipc>
}
  8022a8:	83 c4 14             	add    $0x14,%esp
  8022ab:	5b                   	pop    %ebx
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    

008022ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022bf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8022d1:	e8 4d fd ff ff       	call   802023 <nsipc>
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	56                   	push   %esi
  8022dc:	53                   	push   %ebx
  8022dd:	83 ec 10             	sub    $0x10,%esp
  8022e0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 04 24             	mov    %eax,(%esp)
  8022e9:	e8 72 f2 ff ff       	call   801560 <fd2data>
  8022ee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022f0:	c7 44 24 04 18 34 80 	movl   $0x803418,0x4(%esp)
  8022f7:	00 
  8022f8:	89 1c 24             	mov    %ebx,(%esp)
  8022fb:	e8 a7 e7 ff ff       	call   800aa7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802300:	8b 46 04             	mov    0x4(%esi),%eax
  802303:	2b 06                	sub    (%esi),%eax
  802305:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80230b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802312:	00 00 00 
	stat->st_dev = &devpipe;
  802315:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80231c:	40 80 00 
	return 0;
}
  80231f:	b8 00 00 00 00       	mov    $0x0,%eax
  802324:	83 c4 10             	add    $0x10,%esp
  802327:	5b                   	pop    %ebx
  802328:	5e                   	pop    %esi
  802329:	5d                   	pop    %ebp
  80232a:	c3                   	ret    

0080232b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	53                   	push   %ebx
  80232f:	83 ec 14             	sub    $0x14,%esp
  802332:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802335:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802339:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802340:	e8 25 ec ff ff       	call   800f6a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802345:	89 1c 24             	mov    %ebx,(%esp)
  802348:	e8 13 f2 ff ff       	call   801560 <fd2data>
  80234d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802351:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802358:	e8 0d ec ff ff       	call   800f6a <sys_page_unmap>
}
  80235d:	83 c4 14             	add    $0x14,%esp
  802360:	5b                   	pop    %ebx
  802361:	5d                   	pop    %ebp
  802362:	c3                   	ret    

00802363 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	57                   	push   %edi
  802367:	56                   	push   %esi
  802368:	53                   	push   %ebx
  802369:	83 ec 2c             	sub    $0x2c,%esp
  80236c:	89 c6                	mov    %eax,%esi
  80236e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802371:	a1 08 50 80 00       	mov    0x805008,%eax
  802376:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802379:	89 34 24             	mov    %esi,(%esp)
  80237c:	e8 7d 06 00 00       	call   8029fe <pageref>
  802381:	89 c7                	mov    %eax,%edi
  802383:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802386:	89 04 24             	mov    %eax,(%esp)
  802389:	e8 70 06 00 00       	call   8029fe <pageref>
  80238e:	39 c7                	cmp    %eax,%edi
  802390:	0f 94 c2             	sete   %dl
  802393:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802396:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80239c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80239f:	39 fb                	cmp    %edi,%ebx
  8023a1:	74 21                	je     8023c4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8023a3:	84 d2                	test   %dl,%dl
  8023a5:	74 ca                	je     802371 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023a7:	8b 51 58             	mov    0x58(%ecx),%edx
  8023aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023b6:	c7 04 24 1f 34 80 00 	movl   $0x80341f,(%esp)
  8023bd:	e8 b7 e0 ff ff       	call   800479 <cprintf>
  8023c2:	eb ad                	jmp    802371 <_pipeisclosed+0xe>
	}
}
  8023c4:	83 c4 2c             	add    $0x2c,%esp
  8023c7:	5b                   	pop    %ebx
  8023c8:	5e                   	pop    %esi
  8023c9:	5f                   	pop    %edi
  8023ca:	5d                   	pop    %ebp
  8023cb:	c3                   	ret    

008023cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	57                   	push   %edi
  8023d0:	56                   	push   %esi
  8023d1:	53                   	push   %ebx
  8023d2:	83 ec 1c             	sub    $0x1c,%esp
  8023d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8023d8:	89 34 24             	mov    %esi,(%esp)
  8023db:	e8 80 f1 ff ff       	call   801560 <fd2data>
  8023e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023e7:	eb 45                	jmp    80242e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8023e9:	89 da                	mov    %ebx,%edx
  8023eb:	89 f0                	mov    %esi,%eax
  8023ed:	e8 71 ff ff ff       	call   802363 <_pipeisclosed>
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	75 41                	jne    802437 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8023f6:	e8 a9 ea ff ff       	call   800ea4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8023fe:	8b 0b                	mov    (%ebx),%ecx
  802400:	8d 51 20             	lea    0x20(%ecx),%edx
  802403:	39 d0                	cmp    %edx,%eax
  802405:	73 e2                	jae    8023e9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802407:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80240a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80240e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802411:	99                   	cltd   
  802412:	c1 ea 1b             	shr    $0x1b,%edx
  802415:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802418:	83 e1 1f             	and    $0x1f,%ecx
  80241b:	29 d1                	sub    %edx,%ecx
  80241d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802421:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802425:	83 c0 01             	add    $0x1,%eax
  802428:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80242b:	83 c7 01             	add    $0x1,%edi
  80242e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802431:	75 c8                	jne    8023fb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802433:	89 f8                	mov    %edi,%eax
  802435:	eb 05                	jmp    80243c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802437:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80243c:	83 c4 1c             	add    $0x1c,%esp
  80243f:	5b                   	pop    %ebx
  802440:	5e                   	pop    %esi
  802441:	5f                   	pop    %edi
  802442:	5d                   	pop    %ebp
  802443:	c3                   	ret    

00802444 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802444:	55                   	push   %ebp
  802445:	89 e5                	mov    %esp,%ebp
  802447:	57                   	push   %edi
  802448:	56                   	push   %esi
  802449:	53                   	push   %ebx
  80244a:	83 ec 1c             	sub    $0x1c,%esp
  80244d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802450:	89 3c 24             	mov    %edi,(%esp)
  802453:	e8 08 f1 ff ff       	call   801560 <fd2data>
  802458:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80245a:	be 00 00 00 00       	mov    $0x0,%esi
  80245f:	eb 3d                	jmp    80249e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802461:	85 f6                	test   %esi,%esi
  802463:	74 04                	je     802469 <devpipe_read+0x25>
				return i;
  802465:	89 f0                	mov    %esi,%eax
  802467:	eb 43                	jmp    8024ac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802469:	89 da                	mov    %ebx,%edx
  80246b:	89 f8                	mov    %edi,%eax
  80246d:	e8 f1 fe ff ff       	call   802363 <_pipeisclosed>
  802472:	85 c0                	test   %eax,%eax
  802474:	75 31                	jne    8024a7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802476:	e8 29 ea ff ff       	call   800ea4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80247b:	8b 03                	mov    (%ebx),%eax
  80247d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802480:	74 df                	je     802461 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802482:	99                   	cltd   
  802483:	c1 ea 1b             	shr    $0x1b,%edx
  802486:	01 d0                	add    %edx,%eax
  802488:	83 e0 1f             	and    $0x1f,%eax
  80248b:	29 d0                	sub    %edx,%eax
  80248d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802492:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802495:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802498:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80249b:	83 c6 01             	add    $0x1,%esi
  80249e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024a1:	75 d8                	jne    80247b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024a3:	89 f0                	mov    %esi,%eax
  8024a5:	eb 05                	jmp    8024ac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024ac:	83 c4 1c             	add    $0x1c,%esp
  8024af:	5b                   	pop    %ebx
  8024b0:	5e                   	pop    %esi
  8024b1:	5f                   	pop    %edi
  8024b2:	5d                   	pop    %ebp
  8024b3:	c3                   	ret    

008024b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	56                   	push   %esi
  8024b8:	53                   	push   %ebx
  8024b9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024bf:	89 04 24             	mov    %eax,(%esp)
  8024c2:	e8 b0 f0 ff ff       	call   801577 <fd_alloc>
  8024c7:	89 c2                	mov    %eax,%edx
  8024c9:	85 d2                	test   %edx,%edx
  8024cb:	0f 88 4d 01 00 00    	js     80261e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024d1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024d8:	00 
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e7:	e8 d7 e9 ff ff       	call   800ec3 <sys_page_alloc>
  8024ec:	89 c2                	mov    %eax,%edx
  8024ee:	85 d2                	test   %edx,%edx
  8024f0:	0f 88 28 01 00 00    	js     80261e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8024f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024f9:	89 04 24             	mov    %eax,(%esp)
  8024fc:	e8 76 f0 ff ff       	call   801577 <fd_alloc>
  802501:	89 c3                	mov    %eax,%ebx
  802503:	85 c0                	test   %eax,%eax
  802505:	0f 88 fe 00 00 00    	js     802609 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80250b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802512:	00 
  802513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80251a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802521:	e8 9d e9 ff ff       	call   800ec3 <sys_page_alloc>
  802526:	89 c3                	mov    %eax,%ebx
  802528:	85 c0                	test   %eax,%eax
  80252a:	0f 88 d9 00 00 00    	js     802609 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	89 04 24             	mov    %eax,(%esp)
  802536:	e8 25 f0 ff ff       	call   801560 <fd2data>
  80253b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80253d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802544:	00 
  802545:	89 44 24 04          	mov    %eax,0x4(%esp)
  802549:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802550:	e8 6e e9 ff ff       	call   800ec3 <sys_page_alloc>
  802555:	89 c3                	mov    %eax,%ebx
  802557:	85 c0                	test   %eax,%eax
  802559:	0f 88 97 00 00 00    	js     8025f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80255f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802562:	89 04 24             	mov    %eax,(%esp)
  802565:	e8 f6 ef ff ff       	call   801560 <fd2data>
  80256a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802571:	00 
  802572:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802576:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80257d:	00 
  80257e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802582:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802589:	e8 89 e9 ff ff       	call   800f17 <sys_page_map>
  80258e:	89 c3                	mov    %eax,%ebx
  802590:	85 c0                	test   %eax,%eax
  802592:	78 52                	js     8025e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802594:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025a9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	89 04 24             	mov    %eax,(%esp)
  8025c4:	e8 87 ef ff ff       	call   801550 <fd2num>
  8025c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d1:	89 04 24             	mov    %eax,(%esp)
  8025d4:	e8 77 ef ff ff       	call   801550 <fd2num>
  8025d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e4:	eb 38                	jmp    80261e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8025e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f1:	e8 74 e9 ff ff       	call   800f6a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8025f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802604:	e8 61 e9 ff ff       	call   800f6a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802610:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802617:	e8 4e e9 ff ff       	call   800f6a <sys_page_unmap>
  80261c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80261e:	83 c4 30             	add    $0x30,%esp
  802621:	5b                   	pop    %ebx
  802622:	5e                   	pop    %esi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    

00802625 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802625:	55                   	push   %ebp
  802626:	89 e5                	mov    %esp,%ebp
  802628:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80262b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80262e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	89 04 24             	mov    %eax,(%esp)
  802638:	e8 89 ef ff ff       	call   8015c6 <fd_lookup>
  80263d:	89 c2                	mov    %eax,%edx
  80263f:	85 d2                	test   %edx,%edx
  802641:	78 15                	js     802658 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	89 04 24             	mov    %eax,(%esp)
  802649:	e8 12 ef ff ff       	call   801560 <fd2data>
	return _pipeisclosed(fd, p);
  80264e:	89 c2                	mov    %eax,%edx
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	e8 0b fd ff ff       	call   802363 <_pipeisclosed>
}
  802658:	c9                   	leave  
  802659:	c3                   	ret    

0080265a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	56                   	push   %esi
  80265e:	53                   	push   %ebx
  80265f:	83 ec 10             	sub    $0x10,%esp
  802662:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802665:	85 f6                	test   %esi,%esi
  802667:	75 24                	jne    80268d <wait+0x33>
  802669:	c7 44 24 0c 37 34 80 	movl   $0x803437,0xc(%esp)
  802670:	00 
  802671:	c7 44 24 08 b3 33 80 	movl   $0x8033b3,0x8(%esp)
  802678:	00 
  802679:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802680:	00 
  802681:	c7 04 24 42 34 80 00 	movl   $0x803442,(%esp)
  802688:	e8 f3 dc ff ff       	call   800380 <_panic>
	e = &envs[ENVX(envid)];
  80268d:	89 f3                	mov    %esi,%ebx
  80268f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802695:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802698:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80269e:	eb 05                	jmp    8026a5 <wait+0x4b>
		sys_yield();
  8026a0:	e8 ff e7 ff ff       	call   800ea4 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026a5:	8b 43 48             	mov    0x48(%ebx),%eax
  8026a8:	39 f0                	cmp    %esi,%eax
  8026aa:	75 07                	jne    8026b3 <wait+0x59>
  8026ac:	8b 43 54             	mov    0x54(%ebx),%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	75 ed                	jne    8026a0 <wait+0x46>
		sys_yield();
}
  8026b3:	83 c4 10             	add    $0x10,%esp
  8026b6:	5b                   	pop    %ebx
  8026b7:	5e                   	pop    %esi
  8026b8:	5d                   	pop    %ebp
  8026b9:	c3                   	ret    
  8026ba:	66 90                	xchg   %ax,%ax
  8026bc:	66 90                	xchg   %ax,%ax
  8026be:	66 90                	xchg   %ax,%ax

008026c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c8:	5d                   	pop    %ebp
  8026c9:	c3                   	ret    

008026ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026d0:	c7 44 24 04 4d 34 80 	movl   $0x80344d,0x4(%esp)
  8026d7:	00 
  8026d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026db:	89 04 24             	mov    %eax,(%esp)
  8026de:	e8 c4 e3 ff ff       	call   800aa7 <strcpy>
	return 0;
}
  8026e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    

008026ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026ea:	55                   	push   %ebp
  8026eb:	89 e5                	mov    %esp,%ebp
  8026ed:	57                   	push   %edi
  8026ee:	56                   	push   %esi
  8026ef:	53                   	push   %ebx
  8026f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802701:	eb 31                	jmp    802734 <devcons_write+0x4a>
		m = n - tot;
  802703:	8b 75 10             	mov    0x10(%ebp),%esi
  802706:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802708:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80270b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802710:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802713:	89 74 24 08          	mov    %esi,0x8(%esp)
  802717:	03 45 0c             	add    0xc(%ebp),%eax
  80271a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80271e:	89 3c 24             	mov    %edi,(%esp)
  802721:	e8 1e e5 ff ff       	call   800c44 <memmove>
		sys_cputs(buf, m);
  802726:	89 74 24 04          	mov    %esi,0x4(%esp)
  80272a:	89 3c 24             	mov    %edi,(%esp)
  80272d:	e8 c4 e6 ff ff       	call   800df6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802732:	01 f3                	add    %esi,%ebx
  802734:	89 d8                	mov    %ebx,%eax
  802736:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802739:	72 c8                	jb     802703 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80273b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802741:	5b                   	pop    %ebx
  802742:	5e                   	pop    %esi
  802743:	5f                   	pop    %edi
  802744:	5d                   	pop    %ebp
  802745:	c3                   	ret    

00802746 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
  802749:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80274c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802751:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802755:	75 07                	jne    80275e <devcons_read+0x18>
  802757:	eb 2a                	jmp    802783 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802759:	e8 46 e7 ff ff       	call   800ea4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80275e:	66 90                	xchg   %ax,%ax
  802760:	e8 af e6 ff ff       	call   800e14 <sys_cgetc>
  802765:	85 c0                	test   %eax,%eax
  802767:	74 f0                	je     802759 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802769:	85 c0                	test   %eax,%eax
  80276b:	78 16                	js     802783 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80276d:	83 f8 04             	cmp    $0x4,%eax
  802770:	74 0c                	je     80277e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802772:	8b 55 0c             	mov    0xc(%ebp),%edx
  802775:	88 02                	mov    %al,(%edx)
	return 1;
  802777:	b8 01 00 00 00       	mov    $0x1,%eax
  80277c:	eb 05                	jmp    802783 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80277e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802783:	c9                   	leave  
  802784:	c3                   	ret    

00802785 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802785:	55                   	push   %ebp
  802786:	89 e5                	mov    %esp,%ebp
  802788:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80278b:	8b 45 08             	mov    0x8(%ebp),%eax
  80278e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802791:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802798:	00 
  802799:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80279c:	89 04 24             	mov    %eax,(%esp)
  80279f:	e8 52 e6 ff ff       	call   800df6 <sys_cputs>
}
  8027a4:	c9                   	leave  
  8027a5:	c3                   	ret    

008027a6 <getchar>:

int
getchar(void)
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8027ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8027b3:	00 
  8027b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027c2:	e8 93 f0 ff ff       	call   80185a <read>
	if (r < 0)
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	78 0f                	js     8027da <getchar+0x34>
		return r;
	if (r < 1)
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	7e 06                	jle    8027d5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8027cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8027d3:	eb 05                	jmp    8027da <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8027d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8027da:	c9                   	leave  
  8027db:	c3                   	ret    

008027dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027dc:	55                   	push   %ebp
  8027dd:	89 e5                	mov    %esp,%ebp
  8027df:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	89 04 24             	mov    %eax,(%esp)
  8027ef:	e8 d2 ed ff ff       	call   8015c6 <fd_lookup>
  8027f4:	85 c0                	test   %eax,%eax
  8027f6:	78 11                	js     802809 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802801:	39 10                	cmp    %edx,(%eax)
  802803:	0f 94 c0             	sete   %al
  802806:	0f b6 c0             	movzbl %al,%eax
}
  802809:	c9                   	leave  
  80280a:	c3                   	ret    

0080280b <opencons>:

int
opencons(void)
{
  80280b:	55                   	push   %ebp
  80280c:	89 e5                	mov    %esp,%ebp
  80280e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802811:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802814:	89 04 24             	mov    %eax,(%esp)
  802817:	e8 5b ed ff ff       	call   801577 <fd_alloc>
		return r;
  80281c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80281e:	85 c0                	test   %eax,%eax
  802820:	78 40                	js     802862 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802822:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802829:	00 
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802831:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802838:	e8 86 e6 ff ff       	call   800ec3 <sys_page_alloc>
		return r;
  80283d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80283f:	85 c0                	test   %eax,%eax
  802841:	78 1f                	js     802862 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802843:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802858:	89 04 24             	mov    %eax,(%esp)
  80285b:	e8 f0 ec ff ff       	call   801550 <fd2num>
  802860:	89 c2                	mov    %eax,%edx
}
  802862:	89 d0                	mov    %edx,%eax
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80286c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802873:	75 58                	jne    8028cd <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802875:	a1 08 50 80 00       	mov    0x805008,%eax
  80287a:	8b 40 48             	mov    0x48(%eax),%eax
  80287d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802884:	00 
  802885:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80288c:	ee 
  80288d:	89 04 24             	mov    %eax,(%esp)
  802890:	e8 2e e6 ff ff       	call   800ec3 <sys_page_alloc>
		if(return_code!=0)
  802895:	85 c0                	test   %eax,%eax
  802897:	74 1c                	je     8028b5 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802899:	c7 44 24 08 5c 34 80 	movl   $0x80345c,0x8(%esp)
  8028a0:	00 
  8028a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8028a8:	00 
  8028a9:	c7 04 24 b8 34 80 00 	movl   $0x8034b8,(%esp)
  8028b0:	e8 cb da ff ff       	call   800380 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  8028b5:	a1 08 50 80 00       	mov    0x805008,%eax
  8028ba:	8b 40 48             	mov    0x48(%eax),%eax
  8028bd:	c7 44 24 04 d7 28 80 	movl   $0x8028d7,0x4(%esp)
  8028c4:	00 
  8028c5:	89 04 24             	mov    %eax,(%esp)
  8028c8:	e8 96 e7 ff ff       	call   801063 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028d5:	c9                   	leave  
  8028d6:	c3                   	ret    

008028d7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028d7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028d8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028dd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028df:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  8028e2:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  8028e4:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  8028e8:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  8028ec:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  8028ed:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  8028ef:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  8028f1:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  8028f5:	58                   	pop    %eax
	popl %eax;
  8028f6:	58                   	pop    %eax
	popal;
  8028f7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  8028f8:	83 c4 04             	add    $0x4,%esp
	popfl;
  8028fb:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8028fc:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  8028fd:	c3                   	ret    

008028fe <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8028fe:	55                   	push   %ebp
  8028ff:	89 e5                	mov    %esp,%ebp
  802901:	56                   	push   %esi
  802902:	53                   	push   %ebx
  802903:	83 ec 10             	sub    $0x10,%esp
  802906:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802909:	8b 45 0c             	mov    0xc(%ebp),%eax
  80290c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80290f:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802911:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802916:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802919:	89 04 24             	mov    %eax,(%esp)
  80291c:	e8 b8 e7 ff ff       	call   8010d9 <sys_ipc_recv>
  802921:	85 c0                	test   %eax,%eax
  802923:	75 1e                	jne    802943 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802925:	85 db                	test   %ebx,%ebx
  802927:	74 0a                	je     802933 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802929:	a1 08 50 80 00       	mov    0x805008,%eax
  80292e:	8b 40 74             	mov    0x74(%eax),%eax
  802931:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802933:	85 f6                	test   %esi,%esi
  802935:	74 22                	je     802959 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802937:	a1 08 50 80 00       	mov    0x805008,%eax
  80293c:	8b 40 78             	mov    0x78(%eax),%eax
  80293f:	89 06                	mov    %eax,(%esi)
  802941:	eb 16                	jmp    802959 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802943:	85 f6                	test   %esi,%esi
  802945:	74 06                	je     80294d <ipc_recv+0x4f>
				*perm_store = 0;
  802947:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  80294d:	85 db                	test   %ebx,%ebx
  80294f:	74 10                	je     802961 <ipc_recv+0x63>
				*from_env_store=0;
  802951:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802957:	eb 08                	jmp    802961 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802959:	a1 08 50 80 00       	mov    0x805008,%eax
  80295e:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802961:	83 c4 10             	add    $0x10,%esp
  802964:	5b                   	pop    %ebx
  802965:	5e                   	pop    %esi
  802966:	5d                   	pop    %ebp
  802967:	c3                   	ret    

00802968 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802968:	55                   	push   %ebp
  802969:	89 e5                	mov    %esp,%ebp
  80296b:	57                   	push   %edi
  80296c:	56                   	push   %esi
  80296d:	53                   	push   %ebx
  80296e:	83 ec 1c             	sub    $0x1c,%esp
  802971:	8b 75 0c             	mov    0xc(%ebp),%esi
  802974:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802977:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  80297a:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  80297c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802981:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802984:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802988:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80298c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	89 04 24             	mov    %eax,(%esp)
  802996:	e8 1b e7 ff ff       	call   8010b6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  80299b:	eb 1c                	jmp    8029b9 <ipc_send+0x51>
	{
		sys_yield();
  80299d:	e8 02 e5 ff ff       	call   800ea4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8029a2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029a6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029aa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	89 04 24             	mov    %eax,(%esp)
  8029b4:	e8 fd e6 ff ff       	call   8010b6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8029b9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029bc:	74 df                	je     80299d <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8029be:	83 c4 1c             	add    $0x1c,%esp
  8029c1:	5b                   	pop    %ebx
  8029c2:	5e                   	pop    %esi
  8029c3:	5f                   	pop    %edi
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    

008029c6 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8029c6:	55                   	push   %ebp
  8029c7:	89 e5                	mov    %esp,%ebp
  8029c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8029cc:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8029d1:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8029d4:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8029da:	8b 52 50             	mov    0x50(%edx),%edx
  8029dd:	39 ca                	cmp    %ecx,%edx
  8029df:	75 0d                	jne    8029ee <ipc_find_env+0x28>
			return envs[i].env_id;
  8029e1:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8029e4:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8029e9:	8b 40 40             	mov    0x40(%eax),%eax
  8029ec:	eb 0e                	jmp    8029fc <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8029ee:	83 c0 01             	add    $0x1,%eax
  8029f1:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029f6:	75 d9                	jne    8029d1 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8029f8:	66 b8 00 00          	mov    $0x0,%ax
}
  8029fc:	5d                   	pop    %ebp
  8029fd:	c3                   	ret    

008029fe <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029fe:	55                   	push   %ebp
  8029ff:	89 e5                	mov    %esp,%ebp
  802a01:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a04:	89 d0                	mov    %edx,%eax
  802a06:	c1 e8 16             	shr    $0x16,%eax
  802a09:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a10:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a15:	f6 c1 01             	test   $0x1,%cl
  802a18:	74 1d                	je     802a37 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a1a:	c1 ea 0c             	shr    $0xc,%edx
  802a1d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a24:	f6 c2 01             	test   $0x1,%dl
  802a27:	74 0e                	je     802a37 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a29:	c1 ea 0c             	shr    $0xc,%edx
  802a2c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a33:	ef 
  802a34:	0f b7 c0             	movzwl %ax,%eax
}
  802a37:	5d                   	pop    %ebp
  802a38:	c3                   	ret    
  802a39:	66 90                	xchg   %ax,%ax
  802a3b:	66 90                	xchg   %ax,%ax
  802a3d:	66 90                	xchg   %ax,%ax
  802a3f:	90                   	nop

00802a40 <__udivdi3>:
  802a40:	55                   	push   %ebp
  802a41:	57                   	push   %edi
  802a42:	56                   	push   %esi
  802a43:	83 ec 0c             	sub    $0xc,%esp
  802a46:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a4a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a4e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a52:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a56:	85 c0                	test   %eax,%eax
  802a58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a5c:	89 ea                	mov    %ebp,%edx
  802a5e:	89 0c 24             	mov    %ecx,(%esp)
  802a61:	75 2d                	jne    802a90 <__udivdi3+0x50>
  802a63:	39 e9                	cmp    %ebp,%ecx
  802a65:	77 61                	ja     802ac8 <__udivdi3+0x88>
  802a67:	85 c9                	test   %ecx,%ecx
  802a69:	89 ce                	mov    %ecx,%esi
  802a6b:	75 0b                	jne    802a78 <__udivdi3+0x38>
  802a6d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a72:	31 d2                	xor    %edx,%edx
  802a74:	f7 f1                	div    %ecx
  802a76:	89 c6                	mov    %eax,%esi
  802a78:	31 d2                	xor    %edx,%edx
  802a7a:	89 e8                	mov    %ebp,%eax
  802a7c:	f7 f6                	div    %esi
  802a7e:	89 c5                	mov    %eax,%ebp
  802a80:	89 f8                	mov    %edi,%eax
  802a82:	f7 f6                	div    %esi
  802a84:	89 ea                	mov    %ebp,%edx
  802a86:	83 c4 0c             	add    $0xc,%esp
  802a89:	5e                   	pop    %esi
  802a8a:	5f                   	pop    %edi
  802a8b:	5d                   	pop    %ebp
  802a8c:	c3                   	ret    
  802a8d:	8d 76 00             	lea    0x0(%esi),%esi
  802a90:	39 e8                	cmp    %ebp,%eax
  802a92:	77 24                	ja     802ab8 <__udivdi3+0x78>
  802a94:	0f bd e8             	bsr    %eax,%ebp
  802a97:	83 f5 1f             	xor    $0x1f,%ebp
  802a9a:	75 3c                	jne    802ad8 <__udivdi3+0x98>
  802a9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802aa0:	39 34 24             	cmp    %esi,(%esp)
  802aa3:	0f 86 9f 00 00 00    	jbe    802b48 <__udivdi3+0x108>
  802aa9:	39 d0                	cmp    %edx,%eax
  802aab:	0f 82 97 00 00 00    	jb     802b48 <__udivdi3+0x108>
  802ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	31 d2                	xor    %edx,%edx
  802aba:	31 c0                	xor    %eax,%eax
  802abc:	83 c4 0c             	add    $0xc,%esp
  802abf:	5e                   	pop    %esi
  802ac0:	5f                   	pop    %edi
  802ac1:	5d                   	pop    %ebp
  802ac2:	c3                   	ret    
  802ac3:	90                   	nop
  802ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	89 f8                	mov    %edi,%eax
  802aca:	f7 f1                	div    %ecx
  802acc:	31 d2                	xor    %edx,%edx
  802ace:	83 c4 0c             	add    $0xc,%esp
  802ad1:	5e                   	pop    %esi
  802ad2:	5f                   	pop    %edi
  802ad3:	5d                   	pop    %ebp
  802ad4:	c3                   	ret    
  802ad5:	8d 76 00             	lea    0x0(%esi),%esi
  802ad8:	89 e9                	mov    %ebp,%ecx
  802ada:	8b 3c 24             	mov    (%esp),%edi
  802add:	d3 e0                	shl    %cl,%eax
  802adf:	89 c6                	mov    %eax,%esi
  802ae1:	b8 20 00 00 00       	mov    $0x20,%eax
  802ae6:	29 e8                	sub    %ebp,%eax
  802ae8:	89 c1                	mov    %eax,%ecx
  802aea:	d3 ef                	shr    %cl,%edi
  802aec:	89 e9                	mov    %ebp,%ecx
  802aee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802af2:	8b 3c 24             	mov    (%esp),%edi
  802af5:	09 74 24 08          	or     %esi,0x8(%esp)
  802af9:	89 d6                	mov    %edx,%esi
  802afb:	d3 e7                	shl    %cl,%edi
  802afd:	89 c1                	mov    %eax,%ecx
  802aff:	89 3c 24             	mov    %edi,(%esp)
  802b02:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b06:	d3 ee                	shr    %cl,%esi
  802b08:	89 e9                	mov    %ebp,%ecx
  802b0a:	d3 e2                	shl    %cl,%edx
  802b0c:	89 c1                	mov    %eax,%ecx
  802b0e:	d3 ef                	shr    %cl,%edi
  802b10:	09 d7                	or     %edx,%edi
  802b12:	89 f2                	mov    %esi,%edx
  802b14:	89 f8                	mov    %edi,%eax
  802b16:	f7 74 24 08          	divl   0x8(%esp)
  802b1a:	89 d6                	mov    %edx,%esi
  802b1c:	89 c7                	mov    %eax,%edi
  802b1e:	f7 24 24             	mull   (%esp)
  802b21:	39 d6                	cmp    %edx,%esi
  802b23:	89 14 24             	mov    %edx,(%esp)
  802b26:	72 30                	jb     802b58 <__udivdi3+0x118>
  802b28:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b2c:	89 e9                	mov    %ebp,%ecx
  802b2e:	d3 e2                	shl    %cl,%edx
  802b30:	39 c2                	cmp    %eax,%edx
  802b32:	73 05                	jae    802b39 <__udivdi3+0xf9>
  802b34:	3b 34 24             	cmp    (%esp),%esi
  802b37:	74 1f                	je     802b58 <__udivdi3+0x118>
  802b39:	89 f8                	mov    %edi,%eax
  802b3b:	31 d2                	xor    %edx,%edx
  802b3d:	e9 7a ff ff ff       	jmp    802abc <__udivdi3+0x7c>
  802b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b48:	31 d2                	xor    %edx,%edx
  802b4a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b4f:	e9 68 ff ff ff       	jmp    802abc <__udivdi3+0x7c>
  802b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b58:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b5b:	31 d2                	xor    %edx,%edx
  802b5d:	83 c4 0c             	add    $0xc,%esp
  802b60:	5e                   	pop    %esi
  802b61:	5f                   	pop    %edi
  802b62:	5d                   	pop    %ebp
  802b63:	c3                   	ret    
  802b64:	66 90                	xchg   %ax,%ax
  802b66:	66 90                	xchg   %ax,%ax
  802b68:	66 90                	xchg   %ax,%ax
  802b6a:	66 90                	xchg   %ax,%ax
  802b6c:	66 90                	xchg   %ax,%ax
  802b6e:	66 90                	xchg   %ax,%ax

00802b70 <__umoddi3>:
  802b70:	55                   	push   %ebp
  802b71:	57                   	push   %edi
  802b72:	56                   	push   %esi
  802b73:	83 ec 14             	sub    $0x14,%esp
  802b76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b7a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b7e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802b82:	89 c7                	mov    %eax,%edi
  802b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b88:	8b 44 24 30          	mov    0x30(%esp),%eax
  802b8c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b90:	89 34 24             	mov    %esi,(%esp)
  802b93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b97:	85 c0                	test   %eax,%eax
  802b99:	89 c2                	mov    %eax,%edx
  802b9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b9f:	75 17                	jne    802bb8 <__umoddi3+0x48>
  802ba1:	39 fe                	cmp    %edi,%esi
  802ba3:	76 4b                	jbe    802bf0 <__umoddi3+0x80>
  802ba5:	89 c8                	mov    %ecx,%eax
  802ba7:	89 fa                	mov    %edi,%edx
  802ba9:	f7 f6                	div    %esi
  802bab:	89 d0                	mov    %edx,%eax
  802bad:	31 d2                	xor    %edx,%edx
  802baf:	83 c4 14             	add    $0x14,%esp
  802bb2:	5e                   	pop    %esi
  802bb3:	5f                   	pop    %edi
  802bb4:	5d                   	pop    %ebp
  802bb5:	c3                   	ret    
  802bb6:	66 90                	xchg   %ax,%ax
  802bb8:	39 f8                	cmp    %edi,%eax
  802bba:	77 54                	ja     802c10 <__umoddi3+0xa0>
  802bbc:	0f bd e8             	bsr    %eax,%ebp
  802bbf:	83 f5 1f             	xor    $0x1f,%ebp
  802bc2:	75 5c                	jne    802c20 <__umoddi3+0xb0>
  802bc4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802bc8:	39 3c 24             	cmp    %edi,(%esp)
  802bcb:	0f 87 e7 00 00 00    	ja     802cb8 <__umoddi3+0x148>
  802bd1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802bd5:	29 f1                	sub    %esi,%ecx
  802bd7:	19 c7                	sbb    %eax,%edi
  802bd9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802be1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802be5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802be9:	83 c4 14             	add    $0x14,%esp
  802bec:	5e                   	pop    %esi
  802bed:	5f                   	pop    %edi
  802bee:	5d                   	pop    %ebp
  802bef:	c3                   	ret    
  802bf0:	85 f6                	test   %esi,%esi
  802bf2:	89 f5                	mov    %esi,%ebp
  802bf4:	75 0b                	jne    802c01 <__umoddi3+0x91>
  802bf6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bfb:	31 d2                	xor    %edx,%edx
  802bfd:	f7 f6                	div    %esi
  802bff:	89 c5                	mov    %eax,%ebp
  802c01:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c05:	31 d2                	xor    %edx,%edx
  802c07:	f7 f5                	div    %ebp
  802c09:	89 c8                	mov    %ecx,%eax
  802c0b:	f7 f5                	div    %ebp
  802c0d:	eb 9c                	jmp    802bab <__umoddi3+0x3b>
  802c0f:	90                   	nop
  802c10:	89 c8                	mov    %ecx,%eax
  802c12:	89 fa                	mov    %edi,%edx
  802c14:	83 c4 14             	add    $0x14,%esp
  802c17:	5e                   	pop    %esi
  802c18:	5f                   	pop    %edi
  802c19:	5d                   	pop    %ebp
  802c1a:	c3                   	ret    
  802c1b:	90                   	nop
  802c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c20:	8b 04 24             	mov    (%esp),%eax
  802c23:	be 20 00 00 00       	mov    $0x20,%esi
  802c28:	89 e9                	mov    %ebp,%ecx
  802c2a:	29 ee                	sub    %ebp,%esi
  802c2c:	d3 e2                	shl    %cl,%edx
  802c2e:	89 f1                	mov    %esi,%ecx
  802c30:	d3 e8                	shr    %cl,%eax
  802c32:	89 e9                	mov    %ebp,%ecx
  802c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c38:	8b 04 24             	mov    (%esp),%eax
  802c3b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c3f:	89 fa                	mov    %edi,%edx
  802c41:	d3 e0                	shl    %cl,%eax
  802c43:	89 f1                	mov    %esi,%ecx
  802c45:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c49:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c4d:	d3 ea                	shr    %cl,%edx
  802c4f:	89 e9                	mov    %ebp,%ecx
  802c51:	d3 e7                	shl    %cl,%edi
  802c53:	89 f1                	mov    %esi,%ecx
  802c55:	d3 e8                	shr    %cl,%eax
  802c57:	89 e9                	mov    %ebp,%ecx
  802c59:	09 f8                	or     %edi,%eax
  802c5b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c5f:	f7 74 24 04          	divl   0x4(%esp)
  802c63:	d3 e7                	shl    %cl,%edi
  802c65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c69:	89 d7                	mov    %edx,%edi
  802c6b:	f7 64 24 08          	mull   0x8(%esp)
  802c6f:	39 d7                	cmp    %edx,%edi
  802c71:	89 c1                	mov    %eax,%ecx
  802c73:	89 14 24             	mov    %edx,(%esp)
  802c76:	72 2c                	jb     802ca4 <__umoddi3+0x134>
  802c78:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c7c:	72 22                	jb     802ca0 <__umoddi3+0x130>
  802c7e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802c82:	29 c8                	sub    %ecx,%eax
  802c84:	19 d7                	sbb    %edx,%edi
  802c86:	89 e9                	mov    %ebp,%ecx
  802c88:	89 fa                	mov    %edi,%edx
  802c8a:	d3 e8                	shr    %cl,%eax
  802c8c:	89 f1                	mov    %esi,%ecx
  802c8e:	d3 e2                	shl    %cl,%edx
  802c90:	89 e9                	mov    %ebp,%ecx
  802c92:	d3 ef                	shr    %cl,%edi
  802c94:	09 d0                	or     %edx,%eax
  802c96:	89 fa                	mov    %edi,%edx
  802c98:	83 c4 14             	add    $0x14,%esp
  802c9b:	5e                   	pop    %esi
  802c9c:	5f                   	pop    %edi
  802c9d:	5d                   	pop    %ebp
  802c9e:	c3                   	ret    
  802c9f:	90                   	nop
  802ca0:	39 d7                	cmp    %edx,%edi
  802ca2:	75 da                	jne    802c7e <__umoddi3+0x10e>
  802ca4:	8b 14 24             	mov    (%esp),%edx
  802ca7:	89 c1                	mov    %eax,%ecx
  802ca9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802cad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802cb1:	eb cb                	jmp    802c7e <__umoddi3+0x10e>
  802cb3:	90                   	nop
  802cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cb8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802cbc:	0f 82 0f ff ff ff    	jb     802bd1 <__umoddi3+0x61>
  802cc2:	e9 1a ff ff ff       	jmp    802be1 <__umoddi3+0x71>
