
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 95 02 00 00       	call   8002c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 00 0f 00 00       	call   800f44 <sys_yield>
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>
		sys_yield();

	close(0);
  800049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800050:	e8 e2 13 00 00       	call   801437 <close>
	if ((r = opencons()) < 0)
  800055:	e8 11 02 00 00       	call   80026b <opencons>
  80005a:	85 c0                	test   %eax,%eax
  80005c:	79 20                	jns    80007e <umain+0x4b>
		panic("opencons: %e", r);
  80005e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800062:	c7 44 24 08 c0 28 80 	movl   $0x8028c0,0x8(%esp)
  800069:	00 
  80006a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800071:	00 
  800072:	c7 04 24 cd 28 80 00 	movl   $0x8028cd,(%esp)
  800079:	e8 b3 02 00 00       	call   800331 <_panic>
	if (r != 0)
  80007e:	85 c0                	test   %eax,%eax
  800080:	74 20                	je     8000a2 <umain+0x6f>
		panic("first opencons used fd %d", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 dc 28 80 	movl   $0x8028dc,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 cd 28 80 00 	movl   $0x8028cd,(%esp)
  80009d:	e8 8f 02 00 00       	call   800331 <_panic>
	if ((r = dup(0, 1)) < 0)
  8000a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000a9:	00 
  8000aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b1:	e8 d6 13 00 00       	call   80148c <dup>
  8000b6:	85 c0                	test   %eax,%eax
  8000b8:	79 20                	jns    8000da <umain+0xa7>
		panic("dup: %e", r);
  8000ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000be:	c7 44 24 08 f6 28 80 	movl   $0x8028f6,0x8(%esp)
  8000c5:	00 
  8000c6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000cd:	00 
  8000ce:	c7 04 24 cd 28 80 00 	movl   $0x8028cd,(%esp)
  8000d5:	e8 57 02 00 00       	call   800331 <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000da:	c7 04 24 fe 28 80 00 	movl   $0x8028fe,(%esp)
  8000e1:	e8 3a 09 00 00       	call   800a20 <readline>
		if (buf != NULL)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	74 1a                	je     800104 <umain+0xd1>
			fprintf(1, "%s\n", buf);
  8000ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ee:	c7 44 24 04 0c 29 80 	movl   $0x80290c,0x4(%esp)
  8000f5:	00 
  8000f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fd:	e8 00 1b 00 00       	call   801c02 <fprintf>
  800102:	eb d6                	jmp    8000da <umain+0xa7>
		else
			fprintf(1, "(end of file received)\n");
  800104:	c7 44 24 04 10 29 80 	movl   $0x802910,0x4(%esp)
  80010b:	00 
  80010c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800113:	e8 ea 1a 00 00       	call   801c02 <fprintf>
  800118:	eb c0                	jmp    8000da <umain+0xa7>
  80011a:	66 90                	xchg   %ax,%ax
  80011c:	66 90                	xchg   %ax,%ax
  80011e:	66 90                	xchg   %ax,%ax

00800120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800130:	c7 44 24 04 28 29 80 	movl   $0x802928,0x4(%esp)
  800137:	00 
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 04 0a 00 00       	call   800b47 <strcpy>
	return 0;
}
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800156:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80015b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800161:	eb 31                	jmp    800194 <devcons_write+0x4a>
		m = n - tot;
  800163:	8b 75 10             	mov    0x10(%ebp),%esi
  800166:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  800168:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80016b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800170:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800173:	89 74 24 08          	mov    %esi,0x8(%esp)
  800177:	03 45 0c             	add    0xc(%ebp),%eax
  80017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017e:	89 3c 24             	mov    %edi,(%esp)
  800181:	e8 5e 0b 00 00       	call   800ce4 <memmove>
		sys_cputs(buf, m);
  800186:	89 74 24 04          	mov    %esi,0x4(%esp)
  80018a:	89 3c 24             	mov    %edi,(%esp)
  80018d:	e8 04 0d 00 00       	call   800e96 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800192:	01 f3                	add    %esi,%ebx
  800194:	89 d8                	mov    %ebx,%eax
  800196:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800199:	72 c8                	jb     800163 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80019b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    

008001a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8001ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8001b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001b5:	75 07                	jne    8001be <devcons_read+0x18>
  8001b7:	eb 2a                	jmp    8001e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001b9:	e8 86 0d 00 00       	call   800f44 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001be:	66 90                	xchg   %ax,%ax
  8001c0:	e8 ef 0c 00 00       	call   800eb4 <sys_cgetc>
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 f0                	je     8001b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	78 16                	js     8001e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001cd:	83 f8 04             	cmp    $0x4,%eax
  8001d0:	74 0c                	je     8001de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	88 02                	mov    %al,(%edx)
	return 1;
  8001d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8001dc:	eb 05                	jmp    8001e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8001de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8001e3:	c9                   	leave  
  8001e4:	c3                   	ret    

008001e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001f8:	00 
  8001f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001fc:	89 04 24             	mov    %eax,(%esp)
  8001ff:	e8 92 0c 00 00       	call   800e96 <sys_cputs>
}
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <getchar>:

int
getchar(void)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80020c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800213:	00 
  800214:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800222:	e8 73 13 00 00       	call   80159a <read>
	if (r < 0)
  800227:	85 c0                	test   %eax,%eax
  800229:	78 0f                	js     80023a <getchar+0x34>
		return r;
	if (r < 1)
  80022b:	85 c0                	test   %eax,%eax
  80022d:	7e 06                	jle    800235 <getchar+0x2f>
		return -E_EOF;
	return c;
  80022f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800233:	eb 05                	jmp    80023a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800235:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800242:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800245:	89 44 24 04          	mov    %eax,0x4(%esp)
  800249:	8b 45 08             	mov    0x8(%ebp),%eax
  80024c:	89 04 24             	mov    %eax,(%esp)
  80024f:	e8 b2 10 00 00       	call   801306 <fd_lookup>
  800254:	85 c0                	test   %eax,%eax
  800256:	78 11                	js     800269 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025b:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800261:	39 10                	cmp    %edx,(%eax)
  800263:	0f 94 c0             	sete   %al
  800266:	0f b6 c0             	movzbl %al,%eax
}
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <opencons>:

int
opencons(void)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800271:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800274:	89 04 24             	mov    %eax,(%esp)
  800277:	e8 3b 10 00 00       	call   8012b7 <fd_alloc>
		return r;
  80027c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	78 40                	js     8002c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800282:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800289:	00 
  80028a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80028d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800291:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800298:	e8 c6 0c 00 00       	call   800f63 <sys_page_alloc>
		return r;
  80029d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	78 1f                	js     8002c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8002a3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8002ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	e8 d0 0f 00 00       	call   801290 <fd2num>
  8002c0:	89 c2                	mov    %eax,%edx
}
  8002c2:	89 d0                	mov    %edx,%eax
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    

008002c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 10             	sub    $0x10,%esp
  8002ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002d1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8002d4:	c7 05 08 44 80 00 00 	movl   $0x0,0x804408
  8002db:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8002de:	e8 42 0c 00 00       	call   800f25 <sys_getenvid>
  8002e3:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8002e8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f0:	a3 08 44 80 00       	mov    %eax,0x804408


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f5:	85 db                	test   %ebx,%ebx
  8002f7:	7e 07                	jle    800300 <libmain+0x3a>
		binaryname = argv[0];
  8002f9:	8b 06                	mov    (%esi),%eax
  8002fb:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  800300:	89 74 24 04          	mov    %esi,0x4(%esp)
  800304:	89 1c 24             	mov    %ebx,(%esp)
  800307:	e8 27 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80030c:	e8 07 00 00 00       	call   800318 <exit>
}
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	5b                   	pop    %ebx
  800315:	5e                   	pop    %esi
  800316:	5d                   	pop    %ebp
  800317:	c3                   	ret    

00800318 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80031e:	e8 47 11 00 00       	call   80146a <close_all>
	sys_env_destroy(0);
  800323:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80032a:	e8 a4 0b 00 00       	call   800ed3 <sys_env_destroy>
}
  80032f:	c9                   	leave  
  800330:	c3                   	ret    

00800331 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800339:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80033c:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  800342:	e8 de 0b 00 00       	call   800f25 <sys_getenvid>
  800347:	8b 55 0c             	mov    0xc(%ebp),%edx
  80034a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80034e:	8b 55 08             	mov    0x8(%ebp),%edx
  800351:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800355:	89 74 24 08          	mov    %esi,0x8(%esp)
  800359:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035d:	c7 04 24 40 29 80 00 	movl   $0x802940,(%esp)
  800364:	e8 c1 00 00 00       	call   80042a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800369:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80036d:	8b 45 10             	mov    0x10(%ebp),%eax
  800370:	89 04 24             	mov    %eax,(%esp)
  800373:	e8 51 00 00 00       	call   8003c9 <vcprintf>
	cprintf("\n");
  800378:	c7 04 24 26 29 80 00 	movl   $0x802926,(%esp)
  80037f:	e8 a6 00 00 00       	call   80042a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800384:	cc                   	int3   
  800385:	eb fd                	jmp    800384 <_panic+0x53>

00800387 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	53                   	push   %ebx
  80038b:	83 ec 14             	sub    $0x14,%esp
  80038e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800391:	8b 13                	mov    (%ebx),%edx
  800393:	8d 42 01             	lea    0x1(%edx),%eax
  800396:	89 03                	mov    %eax,(%ebx)
  800398:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80039b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80039f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003a4:	75 19                	jne    8003bf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003a6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003ad:	00 
  8003ae:	8d 43 08             	lea    0x8(%ebx),%eax
  8003b1:	89 04 24             	mov    %eax,(%esp)
  8003b4:	e8 dd 0a 00 00       	call   800e96 <sys_cputs>
		b->idx = 0;
  8003b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003bf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003c3:	83 c4 14             	add    $0x14,%esp
  8003c6:	5b                   	pop    %ebx
  8003c7:	5d                   	pop    %ebp
  8003c8:	c3                   	ret    

008003c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
  8003cc:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003d9:	00 00 00 
	b.cnt = 0;
  8003dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003e3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fe:	c7 04 24 87 03 80 00 	movl   $0x800387,(%esp)
  800405:	e8 b4 01 00 00       	call   8005be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80040a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800410:	89 44 24 04          	mov    %eax,0x4(%esp)
  800414:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80041a:	89 04 24             	mov    %eax,(%esp)
  80041d:	e8 74 0a 00 00       	call   800e96 <sys_cputs>

	return b.cnt;
}
  800422:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800430:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800433:	89 44 24 04          	mov    %eax,0x4(%esp)
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	89 04 24             	mov    %eax,(%esp)
  80043d:	e8 87 ff ff ff       	call   8003c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800442:	c9                   	leave  
  800443:	c3                   	ret    
  800444:	66 90                	xchg   %ax,%ax
  800446:	66 90                	xchg   %ax,%ax
  800448:	66 90                	xchg   %ax,%ax
  80044a:	66 90                	xchg   %ax,%ax
  80044c:	66 90                	xchg   %ax,%ax
  80044e:	66 90                	xchg   %ax,%ax

00800450 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	57                   	push   %edi
  800454:	56                   	push   %esi
  800455:	53                   	push   %ebx
  800456:	83 ec 3c             	sub    $0x3c,%esp
  800459:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80045c:	89 d7                	mov    %edx,%edi
  80045e:	8b 45 08             	mov    0x8(%ebp),%eax
  800461:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	89 c3                	mov    %eax,%ebx
  800469:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80046c:	8b 45 10             	mov    0x10(%ebp),%eax
  80046f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800472:	b9 00 00 00 00       	mov    $0x0,%ecx
  800477:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80047a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80047d:	39 d9                	cmp    %ebx,%ecx
  80047f:	72 05                	jb     800486 <printnum+0x36>
  800481:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800484:	77 69                	ja     8004ef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800486:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800489:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80048d:	83 ee 01             	sub    $0x1,%esi
  800490:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800494:	89 44 24 08          	mov    %eax,0x8(%esp)
  800498:	8b 44 24 08          	mov    0x8(%esp),%eax
  80049c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004a0:	89 c3                	mov    %eax,%ebx
  8004a2:	89 d6                	mov    %edx,%esi
  8004a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004ae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b5:	89 04 24             	mov    %eax,(%esp)
  8004b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004bf:	e8 5c 21 00 00       	call   802620 <__udivdi3>
  8004c4:	89 d9                	mov    %ebx,%ecx
  8004c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004ce:	89 04 24             	mov    %eax,(%esp)
  8004d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004d5:	89 fa                	mov    %edi,%edx
  8004d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004da:	e8 71 ff ff ff       	call   800450 <printnum>
  8004df:	eb 1b                	jmp    8004fc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004e8:	89 04 24             	mov    %eax,(%esp)
  8004eb:	ff d3                	call   *%ebx
  8004ed:	eb 03                	jmp    8004f2 <printnum+0xa2>
  8004ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004f2:	83 ee 01             	sub    $0x1,%esi
  8004f5:	85 f6                	test   %esi,%esi
  8004f7:	7f e8                	jg     8004e1 <printnum+0x91>
  8004f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800500:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800507:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80050a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80050e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800512:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800515:	89 04 24             	mov    %eax,(%esp)
  800518:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80051b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051f:	e8 2c 22 00 00       	call   802750 <__umoddi3>
  800524:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800528:	0f be 80 63 29 80 00 	movsbl 0x802963(%eax),%eax
  80052f:	89 04 24             	mov    %eax,(%esp)
  800532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800535:	ff d0                	call   *%eax
}
  800537:	83 c4 3c             	add    $0x3c,%esp
  80053a:	5b                   	pop    %ebx
  80053b:	5e                   	pop    %esi
  80053c:	5f                   	pop    %edi
  80053d:	5d                   	pop    %ebp
  80053e:	c3                   	ret    

0080053f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80053f:	55                   	push   %ebp
  800540:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800542:	83 fa 01             	cmp    $0x1,%edx
  800545:	7e 0e                	jle    800555 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800547:	8b 10                	mov    (%eax),%edx
  800549:	8d 4a 08             	lea    0x8(%edx),%ecx
  80054c:	89 08                	mov    %ecx,(%eax)
  80054e:	8b 02                	mov    (%edx),%eax
  800550:	8b 52 04             	mov    0x4(%edx),%edx
  800553:	eb 22                	jmp    800577 <getuint+0x38>
	else if (lflag)
  800555:	85 d2                	test   %edx,%edx
  800557:	74 10                	je     800569 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800559:	8b 10                	mov    (%eax),%edx
  80055b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80055e:	89 08                	mov    %ecx,(%eax)
  800560:	8b 02                	mov    (%edx),%eax
  800562:	ba 00 00 00 00       	mov    $0x0,%edx
  800567:	eb 0e                	jmp    800577 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800569:	8b 10                	mov    (%eax),%edx
  80056b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80056e:	89 08                	mov    %ecx,(%eax)
  800570:	8b 02                	mov    (%edx),%eax
  800572:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800577:	5d                   	pop    %ebp
  800578:	c3                   	ret    

00800579 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800579:	55                   	push   %ebp
  80057a:	89 e5                	mov    %esp,%ebp
  80057c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80057f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800583:	8b 10                	mov    (%eax),%edx
  800585:	3b 50 04             	cmp    0x4(%eax),%edx
  800588:	73 0a                	jae    800594 <sprintputch+0x1b>
		*b->buf++ = ch;
  80058a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80058d:	89 08                	mov    %ecx,(%eax)
  80058f:	8b 45 08             	mov    0x8(%ebp),%eax
  800592:	88 02                	mov    %al,(%edx)
}
  800594:	5d                   	pop    %ebp
  800595:	c3                   	ret    

00800596 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800596:	55                   	push   %ebp
  800597:	89 e5                	mov    %esp,%ebp
  800599:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80059c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80059f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b4:	89 04 24             	mov    %eax,(%esp)
  8005b7:	e8 02 00 00 00       	call   8005be <vprintfmt>
	va_end(ap);
}
  8005bc:	c9                   	leave  
  8005bd:	c3                   	ret    

008005be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005be:	55                   	push   %ebp
  8005bf:	89 e5                	mov    %esp,%ebp
  8005c1:	57                   	push   %edi
  8005c2:	56                   	push   %esi
  8005c3:	53                   	push   %ebx
  8005c4:	83 ec 3c             	sub    $0x3c,%esp
  8005c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005cd:	eb 14                	jmp    8005e3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005cf:	85 c0                	test   %eax,%eax
  8005d1:	0f 84 b3 03 00 00    	je     80098a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8005d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005db:	89 04 24             	mov    %eax,(%esp)
  8005de:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005e1:	89 f3                	mov    %esi,%ebx
  8005e3:	8d 73 01             	lea    0x1(%ebx),%esi
  8005e6:	0f b6 03             	movzbl (%ebx),%eax
  8005e9:	83 f8 25             	cmp    $0x25,%eax
  8005ec:	75 e1                	jne    8005cf <vprintfmt+0x11>
  8005ee:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8005f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005f9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800600:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800607:	ba 00 00 00 00       	mov    $0x0,%edx
  80060c:	eb 1d                	jmp    80062b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800610:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800614:	eb 15                	jmp    80062b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800616:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800618:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80061c:	eb 0d                	jmp    80062b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80061e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800621:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800624:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80062e:	0f b6 0e             	movzbl (%esi),%ecx
  800631:	0f b6 c1             	movzbl %cl,%eax
  800634:	83 e9 23             	sub    $0x23,%ecx
  800637:	80 f9 55             	cmp    $0x55,%cl
  80063a:	0f 87 2a 03 00 00    	ja     80096a <vprintfmt+0x3ac>
  800640:	0f b6 c9             	movzbl %cl,%ecx
  800643:	ff 24 8d a0 2a 80 00 	jmp    *0x802aa0(,%ecx,4)
  80064a:	89 de                	mov    %ebx,%esi
  80064c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800651:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800654:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800658:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80065b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80065e:	83 fb 09             	cmp    $0x9,%ebx
  800661:	77 36                	ja     800699 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800663:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800666:	eb e9                	jmp    800651 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8d 48 04             	lea    0x4(%eax),%ecx
  80066e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800671:	8b 00                	mov    (%eax),%eax
  800673:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800676:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800678:	eb 22                	jmp    80069c <vprintfmt+0xde>
  80067a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80067d:	85 c9                	test   %ecx,%ecx
  80067f:	b8 00 00 00 00       	mov    $0x0,%eax
  800684:	0f 49 c1             	cmovns %ecx,%eax
  800687:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80068a:	89 de                	mov    %ebx,%esi
  80068c:	eb 9d                	jmp    80062b <vprintfmt+0x6d>
  80068e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800690:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800697:	eb 92                	jmp    80062b <vprintfmt+0x6d>
  800699:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80069c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006a0:	79 89                	jns    80062b <vprintfmt+0x6d>
  8006a2:	e9 77 ff ff ff       	jmp    80061e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006a7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006aa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006ac:	e9 7a ff ff ff       	jmp    80062b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b4:	8d 50 04             	lea    0x4(%eax),%edx
  8006b7:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	89 04 24             	mov    %eax,(%esp)
  8006c3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006c6:	e9 18 ff ff ff       	jmp    8005e3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ce:	8d 50 04             	lea    0x4(%eax),%edx
  8006d1:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	99                   	cltd   
  8006d7:	31 d0                	xor    %edx,%eax
  8006d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006db:	83 f8 0f             	cmp    $0xf,%eax
  8006de:	7f 0b                	jg     8006eb <vprintfmt+0x12d>
  8006e0:	8b 14 85 00 2c 80 00 	mov    0x802c00(,%eax,4),%edx
  8006e7:	85 d2                	test   %edx,%edx
  8006e9:	75 20                	jne    80070b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8006eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006ef:	c7 44 24 08 7b 29 80 	movl   $0x80297b,0x8(%esp)
  8006f6:	00 
  8006f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 04 24             	mov    %eax,(%esp)
  800701:	e8 90 fe ff ff       	call   800596 <printfmt>
  800706:	e9 d8 fe ff ff       	jmp    8005e3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80070b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80070f:	c7 44 24 08 49 2d 80 	movl   $0x802d49,0x8(%esp)
  800716:	00 
  800717:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	89 04 24             	mov    %eax,(%esp)
  800721:	e8 70 fe ff ff       	call   800596 <printfmt>
  800726:	e9 b8 fe ff ff       	jmp    8005e3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80072e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800731:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800734:	8b 45 14             	mov    0x14(%ebp),%eax
  800737:	8d 50 04             	lea    0x4(%eax),%edx
  80073a:	89 55 14             	mov    %edx,0x14(%ebp)
  80073d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80073f:	85 f6                	test   %esi,%esi
  800741:	b8 74 29 80 00       	mov    $0x802974,%eax
  800746:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800749:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80074d:	0f 84 97 00 00 00    	je     8007ea <vprintfmt+0x22c>
  800753:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800757:	0f 8e 9b 00 00 00    	jle    8007f8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80075d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800761:	89 34 24             	mov    %esi,(%esp)
  800764:	e8 bf 03 00 00       	call   800b28 <strnlen>
  800769:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80076c:	29 c2                	sub    %eax,%edx
  80076e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800771:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800775:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800778:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80077b:	8b 75 08             	mov    0x8(%ebp),%esi
  80077e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800781:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800783:	eb 0f                	jmp    800794 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800785:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800789:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80078c:	89 04 24             	mov    %eax,(%esp)
  80078f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800791:	83 eb 01             	sub    $0x1,%ebx
  800794:	85 db                	test   %ebx,%ebx
  800796:	7f ed                	jg     800785 <vprintfmt+0x1c7>
  800798:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80079b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80079e:	85 d2                	test   %edx,%edx
  8007a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a5:	0f 49 c2             	cmovns %edx,%eax
  8007a8:	29 c2                	sub    %eax,%edx
  8007aa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007ad:	89 d7                	mov    %edx,%edi
  8007af:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007b2:	eb 50                	jmp    800804 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b8:	74 1e                	je     8007d8 <vprintfmt+0x21a>
  8007ba:	0f be d2             	movsbl %dl,%edx
  8007bd:	83 ea 20             	sub    $0x20,%edx
  8007c0:	83 fa 5e             	cmp    $0x5e,%edx
  8007c3:	76 13                	jbe    8007d8 <vprintfmt+0x21a>
					putch('?', putdat);
  8007c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007cc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007d3:	ff 55 08             	call   *0x8(%ebp)
  8007d6:	eb 0d                	jmp    8007e5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8007d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007df:	89 04 24             	mov    %eax,(%esp)
  8007e2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007e5:	83 ef 01             	sub    $0x1,%edi
  8007e8:	eb 1a                	jmp    800804 <vprintfmt+0x246>
  8007ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007ed:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007f0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007f3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007f6:	eb 0c                	jmp    800804 <vprintfmt+0x246>
  8007f8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007fb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800801:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800804:	83 c6 01             	add    $0x1,%esi
  800807:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80080b:	0f be c2             	movsbl %dl,%eax
  80080e:	85 c0                	test   %eax,%eax
  800810:	74 27                	je     800839 <vprintfmt+0x27b>
  800812:	85 db                	test   %ebx,%ebx
  800814:	78 9e                	js     8007b4 <vprintfmt+0x1f6>
  800816:	83 eb 01             	sub    $0x1,%ebx
  800819:	79 99                	jns    8007b4 <vprintfmt+0x1f6>
  80081b:	89 f8                	mov    %edi,%eax
  80081d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800820:	8b 75 08             	mov    0x8(%ebp),%esi
  800823:	89 c3                	mov    %eax,%ebx
  800825:	eb 1a                	jmp    800841 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800827:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80082b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800832:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800834:	83 eb 01             	sub    $0x1,%ebx
  800837:	eb 08                	jmp    800841 <vprintfmt+0x283>
  800839:	89 fb                	mov    %edi,%ebx
  80083b:	8b 75 08             	mov    0x8(%ebp),%esi
  80083e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800841:	85 db                	test   %ebx,%ebx
  800843:	7f e2                	jg     800827 <vprintfmt+0x269>
  800845:	89 75 08             	mov    %esi,0x8(%ebp)
  800848:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80084b:	e9 93 fd ff ff       	jmp    8005e3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800850:	83 fa 01             	cmp    $0x1,%edx
  800853:	7e 16                	jle    80086b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800855:	8b 45 14             	mov    0x14(%ebp),%eax
  800858:	8d 50 08             	lea    0x8(%eax),%edx
  80085b:	89 55 14             	mov    %edx,0x14(%ebp)
  80085e:	8b 50 04             	mov    0x4(%eax),%edx
  800861:	8b 00                	mov    (%eax),%eax
  800863:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800866:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800869:	eb 32                	jmp    80089d <vprintfmt+0x2df>
	else if (lflag)
  80086b:	85 d2                	test   %edx,%edx
  80086d:	74 18                	je     800887 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8d 50 04             	lea    0x4(%eax),%edx
  800875:	89 55 14             	mov    %edx,0x14(%ebp)
  800878:	8b 30                	mov    (%eax),%esi
  80087a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80087d:	89 f0                	mov    %esi,%eax
  80087f:	c1 f8 1f             	sar    $0x1f,%eax
  800882:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800885:	eb 16                	jmp    80089d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	8d 50 04             	lea    0x4(%eax),%edx
  80088d:	89 55 14             	mov    %edx,0x14(%ebp)
  800890:	8b 30                	mov    (%eax),%esi
  800892:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800895:	89 f0                	mov    %esi,%eax
  800897:	c1 f8 1f             	sar    $0x1f,%eax
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80089d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ac:	0f 89 80 00 00 00    	jns    800932 <vprintfmt+0x374>
				putch('-', putdat);
  8008b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008b6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008bd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008c6:	f7 d8                	neg    %eax
  8008c8:	83 d2 00             	adc    $0x0,%edx
  8008cb:	f7 da                	neg    %edx
			}
			base = 10;
  8008cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8008d2:	eb 5e                	jmp    800932 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d7:	e8 63 fc ff ff       	call   80053f <getuint>
			base = 10;
  8008dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8008e1:	eb 4f                	jmp    800932 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  8008e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e6:	e8 54 fc ff ff       	call   80053f <getuint>
			base =8;
  8008eb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8008f0:	eb 40                	jmp    800932 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  8008f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008fd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800900:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800904:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80090b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80090e:	8b 45 14             	mov    0x14(%ebp),%eax
  800911:	8d 50 04             	lea    0x4(%eax),%edx
  800914:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800917:	8b 00                	mov    (%eax),%eax
  800919:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80091e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800923:	eb 0d                	jmp    800932 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800925:	8d 45 14             	lea    0x14(%ebp),%eax
  800928:	e8 12 fc ff ff       	call   80053f <getuint>
			base = 16;
  80092d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800932:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800936:	89 74 24 10          	mov    %esi,0x10(%esp)
  80093a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80093d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800941:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800945:	89 04 24             	mov    %eax,(%esp)
  800948:	89 54 24 04          	mov    %edx,0x4(%esp)
  80094c:	89 fa                	mov    %edi,%edx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	e8 fa fa ff ff       	call   800450 <printnum>
			break;
  800956:	e9 88 fc ff ff       	jmp    8005e3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80095b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095f:	89 04 24             	mov    %eax,(%esp)
  800962:	ff 55 08             	call   *0x8(%ebp)
			break;
  800965:	e9 79 fc ff ff       	jmp    8005e3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80096a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80096e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800975:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800978:	89 f3                	mov    %esi,%ebx
  80097a:	eb 03                	jmp    80097f <vprintfmt+0x3c1>
  80097c:	83 eb 01             	sub    $0x1,%ebx
  80097f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800983:	75 f7                	jne    80097c <vprintfmt+0x3be>
  800985:	e9 59 fc ff ff       	jmp    8005e3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80098a:	83 c4 3c             	add    $0x3c,%esp
  80098d:	5b                   	pop    %ebx
  80098e:	5e                   	pop    %esi
  80098f:	5f                   	pop    %edi
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	83 ec 28             	sub    $0x28,%esp
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80099e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009a1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009a5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009af:	85 c0                	test   %eax,%eax
  8009b1:	74 30                	je     8009e3 <vsnprintf+0x51>
  8009b3:	85 d2                	test   %edx,%edx
  8009b5:	7e 2c                	jle    8009e3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cc:	c7 04 24 79 05 80 00 	movl   $0x800579,(%esp)
  8009d3:	e8 e6 fb ff ff       	call   8005be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e1:	eb 05                	jmp    8009e8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8009e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8009e8:	c9                   	leave  
  8009e9:	c3                   	ret    

008009ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009f0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	89 04 24             	mov    %eax,(%esp)
  800a0b:	e8 82 ff ff ff       	call   800992 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a10:	c9                   	leave  
  800a11:	c3                   	ret    
  800a12:	66 90                	xchg   %ax,%ax
  800a14:	66 90                	xchg   %ax,%ax
  800a16:	66 90                	xchg   %ax,%ax
  800a18:	66 90                	xchg   %ax,%ax
  800a1a:	66 90                	xchg   %ax,%ax
  800a1c:	66 90                	xchg   %ax,%ax
  800a1e:	66 90                	xchg   %ax,%ax

00800a20 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	57                   	push   %edi
  800a24:	56                   	push   %esi
  800a25:	53                   	push   %ebx
  800a26:	83 ec 1c             	sub    $0x1c,%esp
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a2c:	85 c0                	test   %eax,%eax
  800a2e:	74 18                	je     800a48 <readline+0x28>
		fprintf(1, "%s", prompt);
  800a30:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a34:	c7 44 24 04 49 2d 80 	movl   $0x802d49,0x4(%esp)
  800a3b:	00 
  800a3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a43:	e8 ba 11 00 00       	call   801c02 <fprintf>
#endif


	i = 0;
	echoing = iscons(0);
  800a48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a4f:	e8 e8 f7 ff ff       	call   80023c <iscons>
  800a54:	89 c7                	mov    %eax,%edi
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif


	i = 0;
  800a56:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  800a5b:	e8 a6 f7 ff ff       	call   800206 <getchar>
  800a60:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800a62:	85 c0                	test   %eax,%eax
  800a64:	79 25                	jns    800a8b <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);

			return NULL;
  800a66:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  800a6b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800a6e:	0f 84 88 00 00 00    	je     800afc <readline+0xdc>
				cprintf("read error: %e\n", c);
  800a74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a78:	c7 04 24 5f 2c 80 00 	movl   $0x802c5f,(%esp)
  800a7f:	e8 a6 f9 ff ff       	call   80042a <cprintf>

			return NULL;
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
  800a89:	eb 71                	jmp    800afc <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a8b:	83 f8 7f             	cmp    $0x7f,%eax
  800a8e:	74 05                	je     800a95 <readline+0x75>
  800a90:	83 f8 08             	cmp    $0x8,%eax
  800a93:	75 19                	jne    800aae <readline+0x8e>
  800a95:	85 f6                	test   %esi,%esi
  800a97:	7e 15                	jle    800aae <readline+0x8e>
			if (echoing)
  800a99:	85 ff                	test   %edi,%edi
  800a9b:	74 0c                	je     800aa9 <readline+0x89>
				cputchar('\b');
  800a9d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800aa4:	e8 3c f7 ff ff       	call   8001e5 <cputchar>
			i--;
  800aa9:	83 ee 01             	sub    $0x1,%esi
  800aac:	eb ad                	jmp    800a5b <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800aae:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800ab4:	7f 1c                	jg     800ad2 <readline+0xb2>
  800ab6:	83 fb 1f             	cmp    $0x1f,%ebx
  800ab9:	7e 17                	jle    800ad2 <readline+0xb2>
			if (echoing)
  800abb:	85 ff                	test   %edi,%edi
  800abd:	74 08                	je     800ac7 <readline+0xa7>
				cputchar(c);
  800abf:	89 1c 24             	mov    %ebx,(%esp)
  800ac2:	e8 1e f7 ff ff       	call   8001e5 <cputchar>
			buf[i++] = c;
  800ac7:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800acd:	8d 76 01             	lea    0x1(%esi),%esi
  800ad0:	eb 89                	jmp    800a5b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800ad2:	83 fb 0d             	cmp    $0xd,%ebx
  800ad5:	74 09                	je     800ae0 <readline+0xc0>
  800ad7:	83 fb 0a             	cmp    $0xa,%ebx
  800ada:	0f 85 7b ff ff ff    	jne    800a5b <readline+0x3b>
			if (echoing)
  800ae0:	85 ff                	test   %edi,%edi
  800ae2:	74 0c                	je     800af0 <readline+0xd0>
				cputchar('\n');
  800ae4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800aeb:	e8 f5 f6 ff ff       	call   8001e5 <cputchar>
			buf[i] = 0;
  800af0:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800af7:	b8 00 40 80 00       	mov    $0x804000,%eax
		}
	}
}
  800afc:	83 c4 1c             	add    $0x1c,%esp
  800aff:	5b                   	pop    %ebx
  800b00:	5e                   	pop    %esi
  800b01:	5f                   	pop    %edi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    
  800b04:	66 90                	xchg   %ax,%ax
  800b06:	66 90                	xchg   %ax,%ax
  800b08:	66 90                	xchg   %ax,%ax
  800b0a:	66 90                	xchg   %ax,%ax
  800b0c:	66 90                	xchg   %ax,%ax
  800b0e:	66 90                	xchg   %ax,%ax

00800b10 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b16:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1b:	eb 03                	jmp    800b20 <strlen+0x10>
		n++;
  800b1d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b20:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b24:	75 f7                	jne    800b1d <strlen+0xd>
		n++;
	return n;
}
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b31:	b8 00 00 00 00       	mov    $0x0,%eax
  800b36:	eb 03                	jmp    800b3b <strnlen+0x13>
		n++;
  800b38:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b3b:	39 d0                	cmp    %edx,%eax
  800b3d:	74 06                	je     800b45 <strnlen+0x1d>
  800b3f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b43:	75 f3                	jne    800b38 <strnlen+0x10>
		n++;
	return n;
}
  800b45:	5d                   	pop    %ebp
  800b46:	c3                   	ret    

00800b47 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b47:	55                   	push   %ebp
  800b48:	89 e5                	mov    %esp,%ebp
  800b4a:	53                   	push   %ebx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b51:	89 c2                	mov    %eax,%edx
  800b53:	83 c2 01             	add    $0x1,%edx
  800b56:	83 c1 01             	add    $0x1,%ecx
  800b59:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b5d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b60:	84 db                	test   %bl,%bl
  800b62:	75 ef                	jne    800b53 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b64:	5b                   	pop    %ebx
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	53                   	push   %ebx
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b71:	89 1c 24             	mov    %ebx,(%esp)
  800b74:	e8 97 ff ff ff       	call   800b10 <strlen>
	strcpy(dst + len, src);
  800b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b80:	01 d8                	add    %ebx,%eax
  800b82:	89 04 24             	mov    %eax,(%esp)
  800b85:	e8 bd ff ff ff       	call   800b47 <strcpy>
	return dst;
}
  800b8a:	89 d8                	mov    %ebx,%eax
  800b8c:	83 c4 08             	add    $0x8,%esp
  800b8f:	5b                   	pop    %ebx
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	56                   	push   %esi
  800b96:	53                   	push   %ebx
  800b97:	8b 75 08             	mov    0x8(%ebp),%esi
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b9d:	89 f3                	mov    %esi,%ebx
  800b9f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba2:	89 f2                	mov    %esi,%edx
  800ba4:	eb 0f                	jmp    800bb5 <strncpy+0x23>
		*dst++ = *src;
  800ba6:	83 c2 01             	add    $0x1,%edx
  800ba9:	0f b6 01             	movzbl (%ecx),%eax
  800bac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800baf:	80 39 01             	cmpb   $0x1,(%ecx)
  800bb2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb5:	39 da                	cmp    %ebx,%edx
  800bb7:	75 ed                	jne    800ba6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bb9:	89 f0                	mov    %esi,%eax
  800bbb:	5b                   	pop    %ebx
  800bbc:	5e                   	pop    %esi
  800bbd:	5d                   	pop    %ebp
  800bbe:	c3                   	ret    

00800bbf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	56                   	push   %esi
  800bc3:	53                   	push   %ebx
  800bc4:	8b 75 08             	mov    0x8(%ebp),%esi
  800bc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800bcd:	89 f0                	mov    %esi,%eax
  800bcf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bd3:	85 c9                	test   %ecx,%ecx
  800bd5:	75 0b                	jne    800be2 <strlcpy+0x23>
  800bd7:	eb 1d                	jmp    800bf6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800bd9:	83 c0 01             	add    $0x1,%eax
  800bdc:	83 c2 01             	add    $0x1,%edx
  800bdf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800be2:	39 d8                	cmp    %ebx,%eax
  800be4:	74 0b                	je     800bf1 <strlcpy+0x32>
  800be6:	0f b6 0a             	movzbl (%edx),%ecx
  800be9:	84 c9                	test   %cl,%cl
  800beb:	75 ec                	jne    800bd9 <strlcpy+0x1a>
  800bed:	89 c2                	mov    %eax,%edx
  800bef:	eb 02                	jmp    800bf3 <strlcpy+0x34>
  800bf1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800bf3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800bf6:	29 f0                	sub    %esi,%eax
}
  800bf8:	5b                   	pop    %ebx
  800bf9:	5e                   	pop    %esi
  800bfa:	5d                   	pop    %ebp
  800bfb:	c3                   	ret    

00800bfc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c05:	eb 06                	jmp    800c0d <strcmp+0x11>
		p++, q++;
  800c07:	83 c1 01             	add    $0x1,%ecx
  800c0a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c0d:	0f b6 01             	movzbl (%ecx),%eax
  800c10:	84 c0                	test   %al,%al
  800c12:	74 04                	je     800c18 <strcmp+0x1c>
  800c14:	3a 02                	cmp    (%edx),%al
  800c16:	74 ef                	je     800c07 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c18:	0f b6 c0             	movzbl %al,%eax
  800c1b:	0f b6 12             	movzbl (%edx),%edx
  800c1e:	29 d0                	sub    %edx,%eax
}
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	53                   	push   %ebx
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2c:	89 c3                	mov    %eax,%ebx
  800c2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c31:	eb 06                	jmp    800c39 <strncmp+0x17>
		n--, p++, q++;
  800c33:	83 c0 01             	add    $0x1,%eax
  800c36:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c39:	39 d8                	cmp    %ebx,%eax
  800c3b:	74 15                	je     800c52 <strncmp+0x30>
  800c3d:	0f b6 08             	movzbl (%eax),%ecx
  800c40:	84 c9                	test   %cl,%cl
  800c42:	74 04                	je     800c48 <strncmp+0x26>
  800c44:	3a 0a                	cmp    (%edx),%cl
  800c46:	74 eb                	je     800c33 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c48:	0f b6 00             	movzbl (%eax),%eax
  800c4b:	0f b6 12             	movzbl (%edx),%edx
  800c4e:	29 d0                	sub    %edx,%eax
  800c50:	eb 05                	jmp    800c57 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c52:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c57:	5b                   	pop    %ebx
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c64:	eb 07                	jmp    800c6d <strchr+0x13>
		if (*s == c)
  800c66:	38 ca                	cmp    %cl,%dl
  800c68:	74 0f                	je     800c79 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c6a:	83 c0 01             	add    $0x1,%eax
  800c6d:	0f b6 10             	movzbl (%eax),%edx
  800c70:	84 d2                	test   %dl,%dl
  800c72:	75 f2                	jne    800c66 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c85:	eb 07                	jmp    800c8e <strfind+0x13>
		if (*s == c)
  800c87:	38 ca                	cmp    %cl,%dl
  800c89:	74 0a                	je     800c95 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c8b:	83 c0 01             	add    $0x1,%eax
  800c8e:	0f b6 10             	movzbl (%eax),%edx
  800c91:	84 d2                	test   %dl,%dl
  800c93:	75 f2                	jne    800c87 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ca0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ca3:	85 c9                	test   %ecx,%ecx
  800ca5:	74 36                	je     800cdd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ca7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cad:	75 28                	jne    800cd7 <memset+0x40>
  800caf:	f6 c1 03             	test   $0x3,%cl
  800cb2:	75 23                	jne    800cd7 <memset+0x40>
		c &= 0xFF;
  800cb4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cb8:	89 d3                	mov    %edx,%ebx
  800cba:	c1 e3 08             	shl    $0x8,%ebx
  800cbd:	89 d6                	mov    %edx,%esi
  800cbf:	c1 e6 18             	shl    $0x18,%esi
  800cc2:	89 d0                	mov    %edx,%eax
  800cc4:	c1 e0 10             	shl    $0x10,%eax
  800cc7:	09 f0                	or     %esi,%eax
  800cc9:	09 c2                	or     %eax,%edx
  800ccb:	89 d0                	mov    %edx,%eax
  800ccd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ccf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800cd2:	fc                   	cld    
  800cd3:	f3 ab                	rep stos %eax,%es:(%edi)
  800cd5:	eb 06                	jmp    800cdd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cda:	fc                   	cld    
  800cdb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cdd:	89 f8                	mov    %edi,%eax
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cf2:	39 c6                	cmp    %eax,%esi
  800cf4:	73 35                	jae    800d2b <memmove+0x47>
  800cf6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cf9:	39 d0                	cmp    %edx,%eax
  800cfb:	73 2e                	jae    800d2b <memmove+0x47>
		s += n;
		d += n;
  800cfd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800d00:	89 d6                	mov    %edx,%esi
  800d02:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d0a:	75 13                	jne    800d1f <memmove+0x3b>
  800d0c:	f6 c1 03             	test   $0x3,%cl
  800d0f:	75 0e                	jne    800d1f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d11:	83 ef 04             	sub    $0x4,%edi
  800d14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800d1a:	fd                   	std    
  800d1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d1d:	eb 09                	jmp    800d28 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d1f:	83 ef 01             	sub    $0x1,%edi
  800d22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d25:	fd                   	std    
  800d26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d28:	fc                   	cld    
  800d29:	eb 1d                	jmp    800d48 <memmove+0x64>
  800d2b:	89 f2                	mov    %esi,%edx
  800d2d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d2f:	f6 c2 03             	test   $0x3,%dl
  800d32:	75 0f                	jne    800d43 <memmove+0x5f>
  800d34:	f6 c1 03             	test   $0x3,%cl
  800d37:	75 0a                	jne    800d43 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d39:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d3c:	89 c7                	mov    %eax,%edi
  800d3e:	fc                   	cld    
  800d3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d41:	eb 05                	jmp    800d48 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d43:	89 c7                	mov    %eax,%edi
  800d45:	fc                   	cld    
  800d46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d48:	5e                   	pop    %esi
  800d49:	5f                   	pop    %edi
  800d4a:	5d                   	pop    %ebp
  800d4b:	c3                   	ret    

00800d4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d52:	8b 45 10             	mov    0x10(%ebp),%eax
  800d55:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	89 04 24             	mov    %eax,(%esp)
  800d66:	e8 79 ff ff ff       	call   800ce4 <memmove>
}
  800d6b:	c9                   	leave  
  800d6c:	c3                   	ret    

00800d6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	56                   	push   %esi
  800d71:	53                   	push   %ebx
  800d72:	8b 55 08             	mov    0x8(%ebp),%edx
  800d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d78:	89 d6                	mov    %edx,%esi
  800d7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d7d:	eb 1a                	jmp    800d99 <memcmp+0x2c>
		if (*s1 != *s2)
  800d7f:	0f b6 02             	movzbl (%edx),%eax
  800d82:	0f b6 19             	movzbl (%ecx),%ebx
  800d85:	38 d8                	cmp    %bl,%al
  800d87:	74 0a                	je     800d93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800d89:	0f b6 c0             	movzbl %al,%eax
  800d8c:	0f b6 db             	movzbl %bl,%ebx
  800d8f:	29 d8                	sub    %ebx,%eax
  800d91:	eb 0f                	jmp    800da2 <memcmp+0x35>
		s1++, s2++;
  800d93:	83 c2 01             	add    $0x1,%edx
  800d96:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d99:	39 f2                	cmp    %esi,%edx
  800d9b:	75 e2                	jne    800d7f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da2:	5b                   	pop    %ebx
  800da3:	5e                   	pop    %esi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800daf:	89 c2                	mov    %eax,%edx
  800db1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800db4:	eb 07                	jmp    800dbd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800db6:	38 08                	cmp    %cl,(%eax)
  800db8:	74 07                	je     800dc1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dba:	83 c0 01             	add    $0x1,%eax
  800dbd:	39 d0                	cmp    %edx,%eax
  800dbf:	72 f5                	jb     800db6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dcf:	eb 03                	jmp    800dd4 <strtol+0x11>
		s++;
  800dd1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dd4:	0f b6 0a             	movzbl (%edx),%ecx
  800dd7:	80 f9 09             	cmp    $0x9,%cl
  800dda:	74 f5                	je     800dd1 <strtol+0xe>
  800ddc:	80 f9 20             	cmp    $0x20,%cl
  800ddf:	74 f0                	je     800dd1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800de1:	80 f9 2b             	cmp    $0x2b,%cl
  800de4:	75 0a                	jne    800df0 <strtol+0x2d>
		s++;
  800de6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800de9:	bf 00 00 00 00       	mov    $0x0,%edi
  800dee:	eb 11                	jmp    800e01 <strtol+0x3e>
  800df0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800df5:	80 f9 2d             	cmp    $0x2d,%cl
  800df8:	75 07                	jne    800e01 <strtol+0x3e>
		s++, neg = 1;
  800dfa:	8d 52 01             	lea    0x1(%edx),%edx
  800dfd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e01:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800e06:	75 15                	jne    800e1d <strtol+0x5a>
  800e08:	80 3a 30             	cmpb   $0x30,(%edx)
  800e0b:	75 10                	jne    800e1d <strtol+0x5a>
  800e0d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e11:	75 0a                	jne    800e1d <strtol+0x5a>
		s += 2, base = 16;
  800e13:	83 c2 02             	add    $0x2,%edx
  800e16:	b8 10 00 00 00       	mov    $0x10,%eax
  800e1b:	eb 10                	jmp    800e2d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800e1d:	85 c0                	test   %eax,%eax
  800e1f:	75 0c                	jne    800e2d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e21:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e23:	80 3a 30             	cmpb   $0x30,(%edx)
  800e26:	75 05                	jne    800e2d <strtol+0x6a>
		s++, base = 8;
  800e28:	83 c2 01             	add    $0x1,%edx
  800e2b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800e2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e32:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e35:	0f b6 0a             	movzbl (%edx),%ecx
  800e38:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800e3b:	89 f0                	mov    %esi,%eax
  800e3d:	3c 09                	cmp    $0x9,%al
  800e3f:	77 08                	ja     800e49 <strtol+0x86>
			dig = *s - '0';
  800e41:	0f be c9             	movsbl %cl,%ecx
  800e44:	83 e9 30             	sub    $0x30,%ecx
  800e47:	eb 20                	jmp    800e69 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800e49:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800e4c:	89 f0                	mov    %esi,%eax
  800e4e:	3c 19                	cmp    $0x19,%al
  800e50:	77 08                	ja     800e5a <strtol+0x97>
			dig = *s - 'a' + 10;
  800e52:	0f be c9             	movsbl %cl,%ecx
  800e55:	83 e9 57             	sub    $0x57,%ecx
  800e58:	eb 0f                	jmp    800e69 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800e5a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e5d:	89 f0                	mov    %esi,%eax
  800e5f:	3c 19                	cmp    $0x19,%al
  800e61:	77 16                	ja     800e79 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800e63:	0f be c9             	movsbl %cl,%ecx
  800e66:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e69:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800e6c:	7d 0f                	jge    800e7d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800e6e:	83 c2 01             	add    $0x1,%edx
  800e71:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800e75:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800e77:	eb bc                	jmp    800e35 <strtol+0x72>
  800e79:	89 d8                	mov    %ebx,%eax
  800e7b:	eb 02                	jmp    800e7f <strtol+0xbc>
  800e7d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800e7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e83:	74 05                	je     800e8a <strtol+0xc7>
		*endptr = (char *) s;
  800e85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e88:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800e8a:	f7 d8                	neg    %eax
  800e8c:	85 ff                	test   %edi,%edi
  800e8e:	0f 44 c3             	cmove  %ebx,%eax
}
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	57                   	push   %edi
  800e9a:	56                   	push   %esi
  800e9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	89 c3                	mov    %eax,%ebx
  800ea9:	89 c7                	mov    %eax,%edi
  800eab:	89 c6                	mov    %eax,%esi
  800ead:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800eaf:	5b                   	pop    %ebx
  800eb0:	5e                   	pop    %esi
  800eb1:	5f                   	pop    %edi
  800eb2:	5d                   	pop    %ebp
  800eb3:	c3                   	ret    

00800eb4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	57                   	push   %edi
  800eb8:	56                   	push   %esi
  800eb9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eba:	ba 00 00 00 00       	mov    $0x0,%edx
  800ebf:	b8 01 00 00 00       	mov    $0x1,%eax
  800ec4:	89 d1                	mov    %edx,%ecx
  800ec6:	89 d3                	mov    %edx,%ebx
  800ec8:	89 d7                	mov    %edx,%edi
  800eca:	89 d6                	mov    %edx,%esi
  800ecc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    

00800ed3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ed3:	55                   	push   %ebp
  800ed4:	89 e5                	mov    %esp,%ebp
  800ed6:	57                   	push   %edi
  800ed7:	56                   	push   %esi
  800ed8:	53                   	push   %ebx
  800ed9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	89 cb                	mov    %ecx,%ebx
  800eeb:	89 cf                	mov    %ecx,%edi
  800eed:	89 ce                	mov    %ecx,%esi
  800eef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	7e 28                	jle    800f1d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f00:	00 
  800f01:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  800f08:	00 
  800f09:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f10:	00 
  800f11:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  800f18:	e8 14 f4 ff ff       	call   800331 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f1d:	83 c4 2c             	add    $0x2c,%esp
  800f20:	5b                   	pop    %ebx
  800f21:	5e                   	pop    %esi
  800f22:	5f                   	pop    %edi
  800f23:	5d                   	pop    %ebp
  800f24:	c3                   	ret    

00800f25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	57                   	push   %edi
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f30:	b8 02 00 00 00       	mov    $0x2,%eax
  800f35:	89 d1                	mov    %edx,%ecx
  800f37:	89 d3                	mov    %edx,%ebx
  800f39:	89 d7                	mov    %edx,%edi
  800f3b:	89 d6                	mov    %edx,%esi
  800f3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f3f:	5b                   	pop    %ebx
  800f40:	5e                   	pop    %esi
  800f41:	5f                   	pop    %edi
  800f42:	5d                   	pop    %ebp
  800f43:	c3                   	ret    

00800f44 <sys_yield>:

void
sys_yield(void)
{
  800f44:	55                   	push   %ebp
  800f45:	89 e5                	mov    %esp,%ebp
  800f47:	57                   	push   %edi
  800f48:	56                   	push   %esi
  800f49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f54:	89 d1                	mov    %edx,%ecx
  800f56:	89 d3                	mov    %edx,%ebx
  800f58:	89 d7                	mov    %edx,%edi
  800f5a:	89 d6                	mov    %edx,%esi
  800f5c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800f6c:	be 00 00 00 00       	mov    $0x0,%esi
  800f71:	b8 04 00 00 00       	mov    $0x4,%eax
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7f:	89 f7                	mov    %esi,%edi
  800f81:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	7e 28                	jle    800faf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f92:	00 
  800f93:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  800f9a:	00 
  800f9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa2:	00 
  800fa3:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  800faa:	e8 82 f3 ff ff       	call   800331 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800faf:	83 c4 2c             	add    $0x2c,%esp
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	57                   	push   %edi
  800fbb:	56                   	push   %esi
  800fbc:	53                   	push   %ebx
  800fbd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc0:	b8 05 00 00 00       	mov    $0x5,%eax
  800fc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fce:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd1:	8b 75 18             	mov    0x18(%ebp),%esi
  800fd4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	7e 28                	jle    801002 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fda:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fde:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fe5:	00 
  800fe6:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  800fed:	00 
  800fee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff5:	00 
  800ff6:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  800ffd:	e8 2f f3 ff ff       	call   800331 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801002:	83 c4 2c             	add    $0x2c,%esp
  801005:	5b                   	pop    %ebx
  801006:	5e                   	pop    %esi
  801007:	5f                   	pop    %edi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	57                   	push   %edi
  80100e:	56                   	push   %esi
  80100f:	53                   	push   %ebx
  801010:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801013:	bb 00 00 00 00       	mov    $0x0,%ebx
  801018:	b8 06 00 00 00       	mov    $0x6,%eax
  80101d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 df                	mov    %ebx,%edi
  801025:	89 de                	mov    %ebx,%esi
  801027:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801029:	85 c0                	test   %eax,%eax
  80102b:	7e 28                	jle    801055 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80102d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801031:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801038:	00 
  801039:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  801040:	00 
  801041:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801048:	00 
  801049:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  801050:	e8 dc f2 ff ff       	call   800331 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801055:	83 c4 2c             	add    $0x2c,%esp
  801058:	5b                   	pop    %ebx
  801059:	5e                   	pop    %esi
  80105a:	5f                   	pop    %edi
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	53                   	push   %ebx
  801063:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801066:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106b:	b8 08 00 00 00       	mov    $0x8,%eax
  801070:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801073:	8b 55 08             	mov    0x8(%ebp),%edx
  801076:	89 df                	mov    %ebx,%edi
  801078:	89 de                	mov    %ebx,%esi
  80107a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80107c:	85 c0                	test   %eax,%eax
  80107e:	7e 28                	jle    8010a8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801080:	89 44 24 10          	mov    %eax,0x10(%esp)
  801084:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80108b:	00 
  80108c:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  801093:	00 
  801094:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80109b:	00 
  80109c:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  8010a3:	e8 89 f2 ff ff       	call   800331 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010a8:	83 c4 2c             	add    $0x2c,%esp
  8010ab:	5b                   	pop    %ebx
  8010ac:	5e                   	pop    %esi
  8010ad:	5f                   	pop    %edi
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	57                   	push   %edi
  8010b4:	56                   	push   %esi
  8010b5:	53                   	push   %ebx
  8010b6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010be:	b8 09 00 00 00       	mov    $0x9,%eax
  8010c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c9:	89 df                	mov    %ebx,%edi
  8010cb:	89 de                	mov    %ebx,%esi
  8010cd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010cf:	85 c0                	test   %eax,%eax
  8010d1:	7e 28                	jle    8010fb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010de:	00 
  8010df:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  8010e6:	00 
  8010e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ee:	00 
  8010ef:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  8010f6:	e8 36 f2 ff ff       	call   800331 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010fb:	83 c4 2c             	add    $0x2c,%esp
  8010fe:	5b                   	pop    %ebx
  8010ff:	5e                   	pop    %esi
  801100:	5f                   	pop    %edi
  801101:	5d                   	pop    %ebp
  801102:	c3                   	ret    

00801103 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	57                   	push   %edi
  801107:	56                   	push   %esi
  801108:	53                   	push   %ebx
  801109:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801111:	b8 0a 00 00 00       	mov    $0xa,%eax
  801116:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
  80111c:	89 df                	mov    %ebx,%edi
  80111e:	89 de                	mov    %ebx,%esi
  801120:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801122:	85 c0                	test   %eax,%eax
  801124:	7e 28                	jle    80114e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801126:	89 44 24 10          	mov    %eax,0x10(%esp)
  80112a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801131:	00 
  801132:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  801139:	00 
  80113a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801141:	00 
  801142:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  801149:	e8 e3 f1 ff ff       	call   800331 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80114e:	83 c4 2c             	add    $0x2c,%esp
  801151:	5b                   	pop    %ebx
  801152:	5e                   	pop    %esi
  801153:	5f                   	pop    %edi
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    

00801156 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	57                   	push   %edi
  80115a:	56                   	push   %esi
  80115b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80115c:	be 00 00 00 00       	mov    $0x0,%esi
  801161:	b8 0c 00 00 00       	mov    $0xc,%eax
  801166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801169:	8b 55 08             	mov    0x8(%ebp),%edx
  80116c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80116f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801172:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801174:	5b                   	pop    %ebx
  801175:	5e                   	pop    %esi
  801176:	5f                   	pop    %edi
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	57                   	push   %edi
  80117d:	56                   	push   %esi
  80117e:	53                   	push   %ebx
  80117f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801182:	b9 00 00 00 00       	mov    $0x0,%ecx
  801187:	b8 0d 00 00 00       	mov    $0xd,%eax
  80118c:	8b 55 08             	mov    0x8(%ebp),%edx
  80118f:	89 cb                	mov    %ecx,%ebx
  801191:	89 cf                	mov    %ecx,%edi
  801193:	89 ce                	mov    %ecx,%esi
  801195:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801197:	85 c0                	test   %eax,%eax
  801199:	7e 28                	jle    8011c3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80119b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80119f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8011a6:	00 
  8011a7:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  8011ae:	00 
  8011af:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011b6:	00 
  8011b7:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  8011be:	e8 6e f1 ff ff       	call   800331 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011c3:	83 c4 2c             	add    $0x2c,%esp
  8011c6:	5b                   	pop    %ebx
  8011c7:	5e                   	pop    %esi
  8011c8:	5f                   	pop    %edi
  8011c9:	5d                   	pop    %ebp
  8011ca:	c3                   	ret    

008011cb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	57                   	push   %edi
  8011cf:	56                   	push   %esi
  8011d0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011db:	89 d1                	mov    %edx,%ecx
  8011dd:	89 d3                	mov    %edx,%ebx
  8011df:	89 d7                	mov    %edx,%edi
  8011e1:	89 d6                	mov    %edx,%esi
  8011e3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011e5:	5b                   	pop    %ebx
  8011e6:	5e                   	pop    %esi
  8011e7:	5f                   	pop    %edi
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    

008011ea <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	57                   	push   %edi
  8011ee:	56                   	push   %esi
  8011ef:	53                   	push   %ebx
  8011f0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801200:	8b 55 08             	mov    0x8(%ebp),%edx
  801203:	89 df                	mov    %ebx,%edi
  801205:	89 de                	mov    %ebx,%esi
  801207:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801209:	85 c0                	test   %eax,%eax
  80120b:	7e 28                	jle    801235 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80120d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801211:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801218:	00 
  801219:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  801220:	00 
  801221:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801228:	00 
  801229:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  801230:	e8 fc f0 ff ff       	call   800331 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801235:	83 c4 2c             	add    $0x2c,%esp
  801238:	5b                   	pop    %ebx
  801239:	5e                   	pop    %esi
  80123a:	5f                   	pop    %edi
  80123b:	5d                   	pop    %ebp
  80123c:	c3                   	ret    

0080123d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80123d:	55                   	push   %ebp
  80123e:	89 e5                	mov    %esp,%ebp
  801240:	57                   	push   %edi
  801241:	56                   	push   %esi
  801242:	53                   	push   %ebx
  801243:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801246:	bb 00 00 00 00       	mov    $0x0,%ebx
  80124b:	b8 10 00 00 00       	mov    $0x10,%eax
  801250:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801253:	8b 55 08             	mov    0x8(%ebp),%edx
  801256:	89 df                	mov    %ebx,%edi
  801258:	89 de                	mov    %ebx,%esi
  80125a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80125c:	85 c0                	test   %eax,%eax
  80125e:	7e 28                	jle    801288 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801260:	89 44 24 10          	mov    %eax,0x10(%esp)
  801264:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80126b:	00 
  80126c:	c7 44 24 08 6f 2c 80 	movl   $0x802c6f,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  801283:	e8 a9 f0 ff ff       	call   800331 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801288:	83 c4 2c             	add    $0x2c,%esp
  80128b:	5b                   	pop    %ebx
  80128c:	5e                   	pop    %esi
  80128d:	5f                   	pop    %edi
  80128e:	5d                   	pop    %ebp
  80128f:	c3                   	ret    

00801290 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	05 00 00 00 30       	add    $0x30000000,%eax
  80129b:	c1 e8 0c             	shr    $0xc,%eax
}
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    

008012a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8012ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012b5:	5d                   	pop    %ebp
  8012b6:	c3                   	ret    

008012b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012c2:	89 c2                	mov    %eax,%edx
  8012c4:	c1 ea 16             	shr    $0x16,%edx
  8012c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012ce:	f6 c2 01             	test   $0x1,%dl
  8012d1:	74 11                	je     8012e4 <fd_alloc+0x2d>
  8012d3:	89 c2                	mov    %eax,%edx
  8012d5:	c1 ea 0c             	shr    $0xc,%edx
  8012d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012df:	f6 c2 01             	test   $0x1,%dl
  8012e2:	75 09                	jne    8012ed <fd_alloc+0x36>
			*fd_store = fd;
  8012e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012eb:	eb 17                	jmp    801304 <fd_alloc+0x4d>
  8012ed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012f7:	75 c9                	jne    8012c2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012f9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801304:	5d                   	pop    %ebp
  801305:	c3                   	ret    

00801306 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80130c:	83 f8 1f             	cmp    $0x1f,%eax
  80130f:	77 36                	ja     801347 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801311:	c1 e0 0c             	shl    $0xc,%eax
  801314:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801319:	89 c2                	mov    %eax,%edx
  80131b:	c1 ea 16             	shr    $0x16,%edx
  80131e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801325:	f6 c2 01             	test   $0x1,%dl
  801328:	74 24                	je     80134e <fd_lookup+0x48>
  80132a:	89 c2                	mov    %eax,%edx
  80132c:	c1 ea 0c             	shr    $0xc,%edx
  80132f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801336:	f6 c2 01             	test   $0x1,%dl
  801339:	74 1a                	je     801355 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80133b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133e:	89 02                	mov    %eax,(%edx)
	return 0;
  801340:	b8 00 00 00 00       	mov    $0x0,%eax
  801345:	eb 13                	jmp    80135a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801347:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80134c:	eb 0c                	jmp    80135a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80134e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801353:	eb 05                	jmp    80135a <fd_lookup+0x54>
  801355:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80135a:	5d                   	pop    %ebp
  80135b:	c3                   	ret    

0080135c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 18             	sub    $0x18,%esp
  801362:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801365:	ba 00 00 00 00       	mov    $0x0,%edx
  80136a:	eb 13                	jmp    80137f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80136c:	39 08                	cmp    %ecx,(%eax)
  80136e:	75 0c                	jne    80137c <dev_lookup+0x20>
			*dev = devtab[i];
  801370:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801373:	89 01                	mov    %eax,(%ecx)
			return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
  80137a:	eb 38                	jmp    8013b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80137c:	83 c2 01             	add    $0x1,%edx
  80137f:	8b 04 95 1c 2d 80 00 	mov    0x802d1c(,%edx,4),%eax
  801386:	85 c0                	test   %eax,%eax
  801388:	75 e2                	jne    80136c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80138a:	a1 08 44 80 00       	mov    0x804408,%eax
  80138f:	8b 40 48             	mov    0x48(%eax),%eax
  801392:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801396:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139a:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  8013a1:	e8 84 f0 ff ff       	call   80042a <cprintf>
	*dev = 0;
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	56                   	push   %esi
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 20             	sub    $0x20,%esp
  8013be:	8b 75 08             	mov    0x8(%ebp),%esi
  8013c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d4:	89 04 24             	mov    %eax,(%esp)
  8013d7:	e8 2a ff ff ff       	call   801306 <fd_lookup>
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	78 05                	js     8013e5 <fd_close+0x2f>
	    || fd != fd2)
  8013e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8013e3:	74 0c                	je     8013f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8013e5:	84 db                	test   %bl,%bl
  8013e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ec:	0f 44 c2             	cmove  %edx,%eax
  8013ef:	eb 3f                	jmp    801430 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f8:	8b 06                	mov    (%esi),%eax
  8013fa:	89 04 24             	mov    %eax,(%esp)
  8013fd:	e8 5a ff ff ff       	call   80135c <dev_lookup>
  801402:	89 c3                	mov    %eax,%ebx
  801404:	85 c0                	test   %eax,%eax
  801406:	78 16                	js     80141e <fd_close+0x68>
		if (dev->dev_close)
  801408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80140e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801413:	85 c0                	test   %eax,%eax
  801415:	74 07                	je     80141e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801417:	89 34 24             	mov    %esi,(%esp)
  80141a:	ff d0                	call   *%eax
  80141c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80141e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801429:	e8 dc fb ff ff       	call   80100a <sys_page_unmap>
	return r;
  80142e:	89 d8                	mov    %ebx,%eax
}
  801430:	83 c4 20             	add    $0x20,%esp
  801433:	5b                   	pop    %ebx
  801434:	5e                   	pop    %esi
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    

00801437 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801440:	89 44 24 04          	mov    %eax,0x4(%esp)
  801444:	8b 45 08             	mov    0x8(%ebp),%eax
  801447:	89 04 24             	mov    %eax,(%esp)
  80144a:	e8 b7 fe ff ff       	call   801306 <fd_lookup>
  80144f:	89 c2                	mov    %eax,%edx
  801451:	85 d2                	test   %edx,%edx
  801453:	78 13                	js     801468 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801455:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80145c:	00 
  80145d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801460:	89 04 24             	mov    %eax,(%esp)
  801463:	e8 4e ff ff ff       	call   8013b6 <fd_close>
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <close_all>:

void
close_all(void)
{
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
  80146d:	53                   	push   %ebx
  80146e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801471:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801476:	89 1c 24             	mov    %ebx,(%esp)
  801479:	e8 b9 ff ff ff       	call   801437 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80147e:	83 c3 01             	add    $0x1,%ebx
  801481:	83 fb 20             	cmp    $0x20,%ebx
  801484:	75 f0                	jne    801476 <close_all+0xc>
		close(i);
}
  801486:	83 c4 14             	add    $0x14,%esp
  801489:	5b                   	pop    %ebx
  80148a:	5d                   	pop    %ebp
  80148b:	c3                   	ret    

0080148c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	57                   	push   %edi
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801495:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801498:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149c:	8b 45 08             	mov    0x8(%ebp),%eax
  80149f:	89 04 24             	mov    %eax,(%esp)
  8014a2:	e8 5f fe ff ff       	call   801306 <fd_lookup>
  8014a7:	89 c2                	mov    %eax,%edx
  8014a9:	85 d2                	test   %edx,%edx
  8014ab:	0f 88 e1 00 00 00    	js     801592 <dup+0x106>
		return r;
	close(newfdnum);
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	89 04 24             	mov    %eax,(%esp)
  8014b7:	e8 7b ff ff ff       	call   801437 <close>

	newfd = INDEX2FD(newfdnum);
  8014bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014bf:	c1 e3 0c             	shl    $0xc,%ebx
  8014c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8014c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014cb:	89 04 24             	mov    %eax,(%esp)
  8014ce:	e8 cd fd ff ff       	call   8012a0 <fd2data>
  8014d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8014d5:	89 1c 24             	mov    %ebx,(%esp)
  8014d8:	e8 c3 fd ff ff       	call   8012a0 <fd2data>
  8014dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014df:	89 f0                	mov    %esi,%eax
  8014e1:	c1 e8 16             	shr    $0x16,%eax
  8014e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014eb:	a8 01                	test   $0x1,%al
  8014ed:	74 43                	je     801532 <dup+0xa6>
  8014ef:	89 f0                	mov    %esi,%eax
  8014f1:	c1 e8 0c             	shr    $0xc,%eax
  8014f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014fb:	f6 c2 01             	test   $0x1,%dl
  8014fe:	74 32                	je     801532 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801500:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801507:	25 07 0e 00 00       	and    $0xe07,%eax
  80150c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801510:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801514:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80151b:	00 
  80151c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801520:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801527:	e8 8b fa ff ff       	call   800fb7 <sys_page_map>
  80152c:	89 c6                	mov    %eax,%esi
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 3e                	js     801570 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801535:	89 c2                	mov    %eax,%edx
  801537:	c1 ea 0c             	shr    $0xc,%edx
  80153a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801541:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801547:	89 54 24 10          	mov    %edx,0x10(%esp)
  80154b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80154f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801556:	00 
  801557:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801562:	e8 50 fa ff ff       	call   800fb7 <sys_page_map>
  801567:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80156c:	85 f6                	test   %esi,%esi
  80156e:	79 22                	jns    801592 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801570:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801574:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80157b:	e8 8a fa ff ff       	call   80100a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801580:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80158b:	e8 7a fa ff ff       	call   80100a <sys_page_unmap>
	return r;
  801590:	89 f0                	mov    %esi,%eax
}
  801592:	83 c4 3c             	add    $0x3c,%esp
  801595:	5b                   	pop    %ebx
  801596:	5e                   	pop    %esi
  801597:	5f                   	pop    %edi
  801598:	5d                   	pop    %ebp
  801599:	c3                   	ret    

0080159a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	53                   	push   %ebx
  80159e:	83 ec 24             	sub    $0x24,%esp
  8015a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ab:	89 1c 24             	mov    %ebx,(%esp)
  8015ae:	e8 53 fd ff ff       	call   801306 <fd_lookup>
  8015b3:	89 c2                	mov    %eax,%edx
  8015b5:	85 d2                	test   %edx,%edx
  8015b7:	78 6d                	js     801626 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c3:	8b 00                	mov    (%eax),%eax
  8015c5:	89 04 24             	mov    %eax,(%esp)
  8015c8:	e8 8f fd ff ff       	call   80135c <dev_lookup>
  8015cd:	85 c0                	test   %eax,%eax
  8015cf:	78 55                	js     801626 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d4:	8b 50 08             	mov    0x8(%eax),%edx
  8015d7:	83 e2 03             	and    $0x3,%edx
  8015da:	83 fa 01             	cmp    $0x1,%edx
  8015dd:	75 23                	jne    801602 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015df:	a1 08 44 80 00       	mov    0x804408,%eax
  8015e4:	8b 40 48             	mov    0x48(%eax),%eax
  8015e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ef:	c7 04 24 e0 2c 80 00 	movl   $0x802ce0,(%esp)
  8015f6:	e8 2f ee ff ff       	call   80042a <cprintf>
		return -E_INVAL;
  8015fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801600:	eb 24                	jmp    801626 <read+0x8c>
	}
	if (!dev->dev_read)
  801602:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801605:	8b 52 08             	mov    0x8(%edx),%edx
  801608:	85 d2                	test   %edx,%edx
  80160a:	74 15                	je     801621 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80160c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80160f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801613:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801616:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80161a:	89 04 24             	mov    %eax,(%esp)
  80161d:	ff d2                	call   *%edx
  80161f:	eb 05                	jmp    801626 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801621:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801626:	83 c4 24             	add    $0x24,%esp
  801629:	5b                   	pop    %ebx
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	57                   	push   %edi
  801630:	56                   	push   %esi
  801631:	53                   	push   %ebx
  801632:	83 ec 1c             	sub    $0x1c,%esp
  801635:	8b 7d 08             	mov    0x8(%ebp),%edi
  801638:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80163b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801640:	eb 23                	jmp    801665 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801642:	89 f0                	mov    %esi,%eax
  801644:	29 d8                	sub    %ebx,%eax
  801646:	89 44 24 08          	mov    %eax,0x8(%esp)
  80164a:	89 d8                	mov    %ebx,%eax
  80164c:	03 45 0c             	add    0xc(%ebp),%eax
  80164f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801653:	89 3c 24             	mov    %edi,(%esp)
  801656:	e8 3f ff ff ff       	call   80159a <read>
		if (m < 0)
  80165b:	85 c0                	test   %eax,%eax
  80165d:	78 10                	js     80166f <readn+0x43>
			return m;
		if (m == 0)
  80165f:	85 c0                	test   %eax,%eax
  801661:	74 0a                	je     80166d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801663:	01 c3                	add    %eax,%ebx
  801665:	39 f3                	cmp    %esi,%ebx
  801667:	72 d9                	jb     801642 <readn+0x16>
  801669:	89 d8                	mov    %ebx,%eax
  80166b:	eb 02                	jmp    80166f <readn+0x43>
  80166d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80166f:	83 c4 1c             	add    $0x1c,%esp
  801672:	5b                   	pop    %ebx
  801673:	5e                   	pop    %esi
  801674:	5f                   	pop    %edi
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	53                   	push   %ebx
  80167b:	83 ec 24             	sub    $0x24,%esp
  80167e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801681:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801684:	89 44 24 04          	mov    %eax,0x4(%esp)
  801688:	89 1c 24             	mov    %ebx,(%esp)
  80168b:	e8 76 fc ff ff       	call   801306 <fd_lookup>
  801690:	89 c2                	mov    %eax,%edx
  801692:	85 d2                	test   %edx,%edx
  801694:	78 68                	js     8016fe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801696:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801699:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a0:	8b 00                	mov    (%eax),%eax
  8016a2:	89 04 24             	mov    %eax,(%esp)
  8016a5:	e8 b2 fc ff ff       	call   80135c <dev_lookup>
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 50                	js     8016fe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016b5:	75 23                	jne    8016da <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016b7:	a1 08 44 80 00       	mov    0x804408,%eax
  8016bc:	8b 40 48             	mov    0x48(%eax),%eax
  8016bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c7:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  8016ce:	e8 57 ed ff ff       	call   80042a <cprintf>
		return -E_INVAL;
  8016d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016d8:	eb 24                	jmp    8016fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8016e0:	85 d2                	test   %edx,%edx
  8016e2:	74 15                	je     8016f9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016f2:	89 04 24             	mov    %eax,(%esp)
  8016f5:	ff d2                	call   *%edx
  8016f7:	eb 05                	jmp    8016fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8016f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8016fe:	83 c4 24             	add    $0x24,%esp
  801701:	5b                   	pop    %ebx
  801702:	5d                   	pop    %ebp
  801703:	c3                   	ret    

00801704 <seek>:

int
seek(int fdnum, off_t offset)
{
  801704:	55                   	push   %ebp
  801705:	89 e5                	mov    %esp,%ebp
  801707:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80170a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80170d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	89 04 24             	mov    %eax,(%esp)
  801717:	e8 ea fb ff ff       	call   801306 <fd_lookup>
  80171c:	85 c0                	test   %eax,%eax
  80171e:	78 0e                	js     80172e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801720:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801723:	8b 55 0c             	mov    0xc(%ebp),%edx
  801726:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	53                   	push   %ebx
  801734:	83 ec 24             	sub    $0x24,%esp
  801737:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80173a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801741:	89 1c 24             	mov    %ebx,(%esp)
  801744:	e8 bd fb ff ff       	call   801306 <fd_lookup>
  801749:	89 c2                	mov    %eax,%edx
  80174b:	85 d2                	test   %edx,%edx
  80174d:	78 61                	js     8017b0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801752:	89 44 24 04          	mov    %eax,0x4(%esp)
  801756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801759:	8b 00                	mov    (%eax),%eax
  80175b:	89 04 24             	mov    %eax,(%esp)
  80175e:	e8 f9 fb ff ff       	call   80135c <dev_lookup>
  801763:	85 c0                	test   %eax,%eax
  801765:	78 49                	js     8017b0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80176e:	75 23                	jne    801793 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801770:	a1 08 44 80 00       	mov    0x804408,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801775:	8b 40 48             	mov    0x48(%eax),%eax
  801778:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80177c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801780:	c7 04 24 bc 2c 80 00 	movl   $0x802cbc,(%esp)
  801787:	e8 9e ec ff ff       	call   80042a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80178c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801791:	eb 1d                	jmp    8017b0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801796:	8b 52 18             	mov    0x18(%edx),%edx
  801799:	85 d2                	test   %edx,%edx
  80179b:	74 0e                	je     8017ab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80179d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017a4:	89 04 24             	mov    %eax,(%esp)
  8017a7:	ff d2                	call   *%edx
  8017a9:	eb 05                	jmp    8017b0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8017ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8017b0:	83 c4 24             	add    $0x24,%esp
  8017b3:	5b                   	pop    %ebx
  8017b4:	5d                   	pop    %ebp
  8017b5:	c3                   	ret    

008017b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	53                   	push   %ebx
  8017ba:	83 ec 24             	sub    $0x24,%esp
  8017bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ca:	89 04 24             	mov    %eax,(%esp)
  8017cd:	e8 34 fb ff ff       	call   801306 <fd_lookup>
  8017d2:	89 c2                	mov    %eax,%edx
  8017d4:	85 d2                	test   %edx,%edx
  8017d6:	78 52                	js     80182a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e2:	8b 00                	mov    (%eax),%eax
  8017e4:	89 04 24             	mov    %eax,(%esp)
  8017e7:	e8 70 fb ff ff       	call   80135c <dev_lookup>
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	78 3a                	js     80182a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017f7:	74 2c                	je     801825 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017f9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017fc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801803:	00 00 00 
	stat->st_isdir = 0;
  801806:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80180d:	00 00 00 
	stat->st_dev = dev;
  801810:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801816:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80181a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80181d:	89 14 24             	mov    %edx,(%esp)
  801820:	ff 50 14             	call   *0x14(%eax)
  801823:	eb 05                	jmp    80182a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801825:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80182a:	83 c4 24             	add    $0x24,%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    

00801830 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	56                   	push   %esi
  801834:	53                   	push   %ebx
  801835:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801838:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80183f:	00 
  801840:	8b 45 08             	mov    0x8(%ebp),%eax
  801843:	89 04 24             	mov    %eax,(%esp)
  801846:	e8 28 02 00 00       	call   801a73 <open>
  80184b:	89 c3                	mov    %eax,%ebx
  80184d:	85 db                	test   %ebx,%ebx
  80184f:	78 1b                	js     80186c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801851:	8b 45 0c             	mov    0xc(%ebp),%eax
  801854:	89 44 24 04          	mov    %eax,0x4(%esp)
  801858:	89 1c 24             	mov    %ebx,(%esp)
  80185b:	e8 56 ff ff ff       	call   8017b6 <fstat>
  801860:	89 c6                	mov    %eax,%esi
	close(fd);
  801862:	89 1c 24             	mov    %ebx,(%esp)
  801865:	e8 cd fb ff ff       	call   801437 <close>
	return r;
  80186a:	89 f0                	mov    %esi,%eax
}
  80186c:	83 c4 10             	add    $0x10,%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    

00801873 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	56                   	push   %esi
  801877:	53                   	push   %ebx
  801878:	83 ec 10             	sub    $0x10,%esp
  80187b:	89 c6                	mov    %eax,%esi
  80187d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80187f:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801886:	75 11                	jne    801899 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801888:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80188f:	e8 0e 0d 00 00       	call   8025a2 <ipc_find_env>
  801894:	a3 00 44 80 00       	mov    %eax,0x804400
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801899:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8018a0:	00 
  8018a1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8018a8:	00 
  8018a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018ad:	a1 00 44 80 00       	mov    0x804400,%eax
  8018b2:	89 04 24             	mov    %eax,(%esp)
  8018b5:	e8 8a 0c 00 00       	call   802544 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018c1:	00 
  8018c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018cd:	e8 08 0c 00 00       	call   8024da <ipc_recv>
}
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	5b                   	pop    %ebx
  8018d6:	5e                   	pop    %esi
  8018d7:	5d                   	pop    %ebp
  8018d8:	c3                   	ret    

008018d9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ed:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8018fc:	e8 72 ff ff ff       	call   801873 <fsipc>
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8b 40 0c             	mov    0xc(%eax),%eax
  80190f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801914:	ba 00 00 00 00       	mov    $0x0,%edx
  801919:	b8 06 00 00 00       	mov    $0x6,%eax
  80191e:	e8 50 ff ff ff       	call   801873 <fsipc>
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	53                   	push   %ebx
  801929:	83 ec 14             	sub    $0x14,%esp
  80192c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	8b 40 0c             	mov    0xc(%eax),%eax
  801935:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80193a:	ba 00 00 00 00       	mov    $0x0,%edx
  80193f:	b8 05 00 00 00       	mov    $0x5,%eax
  801944:	e8 2a ff ff ff       	call   801873 <fsipc>
  801949:	89 c2                	mov    %eax,%edx
  80194b:	85 d2                	test   %edx,%edx
  80194d:	78 2b                	js     80197a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80194f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801956:	00 
  801957:	89 1c 24             	mov    %ebx,(%esp)
  80195a:	e8 e8 f1 ff ff       	call   800b47 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80195f:	a1 80 50 80 00       	mov    0x805080,%eax
  801964:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80196a:	a1 84 50 80 00       	mov    0x805084,%eax
  80196f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801975:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80197a:	83 c4 14             	add    $0x14,%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    

00801980 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 18             	sub    $0x18,%esp
  801986:	8b 45 10             	mov    0x10(%ebp),%eax
  801989:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80198e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801993:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801996:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80199b:	8b 55 08             	mov    0x8(%ebp),%edx
  80199e:	8b 52 0c             	mov    0xc(%edx),%edx
  8019a1:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  8019a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b2:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8019b9:	e8 26 f3 ff ff       	call   800ce4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  8019be:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c3:	b8 04 00 00 00       	mov    $0x4,%eax
  8019c8:	e8 a6 fe ff ff       	call   801873 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	56                   	push   %esi
  8019d3:	53                   	push   %ebx
  8019d4:	83 ec 10             	sub    $0x10,%esp
  8019d7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019e5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f0:	b8 03 00 00 00       	mov    $0x3,%eax
  8019f5:	e8 79 fe ff ff       	call   801873 <fsipc>
  8019fa:	89 c3                	mov    %eax,%ebx
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 6a                	js     801a6a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801a00:	39 c6                	cmp    %eax,%esi
  801a02:	73 24                	jae    801a28 <devfile_read+0x59>
  801a04:	c7 44 24 0c 30 2d 80 	movl   $0x802d30,0xc(%esp)
  801a0b:	00 
  801a0c:	c7 44 24 08 37 2d 80 	movl   $0x802d37,0x8(%esp)
  801a13:	00 
  801a14:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801a1b:	00 
  801a1c:	c7 04 24 4c 2d 80 00 	movl   $0x802d4c,(%esp)
  801a23:	e8 09 e9 ff ff       	call   800331 <_panic>
	assert(r <= PGSIZE);
  801a28:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a2d:	7e 24                	jle    801a53 <devfile_read+0x84>
  801a2f:	c7 44 24 0c 57 2d 80 	movl   $0x802d57,0xc(%esp)
  801a36:	00 
  801a37:	c7 44 24 08 37 2d 80 	movl   $0x802d37,0x8(%esp)
  801a3e:	00 
  801a3f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801a46:	00 
  801a47:	c7 04 24 4c 2d 80 00 	movl   $0x802d4c,(%esp)
  801a4e:	e8 de e8 ff ff       	call   800331 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801a53:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a57:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801a5e:	00 
  801a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a62:	89 04 24             	mov    %eax,(%esp)
  801a65:	e8 7a f2 ff ff       	call   800ce4 <memmove>
	return r;
}
  801a6a:	89 d8                	mov    %ebx,%eax
  801a6c:	83 c4 10             	add    $0x10,%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	5d                   	pop    %ebp
  801a72:	c3                   	ret    

00801a73 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	53                   	push   %ebx
  801a77:	83 ec 24             	sub    $0x24,%esp
  801a7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801a7d:	89 1c 24             	mov    %ebx,(%esp)
  801a80:	e8 8b f0 ff ff       	call   800b10 <strlen>
  801a85:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a8a:	7f 60                	jg     801aec <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801a8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8f:	89 04 24             	mov    %eax,(%esp)
  801a92:	e8 20 f8 ff ff       	call   8012b7 <fd_alloc>
  801a97:	89 c2                	mov    %eax,%edx
  801a99:	85 d2                	test   %edx,%edx
  801a9b:	78 54                	js     801af1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801a9d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aa1:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801aa8:	e8 9a f0 ff ff       	call   800b47 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801aad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab0:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab8:	b8 01 00 00 00       	mov    $0x1,%eax
  801abd:	e8 b1 fd ff ff       	call   801873 <fsipc>
  801ac2:	89 c3                	mov    %eax,%ebx
  801ac4:	85 c0                	test   %eax,%eax
  801ac6:	79 17                	jns    801adf <open+0x6c>
		fd_close(fd, 0);
  801ac8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801acf:	00 
  801ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad3:	89 04 24             	mov    %eax,(%esp)
  801ad6:	e8 db f8 ff ff       	call   8013b6 <fd_close>
		return r;
  801adb:	89 d8                	mov    %ebx,%eax
  801add:	eb 12                	jmp    801af1 <open+0x7e>
	}

	return fd2num(fd);
  801adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae2:	89 04 24             	mov    %eax,(%esp)
  801ae5:	e8 a6 f7 ff ff       	call   801290 <fd2num>
  801aea:	eb 05                	jmp    801af1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801aec:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801af1:	83 c4 24             	add    $0x24,%esp
  801af4:	5b                   	pop    %ebx
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    

00801af7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801afd:	ba 00 00 00 00       	mov    $0x0,%edx
  801b02:	b8 08 00 00 00       	mov    $0x8,%eax
  801b07:	e8 67 fd ff ff       	call   801873 <fsipc>
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	53                   	push   %ebx
  801b12:	83 ec 14             	sub    $0x14,%esp
  801b15:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b17:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b1b:	7e 31                	jle    801b4e <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b1d:	8b 40 04             	mov    0x4(%eax),%eax
  801b20:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b24:	8d 43 10             	lea    0x10(%ebx),%eax
  801b27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2b:	8b 03                	mov    (%ebx),%eax
  801b2d:	89 04 24             	mov    %eax,(%esp)
  801b30:	e8 42 fb ff ff       	call   801677 <write>
		if (result > 0)
  801b35:	85 c0                	test   %eax,%eax
  801b37:	7e 03                	jle    801b3c <writebuf+0x2e>
			b->result += result;
  801b39:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b3c:	39 43 04             	cmp    %eax,0x4(%ebx)
  801b3f:	74 0d                	je     801b4e <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801b41:	85 c0                	test   %eax,%eax
  801b43:	ba 00 00 00 00       	mov    $0x0,%edx
  801b48:	0f 4f c2             	cmovg  %edx,%eax
  801b4b:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b4e:	83 c4 14             	add    $0x14,%esp
  801b51:	5b                   	pop    %ebx
  801b52:	5d                   	pop    %ebp
  801b53:	c3                   	ret    

00801b54 <putch>:

static void
putch(int ch, void *thunk)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	53                   	push   %ebx
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801b5e:	8b 53 04             	mov    0x4(%ebx),%edx
  801b61:	8d 42 01             	lea    0x1(%edx),%eax
  801b64:	89 43 04             	mov    %eax,0x4(%ebx)
  801b67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b6a:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801b6e:	3d 00 01 00 00       	cmp    $0x100,%eax
  801b73:	75 0e                	jne    801b83 <putch+0x2f>
		writebuf(b);
  801b75:	89 d8                	mov    %ebx,%eax
  801b77:	e8 92 ff ff ff       	call   801b0e <writebuf>
		b->idx = 0;
  801b7c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801b83:	83 c4 04             	add    $0x4,%esp
  801b86:	5b                   	pop    %ebx
  801b87:	5d                   	pop    %ebp
  801b88:	c3                   	ret    

00801b89 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b9b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801ba2:	00 00 00 
	b.result = 0;
  801ba5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bac:	00 00 00 
	b.error = 1;
  801baf:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801bb6:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bbc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd1:	c7 04 24 54 1b 80 00 	movl   $0x801b54,(%esp)
  801bd8:	e8 e1 e9 ff ff       	call   8005be <vprintfmt>
	if (b.idx > 0)
  801bdd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801be4:	7e 0b                	jle    801bf1 <vfprintf+0x68>
		writebuf(&b);
  801be6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bec:	e8 1d ff ff ff       	call   801b0e <writebuf>

	return (b.result ? b.result : b.error);
  801bf1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
  801c05:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c08:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801c0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	89 04 24             	mov    %eax,(%esp)
  801c1c:	e8 68 ff ff ff       	call   801b89 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <printf>:

int
printf(const char *fmt, ...)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c29:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801c2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c3e:	e8 46 ff ff ff       	call   801b89 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    
  801c45:	66 90                	xchg   %ax,%ax
  801c47:	66 90                	xchg   %ax,%ax
  801c49:	66 90                	xchg   %ax,%ax
  801c4b:	66 90                	xchg   %ax,%ax
  801c4d:	66 90                	xchg   %ax,%ax
  801c4f:	90                   	nop

00801c50 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c56:	c7 44 24 04 63 2d 80 	movl   $0x802d63,0x4(%esp)
  801c5d:	00 
  801c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c61:	89 04 24             	mov    %eax,(%esp)
  801c64:	e8 de ee ff ff       	call   800b47 <strcpy>
	return 0;
}
  801c69:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	53                   	push   %ebx
  801c74:	83 ec 14             	sub    $0x14,%esp
  801c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c7a:	89 1c 24             	mov    %ebx,(%esp)
  801c7d:	e8 58 09 00 00       	call   8025da <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801c82:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801c87:	83 f8 01             	cmp    $0x1,%eax
  801c8a:	75 0d                	jne    801c99 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801c8c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801c8f:	89 04 24             	mov    %eax,(%esp)
  801c92:	e8 29 03 00 00       	call   801fc0 <nsipc_close>
  801c97:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801c99:	89 d0                	mov    %edx,%eax
  801c9b:	83 c4 14             	add    $0x14,%esp
  801c9e:	5b                   	pop    %ebx
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    

00801ca1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ca7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cae:	00 
  801caf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc3:	89 04 24             	mov    %eax,(%esp)
  801cc6:	e8 f0 03 00 00       	call   8020bb <nsipc_send>
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cda:	00 
  801cdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cde:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	8b 40 0c             	mov    0xc(%eax),%eax
  801cef:	89 04 24             	mov    %eax,(%esp)
  801cf2:	e8 44 03 00 00       	call   80203b <nsipc_recv>
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801cff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d02:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d06:	89 04 24             	mov    %eax,(%esp)
  801d09:	e8 f8 f5 ff ff       	call   801306 <fd_lookup>
  801d0e:	85 c0                	test   %eax,%eax
  801d10:	78 17                	js     801d29 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d15:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d1b:	39 08                	cmp    %ecx,(%eax)
  801d1d:	75 05                	jne    801d24 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d22:	eb 05                	jmp    801d29 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d24:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	56                   	push   %esi
  801d2f:	53                   	push   %ebx
  801d30:	83 ec 20             	sub    $0x20,%esp
  801d33:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d38:	89 04 24             	mov    %eax,(%esp)
  801d3b:	e8 77 f5 ff ff       	call   8012b7 <fd_alloc>
  801d40:	89 c3                	mov    %eax,%ebx
  801d42:	85 c0                	test   %eax,%eax
  801d44:	78 21                	js     801d67 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d4d:	00 
  801d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d5c:	e8 02 f2 ff ff       	call   800f63 <sys_page_alloc>
  801d61:	89 c3                	mov    %eax,%ebx
  801d63:	85 c0                	test   %eax,%eax
  801d65:	79 0c                	jns    801d73 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801d67:	89 34 24             	mov    %esi,(%esp)
  801d6a:	e8 51 02 00 00       	call   801fc0 <nsipc_close>
		return r;
  801d6f:	89 d8                	mov    %ebx,%eax
  801d71:	eb 20                	jmp    801d93 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d73:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d81:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801d88:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801d8b:	89 14 24             	mov    %edx,(%esp)
  801d8e:	e8 fd f4 ff ff       	call   801290 <fd2num>
}
  801d93:	83 c4 20             	add    $0x20,%esp
  801d96:	5b                   	pop    %ebx
  801d97:	5e                   	pop    %esi
  801d98:	5d                   	pop    %ebp
  801d99:	c3                   	ret    

00801d9a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	e8 51 ff ff ff       	call   801cf9 <fd2sockid>
		return r;
  801da8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801daa:	85 c0                	test   %eax,%eax
  801dac:	78 23                	js     801dd1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dae:	8b 55 10             	mov    0x10(%ebp),%edx
  801db1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801db5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dbc:	89 04 24             	mov    %eax,(%esp)
  801dbf:	e8 45 01 00 00       	call   801f09 <nsipc_accept>
		return r;
  801dc4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	78 07                	js     801dd1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801dca:	e8 5c ff ff ff       	call   801d2b <alloc_sockfd>
  801dcf:	89 c1                	mov    %eax,%ecx
}
  801dd1:	89 c8                	mov    %ecx,%eax
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
  801dd8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	e8 16 ff ff ff       	call   801cf9 <fd2sockid>
  801de3:	89 c2                	mov    %eax,%edx
  801de5:	85 d2                	test   %edx,%edx
  801de7:	78 16                	js     801dff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801de9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dec:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df7:	89 14 24             	mov    %edx,(%esp)
  801dfa:	e8 60 01 00 00       	call   801f5f <nsipc_bind>
}
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <shutdown>:

int
shutdown(int s, int how)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e07:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0a:	e8 ea fe ff ff       	call   801cf9 <fd2sockid>
  801e0f:	89 c2                	mov    %eax,%edx
  801e11:	85 d2                	test   %edx,%edx
  801e13:	78 0f                	js     801e24 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1c:	89 14 24             	mov    %edx,(%esp)
  801e1f:	e8 7a 01 00 00       	call   801f9e <nsipc_shutdown>
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	e8 c5 fe ff ff       	call   801cf9 <fd2sockid>
  801e34:	89 c2                	mov    %eax,%edx
  801e36:	85 d2                	test   %edx,%edx
  801e38:	78 16                	js     801e50 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801e3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e48:	89 14 24             	mov    %edx,(%esp)
  801e4b:	e8 8a 01 00 00       	call   801fda <nsipc_connect>
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <listen>:

int
listen(int s, int backlog)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	e8 99 fe ff ff       	call   801cf9 <fd2sockid>
  801e60:	89 c2                	mov    %eax,%edx
  801e62:	85 d2                	test   %edx,%edx
  801e64:	78 0f                	js     801e75 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6d:	89 14 24             	mov    %edx,(%esp)
  801e70:	e8 a4 01 00 00       	call   802019 <nsipc_listen>
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e80:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	89 04 24             	mov    %eax,(%esp)
  801e91:	e8 98 02 00 00       	call   80212e <nsipc_socket>
  801e96:	89 c2                	mov    %eax,%edx
  801e98:	85 d2                	test   %edx,%edx
  801e9a:	78 05                	js     801ea1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801e9c:	e8 8a fe ff ff       	call   801d2b <alloc_sockfd>
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	53                   	push   %ebx
  801ea7:	83 ec 14             	sub    $0x14,%esp
  801eaa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801eac:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801eb3:	75 11                	jne    801ec6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801eb5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801ebc:	e8 e1 06 00 00       	call   8025a2 <ipc_find_env>
  801ec1:	a3 04 44 80 00       	mov    %eax,0x804404
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ec6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ecd:	00 
  801ece:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ed5:	00 
  801ed6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eda:	a1 04 44 80 00       	mov    0x804404,%eax
  801edf:	89 04 24             	mov    %eax,(%esp)
  801ee2:	e8 5d 06 00 00       	call   802544 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ee7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801eee:	00 
  801eef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ef6:	00 
  801ef7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801efe:	e8 d7 05 00 00       	call   8024da <ipc_recv>
}
  801f03:	83 c4 14             	add    $0x14,%esp
  801f06:	5b                   	pop    %ebx
  801f07:	5d                   	pop    %ebp
  801f08:	c3                   	ret    

00801f09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
  801f0c:	56                   	push   %esi
  801f0d:	53                   	push   %ebx
  801f0e:	83 ec 10             	sub    $0x10,%esp
  801f11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f1c:	8b 06                	mov    (%esi),%eax
  801f1e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f23:	b8 01 00 00 00       	mov    $0x1,%eax
  801f28:	e8 76 ff ff ff       	call   801ea3 <nsipc>
  801f2d:	89 c3                	mov    %eax,%ebx
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	78 23                	js     801f56 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f33:	a1 10 60 80 00       	mov    0x806010,%eax
  801f38:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f3c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f43:	00 
  801f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f47:	89 04 24             	mov    %eax,(%esp)
  801f4a:	e8 95 ed ff ff       	call   800ce4 <memmove>
		*addrlen = ret->ret_addrlen;
  801f4f:	a1 10 60 80 00       	mov    0x806010,%eax
  801f54:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801f56:	89 d8                	mov    %ebx,%eax
  801f58:	83 c4 10             	add    $0x10,%esp
  801f5b:	5b                   	pop    %ebx
  801f5c:	5e                   	pop    %esi
  801f5d:	5d                   	pop    %ebp
  801f5e:	c3                   	ret    

00801f5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	53                   	push   %ebx
  801f63:	83 ec 14             	sub    $0x14,%esp
  801f66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f69:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801f83:	e8 5c ed ff ff       	call   800ce4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f88:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801f8e:	b8 02 00 00 00       	mov    $0x2,%eax
  801f93:	e8 0b ff ff ff       	call   801ea3 <nsipc>
}
  801f98:	83 c4 14             	add    $0x14,%esp
  801f9b:	5b                   	pop    %ebx
  801f9c:	5d                   	pop    %ebp
  801f9d:	c3                   	ret    

00801f9e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801faf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801fb4:	b8 03 00 00 00       	mov    $0x3,%eax
  801fb9:	e8 e5 fe ff ff       	call   801ea3 <nsipc>
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <nsipc_close>:

int
nsipc_close(int s)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801fce:	b8 04 00 00 00       	mov    $0x4,%eax
  801fd3:	e8 cb fe ff ff       	call   801ea3 <nsipc>
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	53                   	push   %ebx
  801fde:	83 ec 14             	sub    $0x14,%esp
  801fe1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801ffe:	e8 e1 ec ff ff       	call   800ce4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802003:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802009:	b8 05 00 00 00       	mov    $0x5,%eax
  80200e:	e8 90 fe ff ff       	call   801ea3 <nsipc>
}
  802013:	83 c4 14             	add    $0x14,%esp
  802016:	5b                   	pop    %ebx
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80202f:	b8 06 00 00 00       	mov    $0x6,%eax
  802034:	e8 6a fe ff ff       	call   801ea3 <nsipc>
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	56                   	push   %esi
  80203f:	53                   	push   %ebx
  802040:	83 ec 10             	sub    $0x10,%esp
  802043:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80204e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802054:	8b 45 14             	mov    0x14(%ebp),%eax
  802057:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80205c:	b8 07 00 00 00       	mov    $0x7,%eax
  802061:	e8 3d fe ff ff       	call   801ea3 <nsipc>
  802066:	89 c3                	mov    %eax,%ebx
  802068:	85 c0                	test   %eax,%eax
  80206a:	78 46                	js     8020b2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80206c:	39 f0                	cmp    %esi,%eax
  80206e:	7f 07                	jg     802077 <nsipc_recv+0x3c>
  802070:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802075:	7e 24                	jle    80209b <nsipc_recv+0x60>
  802077:	c7 44 24 0c 6f 2d 80 	movl   $0x802d6f,0xc(%esp)
  80207e:	00 
  80207f:	c7 44 24 08 37 2d 80 	movl   $0x802d37,0x8(%esp)
  802086:	00 
  802087:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80208e:	00 
  80208f:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  802096:	e8 96 e2 ff ff       	call   800331 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80209b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80209f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8020a6:	00 
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	89 04 24             	mov    %eax,(%esp)
  8020ad:	e8 32 ec ff ff       	call   800ce4 <memmove>
	}

	return r;
}
  8020b2:	89 d8                	mov    %ebx,%eax
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5d                   	pop    %ebp
  8020ba:	c3                   	ret    

008020bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	53                   	push   %ebx
  8020bf:	83 ec 14             	sub    $0x14,%esp
  8020c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8020cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020d3:	7e 24                	jle    8020f9 <nsipc_send+0x3e>
  8020d5:	c7 44 24 0c 90 2d 80 	movl   $0x802d90,0xc(%esp)
  8020dc:	00 
  8020dd:	c7 44 24 08 37 2d 80 	movl   $0x802d37,0x8(%esp)
  8020e4:	00 
  8020e5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8020ec:	00 
  8020ed:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  8020f4:	e8 38 e2 ff ff       	call   800331 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802100:	89 44 24 04          	mov    %eax,0x4(%esp)
  802104:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80210b:	e8 d4 eb ff ff       	call   800ce4 <memmove>
	nsipcbuf.send.req_size = size;
  802110:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802116:	8b 45 14             	mov    0x14(%ebp),%eax
  802119:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80211e:	b8 08 00 00 00       	mov    $0x8,%eax
  802123:	e8 7b fd ff ff       	call   801ea3 <nsipc>
}
  802128:	83 c4 14             	add    $0x14,%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    

0080212e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80213c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802144:	8b 45 10             	mov    0x10(%ebp),%eax
  802147:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80214c:	b8 09 00 00 00       	mov    $0x9,%eax
  802151:	e8 4d fd ff ff       	call   801ea3 <nsipc>
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	56                   	push   %esi
  80215c:	53                   	push   %ebx
  80215d:	83 ec 10             	sub    $0x10,%esp
  802160:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	89 04 24             	mov    %eax,(%esp)
  802169:	e8 32 f1 ff ff       	call   8012a0 <fd2data>
  80216e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802170:	c7 44 24 04 9c 2d 80 	movl   $0x802d9c,0x4(%esp)
  802177:	00 
  802178:	89 1c 24             	mov    %ebx,(%esp)
  80217b:	e8 c7 e9 ff ff       	call   800b47 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802180:	8b 46 04             	mov    0x4(%esi),%eax
  802183:	2b 06                	sub    (%esi),%eax
  802185:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80218b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802192:	00 00 00 
	stat->st_dev = &devpipe;
  802195:	c7 83 88 00 00 00 58 	movl   $0x803058,0x88(%ebx)
  80219c:	30 80 00 
	return 0;
}
  80219f:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a4:	83 c4 10             	add    $0x10,%esp
  8021a7:	5b                   	pop    %ebx
  8021a8:	5e                   	pop    %esi
  8021a9:	5d                   	pop    %ebp
  8021aa:	c3                   	ret    

008021ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	53                   	push   %ebx
  8021af:	83 ec 14             	sub    $0x14,%esp
  8021b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021c0:	e8 45 ee ff ff       	call   80100a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021c5:	89 1c 24             	mov    %ebx,(%esp)
  8021c8:	e8 d3 f0 ff ff       	call   8012a0 <fd2data>
  8021cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d8:	e8 2d ee ff ff       	call   80100a <sys_page_unmap>
}
  8021dd:	83 c4 14             	add    $0x14,%esp
  8021e0:	5b                   	pop    %ebx
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    

008021e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	57                   	push   %edi
  8021e7:	56                   	push   %esi
  8021e8:	53                   	push   %ebx
  8021e9:	83 ec 2c             	sub    $0x2c,%esp
  8021ec:	89 c6                	mov    %eax,%esi
  8021ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8021f1:	a1 08 44 80 00       	mov    0x804408,%eax
  8021f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021f9:	89 34 24             	mov    %esi,(%esp)
  8021fc:	e8 d9 03 00 00       	call   8025da <pageref>
  802201:	89 c7                	mov    %eax,%edi
  802203:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802206:	89 04 24             	mov    %eax,(%esp)
  802209:	e8 cc 03 00 00       	call   8025da <pageref>
  80220e:	39 c7                	cmp    %eax,%edi
  802210:	0f 94 c2             	sete   %dl
  802213:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802216:	8b 0d 08 44 80 00    	mov    0x804408,%ecx
  80221c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80221f:	39 fb                	cmp    %edi,%ebx
  802221:	74 21                	je     802244 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802223:	84 d2                	test   %dl,%dl
  802225:	74 ca                	je     8021f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802227:	8b 51 58             	mov    0x58(%ecx),%edx
  80222a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80222e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802232:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802236:	c7 04 24 a3 2d 80 00 	movl   $0x802da3,(%esp)
  80223d:	e8 e8 e1 ff ff       	call   80042a <cprintf>
  802242:	eb ad                	jmp    8021f1 <_pipeisclosed+0xe>
	}
}
  802244:	83 c4 2c             	add    $0x2c,%esp
  802247:	5b                   	pop    %ebx
  802248:	5e                   	pop    %esi
  802249:	5f                   	pop    %edi
  80224a:	5d                   	pop    %ebp
  80224b:	c3                   	ret    

0080224c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	57                   	push   %edi
  802250:	56                   	push   %esi
  802251:	53                   	push   %ebx
  802252:	83 ec 1c             	sub    $0x1c,%esp
  802255:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802258:	89 34 24             	mov    %esi,(%esp)
  80225b:	e8 40 f0 ff ff       	call   8012a0 <fd2data>
  802260:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802262:	bf 00 00 00 00       	mov    $0x0,%edi
  802267:	eb 45                	jmp    8022ae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802269:	89 da                	mov    %ebx,%edx
  80226b:	89 f0                	mov    %esi,%eax
  80226d:	e8 71 ff ff ff       	call   8021e3 <_pipeisclosed>
  802272:	85 c0                	test   %eax,%eax
  802274:	75 41                	jne    8022b7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802276:	e8 c9 ec ff ff       	call   800f44 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80227b:	8b 43 04             	mov    0x4(%ebx),%eax
  80227e:	8b 0b                	mov    (%ebx),%ecx
  802280:	8d 51 20             	lea    0x20(%ecx),%edx
  802283:	39 d0                	cmp    %edx,%eax
  802285:	73 e2                	jae    802269 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802287:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80228a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80228e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802291:	99                   	cltd   
  802292:	c1 ea 1b             	shr    $0x1b,%edx
  802295:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802298:	83 e1 1f             	and    $0x1f,%ecx
  80229b:	29 d1                	sub    %edx,%ecx
  80229d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8022a1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8022a5:	83 c0 01             	add    $0x1,%eax
  8022a8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022ab:	83 c7 01             	add    $0x1,%edi
  8022ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022b1:	75 c8                	jne    80227b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8022b3:	89 f8                	mov    %edi,%eax
  8022b5:	eb 05                	jmp    8022bc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8022bc:	83 c4 1c             	add    $0x1c,%esp
  8022bf:	5b                   	pop    %ebx
  8022c0:	5e                   	pop    %esi
  8022c1:	5f                   	pop    %edi
  8022c2:	5d                   	pop    %ebp
  8022c3:	c3                   	ret    

008022c4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	57                   	push   %edi
  8022c8:	56                   	push   %esi
  8022c9:	53                   	push   %ebx
  8022ca:	83 ec 1c             	sub    $0x1c,%esp
  8022cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022d0:	89 3c 24             	mov    %edi,(%esp)
  8022d3:	e8 c8 ef ff ff       	call   8012a0 <fd2data>
  8022d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022da:	be 00 00 00 00       	mov    $0x0,%esi
  8022df:	eb 3d                	jmp    80231e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8022e1:	85 f6                	test   %esi,%esi
  8022e3:	74 04                	je     8022e9 <devpipe_read+0x25>
				return i;
  8022e5:	89 f0                	mov    %esi,%eax
  8022e7:	eb 43                	jmp    80232c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8022e9:	89 da                	mov    %ebx,%edx
  8022eb:	89 f8                	mov    %edi,%eax
  8022ed:	e8 f1 fe ff ff       	call   8021e3 <_pipeisclosed>
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	75 31                	jne    802327 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8022f6:	e8 49 ec ff ff       	call   800f44 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8022fb:	8b 03                	mov    (%ebx),%eax
  8022fd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802300:	74 df                	je     8022e1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802302:	99                   	cltd   
  802303:	c1 ea 1b             	shr    $0x1b,%edx
  802306:	01 d0                	add    %edx,%eax
  802308:	83 e0 1f             	and    $0x1f,%eax
  80230b:	29 d0                	sub    %edx,%eax
  80230d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802312:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802315:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802318:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80231b:	83 c6 01             	add    $0x1,%esi
  80231e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802321:	75 d8                	jne    8022fb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802323:	89 f0                	mov    %esi,%eax
  802325:	eb 05                	jmp    80232c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80232c:	83 c4 1c             	add    $0x1c,%esp
  80232f:	5b                   	pop    %ebx
  802330:	5e                   	pop    %esi
  802331:	5f                   	pop    %edi
  802332:	5d                   	pop    %ebp
  802333:	c3                   	ret    

00802334 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	56                   	push   %esi
  802338:	53                   	push   %ebx
  802339:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80233c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80233f:	89 04 24             	mov    %eax,(%esp)
  802342:	e8 70 ef ff ff       	call   8012b7 <fd_alloc>
  802347:	89 c2                	mov    %eax,%edx
  802349:	85 d2                	test   %edx,%edx
  80234b:	0f 88 4d 01 00 00    	js     80249e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802351:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802358:	00 
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802360:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802367:	e8 f7 eb ff ff       	call   800f63 <sys_page_alloc>
  80236c:	89 c2                	mov    %eax,%edx
  80236e:	85 d2                	test   %edx,%edx
  802370:	0f 88 28 01 00 00    	js     80249e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802376:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802379:	89 04 24             	mov    %eax,(%esp)
  80237c:	e8 36 ef ff ff       	call   8012b7 <fd_alloc>
  802381:	89 c3                	mov    %eax,%ebx
  802383:	85 c0                	test   %eax,%eax
  802385:	0f 88 fe 00 00 00    	js     802489 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80238b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802392:	00 
  802393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802396:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023a1:	e8 bd eb ff ff       	call   800f63 <sys_page_alloc>
  8023a6:	89 c3                	mov    %eax,%ebx
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	0f 88 d9 00 00 00    	js     802489 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	89 04 24             	mov    %eax,(%esp)
  8023b6:	e8 e5 ee ff ff       	call   8012a0 <fd2data>
  8023bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023c4:	00 
  8023c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d0:	e8 8e eb ff ff       	call   800f63 <sys_page_alloc>
  8023d5:	89 c3                	mov    %eax,%ebx
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	0f 88 97 00 00 00    	js     802476 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e2:	89 04 24             	mov    %eax,(%esp)
  8023e5:	e8 b6 ee ff ff       	call   8012a0 <fd2data>
  8023ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8023f1:	00 
  8023f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023fd:	00 
  8023fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802402:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802409:	e8 a9 eb ff ff       	call   800fb7 <sys_page_map>
  80240e:	89 c3                	mov    %eax,%ebx
  802410:	85 c0                	test   %eax,%eax
  802412:	78 52                	js     802466 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802414:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802429:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	89 04 24             	mov    %eax,(%esp)
  802444:	e8 47 ee ff ff       	call   801290 <fd2num>
  802449:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80244c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80244e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802451:	89 04 24             	mov    %eax,(%esp)
  802454:	e8 37 ee ff ff       	call   801290 <fd2num>
  802459:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80245c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
  802464:	eb 38                	jmp    80249e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802466:	89 74 24 04          	mov    %esi,0x4(%esp)
  80246a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802471:	e8 94 eb ff ff       	call   80100a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802484:	e8 81 eb ff ff       	call   80100a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802490:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802497:	e8 6e eb ff ff       	call   80100a <sys_page_unmap>
  80249c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80249e:	83 c4 30             	add    $0x30,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    

008024a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	89 04 24             	mov    %eax,(%esp)
  8024b8:	e8 49 ee ff ff       	call   801306 <fd_lookup>
  8024bd:	89 c2                	mov    %eax,%edx
  8024bf:	85 d2                	test   %edx,%edx
  8024c1:	78 15                	js     8024d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	89 04 24             	mov    %eax,(%esp)
  8024c9:	e8 d2 ed ff ff       	call   8012a0 <fd2data>
	return _pipeisclosed(fd, p);
  8024ce:	89 c2                	mov    %eax,%edx
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	e8 0b fd ff ff       	call   8021e3 <_pipeisclosed>
}
  8024d8:	c9                   	leave  
  8024d9:	c3                   	ret    

008024da <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024da:	55                   	push   %ebp
  8024db:	89 e5                	mov    %esp,%ebp
  8024dd:	56                   	push   %esi
  8024de:	53                   	push   %ebx
  8024df:	83 ec 10             	sub    $0x10,%esp
  8024e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e8:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8024eb:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8024ed:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8024f2:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8024f5:	89 04 24             	mov    %eax,(%esp)
  8024f8:	e8 7c ec ff ff       	call   801179 <sys_ipc_recv>
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	75 1e                	jne    80251f <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802501:	85 db                	test   %ebx,%ebx
  802503:	74 0a                	je     80250f <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802505:	a1 08 44 80 00       	mov    0x804408,%eax
  80250a:	8b 40 74             	mov    0x74(%eax),%eax
  80250d:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80250f:	85 f6                	test   %esi,%esi
  802511:	74 22                	je     802535 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802513:	a1 08 44 80 00       	mov    0x804408,%eax
  802518:	8b 40 78             	mov    0x78(%eax),%eax
  80251b:	89 06                	mov    %eax,(%esi)
  80251d:	eb 16                	jmp    802535 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80251f:	85 f6                	test   %esi,%esi
  802521:	74 06                	je     802529 <ipc_recv+0x4f>
				*perm_store = 0;
  802523:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802529:	85 db                	test   %ebx,%ebx
  80252b:	74 10                	je     80253d <ipc_recv+0x63>
				*from_env_store=0;
  80252d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802533:	eb 08                	jmp    80253d <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802535:	a1 08 44 80 00       	mov    0x804408,%eax
  80253a:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  80253d:	83 c4 10             	add    $0x10,%esp
  802540:	5b                   	pop    %ebx
  802541:	5e                   	pop    %esi
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    

00802544 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	57                   	push   %edi
  802548:	56                   	push   %esi
  802549:	53                   	push   %ebx
  80254a:	83 ec 1c             	sub    $0x1c,%esp
  80254d:	8b 75 0c             	mov    0xc(%ebp),%esi
  802550:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802553:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802556:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802558:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  80255d:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802560:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802564:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802568:	89 74 24 04          	mov    %esi,0x4(%esp)
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	89 04 24             	mov    %eax,(%esp)
  802572:	e8 df eb ff ff       	call   801156 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802577:	eb 1c                	jmp    802595 <ipc_send+0x51>
	{
		sys_yield();
  802579:	e8 c6 e9 ff ff       	call   800f44 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80257e:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802582:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802586:	89 74 24 04          	mov    %esi,0x4(%esp)
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	89 04 24             	mov    %eax,(%esp)
  802590:	e8 c1 eb ff ff       	call   801156 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802595:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802598:	74 df                	je     802579 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  80259a:	83 c4 1c             	add    $0x1c,%esp
  80259d:	5b                   	pop    %ebx
  80259e:	5e                   	pop    %esi
  80259f:	5f                   	pop    %edi
  8025a0:	5d                   	pop    %ebp
  8025a1:	c3                   	ret    

008025a2 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
  8025a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025ad:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8025b0:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025b6:	8b 52 50             	mov    0x50(%edx),%edx
  8025b9:	39 ca                	cmp    %ecx,%edx
  8025bb:	75 0d                	jne    8025ca <ipc_find_env+0x28>
			return envs[i].env_id;
  8025bd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8025c0:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8025c5:	8b 40 40             	mov    0x40(%eax),%eax
  8025c8:	eb 0e                	jmp    8025d8 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8025ca:	83 c0 01             	add    $0x1,%eax
  8025cd:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025d2:	75 d9                	jne    8025ad <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8025d4:	66 b8 00 00          	mov    $0x0,%ax
}
  8025d8:	5d                   	pop    %ebp
  8025d9:	c3                   	ret    

008025da <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025da:	55                   	push   %ebp
  8025db:	89 e5                	mov    %esp,%ebp
  8025dd:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025e0:	89 d0                	mov    %edx,%eax
  8025e2:	c1 e8 16             	shr    $0x16,%eax
  8025e5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025ec:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025f1:	f6 c1 01             	test   $0x1,%cl
  8025f4:	74 1d                	je     802613 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8025f6:	c1 ea 0c             	shr    $0xc,%edx
  8025f9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802600:	f6 c2 01             	test   $0x1,%dl
  802603:	74 0e                	je     802613 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802605:	c1 ea 0c             	shr    $0xc,%edx
  802608:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80260f:	ef 
  802610:	0f b7 c0             	movzwl %ax,%eax
}
  802613:	5d                   	pop    %ebp
  802614:	c3                   	ret    
  802615:	66 90                	xchg   %ax,%ax
  802617:	66 90                	xchg   %ax,%ax
  802619:	66 90                	xchg   %ax,%ax
  80261b:	66 90                	xchg   %ax,%ax
  80261d:	66 90                	xchg   %ax,%ax
  80261f:	90                   	nop

00802620 <__udivdi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	83 ec 0c             	sub    $0xc,%esp
  802626:	8b 44 24 28          	mov    0x28(%esp),%eax
  80262a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80262e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802632:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802636:	85 c0                	test   %eax,%eax
  802638:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80263c:	89 ea                	mov    %ebp,%edx
  80263e:	89 0c 24             	mov    %ecx,(%esp)
  802641:	75 2d                	jne    802670 <__udivdi3+0x50>
  802643:	39 e9                	cmp    %ebp,%ecx
  802645:	77 61                	ja     8026a8 <__udivdi3+0x88>
  802647:	85 c9                	test   %ecx,%ecx
  802649:	89 ce                	mov    %ecx,%esi
  80264b:	75 0b                	jne    802658 <__udivdi3+0x38>
  80264d:	b8 01 00 00 00       	mov    $0x1,%eax
  802652:	31 d2                	xor    %edx,%edx
  802654:	f7 f1                	div    %ecx
  802656:	89 c6                	mov    %eax,%esi
  802658:	31 d2                	xor    %edx,%edx
  80265a:	89 e8                	mov    %ebp,%eax
  80265c:	f7 f6                	div    %esi
  80265e:	89 c5                	mov    %eax,%ebp
  802660:	89 f8                	mov    %edi,%eax
  802662:	f7 f6                	div    %esi
  802664:	89 ea                	mov    %ebp,%edx
  802666:	83 c4 0c             	add    $0xc,%esp
  802669:	5e                   	pop    %esi
  80266a:	5f                   	pop    %edi
  80266b:	5d                   	pop    %ebp
  80266c:	c3                   	ret    
  80266d:	8d 76 00             	lea    0x0(%esi),%esi
  802670:	39 e8                	cmp    %ebp,%eax
  802672:	77 24                	ja     802698 <__udivdi3+0x78>
  802674:	0f bd e8             	bsr    %eax,%ebp
  802677:	83 f5 1f             	xor    $0x1f,%ebp
  80267a:	75 3c                	jne    8026b8 <__udivdi3+0x98>
  80267c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802680:	39 34 24             	cmp    %esi,(%esp)
  802683:	0f 86 9f 00 00 00    	jbe    802728 <__udivdi3+0x108>
  802689:	39 d0                	cmp    %edx,%eax
  80268b:	0f 82 97 00 00 00    	jb     802728 <__udivdi3+0x108>
  802691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802698:	31 d2                	xor    %edx,%edx
  80269a:	31 c0                	xor    %eax,%eax
  80269c:	83 c4 0c             	add    $0xc,%esp
  80269f:	5e                   	pop    %esi
  8026a0:	5f                   	pop    %edi
  8026a1:	5d                   	pop    %ebp
  8026a2:	c3                   	ret    
  8026a3:	90                   	nop
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	89 f8                	mov    %edi,%eax
  8026aa:	f7 f1                	div    %ecx
  8026ac:	31 d2                	xor    %edx,%edx
  8026ae:	83 c4 0c             	add    $0xc,%esp
  8026b1:	5e                   	pop    %esi
  8026b2:	5f                   	pop    %edi
  8026b3:	5d                   	pop    %ebp
  8026b4:	c3                   	ret    
  8026b5:	8d 76 00             	lea    0x0(%esi),%esi
  8026b8:	89 e9                	mov    %ebp,%ecx
  8026ba:	8b 3c 24             	mov    (%esp),%edi
  8026bd:	d3 e0                	shl    %cl,%eax
  8026bf:	89 c6                	mov    %eax,%esi
  8026c1:	b8 20 00 00 00       	mov    $0x20,%eax
  8026c6:	29 e8                	sub    %ebp,%eax
  8026c8:	89 c1                	mov    %eax,%ecx
  8026ca:	d3 ef                	shr    %cl,%edi
  8026cc:	89 e9                	mov    %ebp,%ecx
  8026ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026d2:	8b 3c 24             	mov    (%esp),%edi
  8026d5:	09 74 24 08          	or     %esi,0x8(%esp)
  8026d9:	89 d6                	mov    %edx,%esi
  8026db:	d3 e7                	shl    %cl,%edi
  8026dd:	89 c1                	mov    %eax,%ecx
  8026df:	89 3c 24             	mov    %edi,(%esp)
  8026e2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026e6:	d3 ee                	shr    %cl,%esi
  8026e8:	89 e9                	mov    %ebp,%ecx
  8026ea:	d3 e2                	shl    %cl,%edx
  8026ec:	89 c1                	mov    %eax,%ecx
  8026ee:	d3 ef                	shr    %cl,%edi
  8026f0:	09 d7                	or     %edx,%edi
  8026f2:	89 f2                	mov    %esi,%edx
  8026f4:	89 f8                	mov    %edi,%eax
  8026f6:	f7 74 24 08          	divl   0x8(%esp)
  8026fa:	89 d6                	mov    %edx,%esi
  8026fc:	89 c7                	mov    %eax,%edi
  8026fe:	f7 24 24             	mull   (%esp)
  802701:	39 d6                	cmp    %edx,%esi
  802703:	89 14 24             	mov    %edx,(%esp)
  802706:	72 30                	jb     802738 <__udivdi3+0x118>
  802708:	8b 54 24 04          	mov    0x4(%esp),%edx
  80270c:	89 e9                	mov    %ebp,%ecx
  80270e:	d3 e2                	shl    %cl,%edx
  802710:	39 c2                	cmp    %eax,%edx
  802712:	73 05                	jae    802719 <__udivdi3+0xf9>
  802714:	3b 34 24             	cmp    (%esp),%esi
  802717:	74 1f                	je     802738 <__udivdi3+0x118>
  802719:	89 f8                	mov    %edi,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	e9 7a ff ff ff       	jmp    80269c <__udivdi3+0x7c>
  802722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802728:	31 d2                	xor    %edx,%edx
  80272a:	b8 01 00 00 00       	mov    $0x1,%eax
  80272f:	e9 68 ff ff ff       	jmp    80269c <__udivdi3+0x7c>
  802734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802738:	8d 47 ff             	lea    -0x1(%edi),%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	83 c4 0c             	add    $0xc,%esp
  802740:	5e                   	pop    %esi
  802741:	5f                   	pop    %edi
  802742:	5d                   	pop    %ebp
  802743:	c3                   	ret    
  802744:	66 90                	xchg   %ax,%ax
  802746:	66 90                	xchg   %ax,%ax
  802748:	66 90                	xchg   %ax,%ax
  80274a:	66 90                	xchg   %ax,%ax
  80274c:	66 90                	xchg   %ax,%ax
  80274e:	66 90                	xchg   %ax,%ax

00802750 <__umoddi3>:
  802750:	55                   	push   %ebp
  802751:	57                   	push   %edi
  802752:	56                   	push   %esi
  802753:	83 ec 14             	sub    $0x14,%esp
  802756:	8b 44 24 28          	mov    0x28(%esp),%eax
  80275a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80275e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802762:	89 c7                	mov    %eax,%edi
  802764:	89 44 24 04          	mov    %eax,0x4(%esp)
  802768:	8b 44 24 30          	mov    0x30(%esp),%eax
  80276c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802770:	89 34 24             	mov    %esi,(%esp)
  802773:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802777:	85 c0                	test   %eax,%eax
  802779:	89 c2                	mov    %eax,%edx
  80277b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80277f:	75 17                	jne    802798 <__umoddi3+0x48>
  802781:	39 fe                	cmp    %edi,%esi
  802783:	76 4b                	jbe    8027d0 <__umoddi3+0x80>
  802785:	89 c8                	mov    %ecx,%eax
  802787:	89 fa                	mov    %edi,%edx
  802789:	f7 f6                	div    %esi
  80278b:	89 d0                	mov    %edx,%eax
  80278d:	31 d2                	xor    %edx,%edx
  80278f:	83 c4 14             	add    $0x14,%esp
  802792:	5e                   	pop    %esi
  802793:	5f                   	pop    %edi
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    
  802796:	66 90                	xchg   %ax,%ax
  802798:	39 f8                	cmp    %edi,%eax
  80279a:	77 54                	ja     8027f0 <__umoddi3+0xa0>
  80279c:	0f bd e8             	bsr    %eax,%ebp
  80279f:	83 f5 1f             	xor    $0x1f,%ebp
  8027a2:	75 5c                	jne    802800 <__umoddi3+0xb0>
  8027a4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8027a8:	39 3c 24             	cmp    %edi,(%esp)
  8027ab:	0f 87 e7 00 00 00    	ja     802898 <__umoddi3+0x148>
  8027b1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8027b5:	29 f1                	sub    %esi,%ecx
  8027b7:	19 c7                	sbb    %eax,%edi
  8027b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027c1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027c5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8027c9:	83 c4 14             	add    $0x14,%esp
  8027cc:	5e                   	pop    %esi
  8027cd:	5f                   	pop    %edi
  8027ce:	5d                   	pop    %ebp
  8027cf:	c3                   	ret    
  8027d0:	85 f6                	test   %esi,%esi
  8027d2:	89 f5                	mov    %esi,%ebp
  8027d4:	75 0b                	jne    8027e1 <__umoddi3+0x91>
  8027d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027db:	31 d2                	xor    %edx,%edx
  8027dd:	f7 f6                	div    %esi
  8027df:	89 c5                	mov    %eax,%ebp
  8027e1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027e5:	31 d2                	xor    %edx,%edx
  8027e7:	f7 f5                	div    %ebp
  8027e9:	89 c8                	mov    %ecx,%eax
  8027eb:	f7 f5                	div    %ebp
  8027ed:	eb 9c                	jmp    80278b <__umoddi3+0x3b>
  8027ef:	90                   	nop
  8027f0:	89 c8                	mov    %ecx,%eax
  8027f2:	89 fa                	mov    %edi,%edx
  8027f4:	83 c4 14             	add    $0x14,%esp
  8027f7:	5e                   	pop    %esi
  8027f8:	5f                   	pop    %edi
  8027f9:	5d                   	pop    %ebp
  8027fa:	c3                   	ret    
  8027fb:	90                   	nop
  8027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802800:	8b 04 24             	mov    (%esp),%eax
  802803:	be 20 00 00 00       	mov    $0x20,%esi
  802808:	89 e9                	mov    %ebp,%ecx
  80280a:	29 ee                	sub    %ebp,%esi
  80280c:	d3 e2                	shl    %cl,%edx
  80280e:	89 f1                	mov    %esi,%ecx
  802810:	d3 e8                	shr    %cl,%eax
  802812:	89 e9                	mov    %ebp,%ecx
  802814:	89 44 24 04          	mov    %eax,0x4(%esp)
  802818:	8b 04 24             	mov    (%esp),%eax
  80281b:	09 54 24 04          	or     %edx,0x4(%esp)
  80281f:	89 fa                	mov    %edi,%edx
  802821:	d3 e0                	shl    %cl,%eax
  802823:	89 f1                	mov    %esi,%ecx
  802825:	89 44 24 08          	mov    %eax,0x8(%esp)
  802829:	8b 44 24 10          	mov    0x10(%esp),%eax
  80282d:	d3 ea                	shr    %cl,%edx
  80282f:	89 e9                	mov    %ebp,%ecx
  802831:	d3 e7                	shl    %cl,%edi
  802833:	89 f1                	mov    %esi,%ecx
  802835:	d3 e8                	shr    %cl,%eax
  802837:	89 e9                	mov    %ebp,%ecx
  802839:	09 f8                	or     %edi,%eax
  80283b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80283f:	f7 74 24 04          	divl   0x4(%esp)
  802843:	d3 e7                	shl    %cl,%edi
  802845:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802849:	89 d7                	mov    %edx,%edi
  80284b:	f7 64 24 08          	mull   0x8(%esp)
  80284f:	39 d7                	cmp    %edx,%edi
  802851:	89 c1                	mov    %eax,%ecx
  802853:	89 14 24             	mov    %edx,(%esp)
  802856:	72 2c                	jb     802884 <__umoddi3+0x134>
  802858:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80285c:	72 22                	jb     802880 <__umoddi3+0x130>
  80285e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802862:	29 c8                	sub    %ecx,%eax
  802864:	19 d7                	sbb    %edx,%edi
  802866:	89 e9                	mov    %ebp,%ecx
  802868:	89 fa                	mov    %edi,%edx
  80286a:	d3 e8                	shr    %cl,%eax
  80286c:	89 f1                	mov    %esi,%ecx
  80286e:	d3 e2                	shl    %cl,%edx
  802870:	89 e9                	mov    %ebp,%ecx
  802872:	d3 ef                	shr    %cl,%edi
  802874:	09 d0                	or     %edx,%eax
  802876:	89 fa                	mov    %edi,%edx
  802878:	83 c4 14             	add    $0x14,%esp
  80287b:	5e                   	pop    %esi
  80287c:	5f                   	pop    %edi
  80287d:	5d                   	pop    %ebp
  80287e:	c3                   	ret    
  80287f:	90                   	nop
  802880:	39 d7                	cmp    %edx,%edi
  802882:	75 da                	jne    80285e <__umoddi3+0x10e>
  802884:	8b 14 24             	mov    (%esp),%edx
  802887:	89 c1                	mov    %eax,%ecx
  802889:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80288d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802891:	eb cb                	jmp    80285e <__umoddi3+0x10e>
  802893:	90                   	nop
  802894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802898:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80289c:	0f 82 0f ff ff ff    	jb     8027b1 <__umoddi3+0x61>
  8028a2:	e9 1a ff ff ff       	jmp    8027c1 <__umoddi3+0x71>
