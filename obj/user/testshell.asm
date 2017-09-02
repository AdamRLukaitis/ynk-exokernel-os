
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 15 05 00 00       	call   800546 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004c:	89 34 24             	mov    %esi,(%esp)
  80004f:	e8 a0 1b 00 00       	call   801bf4 <seek>
	seek(kfd, off);
  800054:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800058:	89 3c 24             	mov    %edi,(%esp)
  80005b:	e8 94 1b 00 00       	call   801bf4 <seek>

	cprintf("shell produced incorrect output.\n");
  800060:	c7 04 24 80 33 80 00 	movl   $0x803380,(%esp)
  800067:	e8 3e 06 00 00       	call   8006aa <cprintf>
	cprintf("expected:\n===\n");
  80006c:	c7 04 24 eb 33 80 00 	movl   $0x8033eb,(%esp)
  800073:	e8 32 06 00 00       	call   8006aa <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800078:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007b:	eb 0c                	jmp    800089 <wrong+0x56>
		sys_cputs(buf, n);
  80007d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800081:	89 1c 24             	mov    %ebx,(%esp)
  800084:	e8 9d 0f 00 00       	call   801026 <sys_cputs>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800089:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  800090:	00 
  800091:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800095:	89 3c 24             	mov    %edi,(%esp)
  800098:	e8 ed 19 00 00       	call   801a8a <read>
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f dc                	jg     80007d <wrong+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000a1:	c7 04 24 fa 33 80 00 	movl   $0x8033fa,(%esp)
  8000a8:	e8 fd 05 00 00       	call   8006aa <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ad:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b0:	eb 0c                	jmp    8000be <wrong+0x8b>
		sys_cputs(buf, n);
  8000b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b6:	89 1c 24             	mov    %ebx,(%esp)
  8000b9:	e8 68 0f 00 00       	call   801026 <sys_cputs>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000be:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000c5:	00 
  8000c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000ca:	89 34 24             	mov    %esi,(%esp)
  8000cd:	e8 b8 19 00 00       	call   801a8a <read>
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	7f dc                	jg     8000b2 <wrong+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000d6:	c7 04 24 f5 33 80 00 	movl   $0x8033f5,(%esp)
  8000dd:	e8 c8 05 00 00       	call   8006aa <cprintf>
	exit();
  8000e2:	e8 b1 04 00 00       	call   800598 <exit>
}
  8000e7:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000ed:	5b                   	pop    %ebx
  8000ee:	5e                   	pop    %esi
  8000ef:	5f                   	pop    %edi
  8000f0:	5d                   	pop    %ebp
  8000f1:	c3                   	ret    

008000f2 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  8000fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800102:	e8 20 18 00 00       	call   801927 <close>
	close(1);
  800107:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010e:	e8 14 18 00 00       	call   801927 <close>
	opencons();
  800113:	e8 d3 03 00 00       	call   8004eb <opencons>
	opencons();
  800118:	e8 ce 03 00 00       	call   8004eb <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80011d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800124:	00 
  800125:	c7 04 24 08 34 80 00 	movl   $0x803408,(%esp)
  80012c:	e8 32 1e 00 00       	call   801f63 <open>
  800131:	89 c3                	mov    %eax,%ebx
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 15 34 80 	movl   $0x803415,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  800152:	e8 5a 04 00 00       	call   8005b1 <_panic>
	if ((wfd = pipe(pfds)) < 0)
  800157:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80015a:	89 04 24             	mov    %eax,(%esp)
  80015d:	e8 a2 2b 00 00       	call   802d04 <pipe>
  800162:	85 c0                	test   %eax,%eax
  800164:	79 20                	jns    800186 <umain+0x94>
		panic("pipe: %e", wfd);
  800166:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016a:	c7 44 24 08 3c 34 80 	movl   $0x80343c,0x8(%esp)
  800171:	00 
  800172:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800179:	00 
  80017a:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  800181:	e8 2b 04 00 00       	call   8005b1 <_panic>
	wfd = pfds[1];
  800186:	8b 75 e0             	mov    -0x20(%ebp),%esi

	cprintf("running sh -x < testshell.sh | cat\n");
  800189:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  800190:	e8 15 05 00 00       	call   8006aa <cprintf>
	if ((r = fork()) < 0)
  800195:	e8 8c 13 00 00       	call   801526 <fork>
  80019a:	85 c0                	test   %eax,%eax
  80019c:	79 20                	jns    8001be <umain+0xcc>
		panic("fork: %e", r);
  80019e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a2:	c7 44 24 08 45 34 80 	movl   $0x803445,0x8(%esp)
  8001a9:	00 
  8001aa:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8001b1:	00 
  8001b2:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  8001b9:	e8 f3 03 00 00       	call   8005b1 <_panic>
	if (r == 0) {
  8001be:	85 c0                	test   %eax,%eax
  8001c0:	0f 85 9f 00 00 00    	jne    800265 <umain+0x173>
		dup(rfd, 0);
  8001c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001cd:	00 
  8001ce:	89 1c 24             	mov    %ebx,(%esp)
  8001d1:	e8 a6 17 00 00       	call   80197c <dup>
		dup(wfd, 1);
  8001d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001dd:	00 
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 96 17 00 00       	call   80197c <dup>
		close(rfd);
  8001e6:	89 1c 24             	mov    %ebx,(%esp)
  8001e9:	e8 39 17 00 00       	call   801927 <close>
		close(wfd);
  8001ee:	89 34 24             	mov    %esi,(%esp)
  8001f1:	e8 31 17 00 00       	call   801927 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  8001f6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001fd:	00 
  8001fe:	c7 44 24 08 4e 34 80 	movl   $0x80344e,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 12 34 80 	movl   $0x803412,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 51 34 80 00 	movl   $0x803451,(%esp)
  800215:	e8 8e 23 00 00       	call   8025a8 <spawnl>
  80021a:	89 c7                	mov    %eax,%edi
  80021c:	85 c0                	test   %eax,%eax
  80021e:	79 20                	jns    800240 <umain+0x14e>
			panic("spawn: %e", r);
  800220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800224:	c7 44 24 08 55 34 80 	movl   $0x803455,0x8(%esp)
  80022b:	00 
  80022c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800233:	00 
  800234:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  80023b:	e8 71 03 00 00       	call   8005b1 <_panic>
		close(0);
  800240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800247:	e8 db 16 00 00       	call   801927 <close>
		close(1);
  80024c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800253:	e8 cf 16 00 00       	call   801927 <close>
		wait(r);
  800258:	89 3c 24             	mov    %edi,(%esp)
  80025b:	e8 4a 2c 00 00       	call   802eaa <wait>
		exit();
  800260:	e8 33 03 00 00       	call   800598 <exit>
	}
	close(rfd);
  800265:	89 1c 24             	mov    %ebx,(%esp)
  800268:	e8 ba 16 00 00       	call   801927 <close>
	close(wfd);
  80026d:	89 34 24             	mov    %esi,(%esp)
  800270:	e8 b2 16 00 00       	call   801927 <close>

	rfd = pfds[0];
  800275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800278:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  80027b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800282:	00 
  800283:	c7 04 24 5f 34 80 00 	movl   $0x80345f,(%esp)
  80028a:	e8 d4 1c 00 00       	call   801f63 <open>
  80028f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800292:	85 c0                	test   %eax,%eax
  800294:	79 20                	jns    8002b6 <umain+0x1c4>
		panic("open testshell.key for reading: %e", kfd);
  800296:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029a:	c7 44 24 08 c8 33 80 	movl   $0x8033c8,0x8(%esp)
  8002a1:	00 
  8002a2:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002a9:	00 
  8002aa:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  8002b1:	e8 fb 02 00 00       	call   8005b1 <_panic>
	}
	close(rfd);
	close(wfd);

	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002b6:	be 01 00 00 00       	mov    $0x1,%esi
  8002bb:	bf 00 00 00 00       	mov    $0x0,%edi
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  8002c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002c7:	00 
  8002c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d2:	89 04 24             	mov    %eax,(%esp)
  8002d5:	e8 b0 17 00 00       	call   801a8a <read>
  8002da:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002e3:	00 
  8002e4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	e8 94 17 00 00       	call   801a8a <read>
		if (n1 < 0)
  8002f6:	85 db                	test   %ebx,%ebx
  8002f8:	79 20                	jns    80031a <umain+0x228>
			panic("reading testshell.out: %e", n1);
  8002fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002fe:	c7 44 24 08 6d 34 80 	movl   $0x80346d,0x8(%esp)
  800305:	00 
  800306:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80030d:	00 
  80030e:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  800315:	e8 97 02 00 00       	call   8005b1 <_panic>
		if (n2 < 0)
  80031a:	85 c0                	test   %eax,%eax
  80031c:	79 20                	jns    80033e <umain+0x24c>
			panic("reading testshell.key: %e", n2);
  80031e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800322:	c7 44 24 08 87 34 80 	movl   $0x803487,0x8(%esp)
  800329:	00 
  80032a:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800331:	00 
  800332:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  800339:	e8 73 02 00 00       	call   8005b1 <_panic>
		if (n1 == 0 && n2 == 0)
  80033e:	89 c2                	mov    %eax,%edx
  800340:	09 da                	or     %ebx,%edx
  800342:	74 38                	je     80037c <umain+0x28a>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800344:	83 fb 01             	cmp    $0x1,%ebx
  800347:	75 0e                	jne    800357 <umain+0x265>
  800349:	83 f8 01             	cmp    $0x1,%eax
  80034c:	75 09                	jne    800357 <umain+0x265>
  80034e:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  800352:	38 45 e7             	cmp    %al,-0x19(%ebp)
  800355:	74 16                	je     80036d <umain+0x27b>
			wrong(rfd, kfd, nloff);
  800357:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80035b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800362:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800365:	89 04 24             	mov    %eax,(%esp)
  800368:	e8 c6 fc ff ff       	call   800033 <wrong>
		if (c1 == '\n')
			nloff = off+1;
  80036d:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  800371:	0f 44 fe             	cmove  %esi,%edi
  800374:	83 c6 01             	add    $0x1,%esi
	}
  800377:	e9 44 ff ff ff       	jmp    8002c0 <umain+0x1ce>
	cprintf("shell ran correctly\n");
  80037c:	c7 04 24 a1 34 80 00 	movl   $0x8034a1,(%esp)
  800383:	e8 22 03 00 00       	call   8006aa <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800388:	cc                   	int3   

	breakpoint();
}
  800389:	83 c4 3c             	add    $0x3c,%esp
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    
  800391:	66 90                	xchg   %ax,%ax
  800393:	66 90                	xchg   %ax,%ax
  800395:	66 90                	xchg   %ax,%ax
  800397:	66 90                	xchg   %ax,%ax
  800399:	66 90                	xchg   %ax,%ax
  80039b:	66 90                	xchg   %ax,%ax
  80039d:	66 90                	xchg   %ax,%ax
  80039f:	90                   	nop

008003a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8003b0:	c7 44 24 04 b6 34 80 	movl   $0x8034b6,0x4(%esp)
  8003b7:	00 
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	89 04 24             	mov    %eax,(%esp)
  8003be:	e8 14 09 00 00       	call   800cd7 <strcpy>
	return 0;
}
  8003c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	57                   	push   %edi
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
  8003d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003e1:	eb 31                	jmp    800414 <devcons_write+0x4a>
		m = n - tot;
  8003e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8003e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8003e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8003eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8003f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003f7:	03 45 0c             	add    0xc(%ebp),%eax
  8003fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fe:	89 3c 24             	mov    %edi,(%esp)
  800401:	e8 6e 0a 00 00       	call   800e74 <memmove>
		sys_cputs(buf, m);
  800406:	89 74 24 04          	mov    %esi,0x4(%esp)
  80040a:	89 3c 24             	mov    %edi,(%esp)
  80040d:	e8 14 0c 00 00       	call   801026 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800412:	01 f3                	add    %esi,%ebx
  800414:	89 d8                	mov    %ebx,%eax
  800416:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800419:	72 c8                	jb     8003e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80041b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800421:	5b                   	pop    %ebx
  800422:	5e                   	pop    %esi
  800423:	5f                   	pop    %edi
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80042c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  800431:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800435:	75 07                	jne    80043e <devcons_read+0x18>
  800437:	eb 2a                	jmp    800463 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800439:	e8 96 0c 00 00       	call   8010d4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80043e:	66 90                	xchg   %ax,%ax
  800440:	e8 ff 0b 00 00       	call   801044 <sys_cgetc>
  800445:	85 c0                	test   %eax,%eax
  800447:	74 f0                	je     800439 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800449:	85 c0                	test   %eax,%eax
  80044b:	78 16                	js     800463 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80044d:	83 f8 04             	cmp    $0x4,%eax
  800450:	74 0c                	je     80045e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	88 02                	mov    %al,(%edx)
	return 1;
  800457:	b8 01 00 00 00       	mov    $0x1,%eax
  80045c:	eb 05                	jmp    800463 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80045e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800471:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800478:	00 
  800479:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80047c:	89 04 24             	mov    %eax,(%esp)
  80047f:	e8 a2 0b 00 00       	call   801026 <sys_cputs>
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <getchar>:

int
getchar(void)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80048c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800493:	00 
  800494:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004a2:	e8 e3 15 00 00       	call   801a8a <read>
	if (r < 0)
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	78 0f                	js     8004ba <getchar+0x34>
		return r;
	if (r < 1)
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	7e 06                	jle    8004b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8004af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8004b3:	eb 05                	jmp    8004ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8004b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	89 04 24             	mov    %eax,(%esp)
  8004cf:	e8 22 13 00 00       	call   8017f6 <fd_lookup>
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	78 11                	js     8004e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8004d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004db:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8004e1:	39 10                	cmp    %edx,(%eax)
  8004e3:	0f 94 c0             	sete   %al
  8004e6:	0f b6 c0             	movzbl %al,%eax
}
  8004e9:	c9                   	leave  
  8004ea:	c3                   	ret    

008004eb <opencons>:

int
opencons(void)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004f4:	89 04 24             	mov    %eax,(%esp)
  8004f7:	e8 ab 12 00 00       	call   8017a7 <fd_alloc>
		return r;
  8004fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004fe:	85 c0                	test   %eax,%eax
  800500:	78 40                	js     800542 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800502:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800509:	00 
  80050a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800518:	e8 d6 0b 00 00       	call   8010f3 <sys_page_alloc>
		return r;
  80051d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80051f:	85 c0                	test   %eax,%eax
  800521:	78 1f                	js     800542 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800523:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80052e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800531:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	e8 40 12 00 00       	call   801780 <fd2num>
  800540:	89 c2                	mov    %eax,%edx
}
  800542:	89 d0                	mov    %edx,%eax
  800544:	c9                   	leave  
  800545:	c3                   	ret    

00800546 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	56                   	push   %esi
  80054a:	53                   	push   %ebx
  80054b:	83 ec 10             	sub    $0x10,%esp
  80054e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800551:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800554:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80055b:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  80055e:	e8 52 0b 00 00       	call   8010b5 <sys_getenvid>
  800563:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800568:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80056b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800570:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800575:	85 db                	test   %ebx,%ebx
  800577:	7e 07                	jle    800580 <libmain+0x3a>
		binaryname = argv[0];
  800579:	8b 06                	mov    (%esi),%eax
  80057b:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800580:	89 74 24 04          	mov    %esi,0x4(%esp)
  800584:	89 1c 24             	mov    %ebx,(%esp)
  800587:	e8 66 fb ff ff       	call   8000f2 <umain>

	// exit gracefully
	exit();
  80058c:	e8 07 00 00 00       	call   800598 <exit>
}
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	5b                   	pop    %ebx
  800595:	5e                   	pop    %esi
  800596:	5d                   	pop    %ebp
  800597:	c3                   	ret    

00800598 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80059e:	e8 b7 13 00 00       	call   80195a <close_all>
	sys_env_destroy(0);
  8005a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005aa:	e8 b4 0a 00 00       	call   801063 <sys_env_destroy>
}
  8005af:	c9                   	leave  
  8005b0:	c3                   	ret    

008005b1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005b1:	55                   	push   %ebp
  8005b2:	89 e5                	mov    %esp,%ebp
  8005b4:	56                   	push   %esi
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8005b9:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005bc:	8b 35 1c 40 80 00    	mov    0x80401c,%esi
  8005c2:	e8 ee 0a 00 00       	call   8010b5 <sys_getenvid>
  8005c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ca:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8005d1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005d5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8005d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005dd:	c7 04 24 cc 34 80 00 	movl   $0x8034cc,(%esp)
  8005e4:	e8 c1 00 00 00       	call   8006aa <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f0:	89 04 24             	mov    %eax,(%esp)
  8005f3:	e8 51 00 00 00       	call   800649 <vcprintf>
	cprintf("\n");
  8005f8:	c7 04 24 f8 33 80 00 	movl   $0x8033f8,(%esp)
  8005ff:	e8 a6 00 00 00       	call   8006aa <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800604:	cc                   	int3   
  800605:	eb fd                	jmp    800604 <_panic+0x53>

00800607 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	53                   	push   %ebx
  80060b:	83 ec 14             	sub    $0x14,%esp
  80060e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800611:	8b 13                	mov    (%ebx),%edx
  800613:	8d 42 01             	lea    0x1(%edx),%eax
  800616:	89 03                	mov    %eax,(%ebx)
  800618:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80061b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80061f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800624:	75 19                	jne    80063f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800626:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80062d:	00 
  80062e:	8d 43 08             	lea    0x8(%ebx),%eax
  800631:	89 04 24             	mov    %eax,(%esp)
  800634:	e8 ed 09 00 00       	call   801026 <sys_cputs>
		b->idx = 0;
  800639:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80063f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800643:	83 c4 14             	add    $0x14,%esp
  800646:	5b                   	pop    %ebx
  800647:	5d                   	pop    %ebp
  800648:	c3                   	ret    

00800649 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800649:	55                   	push   %ebp
  80064a:	89 e5                	mov    %esp,%ebp
  80064c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800652:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800659:	00 00 00 
	b.cnt = 0;
  80065c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800663:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800666:	8b 45 0c             	mov    0xc(%ebp),%eax
  800669:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80066d:	8b 45 08             	mov    0x8(%ebp),%eax
  800670:	89 44 24 08          	mov    %eax,0x8(%esp)
  800674:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80067a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80067e:	c7 04 24 07 06 80 00 	movl   $0x800607,(%esp)
  800685:	e8 b4 01 00 00       	call   80083e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80068a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800690:	89 44 24 04          	mov    %eax,0x4(%esp)
  800694:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80069a:	89 04 24             	mov    %eax,(%esp)
  80069d:	e8 84 09 00 00       	call   801026 <sys_cputs>

	return b.cnt;
}
  8006a2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006a8:	c9                   	leave  
  8006a9:	c3                   	ret    

008006aa <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006aa:	55                   	push   %ebp
  8006ab:	89 e5                	mov    %esp,%ebp
  8006ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006b0:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	89 04 24             	mov    %eax,(%esp)
  8006bd:	e8 87 ff ff ff       	call   800649 <vcprintf>
	va_end(ap);

	return cnt;
}
  8006c2:	c9                   	leave  
  8006c3:	c3                   	ret    
  8006c4:	66 90                	xchg   %ax,%ax
  8006c6:	66 90                	xchg   %ax,%ax
  8006c8:	66 90                	xchg   %ax,%ax
  8006ca:	66 90                	xchg   %ax,%ax
  8006cc:	66 90                	xchg   %ax,%ax
  8006ce:	66 90                	xchg   %ax,%ax

008006d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006d0:	55                   	push   %ebp
  8006d1:	89 e5                	mov    %esp,%ebp
  8006d3:	57                   	push   %edi
  8006d4:	56                   	push   %esi
  8006d5:	53                   	push   %ebx
  8006d6:	83 ec 3c             	sub    $0x3c,%esp
  8006d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006dc:	89 d7                	mov    %edx,%edi
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e7:	89 c3                	mov    %eax,%ebx
  8006e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006fd:	39 d9                	cmp    %ebx,%ecx
  8006ff:	72 05                	jb     800706 <printnum+0x36>
  800701:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800704:	77 69                	ja     80076f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800706:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800709:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80070d:	83 ee 01             	sub    $0x1,%esi
  800710:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800714:	89 44 24 08          	mov    %eax,0x8(%esp)
  800718:	8b 44 24 08          	mov    0x8(%esp),%eax
  80071c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800720:	89 c3                	mov    %eax,%ebx
  800722:	89 d6                	mov    %edx,%esi
  800724:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800727:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80072a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80072e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800732:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800735:	89 04 24             	mov    %eax,(%esp)
  800738:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80073b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80073f:	e8 9c 29 00 00       	call   8030e0 <__udivdi3>
  800744:	89 d9                	mov    %ebx,%ecx
  800746:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80074a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80074e:	89 04 24             	mov    %eax,(%esp)
  800751:	89 54 24 04          	mov    %edx,0x4(%esp)
  800755:	89 fa                	mov    %edi,%edx
  800757:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80075a:	e8 71 ff ff ff       	call   8006d0 <printnum>
  80075f:	eb 1b                	jmp    80077c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800761:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800765:	8b 45 18             	mov    0x18(%ebp),%eax
  800768:	89 04 24             	mov    %eax,(%esp)
  80076b:	ff d3                	call   *%ebx
  80076d:	eb 03                	jmp    800772 <printnum+0xa2>
  80076f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800772:	83 ee 01             	sub    $0x1,%esi
  800775:	85 f6                	test   %esi,%esi
  800777:	7f e8                	jg     800761 <printnum+0x91>
  800779:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80077c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800780:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800784:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800787:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80078a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80078e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800792:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800795:	89 04 24             	mov    %eax,(%esp)
  800798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80079b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079f:	e8 6c 2a 00 00       	call   803210 <__umoddi3>
  8007a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a8:	0f be 80 ef 34 80 00 	movsbl 0x8034ef(%eax),%eax
  8007af:	89 04 24             	mov    %eax,(%esp)
  8007b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b5:	ff d0                	call   *%eax
}
  8007b7:	83 c4 3c             	add    $0x3c,%esp
  8007ba:	5b                   	pop    %ebx
  8007bb:	5e                   	pop    %esi
  8007bc:	5f                   	pop    %edi
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c2:	83 fa 01             	cmp    $0x1,%edx
  8007c5:	7e 0e                	jle    8007d5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007c7:	8b 10                	mov    (%eax),%edx
  8007c9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007cc:	89 08                	mov    %ecx,(%eax)
  8007ce:	8b 02                	mov    (%edx),%eax
  8007d0:	8b 52 04             	mov    0x4(%edx),%edx
  8007d3:	eb 22                	jmp    8007f7 <getuint+0x38>
	else if (lflag)
  8007d5:	85 d2                	test   %edx,%edx
  8007d7:	74 10                	je     8007e9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007d9:	8b 10                	mov    (%eax),%edx
  8007db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007de:	89 08                	mov    %ecx,(%eax)
  8007e0:	8b 02                	mov    (%edx),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	eb 0e                	jmp    8007f7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007e9:	8b 10                	mov    (%eax),%edx
  8007eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007ee:	89 08                	mov    %ecx,(%eax)
  8007f0:	8b 02                	mov    (%edx),%eax
  8007f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    

008007f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800803:	8b 10                	mov    (%eax),%edx
  800805:	3b 50 04             	cmp    0x4(%eax),%edx
  800808:	73 0a                	jae    800814 <sprintputch+0x1b>
		*b->buf++ = ch;
  80080a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80080d:	89 08                	mov    %ecx,(%eax)
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	88 02                	mov    %al,(%edx)
}
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80081c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80081f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800823:	8b 45 10             	mov    0x10(%ebp),%eax
  800826:	89 44 24 08          	mov    %eax,0x8(%esp)
  80082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80082d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 04 24             	mov    %eax,(%esp)
  800837:	e8 02 00 00 00       	call   80083e <vprintfmt>
	va_end(ap);
}
  80083c:	c9                   	leave  
  80083d:	c3                   	ret    

0080083e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	57                   	push   %edi
  800842:	56                   	push   %esi
  800843:	53                   	push   %ebx
  800844:	83 ec 3c             	sub    $0x3c,%esp
  800847:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80084a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80084d:	eb 14                	jmp    800863 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80084f:	85 c0                	test   %eax,%eax
  800851:	0f 84 b3 03 00 00    	je     800c0a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800857:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80085b:	89 04 24             	mov    %eax,(%esp)
  80085e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800861:	89 f3                	mov    %esi,%ebx
  800863:	8d 73 01             	lea    0x1(%ebx),%esi
  800866:	0f b6 03             	movzbl (%ebx),%eax
  800869:	83 f8 25             	cmp    $0x25,%eax
  80086c:	75 e1                	jne    80084f <vprintfmt+0x11>
  80086e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800872:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800879:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800880:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800887:	ba 00 00 00 00       	mov    $0x0,%edx
  80088c:	eb 1d                	jmp    8008ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80088e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800890:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800894:	eb 15                	jmp    8008ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800896:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800898:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80089c:	eb 0d                	jmp    8008ab <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80089e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008a4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ab:	8d 5e 01             	lea    0x1(%esi),%ebx
  8008ae:	0f b6 0e             	movzbl (%esi),%ecx
  8008b1:	0f b6 c1             	movzbl %cl,%eax
  8008b4:	83 e9 23             	sub    $0x23,%ecx
  8008b7:	80 f9 55             	cmp    $0x55,%cl
  8008ba:	0f 87 2a 03 00 00    	ja     800bea <vprintfmt+0x3ac>
  8008c0:	0f b6 c9             	movzbl %cl,%ecx
  8008c3:	ff 24 8d 40 36 80 00 	jmp    *0x803640(,%ecx,4)
  8008ca:	89 de                	mov    %ebx,%esi
  8008cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008d1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8008d4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8008d8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8008db:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8008de:	83 fb 09             	cmp    $0x9,%ebx
  8008e1:	77 36                	ja     800919 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008e6:	eb e9                	jmp    8008d1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	8d 48 04             	lea    0x4(%eax),%ecx
  8008ee:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008f1:	8b 00                	mov    (%eax),%eax
  8008f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008f6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8008f8:	eb 22                	jmp    80091c <vprintfmt+0xde>
  8008fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8008fd:	85 c9                	test   %ecx,%ecx
  8008ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800904:	0f 49 c1             	cmovns %ecx,%eax
  800907:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80090a:	89 de                	mov    %ebx,%esi
  80090c:	eb 9d                	jmp    8008ab <vprintfmt+0x6d>
  80090e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800910:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800917:	eb 92                	jmp    8008ab <vprintfmt+0x6d>
  800919:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80091c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800920:	79 89                	jns    8008ab <vprintfmt+0x6d>
  800922:	e9 77 ff ff ff       	jmp    80089e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800927:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80092a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80092c:	e9 7a ff ff ff       	jmp    8008ab <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	89 55 14             	mov    %edx,0x14(%ebp)
  80093a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80093e:	8b 00                	mov    (%eax),%eax
  800940:	89 04 24             	mov    %eax,(%esp)
  800943:	ff 55 08             	call   *0x8(%ebp)
			break;
  800946:	e9 18 ff ff ff       	jmp    800863 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80094b:	8b 45 14             	mov    0x14(%ebp),%eax
  80094e:	8d 50 04             	lea    0x4(%eax),%edx
  800951:	89 55 14             	mov    %edx,0x14(%ebp)
  800954:	8b 00                	mov    (%eax),%eax
  800956:	99                   	cltd   
  800957:	31 d0                	xor    %edx,%eax
  800959:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80095b:	83 f8 0f             	cmp    $0xf,%eax
  80095e:	7f 0b                	jg     80096b <vprintfmt+0x12d>
  800960:	8b 14 85 a0 37 80 00 	mov    0x8037a0(,%eax,4),%edx
  800967:	85 d2                	test   %edx,%edx
  800969:	75 20                	jne    80098b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80096b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80096f:	c7 44 24 08 07 35 80 	movl   $0x803507,0x8(%esp)
  800976:	00 
  800977:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	89 04 24             	mov    %eax,(%esp)
  800981:	e8 90 fe ff ff       	call   800816 <printfmt>
  800986:	e9 d8 fe ff ff       	jmp    800863 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80098b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80098f:	c7 44 24 08 65 3a 80 	movl   $0x803a65,0x8(%esp)
  800996:	00 
  800997:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	89 04 24             	mov    %eax,(%esp)
  8009a1:	e8 70 fe ff ff       	call   800816 <printfmt>
  8009a6:	e9 b8 fe ff ff       	jmp    800863 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ab:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8009ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b7:	8d 50 04             	lea    0x4(%eax),%edx
  8009ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8009bd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8009bf:	85 f6                	test   %esi,%esi
  8009c1:	b8 00 35 80 00       	mov    $0x803500,%eax
  8009c6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8009c9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8009cd:	0f 84 97 00 00 00    	je     800a6a <vprintfmt+0x22c>
  8009d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8009d7:	0f 8e 9b 00 00 00    	jle    800a78 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009e1:	89 34 24             	mov    %esi,(%esp)
  8009e4:	e8 cf 02 00 00       	call   800cb8 <strnlen>
  8009e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8009ec:	29 c2                	sub    %eax,%edx
  8009ee:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8009f1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8009f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009f8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8009fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a01:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a03:	eb 0f                	jmp    800a14 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800a05:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a09:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0c:	89 04 24             	mov    %eax,(%esp)
  800a0f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a11:	83 eb 01             	sub    $0x1,%ebx
  800a14:	85 db                	test   %ebx,%ebx
  800a16:	7f ed                	jg     800a05 <vprintfmt+0x1c7>
  800a18:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800a1b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a1e:	85 d2                	test   %edx,%edx
  800a20:	b8 00 00 00 00       	mov    $0x0,%eax
  800a25:	0f 49 c2             	cmovns %edx,%eax
  800a28:	29 c2                	sub    %eax,%edx
  800a2a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a2d:	89 d7                	mov    %edx,%edi
  800a2f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a32:	eb 50                	jmp    800a84 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a38:	74 1e                	je     800a58 <vprintfmt+0x21a>
  800a3a:	0f be d2             	movsbl %dl,%edx
  800a3d:	83 ea 20             	sub    $0x20,%edx
  800a40:	83 fa 5e             	cmp    $0x5e,%edx
  800a43:	76 13                	jbe    800a58 <vprintfmt+0x21a>
					putch('?', putdat);
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a4c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a53:	ff 55 08             	call   *0x8(%ebp)
  800a56:	eb 0d                	jmp    800a65 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a5f:	89 04 24             	mov    %eax,(%esp)
  800a62:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a65:	83 ef 01             	sub    $0x1,%edi
  800a68:	eb 1a                	jmp    800a84 <vprintfmt+0x246>
  800a6a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a6d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800a70:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a73:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a76:	eb 0c                	jmp    800a84 <vprintfmt+0x246>
  800a78:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a7b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800a7e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a81:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a84:	83 c6 01             	add    $0x1,%esi
  800a87:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800a8b:	0f be c2             	movsbl %dl,%eax
  800a8e:	85 c0                	test   %eax,%eax
  800a90:	74 27                	je     800ab9 <vprintfmt+0x27b>
  800a92:	85 db                	test   %ebx,%ebx
  800a94:	78 9e                	js     800a34 <vprintfmt+0x1f6>
  800a96:	83 eb 01             	sub    $0x1,%ebx
  800a99:	79 99                	jns    800a34 <vprintfmt+0x1f6>
  800a9b:	89 f8                	mov    %edi,%eax
  800a9d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800aa0:	8b 75 08             	mov    0x8(%ebp),%esi
  800aa3:	89 c3                	mov    %eax,%ebx
  800aa5:	eb 1a                	jmp    800ac1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800aa7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aab:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800ab2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab4:	83 eb 01             	sub    $0x1,%ebx
  800ab7:	eb 08                	jmp    800ac1 <vprintfmt+0x283>
  800ab9:	89 fb                	mov    %edi,%ebx
  800abb:	8b 75 08             	mov    0x8(%ebp),%esi
  800abe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ac1:	85 db                	test   %ebx,%ebx
  800ac3:	7f e2                	jg     800aa7 <vprintfmt+0x269>
  800ac5:	89 75 08             	mov    %esi,0x8(%ebp)
  800ac8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800acb:	e9 93 fd ff ff       	jmp    800863 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ad0:	83 fa 01             	cmp    $0x1,%edx
  800ad3:	7e 16                	jle    800aeb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800ad5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad8:	8d 50 08             	lea    0x8(%eax),%edx
  800adb:	89 55 14             	mov    %edx,0x14(%ebp)
  800ade:	8b 50 04             	mov    0x4(%eax),%edx
  800ae1:	8b 00                	mov    (%eax),%eax
  800ae3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ae6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ae9:	eb 32                	jmp    800b1d <vprintfmt+0x2df>
	else if (lflag)
  800aeb:	85 d2                	test   %edx,%edx
  800aed:	74 18                	je     800b07 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	8d 50 04             	lea    0x4(%eax),%edx
  800af5:	89 55 14             	mov    %edx,0x14(%ebp)
  800af8:	8b 30                	mov    (%eax),%esi
  800afa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800afd:	89 f0                	mov    %esi,%eax
  800aff:	c1 f8 1f             	sar    $0x1f,%eax
  800b02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b05:	eb 16                	jmp    800b1d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800b07:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0a:	8d 50 04             	lea    0x4(%eax),%edx
  800b0d:	89 55 14             	mov    %edx,0x14(%ebp)
  800b10:	8b 30                	mov    (%eax),%esi
  800b12:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b15:	89 f0                	mov    %esi,%eax
  800b17:	c1 f8 1f             	sar    $0x1f,%eax
  800b1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b23:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2c:	0f 89 80 00 00 00    	jns    800bb2 <vprintfmt+0x374>
				putch('-', putdat);
  800b32:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b36:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b3d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b46:	f7 d8                	neg    %eax
  800b48:	83 d2 00             	adc    $0x0,%edx
  800b4b:	f7 da                	neg    %edx
			}
			base = 10;
  800b4d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800b52:	eb 5e                	jmp    800bb2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b54:	8d 45 14             	lea    0x14(%ebp),%eax
  800b57:	e8 63 fc ff ff       	call   8007bf <getuint>
			base = 10;
  800b5c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800b61:	eb 4f                	jmp    800bb2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800b63:	8d 45 14             	lea    0x14(%ebp),%eax
  800b66:	e8 54 fc ff ff       	call   8007bf <getuint>
			base =8;
  800b6b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800b70:	eb 40                	jmp    800bb2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800b72:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b76:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b7d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800b80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b84:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b8b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b91:	8d 50 04             	lea    0x4(%eax),%edx
  800b94:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b97:	8b 00                	mov    (%eax),%eax
  800b99:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b9e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800ba3:	eb 0d                	jmp    800bb2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba8:	e8 12 fc ff ff       	call   8007bf <getuint>
			base = 16;
  800bad:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bb2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800bb6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800bba:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800bbd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bc1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800bc5:	89 04 24             	mov    %eax,(%esp)
  800bc8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bcc:	89 fa                	mov    %edi,%edx
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	e8 fa fa ff ff       	call   8006d0 <printnum>
			break;
  800bd6:	e9 88 fc ff ff       	jmp    800863 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bdb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bdf:	89 04 24             	mov    %eax,(%esp)
  800be2:	ff 55 08             	call   *0x8(%ebp)
			break;
  800be5:	e9 79 fc ff ff       	jmp    800863 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bee:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800bf5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bf8:	89 f3                	mov    %esi,%ebx
  800bfa:	eb 03                	jmp    800bff <vprintfmt+0x3c1>
  800bfc:	83 eb 01             	sub    $0x1,%ebx
  800bff:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800c03:	75 f7                	jne    800bfc <vprintfmt+0x3be>
  800c05:	e9 59 fc ff ff       	jmp    800863 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800c0a:	83 c4 3c             	add    $0x3c,%esp
  800c0d:	5b                   	pop    %ebx
  800c0e:	5e                   	pop    %esi
  800c0f:	5f                   	pop    %edi
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	83 ec 28             	sub    $0x28,%esp
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c21:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c25:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c2f:	85 c0                	test   %eax,%eax
  800c31:	74 30                	je     800c63 <vsnprintf+0x51>
  800c33:	85 d2                	test   %edx,%edx
  800c35:	7e 2c                	jle    800c63 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c41:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c45:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c4c:	c7 04 24 f9 07 80 00 	movl   $0x8007f9,(%esp)
  800c53:	e8 e6 fb ff ff       	call   80083e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c5b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c61:	eb 05                	jmp    800c68 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800c63:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c70:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c77:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	89 04 24             	mov    %eax,(%esp)
  800c8b:	e8 82 ff ff ff       	call   800c12 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c90:	c9                   	leave  
  800c91:	c3                   	ret    
  800c92:	66 90                	xchg   %ax,%ax
  800c94:	66 90                	xchg   %ax,%ax
  800c96:	66 90                	xchg   %ax,%ax
  800c98:	66 90                	xchg   %ax,%ax
  800c9a:	66 90                	xchg   %ax,%ax
  800c9c:	66 90                	xchg   %ax,%ax
  800c9e:	66 90                	xchg   %ax,%ax

00800ca0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  800cab:	eb 03                	jmp    800cb0 <strlen+0x10>
		n++;
  800cad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800cb4:	75 f7                	jne    800cad <strlen+0xd>
		n++;
	return n;
}
  800cb6:	5d                   	pop    %ebp
  800cb7:	c3                   	ret    

00800cb8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800cb8:	55                   	push   %ebp
  800cb9:	89 e5                	mov    %esp,%ebp
  800cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc6:	eb 03                	jmp    800ccb <strnlen+0x13>
		n++;
  800cc8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccb:	39 d0                	cmp    %edx,%eax
  800ccd:	74 06                	je     800cd5 <strnlen+0x1d>
  800ccf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800cd3:	75 f3                	jne    800cc8 <strnlen+0x10>
		n++;
	return n;
}
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	53                   	push   %ebx
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ce1:	89 c2                	mov    %eax,%edx
  800ce3:	83 c2 01             	add    $0x1,%edx
  800ce6:	83 c1 01             	add    $0x1,%ecx
  800ce9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800ced:	88 5a ff             	mov    %bl,-0x1(%edx)
  800cf0:	84 db                	test   %bl,%bl
  800cf2:	75 ef                	jne    800ce3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800cf4:	5b                   	pop    %ebx
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	53                   	push   %ebx
  800cfb:	83 ec 08             	sub    $0x8,%esp
  800cfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d01:	89 1c 24             	mov    %ebx,(%esp)
  800d04:	e8 97 ff ff ff       	call   800ca0 <strlen>
	strcpy(dst + len, src);
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d10:	01 d8                	add    %ebx,%eax
  800d12:	89 04 24             	mov    %eax,(%esp)
  800d15:	e8 bd ff ff ff       	call   800cd7 <strcpy>
	return dst;
}
  800d1a:	89 d8                	mov    %ebx,%eax
  800d1c:	83 c4 08             	add    $0x8,%esp
  800d1f:	5b                   	pop    %ebx
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	56                   	push   %esi
  800d26:	53                   	push   %ebx
  800d27:	8b 75 08             	mov    0x8(%ebp),%esi
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	89 f3                	mov    %esi,%ebx
  800d2f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d32:	89 f2                	mov    %esi,%edx
  800d34:	eb 0f                	jmp    800d45 <strncpy+0x23>
		*dst++ = *src;
  800d36:	83 c2 01             	add    $0x1,%edx
  800d39:	0f b6 01             	movzbl (%ecx),%eax
  800d3c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d3f:	80 39 01             	cmpb   $0x1,(%ecx)
  800d42:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d45:	39 da                	cmp    %ebx,%edx
  800d47:	75 ed                	jne    800d36 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d49:	89 f0                	mov    %esi,%eax
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    

00800d4f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d4f:	55                   	push   %ebp
  800d50:	89 e5                	mov    %esp,%ebp
  800d52:	56                   	push   %esi
  800d53:	53                   	push   %ebx
  800d54:	8b 75 08             	mov    0x8(%ebp),%esi
  800d57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d5d:	89 f0                	mov    %esi,%eax
  800d5f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d63:	85 c9                	test   %ecx,%ecx
  800d65:	75 0b                	jne    800d72 <strlcpy+0x23>
  800d67:	eb 1d                	jmp    800d86 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d69:	83 c0 01             	add    $0x1,%eax
  800d6c:	83 c2 01             	add    $0x1,%edx
  800d6f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d72:	39 d8                	cmp    %ebx,%eax
  800d74:	74 0b                	je     800d81 <strlcpy+0x32>
  800d76:	0f b6 0a             	movzbl (%edx),%ecx
  800d79:	84 c9                	test   %cl,%cl
  800d7b:	75 ec                	jne    800d69 <strlcpy+0x1a>
  800d7d:	89 c2                	mov    %eax,%edx
  800d7f:	eb 02                	jmp    800d83 <strlcpy+0x34>
  800d81:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800d83:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800d86:	29 f0                	sub    %esi,%eax
}
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d92:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d95:	eb 06                	jmp    800d9d <strcmp+0x11>
		p++, q++;
  800d97:	83 c1 01             	add    $0x1,%ecx
  800d9a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d9d:	0f b6 01             	movzbl (%ecx),%eax
  800da0:	84 c0                	test   %al,%al
  800da2:	74 04                	je     800da8 <strcmp+0x1c>
  800da4:	3a 02                	cmp    (%edx),%al
  800da6:	74 ef                	je     800d97 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	0f b6 12             	movzbl (%edx),%edx
  800dae:	29 d0                	sub    %edx,%eax
}
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    

00800db2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	53                   	push   %ebx
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbc:	89 c3                	mov    %eax,%ebx
  800dbe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800dc1:	eb 06                	jmp    800dc9 <strncmp+0x17>
		n--, p++, q++;
  800dc3:	83 c0 01             	add    $0x1,%eax
  800dc6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800dc9:	39 d8                	cmp    %ebx,%eax
  800dcb:	74 15                	je     800de2 <strncmp+0x30>
  800dcd:	0f b6 08             	movzbl (%eax),%ecx
  800dd0:	84 c9                	test   %cl,%cl
  800dd2:	74 04                	je     800dd8 <strncmp+0x26>
  800dd4:	3a 0a                	cmp    (%edx),%cl
  800dd6:	74 eb                	je     800dc3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	0f b6 00             	movzbl (%eax),%eax
  800ddb:	0f b6 12             	movzbl (%edx),%edx
  800dde:	29 d0                	sub    %edx,%eax
  800de0:	eb 05                	jmp    800de7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800de2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800de7:	5b                   	pop    %ebx
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800df4:	eb 07                	jmp    800dfd <strchr+0x13>
		if (*s == c)
  800df6:	38 ca                	cmp    %cl,%dl
  800df8:	74 0f                	je     800e09 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfa:	83 c0 01             	add    $0x1,%eax
  800dfd:	0f b6 10             	movzbl (%eax),%edx
  800e00:	84 d2                	test   %dl,%dl
  800e02:	75 f2                	jne    800df6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e15:	eb 07                	jmp    800e1e <strfind+0x13>
		if (*s == c)
  800e17:	38 ca                	cmp    %cl,%dl
  800e19:	74 0a                	je     800e25 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e1b:	83 c0 01             	add    $0x1,%eax
  800e1e:	0f b6 10             	movzbl (%eax),%edx
  800e21:	84 d2                	test   %dl,%dl
  800e23:	75 f2                	jne    800e17 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	57                   	push   %edi
  800e2b:	56                   	push   %esi
  800e2c:	53                   	push   %ebx
  800e2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e33:	85 c9                	test   %ecx,%ecx
  800e35:	74 36                	je     800e6d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e37:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e3d:	75 28                	jne    800e67 <memset+0x40>
  800e3f:	f6 c1 03             	test   $0x3,%cl
  800e42:	75 23                	jne    800e67 <memset+0x40>
		c &= 0xFF;
  800e44:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e48:	89 d3                	mov    %edx,%ebx
  800e4a:	c1 e3 08             	shl    $0x8,%ebx
  800e4d:	89 d6                	mov    %edx,%esi
  800e4f:	c1 e6 18             	shl    $0x18,%esi
  800e52:	89 d0                	mov    %edx,%eax
  800e54:	c1 e0 10             	shl    $0x10,%eax
  800e57:	09 f0                	or     %esi,%eax
  800e59:	09 c2                	or     %eax,%edx
  800e5b:	89 d0                	mov    %edx,%eax
  800e5d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e5f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800e62:	fc                   	cld    
  800e63:	f3 ab                	rep stos %eax,%es:(%edi)
  800e65:	eb 06                	jmp    800e6d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	fc                   	cld    
  800e6b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e6d:	89 f8                	mov    %edi,%eax
  800e6f:	5b                   	pop    %ebx
  800e70:	5e                   	pop    %esi
  800e71:	5f                   	pop    %edi
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	57                   	push   %edi
  800e78:	56                   	push   %esi
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e82:	39 c6                	cmp    %eax,%esi
  800e84:	73 35                	jae    800ebb <memmove+0x47>
  800e86:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e89:	39 d0                	cmp    %edx,%eax
  800e8b:	73 2e                	jae    800ebb <memmove+0x47>
		s += n;
		d += n;
  800e8d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e90:	89 d6                	mov    %edx,%esi
  800e92:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e94:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e9a:	75 13                	jne    800eaf <memmove+0x3b>
  800e9c:	f6 c1 03             	test   $0x3,%cl
  800e9f:	75 0e                	jne    800eaf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ea1:	83 ef 04             	sub    $0x4,%edi
  800ea4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ea7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800eaa:	fd                   	std    
  800eab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ead:	eb 09                	jmp    800eb8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800eaf:	83 ef 01             	sub    $0x1,%edi
  800eb2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800eb5:	fd                   	std    
  800eb6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800eb8:	fc                   	cld    
  800eb9:	eb 1d                	jmp    800ed8 <memmove+0x64>
  800ebb:	89 f2                	mov    %esi,%edx
  800ebd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ebf:	f6 c2 03             	test   $0x3,%dl
  800ec2:	75 0f                	jne    800ed3 <memmove+0x5f>
  800ec4:	f6 c1 03             	test   $0x3,%cl
  800ec7:	75 0a                	jne    800ed3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ec9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800ecc:	89 c7                	mov    %eax,%edi
  800ece:	fc                   	cld    
  800ecf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ed1:	eb 05                	jmp    800ed8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ed3:	89 c7                	mov    %eax,%edi
  800ed5:	fc                   	cld    
  800ed6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 04 24             	mov    %eax,(%esp)
  800ef6:	e8 79 ff ff ff       	call   800e74 <memmove>
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
  800f02:	8b 55 08             	mov    0x8(%ebp),%edx
  800f05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f08:	89 d6                	mov    %edx,%esi
  800f0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f0d:	eb 1a                	jmp    800f29 <memcmp+0x2c>
		if (*s1 != *s2)
  800f0f:	0f b6 02             	movzbl (%edx),%eax
  800f12:	0f b6 19             	movzbl (%ecx),%ebx
  800f15:	38 d8                	cmp    %bl,%al
  800f17:	74 0a                	je     800f23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800f19:	0f b6 c0             	movzbl %al,%eax
  800f1c:	0f b6 db             	movzbl %bl,%ebx
  800f1f:	29 d8                	sub    %ebx,%eax
  800f21:	eb 0f                	jmp    800f32 <memcmp+0x35>
		s1++, s2++;
  800f23:	83 c2 01             	add    $0x1,%edx
  800f26:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f29:	39 f2                	cmp    %esi,%edx
  800f2b:	75 e2                	jne    800f0f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f44:	eb 07                	jmp    800f4d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f46:	38 08                	cmp    %cl,(%eax)
  800f48:	74 07                	je     800f51 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f4a:	83 c0 01             	add    $0x1,%eax
  800f4d:	39 d0                	cmp    %edx,%eax
  800f4f:	72 f5                	jb     800f46 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5f:	eb 03                	jmp    800f64 <strtol+0x11>
		s++;
  800f61:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f64:	0f b6 0a             	movzbl (%edx),%ecx
  800f67:	80 f9 09             	cmp    $0x9,%cl
  800f6a:	74 f5                	je     800f61 <strtol+0xe>
  800f6c:	80 f9 20             	cmp    $0x20,%cl
  800f6f:	74 f0                	je     800f61 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f71:	80 f9 2b             	cmp    $0x2b,%cl
  800f74:	75 0a                	jne    800f80 <strtol+0x2d>
		s++;
  800f76:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800f79:	bf 00 00 00 00       	mov    $0x0,%edi
  800f7e:	eb 11                	jmp    800f91 <strtol+0x3e>
  800f80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f85:	80 f9 2d             	cmp    $0x2d,%cl
  800f88:	75 07                	jne    800f91 <strtol+0x3e>
		s++, neg = 1;
  800f8a:	8d 52 01             	lea    0x1(%edx),%edx
  800f8d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f91:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f96:	75 15                	jne    800fad <strtol+0x5a>
  800f98:	80 3a 30             	cmpb   $0x30,(%edx)
  800f9b:	75 10                	jne    800fad <strtol+0x5a>
  800f9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800fa1:	75 0a                	jne    800fad <strtol+0x5a>
		s += 2, base = 16;
  800fa3:	83 c2 02             	add    $0x2,%edx
  800fa6:	b8 10 00 00 00       	mov    $0x10,%eax
  800fab:	eb 10                	jmp    800fbd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 0c                	jne    800fbd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fb1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fb3:	80 3a 30             	cmpb   $0x30,(%edx)
  800fb6:	75 05                	jne    800fbd <strtol+0x6a>
		s++, base = 8;
  800fb8:	83 c2 01             	add    $0x1,%edx
  800fbb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800fbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc5:	0f b6 0a             	movzbl (%edx),%ecx
  800fc8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800fcb:	89 f0                	mov    %esi,%eax
  800fcd:	3c 09                	cmp    $0x9,%al
  800fcf:	77 08                	ja     800fd9 <strtol+0x86>
			dig = *s - '0';
  800fd1:	0f be c9             	movsbl %cl,%ecx
  800fd4:	83 e9 30             	sub    $0x30,%ecx
  800fd7:	eb 20                	jmp    800ff9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800fd9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800fdc:	89 f0                	mov    %esi,%eax
  800fde:	3c 19                	cmp    $0x19,%al
  800fe0:	77 08                	ja     800fea <strtol+0x97>
			dig = *s - 'a' + 10;
  800fe2:	0f be c9             	movsbl %cl,%ecx
  800fe5:	83 e9 57             	sub    $0x57,%ecx
  800fe8:	eb 0f                	jmp    800ff9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800fea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800fed:	89 f0                	mov    %esi,%eax
  800fef:	3c 19                	cmp    $0x19,%al
  800ff1:	77 16                	ja     801009 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ff3:	0f be c9             	movsbl %cl,%ecx
  800ff6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ff9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ffc:	7d 0f                	jge    80100d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800ffe:	83 c2 01             	add    $0x1,%edx
  801001:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801005:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801007:	eb bc                	jmp    800fc5 <strtol+0x72>
  801009:	89 d8                	mov    %ebx,%eax
  80100b:	eb 02                	jmp    80100f <strtol+0xbc>
  80100d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80100f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801013:	74 05                	je     80101a <strtol+0xc7>
		*endptr = (char *) s;
  801015:	8b 75 0c             	mov    0xc(%ebp),%esi
  801018:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80101a:	f7 d8                	neg    %eax
  80101c:	85 ff                	test   %edi,%edi
  80101e:	0f 44 c3             	cmove  %ebx,%eax
}
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	57                   	push   %edi
  80102a:	56                   	push   %esi
  80102b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102c:	b8 00 00 00 00       	mov    $0x0,%eax
  801031:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801034:	8b 55 08             	mov    0x8(%ebp),%edx
  801037:	89 c3                	mov    %eax,%ebx
  801039:	89 c7                	mov    %eax,%edi
  80103b:	89 c6                	mov    %eax,%esi
  80103d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    

00801044 <sys_cgetc>:

int
sys_cgetc(void)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	57                   	push   %edi
  801048:	56                   	push   %esi
  801049:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104a:	ba 00 00 00 00       	mov    $0x0,%edx
  80104f:	b8 01 00 00 00       	mov    $0x1,%eax
  801054:	89 d1                	mov    %edx,%ecx
  801056:	89 d3                	mov    %edx,%ebx
  801058:	89 d7                	mov    %edx,%edi
  80105a:	89 d6                	mov    %edx,%esi
  80105c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80105e:	5b                   	pop    %ebx
  80105f:	5e                   	pop    %esi
  801060:	5f                   	pop    %edi
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  80106c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801071:	b8 03 00 00 00       	mov    $0x3,%eax
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	89 cb                	mov    %ecx,%ebx
  80107b:	89 cf                	mov    %ecx,%edi
  80107d:	89 ce                	mov    %ecx,%esi
  80107f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801081:	85 c0                	test   %eax,%eax
  801083:	7e 28                	jle    8010ad <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801085:	89 44 24 10          	mov    %eax,0x10(%esp)
  801089:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801090:	00 
  801091:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  801098:	00 
  801099:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a0:	00 
  8010a1:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  8010a8:	e8 04 f5 ff ff       	call   8005b1 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010ad:	83 c4 2c             	add    $0x2c,%esp
  8010b0:	5b                   	pop    %ebx
  8010b1:	5e                   	pop    %esi
  8010b2:	5f                   	pop    %edi
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	57                   	push   %edi
  8010b9:	56                   	push   %esi
  8010ba:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c0:	b8 02 00 00 00       	mov    $0x2,%eax
  8010c5:	89 d1                	mov    %edx,%ecx
  8010c7:	89 d3                	mov    %edx,%ebx
  8010c9:	89 d7                	mov    %edx,%edi
  8010cb:	89 d6                	mov    %edx,%esi
  8010cd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010cf:	5b                   	pop    %ebx
  8010d0:	5e                   	pop    %esi
  8010d1:	5f                   	pop    %edi
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    

008010d4 <sys_yield>:

void
sys_yield(void)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	57                   	push   %edi
  8010d8:	56                   	push   %esi
  8010d9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010da:	ba 00 00 00 00       	mov    $0x0,%edx
  8010df:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010e4:	89 d1                	mov    %edx,%ecx
  8010e6:	89 d3                	mov    %edx,%ebx
  8010e8:	89 d7                	mov    %edx,%edi
  8010ea:	89 d6                	mov    %edx,%esi
  8010ec:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010ee:	5b                   	pop    %ebx
  8010ef:	5e                   	pop    %esi
  8010f0:	5f                   	pop    %edi
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	57                   	push   %edi
  8010f7:	56                   	push   %esi
  8010f8:	53                   	push   %ebx
  8010f9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fc:	be 00 00 00 00       	mov    $0x0,%esi
  801101:	b8 04 00 00 00       	mov    $0x4,%eax
  801106:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801109:	8b 55 08             	mov    0x8(%ebp),%edx
  80110c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80110f:	89 f7                	mov    %esi,%edi
  801111:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801113:	85 c0                	test   %eax,%eax
  801115:	7e 28                	jle    80113f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801117:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801122:	00 
  801123:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  80112a:	00 
  80112b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801132:	00 
  801133:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  80113a:	e8 72 f4 ff ff       	call   8005b1 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80113f:	83 c4 2c             	add    $0x2c,%esp
  801142:	5b                   	pop    %ebx
  801143:	5e                   	pop    %esi
  801144:	5f                   	pop    %edi
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    

00801147 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	57                   	push   %edi
  80114b:	56                   	push   %esi
  80114c:	53                   	push   %ebx
  80114d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801150:	b8 05 00 00 00       	mov    $0x5,%eax
  801155:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801158:	8b 55 08             	mov    0x8(%ebp),%edx
  80115b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80115e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801161:	8b 75 18             	mov    0x18(%ebp),%esi
  801164:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801166:	85 c0                	test   %eax,%eax
  801168:	7e 28                	jle    801192 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80116a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80116e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801175:	00 
  801176:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  80117d:	00 
  80117e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801185:	00 
  801186:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  80118d:	e8 1f f4 ff ff       	call   8005b1 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801192:	83 c4 2c             	add    $0x2c,%esp
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    

0080119a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	57                   	push   %edi
  80119e:	56                   	push   %esi
  80119f:	53                   	push   %ebx
  8011a0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a8:	b8 06 00 00 00       	mov    $0x6,%eax
  8011ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b3:	89 df                	mov    %ebx,%edi
  8011b5:	89 de                	mov    %ebx,%esi
  8011b7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	7e 28                	jle    8011e5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8011c8:	00 
  8011c9:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  8011d0:	00 
  8011d1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d8:	00 
  8011d9:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  8011e0:	e8 cc f3 ff ff       	call   8005b1 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011e5:	83 c4 2c             	add    $0x2c,%esp
  8011e8:	5b                   	pop    %ebx
  8011e9:	5e                   	pop    %esi
  8011ea:	5f                   	pop    %edi
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    

008011ed <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	57                   	push   %edi
  8011f1:	56                   	push   %esi
  8011f2:	53                   	push   %ebx
  8011f3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011fb:	b8 08 00 00 00       	mov    $0x8,%eax
  801200:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801203:	8b 55 08             	mov    0x8(%ebp),%edx
  801206:	89 df                	mov    %ebx,%edi
  801208:	89 de                	mov    %ebx,%esi
  80120a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80120c:	85 c0                	test   %eax,%eax
  80120e:	7e 28                	jle    801238 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801210:	89 44 24 10          	mov    %eax,0x10(%esp)
  801214:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80121b:	00 
  80121c:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  801223:	00 
  801224:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80122b:	00 
  80122c:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  801233:	e8 79 f3 ff ff       	call   8005b1 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801238:	83 c4 2c             	add    $0x2c,%esp
  80123b:	5b                   	pop    %ebx
  80123c:	5e                   	pop    %esi
  80123d:	5f                   	pop    %edi
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    

00801240 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	57                   	push   %edi
  801244:	56                   	push   %esi
  801245:	53                   	push   %ebx
  801246:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801249:	bb 00 00 00 00       	mov    $0x0,%ebx
  80124e:	b8 09 00 00 00       	mov    $0x9,%eax
  801253:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801256:	8b 55 08             	mov    0x8(%ebp),%edx
  801259:	89 df                	mov    %ebx,%edi
  80125b:	89 de                	mov    %ebx,%esi
  80125d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80125f:	85 c0                	test   %eax,%eax
  801261:	7e 28                	jle    80128b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801263:	89 44 24 10          	mov    %eax,0x10(%esp)
  801267:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80126e:	00 
  80126f:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  801276:	00 
  801277:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80127e:	00 
  80127f:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  801286:	e8 26 f3 ff ff       	call   8005b1 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80128b:	83 c4 2c             	add    $0x2c,%esp
  80128e:	5b                   	pop    %ebx
  80128f:	5e                   	pop    %esi
  801290:	5f                   	pop    %edi
  801291:	5d                   	pop    %ebp
  801292:	c3                   	ret    

00801293 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	57                   	push   %edi
  801297:	56                   	push   %esi
  801298:	53                   	push   %ebx
  801299:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80129c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8012a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ac:	89 df                	mov    %ebx,%edi
  8012ae:	89 de                	mov    %ebx,%esi
  8012b0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	7e 28                	jle    8012de <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ba:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8012c1:	00 
  8012c2:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  8012c9:	00 
  8012ca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012d1:	00 
  8012d2:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  8012d9:	e8 d3 f2 ff ff       	call   8005b1 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012de:	83 c4 2c             	add    $0x2c,%esp
  8012e1:	5b                   	pop    %ebx
  8012e2:	5e                   	pop    %esi
  8012e3:	5f                   	pop    %edi
  8012e4:	5d                   	pop    %ebp
  8012e5:	c3                   	ret    

008012e6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	57                   	push   %edi
  8012ea:	56                   	push   %esi
  8012eb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ec:	be 00 00 00 00       	mov    $0x0,%esi
  8012f1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ff:	8b 7d 14             	mov    0x14(%ebp),%edi
  801302:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801304:	5b                   	pop    %ebx
  801305:	5e                   	pop    %esi
  801306:	5f                   	pop    %edi
  801307:	5d                   	pop    %ebp
  801308:	c3                   	ret    

00801309 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	57                   	push   %edi
  80130d:	56                   	push   %esi
  80130e:	53                   	push   %ebx
  80130f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801312:	b9 00 00 00 00       	mov    $0x0,%ecx
  801317:	b8 0d 00 00 00       	mov    $0xd,%eax
  80131c:	8b 55 08             	mov    0x8(%ebp),%edx
  80131f:	89 cb                	mov    %ecx,%ebx
  801321:	89 cf                	mov    %ecx,%edi
  801323:	89 ce                	mov    %ecx,%esi
  801325:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801327:	85 c0                	test   %eax,%eax
  801329:	7e 28                	jle    801353 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80132b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80132f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801336:	00 
  801337:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  80133e:	00 
  80133f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801346:	00 
  801347:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  80134e:	e8 5e f2 ff ff       	call   8005b1 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801353:	83 c4 2c             	add    $0x2c,%esp
  801356:	5b                   	pop    %ebx
  801357:	5e                   	pop    %esi
  801358:	5f                   	pop    %edi
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	57                   	push   %edi
  80135f:	56                   	push   %esi
  801360:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801361:	ba 00 00 00 00       	mov    $0x0,%edx
  801366:	b8 0e 00 00 00       	mov    $0xe,%eax
  80136b:	89 d1                	mov    %edx,%ecx
  80136d:	89 d3                	mov    %edx,%ebx
  80136f:	89 d7                	mov    %edx,%edi
  801371:	89 d6                	mov    %edx,%esi
  801373:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801375:	5b                   	pop    %ebx
  801376:	5e                   	pop    %esi
  801377:	5f                   	pop    %edi
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	57                   	push   %edi
  80137e:	56                   	push   %esi
  80137f:	53                   	push   %ebx
  801380:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801383:	bb 00 00 00 00       	mov    $0x0,%ebx
  801388:	b8 0f 00 00 00       	mov    $0xf,%eax
  80138d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801390:	8b 55 08             	mov    0x8(%ebp),%edx
  801393:	89 df                	mov    %ebx,%edi
  801395:	89 de                	mov    %ebx,%esi
  801397:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801399:	85 c0                	test   %eax,%eax
  80139b:	7e 28                	jle    8013c5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80139d:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013a1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8013a8:	00 
  8013a9:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  8013b0:	00 
  8013b1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013b8:	00 
  8013b9:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  8013c0:	e8 ec f1 ff ff       	call   8005b1 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  8013c5:	83 c4 2c             	add    $0x2c,%esp
  8013c8:	5b                   	pop    %ebx
  8013c9:	5e                   	pop    %esi
  8013ca:	5f                   	pop    %edi
  8013cb:	5d                   	pop    %ebp
  8013cc:	c3                   	ret    

008013cd <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	57                   	push   %edi
  8013d1:	56                   	push   %esi
  8013d2:	53                   	push   %ebx
  8013d3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013db:	b8 10 00 00 00       	mov    $0x10,%eax
  8013e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e6:	89 df                	mov    %ebx,%edi
  8013e8:	89 de                	mov    %ebx,%esi
  8013ea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	7e 28                	jle    801418 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013f4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8013fb:	00 
  8013fc:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  801403:	00 
  801404:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80140b:	00 
  80140c:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  801413:	e8 99 f1 ff ff       	call   8005b1 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801418:	83 c4 2c             	add    $0x2c,%esp
  80141b:	5b                   	pop    %ebx
  80141c:	5e                   	pop    %esi
  80141d:	5f                   	pop    %edi
  80141e:	5d                   	pop    %ebp
  80141f:	c3                   	ret    

00801420 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 24             	sub    $0x24,%esp
  801427:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  80142a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  80142c:	89 d3                	mov    %edx,%ebx
  80142e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  801434:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801438:	74 1a                	je     801454 <pgfault+0x34>
  80143a:	c1 ea 0c             	shr    $0xc,%edx
  80143d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801444:	a8 01                	test   $0x1,%al
  801446:	74 0c                	je     801454 <pgfault+0x34>
  801448:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80144f:	f6 c4 08             	test   $0x8,%ah
  801452:	75 1c                	jne    801470 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  801454:	c7 44 24 08 2c 38 80 	movl   $0x80382c,0x8(%esp)
  80145b:	00 
  80145c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801463:	00 
  801464:	c7 04 24 7b 39 80 00 	movl   $0x80397b,(%esp)
  80146b:	e8 41 f1 ff ff       	call   8005b1 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801470:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801477:	00 
  801478:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80147f:	00 
  801480:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801487:	e8 67 fc ff ff       	call   8010f3 <sys_page_alloc>
  80148c:	85 c0                	test   %eax,%eax
  80148e:	79 1c                	jns    8014ac <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801490:	c7 44 24 08 70 38 80 	movl   $0x803870,0x8(%esp)
  801497:	00 
  801498:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80149f:	00 
  8014a0:	c7 04 24 7b 39 80 00 	movl   $0x80397b,(%esp)
  8014a7:	e8 05 f1 ff ff       	call   8005b1 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  8014ac:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014b3:	00 
  8014b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014b8:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8014bf:	e8 18 fa ff ff       	call   800edc <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  8014c4:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014cb:	00 
  8014cc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014d7:	00 
  8014d8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014df:	00 
  8014e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014e7:	e8 5b fc ff ff       	call   801147 <sys_page_map>
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 1c                	je     80150c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  8014f0:	c7 44 24 08 86 39 80 	movl   $0x803986,0x8(%esp)
  8014f7:	00 
  8014f8:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8014ff:	00 
  801500:	c7 04 24 7b 39 80 00 	movl   $0x80397b,(%esp)
  801507:	e8 a5 f0 ff ff       	call   8005b1 <_panic>
    sys_page_unmap(0,PFTEMP);
  80150c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801513:	00 
  801514:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80151b:	e8 7a fc ff ff       	call   80119a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801520:	83 c4 24             	add    $0x24,%esp
  801523:	5b                   	pop    %ebx
  801524:	5d                   	pop    %ebp
  801525:	c3                   	ret    

00801526 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	57                   	push   %edi
  80152a:	56                   	push   %esi
  80152b:	53                   	push   %ebx
  80152c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80152f:	c7 04 24 20 14 80 00 	movl   $0x801420,(%esp)
  801536:	e8 cf 19 00 00       	call   802f0a <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80153b:	b8 07 00 00 00       	mov    $0x7,%eax
  801540:	cd 30                	int    $0x30
  801542:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801545:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801547:	bb 00 00 00 00       	mov    $0x0,%ebx
  80154c:	85 c0                	test   %eax,%eax
  80154e:	75 21                	jne    801571 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801550:	e8 60 fb ff ff       	call   8010b5 <sys_getenvid>
  801555:	25 ff 03 00 00       	and    $0x3ff,%eax
  80155a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80155d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801562:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
  80156c:	e9 de 01 00 00       	jmp    80174f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801571:	89 d8                	mov    %ebx,%eax
  801573:	c1 e8 16             	shr    $0x16,%eax
  801576:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80157d:	a8 01                	test   $0x1,%al
  80157f:	0f 84 58 01 00 00    	je     8016dd <fork+0x1b7>
  801585:	89 de                	mov    %ebx,%esi
  801587:	c1 ee 0c             	shr    $0xc,%esi
  80158a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801591:	83 e0 05             	and    $0x5,%eax
  801594:	83 f8 05             	cmp    $0x5,%eax
  801597:	0f 85 40 01 00 00    	jne    8016dd <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80159d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8015a4:	f6 c4 04             	test   $0x4,%ah
  8015a7:	74 4f                	je     8015f8 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  8015a9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8015b0:	c1 e6 0c             	shl    $0xc,%esi
  8015b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8015b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015bc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8015c0:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8015c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015cf:	e8 73 fb ff ff       	call   801147 <sys_page_map>
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	0f 89 01 01 00 00    	jns    8016dd <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  8015dc:	c7 44 24 08 90 38 80 	movl   $0x803890,0x8(%esp)
  8015e3:	00 
  8015e4:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8015eb:	00 
  8015ec:	c7 04 24 7b 39 80 00 	movl   $0x80397b,(%esp)
  8015f3:	e8 b9 ef ff ff       	call   8005b1 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  8015f8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8015ff:	a8 02                	test   $0x2,%al
  801601:	75 10                	jne    801613 <fork+0xed>
  801603:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80160a:	f6 c4 08             	test   $0x8,%ah
  80160d:	0f 84 87 00 00 00    	je     80169a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801613:	c1 e6 0c             	shl    $0xc,%esi
  801616:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80161d:	00 
  80161e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801622:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801626:	89 74 24 04          	mov    %esi,0x4(%esp)
  80162a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801631:	e8 11 fb ff ff       	call   801147 <sys_page_map>
  801636:	85 c0                	test   %eax,%eax
  801638:	79 1c                	jns    801656 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80163a:	c7 44 24 08 c8 38 80 	movl   $0x8038c8,0x8(%esp)
  801641:	00 
  801642:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801649:	00 
  80164a:	c7 04 24 7b 39 80 00 	movl   $0x80397b,(%esp)
  801651:	e8 5b ef ff ff       	call   8005b1 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801656:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80165d:	00 
  80165e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801662:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801669:	00 
  80166a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80166e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801675:	e8 cd fa ff ff       	call   801147 <sys_page_map>
  80167a:	85 c0                	test   %eax,%eax
  80167c:	79 5f                	jns    8016dd <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  80167e:	c7 44 24 08 00 39 80 	movl   $0x803900,0x8(%esp)
  801685:	00 
  801686:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  80168d:	00 
  80168e:	c7 04 24 7b 39 80 00 	movl   $0x80397b,(%esp)
  801695:	e8 17 ef ff ff       	call   8005b1 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80169a:	c1 e6 0c             	shl    $0xc,%esi
  80169d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8016a4:	00 
  8016a5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016a9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8016ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b8:	e8 8a fa ff ff       	call   801147 <sys_page_map>
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	74 1c                	je     8016dd <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  8016c1:	c7 44 24 08 28 39 80 	movl   $0x803928,0x8(%esp)
  8016c8:	00 
  8016c9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8016d0:	00 
  8016d1:	c7 04 24 7b 39 80 00 	movl   $0x80397b,(%esp)
  8016d8:	e8 d4 ee ff ff       	call   8005b1 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  8016dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8016e3:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8016e9:	0f 85 82 fe ff ff    	jne    801571 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  8016ef:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8016f6:	00 
  8016f7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8016fe:	ee 
  8016ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801702:	89 04 24             	mov    %eax,(%esp)
  801705:	e8 e9 f9 ff ff       	call   8010f3 <sys_page_alloc>
  80170a:	85 c0                	test   %eax,%eax
  80170c:	79 1c                	jns    80172a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  80170e:	c7 44 24 08 5c 39 80 	movl   $0x80395c,0x8(%esp)
  801715:	00 
  801716:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  80171d:	00 
  80171e:	c7 04 24 7b 39 80 00 	movl   $0x80397b,(%esp)
  801725:	e8 87 ee ff ff       	call   8005b1 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  80172a:	c7 44 24 04 7b 2f 80 	movl   $0x802f7b,0x4(%esp)
  801731:	00 
  801732:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801735:	89 3c 24             	mov    %edi,(%esp)
  801738:	e8 56 fb ff ff       	call   801293 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80173d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801744:	00 
  801745:	89 3c 24             	mov    %edi,(%esp)
  801748:	e8 a0 fa ff ff       	call   8011ed <sys_env_set_status>
		return child;
  80174d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80174f:	83 c4 2c             	add    $0x2c,%esp
  801752:	5b                   	pop    %ebx
  801753:	5e                   	pop    %esi
  801754:	5f                   	pop    %edi
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    

00801757 <sfork>:

// Challenge!
int
sfork(void)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80175d:	c7 44 24 08 a4 39 80 	movl   $0x8039a4,0x8(%esp)
  801764:	00 
  801765:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80176c:	00 
  80176d:	c7 04 24 7b 39 80 00 	movl   $0x80397b,(%esp)
  801774:	e8 38 ee ff ff       	call   8005b1 <_panic>
  801779:	66 90                	xchg   %ax,%ax
  80177b:	66 90                	xchg   %ax,%ax
  80177d:	66 90                	xchg   %ax,%ax
  80177f:	90                   	nop

00801780 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801783:	8b 45 08             	mov    0x8(%ebp),%eax
  801786:	05 00 00 00 30       	add    $0x30000000,%eax
  80178b:	c1 e8 0c             	shr    $0xc,%eax
}
  80178e:	5d                   	pop    %ebp
  80178f:	c3                   	ret    

00801790 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80179b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017ad:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017b2:	89 c2                	mov    %eax,%edx
  8017b4:	c1 ea 16             	shr    $0x16,%edx
  8017b7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017be:	f6 c2 01             	test   $0x1,%dl
  8017c1:	74 11                	je     8017d4 <fd_alloc+0x2d>
  8017c3:	89 c2                	mov    %eax,%edx
  8017c5:	c1 ea 0c             	shr    $0xc,%edx
  8017c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017cf:	f6 c2 01             	test   $0x1,%dl
  8017d2:	75 09                	jne    8017dd <fd_alloc+0x36>
			*fd_store = fd;
  8017d4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017db:	eb 17                	jmp    8017f4 <fd_alloc+0x4d>
  8017dd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8017e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017e7:	75 c9                	jne    8017b2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017e9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8017ef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8017f4:	5d                   	pop    %ebp
  8017f5:	c3                   	ret    

008017f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017fc:	83 f8 1f             	cmp    $0x1f,%eax
  8017ff:	77 36                	ja     801837 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801801:	c1 e0 0c             	shl    $0xc,%eax
  801804:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801809:	89 c2                	mov    %eax,%edx
  80180b:	c1 ea 16             	shr    $0x16,%edx
  80180e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801815:	f6 c2 01             	test   $0x1,%dl
  801818:	74 24                	je     80183e <fd_lookup+0x48>
  80181a:	89 c2                	mov    %eax,%edx
  80181c:	c1 ea 0c             	shr    $0xc,%edx
  80181f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801826:	f6 c2 01             	test   $0x1,%dl
  801829:	74 1a                	je     801845 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80182b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182e:	89 02                	mov    %eax,(%edx)
	return 0;
  801830:	b8 00 00 00 00       	mov    $0x0,%eax
  801835:	eb 13                	jmp    80184a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801837:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80183c:	eb 0c                	jmp    80184a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80183e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801843:	eb 05                	jmp    80184a <fd_lookup+0x54>
  801845:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    

0080184c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 18             	sub    $0x18,%esp
  801852:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801855:	ba 00 00 00 00       	mov    $0x0,%edx
  80185a:	eb 13                	jmp    80186f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80185c:	39 08                	cmp    %ecx,(%eax)
  80185e:	75 0c                	jne    80186c <dev_lookup+0x20>
			*dev = devtab[i];
  801860:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801863:	89 01                	mov    %eax,(%ecx)
			return 0;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
  80186a:	eb 38                	jmp    8018a4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80186c:	83 c2 01             	add    $0x1,%edx
  80186f:	8b 04 95 38 3a 80 00 	mov    0x803a38(,%edx,4),%eax
  801876:	85 c0                	test   %eax,%eax
  801878:	75 e2                	jne    80185c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80187a:	a1 08 50 80 00       	mov    0x805008,%eax
  80187f:	8b 40 48             	mov    0x48(%eax),%eax
  801882:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801886:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188a:	c7 04 24 bc 39 80 00 	movl   $0x8039bc,(%esp)
  801891:	e8 14 ee ff ff       	call   8006aa <cprintf>
	*dev = 0;
  801896:	8b 45 0c             	mov    0xc(%ebp),%eax
  801899:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80189f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	56                   	push   %esi
  8018aa:	53                   	push   %ebx
  8018ab:	83 ec 20             	sub    $0x20,%esp
  8018ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8018b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018c1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018c4:	89 04 24             	mov    %eax,(%esp)
  8018c7:	e8 2a ff ff ff       	call   8017f6 <fd_lookup>
  8018cc:	85 c0                	test   %eax,%eax
  8018ce:	78 05                	js     8018d5 <fd_close+0x2f>
	    || fd != fd2)
  8018d0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018d3:	74 0c                	je     8018e1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8018d5:	84 db                	test   %bl,%bl
  8018d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018dc:	0f 44 c2             	cmove  %edx,%eax
  8018df:	eb 3f                	jmp    801920 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e8:	8b 06                	mov    (%esi),%eax
  8018ea:	89 04 24             	mov    %eax,(%esp)
  8018ed:	e8 5a ff ff ff       	call   80184c <dev_lookup>
  8018f2:	89 c3                	mov    %eax,%ebx
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 16                	js     80190e <fd_close+0x68>
		if (dev->dev_close)
  8018f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8018fe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801903:	85 c0                	test   %eax,%eax
  801905:	74 07                	je     80190e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801907:	89 34 24             	mov    %esi,(%esp)
  80190a:	ff d0                	call   *%eax
  80190c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80190e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801912:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801919:	e8 7c f8 ff ff       	call   80119a <sys_page_unmap>
	return r;
  80191e:	89 d8                	mov    %ebx,%eax
}
  801920:	83 c4 20             	add    $0x20,%esp
  801923:	5b                   	pop    %ebx
  801924:	5e                   	pop    %esi
  801925:	5d                   	pop    %ebp
  801926:	c3                   	ret    

00801927 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
  80192a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80192d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801930:	89 44 24 04          	mov    %eax,0x4(%esp)
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	89 04 24             	mov    %eax,(%esp)
  80193a:	e8 b7 fe ff ff       	call   8017f6 <fd_lookup>
  80193f:	89 c2                	mov    %eax,%edx
  801941:	85 d2                	test   %edx,%edx
  801943:	78 13                	js     801958 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801945:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80194c:	00 
  80194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801950:	89 04 24             	mov    %eax,(%esp)
  801953:	e8 4e ff ff ff       	call   8018a6 <fd_close>
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <close_all>:

void
close_all(void)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	53                   	push   %ebx
  80195e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801961:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801966:	89 1c 24             	mov    %ebx,(%esp)
  801969:	e8 b9 ff ff ff       	call   801927 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80196e:	83 c3 01             	add    $0x1,%ebx
  801971:	83 fb 20             	cmp    $0x20,%ebx
  801974:	75 f0                	jne    801966 <close_all+0xc>
		close(i);
}
  801976:	83 c4 14             	add    $0x14,%esp
  801979:	5b                   	pop    %ebx
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    

0080197c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	57                   	push   %edi
  801980:	56                   	push   %esi
  801981:	53                   	push   %ebx
  801982:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801985:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801988:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	89 04 24             	mov    %eax,(%esp)
  801992:	e8 5f fe ff ff       	call   8017f6 <fd_lookup>
  801997:	89 c2                	mov    %eax,%edx
  801999:	85 d2                	test   %edx,%edx
  80199b:	0f 88 e1 00 00 00    	js     801a82 <dup+0x106>
		return r;
	close(newfdnum);
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	89 04 24             	mov    %eax,(%esp)
  8019a7:	e8 7b ff ff ff       	call   801927 <close>

	newfd = INDEX2FD(newfdnum);
  8019ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019af:	c1 e3 0c             	shl    $0xc,%ebx
  8019b2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8019b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019bb:	89 04 24             	mov    %eax,(%esp)
  8019be:	e8 cd fd ff ff       	call   801790 <fd2data>
  8019c3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8019c5:	89 1c 24             	mov    %ebx,(%esp)
  8019c8:	e8 c3 fd ff ff       	call   801790 <fd2data>
  8019cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019cf:	89 f0                	mov    %esi,%eax
  8019d1:	c1 e8 16             	shr    $0x16,%eax
  8019d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019db:	a8 01                	test   $0x1,%al
  8019dd:	74 43                	je     801a22 <dup+0xa6>
  8019df:	89 f0                	mov    %esi,%eax
  8019e1:	c1 e8 0c             	shr    $0xc,%eax
  8019e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019eb:	f6 c2 01             	test   $0x1,%dl
  8019ee:	74 32                	je     801a22 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8019fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a00:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a04:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a0b:	00 
  801a0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a17:	e8 2b f7 ff ff       	call   801147 <sys_page_map>
  801a1c:	89 c6                	mov    %eax,%esi
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 3e                	js     801a60 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a25:	89 c2                	mov    %eax,%edx
  801a27:	c1 ea 0c             	shr    $0xc,%edx
  801a2a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a31:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a37:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a3b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a46:	00 
  801a47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a52:	e8 f0 f6 ff ff       	call   801147 <sys_page_map>
  801a57:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801a59:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a5c:	85 f6                	test   %esi,%esi
  801a5e:	79 22                	jns    801a82 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a60:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6b:	e8 2a f7 ff ff       	call   80119a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a70:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7b:	e8 1a f7 ff ff       	call   80119a <sys_page_unmap>
	return r;
  801a80:	89 f0                	mov    %esi,%eax
}
  801a82:	83 c4 3c             	add    $0x3c,%esp
  801a85:	5b                   	pop    %ebx
  801a86:	5e                   	pop    %esi
  801a87:	5f                   	pop    %edi
  801a88:	5d                   	pop    %ebp
  801a89:	c3                   	ret    

00801a8a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
  801a8d:	53                   	push   %ebx
  801a8e:	83 ec 24             	sub    $0x24,%esp
  801a91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a94:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9b:	89 1c 24             	mov    %ebx,(%esp)
  801a9e:	e8 53 fd ff ff       	call   8017f6 <fd_lookup>
  801aa3:	89 c2                	mov    %eax,%edx
  801aa5:	85 d2                	test   %edx,%edx
  801aa7:	78 6d                	js     801b16 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab3:	8b 00                	mov    (%eax),%eax
  801ab5:	89 04 24             	mov    %eax,(%esp)
  801ab8:	e8 8f fd ff ff       	call   80184c <dev_lookup>
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 55                	js     801b16 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac4:	8b 50 08             	mov    0x8(%eax),%edx
  801ac7:	83 e2 03             	and    $0x3,%edx
  801aca:	83 fa 01             	cmp    $0x1,%edx
  801acd:	75 23                	jne    801af2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801acf:	a1 08 50 80 00       	mov    0x805008,%eax
  801ad4:	8b 40 48             	mov    0x48(%eax),%eax
  801ad7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adf:	c7 04 24 fd 39 80 00 	movl   $0x8039fd,(%esp)
  801ae6:	e8 bf eb ff ff       	call   8006aa <cprintf>
		return -E_INVAL;
  801aeb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801af0:	eb 24                	jmp    801b16 <read+0x8c>
	}
	if (!dev->dev_read)
  801af2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af5:	8b 52 08             	mov    0x8(%edx),%edx
  801af8:	85 d2                	test   %edx,%edx
  801afa:	74 15                	je     801b11 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801afc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b0a:	89 04 24             	mov    %eax,(%esp)
  801b0d:	ff d2                	call   *%edx
  801b0f:	eb 05                	jmp    801b16 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b11:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b16:	83 c4 24             	add    $0x24,%esp
  801b19:	5b                   	pop    %ebx
  801b1a:	5d                   	pop    %ebp
  801b1b:	c3                   	ret    

00801b1c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
  801b1f:	57                   	push   %edi
  801b20:	56                   	push   %esi
  801b21:	53                   	push   %ebx
  801b22:	83 ec 1c             	sub    $0x1c,%esp
  801b25:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b28:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b30:	eb 23                	jmp    801b55 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b32:	89 f0                	mov    %esi,%eax
  801b34:	29 d8                	sub    %ebx,%eax
  801b36:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b3a:	89 d8                	mov    %ebx,%eax
  801b3c:	03 45 0c             	add    0xc(%ebp),%eax
  801b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b43:	89 3c 24             	mov    %edi,(%esp)
  801b46:	e8 3f ff ff ff       	call   801a8a <read>
		if (m < 0)
  801b4b:	85 c0                	test   %eax,%eax
  801b4d:	78 10                	js     801b5f <readn+0x43>
			return m;
		if (m == 0)
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	74 0a                	je     801b5d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b53:	01 c3                	add    %eax,%ebx
  801b55:	39 f3                	cmp    %esi,%ebx
  801b57:	72 d9                	jb     801b32 <readn+0x16>
  801b59:	89 d8                	mov    %ebx,%eax
  801b5b:	eb 02                	jmp    801b5f <readn+0x43>
  801b5d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b5f:	83 c4 1c             	add    $0x1c,%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5e                   	pop    %esi
  801b64:	5f                   	pop    %edi
  801b65:	5d                   	pop    %ebp
  801b66:	c3                   	ret    

00801b67 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	53                   	push   %ebx
  801b6b:	83 ec 24             	sub    $0x24,%esp
  801b6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b71:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b78:	89 1c 24             	mov    %ebx,(%esp)
  801b7b:	e8 76 fc ff ff       	call   8017f6 <fd_lookup>
  801b80:	89 c2                	mov    %eax,%edx
  801b82:	85 d2                	test   %edx,%edx
  801b84:	78 68                	js     801bee <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b90:	8b 00                	mov    (%eax),%eax
  801b92:	89 04 24             	mov    %eax,(%esp)
  801b95:	e8 b2 fc ff ff       	call   80184c <dev_lookup>
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	78 50                	js     801bee <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ba5:	75 23                	jne    801bca <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801ba7:	a1 08 50 80 00       	mov    0x805008,%eax
  801bac:	8b 40 48             	mov    0x48(%eax),%eax
  801baf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb7:	c7 04 24 19 3a 80 00 	movl   $0x803a19,(%esp)
  801bbe:	e8 e7 ea ff ff       	call   8006aa <cprintf>
		return -E_INVAL;
  801bc3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bc8:	eb 24                	jmp    801bee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bcd:	8b 52 0c             	mov    0xc(%edx),%edx
  801bd0:	85 d2                	test   %edx,%edx
  801bd2:	74 15                	je     801be9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bd4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801be2:	89 04 24             	mov    %eax,(%esp)
  801be5:	ff d2                	call   *%edx
  801be7:	eb 05                	jmp    801bee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801be9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801bee:	83 c4 24             	add    $0x24,%esp
  801bf1:	5b                   	pop    %ebx
  801bf2:	5d                   	pop    %ebp
  801bf3:	c3                   	ret    

00801bf4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bfa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	89 04 24             	mov    %eax,(%esp)
  801c07:	e8 ea fb ff ff       	call   8017f6 <fd_lookup>
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	78 0e                	js     801c1e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c16:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	53                   	push   %ebx
  801c24:	83 ec 24             	sub    $0x24,%esp
  801c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c31:	89 1c 24             	mov    %ebx,(%esp)
  801c34:	e8 bd fb ff ff       	call   8017f6 <fd_lookup>
  801c39:	89 c2                	mov    %eax,%edx
  801c3b:	85 d2                	test   %edx,%edx
  801c3d:	78 61                	js     801ca0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c49:	8b 00                	mov    (%eax),%eax
  801c4b:	89 04 24             	mov    %eax,(%esp)
  801c4e:	e8 f9 fb ff ff       	call   80184c <dev_lookup>
  801c53:	85 c0                	test   %eax,%eax
  801c55:	78 49                	js     801ca0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c5e:	75 23                	jne    801c83 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801c60:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c65:	8b 40 48             	mov    0x48(%eax),%eax
  801c68:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c70:	c7 04 24 dc 39 80 00 	movl   $0x8039dc,(%esp)
  801c77:	e8 2e ea ff ff       	call   8006aa <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801c7c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c81:	eb 1d                	jmp    801ca0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c86:	8b 52 18             	mov    0x18(%edx),%edx
  801c89:	85 d2                	test   %edx,%edx
  801c8b:	74 0e                	je     801c9b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c90:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c94:	89 04 24             	mov    %eax,(%esp)
  801c97:	ff d2                	call   *%edx
  801c99:	eb 05                	jmp    801ca0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801c9b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801ca0:	83 c4 24             	add    $0x24,%esp
  801ca3:	5b                   	pop    %ebx
  801ca4:	5d                   	pop    %ebp
  801ca5:	c3                   	ret    

00801ca6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	53                   	push   %ebx
  801caa:	83 ec 24             	sub    $0x24,%esp
  801cad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cb0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	89 04 24             	mov    %eax,(%esp)
  801cbd:	e8 34 fb ff ff       	call   8017f6 <fd_lookup>
  801cc2:	89 c2                	mov    %eax,%edx
  801cc4:	85 d2                	test   %edx,%edx
  801cc6:	78 52                	js     801d1a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd2:	8b 00                	mov    (%eax),%eax
  801cd4:	89 04 24             	mov    %eax,(%esp)
  801cd7:	e8 70 fb ff ff       	call   80184c <dev_lookup>
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	78 3a                	js     801d1a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ce7:	74 2c                	je     801d15 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ce9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cf3:	00 00 00 
	stat->st_isdir = 0;
  801cf6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cfd:	00 00 00 
	stat->st_dev = dev;
  801d00:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d0d:	89 14 24             	mov    %edx,(%esp)
  801d10:	ff 50 14             	call   *0x14(%eax)
  801d13:	eb 05                	jmp    801d1a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d15:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d1a:	83 c4 24             	add    $0x24,%esp
  801d1d:	5b                   	pop    %ebx
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    

00801d20 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	56                   	push   %esi
  801d24:	53                   	push   %ebx
  801d25:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d2f:	00 
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	89 04 24             	mov    %eax,(%esp)
  801d36:	e8 28 02 00 00       	call   801f63 <open>
  801d3b:	89 c3                	mov    %eax,%ebx
  801d3d:	85 db                	test   %ebx,%ebx
  801d3f:	78 1b                	js     801d5c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d48:	89 1c 24             	mov    %ebx,(%esp)
  801d4b:	e8 56 ff ff ff       	call   801ca6 <fstat>
  801d50:	89 c6                	mov    %eax,%esi
	close(fd);
  801d52:	89 1c 24             	mov    %ebx,(%esp)
  801d55:	e8 cd fb ff ff       	call   801927 <close>
	return r;
  801d5a:	89 f0                	mov    %esi,%eax
}
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	5b                   	pop    %ebx
  801d60:	5e                   	pop    %esi
  801d61:	5d                   	pop    %ebp
  801d62:	c3                   	ret    

00801d63 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	56                   	push   %esi
  801d67:	53                   	push   %ebx
  801d68:	83 ec 10             	sub    $0x10,%esp
  801d6b:	89 c6                	mov    %eax,%esi
  801d6d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d6f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801d76:	75 11                	jne    801d89 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d7f:	e8 e6 12 00 00       	call   80306a <ipc_find_env>
  801d84:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d89:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d90:	00 
  801d91:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d98:	00 
  801d99:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d9d:	a1 00 50 80 00       	mov    0x805000,%eax
  801da2:	89 04 24             	mov    %eax,(%esp)
  801da5:	e8 62 12 00 00       	call   80300c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801daa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801db1:	00 
  801db2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801db6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dbd:	e8 e0 11 00 00       	call   802fa2 <ipc_recv>
}
  801dc2:	83 c4 10             	add    $0x10,%esp
  801dc5:	5b                   	pop    %ebx
  801dc6:	5e                   	pop    %esi
  801dc7:	5d                   	pop    %ebp
  801dc8:	c3                   	ret    

00801dc9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801de2:	ba 00 00 00 00       	mov    $0x0,%edx
  801de7:	b8 02 00 00 00       	mov    $0x2,%eax
  801dec:	e8 72 ff ff ff       	call   801d63 <fsipc>
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dff:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e04:	ba 00 00 00 00       	mov    $0x0,%edx
  801e09:	b8 06 00 00 00       	mov    $0x6,%eax
  801e0e:	e8 50 ff ff ff       	call   801d63 <fsipc>
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	53                   	push   %ebx
  801e19:	83 ec 14             	sub    $0x14,%esp
  801e1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	8b 40 0c             	mov    0xc(%eax),%eax
  801e25:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e34:	e8 2a ff ff ff       	call   801d63 <fsipc>
  801e39:	89 c2                	mov    %eax,%edx
  801e3b:	85 d2                	test   %edx,%edx
  801e3d:	78 2b                	js     801e6a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e3f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e46:	00 
  801e47:	89 1c 24             	mov    %ebx,(%esp)
  801e4a:	e8 88 ee ff ff       	call   800cd7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e4f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e54:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e5a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e5f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6a:	83 c4 14             	add    $0x14,%esp
  801e6d:	5b                   	pop    %ebx
  801e6e:	5d                   	pop    %ebp
  801e6f:	c3                   	ret    

00801e70 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 18             	sub    $0x18,%esp
  801e76:	8b 45 10             	mov    0x10(%ebp),%eax
  801e79:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801e7e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801e83:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801e86:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e8b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8e:	8b 52 0c             	mov    0xc(%edx),%edx
  801e91:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801e97:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea2:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801ea9:	e8 c6 ef ff ff       	call   800e74 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801eae:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb3:	b8 04 00 00 00       	mov    $0x4,%eax
  801eb8:	e8 a6 fe ff ff       	call   801d63 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	56                   	push   %esi
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 10             	sub    $0x10,%esp
  801ec7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ed5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801edb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ee5:	e8 79 fe ff ff       	call   801d63 <fsipc>
  801eea:	89 c3                	mov    %eax,%ebx
  801eec:	85 c0                	test   %eax,%eax
  801eee:	78 6a                	js     801f5a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ef0:	39 c6                	cmp    %eax,%esi
  801ef2:	73 24                	jae    801f18 <devfile_read+0x59>
  801ef4:	c7 44 24 0c 4c 3a 80 	movl   $0x803a4c,0xc(%esp)
  801efb:	00 
  801efc:	c7 44 24 08 53 3a 80 	movl   $0x803a53,0x8(%esp)
  801f03:	00 
  801f04:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f0b:	00 
  801f0c:	c7 04 24 68 3a 80 00 	movl   $0x803a68,(%esp)
  801f13:	e8 99 e6 ff ff       	call   8005b1 <_panic>
	assert(r <= PGSIZE);
  801f18:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f1d:	7e 24                	jle    801f43 <devfile_read+0x84>
  801f1f:	c7 44 24 0c 73 3a 80 	movl   $0x803a73,0xc(%esp)
  801f26:	00 
  801f27:	c7 44 24 08 53 3a 80 	movl   $0x803a53,0x8(%esp)
  801f2e:	00 
  801f2f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801f36:	00 
  801f37:	c7 04 24 68 3a 80 00 	movl   $0x803a68,(%esp)
  801f3e:	e8 6e e6 ff ff       	call   8005b1 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f43:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f47:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f4e:	00 
  801f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f52:	89 04 24             	mov    %eax,(%esp)
  801f55:	e8 1a ef ff ff       	call   800e74 <memmove>
	return r;
}
  801f5a:	89 d8                	mov    %ebx,%eax
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	5b                   	pop    %ebx
  801f60:	5e                   	pop    %esi
  801f61:	5d                   	pop    %ebp
  801f62:	c3                   	ret    

00801f63 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f63:	55                   	push   %ebp
  801f64:	89 e5                	mov    %esp,%ebp
  801f66:	53                   	push   %ebx
  801f67:	83 ec 24             	sub    $0x24,%esp
  801f6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f6d:	89 1c 24             	mov    %ebx,(%esp)
  801f70:	e8 2b ed ff ff       	call   800ca0 <strlen>
  801f75:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f7a:	7f 60                	jg     801fdc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7f:	89 04 24             	mov    %eax,(%esp)
  801f82:	e8 20 f8 ff ff       	call   8017a7 <fd_alloc>
  801f87:	89 c2                	mov    %eax,%edx
  801f89:	85 d2                	test   %edx,%edx
  801f8b:	78 54                	js     801fe1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801f8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f91:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801f98:	e8 3a ed ff ff       	call   800cd7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa0:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801fa5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa8:	b8 01 00 00 00       	mov    $0x1,%eax
  801fad:	e8 b1 fd ff ff       	call   801d63 <fsipc>
  801fb2:	89 c3                	mov    %eax,%ebx
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	79 17                	jns    801fcf <open+0x6c>
		fd_close(fd, 0);
  801fb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fbf:	00 
  801fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc3:	89 04 24             	mov    %eax,(%esp)
  801fc6:	e8 db f8 ff ff       	call   8018a6 <fd_close>
		return r;
  801fcb:	89 d8                	mov    %ebx,%eax
  801fcd:	eb 12                	jmp    801fe1 <open+0x7e>
	}

	return fd2num(fd);
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	89 04 24             	mov    %eax,(%esp)
  801fd5:	e8 a6 f7 ff ff       	call   801780 <fd2num>
  801fda:	eb 05                	jmp    801fe1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801fdc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801fe1:	83 c4 24             	add    $0x24,%esp
  801fe4:	5b                   	pop    %ebx
  801fe5:	5d                   	pop    %ebp
  801fe6:	c3                   	ret    

00801fe7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fed:	ba 00 00 00 00       	mov    $0x0,%edx
  801ff2:	b8 08 00 00 00       	mov    $0x8,%eax
  801ff7:	e8 67 fd ff ff       	call   801d63 <fsipc>
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    
  801ffe:	66 90                	xchg   %ax,%ax

00802000 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	57                   	push   %edi
  802004:	56                   	push   %esi
  802005:	53                   	push   %ebx
  802006:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  80200c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802013:	00 
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	89 04 24             	mov    %eax,(%esp)
  80201a:	e8 44 ff ff ff       	call   801f63 <open>
  80201f:	89 c2                	mov    %eax,%edx
  802021:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  802027:	85 c0                	test   %eax,%eax
  802029:	0f 88 0f 05 00 00    	js     80253e <spawn+0x53e>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80202f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802036:	00 
  802037:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80203d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802041:	89 14 24             	mov    %edx,(%esp)
  802044:	e8 d3 fa ff ff       	call   801b1c <readn>
  802049:	3d 00 02 00 00       	cmp    $0x200,%eax
  80204e:	75 0c                	jne    80205c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802050:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802057:	45 4c 46 
  80205a:	74 36                	je     802092 <spawn+0x92>
		close(fd);
  80205c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802062:	89 04 24             	mov    %eax,(%esp)
  802065:	e8 bd f8 ff ff       	call   801927 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80206a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802071:	46 
  802072:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802078:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207c:	c7 04 24 7f 3a 80 00 	movl   $0x803a7f,(%esp)
  802083:	e8 22 e6 ff ff       	call   8006aa <cprintf>
		return -E_NOT_EXEC;
  802088:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80208d:	e9 0b 05 00 00       	jmp    80259d <spawn+0x59d>
  802092:	b8 07 00 00 00       	mov    $0x7,%eax
  802097:	cd 30                	int    $0x30
  802099:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80209f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8020a5:	85 c0                	test   %eax,%eax
  8020a7:	0f 88 99 04 00 00    	js     802546 <spawn+0x546>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8020ad:	89 c6                	mov    %eax,%esi
  8020af:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8020b5:	6b f6 7c             	imul   $0x7c,%esi,%esi
  8020b8:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8020be:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8020c4:	b9 11 00 00 00       	mov    $0x11,%ecx
  8020c9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8020cb:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8020d1:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8020d7:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8020dc:	be 00 00 00 00       	mov    $0x0,%esi
  8020e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8020e4:	eb 0f                	jmp    8020f5 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8020e6:	89 04 24             	mov    %eax,(%esp)
  8020e9:	e8 b2 eb ff ff       	call   800ca0 <strlen>
  8020ee:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8020f2:	83 c3 01             	add    $0x1,%ebx
  8020f5:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8020fc:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8020ff:	85 c0                	test   %eax,%eax
  802101:	75 e3                	jne    8020e6 <spawn+0xe6>
  802103:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802109:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80210f:	bf 00 10 40 00       	mov    $0x401000,%edi
  802114:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802116:	89 fa                	mov    %edi,%edx
  802118:	83 e2 fc             	and    $0xfffffffc,%edx
  80211b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802122:	29 c2                	sub    %eax,%edx
  802124:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80212a:	8d 42 f8             	lea    -0x8(%edx),%eax
  80212d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802132:	0f 86 1e 04 00 00    	jbe    802556 <spawn+0x556>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802138:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80213f:	00 
  802140:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802147:	00 
  802148:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80214f:	e8 9f ef ff ff       	call   8010f3 <sys_page_alloc>
  802154:	85 c0                	test   %eax,%eax
  802156:	0f 88 41 04 00 00    	js     80259d <spawn+0x59d>
  80215c:	be 00 00 00 00       	mov    $0x0,%esi
  802161:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  802167:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80216a:	eb 30                	jmp    80219c <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80216c:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802172:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802178:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  80217b:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80217e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802182:	89 3c 24             	mov    %edi,(%esp)
  802185:	e8 4d eb ff ff       	call   800cd7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  80218a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80218d:	89 04 24             	mov    %eax,(%esp)
  802190:	e8 0b eb ff ff       	call   800ca0 <strlen>
  802195:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802199:	83 c6 01             	add    $0x1,%esi
  80219c:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  8021a2:	7f c8                	jg     80216c <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8021a4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8021aa:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8021b0:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8021b7:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8021bd:	74 24                	je     8021e3 <spawn+0x1e3>
  8021bf:	c7 44 24 0c f4 3a 80 	movl   $0x803af4,0xc(%esp)
  8021c6:	00 
  8021c7:	c7 44 24 08 53 3a 80 	movl   $0x803a53,0x8(%esp)
  8021ce:	00 
  8021cf:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  8021d6:	00 
  8021d7:	c7 04 24 99 3a 80 00 	movl   $0x803a99,(%esp)
  8021de:	e8 ce e3 ff ff       	call   8005b1 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8021e3:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8021e9:	89 c8                	mov    %ecx,%eax
  8021eb:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8021f0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8021f3:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8021f9:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8021fc:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802202:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802208:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80220f:	00 
  802210:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802217:	ee 
  802218:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80221e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802222:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802229:	00 
  80222a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802231:	e8 11 ef ff ff       	call   801147 <sys_page_map>
  802236:	89 c3                	mov    %eax,%ebx
  802238:	85 c0                	test   %eax,%eax
  80223a:	0f 88 47 03 00 00    	js     802587 <spawn+0x587>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802240:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802247:	00 
  802248:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80224f:	e8 46 ef ff ff       	call   80119a <sys_page_unmap>
  802254:	89 c3                	mov    %eax,%ebx
  802256:	85 c0                	test   %eax,%eax
  802258:	0f 88 29 03 00 00    	js     802587 <spawn+0x587>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80225e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802264:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  80226b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802271:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802278:	00 00 00 
  80227b:	e9 b6 01 00 00       	jmp    802436 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  802280:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802286:	83 38 01             	cmpl   $0x1,(%eax)
  802289:	0f 85 99 01 00 00    	jne    802428 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80228f:	89 c2                	mov    %eax,%edx
  802291:	8b 40 18             	mov    0x18(%eax),%eax
  802294:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802297:	83 f8 01             	cmp    $0x1,%eax
  80229a:	19 c0                	sbb    %eax,%eax
  80229c:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8022a2:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  8022a9:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8022b0:	89 d0                	mov    %edx,%eax
  8022b2:	8b 7a 04             	mov    0x4(%edx),%edi
  8022b5:	89 bd 80 fd ff ff    	mov    %edi,-0x280(%ebp)
  8022bb:	8b 52 10             	mov    0x10(%edx),%edx
  8022be:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  8022c4:	8b 78 14             	mov    0x14(%eax),%edi
  8022c7:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  8022cd:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8022d0:	89 f0                	mov    %esi,%eax
  8022d2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022d7:	74 14                	je     8022ed <spawn+0x2ed>
		va -= i;
  8022d9:	29 c6                	sub    %eax,%esi
		memsz += i;
  8022db:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  8022e1:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  8022e7:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8022ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022f2:	e9 23 01 00 00       	jmp    80241a <spawn+0x41a>
		if (i >= filesz) {
  8022f7:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  8022fd:	77 2b                	ja     80232a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8022ff:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802305:	89 44 24 08          	mov    %eax,0x8(%esp)
  802309:	89 74 24 04          	mov    %esi,0x4(%esp)
  80230d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802313:	89 04 24             	mov    %eax,(%esp)
  802316:	e8 d8 ed ff ff       	call   8010f3 <sys_page_alloc>
  80231b:	85 c0                	test   %eax,%eax
  80231d:	0f 89 eb 00 00 00    	jns    80240e <spawn+0x40e>
  802323:	89 c3                	mov    %eax,%ebx
  802325:	e9 3d 02 00 00       	jmp    802567 <spawn+0x567>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80232a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802331:	00 
  802332:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802339:	00 
  80233a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802341:	e8 ad ed ff ff       	call   8010f3 <sys_page_alloc>
  802346:	85 c0                	test   %eax,%eax
  802348:	0f 88 0f 02 00 00    	js     80255d <spawn+0x55d>
  80234e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802354:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802356:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235a:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802360:	89 04 24             	mov    %eax,(%esp)
  802363:	e8 8c f8 ff ff       	call   801bf4 <seek>
  802368:	85 c0                	test   %eax,%eax
  80236a:	0f 88 f1 01 00 00    	js     802561 <spawn+0x561>
  802370:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802376:	29 f9                	sub    %edi,%ecx
  802378:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  80237a:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  802380:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802385:	0f 47 c1             	cmova  %ecx,%eax
  802388:	89 44 24 08          	mov    %eax,0x8(%esp)
  80238c:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802393:	00 
  802394:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80239a:	89 04 24             	mov    %eax,(%esp)
  80239d:	e8 7a f7 ff ff       	call   801b1c <readn>
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	0f 88 bb 01 00 00    	js     802565 <spawn+0x565>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8023aa:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8023b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8023b4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8023b8:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8023be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023c2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023c9:	00 
  8023ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d1:	e8 71 ed ff ff       	call   801147 <sys_page_map>
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	79 20                	jns    8023fa <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  8023da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023de:	c7 44 24 08 a5 3a 80 	movl   $0x803aa5,0x8(%esp)
  8023e5:	00 
  8023e6:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  8023ed:	00 
  8023ee:	c7 04 24 99 3a 80 00 	movl   $0x803a99,(%esp)
  8023f5:	e8 b7 e1 ff ff       	call   8005b1 <_panic>
			sys_page_unmap(0, UTEMP);
  8023fa:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802401:	00 
  802402:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802409:	e8 8c ed ff ff       	call   80119a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80240e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802414:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80241a:	89 df                	mov    %ebx,%edi
  80241c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  802422:	0f 87 cf fe ff ff    	ja     8022f7 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802428:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  80242f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802436:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80243d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  802443:	0f 8c 37 fe ff ff    	jl     802280 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802449:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80244f:	89 04 24             	mov    %eax,(%esp)
  802452:	e8 d0 f4 ff ff       	call   801927 <close>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  802457:	bb 00 00 00 00       	mov    $0x0,%ebx
  80245c:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	{
		if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U))&&((uvpt[i/PGSIZE]&(PTE_SHARE))==PTE_SHARE))
  802462:	89 d8                	mov    %ebx,%eax
  802464:	c1 e8 16             	shr    $0x16,%eax
  802467:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80246e:	a8 01                	test   $0x1,%al
  802470:	74 48                	je     8024ba <spawn+0x4ba>
  802472:	89 d8                	mov    %ebx,%eax
  802474:	c1 e8 0c             	shr    $0xc,%eax
  802477:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80247e:	83 e2 05             	and    $0x5,%edx
  802481:	83 fa 05             	cmp    $0x5,%edx
  802484:	75 34                	jne    8024ba <spawn+0x4ba>
  802486:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80248d:	f6 c6 04             	test   $0x4,%dh
  802490:	74 28                	je     8024ba <spawn+0x4ba>
		{
			//cprintf("in copy_shared_pages\n");
			//cprintf("%08x\n",PDX(i));
			sys_page_map(0,(void*)i,child,(void*)i,uvpt[i/PGSIZE]&PTE_SYSCALL);
  802492:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802499:	25 07 0e 00 00       	and    $0xe07,%eax
  80249e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8024a2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8024a6:	89 74 24 08          	mov    %esi,0x8(%esp)
  8024aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b5:	e8 8d ec ff ff       	call   801147 <sys_page_map>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  8024ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8024c0:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8024c6:	75 9a                	jne    802462 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8024c8:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8024ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d2:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8024d8:	89 04 24             	mov    %eax,(%esp)
  8024db:	e8 60 ed ff ff       	call   801240 <sys_env_set_trapframe>
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	79 20                	jns    802504 <spawn+0x504>
		panic("sys_env_set_trapframe: %e", r);
  8024e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024e8:	c7 44 24 08 c2 3a 80 	movl   $0x803ac2,0x8(%esp)
  8024ef:	00 
  8024f0:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  8024f7:	00 
  8024f8:	c7 04 24 99 3a 80 00 	movl   $0x803a99,(%esp)
  8024ff:	e8 ad e0 ff ff       	call   8005b1 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802504:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80250b:	00 
  80250c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802512:	89 04 24             	mov    %eax,(%esp)
  802515:	e8 d3 ec ff ff       	call   8011ed <sys_env_set_status>
  80251a:	85 c0                	test   %eax,%eax
  80251c:	79 30                	jns    80254e <spawn+0x54e>
		panic("sys_env_set_status: %e", r);
  80251e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802522:	c7 44 24 08 dc 3a 80 	movl   $0x803adc,0x8(%esp)
  802529:	00 
  80252a:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802531:	00 
  802532:	c7 04 24 99 3a 80 00 	movl   $0x803a99,(%esp)
  802539:	e8 73 e0 ff ff       	call   8005b1 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  80253e:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802544:	eb 57                	jmp    80259d <spawn+0x59d>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  802546:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80254c:	eb 4f                	jmp    80259d <spawn+0x59d>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  80254e:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802554:	eb 47                	jmp    80259d <spawn+0x59d>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802556:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80255b:	eb 40                	jmp    80259d <spawn+0x59d>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80255d:	89 c3                	mov    %eax,%ebx
  80255f:	eb 06                	jmp    802567 <spawn+0x567>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802561:	89 c3                	mov    %eax,%ebx
  802563:	eb 02                	jmp    802567 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802565:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  802567:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  80256d:	89 04 24             	mov    %eax,(%esp)
  802570:	e8 ee ea ff ff       	call   801063 <sys_env_destroy>
	close(fd);
  802575:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80257b:	89 04 24             	mov    %eax,(%esp)
  80257e:	e8 a4 f3 ff ff       	call   801927 <close>
	return r;
  802583:	89 d8                	mov    %ebx,%eax
  802585:	eb 16                	jmp    80259d <spawn+0x59d>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802587:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80258e:	00 
  80258f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802596:	e8 ff eb ff ff       	call   80119a <sys_page_unmap>
  80259b:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  80259d:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8025a3:	5b                   	pop    %ebx
  8025a4:	5e                   	pop    %esi
  8025a5:	5f                   	pop    %edi
  8025a6:	5d                   	pop    %ebp
  8025a7:	c3                   	ret    

008025a8 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	56                   	push   %esi
  8025ac:	53                   	push   %ebx
  8025ad:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025b0:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8025b3:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025b8:	eb 03                	jmp    8025bd <spawnl+0x15>
		argc++;
  8025ba:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8025bd:	83 c0 04             	add    $0x4,%eax
  8025c0:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8025c4:	75 f4                	jne    8025ba <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8025c6:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  8025cd:	83 e0 f0             	and    $0xfffffff0,%eax
  8025d0:	29 c4                	sub    %eax,%esp
  8025d2:	8d 44 24 0b          	lea    0xb(%esp),%eax
  8025d6:	c1 e8 02             	shr    $0x2,%eax
  8025d9:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  8025e0:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8025e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025e5:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  8025ec:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  8025f3:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8025f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f9:	eb 0a                	jmp    802605 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  8025fb:	83 c0 01             	add    $0x1,%eax
  8025fe:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802602:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802605:	39 d0                	cmp    %edx,%eax
  802607:	75 f2                	jne    8025fb <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802609:	89 74 24 04          	mov    %esi,0x4(%esp)
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	89 04 24             	mov    %eax,(%esp)
  802613:	e8 e8 f9 ff ff       	call   802000 <spawn>
}
  802618:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80261b:	5b                   	pop    %ebx
  80261c:	5e                   	pop    %esi
  80261d:	5d                   	pop    %ebp
  80261e:	c3                   	ret    
  80261f:	90                   	nop

00802620 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802626:	c7 44 24 04 1a 3b 80 	movl   $0x803b1a,0x4(%esp)
  80262d:	00 
  80262e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802631:	89 04 24             	mov    %eax,(%esp)
  802634:	e8 9e e6 ff ff       	call   800cd7 <strcpy>
	return 0;
}
  802639:	b8 00 00 00 00       	mov    $0x0,%eax
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	53                   	push   %ebx
  802644:	83 ec 14             	sub    $0x14,%esp
  802647:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80264a:	89 1c 24             	mov    %ebx,(%esp)
  80264d:	e8 50 0a 00 00       	call   8030a2 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802652:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802657:	83 f8 01             	cmp    $0x1,%eax
  80265a:	75 0d                	jne    802669 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80265c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80265f:	89 04 24             	mov    %eax,(%esp)
  802662:	e8 29 03 00 00       	call   802990 <nsipc_close>
  802667:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802669:	89 d0                	mov    %edx,%eax
  80266b:	83 c4 14             	add    $0x14,%esp
  80266e:	5b                   	pop    %ebx
  80266f:	5d                   	pop    %ebp
  802670:	c3                   	ret    

00802671 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802677:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80267e:	00 
  80267f:	8b 45 10             	mov    0x10(%ebp),%eax
  802682:	89 44 24 08          	mov    %eax,0x8(%esp)
  802686:	8b 45 0c             	mov    0xc(%ebp),%eax
  802689:	89 44 24 04          	mov    %eax,0x4(%esp)
  80268d:	8b 45 08             	mov    0x8(%ebp),%eax
  802690:	8b 40 0c             	mov    0xc(%eax),%eax
  802693:	89 04 24             	mov    %eax,(%esp)
  802696:	e8 f0 03 00 00       	call   802a8b <nsipc_send>
}
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
  8026a0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8026a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8026aa:	00 
  8026ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bf:	89 04 24             	mov    %eax,(%esp)
  8026c2:	e8 44 03 00 00       	call   802a0b <nsipc_recv>
}
  8026c7:	c9                   	leave  
  8026c8:	c3                   	ret    

008026c9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8026c9:	55                   	push   %ebp
  8026ca:	89 e5                	mov    %esp,%ebp
  8026cc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8026cf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8026d2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026d6:	89 04 24             	mov    %eax,(%esp)
  8026d9:	e8 18 f1 ff ff       	call   8017f6 <fd_lookup>
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	78 17                	js     8026f9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 0d 3c 40 80 00    	mov    0x80403c,%ecx
  8026eb:	39 08                	cmp    %ecx,(%eax)
  8026ed:	75 05                	jne    8026f4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8026ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f2:	eb 05                	jmp    8026f9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8026f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    

008026fb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8026fb:	55                   	push   %ebp
  8026fc:	89 e5                	mov    %esp,%ebp
  8026fe:	56                   	push   %esi
  8026ff:	53                   	push   %ebx
  802700:	83 ec 20             	sub    $0x20,%esp
  802703:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802705:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802708:	89 04 24             	mov    %eax,(%esp)
  80270b:	e8 97 f0 ff ff       	call   8017a7 <fd_alloc>
  802710:	89 c3                	mov    %eax,%ebx
  802712:	85 c0                	test   %eax,%eax
  802714:	78 21                	js     802737 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802716:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80271d:	00 
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	89 44 24 04          	mov    %eax,0x4(%esp)
  802725:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80272c:	e8 c2 e9 ff ff       	call   8010f3 <sys_page_alloc>
  802731:	89 c3                	mov    %eax,%ebx
  802733:	85 c0                	test   %eax,%eax
  802735:	79 0c                	jns    802743 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802737:	89 34 24             	mov    %esi,(%esp)
  80273a:	e8 51 02 00 00       	call   802990 <nsipc_close>
		return r;
  80273f:	89 d8                	mov    %ebx,%eax
  802741:	eb 20                	jmp    802763 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802743:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80274e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802751:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802758:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80275b:	89 14 24             	mov    %edx,(%esp)
  80275e:	e8 1d f0 ff ff       	call   801780 <fd2num>
}
  802763:	83 c4 20             	add    $0x20,%esp
  802766:	5b                   	pop    %ebx
  802767:	5e                   	pop    %esi
  802768:	5d                   	pop    %ebp
  802769:	c3                   	ret    

0080276a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802770:	8b 45 08             	mov    0x8(%ebp),%eax
  802773:	e8 51 ff ff ff       	call   8026c9 <fd2sockid>
		return r;
  802778:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80277a:	85 c0                	test   %eax,%eax
  80277c:	78 23                	js     8027a1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80277e:	8b 55 10             	mov    0x10(%ebp),%edx
  802781:	89 54 24 08          	mov    %edx,0x8(%esp)
  802785:	8b 55 0c             	mov    0xc(%ebp),%edx
  802788:	89 54 24 04          	mov    %edx,0x4(%esp)
  80278c:	89 04 24             	mov    %eax,(%esp)
  80278f:	e8 45 01 00 00       	call   8028d9 <nsipc_accept>
		return r;
  802794:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802796:	85 c0                	test   %eax,%eax
  802798:	78 07                	js     8027a1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80279a:	e8 5c ff ff ff       	call   8026fb <alloc_sockfd>
  80279f:	89 c1                	mov    %eax,%ecx
}
  8027a1:	89 c8                	mov    %ecx,%eax
  8027a3:	c9                   	leave  
  8027a4:	c3                   	ret    

008027a5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	e8 16 ff ff ff       	call   8026c9 <fd2sockid>
  8027b3:	89 c2                	mov    %eax,%edx
  8027b5:	85 d2                	test   %edx,%edx
  8027b7:	78 16                	js     8027cf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8027b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8027bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c7:	89 14 24             	mov    %edx,(%esp)
  8027ca:	e8 60 01 00 00       	call   80292f <nsipc_bind>
}
  8027cf:	c9                   	leave  
  8027d0:	c3                   	ret    

008027d1 <shutdown>:

int
shutdown(int s, int how)
{
  8027d1:	55                   	push   %ebp
  8027d2:	89 e5                	mov    %esp,%ebp
  8027d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027da:	e8 ea fe ff ff       	call   8026c9 <fd2sockid>
  8027df:	89 c2                	mov    %eax,%edx
  8027e1:	85 d2                	test   %edx,%edx
  8027e3:	78 0f                	js     8027f4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8027e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ec:	89 14 24             	mov    %edx,(%esp)
  8027ef:	e8 7a 01 00 00       	call   80296e <nsipc_shutdown>
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	e8 c5 fe ff ff       	call   8026c9 <fd2sockid>
  802804:	89 c2                	mov    %eax,%edx
  802806:	85 d2                	test   %edx,%edx
  802808:	78 16                	js     802820 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80280a:	8b 45 10             	mov    0x10(%ebp),%eax
  80280d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802811:	8b 45 0c             	mov    0xc(%ebp),%eax
  802814:	89 44 24 04          	mov    %eax,0x4(%esp)
  802818:	89 14 24             	mov    %edx,(%esp)
  80281b:	e8 8a 01 00 00       	call   8029aa <nsipc_connect>
}
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <listen>:

int
listen(int s, int backlog)
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
  802825:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	e8 99 fe ff ff       	call   8026c9 <fd2sockid>
  802830:	89 c2                	mov    %eax,%edx
  802832:	85 d2                	test   %edx,%edx
  802834:	78 0f                	js     802845 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802836:	8b 45 0c             	mov    0xc(%ebp),%eax
  802839:	89 44 24 04          	mov    %eax,0x4(%esp)
  80283d:	89 14 24             	mov    %edx,(%esp)
  802840:	e8 a4 01 00 00       	call   8029e9 <nsipc_listen>
}
  802845:	c9                   	leave  
  802846:	c3                   	ret    

00802847 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
  80284a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80284d:	8b 45 10             	mov    0x10(%ebp),%eax
  802850:	89 44 24 08          	mov    %eax,0x8(%esp)
  802854:	8b 45 0c             	mov    0xc(%ebp),%eax
  802857:	89 44 24 04          	mov    %eax,0x4(%esp)
  80285b:	8b 45 08             	mov    0x8(%ebp),%eax
  80285e:	89 04 24             	mov    %eax,(%esp)
  802861:	e8 98 02 00 00       	call   802afe <nsipc_socket>
  802866:	89 c2                	mov    %eax,%edx
  802868:	85 d2                	test   %edx,%edx
  80286a:	78 05                	js     802871 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80286c:	e8 8a fe ff ff       	call   8026fb <alloc_sockfd>
}
  802871:	c9                   	leave  
  802872:	c3                   	ret    

00802873 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802873:	55                   	push   %ebp
  802874:	89 e5                	mov    %esp,%ebp
  802876:	53                   	push   %ebx
  802877:	83 ec 14             	sub    $0x14,%esp
  80287a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80287c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802883:	75 11                	jne    802896 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802885:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80288c:	e8 d9 07 00 00       	call   80306a <ipc_find_env>
  802891:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802896:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80289d:	00 
  80289e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8028a5:	00 
  8028a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028aa:	a1 04 50 80 00       	mov    0x805004,%eax
  8028af:	89 04 24             	mov    %eax,(%esp)
  8028b2:	e8 55 07 00 00       	call   80300c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8028b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8028be:	00 
  8028bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8028c6:	00 
  8028c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ce:	e8 cf 06 00 00       	call   802fa2 <ipc_recv>
}
  8028d3:	83 c4 14             	add    $0x14,%esp
  8028d6:	5b                   	pop    %ebx
  8028d7:	5d                   	pop    %ebp
  8028d8:	c3                   	ret    

008028d9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
  8028dc:	56                   	push   %esi
  8028dd:	53                   	push   %ebx
  8028de:	83 ec 10             	sub    $0x10,%esp
  8028e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8028e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8028ec:	8b 06                	mov    (%esi),%eax
  8028ee:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8028f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f8:	e8 76 ff ff ff       	call   802873 <nsipc>
  8028fd:	89 c3                	mov    %eax,%ebx
  8028ff:	85 c0                	test   %eax,%eax
  802901:	78 23                	js     802926 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802903:	a1 10 70 80 00       	mov    0x807010,%eax
  802908:	89 44 24 08          	mov    %eax,0x8(%esp)
  80290c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802913:	00 
  802914:	8b 45 0c             	mov    0xc(%ebp),%eax
  802917:	89 04 24             	mov    %eax,(%esp)
  80291a:	e8 55 e5 ff ff       	call   800e74 <memmove>
		*addrlen = ret->ret_addrlen;
  80291f:	a1 10 70 80 00       	mov    0x807010,%eax
  802924:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802926:	89 d8                	mov    %ebx,%eax
  802928:	83 c4 10             	add    $0x10,%esp
  80292b:	5b                   	pop    %ebx
  80292c:	5e                   	pop    %esi
  80292d:	5d                   	pop    %ebp
  80292e:	c3                   	ret    

0080292f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80292f:	55                   	push   %ebp
  802930:	89 e5                	mov    %esp,%ebp
  802932:	53                   	push   %ebx
  802933:	83 ec 14             	sub    $0x14,%esp
  802936:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802941:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802945:	8b 45 0c             	mov    0xc(%ebp),%eax
  802948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80294c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802953:	e8 1c e5 ff ff       	call   800e74 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802958:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80295e:	b8 02 00 00 00       	mov    $0x2,%eax
  802963:	e8 0b ff ff ff       	call   802873 <nsipc>
}
  802968:	83 c4 14             	add    $0x14,%esp
  80296b:	5b                   	pop    %ebx
  80296c:	5d                   	pop    %ebp
  80296d:	c3                   	ret    

0080296e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802974:	8b 45 08             	mov    0x8(%ebp),%eax
  802977:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80297c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80297f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802984:	b8 03 00 00 00       	mov    $0x3,%eax
  802989:	e8 e5 fe ff ff       	call   802873 <nsipc>
}
  80298e:	c9                   	leave  
  80298f:	c3                   	ret    

00802990 <nsipc_close>:

int
nsipc_close(int s)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80299e:	b8 04 00 00 00       	mov    $0x4,%eax
  8029a3:	e8 cb fe ff ff       	call   802873 <nsipc>
}
  8029a8:	c9                   	leave  
  8029a9:	c3                   	ret    

008029aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8029aa:	55                   	push   %ebp
  8029ab:	89 e5                	mov    %esp,%ebp
  8029ad:	53                   	push   %ebx
  8029ae:	83 ec 14             	sub    $0x14,%esp
  8029b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8029bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8029ce:	e8 a1 e4 ff ff       	call   800e74 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8029d3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8029d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8029de:	e8 90 fe ff ff       	call   802873 <nsipc>
}
  8029e3:	83 c4 14             	add    $0x14,%esp
  8029e6:	5b                   	pop    %ebx
  8029e7:	5d                   	pop    %ebp
  8029e8:	c3                   	ret    

008029e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8029e9:	55                   	push   %ebp
  8029ea:	89 e5                	mov    %esp,%ebp
  8029ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8029f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029fa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8029ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802a04:	e8 6a fe ff ff       	call   802873 <nsipc>
}
  802a09:	c9                   	leave  
  802a0a:	c3                   	ret    

00802a0b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802a0b:	55                   	push   %ebp
  802a0c:	89 e5                	mov    %esp,%ebp
  802a0e:	56                   	push   %esi
  802a0f:	53                   	push   %ebx
  802a10:	83 ec 10             	sub    $0x10,%esp
  802a13:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  802a1e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802a24:	8b 45 14             	mov    0x14(%ebp),%eax
  802a27:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802a2c:	b8 07 00 00 00       	mov    $0x7,%eax
  802a31:	e8 3d fe ff ff       	call   802873 <nsipc>
  802a36:	89 c3                	mov    %eax,%ebx
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	78 46                	js     802a82 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802a3c:	39 f0                	cmp    %esi,%eax
  802a3e:	7f 07                	jg     802a47 <nsipc_recv+0x3c>
  802a40:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802a45:	7e 24                	jle    802a6b <nsipc_recv+0x60>
  802a47:	c7 44 24 0c 26 3b 80 	movl   $0x803b26,0xc(%esp)
  802a4e:	00 
  802a4f:	c7 44 24 08 53 3a 80 	movl   $0x803a53,0x8(%esp)
  802a56:	00 
  802a57:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802a5e:	00 
  802a5f:	c7 04 24 3b 3b 80 00 	movl   $0x803b3b,(%esp)
  802a66:	e8 46 db ff ff       	call   8005b1 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802a6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a6f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802a76:	00 
  802a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a7a:	89 04 24             	mov    %eax,(%esp)
  802a7d:	e8 f2 e3 ff ff       	call   800e74 <memmove>
	}

	return r;
}
  802a82:	89 d8                	mov    %ebx,%eax
  802a84:	83 c4 10             	add    $0x10,%esp
  802a87:	5b                   	pop    %ebx
  802a88:	5e                   	pop    %esi
  802a89:	5d                   	pop    %ebp
  802a8a:	c3                   	ret    

00802a8b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802a8b:	55                   	push   %ebp
  802a8c:	89 e5                	mov    %esp,%ebp
  802a8e:	53                   	push   %ebx
  802a8f:	83 ec 14             	sub    $0x14,%esp
  802a92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  802a9d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802aa3:	7e 24                	jle    802ac9 <nsipc_send+0x3e>
  802aa5:	c7 44 24 0c 47 3b 80 	movl   $0x803b47,0xc(%esp)
  802aac:	00 
  802aad:	c7 44 24 08 53 3a 80 	movl   $0x803a53,0x8(%esp)
  802ab4:	00 
  802ab5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802abc:	00 
  802abd:	c7 04 24 3b 3b 80 00 	movl   $0x803b3b,(%esp)
  802ac4:	e8 e8 da ff ff       	call   8005b1 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802ac9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  802adb:	e8 94 e3 ff ff       	call   800e74 <memmove>
	nsipcbuf.send.req_size = size;
  802ae0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  802ae9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  802aee:	b8 08 00 00 00       	mov    $0x8,%eax
  802af3:	e8 7b fd ff ff       	call   802873 <nsipc>
}
  802af8:	83 c4 14             	add    $0x14,%esp
  802afb:	5b                   	pop    %ebx
  802afc:	5d                   	pop    %ebp
  802afd:	c3                   	ret    

00802afe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802afe:	55                   	push   %ebp
  802aff:	89 e5                	mov    %esp,%ebp
  802b01:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  802b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b0f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802b14:	8b 45 10             	mov    0x10(%ebp),%eax
  802b17:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  802b1c:	b8 09 00 00 00       	mov    $0x9,%eax
  802b21:	e8 4d fd ff ff       	call   802873 <nsipc>
}
  802b26:	c9                   	leave  
  802b27:	c3                   	ret    

00802b28 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802b28:	55                   	push   %ebp
  802b29:	89 e5                	mov    %esp,%ebp
  802b2b:	56                   	push   %esi
  802b2c:	53                   	push   %ebx
  802b2d:	83 ec 10             	sub    $0x10,%esp
  802b30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	89 04 24             	mov    %eax,(%esp)
  802b39:	e8 52 ec ff ff       	call   801790 <fd2data>
  802b3e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802b40:	c7 44 24 04 53 3b 80 	movl   $0x803b53,0x4(%esp)
  802b47:	00 
  802b48:	89 1c 24             	mov    %ebx,(%esp)
  802b4b:	e8 87 e1 ff ff       	call   800cd7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802b50:	8b 46 04             	mov    0x4(%esi),%eax
  802b53:	2b 06                	sub    (%esi),%eax
  802b55:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802b5b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802b62:	00 00 00 
	stat->st_dev = &devpipe;
  802b65:	c7 83 88 00 00 00 58 	movl   $0x804058,0x88(%ebx)
  802b6c:	40 80 00 
	return 0;
}
  802b6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b74:	83 c4 10             	add    $0x10,%esp
  802b77:	5b                   	pop    %ebx
  802b78:	5e                   	pop    %esi
  802b79:	5d                   	pop    %ebp
  802b7a:	c3                   	ret    

00802b7b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802b7b:	55                   	push   %ebp
  802b7c:	89 e5                	mov    %esp,%ebp
  802b7e:	53                   	push   %ebx
  802b7f:	83 ec 14             	sub    $0x14,%esp
  802b82:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802b85:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b90:	e8 05 e6 ff ff       	call   80119a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802b95:	89 1c 24             	mov    %ebx,(%esp)
  802b98:	e8 f3 eb ff ff       	call   801790 <fd2data>
  802b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ba1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ba8:	e8 ed e5 ff ff       	call   80119a <sys_page_unmap>
}
  802bad:	83 c4 14             	add    $0x14,%esp
  802bb0:	5b                   	pop    %ebx
  802bb1:	5d                   	pop    %ebp
  802bb2:	c3                   	ret    

00802bb3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802bb3:	55                   	push   %ebp
  802bb4:	89 e5                	mov    %esp,%ebp
  802bb6:	57                   	push   %edi
  802bb7:	56                   	push   %esi
  802bb8:	53                   	push   %ebx
  802bb9:	83 ec 2c             	sub    $0x2c,%esp
  802bbc:	89 c6                	mov    %eax,%esi
  802bbe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802bc1:	a1 08 50 80 00       	mov    0x805008,%eax
  802bc6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802bc9:	89 34 24             	mov    %esi,(%esp)
  802bcc:	e8 d1 04 00 00       	call   8030a2 <pageref>
  802bd1:	89 c7                	mov    %eax,%edi
  802bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bd6:	89 04 24             	mov    %eax,(%esp)
  802bd9:	e8 c4 04 00 00       	call   8030a2 <pageref>
  802bde:	39 c7                	cmp    %eax,%edi
  802be0:	0f 94 c2             	sete   %dl
  802be3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802be6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  802bec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802bef:	39 fb                	cmp    %edi,%ebx
  802bf1:	74 21                	je     802c14 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802bf3:	84 d2                	test   %dl,%dl
  802bf5:	74 ca                	je     802bc1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802bf7:	8b 51 58             	mov    0x58(%ecx),%edx
  802bfa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bfe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802c06:	c7 04 24 5a 3b 80 00 	movl   $0x803b5a,(%esp)
  802c0d:	e8 98 da ff ff       	call   8006aa <cprintf>
  802c12:	eb ad                	jmp    802bc1 <_pipeisclosed+0xe>
	}
}
  802c14:	83 c4 2c             	add    $0x2c,%esp
  802c17:	5b                   	pop    %ebx
  802c18:	5e                   	pop    %esi
  802c19:	5f                   	pop    %edi
  802c1a:	5d                   	pop    %ebp
  802c1b:	c3                   	ret    

00802c1c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
  802c1f:	57                   	push   %edi
  802c20:	56                   	push   %esi
  802c21:	53                   	push   %ebx
  802c22:	83 ec 1c             	sub    $0x1c,%esp
  802c25:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802c28:	89 34 24             	mov    %esi,(%esp)
  802c2b:	e8 60 eb ff ff       	call   801790 <fd2data>
  802c30:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c32:	bf 00 00 00 00       	mov    $0x0,%edi
  802c37:	eb 45                	jmp    802c7e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802c39:	89 da                	mov    %ebx,%edx
  802c3b:	89 f0                	mov    %esi,%eax
  802c3d:	e8 71 ff ff ff       	call   802bb3 <_pipeisclosed>
  802c42:	85 c0                	test   %eax,%eax
  802c44:	75 41                	jne    802c87 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802c46:	e8 89 e4 ff ff       	call   8010d4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802c4b:	8b 43 04             	mov    0x4(%ebx),%eax
  802c4e:	8b 0b                	mov    (%ebx),%ecx
  802c50:	8d 51 20             	lea    0x20(%ecx),%edx
  802c53:	39 d0                	cmp    %edx,%eax
  802c55:	73 e2                	jae    802c39 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802c57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c5a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802c5e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802c61:	99                   	cltd   
  802c62:	c1 ea 1b             	shr    $0x1b,%edx
  802c65:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802c68:	83 e1 1f             	and    $0x1f,%ecx
  802c6b:	29 d1                	sub    %edx,%ecx
  802c6d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802c71:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802c75:	83 c0 01             	add    $0x1,%eax
  802c78:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c7b:	83 c7 01             	add    $0x1,%edi
  802c7e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802c81:	75 c8                	jne    802c4b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802c83:	89 f8                	mov    %edi,%eax
  802c85:	eb 05                	jmp    802c8c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802c87:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802c8c:	83 c4 1c             	add    $0x1c,%esp
  802c8f:	5b                   	pop    %ebx
  802c90:	5e                   	pop    %esi
  802c91:	5f                   	pop    %edi
  802c92:	5d                   	pop    %ebp
  802c93:	c3                   	ret    

00802c94 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
  802c97:	57                   	push   %edi
  802c98:	56                   	push   %esi
  802c99:	53                   	push   %ebx
  802c9a:	83 ec 1c             	sub    $0x1c,%esp
  802c9d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802ca0:	89 3c 24             	mov    %edi,(%esp)
  802ca3:	e8 e8 ea ff ff       	call   801790 <fd2data>
  802ca8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802caa:	be 00 00 00 00       	mov    $0x0,%esi
  802caf:	eb 3d                	jmp    802cee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802cb1:	85 f6                	test   %esi,%esi
  802cb3:	74 04                	je     802cb9 <devpipe_read+0x25>
				return i;
  802cb5:	89 f0                	mov    %esi,%eax
  802cb7:	eb 43                	jmp    802cfc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802cb9:	89 da                	mov    %ebx,%edx
  802cbb:	89 f8                	mov    %edi,%eax
  802cbd:	e8 f1 fe ff ff       	call   802bb3 <_pipeisclosed>
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	75 31                	jne    802cf7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802cc6:	e8 09 e4 ff ff       	call   8010d4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802ccb:	8b 03                	mov    (%ebx),%eax
  802ccd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802cd0:	74 df                	je     802cb1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802cd2:	99                   	cltd   
  802cd3:	c1 ea 1b             	shr    $0x1b,%edx
  802cd6:	01 d0                	add    %edx,%eax
  802cd8:	83 e0 1f             	and    $0x1f,%eax
  802cdb:	29 d0                	sub    %edx,%eax
  802cdd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802ce2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ce5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802ce8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ceb:	83 c6 01             	add    $0x1,%esi
  802cee:	3b 75 10             	cmp    0x10(%ebp),%esi
  802cf1:	75 d8                	jne    802ccb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802cf3:	89 f0                	mov    %esi,%eax
  802cf5:	eb 05                	jmp    802cfc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802cf7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802cfc:	83 c4 1c             	add    $0x1c,%esp
  802cff:	5b                   	pop    %ebx
  802d00:	5e                   	pop    %esi
  802d01:	5f                   	pop    %edi
  802d02:	5d                   	pop    %ebp
  802d03:	c3                   	ret    

00802d04 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802d04:	55                   	push   %ebp
  802d05:	89 e5                	mov    %esp,%ebp
  802d07:	56                   	push   %esi
  802d08:	53                   	push   %ebx
  802d09:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802d0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d0f:	89 04 24             	mov    %eax,(%esp)
  802d12:	e8 90 ea ff ff       	call   8017a7 <fd_alloc>
  802d17:	89 c2                	mov    %eax,%edx
  802d19:	85 d2                	test   %edx,%edx
  802d1b:	0f 88 4d 01 00 00    	js     802e6e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d21:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d28:	00 
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d37:	e8 b7 e3 ff ff       	call   8010f3 <sys_page_alloc>
  802d3c:	89 c2                	mov    %eax,%edx
  802d3e:	85 d2                	test   %edx,%edx
  802d40:	0f 88 28 01 00 00    	js     802e6e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802d46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802d49:	89 04 24             	mov    %eax,(%esp)
  802d4c:	e8 56 ea ff ff       	call   8017a7 <fd_alloc>
  802d51:	89 c3                	mov    %eax,%ebx
  802d53:	85 c0                	test   %eax,%eax
  802d55:	0f 88 fe 00 00 00    	js     802e59 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d5b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d62:	00 
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d71:	e8 7d e3 ff ff       	call   8010f3 <sys_page_alloc>
  802d76:	89 c3                	mov    %eax,%ebx
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	0f 88 d9 00 00 00    	js     802e59 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	89 04 24             	mov    %eax,(%esp)
  802d86:	e8 05 ea ff ff       	call   801790 <fd2data>
  802d8b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d8d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d94:	00 
  802d95:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802da0:	e8 4e e3 ff ff       	call   8010f3 <sys_page_alloc>
  802da5:	89 c3                	mov    %eax,%ebx
  802da7:	85 c0                	test   %eax,%eax
  802da9:	0f 88 97 00 00 00    	js     802e46 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	89 04 24             	mov    %eax,(%esp)
  802db5:	e8 d6 e9 ff ff       	call   801790 <fd2data>
  802dba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802dc1:	00 
  802dc2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802dc6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802dcd:	00 
  802dce:	89 74 24 04          	mov    %esi,0x4(%esp)
  802dd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dd9:	e8 69 e3 ff ff       	call   801147 <sys_page_map>
  802dde:	89 c3                	mov    %eax,%ebx
  802de0:	85 c0                	test   %eax,%eax
  802de2:	78 52                	js     802e36 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802de4:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802df9:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e02:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e07:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	89 04 24             	mov    %eax,(%esp)
  802e14:	e8 67 e9 ff ff       	call   801780 <fd2num>
  802e19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e1c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e21:	89 04 24             	mov    %eax,(%esp)
  802e24:	e8 57 e9 ff ff       	call   801780 <fd2num>
  802e29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e2c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e34:	eb 38                	jmp    802e6e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802e36:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e41:	e8 54 e3 ff ff       	call   80119a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e4d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e54:	e8 41 e3 ff ff       	call   80119a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e67:	e8 2e e3 ff ff       	call   80119a <sys_page_unmap>
  802e6c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802e6e:	83 c4 30             	add    $0x30,%esp
  802e71:	5b                   	pop    %ebx
  802e72:	5e                   	pop    %esi
  802e73:	5d                   	pop    %ebp
  802e74:	c3                   	ret    

00802e75 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802e75:	55                   	push   %ebp
  802e76:	89 e5                	mov    %esp,%ebp
  802e78:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	89 04 24             	mov    %eax,(%esp)
  802e88:	e8 69 e9 ff ff       	call   8017f6 <fd_lookup>
  802e8d:	89 c2                	mov    %eax,%edx
  802e8f:	85 d2                	test   %edx,%edx
  802e91:	78 15                	js     802ea8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	89 04 24             	mov    %eax,(%esp)
  802e99:	e8 f2 e8 ff ff       	call   801790 <fd2data>
	return _pipeisclosed(fd, p);
  802e9e:	89 c2                	mov    %eax,%edx
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	e8 0b fd ff ff       	call   802bb3 <_pipeisclosed>
}
  802ea8:	c9                   	leave  
  802ea9:	c3                   	ret    

00802eaa <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802eaa:	55                   	push   %ebp
  802eab:	89 e5                	mov    %esp,%ebp
  802ead:	56                   	push   %esi
  802eae:	53                   	push   %ebx
  802eaf:	83 ec 10             	sub    $0x10,%esp
  802eb2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802eb5:	85 f6                	test   %esi,%esi
  802eb7:	75 24                	jne    802edd <wait+0x33>
  802eb9:	c7 44 24 0c 72 3b 80 	movl   $0x803b72,0xc(%esp)
  802ec0:	00 
  802ec1:	c7 44 24 08 53 3a 80 	movl   $0x803a53,0x8(%esp)
  802ec8:	00 
  802ec9:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802ed0:	00 
  802ed1:	c7 04 24 7d 3b 80 00 	movl   $0x803b7d,(%esp)
  802ed8:	e8 d4 d6 ff ff       	call   8005b1 <_panic>
	e = &envs[ENVX(envid)];
  802edd:	89 f3                	mov    %esi,%ebx
  802edf:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802ee5:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802ee8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802eee:	eb 05                	jmp    802ef5 <wait+0x4b>
		sys_yield();
  802ef0:	e8 df e1 ff ff       	call   8010d4 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802ef5:	8b 43 48             	mov    0x48(%ebx),%eax
  802ef8:	39 f0                	cmp    %esi,%eax
  802efa:	75 07                	jne    802f03 <wait+0x59>
  802efc:	8b 43 54             	mov    0x54(%ebx),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	75 ed                	jne    802ef0 <wait+0x46>
		sys_yield();
}
  802f03:	83 c4 10             	add    $0x10,%esp
  802f06:	5b                   	pop    %ebx
  802f07:	5e                   	pop    %esi
  802f08:	5d                   	pop    %ebp
  802f09:	c3                   	ret    

00802f0a <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802f0a:	55                   	push   %ebp
  802f0b:	89 e5                	mov    %esp,%ebp
  802f0d:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802f10:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802f17:	75 58                	jne    802f71 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802f19:	a1 08 50 80 00       	mov    0x805008,%eax
  802f1e:	8b 40 48             	mov    0x48(%eax),%eax
  802f21:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802f28:	00 
  802f29:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802f30:	ee 
  802f31:	89 04 24             	mov    %eax,(%esp)
  802f34:	e8 ba e1 ff ff       	call   8010f3 <sys_page_alloc>
		if(return_code!=0)
  802f39:	85 c0                	test   %eax,%eax
  802f3b:	74 1c                	je     802f59 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802f3d:	c7 44 24 08 88 3b 80 	movl   $0x803b88,0x8(%esp)
  802f44:	00 
  802f45:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802f4c:	00 
  802f4d:	c7 04 24 e4 3b 80 00 	movl   $0x803be4,(%esp)
  802f54:	e8 58 d6 ff ff       	call   8005b1 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802f59:	a1 08 50 80 00       	mov    0x805008,%eax
  802f5e:	8b 40 48             	mov    0x48(%eax),%eax
  802f61:	c7 44 24 04 7b 2f 80 	movl   $0x802f7b,0x4(%esp)
  802f68:	00 
  802f69:	89 04 24             	mov    %eax,(%esp)
  802f6c:	e8 22 e3 ff ff       	call   801293 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802f7b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802f7c:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802f81:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802f83:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802f86:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  802f88:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  802f8c:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  802f90:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  802f91:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  802f93:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802f95:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  802f99:	58                   	pop    %eax
	popl %eax;
  802f9a:	58                   	pop    %eax
	popal;
  802f9b:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  802f9c:	83 c4 04             	add    $0x4,%esp
	popfl;
  802f9f:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802fa0:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  802fa1:	c3                   	ret    

00802fa2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802fa2:	55                   	push   %ebp
  802fa3:	89 e5                	mov    %esp,%ebp
  802fa5:	56                   	push   %esi
  802fa6:	53                   	push   %ebx
  802fa7:	83 ec 10             	sub    $0x10,%esp
  802faa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb0:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802fb3:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802fb5:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802fba:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802fbd:	89 04 24             	mov    %eax,(%esp)
  802fc0:	e8 44 e3 ff ff       	call   801309 <sys_ipc_recv>
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	75 1e                	jne    802fe7 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802fc9:	85 db                	test   %ebx,%ebx
  802fcb:	74 0a                	je     802fd7 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802fcd:	a1 08 50 80 00       	mov    0x805008,%eax
  802fd2:	8b 40 74             	mov    0x74(%eax),%eax
  802fd5:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802fd7:	85 f6                	test   %esi,%esi
  802fd9:	74 22                	je     802ffd <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802fdb:	a1 08 50 80 00       	mov    0x805008,%eax
  802fe0:	8b 40 78             	mov    0x78(%eax),%eax
  802fe3:	89 06                	mov    %eax,(%esi)
  802fe5:	eb 16                	jmp    802ffd <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802fe7:	85 f6                	test   %esi,%esi
  802fe9:	74 06                	je     802ff1 <ipc_recv+0x4f>
				*perm_store = 0;
  802feb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802ff1:	85 db                	test   %ebx,%ebx
  802ff3:	74 10                	je     803005 <ipc_recv+0x63>
				*from_env_store=0;
  802ff5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802ffb:	eb 08                	jmp    803005 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802ffd:	a1 08 50 80 00       	mov    0x805008,%eax
  803002:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  803005:	83 c4 10             	add    $0x10,%esp
  803008:	5b                   	pop    %ebx
  803009:	5e                   	pop    %esi
  80300a:	5d                   	pop    %ebp
  80300b:	c3                   	ret    

0080300c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80300c:	55                   	push   %ebp
  80300d:	89 e5                	mov    %esp,%ebp
  80300f:	57                   	push   %edi
  803010:	56                   	push   %esi
  803011:	53                   	push   %ebx
  803012:	83 ec 1c             	sub    $0x1c,%esp
  803015:	8b 75 0c             	mov    0xc(%ebp),%esi
  803018:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80301b:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  80301e:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  803020:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  803025:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  803028:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80302c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803030:	89 74 24 04          	mov    %esi,0x4(%esp)
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	89 04 24             	mov    %eax,(%esp)
  80303a:	e8 a7 e2 ff ff       	call   8012e6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  80303f:	eb 1c                	jmp    80305d <ipc_send+0x51>
	{
		sys_yield();
  803041:	e8 8e e0 ff ff       	call   8010d4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  803046:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80304a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80304e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	89 04 24             	mov    %eax,(%esp)
  803058:	e8 89 e2 ff ff       	call   8012e6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  80305d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803060:	74 df                	je     803041 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  803062:	83 c4 1c             	add    $0x1c,%esp
  803065:	5b                   	pop    %ebx
  803066:	5e                   	pop    %esi
  803067:	5f                   	pop    %edi
  803068:	5d                   	pop    %ebp
  803069:	c3                   	ret    

0080306a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80306a:	55                   	push   %ebp
  80306b:	89 e5                	mov    %esp,%ebp
  80306d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  803070:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803075:	6b d0 7c             	imul   $0x7c,%eax,%edx
  803078:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80307e:	8b 52 50             	mov    0x50(%edx),%edx
  803081:	39 ca                	cmp    %ecx,%edx
  803083:	75 0d                	jne    803092 <ipc_find_env+0x28>
			return envs[i].env_id;
  803085:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803088:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80308d:	8b 40 40             	mov    0x40(%eax),%eax
  803090:	eb 0e                	jmp    8030a0 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803092:	83 c0 01             	add    $0x1,%eax
  803095:	3d 00 04 00 00       	cmp    $0x400,%eax
  80309a:	75 d9                	jne    803075 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  80309c:	66 b8 00 00          	mov    $0x0,%ax
}
  8030a0:	5d                   	pop    %ebp
  8030a1:	c3                   	ret    

008030a2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8030a2:	55                   	push   %ebp
  8030a3:	89 e5                	mov    %esp,%ebp
  8030a5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8030a8:	89 d0                	mov    %edx,%eax
  8030aa:	c1 e8 16             	shr    $0x16,%eax
  8030ad:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8030b4:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8030b9:	f6 c1 01             	test   $0x1,%cl
  8030bc:	74 1d                	je     8030db <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8030be:	c1 ea 0c             	shr    $0xc,%edx
  8030c1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8030c8:	f6 c2 01             	test   $0x1,%dl
  8030cb:	74 0e                	je     8030db <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8030cd:	c1 ea 0c             	shr    $0xc,%edx
  8030d0:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8030d7:	ef 
  8030d8:	0f b7 c0             	movzwl %ax,%eax
}
  8030db:	5d                   	pop    %ebp
  8030dc:	c3                   	ret    
  8030dd:	66 90                	xchg   %ax,%ax
  8030df:	90                   	nop

008030e0 <__udivdi3>:
  8030e0:	55                   	push   %ebp
  8030e1:	57                   	push   %edi
  8030e2:	56                   	push   %esi
  8030e3:	83 ec 0c             	sub    $0xc,%esp
  8030e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8030ea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8030ee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8030f2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8030fc:	89 ea                	mov    %ebp,%edx
  8030fe:	89 0c 24             	mov    %ecx,(%esp)
  803101:	75 2d                	jne    803130 <__udivdi3+0x50>
  803103:	39 e9                	cmp    %ebp,%ecx
  803105:	77 61                	ja     803168 <__udivdi3+0x88>
  803107:	85 c9                	test   %ecx,%ecx
  803109:	89 ce                	mov    %ecx,%esi
  80310b:	75 0b                	jne    803118 <__udivdi3+0x38>
  80310d:	b8 01 00 00 00       	mov    $0x1,%eax
  803112:	31 d2                	xor    %edx,%edx
  803114:	f7 f1                	div    %ecx
  803116:	89 c6                	mov    %eax,%esi
  803118:	31 d2                	xor    %edx,%edx
  80311a:	89 e8                	mov    %ebp,%eax
  80311c:	f7 f6                	div    %esi
  80311e:	89 c5                	mov    %eax,%ebp
  803120:	89 f8                	mov    %edi,%eax
  803122:	f7 f6                	div    %esi
  803124:	89 ea                	mov    %ebp,%edx
  803126:	83 c4 0c             	add    $0xc,%esp
  803129:	5e                   	pop    %esi
  80312a:	5f                   	pop    %edi
  80312b:	5d                   	pop    %ebp
  80312c:	c3                   	ret    
  80312d:	8d 76 00             	lea    0x0(%esi),%esi
  803130:	39 e8                	cmp    %ebp,%eax
  803132:	77 24                	ja     803158 <__udivdi3+0x78>
  803134:	0f bd e8             	bsr    %eax,%ebp
  803137:	83 f5 1f             	xor    $0x1f,%ebp
  80313a:	75 3c                	jne    803178 <__udivdi3+0x98>
  80313c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803140:	39 34 24             	cmp    %esi,(%esp)
  803143:	0f 86 9f 00 00 00    	jbe    8031e8 <__udivdi3+0x108>
  803149:	39 d0                	cmp    %edx,%eax
  80314b:	0f 82 97 00 00 00    	jb     8031e8 <__udivdi3+0x108>
  803151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803158:	31 d2                	xor    %edx,%edx
  80315a:	31 c0                	xor    %eax,%eax
  80315c:	83 c4 0c             	add    $0xc,%esp
  80315f:	5e                   	pop    %esi
  803160:	5f                   	pop    %edi
  803161:	5d                   	pop    %ebp
  803162:	c3                   	ret    
  803163:	90                   	nop
  803164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803168:	89 f8                	mov    %edi,%eax
  80316a:	f7 f1                	div    %ecx
  80316c:	31 d2                	xor    %edx,%edx
  80316e:	83 c4 0c             	add    $0xc,%esp
  803171:	5e                   	pop    %esi
  803172:	5f                   	pop    %edi
  803173:	5d                   	pop    %ebp
  803174:	c3                   	ret    
  803175:	8d 76 00             	lea    0x0(%esi),%esi
  803178:	89 e9                	mov    %ebp,%ecx
  80317a:	8b 3c 24             	mov    (%esp),%edi
  80317d:	d3 e0                	shl    %cl,%eax
  80317f:	89 c6                	mov    %eax,%esi
  803181:	b8 20 00 00 00       	mov    $0x20,%eax
  803186:	29 e8                	sub    %ebp,%eax
  803188:	89 c1                	mov    %eax,%ecx
  80318a:	d3 ef                	shr    %cl,%edi
  80318c:	89 e9                	mov    %ebp,%ecx
  80318e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803192:	8b 3c 24             	mov    (%esp),%edi
  803195:	09 74 24 08          	or     %esi,0x8(%esp)
  803199:	89 d6                	mov    %edx,%esi
  80319b:	d3 e7                	shl    %cl,%edi
  80319d:	89 c1                	mov    %eax,%ecx
  80319f:	89 3c 24             	mov    %edi,(%esp)
  8031a2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8031a6:	d3 ee                	shr    %cl,%esi
  8031a8:	89 e9                	mov    %ebp,%ecx
  8031aa:	d3 e2                	shl    %cl,%edx
  8031ac:	89 c1                	mov    %eax,%ecx
  8031ae:	d3 ef                	shr    %cl,%edi
  8031b0:	09 d7                	or     %edx,%edi
  8031b2:	89 f2                	mov    %esi,%edx
  8031b4:	89 f8                	mov    %edi,%eax
  8031b6:	f7 74 24 08          	divl   0x8(%esp)
  8031ba:	89 d6                	mov    %edx,%esi
  8031bc:	89 c7                	mov    %eax,%edi
  8031be:	f7 24 24             	mull   (%esp)
  8031c1:	39 d6                	cmp    %edx,%esi
  8031c3:	89 14 24             	mov    %edx,(%esp)
  8031c6:	72 30                	jb     8031f8 <__udivdi3+0x118>
  8031c8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031cc:	89 e9                	mov    %ebp,%ecx
  8031ce:	d3 e2                	shl    %cl,%edx
  8031d0:	39 c2                	cmp    %eax,%edx
  8031d2:	73 05                	jae    8031d9 <__udivdi3+0xf9>
  8031d4:	3b 34 24             	cmp    (%esp),%esi
  8031d7:	74 1f                	je     8031f8 <__udivdi3+0x118>
  8031d9:	89 f8                	mov    %edi,%eax
  8031db:	31 d2                	xor    %edx,%edx
  8031dd:	e9 7a ff ff ff       	jmp    80315c <__udivdi3+0x7c>
  8031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8031e8:	31 d2                	xor    %edx,%edx
  8031ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ef:	e9 68 ff ff ff       	jmp    80315c <__udivdi3+0x7c>
  8031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8031f8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8031fb:	31 d2                	xor    %edx,%edx
  8031fd:	83 c4 0c             	add    $0xc,%esp
  803200:	5e                   	pop    %esi
  803201:	5f                   	pop    %edi
  803202:	5d                   	pop    %ebp
  803203:	c3                   	ret    
  803204:	66 90                	xchg   %ax,%ax
  803206:	66 90                	xchg   %ax,%ax
  803208:	66 90                	xchg   %ax,%ax
  80320a:	66 90                	xchg   %ax,%ax
  80320c:	66 90                	xchg   %ax,%ax
  80320e:	66 90                	xchg   %ax,%ax

00803210 <__umoddi3>:
  803210:	55                   	push   %ebp
  803211:	57                   	push   %edi
  803212:	56                   	push   %esi
  803213:	83 ec 14             	sub    $0x14,%esp
  803216:	8b 44 24 28          	mov    0x28(%esp),%eax
  80321a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80321e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803222:	89 c7                	mov    %eax,%edi
  803224:	89 44 24 04          	mov    %eax,0x4(%esp)
  803228:	8b 44 24 30          	mov    0x30(%esp),%eax
  80322c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803230:	89 34 24             	mov    %esi,(%esp)
  803233:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803237:	85 c0                	test   %eax,%eax
  803239:	89 c2                	mov    %eax,%edx
  80323b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80323f:	75 17                	jne    803258 <__umoddi3+0x48>
  803241:	39 fe                	cmp    %edi,%esi
  803243:	76 4b                	jbe    803290 <__umoddi3+0x80>
  803245:	89 c8                	mov    %ecx,%eax
  803247:	89 fa                	mov    %edi,%edx
  803249:	f7 f6                	div    %esi
  80324b:	89 d0                	mov    %edx,%eax
  80324d:	31 d2                	xor    %edx,%edx
  80324f:	83 c4 14             	add    $0x14,%esp
  803252:	5e                   	pop    %esi
  803253:	5f                   	pop    %edi
  803254:	5d                   	pop    %ebp
  803255:	c3                   	ret    
  803256:	66 90                	xchg   %ax,%ax
  803258:	39 f8                	cmp    %edi,%eax
  80325a:	77 54                	ja     8032b0 <__umoddi3+0xa0>
  80325c:	0f bd e8             	bsr    %eax,%ebp
  80325f:	83 f5 1f             	xor    $0x1f,%ebp
  803262:	75 5c                	jne    8032c0 <__umoddi3+0xb0>
  803264:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803268:	39 3c 24             	cmp    %edi,(%esp)
  80326b:	0f 87 e7 00 00 00    	ja     803358 <__umoddi3+0x148>
  803271:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803275:	29 f1                	sub    %esi,%ecx
  803277:	19 c7                	sbb    %eax,%edi
  803279:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80327d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803281:	8b 44 24 08          	mov    0x8(%esp),%eax
  803285:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803289:	83 c4 14             	add    $0x14,%esp
  80328c:	5e                   	pop    %esi
  80328d:	5f                   	pop    %edi
  80328e:	5d                   	pop    %ebp
  80328f:	c3                   	ret    
  803290:	85 f6                	test   %esi,%esi
  803292:	89 f5                	mov    %esi,%ebp
  803294:	75 0b                	jne    8032a1 <__umoddi3+0x91>
  803296:	b8 01 00 00 00       	mov    $0x1,%eax
  80329b:	31 d2                	xor    %edx,%edx
  80329d:	f7 f6                	div    %esi
  80329f:	89 c5                	mov    %eax,%ebp
  8032a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032a5:	31 d2                	xor    %edx,%edx
  8032a7:	f7 f5                	div    %ebp
  8032a9:	89 c8                	mov    %ecx,%eax
  8032ab:	f7 f5                	div    %ebp
  8032ad:	eb 9c                	jmp    80324b <__umoddi3+0x3b>
  8032af:	90                   	nop
  8032b0:	89 c8                	mov    %ecx,%eax
  8032b2:	89 fa                	mov    %edi,%edx
  8032b4:	83 c4 14             	add    $0x14,%esp
  8032b7:	5e                   	pop    %esi
  8032b8:	5f                   	pop    %edi
  8032b9:	5d                   	pop    %ebp
  8032ba:	c3                   	ret    
  8032bb:	90                   	nop
  8032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8032c0:	8b 04 24             	mov    (%esp),%eax
  8032c3:	be 20 00 00 00       	mov    $0x20,%esi
  8032c8:	89 e9                	mov    %ebp,%ecx
  8032ca:	29 ee                	sub    %ebp,%esi
  8032cc:	d3 e2                	shl    %cl,%edx
  8032ce:	89 f1                	mov    %esi,%ecx
  8032d0:	d3 e8                	shr    %cl,%eax
  8032d2:	89 e9                	mov    %ebp,%ecx
  8032d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d8:	8b 04 24             	mov    (%esp),%eax
  8032db:	09 54 24 04          	or     %edx,0x4(%esp)
  8032df:	89 fa                	mov    %edi,%edx
  8032e1:	d3 e0                	shl    %cl,%eax
  8032e3:	89 f1                	mov    %esi,%ecx
  8032e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8032e9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8032ed:	d3 ea                	shr    %cl,%edx
  8032ef:	89 e9                	mov    %ebp,%ecx
  8032f1:	d3 e7                	shl    %cl,%edi
  8032f3:	89 f1                	mov    %esi,%ecx
  8032f5:	d3 e8                	shr    %cl,%eax
  8032f7:	89 e9                	mov    %ebp,%ecx
  8032f9:	09 f8                	or     %edi,%eax
  8032fb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8032ff:	f7 74 24 04          	divl   0x4(%esp)
  803303:	d3 e7                	shl    %cl,%edi
  803305:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803309:	89 d7                	mov    %edx,%edi
  80330b:	f7 64 24 08          	mull   0x8(%esp)
  80330f:	39 d7                	cmp    %edx,%edi
  803311:	89 c1                	mov    %eax,%ecx
  803313:	89 14 24             	mov    %edx,(%esp)
  803316:	72 2c                	jb     803344 <__umoddi3+0x134>
  803318:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80331c:	72 22                	jb     803340 <__umoddi3+0x130>
  80331e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803322:	29 c8                	sub    %ecx,%eax
  803324:	19 d7                	sbb    %edx,%edi
  803326:	89 e9                	mov    %ebp,%ecx
  803328:	89 fa                	mov    %edi,%edx
  80332a:	d3 e8                	shr    %cl,%eax
  80332c:	89 f1                	mov    %esi,%ecx
  80332e:	d3 e2                	shl    %cl,%edx
  803330:	89 e9                	mov    %ebp,%ecx
  803332:	d3 ef                	shr    %cl,%edi
  803334:	09 d0                	or     %edx,%eax
  803336:	89 fa                	mov    %edi,%edx
  803338:	83 c4 14             	add    $0x14,%esp
  80333b:	5e                   	pop    %esi
  80333c:	5f                   	pop    %edi
  80333d:	5d                   	pop    %ebp
  80333e:	c3                   	ret    
  80333f:	90                   	nop
  803340:	39 d7                	cmp    %edx,%edi
  803342:	75 da                	jne    80331e <__umoddi3+0x10e>
  803344:	8b 14 24             	mov    (%esp),%edx
  803347:	89 c1                	mov    %eax,%ecx
  803349:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80334d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803351:	eb cb                	jmp    80331e <__umoddi3+0x10e>
  803353:	90                   	nop
  803354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803358:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80335c:	0f 82 0f ff ff ff    	jb     803271 <__umoddi3+0x61>
  803362:	e9 1a ff ff ff       	jmp    803281 <__umoddi3+0x71>
