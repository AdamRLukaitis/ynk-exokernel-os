
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 d5 03 00 00       	call   800406 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80004b:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	eb 0c                	jmp    800063 <sum+0x23>
		tot ^= i * s[i];
  800057:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80005b:	0f af ca             	imul   %edx,%ecx
  80005e:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800060:	83 c2 01             	add    $0x1,%edx
  800063:	39 da                	cmp    %ebx,%edx
  800065:	7c f0                	jl     800057 <sum+0x17>
		tot ^= i * s[i];
	return tot;
}
  800067:	5b                   	pop    %ebx
  800068:	5e                   	pop    %esi
  800069:	5d                   	pop    %ebp
  80006a:	c3                   	ret    

0080006b <umain>:

void
umain(int argc, char **argv)
{
  80006b:	55                   	push   %ebp
  80006c:	89 e5                	mov    %esp,%ebp
  80006e:	57                   	push   %edi
  80006f:	56                   	push   %esi
  800070:	53                   	push   %ebx
  800071:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  800077:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80007a:	c7 04 24 40 2e 80 00 	movl   $0x802e40,(%esp)
  800081:	e8 e4 04 00 00       	call   80056a <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800086:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  800095:	e8 a6 ff ff ff       	call   800040 <sum>
  80009a:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80009f:	74 1a                	je     8000bb <umain+0x50>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a1:	c7 44 24 08 9e 98 0f 	movl   $0xf989e,0x8(%esp)
  8000a8:	00 
  8000a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ad:	c7 04 24 08 2f 80 00 	movl   $0x802f08,(%esp)
  8000b4:	e8 b1 04 00 00       	call   80056a <cprintf>
  8000b9:	eb 0c                	jmp    8000c7 <umain+0x5c>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000bb:	c7 04 24 4f 2e 80 00 	movl   $0x802e4f,(%esp)
  8000c2:	e8 a3 04 00 00       	call   80056a <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000c7:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000ce:	00 
  8000cf:	c7 04 24 20 60 80 00 	movl   $0x806020,(%esp)
  8000d6:	e8 65 ff ff ff       	call   800040 <sum>
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 12                	je     8000f1 <umain+0x86>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e3:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  8000ea:	e8 7b 04 00 00       	call   80056a <cprintf>
  8000ef:	eb 0c                	jmp    8000fd <umain+0x92>
	else
		cprintf("init: bss seems okay\n");
  8000f1:	c7 04 24 66 2e 80 00 	movl   $0x802e66,(%esp)
  8000f8:	e8 6d 04 00 00       	call   80056a <cprintf>

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000fd:	c7 44 24 04 7c 2e 80 	movl   $0x802e7c,0x4(%esp)
  800104:	00 
  800105:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80010b:	89 04 24             	mov    %eax,(%esp)
  80010e:	e8 a4 0a 00 00       	call   800bb7 <strcat>
	for (i = 0; i < argc; i++) {
  800113:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  800118:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80011e:	eb 32                	jmp    800152 <umain+0xe7>
		strcat(args, " '");
  800120:	c7 44 24 04 88 2e 80 	movl   $0x802e88,0x4(%esp)
  800127:	00 
  800128:	89 34 24             	mov    %esi,(%esp)
  80012b:	e8 87 0a 00 00       	call   800bb7 <strcat>
		strcat(args, argv[i]);
  800130:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800133:	89 44 24 04          	mov    %eax,0x4(%esp)
  800137:	89 34 24             	mov    %esi,(%esp)
  80013a:	e8 78 0a 00 00       	call   800bb7 <strcat>
		strcat(args, "'");
  80013f:	c7 44 24 04 89 2e 80 	movl   $0x802e89,0x4(%esp)
  800146:	00 
  800147:	89 34 24             	mov    %esi,(%esp)
  80014a:	e8 68 0a 00 00       	call   800bb7 <strcat>
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80014f:	83 c3 01             	add    $0x1,%ebx
  800152:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800155:	7c c9                	jl     800120 <umain+0xb5>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  800157:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800161:	c7 04 24 8b 2e 80 00 	movl   $0x802e8b,(%esp)
  800168:	e8 fd 03 00 00       	call   80056a <cprintf>

	cprintf("init: running sh\n");
  80016d:	c7 04 24 8f 2e 80 00 	movl   $0x802e8f,(%esp)
  800174:	e8 f1 03 00 00       	call   80056a <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800180:	e8 02 13 00 00       	call   801487 <close>
	if ((r = opencons()) < 0)
  800185:	e8 21 02 00 00       	call   8003ab <opencons>
  80018a:	85 c0                	test   %eax,%eax
  80018c:	79 20                	jns    8001ae <umain+0x143>
		panic("opencons: %e", r);
  80018e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800192:	c7 44 24 08 a1 2e 80 	movl   $0x802ea1,0x8(%esp)
  800199:	00 
  80019a:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8001a1:	00 
  8001a2:	c7 04 24 ae 2e 80 00 	movl   $0x802eae,(%esp)
  8001a9:	e8 c3 02 00 00       	call   800471 <_panic>
	if (r != 0)
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	74 20                	je     8001d2 <umain+0x167>
		panic("first opencons used fd %d", r);
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 ba 2e 80 	movl   $0x802eba,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 ae 2e 80 00 	movl   $0x802eae,(%esp)
  8001cd:	e8 9f 02 00 00       	call   800471 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001d9:	00 
  8001da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e1:	e8 f6 12 00 00       	call   8014dc <dup>
  8001e6:	85 c0                	test   %eax,%eax
  8001e8:	79 20                	jns    80020a <umain+0x19f>
		panic("dup: %e", r);
  8001ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ee:	c7 44 24 08 d4 2e 80 	movl   $0x802ed4,0x8(%esp)
  8001f5:	00 
  8001f6:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  8001fd:	00 
  8001fe:	c7 04 24 ae 2e 80 00 	movl   $0x802eae,(%esp)
  800205:	e8 67 02 00 00       	call   800471 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  80020a:	c7 04 24 dc 2e 80 00 	movl   $0x802edc,(%esp)
  800211:	e8 54 03 00 00       	call   80056a <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800216:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80021d:	00 
  80021e:	c7 44 24 04 f0 2e 80 	movl   $0x802ef0,0x4(%esp)
  800225:	00 
  800226:	c7 04 24 ef 2e 80 00 	movl   $0x802eef,(%esp)
  80022d:	e8 d6 1e 00 00       	call   802108 <spawnl>
		if (r < 0) {
  800232:	85 c0                	test   %eax,%eax
  800234:	79 12                	jns    800248 <umain+0x1dd>
			cprintf("init: spawn sh: %e\n", r);
  800236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023a:	c7 04 24 f3 2e 80 00 	movl   $0x802ef3,(%esp)
  800241:	e8 24 03 00 00       	call   80056a <cprintf>
			continue;
  800246:	eb c2                	jmp    80020a <umain+0x19f>
		}
		wait(r);
  800248:	89 04 24             	mov    %eax,(%esp)
  80024b:	e8 ba 27 00 00       	call   802a0a <wait>
  800250:	eb b8                	jmp    80020a <umain+0x19f>
  800252:	66 90                	xchg   %ax,%ax
  800254:	66 90                	xchg   %ax,%ax
  800256:	66 90                	xchg   %ax,%ax
  800258:	66 90                	xchg   %ax,%ax
  80025a:	66 90                	xchg   %ax,%ax
  80025c:	66 90                	xchg   %ax,%ax
  80025e:	66 90                	xchg   %ax,%ax

00800260 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800263:	b8 00 00 00 00       	mov    $0x0,%eax
  800268:	5d                   	pop    %ebp
  800269:	c3                   	ret    

0080026a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800270:	c7 44 24 04 73 2f 80 	movl   $0x802f73,0x4(%esp)
  800277:	00 
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	e8 14 09 00 00       	call   800b97 <strcpy>
	return 0;
}
  800283:	b8 00 00 00 00       	mov    $0x0,%eax
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800296:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80029b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002a1:	eb 31                	jmp    8002d4 <devcons_write+0x4a>
		m = n - tot;
  8002a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8002a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8002a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8002ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8002b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8002b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002b7:	03 45 0c             	add    0xc(%ebp),%eax
  8002ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002be:	89 3c 24             	mov    %edi,(%esp)
  8002c1:	e8 6e 0a 00 00       	call   800d34 <memmove>
		sys_cputs(buf, m);
  8002c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ca:	89 3c 24             	mov    %edi,(%esp)
  8002cd:	e8 14 0c 00 00       	call   800ee6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002d2:	01 f3                	add    %esi,%ebx
  8002d4:	89 d8                	mov    %ebx,%eax
  8002d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8002d9:	72 c8                	jb     8002a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8002db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8002ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8002f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002f5:	75 07                	jne    8002fe <devcons_read+0x18>
  8002f7:	eb 2a                	jmp    800323 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8002f9:	e8 96 0c 00 00       	call   800f94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8002fe:	66 90                	xchg   %ax,%ax
  800300:	e8 ff 0b 00 00       	call   800f04 <sys_cgetc>
  800305:	85 c0                	test   %eax,%eax
  800307:	74 f0                	je     8002f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800309:	85 c0                	test   %eax,%eax
  80030b:	78 16                	js     800323 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80030d:	83 f8 04             	cmp    $0x4,%eax
  800310:	74 0c                	je     80031e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800312:	8b 55 0c             	mov    0xc(%ebp),%edx
  800315:	88 02                	mov    %al,(%edx)
	return 1;
  800317:	b8 01 00 00 00       	mov    $0x1,%eax
  80031c:	eb 05                	jmp    800323 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800331:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800338:	00 
  800339:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80033c:	89 04 24             	mov    %eax,(%esp)
  80033f:	e8 a2 0b 00 00       	call   800ee6 <sys_cputs>
}
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <getchar>:

int
getchar(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80034c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800353:	00 
  800354:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800362:	e8 83 12 00 00       	call   8015ea <read>
	if (r < 0)
  800367:	85 c0                	test   %eax,%eax
  800369:	78 0f                	js     80037a <getchar+0x34>
		return r;
	if (r < 1)
  80036b:	85 c0                	test   %eax,%eax
  80036d:	7e 06                	jle    800375 <getchar+0x2f>
		return -E_EOF;
	return c;
  80036f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800373:	eb 05                	jmp    80037a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800375:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800382:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800385:	89 44 24 04          	mov    %eax,0x4(%esp)
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	89 04 24             	mov    %eax,(%esp)
  80038f:	e8 c2 0f 00 00       	call   801356 <fd_lookup>
  800394:	85 c0                	test   %eax,%eax
  800396:	78 11                	js     8003a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80039b:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003a1:	39 10                	cmp    %edx,(%eax)
  8003a3:	0f 94 c0             	sete   %al
  8003a6:	0f b6 c0             	movzbl %al,%eax
}
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    

008003ab <opencons>:

int
opencons(void)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8003b4:	89 04 24             	mov    %eax,(%esp)
  8003b7:	e8 4b 0f 00 00       	call   801307 <fd_alloc>
		return r;
  8003bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003be:	85 c0                	test   %eax,%eax
  8003c0:	78 40                	js     800402 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8003c9:	00 
  8003ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003d8:	e8 d6 0b 00 00       	call   800fb3 <sys_page_alloc>
		return r;
  8003dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	78 1f                	js     800402 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8003e3:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8003ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8003f8:	89 04 24             	mov    %eax,(%esp)
  8003fb:	e8 e0 0e 00 00       	call   8012e0 <fd2num>
  800400:	89 c2                	mov    %eax,%edx
}
  800402:	89 d0                	mov    %edx,%eax
  800404:	c9                   	leave  
  800405:	c3                   	ret    

00800406 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	56                   	push   %esi
  80040a:	53                   	push   %ebx
  80040b:	83 ec 10             	sub    $0x10,%esp
  80040e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800411:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800414:	c7 05 90 77 80 00 00 	movl   $0x0,0x807790
  80041b:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  80041e:	e8 52 0b 00 00       	call   800f75 <sys_getenvid>
  800423:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800428:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80042b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800430:	a3 90 77 80 00       	mov    %eax,0x807790


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800435:	85 db                	test   %ebx,%ebx
  800437:	7e 07                	jle    800440 <libmain+0x3a>
		binaryname = argv[0];
  800439:	8b 06                	mov    (%esi),%eax
  80043b:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  800440:	89 74 24 04          	mov    %esi,0x4(%esp)
  800444:	89 1c 24             	mov    %ebx,(%esp)
  800447:	e8 1f fc ff ff       	call   80006b <umain>

	// exit gracefully
	exit();
  80044c:	e8 07 00 00 00       	call   800458 <exit>
}
  800451:	83 c4 10             	add    $0x10,%esp
  800454:	5b                   	pop    %ebx
  800455:	5e                   	pop    %esi
  800456:	5d                   	pop    %ebp
  800457:	c3                   	ret    

00800458 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800458:	55                   	push   %ebp
  800459:	89 e5                	mov    %esp,%ebp
  80045b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80045e:	e8 57 10 00 00       	call   8014ba <close_all>
	sys_env_destroy(0);
  800463:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80046a:	e8 b4 0a 00 00       	call   800f23 <sys_env_destroy>
}
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	56                   	push   %esi
  800475:	53                   	push   %ebx
  800476:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800479:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80047c:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  800482:	e8 ee 0a 00 00       	call   800f75 <sys_getenvid>
  800487:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80048e:	8b 55 08             	mov    0x8(%ebp),%edx
  800491:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800495:	89 74 24 08          	mov    %esi,0x8(%esp)
  800499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049d:	c7 04 24 8c 2f 80 00 	movl   $0x802f8c,(%esp)
  8004a4:	e8 c1 00 00 00       	call   80056a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8004a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b0:	89 04 24             	mov    %eax,(%esp)
  8004b3:	e8 51 00 00 00       	call   800509 <vcprintf>
	cprintf("\n");
  8004b8:	c7 04 24 9d 34 80 00 	movl   $0x80349d,(%esp)
  8004bf:	e8 a6 00 00 00       	call   80056a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004c4:	cc                   	int3   
  8004c5:	eb fd                	jmp    8004c4 <_panic+0x53>

008004c7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	53                   	push   %ebx
  8004cb:	83 ec 14             	sub    $0x14,%esp
  8004ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004d1:	8b 13                	mov    (%ebx),%edx
  8004d3:	8d 42 01             	lea    0x1(%edx),%eax
  8004d6:	89 03                	mov    %eax,(%ebx)
  8004d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004db:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8004df:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004e4:	75 19                	jne    8004ff <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8004e6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8004ed:	00 
  8004ee:	8d 43 08             	lea    0x8(%ebx),%eax
  8004f1:	89 04 24             	mov    %eax,(%esp)
  8004f4:	e8 ed 09 00 00       	call   800ee6 <sys_cputs>
		b->idx = 0;
  8004f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8004ff:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800503:	83 c4 14             	add    $0x14,%esp
  800506:	5b                   	pop    %ebx
  800507:	5d                   	pop    %ebp
  800508:	c3                   	ret    

00800509 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800509:	55                   	push   %ebp
  80050a:	89 e5                	mov    %esp,%ebp
  80050c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800512:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800519:	00 00 00 
	b.cnt = 0;
  80051c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800523:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800526:	8b 45 0c             	mov    0xc(%ebp),%eax
  800529:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80052d:	8b 45 08             	mov    0x8(%ebp),%eax
  800530:	89 44 24 08          	mov    %eax,0x8(%esp)
  800534:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80053a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053e:	c7 04 24 c7 04 80 00 	movl   $0x8004c7,(%esp)
  800545:	e8 b4 01 00 00       	call   8006fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80054a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800550:	89 44 24 04          	mov    %eax,0x4(%esp)
  800554:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80055a:	89 04 24             	mov    %eax,(%esp)
  80055d:	e8 84 09 00 00       	call   800ee6 <sys_cputs>

	return b.cnt;
}
  800562:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800570:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800573:	89 44 24 04          	mov    %eax,0x4(%esp)
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	89 04 24             	mov    %eax,(%esp)
  80057d:	e8 87 ff ff ff       	call   800509 <vcprintf>
	va_end(ap);

	return cnt;
}
  800582:	c9                   	leave  
  800583:	c3                   	ret    
  800584:	66 90                	xchg   %ax,%ax
  800586:	66 90                	xchg   %ax,%ax
  800588:	66 90                	xchg   %ax,%ax
  80058a:	66 90                	xchg   %ax,%ax
  80058c:	66 90                	xchg   %ax,%ax
  80058e:	66 90                	xchg   %ax,%ax

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	57                   	push   %edi
  800594:	56                   	push   %esi
  800595:	53                   	push   %ebx
  800596:	83 ec 3c             	sub    $0x3c,%esp
  800599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80059c:	89 d7                	mov    %edx,%edi
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a7:	89 c3                	mov    %eax,%ebx
  8005a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8005ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8005af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005bd:	39 d9                	cmp    %ebx,%ecx
  8005bf:	72 05                	jb     8005c6 <printnum+0x36>
  8005c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005c4:	77 69                	ja     80062f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8005cd:	83 ee 01             	sub    $0x1,%esi
  8005d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8005d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8005dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8005e0:	89 c3                	mov    %eax,%ebx
  8005e2:	89 d6                	mov    %edx,%esi
  8005e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8005f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f5:	89 04 24             	mov    %eax,(%esp)
  8005f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ff:	e8 ac 25 00 00       	call   802bb0 <__udivdi3>
  800604:	89 d9                	mov    %ebx,%ecx
  800606:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80060a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80060e:	89 04 24             	mov    %eax,(%esp)
  800611:	89 54 24 04          	mov    %edx,0x4(%esp)
  800615:	89 fa                	mov    %edi,%edx
  800617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80061a:	e8 71 ff ff ff       	call   800590 <printnum>
  80061f:	eb 1b                	jmp    80063c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800621:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800625:	8b 45 18             	mov    0x18(%ebp),%eax
  800628:	89 04 24             	mov    %eax,(%esp)
  80062b:	ff d3                	call   *%ebx
  80062d:	eb 03                	jmp    800632 <printnum+0xa2>
  80062f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800632:	83 ee 01             	sub    $0x1,%esi
  800635:	85 f6                	test   %esi,%esi
  800637:	7f e8                	jg     800621 <printnum+0x91>
  800639:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80063c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800640:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800644:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800647:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80064a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80064e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800655:	89 04 24             	mov    %eax,(%esp)
  800658:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80065b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065f:	e8 7c 26 00 00       	call   802ce0 <__umoddi3>
  800664:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800668:	0f be 80 af 2f 80 00 	movsbl 0x802faf(%eax),%eax
  80066f:	89 04 24             	mov    %eax,(%esp)
  800672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800675:	ff d0                	call   *%eax
}
  800677:	83 c4 3c             	add    $0x3c,%esp
  80067a:	5b                   	pop    %ebx
  80067b:	5e                   	pop    %esi
  80067c:	5f                   	pop    %edi
  80067d:	5d                   	pop    %ebp
  80067e:	c3                   	ret    

0080067f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800682:	83 fa 01             	cmp    $0x1,%edx
  800685:	7e 0e                	jle    800695 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800687:	8b 10                	mov    (%eax),%edx
  800689:	8d 4a 08             	lea    0x8(%edx),%ecx
  80068c:	89 08                	mov    %ecx,(%eax)
  80068e:	8b 02                	mov    (%edx),%eax
  800690:	8b 52 04             	mov    0x4(%edx),%edx
  800693:	eb 22                	jmp    8006b7 <getuint+0x38>
	else if (lflag)
  800695:	85 d2                	test   %edx,%edx
  800697:	74 10                	je     8006a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800699:	8b 10                	mov    (%eax),%edx
  80069b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80069e:	89 08                	mov    %ecx,(%eax)
  8006a0:	8b 02                	mov    (%edx),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a7:	eb 0e                	jmp    8006b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8006a9:	8b 10                	mov    (%eax),%edx
  8006ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006ae:	89 08                	mov    %ecx,(%eax)
  8006b0:	8b 02                	mov    (%edx),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006b7:	5d                   	pop    %ebp
  8006b8:	c3                   	ret    

008006b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006b9:	55                   	push   %ebp
  8006ba:	89 e5                	mov    %esp,%ebp
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006c3:	8b 10                	mov    (%eax),%edx
  8006c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8006c8:	73 0a                	jae    8006d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8006ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006cd:	89 08                	mov    %ecx,(%eax)
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	88 02                	mov    %al,(%edx)
}
  8006d4:	5d                   	pop    %ebp
  8006d5:	c3                   	ret    

008006d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006d6:	55                   	push   %ebp
  8006d7:	89 e5                	mov    %esp,%ebp
  8006d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8006dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	89 04 24             	mov    %eax,(%esp)
  8006f7:	e8 02 00 00 00       	call   8006fe <vprintfmt>
	va_end(ap);
}
  8006fc:	c9                   	leave  
  8006fd:	c3                   	ret    

008006fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	57                   	push   %edi
  800702:	56                   	push   %esi
  800703:	53                   	push   %ebx
  800704:	83 ec 3c             	sub    $0x3c,%esp
  800707:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80070a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80070d:	eb 14                	jmp    800723 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80070f:	85 c0                	test   %eax,%eax
  800711:	0f 84 b3 03 00 00    	je     800aca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800717:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071b:	89 04 24             	mov    %eax,(%esp)
  80071e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800721:	89 f3                	mov    %esi,%ebx
  800723:	8d 73 01             	lea    0x1(%ebx),%esi
  800726:	0f b6 03             	movzbl (%ebx),%eax
  800729:	83 f8 25             	cmp    $0x25,%eax
  80072c:	75 e1                	jne    80070f <vprintfmt+0x11>
  80072e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800732:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800739:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800740:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800747:	ba 00 00 00 00       	mov    $0x0,%edx
  80074c:	eb 1d                	jmp    80076b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800750:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800754:	eb 15                	jmp    80076b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800756:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800758:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80075c:	eb 0d                	jmp    80076b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80075e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800761:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800764:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80076e:	0f b6 0e             	movzbl (%esi),%ecx
  800771:	0f b6 c1             	movzbl %cl,%eax
  800774:	83 e9 23             	sub    $0x23,%ecx
  800777:	80 f9 55             	cmp    $0x55,%cl
  80077a:	0f 87 2a 03 00 00    	ja     800aaa <vprintfmt+0x3ac>
  800780:	0f b6 c9             	movzbl %cl,%ecx
  800783:	ff 24 8d 00 31 80 00 	jmp    *0x803100(,%ecx,4)
  80078a:	89 de                	mov    %ebx,%esi
  80078c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800791:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800794:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800798:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80079b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80079e:	83 fb 09             	cmp    $0x9,%ebx
  8007a1:	77 36                	ja     8007d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a6:	eb e9                	jmp    800791 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8007ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8007b8:	eb 22                	jmp    8007dc <vprintfmt+0xde>
  8007ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007bd:	85 c9                	test   %ecx,%ecx
  8007bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c4:	0f 49 c1             	cmovns %ecx,%eax
  8007c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ca:	89 de                	mov    %ebx,%esi
  8007cc:	eb 9d                	jmp    80076b <vprintfmt+0x6d>
  8007ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8007d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8007d7:	eb 92                	jmp    80076b <vprintfmt+0x6d>
  8007d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8007dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007e0:	79 89                	jns    80076b <vprintfmt+0x6d>
  8007e2:	e9 77 ff ff ff       	jmp    80075e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8007ec:	e9 7a ff ff ff       	jmp    80076b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8007fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007fe:	8b 00                	mov    (%eax),%eax
  800800:	89 04 24             	mov    %eax,(%esp)
  800803:	ff 55 08             	call   *0x8(%ebp)
			break;
  800806:	e9 18 ff ff ff       	jmp    800723 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80080b:	8b 45 14             	mov    0x14(%ebp),%eax
  80080e:	8d 50 04             	lea    0x4(%eax),%edx
  800811:	89 55 14             	mov    %edx,0x14(%ebp)
  800814:	8b 00                	mov    (%eax),%eax
  800816:	99                   	cltd   
  800817:	31 d0                	xor    %edx,%eax
  800819:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80081b:	83 f8 0f             	cmp    $0xf,%eax
  80081e:	7f 0b                	jg     80082b <vprintfmt+0x12d>
  800820:	8b 14 85 60 32 80 00 	mov    0x803260(,%eax,4),%edx
  800827:	85 d2                	test   %edx,%edx
  800829:	75 20                	jne    80084b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80082b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80082f:	c7 44 24 08 c7 2f 80 	movl   $0x802fc7,0x8(%esp)
  800836:	00 
  800837:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	89 04 24             	mov    %eax,(%esp)
  800841:	e8 90 fe ff ff       	call   8006d6 <printfmt>
  800846:	e9 d8 fe ff ff       	jmp    800723 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80084b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80084f:	c7 44 24 08 95 33 80 	movl   $0x803395,0x8(%esp)
  800856:	00 
  800857:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	89 04 24             	mov    %eax,(%esp)
  800861:	e8 70 fe ff ff       	call   8006d6 <printfmt>
  800866:	e9 b8 fe ff ff       	jmp    800723 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80086b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80086e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800871:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800874:	8b 45 14             	mov    0x14(%ebp),%eax
  800877:	8d 50 04             	lea    0x4(%eax),%edx
  80087a:	89 55 14             	mov    %edx,0x14(%ebp)
  80087d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80087f:	85 f6                	test   %esi,%esi
  800881:	b8 c0 2f 80 00       	mov    $0x802fc0,%eax
  800886:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800889:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80088d:	0f 84 97 00 00 00    	je     80092a <vprintfmt+0x22c>
  800893:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800897:	0f 8e 9b 00 00 00    	jle    800938 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80089d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008a1:	89 34 24             	mov    %esi,(%esp)
  8008a4:	e8 cf 02 00 00       	call   800b78 <strnlen>
  8008a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8008ac:	29 c2                	sub    %eax,%edx
  8008ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8008b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8008b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8008bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8008be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c3:	eb 0f                	jmp    8008d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8008c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008cc:	89 04 24             	mov    %eax,(%esp)
  8008cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d1:	83 eb 01             	sub    $0x1,%ebx
  8008d4:	85 db                	test   %ebx,%ebx
  8008d6:	7f ed                	jg     8008c5 <vprintfmt+0x1c7>
  8008d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8008db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8008de:	85 d2                	test   %edx,%edx
  8008e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e5:	0f 49 c2             	cmovns %edx,%eax
  8008e8:	29 c2                	sub    %eax,%edx
  8008ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8008ed:	89 d7                	mov    %edx,%edi
  8008ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008f2:	eb 50                	jmp    800944 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008f8:	74 1e                	je     800918 <vprintfmt+0x21a>
  8008fa:	0f be d2             	movsbl %dl,%edx
  8008fd:	83 ea 20             	sub    $0x20,%edx
  800900:	83 fa 5e             	cmp    $0x5e,%edx
  800903:	76 13                	jbe    800918 <vprintfmt+0x21a>
					putch('?', putdat);
  800905:	8b 45 0c             	mov    0xc(%ebp),%eax
  800908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800913:	ff 55 08             	call   *0x8(%ebp)
  800916:	eb 0d                	jmp    800925 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800918:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80091f:	89 04 24             	mov    %eax,(%esp)
  800922:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800925:	83 ef 01             	sub    $0x1,%edi
  800928:	eb 1a                	jmp    800944 <vprintfmt+0x246>
  80092a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80092d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800930:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800933:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800936:	eb 0c                	jmp    800944 <vprintfmt+0x246>
  800938:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80093b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80093e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800941:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800944:	83 c6 01             	add    $0x1,%esi
  800947:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80094b:	0f be c2             	movsbl %dl,%eax
  80094e:	85 c0                	test   %eax,%eax
  800950:	74 27                	je     800979 <vprintfmt+0x27b>
  800952:	85 db                	test   %ebx,%ebx
  800954:	78 9e                	js     8008f4 <vprintfmt+0x1f6>
  800956:	83 eb 01             	sub    $0x1,%ebx
  800959:	79 99                	jns    8008f4 <vprintfmt+0x1f6>
  80095b:	89 f8                	mov    %edi,%eax
  80095d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800960:	8b 75 08             	mov    0x8(%ebp),%esi
  800963:	89 c3                	mov    %eax,%ebx
  800965:	eb 1a                	jmp    800981 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800967:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80096b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800972:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800974:	83 eb 01             	sub    $0x1,%ebx
  800977:	eb 08                	jmp    800981 <vprintfmt+0x283>
  800979:	89 fb                	mov    %edi,%ebx
  80097b:	8b 75 08             	mov    0x8(%ebp),%esi
  80097e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800981:	85 db                	test   %ebx,%ebx
  800983:	7f e2                	jg     800967 <vprintfmt+0x269>
  800985:	89 75 08             	mov    %esi,0x8(%ebp)
  800988:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80098b:	e9 93 fd ff ff       	jmp    800723 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800990:	83 fa 01             	cmp    $0x1,%edx
  800993:	7e 16                	jle    8009ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800995:	8b 45 14             	mov    0x14(%ebp),%eax
  800998:	8d 50 08             	lea    0x8(%eax),%edx
  80099b:	89 55 14             	mov    %edx,0x14(%ebp)
  80099e:	8b 50 04             	mov    0x4(%eax),%edx
  8009a1:	8b 00                	mov    (%eax),%eax
  8009a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8009a9:	eb 32                	jmp    8009dd <vprintfmt+0x2df>
	else if (lflag)
  8009ab:	85 d2                	test   %edx,%edx
  8009ad:	74 18                	je     8009c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8d 50 04             	lea    0x4(%eax),%edx
  8009b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b8:	8b 30                	mov    (%eax),%esi
  8009ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8009bd:	89 f0                	mov    %esi,%eax
  8009bf:	c1 f8 1f             	sar    $0x1f,%eax
  8009c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009c5:	eb 16                	jmp    8009dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8009c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ca:	8d 50 04             	lea    0x4(%eax),%edx
  8009cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8009d0:	8b 30                	mov    (%eax),%esi
  8009d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8009d5:	89 f0                	mov    %esi,%eax
  8009d7:	c1 f8 1f             	sar    $0x1f,%eax
  8009da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8009e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8009e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ec:	0f 89 80 00 00 00    	jns    800a72 <vprintfmt+0x374>
				putch('-', putdat);
  8009f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a06:	f7 d8                	neg    %eax
  800a08:	83 d2 00             	adc    $0x0,%edx
  800a0b:	f7 da                	neg    %edx
			}
			base = 10;
  800a0d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800a12:	eb 5e                	jmp    800a72 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a14:	8d 45 14             	lea    0x14(%ebp),%eax
  800a17:	e8 63 fc ff ff       	call   80067f <getuint>
			base = 10;
  800a1c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800a21:	eb 4f                	jmp    800a72 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800a23:	8d 45 14             	lea    0x14(%ebp),%eax
  800a26:	e8 54 fc ff ff       	call   80067f <getuint>
			base =8;
  800a2b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800a30:	eb 40                	jmp    800a72 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800a32:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a36:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a3d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800a40:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a44:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a4b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a4e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a51:	8d 50 04             	lea    0x4(%eax),%edx
  800a54:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a57:	8b 00                	mov    (%eax),%eax
  800a59:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a5e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800a63:	eb 0d                	jmp    800a72 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a65:	8d 45 14             	lea    0x14(%ebp),%eax
  800a68:	e8 12 fc ff ff       	call   80067f <getuint>
			base = 16;
  800a6d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a72:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800a76:	89 74 24 10          	mov    %esi,0x10(%esp)
  800a7a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800a7d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a81:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a85:	89 04 24             	mov    %eax,(%esp)
  800a88:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a8c:	89 fa                	mov    %edi,%edx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	e8 fa fa ff ff       	call   800590 <printnum>
			break;
  800a96:	e9 88 fc ff ff       	jmp    800723 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a9b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a9f:	89 04 24             	mov    %eax,(%esp)
  800aa2:	ff 55 08             	call   *0x8(%ebp)
			break;
  800aa5:	e9 79 fc ff ff       	jmp    800723 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aaa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800ab5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab8:	89 f3                	mov    %esi,%ebx
  800aba:	eb 03                	jmp    800abf <vprintfmt+0x3c1>
  800abc:	83 eb 01             	sub    $0x1,%ebx
  800abf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800ac3:	75 f7                	jne    800abc <vprintfmt+0x3be>
  800ac5:	e9 59 fc ff ff       	jmp    800723 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800aca:	83 c4 3c             	add    $0x3c,%esp
  800acd:	5b                   	pop    %ebx
  800ace:	5e                   	pop    %esi
  800acf:	5f                   	pop    %edi
  800ad0:	5d                   	pop    %ebp
  800ad1:	c3                   	ret    

00800ad2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ad2:	55                   	push   %ebp
  800ad3:	89 e5                	mov    %esp,%ebp
  800ad5:	83 ec 28             	sub    $0x28,%esp
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ade:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ae1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ae5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800aef:	85 c0                	test   %eax,%eax
  800af1:	74 30                	je     800b23 <vsnprintf+0x51>
  800af3:	85 d2                	test   %edx,%edx
  800af5:	7e 2c                	jle    800b23 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800afe:	8b 45 10             	mov    0x10(%ebp),%eax
  800b01:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0c:	c7 04 24 b9 06 80 00 	movl   $0x8006b9,(%esp)
  800b13:	e8 e6 fb ff ff       	call   8006fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b21:	eb 05                	jmp    800b28 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800b23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800b28:	c9                   	leave  
  800b29:	c3                   	ret    

00800b2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b30:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	89 04 24             	mov    %eax,(%esp)
  800b4b:	e8 82 ff ff ff       	call   800ad2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    
  800b52:	66 90                	xchg   %ax,%ax
  800b54:	66 90                	xchg   %ax,%ax
  800b56:	66 90                	xchg   %ax,%ax
  800b58:	66 90                	xchg   %ax,%ax
  800b5a:	66 90                	xchg   %ax,%ax
  800b5c:	66 90                	xchg   %ax,%ax
  800b5e:	66 90                	xchg   %ax,%ax

00800b60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b66:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6b:	eb 03                	jmp    800b70 <strlen+0x10>
		n++;
  800b6d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b70:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b74:	75 f7                	jne    800b6d <strlen+0xd>
		n++;
	return n;
}
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
  800b86:	eb 03                	jmp    800b8b <strnlen+0x13>
		n++;
  800b88:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b8b:	39 d0                	cmp    %edx,%eax
  800b8d:	74 06                	je     800b95 <strnlen+0x1d>
  800b8f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b93:	75 f3                	jne    800b88 <strnlen+0x10>
		n++;
	return n;
}
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ba1:	89 c2                	mov    %eax,%edx
  800ba3:	83 c2 01             	add    $0x1,%edx
  800ba6:	83 c1 01             	add    $0x1,%ecx
  800ba9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800bad:	88 5a ff             	mov    %bl,-0x1(%edx)
  800bb0:	84 db                	test   %bl,%bl
  800bb2:	75 ef                	jne    800ba3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800bb4:	5b                   	pop    %ebx
  800bb5:	5d                   	pop    %ebp
  800bb6:	c3                   	ret    

00800bb7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	53                   	push   %ebx
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bc1:	89 1c 24             	mov    %ebx,(%esp)
  800bc4:	e8 97 ff ff ff       	call   800b60 <strlen>
	strcpy(dst + len, src);
  800bc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bcc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bd0:	01 d8                	add    %ebx,%eax
  800bd2:	89 04 24             	mov    %eax,(%esp)
  800bd5:	e8 bd ff ff ff       	call   800b97 <strcpy>
	return dst;
}
  800bda:	89 d8                	mov    %ebx,%eax
  800bdc:	83 c4 08             	add    $0x8,%esp
  800bdf:	5b                   	pop    %ebx
  800be0:	5d                   	pop    %ebp
  800be1:	c3                   	ret    

00800be2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	56                   	push   %esi
  800be6:	53                   	push   %ebx
  800be7:	8b 75 08             	mov    0x8(%ebp),%esi
  800bea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bed:	89 f3                	mov    %esi,%ebx
  800bef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf2:	89 f2                	mov    %esi,%edx
  800bf4:	eb 0f                	jmp    800c05 <strncpy+0x23>
		*dst++ = *src;
  800bf6:	83 c2 01             	add    $0x1,%edx
  800bf9:	0f b6 01             	movzbl (%ecx),%eax
  800bfc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bff:	80 39 01             	cmpb   $0x1,(%ecx)
  800c02:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c05:	39 da                	cmp    %ebx,%edx
  800c07:	75 ed                	jne    800bf6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c09:	89 f0                	mov    %esi,%eax
  800c0b:	5b                   	pop    %ebx
  800c0c:	5e                   	pop    %esi
  800c0d:	5d                   	pop    %ebp
  800c0e:	c3                   	ret    

00800c0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	56                   	push   %esi
  800c13:	53                   	push   %ebx
  800c14:	8b 75 08             	mov    0x8(%ebp),%esi
  800c17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c1d:	89 f0                	mov    %esi,%eax
  800c1f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c23:	85 c9                	test   %ecx,%ecx
  800c25:	75 0b                	jne    800c32 <strlcpy+0x23>
  800c27:	eb 1d                	jmp    800c46 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c29:	83 c0 01             	add    $0x1,%eax
  800c2c:	83 c2 01             	add    $0x1,%edx
  800c2f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c32:	39 d8                	cmp    %ebx,%eax
  800c34:	74 0b                	je     800c41 <strlcpy+0x32>
  800c36:	0f b6 0a             	movzbl (%edx),%ecx
  800c39:	84 c9                	test   %cl,%cl
  800c3b:	75 ec                	jne    800c29 <strlcpy+0x1a>
  800c3d:	89 c2                	mov    %eax,%edx
  800c3f:	eb 02                	jmp    800c43 <strlcpy+0x34>
  800c41:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800c43:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800c46:	29 f0                	sub    %esi,%eax
}
  800c48:	5b                   	pop    %ebx
  800c49:	5e                   	pop    %esi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c52:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c55:	eb 06                	jmp    800c5d <strcmp+0x11>
		p++, q++;
  800c57:	83 c1 01             	add    $0x1,%ecx
  800c5a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c5d:	0f b6 01             	movzbl (%ecx),%eax
  800c60:	84 c0                	test   %al,%al
  800c62:	74 04                	je     800c68 <strcmp+0x1c>
  800c64:	3a 02                	cmp    (%edx),%al
  800c66:	74 ef                	je     800c57 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c68:	0f b6 c0             	movzbl %al,%eax
  800c6b:	0f b6 12             	movzbl (%edx),%edx
  800c6e:	29 d0                	sub    %edx,%eax
}
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	53                   	push   %ebx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c7c:	89 c3                	mov    %eax,%ebx
  800c7e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c81:	eb 06                	jmp    800c89 <strncmp+0x17>
		n--, p++, q++;
  800c83:	83 c0 01             	add    $0x1,%eax
  800c86:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c89:	39 d8                	cmp    %ebx,%eax
  800c8b:	74 15                	je     800ca2 <strncmp+0x30>
  800c8d:	0f b6 08             	movzbl (%eax),%ecx
  800c90:	84 c9                	test   %cl,%cl
  800c92:	74 04                	je     800c98 <strncmp+0x26>
  800c94:	3a 0a                	cmp    (%edx),%cl
  800c96:	74 eb                	je     800c83 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c98:	0f b6 00             	movzbl (%eax),%eax
  800c9b:	0f b6 12             	movzbl (%edx),%edx
  800c9e:	29 d0                	sub    %edx,%eax
  800ca0:	eb 05                	jmp    800ca7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ca2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ca7:	5b                   	pop    %ebx
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb4:	eb 07                	jmp    800cbd <strchr+0x13>
		if (*s == c)
  800cb6:	38 ca                	cmp    %cl,%dl
  800cb8:	74 0f                	je     800cc9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cba:	83 c0 01             	add    $0x1,%eax
  800cbd:	0f b6 10             	movzbl (%eax),%edx
  800cc0:	84 d2                	test   %dl,%dl
  800cc2:	75 f2                	jne    800cb6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd5:	eb 07                	jmp    800cde <strfind+0x13>
		if (*s == c)
  800cd7:	38 ca                	cmp    %cl,%dl
  800cd9:	74 0a                	je     800ce5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cdb:	83 c0 01             	add    $0x1,%eax
  800cde:	0f b6 10             	movzbl (%eax),%edx
  800ce1:	84 d2                	test   %dl,%dl
  800ce3:	75 f2                	jne    800cd7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
  800ced:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cf3:	85 c9                	test   %ecx,%ecx
  800cf5:	74 36                	je     800d2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cf7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cfd:	75 28                	jne    800d27 <memset+0x40>
  800cff:	f6 c1 03             	test   $0x3,%cl
  800d02:	75 23                	jne    800d27 <memset+0x40>
		c &= 0xFF;
  800d04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d08:	89 d3                	mov    %edx,%ebx
  800d0a:	c1 e3 08             	shl    $0x8,%ebx
  800d0d:	89 d6                	mov    %edx,%esi
  800d0f:	c1 e6 18             	shl    $0x18,%esi
  800d12:	89 d0                	mov    %edx,%eax
  800d14:	c1 e0 10             	shl    $0x10,%eax
  800d17:	09 f0                	or     %esi,%eax
  800d19:	09 c2                	or     %eax,%edx
  800d1b:	89 d0                	mov    %edx,%eax
  800d1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800d22:	fc                   	cld    
  800d23:	f3 ab                	rep stos %eax,%es:(%edi)
  800d25:	eb 06                	jmp    800d2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	fc                   	cld    
  800d2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d2d:	89 f8                	mov    %edi,%eax
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d42:	39 c6                	cmp    %eax,%esi
  800d44:	73 35                	jae    800d7b <memmove+0x47>
  800d46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d49:	39 d0                	cmp    %edx,%eax
  800d4b:	73 2e                	jae    800d7b <memmove+0x47>
		s += n;
		d += n;
  800d4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800d50:	89 d6                	mov    %edx,%esi
  800d52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d5a:	75 13                	jne    800d6f <memmove+0x3b>
  800d5c:	f6 c1 03             	test   $0x3,%cl
  800d5f:	75 0e                	jne    800d6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d61:	83 ef 04             	sub    $0x4,%edi
  800d64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800d6a:	fd                   	std    
  800d6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d6d:	eb 09                	jmp    800d78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d6f:	83 ef 01             	sub    $0x1,%edi
  800d72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d75:	fd                   	std    
  800d76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d78:	fc                   	cld    
  800d79:	eb 1d                	jmp    800d98 <memmove+0x64>
  800d7b:	89 f2                	mov    %esi,%edx
  800d7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d7f:	f6 c2 03             	test   $0x3,%dl
  800d82:	75 0f                	jne    800d93 <memmove+0x5f>
  800d84:	f6 c1 03             	test   $0x3,%cl
  800d87:	75 0a                	jne    800d93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d8c:	89 c7                	mov    %eax,%edi
  800d8e:	fc                   	cld    
  800d8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d91:	eb 05                	jmp    800d98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d93:	89 c7                	mov    %eax,%edi
  800d95:	fc                   	cld    
  800d96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800db0:	8b 45 08             	mov    0x8(%ebp),%eax
  800db3:	89 04 24             	mov    %eax,(%esp)
  800db6:	e8 79 ff ff ff       	call   800d34 <memmove>
}
  800dbb:	c9                   	leave  
  800dbc:	c3                   	ret    

00800dbd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
  800dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	89 d6                	mov    %edx,%esi
  800dca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dcd:	eb 1a                	jmp    800de9 <memcmp+0x2c>
		if (*s1 != *s2)
  800dcf:	0f b6 02             	movzbl (%edx),%eax
  800dd2:	0f b6 19             	movzbl (%ecx),%ebx
  800dd5:	38 d8                	cmp    %bl,%al
  800dd7:	74 0a                	je     800de3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800dd9:	0f b6 c0             	movzbl %al,%eax
  800ddc:	0f b6 db             	movzbl %bl,%ebx
  800ddf:	29 d8                	sub    %ebx,%eax
  800de1:	eb 0f                	jmp    800df2 <memcmp+0x35>
		s1++, s2++;
  800de3:	83 c2 01             	add    $0x1,%edx
  800de6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800de9:	39 f2                	cmp    %esi,%edx
  800deb:	75 e2                	jne    800dcf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800dff:	89 c2                	mov    %eax,%edx
  800e01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e04:	eb 07                	jmp    800e0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e06:	38 08                	cmp    %cl,(%eax)
  800e08:	74 07                	je     800e11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e0a:	83 c0 01             	add    $0x1,%eax
  800e0d:	39 d0                	cmp    %edx,%eax
  800e0f:	72 f5                	jb     800e06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e1f:	eb 03                	jmp    800e24 <strtol+0x11>
		s++;
  800e21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e24:	0f b6 0a             	movzbl (%edx),%ecx
  800e27:	80 f9 09             	cmp    $0x9,%cl
  800e2a:	74 f5                	je     800e21 <strtol+0xe>
  800e2c:	80 f9 20             	cmp    $0x20,%cl
  800e2f:	74 f0                	je     800e21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e31:	80 f9 2b             	cmp    $0x2b,%cl
  800e34:	75 0a                	jne    800e40 <strtol+0x2d>
		s++;
  800e36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e39:	bf 00 00 00 00       	mov    $0x0,%edi
  800e3e:	eb 11                	jmp    800e51 <strtol+0x3e>
  800e40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e45:	80 f9 2d             	cmp    $0x2d,%cl
  800e48:	75 07                	jne    800e51 <strtol+0x3e>
		s++, neg = 1;
  800e4a:	8d 52 01             	lea    0x1(%edx),%edx
  800e4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800e56:	75 15                	jne    800e6d <strtol+0x5a>
  800e58:	80 3a 30             	cmpb   $0x30,(%edx)
  800e5b:	75 10                	jne    800e6d <strtol+0x5a>
  800e5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e61:	75 0a                	jne    800e6d <strtol+0x5a>
		s += 2, base = 16;
  800e63:	83 c2 02             	add    $0x2,%edx
  800e66:	b8 10 00 00 00       	mov    $0x10,%eax
  800e6b:	eb 10                	jmp    800e7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	75 0c                	jne    800e7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e73:	80 3a 30             	cmpb   $0x30,(%edx)
  800e76:	75 05                	jne    800e7d <strtol+0x6a>
		s++, base = 8;
  800e78:	83 c2 01             	add    $0x1,%edx
  800e7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800e7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e85:	0f b6 0a             	movzbl (%edx),%ecx
  800e88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800e8b:	89 f0                	mov    %esi,%eax
  800e8d:	3c 09                	cmp    $0x9,%al
  800e8f:	77 08                	ja     800e99 <strtol+0x86>
			dig = *s - '0';
  800e91:	0f be c9             	movsbl %cl,%ecx
  800e94:	83 e9 30             	sub    $0x30,%ecx
  800e97:	eb 20                	jmp    800eb9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800e99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800e9c:	89 f0                	mov    %esi,%eax
  800e9e:	3c 19                	cmp    $0x19,%al
  800ea0:	77 08                	ja     800eaa <strtol+0x97>
			dig = *s - 'a' + 10;
  800ea2:	0f be c9             	movsbl %cl,%ecx
  800ea5:	83 e9 57             	sub    $0x57,%ecx
  800ea8:	eb 0f                	jmp    800eb9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800eaa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800ead:	89 f0                	mov    %esi,%eax
  800eaf:	3c 19                	cmp    $0x19,%al
  800eb1:	77 16                	ja     800ec9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800eb3:	0f be c9             	movsbl %cl,%ecx
  800eb6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800eb9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ebc:	7d 0f                	jge    800ecd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800ebe:	83 c2 01             	add    $0x1,%edx
  800ec1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ec5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ec7:	eb bc                	jmp    800e85 <strtol+0x72>
  800ec9:	89 d8                	mov    %ebx,%eax
  800ecb:	eb 02                	jmp    800ecf <strtol+0xbc>
  800ecd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ecf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed3:	74 05                	je     800eda <strtol+0xc7>
		*endptr = (char *) s;
  800ed5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ed8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800eda:	f7 d8                	neg    %eax
  800edc:	85 ff                	test   %edi,%edi
  800ede:	0f 44 c3             	cmove  %ebx,%eax
}
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	57                   	push   %edi
  800eea:	56                   	push   %esi
  800eeb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eec:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	89 c3                	mov    %eax,%ebx
  800ef9:	89 c7                	mov    %eax,%edi
  800efb:	89 c6                	mov    %eax,%esi
  800efd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800eff:	5b                   	pop    %ebx
  800f00:	5e                   	pop    %esi
  800f01:	5f                   	pop    %edi
  800f02:	5d                   	pop    %ebp
  800f03:	c3                   	ret    

00800f04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f04:	55                   	push   %ebp
  800f05:	89 e5                	mov    %esp,%ebp
  800f07:	57                   	push   %edi
  800f08:	56                   	push   %esi
  800f09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800f14:	89 d1                	mov    %edx,%ecx
  800f16:	89 d3                	mov    %edx,%ebx
  800f18:	89 d7                	mov    %edx,%edi
  800f1a:	89 d6                	mov    %edx,%esi
  800f1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
  800f29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f31:	b8 03 00 00 00       	mov    $0x3,%eax
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	89 cb                	mov    %ecx,%ebx
  800f3b:	89 cf                	mov    %ecx,%edi
  800f3d:	89 ce                	mov    %ecx,%esi
  800f3f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f41:	85 c0                	test   %eax,%eax
  800f43:	7e 28                	jle    800f6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f50:	00 
  800f51:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  800f58:	00 
  800f59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f60:	00 
  800f61:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  800f68:	e8 04 f5 ff ff       	call   800471 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f6d:	83 c4 2c             	add    $0x2c,%esp
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	57                   	push   %edi
  800f79:	56                   	push   %esi
  800f7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f80:	b8 02 00 00 00       	mov    $0x2,%eax
  800f85:	89 d1                	mov    %edx,%ecx
  800f87:	89 d3                	mov    %edx,%ebx
  800f89:	89 d7                	mov    %edx,%edi
  800f8b:	89 d6                	mov    %edx,%esi
  800f8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f8f:	5b                   	pop    %ebx
  800f90:	5e                   	pop    %esi
  800f91:	5f                   	pop    %edi
  800f92:	5d                   	pop    %ebp
  800f93:	c3                   	ret    

00800f94 <sys_yield>:

void
sys_yield(void)
{
  800f94:	55                   	push   %ebp
  800f95:	89 e5                	mov    %esp,%ebp
  800f97:	57                   	push   %edi
  800f98:	56                   	push   %esi
  800f99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fa4:	89 d1                	mov    %edx,%ecx
  800fa6:	89 d3                	mov    %edx,%ebx
  800fa8:	89 d7                	mov    %edx,%edi
  800faa:	89 d6                	mov    %edx,%esi
  800fac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	57                   	push   %edi
  800fb7:	56                   	push   %esi
  800fb8:	53                   	push   %ebx
  800fb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbc:	be 00 00 00 00       	mov    $0x0,%esi
  800fc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fcf:	89 f7                	mov    %esi,%edi
  800fd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	7e 28                	jle    800fff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fe2:	00 
  800fe3:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  800fea:	00 
  800feb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff2:	00 
  800ff3:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  800ffa:	e8 72 f4 ff ff       	call   800471 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fff:	83 c4 2c             	add    $0x2c,%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
  80100d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801010:	b8 05 00 00 00       	mov    $0x5,%eax
  801015:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801018:	8b 55 08             	mov    0x8(%ebp),%edx
  80101b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80101e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801021:	8b 75 18             	mov    0x18(%ebp),%esi
  801024:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801026:	85 c0                	test   %eax,%eax
  801028:	7e 28                	jle    801052 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80102a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801035:	00 
  801036:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  80103d:	00 
  80103e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801045:	00 
  801046:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  80104d:	e8 1f f4 ff ff       	call   800471 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801052:	83 c4 2c             	add    $0x2c,%esp
  801055:	5b                   	pop    %ebx
  801056:	5e                   	pop    %esi
  801057:	5f                   	pop    %edi
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    

0080105a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801063:	bb 00 00 00 00       	mov    $0x0,%ebx
  801068:	b8 06 00 00 00       	mov    $0x6,%eax
  80106d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801070:	8b 55 08             	mov    0x8(%ebp),%edx
  801073:	89 df                	mov    %ebx,%edi
  801075:	89 de                	mov    %ebx,%esi
  801077:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801079:	85 c0                	test   %eax,%eax
  80107b:	7e 28                	jle    8010a5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801081:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801088:	00 
  801089:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  801090:	00 
  801091:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801098:	00 
  801099:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  8010a0:	e8 cc f3 ff ff       	call   800471 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010a5:	83 c4 2c             	add    $0x2c,%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    

008010ad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	57                   	push   %edi
  8010b1:	56                   	push   %esi
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8010c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c6:	89 df                	mov    %ebx,%edi
  8010c8:	89 de                	mov    %ebx,%esi
  8010ca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	7e 28                	jle    8010f8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010db:	00 
  8010dc:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  8010e3:	00 
  8010e4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010eb:	00 
  8010ec:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  8010f3:	e8 79 f3 ff ff       	call   800471 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010f8:	83 c4 2c             	add    $0x2c,%esp
  8010fb:	5b                   	pop    %ebx
  8010fc:	5e                   	pop    %esi
  8010fd:	5f                   	pop    %edi
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	57                   	push   %edi
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
  801106:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801109:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110e:	b8 09 00 00 00       	mov    $0x9,%eax
  801113:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801116:	8b 55 08             	mov    0x8(%ebp),%edx
  801119:	89 df                	mov    %ebx,%edi
  80111b:	89 de                	mov    %ebx,%esi
  80111d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80111f:	85 c0                	test   %eax,%eax
  801121:	7e 28                	jle    80114b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801123:	89 44 24 10          	mov    %eax,0x10(%esp)
  801127:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80112e:	00 
  80112f:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  801136:	00 
  801137:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80113e:	00 
  80113f:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  801146:	e8 26 f3 ff ff       	call   800471 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80114b:	83 c4 2c             	add    $0x2c,%esp
  80114e:	5b                   	pop    %ebx
  80114f:	5e                   	pop    %esi
  801150:	5f                   	pop    %edi
  801151:	5d                   	pop    %ebp
  801152:	c3                   	ret    

00801153 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	57                   	push   %edi
  801157:	56                   	push   %esi
  801158:	53                   	push   %ebx
  801159:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80115c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801161:	b8 0a 00 00 00       	mov    $0xa,%eax
  801166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801169:	8b 55 08             	mov    0x8(%ebp),%edx
  80116c:	89 df                	mov    %ebx,%edi
  80116e:	89 de                	mov    %ebx,%esi
  801170:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801172:	85 c0                	test   %eax,%eax
  801174:	7e 28                	jle    80119e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801176:	89 44 24 10          	mov    %eax,0x10(%esp)
  80117a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801181:	00 
  801182:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  801189:	00 
  80118a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801191:	00 
  801192:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  801199:	e8 d3 f2 ff ff       	call   800471 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80119e:	83 c4 2c             	add    $0x2c,%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    

008011a6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	57                   	push   %edi
  8011aa:	56                   	push   %esi
  8011ab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ac:	be 00 00 00 00       	mov    $0x0,%esi
  8011b1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011c2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011c4:	5b                   	pop    %ebx
  8011c5:	5e                   	pop    %esi
  8011c6:	5f                   	pop    %edi
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    

008011c9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	57                   	push   %edi
  8011cd:	56                   	push   %esi
  8011ce:	53                   	push   %ebx
  8011cf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011df:	89 cb                	mov    %ecx,%ebx
  8011e1:	89 cf                	mov    %ecx,%edi
  8011e3:	89 ce                	mov    %ecx,%esi
  8011e5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	7e 28                	jle    801213 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8011f6:	00 
  8011f7:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  8011fe:	00 
  8011ff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801206:	00 
  801207:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  80120e:	e8 5e f2 ff ff       	call   800471 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801213:	83 c4 2c             	add    $0x2c,%esp
  801216:	5b                   	pop    %ebx
  801217:	5e                   	pop    %esi
  801218:	5f                   	pop    %edi
  801219:	5d                   	pop    %ebp
  80121a:	c3                   	ret    

0080121b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	57                   	push   %edi
  80121f:	56                   	push   %esi
  801220:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801221:	ba 00 00 00 00       	mov    $0x0,%edx
  801226:	b8 0e 00 00 00       	mov    $0xe,%eax
  80122b:	89 d1                	mov    %edx,%ecx
  80122d:	89 d3                	mov    %edx,%ebx
  80122f:	89 d7                	mov    %edx,%edi
  801231:	89 d6                	mov    %edx,%esi
  801233:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801235:	5b                   	pop    %ebx
  801236:	5e                   	pop    %esi
  801237:	5f                   	pop    %edi
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	57                   	push   %edi
  80123e:	56                   	push   %esi
  80123f:	53                   	push   %ebx
  801240:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801243:	bb 00 00 00 00       	mov    $0x0,%ebx
  801248:	b8 0f 00 00 00       	mov    $0xf,%eax
  80124d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801250:	8b 55 08             	mov    0x8(%ebp),%edx
  801253:	89 df                	mov    %ebx,%edi
  801255:	89 de                	mov    %ebx,%esi
  801257:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801259:	85 c0                	test   %eax,%eax
  80125b:	7e 28                	jle    801285 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80125d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801261:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801268:	00 
  801269:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  801270:	00 
  801271:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801278:	00 
  801279:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  801280:	e8 ec f1 ff ff       	call   800471 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801285:	83 c4 2c             	add    $0x2c,%esp
  801288:	5b                   	pop    %ebx
  801289:	5e                   	pop    %esi
  80128a:	5f                   	pop    %edi
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
  801290:	57                   	push   %edi
  801291:	56                   	push   %esi
  801292:	53                   	push   %ebx
  801293:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801296:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129b:	b8 10 00 00 00       	mov    $0x10,%eax
  8012a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a6:	89 df                	mov    %ebx,%edi
  8012a8:	89 de                	mov    %ebx,%esi
  8012aa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	7e 28                	jle    8012d8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8012bb:	00 
  8012bc:	c7 44 24 08 bf 32 80 	movl   $0x8032bf,0x8(%esp)
  8012c3:	00 
  8012c4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012cb:	00 
  8012cc:	c7 04 24 dc 32 80 00 	movl   $0x8032dc,(%esp)
  8012d3:	e8 99 f1 ff ff       	call   800471 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8012d8:	83 c4 2c             	add    $0x2c,%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    

008012f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8012fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801300:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801305:	5d                   	pop    %ebp
  801306:	c3                   	ret    

00801307 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801312:	89 c2                	mov    %eax,%edx
  801314:	c1 ea 16             	shr    $0x16,%edx
  801317:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131e:	f6 c2 01             	test   $0x1,%dl
  801321:	74 11                	je     801334 <fd_alloc+0x2d>
  801323:	89 c2                	mov    %eax,%edx
  801325:	c1 ea 0c             	shr    $0xc,%edx
  801328:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132f:	f6 c2 01             	test   $0x1,%dl
  801332:	75 09                	jne    80133d <fd_alloc+0x36>
			*fd_store = fd;
  801334:	89 01                	mov    %eax,(%ecx)
			return 0;
  801336:	b8 00 00 00 00       	mov    $0x0,%eax
  80133b:	eb 17                	jmp    801354 <fd_alloc+0x4d>
  80133d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801342:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801347:	75 c9                	jne    801312 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801349:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80134f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    

00801356 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80135c:	83 f8 1f             	cmp    $0x1f,%eax
  80135f:	77 36                	ja     801397 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801361:	c1 e0 0c             	shl    $0xc,%eax
  801364:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801369:	89 c2                	mov    %eax,%edx
  80136b:	c1 ea 16             	shr    $0x16,%edx
  80136e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801375:	f6 c2 01             	test   $0x1,%dl
  801378:	74 24                	je     80139e <fd_lookup+0x48>
  80137a:	89 c2                	mov    %eax,%edx
  80137c:	c1 ea 0c             	shr    $0xc,%edx
  80137f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801386:	f6 c2 01             	test   $0x1,%dl
  801389:	74 1a                	je     8013a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80138b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80138e:	89 02                	mov    %eax,(%edx)
	return 0;
  801390:	b8 00 00 00 00       	mov    $0x0,%eax
  801395:	eb 13                	jmp    8013aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801397:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139c:	eb 0c                	jmp    8013aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80139e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a3:	eb 05                	jmp    8013aa <fd_lookup+0x54>
  8013a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    

008013ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 18             	sub    $0x18,%esp
  8013b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8013b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ba:	eb 13                	jmp    8013cf <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8013bc:	39 08                	cmp    %ecx,(%eax)
  8013be:	75 0c                	jne    8013cc <dev_lookup+0x20>
			*dev = devtab[i];
  8013c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ca:	eb 38                	jmp    801404 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8013cc:	83 c2 01             	add    $0x1,%edx
  8013cf:	8b 04 95 68 33 80 00 	mov    0x803368(,%edx,4),%eax
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	75 e2                	jne    8013bc <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013da:	a1 90 77 80 00       	mov    0x807790,%eax
  8013df:	8b 40 48             	mov    0x48(%eax),%eax
  8013e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ea:	c7 04 24 ec 32 80 00 	movl   $0x8032ec,(%esp)
  8013f1:	e8 74 f1 ff ff       	call   80056a <cprintf>
	*dev = 0;
  8013f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801404:	c9                   	leave  
  801405:	c3                   	ret    

00801406 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
  80140b:	83 ec 20             	sub    $0x20,%esp
  80140e:	8b 75 08             	mov    0x8(%ebp),%esi
  801411:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801414:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801417:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80141b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801421:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801424:	89 04 24             	mov    %eax,(%esp)
  801427:	e8 2a ff ff ff       	call   801356 <fd_lookup>
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 05                	js     801435 <fd_close+0x2f>
	    || fd != fd2)
  801430:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801433:	74 0c                	je     801441 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801435:	84 db                	test   %bl,%bl
  801437:	ba 00 00 00 00       	mov    $0x0,%edx
  80143c:	0f 44 c2             	cmove  %edx,%eax
  80143f:	eb 3f                	jmp    801480 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801441:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801444:	89 44 24 04          	mov    %eax,0x4(%esp)
  801448:	8b 06                	mov    (%esi),%eax
  80144a:	89 04 24             	mov    %eax,(%esp)
  80144d:	e8 5a ff ff ff       	call   8013ac <dev_lookup>
  801452:	89 c3                	mov    %eax,%ebx
  801454:	85 c0                	test   %eax,%eax
  801456:	78 16                	js     80146e <fd_close+0x68>
		if (dev->dev_close)
  801458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80145e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801463:	85 c0                	test   %eax,%eax
  801465:	74 07                	je     80146e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801467:	89 34 24             	mov    %esi,(%esp)
  80146a:	ff d0                	call   *%eax
  80146c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80146e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801472:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801479:	e8 dc fb ff ff       	call   80105a <sys_page_unmap>
	return r;
  80147e:	89 d8                	mov    %ebx,%eax
}
  801480:	83 c4 20             	add    $0x20,%esp
  801483:	5b                   	pop    %ebx
  801484:	5e                   	pop    %esi
  801485:	5d                   	pop    %ebp
  801486:	c3                   	ret    

00801487 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80148d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801490:	89 44 24 04          	mov    %eax,0x4(%esp)
  801494:	8b 45 08             	mov    0x8(%ebp),%eax
  801497:	89 04 24             	mov    %eax,(%esp)
  80149a:	e8 b7 fe ff ff       	call   801356 <fd_lookup>
  80149f:	89 c2                	mov    %eax,%edx
  8014a1:	85 d2                	test   %edx,%edx
  8014a3:	78 13                	js     8014b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8014a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014ac:	00 
  8014ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b0:	89 04 24             	mov    %eax,(%esp)
  8014b3:	e8 4e ff ff ff       	call   801406 <fd_close>
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <close_all>:

void
close_all(void)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	53                   	push   %ebx
  8014be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014c6:	89 1c 24             	mov    %ebx,(%esp)
  8014c9:	e8 b9 ff ff ff       	call   801487 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8014ce:	83 c3 01             	add    $0x1,%ebx
  8014d1:	83 fb 20             	cmp    $0x20,%ebx
  8014d4:	75 f0                	jne    8014c6 <close_all+0xc>
		close(i);
}
  8014d6:	83 c4 14             	add    $0x14,%esp
  8014d9:	5b                   	pop    %ebx
  8014da:	5d                   	pop    %ebp
  8014db:	c3                   	ret    

008014dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	57                   	push   %edi
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
  8014e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ef:	89 04 24             	mov    %eax,(%esp)
  8014f2:	e8 5f fe ff ff       	call   801356 <fd_lookup>
  8014f7:	89 c2                	mov    %eax,%edx
  8014f9:	85 d2                	test   %edx,%edx
  8014fb:	0f 88 e1 00 00 00    	js     8015e2 <dup+0x106>
		return r;
	close(newfdnum);
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	89 04 24             	mov    %eax,(%esp)
  801507:	e8 7b ff ff ff       	call   801487 <close>

	newfd = INDEX2FD(newfdnum);
  80150c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80150f:	c1 e3 0c             	shl    $0xc,%ebx
  801512:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801518:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80151b:	89 04 24             	mov    %eax,(%esp)
  80151e:	e8 cd fd ff ff       	call   8012f0 <fd2data>
  801523:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801525:	89 1c 24             	mov    %ebx,(%esp)
  801528:	e8 c3 fd ff ff       	call   8012f0 <fd2data>
  80152d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80152f:	89 f0                	mov    %esi,%eax
  801531:	c1 e8 16             	shr    $0x16,%eax
  801534:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80153b:	a8 01                	test   $0x1,%al
  80153d:	74 43                	je     801582 <dup+0xa6>
  80153f:	89 f0                	mov    %esi,%eax
  801541:	c1 e8 0c             	shr    $0xc,%eax
  801544:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80154b:	f6 c2 01             	test   $0x1,%dl
  80154e:	74 32                	je     801582 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801550:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801557:	25 07 0e 00 00       	and    $0xe07,%eax
  80155c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801560:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801564:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80156b:	00 
  80156c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801570:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801577:	e8 8b fa ff ff       	call   801007 <sys_page_map>
  80157c:	89 c6                	mov    %eax,%esi
  80157e:	85 c0                	test   %eax,%eax
  801580:	78 3e                	js     8015c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801585:	89 c2                	mov    %eax,%edx
  801587:	c1 ea 0c             	shr    $0xc,%edx
  80158a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801591:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801597:	89 54 24 10          	mov    %edx,0x10(%esp)
  80159b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80159f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015a6:	00 
  8015a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b2:	e8 50 fa ff ff       	call   801007 <sys_page_map>
  8015b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8015b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015bc:	85 f6                	test   %esi,%esi
  8015be:	79 22                	jns    8015e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015cb:	e8 8a fa ff ff       	call   80105a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015db:	e8 7a fa ff ff       	call   80105a <sys_page_unmap>
	return r;
  8015e0:	89 f0                	mov    %esi,%eax
}
  8015e2:	83 c4 3c             	add    $0x3c,%esp
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5f                   	pop    %edi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	53                   	push   %ebx
  8015ee:	83 ec 24             	sub    $0x24,%esp
  8015f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fb:	89 1c 24             	mov    %ebx,(%esp)
  8015fe:	e8 53 fd ff ff       	call   801356 <fd_lookup>
  801603:	89 c2                	mov    %eax,%edx
  801605:	85 d2                	test   %edx,%edx
  801607:	78 6d                	js     801676 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801609:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801613:	8b 00                	mov    (%eax),%eax
  801615:	89 04 24             	mov    %eax,(%esp)
  801618:	e8 8f fd ff ff       	call   8013ac <dev_lookup>
  80161d:	85 c0                	test   %eax,%eax
  80161f:	78 55                	js     801676 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801624:	8b 50 08             	mov    0x8(%eax),%edx
  801627:	83 e2 03             	and    $0x3,%edx
  80162a:	83 fa 01             	cmp    $0x1,%edx
  80162d:	75 23                	jne    801652 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80162f:	a1 90 77 80 00       	mov    0x807790,%eax
  801634:	8b 40 48             	mov    0x48(%eax),%eax
  801637:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80163b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163f:	c7 04 24 2d 33 80 00 	movl   $0x80332d,(%esp)
  801646:	e8 1f ef ff ff       	call   80056a <cprintf>
		return -E_INVAL;
  80164b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801650:	eb 24                	jmp    801676 <read+0x8c>
	}
	if (!dev->dev_read)
  801652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801655:	8b 52 08             	mov    0x8(%edx),%edx
  801658:	85 d2                	test   %edx,%edx
  80165a:	74 15                	je     801671 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80165c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80165f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801663:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801666:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80166a:	89 04 24             	mov    %eax,(%esp)
  80166d:	ff d2                	call   *%edx
  80166f:	eb 05                	jmp    801676 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801671:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801676:	83 c4 24             	add    $0x24,%esp
  801679:	5b                   	pop    %ebx
  80167a:	5d                   	pop    %ebp
  80167b:	c3                   	ret    

0080167c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	57                   	push   %edi
  801680:	56                   	push   %esi
  801681:	53                   	push   %ebx
  801682:	83 ec 1c             	sub    $0x1c,%esp
  801685:	8b 7d 08             	mov    0x8(%ebp),%edi
  801688:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80168b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801690:	eb 23                	jmp    8016b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801692:	89 f0                	mov    %esi,%eax
  801694:	29 d8                	sub    %ebx,%eax
  801696:	89 44 24 08          	mov    %eax,0x8(%esp)
  80169a:	89 d8                	mov    %ebx,%eax
  80169c:	03 45 0c             	add    0xc(%ebp),%eax
  80169f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a3:	89 3c 24             	mov    %edi,(%esp)
  8016a6:	e8 3f ff ff ff       	call   8015ea <read>
		if (m < 0)
  8016ab:	85 c0                	test   %eax,%eax
  8016ad:	78 10                	js     8016bf <readn+0x43>
			return m;
		if (m == 0)
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	74 0a                	je     8016bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016b3:	01 c3                	add    %eax,%ebx
  8016b5:	39 f3                	cmp    %esi,%ebx
  8016b7:	72 d9                	jb     801692 <readn+0x16>
  8016b9:	89 d8                	mov    %ebx,%eax
  8016bb:	eb 02                	jmp    8016bf <readn+0x43>
  8016bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016bf:	83 c4 1c             	add    $0x1c,%esp
  8016c2:	5b                   	pop    %ebx
  8016c3:	5e                   	pop    %esi
  8016c4:	5f                   	pop    %edi
  8016c5:	5d                   	pop    %ebp
  8016c6:	c3                   	ret    

008016c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	53                   	push   %ebx
  8016cb:	83 ec 24             	sub    $0x24,%esp
  8016ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d8:	89 1c 24             	mov    %ebx,(%esp)
  8016db:	e8 76 fc ff ff       	call   801356 <fd_lookup>
  8016e0:	89 c2                	mov    %eax,%edx
  8016e2:	85 d2                	test   %edx,%edx
  8016e4:	78 68                	js     80174e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	8b 00                	mov    (%eax),%eax
  8016f2:	89 04 24             	mov    %eax,(%esp)
  8016f5:	e8 b2 fc ff ff       	call   8013ac <dev_lookup>
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	78 50                	js     80174e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801701:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801705:	75 23                	jne    80172a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801707:	a1 90 77 80 00       	mov    0x807790,%eax
  80170c:	8b 40 48             	mov    0x48(%eax),%eax
  80170f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801713:	89 44 24 04          	mov    %eax,0x4(%esp)
  801717:	c7 04 24 49 33 80 00 	movl   $0x803349,(%esp)
  80171e:	e8 47 ee ff ff       	call   80056a <cprintf>
		return -E_INVAL;
  801723:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801728:	eb 24                	jmp    80174e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80172a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80172d:	8b 52 0c             	mov    0xc(%edx),%edx
  801730:	85 d2                	test   %edx,%edx
  801732:	74 15                	je     801749 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801734:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801737:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80173b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80173e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801742:	89 04 24             	mov    %eax,(%esp)
  801745:	ff d2                	call   *%edx
  801747:	eb 05                	jmp    80174e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801749:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80174e:	83 c4 24             	add    $0x24,%esp
  801751:	5b                   	pop    %ebx
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <seek>:

int
seek(int fdnum, off_t offset)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80175a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80175d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801761:	8b 45 08             	mov    0x8(%ebp),%eax
  801764:	89 04 24             	mov    %eax,(%esp)
  801767:	e8 ea fb ff ff       	call   801356 <fd_lookup>
  80176c:	85 c0                	test   %eax,%eax
  80176e:	78 0e                	js     80177e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801770:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801773:	8b 55 0c             	mov    0xc(%ebp),%edx
  801776:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	53                   	push   %ebx
  801784:	83 ec 24             	sub    $0x24,%esp
  801787:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80178d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801791:	89 1c 24             	mov    %ebx,(%esp)
  801794:	e8 bd fb ff ff       	call   801356 <fd_lookup>
  801799:	89 c2                	mov    %eax,%edx
  80179b:	85 d2                	test   %edx,%edx
  80179d:	78 61                	js     801800 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80179f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a9:	8b 00                	mov    (%eax),%eax
  8017ab:	89 04 24             	mov    %eax,(%esp)
  8017ae:	e8 f9 fb ff ff       	call   8013ac <dev_lookup>
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	78 49                	js     801800 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017be:	75 23                	jne    8017e3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017c0:	a1 90 77 80 00       	mov    0x807790,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017c5:	8b 40 48             	mov    0x48(%eax),%eax
  8017c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d0:	c7 04 24 0c 33 80 00 	movl   $0x80330c,(%esp)
  8017d7:	e8 8e ed ff ff       	call   80056a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017e1:	eb 1d                	jmp    801800 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8017e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e6:	8b 52 18             	mov    0x18(%edx),%edx
  8017e9:	85 d2                	test   %edx,%edx
  8017eb:	74 0e                	je     8017fb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017f4:	89 04 24             	mov    %eax,(%esp)
  8017f7:	ff d2                	call   *%edx
  8017f9:	eb 05                	jmp    801800 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8017fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801800:	83 c4 24             	add    $0x24,%esp
  801803:	5b                   	pop    %ebx
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    

00801806 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	53                   	push   %ebx
  80180a:	83 ec 24             	sub    $0x24,%esp
  80180d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801810:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801813:	89 44 24 04          	mov    %eax,0x4(%esp)
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	89 04 24             	mov    %eax,(%esp)
  80181d:	e8 34 fb ff ff       	call   801356 <fd_lookup>
  801822:	89 c2                	mov    %eax,%edx
  801824:	85 d2                	test   %edx,%edx
  801826:	78 52                	js     80187a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801828:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801832:	8b 00                	mov    (%eax),%eax
  801834:	89 04 24             	mov    %eax,(%esp)
  801837:	e8 70 fb ff ff       	call   8013ac <dev_lookup>
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 3a                	js     80187a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801843:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801847:	74 2c                	je     801875 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801849:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80184c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801853:	00 00 00 
	stat->st_isdir = 0;
  801856:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80185d:	00 00 00 
	stat->st_dev = dev;
  801860:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801866:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80186a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80186d:	89 14 24             	mov    %edx,(%esp)
  801870:	ff 50 14             	call   *0x14(%eax)
  801873:	eb 05                	jmp    80187a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801875:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80187a:	83 c4 24             	add    $0x24,%esp
  80187d:	5b                   	pop    %ebx
  80187e:	5d                   	pop    %ebp
  80187f:	c3                   	ret    

00801880 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801888:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80188f:	00 
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	89 04 24             	mov    %eax,(%esp)
  801896:	e8 28 02 00 00       	call   801ac3 <open>
  80189b:	89 c3                	mov    %eax,%ebx
  80189d:	85 db                	test   %ebx,%ebx
  80189f:	78 1b                	js     8018bc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8018a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a8:	89 1c 24             	mov    %ebx,(%esp)
  8018ab:	e8 56 ff ff ff       	call   801806 <fstat>
  8018b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8018b2:	89 1c 24             	mov    %ebx,(%esp)
  8018b5:	e8 cd fb ff ff       	call   801487 <close>
	return r;
  8018ba:	89 f0                	mov    %esi,%eax
}
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5d                   	pop    %ebp
  8018c2:	c3                   	ret    

008018c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 10             	sub    $0x10,%esp
  8018cb:	89 c6                	mov    %eax,%esi
  8018cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018cf:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8018d6:	75 11                	jne    8018e9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8018df:	e8 4e 12 00 00       	call   802b32 <ipc_find_env>
  8018e4:	a3 00 60 80 00       	mov    %eax,0x806000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018e9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8018f0:	00 
  8018f1:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8018f8:	00 
  8018f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018fd:	a1 00 60 80 00       	mov    0x806000,%eax
  801902:	89 04 24             	mov    %eax,(%esp)
  801905:	e8 ca 11 00 00       	call   802ad4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80190a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801911:	00 
  801912:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801916:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80191d:	e8 48 11 00 00       	call   802a6a <ipc_recv>
}
  801922:	83 c4 10             	add    $0x10,%esp
  801925:	5b                   	pop    %ebx
  801926:	5e                   	pop    %esi
  801927:	5d                   	pop    %ebp
  801928:	c3                   	ret    

00801929 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	8b 40 0c             	mov    0xc(%eax),%eax
  801935:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  80193a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193d:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801942:	ba 00 00 00 00       	mov    $0x0,%edx
  801947:	b8 02 00 00 00       	mov    $0x2,%eax
  80194c:	e8 72 ff ff ff       	call   8018c3 <fsipc>
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8b 40 0c             	mov    0xc(%eax),%eax
  80195f:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  801964:	ba 00 00 00 00       	mov    $0x0,%edx
  801969:	b8 06 00 00 00       	mov    $0x6,%eax
  80196e:	e8 50 ff ff ff       	call   8018c3 <fsipc>
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	53                   	push   %ebx
  801979:	83 ec 14             	sub    $0x14,%esp
  80197c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8b 40 0c             	mov    0xc(%eax),%eax
  801985:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80198a:	ba 00 00 00 00       	mov    $0x0,%edx
  80198f:	b8 05 00 00 00       	mov    $0x5,%eax
  801994:	e8 2a ff ff ff       	call   8018c3 <fsipc>
  801999:	89 c2                	mov    %eax,%edx
  80199b:	85 d2                	test   %edx,%edx
  80199d:	78 2b                	js     8019ca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80199f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8019a6:	00 
  8019a7:	89 1c 24             	mov    %ebx,(%esp)
  8019aa:	e8 e8 f1 ff ff       	call   800b97 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019af:	a1 80 80 80 00       	mov    0x808080,%eax
  8019b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019ba:	a1 84 80 80 00       	mov    0x808084,%eax
  8019bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ca:	83 c4 14             	add    $0x14,%esp
  8019cd:	5b                   	pop    %ebx
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    

008019d0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 18             	sub    $0x18,%esp
  8019d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019de:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8019e3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  8019e6:	a3 04 80 80 00       	mov    %eax,0x808004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ee:	8b 52 0c             	mov    0xc(%edx),%edx
  8019f1:	89 15 00 80 80 00    	mov    %edx,0x808000
    memmove(fsipcbuf.write.req_buf,buf,n);
  8019f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a02:	c7 04 24 08 80 80 00 	movl   $0x808008,(%esp)
  801a09:	e8 26 f3 ff ff       	call   800d34 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a13:	b8 04 00 00 00       	mov    $0x4,%eax
  801a18:	e8 a6 fe ff ff       	call   8018c3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	56                   	push   %esi
  801a23:	53                   	push   %ebx
  801a24:	83 ec 10             	sub    $0x10,%esp
  801a27:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a30:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801a35:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a40:	b8 03 00 00 00       	mov    $0x3,%eax
  801a45:	e8 79 fe ff ff       	call   8018c3 <fsipc>
  801a4a:	89 c3                	mov    %eax,%ebx
  801a4c:	85 c0                	test   %eax,%eax
  801a4e:	78 6a                	js     801aba <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801a50:	39 c6                	cmp    %eax,%esi
  801a52:	73 24                	jae    801a78 <devfile_read+0x59>
  801a54:	c7 44 24 0c 7c 33 80 	movl   $0x80337c,0xc(%esp)
  801a5b:	00 
  801a5c:	c7 44 24 08 83 33 80 	movl   $0x803383,0x8(%esp)
  801a63:	00 
  801a64:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801a6b:	00 
  801a6c:	c7 04 24 98 33 80 00 	movl   $0x803398,(%esp)
  801a73:	e8 f9 e9 ff ff       	call   800471 <_panic>
	assert(r <= PGSIZE);
  801a78:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a7d:	7e 24                	jle    801aa3 <devfile_read+0x84>
  801a7f:	c7 44 24 0c a3 33 80 	movl   $0x8033a3,0xc(%esp)
  801a86:	00 
  801a87:	c7 44 24 08 83 33 80 	movl   $0x803383,0x8(%esp)
  801a8e:	00 
  801a8f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801a96:	00 
  801a97:	c7 04 24 98 33 80 00 	movl   $0x803398,(%esp)
  801a9e:	e8 ce e9 ff ff       	call   800471 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801aa3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa7:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801aae:	00 
  801aaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab2:	89 04 24             	mov    %eax,(%esp)
  801ab5:	e8 7a f2 ff ff       	call   800d34 <memmove>
	return r;
}
  801aba:	89 d8                	mov    %ebx,%eax
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5e                   	pop    %esi
  801ac1:	5d                   	pop    %ebp
  801ac2:	c3                   	ret    

00801ac3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	53                   	push   %ebx
  801ac7:	83 ec 24             	sub    $0x24,%esp
  801aca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801acd:	89 1c 24             	mov    %ebx,(%esp)
  801ad0:	e8 8b f0 ff ff       	call   800b60 <strlen>
  801ad5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ada:	7f 60                	jg     801b3c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801adc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adf:	89 04 24             	mov    %eax,(%esp)
  801ae2:	e8 20 f8 ff ff       	call   801307 <fd_alloc>
  801ae7:	89 c2                	mov    %eax,%edx
  801ae9:	85 d2                	test   %edx,%edx
  801aeb:	78 54                	js     801b41 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801aed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801af1:	c7 04 24 00 80 80 00 	movl   $0x808000,(%esp)
  801af8:	e8 9a f0 ff ff       	call   800b97 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801afd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b00:	a3 00 84 80 00       	mov    %eax,0x808400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b08:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0d:	e8 b1 fd ff ff       	call   8018c3 <fsipc>
  801b12:	89 c3                	mov    %eax,%ebx
  801b14:	85 c0                	test   %eax,%eax
  801b16:	79 17                	jns    801b2f <open+0x6c>
		fd_close(fd, 0);
  801b18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b1f:	00 
  801b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b23:	89 04 24             	mov    %eax,(%esp)
  801b26:	e8 db f8 ff ff       	call   801406 <fd_close>
		return r;
  801b2b:	89 d8                	mov    %ebx,%eax
  801b2d:	eb 12                	jmp    801b41 <open+0x7e>
	}

	return fd2num(fd);
  801b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b32:	89 04 24             	mov    %eax,(%esp)
  801b35:	e8 a6 f7 ff ff       	call   8012e0 <fd2num>
  801b3a:	eb 05                	jmp    801b41 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b3c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801b41:	83 c4 24             	add    $0x24,%esp
  801b44:	5b                   	pop    %ebx
  801b45:	5d                   	pop    %ebp
  801b46:	c3                   	ret    

00801b47 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b52:	b8 08 00 00 00       	mov    $0x8,%eax
  801b57:	e8 67 fd ff ff       	call   8018c3 <fsipc>
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    
  801b5e:	66 90                	xchg   %ax,%ax

00801b60 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	57                   	push   %edi
  801b64:	56                   	push   %esi
  801b65:	53                   	push   %ebx
  801b66:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801b6c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b73:	00 
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	89 04 24             	mov    %eax,(%esp)
  801b7a:	e8 44 ff ff ff       	call   801ac3 <open>
  801b7f:	89 c2                	mov    %eax,%edx
  801b81:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801b87:	85 c0                	test   %eax,%eax
  801b89:	0f 88 0f 05 00 00    	js     80209e <spawn+0x53e>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801b8f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801b96:	00 
  801b97:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba1:	89 14 24             	mov    %edx,(%esp)
  801ba4:	e8 d3 fa ff ff       	call   80167c <readn>
  801ba9:	3d 00 02 00 00       	cmp    $0x200,%eax
  801bae:	75 0c                	jne    801bbc <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801bb0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801bb7:	45 4c 46 
  801bba:	74 36                	je     801bf2 <spawn+0x92>
		close(fd);
  801bbc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801bc2:	89 04 24             	mov    %eax,(%esp)
  801bc5:	e8 bd f8 ff ff       	call   801487 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801bca:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801bd1:	46 
  801bd2:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdc:	c7 04 24 af 33 80 00 	movl   $0x8033af,(%esp)
  801be3:	e8 82 e9 ff ff       	call   80056a <cprintf>
		return -E_NOT_EXEC;
  801be8:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801bed:	e9 0b 05 00 00       	jmp    8020fd <spawn+0x59d>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801bf2:	b8 07 00 00 00       	mov    $0x7,%eax
  801bf7:	cd 30                	int    $0x30
  801bf9:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801bff:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801c05:	85 c0                	test   %eax,%eax
  801c07:	0f 88 99 04 00 00    	js     8020a6 <spawn+0x546>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801c0d:	89 c6                	mov    %eax,%esi
  801c0f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801c15:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801c18:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801c1e:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801c24:	b9 11 00 00 00       	mov    $0x11,%ecx
  801c29:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801c2b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801c31:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801c37:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801c3c:	be 00 00 00 00       	mov    $0x0,%esi
  801c41:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c44:	eb 0f                	jmp    801c55 <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801c46:	89 04 24             	mov    %eax,(%esp)
  801c49:	e8 12 ef ff ff       	call   800b60 <strlen>
  801c4e:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801c52:	83 c3 01             	add    $0x1,%ebx
  801c55:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801c5c:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	75 e3                	jne    801c46 <spawn+0xe6>
  801c63:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  801c69:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801c6f:	bf 00 10 40 00       	mov    $0x401000,%edi
  801c74:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801c76:	89 fa                	mov    %edi,%edx
  801c78:	83 e2 fc             	and    $0xfffffffc,%edx
  801c7b:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801c82:	29 c2                	sub    %eax,%edx
  801c84:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801c8a:	8d 42 f8             	lea    -0x8(%edx),%eax
  801c8d:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801c92:	0f 86 1e 04 00 00    	jbe    8020b6 <spawn+0x556>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c98:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c9f:	00 
  801ca0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ca7:	00 
  801ca8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801caf:	e8 ff f2 ff ff       	call   800fb3 <sys_page_alloc>
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	0f 88 41 04 00 00    	js     8020fd <spawn+0x59d>
  801cbc:	be 00 00 00 00       	mov    $0x0,%esi
  801cc1:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801cc7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801cca:	eb 30                	jmp    801cfc <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801ccc:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801cd2:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801cd8:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801cdb:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce2:	89 3c 24             	mov    %edi,(%esp)
  801ce5:	e8 ad ee ff ff       	call   800b97 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801cea:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801ced:	89 04 24             	mov    %eax,(%esp)
  801cf0:	e8 6b ee ff ff       	call   800b60 <strlen>
  801cf5:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801cf9:	83 c6 01             	add    $0x1,%esi
  801cfc:	39 b5 90 fd ff ff    	cmp    %esi,-0x270(%ebp)
  801d02:	7f c8                	jg     801ccc <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801d04:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801d0a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801d10:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801d17:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801d1d:	74 24                	je     801d43 <spawn+0x1e3>
  801d1f:	c7 44 24 0c 24 34 80 	movl   $0x803424,0xc(%esp)
  801d26:	00 
  801d27:	c7 44 24 08 83 33 80 	movl   $0x803383,0x8(%esp)
  801d2e:	00 
  801d2f:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  801d36:	00 
  801d37:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
  801d3e:	e8 2e e7 ff ff       	call   800471 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801d43:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801d49:	89 c8                	mov    %ecx,%eax
  801d4b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801d50:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801d53:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801d59:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801d5c:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801d62:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d68:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801d6f:	00 
  801d70:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801d77:	ee 
  801d78:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  801d7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d82:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d89:	00 
  801d8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d91:	e8 71 f2 ff ff       	call   801007 <sys_page_map>
  801d96:	89 c3                	mov    %eax,%ebx
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	0f 88 47 03 00 00    	js     8020e7 <spawn+0x587>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801da0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801da7:	00 
  801da8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801daf:	e8 a6 f2 ff ff       	call   80105a <sys_page_unmap>
  801db4:	89 c3                	mov    %eax,%ebx
  801db6:	85 c0                	test   %eax,%eax
  801db8:	0f 88 29 03 00 00    	js     8020e7 <spawn+0x587>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801dbe:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801dc4:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801dcb:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801dd1:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801dd8:	00 00 00 
  801ddb:	e9 b6 01 00 00       	jmp    801f96 <spawn+0x436>
		if (ph->p_type != ELF_PROG_LOAD)
  801de0:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801de6:	83 38 01             	cmpl   $0x1,(%eax)
  801de9:	0f 85 99 01 00 00    	jne    801f88 <spawn+0x428>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801def:	89 c2                	mov    %eax,%edx
  801df1:	8b 40 18             	mov    0x18(%eax),%eax
  801df4:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801df7:	83 f8 01             	cmp    $0x1,%eax
  801dfa:	19 c0                	sbb    %eax,%eax
  801dfc:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  801e02:	83 a5 90 fd ff ff fe 	andl   $0xfffffffe,-0x270(%ebp)
  801e09:	83 85 90 fd ff ff 07 	addl   $0x7,-0x270(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801e10:	89 d0                	mov    %edx,%eax
  801e12:	8b 7a 04             	mov    0x4(%edx),%edi
  801e15:	89 bd 80 fd ff ff    	mov    %edi,-0x280(%ebp)
  801e1b:	8b 52 10             	mov    0x10(%edx),%edx
  801e1e:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801e24:	8b 78 14             	mov    0x14(%eax),%edi
  801e27:	89 bd 8c fd ff ff    	mov    %edi,-0x274(%ebp)
  801e2d:	8b 70 08             	mov    0x8(%eax),%esi
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801e30:	89 f0                	mov    %esi,%eax
  801e32:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e37:	74 14                	je     801e4d <spawn+0x2ed>
		va -= i;
  801e39:	29 c6                	sub    %eax,%esi
		memsz += i;
  801e3b:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  801e41:	01 85 94 fd ff ff    	add    %eax,-0x26c(%ebp)
		fileoffset -= i;
  801e47:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801e4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e52:	e9 23 01 00 00       	jmp    801f7a <spawn+0x41a>
		if (i >= filesz) {
  801e57:	39 9d 94 fd ff ff    	cmp    %ebx,-0x26c(%ebp)
  801e5d:	77 2b                	ja     801e8a <spawn+0x32a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801e5f:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801e65:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e69:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e6d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801e73:	89 04 24             	mov    %eax,(%esp)
  801e76:	e8 38 f1 ff ff       	call   800fb3 <sys_page_alloc>
  801e7b:	85 c0                	test   %eax,%eax
  801e7d:	0f 89 eb 00 00 00    	jns    801f6e <spawn+0x40e>
  801e83:	89 c3                	mov    %eax,%ebx
  801e85:	e9 3d 02 00 00       	jmp    8020c7 <spawn+0x567>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e8a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801e91:	00 
  801e92:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e99:	00 
  801e9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ea1:	e8 0d f1 ff ff       	call   800fb3 <sys_page_alloc>
  801ea6:	85 c0                	test   %eax,%eax
  801ea8:	0f 88 0f 02 00 00    	js     8020bd <spawn+0x55d>
  801eae:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801eb4:	01 f8                	add    %edi,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801eb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eba:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ec0:	89 04 24             	mov    %eax,(%esp)
  801ec3:	e8 8c f8 ff ff       	call   801754 <seek>
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	0f 88 f1 01 00 00    	js     8020c1 <spawn+0x561>
  801ed0:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801ed6:	29 f9                	sub    %edi,%ecx
  801ed8:	89 c8                	mov    %ecx,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801eda:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  801ee0:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801ee5:	0f 47 c1             	cmova  %ecx,%eax
  801ee8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eec:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ef3:	00 
  801ef4:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801efa:	89 04 24             	mov    %eax,(%esp)
  801efd:	e8 7a f7 ff ff       	call   80167c <readn>
  801f02:	85 c0                	test   %eax,%eax
  801f04:	0f 88 bb 01 00 00    	js     8020c5 <spawn+0x565>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801f0a:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  801f10:	89 44 24 10          	mov    %eax,0x10(%esp)
  801f14:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f18:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f22:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f29:	00 
  801f2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f31:	e8 d1 f0 ff ff       	call   801007 <sys_page_map>
  801f36:	85 c0                	test   %eax,%eax
  801f38:	79 20                	jns    801f5a <spawn+0x3fa>
				panic("spawn: sys_page_map data: %e", r);
  801f3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f3e:	c7 44 24 08 d5 33 80 	movl   $0x8033d5,0x8(%esp)
  801f45:	00 
  801f46:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  801f4d:	00 
  801f4e:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
  801f55:	e8 17 e5 ff ff       	call   800471 <_panic>
			sys_page_unmap(0, UTEMP);
  801f5a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f61:	00 
  801f62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f69:	e8 ec f0 ff ff       	call   80105a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801f6e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801f74:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801f7a:	89 df                	mov    %ebx,%edi
  801f7c:	39 9d 8c fd ff ff    	cmp    %ebx,-0x274(%ebp)
  801f82:	0f 87 cf fe ff ff    	ja     801e57 <spawn+0x2f7>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f88:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  801f8f:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801f96:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801f9d:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801fa3:	0f 8c 37 fe ff ff    	jl     801de0 <spawn+0x280>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801fa9:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801faf:	89 04 24             	mov    %eax,(%esp)
  801fb2:	e8 d0 f4 ff ff       	call   801487 <close>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  801fb7:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fbc:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	{
		if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U))&&((uvpt[i/PGSIZE]&(PTE_SHARE))==PTE_SHARE))
  801fc2:	89 d8                	mov    %ebx,%eax
  801fc4:	c1 e8 16             	shr    $0x16,%eax
  801fc7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801fce:	a8 01                	test   $0x1,%al
  801fd0:	74 48                	je     80201a <spawn+0x4ba>
  801fd2:	89 d8                	mov    %ebx,%eax
  801fd4:	c1 e8 0c             	shr    $0xc,%eax
  801fd7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801fde:	83 e2 05             	and    $0x5,%edx
  801fe1:	83 fa 05             	cmp    $0x5,%edx
  801fe4:	75 34                	jne    80201a <spawn+0x4ba>
  801fe6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801fed:	f6 c6 04             	test   $0x4,%dh
  801ff0:	74 28                	je     80201a <spawn+0x4ba>
		{
			//cprintf("in copy_shared_pages\n");
			//cprintf("%08x\n",PDX(i));
			sys_page_map(0,(void*)i,child,(void*)i,uvpt[i/PGSIZE]&PTE_SYSCALL);
  801ff2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ff9:	25 07 0e 00 00       	and    $0xe07,%eax
  801ffe:	89 44 24 10          	mov    %eax,0x10(%esp)
  802002:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802006:	89 74 24 08          	mov    %esi,0x8(%esp)
  80200a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80200e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802015:	e8 ed ef ff ff       	call   801007 <sys_page_map>
{
	// LAB 5: Your code here.

	uint32_t i;
	struct Env *child_env;
	for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  80201a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802020:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  802026:	75 9a                	jne    801fc2 <spawn+0x462>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802028:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80202e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802032:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802038:	89 04 24             	mov    %eax,(%esp)
  80203b:	e8 c0 f0 ff ff       	call   801100 <sys_env_set_trapframe>
  802040:	85 c0                	test   %eax,%eax
  802042:	79 20                	jns    802064 <spawn+0x504>
		panic("sys_env_set_trapframe: %e", r);
  802044:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802048:	c7 44 24 08 f2 33 80 	movl   $0x8033f2,0x8(%esp)
  80204f:	00 
  802050:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802057:	00 
  802058:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
  80205f:	e8 0d e4 ff ff       	call   800471 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802064:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80206b:	00 
  80206c:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802072:	89 04 24             	mov    %eax,(%esp)
  802075:	e8 33 f0 ff ff       	call   8010ad <sys_env_set_status>
  80207a:	85 c0                	test   %eax,%eax
  80207c:	79 30                	jns    8020ae <spawn+0x54e>
		panic("sys_env_set_status: %e", r);
  80207e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802082:	c7 44 24 08 0c 34 80 	movl   $0x80340c,0x8(%esp)
  802089:	00 
  80208a:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802091:	00 
  802092:	c7 04 24 c9 33 80 00 	movl   $0x8033c9,(%esp)
  802099:	e8 d3 e3 ff ff       	call   800471 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  80209e:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020a4:	eb 57                	jmp    8020fd <spawn+0x59d>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8020a6:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020ac:	eb 4f                	jmp    8020fd <spawn+0x59d>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  8020ae:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020b4:	eb 47                	jmp    8020fd <spawn+0x59d>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8020b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8020bb:	eb 40                	jmp    8020fd <spawn+0x59d>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020bd:	89 c3                	mov    %eax,%ebx
  8020bf:	eb 06                	jmp    8020c7 <spawn+0x567>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8020c1:	89 c3                	mov    %eax,%ebx
  8020c3:	eb 02                	jmp    8020c7 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8020c5:	89 c3                	mov    %eax,%ebx
		panic("sys_env_set_status: %e", r);

	return child;

error:
	sys_env_destroy(child);
  8020c7:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  8020cd:	89 04 24             	mov    %eax,(%esp)
  8020d0:	e8 4e ee ff ff       	call   800f23 <sys_env_destroy>
	close(fd);
  8020d5:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020db:	89 04 24             	mov    %eax,(%esp)
  8020de:	e8 a4 f3 ff ff       	call   801487 <close>
	return r;
  8020e3:	89 d8                	mov    %ebx,%eax
  8020e5:	eb 16                	jmp    8020fd <spawn+0x59d>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8020e7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020ee:	00 
  8020ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f6:	e8 5f ef ff ff       	call   80105a <sys_page_unmap>
  8020fb:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8020fd:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802103:	5b                   	pop    %ebx
  802104:	5e                   	pop    %esi
  802105:	5f                   	pop    %edi
  802106:	5d                   	pop    %ebp
  802107:	c3                   	ret    

00802108 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	56                   	push   %esi
  80210c:	53                   	push   %ebx
  80210d:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802110:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802113:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802118:	eb 03                	jmp    80211d <spawnl+0x15>
		argc++;
  80211a:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80211d:	83 c0 04             	add    $0x4,%eax
  802120:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802124:	75 f4                	jne    80211a <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802126:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  80212d:	83 e0 f0             	and    $0xfffffff0,%eax
  802130:	29 c4                	sub    %eax,%esp
  802132:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802136:	c1 e8 02             	shr    $0x2,%eax
  802139:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  802140:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802142:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802145:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  80214c:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  802153:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802154:	b8 00 00 00 00       	mov    $0x0,%eax
  802159:	eb 0a                	jmp    802165 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  80215b:	83 c0 01             	add    $0x1,%eax
  80215e:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802162:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802165:	39 d0                	cmp    %edx,%eax
  802167:	75 f2                	jne    80215b <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802169:	89 74 24 04          	mov    %esi,0x4(%esp)
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	89 04 24             	mov    %eax,(%esp)
  802173:	e8 e8 f9 ff ff       	call   801b60 <spawn>
}
  802178:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217b:	5b                   	pop    %ebx
  80217c:	5e                   	pop    %esi
  80217d:	5d                   	pop    %ebp
  80217e:	c3                   	ret    
  80217f:	90                   	nop

00802180 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802186:	c7 44 24 04 4c 34 80 	movl   $0x80344c,0x4(%esp)
  80218d:	00 
  80218e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802191:	89 04 24             	mov    %eax,(%esp)
  802194:	e8 fe e9 ff ff       	call   800b97 <strcpy>
	return 0;
}
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	53                   	push   %ebx
  8021a4:	83 ec 14             	sub    $0x14,%esp
  8021a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8021aa:	89 1c 24             	mov    %ebx,(%esp)
  8021ad:	e8 b8 09 00 00       	call   802b6a <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8021b2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8021b7:	83 f8 01             	cmp    $0x1,%eax
  8021ba:	75 0d                	jne    8021c9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8021bc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8021bf:	89 04 24             	mov    %eax,(%esp)
  8021c2:	e8 29 03 00 00       	call   8024f0 <nsipc_close>
  8021c7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8021c9:	89 d0                	mov    %edx,%eax
  8021cb:	83 c4 14             	add    $0x14,%esp
  8021ce:	5b                   	pop    %ebx
  8021cf:	5d                   	pop    %ebp
  8021d0:	c3                   	ret    

008021d1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8021d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021de:	00 
  8021df:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f3:	89 04 24             	mov    %eax,(%esp)
  8021f6:	e8 f0 03 00 00       	call   8025eb <nsipc_send>
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802203:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80220a:	00 
  80220b:	8b 45 10             	mov    0x10(%ebp),%eax
  80220e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802212:	8b 45 0c             	mov    0xc(%ebp),%eax
  802215:	89 44 24 04          	mov    %eax,0x4(%esp)
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	8b 40 0c             	mov    0xc(%eax),%eax
  80221f:	89 04 24             	mov    %eax,(%esp)
  802222:	e8 44 03 00 00       	call   80256b <nsipc_recv>
}
  802227:	c9                   	leave  
  802228:	c3                   	ret    

00802229 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802229:	55                   	push   %ebp
  80222a:	89 e5                	mov    %esp,%ebp
  80222c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80222f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802232:	89 54 24 04          	mov    %edx,0x4(%esp)
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 18 f1 ff ff       	call   801356 <fd_lookup>
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 17                	js     802259 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802245:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  80224b:	39 08                	cmp    %ecx,(%eax)
  80224d:	75 05                	jne    802254 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80224f:	8b 40 0c             	mov    0xc(%eax),%eax
  802252:	eb 05                	jmp    802259 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802254:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	56                   	push   %esi
  80225f:	53                   	push   %ebx
  802260:	83 ec 20             	sub    $0x20,%esp
  802263:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802265:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802268:	89 04 24             	mov    %eax,(%esp)
  80226b:	e8 97 f0 ff ff       	call   801307 <fd_alloc>
  802270:	89 c3                	mov    %eax,%ebx
  802272:	85 c0                	test   %eax,%eax
  802274:	78 21                	js     802297 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802276:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80227d:	00 
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	89 44 24 04          	mov    %eax,0x4(%esp)
  802285:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80228c:	e8 22 ed ff ff       	call   800fb3 <sys_page_alloc>
  802291:	89 c3                	mov    %eax,%ebx
  802293:	85 c0                	test   %eax,%eax
  802295:	79 0c                	jns    8022a3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802297:	89 34 24             	mov    %esi,(%esp)
  80229a:	e8 51 02 00 00       	call   8024f0 <nsipc_close>
		return r;
  80229f:	89 d8                	mov    %ebx,%eax
  8022a1:	eb 20                	jmp    8022c3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8022a3:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8022ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8022b8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8022bb:	89 14 24             	mov    %edx,(%esp)
  8022be:	e8 1d f0 ff ff       	call   8012e0 <fd2num>
}
  8022c3:	83 c4 20             	add    $0x20,%esp
  8022c6:	5b                   	pop    %ebx
  8022c7:	5e                   	pop    %esi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    

008022ca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
  8022cd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d3:	e8 51 ff ff ff       	call   802229 <fd2sockid>
		return r;
  8022d8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	78 23                	js     802301 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8022de:	8b 55 10             	mov    0x10(%ebp),%edx
  8022e1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022ec:	89 04 24             	mov    %eax,(%esp)
  8022ef:	e8 45 01 00 00       	call   802439 <nsipc_accept>
		return r;
  8022f4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	78 07                	js     802301 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8022fa:	e8 5c ff ff ff       	call   80225b <alloc_sockfd>
  8022ff:	89 c1                	mov    %eax,%ecx
}
  802301:	89 c8                	mov    %ecx,%eax
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80230b:	8b 45 08             	mov    0x8(%ebp),%eax
  80230e:	e8 16 ff ff ff       	call   802229 <fd2sockid>
  802313:	89 c2                	mov    %eax,%edx
  802315:	85 d2                	test   %edx,%edx
  802317:	78 16                	js     80232f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802319:	8b 45 10             	mov    0x10(%ebp),%eax
  80231c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802320:	8b 45 0c             	mov    0xc(%ebp),%eax
  802323:	89 44 24 04          	mov    %eax,0x4(%esp)
  802327:	89 14 24             	mov    %edx,(%esp)
  80232a:	e8 60 01 00 00       	call   80248f <nsipc_bind>
}
  80232f:	c9                   	leave  
  802330:	c3                   	ret    

00802331 <shutdown>:

int
shutdown(int s, int how)
{
  802331:	55                   	push   %ebp
  802332:	89 e5                	mov    %esp,%ebp
  802334:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	e8 ea fe ff ff       	call   802229 <fd2sockid>
  80233f:	89 c2                	mov    %eax,%edx
  802341:	85 d2                	test   %edx,%edx
  802343:	78 0f                	js     802354 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802345:	8b 45 0c             	mov    0xc(%ebp),%eax
  802348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234c:	89 14 24             	mov    %edx,(%esp)
  80234f:	e8 7a 01 00 00       	call   8024ce <nsipc_shutdown>
}
  802354:	c9                   	leave  
  802355:	c3                   	ret    

00802356 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802356:	55                   	push   %ebp
  802357:	89 e5                	mov    %esp,%ebp
  802359:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	e8 c5 fe ff ff       	call   802229 <fd2sockid>
  802364:	89 c2                	mov    %eax,%edx
  802366:	85 d2                	test   %edx,%edx
  802368:	78 16                	js     802380 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80236a:	8b 45 10             	mov    0x10(%ebp),%eax
  80236d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	89 44 24 04          	mov    %eax,0x4(%esp)
  802378:	89 14 24             	mov    %edx,(%esp)
  80237b:	e8 8a 01 00 00       	call   80250a <nsipc_connect>
}
  802380:	c9                   	leave  
  802381:	c3                   	ret    

00802382 <listen>:

int
listen(int s, int backlog)
{
  802382:	55                   	push   %ebp
  802383:	89 e5                	mov    %esp,%ebp
  802385:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	e8 99 fe ff ff       	call   802229 <fd2sockid>
  802390:	89 c2                	mov    %eax,%edx
  802392:	85 d2                	test   %edx,%edx
  802394:	78 0f                	js     8023a5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239d:	89 14 24             	mov    %edx,(%esp)
  8023a0:	e8 a4 01 00 00       	call   802549 <nsipc_listen>
}
  8023a5:	c9                   	leave  
  8023a6:	c3                   	ret    

008023a7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8023a7:	55                   	push   %ebp
  8023a8:	89 e5                	mov    %esp,%ebp
  8023aa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8023ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	89 04 24             	mov    %eax,(%esp)
  8023c1:	e8 98 02 00 00       	call   80265e <nsipc_socket>
  8023c6:	89 c2                	mov    %eax,%edx
  8023c8:	85 d2                	test   %edx,%edx
  8023ca:	78 05                	js     8023d1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8023cc:	e8 8a fe ff ff       	call   80225b <alloc_sockfd>
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	53                   	push   %ebx
  8023d7:	83 ec 14             	sub    $0x14,%esp
  8023da:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8023dc:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  8023e3:	75 11                	jne    8023f6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8023e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8023ec:	e8 41 07 00 00       	call   802b32 <ipc_find_env>
  8023f1:	a3 04 60 80 00       	mov    %eax,0x806004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8023f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8023fd:	00 
  8023fe:	c7 44 24 08 00 90 80 	movl   $0x809000,0x8(%esp)
  802405:	00 
  802406:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80240a:	a1 04 60 80 00       	mov    0x806004,%eax
  80240f:	89 04 24             	mov    %eax,(%esp)
  802412:	e8 bd 06 00 00       	call   802ad4 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802417:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80241e:	00 
  80241f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802426:	00 
  802427:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80242e:	e8 37 06 00 00       	call   802a6a <ipc_recv>
}
  802433:	83 c4 14             	add    $0x14,%esp
  802436:	5b                   	pop    %ebx
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    

00802439 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	56                   	push   %esi
  80243d:	53                   	push   %ebx
  80243e:	83 ec 10             	sub    $0x10,%esp
  802441:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802444:	8b 45 08             	mov    0x8(%ebp),%eax
  802447:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80244c:	8b 06                	mov    (%esi),%eax
  80244e:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802453:	b8 01 00 00 00       	mov    $0x1,%eax
  802458:	e8 76 ff ff ff       	call   8023d3 <nsipc>
  80245d:	89 c3                	mov    %eax,%ebx
  80245f:	85 c0                	test   %eax,%eax
  802461:	78 23                	js     802486 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802463:	a1 10 90 80 00       	mov    0x809010,%eax
  802468:	89 44 24 08          	mov    %eax,0x8(%esp)
  80246c:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  802473:	00 
  802474:	8b 45 0c             	mov    0xc(%ebp),%eax
  802477:	89 04 24             	mov    %eax,(%esp)
  80247a:	e8 b5 e8 ff ff       	call   800d34 <memmove>
		*addrlen = ret->ret_addrlen;
  80247f:	a1 10 90 80 00       	mov    0x809010,%eax
  802484:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802486:	89 d8                	mov    %ebx,%eax
  802488:	83 c4 10             	add    $0x10,%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5e                   	pop    %esi
  80248d:	5d                   	pop    %ebp
  80248e:	c3                   	ret    

0080248f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
  802492:	53                   	push   %ebx
  802493:	83 ec 14             	sub    $0x14,%esp
  802496:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ac:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  8024b3:	e8 7c e8 ff ff       	call   800d34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024b8:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  8024be:	b8 02 00 00 00       	mov    $0x2,%eax
  8024c3:	e8 0b ff ff ff       	call   8023d3 <nsipc>
}
  8024c8:	83 c4 14             	add    $0x14,%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5d                   	pop    %ebp
  8024cd:	c3                   	ret    

008024ce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8024d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d7:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  8024dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024df:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  8024e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8024e9:	e8 e5 fe ff ff       	call   8023d3 <nsipc>
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <nsipc_close>:

int
nsipc_close(int s)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  8024fe:	b8 04 00 00 00       	mov    $0x4,%eax
  802503:	e8 cb fe ff ff       	call   8023d3 <nsipc>
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	53                   	push   %ebx
  80250e:	83 ec 14             	sub    $0x14,%esp
  802511:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80251c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802520:	8b 45 0c             	mov    0xc(%ebp),%eax
  802523:	89 44 24 04          	mov    %eax,0x4(%esp)
  802527:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  80252e:	e8 01 e8 ff ff       	call   800d34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802533:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  802539:	b8 05 00 00 00       	mov    $0x5,%eax
  80253e:	e8 90 fe ff ff       	call   8023d3 <nsipc>
}
  802543:	83 c4 14             	add    $0x14,%esp
  802546:	5b                   	pop    %ebx
  802547:	5d                   	pop    %ebp
  802548:	c3                   	ret    

00802549 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
  80254c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80254f:	8b 45 08             	mov    0x8(%ebp),%eax
  802552:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  802557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255a:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  80255f:	b8 06 00 00 00       	mov    $0x6,%eax
  802564:	e8 6a fe ff ff       	call   8023d3 <nsipc>
}
  802569:	c9                   	leave  
  80256a:	c3                   	ret    

0080256b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80256b:	55                   	push   %ebp
  80256c:	89 e5                	mov    %esp,%ebp
  80256e:	56                   	push   %esi
  80256f:	53                   	push   %ebx
  802570:	83 ec 10             	sub    $0x10,%esp
  802573:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  80257e:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  802584:	8b 45 14             	mov    0x14(%ebp),%eax
  802587:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80258c:	b8 07 00 00 00       	mov    $0x7,%eax
  802591:	e8 3d fe ff ff       	call   8023d3 <nsipc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	85 c0                	test   %eax,%eax
  80259a:	78 46                	js     8025e2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80259c:	39 f0                	cmp    %esi,%eax
  80259e:	7f 07                	jg     8025a7 <nsipc_recv+0x3c>
  8025a0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8025a5:	7e 24                	jle    8025cb <nsipc_recv+0x60>
  8025a7:	c7 44 24 0c 58 34 80 	movl   $0x803458,0xc(%esp)
  8025ae:	00 
  8025af:	c7 44 24 08 83 33 80 	movl   $0x803383,0x8(%esp)
  8025b6:	00 
  8025b7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8025be:	00 
  8025bf:	c7 04 24 6d 34 80 00 	movl   $0x80346d,(%esp)
  8025c6:	e8 a6 de ff ff       	call   800471 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8025cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025cf:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  8025d6:	00 
  8025d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025da:	89 04 24             	mov    %eax,(%esp)
  8025dd:	e8 52 e7 ff ff       	call   800d34 <memmove>
	}

	return r;
}
  8025e2:	89 d8                	mov    %ebx,%eax
  8025e4:	83 c4 10             	add    $0x10,%esp
  8025e7:	5b                   	pop    %ebx
  8025e8:	5e                   	pop    %esi
  8025e9:	5d                   	pop    %ebp
  8025ea:	c3                   	ret    

008025eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	53                   	push   %ebx
  8025ef:	83 ec 14             	sub    $0x14,%esp
  8025f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8025f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f8:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  8025fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802603:	7e 24                	jle    802629 <nsipc_send+0x3e>
  802605:	c7 44 24 0c 79 34 80 	movl   $0x803479,0xc(%esp)
  80260c:	00 
  80260d:	c7 44 24 08 83 33 80 	movl   $0x803383,0x8(%esp)
  802614:	00 
  802615:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80261c:	00 
  80261d:	c7 04 24 6d 34 80 00 	movl   $0x80346d,(%esp)
  802624:	e8 48 de ff ff       	call   800471 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802629:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80262d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802630:	89 44 24 04          	mov    %eax,0x4(%esp)
  802634:	c7 04 24 0c 90 80 00 	movl   $0x80900c,(%esp)
  80263b:	e8 f4 e6 ff ff       	call   800d34 <memmove>
	nsipcbuf.send.req_size = size;
  802640:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  802646:	8b 45 14             	mov    0x14(%ebp),%eax
  802649:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  80264e:	b8 08 00 00 00       	mov    $0x8,%eax
  802653:	e8 7b fd ff ff       	call   8023d3 <nsipc>
}
  802658:	83 c4 14             	add    $0x14,%esp
  80265b:	5b                   	pop    %ebx
  80265c:	5d                   	pop    %ebp
  80265d:	c3                   	ret    

0080265e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80265e:	55                   	push   %ebp
  80265f:	89 e5                	mov    %esp,%ebp
  802661:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  80266c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80266f:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  802674:	8b 45 10             	mov    0x10(%ebp),%eax
  802677:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  80267c:	b8 09 00 00 00       	mov    $0x9,%eax
  802681:	e8 4d fd ff ff       	call   8023d3 <nsipc>
}
  802686:	c9                   	leave  
  802687:	c3                   	ret    

00802688 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802688:	55                   	push   %ebp
  802689:	89 e5                	mov    %esp,%ebp
  80268b:	56                   	push   %esi
  80268c:	53                   	push   %ebx
  80268d:	83 ec 10             	sub    $0x10,%esp
  802690:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	89 04 24             	mov    %eax,(%esp)
  802699:	e8 52 ec ff ff       	call   8012f0 <fd2data>
  80269e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8026a0:	c7 44 24 04 85 34 80 	movl   $0x803485,0x4(%esp)
  8026a7:	00 
  8026a8:	89 1c 24             	mov    %ebx,(%esp)
  8026ab:	e8 e7 e4 ff ff       	call   800b97 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8026b0:	8b 46 04             	mov    0x4(%esi),%eax
  8026b3:	2b 06                	sub    (%esi),%eax
  8026b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8026bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8026c2:	00 00 00 
	stat->st_dev = &devpipe;
  8026c5:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  8026cc:	57 80 00 
	return 0;
}
  8026cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d4:	83 c4 10             	add    $0x10,%esp
  8026d7:	5b                   	pop    %ebx
  8026d8:	5e                   	pop    %esi
  8026d9:	5d                   	pop    %ebp
  8026da:	c3                   	ret    

008026db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	53                   	push   %ebx
  8026df:	83 ec 14             	sub    $0x14,%esp
  8026e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f0:	e8 65 e9 ff ff       	call   80105a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026f5:	89 1c 24             	mov    %ebx,(%esp)
  8026f8:	e8 f3 eb ff ff       	call   8012f0 <fd2data>
  8026fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802701:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802708:	e8 4d e9 ff ff       	call   80105a <sys_page_unmap>
}
  80270d:	83 c4 14             	add    $0x14,%esp
  802710:	5b                   	pop    %ebx
  802711:	5d                   	pop    %ebp
  802712:	c3                   	ret    

00802713 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802713:	55                   	push   %ebp
  802714:	89 e5                	mov    %esp,%ebp
  802716:	57                   	push   %edi
  802717:	56                   	push   %esi
  802718:	53                   	push   %ebx
  802719:	83 ec 2c             	sub    $0x2c,%esp
  80271c:	89 c6                	mov    %eax,%esi
  80271e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802721:	a1 90 77 80 00       	mov    0x807790,%eax
  802726:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802729:	89 34 24             	mov    %esi,(%esp)
  80272c:	e8 39 04 00 00       	call   802b6a <pageref>
  802731:	89 c7                	mov    %eax,%edi
  802733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802736:	89 04 24             	mov    %eax,(%esp)
  802739:	e8 2c 04 00 00       	call   802b6a <pageref>
  80273e:	39 c7                	cmp    %eax,%edi
  802740:	0f 94 c2             	sete   %dl
  802743:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802746:	8b 0d 90 77 80 00    	mov    0x807790,%ecx
  80274c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80274f:	39 fb                	cmp    %edi,%ebx
  802751:	74 21                	je     802774 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802753:	84 d2                	test   %dl,%dl
  802755:	74 ca                	je     802721 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802757:	8b 51 58             	mov    0x58(%ecx),%edx
  80275a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80275e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802762:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802766:	c7 04 24 8c 34 80 00 	movl   $0x80348c,(%esp)
  80276d:	e8 f8 dd ff ff       	call   80056a <cprintf>
  802772:	eb ad                	jmp    802721 <_pipeisclosed+0xe>
	}
}
  802774:	83 c4 2c             	add    $0x2c,%esp
  802777:	5b                   	pop    %ebx
  802778:	5e                   	pop    %esi
  802779:	5f                   	pop    %edi
  80277a:	5d                   	pop    %ebp
  80277b:	c3                   	ret    

0080277c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80277c:	55                   	push   %ebp
  80277d:	89 e5                	mov    %esp,%ebp
  80277f:	57                   	push   %edi
  802780:	56                   	push   %esi
  802781:	53                   	push   %ebx
  802782:	83 ec 1c             	sub    $0x1c,%esp
  802785:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802788:	89 34 24             	mov    %esi,(%esp)
  80278b:	e8 60 eb ff ff       	call   8012f0 <fd2data>
  802790:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802792:	bf 00 00 00 00       	mov    $0x0,%edi
  802797:	eb 45                	jmp    8027de <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802799:	89 da                	mov    %ebx,%edx
  80279b:	89 f0                	mov    %esi,%eax
  80279d:	e8 71 ff ff ff       	call   802713 <_pipeisclosed>
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	75 41                	jne    8027e7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8027a6:	e8 e9 e7 ff ff       	call   800f94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8027ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8027ae:	8b 0b                	mov    (%ebx),%ecx
  8027b0:	8d 51 20             	lea    0x20(%ecx),%edx
  8027b3:	39 d0                	cmp    %edx,%eax
  8027b5:	73 e2                	jae    802799 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8027b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027ba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8027be:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8027c1:	99                   	cltd   
  8027c2:	c1 ea 1b             	shr    $0x1b,%edx
  8027c5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8027c8:	83 e1 1f             	and    $0x1f,%ecx
  8027cb:	29 d1                	sub    %edx,%ecx
  8027cd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8027d1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8027d5:	83 c0 01             	add    $0x1,%eax
  8027d8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027db:	83 c7 01             	add    $0x1,%edi
  8027de:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8027e1:	75 c8                	jne    8027ab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8027e3:	89 f8                	mov    %edi,%eax
  8027e5:	eb 05                	jmp    8027ec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8027e7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8027ec:	83 c4 1c             	add    $0x1c,%esp
  8027ef:	5b                   	pop    %ebx
  8027f0:	5e                   	pop    %esi
  8027f1:	5f                   	pop    %edi
  8027f2:	5d                   	pop    %ebp
  8027f3:	c3                   	ret    

008027f4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	57                   	push   %edi
  8027f8:	56                   	push   %esi
  8027f9:	53                   	push   %ebx
  8027fa:	83 ec 1c             	sub    $0x1c,%esp
  8027fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802800:	89 3c 24             	mov    %edi,(%esp)
  802803:	e8 e8 ea ff ff       	call   8012f0 <fd2data>
  802808:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80280a:	be 00 00 00 00       	mov    $0x0,%esi
  80280f:	eb 3d                	jmp    80284e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802811:	85 f6                	test   %esi,%esi
  802813:	74 04                	je     802819 <devpipe_read+0x25>
				return i;
  802815:	89 f0                	mov    %esi,%eax
  802817:	eb 43                	jmp    80285c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802819:	89 da                	mov    %ebx,%edx
  80281b:	89 f8                	mov    %edi,%eax
  80281d:	e8 f1 fe ff ff       	call   802713 <_pipeisclosed>
  802822:	85 c0                	test   %eax,%eax
  802824:	75 31                	jne    802857 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802826:	e8 69 e7 ff ff       	call   800f94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80282b:	8b 03                	mov    (%ebx),%eax
  80282d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802830:	74 df                	je     802811 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802832:	99                   	cltd   
  802833:	c1 ea 1b             	shr    $0x1b,%edx
  802836:	01 d0                	add    %edx,%eax
  802838:	83 e0 1f             	and    $0x1f,%eax
  80283b:	29 d0                	sub    %edx,%eax
  80283d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802842:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802845:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802848:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80284b:	83 c6 01             	add    $0x1,%esi
  80284e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802851:	75 d8                	jne    80282b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802853:	89 f0                	mov    %esi,%eax
  802855:	eb 05                	jmp    80285c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802857:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80285c:	83 c4 1c             	add    $0x1c,%esp
  80285f:	5b                   	pop    %ebx
  802860:	5e                   	pop    %esi
  802861:	5f                   	pop    %edi
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    

00802864 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
  802867:	56                   	push   %esi
  802868:	53                   	push   %ebx
  802869:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80286c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80286f:	89 04 24             	mov    %eax,(%esp)
  802872:	e8 90 ea ff ff       	call   801307 <fd_alloc>
  802877:	89 c2                	mov    %eax,%edx
  802879:	85 d2                	test   %edx,%edx
  80287b:	0f 88 4d 01 00 00    	js     8029ce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802881:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802888:	00 
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802890:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802897:	e8 17 e7 ff ff       	call   800fb3 <sys_page_alloc>
  80289c:	89 c2                	mov    %eax,%edx
  80289e:	85 d2                	test   %edx,%edx
  8028a0:	0f 88 28 01 00 00    	js     8029ce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8028a9:	89 04 24             	mov    %eax,(%esp)
  8028ac:	e8 56 ea ff ff       	call   801307 <fd_alloc>
  8028b1:	89 c3                	mov    %eax,%ebx
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	0f 88 fe 00 00 00    	js     8029b9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028c2:	00 
  8028c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d1:	e8 dd e6 ff ff       	call   800fb3 <sys_page_alloc>
  8028d6:	89 c3                	mov    %eax,%ebx
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	0f 88 d9 00 00 00    	js     8029b9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	89 04 24             	mov    %eax,(%esp)
  8028e6:	e8 05 ea ff ff       	call   8012f0 <fd2data>
  8028eb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028ed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028f4:	00 
  8028f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802900:	e8 ae e6 ff ff       	call   800fb3 <sys_page_alloc>
  802905:	89 c3                	mov    %eax,%ebx
  802907:	85 c0                	test   %eax,%eax
  802909:	0f 88 97 00 00 00    	js     8029a6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	89 04 24             	mov    %eax,(%esp)
  802915:	e8 d6 e9 ff ff       	call   8012f0 <fd2data>
  80291a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802921:	00 
  802922:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802926:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80292d:	00 
  80292e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802932:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802939:	e8 c9 e6 ff ff       	call   801007 <sys_page_map>
  80293e:	89 c3                	mov    %eax,%ebx
  802940:	85 c0                	test   %eax,%eax
  802942:	78 52                	js     802996 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802944:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802959:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  80295f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802962:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802964:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802967:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	89 04 24             	mov    %eax,(%esp)
  802974:	e8 67 e9 ff ff       	call   8012e0 <fd2num>
  802979:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80297c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	89 04 24             	mov    %eax,(%esp)
  802984:	e8 57 e9 ff ff       	call   8012e0 <fd2num>
  802989:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80298c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80298f:	b8 00 00 00 00       	mov    $0x0,%eax
  802994:	eb 38                	jmp    8029ce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802996:	89 74 24 04          	mov    %esi,0x4(%esp)
  80299a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a1:	e8 b4 e6 ff ff       	call   80105a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b4:	e8 a1 e6 ff ff       	call   80105a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c7:	e8 8e e6 ff ff       	call   80105a <sys_page_unmap>
  8029cc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8029ce:	83 c4 30             	add    $0x30,%esp
  8029d1:	5b                   	pop    %ebx
  8029d2:	5e                   	pop    %esi
  8029d3:	5d                   	pop    %ebp
  8029d4:	c3                   	ret    

008029d5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8029d5:	55                   	push   %ebp
  8029d6:	89 e5                	mov    %esp,%ebp
  8029d8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	89 04 24             	mov    %eax,(%esp)
  8029e8:	e8 69 e9 ff ff       	call   801356 <fd_lookup>
  8029ed:	89 c2                	mov    %eax,%edx
  8029ef:	85 d2                	test   %edx,%edx
  8029f1:	78 15                	js     802a08 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	89 04 24             	mov    %eax,(%esp)
  8029f9:	e8 f2 e8 ff ff       	call   8012f0 <fd2data>
	return _pipeisclosed(fd, p);
  8029fe:	89 c2                	mov    %eax,%edx
  802a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a03:	e8 0b fd ff ff       	call   802713 <_pipeisclosed>
}
  802a08:	c9                   	leave  
  802a09:	c3                   	ret    

00802a0a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802a0a:	55                   	push   %ebp
  802a0b:	89 e5                	mov    %esp,%ebp
  802a0d:	56                   	push   %esi
  802a0e:	53                   	push   %ebx
  802a0f:	83 ec 10             	sub    $0x10,%esp
  802a12:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802a15:	85 f6                	test   %esi,%esi
  802a17:	75 24                	jne    802a3d <wait+0x33>
  802a19:	c7 44 24 0c a4 34 80 	movl   $0x8034a4,0xc(%esp)
  802a20:	00 
  802a21:	c7 44 24 08 83 33 80 	movl   $0x803383,0x8(%esp)
  802a28:	00 
  802a29:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802a30:	00 
  802a31:	c7 04 24 af 34 80 00 	movl   $0x8034af,(%esp)
  802a38:	e8 34 da ff ff       	call   800471 <_panic>
	e = &envs[ENVX(envid)];
  802a3d:	89 f3                	mov    %esi,%ebx
  802a3f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802a45:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802a48:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a4e:	eb 05                	jmp    802a55 <wait+0x4b>
		sys_yield();
  802a50:	e8 3f e5 ff ff       	call   800f94 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a55:	8b 43 48             	mov    0x48(%ebx),%eax
  802a58:	39 f0                	cmp    %esi,%eax
  802a5a:	75 07                	jne    802a63 <wait+0x59>
  802a5c:	8b 43 54             	mov    0x54(%ebx),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	75 ed                	jne    802a50 <wait+0x46>
		sys_yield();
}
  802a63:	83 c4 10             	add    $0x10,%esp
  802a66:	5b                   	pop    %ebx
  802a67:	5e                   	pop    %esi
  802a68:	5d                   	pop    %ebp
  802a69:	c3                   	ret    

00802a6a <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
  802a6d:	56                   	push   %esi
  802a6e:	53                   	push   %ebx
  802a6f:	83 ec 10             	sub    $0x10,%esp
  802a72:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a78:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802a7b:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802a7d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802a82:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802a85:	89 04 24             	mov    %eax,(%esp)
  802a88:	e8 3c e7 ff ff       	call   8011c9 <sys_ipc_recv>
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	75 1e                	jne    802aaf <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802a91:	85 db                	test   %ebx,%ebx
  802a93:	74 0a                	je     802a9f <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802a95:	a1 90 77 80 00       	mov    0x807790,%eax
  802a9a:	8b 40 74             	mov    0x74(%eax),%eax
  802a9d:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802a9f:	85 f6                	test   %esi,%esi
  802aa1:	74 22                	je     802ac5 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802aa3:	a1 90 77 80 00       	mov    0x807790,%eax
  802aa8:	8b 40 78             	mov    0x78(%eax),%eax
  802aab:	89 06                	mov    %eax,(%esi)
  802aad:	eb 16                	jmp    802ac5 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802aaf:	85 f6                	test   %esi,%esi
  802ab1:	74 06                	je     802ab9 <ipc_recv+0x4f>
				*perm_store = 0;
  802ab3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802ab9:	85 db                	test   %ebx,%ebx
  802abb:	74 10                	je     802acd <ipc_recv+0x63>
				*from_env_store=0;
  802abd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802ac3:	eb 08                	jmp    802acd <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802ac5:	a1 90 77 80 00       	mov    0x807790,%eax
  802aca:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802acd:	83 c4 10             	add    $0x10,%esp
  802ad0:	5b                   	pop    %ebx
  802ad1:	5e                   	pop    %esi
  802ad2:	5d                   	pop    %ebp
  802ad3:	c3                   	ret    

00802ad4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802ad4:	55                   	push   %ebp
  802ad5:	89 e5                	mov    %esp,%ebp
  802ad7:	57                   	push   %edi
  802ad8:	56                   	push   %esi
  802ad9:	53                   	push   %ebx
  802ada:	83 ec 1c             	sub    $0x1c,%esp
  802add:	8b 75 0c             	mov    0xc(%ebp),%esi
  802ae0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802ae3:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802ae6:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802ae8:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802aed:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802af0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802af4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802af8:	89 74 24 04          	mov    %esi,0x4(%esp)
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	89 04 24             	mov    %eax,(%esp)
  802b02:	e8 9f e6 ff ff       	call   8011a6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802b07:	eb 1c                	jmp    802b25 <ipc_send+0x51>
	{
		sys_yield();
  802b09:	e8 86 e4 ff ff       	call   800f94 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802b0e:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b12:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b16:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	89 04 24             	mov    %eax,(%esp)
  802b20:	e8 81 e6 ff ff       	call   8011a6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802b25:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b28:	74 df                	je     802b09 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802b2a:	83 c4 1c             	add    $0x1c,%esp
  802b2d:	5b                   	pop    %ebx
  802b2e:	5e                   	pop    %esi
  802b2f:	5f                   	pop    %edi
  802b30:	5d                   	pop    %ebp
  802b31:	c3                   	ret    

00802b32 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b32:	55                   	push   %ebp
  802b33:	89 e5                	mov    %esp,%ebp
  802b35:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802b38:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802b3d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802b40:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b46:	8b 52 50             	mov    0x50(%edx),%edx
  802b49:	39 ca                	cmp    %ecx,%edx
  802b4b:	75 0d                	jne    802b5a <ipc_find_env+0x28>
			return envs[i].env_id;
  802b4d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802b50:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802b55:	8b 40 40             	mov    0x40(%eax),%eax
  802b58:	eb 0e                	jmp    802b68 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b5a:	83 c0 01             	add    $0x1,%eax
  802b5d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b62:	75 d9                	jne    802b3d <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802b64:	66 b8 00 00          	mov    $0x0,%ax
}
  802b68:	5d                   	pop    %ebp
  802b69:	c3                   	ret    

00802b6a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b6a:	55                   	push   %ebp
  802b6b:	89 e5                	mov    %esp,%ebp
  802b6d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b70:	89 d0                	mov    %edx,%eax
  802b72:	c1 e8 16             	shr    $0x16,%eax
  802b75:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b81:	f6 c1 01             	test   $0x1,%cl
  802b84:	74 1d                	je     802ba3 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b86:	c1 ea 0c             	shr    $0xc,%edx
  802b89:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b90:	f6 c2 01             	test   $0x1,%dl
  802b93:	74 0e                	je     802ba3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b95:	c1 ea 0c             	shr    $0xc,%edx
  802b98:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b9f:	ef 
  802ba0:	0f b7 c0             	movzwl %ax,%eax
}
  802ba3:	5d                   	pop    %ebp
  802ba4:	c3                   	ret    
  802ba5:	66 90                	xchg   %ax,%ax
  802ba7:	66 90                	xchg   %ax,%ax
  802ba9:	66 90                	xchg   %ax,%ax
  802bab:	66 90                	xchg   %ax,%ax
  802bad:	66 90                	xchg   %ax,%ax
  802baf:	90                   	nop

00802bb0 <__udivdi3>:
  802bb0:	55                   	push   %ebp
  802bb1:	57                   	push   %edi
  802bb2:	56                   	push   %esi
  802bb3:	83 ec 0c             	sub    $0xc,%esp
  802bb6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802bba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802bbe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802bc2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bcc:	89 ea                	mov    %ebp,%edx
  802bce:	89 0c 24             	mov    %ecx,(%esp)
  802bd1:	75 2d                	jne    802c00 <__udivdi3+0x50>
  802bd3:	39 e9                	cmp    %ebp,%ecx
  802bd5:	77 61                	ja     802c38 <__udivdi3+0x88>
  802bd7:	85 c9                	test   %ecx,%ecx
  802bd9:	89 ce                	mov    %ecx,%esi
  802bdb:	75 0b                	jne    802be8 <__udivdi3+0x38>
  802bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  802be2:	31 d2                	xor    %edx,%edx
  802be4:	f7 f1                	div    %ecx
  802be6:	89 c6                	mov    %eax,%esi
  802be8:	31 d2                	xor    %edx,%edx
  802bea:	89 e8                	mov    %ebp,%eax
  802bec:	f7 f6                	div    %esi
  802bee:	89 c5                	mov    %eax,%ebp
  802bf0:	89 f8                	mov    %edi,%eax
  802bf2:	f7 f6                	div    %esi
  802bf4:	89 ea                	mov    %ebp,%edx
  802bf6:	83 c4 0c             	add    $0xc,%esp
  802bf9:	5e                   	pop    %esi
  802bfa:	5f                   	pop    %edi
  802bfb:	5d                   	pop    %ebp
  802bfc:	c3                   	ret    
  802bfd:	8d 76 00             	lea    0x0(%esi),%esi
  802c00:	39 e8                	cmp    %ebp,%eax
  802c02:	77 24                	ja     802c28 <__udivdi3+0x78>
  802c04:	0f bd e8             	bsr    %eax,%ebp
  802c07:	83 f5 1f             	xor    $0x1f,%ebp
  802c0a:	75 3c                	jne    802c48 <__udivdi3+0x98>
  802c0c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c10:	39 34 24             	cmp    %esi,(%esp)
  802c13:	0f 86 9f 00 00 00    	jbe    802cb8 <__udivdi3+0x108>
  802c19:	39 d0                	cmp    %edx,%eax
  802c1b:	0f 82 97 00 00 00    	jb     802cb8 <__udivdi3+0x108>
  802c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c28:	31 d2                	xor    %edx,%edx
  802c2a:	31 c0                	xor    %eax,%eax
  802c2c:	83 c4 0c             	add    $0xc,%esp
  802c2f:	5e                   	pop    %esi
  802c30:	5f                   	pop    %edi
  802c31:	5d                   	pop    %ebp
  802c32:	c3                   	ret    
  802c33:	90                   	nop
  802c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c38:	89 f8                	mov    %edi,%eax
  802c3a:	f7 f1                	div    %ecx
  802c3c:	31 d2                	xor    %edx,%edx
  802c3e:	83 c4 0c             	add    $0xc,%esp
  802c41:	5e                   	pop    %esi
  802c42:	5f                   	pop    %edi
  802c43:	5d                   	pop    %ebp
  802c44:	c3                   	ret    
  802c45:	8d 76 00             	lea    0x0(%esi),%esi
  802c48:	89 e9                	mov    %ebp,%ecx
  802c4a:	8b 3c 24             	mov    (%esp),%edi
  802c4d:	d3 e0                	shl    %cl,%eax
  802c4f:	89 c6                	mov    %eax,%esi
  802c51:	b8 20 00 00 00       	mov    $0x20,%eax
  802c56:	29 e8                	sub    %ebp,%eax
  802c58:	89 c1                	mov    %eax,%ecx
  802c5a:	d3 ef                	shr    %cl,%edi
  802c5c:	89 e9                	mov    %ebp,%ecx
  802c5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c62:	8b 3c 24             	mov    (%esp),%edi
  802c65:	09 74 24 08          	or     %esi,0x8(%esp)
  802c69:	89 d6                	mov    %edx,%esi
  802c6b:	d3 e7                	shl    %cl,%edi
  802c6d:	89 c1                	mov    %eax,%ecx
  802c6f:	89 3c 24             	mov    %edi,(%esp)
  802c72:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c76:	d3 ee                	shr    %cl,%esi
  802c78:	89 e9                	mov    %ebp,%ecx
  802c7a:	d3 e2                	shl    %cl,%edx
  802c7c:	89 c1                	mov    %eax,%ecx
  802c7e:	d3 ef                	shr    %cl,%edi
  802c80:	09 d7                	or     %edx,%edi
  802c82:	89 f2                	mov    %esi,%edx
  802c84:	89 f8                	mov    %edi,%eax
  802c86:	f7 74 24 08          	divl   0x8(%esp)
  802c8a:	89 d6                	mov    %edx,%esi
  802c8c:	89 c7                	mov    %eax,%edi
  802c8e:	f7 24 24             	mull   (%esp)
  802c91:	39 d6                	cmp    %edx,%esi
  802c93:	89 14 24             	mov    %edx,(%esp)
  802c96:	72 30                	jb     802cc8 <__udivdi3+0x118>
  802c98:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c9c:	89 e9                	mov    %ebp,%ecx
  802c9e:	d3 e2                	shl    %cl,%edx
  802ca0:	39 c2                	cmp    %eax,%edx
  802ca2:	73 05                	jae    802ca9 <__udivdi3+0xf9>
  802ca4:	3b 34 24             	cmp    (%esp),%esi
  802ca7:	74 1f                	je     802cc8 <__udivdi3+0x118>
  802ca9:	89 f8                	mov    %edi,%eax
  802cab:	31 d2                	xor    %edx,%edx
  802cad:	e9 7a ff ff ff       	jmp    802c2c <__udivdi3+0x7c>
  802cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cb8:	31 d2                	xor    %edx,%edx
  802cba:	b8 01 00 00 00       	mov    $0x1,%eax
  802cbf:	e9 68 ff ff ff       	jmp    802c2c <__udivdi3+0x7c>
  802cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cc8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802ccb:	31 d2                	xor    %edx,%edx
  802ccd:	83 c4 0c             	add    $0xc,%esp
  802cd0:	5e                   	pop    %esi
  802cd1:	5f                   	pop    %edi
  802cd2:	5d                   	pop    %ebp
  802cd3:	c3                   	ret    
  802cd4:	66 90                	xchg   %ax,%ax
  802cd6:	66 90                	xchg   %ax,%ax
  802cd8:	66 90                	xchg   %ax,%ax
  802cda:	66 90                	xchg   %ax,%ax
  802cdc:	66 90                	xchg   %ax,%ax
  802cde:	66 90                	xchg   %ax,%ax

00802ce0 <__umoddi3>:
  802ce0:	55                   	push   %ebp
  802ce1:	57                   	push   %edi
  802ce2:	56                   	push   %esi
  802ce3:	83 ec 14             	sub    $0x14,%esp
  802ce6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802cf2:	89 c7                	mov    %eax,%edi
  802cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cf8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802cfc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d00:	89 34 24             	mov    %esi,(%esp)
  802d03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d07:	85 c0                	test   %eax,%eax
  802d09:	89 c2                	mov    %eax,%edx
  802d0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d0f:	75 17                	jne    802d28 <__umoddi3+0x48>
  802d11:	39 fe                	cmp    %edi,%esi
  802d13:	76 4b                	jbe    802d60 <__umoddi3+0x80>
  802d15:	89 c8                	mov    %ecx,%eax
  802d17:	89 fa                	mov    %edi,%edx
  802d19:	f7 f6                	div    %esi
  802d1b:	89 d0                	mov    %edx,%eax
  802d1d:	31 d2                	xor    %edx,%edx
  802d1f:	83 c4 14             	add    $0x14,%esp
  802d22:	5e                   	pop    %esi
  802d23:	5f                   	pop    %edi
  802d24:	5d                   	pop    %ebp
  802d25:	c3                   	ret    
  802d26:	66 90                	xchg   %ax,%ax
  802d28:	39 f8                	cmp    %edi,%eax
  802d2a:	77 54                	ja     802d80 <__umoddi3+0xa0>
  802d2c:	0f bd e8             	bsr    %eax,%ebp
  802d2f:	83 f5 1f             	xor    $0x1f,%ebp
  802d32:	75 5c                	jne    802d90 <__umoddi3+0xb0>
  802d34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d38:	39 3c 24             	cmp    %edi,(%esp)
  802d3b:	0f 87 e7 00 00 00    	ja     802e28 <__umoddi3+0x148>
  802d41:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d45:	29 f1                	sub    %esi,%ecx
  802d47:	19 c7                	sbb    %eax,%edi
  802d49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d51:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d55:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d59:	83 c4 14             	add    $0x14,%esp
  802d5c:	5e                   	pop    %esi
  802d5d:	5f                   	pop    %edi
  802d5e:	5d                   	pop    %ebp
  802d5f:	c3                   	ret    
  802d60:	85 f6                	test   %esi,%esi
  802d62:	89 f5                	mov    %esi,%ebp
  802d64:	75 0b                	jne    802d71 <__umoddi3+0x91>
  802d66:	b8 01 00 00 00       	mov    $0x1,%eax
  802d6b:	31 d2                	xor    %edx,%edx
  802d6d:	f7 f6                	div    %esi
  802d6f:	89 c5                	mov    %eax,%ebp
  802d71:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d75:	31 d2                	xor    %edx,%edx
  802d77:	f7 f5                	div    %ebp
  802d79:	89 c8                	mov    %ecx,%eax
  802d7b:	f7 f5                	div    %ebp
  802d7d:	eb 9c                	jmp    802d1b <__umoddi3+0x3b>
  802d7f:	90                   	nop
  802d80:	89 c8                	mov    %ecx,%eax
  802d82:	89 fa                	mov    %edi,%edx
  802d84:	83 c4 14             	add    $0x14,%esp
  802d87:	5e                   	pop    %esi
  802d88:	5f                   	pop    %edi
  802d89:	5d                   	pop    %ebp
  802d8a:	c3                   	ret    
  802d8b:	90                   	nop
  802d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d90:	8b 04 24             	mov    (%esp),%eax
  802d93:	be 20 00 00 00       	mov    $0x20,%esi
  802d98:	89 e9                	mov    %ebp,%ecx
  802d9a:	29 ee                	sub    %ebp,%esi
  802d9c:	d3 e2                	shl    %cl,%edx
  802d9e:	89 f1                	mov    %esi,%ecx
  802da0:	d3 e8                	shr    %cl,%eax
  802da2:	89 e9                	mov    %ebp,%ecx
  802da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802da8:	8b 04 24             	mov    (%esp),%eax
  802dab:	09 54 24 04          	or     %edx,0x4(%esp)
  802daf:	89 fa                	mov    %edi,%edx
  802db1:	d3 e0                	shl    %cl,%eax
  802db3:	89 f1                	mov    %esi,%ecx
  802db5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802db9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802dbd:	d3 ea                	shr    %cl,%edx
  802dbf:	89 e9                	mov    %ebp,%ecx
  802dc1:	d3 e7                	shl    %cl,%edi
  802dc3:	89 f1                	mov    %esi,%ecx
  802dc5:	d3 e8                	shr    %cl,%eax
  802dc7:	89 e9                	mov    %ebp,%ecx
  802dc9:	09 f8                	or     %edi,%eax
  802dcb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802dcf:	f7 74 24 04          	divl   0x4(%esp)
  802dd3:	d3 e7                	shl    %cl,%edi
  802dd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dd9:	89 d7                	mov    %edx,%edi
  802ddb:	f7 64 24 08          	mull   0x8(%esp)
  802ddf:	39 d7                	cmp    %edx,%edi
  802de1:	89 c1                	mov    %eax,%ecx
  802de3:	89 14 24             	mov    %edx,(%esp)
  802de6:	72 2c                	jb     802e14 <__umoddi3+0x134>
  802de8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802dec:	72 22                	jb     802e10 <__umoddi3+0x130>
  802dee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802df2:	29 c8                	sub    %ecx,%eax
  802df4:	19 d7                	sbb    %edx,%edi
  802df6:	89 e9                	mov    %ebp,%ecx
  802df8:	89 fa                	mov    %edi,%edx
  802dfa:	d3 e8                	shr    %cl,%eax
  802dfc:	89 f1                	mov    %esi,%ecx
  802dfe:	d3 e2                	shl    %cl,%edx
  802e00:	89 e9                	mov    %ebp,%ecx
  802e02:	d3 ef                	shr    %cl,%edi
  802e04:	09 d0                	or     %edx,%eax
  802e06:	89 fa                	mov    %edi,%edx
  802e08:	83 c4 14             	add    $0x14,%esp
  802e0b:	5e                   	pop    %esi
  802e0c:	5f                   	pop    %edi
  802e0d:	5d                   	pop    %ebp
  802e0e:	c3                   	ret    
  802e0f:	90                   	nop
  802e10:	39 d7                	cmp    %edx,%edi
  802e12:	75 da                	jne    802dee <__umoddi3+0x10e>
  802e14:	8b 14 24             	mov    (%esp),%edx
  802e17:	89 c1                	mov    %eax,%ecx
  802e19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802e1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e21:	eb cb                	jmp    802dee <__umoddi3+0x10e>
  802e23:	90                   	nop
  802e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e2c:	0f 82 0f ff ff ff    	jb     802d41 <__umoddi3+0x61>
  802e32:	e9 1a ff ff ff       	jmp    802d51 <__umoddi3+0x71>
